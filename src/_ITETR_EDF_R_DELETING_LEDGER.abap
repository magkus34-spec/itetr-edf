*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_DELETING_LEDGER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /ITETR/EDF_R_DELETING_LEDGER MESSAGE-ID /ITETR/EDF_MSG.
INCLUDE /ITETR/EDF_R_del_TOP.
INCLUDE /ITETR/EDF_R_del_SEL.
INCLUDE /ITETR/EDF_R_del_FRM.

AT SELECTION-SCREEN OUTPUT.
  PERFORM SCREEN_OUTPUT.

START-OF-SELECTION.
  PERFORM GET_LED_VALS.
  PERFORM CHECK_AUTHORIZATION.
  PERFORM CHECK_VALUES.
  PERFORM CHECK_LEDGER.

END-OF-SELECTION.
  IF P_SUBMIT IS INITIAL.
    PERFORM SUBMIT_DELETE_LEDGER.
  ELSE.
    PERFORM DELETE_FROM_SERVER.
    PERFORM DELETE_FROM_SAP.
  ENDIF.