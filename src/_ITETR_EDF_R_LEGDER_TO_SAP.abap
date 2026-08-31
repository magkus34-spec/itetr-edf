*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_LEGDER_TO_SAP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/edf_r_legder_to_sap MESSAGE-ID /itetr/edf_msg.

INCLUDE /itetr/edf_r_led_top.
INCLUDE /itetr/edf_r_led_sel.
INCLUDE /itetr/edf_r_led_frm.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM get_files.