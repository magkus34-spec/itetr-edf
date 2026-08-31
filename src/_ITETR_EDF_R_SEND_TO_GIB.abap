*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_SEND_TO_GIB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/edf_r_send_to_gib.

INCLUDE /itetr/edf_r_stb_top.
INCLUDE /itetr/edf_r_stb_sel.
INCLUDE /itetr/edf_r_stb_frm.

START-OF-SELECTION.
  PERFORM progress.

END-OF-SELECTION.
  PERFORM end_progress.