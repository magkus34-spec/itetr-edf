interface /ITETR/IF_EDF_RFC_REFIN_ITEM3
  public .


  types:
    CHAR1 type C length 000001 .
  types:
    BUKRS type C length 000004 .
  types:
    BELNR_D type C length 000010 .
  types:
    GJAHR type N length 000004 .
  types:
    BUZEI type N length 000003 .
  types:
    DOCLN6 type C length 000006 .
  types:
    /ITETR/EDF_BCODE type C length 000004 .
  types:
    MONAT type N length 000002 .
  types:
    /ITETR/EDF_LEDGER_IN_PURGE type C length 000001 .
  types:
    /ITETR/EDF_PART_NO type C length 000006 .
  types:
    /ITETR/EDF_DEFTER_KLMNO type N length 000006 .
  types:
    /ITETR/EDF_SIRA_NO type N length 000010 .
  types:
    /ITETR/EDF_YVMY_NO type N length 000010 .
  types:
    BLART type C length 000002 .
  types:
    /ITETR/EDF_GIB_DOC_TYPE type C length 000020 .
  types:
    /ITETR/EDF_GIB_DOC_TYPE_DEF type C length 000255 .
  types:
    /ITETR/EDF_PAYMENT_TERM type C length 000020 .
  types:
    USNAM type C length 000012 .
  types:
    TCODE type C length 000020 .
  types:
    XBLNR type C length 000016 .
  types:
    STBLG type C length 000010 .
  types:
    STJAH type N length 000004 .
  types:
    BKTXT type C length 000025 .
  types:
    WAERS type C length 000005 .
  types:
    BSTAT_D type C length 000001 .
  types:
    AWTYP type C length 000005 .
  types:
    AWKEY type C length 000020 .
  types:
    XBLNR_ALT type C length 000026 .
  types:
    BSCHL type C length 000002 .
  types:
    KOART type C length 000001 .
  types:
    UMSKZ type C length 000001 .
  types:
    SHKZG type C length 000001 .
  types:
    GSBER type C length 000004 .
  types:
    MWSKZ type C length 000002 .
  types:
    /ITETR/EDF_DEFTER_YNSYN_TUT type P length 9  decimals 000002 .
  types:
    DMBTR type P length 12  decimals 000002 .
  types:
    WRBTR type P length 12  decimals 000002 .
  types:
    KTOSL type C length 000003 .
  types:
    DZUONR type C length 000018 .
  types:
    SGTXT type C length 000050 .
  types:
    ALTKT type C length 000010 .
  types:
    KOSTL type C length 000010 .
  types:
    PERNR_D type N length 000008 .
  types:
    SAKNR type C length 000010 .
  types:
    HKONT type C length 000010 .
  types:
    TXT50_SKAT type C length 000050 .
  types:
    /ITETR/EDF_ANA_HESAP type C length 000003 .
  types:
    /ITETR/EDF_ACCOUNT_DEF type C length 000255 .
  types:
    XCPDD type C length 000001 .
  types:
    KUNNR type C length 000010 .
  types:
    LIFNR type C length 000010 .
  types:
    /ITETR/EDF_MUSTERI_AD type C length 000140 .
  types:
    /ITETR/EDF_SATICI_AD type C length 000140 .
  types:
    SCHZW_BSEG type C length 000001 .
  types:
    /ITETR/EDF_DIF45 type C length 000001 .
  types:
    /ITETR/EDF_DEBIT type P length 12  decimals 000002 .
  types:
    /ITETR/EDF_CREDIT type P length 12  decimals 000002 .
  types:
    /ITETR/EDF_BORC type P length 12  decimals 000002 .
  types:
    /ITETR/EDF_TCREDIT_F08 type P length 12  decimals 000002 .
  types:
    /ITETR/EDF_F08DIFF type C length 000001 .
  types:
    /ITETR/EDF_CLDOC type C length 000255 .
  types:
    /ITETR/EDF_CLITM type C length 000001 .
  types:
    begin of /ITETR/EDF_S_LEDGER_DOC,
      SEL type CHAR1,
      BUKRS type BUKRS,
      BUDAT type DATS,
      BELNR type BELNR_D,
      GJAHR type GJAHR,
      BUZEI type BUZEI,
      DOCLN type DOCLN6,
      BCODE type /ITETR/EDF_BCODE,
      MONAT type MONAT,
      TSFYD type /ITETR/EDF_LEDGER_IN_PURGE,
      PARTN type /ITETR/EDF_PART_NO,
      DFBUZ type /ITETR/EDF_DEFTER_KLMNO,
      LINEN type /ITETR/EDF_SIRA_NO,
      YEVNO type /ITETR/EDF_YVMY_NO,
      BLART type BLART,
      GBTUR type /ITETR/EDF_GIB_DOC_TYPE,
      BLART_T type /ITETR/EDF_GIB_DOC_TYPE_DEF,
      OTURU type /ITETR/EDF_PAYMENT_TERM,
      BLDAT type DATS,
      CPUDT type DATS,
      USNAM type USNAM,
      TCODE type TCODE,
      XBLNR type XBLNR,
      STBLG type STBLG,
      STJAH type STJAH,
      BKTXT type BKTXT,
      WAERS type WAERS,
      BSTAT type BSTAT_D,
      AWTYP type AWTYP,
      AWKEY type AWKEY,
      XBLNR_ALT type XBLNR_ALT,
      BSCHL type BSCHL,
      KOART type KOART,
      UMSKZ type UMSKZ,
      SHKZG type SHKZG,
      SHKZG_SRT type SHKZG,
      GSBER type GSBER,
      MWSKZ type MWSKZ,
      DMBTR_DEF type /ITETR/EDF_DEFTER_YNSYN_TUT,
      WAERS_DEF type WAERS,
      DMBTR type DMBTR,
      WRBTR type WRBTR,
      KTOSL type KTOSL,
      ZUONR type DZUONR,
      SGTXT type SGTXT,
      ALTKT type ALTKT,
      KOSTL type KOSTL,
      PERNR type PERNR_D,
      SAKNR type SAKNR,
      HKONT type HKONT,
      TXT50 type TXT50_SKAT,
      HKONT_3 type /ITETR/EDF_ANA_HESAP,
      SAKNR_T type /ITETR/EDF_ACCOUNT_DEF,
      XCPDD type XCPDD,
      KUNNR type KUNNR,
      LIFNR type LIFNR,
      KNAME type /ITETR/EDF_MUSTERI_AD,
      LNAME type /ITETR/EDF_SATICI_AD,
      ZLSCH type SCHZW_BSEG,
      DIF45 type /ITETR/EDF_DIF45,
      TDEBIT type /ITETR/EDF_DEBIT,
      TCREDIT type /ITETR/EDF_CREDIT,
      TDEBIT_F08 type /ITETR/EDF_BORC,
      TCREDIT_F08 type /ITETR/EDF_TCREDIT_F08,
      F08DIFF type /ITETR/EDF_F08DIFF,
      CLDOC type /ITETR/EDF_CLDOC,
      CLITM type /ITETR/EDF_CLITM,
    end of /ITETR/EDF_S_LEDGER_DOC .
  types:
    /ITETR/EDF_TT_PART_LIST        type standard table of /ITETR/EDF_S_LEDGER_DOC        with non-unique default key .
endinterface.