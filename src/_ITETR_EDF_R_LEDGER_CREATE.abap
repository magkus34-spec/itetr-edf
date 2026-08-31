*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_LEDGER_CREATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/edf_r_ledger_create MESSAGE-ID /itetr/edf_msg.

INCLUDE /itetr/edf_version.
INCLUDE /itetr/edf_r_ledger_create_top.
INCLUDE /itetr/edf_r_ledger_create_cls.
INCLUDE /itetr/edf_r_ledger_create_pbo.
INCLUDE /itetr/edf_r_ledger_create_pai.
INCLUDE /itetr/edf_r_ledger_create_frm.


START-OF-SELECTION.
*  IF sy-tcode EQ '/ITETR/EDF100'.
  "<<Anantu.
  CALL SCREEN 0001.
  ">>Anantu
*    CALL SCREEN 100.
*  ELSEIF sy-tcode EQ '/ITETR/EDF200'.
*    CALL SCREEN 200.
*  ENDIF.