*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_TRNSFR_TO_SERVICE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /ITETR/EDF_R_TRNSFR_TO_SERVICE.

INCLUDE /ITETR/EDF_R_tos_TOP.
INCLUDE /ITETR/EDF_R_tos_SEL.
INCLUDE /ITETR/EDF_R_tos_FRM.

START-OF-SELECTION.
  PERFORM PROGRESS.

END-OF-SELECTION.
  PERFORM END_PROGRESS.