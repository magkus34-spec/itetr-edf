*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_INVOICE_DATA_TRF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/edf_r_invoice_data_trf.

TYPE-POOLS:slis,esp1,truxs.

DATA: gt_data     TYPE TABLE OF string WITH HEADER LINE.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_path LIKE rlgrap-filename OBLIGATORY.

PARAMETERS: p1 TYPE c LENGTH 40,
            p2 TYPE c LENGTH 30,
            p3 TYPE c LENGTH 100.
SELECTION-SCREEN: END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.
  PERFORM get_file_path.

START-OF-SELECTION.
  PERFORM upload_master_data.

END-OF-SELECTION.
  PERFORM call_id.
*&---------------------------------------------------------------------*
*&      Form  GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_file_path .
  DATA : lv_subrc LIKE sy-subrc,
         lt_path  TYPE filetable.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title     = 'Select Source Text File'
      default_filename = '*.txt'
      multiselection   = ' '
    CHANGING
      file_table       = lt_path
      rc               = lv_subrc.

  LOOP AT lt_path INTO p_path.
  ENDLOOP.
ENDFORM.                    " GET_FILE_PATH
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM upload_master_data .

  DATA: lv_filename TYPE string.

  lv_filename = p_path.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_filename
    TABLES
      data_tab                = gt_data
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  CHECK sy-subrc EQ 0.
ENDFORM.                    " UPLOAD_EXCEL
*&---------------------------------------------------------------------*
*&      Form  CALL_ID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM call_id .
  DATA: lv_program  TYPE c LENGTH 100,
        lv_message  TYPE string,
        lv_sid      TYPE string,
        lv_formname TYPE c LENGTH 50,
        lv_subrc    LIKE sy-subrc.

  FREE MEMORY ID '/ITETR/EDF_GET_DATA'.
  EXPORT p1 p2 p3 TO MEMORY ID '/ITETR/EDF_GET_DATA'.

  GENERATE SUBROUTINE
                 POOL gt_data
                 NAME lv_program
              MESSAGE lv_message
         SHORTDUMP-ID lv_sid.

  IF lv_program IS NOT INITIAL.
    PERFORM p1 IN PROGRAM (lv_program) IF FOUND.
  ELSE.
    WRITE:/ 'Error ocurred', lv_message.
  ENDIF.
ENDFORM.