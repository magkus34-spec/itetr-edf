*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_CUSTOM_PRG
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/edf_r_custom_prg MESSAGE-ID /itetr/edf_msg.

INCLUDE /itetr/edf_r_cus_top.
INCLUDE /itetr/edf_r_cus_pai.
INCLUDE /itetr/edf_r_cus_pbo.
INCLUDE /itetr/edf_r_cus_frm.

START-OF-SELECTION.
  CALL SCREEN 100 STARTING AT 25 6.

END-OF-SELECTION.
  CALL SCREEN 101.