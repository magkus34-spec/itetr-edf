*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_LOG_NUM_SET_RANGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/edf_r_log_num_set_range MESSAGE-ID /itetr/edf_msg.

DATA: gt_interval LIKE inriv OCCURS 0 WITH HEADER LINE,
      gv_object   TYPE tnro-object VALUE '/ITETR/EDF',
      gs_error    TYPE inrer,
      gv_error    TYPE c LENGTH 1,
      gv_warnign  TYPE c LENGTH 1,
      gt_error    LIKE inriv OCCURS 0 WITH HEADER LINE.

START-OF-SELECTION.
  SELECT SINGLE COUNT(*)
    FROM nriv
   WHERE object    = '/ITETR/EDF'
     AND nrrangenr = '01'.
  IF sy-subrc EQ 0.
    MESSAGE i072.
    LEAVE PROGRAM.
  ENDIF.

END-OF-SELECTION.
  CLEAR gt_interval.
  gt_interval-nrrangenr  = '01'.
  gt_interval-fromnumber = '0000000001'.
  gt_interval-tonumber   = '9999999999'.
  gt_interval-procind    = 'I'.

  CALL FUNCTION 'NUMBER_RANGE_INTERVAL_UPDATE'
    EXPORTING
      object           = gv_object
      subobject        = space
    IMPORTING
      error            = gs_error
      error_occured    = gv_error
      warning_occured  = gv_warnign
    TABLES
      error_iv         = gt_error
      interval         = gt_interval
    EXCEPTIONS
      object_not_found = 1
      OTHERS           = 2.
  IF sy-subrc <> 0 OR gt_error[] IS NOT INITIAL.
    MESSAGE i073. "DISPLAY LIKE 'E'.
  ENDIF.

  CALL FUNCTION 'NUMBER_RANGE_UPDATE_CLOSE'
    EXPORTING
      object                 = gv_object
    EXCEPTIONS
      no_changes_made        = 1
      object_not_initialized = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE i073. "DISPLAY LIKE 'E'.
  ELSE.
    MESSAGE i073. "DISPLAY LIKE 'E'.
  ENDIF.

  LEAVE PROGRAM.