*&---------------------------------------------------------------------*
*& Include          ZR_EXECWAG_I_TOP
*&---------------------------------------------------------------------*

TABLES: ztb_c100_i,
        ztb_c170_i.

CONSTANTS: gc_sterro type string  value 'Erro',
           gc_msgerro1 type string value 'Erro conversão',
           gc_msgerro2 type string value 'Erro - campo vazio',
           gc_stbom type string value 'Sucesso',
           gc_msgbom type string value 'OK'.

"declarar as variaveizinhas uhuu
DATA: lt_recebe_caminho_arquivo  TYPE filetable.

DATA: go_salv_table TYPE REF TO cl_salv_table. "para o alv

DATA: gt_c100   TYPE TABLE OF ztb_c100_i,
      gt_c170   TYPE TABLE OF ztb_c170_i,
      gt_dados  TYPE STANDARD TABLE OF string,
      gt_log100 TYPE TABLE OF zst_header_ff,
      gt_log170 TYPE TABLE OF zst_item_ff.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_radio1 RADIOBUTTON GROUP gr1 DEFAULT 'X',
              p_radio2 RADIOBUTTON GROUP gr1.

  PARAMETERS: p_caminh TYPE rlgrap-filename.

  PARAMETERs:  p_cx_del AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK bl1.
