
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     �Autor  �Jos� Henrique M Felipetto * Data 10/04/11 ���
�������������������������������������������������������������������������͹��
���Desc.     � RELAT�RIO DE DIVERG�NCIAS                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE/CUSTOS                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    
#include "protheus.ch"        
#INCLUDE "FIVEWIN.CH"

User Function NHEST189()

cString		:= "ZDE"
cDesc1		:= "Relat�rio de Diverg�ncias"
cDesc2      := ""
cDesc3      := ""      
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHEST189"
nLastKey	:= 0
titulo		:= OemToAnsi("Relat�rio de Diverg�ncias")
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHEST189"
_cPerg		:= "EST189"
nCont		:= 0
Cabec1		:= "Num. Diverg�ncia      Num.NF - S�rie      Fornecedor                                             QUANT.NF    Status          Usu�rio          Data"
Cabec2		:= ""

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,,,.F.,,,tamanho)

If nlastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

nTipo	:= IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver	:= ReadDriver()
cCompac	:= aDriver[1]

If Pergunte(_cPerg,.T.)
	Processa({||Gerando() },"Gerando Relat�rio...")
	Processa({||RptDetail() }," Imprimindo Relat�rio...")
Else
	Return(nil)
EndIf
TTRA->(DbCloseArea() )

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool



Return

Static Function Gerando()
cQuery := "SELECT * FROM " + RetSqlName("ZDE")
cQuery += " WHERE ZDE_NUM BETWEEN '" + mv_Par01 + "' AND '" + mv_par02 + "'"
cQuery += " AND ZDE_DATA BETWEEN '" + DTOS(mv_par03) + "' AND '" + DTOS(mv_par04) + "'"

If mv_par05 == 1
	cQuery += " AND ZDE_STATUS = 'P' "
ElseIf mv_par05 == 2
	cQuery += " AND ZDE_STATUS = 'E' "
EndIf

cQuery += " ORDER BY ZDE_DATA DESC "
TCQUERY cQuery NEW ALIAS "TTRA"
MemoWrit("D:\temp\queryos.sql",cQuery)
TcSetField("TTRA","ZDE_DATA","D")  // Muda a data de string para date    
DbSelectArea("TTRA")

/*cQuery := "SELECT ZDE_NUM,ZDE_FORNEC,ZDE_DOC,ZDE_SERIE,ZDE_LOJA,ZDE_LOGIN,D1_QUANT,A2_NOME FROM "  
cQuery +=  RetSqlName("ZDE") + " (NOLOCK) " +  " , " + RetSqlName("SA2")+ " (NOLOCK) " + " , " + RetSqlName("SD1") + " (NOLOCK) "
cQuery += " WHERE  ZDE_NUM BETWEEN '" + mv_Par01 + "' AND '" + mv_Par02 + "'"
cQuery += " AND ZDE_DOC = D1_DOC AND ZDE_DATA BETWEEN '" + DTOS(mv_par03) + "' AND '" + DTOS(mv_par04) + "'"
cQuery += " AND ZDE_FORNEC = A2_COD AND ZDE_SERIE = D1_SERIE AND ZDE_FORNEC = D1_FORNECE "
cQuery += " AND ZDE_LOJA = D1_LOJA AND ZDE_ITEMNF = D1_ITEM AND ZDE_LOJA = A2_LOJA" */




 
TTRA->(DbGoTop() )

Return

Static Function RptDetail()
Local cStatus 

Titulo := OemToAnsi("Relat�rio de Diverg�ncias - De:" + DTOC(mv_par03) + " At�: " + DTOC(mv_par04) )
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 

While TTRA->(!EOF())
If @Prow() > 65
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
EndIf
	SA2->(DbSetOrder(1) )
	SA2->(DbSeek(xFilial("SA2") + TTRA->ZDE_FORNEC + TTRA->ZDE_LOJA))
	SD1->(DbSetOrder(1) )
	SD1->(DbSeek(xFilial("SD1") + TTRA->(ZDE_DOC + ZDE_SERIE + ZDE_FORNEC + ZDE_LOJA + ZDE_COD + ZDE_ITEMNF)) )
	@Prow()+1, 001 psay Alltrim(TTRA->ZDE_NUM) // N�mero da Diverg.
	@Prow(), 022 psay   Alltrim(TTRA->ZDE_DOC) + " - " + ZDE_SERIE // N�mero da NF
	@Prow(),042 psay    Alltrim(TTRA->ZDE_FORNEC) + " - " + Alltrim(TTRA->ZDE_LOJA) + "  " + Substring(SA2->A2_NOME,1,30)  // Fornecedor
//	@Prow(),089 psay    TTRA->ZDE_QTDDIG  Picture "@e 9999999,99" //  Quantidade Digitada
	@Prow(),089 psay    SD1->D1_QUANT Picture "@e 999999999" // Quantidade na Nota Fiscal
	If TTRA->ZDE_STATUS == 'P'
		cStatus := "Pendente"
	Elseif TTRA->ZDE_STATUS == 'E'
		cStatus := "Encerrado"
	EndIf
	@Prow(),109 psay 	cStatus // Status
	@Prow(),125 psay    Alltrim(TTRA->ZDE_LOGIN)
	@PROW(),140 psay 	DTOC(TTRA->ZDE_DATA)
   // DEZ EM DEZ AS POSI��ES
	TTRA -> (DbSkip())
EndDo

Return