class /ITETR/EDF_CLS_JSON_SER definition
  public
  final
  create public .

public section.

  class-methods CLASS_CONSTRUCTOR .
  methods CONSTRUCTOR .
  methods SERIALIZE .
  methods GET_DATA
    returning
      value(RVAL) type /ITETR/EDF_JSON .
  methods SET_DATA
    importing
      !I_DATA type ANY .
protected section.
private section.

  data FRAGMENTS type /ITETR/EDF_TT_STRING .
  data DATA_REF type ref to DATA .
  class-data C_COLON type /ITETR/EDF_STRING .
  class-data C_COMMA type /ITETR/EDF_STRING .

  methods RECURSE
    importing
      !DATA type ANY
      !NAME type CHAR30 optional .
ENDCLASS.



CLASS /ITETR/EDF_CLS_JSON_SER IMPLEMENTATION.


  METHOD class_constructor.
    cl_abap_string_utilities=>c2str_preserving_blanks(
    EXPORTING source = ': '
    IMPORTING dest   = c_colon ) .

    cl_abap_string_utilities=>c2str_preserving_blanks(
        EXPORTING source = ', '
        IMPORTING dest   = c_comma ) .
  ENDMETHOD.


  method CONSTRUCTOR.
  endmethod.


  METHOD get_data.
    CONCATENATE LINES OF me->fragments INTO rval .
  ENDMETHOD.


  METHOD recurse.
    TYPE-POOLS:abap.

    DATA:
      l_type   TYPE c,
      l_comps  TYPE i,
      l_lines  TYPE i,
      l_index  TYPE i,
      l_value  TYPE string,
      l_valuec TYPE c LENGTH 10000,
      lv_p     TYPE menge_d,
      lv_n     TYPE n LENGTH 13.

    FIELD-SYMBOLS:
      <itab> TYPE ANY TABLE,
      <comp> TYPE any.

    DESCRIBE FIELD data TYPE l_type COMPONENTS l_comps .

    IF l_type = cl_abap_typedescr=>typekind_table .
      APPEND '[' TO me->fragments .
      ASSIGN data TO <itab> .
      l_lines = lines( <itab> ) .
      LOOP AT <itab> ASSIGNING <comp> .
        ADD 1 TO l_index .
        recurse( <comp> ) .
        IF l_index < l_lines .
          APPEND c_comma TO me->fragments .
        ENDIF .
      ENDLOOP .
      APPEND ']' TO fragments .
    ELSE .
      IF l_comps IS INITIAL .
        l_value = data.
        CONDENSE l_value.

*      REPLACE ALL OCCURRENCES OF '\'                                    IN l_value WITH '\\' .
*      REPLACE ALL OCCURRENCES OF ''''                                   IN l_value WITH '\''' .
        REPLACE ALL OCCURRENCES OF '"'                                    IN l_value WITH '\"' .
        REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf          IN l_value WITH '\r\n' .
        REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>newline        IN l_value WITH '\n' .
        REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>horizontal_tab IN l_value WITH '\t' .
        REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>backspace      IN l_value WITH '\b' .
        REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>form_feed      IN l_value WITH '\f' .

        "Numerik olan alanlar başında sıfır olmadan yazılsın
        IF l_type EQ 'N' OR l_type EQ 'P'.
          WRITE data TO l_valuec NO-ZERO.CONDENSE l_valuec.
          l_value = l_valuec.

          lv_p = l_value.
          IF lv_p EQ 0.
            l_value = space.
          ENDIF.
        ENDIF.

        IF l_value IS INITIAL.
          l_value = 'null'.
        ELSE.
          IF l_type NE 'N' AND l_type NE 'P'.
            CONCATENATE '"' l_value '"' INTO l_value.
          ENDIF.
        ENDIF.

        APPEND l_value TO me->fragments .
      ELSE .
        DATA l_typedescr TYPE REF TO cl_abap_structdescr .
        FIELD-SYMBOLS <abapcomp> TYPE abap_compdescr .

        APPEND '{' TO me->fragments .
        l_typedescr ?= cl_abap_typedescr=>describe_by_data( data ) .
        LOOP AT l_typedescr->components ASSIGNING <abapcomp> .
          l_index = sy-tabix .

          "Kolon ismi sığmayan alanlar
          IF <abapcomp>-name EQ 'ACCOUNTANTENGAGEMENTTYPEDESCRI'.
            CONCATENATE '"accountantEngagementTypeDescription"' c_colon INTO l_value .
          ELSEIF <abapcomp>-name EQ 'ACCOUNTANTCONTACTPHONENUMBERDE'.
            CONCATENATE '"accountantContactPhoneNumberDescription"' c_colon INTO l_value .
          ELSEIF <abapcomp>-name EQ 'ORGANIZATIONADDRESSZIPORPOSTAL'.
            CONCATENATE '"organizationAddressZipOrPostalCode"' c_colon INTO l_value .
          ELSE.
            CONCATENATE '"' <abapcomp>-name '"' c_colon INTO l_value .
          ENDIF.

          TRANSLATE l_value TO LOWER CASE .
          APPEND l_value TO me->fragments .
          ASSIGN COMPONENT <abapcomp>-name OF STRUCTURE data TO <comp> .
          recurse( data = <comp> name = <abapcomp>-name ) .
          IF l_index < l_comps .
            APPEND c_comma TO me->fragments .
          ENDIF .
        ENDLOOP .
        APPEND '}' TO me->fragments .
      ENDIF .
    ENDIF .
  ENDMETHOD.


  METHOD serialize.
    FIELD-SYMBOLS <data> TYPE data .

    REFRESH me->fragments.

    ASSIGN me->data_ref->* TO <data> .

    recurse( <data> ) .
  ENDMETHOD.


  METHOD set_data.
    GET REFERENCE OF i_data INTO me->data_ref .
  ENDMETHOD.
ENDCLASS.