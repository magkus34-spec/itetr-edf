*&---------------------------------------------------------------------*
*& Report /ITETR/EDF_R_MID_TERM_LAST_P
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/edf_r_mid_term_last_p MESSAGE-ID /itetr/edf_msg.

DATA: gs_200   LIKE /itetr/edf_oldef,
      gs_202   LIKE /itetr/edf_defcl,
      gv_datab LIKE /itetr/edf_oldef-datab,
      gv_datbi LIKE /itetr/edf_oldef-datbi.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_bukrs  LIKE /itetr/edf_oldef-bukrs OBLIGATORY,
              p_bcode  LIKE /itetr/edf_oldef-bcode,
              p_gjahr  LIKE /itetr/edf_oldef-gjahr OBLIGATORY,
              p_monat  LIKE /itetr/edf_oldef-monat OBLIGATORY,
              p_parno  LIKE /itetr/edf_oldef-parno OBLIGATORY,
              p_eyevno LIKE /itetr/edf_oldef-eyevno OBLIGATORY,
              p_elinen LIKE /itetr/edf_oldef-elinen OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  SELECT SINGLE COUNT(*)
    FROM /itetr/edf_oldef
   WHERE bukrs = p_bukrs.
  IF sy-subrc EQ 0.
    DATA lv_message TYPE bapi_msg.
    DATA lv_answer TYPE c.
    MESSAGE s098 INTO lv_message.
    CONCATENATE lv_message TEXT-002 INTO lv_message SEPARATED BY space.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        text_question  = lv_message
        default_button = '2'
      IMPORTING
        answer         = lv_answer
      EXCEPTIONS
        text_not_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0 OR lv_answer <> '1'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.

  SELECT SINGLE COUNT(*)
    FROM /itetr/edf_sbblg
   WHERE bukrs = p_bukrs.
  IF sy-subrc EQ 0 AND p_bcode IS INITIAL.
    MESSAGE s009 DISPLAY LIKE 'E' WITH p_bukrs.
    LEAVE LIST-PROCESSING.
  ENDIF.

  AUTHORITY-CHECK OBJECT 'F_BKPF_BUK'
           ID 'BUKRS' FIELD p_bukrs
           ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE s000(/itetr/edf_msg) WITH p_bukrs DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  SELECT SINGLE COUNT(*)
    FROM /itetr/edf_dopvr
   WHERE bukrs = p_bukrs
     AND bcode = p_bcode
     AND chktb = 'X'.
  IF sy-subrc EQ 0.
    AUTHORITY-CHECK
             OBJECT 'S_TABU_DIS'
                 ID 'DICBERCLS' FIELD 'YIDL'
                 ID 'ACTVT'     FIELD '02'.
    MESSAGE i106 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

END-OF-SELECTION.
  CLEAR: gs_200,gs_202.

  CONCATENATE p_gjahr p_monat '01' INTO gv_datab.

  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = gv_datab
    IMPORTING
      last_day_of_month = gv_datbi
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.
  IF sy-subrc NE 0.
  ENDIF.

  gs_200-bukrs  = p_bukrs.
  gs_200-gjahr  = p_gjahr.
  gs_200-monat  = p_monat.
  gs_200-datbi  = gv_datbi.
  gs_200-partn  = '000000'.
  gs_200-parno  = p_parno.
  gs_200-datab  = gv_datab.
  gs_200-syevno = '0000000001'.
  gs_200-eyevno = p_eyevno.
  gs_200-slinen = '0000000001'.
  gs_200-elinen = p_elinen.
  gs_200-debit  = 1.
  gs_200-credit = 1.
  gs_200-pdatab = gv_datab.
  gs_200-pdatbi = gv_datbi.
  gs_200-serok  = 'X'.
  gs_200-yevok  = 'X'.
  gs_200-yvbok  = 'X'.
  gs_200-kebok  = 'X'.
  gs_200-kbbok  = 'X'.
  gs_200-gbyok  = 'X'.
  gs_200-gbkok  = 'X'.
  gs_200-derok  = 'X'.
  gs_200-erdat  = sy-datum.
  gs_200-erzet  = sy-uzeit.
  gs_200-ernam  = sy-uname.
  INSERT /itetr/edf_oldef FROM gs_200.
  COMMIT WORK AND WAIT.

  gs_202-bukrs = p_bukrs.
  gs_202-gjahr = p_gjahr.
  gs_202-monat = p_monat.
  gs_202-ernam = sy-uname.
  gs_202-erdat = sy-datum.
  gs_202-erzet = sy-uzeit.
  gs_202-elprc = 'X'.
  gs_202-jbnlc = 'GET_LED_DATA'.
  gs_202-jbclc = '10000001'.
  gs_202-stldr = 'X'.
  gs_202-etldr = 'X'.
  gs_202-jbnld = 'SET_PARTIAL'.
  gs_202-jbcld = '10000001'.
  gs_202-stsds = 'X'.
  gs_202-etsds = 'X'.
  gs_202-jbnsd = 'SEND_SERV'.
  gs_202-jbcsd = '10000001'.
  gs_202-sgbsn = 'X'.
  gs_202-egbsn = 'X'.
  gs_202-jbngb = 'SEND_GIB'.
  gs_202-jbcgb = '10000001'.
  INSERT /itetr/edf_defcl FROM gs_202.
  COMMIT WORK AND WAIT.

  MESSAGE s099.