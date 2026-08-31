interface /ITETR/IF_EDF_SEND_SERV
  public .


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
  types:
    SYST_DAYST type C length 000001 .
  types:
    SYST_FTYPE type C length 000001 .
  types:
    SYST_APPLI type X length 000002 .
  types:
    SYST_CCURS type P length 5  decimals 000000 .
  types:
    SYST_CCURT type P length 5  decimals 000000 .
  types:
    SYST_DEBUG type C length 000001 .
  types:
    SYST_CTYPE type C length 000001 .
  types:
    SYST_INPUT type C length 000001 .
  types:
    SYST_LANGU type C length 000001 .
  types:
    SYST_BATCH type C length 000001 .
  types:
    SYST_BINPT type C length 000001 .
  types:
    SYST_CALLD type C length 000001 .
  types:
    SYST_DYNNR type C length 000004 .
  types:
    SYST_DYNGR type C length 000004 .
  types:
    SYST_NEWPA type C length 000001 .
  types:
    SYST_PRI40 type C length 000001 .
  types:
    SYST_RSTRT type C length 000001 .
  types:
    SYST_WTITL type C length 000001 .
  types:
    SYST_DBNAM type C length 000020 .
  types:
    SYST_MANDT type C length 000003 .
  types:
    SYST_PREFX type C length 000003 .
  types:
    SYST_FMKEY type C length 000003 .
  types:
    SYST_PEXPI type N length 000001 .
  types:
    SYST_PRINI type N length 000001 .
  types:
    SYST_PRIMM type C length 000001 .
  types:
    SYST_PRREL type C length 000001 .
  types:
    SYST_PLAYO type C length 000005 .
  types:
    SYST_PRBIG type C length 000001 .
  types:
    SYST_PLAYP type C length 000001 .
  types:
    SYST_PRNEW type C length 000001 .
  types:
    SYST_PRLOG type C length 000001 .
  types:
    SYST_PDEST type C length 000004 .
  types:
    SYST_PLIST type C length 000012 .
  types:
    SYST_PAUTH type N length 000002 .
  types:
    SYST_PRDSN type C length 000006 .
  types:
    SYST_PNWPA type C length 000001 .
  types:
    SYST_CALLR type C length 000008 .
  types:
    SYST_REPI2 type C length 000040 .
  types:
    SYST_RTITL type C length 000070 .
  types:
    SYST_PRREC type C length 000012 .
  types:
    SYST_PRTXT type C length 000068 .
  types:
    SYST_PRABT type C length 000012 .
  types:
    SYST_LPASS type C length 000004 .
  types:
    SYST_NRPAG type C length 000001 .
  types:
    SYST_PAART type C length 000016 .
  types:
    SYST_PRCOP type N length 000003 .
  types:
    SYST_BATZS type C length 000001 .
  types:
    SYST_BSPLD type C length 000001 .
  types:
    SYST_BREP4 type C length 000004 .
  types:
    SYST_BATZO type C length 000001 .
  types:
    SYST_BATZD type C length 000001 .
  types:
    SYST_BATZW type C length 000001 .
  types:
    SYST_BATZM type C length 000001 .
  types:
    SYST_CTABL type C length 000004 .
  types:
    SYST_DBSYS type C length 000010 .
  types:
    SYST_DCSYS type C length 000004 .
  types:
    SYST_MACDB type C length 000004 .
  types:
    SYST_SYSID type C length 000008 .
  types:
    SYST_OPSYS type C length 000010 .
  types:
    SYST_PFKEY type C length 000020 .
  types:
    SYST_SAPRL type C length 000004 .
  types:
    SYST_TCODE type C length 000020 .
  types:
    SYST_UCOMM type C length 000070 .
  types:
    SYST_CFWAE type C length 000005 .
  types:
    SYST_CHWAE type C length 000005 .
  types:
    SYST_SPONO type N length 000010 .
  types:
    SYST_SPONR type N length 000010 .
  types:
    SYST_WAERS type C length 000005 .
  types:
    SYST_SLSET type C length 000014 .
  types:
    SYST_SUBTY type X length 000001 .
  types:
    SYST_SUBCS type C length 000001 .
  types:
    SYST_GROUP type C length 000001 .
  types:
    SYST_FFILE type C length 000008 .
  types SYST_UZEIT type T .
  types:
    SYST_DSNAM type C length 000008 .
  types:
    SYST_TABID type C length 000008 .
  types:
    SYST_TFDSN type C length 000008 .
  types:
    SYST_UNAME type C length 000012 .
  types:
    SYST_LSTAT type C length 000016 .
  types:
    SYST_ABCDE type C length 000026 .
  types:
    SYST_MARKY type C length 000001 .
  types:
    SYST_SFNAM type C length 000030 .
  types:
    SYST_TNAME type C length 000030 .
  types:
    SYST_MSGLI type C length 000060 .
  types:
    SYST_TITLE type C length 000070 .
  types:
    SYST_ENTRY type C length 000072 .
  types:
    SYST_LISEL type C length 000255 .
  types:
    SYST_ULINE type C length 000255 .
  types:
    SYST_XCODE type C length 000070 .
  types:
    SYST_CPROG type C length 000040 .
  types:
    SYST_XPROG type C length 000040 .
  types:
    SYST_XFORM type C length 000030 .
  types:
    SYST_LDBPG type C length 000040 .
  types:
    SYST_TVAR type C length 000020 .
  types:
    SYST_MSGID type C length 000020 .
  types:
    SYST_MSGTY type C length 000001 .
  types:
    SYST_MSGNO type N length 000003 .
  types:
    SYST_MSGV type C length 000050 .
  types:
    SYST_ONCOM type C length 000001 .
  types:
    SYST_VLINE type C length 000001 .
  types:
    SYST_WINSL type C length 000079 .
  types:
    SYST_DATAR type C length 000001 .
  types:
    SYST_HOST type C length 000032 .
  types:
    SYST_LOCDB type C length 000001 .
  types:
    SYST_LOCOP type C length 000001 .
  types SYST_TIMLO type T .
  types:
    SYST_ZONLO type C length 000006 .
  types:
    begin of SYST,
      INDEX type INT4,
      PAGNO type INT4,
      TABIX type INT4,
      TFILL type INT4,
      TLOPC type INT4,
      TMAXL type INT4,
      TOCCU type INT4,
      TTABC type INT4,
      TSTIS type INT4,
      TTABI type INT4,
      DBCNT type INT4,
      FDPOS type INT4,
      COLNO type INT4,
      LINCT type INT4,
      LINNO type INT4,
      LINSZ type INT4,
      PAGCT type INT4,
      MACOL type INT4,
      MAROW type INT4,
      TLENG type INT4,
      SFOFF type INT4,
      WILLI type INT4,
      LILLI type INT4,
      SUBRC type INT4,
      FLENG type INT4,
      CUCOL type INT4,
      CUROW type INT4,
      LSIND type INT4,
      LISTI type INT4,
      STEPL type INT4,
      TPAGI type INT4,
      WINX1 type INT4,
      WINY1 type INT4,
      WINX2 type INT4,
      WINY2 type INT4,
      WINCO type INT4,
      WINRO type INT4,
      WINDI type INT4,
      SROWS type INT4,
      SCOLS type INT4,
      LOOPC type INT4,
      FOLEN type INT4,
      FODEC type INT4,
      TZONE type INT4,
      DAYST type SYST_DAYST,
      FTYPE type SYST_FTYPE,
      APPLI type SYST_APPLI,
      FDAYW type INT1,
      CCURS type SYST_CCURS,
      CCURT type SYST_CCURT,
      DEBUG type SYST_DEBUG,
      CTYPE type SYST_CTYPE,
      INPUT type SYST_INPUT,
      LANGU type SYST_LANGU,
      MODNO type INT4,
      BATCH type SYST_BATCH,
      BINPT type SYST_BINPT,
      CALLD type SYST_CALLD,
      DYNNR type SYST_DYNNR,
      DYNGR type SYST_DYNGR,
      NEWPA type SYST_NEWPA,
      PRI40 type SYST_PRI40,
      RSTRT type SYST_RSTRT,
      WTITL type SYST_WTITL,
      CPAGE type INT4,
      DBNAM type SYST_DBNAM,
      MANDT type SYST_MANDT,
      PREFX type SYST_PREFX,
      FMKEY type SYST_FMKEY,
      PEXPI type SYST_PEXPI,
      PRINI type SYST_PRINI,
      PRIMM type SYST_PRIMM,
      PRREL type SYST_PRREL,
      PLAYO type SYST_PLAYO,
      PRBIG type SYST_PRBIG,
      PLAYP type SYST_PLAYP,
      PRNEW type SYST_PRNEW,
      PRLOG type SYST_PRLOG,
      PDEST type SYST_PDEST,
      PLIST type SYST_PLIST,
      PAUTH type SYST_PAUTH,
      PRDSN type SYST_PRDSN,
      PNWPA type SYST_PNWPA,
      CALLR type SYST_CALLR,
      REPI2 type SYST_REPI2,
      RTITL type SYST_RTITL,
      PRREC type SYST_PRREC,
      PRTXT type SYST_PRTXT,
      PRABT type SYST_PRABT,
      LPASS type SYST_LPASS,
      NRPAG type SYST_NRPAG,
      PAART type SYST_PAART,
      PRCOP type SYST_PRCOP,
      BATZS type SYST_BATZS,
      BSPLD type SYST_BSPLD,
      BREP4 type SYST_BREP4,
      BATZO type SYST_BATZO,
      BATZD type SYST_BATZD,
      BATZW type SYST_BATZW,
      BATZM type SYST_BATZM,
      CTABL type SYST_CTABL,
      DBSYS type SYST_DBSYS,
      DCSYS type SYST_DCSYS,
      MACDB type SYST_MACDB,
      SYSID type SYST_SYSID,
      OPSYS type SYST_OPSYS,
      PFKEY type SYST_PFKEY,
      SAPRL type SYST_SAPRL,
      TCODE type SYST_TCODE,
      UCOMM type SYST_UCOMM,
      CFWAE type SYST_CFWAE,
      CHWAE type SYST_CHWAE,
      SPONO type SYST_SPONO,
      SPONR type SYST_SPONR,
      WAERS type SYST_WAERS,
      CDATE type DATS,
      DATUM type DATS,
      SLSET type SYST_SLSET,
      SUBTY type SYST_SUBTY,
      SUBCS type SYST_SUBCS,
      GROUP type SYST_GROUP,
      FFILE type SYST_FFILE,
      UZEIT type SYST_UZEIT,
      DSNAM type SYST_DSNAM,
      TABID type SYST_TABID,
      TFDSN type SYST_TFDSN,
      UNAME type SYST_UNAME,
      LSTAT type SYST_LSTAT,
      ABCDE type SYST_ABCDE,
      MARKY type SYST_MARKY,
      SFNAM type SYST_SFNAM,
      TNAME type SYST_TNAME,
      MSGLI type SYST_MSGLI,
      TITLE type SYST_TITLE,
      ENTRY type SYST_ENTRY,
      LISEL type SYST_LISEL,
      ULINE type SYST_ULINE,
      XCODE type SYST_XCODE,
      CPROG type SYST_CPROG,
      XPROG type SYST_XPROG,
      XFORM type SYST_XFORM,
      LDBPG type SYST_LDBPG,
      TVAR0 type SYST_TVAR,
      TVAR1 type SYST_TVAR,
      TVAR2 type SYST_TVAR,
      TVAR3 type SYST_TVAR,
      TVAR4 type SYST_TVAR,
      TVAR5 type SYST_TVAR,
      TVAR6 type SYST_TVAR,
      TVAR7 type SYST_TVAR,
      TVAR8 type SYST_TVAR,
      TVAR9 type SYST_TVAR,
      MSGID type SYST_MSGID,
      MSGTY type SYST_MSGTY,
      MSGNO type SYST_MSGNO,
      MSGV1 type SYST_MSGV,
      MSGV2 type SYST_MSGV,
      MSGV3 type SYST_MSGV,
      MSGV4 type SYST_MSGV,
      ONCOM type SYST_ONCOM,
      VLINE type SYST_VLINE,
      WINSL type SYST_WINSL,
      STACO type INT4,
      STARO type INT4,
      DATAR type SYST_DATAR,
      HOST type SYST_HOST,
      LOCDB type SYST_LOCDB,
      LOCOP type SYST_LOCOP,
      DATLO type DATS,
      TIMLO type SYST_TIMLO,
      ZONLO type SYST_ZONLO,
    end of SYST .
  types:
    /ITETR/EDF_BCODE type C length 000004 .
  types:
    BUKRS type C length 000004 .
  types:
    GJAHR type N length 000004 .
  types:
    MONAT type N length 000002 .
  types:
    __BAPIRET2                     type standard table of BAPIRET2                       with non-unique default key .
  types:
    CHAR1 type C length 000001 .
  types:
    CHAR2 type C length 000002 .
  types:
    begin of /ITETR/EDF_S_RANGE_BUDAT,
      SIGN type CHAR1,
      OPTION type CHAR2,
      LOW type DATS,
      HIGH type DATS,
    end of /ITETR/EDF_S_RANGE_BUDAT .
  types:
    __/ITETR/EDF_S_RANGE_BUDAT     type standard table of /ITETR/EDF_S_RANGE_BUDAT       with non-unique default key .
endinterface.