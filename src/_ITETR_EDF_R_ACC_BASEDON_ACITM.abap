*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_ACC_BASEDON_ACITM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /ITETR/EDF_R_ACC_BASEDON_ACITM MESSAGE-ID /ITETR/EDF_MSG.

INCLUDE /ITETR/EDF_R_acc_TOP.
INCLUDE /ITETR/EDF_R_acc_SEL.
INCLUDE /ITETR/EDF_R_acc_FRM.

START-OF-SELECTION.
  PERFORM CHECK_AUTHORIZATION.
  PERFORM GET_DATA.

END-OF-SELECTION.
  PERFORM FIELDCAT.
  PERFORM LAYOUT.
  PERFORM DISPLAY.