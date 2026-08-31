class /ITETR/CL_EDF_XML_INT_ELG definition
  public
  inheriting from /ITETR/CL_EDF_XML_INT
  final
  create public .

public section.

  data MS_ELG_CSV type /ITETR/IF_EDF_XML_TYPES=>TY_ELG_CSV .

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



CLASS /ITETR/CL_EDF_XML_INT_ELG IMPLEMENTATION.


  METHOD CONVERT_RESPONSE.

***    DATA lv_xml_input TYPE xstring.
***    DATA ls_xml_table TYPE smum_xmltb.
***    DATA lt_xml_table TYPE TABLE OF smum_xmltb.
***    DATA lt_return    TYPE TABLE OF bapiret2.
***    DATA lv_code      TYPE string.
***
***    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
***      EXPORTING
***        text   = iv_response
***      IMPORTING
***        buffer = lv_xml_input
***      EXCEPTIONS
***        failed = 1
***        OTHERS = 2.
***    IF sy-subrc <> 0.
**** Implement suitable error handling here
***    ENDIF.
***
***    CALL FUNCTION 'SMUM_XML_PARSE'
***      EXPORTING
***        xml_input = lv_xml_input
***      TABLES
***        xml_table = lt_xml_table
***        return    = lt_return.
***
***    IF iv_code EQ '200'.
***      CLEAR ls_xml_table.
***      READ TABLE lt_xml_table INTO ls_xml_table WITH KEY cname = 'sonucKodu'.
***
***      IF ls_xml_table-cvalue EQ '907'.  "CSV dosyası başarıyla yüklendi
***        rs_msg_response-msgty = 'S'.
***      ELSE.
***        rs_msg_response-msgty = 'E'.
***      ENDIF.
***    ELSE.
***      rs_msg_response-msgty = 'E'.
***    ENDIF.
***
***    CLEAR ls_xml_table.
***    READ TABLE lt_xml_table INTO ls_xml_table WITH KEY cname = 'sonucAciklama'.
***    rs_msg_response-msgtx = ls_xml_table-cvalue.
***
***    lv_code = iv_code.
***
***    CONCATENATE rs_msg_response-msgtx
***                'HTTP Status Code:'
***                lv_code
***                '-'
***                iv_response
***                INTO rs_msg_response-msgtx
***                SEPARATED BY space.

  ENDMETHOD.


  method CREATE_BODY_API.
  endmethod.


 METHOD CREATE_REQUEST.

***   DATA lv_bcode       TYPE n LENGTH 4.
***   DATA lv_part_no     TYPE /itetr/edf_part_no.
***   DATA lv_request     TYPE string.
***   DATA lv_filename    TYPE string.
***   DATA lv_base_64     TYPE string.
***   DATA lo_zip         TYPE REF TO cl_abap_zip.
***   DATA lv_zipped_file TYPE xstring.
***   CONSTANTS lc_op_enc TYPE x VALUE 36.
***
***   lv_bcode = iv_bcode.
***
***   lv_part_no = iv_partn.
***   SHIFT lv_part_no LEFT DELETING LEADING '0'.
***
***   IF lv_part_no IS INITIAL.
***     lv_part_no = '1'.
***   ENDIF.
***
***   CONCATENATE ms_srkdb-stcd1
***               '_'
***               lv_bcode
***               '_'
***               iv_gjahr
***               iv_monat
***               '_'
***               lv_part_no
***               '.csv'
***               INTO lv_filename.
***
***   CREATE OBJECT lo_zip.
***   lo_zip->add(
***     EXPORTING
***       name           = lv_filename
***       content        = iv_xml
***   ).
***
***   lv_zipped_file = lo_zip->save( ).
***
***   CLEAR lv_base_64.
***   CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
***     EXPORTING
***       input  = lv_zipped_file
***     IMPORTING
***       output = lv_base_64.
***
***   REPLACE FIRST OCCURRENCE OF '.csv' IN lv_filename WITH '.zip'.
***
***   CONCATENATE
***   '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.edefter.uut.cs.com.tr/">'
***     '<soapenv:Header>'
***       '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
***         '<wsse:UsernameToken>'
***           '<wsse:Username>' ms_srkdb-sausr '</wsse:Username>'
***           '<wsse:Password>' ms_srkdb-sapas '</wsse:Password>'
***         '</wsse:UsernameToken>'
***       '</wsse:Security>'
***     '</soapenv:Header>'
***      '<soapenv:Body>'
***         '<web:eDefterCsvFileYukle>'
***            '<arg0>'
***               '<donem>' iv_gjahr iv_monat '</donem>'
***               '<parametreList>'
***                  '<entry>'
***                     '<key>dosya</key>'
***                     '<value>' lv_base_64 '</value>'
***                  '</entry>'
***                  '<entry>'
***                     '<key>dosyaIsmi</key>'
***                     '<value>' lv_filename '</value>'
***                  '</entry>'
***               '</parametreList>'
***               '<subeKodu>' lv_bcode '</subeKodu>'
***               '<vknTckn>' ms_srkdb-stcd1 '</vknTckn>'
***            '</arg0>'
***         '</web:eDefterCsvFileYukle>'
***      '</soapenv:Body>'
***   '</soapenv:Envelope>'
***   INTO lv_request.
***
***   CALL FUNCTION 'ECATT_CONV_STRING_TO_XSTRING'
***     EXPORTING
***       im_string  = lv_request
***     IMPORTING
***       ex_xstring = rv_request.
 ENDMETHOD.


  METHOD generate_xml.
    TYPES: BEGIN OF ty_header,
             field01 TYPE text50,
             field02 TYPE text50,
             field03 TYPE text50,
             field04 TYPE text50,
             field05 TYPE text50,
             field06 TYPE text50,
             field07 TYPE text50,
             field08 TYPE text50,
             field09 TYPE text50,
             field10 TYPE text50,
             field11 TYPE text50,
             field12 TYPE text50,
             field13 TYPE text50,
             field14 TYPE text50,
             field15 TYPE text50,
             field16 TYPE text50,
             field17 TYPE text50,
             field18 TYPE text50,
             field19 TYPE text50,
             field20 TYPE text50,
             field21 TYPE text50,
             field22 TYPE text50,
             field23 TYPE text50,
             field24 TYPE text50,
***            field25 TYPE text50,
***            field26 TYPE text50,
           END OF ty_header.

    TYPE-POOLS: truxs.

    DATA lo_converter TYPE REF TO cl_rsda_csv_converter.
    DATA lt_csv TYPE truxs_t_text_data.
    DATA lv_csv TYPE LINE OF truxs_t_text_data.
    DATA ls_item TYPE /itetr/edf_s_elg_csv.
    DATA lv_string_csv    TYPE string.
    DATA lv_xstring_csv   TYPE xstring.
    DATA lv_xstring_csv_1 TYPE xstring.
    DATA ls_header TYPE ty_header.


    lo_converter = cl_rsda_csv_converter=>create( i_separator = ';' ) .

    ls_header-field01 = 'FirmID'.
    ls_header-field02 = 'FirmCode'.
    ls_header-field03 = 'SlipType'.
    ls_header-field04 = 'SlipNr'.
    ls_header-field05 = 'SlipComment'.
    ls_header-field06 = 'SlipDate'.
    ls_header-field07 = 'SlipJournalNr'.
    ls_header-field08 = 'SlipDebit'.
    ls_header-field09 = 'SlipCredit'.
    ls_header-field10 = 'SlipEnteredBy'.
    ls_header-field11 = 'TransSign'.
    ls_header-field12 = 'TransRootAccCode'.
    ls_header-field13 = 'TransRootAccDesc'.
    ls_header-field14 = 'TransAccCode'.
    ls_header-field15 = 'TransAccDesc'.
    ls_header-field16 = 'TransAmount'.
    ls_header-field17 = 'TransGlobalLineNumber'.
    ls_header-field18 = 'TransComment'.
    ls_header-field19 = 'DetailDocType'.
    ls_header-field20 = 'DetailDescription'.
    ls_header-field21 = 'DetailDocNr'.
    ls_header-field22 = 'DetailDocDate'.
    ls_header-field23 = 'DetailPaymentType'.
    ls_header-field24 = 'DetailUnDocumented'.

***    IF me->mv_partn LT '000002'.
    CLEAR lv_csv.
    lo_converter->structure_to_csv(
      EXPORTING
        i_s_data = ls_header
      IMPORTING
        e_data   = lv_csv
    ).
*    APPEND lv_csv TO lt_csv.
    lv_string_csv = lv_csv.
***    ENDIF.
    DATA : lv_transgloballinenumber TYPE   /itetr/edf_defky-linen.

    CLEAR lv_transgloballinenumber.

    SORT me->ms_elg_csv BY  transgloballinenumber ASCENDING.

    READ TABLE me->ms_elg_csv INTO ls_item INDEX 1.
    lv_transgloballinenumber = ls_item-transgloballinenumber.

    SORT me->ms_elg_csv BY slipdate ASCENDING slipjournalnr ASCENDING transsign DESCENDING.


    LOOP AT me->ms_elg_csv INTO ls_item.
*      TRANSLATE ls_item-amount USING '.!'.
*      TRANSLATE ls_item-total_debit USING '.!'.
*      TRANSLATE ls_item-total_credit USING '.!'.

      ls_item-transgloballinenumber = lv_transgloballinenumber.
      CLEAR lv_csv.
      lo_converter->structure_to_csv(
        EXPORTING
          i_s_data = ls_item
        IMPORTING
          e_data   = lv_csv
      ).

      ADD 1 TO lv_transgloballinenumber.

*      APPEND lv_csv TO lt_csv.

      REPLACE ALL OCCURRENCES OF ','    IN lv_csv WITH '.'.
      REPLACE ALL OCCURRENCES OF '!'    IN lv_csv WITH '.'.
      REPLACE ALL OCCURRENCES OF '" "'  IN lv_csv WITH ''.

      CONCATENATE lv_string_csv cl_abap_char_utilities=>newline lv_csv INTO lv_string_csv.

    ENDLOOP.

*    CLEAR lv_string_csv.

*    LOOP AT lt_csv INTO lv_csv.
*      REPLACE ALL OCCURRENCES OF ','  IN lv_csv WITH '.'.
*      REPLACE ALL OCCURRENCES OF '!'  IN lv_csv WITH '.'.
*      REPLACE ALL OCCURRENCES OF '" "'  IN lv_csv WITH ''.
*****      REPLACE ALL OCCURRENCES OF ';'  IN lv_csv WITH ','.

*      IF lv_string_csv IS INITIAL.
*        lv_string_csv = lv_csv.

*****        CONSTANTS lc_mimetype TYPE c LENGTH 50 VALUE 'text/plain; charset=utf-8'.
*****
*****        CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
*****          EXPORTING
*****            text     = lv_string_csv
*****            mimetype = lc_mimetype
*****          IMPORTING
*****            buffer   = lv_xstring_csv
*****          EXCEPTIONS
*****            failed   = 1
*****            OTHERS   = 2.
*****        IF sy-subrc <> 0.
****** Implement suitable error handling here
*****        ENDIF.

*      ELSE.
****        lv_string_csv = lv_string_csv && cl_abap_char_utilities=>newline && lv_csv.
****        CONCATENATE lv_string_csv cl_abap_char_utilities=>newline lv_csv ',' INTO lv_string_csv.
*        CONCATENATE lv_string_csv cl_abap_char_utilities=>newline lv_csv INTO lv_string_csv.
****        CONCATENATE  cl_abap_char_utilities=>newline lv_csv INTO lv_string_csv.
***
****        CONSTANTS lc_mimetype TYPE c LENGTH 50 VALUE 'text/plain; charset=utf-8'.
****
****        CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
****          EXPORTING
****            text     = lv_string_csv
****            mimetype = lc_mimetype
****          IMPORTING
****            buffer   = lv_xstring_csv_1
****          EXCEPTIONS
****            failed   = 1
****            OTHERS   = 2.
****        IF sy-subrc <> 0.
***** Implement suitable error handling here
****        ENDIF.
****
****        CONCATENATE lv_xstring_csv lv_xstring_csv_1 INTO lv_xstring_csv.
*      ENDIF.

*    ENDLOOP.

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


  METHOD SET_HEADER.
    "***
  ENDMETHOD.


  METHOD set_item.
    FIELD-SYMBOLS <ls_item> TYPE /itetr/edf_s_elg_csv.
    DATA: lv_stcd1 TYPE /itetr/edf_srkdb-stcd1.
    DATA: lv_ocblg TYPE /itetr/edf_beltr-ocblg.
    "operation
    APPEND INITIAL LINE TO me->ms_elg_csv ASSIGNING <ls_item>.

    IF ms_srkdb-stcd1 IS INITIAL.
      SELECT SINGLE *
          FROM /itetr/edf_srkdb
          INTO ms_srkdb
          WHERE bukrs EQ is_item-head-header-bukrs.
    ENDIF.
    lv_stcd1 = ms_srkdb-stcd1.
**    SELECT SINGLE stcd1
**      FROM /itetr/edf_srkdb
**      INTO lv_stcd1
**      WHERE bukrs EQ is_item-head-header-bukrs.

    "general assignment
    <ls_item>-firmid                = lv_stcd1.
    <ls_item>-firmcode              = space.
**    <ls_item>-sliptype              = COND #( WHEN is_item-item-blart = 'YA' THEN '1'
**                                              WHEN is_item-item-blart = 'YK' THEN '10'
**                                              ELSE '4' ).


"09.06.2026 Magkus..
*--------------------------------------------------------------------*
*    CASE is_item-item-blart.
*      WHEN 'YA'.
*        <ls_item>-sliptype = '1'.
*      WHEN 'YK' .
*        <ls_item>-sliptype = '10'.
*      WHEN OTHERS.
*        <ls_item>-sliptype = '4'.
*    ENDCASE.

    CASE is_item-item-blart.
      WHEN ms_srkdb-ablart ."Yıl Açılış
        <ls_item>-sliptype = '1'.
      WHEN ms_srkdb-kblart.
        <ls_item>-sliptype = '10'.
      WHEN OTHERS.
         CLEAR lv_ocblg.
         SELECT SINGLE ocblg INTO lv_ocblg FROM /itetr/edf_beltr
                WHERE blart = is_item-item-blart.
         IF lv_ocblg EQ 'C'.
           <ls_item>-sliptype = '10'.
         ELSE.
            <ls_item>-sliptype = '4'.
         ENDIF.
    ENDCASE.



    <ls_item>-slipnr                = is_item-documentreference. "is_item-documentnumber.
***    <ls_item>-slipcomment           = is_item-detailcomment.
    <ls_item>-slipdate              = is_item-head-entereddate.
    <ls_item>-slipjournalnr         = is_item-item-yevno.
    <ls_item>-slipenteredby         = is_item-head-enteredby.
    <ls_item>-transrootacccode      = is_item-accountmainid.
    <ls_item>-transrootaccdesc      = is_item-accountmaindescription.
    <ls_item>-transacccode          = is_item-accountsubid.
    <ls_item>-transaccdesc          = is_item-accountsubdescription.
    <ls_item>-transamount           = is_item-item-dmbtr_def.
    <ls_item>-transgloballinenumber = is_item-item-linen.
    <ls_item>-transcomment          = space.
    <ls_item>-detaildescription     = is_item-documenttypedesc.
    <ls_item>-detaildocnr           = is_item-documentreference. "is_item-documentnumber.
    <ls_item>-detaildocdate         = is_item-documentdate.
    <ls_item>-detailpaymenttype     = is_item-paymentmethod.
    <ls_item>-detailundocumented    = '0'.
    "***

    "slipcomment
    DATA:lv_bktxt TYPE /itetr/edf_defky-bktxt.
    DATA:ls_item_dat TYPE /itetr/edf_defky.

    lv_bktxt = is_item-item-bktxt.
*    IF lv_bktxt IS INITIAL.
*      LOOP AT it_items  INTO ls_item_dat WHERE yevno EQ is_item-item-yevno AND
*                                               bktxt NE space.
*        lv_bktxt = ls_item_dat-bktxt.
*        EXIT.
*      ENDLOOP.
*    ENDIF.
    IF lv_bktxt IS INITIAL.
      lv_bktxt = 'E-defter Denkleştirme'.
    ENDIF.
    IF lv_bktxt+0(1) = ' '.
      lv_bktxt = lv_bktxt+1.
    ENDIF.
    <ls_item>-slipcomment = lv_bktxt.
    CONDENSE <ls_item>-slipcomment.
    "***

    "doctype switch
*    <ls_item>-detaildoctype = SWITCH #( is_item-documenttype WHEN 'check' THEN '0'
*                                                             WHEN 'invoice' THEN '1'
*                                                             WHEN 'order-customer' THEN '2'
*                                                             WHEN 'order-vendor' THEN '3'
*                                                             WHEN 'voucher' THEN '4'
*                                                             WHEN 'shipment' THEN '5'
*                                                             WHEN 'receipt' THEN '6'
*                                                             WHEN 'other' THEN '7'
*                                                             ELSE '7' ).
    "***
    CASE is_item-documenttype.
      WHEN 'check'.
        <ls_item>-detaildoctype = '0'.
      WHEN 'invoice'.
        <ls_item>-detaildoctype = '1'.
      WHEN 'order-customer'.
        <ls_item>-detaildoctype = '2'.
      WHEN  'order-vendor'.
        <ls_item>-detaildoctype = '3'.
      WHEN 'voucher'.
        <ls_item>-detaildoctype = '4'.
      WHEN 'shipment'.
        <ls_item>-detaildoctype = '5'.
      WHEN 'receipt'.
        <ls_item>-detaildoctype = '6'.
      WHEN 'other'.
        <ls_item>-detaildoctype = '7'.
      WHEN OTHERS.
        <ls_item>-detaildoctype = '7'.
    ENDCASE.

    "debit/credit indicator
    IF is_item-item-shkzg EQ 'S'.
      <ls_item>-transsign =  'D'.
    ELSEIF is_item-item-shkzg EQ 'H'.
      <ls_item>-transsign =  'C'.
    ENDIF.
    "***

    "calculate debit/credit amount
**    DATA:lv_dmbtr TYPE /itetr/edf_defky-dmbtr_def.
**    DATA:lv_dmbtr_h TYPE /itetr/edf_defky-dmbtr_def.
**    SELECT SUM( dmbtr_def ) AS dmbtr_def
**      FROM /itetr/edf_defky
**      INTO lv_dmbtr
**      WHERE shkzg EQ 'S'
**        AND yevno EQ is_item-item-yevno.

    DATA: ls_sum_amount TYPE /itetr/edf_s_sum_items.
    READ TABLE it_sum_items INTO ls_sum_amount WITH KEY yevno = is_item-item-yevno
                                                        shkzg = 'H' BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      <ls_item>-slipcredit = ls_sum_amount-dmbtr_def.
    ENDIF.

    READ TABLE it_sum_items INTO ls_sum_amount WITH KEY yevno = is_item-item-yevno
                                                    shkzg = 'S' BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      <ls_item>-slipdebit  = ls_sum_amount-dmbtr_def..
    ENDIF.

***    LOOP AT it_sum_items INTO ls_sum_amount WHERE yevno = is_item-item-yevno.
***      CASE ls_sum_amount-shkzg.
***        WHEN 'H'.
***          <ls_item>-slipcredit = ls_sum_amount-dmbtr_def.
***        WHEN 'S'.
***          <ls_item>-slipdebit  = ls_sum_amount-dmbtr_def.
***      ENDCASE.
***    ENDLOOP.

**        DATA:lv_dmbtr_h TYPE /itetr/edf_defky-dmbtr_def.
**    SELECT SUM( dmbtr_def ) AS dmbtr_def
**      FROM /itetr/edf_defky
**      INTO lv_dmbtr_h
**      WHERE shkzg EQ 'H'
**        AND yevno EQ is_item-item-yevno.

**    IF lv_dmbtr IS NOT INITIAL.
**      <ls_item>-slipdebit  = lv_dmbtr.
**    ENDIF.
**    IF lv_dmbtr_h IS NOT INITIAL.
**      <ls_item>-slipcredit = lv_dmbtr_h.
**    ENDIF.
    "***
  ENDMETHOD.


  method SET_REQUEST_HEADER.
    "***
  endmethod.


  method SET_REQUEST_HEADER_API.
  endmethod.
ENDCLASS.