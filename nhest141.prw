#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHEST141  �Autor �Jo�o Felipe da Rosa � Data �  20/03/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � RELATORIO DE CONSUMO MES A MES                             ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE E CUSTOS                                           ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHEST141()   

cString   := ""
cDesc1    := OemToAnsi("Este relat�rio apresenta o consumo de materiais")
cDesc2    := OemToAnsi("m�s a m�s.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST141" //nome do arquivo
nLastKey  := 0
titulo    := OemToAnsi("CONSUMO M�S A M�S") //t�tulo
//           |01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1    := "CODIGO          TP GRUP DESCRICAO                      UM"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1 
M_PAG     := 1 //Variavel que acumula numero da pagina 
wnrel     := nomeprog //"NH"
_cPerg    := "EST141"

_aMat     := {}

If !Pergunte(_cPerg,.T.)
   Return(nil)
Endif 

//cabe�alho
FOR nX := 1 TO 12
	
	cabec1 += Space(3)+UPPER(substr(MesExtenso(nX),1,3))+"/"+StrZero(MV_PAR07,4)

NEXT nX

cabec1 += "      MEDIA          VALOR"

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

//������������������������Ŀ
//�CHAMADAS PARA AS FUN��ES�
//��������������������������

Processa(  {|| Gerando()   },"Gerando Dados para a Impressao") 
RptStatus( {|| Imprime()   },"Imprimindo...")

set filter to //remove o filtro da tabela

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          

MS_FLUSH() //Libera fila de relatorios em spool

Return

//���������������������������������������Ŀ
//�FUNCAO QUE GERA OS DADOS PARA IMPRESSAO�
//�����������������������������������������

Static Function Gerando()
Local _dDtIni := CtoD("  /  /  ")
Local _dDtFim := CtoD("  /  /  ")

_dDtIni := CtoD("01/01/"+STRZERO(MV_PAR07,4))
_dDtFim := CtoD("31/12/"+STRZERO(MV_PAR07,4))

cQuery := "SELECT B1_COD, B1_TIPO, B1_GRUPO, B1_DESC, B1_UM, SUM(D3_QUANT) QUANT "
cQuery += " FROM "+RetSqlName("SB1")+" B1, "+RetSqlName("SD3")+" D3"
cQuery += " WHERE B1.B1_COD = D3.D3_COD"
cQuery += " AND D3.D3_EMISSAO BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DtoS(_dDtFim)+"'"
cQuery += " AND D3.D3_CC BETWEEN '"+mv_par08+"' AND '"+mv_par09+"'"
cQuery += " AND D3_TM = '501'"
cQuery += " AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQuery += " AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"   
cQuery += " AND D3_LOCAL BETWEEN '"+mv_par10+"' AND '"+mv_par11+"'"
cQuery += " AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND D3.D_E_L_E_T_ = '' AND D3.D3_FILIAL = '"+xFilial("SD3")+"'"
cQuery += " GROUP BY B1_COD, B1_TIPO, B1_GRUPO, B1_DESC, B1_UM"
cQuery += " ORDER BY B1_COD"

TCQUERY cQuery NEW ALIAS "TRB"
MemoWrit('C:\TEMP\NHEST141.SQL',cQuery)

ProcRegua(0)

WHILE TRB->(!EoF())

	IncProc(TRB->B1_COD)
	
	If TRB->QUANT <= 0
		TRB->(dbSkip())
		Loop
	EndIf
	
	aAdd(_aMat,{TRB->B1_COD,;
				TRB->B1_TIPO,;
				TRB->B1_GRUPO,;
				TRB->B1_DESC,;				
				TRB->B1_UM,;
				{0,0,0,0,0,0,0,0,0,0,0,0},; //QUANTIDADES MOVIMENTADAS 12 MESES
				{0,0,0,0,0,0,0,0,0,0,0,0}}) //PRECOS MAIORES COMPRADOS POR MES
//				TRB->B1_CUSTD})

	cQuery := " SELECT D3.D3_COD, MONTH(D3_EMISSAO) MES, SUM(D3_QUANT) AS QUANT, "

	//pega o pre�o mais alto de compra do produto no mes
	//cQuery += " (SELECT MAX(D1_VUNIT) PRECO FROM SD1FN0 D1 (NOLOCK)"
	cQuery += " (SELECT MAX(D1_VUNIT) PRECO FROM "+RetSqlName("SD1")+" D1 (NOLOCK)"	
	cQuery += " WHERE D1.D1_COD = D3.D3_COD"
	cQuery += " AND MONTH(D1.D1_EMISSAO)= MONTH(D3.D3_EMISSAO)"
	cQuery += " AND YEAR(D1.D1_EMISSAO) = '"+ALLTRIM(STR(mv_par07))+"'"
	cQuery += " AND D1.D_E_L_E_T_ = ''"
	cQuery += " AND D1.D1_FILIAL = '"+xFilial("SD1")+"') PRECO"

	cQuery += " FROM "+RetSqlName("SD3")+" D3"
	cQuery += " WHERE D3_COD = '"+TRB->B1_COD+"'"
/*	cQuery += " AND YEAR(D3_EMISSAO) = '"+ALLTRIM(STR(mv_par07))+"'" */
	cQuery += " AND D3_EMISSAO BETWEEN '"+DtoS(_dDtIni)+"' AND '"+DtoS(_dDtFim)+"'"
	cQuery += " AND D3_TM = '501'"
	cQuery += " AND D3.D3_CC BETWEEN '"+mv_par08+"' AND '"+mv_par09+"'"
	cQuery += " AND D3.D3_LOCAL BETWEEN '"+mv_par10+"' AND '"+mv_par11+"'"	
	cQuery += " AND D3.D_E_L_E_T_ = '' AND D3_FILIAL = '"+xFilial("SD3")+"'"
	cQuery += " GROUP BY D3.D3_COD, MONTH(D3_EMISSAO)"
        
	TCQUERY cQuery NEW ALIAS "TRA1"
	MemoWrit('C:\TEMP\NHEST141PRECO.SQL',cQuery)
	    
	TRA1->(DbGoTop())
	
	//ADICIONA AS QUANTIDADES DENTRO DO ARRAY NA POSICAO DO MES+5
	While TRA1->(!EOF())
		_aMat[len(_aMat)][6][TRA1->MES] := TRA1->QUANT
		_aMat[len(_aMat)][7][TRA1->MES] := TRA1->PRECO
		TRA1->(dbSkip())
	EndDo

	TRB->(DBSKIP())
	TRA1->(dbCloseArea())
	
ENDDO

TRB->(dbCloseArea())
//TRA1->(dbCloseArea())

Return

//����������������������������������Ŀ
//�FUNCAO PARA IMPRESSAO DO RELAT�RIO�
//������������������������������������
Static Function Imprime()
Local _nTot := 0
Local _aTot := {0,0,0,0,0,0,0,0,0,0,0,0,0,0}

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

SetRegua(Len(_aMat))

//Percorre os registros
For _x:=1 to Len(_aMat)

	If Prow() > 55 
		_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif

	IncRegua()
		
	@Prow()+1, 000 psay _aMat[_x][1] //B1_COD
	@Prow()  , 016 psay _aMat[_x][2] //B1_TIPO
	@Prow()  , 019 psay _aMat[_x][3] //B1_GRUPO
	@Prow()  , 024 psay SUBSTR(_aMat[_x][4],1,30) //B1_DESC
	@Prow()  , 055 psay _aMat[_x][5] //B1_UM
	               
	_nTot := 0
	For _y:=1 to Len(_aMat[_x][6]) //12
		@Prow()  , 047+(_y*11) psay _aMat[_x][6][_y] PICTURE "@E 99999999"
		_nTot += _aMat[_x][6][_y]
	Next                           
	
	@Prow()  , 192 psay _nTot/12 PICTURE "@E 99999999" //MEDIA

	@Prow()+1, 001 psay "PRE�O UN.:"
            
	_nMediaV := 0
    _nTotVal := 0
    _nCountV := 0
    
	For _y:=1 to Len(_aMat[_x][7]) //12
		@Prow()  , 045+(_y*11) psay _aMat[_x][7][_y] PICTURE "@E 999,999.99"
		
		If!Empty(_aMat[_x][7][_y])
			_nMediaV += _aMat[_x][7][_y]
			_nCountV++
		EndIF
	Next
	
	_nTotVal := (_nMediaV/_nCountV) * _nTot //acumula o valor total

	@Prow()  , 203 psay _nTotVal PICTURE "@E 9,999,999.99" //B1_CUSTOD
	
	For _y:=1 to Len(_aMat[_x][6])
		_aTot[_y]  += _aMat[_x][6][_y]
	Next
	
	@Prow()+1, 001 psay " "

	_aTot[13] += _nTot/12
	_aTot[14] += _nTotVal //_aMat[_x][8]

NEXT

@ prow()+2,010 PSAY "Total Geral...................................."

	For _x:=1 to 12
		@ prow()  ,047+(_x*11) PSAY _aTot[_x] PICTURE "@E 99999999"
	NEXT
	
	@ prow()  ,190 PSAY _aTot[13] PICTURE "@E 9999999999"
	@ prow()  ,204 PSAY _aTot[14] PICTURE "@E 99999999.99"

Return(nil)