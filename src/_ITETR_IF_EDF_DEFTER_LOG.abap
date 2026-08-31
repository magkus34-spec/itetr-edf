interface /ITETR/IF_EDF_DEFTER_LOG
  public .


  types:
    CHAR1 type C length 000001 .
  types:
    /ITETR/EDF_LGSNO type N length 000010 .
  types UZEIT type T .
  types:
    /ITETR/EDF_PART_NO type C length 000006 .
  types:
    /ITETR/EDF_MESAJ_TIP type C length 000001 .
  types:
    begin of /ITETR/EDF_S_LEDGER_MESSAGE,
      SEL type CHAR1,
      LGSNO type /ITETR/EDF_LGSNO,
      DATUM type DATS,
      UZEIT type UZEIT,
      PARTN type /ITETR/EDF_PART_NO,
      MSTYP type /ITETR/EDF_MESAJ_TIP,
      LGMES type STRING,
    end of /ITETR/EDF_S_LEDGER_MESSAGE .
  types:
    /ITETR/EDF_TT_LEDGER_LOG       type standard table of /ITETR/EDF_S_LEDGER_MESSAGE    with non-unique default key .
  types:
    /ITETR/EDF_BCODE type C length 000004 .
  types:
    BUKRS type C length 000004 .
  types:
    GJAHR type N length 000004 .
  types:
    MONAT type N length 000002 .
endinterface.