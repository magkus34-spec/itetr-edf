class /ITETR/CL_EDF_XML_INT_KOC definition
  public
  inheriting from /ITETR/CL_EDF_XML_INT
  final
  create public .

public section.

  data MS_ROOT_KOC type /ITETR/IF_EDF_XML_TYPES=>TY_KOC .

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



CLASS /ITETR/CL_EDF_XML_INT_KOC IMPLEMENTATION.


  METHOD constructor.

    FIELD-SYMBOLS <ls_lines> TYPE /itetr/if_edf_xml_types=>ty_line.
    CALL METHOD super->constructor(
      EXPORTING
        is_header  = is_header
        iv_purpose = iv_purpose ).

    IF iv_purpose EQ 'C'.

      APPEND INITIAL LINE TO ms_root_koc-lines ASSIGNING <ls_lines>.

      CHECK <ls_lines> IS ASSIGNED.

      <ls_lines>-information-branchcode-content           = ms_header-branch.
      <ls_lines>-information-branchdescription-content    = ms_header-branchname.
      <ls_lines>-information-filecontentstartdate-content = ms_header-periodcoveredstart.
      <ls_lines>-information-filecontentenddate-content   = ms_header-periodcoveredend.

    ENDIF.

  ENDMETHOD.


  METHOD convert_response.

    CONSTANTS lc_status      TYPE string VALUE 'true'.
    CONSTANTS lc_description TYPE string VALUE 'OK'.
    DATA ls_envelope         TYPE /itetr/if_edf_xml_types=>ty_envelope.
    DATA lv_code             TYPE string.

    CLEAR ls_envelope.
    CALL TRANSFORMATION /itetr/edf_koc_system_res
     SOURCE XML iv_response
     RESULT root = ls_envelope.

    IF ls_envelope-envelope-body-uploadfileresponse-uploadfileresult-status-content EQ lc_status AND
       ls_envelope-envelope-body-uploadfileresponse-uploadfileresult-description-content EQ lc_description.
      rs_msg_response-msgty = 'S'.
      rs_msg_response-msgtx = ls_envelope-envelope-body-uploadfileresponse-uploadfileresult-description-content.
    ELSE.
      rs_msg_response-msgty = 'E'.
      rs_msg_response-msgtx = ls_envelope-envelope-body-uploadfileresponse-uploadfileresult-description-content.
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

    DATA lv_max_part(4) TYPE n.
    DATA lv_part_no(4)  TYPE n.

    SELECT MAX( partn )
           INTO lv_last_part
           FROM /itetr/edf_dihhd
           WHERE bukrs EQ ms_srkdb-bukrs
             AND bcode EQ iv_bcode
             AND gjahr EQ iv_gjahr
             AND monat EQ iv_monat
*             AND partn EQ iv_partn
             AND dfile EQ 'INT'.

    lv_max_part = lv_last_part.
    lv_part_no  = iv_partn.

    "hk
    IF lv_part_no EQ '0000' AND lv_max_part EQ '0000'.
      lv_part_no = '0001'.
      lv_max_part = '0001'.
    ENDIF.
    "hk
    "
** Yıl ortası parçalı gönderim dosya ismi parça numarası eksi 1
**    ADD 1 TO lv_max_part.
**    ADD 1 TO lv_part_no.

    IF iv_bcode EQ space.
      CONCATENATE ms_srkdb-stcd1
                  '-'
                  iv_gjahr
                  '-'
                  iv_monat
                  '-'
                  lv_part_no
                  '-'
                  lv_max_part
                  '.xml'
                  INTO lv_filename.
    ELSE.
      CONCATENATE ms_srkdb-stcd1
                  '-'
                  iv_gjahr
                  '-'
                  iv_monat
                  '-'
                  lv_part_no
                  '-'
                  lv_max_part
                  '-'
                  iv_bcode
                  '.xml'
                  INTO lv_filename.
    ENDIF.

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

    CLEAR lv_length.
    CLEAR lv_hash_string.
    CALL FUNCTION 'CALCULATE_HASH_FOR_RAW'
      EXPORTING
        alg            = 'MD5'
        data           = lv_zipped_file
        length         = lv_length
      IMPORTING
        hashstring     = lv_hash_string
      EXCEPTIONS
        unknown_alg    = 1
        param_error    = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CONCATENATE lv_hash_string+0(2)
                '-'
                lv_hash_string+2(2)
                '-'
                lv_hash_string+4(2)
                '-'
                lv_hash_string+6(2)
                '-'
                lv_hash_string+8(2)
                '-'
                lv_hash_string+10(2)
                '-'
                lv_hash_string+12(2)
                '-'
                lv_hash_string+14(2)
                '-'
                lv_hash_string+16(2)
                '-'
                lv_hash_string+18(2)
                '-'
                lv_hash_string+20(2)
                '-'
                lv_hash_string+22(2)
                '-'
                lv_hash_string+24(2)
                '-'
                lv_hash_string+26(2)
                '-'
                lv_hash_string+28(2)
                '-'
                lv_hash_string+30(2)
                INTO lv_hash_string.


    REPLACE FIRST OCCURRENCE OF '.xml' IN lv_filename WITH '.zip'.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
    '<soapenv:Header/>'
    '<soapenv:Body>'
    '<tem:UploadFile>'
    '<tem:userName>'
    ms_srkdb-sausr
    '</tem:userName>'
    '<tem:password>'
    ms_srkdb-sapas
    '</tem:password>'
    '<tem:fileName>'
    lv_filename
    '</tem:fileName>'
    '<tem:fileMd5HashCode>'
    lv_hash_string
    '</tem:fileMd5HashCode>'
    '<tem:stringFileBytes>'
    lv_base_64
    '</tem:stringFileBytes>'
    '</tem:UploadFile>'
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

    DATA lo_root TYPE REF TO cx_root.

    IF ms_root_koc IS NOT INITIAL.
      TRY.
          CALL TRANSFORMATION /itetr/edf_koc_system
            SOURCE root = ms_root_koc
            RESULT XML ev_filex
            OPTIONS xml_header = 'full'.

          ev_ftype = 'XML'.
        CATCH cx_root INTO lo_root.
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD set_header.

    FIELD-SYMBOLS <ls_lines>         TYPE /itetr/if_edf_xml_types=>ty_line.
    FIELD-SYMBOLS <fs_journallist>   TYPE /itetr/if_edf_xml_types=>ty_journallist.
    FIELD-SYMBOLS <fs_journalitem>   TYPE /itetr/if_edf_xml_types=>ty_journalitem.
    DATA lv_index TYPE i.
    lv_index = lines( ms_root_koc-lines ).
    READ TABLE ms_root_koc-lines ASSIGNING <ls_lines> INDEX lv_index.
    CHECK <ls_lines> IS ASSIGNED.
    READ TABLE <ls_lines>-journallist ASSIGNING <fs_journallist> INDEX 1.
    IF <fs_journallist> IS NOT ASSIGNED.
      APPEND INITIAL LINE TO <ls_lines>-journallist ASSIGNING <fs_journallist>.
    ENDIF.

*    CHECK <fs_journallist> IS ASSIGNED.
*    APPEND INITIAL LINE TO <fs_journallist>-journalitem ASSIGNING <fs_journalitem>.
*    CHECK <fs_journalitem> IS ASSIGNED.

*    <fs_journalitem>-enteredby     = is_head-enteredby.
*    <fs_journalitem>-entereddate   = is_head-entereddate.
*    <fs_journalitem>-entrynumber   = is_head-yevno.
*    <fs_journalitem>-entrycomment  = is_head-entrycomment.

  ENDMETHOD.


  METHOD set_item.

    DATA lv_index_line         TYPE i.
    DATA lv_index_journal_list TYPE i.
    DATA lv_index_journal_item TYPE i.
    FIELD-SYMBOLS <ls_lines>         TYPE /itetr/if_edf_xml_types=>ty_line.
    FIELD-SYMBOLS <fs_journallist>   TYPE /itetr/if_edf_xml_types=>ty_journallist.
    FIELD-SYMBOLS <fs_journalitem>   TYPE /itetr/if_edf_xml_types=>ty_journalitem.
    FIELD-SYMBOLS <fs_journaldetail> TYPE /itetr/if_edf_xml_types=>ty_journaldetail.


    lv_index_line = lines( ms_root_koc-lines ).

    READ TABLE ms_root_koc-lines ASSIGNING <ls_lines> INDEX lv_index_line.
    CHECK <ls_lines> IS ASSIGNED.
    lv_index_journal_list = lines( <ls_lines>-journallist ).
    READ TABLE <ls_lines>-journallist ASSIGNING <fs_journallist> INDEX lv_index_journal_list.
    CHECK <fs_journallist> IS ASSIGNED.
*    lv_index_journal_item = lines( <fs_journallist>-journalitem ).
*    READ TABLE <fs_journallist>-journalitem ASSIGNING <fs_journalitem> INDEX lv_index_journal_item.
*    CHECK <fs_journalitem> IS ASSIGNED.

    READ TABLE <fs_journallist>-journalitem ASSIGNING <fs_journalitem> WITH KEY entrynumber = is_item-item-belnr.
    IF <fs_journalitem> IS NOT ASSIGNED.
      APPEND INITIAL LINE TO <fs_journallist>-journalitem ASSIGNING <fs_journalitem>.
    ENDIF.

    ADD is_item-creditamount TO <fs_journalitem>-totalcredit.
    ADD is_item-debitamount  TO <fs_journalitem>-totaldebit.

    <fs_journalitem>-entrynumber        = is_item-item-belnr.
    <fs_journalitem>-entrynumbercounter = is_item-item-yevno.

    SHIFT <fs_journalitem>-entrynumbercounter LEFT DELETING LEADING space.
    SHIFT <fs_journalitem>-entrynumbercounter LEFT DELETING LEADING '0'.
    CONDENSE <fs_journalitem>-entrynumbercounter NO-GAPS.

    <fs_journalitem>-enteredby          = is_item-head-enteredby.
    <fs_journalitem>-entereddate        = is_item-head-entereddate.
    <fs_journalitem>-entrycomment       = is_item-head-entrycomment.

    APPEND INITIAL LINE TO <fs_journalitem>-journaldetail ASSIGNING <fs_journaldetail>.
    CHECK <fs_journaldetail> IS ASSIGNED.
*    <fs_journaldetail>-linenumber              = is_item-item-dfbuz.
    <fs_journaldetail>-linenumber              = is_item-item-linen.
    SHIFT <fs_journaldetail>-linenumber LEFT DELETING LEADING space.
    SHIFT <fs_journaldetail>-linenumber LEFT DELETING LEADING '0'.
    CONDENSE <fs_journaldetail>-linenumber NO-GAPS.
    <fs_journaldetail>-accountmainid           = is_item-accountmainid.
    <fs_journaldetail>-accountmaindescription  = is_item-accountmaindescription.
    <fs_journaldetail>-accountsubid            = is_item-accountsubid.
    <fs_journaldetail>-accountsubdescription   = is_item-accountsubdescription.
    <fs_journaldetail>-amount                  = is_item-item-dmbtr_def.
    <fs_journaldetail>-debitcreditcode         = is_item-debitcreditcode.
    <fs_journaldetail>-documenttype            = is_item-documenttype.
    <fs_journaldetail>-documenttypedescription = is_item-documenttypedesc.
    <fs_journaldetail>-documentnumber          = is_item-documentnumber.
    <fs_journaldetail>-documentreference       = is_item-documentreference.
    <fs_journaldetail>-documentdate            = is_item-documentdate.
    <fs_journaldetail>-paymentmethod           = is_item-paymentmethod.
    <fs_journaldetail>-detailcomment           = is_item-detailcomment.

    CONDENSE <fs_journaldetail>-amount NO-GAPS.
    CONDENSE <fs_journalitem>-totalcredit NO-GAPS.
    CONDENSE <fs_journalitem>-totaldebit NO-GAPS.
  ENDMETHOD.


  METHOD set_request_header.

    DATA lv_length TYPE i.
    DATA lv_length_s TYPE string.

    lv_length = xstrlen( iv_request ).
    lv_length_s = lv_length.
    CONDENSE lv_length_s NO-GAPS.

    mo_client->request->set_header_field( name = 'Accept-Encoding'   value =  'gzip,deflate' ).
    mo_client->request->set_header_field( name = 'Content-Type'      value =  'text/xml;charset=UTF-8' ).
    mo_client->request->set_header_field( name = 'SOAPAction'        value =  'http://tempuri.org/UploadFile' ).
    mo_client->request->set_header_field( name = 'Content-Length'    value =  lv_length_s ).

  ENDMETHOD.


  method SET_REQUEST_HEADER_API.
  endmethod.
ENDCLASS.