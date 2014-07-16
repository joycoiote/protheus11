/*
+------------------------------------------------------------------------------------------------------------------+
!                                                FICHA TECNICA DO PROGRAMA                                         !
+------------------------------------------------------------------------------------------------------------------+
!                                                   DADOS DO PROGRAMA                                              !
+------------------+-----------------------------------------------------------------------------------------------+
!Modulo            ! Ponto de Entrada FA080CHK - Valida��o baixas a pagar manual                                   !
!                  !                                                                                               !
+------------------+-----------------------------------------------------------------------------------------------+
!Nome              ! FA080CHK.PRW                                                                                  !
+------------------+-----------------------------------------------------------------------------------------------+
!Descricao         ! O ponto de entrada FA080CHK e acionado antes de carregar a tela de baixa do contas a pagar    +
+------------------+-----------------------------------------------------------------------------------------------+
!Autor             ! Edenilson Santos                                                                              !
+------------------+-----------------------------------------------------------------------------------------------+
!Data de Criacao   ! 17/05/2013                                                                                    !
+------------------+-----------------------------------------------------------------------------------------------+
!                                                   ATUALIZACOES                                                   !
+------------------------------------------------+---------------------+---------------------+---------------------+
!Descricao detalhada da atualizacao              !Nome do solicitante  ! Analista Reponsavel !Data da Atualizacao  !
+------------------------------------------------+---------------------+---------------------+---------------------+
!                                                !                     !                     !                     !
+------------------------------------------------+---------------------+---------------------+---------------------+
*/

#include "rwmake.ch"
#include "protheus.ch"

User Function F090BROW()
If Alltrim(Upper(cusername))$"ADMIN/EDENILSONAS/ALEXANDRERB"
	TudoOK:= .F.
	Aviso("Baixa de Titulos","Caro usu�rio, voc� n�o tem permiss�o para baixar Titulos.", {"OK"},2)
Else
	TudoOK:= .T.
Endif

Return(TudoOK)
