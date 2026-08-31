class /ITETR/CL_EDF_XML_INT_SPR definition
  public
  inheriting from /ITETR/CL_EDF_XML_INT
  final
  create public .

public section.

  types:
    begin of mty_service_header.
    TYPES name TYPE string.
    TYPES value TYPE string.
    TYPES END OF mty_service_header .
  types:
    mty_service_header_tab TYPE TABLE OF mty_service_header WITH DEFAULT KEY .

  data MS_SPR_CSV type /ITETR/IF_EDF_XML_TYPES=>TY_SPR_CSV .

  methods GET_TOKEN
    returning
      value(RV_TOKEN) type STRING .
  methods CONSTRUCTOR
    importing
      !IS_HEADER type /ITETR/EDF_S_XML_HEADER
      !IV_PURPOSE type CHAR1 optional
      !IV_PARTN type /ITETR/EDF_PART_NO optional .

  methods CONVERT_RESPONSE
    redefinition .
  methods CREATE_BODY_API
    redefinition .
  methods CREATE_REQUEST
    redefinition .
  methods GENERATE_XML
    redefinition .
  methods SET_HEADER
    redefinition .
  methods SET_ITEM
    redefinition .
  methods SET_REQUEST_HEADER
    redefinition .
  methods SET_REQUEST_HEADER_API
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /ITETR/CL_EDF_XML_INT_SPR IMPLEMENTATION.


  METHOD constructor.

    CALL METHOD super->constructor(
      EXPORTING
        is_header  = is_header
        iv_purpose = iv_purpose
        iv_partn   = iv_partn  ).

    IF iv_purpose EQ 'C'.
      DATA ls_srkdb TYPE /itetr/edf_srkdb.

      SELECT SINGLE *
        INTO ls_srkdb
        FROM /itetr/edf_srkdb
        WHERE bukrs EQ is_header-bukrs.

      me->ms_spr_csv-header-taxid                = ls_srkdb-stcd1.
      me->ms_spr_csv-header-period_covered_end   = is_header-periodcoveredstart.
      me->ms_spr_csv-header-period_covered_end   = is_header-periodcoveredend.
      me->ms_spr_csv-header-fiscal_year_start    = is_header-fiscalyearstart.
      me->ms_spr_csv-header-fiscal_year_end      = is_header-fiscalyearend.

    ENDIF.
  ENDMETHOD.


  METHOD convert_response.

    TYPES : BEGIN OF ty_result,
              status            TYPE char600,
              statusenumvalue   TYPE char10,
              issuccess         TYPE boolean_flg,
              resultmessage     TYPE char600,
              traceid           TYPE char600,
              description       TYPE char600,
              statusdescription TYPE char600,
              errormessage      TYPE char600,
              isadded           TYPE boolean_flg,
              isupdated         TYPE boolean_flg,
              isdeleted         TYPE boolean_flg,
              isapproved        TYPE boolean_flg,
              completed         TYPE boolean_flg.
    TYPES END OF ty_result.

    DATA: ls_result TYPE ty_result.


*    /itetr/cl_edf_json=>deserialize( EXPORTING json        = iv_response
*                                         pretty_name = /itetr/cl_edf_json=>pretty_mode-camel_case
*                              CHANGING  data        = ls_result ).

    CALL FUNCTION '/ITETR/EDF_JSON_DESERIALIZE'
      EXPORTING
        i_data = iv_response
      IMPORTING
        e_data = ls_result
      EXCEPTIONS
        OTHERS = 1.



    IF iv_code EQ '200'.

      IF ls_result-statusenumvalue EQ '0'.
        rs_msg_response-msgty = 'S'.
      ELSE.
        rs_msg_response-msgty = 'E'.
      ENDIF.
    ELSE.
      rs_msg_response-msgty = 'E'.
    ENDIF.

    IF ls_result-statusenumvalue NE '0'.
      rs_msg_response-msgty = 'E'.

      CONCATENATE ls_result-statusenumvalue
             '-'
             ls_result-status
             '-'
              ls_result-statusdescription
             INTO rs_msg_response-msgtx
             SEPARATED BY space.
    ENDIF.

  ENDMETHOD.


  METHOD create_body_api.

    DATA: BEGIN OF ls_data,
            customerbranchid  TYPE i,
            customerbrachcode TYPE string,
            year              TYPE gjahr,
            month             TYPE monat,
            partnumber        TYPE i,
            partdata          TYPE string,
          END OF ls_data.

    DATA lv_bcode       TYPE n LENGTH 4.
    DATA lv_part_no     TYPE /itetr/edf_part_no.
    DATA lv_request     TYPE string.
    DATA lv_filename    TYPE string.
    DATA lv_base_64     TYPE string.
    DATA lo_zip         TYPE REF TO cl_abap_zip.
    DATA lv_zipped_file TYPE xstring.
    CONSTANTS lc_op_enc TYPE x VALUE 36.

    lv_bcode = iv_bcode.

    lv_part_no = iv_partn.
    SHIFT lv_part_no LEFT DELETING LEADING '0'.

    IF lv_part_no IS INITIAL.
      lv_part_no = '1'.
    ENDIF.

    CONCATENATE ms_srkdb-stcd1
                '_'
                lv_bcode
                '_'
                iv_gjahr
                iv_monat
                '_'
                lv_part_no
                '.csv'
                INTO lv_filename.

    CREATE OBJECT lo_zip.
    lo_zip->add(
      EXPORTING
        name           = lv_filename
        content        = iv_xml
    ).

    lv_zipped_file = lo_zip->save( ).

    CLEAR lv_base_64.
    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_zipped_file
      IMPORTING
        output = lv_base_64.

    REPLACE FIRST OCCURRENCE OF '.csv' IN lv_filename WITH '.zip'.

    ls_data-partdata = lv_base_64.
    ls_data-year = iv_gjahr.
    ls_data-month = iv_monat.
    ls_data-partnumber  = iv_partn.
    ls_data-customerbrachcode = lv_bcode.
*    ls_data-customerbrachcode = '0000'.
    ls_data-customerbranchid = 0.

**    rv_body = /itetr/cl_edf_json=>serialize( data         = ls_data
**                                       pretty_name  = /itetr/cl_edf_json=>pretty_mode-camel_case ).

  CALL FUNCTION '/ITETR/EDF_JSON_SERIALIZE'
    EXPORTING
      i_data = ls_data
    IMPORTING
      e_json = ls_data.


  ENDMETHOD.


  method CREATE_REQUEST.
  endmethod.


  METHOD generate_xml.


    TYPE-POOLS: truxs.

    DATA lo_converter TYPE REF TO cl_rsda_csv_converter.
    DATA lt_csv TYPE truxs_t_text_data.
    DATA lv_csv TYPE LINE OF truxs_t_text_data.
    DATA ls_item TYPE /itetr/edf_s_spr_csv_item.
    DATA ls_header TYPE /itetr/if_edf_xml_types=>ty_spr_header.
    DATA lv_string_csv TYPE string.
    DATA lv_xstring_csv TYPE xstring.

    lo_converter = cl_rsda_csv_converter=>create( i_separator = ';' ) .


    LOOP AT me->ms_spr_csv-item INTO ls_item.

      CLEAR lv_csv.
      lo_converter->structure_to_csv(
        EXPORTING
          i_s_data = ls_item
        IMPORTING
          e_data   = lv_csv
      ).

      APPEND lv_csv TO lt_csv.
    ENDLOOP.

    CLEAR lv_string_csv.

    LOOP AT lt_csv INTO lv_csv.
*      REPLACE ALL OCCURRENCES OF '.'  IN lv_csv WITH ''.
*      REPLACE ALL OCCURRENCES OF ','  IN lv_csv WITH '.'.
*      REPLACE ALL OCCURRENCES OF '!'  IN lv_csv WITH '.'.
*      REPLACE ALL OCCURRENCES OF '"'  IN lv_csv WITH ''.

      IF lv_string_csv IS INITIAL.
        lv_string_csv = lv_csv.
      ELSE.
         CONCATENATE lv_string_csv cl_abap_char_utilities=>newline lv_csv ',' INTO lv_string_csv.
      ENDIF.
    ENDLOOP.

    CONSTANTS lc_mimetype TYPE c LENGTH 50 VALUE 'text/plain; charset=utf-8'.

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text     = lv_string_csv
        mimetype = lc_mimetype
      IMPORTING
        buffer   = lv_xstring_csv
      EXCEPTIONS
        failed   = 1
        OTHERS   = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CONCATENATE  cl_abap_char_utilities=>byte_order_mark_utf8
                 lv_xstring_csv
                 INTO lv_xstring_csv IN BYTE MODE.

    ev_ftype = 'CSV'.
    ev_filex = lv_xstring_csv.
  ENDMETHOD.


  METHOD get_token.

    TYPES : BEGIN OF ty_result,
              issuccessed     TYPE string,
              result          TYPE string,
              resultenumvalue TYPE string,
              accesstoken     TYPE string.
    TYPES END OF ty_result.

    DATA: ls_token             TYPE /itetr/edf_token,
          ls_token_old         TYPE /itetr/edf_token,
          lv_timestamp         TYPE timestamp,
          lv_expire_timestamp  TYPE timestamp,
          lv_request_xml       TYPE string,
          lv_response_xml      TYPE string,
          lt_xml_table         TYPE TABLE OF smum_xmltb,
          ls_xml_line          TYPE smum_xmltb,
          lv_content           TYPE string,
          lv_zipped_file       TYPE xstring,
          lv_message           TYPE bapi_msg,
*          lx_exception         TYPE REF TO /itetr/cx_regulative_exception,
          lv_body              TYPE string,
          lv_response          TYPE string,
          lv_user              TYPE string,
          lv_password          TYPE string,
          lv_url               TYPE string,
          ls_result            TYPE ty_result,
          lt_request_header    TYPE mty_service_header_tab,
          lv_input_string      TYPE string,
          lv_response_desc     TYPE string,
          lv_response_code     TYPE i,
          lo_http_client_login TYPE REF TO if_http_client.

    lv_user  = ms_srkdb-sausr.
    lv_password = ms_srkdb-sapas.


    SELECT SINGLE * FROM /itetr/edf_token INTO ls_token_old WHERE client_id = sy-sysid AND
                                                                  intid = ms_srkdb-intid.
    GET TIME STAMP FIELD lv_timestamp.

    "Token hâlâ geçerli mi?
    IF ls_token_old-expire_at IS NOT INITIAL AND
       ls_token_old-expire_at > lv_timestamp + 150. "son 5 dk kala degistirilir
      rv_token = ls_token_old-access_token.
      RETURN.
    ENDIF.


    IF  rv_token IS INITIAL.


      CALL FUNCTION 'ENQUEUE_/ITETR/EEDF_TKN'
        EXPORTING
          client_id      = sy-sysid
          intid          = ms_srkdb-intid
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        rv_token = ls_token_old-access_token.
      ELSE.


        cl_http_client=>create_by_destination(
      EXPORTING
        destination              = ms_srkdb-desti
      IMPORTING
        client                   = lo_http_client_login
      EXCEPTIONS
        argument_not_found       = 1
        destination_not_found    = 2
        destination_no_authority = 3
        plugin_not_active        = 4
        internal_error           = 5
        OTHERS                   = 6 ).


        CONCATENATE '{ "clientType": " WebService", "eMail": "' lv_user '", "password": "' lv_password '" , "customerIdentity": "' ms_srkdb-stcd1 '" }' INTO lv_input_string.
        lo_http_client_login->request->set_header_field( name = '~request_method' value = 'POST' ).
        lo_http_client_login->request->set_header_field( name = 'Content-Type' value = 'application/json; charset=utf-8' ).
        lo_http_client_login->request->set_header_field( name = '~request_uri' value = '/v1/Auth/AccessToken' ).
        lo_http_client_login->request->set_cdata( data = lv_input_string offset = 0 length = strlen( lv_input_string ) ).

        lo_http_client_login->send(
          EXCEPTIONS
            http_communication_failure = 1
            http_invalid_state         = 2 ).

        lo_http_client_login->receive(
           EXCEPTIONS
            http_communication_failure = 1
            http_invalid_state         = 2
            http_processing_failed     = 3 ).

        lo_http_client_login->response->get_status(
           IMPORTING
            code   = lv_response_code
           reason  = lv_response_desc ).


        lv_response = lo_http_client_login->response->get_cdata( ).

**        /itetr/cl_edf_json=>deserialize( EXPORTING json        = lv_response
**                                             pretty_name = /itetr/cl_edf_json=>pretty_mode-camel_case
**                                   CHANGING  data        = ls_result ).

    CALL FUNCTION '/ITETR/EDF_JSON_DESERIALIZE'
      EXPORTING
        i_data = lv_response
      IMPORTING
        e_data = ls_result
      EXCEPTIONS
        OTHERS = 1.

        IF ls_result-issuccessed EQ abap_true.
          rv_token = ls_result-accesstoken.
        ENDIF.
      ENDIF.

      IF rv_token IS NOT INITIAL.

        "24 saat eklenir
        cl_abap_tstmp=>add(
          EXPORTING
            tstmp = lv_timestamp
            secs = 86400        " 24 saat = 24 * 60 * 60
          RECEIVING
            r_tstmp = lv_expire_timestamp ).

        ls_token-client_id = sy-sysid.
        ls_token-access_token = rv_token.
        ls_token-created_on = lv_timestamp.
        ls_token-expire_at = lv_expire_timestamp.
        ls_token-intid = ms_srkdb-intid.
        MODIFY /itetr/edf_token FROM ls_token.
        COMMIT WORK AND WAIT.
      ENDIF.

      CALL FUNCTION 'DEQUEUE_/ITETR/EEDF_TKN'
        EXPORTING
          client_id = sy-sysid
          intid     = ms_srkdb-intid.

    ENDIF.




  ENDMETHOD.


  METHOD set_header.


  ENDMETHOD.


  METHOD set_item.

    DATA: lv_stcd1       TYPE stcd1,
          lv_dmbtr_str   TYPE string,
          lv_dmbtr_h_str TYPE string.

    FIELD-SYMBOLS <ls_item> TYPE /itetr/edf_s_spr_csv_item.


    APPEND INITIAL LINE TO me->ms_spr_csv-item ASSIGNING <ls_item>.

    SELECT SINGLE stcd1
      FROM /itetr/edf_srkdb
      INTO lv_stcd1
      WHERE bukrs EQ is_item-head-header-bukrs.

    <ls_item>-identifier                    = lv_stcd1.
    <ls_item>-ledger_year                   = is_item-item-gjahr.
    <ls_item>-ledger_month                  = is_item-item-monat.
    <ls_item>-entered_by                    = is_item-head-enteredby.
    <ls_item>-entered_date                  = is_item-head-entereddate.
    <ls_item>-entry_number                  = is_item-item-belnr.
    <ls_item>-entry_comment                 = is_item-head-entrycomment.
    <ls_item>-entry_number_counter          = is_item-item-yevno.
    <ls_item>-line_number                   = is_item-item-linen.
    <ls_item>-account_main_id               = is_item-accountmainid.
    <ls_item>-account_main_description      = is_item-accountmaindescription.
    <ls_item>-acount_sub_description        = is_item-accountsubdescription.
    <ls_item>-account_sub_id                = is_item-accountsubid.
    <ls_item>-amount                        = is_item-item-dmbtr_def.
    <ls_item>-debit_credit_code             = is_item-debitcreditcode.
    <ls_item>-document_type                 = is_item-documenttype.
    <ls_item>-document_type_description     = is_item-documenttypedesc.
    <ls_item>-document_number               = is_item-documentnumber.
    <ls_item>-document_date                 = is_item-documentdate.
    <ls_item>-payment_method                = is_item-paymentmethod.
    <ls_item>-detail_comment                = is_item-detailcomment.
    <ls_item>-amount_currency               = ' '.
    <ls_item>-amount_org_ex_rate_date       = '  '.
    <ls_item>-amount_original_amount        = '  '.
    <ls_item>-amount_original_currency      = '  '.
    <ls_item>-amount_original_exchange_rate = '  '.
    <ls_item>-amount_org_ex_rate_source     = '  '.
    <ls_item>-amount_org_ex_rate_comment    = '  '.
     <ls_item>-batch_id                      = is_item-head-header-bcode.
*    <ls_item>-batch_id                      = '0000'.

    DATA: lv_dmbtr TYPE /itetr/edf_defky-dmbtr_def.
    SELECT SUM( dmbtr_def ) AS dmbtr_def
      FROM /itetr/edf_defky
      INTO lv_dmbtr
      WHERE bukrs EQ is_item-head-header-bukrs
        AND shkzg EQ 'S'
        AND gjahr EQ is_item-item-gjahr
        AND monat EQ is_item-item-monat
        AND yevno EQ is_item-item-yevno.
    DATA: lv_dmbtr_h TYPE /itetr/edf_defky-dmbtr_def.
    SELECT SUM( dmbtr_def ) AS dmbtr_def
      FROM /itetr/edf_defky
      INTO lv_dmbtr_h
      WHERE bukrs EQ is_item-head-header-bukrs
        AND shkzg EQ 'H'
        AND gjahr EQ is_item-item-gjahr
        AND monat EQ is_item-item-monat
        AND yevno EQ is_item-item-yevno.

    IF lv_dmbtr IS NOT INITIAL.
      <ls_item>-total_debit              = lv_dmbtr.
    ENDIF.
    IF lv_dmbtr_h IS NOT INITIAL.
      <ls_item>-total_credit             = lv_dmbtr_h.
    ENDIF.



  ENDMETHOD.


  METHOD set_request_header.
  ENDMETHOD.


  METHOD set_request_header_api.

    DATA: lv_token TYPE string,
          lv_uri   TYPE string.

    CALL METHOD me->get_token
      RECEIVING
        rv_token = lv_token.



    mo_client->request->set_header_field( name = '~request_method' value = 'POST' ).
    mo_client->request->set_header_field( name = 'Content-Type'  value = 'application/json; charset=utf-8' ).
    mo_client->request->set_header_field( name = '~request_uri'  value = '/v1/UploadedLedger/SendLedgerPart' ).
    mo_client->request->set_header_field( name = 'Authorization' value = |Bearer { lv_token }| ).


  ENDMETHOD.
ENDCLASS.