/*
+--------------------------------------------------------------------------------------------------------------------+
!                                                FICHA TECNICA DO PROGRAMA                                           !
+--------------------------------------------------------------------------------------------------------------------+
!                                                   DADOS DO PROGRAMA                                                !
+------------------+-------------------------------------------------------------------------------------------------+
! Modulo           ! Ponto de Entrada F240FIL -  Montagem de Filtro                                                  !
+------------------+-------------------------------------------------------------------------------------------------+
! Nome             ! F240FIL.PRW                                                                                     !
+------------------+-------------------------------------------------------------------------------------------------+
! Descricao        ! O ponto de entrada F240FIL sera utilizado para montar o filtro para Indregua apos preenchimento !
!                  ! da tela de dados do bordero. O filtro retornado pelo ponto de entrada ser� anexado ao filtro    !
!                  ! padr�o do programa.                                                                             !
+------------------+-------------------------------------------------------------------------------------------------+
! Autor             ! Edenilson Santos                                                                               !
+------------------+-------------------------------------------------------------------------------------------------+
! Data de Criacao   ! 15/07/2014                                                                                     !
+------------------+-------------------------------------------------------------------------------------------------+
!                                                   ATUALIZACOES                                                     !
+--------------------------------------------------+---------------------+---------------------+---------------------+
! Descricao detalhada da atualizacao               ! Nome do solicitante ! Analista Reponsavel ! Data da Atualizacao !
+--------------------------------------------------+---------------------+---------------------+---------------------+
! Customiza��o do Filtro Border� de Pagamentos     ! Paulocb             ! Edenilson Santos    ! 15/07/2014          !
+--------------------------------------------------+---------------------+---------------------+---------------------+
*/
#include "rwmake.ch"
#include "protheus.ch"

/*********************/
User Function F240FIL()
/*********************/
Local aAliasANT := GetArea()
Local aAliasSE2 := SE2->(GetArea())
Local cMV_PAR01 := MV_PAR01 //DO PORTADOR
Local cMV_PAR02 := MV_PAR02 //ATE PORTADOR
Local cMV_PAR03 := MV_PAR03 //DO VALOR MINIMO
Local cMV_PAR04 := MV_PAR04 //ATE VALOR MAXIMO
Local cPerg  := 'F240FIL'
Local cFiltro:= ''
Local lRet   := .F.

CRIPRGBR(cPerg)

If Pergunte(cPerg,.T.)
	
	If !Empty(Alltrim(MV_PAR01)) .and. !Empty(Alltrim(MV_PAR02))
		
		cFiltro := Iif(Alltrim(MV_PAR01)=='880' .or. Alltrim(MV_PAR02)=='880', "E2_PORTADO >= '"+Alltrim(MV_PAR01)+"' .and. E2_PORTADO <= '"+Alltrim(MV_PAR02)+"'", "E2_PORTADO >= '"+Alltrim(MV_PAR01)+"' .and. E2_PORTADO <= '"+Alltrim(MV_PAR02)+"' .and. E2_SALDO >= "+cValToChar(MV_PAR03)+" .and. E2_SALDO <= "+cValToChar(MV_PAR04))
		
	Endif
	
Endif

MV_PAR01 := cMV_PAR01
MV_PAR02 := cMV_PAR02
MV_PAR03 := cMV_PAR03
MV_PAR04 := cMV_PAR04
RestArea(AALIASSE2)
RestArea(AALIASANT)

Return(cFiltro)

/*****************************/
Static Function CRIPRGBR(cPerg)
/*****************************/
Local aRegs := {}
/*
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
! Grupo Ordem Pergunta Portugues Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel GSC Valid Var01 Def01 DefSPA1 DefEng1 Cnt01 Var02 Def02 DefSpa2 DefEng2	Cnt02 Var03 Def03 DefSpa3 DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5	 DefEng5 Cnt05 XF3 GrgSxg !
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+*/
aadd(aRegs,{cPerg,'01' ,'Do Portador?'     ,'Do Portador?'     ,'Do Portador?'     ,'mv_ch1','C' ,03 ,0 ,0 ,'G',' ','mv_par01',' ' ,''	 ,''	 ,' ','' ,' ','' ,'' ,''	 ,'' ,' ' ,'' ,'' ,''	 ,''	,' ','' ,'' ,''	 ,''	,''	 ,'' ,''	 ,''	,'SA6',''})
aadd(aRegs,{cPerg,'02' ,'Ate Portador?'    ,'Ate Portador?'    ,'Ate Portador?'    ,'mv_ch2','C' ,03 ,0 ,0 ,'G',' ','mv_par02',' ' ,''	 ,''	 ,'' ,'' ,' ',''	 ,'' ,''	 ,'' ,' ' ,'' ,'' ,''	 ,''	,' ','' ,'' ,''	 ,''	,''	 ,'' ,''	 ,''	,'SA6',''})
aadd(aRegs,{cPerg,'03' ,'Do Valor Minimo?' ,'Do Valor Minimo?' ,'Do Valor Minimo?' ,'mv_ch3','N' ,15 ,2 ,0 ,'G',' ','mv_par03',' ' ,''	 ,''	 ,' ','' ,' ','' ,'' ,''	 ,'' ,' ' ,'' ,'' ,''	 ,''	,' ','' ,'' ,''	 ,''	,''	 ,'' ,''	 ,''	,''   ,''})
aadd(aRegs,{cPerg,'04' ,'Ate Valor Maximo?','Ate Valor Maximo?','Ate Valor Maximo?','mv_ch4','N' ,15 ,2 ,0 ,'G',' ','mv_par04',' ' ,''	 ,''	 ,'' ,'' ,' ',''	 ,'' ,''	 ,'' ,' ' ,'' ,'' ,''	 ,''	,' ','' ,'' ,''	 ,''	,''	 ,'' ,''	 ,''	,''   ,''})

ValidPerg(aRegs,cPerg)

Return()