class /ITETR/EDF_CLS_JSON_DES definition
  public
  final
  create public .

public section.

  methods DESERIALIZE
    importing
      !JSON type STRING
    exporting
      !ABAP type ANY .
  methods DESERIALIZE_REF
    importing
      !JSON type STRING
      !REF type ref to OBJECT .
protected section.
private section.

  methods DESERIALIZE_NODE
    importing
      !JSON type STRING
    changing
      !OFFSET type I default 0
      !NODE type ANY .
  methods DESERIALIZE_OBJECT
    importing
      !JSON type STRING
    changing
      !OFFSET type I default 0
      !NODE type ANY .
  methods DESERIALIZE_ARRAY
    importing
      !JSON type STRING
    changing
      !OFFSET type I default 0
      !NODE type ANY .
ENDCLASS.



CLASS /ITETR/EDF_CLS_JSON_DES IMPLEMENTATION.


  METHOD deserialize.
    deserialize_node(
  EXPORTING
    json = json
  CHANGING
    node = abap ) .
  ENDMETHOD.


  METHOD deserialize_array.
    TYPE-POOLS:abap.

    DATA:
      l_done TYPE c LENGTH 1,
      l_rec  TYPE REF TO data.

    FIELD-SYMBOLS:
      <itab> TYPE ANY TABLE,
      <rec>  TYPE data.

    ADD 1 TO offset . "skip [

    ASSIGN node TO <itab> .

* create record
    CREATE DATA l_rec LIKE LINE OF <itab> .
    ASSIGN l_rec->* TO <rec> .

    WHILE l_done = abap_false .
      CLEAR <rec> .

      IF json+offset(1) = ']' .
        l_done = abap_true .
        ADD 1 TO offset.
        EXIT.
      ENDIF .

      deserialize_node(
        EXPORTING
          json = json
        CHANGING
          offset = offset
          node = <rec> ) .

      INSERT <rec> INTO TABLE <itab> .

      FIND REGEX ',|\]' IN SECTION OFFSET offset OF json MATCH OFFSET offset .
      IF sy-subrc <> 0 .
        RAISE EXCEPTION TYPE cx_trex_serialization .
      ENDIF .
      IF json+offset(1) = ']' .
        l_done = abap_true .
      ENDIF .

      ADD 1 TO offset .
    ENDWHILE .
  ENDMETHOD.


  METHOD deserialize_node.
    DATA:
      l_len    TYPE i,
      l_string TYPE string,
      l_number TYPE string.

    FIND REGEX '\{|\[|"([^"]*)"|(\d+)' IN SECTION OFFSET offset OF json
      MATCH OFFSET offset MATCH LENGTH l_len
      SUBMATCHES l_string l_number .

    IF sy-subrc <> 0 .
      RAISE EXCEPTION TYPE cx_trex_serialization .
    ENDIF .

    CASE json+offset(1) .
      WHEN '{' .
        deserialize_object(
          EXPORTING
            json = json
          CHANGING
            offset = offset
            node = node ) .

      WHEN '[' .
        deserialize_array(
          EXPORTING
            json = json
          CHANGING
            offset = offset
            node = node ) .

      WHEN '"' .
        node = l_string .
        ADD l_len TO offset .
      WHEN OTHERS . "0-9
        node = l_number .
        ADD l_len TO offset .
    ENDCASE .
  ENDMETHOD.


  METHOD deserialize_object.
    DATA:
      l_node_type TYPE REF TO cl_abap_typedescr,
      l_ref       TYPE REF TO object.

    ADD 1 TO offset . "skip {

    l_node_type = cl_abap_typedescr=>describe_by_data( node ) .

* prepare for dynamic access
    CASE l_node_type->kind .
      WHEN cl_abap_typedescr=>kind_ref .
        l_ref = node .
      WHEN cl_abap_typedescr=>kind_struct .

      WHEN OTHERS .
        EXIT.
        RAISE EXCEPTION TYPE cx_trex_serialization .
    ENDCASE .

    DATA:
      l_done TYPE c LENGTH 1,
      l_len  TYPE i,
      l_name TYPE string.

* handle each component
    WHILE l_done = abap_false .
      "find next key
      FIND REGEX '"(\w+)\s*":' IN SECTION OFFSET offset OF json
        MATCH OFFSET offset MATCH LENGTH l_len
        SUBMATCHES l_name .
      IF sy-subrc <> 0 .
        l_done = abap_true .
        CONTINUE.
*      RAISE EXCEPTION TYPE cx_trex_serialization .
      ENDIF .
      ADD l_len TO offset .

      FIELD-SYMBOLS <comp> TYPE any .

*   dynamic binding to component
      TRANSLATE l_name TO UPPER CASE .
      CASE l_node_type->kind .
        WHEN cl_abap_typedescr=>kind_ref .
          ASSIGN l_ref->(l_name) TO <comp> .
        WHEN cl_abap_typedescr=>kind_struct .
          ASSIGN COMPONENT l_name OF STRUCTURE node TO <comp> .
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.
        WHEN OTHERS .
          RAISE EXCEPTION TYPE cx_trex_serialization .
      ENDCASE .

      DATA:
        l_comp_type TYPE REF TO cl_abap_typedescr,
        l_ref_type  TYPE REF TO cl_abap_refdescr.

*   check component type
      l_comp_type = cl_abap_typedescr=>describe_by_data( <comp> ) .
      CASE l_comp_type->kind .
*     create instance if it's an oref
        WHEN cl_abap_typedescr=>kind_ref .
          l_ref_type ?= l_comp_type .
          l_comp_type = l_ref_type->get_referenced_type( ) .
          CREATE OBJECT <comp> TYPE (l_comp_type->absolute_name) .
      ENDCASE .

*   deserialize current component
      deserialize_node(
        EXPORTING
          json = json
        CHANGING
          offset = offset
          node = <comp> ) .

      FIND REGEX ',|\}' IN SECTION OFFSET offset OF json MATCH OFFSET offset .
      IF sy-subrc <> 0 .
        RAISE EXCEPTION TYPE cx_trex_serialization .
      ENDIF .

      IF json+offset(1) = '}' .
        l_done = abap_true .
      ENDIF .
      ADD 1 TO offset .
    ENDWHILE .

  ENDMETHOD.


  METHOD deserialize_ref.
    DATA l_ref TYPE REF TO object .
    l_ref = ref .
    deserialize_node(
      EXPORTING
        json = json
      CHANGING
        node = l_ref ) .
  ENDMETHOD.
ENDCLASS.