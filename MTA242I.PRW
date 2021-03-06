/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � MTA242I         � Alexandre R. Bento    � Data � 10.05.04 ���
������������������������������������������������������������������������Ĵ��
���Descri��o �  Ponto de Entrada que grava novos campos no SD3           ��� 
���          �  no desmonte de produtos                                  ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/


#INCLUDE "rwmake.ch"

User Function MTA242I() 


// posicao do campo no aHeader
Local _nCarDef  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CARDEF"})
Local _nDefeito := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_DEFEITO"})
Local _nOper    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_OPERACA"})
Local _nForne   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_FORNECE"})
Local _nLoja    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOJA"})
Local _nLocOri  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCORIG"})
Local _cCod     := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_COD"})
Local _n        := PARAMIXB[1] // Pega a atual posi��o do acols


//Gravando os novos campos de Origem

RecLock("SD3",.F.)
   SD3->D3_CARDEF    :=  aCols[_n,_nCarDef]
	SD3->D3_DEFEITO   :=  aCols[_n,_nDefeito]
	SD3->D3_OPERACA   :=  aCols[_n,_nOper]
	SD3->D3_FORNECE   :=  aCols[_n,_nForne]
	SD3->D3_LOJA      :=  aCols[_n,_nLoja] 
	SD3->D3_LOCORIG   :=  aCols[_n,_nLocOri]
	SD3->D3_CC        :=  SB1->B1_CC
MsUnLock("SD3")

Return
