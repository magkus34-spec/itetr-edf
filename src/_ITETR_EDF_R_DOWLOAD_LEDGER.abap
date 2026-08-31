*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_DOWLOAD_LEDGER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /ITETR/EDF_R_DOWLOAD_LEDGER MESSAGE-ID /ITETR/EDF_MSG.

INCLUDE /ITETR/EDF_I_DOL_TOP.
INCLUDE /ITETR/EDF_I_DOL_SEL.
INCLUDE /ITETR/EDF_I_DOL_PBO.
INCLUDE /ITETR/EDF_I_DOL_PAI.
INCLUDE /ITETR/EDF_I_DOL_FRM.

START-OF-SELECTION.
  PERFORM GET_LED_VALS.

END-OF-SELECTION.
  CALL SCREEN 100.