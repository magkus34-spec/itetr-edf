class /ITETR/CL_EDF_XML_INT_HTK definition
  public
  inheriting from /ITETR/CL_EDF_XML_INT
  final
  create public .

public section.

  data MS_HTK_CSV type /ITETR/IF_EDF_XML_TYPES=>TY_HTK_CSV .

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



CLASS /ITETR/CL_EDF_XML_INT_HTK IMPLEMENTATION.


  METHOD constructor.

    DATA ls_srkdb TYPE /itetr/edf_srkdb.

    CALL METHOD super->constructor(
      EXPORTING
        is_header  = is_header
        iv_purpose = iv_purpose
        iv_partn   = iv_partn ).

    IF iv_purpose EQ 'C'.
      CLEAR ls_srkdb.
      SELECT SINGLE *
               INTO ls_srkdb
               FROM /itetr/edf_srkdb
              WHERE bukrs EQ is_header-bukrs.

      me->ms_htk_csv-header-period_covered_start = is_header-periodcoveredstart.
      me->ms_htk_csv-header-period_covered_end   = is_header-periodcoveredend.
      me->ms_htk_csv-header-fiscal_year_start    = is_header-fiscalyearstart.
      me->ms_htk_csv-header-fiscal_year_end      = is_header-fiscalyearend.
      me->ms_htk_csv-header-taxid                = ls_srkdb-stcd1.
    ENDIF.

  ENDMETHOD.


  METHOD convert_response.

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
      READ TABLE lt_xml_table INTO ls_xml_table WITH KEY cname = 'sonucKodu'.

      IF ls_xml_table-cvalue EQ '907'.  "CSV dosyası başarıyla yüklendi
        rs_msg_response-msgty = 'S'.
      ELSE.
        rs_msg_response-msgty = 'E'.
      ENDIF.
    ELSE.
      rs_msg_response-msgty = 'E'.
    ENDIF.

    CLEAR ls_xml_table.
    READ TABLE lt_xml_table INTO ls_xml_table WITH KEY cname = 'sonucAciklama'.
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

   CONCATENATE
   '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.edefter.uut.cs.com.tr/">'
     '<soapenv:Header>'
       '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
         '<wsse:UsernameToken>'
           '<wsse:Username>' ms_srkdb-sausr '</wsse:Username>'
           '<wsse:Password>' ms_srkdb-sapas '</wsse:Password>'
         '</wsse:UsernameToken>'
       '</wsse:Security>'
     '</soapenv:Header>'
      '<soapenv:Body>'
         '<web:eDefterCsvFileYukle>'
            '<arg0>'
               '<donem>' iv_gjahr iv_monat '</donem>'
               '<parametreList>'
                  '<entry>'
                     '<key>dosya</key>'
                     '<value>' lv_base_64 '</value>'
                  '</entry>'
                  '<entry>'
                     '<key>dosyaIsmi</key>'
                     '<value>' lv_filename '</value>'
                  '</entry>'
               '</parametreList>'
               '<subeKodu>' lv_bcode '</subeKodu>'
               '<vknTckn>' ms_srkdb-stcd1 '</vknTckn>'
            '</arg0>'
         '</web:eDefterCsvFileYukle>'
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

    TYPE-POOLS: truxs.

    DATA lo_converter TYPE REF TO cl_rsda_csv_converter.
    DATA lt_csv TYPE truxs_t_text_data.
    DATA lv_csv TYPE LINE OF truxs_t_text_data.
    DATA ls_item TYPE /itetr/edf_s_htk_csv_item.
    DATA lv_string_csv TYPE string.
    DATA lv_xstring_csv TYPE xstring.
    DATA ls_general TYPE /itetr/edf_s_htk_csv_general.


    lo_converter = cl_rsda_csv_converter=>create( i_separator = ';' ) .

    ls_general-identifier                   = 'IDENTIFIER'.
    ls_general-batch_id                     = 'BATCH_ID'.
    ls_general-period_covered_start         = 'PERIOD_COVERED_START'.
    ls_general-period_covered_end           = 'PERIOD_COVERED_END'.
    ls_general-entered_by                   = 'ENTERED_BY'.
    ls_general-entered_date                 = 'ENTERED_DATE'.
    ls_general-entry_comment                = 'ENTRY_COMMENT'.
    ls_general-total_debit                  = 'TOTAL_DEBIT'.
    ls_general-total_credit                 = 'TOTAL_CREDIT'.
    ls_general-entry_number_counter         = 'ENTRY_NUMBER_COUNTER'.
    ls_general-payment_method               = 'PAYMENT_METHOD'.
    ls_general-document_type                = 'DOCUMENT_TYPE'.
    ls_general-document_type_description    = 'DOCUMENT_TYPE_DESCRIPTION'.
    ls_general-document_number              = 'DOCUMENT_NUMBER'.
    ls_general-document_reference           = 'DOCUMENT_REFERENCE'.
    ls_general-document_date                = 'DOCUMENT_DATE'.
    ls_general-line_number                  = 'LINE_NUMBER'.
    ls_general-account_main_id              = 'ACCOUNT_MAIN_ID'.
    ls_general-account_main_description     = 'ACCOUNT_MAIN_DESCRIPTION'.
    ls_general-account_sub_id               = 'ACCOUNT_SUB_ID'.
    ls_general-acount_sub_description       = 'ACOUNT_SUB_DESCRIPTION'.
    ls_general-amount                       = 'AMOUNT'.
    ls_general-debit_credit_code            = 'DEBIT_CREDIT_CODE'.
    ls_general-detail_comment               = 'DETAIL_COMMENT'.

    IF me->mv_partn LT '000002'.
      CLEAR lv_csv.
      lo_converter->structure_to_csv(
        EXPORTING
          i_s_data = ls_general
        IMPORTING
          e_data   = lv_csv
      ).
      APPEND lv_csv TO lt_csv.
    ENDIF.

    LOOP AT me->ms_htk_csv-item INTO ls_item.
*      TRANSLATE ls_item-amount USING '.!'.
*      TRANSLATE ls_item-total_debit USING '.!'.
*      TRANSLATE ls_item-total_credit USING '.!'.

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
      REPLACE ALL OCCURRENCES OF ','  IN lv_csv WITH '.'.
      REPLACE ALL OCCURRENCES OF '!'  IN lv_csv WITH '.'.
      REPLACE ALL OCCURRENCES OF '"'  IN lv_csv WITH ''.
      REPLACE ALL OCCURRENCES OF ';'  IN lv_csv WITH ','.

      IF lv_string_csv IS INITIAL.
        lv_string_csv = lv_csv.
      ELSE.
        CONCATENATE lv_string_csv cl_abap_char_utilities=>newline lv_csv ',' INTO lv_string_csv.
*        lv_string_csv = lv_string_csv && cl_abap_char_utilities=>newline && lv_csv.
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


  METHOD set_header.

  ENDMETHOD.


  METHOD set_item.

    DATA: BEGIN OF ls_oldef,
            datab TYPE /itetr/edf_begin_date,
            datbi TYPE /itetr/edf_end_date,
          END OF ls_oldef.

    DATA: lv_stcd1       TYPE stcd1,
          lv_dmbtr_str   TYPE string,
          lv_dmbtr_h_str TYPE string,
          lv_datab_c     TYPE char10,
          lv_datbi_c     TYPE char10.
    FIELD-SYMBOLS <ls_item> TYPE /itetr/edf_s_htk_csv_item.

    APPEND INITIAL LINE TO me->ms_htk_csv-item ASSIGNING <ls_item>.

    SELECT SINGLE stcd1
      FROM /itetr/edf_srkdb
      INTO lv_stcd1
      WHERE bukrs EQ is_item-head-header-bukrs.

    SELECT SINGLE datab datbi
    FROM /itetr/edf_oldef
    INTO ls_oldef
    WHERE bukrs EQ is_item-item-bukrs
      AND gjahr EQ is_item-item-gjahr
      AND monat EQ is_item-item-monat.

*    SELECT SINGLE datab, datbi
*      FROM /itetr/edf_oldef
*      INTO @DATA(ls_oldef)
*      WHERE bukrs EQ @is_item-item-bukrs
*        AND gjahr EQ @is_item-item-gjahr
*        AND monat EQ @is_item-item-monat.

    CONCATENATE ls_oldef-datab+0(4)
                '-'
                ls_oldef-datab+4(2)
                '-'
                ls_oldef-datab+6(2)
                INTO
                lv_datab_c.

    CONCATENATE ls_oldef-datbi+0(4)
            '-'
            ls_oldef-datbi+4(2)
            '-'
            ls_oldef-datbi+6(2)
            INTO
            lv_datbi_c.

    <ls_item>-identifier                  = lv_stcd1.
    <ls_item>-batch_id                    = 'NULL'.
    <ls_item>-period_covered_start        = lv_datab_c.
    <ls_item>-period_covered_end          = lv_datbi_c.
    <ls_item>-entered_by                  = is_item-head-enteredby.
    <ls_item>-entered_date                = is_item-head-entereddate.
    <ls_item>-entry_comment               = 'NULL'.
    <ls_item>-entry_number_counter        = is_item-item-yevno.
    <ls_item>-payment_method              = is_item-paymentmethod.
    <ls_item>-document_type               = is_item-documenttype.
    <ls_item>-document_type_description   = is_item-documenttypedesc.
    <ls_item>-document_number             = is_item-documentnumber.
    <ls_item>-document_reference          = is_item-documentreference.
    <ls_item>-document_date               = is_item-documentdate.
    <ls_item>-line_number                 = is_item-item-linen.
    <ls_item>-account_main_id             = is_item-accountmainid.
    <ls_item>-account_main_description    = is_item-accountmaindescription.
    <ls_item>-account_sub_id              = is_item-accountsubid.
    <ls_item>-acount_sub_description      = is_item-accountsubdescription.
    <ls_item>-amount                      = is_item-item-dmbtr_def.

    IF is_item-item-shkzg EQ 'S'.
      <ls_item>-debit_credit_code =  'D'.
    ELSEIF is_item-item-shkzg EQ 'H'.
      <ls_item>-debit_credit_code =  'C'.
    ENDIF.
    <ls_item>-detail_comment = 'NULL'.
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
      <ls_item>-total_debit                 = lv_dmbtr.
    ENDIF.
    IF lv_dmbtr_h IS NOT INITIAL.
      <ls_item>-total_credit                = lv_dmbtr_h.
    ENDIF.

  ENDMETHOD.


  method SET_REQUEST_HEADER.
  endmethod.


  method SET_REQUEST_HEADER_API.
  endmethod.
ENDCLASS.