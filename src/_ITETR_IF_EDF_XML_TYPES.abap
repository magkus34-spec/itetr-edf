INTERFACE /itetr/if_edf_xml_types
  PUBLIC .


  TYPES ty_spr_csv TYPE /itetr/edf_s_spr_csv .
  TYPES ty_htk_csv TYPE /itetr/edf_s_htk_csv .
  TYPES ty_sovos_txt TYPE /itetr/edf_s_sov_txt .
  TYPES ty_efinans_csv TYPE /itetr/edf_s_efn_csv .
  TYPES ty_edoksis_txt TYPE /itetr/edf_tt_sdx_txt_item .
  TYPES:
    ty_elg_csv TYPE TABLE OF /itetr/edf_s_elg_csv .
  TYPES linenumber TYPE string .
  TYPES:
    BEGIN OF ty_journaldetail_att.
  TYPES linenumber              TYPE string.
  TYPES accountmainid           TYPE string.
  TYPES accountmaindescription  TYPE string.
  TYPES accountsubid            TYPE string.
  TYPES accountsubdescription   TYPE string.
  TYPES amount                  TYPE string.
  TYPES debitcreditcode         TYPE string.
  TYPES documenttype            TYPE string.
  TYPES documenttypedescription TYPE string.
  TYPES documentnumber          TYPE string.
  TYPES documentreference       TYPE string.
  TYPES documentdate            TYPE string.
  TYPES paymentmethod           TYPE string.
  TYPES detailcomment           TYPE string.
  TYPES END OF ty_journaldetail_att .
  TYPES accountmainid TYPE string .
  TYPES:
    BEGIN OF ty_journalitem_att.
  TYPES enteredby          TYPE string.
  TYPES entereddate        TYPE string.
  TYPES entrynumber        TYPE string.
  TYPES entrycomment       TYPE string.
  TYPES totaldebit         TYPE string.
  TYPES totalcredit        TYPE string.
  TYPES entrynumbercounter TYPE string.
  TYPES END OF ty_journalitem_att .
  TYPES accountmaindescription TYPE string .
  TYPES:
    BEGIN OF ty_content.
  TYPES content TYPE string.
  TYPES END OF ty_content .
  TYPES accountsubid TYPE string .
  TYPES:
    BEGIN OF ty_journaldetail.
      INCLUDE TYPE ty_journaldetail_att.
      INCLUDE TYPE ty_content.
TYPES END OF ty_journaldetail .
  TYPES accountsubdescription TYPE string .
  TYPES:
    tty_journaldetail TYPE STANDARD TABLE OF ty_journaldetail WITH DEFAULT KEY .
  TYPES amount TYPE string .
  TYPES:
    BEGIN OF ty_journalitem.
      INCLUDE TYPE ty_journalitem_att.
      INCLUDE TYPE ty_content.
  TYPES journaldetail TYPE tty_journaldetail.
  TYPES END OF ty_journalitem .
  TYPES debitcreditcode TYPE string .
  TYPES:
    tty_journalitem TYPE STANDARD TABLE OF ty_journalitem WITH DEFAULT KEY .
  TYPES documenttype TYPE string .
  TYPES:
    BEGIN OF ty_journallist.
      INCLUDE TYPE ty_content.
  TYPES journalitem TYPE tty_journalitem.
  TYPES END OF ty_journallist .
  TYPES documenttypedescription TYPE string .
  TYPES:
    tty_journallist TYPE STANDARD TABLE OF ty_journallist WITH DEFAULT KEY .
  TYPES documentnumber TYPE string .
  TYPES:
    BEGIN OF ty_information.
  TYPES branchcode           TYPE ty_content.
  TYPES branchdescription    TYPE ty_content.
  TYPES filecontentstartdate TYPE ty_content.
  TYPES filecontentenddate   TYPE ty_content.
  TYPES END OF ty_information .
  TYPES documentreference TYPE string .
  TYPES:
    BEGIN OF ty_uploadfileresult_container.
  TYPES status      TYPE ty_content.
  TYPES description TYPE ty_content.
  TYPES date        TYPE ty_content.
  TYPES END OF ty_uploadfileresult_container .
  TYPES documentdate TYPE string .
  TYPES:
    BEGIN OF ty_uploadfileresult.
  TYPES uploadfileresult TYPE ty_uploadfileresult_container.
  TYPES END OF ty_uploadfileresult .
  TYPES paymentmethod TYPE string .
  TYPES:
    BEGIN OF ty_uploadfileresponse.
  TYPES uploadfileresponse TYPE ty_uploadfileresult.
  TYPES END OF ty_uploadfileresponse .
  TYPES detailcomment TYPE string .
  TYPES:
    BEGIN OF ty_body.
  TYPES body TYPE ty_uploadfileresponse .
  TYPES END OF ty_body .
  TYPES:
    BEGIN OF ty_envelope.
  TYPES envelope TYPE ty_body.
  TYPES END OF ty_envelope .
  TYPES:
    BEGIN OF ty_line.
  TYPES information TYPE ty_information.
  TYPES journallist TYPE tty_journallist.
  TYPES END OF ty_line .
  TYPES:
    tty_line TYPE STANDARD TABLE OF ty_line WITH DEFAULT KEY .
  TYPES:
    BEGIN OF ty_koc.
  TYPES lines TYPE tty_line.
  TYPES END OF ty_koc .
  TYPES:
    BEGIN OF ty_vbt_detail.
  TYPES linenumber TYPE string.
  TYPES linenumbercounter TYPE string.
  TYPES accountmainid TYPE string.
  TYPES accountmaindescription TYPE string.
  TYPES accountsubdescription TYPE string.
  TYPES accountsubid TYPE string.
  TYPES amount TYPE string.
  TYPES debitcreditcode TYPE string.
  TYPES postingdate TYPE string.
  TYPES documenttype TYPE string.
  TYPES documenttypedescription TYPE string.
  TYPES documentnumber TYPE string.
  TYPES documentreference TYPE string.
  TYPES documentdate TYPE string.
  TYPES paymentmethod TYPE string.
  TYPES detailcomment TYPE string.
  TYPES END OF ty_vbt_detail .
  TYPES:
    BEGIN OF ty_vbt_header.
  TYPES enteredby        TYPE string.
  TYPES entereddate      TYPE string.
  TYPES entrynumber      TYPE string.
  TYPES entrycomment     TYPE string.
  TYPES totaldebit       TYPE string.
  TYPES totalcredit      TYPE string.
  TYPES entrynumbercount TYPE string.
  TYPES entry_detail     TYPE TABLE OF ty_vbt_detail WITH KEY linenumber.
  TYPES END OF ty_vbt_header .
  TYPES:
    BEGIN OF ty_vbt.
  TYPES companyvkn TYPE string.
  TYPES periodstart TYPE string.
  TYPES periodend TYPE string.
  TYPES branchcode TYPE string.
  TYPES entry_header TYPE TABLE OF ty_vbt_header WITH KEY entrynumbercount.
  TYPES END OF ty_vbt .
***************spr*********
  TYPES:
  BEGIN OF ty_spr_detail.
  TYPES companyvkn TYPE string.
  TYPES ledger_year TYPE string.
  TYPES ledger_month TYPE string.
  TYPES enteredby        TYPE string.
  TYPES entereddate      TYPE string.
  TYPES entrynumber      TYPE string.
  TYPES entrycomment     TYPE string.
  TYPES totaldebit       TYPE string.
  TYPES totalcredit      TYPE string.
  TYPES entrynumbercount TYPE string.
  TYPES linenumber TYPE string.
  TYPES accountmainid TYPE string.
  TYPES accountmaindescription TYPE string.
  TYPES accountsubid TYPE string.
  TYPES accountsubdescription TYPE string.
  TYPES amount TYPE string.
  TYPES debitcreditcode TYPE string.
  TYPES documenttype TYPE string.
  TYPES documenttypedescription TYPE string.
  TYPES documentnumber TYPE string.
  TYPES documentdate TYPE string.
  TYPES paymentmethod TYPE string.
  TYPES detailcomment TYPE string.
  TYPES amountcurrency TYPE string.
  TYPES amountoriginalexchangeratedate TYPE string.
  TYPES amountoriginalamount TYPE string.
  TYPES amountoriginalcurrency TYPE string.
  TYPES amountoriginalexchangerate TYPE string.
  TYPES amountoriginalexchratesource TYPE string.
  TYPES amountoriginalexchratecomment TYPE string.
  TYPES batchid TYPE string.
  TYPES END OF ty_spr_detail .
  TYPES:
  BEGIN OF ty_spr_header.
  TYPES companyvkn TYPE string.
  TYPES ledger_year TYPE string.
  TYPES ledger_month TYPE string.
  TYPES enteredby        TYPE string.
  TYPES entereddate      TYPE string.
  TYPES entrynumber      TYPE string.
  TYPES entrycomment     TYPE string.
  TYPES totaldebit       TYPE string.
  TYPES totalcredit      TYPE string.
  TYPES entrynumbercount TYPE string.
  TYPES entry_detail     TYPE TABLE OF ty_spr_detail WITH KEY linenumber.
  TYPES END OF ty_spr_header .
  TYPES:
    BEGIN OF ty_spr.
  TYPES companyvkn TYPE string.
  TYPES periodstart TYPE string.
  TYPES periodend TYPE string.
  TYPES branchcode TYPE string.
  TYPES entry_header TYPE TABLE OF ty_spr_header WITH KEY entrynumbercount.
  TYPES END OF ty_spr .
***************spr*********
  TYPES:
    BEGIN OF ty_yevmiyekayetxmlresult.
  TYPES success     TYPE string.
  TYPES code        TYPE string.
  TYPES description TYPE string.
  TYPES END OF ty_yevmiyekayetxmlresult .
  TYPES:
    BEGIN OF ty_yevmiyekayetxmlresponse.
  TYPES yevmiyekayetxmlresult TYPE ty_yevmiyekayetxmlresult.
  TYPES END OF ty_yevmiyekayetxmlresponse .
  TYPES:
    BEGIN OF ty_body_vbt.
  TYPES yevmiyekayetxmlresponse TYPE ty_yevmiyekayetxmlresponse.
  TYPES END OF ty_body_vbt .
  TYPES:
    BEGIN OF ty_envelope_vbt.
  TYPES body TYPE ty_body_vbt.
  TYPES END OF ty_envelope_vbt .
  TYPES:
    BEGIN OF ty_response_vbt.
  TYPES envelope TYPE ty_envelope_vbt.
  TYPES END OF ty_response_vbt .
ENDINTERFACE.