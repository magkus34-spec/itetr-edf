interface /ITETR/IF_EDF_RFC_BUTTON_ACTIV
  public .


  types:
    /ITETR/EDF_DFT_VR type C length 000001 .
  types:
    /ITETR/EDF_DFT_OL type C length 000001 .
  types:
    /ITETR/EDF_XML_OL type C length 000001 .
  types:
    /ITETR/EDF_DFT_SN type C length 000001 .
  types:
    /ITETR/EDF_DFT_RESEND type C length 000001 .
  types:
    /ITETR/EDF_DFT_LOG type C length 000001 .
  types:
    /ITETR/EDF_DFT_DEL type C length 000001 .
  types:
    /ITETR/EDF_DFT_REFIN type C length 000001 .
  types:
    begin of /ITETR/EDF_S_BUTTON_ACTIVE,
      JBNLC type /ITETR/EDF_DFT_VR,
      JBNLD type /ITETR/EDF_DFT_OL,
      JBNSD type /ITETR/EDF_XML_OL,
      JBNGB type /ITETR/EDF_DFT_SN,
      RESEND type /ITETR/EDF_DFT_RESEND,
      LOG type /ITETR/EDF_DFT_LOG,
      DEL_DEFTER type /ITETR/EDF_DFT_DEL,
      REFIN type /ITETR/EDF_DFT_REFIN,
    end of /ITETR/EDF_S_BUTTON_ACTIVE .
  types:
    /ITETR/EDF_BCODE type C length 000004 .
  types:
    BUKRS type C length 000004 .
  types:
    GJAHR type N length 000004 .
  types:
    MONAT type N length 000002 .
endinterface.