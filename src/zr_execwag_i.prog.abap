*&---------------------------------------------------------------------*
*& Report ZR_EXECWAG_I
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_execwag_i.

INCLUDE zr_execwag_i_TOP.
INCLUDE ZR_execwag_I_f01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_caminh. "quadradinho de ajuda de pesquisa
  PERFORM abre_janela_p_pegar_o_csv.

START-OF-SELECTION.

  PERFORM execute.
