class /ITETR/CL_EDF_XML_INT_SDX definition
  public
  inheriting from /ITETR/CL_EDF_XML_INT
  final
  create public .

public section.

  data MT_SABANCIDX_TXT type /ITETR/IF_EDF_XML_TYPES=>TY_EDOKSIS_TXT .
  data MV_COUNTER type INT4 .

  methods CONSTRUCTOR
    importing
      !IS_HEADER type /ITETR/EDF_S_XML_HEADER
      !IV_PURPOSE type CHAR1 default 'C'
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

  methods UPLOAD_FILE_TO_FTP
    importing
      !IV_FILENAME type STRING
      !IV_FILE_XSTRING type XSTRING .
ENDCLASS.



CLASS /ITETR/CL_EDF_XML_INT_SDX IMPLEMENTATION.


  METHOD constructor.

    DATA lv_part_number TYPE n LENGTH 8.
    DATA ls_month_names TYPE t247.
    DATA lt_month_names TYPE TABLE OF t247.

    lv_part_number = iv_partn.

    IF lv_part_number IS INITIAL.
      lv_part_number = 1.
    ENDIF.

    DATA ls_srkdb TYPE /itetr/edf_srkdb.

    CALL METHOD super->constructor(
      EXPORTING
        is_header  = is_header
        iv_purpose = iv_purpose ).

    IF iv_purpose EQ 'C'.
      CLEAR ls_srkdb.
      SELECT SINGLE *
               INTO ls_srkdb
               FROM /itetr/edf_srkdb
              WHERE bukrs EQ is_header-bukrs.

      FIELD-SYMBOLS <ls_txt> TYPE /itetr/edf_s_sdx_txt_item.

      APPEND INITIAL LINE TO me->mt_sabancidx_txt ASSIGNING <ls_txt>.
      <ls_txt>-line_type = 'HDR:'.
      <ls_txt>-column01 = 'JOURNAL'.
      <ls_txt>-column02 = is_header-fiscalyearstart.
      <ls_txt>-column03 = is_header-fiscalyearend.
      <ls_txt>-column04 = is_header-periodcoveredstart.
      <ls_txt>-column05 = is_header-periodcoveredend.

*      CONCATENATE 'YEV'
*                  is_header-gjahr
*                  lv_part_number
*                  INTO <ls_txt>-column06.
      <ls_txt>-column06 = is_header-stcd1.

      CALL FUNCTION 'MONTH_NAMES_GET'
        EXPORTING
          language              = sy-langu
        TABLES
          month_names           = lt_month_names
        EXCEPTIONS
          month_names_not_found = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CLEAR ls_month_names.
      READ TABLE lt_month_names INTO ls_month_names WITH KEY mnr = is_header-monat.

      CONCATENATE is_header-gjahr
                  ls_month_names-ltx
                  TEXT-001
                  INTO <ls_txt>-column07 SEPARATED BY space.

      <ls_txt>-column08 = 'EMPTY'.
      <ls_txt>-column09 = 'EMPTY'.
      <ls_txt>-column10 = 'EMPTY'.
      <ls_txt>-column11 = 'EMPTY'.
      <ls_txt>-column12 = 'EMPTY'.
    ENDIF.

  ENDMETHOD.


  METHOD CONVERT_RESPONSE.

    DATA lv_xml_input TYPE xstring.
    DATA ls_xml_table TYPE smum_xmltb.
    DATA lt_xml_table TYPE TABLE OF smum_xmltb.
    DATA lt_return    TYPE TABLE OF bapiret2.
    DATA lv_code      TYPE string.

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = iv_response
      IMPORTING
        buffer = lv_xml_input
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'SMUM_XML_PARSE'
      EXPORTING
        xml_input = lv_xml_input
      TABLES
        xml_table = lt_xml_table
        return    = lt_return.

    IF iv_code EQ '200'.
      CLEAR ls_xml_table.
      READ TABLE lt_xml_table INTO ls_xml_table WITH KEY cname = 'FileUploadedExResult'.
      rs_msg_response-msgtx = ls_xml_table-cvalue.

      IF ls_xml_table-cvalue+0(9) EQ 'BASARILI:'.
        rs_msg_response-msgty = 'S'.
      ELSE.
        rs_msg_response-msgty = 'E'.
      ENDIF.
    ELSE.
      rs_msg_response-msgty = 'E'.
    ENDIF.

    lv_code = iv_code.

    CONCATENATE rs_msg_response-msgtx
                'HTTP Status Code:'
                lv_code
                '-'
                iv_response
                INTO rs_msg_response-msgtx
                SEPARATED BY space.

  ENDMETHOD.


  method CREATE_BODY_API.
  endmethod.


  METHOD create_request.

    DATA lv_bcode       TYPE n LENGTH 4.
    DATA lv_part_no     TYPE /itetr/edf_part_no.
    DATA lv_request     TYPE string.
    DATA lv_filename    TYPE string.
    DATA lv_length      TYPE i.
    DATA lv_hash_string TYPE string.
    DATA lv_guid        TYPE guid_32.

    lv_bcode = iv_bcode.

    lv_part_no = iv_partn.
    SHIFT lv_part_no LEFT DELETING LEADING '0'.

    IF lv_part_no IS INITIAL.
      lv_part_no = '1'.
    ENDIF.

    CONCATENATE me->ms_srkdb-stcd1
                '.txt'
                INTO lv_filename.

    CALL FUNCTION 'GUID_CREATE'
      IMPORTING
        ev_guid_32 = lv_guid.

    CONCATENATE lv_guid
                '.txt'
                INTO lv_filename.

    TRY .
        cl_abap_message_digest=>calculate_hash_for_raw(
          EXPORTING
            if_algorithm     = 'SHA1'
            if_data          = iv_xml
            if_length        = lv_length
          IMPORTING
            ef_hashb64string = lv_hash_string
        ).
      CATCH cx_abap_message_digest.
    ENDTRY.

***    me->upload_file_to_ftp(
***      EXPORTING
***        iv_filename     = lv_filename
***        iv_file_xstring = iv_xml
***    ).

    CONCATENATE
    '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/">'
       '<soap:Header/>'
       '<soap:Body>'
          '<tem:FileUploadedEx>'
             '<tem:FTPUserID>' ms_srkdb-sausr '</tem:FTPUserID>'
             '<tem:FTPUserPassword>' ms_srkdb-sapas '</tem:FTPUserPassword>'
             '<tem:FileName>' lv_filename '</tem:FileName>'
             '<tem:HashAlgorithm>' 'SHA1' '</tem:HashAlgorithm>'
             '<tem:FileHash>' lv_hash_string '</tem:FileHash>'
          '</tem:FileUploadedEx>'
       '</soap:Body>'
    '</soap:Envelope>'
    INTO lv_request.

    CALL FUNCTION 'ECATT_CONV_STRING_TO_XSTRING'
      EXPORTING
        im_string  = lv_request
      IMPORTING
        ex_xstring = rv_request.

***--->> SOAP Example

***<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/">
***   <soap:Header/>
***   <soap:Body>
***      <tem:FileUploadedEx>
***         <tem:FTPUserID> </tem:FTPUserID>
***         <tem:FTPUserPassword> </tem:FTPUserPassword>
***         <tem:FileName> </tem:FileName>
***         <tem:HashAlgorithm> </tem:HashAlgorithm>
***         <tem:FileHash> </tem:FileHash>
***      </tem:FileUploadedEx>
***   </soap:Body>
***</soap:Envelope>

***<<--- SOAP Example

  ENDMETHOD.


  METHOD generate_xml.

    TYPE-POOLS: truxs.

    DATA lo_converter TYPE REF TO cl_rsda_csv_converter.
    DATA lt_file TYPE truxs_t_text_data.
    DATA lv_file TYPE LINE OF truxs_t_text_data.
    DATA ls_txt TYPE /itetr/edf_s_sdx_txt_item.
    DATA lv_string_txt TYPE string.
    DATA lv_xstring_txt TYPE xstring.
    DATA lv_index TYPE sy-index.
    FIELD-SYMBOLS <lv_value> TYPE any.

    lo_converter = cl_rsda_csv_converter=>create( i_separator = cl_abap_char_utilities=>horizontal_tab ) .

    LOOP AT me->mt_sabancidx_txt INTO ls_txt.
*      TRANSLATE ls_txt-amount USING '.!'.
*      TRANSLATE ls_txt-total_debit USING '.!'.
*      TRANSLATE ls_txt-total_credit USING '.!'.

      DO.
        lv_index = sy-index + 1.
        ASSIGN COMPONENT lv_index OF STRUCTURE ls_txt TO <lv_value>.
        IF sy-subrc EQ 0.
          CONCATENATE '~|' <lv_value> '~|' INTO <lv_value>.
*          <lv_value> = '~|' && <lv_value> && '~|'.
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.

      CLEAR lv_file.
      lo_converter->structure_to_csv(
        EXPORTING
          i_s_data = ls_txt
        IMPORTING
          e_data   = lv_file
      ).

      APPEND lv_file TO lt_file.
    ENDLOOP.

    CLEAR lv_string_txt.

    LOOP AT lt_file INTO lv_file.
*      REPLACE ALL OCCURRENCES OF '.' IN ls_txt WITH ''.
*      REPLACE ALL OCCURRENCES OF ',' IN ls_txt WITH '.'.
*      REPLACE ALL OCCURRENCES OF '!' IN ls_txt WITH '.'.
      REPLACE ALL OCCURRENCES OF '~|' IN lv_file WITH '"'.
      REPLACE ALL OCCURRENCES OF '"EMPTY"' IN lv_file WITH ''.

      IF lv_string_txt IS INITIAL.
        lv_string_txt = lv_file.
      ELSE.
        CONCATENATE lv_string_txt cl_abap_char_utilities=>newline lv_file INTO lv_string_txt.
*        lv_string_txt = lv_string_txt && cl_abap_char_utilities=>newline && lv_file.
      ENDIF.
    ENDLOOP.

    CONSTANTS lc_mimetype TYPE c LENGTH 50 VALUE 'text/plain; charset=utf-8'.

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text     = lv_string_txt
        mimetype = lc_mimetype
      IMPORTING
        buffer   = lv_xstring_txt
      EXCEPTIONS
        failed   = 1
        OTHERS   = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

*    CONCATENATE  cl_abap_char_utilities=>byte_order_mark_utf8
*                 lv_xstring_txt
*                 INTO lv_xstring_txt IN BYTE MODE.

    ev_ftype = 'txt'.
    ev_filex = lv_xstring_txt.

  ENDMETHOD.


  METHOD set_header.

    FIELD-SYMBOLS <ls_txt> TYPE /itetr/edf_s_sdx_txt_item.

    APPEND INITIAL LINE TO me->mt_sabancidx_txt ASSIGNING <ls_txt>.
    <ls_txt>-line_type = 'Y:'.

  ENDMETHOD.


  METHOD set_item.

    DATA lv_yevno TYPE char10.
    DATA lv_sirano TYPE char10.
    DATA lv_debitamount LIKE is_item-debitamount.
    DATA lv_creditamount LIKE is_item-creditamount.

    lv_yevno = is_item-item-yevno.
    SHIFT lv_yevno LEFT DELETING LEADING '0'.
    CONDENSE lv_yevno NO-GAPS.

    FIELD-SYMBOLS <ls_txt> TYPE /itetr/edf_s_sdx_txt_item.

***--->> Header
    READ TABLE me->mt_sabancidx_txt ASSIGNING <ls_txt> WITH KEY line_type = 'Y:'
                                                                column01 = lv_yevno.
    IF sy-subrc EQ 0.
      lv_creditamount = <ls_txt>-column02 + is_item-creditamount.
      lv_debitamount = <ls_txt>-column03 + is_item-debitamount.
      <ls_txt>-column02 = lv_creditamount.
      <ls_txt>-column03 = lv_debitamount.

      CONDENSE <ls_txt>-column02 NO-GAPS.
      CONDENSE <ls_txt>-column03 NO-GAPS.
    ELSE.
      READ TABLE me->mt_sabancidx_txt ASSIGNING <ls_txt> WITH KEY line_type = 'Y:'
                                                                  column01 = ''.
      IF sy-subrc EQ 0.
        <ls_txt>-column01 = lv_yevno.
        <ls_txt>-column02 = is_item-creditamount.
        <ls_txt>-column03 = is_item-debitamount.

        CONDENSE <ls_txt>-column02 NO-GAPS.
        CONDENSE <ls_txt>-column03 NO-GAPS.

        <ls_txt>-column04 = is_item-documentdate.
        <ls_txt>-column05 = is_item-item-belnr.
        <ls_txt>-column06 = is_item-item-bktxt.

        <ls_txt>-column07 = 'EMPTY'.
        <ls_txt>-column08 = 'EMPTY'.
        <ls_txt>-column09 = 'EMPTY'.
        <ls_txt>-column10 = 'EMPTY'.
        <ls_txt>-column11 = 'EMPTY'.
        <ls_txt>-column12 = 'EMPTY'.
      ENDIF.
    ENDIF.
***<<--- Header

*    me->mv_counter = me->mv_counter + 1.

    APPEND INITIAL LINE TO me->mt_sabancidx_txt ASSIGNING <ls_txt>.
    <ls_txt>-line_type = 'YD:'.
    <ls_txt>-column01 = is_item-accountmainid.
    <ls_txt>-column02 = is_item-accountmaindescription.
*    <ls_txt>-column03 = me->mv_counter.
    lv_sirano = is_item-item-linen.
    SHIFT lv_sirano LEFT DELETING LEADING '0'.
    CONDENSE lv_sirano NO-GAPS.
    <ls_txt>-column03 = lv_sirano.
    <ls_txt>-column04 = is_item-accountsubid.
    <ls_txt>-column05 = is_item-accountsubdescription.
    <ls_txt>-column06 = is_item-item-dmbtr_def.
    <ls_txt>-column07 = is_item-debitcreditcode.
    <ls_txt>-column08 = ''.
    <ls_txt>-column09 = is_item-documenttype.
    <ls_txt>-column10 = is_item-documenttypedesc.

    IF is_item-documenttype EQ 'invoice'.
      IF is_item-item-xblnr IS NOT INITIAL.
        <ls_txt>-column11 = is_item-item-xblnr.
      ELSE.
        <ls_txt>-column11 = is_item-item-belnr.
      ENDIF.
    ELSE.
      <ls_txt>-column11 = is_item-item-belnr.
    ENDIF.

    <ls_txt>-column12 = is_item-documentdate.

    CONDENSE <ls_txt>-column03 NO-GAPS.
    CONDENSE <ls_txt>-column06 NO-GAPS.

  ENDMETHOD.


  METHOD set_request_header.

    DATA lv_length TYPE i.
    DATA lv_length_s TYPE string.

    lv_length = xstrlen( iv_request ).
    lv_length_s = lv_length.
    CONDENSE lv_length_s NO-GAPS.

    mo_client->request->set_header_field( name = 'Accept-Encoding'   value =  'gzip,deflate' ).
    mo_client->request->set_header_field( name = 'Content-Type'      value =  'text/xml;charset=UTF-8' ).
    mo_client->request->set_header_field( name = 'SOAPAction'        value =  'http://tempuri.org/FileUploadedEx' ).
    mo_client->request->set_header_field( name = 'Connection'        value =  'Keep-Alive' ).
    mo_client->request->set_header_field( name = 'Content-Length'    value =  lv_length_s ).

  ENDMETHOD.


  method SET_REQUEST_HEADER_API.
  endmethod.


  METHOD upload_file_to_ftp.

    CONSTANTS lc_key  TYPE i VALUE 26101957.

    DATA lv_sourcelen       TYPE i.
    DATA lv_user            TYPE c.
    DATA lv_password        TYPE c.
    DATA lv_host            TYPE c.
    DATA lv_handle          TYPE i.

    DATA: BEGIN OF ls_file ,
            line TYPE c LENGTH 300,
          END OF ls_file.
    DATA: lt_file LIKE TABLE OF ls_file.

    lv_user = 'sartenws'.
    lv_password = 'zd7QxLqC'.
    lv_host = '213.153.169.170'.

    lv_sourcelen = strlen( lv_password ).

    CALL FUNCTION 'HTTP_SCRAMBLE'
      EXPORTING
        source      = lv_password
        sourcelen   = lv_sourcelen
        key         = lc_key
      IMPORTING
        destination = lv_password.

    CALL FUNCTION 'FTP_CONNECT'
      EXPORTING
        user            = lv_user
        password        = lv_password
        host            = lv_host
        rfc_destination = 'SAPFTPA'
      IMPORTING
        handle          = lv_handle
      EXCEPTIONS
        not_connected   = 1
        OTHERS          = 2.
    IF sy-subrc EQ 0.
      CLEAR lt_file.

      CALL FUNCTION 'FTP_COMMAND'
        EXPORTING
          handle        = lv_handle
          command       = 'dir'
        TABLES
          data          = lt_file
        EXCEPTIONS
          tcpip_error   = 1
          command_error = 2
          data_error    = 3
          OTHERS        = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CLEAR lt_file.

      CALL FUNCTION 'FTP_R3_TO_SERVER'
        EXPORTING
          handle         = lv_handle
          fname          = iv_filename
          character_mode = abap_true
        TABLES
          text           = lt_file
        EXCEPTIONS
          tcpip_error    = 1
          command_error  = 2
          data_error     = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CLEAR lt_file.

      CALL FUNCTION 'FTP_COMMAND'
        EXPORTING
          handle        = lv_handle
          command       = 'dir'
        TABLES
          data          = lt_file
        EXCEPTIONS
          tcpip_error   = 1
          command_error = 2
          data_error    = 3
          OTHERS        = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.

    CALL FUNCTION 'FTP_DISCONNECT'
      EXPORTING
        handle = lv_handle.

    CALL FUNCTION 'RFC_CONNECTION_CLOSE'
      EXPORTING
        destination          = 'SAPFTPA'
      EXCEPTIONS
        destination_not_open = 1
        OTHERS               = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDMETHOD.
ENDCLASS.