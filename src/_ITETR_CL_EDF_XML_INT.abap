class /ITETR/CL_EDF_XML_INT definition
  public
  abstract
  create public .

public section.

  class-methods FACTORY
    importing
      !IV_BUKRS type BUKRS
      !IS_HEADER type /ITETR/EDF_S_XML_HEADER
      !IV_PURPOSE type CHAR1 default 'C'
      !IV_PARTN type /ITETR/EDF_PART_NO optional
    returning
      value(RO_OBJECT) type ref to /ITETR/CL_EDF_XML_INT .
  class-methods GET_INTID
    importing
      !IV_BUKRS type BUKRS
    returning
      value(RV_INTID) type /ITETR/EDF_E_INTID .
  methods CONSTRUCTOR
    importing
      !IS_HEADER type /ITETR/EDF_S_XML_HEADER
      !IV_PURPOSE type CHAR1 default 'C'
      !IV_PARTN type /ITETR/EDF_PART_NO optional
      !IV_AUTH type XFELD optional .
  methods SET_HEADER
  abstract
    importing
      !IS_HEAD type /ITETR/EDF_S_XML_HEAD .
  methods SET_ITEM
  abstract
    importing
      !IS_ITEM type /ITETR/EDF_S_XML_ITEM
      !IT_SUM_ITEMS type /ITETR/EDF_TT_SUM_ITEMS optional
      !IT_ITEMS type /ITETR/EDF_TT_DEFKY optional .
  methods GENERATE_XML
  abstract
    exporting
      !EV_FTYPE type /ITETR/EDF_FTYPE
      !EV_FILEX type XSTRING .
  methods SAVE
    importing
      !IV_BUKRS type BUKRS
      !IV_BCODE type /ITETR/EDF_BCODE
      !IV_GJAHR type GJAHR
      !IV_MONAT type MONAT
      !IV_PARTN type /ITETR/EDF_PART_NO .
  methods CREATE_BY_URL
    importing
      !IV_URL type STRING .
  methods SET_COMPANY_INFO
    importing
      !IV_BUKRS type BUKRS .
  methods CREATE_REQUEST
  abstract
    importing
      !IV_XML type XSTRING
      !IV_BCODE type /ITETR/EDF_BCODE
      !IV_GJAHR type GJAHR
      !IV_MONAT type MONAT
      !IV_PARTN type /ITETR/EDF_PART_NO
    returning
      value(RV_REQUEST) type XSTRING .
  methods SET_REQUEST_HEADER
  abstract
    importing
      !IV_REQUEST type XSTRING .
  methods SEND
    importing
      !IV_BUKRS type BUKRS
      !IV_BCODE type /ITETR/EDF_BCODE
      !IV_GJAHR type GJAHR
      !IV_MONAT type MONAT
      !IV_PARTN type /ITETR/EDF_PART_NO
      !IV_XML type XSTRING
    returning
      value(RS_MSG_RESPONSE) type /ITETR/EDF_S_RESPONSE .
  methods CONVERT_RESPONSE
  abstract
    importing
      !IV_RESPONSE type STRING
      !IV_CODE type INT4
      !IV_REASON type STRING
    returning
      value(RS_MSG_RESPONSE) type /ITETR/EDF_S_RESPONSE .
  methods SEND_REST
    importing
      !IV_BUKRS type BUKRS
      !IV_BCODE type /ITETR/EDF_BCODE
      !IV_GJAHR type GJAHR
      !IV_MONAT type MONAT
      !IV_PARTN type /ITETR/EDF_PART_NO
      !IV_XML type XSTRING
    returning
      value(RS_MSG_RESPONSE) type /ITETR/EDF_S_RESPONSE .
  methods CREATE_BODY_API
  abstract
    importing
      !IV_XML type XSTRING
      !IV_BCODE type /ITETR/EDF_BCODE
      !IV_GJAHR type GJAHR
      !IV_MONAT type MONAT
      !IV_PARTN type /ITETR/EDF_PART_NO
    returning
      value(RV_BODY) type STRING .
  methods SET_REQUEST_HEADER_API
  abstract
    importing
      !IV_BODY type STRING .
protected section.

  data MS_HEADER type /ITETR/EDF_S_XML_HEADER .
  data MO_CLIENT type ref to IF_HTTP_CLIENT .
  data MS_SRKDB type /ITETR/EDF_SRKDB .
  data MV_PARTN type /ITETR/EDF_PART_NO .
  data MV_AUTH type XFELD .
private section.

  constants MC_CHILD_CLASS_NAME_PREFIX type SEOCLSNAME value '/ITETR/CL_EDF_XML_INT_'.
ENDCLASS.



CLASS /ITETR/CL_EDF_XML_INT IMPLEMENTATION.


  METHOD constructor.

    me->ms_header = is_header.
    me->mv_partn  = iv_partn.
    me->mv_auth   = iv_auth.

  ENDMETHOD.


  METHOD create_by_url.

    IF ms_srkdb-sm59_dest IS NOT INITIAL.
      cl_http_client=>create_by_destination(
            EXPORTING
              destination              = ms_srkdb-sm59_dest
            IMPORTING
              client                   = mo_client
            EXCEPTIONS
              argument_not_found       = 1
              destination_not_found    = 2
              destination_no_authority = 3
              plugin_not_active        = 4
              internal_error           = 5
              OTHERS                   = 6 ).
    ELSE.
      cl_http_client=>create_by_url(
                    EXPORTING url    = iv_url
                    IMPORTING client = mo_client ).
    ENDIF.

  ENDMETHOD.


  METHOD factory.

    DATA lv_intid TYPE /itetr/edf_e_intid.
    DATA lv_class_name TYPE seoclsname.

    CALL METHOD /itetr/cl_edf_xml_int=>get_intid
      EXPORTING
        iv_bukrs = iv_bukrs
      RECEIVING
        rv_intid = lv_intid.

    CHECK lv_intid IS NOT INITIAL.

    CONCATENATE mc_child_class_name_prefix
                lv_intid
                INTO lv_class_name.

    CREATE OBJECT ro_object TYPE (lv_class_name) EXPORTING is_header  = is_header
                                                           iv_purpose = iv_purpose
                                                           iv_partn   = iv_partn.


  ENDMETHOD.


  METHOD get_intid.


    SELECT SINGLE intid
           INTO rv_intid
           FROM /itetr/edf_srkdb
           WHERE bukrs EQ iv_bukrs.


  ENDMETHOD.


  METHOD save.


    DATA ls_dihhd TYPE /itetr/edf_dihhd.
    DATA lt_dihhd TYPE TABLE OF /itetr/edf_dihhd.
    DATA lv_ftype TYPE /itetr/edf_dihhd-ftype.
    DATA lv_filex TYPE xstring.
    DATA lo_root  TYPE REF TO cx_root.

    CLEAR lv_filex.
    CLEAR ls_dihhd.

    ls_dihhd-dfile = 'INT'.

    TRY.
        me->generate_xml(
          IMPORTING
            ev_ftype = lv_ftype
            ev_filex = lv_filex
        ).

        ls_dihhd-ftype = lv_ftype.
        ls_dihhd-filex = lv_filex.

      CATCH cx_root INTO lo_root.

    ENDTRY.

    IF ls_dihhd-ftype IS NOT INITIAL AND ls_dihhd-filex IS NOT INITIAL.
      ls_dihhd-bukrs = iv_bukrs.
      ls_dihhd-bcode = iv_bcode.
      ls_dihhd-gjahr = iv_gjahr.
      ls_dihhd-monat = iv_monat.
      ls_dihhd-partn = iv_partn.

      APPEND ls_dihhd TO lt_dihhd.
      CLEAR ls_dihhd.
    ENDIF.

    IF lines( lt_dihhd ) GT 0.

      UPDATE /itetr/edf_oldef SET yevok = abap_true
                                  yvbok = abap_true
                                  kebok = abap_true
                                  kbbok = abap_true
                                  gbyok = space
                                  gbkok = space
                                  derok = abap_true
                                  serok = abap_true
                            WHERE bukrs EQ iv_bukrs
                              AND bcode EQ iv_bcode
                              AND gjahr EQ iv_gjahr
                              AND monat EQ iv_monat
                              AND partn EQ iv_partn.

      MODIFY /itetr/edf_dihhd FROM TABLE lt_dihhd[].
      COMMIT WORK AND WAIT.
    ENDIF.

  ENDMETHOD.


METHOD send.

  DATA: lv_url      TYPE string,
        lv_request  TYPE xstring,
        lv_code     TYPE i,
        lv_reason   TYPE string,
        lv_response TYPE string,
        lv_user     TYPE string,
        lv_password TYPE string.

  CALL METHOD me->set_company_info
    EXPORTING
      iv_bukrs = iv_bukrs.

  lv_url = ms_srkdb-srapi.

  CALL METHOD me->create_by_url
    EXPORTING
      iv_url = lv_url.

  CALL METHOD me->create_request
    EXPORTING
      iv_xml     = iv_xml
      iv_bcode   = iv_bcode
      iv_gjahr   = iv_gjahr
      iv_monat   = iv_monat
      iv_partn   = iv_partn
    RECEIVING
      rv_request = lv_request.

  IF me->mv_auth IS NOT INITIAL.
    lv_user = ms_srkdb-sausr.
    lv_password = ms_srkdb-sapas.
    mo_client->authenticate(
      EXPORTING
        username = lv_user
        password = lv_password ).
  ENDIF.

  CALL METHOD me->set_request_header( EXPORTING iv_request = lv_request ).

  mo_client->request->set_data( lv_request ).

  mo_client->send( EXCEPTIONS
                   http_communication_failure = 1
                   http_invalid_state         = 2
                   http_processing_failed     = 3
                   http_invalid_timeout       = 4
                   OTHERS                     = 99 ).

  mo_client->receive( EXCEPTIONS
                      http_communication_failure = 1
                      http_invalid_state         = 2
                      http_processing_failed     = 3
                      OTHERS                     = 99 ).

  mo_client->response->get_status( IMPORTING code   = lv_code
                                             reason = lv_reason ).

  lv_response = mo_client->response->get_cdata( ).

  CALL METHOD me->convert_response
    EXPORTING
      iv_response     = lv_response
      iv_code         = lv_code
      iv_reason       = lv_reason
    RECEIVING
      rs_msg_response = rs_msg_response.

ENDMETHOD.


  METHOD send_rest.
    DATA: lv_url      TYPE string,
          lv_request  TYPE xstring,
          lv_code     TYPE i,
          lv_reason   TYPE string,
          lv_response TYPE string,
          lv_user     TYPE string,
          lv_password TYPE string,
          lv_body     TYPE string.

    CALL METHOD me->set_company_info
      EXPORTING
        iv_bukrs = iv_bukrs.

    lv_url = ms_srkdb-srapi.

    CALL METHOD me->create_by_url
      EXPORTING
        iv_url = lv_url.

    CALL METHOD me->create_body_api
      EXPORTING
        iv_xml   = iv_xml
        iv_bcode = iv_bcode
        iv_gjahr = iv_gjahr
        iv_monat = iv_monat
        iv_partn = iv_partn
      RECEIVING
        rv_body  = lv_body.


    CALL METHOD me->set_request_header_api( EXPORTING iv_body = lv_body ).

    mo_client->request->set_cdata( data = lv_body offset = 0 length = strlen( lv_body ) ).

    mo_client->send( EXCEPTIONS
                     http_communication_failure = 1
                     http_invalid_state         = 2
                     http_processing_failed     = 3
                     http_invalid_timeout       = 4
                     OTHERS                     = 99 ).

    mo_client->receive( EXCEPTIONS
                    http_communication_failure = 1
                    http_invalid_state         = 2
                    http_processing_failed     = 3
                    OTHERS                     = 99 ).

    mo_client->response->get_status( IMPORTING code   = lv_code
                                               reason = lv_reason ).

    lv_response = mo_client->response->get_cdata( ).

    CALL METHOD me->convert_response
      EXPORTING
        iv_response     = lv_response
        iv_code         = lv_code
        iv_reason       = lv_reason
      RECEIVING
        rs_msg_response = rs_msg_response.


  ENDMETHOD.


  METHOD set_company_info.

    CLEAR ms_srkdb.

    SELECT SINGLE *
      INTO ms_srkdb
      FROM /itetr/edf_srkdb
      WHERE bukrs EQ iv_bukrs.

    IF ms_srkdb-srapi IS INITIAL.
      "raise exception konulucak
    ENDIF.

  ENDMETHOD.
ENDCLASS.