/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST069  �Autor  �Marcos R Roquitski  � Data �  27/02/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Estoque de Materiais no Cliente                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "Rwmake.ch"      
#include "Topconn.ch"

User Function NhEst069()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,cQuery")
SetPrvt("aEstoque,cAnoMes")

cString   := "SD3"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os ")
cDesc2    := OemToAnsi("Estoque de Materias no Cliente")
cDesc3    := OemToAnsi(" ")
tamanho   := "G"
limite    := 260
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST069"
nLastKey  := 0
titulo    := "EXPEDICAO DE MATERIAIS (DIARIO) DO PERIODO DE "
Cabec1    := " PECAS/DIAS                      1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31 TOTAL"
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST069"
_cPerg    := "EST069"
cDia      := " "
aRefugo   := {}           
aTotal    := {}               
aLocal    := {}                                                      
aProduto  := {}
cLocal    := " "                                            
nTotGer   := 0
lCol      := .F. 
aEstoque  := {}

// Parametros Utilizados

//MV_PAR01 = MES/ANO
//MV_PAR02 = PRODUTO DE
//MV_PAR03 = PRODUTO ATE
//MV_PAR04 = TIPO DE 
//MV_PAR05 = TIPO ATE
//MV_PAR06 = DO CLIENTE
//MV_PAR07 = ATE CLIENTE
//MV_PAR08 = WHBIII (SIM/NAO)
//MV_PAR09 = FREQUENCIA (1=DIARIO/2=MENSAL)
//MV_PAR10 = Impr. Cod. Produto (SIM/NAO)

Pergunte('EST069',.T.)

If nLastKey == 27
    Set Filter To
    Return
Endif


If mv_par09 == 2 //mensal
	titulo := "EXPEDICAO DE MATERIAIS (MENSAL) DO PERIODO DE " 
	Cabec1 := " PECAS/MES                           Jan            Fev            Mar            Abr            Mai            Jun            Jul            Ago            Set            Out            Nov            Dez          TOTAL"
EndIf

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif
             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]                   
cAnoMes := Substr(mv_par01,4,4) + Substr(mv_par01,1,2)

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")

TMP->(DbGoTop())
If Empty(TMP->D2_DOC)
   MsgBox("Nenhum produto foi encontrado","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif     

Processa( {|| GeraMatriz()   },"Totalizando Produtos")
Processa( {|| RptDetail() },"Imprimindo...")

Return

Static Function Gerando()

/*
   cQuery := "SELECT B1.B1_DESC,SZM.ZM_DOC,SZM.ZM_DATAEXP,SZN.ZN_COD, "
   cQuery += " SZN.ZN_QUANT, SZM.ZM_CLIENTE, SZM.ZM_LOJA, SZN.ZN_NFISCAL, SZN.ZN_SERIE "
   cQuery += " FROM " + RetSqlName( 'SZM' ) +" SZM, " + RetSqlName( 'SZN' ) +" SZN, " + RetSqlName( 'SB1' ) +" B1 "
   cQuery += " WHERE SZM.ZM_FILIAL = '" + xFilial("SZM")+ "'"
   cQuery += " AND SZN.ZN_FILIAL = '" + xFilial("SZN")+ "'"
   cQuery += " AND SZN.ZN_COD BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
   cQuery += " AND B1.B1_TIPO BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
   cQuery += " AND SZM.ZM_CLIENTE BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
   cQuery += " AND SZN.ZN_COD != 'VWB06.3.0083.00'"

   If SM0->M0_CODIGO == "FN" .And. mv_par08 == 1     
   		cQuery += " AND B1.B1_GRUPO IN ('PA02','PA03')"
   		
   ElseIf  SM0->M0_CODIGO == "FN" .And. mv_par08 == 2     
   		cQuery += " AND B1.B1_GRUPO = 'PA01'"
   EndIf

   cQuery += " AND SZM.ZM_DOC = SZN.ZN_DOC"
   cQuery += " AND SZN.ZN_COD = B1.B1_COD"

   If mv_par09 == 2//MENSAL
   		cQuery += " AND SUBSTRING(SZM.ZM_DATAEXP,1,4) = '" + Substr(cAnoMes,1,4) +"'"
   Else
   		cQuery += " AND SUBSTRING(SZM.ZM_DATAEXP,1,6) = '" + cAnoMes +"'"
   EndIf

   cQuery += " AND SZM.D_E_L_E_T_ = ' '"
   cQuery += " AND SZN.D_E_L_E_T_ = ' '"
   cQuery += " ORDER BY SZN.ZN_COD ASC"

   // MemoWrit('C:\TEMP\EST068.SQL',cQuery)
   TCQUERY cQuery NEW ALIAS "TMP"
   // TcSetField("TMP","ZM_DATAEXP","D")  // Muda a data de string para date
*/

	cQuery := "SELECT D2.D2_COD, B1.B1_DESC, D2.D2_DOC, D2.D2_SERIE, D2.D2_EMISSAO, D2.D2_QUANT, D2.D2_CLIENTE, D2.D2_LOJA"
	cQuery += " FROM "+RetSqlName("SD2")+" D2, "+RetSqlName("SB1")+" B1, "   +RetSqlName("SC6")+" C6," +RetSqlName("SC5")+" C5" 
	cQuery += " WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+xFilial("SD2")+"'"
	cQuery += " AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND C6.D_E_L_E_T_ = ''	
	cQuery += " AND C5.D_E_L_E_T_ = ''	
	cQuery += " AND B1.B1_COD = D2.D2_COD"
	cQuery += " AND D2.D2_COD BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
    cQuery += " AND B1.B1_TIPO BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
	cQuery += " AND D2.D2_CLIENTE BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"	
	cQuery += " AND D2.D2_CLIENTE <> '000184'" // nao busca quando for cliente fundicao
    cQuery += " AND D2.D2_COD != 'VWB06.3.0083.00'"
    
    cQuery += " AND D2.D2_COD = C6.C6_PRODUTO"
    cQuery += " AND D2.D2_ITEMPV = C6.C6_ITEM" 
    cQuery += " AND D2.D2_CLIENTE = C6.C6_CLI"
    cQuery += " AND D2.D2_LOJA = C6.C6_LOJA"
    cQuery += " AND D2.D2_PEDIDO = C6.C6_NUM"
    cQuery += " AND D2.D2_DOC = C6.C6_NOTA"
    cQuery += " AND D2.D2_SERIE = C6.C6_SERIE"
    cQuery += " AND D2.D2_EMISSAO = C6.C6_DATFAT" 
    cQuery += " AND C5.C5_CLIENTE = C6.C6_CLI"
    cQuery += " AND C5.C5_LOJACLI = C6.C6_LOJA"
    cQuery += " AND C5.C5_NUM = C6.C6_NUM"
    cQuery += " AND C5.C5_REFUGO <> 'S'" //Nao trazer as notas referentes a refugo
	
    If SM0->M0_CODIGO == "FN" .And. mv_par08 == 1     
   		cQuery += " AND B1.B1_GRUPO IN ('PA02','PA03')"
    ElseIf  SM0->M0_CODIGO == "FN" .And. mv_par08 == 2     
   		cQuery += " AND B1.B1_GRUPO = 'PA01'"
    EndIf

    If mv_par09 == 2//MENSAL
   		cQuery += " AND SUBSTRING(D2.D2_EMISSAO,1,4) = '" + Substr(cAnoMes,1,4) +"'"
    Else
   		cQuery += " AND SUBSTRING(D2.D2_EMISSAO,1,6) = '" + cAnoMes +"'"
    EndIf
    
    cQuery += " AND D2.D2_CF NOT IN ('5901','6924','6901','5924','6905')" //remessa para industrializa��o
    
    cQuery += " ORDER BY D2.D2_COD ASC"
    
//    MemoWrit('C:\TEMP\EST069.SQL',cQuery)    

    TCQUERY cQuery NEW ALIAS "TMP"


Return


Static Function GeraMatriz()
Local nPos := nDia := 0

	DbSelectArea("TMP")
	TMP->(DbGotop())
	While !TMP->(Eof())
		nPos := Ascan(aEstoque, {|x| x[1] == TMP->D2_COD})
		
		If mv_par09 == 2 //mensal
			
			nMes := Val(Substr(TMP->D2_EMISSAO,5,2)) + 2
			If nPos == 0
				aAdd(aEstoque, {TMP->D2_COD,TMP->B1_DESC,0,0,0,0,0,0,0,0,0,0,0,0})
				nPos := Ascan(aEstoque, {|x| x[1] == TMP->D2_COD})
				If nPos > 0
					aEstoque[nPos,nMes] += TMP->D2_QUANT
				EndIf
			Else
				aEstoque[nPos,nMes] += TMP->D2_QUANT
			EndIf

		Else	//diario
		
			nDia := Val(Substring(TMP->D2_EMISSAO,7,2)) + 2
			If nPos == 0
				AADD(aEstoque,{TMP->D2_COD,TMP->B1_DESC,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
				nPos := Ascan(aEstoque, {|x| x[1] == TMP->D2_COD})    
				If nPos > 0
					aEstoque[nPos,nDia] += TMP->D2_QUANT
				Endif	
			Else
				aEstoque[nPos,nDia] += TMP->D2_QUANT
			Endif	
		
		EndIf
		
		TMP->(DbSkip())	
	Enddo

Return

Static Function RptDetail()
Local _cCod := ""
Local m, nTotLinha := 0  

if mv_par09 == 2 //mensal
	Titulo += Substr(mv_par01,4,4)
else //diario
	Titulo += UPPER(MesExtenso(Val(Substr(mv_par01,1,2)))) + "/" + Substr(mv_par01,4,4)
endif

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
For m := 1 To Len(aEstoque)
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
	
	If _cCod <> Substr(aEstoque[m,1],1,3)
		_cCod := Substr(aEstoque[m,1],1,3)
		@ Prow()+01,001 Psay __PrtThinLine()
	EndIf
	
	If MV_PAR10==1 //SIM, IMPRIME CODIGO DO PRODUTO
		@ Prow()+1,001 Psay Substr(aEstoque[m,1],1,15)+" "+ Substr(aEstoque[m,2],1,11)
	ELSE
		@ Prow()+1,001 Psay Substr(aEstoque[m,2],1,28)
	ENDIF

	If mv_par09 == 2 //mensal
		_nLin  := 31
	    _nMais := 15   
	    _cMask := "@E 99999999"
	else
		_nLin  := 29
		_nMais := 6            
		_cMask := "@E 99999"
	EndIf
	
	@ Prow()  ,_nLin Psay aEstoque[m,3]  Picture _cMask
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,4]  Picture _cMask
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,5]  Picture _cMask	     
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,6]  Picture _cMask
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,7]  Picture _cMask
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,8]  Picture _cMask	
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,9]  Picture _cMask
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,10] Picture _cMask
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,11] Picture _cMask
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,12] Picture _cMask
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,13] Picture _cMask
	_nLin += _nMais
	@ Prow()  ,_nLin Psay aEstoque[m,14] Picture _cMask
	_nLin += _nMais
	
	If MV_PAR09 == 1//DIARIO
		@ Prow()  ,_nLin Psay aEstoque[m,15] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,16] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,17] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,18] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,19] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,20] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,21] Picture "@E 99999"								
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,22] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,23] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,24] Picture "@E 99999"		
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,25] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,26] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,27] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,28] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,29] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,30] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,31] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,32] Picture "@E 99999"
		_nLin += _nMais
		@ Prow()  ,_nLin Psay aEstoque[m,33] Picture "@E 99999"
		_nLin += _nMais
	EndIf
	
	nTotLinha += aEstoque[m,03] + aEstoque[m,04] + aEstoque[m,05] + aEstoque[m,06] + aEstoque[m,07] + aEstoque[m,08] +;
				 aEstoque[m,09] + aEstoque[m,10] + aEstoque[m,11] + aEstoque[m,12] + aEstoque[m,13] + aEstoque[m,14]
				 
				 
	If mv_par09 == 1 //diario
	
		nTotLinha += aEstoque[m,15] + aEstoque[m,16] + aEstoque[m,17] + aEstoque[m,18] + aEstoque[m,19] + aEstoque[m,20] + ;
				     aEstoque[m,21] + aEstoque[m,22] + aEstoque[m,23] + aEstoque[m,24] + aEstoque[m,25] + aEstoque[m,26] + ;
				     aEstoque[m,27] + aEstoque[m,28] + aEstoque[m,29] + aEstoque[m,30] + aEstoque[m,31] + aEstoque[m,32] + ;
				     aEstoque[m,33]
	EndIf

	IF MV_PAR09 == 1 //DIARIO
		@ Prow()  ,215 Psay nTotLinha Picture "@E 999999"
	ELSE
		@ Prow()  ,211 Psay nTotLinha Picture "@E 999999999"
	ENDIF
	nTotLinha := 0
Next
@ Prow()+01,001 Psay __PrtThinLine()
@ Prow()+002, 001 Psay ""
     
DbSelectArea("TMP")
DbCloseArea()
       

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return(nil)
