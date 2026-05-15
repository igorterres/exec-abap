*&---------------------------------------------------------------------*
*& Include          ZR_CRUZAMENTOALV_I_F01
*&---------------------------------------------------------------------*

FORM filtro.
  IF p_resu = abap_true.
    IF p_todos = abap_true.
      RETURN.
    ELSE.
      IF p_CASADO = abap_true.
        DELETE gt_alv100 WHERE status_rel <> gc_stat1.
      ELSEIF p_diverg = abap_true.
        DELETE gt_alv100 WHERE status_rel <> gc_stat2.
      ELSE.
        p_semrel = abap_true.
        DELETE gt_alv100 WHERE status_rel <> gc_stat3 AND status_rel <> gc_stat4.
      ENDIF.
    ENDIF.
  ELSE.
    IF p_todos = abap_true.
      RETURN.
    ELSE.
      IF p_CASADO = abap_true.
        DELETE gt_alv170 WHERE status_rel <> gc_stat1.
      ELSEIF p_diverg = abap_true.
        DELETE gt_alv170 WHERE status_rel <> gc_stat2.
      ELSE.
        p_semrel = abap_true.
        DELETE gt_alv170 WHERE status_rel <> gc_stat3 AND status_rel <> gc_stat4.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM exibir_alv USING alv_table TYPE ANY TABLE.

  CALL METHOD cl_salv_table=>factory
*    EXPORTING
*      list_display   = if_salv_c_bool_sap=>false " ALV Displayed in List Mode
*      r_container    =                           " Abstract Container for GUI Controls
*      container_name =
    IMPORTING
      r_salv_table = go_salv_table                      " Basis Class Simple ALV Tables
    CHANGING
      t_table      = alv_table.


  IF go_salv_table IS BOUND.
    go_salv_table->display( ).
  ENDIF.


ENDFORM.

FORM pega_dados.


  IF p_resu = abap_true.

    " dados da c100
    SELECT *
      FROM ztb_c100_ff
      INTO TABLE gt_header
      UP TO p_lim ROWS
      WHERE num_doc  IN s_numdc  AND
            dt_doc   IN s_data   AND
            cod_part IN s_parcro AND
            cod_mod  IN s_modelo AND
            cod_sit  IN s_sitdoc.

    " dados da c170
    SELECT *
      FROM ztb_c170_ff
      INTO TABLE gt_item
      WHERE num_doc  IN s_numdc  AND
            cfop     IN s_cfop   AND
            num_item IN s_mtrial AND
            cst_icms IN s_csticm.

  ELSE.
    " dados da c100
    SELECT *
      FROM ztb_c100_ff
      INTO TABLE gt_header
      WHERE num_doc  IN s_numdc  AND
            dt_doc   IN s_data   AND
            cod_part IN s_parcro AND
            cod_mod  IN s_modelo AND
            cod_sit  IN s_sitdoc.

    " dados da c170
    SELECT *
      FROM ztb_c170_ff
      INTO TABLE gt_item
      UP TO p_lim ROWS
      WHERE num_doc  IN s_numdc  AND
          cfop     IN s_cfop   AND
          num_item IN s_mtrial AND
          cst_icms IN s_csticm.
  ENDIF.


ENDFORM.

FORM cruzamento.

  DATA: ls_header   TYPE ztb_c100_ff,
        ls_item     TYPE ztb_c170_ff,
        ls_item_aux TYPE ztb_c170_ff,
        ls_alv100   TYPE zst_resalv_i,
        ls_alv170   TYPE zst_compalv_i.

  DATA: lv_soma_item TYPE ztb_c170_ff-vl_item,
        lv_dif       TYPE p DECIMALS 2,
        lv_status    TYPE string..

  SORT gt_header BY num_doc.
  SORT gt_item   BY num_doc num_item.

  IF p_resu = abap_true.

    LOOP AT gt_header INTO ls_header.

      CLEAR: ls_alv100.

      ls_alv100-num_doc   = ls_header-num_doc.
      ls_alv100-dt_doc    = ls_header-dt_doc.
      ls_alv100-cod_part  = ls_header-cod_part.
      ls_alv100-cod_mod   = ls_header-cod_mod.
      ls_alv100-cod_sit   = ls_header-cod_sit.
      ls_alv100-vl_total  = ls_header-vl_doc.

      READ TABLE gt_item TRANSPORTING NO FIELDS
      WITH KEY num_doc = ls_header-num_doc
      BINARY SEARCH.
*    pega a gt_header, toca em ls_header (linha a linha)
*    quando pegar 1 linha, procure em gt_item se há algum num_doc
*    que corresponda a linha (ls_header)-num_doc
*    aqui o item pode ser casado ou divergente.
      IF sy-subrc = 0.
        CLEAR lv_soma_item.
        LOOP AT gt_item INTO ls_item where num_doc = ls_header-num_doc.
*          IF ls_item-num_doc <> ls_header-num_doc.
*            EXIT.
*          ENDIF.
          ls_alv100-quant = ls_alv100-quant + 1.
          lv_soma_item = lv_soma_item + ls_item-vl_item.
        ENDLOOP.

        ls_alv100-soma_IT = lv_soma_item.

*        trannsforma o numero em positivo.
        ls_alv100-dif_calc =  ls_header-vl_doc - ls_alv100-soma_it.
        IF ls_alv100-dif_calc < 0.
          ls_alv100-dif_calc = ls_alv100-dif_calc * -1.
        ENDIF.

        IF ls_alv100-dif_calc > p_toler.
          ls_alv100-status_rel = gc_stat2.
          ls_alv100-obs = gc_obs2.
        ELSE.
          ls_alv100-status_rel = gc_stat1.
          ls_alv100-obs = gc_obs1.
        ENDIF.

      ELSE.
        ls_alv100-quant = 0.
        ls_alv100-soma_it = 0.
        ls_alv100-dif_calc = ls_alv100-vl_total.
        ls_alv100-status_rel = gc_stat3.
        ls_alv100-obs = gc_obs3.
      ENDIF.

      APPEND ls_alv100 TO gt_alv100.
    ENDLOOP.

*    LOOP AT gt_item INTO ls_item.
*
*      READ TABLE gt_header TRANSPORTING NO FIELDS
*      WITH KEY num_doc = ls_item-num_doc
*      BINARY SEARCH.
*
*      IF sy-subrc <> 0.
*        READ TABLE gt_alv100 TRANSPORTING NO FIELDS
*        WITH KEY num_doc = ls_item-num_doc.
*
*        IF sy-subrc <> 0.
*          CLEAR ls_alv100.
*          ls_alv100-num_doc    = ls_item-num_doc.
*          ls_alv100-vl_total   = 0.
*          ls_alv100-quant      = 0.
*          ls_alv100-soma_it    = ls_item-vl_item.
*          ls_alv100-dif_calc   = ls_item-vl_item.
*          ls_alv100-status_rel = gc_stat4.
*          ls_alv100-obs        = gc_obs4.
*
*          APPEND ls_alv100 TO gt_alv100.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.

*    PERFORM exibir_alv USING gt_alv100.

  ELSE.
*    modo detalhado aqui.

    LOOP AT gt_item INTO ls_item.
      CLEAR ls_alv170.
*
*- número do documento;           num_doc//
*- data do documento;             dt_doc
*- parceiro;
*- modelo;                        cod_mod
*- situação;                      cod_sit
*- número do item;                Num_item
*- material;
*- descrição do item;             desc_compl
*- CFOP;                          cfop
*- CST ICMS;                      CST_ICMS
*- quantidade;                    QUANT
*- unidade;                       UNIDADE
*- valor do item;                 VL_ITEM
*- valor total do Header;         VL_HEADER
*- soma dos Itens do documento;   soma_it
*- diferença calculada;           dif_calc
*- status de relacionamento;      status_rel
*- observação da inconsistência.  obs

      ls_alv170-num_doc = ls_item-num_doc.
      ls_alv170-num_item = ls_item-num_item.
      ls_alv170-descr_compl = ls_item-descr_compl.
      ls_alv170-cfop = ls_item-cfop.
      ls_alv170-cst_icms = ls_item-cst_icms.
      ls_alv170-unidade = ls_item-unid.
      ls_alv170-quant = ls_item-qtd.
      ls_alv170-vl_item = ls_item-vl_item.

      READ TABLE gt_header INTO ls_header
      WITH KEY num_doc = ls_item-num_doc
      BINARY SEARCH.

      IF sy-subrc = 0.

        ls_alv170-vl_header = ls_header-vl_doc.
        ls_alv170-dt_doc = ls_header-dt_doc.
        ls_alv170-cod_part = ls_header-cod_part.
        ls_alv170-cod_mod = ls_header-cod_mod.
        ls_alv170-cod_sit = ls_header-cod_sit.

        CLEAR: lv_soma_item.

        LOOP AT gt_item INTO ls_item_aux
          WHERE num_doc = ls_header-num_doc.
          lv_soma_item = lv_soma_item + ls_item_aux-vl_item.
        ENDLOOP.

        ls_alv170-dif_calc = ls_header-vl_doc - lv_soma_item.
        IF  ls_alv170-dif_calc  < 0.
          ls_alv170-dif_calc = ls_alv170-dif_calc * -1.
        ENDIF.

        ls_alv170-soma_it = lv_soma_item.

        IF ls_alv170-dif_calc > p_toler.
          ls_alv170-status_rel = gc_stat2.
          ls_alv170-obs = gc_obs2.
        ELSE.
          ls_alv170-status_rel = gc_stat1.
          ls_alv170-obs = gc_obs1.
        ENDIF.

      ELSE.

        ls_alv170-soma_it = ls_item-vl_item.
        ls_alv170-dif_calc = ls_item-vl_item.
        ls_alv170-status_rel = gc_stat4.
        ls_alv170-obs = gc_obs4.
      ENDIF.
      APPEND ls_alv170 TO gt_alv170.

    ENDLOOP.
  ENDIF.

*  PERFORM exibir_alv USING gt_alv170.

ENDFORM.


FORM execute.
  PERFORM pega_dados.
  PERFORM cruzamento.
  PERFORM filtro.

  IF p_resu = abap_true.
    PERFORM exibir_alv USING gt_alv100.
  ELSE.
    PERFORM exibir_alv USING gt_alv170.
  ENDIF.

ENDFORM.
