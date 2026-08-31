*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_OTHER_SYSTM_TRNFR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /ITETR/EDF_R_OTHER_SYSTM_TRNFR MESSAGE-ID /ITETR/EDF_MSG.

INCLUDE /ITETR/EDF_R_OST_TOP.
INCLUDE /ITETR/EDF_R_OST_SEL.
INCLUDE /ITETR/EDF_R_OST_FRM.

START-OF-SELECTION.
  PERFORM CHECK_PARAMS.
  PERFORM GET_SELECT_FILES.

END-OF-SELECTION.
  PERFORM GET_FCAT.
  PERFORM UPLOAD_FILES.