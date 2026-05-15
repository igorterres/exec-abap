*&---------------------------------------------------------------------*
*& Include          ZR_EXECWAG_I_F01
*&---------------------------------------------------------------------*
FORM display_alv100.

  CALL METHOD cl_salv_table=>factory
*    EXPORTING
*      list_display   = if_salv_c_bool_sap=>false " ALV Displayed in List Mode
*      r_container    =                           " Abstract Container for GUI Controls
*      container_name =
    IMPORTING
      r_salv_table = go_salv_table                        " Basis Class Simple ALV Tables
    CHANGING
      t_table      = gt_log100.


  IF go_salv_table IS BOUND.
    go_salv_table->display( ).
  ENDIF.

ENDFORM.

FORM display_alv170.

  CALL METHOD cl_salv_table=>factory
*    EXPORTING
*      list_display   = if_salv_c_bool_sap=>false " ALV Displayed in List Mode
*      r_container    =                           " Abstract Container for GUI Controls
*      container_name =
    IMPORTING
      r_salv_table = go_salv_table                        " Basis Class Simple ALV Tables
    CHANGING
      t_table      = gt_log170.


  IF go_salv_table IS BOUND.
    go_salv_table->display( ).
  ENDIF.

ENDFORM.

FORM botao_deletar.
  IF p_cx_del = abap_true.
    IF p_radio1 = abap_true.
      DELETE FROM ztb_c100_i.
    ELSE.
      DELETE FROM ztb_c170_i.
    ENDIF.
  ENDIF.
ENDFORM.

FORM abre_janela_p_pegar_o_csv.
  "usar gui_upload

  DATA: lv_rc                     TYPE i,
        ls_recebe_caminho_arquivo LIKE LINE OF lt_recebe_caminho_arquivo.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title = 'Importar arquivo CSV'                " nome da janela
*     default_extension       =                  " Default Extension
*     default_filename        =                  " Default File Name
*     file_filter  = 'CSV Files (*.csv)|*.csv'              " tipo de arquivo aceito: Descrição (Padrão)|Padrão
*     with_encoding           =                  " File Encoding
*     initial_directory       =                  " Initial Directory
*     multiselection          =                  " Multiple selections poss.
    CHANGING
      file_table   = lt_recebe_caminho_arquivo    "o qual o usuario que indica " Table Holding Selected Files
      rc           = lv_rc               " Return Code, Number of Files or -1 If Error Occurred
*     user_action  =                  " User Action (See Class Constants ACTION_OK, ACTION_CANCEL)
*     file_encoding           =
*    EXCEPTIONS
*     file_open_dialog_failed = 1                " "Open File" dialog failed
*     cntl_error   = 2                " Control error
*     error_no_gui = 3                " No GUI available
*     not_supported_by_gui    = 4                " GUI does not support this
*     others       = 5
    .
  IF sy-subrc = 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    READ TABLE lt_recebe_caminho_arquivo  INTO ls_recebe_caminho_arquivo  INDEX 1. "pega o nome da primeira linha do arquivo, poe na estrutura
    p_caminh = ls_recebe_caminho_arquivo-filename. "pega a coluninha filename
  ELSE.
    MESSAGE 'Erro ao importar dados' TYPE 'E'.
  ENDIF.


ENDFORM.

FORM salvarc100.

  INSERT ztb_c100_i FROM TABLE gt_c100.

  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE 'Sucesso ao importar dados' TYPE 'S'.
  ELSE.
    MESSAGE 'Erro ao salvar arquivos' TYPE 'E'.
    ROLLBACK WORK.

  ENDIF.

ENDFORM.

FORM salvarc170.

  INSERT ztb_c170_i FROM TABLE gt_c170.

  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE 'Sucesso ao importar dados' TYPE 'S'.
  ELSE.
    MESSAGE 'Erro ao salvar arquivos' TYPE 'E'.
    ROLLBACK WORK.

  ENDIF.

ENDFORM.

FORM c100_processo USING is_string TYPE zst_string_ff.
  DATA ls_c100_quase TYPE ztb_c100_i.
  DATA  ls_plog_100 TYPE zst_header_ff.
  DATA(ls_string) = is_string.
  DATA: lv_data_min TYPE ztb_c100_i-dt_doc,
        lv_data_max TYPE ztb_c100_i-dt_doc.

  CLEAR ls_c100_quase.
  CLEAR ls_plog_100.

  lv_data_min = '19700101'.
  lv_data_max = '20270101'.


  ls_plog_100-usuario = sy-uname.
  ls_plog_100-data = sy-datum.
  ls_plog_100-hora = sy-uzeit.

  "textos de sucesso
  ls_plog_100-status = gc_stbom.
  ls_plog_100-mensagem = gc_msgbom.

  IF is_string-campo1 IS NOT INITIAL AND
     is_string-campo7 IS NOT INITIAL.

    ls_plog_100-reg           = is_string-campo1.
    ls_plog_100-ind_oper      = is_string-campo2.
    ls_plog_100-ind_emit      = is_string-campo3.
    ls_plog_100-cod_part      = is_string-campo4.
    ls_plog_100-cod_mod       = is_string-campo5.
    ls_plog_100-cod_sit       = is_string-campo6.
    ls_plog_100-num_doc       = is_string-campo7.
    ls_plog_100-dt_doc        = is_string-campo8.
    ls_plog_100-dt_e_s        = is_string-campo9.
    ls_plog_100-vl_doc        = is_string-campo10.
    ls_plog_100-ind_pgto      = is_string-campo11.
    ls_plog_100-ind_frt       = is_string-campo12.
    ls_plog_100-chv_nfe       = is_string-campo13.
    ls_plog_100-ser           = is_string-campo14.
    ls_plog_100-vl_desc       = is_string-campo15.
    ls_plog_100-vl_abat_nt    = is_string-campo16.
    ls_plog_100-vl_merc       = is_string-campo17.
    ls_plog_100-vl_frt        = is_string-campo18.
    ls_plog_100-vl_seg        = is_string-campo19.
    ls_plog_100-vl_out_da     = is_string-campo20.
    ls_plog_100-vl_bc_icms    = is_string-campo21.
    ls_plog_100-vl_icms       = is_string-campo22.
    ls_plog_100-vl_bc_icms_st = is_string-campo23.
    ls_plog_100-vl_icms_st    = is_string-campo24.
    ls_plog_100-vl_ipi        = is_string-campo25.
    ls_plog_100-vl_pis        = is_string-campo26.
    ls_plog_100-vl_cofins     = is_string-campo27.
    ls_plog_100-vl_pis_st     = is_string-campo28.
    ls_plog_100-vl_cofins_st  = is_string-campo29.

    DATA(lv_ano) = is_string-campo8+4(4).
    DATA(lv_mes) = is_string-campo8+2(2).
    DATA(lv_dia) = is_string-campo8(2).

    CONCATENATE lv_ano lv_mes lv_dia INTO DATA(lv_datacerta).

    ls_plog_100-dt_doc = lv_datacerta.

    lv_ano = is_string-campo9+4(4).
    lv_mes = is_string-campo9+2(2).
    lv_dia = is_string-campo9(2).

    CONCATENATE lv_ano lv_mes lv_dia INTO lv_datacerta.

    ls_plog_100-dt_e_s = lv_datacerta.

    IF ( ls_plog_100-dt_doc NOT BETWEEN lv_data_min AND lv_data_max ) OR ( ls_plog_100-dt_e_s NOT BETWEEN lv_data_min AND lv_data_max ).
      ls_plog_100-status = gc_sterro.
      ls_plog_100-mensagem = 'Data Invalida'.
      APPEND ls_plog_100 TO gt_log100.

    ELSEIF ls_plog_100-ind_oper <> '1' AND ls_plog_100-ind_oper <> '0'.
      ls_plog_100-status = gc_sterro.
      ls_plog_100-mensagem = gc_msgerro2.
      APPEND ls_plog_100 TO gt_log100.

    ELSEIF ls_plog_100-ind_emit <> '1' AND ls_plog_100-ind_emit <> '0'.
      ls_plog_100-status = gc_sterro.
      ls_plog_100-mensagem = gc_msgerro2.
      APPEND ls_plog_100 TO gt_log100.

    ELSEIF ls_plog_100-ind_pgto <> '1' AND ls_plog_100-ind_pgto <> '0' AND
       ls_plog_100-ind_pgto <> '2' AND ls_plog_100-ind_pgto <> '9'.
      ls_plog_100-status = gc_sterro.
      ls_plog_100-mensagem = gc_msgerro2.
      APPEND ls_plog_100 TO gt_log100.

    ELSEIF ls_plog_100-ind_frt <> '1' AND ls_plog_100-ind_frt <> '0' AND
       ls_plog_100-ind_frt <> '2' AND ls_plog_100-ind_frt <> '3' AND
       ls_plog_100-ind_frt <> '4' AND ls_plog_100-ind_frt <> '9'.
      ls_plog_100-status = gc_sterro.
      ls_plog_100-mensagem = gc_msgerro2.
      APPEND ls_plog_100 TO gt_log100.
    ENDIF.

    IF ls_plog_100-status <> gc_sterro.

      TRY.
          ls_c100_quase-reg           = is_string-campo1.
          ls_c100_quase-ind_oper      = is_string-campo2.
          ls_c100_quase-ind_emit      = is_string-campo3.
          ls_c100_quase-cod_part      = is_string-campo4.
          ls_c100_quase-cod_mod       = is_string-campo5.
          ls_c100_quase-cod_sit       = is_string-campo6.
          ls_c100_quase-num_doc       = is_string-campo7.
          ls_c100_quase-dt_doc        = is_string-campo8.
          ls_c100_quase-dt_e_s        = is_string-campo9.
          ls_c100_quase-vl_doc        = is_string-campo10.
          ls_c100_quase-ind_pgto      = is_string-campo11.
          ls_c100_quase-ind_frt       = is_string-campo12.
          ls_c100_quase-chv_nfe       = is_string-campo13.
          ls_c100_quase-ser           = is_string-campo14.
          ls_c100_quase-vl_desc       = is_string-campo15.
          ls_c100_quase-vl_abat_nt    = is_string-campo16.
          ls_c100_quase-vl_merc       = is_string-campo17.
          ls_c100_quase-vl_frt        = is_string-campo18.
          ls_c100_quase-vl_seg        = is_string-campo19.
          ls_c100_quase-vl_out_da     = is_string-campo20.
          ls_c100_quase-vl_bc_icms    = is_string-campo21.
          ls_c100_quase-vl_icms       = is_string-campo22.
          ls_c100_quase-vl_bc_icms_st = is_string-campo23.
          ls_c100_quase-vl_icms_st    = is_string-campo24.
          ls_c100_quase-vl_ipi        = is_string-campo25.
          ls_c100_quase-vl_pis        = is_string-campo26.
          ls_c100_quase-vl_cofins     = is_string-campo27.
          ls_c100_quase-vl_pis_st     = is_string-campo28.
          ls_c100_quase-vl_cofins_st  = is_string-campo29.

          APPEND ls_c100_quase TO gt_c100.
          APPEND ls_plog_100 TO gt_log100.

        CATCH cx_sy_conversion_error INTO DATA(lo_error).
          ls_plog_100-status = gc_sterro.
          ls_plog_100-mensagem = gc_msgerro2.
          APPEND ls_plog_100 TO gt_log100.

      ENDTRY.
    ENDIF.

  ENDIF.
ENDFORM.

FORM c170_processo USING is_string TYPE zst_string_ff.
  DATA ls_c170_quase TYPE ztb_c170_i.
  DATA ls_plog_170 TYPE zst_item_ff.
  DATA(ls_string) = is_string.
  CLEAR ls_c170_quase.
  CLEAR ls_plog_170.

  ls_plog_170-usuario = sy-uname.
  ls_plog_170-data = sy-datum.
  ls_plog_170-hora = sy-uzeit.

  ls_plog_170-status = gc_stbom.
  ls_plog_170-mensagem = gc_msgbom.

  IF is_string-campo1 IS NOT INITIAL AND
    is_string-campo7 IS NOT INITIAL.

    ls_plog_170-reg               = is_string-campo1.
    ls_plog_170-num_item          = is_string-campo2.
    ls_plog_170-cod_item          = is_string-campo3.
    ls_plog_170-vl_item           = is_string-campo4.
    ls_plog_170-cfop              = is_string-campo5.
    ls_plog_170-cst_pis           = is_string-campo6.
    ls_plog_170-cst_cofins        = is_string-campo7.
    ls_plog_170-num_doc           = is_string-campo8.
    ls_plog_170-descr_compl       = is_string-campo9.
    ls_plog_170-qtd               = is_string-campo10.
    ls_plog_170-unid              = is_string-campo11.
    ls_plog_170-vl_desc           = is_string-campo12.
    ls_plog_170-ind_mov           = is_string-campo13.
    ls_plog_170-cst_icms          = is_string-campo14.
    ls_plog_170-cod_nat           = is_string-campo15.
    ls_plog_170-vl_bc_icms        = is_string-campo16.
    ls_plog_170-aliq_icms         = is_string-campo17.
    ls_plog_170-vl_icms           = is_string-campo18.
    ls_plog_170-vl_bc_icms_st     = is_string-campo19.
    ls_plog_170-aliq_st           = is_string-campo20.
    ls_plog_170-vl_icms_st        = is_string-campo21.
    ls_plog_170-ind_apur          = is_string-campo22.
    ls_plog_170-cst_ipi           = is_string-campo23.
    ls_plog_170-cod_enq           = is_string-campo24.
    ls_plog_170-vl_bc_ipi         = is_string-campo25.
    ls_plog_170-aliq_ipi          = is_string-campo26.
    ls_plog_170-vl_ipi            = is_string-campo27.
    ls_plog_170-vl_bc_pis         = is_string-campo28.
    ls_plog_170-aliq_pis          = is_string-campo29.
    ls_plog_170-quant_bc_pis      = is_string-campo30.
    ls_plog_170-aliq_pis_quant    = is_string-campo31.
    ls_plog_170-vl_pis            = is_string-campo32.
    ls_plog_170-vl_bc_cofins      = is_string-campo33.
    ls_plog_170-aliq_cofins       = is_string-campo34.
    ls_plog_170-quant_bc_cofins   = is_string-campo35.
    ls_plog_170-aliq_cofins_quant = is_string-campo36.
    ls_plog_170-vl_cofins         = is_string-campo37.
    ls_plog_170-cod_cta           = is_string-campo38.

    IF ls_plog_170-ind_mov <> '1' AND ls_plog_170-ind_mov <> '0'.
      ls_plog_170-status = gc_sterro.
      ls_plog_170-mensagem = gc_msgerro2.
      APPEND ls_plog_170 TO gt_log170.

    ELSEIF ls_plog_170-ind_apur <> '1' AND ls_plog_170-ind_apur <> '0'.
      ls_plog_170-status = gc_sterro.
      ls_plog_170-mensagem = gc_msgerro2.
      APPEND ls_plog_170 TO gt_log170.
    ENDIF.

    IF ls_plog_170-status <> gc_sterro.

      TRY.
          ls_c170_quase-reg               = is_string-campo1.
          ls_c170_quase-num_item          = is_string-campo2.
          ls_c170_quase-cod_item          = is_string-campo3.
          ls_c170_quase-vl_item           = is_string-campo4.
          ls_c170_quase-cfop              = is_string-campo5.
          ls_c170_quase-cst_pis           = is_string-campo6.
          ls_c170_quase-cst_cofins        = is_string-campo7.
          ls_c170_quase-num_doc           = is_string-campo8.
          ls_c170_quase-descr_compl       = is_string-campo9.
          ls_c170_quase-qtd               = is_string-campo10.
          ls_c170_quase-unid              = is_string-campo11.
          ls_c170_quase-vl_desc           = is_string-campo12.
          ls_c170_quase-ind_mov           = is_string-campo13.
          ls_c170_quase-cst_icms          = is_string-campo14.
          ls_c170_quase-cod_nat           = is_string-campo15.
          ls_c170_quase-vl_bc_icms        = is_string-campo16.
          ls_c170_quase-aliq_icms         = is_string-campo17.
          ls_c170_quase-vl_icms           = is_string-campo18.
          ls_c170_quase-vl_bc_icms_st     = is_string-campo19.
          ls_c170_quase-aliq_st           = is_string-campo20.
          ls_c170_quase-vl_icms_st        = is_string-campo21.
          ls_c170_quase-ind_apur          = is_string-campo22.
          ls_c170_quase-cst_ipi           = is_string-campo23.
          ls_c170_quase-cod_enq           = is_string-campo24.
          ls_c170_quase-vl_bc_ipi         = is_string-campo25.
          ls_c170_quase-aliq_ipi          = is_string-campo26.
          ls_c170_quase-vl_ipi            = is_string-campo27.
          ls_c170_quase-vl_bc_pis         = is_string-campo28.
          ls_c170_quase-aliq_pis          = is_string-campo29.
          ls_c170_quase-quant_bc_pis      = is_string-campo30.
          ls_c170_quase-aliq_pis_quant    = is_string-campo31.
          ls_c170_quase-vl_pis            = is_string-campo32.
          ls_c170_quase-vl_bc_cofins      = is_string-campo33.
          ls_c170_quase-aliq_cofins       = is_string-campo34.
          ls_c170_quase-quant_bc_cofins   = is_string-campo35.
          ls_c170_quase-aliq_cofins_quant = is_string-campo36.
          ls_c170_quase-vl_cofins         = is_string-campo37.
          ls_c170_quase-cod_cta           = is_string-campo38.

          APPEND ls_c170_quase TO gt_c170.
          APPEND ls_plog_170 TO gt_log170.

        CATCH cx_sy_conversion_error INTO DATA(lo_error).
          ls_plog_170-status = gc_sterro.
          ls_plog_170-mensagem = gc_msgerro2.

          APPEND ls_plog_170 TO gt_log170.
      ENDTRY.
    ENDIF.
  ENDIF.


ENDFORM.


" FAZER UPLOAD, PEGAR OS DADOS E SALVAR NA ESTRUTURA ----------------------------------------------------------------------------------------------
FORM upload.

  DATA lv_arqv TYPE string.
  lv_arqv = CONV string( p_caminh ). "o pfile ta em char, e pra processar precisa converter p string



  DATA ls_string TYPE zst_string_ff.


  cl_gui_frontend_services=>gui_upload(
    EXPORTING
      filename                = lv_arqv          " Name of file
      filetype                = 'ASC'            " File Type (ASCII, Binary)
      has_field_separator     = ';'              " pq csv separa no ;
*      header_length           = 0                " Length of Header for Binary Data
*      read_by_line            = 'X'              " File Written Line-By-Line to the Internal Table
*      dat_mode                = space            " Numeric and date fields are in DAT format in WS_DOWNLOAD
*      codepage                =                  " Character Representation for Output
*      ignore_cerr             = abap_true        " Ignore character set conversion errors?
*      replacement             = '#'              " Replacement Character for Non-Convertible Characters
*      virus_scan_profile      =                  " Virus Scan Profile
*    IMPORTING
*      filelength              =                  " File Length
*      header                  =                  " File Header in Case of Binary Upload
    CHANGING
      data_tab                =  gt_dados                " Transfer table for file contents
*      isscanperformed         = space            " File already scanned
    EXCEPTIONS
      file_open_error         = 1                " File does not exist and cannot be opened
      file_read_error         = 2                " Error when reading file
      no_batch                = 3                " Front-End Function Cannot Be Executed in Backgrnd
      gui_refuse_filetransfer = 4                " Incorrect front end or error on front end
      invalid_type            = 5                " Incorrect parameter FILETYPE
      no_authority            = 6                " No Upload Authorization
      unknown_error           = 7                " Unknown error
      bad_data_format         = 8                " Cannot Interpret Data in File
      header_not_allowed      = 9                " Invalid header
      separator_not_allowed   = 10               " Invalid separator
      header_too_long         = 11               " Header information currently restricted to 1023 bytes
      unknown_dp_error        = 12               " Error when calling data provider
      access_denied           = 13               " Access to File Denied
      dp_out_of_memory        = 14               " Not Enough Memory in DataProvider
      disk_full               = 15               " Storage Medium full
      dp_timeout              = 16               " Timeout of DataProvider
      not_supported_by_gui    = 17               " GUI does not support this
      error_no_gui            = 18               " GUI not available
      OTHERS                  = 19
  ).
  IF sy-subrc = 0.
    LOOP  AT gt_dados ASSIGNING FIELD-SYMBOL(<fs_linha>). "passar os dados p estrutura
      IF <fs_linha> IS ASSIGNED.
        IF sy-tabix > 1.
          SPLIT <fs_linha> AT ';' INTO TABLE DATA(lt_quase_pronta).


          IF lt_quase_pronta IS NOT INITIAL.
            CLEAR: ls_string.

            ls_string-campo1  = VALUE #( lt_quase_pronta[ 1  ] OPTIONAL ).
            ls_string-campo2  = VALUE #( lt_quase_pronta[ 2  ] OPTIONAL ).
            ls_string-campo3  = VALUE #( lt_quase_pronta[ 3  ] OPTIONAL ).
            ls_string-campo4  = VALUE #( lt_quase_pronta[ 4  ] OPTIONAL ).
            ls_string-campo5  = VALUE #( lt_quase_pronta[ 5  ] OPTIONAL ).
            ls_string-campo6  = VALUE #( lt_quase_pronta[ 6  ] OPTIONAL ).
            ls_string-campo7  = VALUE #( lt_quase_pronta[ 7  ] OPTIONAL ).
            ls_string-campo8  = VALUE #( lt_quase_pronta[ 8  ] OPTIONAL ).
            ls_string-campo9  = VALUE #( lt_quase_pronta[ 9  ] OPTIONAL ).
            ls_string-campo10 = VALUE #( lt_quase_pronta[ 10 ] OPTIONAL ).
            ls_string-campo11 = VALUE #( lt_quase_pronta[ 11 ] OPTIONAL ).
            ls_string-campo12 = VALUE #( lt_quase_pronta[ 12 ] OPTIONAL ).
            ls_string-campo13 = VALUE #( lt_quase_pronta[ 13 ] OPTIONAL ).
            ls_string-campo14 = VALUE #( lt_quase_pronta[ 14 ] OPTIONAL ).
            ls_string-campo15 = VALUE #( lt_quase_pronta[ 15 ] OPTIONAL ).
            ls_string-campo16 = VALUE #( lt_quase_pronta[ 16 ] OPTIONAL ).
            ls_string-campo17 = VALUE #( lt_quase_pronta[ 17 ] OPTIONAL ).
            ls_string-campo18 = VALUE #( lt_quase_pronta[ 18 ] OPTIONAL ).
            ls_string-campo19 = VALUE #( lt_quase_pronta[ 19 ] OPTIONAL ).
            ls_string-campo20 = VALUE #( lt_quase_pronta[ 20 ] OPTIONAL ).
            ls_string-campo21 = VALUE #( lt_quase_pronta[ 21 ] OPTIONAL ).
            ls_string-campo22 = VALUE #( lt_quase_pronta[ 22 ] OPTIONAL ).
            ls_string-campo23 = VALUE #( lt_quase_pronta[ 23 ] OPTIONAL ).
            ls_string-campo24 = VALUE #( lt_quase_pronta[ 24 ] OPTIONAL ).
            ls_string-campo25 = VALUE #( lt_quase_pronta[ 25 ] OPTIONAL ).
            ls_string-campo26 = VALUE #( lt_quase_pronta[ 26 ] OPTIONAL ).
            ls_string-campo27 = VALUE #( lt_quase_pronta[ 27 ] OPTIONAL ).
            ls_string-campo28 = VALUE #( lt_quase_pronta[ 28 ] OPTIONAL ).
            ls_string-campo29 = VALUE #( lt_quase_pronta[ 29 ] OPTIONAL ).
            ls_string-campo30 = VALUE #( lt_quase_pronta[ 30 ] OPTIONAL ).
            ls_string-campo31 = VALUE #( lt_quase_pronta[ 31 ] OPTIONAL ).
            ls_string-campo32 = VALUE #( lt_quase_pronta[ 32 ] OPTIONAL ).
            ls_string-campo33 = VALUE #( lt_quase_pronta[ 33 ] OPTIONAL ).
            ls_string-campo34 = VALUE #( lt_quase_pronta[ 34 ] OPTIONAL ).
            ls_string-campo35 = VALUE #( lt_quase_pronta[ 35 ] OPTIONAL ).
            ls_string-campo36 = VALUE #( lt_quase_pronta[ 36 ] OPTIONAL ).
            ls_string-campo37 = VALUE #( lt_quase_pronta[ 37 ] OPTIONAL ).
            ls_string-campo38 = VALUE #( lt_quase_pronta[ 38 ] OPTIONAL ).
            ls_string-campo39 = VALUE #( lt_quase_pronta[ 39 ] OPTIONAL ).
            ls_string-campo40 = VALUE #( lt_quase_pronta[ 40 ] OPTIONAL ).

          ENDIF.
          IF p_radio1 = abap_true.
            PERFORM c100_processo USING ls_string.
          ELSE.
            PERFORM c170_processo USING ls_string.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.



  ENDIF.

ENDFORM.


" FORM PARA EXECUTAR AS COISAS ----------------------------------------------------------------------------------------------
FORM execute.
  PERFORM botao_deletar.
  PERFORM upload.
  IF p_radio1 = abap_true.
    PERFORM salvarc100.
    PERFORM display_alv100.
  ELSE.
    PERFORM salvarc170.
    PERFORM display_alv170.
  ENDIF.
  WRITE ':)'.

ENDFORM.
