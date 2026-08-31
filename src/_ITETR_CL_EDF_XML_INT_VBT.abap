class /ITETR/CL_EDF_XML_INT_VBT definition
  public
  inheriting from /ITETR/CL_EDF_XML_INT
  final
  create public .

public section.

  data MS_ROOT_VBT type /ITETR/IF_EDF_XML_TYPES=>TY_VBT .

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
ENDCLASS.



CLASS /ITETR/CL_EDF_XML_INT_VBT IMPLEMENTATION.


  METHOD constructor.

    FIELD-SYMBOLS <ls_lines> TYPE /itetr/if_edf_xml_types=>ty_line.
    CALL METHOD super->constructor(
      EXPORTING
        is_header  = is_header
        iv_purpose = iv_purpose ).

    IF iv_purpose EQ 'C'.
      DATA ls_srkdb TYPE /itetr/edf_srkdb.

      SELECT SINGLE *
        INTO ls_srkdb
        FROM /itetr/edf_srkdb
        WHERE bukrs EQ is_header-bukrs.

      me->ms_root_vbt-companyvkn  = ls_srkdb-stcd1.
      me->ms_root_vbt-branchcode  = is_header-branch.
      me->ms_root_vbt-periodstart = is_header-periodcoveredstart.
      me->ms_root_vbt-periodend   = is_header-periodcoveredend.

    ENDIF.

  ENDMETHOD.


  METHOD convert_response.

    CONSTANTS lc_status      TYPE string VALUE 'true'.
    DATA ls_response         TYPE /itetr/if_edf_xml_types=>ty_response_vbt.
    DATA lv_code             TYPE string.
    DATA lx_root             TYPE REF TO cx_root.

    CLEAR ls_response.
    TRY.
        CALL TRANSFORMATION /itetr/edf_vbt_res
         SOURCE XML iv_response
         RESULT root = ls_response.
      CATCH cx_root INTO lx_root.

    ENDTRY.

    IF ls_response-envelope-body-yevmiyekayetxmlresponse-yevmiyekayetxmlresult-success EQ lc_status OR
       ls_response-envelope-body-yevmiyekayetxmlresponse-yevmiyekayetxmlresult-code EQ '0'.
      rs_msg_response-msgty = 'S'.
      rs_msg_response-msgtx = ls_response-envelope-body-yevmiyekayetxmlresponse-yevmiyekayetxmlresult-description.
    ELSE.
      rs_msg_response-msgty = 'E'.
      rs_msg_response-msgtx = ls_response-envelope-body-yevmiyekayetxmlresponse-yevmiyekayetxmlresult-description.
    ENDIF.

    IF iv_code NE '200'.
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

    DATA lv_request       TYPE string.
    DATA lv_filename      TYPE string.
    DATA lv_base_64       TYPE string.
    DATA lv_hash_string   TYPE string.
    DATA lv_last_part     TYPE /itetr/edf_dihhd-partn.
    DATA lo_zip           TYPE REF TO cl_abap_zip.
    DATA lv_length        TYPE i.
    DATA lv_zipped_file   TYPE xstring.
    CONSTANTS lc_op_enc   TYPE x VALUE 36.
    DATA lt_part TYPE TABLE OF /itetr/edf_dihhd.
    DATA lv_guid TYPE char36.
    DATA lv_partial TYPE string.

    SELECT *
        INTO TABLE lt_part
        FROM /itetr/edf_dihhd
        WHERE bukrs EQ ms_srkdb-bukrs
          AND bcode EQ iv_bcode
          AND gjahr EQ iv_gjahr
          AND monat EQ iv_monat
          AND dfile EQ 'INT'.
    IF lines( lt_part ) EQ 1.
      lv_partial = 'false'.
    ELSEIF lines( lt_part ) GT 0.
      IF iv_partn EQ '000000' OR iv_partn EQ '0'.
        lv_partial = 'false'.
      ELSE.
        lv_partial = 'true'.
      ENDIF.
    ENDIF.

    lv_guid = /itetr/cl_edf_common=>generate_guid( ).

    CONCATENATE lv_guid
                '.xml'
                INTO lv_filename.

    CREATE OBJECT lo_zip.
    lo_zip->add(
      EXPORTING
        name           = lv_filename
        content        = iv_xml
    ).

    lv_zipped_file = lo_zip->save( ).

    CLEAR lv_base_64.
    CALL 'SSF_ABAP_SERVICE'
      ID 'OPCODE'  FIELD lc_op_enc
      ID 'BINDATA' FIELD lv_zipped_file
      ID 'B64DATA' FIELD lv_base_64.

    CLEAR lv_filename.

    CONCATENATE lv_guid
                '.zip'
                INTO lv_filename.

*    CONCATENATE
*   '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:edef="EdefterService">'
*      '<soapenv:Header/>'
*      '<soapenv:Body>'
*         '<edef:YevmiyeKayetXml>'
*            '<!--Optional:-->'
*            '<edef:req>'
*               '<!--Optional:-->'
*               '<edef:fileName>' lv_filename '</edef:fileName>'
*               '<!--Optional:-->'
*               '<edef:binaryData>' lv_base_64 '</edef:binaryData>'
*               '<!--Optional:-->'
*               '<edef:userName>' ms_srkdb-sausr '</edef:userName>'
*               '<!--Optional:-->'
*               '<edef:password>' ms_srkdb-sapas '</edef:password>'
*               '<edef:parcaliMi>' lv_partial '</edef:parcaliMi>'
*            '</edef:req>'
*         '</edef:YevmiyeKayetXml>'
*      '</soapenv:Body>'
*   '</soapenv:Envelope>'
*   INTO lv_request.


    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:edef="EdefterService">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<edef:YevmiyeKaydetXml>'
             '<!--Optional:-->'
             '<edef:req>'
                '<!--Optional:-->'
                '<edef:fileName>' lv_filename '</edef:fileName>'
                '<!--Optional:-->'
                '<edef:binaryData>' lv_base_64 '</edef:binaryData>'
                '<!--Optional:-->'
                '<edef:userName>' ms_srkdb-sausr '</edef:userName>'
                '<!--Optional:-->'
                '<edef:password>' ms_srkdb-sapas '</edef:password>'
             '</edef:req>'
             '<edef:ParcaliMi>' lv_partial '</edef:ParcaliMi>'
          '</edef:YevmiyeKaydetXml>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request.

    CALL FUNCTION 'ECATT_CONV_STRING_TO_XSTRING'
      EXPORTING
        im_string  = lv_request
      IMPORTING
        ex_xstring = rv_request.

  ENDMETHOD.


  METHOD generate_xml.

    DATA: ls_format TYPE /itetr/edf_frmat.

    DATA lo_root TYPE REF TO cx_root.

    IF ms_root_vbt IS NOT INITIAL.

      SELECT SINGLE * FROM /itetr/edf_frmat INTO ls_format WHERE intid = 'VBT'.

      IF ls_format-is_csv EQ abap_true."gkadioglu
        TYPE-POOLS: truxs.

        DATA lo_converter TYPE REF TO cl_rsda_csv_converter.
        DATA lt_csv TYPE truxs_t_text_data.
        DATA lv_csv TYPE LINE OF truxs_t_text_data.
        DATA ls_header TYPE /itetr/if_edf_xml_types=>ty_vbt_header.
        DATA ls_item TYPE /itetr/if_edf_xml_types=>ty_vbt_detail.
        DATA: ls_item_csv TYPE /itetr/edf_s_vbt_csv_item.
        DATA lv_string_csv TYPE string.
        DATA lv_xstring_csv TYPE xstring.

        lo_converter = cl_rsda_csv_converter=>create( i_separator = ';' ) .


        LOOP AT me->ms_root_vbt-entry_header INTO ls_header.
          CLEAR:ls_item_csv.
          MOVE-CORRESPONDING  ls_header TO  ls_item_csv.

          LOOP AT ls_header-entry_detail INTO ls_item.

            MOVE-CORRESPONDING  ls_item TO  ls_item_csv.

            CLEAR lv_csv.
            lo_converter->structure_to_csv(
              EXPORTING
                i_s_data = ls_item_csv
              IMPORTING
                e_data   = lv_csv ).

            APPEND lv_csv TO lt_csv.
          ENDLOOP.
        ENDLOOP.

        CLEAR lv_string_csv.

        LOOP AT lt_csv INTO lv_csv.
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



      ELSE."mevcut surec
        TRY.
            CALL TRANSFORMATION /itetr/edf_vbt
              SOURCE root = ms_root_vbt
              RESULT XML ev_filex
              OPTIONS xml_header = 'full'.

            ev_ftype = 'XML'.
          CATCH cx_root INTO lo_root.
        ENDTRY.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  method SET_HEADER.






  endmethod.


  METHOD set_item.

    FIELD-SYMBOLS <fs_header> TYPE /itetr/if_edf_xml_types=>ty_vbt_header.
    FIELD-SYMBOLS <fs_item>   TYPE /itetr/if_edf_xml_types=>ty_vbt_detail.

    READ TABLE ms_root_vbt-entry_header ASSIGNING <fs_header> WITH KEY entrynumber = is_item-item-belnr.
    IF <fs_header> IS NOT ASSIGNED.
      APPEND INITIAL LINE TO ms_root_vbt-entry_header ASSIGNING <fs_header>.
    ENDIF.

    <fs_header>-enteredby        = is_item-head-enteredby.
    <fs_header>-entereddate      = is_item-head-entereddate.
    <fs_header>-entrynumber      = is_item-item-belnr.
    <fs_header>-entrynumbercount = is_item-item-yevno.
    <fs_header>-entrycomment     = is_item-head-entrycomment.

    SHIFT <fs_header>-entrynumbercount LEFT DELETING LEADING space.
    SHIFT <fs_header>-entrynumbercount LEFT DELETING LEADING '0'.
    CONDENSE <fs_header>-entrynumbercount NO-GAPS.

    ADD is_item-debitamount TO <fs_header>-totaldebit.
    ADD is_item-creditamount TO <fs_header>-totalcredit.

    APPEND INITIAL LINE TO <fs_header>-entry_detail ASSIGNING <fs_item>.

    <fs_item>-linenumber                = is_item-item-linen.
    SHIFT <fs_item>-linenumber LEFT DELETING LEADING space.
    SHIFT <fs_item>-linenumber LEFT DELETING LEADING '0'.
    CONDENSE <fs_item>-linenumber NO-GAPS.
*    <fs_item>-linenumbercounter         = is_item-item-dfbuz.
    <fs_item>-linenumbercounter         = <fs_header>-entrynumbercount.
    <fs_item>-accountmainid             = is_item-accountmainid.
    <fs_item>-accountmaindescription    = is_item-accountmaindescription.
    <fs_item>-accountsubdescription     = is_item-accountsubdescription.
    <fs_item>-accountsubid              = is_item-accountsubid.
    <fs_item>-amount                    = is_item-item-dmbtr_def.
    <fs_item>-debitcreditcode           = is_item-debitcreditcode.
    <fs_item>-postingdate               = is_item-postingdate.
    <fs_item>-documenttype              = is_item-documenttype.
    <fs_item>-documenttypedescription   = is_item-documenttypedesc.
    <fs_item>-documentnumber            = is_item-documentnumber.
    <fs_item>-documentreference         = is_item-documentreference.
    <fs_item>-documentdate              = is_item-documentdate.
    <fs_item>-paymentmethod             = is_item-paymentmethod.
    <fs_item>-detailcomment             = is_item-detailcomment.

  ENDMETHOD.


  method SET_REQUEST_HEADER.

    DATA lv_length TYPE i.
    DATA lv_length_s TYPE string.

    lv_length = xstrlen( iv_request ).
    lv_length_s = lv_length.
    CONDENSE lv_length_s NO-GAPS.

    mo_client->request->set_header_field( name = 'Accept-Encoding'   value =  'gzip,deflate' ).
    mo_client->request->set_header_field( name = 'Content-Type'      value =  'text/xml;charset=UTF-8' ).
    mo_client->request->set_header_field( name = 'SOAPAction'        value =  '"EdefterService/YevmiyeKaydetXml"' ).
*    mo_client->request->set_header_field( name = 'Proxy-Connection'  value =  'Keep-Alive' ).
    mo_client->request->set_header_field( name = 'Connection'  value =  'Keep-Alive' ).
    mo_client->request->set_header_field( name = 'Content-Length'    value =  lv_length_s ).

  endmethod.


  method SET_REQUEST_HEADER_API.
  endmethod.
ENDCLASS.