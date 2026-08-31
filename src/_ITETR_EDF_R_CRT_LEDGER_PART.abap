*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_CRT_LEDGER_PART
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /ITETR/EDF_R_CRT_LEDGER_PART.

INCLUDE /ITETR/EDF_R_clp_TOP.
INCLUDE /ITETR/EDF_R_clp_SEL.
INCLUDE /ITETR/EDF_R_clp_FRM.

START-OF-SELECTION.
  PERFORM PROGRESS.

END-OF-SELECTION.
  PERFORM END_PROGRESS.