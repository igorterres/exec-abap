*&---------------------------------------------------------------------*
*& Include          ZR_CRUZAMENTOALV_I_TOP
*&---------------------------------------------------------------------*
CONSTANTS:gc_stat1 type string value 'CASADO',
          gc_stat2 type string value 'DIVERGENTE',
          gc_stat3 type string value 'HEADER_SEM_ITEM',
          gc_stat4 type string value 'ITEM_SEM_HEADER',
          gc_obs1  type string value 'Dentro do periodo de tolerancia ou valor correspondente',
          gc_obs2  type string value 'Fora do periodo de tolerancia ou nãol correspondente',
          gc_obs3  type string value 'Header sem nenhum item',
          gc_obs4  type string value 'Item sem nenhum header'.

DATA: go_salv_table type ref to cl_salv_table.

TABLES: ztb_c100_ff,
        ztb_c170_ff.

DATA: gt_header TYPE TABLE OF ztb_c100_ff,
      gt_item   TYPE TABLE OF ztb_c170_ff,
      gt_alv170 type table of zst_compalv_i,
      gt_alv100 type table of zst_resalv_i.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001. "modo do relatorio
  PARAMETERS: p_resu RADIOBUTTON GROUP gr1 DEFAULT 'X',
              p_detl RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK b01.
"for mais ou menos q nem o type

*tipos de arquivos mostrados na alv
SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-002. "geral
 PARAMETERS: p_todos  RADIOBUTTON GROUP g2 DEFAULT 'X',
             p_casado RADIOBUTTON GROUP g2,
             p_diverg RADIOBUTTON GROUP g2,
             p_semrel RADIOBUTTON GROUP g2.

 PARAMETERS: p_toler type p decimals 2 default '500.00',
             p_lim   type i default 35000.
SELECTION-SCREEN END OF BLOCK b02.

*oq é da header
SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-003. "header
  SELECT-OPTIONS: s_numdc  FOR ztb_c100_ff-num_doc,
                  s_data   FOR ztb_c100_ff-dt_doc,
                  s_parcro FOR ztb_c100_ff-cod_part,
                  s_modelo FOR ztb_c100_ff-cod_mod,
                  s_sitdoc FOR ztb_c100_ff-cod_sit.
SELECTION-SCREEN END OF BLOCK b03.

*oq é da item
SELECTION-SCREEN BEGIN OF BLOCK b04 WITH FRAME TITLE TEXT-004. "item
  SELECT-OPTIONS: s_cfop   FOR ztb_c170_ff-cfop,
                  s_mtrial FOR ztb_c170_ff-num_item,
                  s_csticm FOR ztb_c170_ff-cst_icms.
SELECTION-SCREEN END OF BLOCK b04.


*status relacionamento: dependente e tal
