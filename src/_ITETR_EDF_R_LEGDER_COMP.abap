*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_LEGDER_COMP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/edf_r_legder_comp.

INCLUDE /itetr/edf_r_legder_comp_top.
INCLUDE /itetr/edf_r_legder_comp_c01.
INCLUDE /itetr/edf_r_legder_comp_mdl.

INITIALIZATION.
  go_main_controller = lcl_main_controller=>get_instance( ).

START-OF-SELECTION.

  CALL SCREEN 0001.