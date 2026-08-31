*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_WRT_LEDGER_TO_DB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/edf_r_wrt_ledger_to_db.

INCLUDE /itetr/edf_r_ltd_top.
INCLUDE /itetr/edf_r_ltd_sel.
INCLUDE /itetr/edf_r_ltd_frm.

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.
  PERFORM screen_output.

START-OF-SELECTION.
  PERFORM progress.

END-OF-SELECTION.
  PERFORM end_progress.