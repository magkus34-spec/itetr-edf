interface /ITETR/IF_EDF_GET_LED_VALS
  public .


  types:
    /ITETR/EDF_PART_NO type C length 000006 .
  types:
    /ITETR/EDF_PIECE_NO type N length 000006 .
  types:
    /ITETR/EDF_BEGIN_JOURNAL type N length 000010 .
  types:
    /ITETR/EDF_END_JOURNAL type N length 000010 .
  types:
    /ITETR/EDF_BEGIN_ITEM_NO type N length 000010 .
  types:
    /ITETR/EDF_END_ITEM_NO type N length 000010 .
  types:
    /ITETR/EDF_DEBIT type P length 12  decimals 000002 .
  types:
    /ITETR/EDF_CREDIT type P length 12  decimals 000002 .
  types:
    begin of /ITETR/EDF_S_RFC_HEADER,
      TPART type /ITETR/EDF_PART_NO,
      SPART type /ITETR/EDF_PIECE_NO,
      EPART type /ITETR/EDF_PIECE_NO,
      SYEVNO type /ITETR/EDF_BEGIN_JOURNAL,
      EYEVNO type /ITETR/EDF_END_JOURNAL,
      SLINEN type /ITETR/EDF_BEGIN_ITEM_NO,
      ELINEN type /ITETR/EDF_END_ITEM_NO,
      TDEBIT type /ITETR/EDF_DEBIT,
      TCRDIT type /ITETR/EDF_CREDIT,
      STDEBIT type /ITETR/EDF_DEBIT,
      STCRDIT type /ITETR/EDF_CREDIT,
    end of /ITETR/EDF_S_RFC_HEADER .
  types:
    CHAR1 type C length 000001 .
  types:
    BUKRS type C length 000004 .
  types:
    /ITETR/EDF_BCODE type C length 000004 .
  types:
    GJAHR type N length 000004 .
  types:
    MONAT type N length 000002 .
  types:
    /ITETR/EDF_LEDGER_IN_PURGE type C length 000001 .
  types:
    /ITETR/EDF_TRANS_TO_SERVICE type C length 000004 .
  types:
    /ITETR/EDF_YEVMIYE_OLUSTU type C length 000004 .
  types:
    /ITETR/EDF_YEVMIYE_BERAT_OLUS type C length 000004 .
  types:
    /ITETR/EDF_KEBIR_OLUS type C length 000004 .
  types:
    /ITETR/EDF_KEBIR_BERAT_OLUS type C length 000004 .
  types:
    /ITETR/EDF_DEFTER_RAPOR_OLUS type C length 000004 .
  types:
    /ITETR/EDF_YVMY_BRT_GIB_GOND type C length 000004 .
  types:
    /ITETR/EDF_KEBIR_BRT_GIB_GOND type C length 000004 .
  types:
    /ITETR/EDF_ISYVK type C length 000001 .
  types:
    /ITETR/EDF_ISYVK_OK type C length 000004 .
  types:
    /ITETR/EDF_IGYVK type C length 000255 .
  types:
    /ITETR/EDF_IGYVK_OK type C length 000004 .
  types:
    /ITETR/EDF_ISKBK type C length 000001 .
  types:
    /ITETR/EDF_ISKBK_OK type C length 000004 .
  types:
    /ITETR/EDF_IGKBK type C length 000255 .
  types:
    /ITETR/EDF_IGKBK_OK type C length 000004 .
  types:
    /ITETR/EDF_ISGYK type C length 000001 .
  types:
    /ITETR/EDF_ISGYK_OK type C length 000004 .
  types:
    /ITETR/EDF_IGGYK type C length 000255 .
  types:
    /ITETR/EDF_IGGYK_OK type C length 000004 .
  types:
    /ITETR/EDF_ISGKK type C length 000001 .
  types:
    /ITETR/EDF_ISGKK_OK type C length 000004 .
  types:
    /ITETR/EDF_IGGKK type C length 000255 .
  types:
    /ITETR/EDF_IGGKK_OK type C length 000004 .
  types:
    /ITETR/EDF_MANUALLY_UPLOADED type C length 000001 .
  types:
    /ITETR/EDF_HATA_YOK type C length 000004 .
  types:
    /ITETR/EDF_YVMY_GUID type C length 000036 .
  types:
    /ITETR/EDF_KBR_GUID type C length 000036 .
  types:
    /ITETR/EDF_RPR_GUID type C length 000036 .
  types ERZET type T .
  types:
    ERNAM type C length 000012 .
  types:
    /ITETR/EDF_PART_DISPLAY type C length 000020 .
  types:
    /ITETR/EDF_PART_DETAIL type C length 000020 .
  types:
    begin of /ITETR/EDF_S_LEDGER_LIST,
      SEL type CHAR1,
      BUKRS type BUKRS,
      BCODE type /ITETR/EDF_BCODE,
      GJAHR type GJAHR,
      MONAT type MONAT,
      DATBI type DATS,
      PARTN type /ITETR/EDF_PART_NO,
      PARNO type /ITETR/EDF_PIECE_NO,
      DATAB type DATS,
      TSFYD type /ITETR/EDF_LEDGER_IN_PURGE,
      FSSYR type DATS,
      FSEYR type DATS,
      SYEVNO type /ITETR/EDF_BEGIN_JOURNAL,
      EYEVNO type /ITETR/EDF_END_JOURNAL,
      SLINEN type /ITETR/EDF_BEGIN_ITEM_NO,
      ELINEN type /ITETR/EDF_END_ITEM_NO,
      DEBIT type /ITETR/EDF_DEBIT,
      CREDIT type /ITETR/EDF_CREDIT,
      PDATAB type DATS,
      PDATBI type DATS,
      SEROK type /ITETR/EDF_TRANS_TO_SERVICE,
      YEVOK type /ITETR/EDF_YEVMIYE_OLUSTU,
      YVBOK type /ITETR/EDF_YEVMIYE_BERAT_OLUS,
      KEBOK type /ITETR/EDF_KEBIR_OLUS,
      KBBOK type /ITETR/EDF_KEBIR_BERAT_OLUS,
      DEROK type /ITETR/EDF_DEFTER_RAPOR_OLUS,
      GBYOK type /ITETR/EDF_YVMY_BRT_GIB_GOND,
      GBKOK type /ITETR/EDF_KEBIR_BRT_GIB_GOND,
      ISYVK type /ITETR/EDF_ISYVK,
      ISYVK_OK type /ITETR/EDF_ISYVK_OK,
      IGYVK type /ITETR/EDF_IGYVK,
      IGYVK_OK type /ITETR/EDF_IGYVK_OK,
      ISKBK type /ITETR/EDF_ISKBK,
      ISKBK_OK type /ITETR/EDF_ISKBK_OK,
      IGKBK type /ITETR/EDF_IGKBK,
      IGKBK_OK type /ITETR/EDF_IGKBK_OK,
      ISGYK type /ITETR/EDF_ISGYK,
      ISGYK_OK type /ITETR/EDF_ISGYK_OK,
      IGGYK type /ITETR/EDF_IGGYK,
      IGGYK_OK type /ITETR/EDF_IGGYK_OK,
      ISGKK type /ITETR/EDF_ISGKK,
      ISGKK_OK type /ITETR/EDF_ISGKK_OK,
      IGGKK type /ITETR/EDF_IGGKK,
      IGGKK_OK type /ITETR/EDF_IGGKK_OK,
      MANUP type /ITETR/EDF_MANUALLY_UPLOADED,
      HATA type /ITETR/EDF_HATA_YOK,
      UIYEV type /ITETR/EDF_YVMY_GUID,
      UIKEB type /ITETR/EDF_KBR_GUID,
      UIDER type /ITETR/EDF_RPR_GUID,
      ERDAT type DATS,
      ERZET type ERZET,
      ERNAM type ERNAM,
      PART_DISPLAY type /ITETR/EDF_PART_DISPLAY,
      PART_DETAIL type /ITETR/EDF_PART_DETAIL,
    end of /ITETR/EDF_S_LEDGER_LIST .
  types:
    /ITETR/EDF_TT_LEDGER_LIST      type standard table of /ITETR/EDF_S_LEDGER_LIST       with non-unique default key .
  types:
    BAPI_MTYPE type C length 000001 .
  types:
    SYMSGID type C length 000020 .
  types:
    SYMSGNO type N length 000003 .
  types:
    BAPI_MSG type C length 000220 .
  types:
    BALOGNR type C length 000020 .
  types:
    BALMNR type N length 000006 .
  types:
    SYMSGV type C length 000050 .
  types:
    BAPI_PARAM type C length 000032 .
  types:
    BAPI_FLD type C length 000030 .
  types:
    BAPILOGSYS type C length 000010 .
  types:
    begin of BAPIRET2,
      TYPE type BAPI_MTYPE,
      ID type SYMSGID,
      NUMBER type SYMSGNO,
      MESSAGE type BAPI_MSG,
      LOG_NO type BALOGNR,
      LOG_MSG_NO type BALMNR,
      MESSAGE_V1 type SYMSGV,
      MESSAGE_V2 type SYMSGV,
      MESSAGE_V3 type SYMSGV,
      MESSAGE_V4 type SYMSGV,
      PARAMETER type BAPI_PARAM,
      ROW type INT4,
      FIELD type BAPI_FLD,
      SYSTEM type BAPILOGSYS,
    end of BAPIRET2 .
endinterface.