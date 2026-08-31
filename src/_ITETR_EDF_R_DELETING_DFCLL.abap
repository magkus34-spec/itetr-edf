*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_DELETING_DFCLL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/edf_r_deleting_dfcll.
TABLES: /itetr/edf_oldef.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_bukrs TYPE bukrs MATCHCODE OBJECT /itetr/edf_sh_srkk OBLIGATORY,
              p_bcode TYPE /itetr/edf_bcode.

  SELECT-OPTIONS: s_gjahr FOR /itetr/edf_oldef-gjahr,
                  s_monat FOR /itetr/edf_oldef-monat.
SELECTION-SCREEN END OF BLOCK b1.

DATA:  lv_answer        TYPE c LENGTH 1.

lv_answer = /itetr/cl_edf_common=>popup_to_confirm_simple( iv_question = TEXT-002 ).
CHECK lv_answer = '1'.

DELETE FROM /itetr/edf_dfcll WHERE bukrs EQ p_bukrs AND
                                   bcode EQ p_bcode AND
                                   gjahr IN s_gjahr AND
                                   monat IN s_monat.

COMMIT WORK AND WAIT.
IF sy-subrc EQ 0.
  MESSAGE TEXT-003 TYPE 'S' DISPLAY LIKE 'S'.
ENDIF.