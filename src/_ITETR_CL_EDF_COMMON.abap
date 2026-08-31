class /ITETR/CL_EDF_COMMON definition
  public
  final
  create public .

public section.

  class-methods NUMBER_GET_NEXT
    importing
      !IV_NUMRN type NRNR
      !IV_NROBJ type NROBJ
      !IV_YEAR type NRYEAR default '0000'
      !IV_QUAN type NRQUAN default 1
    exporting
      !EV_NUMBER type ANY .
  class-methods GENERATE_UNIQUEID
    importing
      !IV_BUKRS type BUKRS
      !IV_XMLTY type /ITETR/EDF_E_XML_TYPES
      !IV_YEAR type GJAHR
    returning
      value(RV_UNQID) type /ITETR/EDF_E_UNQID .
  class-methods GENERATE_GUID
    returning
      value(RV_GUID) type CHAR36 .
  class-methods POPUP_TO_CONFIRM_SIMPLE
    importing
      !IV_QUESTION type CLIKE
      !IV_DEFAULT type CHAR1 default '2'
    returning
      value(RV_ANSWER) type CHAR1 .
  class-methods CONVERT_XSTRING_TO_STRING
    importing
      !IV_INPUT type XSTRING
    returning
      value(RV_OUTPUT) type STRING .
  class-methods CONVERT_STRING_TO_XSTRING
    importing
      !IV_INPUT type STRING
    returning
      value(RV_OUTPUT) type XSTRING .
protected section.
private section.
ENDCLASS.



CLASS /ITETR/CL_EDF_COMMON IMPLEMENTATION.


  METHOD convert_string_to_xstring.
    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = iv_input
      IMPORTING
        buffer = rv_output
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc <> 0.
      CLEAR rv_output.
    ENDIF.
  ENDMETHOD.


  METHOD convert_xstring_to_string.
    DATA: lt_binary TYPE solix_tab,
          lv_length TYPE i.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = iv_input
      IMPORTING
        output_length = lv_length
      TABLES
        binary_tab    = lt_binary.
    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
      EXPORTING
        input_length = lv_length
      IMPORTING
        text_buffer  = rv_output
      TABLES
        binary_tab   = lt_binary
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      CLEAR rv_output.
    ENDIF.

  ENDMETHOD.


  METHOD generate_guid.

    DATA lv_guid TYPE guid_32.

    WAIT UP TO '0.5' SECONDS.

    CALL FUNCTION 'GUID_CREATE'
      IMPORTING
        ev_guid_32 = lv_guid.

    CONCATENATE lv_guid+0(8)
                '-'
                lv_guid+8(4)
                '-'
                lv_guid+12(4)
                '-'
                lv_guid+16(4)
                '-'
                lv_guid+20(*)
                INTO rv_guid.


  ENDMETHOD.


  METHOD generate_uniqueid.

    DATA ls_srnr TYPE /itetr/etr_srnmr.
    DATA lv_num(8) TYPE c.

    SELECT SINGLE *
        INTO ls_srnr
        FROM /itetr/etr_srnmr
        WHERE bukrs EQ iv_bukrs
          AND xmlty EQ iv_xmlty.

    CHECK sy-subrc IS INITIAL.

    CALL METHOD /itetr/cl_edf_common=>number_get_next
      EXPORTING
        iv_numrn  = ls_srnr-numrn
        iv_nrobj  = ls_srnr-nrobj
        iv_year   = iv_year
        iv_quan   = 1
      IMPORTING
        ev_number = lv_num.

    CONCATENATE ls_srnr-serpr
                iv_year
                lv_num
                INTO rv_unqid.

  ENDMETHOD.


  METHOD number_get_next.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = iv_numrn
        object                  = iv_nrobj
        quantity                = iv_quan
        toyear                  = iv_year
      IMPORTING
        number                  = ev_number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.



  ENDMETHOD.


  METHOD popup_to_confirm_simple.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        text_question  = iv_question
        default_button = iv_default
      IMPORTING
        answer         = rv_answer
      EXCEPTIONS
        text_not_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
      CLEAR rv_answer.
    ENDIF.
  ENDMETHOD.
ENDCLASS.