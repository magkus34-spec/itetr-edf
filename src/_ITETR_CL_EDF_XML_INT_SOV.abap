class /ITETR/CL_EDF_XML_INT_SOV definition
  public
  inheriting from /ITETR/CL_EDF_XML_INT
  final
  create public .

public section.

  data MS_SOVOS_TXT type /ITETR/IF_EDF_XML_TYPES=>TY_SOVOS_TXT .

  methods CONSTRUCTOR
    importing
      !IS_HEADER type /ITETR/EDF_S_XML_HEADER
      !IV_PURPOSE type CHAR1 default 'C'
      !IV_PARTN type /ITETR/EDF_PART_NO optional .
  methods SET_GENERAL
    importing
      !IS_GENERAL type /ITETR/EDF_S_XML_HEADER .
  methods CREATE_REQUEST_SAVE
    importing
      !IV_XML type XSTRING
      !IV_BCODE type /ITETR/EDF_BCODE
      !IV_GJAHR type GJAHR
      !IV_MONAT type MONAT
      !IV_PARTN type /ITETR/EDF_PART_NO
    returning
      value(RV_REQUEST) type XSTRING .

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



CLASS /ITETR/CL_EDF_XML_INT_SOV IMPLEMENTATION.


  METHOD constructor.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Tuesday, May 07, 2024 ----------------------------------------------*
*&---------------------------------------------------------------------*


    DATA ls_srkdb TYPE /itetr/edf_srkdb.

    CALL METHOD super->constructor(
      EXPORTING
        is_header  = is_header
        iv_purpose = iv_purpose
        iv_partn   = iv_partn
        iv_auth    = 'X' ).

    IF iv_purpose EQ 'C'.
      CLEAR ls_srkdb.
      SELECT SINGLE *
               INTO ls_srkdb
               FROM /itetr/edf_srkdb
              WHERE bukrs EQ is_header-bukrs.

    ENDIF.

    me->ms_sovos_txt-general-recordtype            = 'L'.
    me->ms_sovos_txt-general-identifier            = is_header-stcd1.
    me->ms_sovos_txt-general-batchid               = ''.                            " Zorunlu Değil
    me->ms_sovos_txt-general-periodcoveredstart    = is_header-periodcoveredstart.
    me->ms_sovos_txt-general-periodcoveredend      = is_header-periodcoveredend.
*    me->ms_sovos_txt-general-entryHeaderCount      = is_header-.                   " Item methodunda yazıldı
*    me->ms_sovos_txt-general- defaultCurrency     = is_header-.                    " Zorunlu Değil


  ENDMETHOD.


  METHOD convert_response.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Tuesday, May 07, 2024 ----------------------------------------------*
*&---------------------------------------------------------------------*

*

    DATA lv_xml_input TYPE xstring.
    DATA ls_xml_table TYPE smum_xmltb.
    DATA lt_xml_table TYPE TABLE OF smum_xmltb.
    DATA lt_return    TYPE TABLE OF bapiret2.
    DATA: lv_code      TYPE string,
          lv_ledger_id TYPE string. "gkadioglu

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
      CLEAR: ls_xml_table , lv_ledger_id.
      READ TABLE lt_xml_table INTO ls_xml_table WITH KEY cname = 'ledgerId'. "LEDGERID

      "IF ls_xml_table-cvalue EQ '{0}'.  "CSV dosyası başarıyla yüklendi
      lv_ledger_id = ls_xml_table-cvalue.
      IF lv_ledger_id IS NOT INITIAL AND "gkadioglu eklendi 03062024
         lv_ledger_id CO '0123456789'.
        rs_msg_response-msgty = 'S'.
      ELSE.
        rs_msg_response-msgty = 'E'.
      ENDIF.
    ELSE.
      rs_msg_response-msgty = 'E'.
    ENDIF.

    CLEAR ls_xml_table.
    READ TABLE lt_xml_table INTO ls_xml_table WITH KEY cname = 'ServiceFault'. "Hata
    rs_msg_response-msgtx = ls_xml_table-cvalue.

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
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Tuesday, May 07, 2024 ----------------------------------------------*
*&---------------------------------------------------------------------*


    DATA lv_request       TYPE string.
    DATA lv_filename      TYPE string.
    DATA lv_base_64       TYPE string.
    DATA lv_hash_string   TYPE string.
    DATA lv_last_part     TYPE /itetr/edf_dihhd-partn.
    DATA lo_zip           TYPE REF TO cl_abap_zip.
    DATA lv_length        TYPE i.
    DATA lv_zipped_file   TYPE xstring.
    CONSTANTS lc_op_enc   TYPE x VALUE 36.
    DATA lv_guid          TYPE guid_32.
    DATA lv_bcode         TYPE n LENGTH 4.
    DATA lv_hash          TYPE hash160.
    DATA lv_part_no       TYPE /itetr/edf_part_no.

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
                "'.txt'
                '.zip' "gkadioglu
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


    CALL FUNCTION 'CALCULATE_HASH_FOR_RAW'
      EXPORTING
        alg            = 'MD5'
        data           = lv_zipped_file
      IMPORTING
        hash           = lv_hash
      EXCEPTIONS
        unknown_alg    = 1
        param_error    = 2
        internal_error = 3
        OTHERS         = 4.


    CONCATENATE

  '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:led="http://ws.cloud.eledger.fit.com/ledger">'
     '<soap:Header/>'
     '<soap:Body>'
        '<led:SaveRequest>'
           '<company>'
              '<identifier>' ms_srkdb-stcd1 '</identifier>'
              '<branchId>' lv_bcode '</branchId>'
           '</company>'
           '<source>'
              '<fileName>' lv_filename '</fileName>'
              '<binaryData>' lv_base_64 '</binaryData>'
              '<hash>' lv_hash '</hash>'
           '</source>'
        '</led:SaveRequest>'
     '</soap:Body>'
  '</soap:Envelope>'

    INTO lv_request.

    CALL FUNCTION 'ECATT_CONV_STRING_TO_XSTRING'
      EXPORTING
        im_string  = lv_request
      IMPORTING
        ex_xstring = rv_request.



  ENDMETHOD.


  METHOD create_request_save.


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
                '.txt'
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

    REPLACE FIRST OCCURRENCE OF '.txt' IN lv_filename WITH '.zip'.



*
*<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:led="http://ws.cloud.eledger.fit.com/ledger">
*   <soap:Header/>
*   <soap:Body>
*      <led:SaveRequest>
*         <company>
*            <identifier>?</identifier>
*            <branchId>?</branchId>
*         </company>
*         <source>
*            <fileName>?</fileName>
*            <binaryData>cid:834092265064</binaryData>
*            <hash>?</hash>
*         </source>
*      </led:SaveRequest>
*   </soap:Body>
*</soap:Envelope>
*
*    INTO lv_request.

    CALL FUNCTION 'ECATT_CONV_STRING_TO_XSTRING'
      EXPORTING
        im_string  = lv_request
      IMPORTING
        ex_xstring = rv_request.

  ENDMETHOD.


  METHOD generate_xml.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Tuesday, May 07, 2024 ----------------------------------------------*
*&---------------------------------------------------------------------*


    TYPE-POOLS: truxs.

    DATA lo_converter TYPE REF TO cl_rsda_csv_converter.
    DATA lt_file TYPE truxs_t_text_data.
    DATA lv_file TYPE LINE OF truxs_t_text_data.
    DATA lv_string_txt TYPE string.
    DATA lv_xstring_txt TYPE xstring.
    DATA lv_index TYPE sy-index.
    FIELD-SYMBOLS <lv_value> TYPE any.
    DATA ls_txt TYPE /itetr/edf_s_sov_txt.

    TYPES : BEGIN OF ty_item,
              recordtype              TYPE text100,
              accountmainid           TYPE text100,
              accountmaindescription  TYPE text100,
              accountsubid            TYPE text100,
              accountsubdescription   TYPE text100,
              amount                  TYPE text100,
              debitcreditcode         TYPE text100,
              documenttype            TYPE text100,
              documenttypedescription TYPE text100,
              documentnumber          TYPE text100,
              documentdate            TYPE text100,
              documentreference       TYPE text100,
              paymentmethod           TYPE text100,
              detailcomment           TYPE text100,
            END OF ty_item.

    DATA : ls_item        TYPE ty_item,
           lv_count       TYPE /itetr/edf_yvmy_no,
           ls_header_text TYPE /itetr/edf_s_sov_txt_header,
           ls_item_text   TYPE /itetr/edf_s_sov_txt_item.

    "general ENTRYHEADERCOUNT sorun vardı gkadioglu begin 31052024
    lv_count = lines( me->ms_sovos_txt-header ).
    IF lv_count IS NOT INITIAL.
      me->ms_sovos_txt-general-entryheadercount = lv_count.
    ENDIF.
    "general ENTRYHEADERCOUNT sorun vardı gkadioglu end 31052024

    lo_converter = cl_rsda_csv_converter=>create( i_separator = cl_abap_char_utilities=>horizontal_tab ) .

    DO. " General Info
      lv_index = sy-index + 1.
      ASSIGN COMPONENT lv_index OF STRUCTURE me->ms_sovos_txt-general TO <lv_value>.
      IF sy-subrc EQ 0.
        CONCATENATE '|' <lv_value> INTO <lv_value>.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

    CLEAR lv_file.
    CLEAR lv_index.

    lo_converter->structure_to_csv(
      EXPORTING
        i_s_data = me->ms_sovos_txt-general
      IMPORTING
        e_data   = lv_file
    ).

    APPEND lv_file TO lt_file. "General eklendi.

    LOOP AT me->ms_sovos_txt-header INTO ls_header_text.
      DATA(lv_entrynumber) = ls_header_text-entrynumber.

      DO. " Header Info
        lv_index = sy-index + 1.
        ASSIGN COMPONENT lv_index OF STRUCTURE ls_header_text TO <lv_value>.
        IF sy-subrc EQ 0.
          CONCATENATE '|' <lv_value> INTO <lv_value>.
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.

      CLEAR lv_index.
      CLEAR lv_file.
      lo_converter->structure_to_csv(
        EXPORTING
          i_s_data = ls_header_text
        IMPORTING
          e_data   = lv_file
      ).

      APPEND lv_file TO lt_file. "Header eklendi


      LOOP AT me->ms_sovos_txt-item INTO ls_item_text WHERE documentreference EQ lv_entrynumber.

        MOVE-CORRESPONDING ls_item_text TO ls_item.

        DO. " Item Info
          lv_index = sy-index + 1.
          ASSIGN COMPONENT lv_index OF STRUCTURE ls_item TO <lv_value>.
          IF sy-subrc EQ 0.
            CONCATENATE '|' <lv_value> INTO <lv_value>.
          ELSE.
            EXIT.
          ENDIF.
        ENDDO.

        CLEAR lv_index.
        CLEAR lv_file.
        lo_converter->structure_to_csv(
          EXPORTING
            i_s_data = ls_item
          IMPORTING
            e_data   = lv_file
        ).

        APPEND lv_file TO lt_file. "Item eklendi


      ENDLOOP.
    ENDLOOP.

    CLEAR lv_string_txt.

    LOOP AT lt_file INTO lv_file.

      IF lv_string_txt IS INITIAL.
        lv_string_txt = lv_file.
      ELSE.
        CONCATENATE lv_string_txt cl_abap_char_utilities=>newline lv_file INTO lv_string_txt.
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

    ev_ftype = 'txt'.
    ev_filex = lv_xstring_txt.



  ENDMETHOD.


  METHOD set_general.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Tuesday, May 07, 2024 ----------------------------------------------*
*&---------------------------------------------------------------------*


*    me->ms_sovos_txt-general-RecordType            = 'L'.
*    me->ms_sovos_txt-general-Identifier            = is_general-stcd1.
*    me->ms_sovos_txt-general-batchID               = is_general-srkdb-bukrs.
*    me->ms_sovos_txt-general-periodCoveredStart    = is_general-periodCoveredStart.
*    me->ms_sovos_txt-general-periodCoveredEnd      = is_general-periodCoveredEnd.
**    me->ms_sovos_txt-general-entryHeaderCount      = is_general-entryHeaderCount.

  ENDMETHOD.


  METHOD set_header.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Tuesday, May 07, 2024 ----------------------------------------------*
*&---------------------------------------------------------------------*


    FIELD-SYMBOLS <ls_header> TYPE /itetr/edf_s_sov_txt_header.
    APPEND INITIAL LINE TO me->ms_sovos_txt-header ASSIGNING <ls_header>.

    <ls_header>-recordtype         = 'H'.
    <ls_header>-enteredby          = is_head-enteredby.
    <ls_header>-entereddate        = is_head-entereddate.
    <ls_header>-entrynumber        = is_head-header-belnr.
    <ls_header>-entrynumbercounter = is_head-yevno.
    <ls_header>-entrycomment       = is_head-entrycomment.
*    <ls_header>-entryDetailCount   = "Item methodunda son yev no verildi.


  ENDMETHOD.


  METHOD set_item.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Tuesday, May 07, 2024 ----------------------------------------------*
*&---------------------------------------------------------------------*


    FIELD-SYMBOLS <ls_item>   TYPE /itetr/edf_s_sov_txt_item.
    FIELD-SYMBOLS <fs_header> TYPE /itetr/edf_s_sov_txt_header.
    APPEND INITIAL LINE TO me->ms_sovos_txt-item ASSIGNING <ls_item>.

    <ls_item>-recordtype                   = 'D'.
    <ls_item>-entrynumber                  = is_item-head-header-hkont.
    <ls_item>-accountmainid                = is_item-accountmainid.
    <ls_item>-accountmaindescription       = is_item-accountmaindescription.
    <ls_item>-accountsubid                 = is_item-accountsubid.
    <ls_item>-accountsubdescription        = is_item-accountsubdescription.
    IF is_item-debitcreditcode = 'C'.
      <ls_item>-amount                     = is_item-creditamount.
    ELSEIF is_item-debitcreditcode = 'D'.
      <ls_item>-amount                     = is_item-debitamount.
    ENDIF.
    CONDENSE <ls_item>-amount NO-GAPS.
    <ls_item>-debitcreditcode              = is_item-debitcreditcode.
    <ls_item>-documenttype                 = is_item-documenttype.
    <ls_item>-documenttypedescription      = is_item-documenttypedesc.
    <ls_item>-documentnumber               = is_item-documentnumber.
    <ls_item>-documentdate                 = is_item-documentdate.
    <ls_item>-documentreference            = is_item-documentreference.
    <ls_item>-paymentmethod                = is_item-paymentmethod.

    " READ TABLE  me->ms_sovos_txt-header ASSIGNING FIELD-SYMBOL(<fs_header>) WITH KEY entrynumber = is_item-documentreference .
    READ TABLE  me->ms_sovos_txt-header ASSIGNING <fs_header> WITH KEY entrynumber = is_item-documentreference .
    IF sy-subrc EQ 0.
      <fs_header>-entrydetailcount   = is_item-item-dfbuz.
    ENDIF.

    me->ms_sovos_txt-general-entryheadercount = is_item-item-yevno.


  ENDMETHOD.


  METHOD set_request_header.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Tuesday, May 07, 2024 ----------------------------------------------*
*&---------------------------------------------------------------------*


    DATA lv_length TYPE i.
    DATA lv_length_s TYPE string.

    lv_length = xstrlen( iv_request ).
    lv_length_s = lv_length.
    CONDENSE lv_length_s NO-GAPS.

    mo_client->request->set_header_field( name = 'Accept-Encoding'   value =  'gzip,deflate' ).
    mo_client->request->set_header_field( name = 'Content-Type'      value =  'application/soap+xml;charset=UTF-8' )."gkadioglu
   " mo_client->request->set_header_field( name = 'Content-Type'      value =  'text/xml;charset=UTF-8' ).
    mo_client->request->set_header_field( name = 'Connection'        value =  'Keep-Alive' ).
    mo_client->request->set_header_field( name = 'Content-Length'    value =  lv_length_s ).


  ENDMETHOD.


  method SET_REQUEST_HEADER_API.
  endmethod.
ENDCLASS.