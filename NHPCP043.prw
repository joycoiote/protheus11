
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa:PCP043 Autor:Jos� Henrique M Felipetto  Data:12/16/11         ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PCP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#INCLUDE "protheus.ch"
#include "colors.ch"
#include "TOPCONN.CH"
#include 'COLORS.CH'
#Include "prtopdef.ch"

// --------------------------------------------------------------------------------
User Function NHPCP043()

Private aRotina   := {}
Private cCadastro := "Consulta Apontamento Forjaria"

aAdd( aRotina, {"Pesquisar"     ,"AxPesqui"     ,0,1 } )
aAdd( aRotina, {"Incluir"       ,"U_PCP43(1)"   ,0,3 } )
aAdd( aRotina, {"Visualizar"    ,"U_PCP43(2)"   ,0,2 } )
//aAdd( aRotina, {"Alterar"       ,"U_PCP43(2)"   ,0,4 } )
aAdd( aRotina, {"Excluir"       ,"U_DelReg()"   ,0,5 } )
aAdd( aRotina, {"Apontamentos"  ,"U_NHPCP045()" ,0,3 } )
aAdd( aRotina, {"Relat�rio"     ,"U_NHPCP046()" ,0,3 } )
aAdd( aRotina, {"Movimenta��es" ,"U_NHPCP047()" ,0,3 } )

dbSelectArea("ZEJ")
ZEJ->(DbSetOrder(2) )

mBrowse(,,,,"ZEJ",,,,,,)
Return

// --------------------------------------------------------------------------------
User Function PCP43(nparam)

Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Local nPar := nparam

SetPrvt("dData,dHora,cPeca,cOpera,cMat,cNome,nPar,cOp,cLT,cDA,cCO,nQD,dHF,dHI,nQuant,cTempo,nAux,cAO,cAD,aSize,cUn,cAlmox,cCCop,cAuxOp,cCor,nQtdePI,cPeca2,lLogic,lGrava")
SetPrvt("lOp,cPacTot,cCont,lBTrans,cWHB,cPecOp")

aSize     := MsAdvSize()

bCanc := {|| oDlg:End() } 

cPeca 	  := space(15)
cOpera    := space(03)
cOp 	  := space(11)
cLT  	  := space(15)
cDa 	  := CTOD("  /  /    ")
cCo		  := space(3)
nQD 	  := 0
cTempo 	  := CTOD("  :  ")
cCor	  := space(10)
cPacTot
cCont

dData 	  := dDataBase
dHora 	  := Time()
dHF 	  := space(5)
dHi 	  := space(5)

nQuant 	  := 0
nQtdePI   := space(15)
nPar 	  := nParam
nSalEst	  := 0

lTransf   := .T.
lPI 	  :=  .T.
lLogic    := .T.
lGrava    := .T.
lOp       := .T.
lBTrans   := .T.

oFont1 := TFont():New("Arial",,22,,.t.,,,,,.f.)

If nPar == 1 // Incluir

	QAA->(DbSetOrder(6))
	If QAA->(DbSeek(cUserName) )
		cMat      := QAA->QAA_MAT
		cNome 	  := QAA->QAA_NOME
	else
		alert("Usu�rio n�o possui cadastro na tabela QAA. Favor, contacte a inform�tica!")
		Return .F.
	EndIf
	
	bOk   := {|| fGrava() }
ElseIf nPar == 2 // Visualizar
	fCarrega()
	bOk   := {|| oDlg:End() }
ElseIf nPar == 3 // Alterar
	fCarrega()
	bOk := {|| fAltera() }
EndIf

bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Apontamento de Produ��o",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
oSay1 := TSay():New(36,10,{||"Data:"},oDlg,,,,,,.T.,,)
oGet1 := tGet():New(34,50,{|u| if(Pcount() > 0, dData := u,dData)},oDlg,60,8,"99/99/9999",{||.T.},;
,,,,,.T.,,,{|| .F. },,,,,,,"dData")

oSay2 := TSay():New(36,160,{||"Hora:"},oDlg,,,,,,.T.,,)
oGet2 := tGet():New(34,200,{|u| if(Pcount() > 0, dHora := u,dHora)},oDlg,35,8,"99:99",{||.T.},;
,,,,,.T.,,,{|| .F. },,,,,,,"dHora")

oSay3 := TSay():New(48,10,{||"Peca:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet3 := tGet():New(46,50,{|u| if(Pcount() > 0, cPeca := u,cPeca)},oDlg,60,8,"@!",{||fValPeca()},;
,,,,,.T.,,,{|| .T. },,,,,,"KKK","cPeca")
cPecOp := cPeca

oSay4 := TSay():New(48,160,{||"Opera��o:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet4 := tGet():New(46,200,{|u| if(Pcount() > 0, cOpera := u,cOpera)},oDlg,40,8,"@!",{||.T.},;
,,,,,.T.,,,{|| .T. },,,,,,"ZEK","cOpera")

oSay5 := TSay():New(60,10,{||"Matricula:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet5 := tGet():New(58,50,{|u| if(Pcount() > 0, cMat := u,cMat)},oDlg,60,8,"@!",{||.T.},;
,,,,,.T.,,,{|| .F. },,,,,,"QAA","cMat")

// Nome do Funcionario
oSay6 := TSay():New(58,160,{||"Funcionario:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet6 := tGet():New(58,200,{|u| if(Pcount() > 0, cNome := u,cNome)},oDlg,200,8,"@!",{||.T.},;
,,,,,.T.,,,{|| .F. },,,,,,,"cNome")

oGroup1 := tGroup():New(72,10,132,410," Ordem de Produ��o ",oDlg,,,.T.)

oSay7 := TSay():New(82,20,{||"OP:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet7 := tGet():New(80,50,{|u| if(Pcount() > 0, cOp := u,cOp)},oDlg,60,8,"@!",{||fValidaOp()},;
,,,,,.T.,,,{|| .T. },,,,,,"COP","cOp")

oSay8 := TSay():New(82,160,{||"Lote Total:"},oDlg,,,,,,.T.,,)
oGet8 := tGet():New(80,200,{|u| if(Pcount() > 0, cLT := u,cLT)},oDlg,60,8,"@!",{||.T.},;
,,,,,.T.,,,{|| .F. },,,,,,,"cLT")

oSay9 := TSay():New(94,160,{||"Data Abertura:"},oDlg,,,,,,.T.,,)
oGet9 := tGet():New(92,200,{|u| if(Pcount() > 0, cDA := u,cDA)},oDlg,60,8,"99/99/99",{||.T.},;
,,,,,.T.,,,{|| .F. },,,,,,,"cDA")

oSay10 := TSay():New(106,160,{||"Corrida:"},oDlg,,,,,,.T.,,)
oGet10 := tGet():New(104,200,{|u| if(Pcount() > 0, cCO := u,cCO)},oDlg,60,8,"@!",{||.T.},;
,,,,,.T.,,,{|| .F. },,,,,,,"cCO")

oSay14 := TSay():New(118,160,{||"Qtd. Dispon�vel:"},oDlg,,,,,,.T.,,)
oGet14 := tGet():New(116,200,{|u| if(Pcount() > 0, nQD := u,nQD)},oDlg,60,8,"999999",{||.T.},;
,,,,,.T.,,,{|| .F.},,,,,,,"nQD")

oSay19 := TSay():New(118,280,{||"Saldo Estoque:"},oDlg,,,,,,.T.,,)
oGet19 := tGet():New(116,320,{|u| if(Pcount() > 0, nSalEst := u,nSalEst)},oDlg,60,8,PesqPict("SB2","B2_QATU"),{||.T.},;
,,,,,.T.,,,{|| .F.},,,,,,,"nSalEst")

oSay15 := TSay():New(82,280,{||"Almox. Origem:"},oDlg,,,,,,.T.,,)
oGet15 := tGet():New(80,320,{|u| if(Pcount() > 0, cAO := u,cAO)},oDlg,60,8,"@99",{||.T.},;
,,,,,.T.,,,{|| .F.},,,,,,,"cAO")

oSay16 := TSay():New(94,280,{||"Almox. Destino:"},oDlg,,,,,,.T.,,)
oGet16 := tGet():New(92,320,{|u| if(Pcount() > 0, cAD := u,cAD)},oDlg,60,8,"@99",{||.T.},;
,,,,,.T.,,,{|| .F.},,,,,,,"cAD")

oSay17 := TSay():New(106,280,{||"Corrida Whb:"},oDlg,,,,,,.T.,,)
oGet17 := tGet():New(104,320,{|u| if(Pcount() > 0, cWHB := u,cWHB)},oDlg,60,8,"@!",{||.T.},;
,,,,,.T.,,,{|| .F. },,,,,,,"cWHB")

oSay11 := TSay():New(138,10,{||"Hora Inicial:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet11 := tGet():New(136,50,{|u| if(Pcount() > 0, dHI := u,dHI)},oDlg,60,8,"99:99",{||fValHIni()},;
,,,,,.T.,,,{|| .T. },,,,,,,"dHI")

oSay12 := TSay():New(138,160,{||"Hora Final:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet12 := tGet():New(136,200,{|u| if(Pcount() > 0, dHF := u,dHF)},oDlg,60,8,"99:99",{||fValHora()},;
,,,,,.T.,,,{|| .T. },,,,,,,"dHF")

oSay13 := TSay():New(150,10,{||"Quantidade:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet13 := tGet():New(148,50,{|u| if(Pcount() > 0, nQuant := u,nQuant)},oDlg,60,8,"@E 999999999",{||fValQtde()},;
,,,,,.T.,,,{|| .T. },,,,,,,"nQuant")

oSay18 := TSay():New(150,160,{||"Tempo:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet18 := tGet():New(148,200,{|u| if(Pcount() > 0, cTempo := u,cTempo)},oDlg,60,8,"99:99",{||.T.},;
,,,,,.T.,,,{|| .F.},,,,,,,"cTempo")


oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

// --------------------------------------------------------------------------------
Static Function fValPeca()

SB1->(DbSetOrder(1) )
If !SB1->(DbSeek(xFilial("SB1") + cPeca) )
	Alert("Pe�a n�o encontrada! ")
	Return .F.
else
	cPeca2 := SB1->B1_COD
EndIf

Return

// --------------------------------------------------------------------------------
Static Function fValidaOp()
cAlmox := space(02)
cUn := Space(02)
cAuxOp := cOp

SC2->(DbSetOrder(9) )
If SC2->(DbSeek(xFilial("SC2") + Substr(cOp,1,8) + cPeca) )
	
	If Alltrim(SC2->C2_PRODUTO) == Alltrim(cPeca)
		cDa	   := SC2->C2_EMISSAO
		cCo    := SC2->C2_CORRIDA
		cAlmox := SC2->C2_LOCAL
		cUn    := SC2->C2_UM
		cCCop  := SC2->C2_CC
		cWHB   := SC2->C2_CORRWHB
		
		fQtdMax()
	Else
		alert("Produto da OP deve ser o mesmo que o digitado no campo pe�a!")
		Return .F.
	EndIf
else
	alert("Ordem de Produ��o n�o encontrada! ")
EndIf

Return

// --------------------------------------------------------------------------------
Static Function fQtdMax()
Local cQuery  := ""
Local cQuery2 := ""
Local cQuery3 := ""

Private nQtdAt := 0
Private nQtdAn := 0
Private cCodPi := ""
Private nSaldoPI := 0

	// If para nao deixar que a query seja executada com a cOpera vazia
	If Empty(cOpera)
		alert(" Digite a Operacao da Peca!" )
		Return .F.
	EndIf 
	
	If Alltrim(cOpera) == "10"
		nQtdAn := SC2->C2_QUANT
	Else
	
		// Pega a ultima opera��o antes da selecionada pelo usu�rio
		cQuery := " SELECT SUM(ZEJ_QUANT) AS QUANT, ULTIMA " + ;
				  " FROM " + RetSqlName("ZEJ") + " EJ, " + ;
				  " (SELECT  MAX(ZEK_OPERA) AS ULTIMA " + ;
				  " FROM " + RetSqlName("ZEK") + " EK " + ;
				  " WHERE ZEK_OPERA < " + cOpera + ;
				  " AND ZEK_COD = '" + cPeca + "' " + ;
				  " AND EK.D_E_L_E_T_ = '' AND EK.ZEK_FILIAL = '" + xFilial("ZEK") + "' " + ;
				  " ) EK " + ;
				  " WHERE ZEJ_OPERA = EK.ULTIMA " + ;
				  " AND ZEJ_OP = '" + cOP + "' " + ;
				  " AND EJ.D_E_L_E_T_ = '' AND EJ.ZEJ_FILIAL = '" + xFilial("ZEJ") + "' " + ;
				  " GROUP BY ULTIMA " 
							
		MemoWrit("D:\Temp\arq.sql",cQuery)
		TCQUERY cQuery NEW ALIAS "TTRA"
		
		If TTRA->(!EOF() ) .AND. !EMPTY(TTRA->ULTIMA) // Testa se existe uma opera��o anterior
			nQtdAn := TTRA->QUANT
		Endif   
		
		TTRA->(dbclosearea())
		
		//-- Verifica se � a segunda operacao (Forja)
		cQuery := " SELECT MIN(ZEK_OPERA) AS SEGUNDA FROM " + RetSqlName("ZEK") + " EK "
		cQuery += " WHERE ZEK_OPERA > 10 AND ZEK_COD = '"+cPeca+"' AND EK.D_E_L_E_T_ = '' AND EK.ZEK_FILIAL = '"+xFilial("ZEK")+"'"
		                                               
		TCQUERY cQuery NEW ALIAS "TRAM"
				
		If TRAM->(!EOF()) .AND. TRAM->SEGUNDA == Val(cOpera)
			// Verificar se h� saldo no estoque do PI
			cCodPI := U_f43TEMPI(cPeca)
	
			SB2->(dbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL                                                                                                                                       
			If !EMPTY(cCodPI) .AND. SB2->(DbSeek(xFilial("SB2") + cCodPI + "44" ) ) // Pesquisa na tabela saldo de Produtos -- Filial  + Produto + Armazem
				nSaldoPI := nSalEst := SB2->B2_QATU - SB2->B2_QACLASS - SB2->B2_RESERVA - SB2->B2_QTNP
				//oGet19:Refresh()
			EndIf
		EndIf
		
		TRAM->(dbclosearea())

	EndIf
	
	cQuery3 := "SELECT SUM(ZEJ_QUANT) AS QUANT FROM " + RetSqlName("ZEJ") + " EJ "
	cQuery3 += " WHERE ZEJ_OPERA = '" + cOpera + "' "
	cQuery3 += " AND ZEJ_OP = '" + cOp + "' "
	cQuery3 += " AND EJ.D_E_L_E_T_ = '' AND EJ.ZEJ_FILIAL = '"+xFilial("ZEJ")+"'" 
	
	TCQUERY cQuery3 NEW ALIAS "TTRA3"

	If TTRA3->(!EOF() )
		nQtdAt := TTRA3->QUANT
	EndIf  
	
	TTRA3->(dbclosearea())
	
	nAux := nQtdAn + nSaldoPI
	If nAux < SC2->C2_QUANT
		nQD := nAux - nQtdAt
	else
	    nQD := SC2->C2_QUANT - nQtdAt
	EndIf

Return

// --------------------------------------------------------------------------------
User Function f43TEMPI(cProd)
Local x

If SG1->(DbSeek(xFilial("SG1") + Alltrim(cProd)) )
	While SG1->(!EOF() ) .AND. Alltrim(SG1->G1_COD) == Alltrim(cProd)
		If SB1->(dbSeek(xFilial("SB1") + SG1->G1_COMP) )
			If SB1->B1_TIPO $ "MO"
				SG1->(DbSkip() )
				Loop
			EndIf
			
			If SB1->B1_TIPO == "PI"
				x := SG1->(Recno() )
				Return SG1->G1_COMP
			EndIf
		EndIf
		SG1->(DbSkip() )
	EndDo
EndIf
Return ""

// --------------------------------------------------------------------------------
Static Function fValHIni()

If len(dHI)<>5
	Alert('Digite a hora corretamente!')
	Return .f.
Endif

If dHI > "23:59"
	alert("Hora n�o pode ser maior que 23:59!. Favor, digite novamente.")
	Return .F.
EndIf

Return
// -------------------------------------------------------------------------------

Static Function fValHora()

If len(dHF)<>5
	Alert('Digite a hora corretamente!')
	Return .f.
Endif

If dHF > "23:59"
	alert("Hora n�o pode ser maior que 23:59!. Favor, digite novamente.")
	Return .F.
EndIf

If dHF > dHI
	cTempo := IntToHora(HoraToInt(dHF) - HoraToInt(dHI) )
ElseIf dHF < dHi
	nAux := 24 + HoraToInt(dHF)
	cTempo2 := nAux - HoraToInt(dHI)
	cTempo := IntToHora(cTempo2)
ElseIf dHF == dHI
	cTempo = "24:00"
EndIf

Return

// --------------------------------------------------------------------------------
Static Function fValQtde()

If nQuant > nQD
	alert("Quantidade n�o dispon�vel na opera��o anterior ! ")
	Return .F.
EndIf

Return  .T.

// ----------------------------------------------------------------------------
Static Function fGrava()
Local nQtde
Private lCont := .T.
Private _cNTrans 

If SC2->C2_QUANT - SC2->C2_QUJE > nQuant
	cPacTot := "P"
Else
	cPacTot := "T"
EndIf

_cNTrans := getSXENum("ZEJ","ZEJ_NUM")
If !fValida()
	Return
EndIf

If !fOpe()
	Return
EndIf

If !Empty(cAO) .and. !Empty(cAD) .and. cAO != cAD
	fTrAlmox()
	If !lcont
		Return .F.
	EndIf
EndIf

fUltOp()

If lGrava .and. lPI .and. lTransf .and. lBTrans
	RecLock("ZEJ",.T.)
	ZEJ->ZEJ_FILIAL	:= xFilial("ZEJ")
	ZEJ->ZEJ_DATA 	:= dData
	ZEJ->ZEJ_HORA 	:= dHora
	ZEJ->ZEJ_COD  	:= cPeca
	ZEJ->ZEJ_OPERA 	:= Val(cOpera)
	ZEJ->ZEJ_MAT 	:= cMat
	ZEJ->ZEJ_OP 	:= cAuxOp
	ZEJ->ZEJ_HINI   := dHi
	ZEJ->ZEJ_HFIN   := dHF
	ZEJ->ZEJ_QUANT  := nQuant
	ZEJ->ZEJ_TEMPO  := cTempo
	ZEJ->ZEJ_NUM	:= _cNTrans
	MsUnlock("ZEJ")
Else
	alert("Ocorreu algum erro! O apontamento n�o ser� feito. ")
	oDlg:End()
	Return .F.
EndIf

If lGrava .and. lOp .and. lBTrans
	MsgInfo("Dados gravados com sucesso!","Apontamento de Produ��o")
EndIf

oDlg:End()

Return

// --------------------------------------------------------------------------------

Static Function fValida()

If nQuant > nQd
	alert(" Quantidade n�o pode ser maior que a quantidade dispon�vel! ")
	nQuant := ""
	nQuant := space(15)
	Return .F.
EndIf

If Empty(nQuant)
	alert("Quantidade n�o pode ser em branco! ")
	Return .F.
EndIf

If Empty(cPeca)
	alert("O campo Peca deve ser preenchido! ")
	Return .F.
EndIf

If Empty(cOpera)
	alert("O campo Opera��o deve ser preenchido! ")
	Return .F.
EndIf

If Empty(cMat)
	alert("O campo Matricula deve ser preenchido! ")
	Return .F.
EndIf

If Empty(cOp)
	alert("O campo Op deve ser preenchido! ")
	Return .F.
EndIf

Return .T.

// --------------------------------------------------------------------------------
Static Function fOpe()


ZEK->(DbSetOrder(2) )
If !ZEK->(DbSeek(xFilial("ZEK") + cPeca + cOpera))
	Alert("Opera��o n�o encontrada! Digite Novamente! ")
	Return .F.
Else
	// PESQUISA ALMOXARIFADO SD4 - TARUGO
	// PEGAR DESTINO DA OP
	cAO := "42"
	cAD := "43"
EndIf

Return .T.

// --------------------------------------------------------------------------------
Static Function fTrAlmox()
Local aArray := {}
Local nAuxQt := nQuant

Private aComp := {}
Private aLote := {}
Private lMsErroAuto  := .F.
Private _cDoc
Private lPriOp := .F.
Private aMat250 := {}
Private _cDoc2
Private cRotina := ""

lPriOp := fPriOp()

If lPriOp

	fBuscPrim(cPeca) // Busca os componentes da estrutura do produto, acrescenta dados no aComp

	If lLogic		
		
		DbSelectArea("SD3")
		_cDoc  := NextNumero("SD3",2,"D3_DOC",.T.)//pega o proximo numero do documento do d3_doc
		
		//-- CABECALHO
		aArray := {{_cDoc,;		// 01.Numero do Documento
				    ddatabase}}	// 02.Data da Transferencia
		
		For x := 1 to Len(aComp)
			
			SB1->(DbSetOrder(1) )
			If SB1->(DbSeek(xFilial("SB1") + aComp[x][1]) ) // Filial + peca
				// Se a quantidade for negativa, n�o transfere.
				If aComp[x][2] < 0
					Loop
				EndIf 
				aAdd(aArray,{	SB1->B1_COD									 ,;	// 01.Produto Origem
				SB1->B1_DESC												 ,; // 02.Descricao
				SB1->B1_UM													 ,; // 03.Unidade de Medida
				SB1->B1_LOCPAD												 ,; // 04.Local Origem
				IIF(Empty(aComp[x][4]),CriaVar("D3_LOCALIZ",.F.),aComp[x][4]),;	// 05.Endereco Origem
				SB1->B1_COD													 ,;	// 06.Produto Destino
				SB1->B1_DESC											     ,; // 07.Descricao
				SB1->B1_UM													 ,;	// 08.Unidade de Medida
				"44"														 ,;	// 09.Armazem Destino
				IIF(Empty(aComp[x][4]),CriaVar("D3_LOCALIZ",.F.),aComp[x][4]),;	// 10.Endereco Destino
				CriaVar("D3_NUMSERI",.F.)                                    ,;	// 11.Numero de Serie
				IIF(Empty(aComp[x][3]),CriaVar("D3_LOTECTL",.F.),aComp[x][3]),; // 12.Lote Origem
				CriaVar("D3_NUMLOTE",.F.)									 ,;	// 13.Sublote
				CriaVar("D3_DTVALID",.F.)								     ,;	// 14.Data de Validade
				CriaVar("D3_POTENCI",.F.)									 ,;	// 15.Potencia do Lote
				aComp[x][2]													 ,; // 16.Quantidade
				CriaVar("D3_QTSEGUM",.F.)									 ,;	// 17.Quantidade na 2 UM
				CriaVar("D3_ESTORNO",.F.)									 ,;	// 18.Estorno
				CriaVar("D3_NUMSEQ" ,.F.)									 ,;	// 19.NumSeq
				IIF(Empty(aComp[x][3]),CriaVar("D3_LOTECTL",.F.),aComp[x][3]),;	// 20.Lote Destino
				CRIAVAR("D3_DTVALID",.F.)									 ,; // 21.Data Validade
				CRIAVAR("D3_ITEMGRD",.F.)									 ,; // 22.Item da grade
				CRIAVAR("D3_CARDEF" ,.F.)									 ,;
				CRIAVAR("D3_DEFEITO",.F.)									 ,;
				CRIAVAR("D3_OPERACA",.F.)									 ,;
				CRIAVAR("D3_FORNECE",.F.)									 ,;
				CRIAVAR("D3_LOJA"   ,.F.)									 ,;
				CRIAVAR("D3_LOCORIG",.F.)									 ,;
				SB1->B1_CC													 ,;
				CRIAVAR("D3_TURNO",.F.)										 ,;
				CRIAVAR("D3_MAQUINA",.F.)									 ,;
				CRIAVAR("D3_LINHA",.F.)										 ,;
				CRIAVAR("D3_CODPA",.F.)										 ,;
				CRIAVAR("D3_DTREF",.F.)                                      ,;	
				CRIAVAR("D3_CORRID",.F.)                                     ,; // 33.Codigo PA - Adicionado em 12/12/12	
				CRIAVAR("D3_OP",.F.)                                         }) // ADIDIONADO 21/10/2013 - OEE X OP
			EndIf
		Next x
		cCont := cPeca

		For y := 1 to Len(aComp)
			If cCont != aComp[y][5]
				
				cQuery := " SELECT TOP 1 C2_NUM,C2_ITEM,C2_SEQUEN,C2_UM FROM " + RetSqlName("SC2") + " C2 "
				cQuery += " WHERE C2.C2_PRODUTO = '" + aComp[y][5] + "' "
				cQuery += " AND C2.D_E_L_E_T_ = '' "
				cQuery += " ORDER BY C2.R_E_C_N_O_ DESC "
				TCQUERY cQuery NEW ALIAS "WOR"
				
				If WOR->(!EOF() )
					aAdd(aMat250,{{ 'D3_TM',"101",NIL }                    				,;
					{ 'D3_OP'     , WOR->C2_NUM + WOR->C2_ITEM + WOR->C2_SEQUEN  ,Nil}  ,;
					{ 'D3_COD'    ,aComp[y][5]   ,NIL } 								,;
					{ 'D3_QUANT'  ,nQuant        ,NIL } 								,;
					{ 'D3_UM'     ,WOR->C2_UM    ,NIL } 								,;
					{ 'D3_LOCAL'  ,"44"          ,NIL } 								,;
					{ 'D3_CC'     ,Alltrim(cCCop),NIL }						 			,;
					{ 'D3_EMISSAO',dDataBase     ,NIL }									,;
					{ 'D3_SEGUM'  ,"KG"          ,NIL }						 			,;
					{ 'D3_CONTA'  ,'101040010001',NIL }									,;
					{ 'D3_TIPO'   ,"PI"          ,NIL }									,;
					{ 'D3_CF'     ,'PR0'         ,Nil }									,;
					{ 'D3_DOC'    ,"XXXXXXX"     ,Nil }									,;
					{ 'D3_CHAVE'  ,'R0'          ,Nil }									,;
					{ 'D3_PARCTOT',cPacTot       ,Nil }									,;
					{ 'D3_PERDA'  ,1             ,Nil }									,;
					{ 'D3_USUARIO',upper(alltrim(cUserName)),Nil} 					  		})
				Else
					lGrava := .F.
					alert("N�o encontrado Ordem de Produ��o para o componente " + aComp[y][5] + "! ")
				EndIf
				WOR->(DbCloseArea() )
			EndIf
			cCont := aComp[y][5]
		Next y
	else
		alert("A transfer�ncia e o apontamento n�o ser�o feitos, pois n�o h� saldo no estoque para consumir a mat�ria prima!. Favor verifique! ")
		lGrava := .F.
	EndIf

	// Quando foi a primeria Op, Transfere Mat�ria Prima e Aponta produ��o do PI
	If  lGrava .AND. LEN(aArray) > 1
	
		Begin Transaction
		
		//-- colocado devido a um errorlog enviado pelo Mario dizendo alias in use TTS
		If SELECT('TTS') > 0
			TTS->(dbclosearea())
		Endif
		
		Processa({|| MSExecAuto({|x| MATA261(x)},aArray)},"Aguarde. Transferindo Mat�ria Prima...")
		
		If lMsErroAuto
			alert("Erro na transferencia ")
			lTransf := .F.
			lBTrans := .F.
			mostraerro()
			DisarmTransaction()
			Return
		EndIf
		
		//-- verifica se houve transferencia
		cAl := getnextalias()
		beginSql alias cAl
			SELECT D3_DOC 
			FROM %Table:SD3%
			WHERE D3_DOC = %Exp:_cDoc%
			AND %NotDel%
			AND D3_ESTORNO <> 'S'
		endSql
		
		If (cAl)->(eof())
			alert("Erro na Transfer�ncia!")
			lTransf := .F.
			lGrava  := .F.
			lBTrans := .F.
			(cAl)->(dbclosearea())
			Return
		Else
			RecLock("ZEL",.T.)
				ZEL->ZEL_FILIAL := xFilial("ZEL")
				ZEL->ZEL_NUM := _cNTrans
				ZEL->ZEL_DOC := _cDoc
				ZEL->ZEL_ROTINA := "MATA261"	
			MsUnLock("ZEL")
		Endif
	
		(cAl)->(dbclosearea())	
		//-- fim verificacao de gravacao na sd3
	
		If Len(aMat250) > 0
			DbSelectArea("SD3")
			_cDoc2 := NextNumero("SD3",2,"D3_DOC",.T.)//pega o proximo numero do documento do d3_doc
			
			for u := 1 to Len(aMat250)
				aMat250[u][13] :=  {"D3_DOC", _cDoc2,NIL}
			Next u
			 
			//-- adiciona saldo nos empenhos de mod para n�o gerar erro no execauto
			For xMOD:=1 to Len(aMat250)
				//-- passa a op, e o .t. significa que vai adicionar saldo ao mod no sb2
				fAjuSalMOD(aMat250[xMOD][2][2],.T.)
			Next 
						
			Processa({|| MSExecAuto({|x,y| mata250(x,y)},aMat250[1],3)},"Aguarde. Gerando PI...")
			
			//-- remove o saldo adicionado nos empenhos de mod para n�o ficar com saldo incorreto no sistema
			For xMOD:=1 to Len(aMat250)
				//-- passa a op, e o .f. significa que vai decrementar saldo ao mod no sb2
				fAjuSalMOD(aMat250[xMOD][2][2],.F.)
			Next
			
			If lMsErroAuto
				lPI := .F.
				lBTrans := .F.
				mostraerro()
				DisarmTransaction()
				Return
			Else
				RecLock("ZEL",.T.)
					ZEL->ZEL_FILIAL := xFilial("ZEL")
					ZEL->ZEL_NUM := _cNTrans
					ZEL->ZEL_DOC := _cDoc2
					ZEL->ZEL_ROTINA := "MATA250"	
				MsUnLock("ZEL")
			EndIf
		EndIf
		If !lBTrans
			DisarmTransaction()
		EndIf
		End Transaction

	EndIf
	
EndIf

Return

// --------------------------------------------------------------------------------
Static Function fPriOp()
Local lContr := .F. 
cQuery := " SELECT MIN(ZEK_OPERA) AS MINIMA FROM " + RetSqlName("ZEK") + " EK "
cQuery += " WHERE ZEK_COD = '" + cPeca + "' "
cQuery += " AND EK.D_E_L_E_T_ = '' "
TCQUERY cQuery NEW ALIAS "TTRA6"

If Val(cOpera) == TTRA6->MINIMA
	lContr := .T.
EndIf

TTRA6->(DbCloseArea() )
Return  lContr
// -----------------------------------------------------------------------------------------------------------------------------------------


Static Function fFaz()

If SELECT("SD3") > 0
	SD3->(DbCloseArea() )
EndIf

dbselectarea("SD3")
aMata250 := {}
lMsErroAuto := .F.
_cDoc2 := NextNumero("SD3",2,"D3_DOC",.T.)//pega o proximo numero do documento do d3_doc

aAdd(aMata250,{{ 'D3_TM'    ,"101"  ,NIL },;
{ 'D3_OP'     ,cOp  				,Nil },;
{ 'D3_COD'    ,SC2->C2_PRODUTO  	,NIL },;
{ 'D3_QUANT'  ,nQuant 		    	,NIL },;
{ 'D3_UM'     ,SC2->C2_UM    		,NIL },;
{ 'D3_LOCAL'  ,cAlmox 				,NIL },;
{ 'D3_CC'     ,Alltrim(cCCop) 		,NIL },;
{ 'D3_EMISSAO',dDataBase 			,NIL },;
{ 'D3_SEGUM'  ,"KG"   				,NIL },;
{ 'D3_CONTA'  ,'101040010001'		,NIL },;
{ 'D3_TIPO'   ,"PA" 				,NIL },;
{ 'D3_CF'     ,'PR0'				,Nil },;
{ 'D3_DOC'    ,_cDoc2				,Nil },;
{ 'D3_CHAVE'  ,'R0'					,Nil },;
{ 'D3_PARCTOT',cPacTot 				,Nil },;
{ 'D3_PERDA'  ,1   					,Nil },;
{ 'D3_USUARIO',upper(alltrim(cUserName)),Nil } })

//-- adiciona saldo nos empenhos de mod para n�o gerar erro no execauto
//-- passa a op, e o .t. significa que vai adicionar saldo ao mod no sb2
fAjuSalMOD(cOp,.T.)

Processa({|| MSExecAuto({|x,y| mata250(x,y)},aMata250[1],3)},"Aguarde. Finalizando Op...")

//-- remove o saldo adicionado nos empenhos de mod para n�o ficar com saldo incorreto no sistema
//-- passa a op, e o .f. significa que vai decrementar saldo ao mod no sb2
fAjuSalMOD(cOp,.F.)

If lMsErroAuto
	lGrava := .F.
	lOp := .F.
	mostraerro()
	DisarmTransaction()
	Return
EndIf    

_cNTrans := getSXEnum("ZEL","ZEL_NUM")

RecLock("ZEL",.T.)
	ZEL->ZEL_FILIAL := xFilial("ZEL")
	ZEL->ZEL_NUM := _cNTrans
	ZEL->ZEL_DOC := _cDoc2
	ZEL->ZEL_ROTINA := "MATA250"	
MsUnLock("ZEL")
Return

// --------------------------------------------------------------------------------
Static Function fBuscPrim(CodPeca)
Local x
Local cPc

Private lLocaliz  := .F.
Private nAuxQt := 0
Private nQtAddL := 0
Private nTot := 0
Private aPI := {}
//Private cPc := cPeca

Private lLote := .F.


SG1->(DbSetOrder(1) )
SB1->(dBSetOrder(1) )
SB2->(dbSetOrder(2) )

cPc := CodPeca

If SG1->(DbSeek(xFilial("SG1") + Alltrim(cPc)) )
	While SG1->(!EOF() ) .AND. Alltrim(SG1->G1_COD) == Alltrim(cPc)
		
		If SB1->(dbSeek(xFilial("SB1") + SG1->G1_COMP) )
			If SB1->B1_TIPO $ "MO"
				SG1->(DbSkip() )
				Loop
			EndIf
			
			If SB1->B1_TIPO == "PI"
				x := SG1->(Recno() )
				// TRATAR A QUANTIDADE DOS PI
				fBuscPrim(SG1->G1_COMP)
				SG1->(DbGoTo(x) )
				SG1->(DbSkip() )
				Loop
			EndIf
			
			If SB1->B1_RASTRO == "L"
				lLote := .T.
			EndIf
			If SB1->B1_LOCALIZ == "S"
				lLocaliz := .T.
			EndIf
		EndIf
		
		nTot := nQuant * SG1->G1_QUANT
		
		If nTot <= 0
			SG1->(dbskip())
			Loop
		Endif
					
		If SB2->(DbSeek(xFilial("SB2") + cAo + SG1->G1_COMP) ) // Pesquisa na tabela saldo de Produtos -- Filial  + Armazem + Produto
			
			If nTot > (SB2->B2_QATU - SB2->B2_QACLASS - SB2->B2_RESERVA - SB2->B2_QTNP)
				alert("Materia Prima " + SG1->G1_COMP + " n�o possui saldo no almoxarifado " + cAo + " ! ")
				lLogic := .F.
				Return .F.
			EndIf
		EndIf

		
		If !lLote .and. !lLocaliz // Se nao controla nada
			aAdd(aComp,{SG1->G1_COMP,nTot,"","",Alltrim(cPc)})
		Elseif lLote .and. !lLocaliz // Se controla lote e n�o controla Localiza��o
			aLote := fLote(SG1->G1_COMP)
			nAuxQt := nTot
			If Len(aLote) == 0
				alert("Produto " + Alltrim(SG1->G1_COMP) + " n�o possui saldo em nenhum lote! ")
				lLogic := .F.
				Return .F.
			EndIf
			
			x := 1
			While nAuxQt > 0 .and. x <= Len(aLote)
				If nAuxQt < aLote[x][4]
					nQtAddL := nAuxQt
				Else
					nQtAddL := aLote[x][4]
				EndIf
				
				aAdd(aComp,{SG1->G1_COMP,nQtAddL,aLote[x][3],"",Alltrim(cPc)})
				nAuxQt -= nQtAddL
				x++
			EndDo
			
			If nAuxQt > 0
				alert("Produto " + Alltrim(SG1->G1_COMP) + " n�o possui saldo suficiente por lote! ")
				lLogic := .F.
				Return .F.
			EndIf
			
		ElseIf lLocaliz .and. !lLote // Se controla endere�o e n�o controla lote
			aLocaliz := fLocaliz(SG1->G1_COMP)
			nAuxQt := SG1->G1_QUANT * nQuant
			
			If Len(aLocaliz) == 0
				alert("Produto " + Alltrim(SG1->G1_COMP) + " n�o possui saldo em nenhum endere�o! ")
				lLogic := .F.
				Return .F.
			EndIf
			
			x := 1
			While nAuxQt > 0 .and. x <= Len(aLocaliz)
				If nAuxQt < aLocaliz[x][3]
					nQtAddL := nAuxQt
				Else
					nQtAddL := aLocaliz[x][3]
				EndIf
				
				aAdd(aComp,{SG1->G1_COMP,nQtAddL,"",aLocaliz[x][2],Alltrim(cPc)})
				nAuxQt -= nQtAddL
				x++
			EndDo
			
			If nAuxQt > 0
				alert("Produto " + Alltrim(SG1->G1_COMP) + " n�o possui saldo suficiente por endere�o! ")
				lLogic := .F.
				Return .F.
			EndIf
		Elseif lLote .and. lLocaliz
			aLote := fLote(SG1->G1_COMP)
			aLocaliz := fLocaliz(SG1->G1_COMP)
			nAuxQt := SG1->G1_QUANT * nQuant
			
			If Len(aLote) == 0
				alert("Produto " + Alltrim(SG1->G1_COMP) + " n�o possui saldo em nenhum lote! ")
				lLogic := .F.
				Return .F.
			EndIf
			
			If Len(aLocaliz) == 0
				alert("Produto " + Alltrim(SG1->G1_COMP) + " n�o possui saldo em nenhum endere�o! ")
				lLogic := .F.
				Return .F.
			EndIf
			
			x := 1
			While nAuxQt > 0 .and. x <= Len(aLocaliz)
				_n := aScan(aLote,{|y| y[3] == aLocaliz[x][4] })
				
				If _n == 0
					alert("Saldo do Lote " + aLocaliz[x][4] + " n�o encontrado na tabela SB8 ")
					x++
					Loop
				Else
					If aLote[_n][4] != aLocaliz[x][3]
						alert("Saldo do Lote " + aLote[_n][3] + " divergente entre as tabelas SB8 e SBF ")
						x++
						Loop
					EndIf
				EndIf
				
				If nAuxQt < aLocaliz[x][3]
					nQtAddL := nAuxQt
				Else
					nQtAddL := aLocaliz[x][3]
				EndIf
				
				aAdd(aComp,{SG1->G1_COMP,nQtAddL,aLote[x][3],"",cPc})
				nAuxQt -= nQtAddL
				x++
			EndDo
			
			If nAuxQt > 0 // Se nao consumiu com os produtos controlados por lote e endere�o.
				
				x := 1
				While nAuxQt > 0 .and. x <= Len(aLote)
					If nAuxQt < aLote[x][4]
						nQtAddL := nAuxQt
					Else
						nQtAddL := aLote[x][4]
					EndIf
					
					aAdd(aComp,{SG1->G1_COMP,nQtAddL,aLote[x][3],"",cPc})
					nAuxQt -= nQtAddL
					x++
				EndDo
			EndIf
			
			If nAuxQt > 0
				alert("N�o existe saldo suficiente do produto " + Alltrim(SG1->G1_COMP) + " por lote e por endere�o ")
				lLogic := .F.
				Return .F.
			EndIf
			
			
		EndIf
		
		SG1->(DbSkip() )
	EndDo
else
	alert("Mat�ria prima n�o encontrada! ")
EndIf
Return  

// ----------------------------------------------------------------------------------------------------------------

Static Function fLote(cProd)
SB8->(DbSetOrder(1)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE
SB8->(DbSeek(xFilial("SB8")+cProd+cAO))

If SB8->(Found() )
	While SB8->(!EOF()) .AND. SB8->B8_PRODUTO == cProd .AND. SB8->B8_LOCAL == cAO
		If SB8->B8_SALDO > 0
			_n := aScan(aLote,{|x| x[1] == SB8->B8_PRODUTO .and. ;
			x[3] == SB8->B8_LOTECTL })
			If _n == 0
				aAdd(aLote,{SB8->B8_PRODUTO,SB8->B8_DATA,SB8->B8_LOTECTL,SB8->B8_SALDO})
			Else
				aLote[_n][4] += SB8->B8_SALDO // Geralmente n�o deve entrar nesse Else
			EndIf
		EndIf
		SB8->(DbSkip() )
	EndDo
EndIf
aSort(aLote,,,{|x,y| x[2] < y[2] .and. x[4] > y[4]}) //ordena por data decrescente
Return aLote

// --------------------------------------------------------------------------------
Static Function fLocaliz(cProd)
aLocaliz := {}
SBF->(DbSetOrder(2) ) // Filial + Produto + Local
SBF->(DbSeek(xFilial("SBF") + cProd + cAO) )

If SBF->(Found() )
	While SBF->(!EOF() ) .AND. SBF->BF_PRODUTO == cProd .AND. SBF->BF_LOCAL == cAO
		If SBF->BF_QUANT > 0
			_n := aScan(aLocaliz,{|z| z[1] == SBF->BF_PRODUTO .AND. z[2] == SBF->BF_LOCALIZ .and. z[4] == SBF->BF_LOTECTL})
			
			If _n == 0
				aAdd(aLocaliz,{SBF->BF_PRODUTO,SBF->BF_LOCALIZ,SBF->BF_QUANT,SBF->BF_LOTECTL})
			Else
				aLocaliz[_n][3] += SBF->BF_QUANT
			EndIf
		EndIf
	SBF->(DbSkip())
	EndDo
EndIf
Return aLocaliz

// ------------------------------------------------------------------------------------------------
Static Function fUltOp()
cQuery := " SELECT MAX(ZEK_OPERA) AS MAXIMA FROM " + RetSqlName("ZEK") + " EK "
cQuery += " WHERE ZEK_COD = '" + cPeca + "' "
cQuery += " AND EK.D_E_L_E_T_ = '' "
TCQUERY cQuery NEW ALIAS "TTRA5"

If Val(cOpera) == TTRA5->MAXIMA
	fFaz()
EndIf
     
TTRA5->(DbCloseArea() )
Return
// -----------------------------------------------------------------------------------------------
Static Function fCarrega()

cPeca 	  := ZEJ->ZEJ_COD
cOpera    := Alltrim(Str(ZEJ->ZEJ_OPERA))
cMat      := ZEJ->ZEJ_MAT

QAA->(DbSetOrder(1) )
If QAA->(DbSeek(xFilial("QAA") + Alltrim(cMat) ))
	cNome := QAA->QAA_NOME
EndIf

cOp 	  := ZEJ->ZEJ_OP

ZEK->(DbSetOrder(2) )
If ZEK->(DbSeek(xFilial("ZEK") + cPeca + cOpera))
	cAO := "42"
	cAD := "43"
EndIf
cLT  	  := space(15)
cDa 	  := space(15)
cCo		  := space(3)
nQD 	  := 0
cCor	  := space(10)
fValidaOp()
cTempo 	  := ZEJ->ZEJ_TEMPO
nQuant    := ZEJ->ZEJ_QUANT

dData 	  := ZEJ->ZEJ_DATA
dHora 	  := ZEJ->ZEJ_HORA
dHF 	  := ZEJ->ZEJ_HINI
dHi 	  := ZEJ->ZEJ_HFIN

Return

// --------------------------------------------------------------------------------







// --------------------------------------------------------------------------------
User Function DelReg(lExcTodas)
Local _cDocT    := ""
Local _cProd    := ""
Local aAuto     := {}
Local cAl       := getnextalias()
Local cAl2	    := getnextalias()
Local cAl3	    := getnextalias()
Local cPeca	    := ""
Local lAchou    := .T.
Local aMata250  := {}
Local aMat250   := {}
Local lBTrans   := .T.
Local cOperAtu  := ZEJ->ZEJ_OPERA
Local lUltOp    := isUltOP(ZEJ->ZEJ_COD,ZEJ->ZEJ_OPERA)    
Local lTemMaior := .f.
Local lTransOk  := .T.
Private lMsErroAuto := .F. 

Default lExcTodas := .F.

	ZEJ->(DbSetOrder(2) ) // FILIAL + OP + OPERA��O

	SD3->(DbSetOrder(8) ) // D3_FILIAL+D3_DOC+D3_NUMSEQ                                                                                                                                      
	
	If !lExcTodas

		 lTemMaior := fTemMaior(ZEJ->ZEJ_COD,ZEJ->ZEJ_OPERA)

		If lTemMaior 
			If !MsgYesNo("Existem apontamentos com Opera��o superior a "+AllTrim(str(ZEJ->ZEJ_OPERA))+". A exclus�o ir� apaga-los. Deseja continuar?" )
				Return
			Endif
		Else
			If !MsgYesNo("Deseja excluir apontamento: " + Alltrim(ZEJ->ZEJ_COD) + " - Opera��o: " + Alltrim(Str(ZEJ->ZEJ_OPERA)) )
				Return
			Endif
		Endif
	Endif
				
	begin transaction
	
	cPeca := ZEJ->ZEJ_COD // Para utilizar no While quando houver apontamentos com opera��es superiores da opera��o selecionada no grid
	
	// Verifica se a opera��o selecionada � a 10(Primeira) ou a ultima
	If ZEJ->ZEJ_OPERA == 10 .or. lUltOp

		ZEL->(DbSetOrder(1) )//filial + numero + codigo
				
		// Vai na tabela e procura o n�mero da transfer�ncia com o num cadastrado na ZEJ
		If ZEL->(DbSeek(xFilial("ZEL") + Alltrim(ZEJ->ZEJ_NUM)))
			While ZEL->(!EOF()) .AND. ZEJ->ZEJ_NUM == ZEL->ZEL_NUM
			
				If ZEL->ZEL_ESTORN=='S'
					ZEL->(dbskip())
					Loop
				Endif
			
				If Alltrim(ZEL->ZEL_ROTINA) == "MATA261" // Se for Transfer�ncia entre almoxarifados

					//-- ESTORNO DE TRANSFERENCIA
					SD3->(DbSeek(xFilial("SD3") + Alltrim(ZEL->ZEL_DOC)))  // procura na SD3 passando o documento da Transfer�ncia realizada
					Processa( {|| MSExecAuto({|x,y| mata261(x,y)},aAuto,6)}, "Estornando Transfer�ncia... ") // Estorna as transfer�ncias
					If lMsErroAuto
						lTransOk := .f.
						mostraerro()
						DisarmTransaction()
					EndIf
				ElseIf Alltrim(ZEL->ZEL_ROTINA) == "MATA250" // Se for apontamento de produ��o

					// Estornar Apontamento de produ��o
					SD3->(DbSeek(xFilial("SD3") + Alltrim(ZEL->ZEL_DOC))) // procura na SD3 passando o n�mero do Apontamento Realizado.
					While SD3->D3_TM # '101' .AND. ZEL->ZEL_DOC == SD3->D3_DOC // Enquanto o TM for diferente de 101 e o DOC do ZEL = ao DOC do SD3, da um Skip para poder posicionar em uma D3_TM 101
						SD3->(DbSkip() ) // Pula
						If SD3->D3_TM == "101"
							lAchou := .T. // Se encontrou uma TM 101, atribui .T. a lAchou
						EndIf
					EndDo
					
					If !lAchou
						alert("Movimento de produ��o 101 n�o encontrado. ") 
						lTransOk := .f.
						DisarmTransaction()
					Else
								
						lMsErroAuto := .F.
								
						SB1->(dbSeek(xFilial("SB1")+SD3->D3_COD)) //-- Posiciona o produto para n�o dar erro
						
						// Aqui, j� estar� posicionado na SD3 o Apontamento do PI, ent�o iremos carregar o array com os dados da SD3
						aAdd(aMata250,{{ 'D3_DOC'    ,SD3->D3_DOC ,NIL },;
									   { 'D3_COD'    ,SD3->D3_COD ,NIL },;
						               { 'INDEX'     ,2           ,Nil }})

						fAjuSalMOD(SD3->D3_OP,.T.)
							
						Processa({|| MSExecAuto({|x,Y| mata250(x,Y)},aMata250[1],5)},"Estornando Ap. Produ��o....")// Nopc = 5 => Estorno
						
						fAjuSalMOD(SD3->D3_OP,.F.)

						If lMsErroAuto  
							lTransOk := .f.
							MostraErro()
							DisarmTransaction()
						EndIf			
 					EndIf
				EndIf
				
				// Grava na ZEL(TABELA AUXILIAR) que o documento foi estornado. Se for usar a ZEL, lembrar de condicionar ZEL_ESTORNO <> 'S'
				If lTransOk
					RecLock("ZEL",.F.)
						ZEL->ZEL_ESTORN := "S"
					MsUnLock("ZEL")
            	Endif
            	
				ZEL->(DbSkip())
			EndDo 

		EndIf	
	
	EndIf
	
	If !lTransOk
		alert('Erro na exclus�o do apontamento') 
		DisarmTransaction()
		Return
	endif

	//-- EXCLUI O APONTAMENTO
	RecLock("ZEJ",.F.)
		ZEJ->(DbDelete() )
	MsUnLock("ZEJ")
		      
	If !lUltOp .and. !lExcTodas .and. lTemMaior
		ZEJ->(DbSkip() )
		// Loop para excluir todas os apontamento daquela pe�a.
		While ZEJ->(!EOF()) .AND. cPeca == ZEJ->ZEJ_COD
			U_DelReg(.t.)
			ZEJ->(DbSkip() )
		EndDo							
	Endif
	
	end transaction

Return

/*
Static Function fAltera()

If !fValida()
	Return
EndIf

RecLock("ZEJ",.F.)
	ZEJ->ZEJ_HORA 	:= dHora
	ZEJ->ZEJ_COD  	:= cPeca
	ZEJ->ZEJ_OPERA 	:= Val(cOpera)
	ZEJ->ZEJ_OP 	:= cAuxOp
	ZEJ->ZEJ_HINI   := dHi
	ZEJ->ZEJ_HFIN   := dHF
	ZEJ->ZEJ_QUANT  := Val(nQuant)
	ZEJ->ZEJ_TEMPO  := cTempo
MsUnLock("ZEJ")

Return
*/

// Verifica se � a �ltima Opera��o da pe�a
Static Function isUltOP(cCod,cOP)
Local lRet   := .f.
Local cUltAl := getnextalias()

	If Valtype(cOp)=='N'
		cOp := Alltrim(str(cOp))
	Endif

	BeginSql alias cUltAl
		SELECT MAX(ZEK_OPERA) AS MAXIMA 
		FROM %TABLE:ZEK%
		WHERE ZEK_COD = %Exp:cCod%
		AND ZEK_FILIAL = %xFilial:ZEK%
		AND %notDel%
	EndSqL  
	
	If (cUltAl)->(!Eof())
		If cOP == Alltrim(Str((cUltAl)->MAXIMA))
			lRet:=.t.
		Endif
	endif
	
	(cUltAl)->(dbclosearea())

Return lRet
	
// Verifica se tem opera��es maiores
Static function fTemMaior(cCod,cOP)
Local lRet   := .f.
Local cMaiAl := getnextalias()

	If Valtype(cOp)=='N'
		cOp := Alltrim(str(cOp))
	Endif

	BeginSql alias cMaiAl
		SELECT COUNT(*) AS NUMERO
		FROM %TABLE:ZEJ%
		WHERE ZEJ_OPERA > %Exp:cOP%
		AND ZEJ_COD = %Exp:cCod%
		AND ZEJ_FILIAL = %xFilial:ZEJ%
		AND %notDel%
	EndSql
			
	lRet := (cMaiAl)->NUMERO > 0
	
	(cMaiAl)->(dbclosearea())
	
Return lRet

Static Function fAjuSalMOD(cOPAju,lAdiciona)
Local aAreaSD4  := SD4->(GetArea())
Local aAreaSB2  := SB2->(GetArea())
Local nValorSld := 999999999

SD4->(dbSetOrder(2)) //D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
SB2->(DbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL

If SD4->(DbSeek(xFilial("SD4") + cOPAju ))
	While SD4->(!EOF()) .AND. ALLTRIM(SD4->D4_OP) == ALLTRIM(cOPAju)
		If SUBSTR(SD4->D4_COD,1,3)$'MOD'
		
			If SB2->(dbSeek(xFilial('SB2')+SD4->D4_COD+SD4->D4_LOCAL))
				
				RecLock('SB2',.F.)
					If lAdiciona
						SB2->B2_QATU += nValorSld
					Else
						SB2->B2_QATU -= nValorSld
					Endif
				MsUnlock('SB2')
			
			Endif
		
		EndIf
		SD4->(DbSkip() )
	EndDo
EndIf
	
RestArea(aAreaSD4)
RestArea(aAreaSB2)

Return