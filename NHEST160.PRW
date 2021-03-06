/*                                  
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHEST160 �Autor  �Jo�o Felipe da Rosa � Data �  15/04/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � CADASTRO FERRAMENTAS X PE�AS                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include 'topconn.ch'
#include 'colors.ch'

User Function NHEST160()
	Processa({|| fFerxPec() }, 'Carregando ...')
Return

Static Function fFerxPec()

Private cCadastro := "Ferramenta x Pe�a"
Private aRotina   := {}

aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"       , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_EST160(2)" 	  , 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_EST160(3)" 	  , 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"U_EST160(4)"    , 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"U_EST160(5)"    , 0 , 5})
aAdd(aRotina,{ "Duplica"        ,"U_EST160(6)"    , 0 , 5})
//aAdd(aRotina,{ "Ind. Refugo"    ,"U_EST160REF()"  , 0 , 5})
aAdd(aRotina,{ "Legenda"        ,"U_EST160LEG()"  , 0 , 2})

dbSelectArea("SB1")
SET FILTER TO SB1->B1_TIPO $ "PA/CC" .AND. SB1->B1_MSBLQL<>'1' //Filtra por Produto Acabado e Componente
DBGOTOP()

mBrowse(6,1,22,75,"SB1",,,,,,fCriaCor())
             
dbSelectArea("SB1")
SET FILTER TO

Return

//��������������������
//� TELA DO CADASTRO �
//��������������������
User Function EST160(nParam) 
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private nPar 	  := nParam  
Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)

Private cProd   := SB1->B1_COD
Private cPDesc  := SB1->B1_DESC
Private cCC     := SB1->B1_CC
Private cCDesc  := ""
Private aHeader := {}
Private aCols   := {}
Private nB1Rec  := SB1->(RecNo())
Private nIndRef := 0

	dbSelectArea("SB1")
	SET FILTER TO

	aAdd(aHeader,{"Item"         , "ZDJ_ITEM"     , PesqPict("ZDJ","ZDJ_ITEM")    , 04,00, ".F."          ,"","C","ZDJ"})//1
	aAdd(aHeader,{"Ferramenta"   , "ZDJ_FERRAM"   , PesqPict("ZDJ","ZDJ_FERRAM")  , 15,00, "U_160VALFE()" ,"","C","ZDJ"})//2
	aAdd(aHeader,{"Descri��o"    , "B1_DESC"      , PesqPict("SB1","B1_DESC")     , 40,00, ".F."          ,"","C","SB1"})//3

	aAdd(aHeader,{"Saldo"        , "B2_QATU"      , PesqPict("SB2","B2_QATU")     , 12,02, ".F."          ,"","N","SB2"})//4
	aAdd(aHeader,{"Saldo Reaf."  , "B2_QEMP"      , PesqPict("SB2","B2_QATU")     , 12,02, ".F."          ,"","N","SB2"})//5

	aAdd(aHeader,{"Opera��o"     , "ZDJ_OP"       , PesqPict("ZDJ","ZDJ_OP")      , 03,00, ".T."          ,"","C","ZDJ"})//6
	aAdd(aHeader,{"V U Montagem" , "ZDJ_VUMONT"   , PesqPict("ZDJ","ZDJ_VUMONT")  , 12,00, ".T."          ,"","N","ZDJ"})//7
	aAdd(aHeader,{"Qtd Reafiada" , "ZDJ_QTREAF"   , PesqPict("ZDJ","ZDJ_QTREAF")  , 06,00, ".T."          ,"","N","ZDJ"})//8
	aAdd(aHeader,{"N Arestas"    , "ZDJ_ARESTA"   , PesqPict("ZDJ","ZDJ_ARESTA")  , 06,00, ".T."          ,"","N","ZDJ"})//9
	aAdd(aHeader,{"Fer p/ Mont." , "ZDJ_FMONT"    , PesqPict("ZDJ","ZDJ_FMONT")   , 06,00, ".T."          ,"","N","ZDJ"})//10
	aAdd(aHeader,{"V U Set Mont" , "ZDJ_VUSET"    , PesqPict("ZDJ","ZDJ_VUSET")   , 12,00, ".T."          ,"","N","ZDJ"})//11
//	aAdd(aHeader,{"Ind. Refugo"  , "ZDJ_INDREF"   , PesqPict("ZDJ","ZDJ_INDREF")  , 06,00, ".T."          ,"","N","ZDJ"})//12
	aAdd(aHeader,{"Ind. Quebra"  , "ZDJ_INDQUE"   , PesqPict("ZDJ","ZDJ_INDQUE")  , 06,00, ".T."          ,"","N","ZDJ"})//13
	aAdd(aHeader,{"N. M�quinas"  , "ZDJ_NMAQ"     , PesqPict("ZDJ","ZDJ_NMAQ")    , 03,00, ".T."          ,"","N","ZDJ"})//14
	aAdd(aHeader,{"Est. Min."    , "ZDJ_EMIN"     , PesqPict("ZDJ","ZDJ_EMIN")    , 12,02, ".T."          ,"","N","ZDJ"})//15
	aAdd(aHeader,{"F�rmula"      , "ZDJ_FORMUL"   , PesqPict("ZDJ","ZDJ_FORMUL")  , 01,00, ".T."          ,"","C","ZDJ"})//16

	ZDJ->(dbSetOrder(1)) //FILIAL + PROD
	If !ZDJ->(dbSeek(xFilial("ZDJ")+SB1->B1_COD)) .AND. nPar!=3
		alert("N�o existem ferramentas para este produto!")
		Return
	EndIf		
	
	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
		If ZDJ->(Found())
			fCarrega()
			bOk := {|| fAltera()}
		Else
			bOk := {|| fInclui()}
		EndIf
	ElseIf nPar==4 //alterar
		fCarrega()
		bOk := {|| fAltera()}
	ElseIf nPar==5 //excluir
		fCarrega()
		bOk := {|| fExclui()}
	ElseIf nPar==6 // duplica
		fDuplica()
		Return
	EndIf

	CTT->(dbSetOrder(1)) // FILIAL + CC
	If CTT->(dbSeek(xFilial("CTT")+cCC))
		cCDesc := CTT->CTT_DESC01
	EndIf
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Ferramentas x Pe�as",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"Produto"},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(18,50,{|u| if(Pcount() > 0, cProd := u,cProd)},oDlg,60,8,"@!",,;
		,,,,,.T.,,,{||.F.},,,,,,,"cProd")
	
	oSay2 := TSay():New(20,160,{||"Prod. Desc"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(18,200,{|u| if(Pcount() > 0, cPDesc := u,cPDesc)},oDlg,150,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesc")

	oSay1 := TSay():New(31,10,{||"C.Custo"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(30,50,{|u| if(Pcount() > 0, cCC := u,cCC)},oDlg,60,8,"@!",{||fValCC()},;
		,,,,,.T.,,,{||.T.},,,,,,"CTT","cCC")
	
	oSay2 := TSay():New(31,160,{||"C.C. Desc"},oDlg,,,,,,.T.,,)
	oGet4 := tGet():New(30,200,{|u| if(Pcount() > 0, cCDesc := u,cCDesc)},oDlg,150,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cCDesc")

	oSay3 := TSay():New(42,10,{||"Ind. Refugo"},oDlg,,,,,,.T.,,)
	oGet5 := tGet():New(41,50,{|u| if(Pcount() > 0, nIndRef := u, nIndRef)},oDlg,30,8,"@E 999.99",{||.T.},;
		,,,,,.T.,,,{||nPar==3 .or. nPar==4},,,,,,,"nIndRef")
                 
    // cria o getDados
	oGeTD := MsGetDados():New( /*aPosObj[2,1]*/ 64,; //superior
	                           aPosObj[2,2]     ,; //esquerda
	                           aPosObj[2,3]     ,; //inferior
	                           aPosObj[2,4]     ,; //direita
	                           4                ,; // nOpc
	                           "AllwaysTrue"    ,; // CLINHAOK
	                           "AllwaysTrue"    ,; // CTUDOOK
	                           ""               ,; // CINICPOS
	                           .T.              ,; // LDELETA
	                           nil              ,; // aAlter
	                           nil              ,; // uPar1
	                           .F.              ,; // LEMPTY
	                           400              ,; // nMax
	                           nil              ,; // cCampoOk
	                           "AllwaysTrue()"  ,; // CSUPERDEL
	                           nil              ,; // uPar2
	                           "AllwaysTrue()"  ,; // CDELOK
	                           oDlg              ; // oWnd
	                          )
                               
	If nPar!=3 .and. nPar!=4 //diferente de incluir ou alterar
		oGetD:nMax := Len(aCols)
	EndIf

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)
	
	SB1->(dbGoTo(nB1Rec))

	dbSelectArea("SB1")
	SET FILTER TO SB1->B1_TIPO $ "PA/CC" .AND. SB1->B1_MSBLQL=='2' //Filtra por Produto Acabado e Componente

Return

Static Function fValCC()
	
	If Substr(cCC,1,2)$'35'
		Alert('Informe o C.Custo de Consumo iniciado por 34!')
		Return .F.
	EndIf
	
	CTT->(dbSetOrder(1))
	If CTT->(dbSeek(xFilial("CTT")+cCC))
		cCDesc := CTT->CTT_DESC01
	Else
		Alert("C.Custo n�o encontrado!")
		Return .F.
	EndIf         
	
	oGet4:Refresh()

Return .T.

User Function 160VALFE()
Local nFDesc := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="B1_DESC" })          

	If !Empty(cProd)
		SB1->(dbSetOrder(1)) // FILIAL + COD
		If SB1->(dbSeek(xFilial("SB1")+M->ZDJ_FERRAM))
			aCols[n][nFDesc] := SB1->B1_DESC
			oGetD:Refresh()
		Else
			alert("Ferramenta n�o encotnrada!")
			Return .F.
		EndIf
	EndIf
	
Return .T.

//��������Ŀ
//� VALIDA �
//����������
Static Function fValida()
Local nFerr := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZDJ_FERRAM" })          
Local nQtd := 0

	For x:=1 to Len(aCols)
		If !Empty(aCols[x][nFerr])
			nQtd++
		EndIf
	Next

	If Substr(cCC,1,2)$'35'
		Alert('Informe o C.Custo de Consumo iniciado por 34!')
		Return .F.
	EndIf
	
	If nQtd == 0
		Alert("Informe pelo menos uma ferramenta!")
		Return .F.
	EndIf
	
	For x:=1 to Len(aCols)
		If Empty(aCols[x][nFerr])
			Alert("Informe a ferramenta no item "+aCols[x][1])
			Return .f.
		EndIf
	Next

Return .T.

//��������Ŀ
//� INCLUI �
//����������
Static Function fInclui()
	
	If !fValida()
		Return
	EndIf

	For x:=1 to Len(aCols)
		RecLock("ZDJ",.T.)
			ZDJ->ZDJ_FILIAL := xFilial("ZDJ")
			ZDJ->ZDJ_PROD   := cProd
			ZDJ->ZDJ_CC     := cCC
			ZDJ->ZDJ_INDREF := nIndRef
			ZDJ->ZDJ_ITEM   := aCols[x][1]
			ZDJ->ZDJ_FERRAM := aCols[x][2]
			ZDJ->ZDJ_OP     := aCols[x][6]
			ZDJ->ZDJ_VUMONT := aCols[x][7]
			ZDJ->ZDJ_QTREAF := aCols[x][8]
			ZDJ->ZDJ_ARESTA := aCols[x][9]
			ZDJ->ZDJ_FMONT  := aCols[x][10]
			ZDJ->ZDJ_VUSET  := aCols[x][11]
			ZDJ->ZDJ_INDQUE := aCols[x][12]
			ZDJ->ZDJ_NMAQ   := aCols[x][13]
			ZDJ->ZDJ_EMIN   := aCols[x][14]
			ZDJ->ZDJ_FORMUL := aCols[x][15]
		MsUnLock("ZDJ")
		
		RecLock("ZE4",.T.)
			ZE4->ZE4_FILIAL := xFilial("ZE4")
			ZE4->ZE4_PROD   := cProd
			ZE4->ZE4_CC     := cCC
			ZE4->ZE4_ITEM   := aCols[x][1]
			ZE4->ZE4_FERRAM := aCols[x][2]
			ZE4->ZE4_ZDJREC := ZDJ->(Recno())
			ZE4->ZE4_ACAO   := 'INCLUSAO'
			ZE4->ZE4_USER   := UPPER(ALLTRIM(cUserName))
			ZE4->ZE4_DATA   := date()
			ZE4->ZE4_HORA   := time()
		MsUnlock("ZE4")

	Next
	
	oDlg:End()

Return

//��������Ŀ
//� ALTERA �
//����������
Static Function fAltera()
	
	If !fValida()
		Return
	EndIf
	
	ZDJ->(dbSetOrder(1)) // FILIAL + COD + ITEM
	
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] //nao pega quando estiver deletado
			
			If ZDJ->(dbSeek(xFilial("ZDJ")+cProd+aCols[x][1])) 
			
				//-- Verifica se houve altera��o no item
				If ZDJ->ZDJ_INDREF <> nIndRef .or. ;
				   ZDJ->ZDJ_CC     <> cCC .or. ;
				   ZDJ->ZDJ_FERRAM <> aCols[x][2] .or. ;
				   ZDJ->ZDJ_OP     <> aCols[x][6] .or. ;
				   ZDJ->ZDJ_VUMONT <> aCols[x][7] .or. ;
				   ZDJ->ZDJ_QTREAF <> aCols[x][8] .or. ;
				   ZDJ->ZDJ_ARESTA <> aCols[x][9] .or. ;
				   ZDJ->ZDJ_FMONT  <> aCols[x][10] .or. ;
				   ZDJ->ZDJ_VUSET  <> aCols[x][11] .or. ;
				   ZDJ->ZDJ_INDQUE <> aCols[x][12] .or. ;
				   ZDJ->ZDJ_NMAQ   <> aCols[x][13] .or. ;
				   ZDJ->ZDJ_EMIN   <> aCols[x][14] .or. ;
				   ZDJ->ZDJ_FORMUL <> aCols[x][15]
											
					RecLock("ZDJ",.F.)
						ZDJ->ZDJ_CC     := cCC
						ZDJ->ZDJ_INDREF := nIndRef
						ZDJ->ZDJ_FERRAM := aCols[x][2]
						ZDJ->ZDJ_OP     := aCols[x][6]
						ZDJ->ZDJ_VUMONT := aCols[x][7]
						ZDJ->ZDJ_QTREAF := aCols[x][8]
						ZDJ->ZDJ_ARESTA := aCols[x][9]
						ZDJ->ZDJ_FMONT  := aCols[x][10]
						ZDJ->ZDJ_VUSET  := aCols[x][11]
						ZDJ->ZDJ_INDQUE := aCols[x][12]
						ZDJ->ZDJ_NMAQ   := aCols[x][13]
						ZDJ->ZDJ_EMIN   := aCols[x][14]
						ZDJ->ZDJ_FORMUL := aCols[x][15]
					MsUnLock("ZDJ")
	
					RecLock("ZE4",.T.)
						ZE4->ZE4_FILIAL := xFilial("ZE4")
						ZE4->ZE4_PROD   := cProd
						ZE4->ZE4_CC     := cCC
						ZE4->ZE4_ITEM   := aCols[x][1]
						ZE4->ZE4_FERRAM := aCols[x][2]
						ZE4->ZE4_ZDJREC := ZDJ->(Recno())
						ZE4->ZE4_ACAO   := 'ALTERACAO'
						ZE4->ZE4_USER   := UPPER(ALLTRIM(cUserName))
						ZE4->ZE4_DATA   := date()
						ZE4->ZE4_HORA   := time()
					MsUnlock("ZE4")
				EndIf
					
			Else
				RecLock("ZDJ",.T.)
					ZDJ->ZDJ_FILIAL := xFilial("ZDJ")
					ZDJ->ZDJ_PROD   := cProd
					ZDJ->ZDJ_CC     := cCC
					ZDJ->ZDJ_INDREF := nIndRef
					ZDJ->ZDJ_ITEM   := aCols[x][1]
					ZDJ->ZDJ_FERRAM := aCols[x][2]
					ZDJ->ZDJ_OP     := aCols[x][6]
					ZDJ->ZDJ_VUMONT := aCols[x][7]
					ZDJ->ZDJ_QTREAF := aCols[x][8]
					ZDJ->ZDJ_ARESTA := aCols[x][9]
					ZDJ->ZDJ_FMONT  := aCols[x][10]
					ZDJ->ZDJ_VUSET  := aCols[x][11]
					ZDJ->ZDJ_INDQUE := aCols[x][12]
					ZDJ->ZDJ_NMAQ   := aCols[x][13]
					ZDJ->ZDJ_EMIN   := aCols[x][14]
					ZDJ->ZDJ_FORMUL := aCols[x][15]
					
				MsUnLock("ZDJ")

				RecLock("ZE4",.T.)
					ZE4->ZE4_FILIAL := xFilial("ZE4")
					ZE4->ZE4_PROD   := cProd
					ZE4->ZE4_CC     := cCC
					ZE4->ZE4_ITEM   := aCols[x][1]
					ZE4->ZE4_FERRAM := aCols[x][2]
					ZE4->ZE4_ZDJREC := ZDJ->(Recno())
					ZE4->ZE4_ACAO   := 'INCLUSAO'
					ZE4->ZE4_USER   := UPPER(ALLTRIM(cUserName))
					ZE4->ZE4_DATA   := date()
					ZE4->ZE4_HORA   := time()
				MsUnlock("ZE4")

			EndIf
		Else
			If ZDJ->(dbSeek(xFilial("ZDJ")+cProd+aCols[x][1]))

				RecLock("ZE4",.T.)
					ZE4->ZE4_FILIAL := xFilial("ZE4")
					ZE4->ZE4_PROD   := cProd
					ZE4->ZE4_CC     := cCC
					ZE4->ZE4_ITEM   := aCols[x][1]
					ZE4->ZE4_FERRAM := aCols[x][2]
					ZE4->ZE4_ZDJREC := ZDJ->(Recno())
					ZE4->ZE4_ACAO   := 'EXCLUSAO'
					ZE4->ZE4_USER   := UPPER(ALLTRIM(cUserName))
					ZE4->ZE4_DATA   := date()
					ZE4->ZE4_HORA   := time()
				MsUnlock("ZE4")
		
				RecLock("ZDJ",.F.)
					ZDJ->(dbDelete())
				MsUnLock("ZDJ")

			EndIf
		EndIf
	Next

	oDlg:End()

Return

//��������Ŀ
//� EXCLUI �
//����������
Static Function fExclui()

	If MsgYesNo("Tem certeza de que deseja excluir?")
		ZDJ->(dbSetorder(1)) //filial + cod + item
		ZDJ->(dbSeek(xFilial("ZDJ")+cProd))
	
		WHILE ZDJ->(!EOF()) .AND. ZDJ->ZDJ_PROD==cProd

			RecLock("ZE4",.T.)
				ZE4->ZE4_FILIAL := xFilial("ZE4")
				ZE4->ZE4_PROD   := cProd
				ZE4->ZE4_CC     := cCC
				ZE4->ZE4_ITEM   := aCols[x][1]
				ZE4->ZE4_FERRAM := aCols[x][2]
				ZE4->ZE4_ZDJREC := ZDJ->(Recno())
				ZE4->ZE4_ACAO   := 'EXCLUSAO'
				ZE4->ZE4_USER   := UPPER(ALLTRIM(cUserName))
				ZE4->ZE4_DATA   := date()
				ZE4->ZE4_HORA   := time()
			MsUnlock("ZE4")

			RecLock("ZDJ",.F.)
				ZDJ->(dbDelete())
			MsUnLock("ZDJ")

			ZDJ->(dbSkip())
		EndDO
	EndIf	
	
	oDlg:End()

Return

//�������������������������������������Ŀ
//� Traz o saldo da ferramenta reafiada �
//���������������������������������������
Static Function fSalReaf(cProd)
Local nRet := 0

//--Ferramenta reafiada 
//--Se o quarto digito do do produto for <> 5
//--e se B1_TIPO diferente de "PA"
//--Podera ter uma ferramenta reafiada
If subStr(cProd,4,1) <> "5"

	//--Verifica se Existe o produto
	If SB1->(dbSeek(xFilial('SB1')+subStr(cProd,1,3)+"5"+subStr(cProd,5,11)))

		SB2->(dbSeek(xFilial('SB2')+subStr(cProd,1,3)+"5"+subStr(cProd,5,11)))
		
		While !Eof() .And. SB2->B2_FILIAL+SB2->B2_COD == xFilial("SB2")+subStr(cProd,1,3)+"5"+subStr(cProd,5,11)
			
			//--Pega somente a primeira possi��o do vetor de retorno
			nRet += SB2->B2_QATU
			
			//--Proxima linha
			SB2->(dbSkip())
		
		Enddo

	Endif
         
EndIf
 
Return nRet

//���������������������������������Ŀ
//� TRAZ OS DADOS PARA VISUALIZACAO �
//�����������������������������������
Static Function fCarrega()
Local nB1Rec := SB1->(RecNo())
	
	nIndRef := ZDJ->ZDJ_INDREF
 	cCC     := ZDJ->ZDJ_CC
 	
	SB2->(dbSetOrder(1))// filial + cod

	WHILE ZDJ->(!EOF()) .AND. ZDJ->ZDJ_PROD == SB1->B1_COD
	        
		SB2->(dbSeek(xFilial("SB2")+ZDJ->ZDJ_FERRAM+Iif(SM0->M0_CODIGO=='IT','35','31')))
		
		aAdd(aCols,{ZDJ->ZDJ_ITEM,;
					ZDJ->ZDJ_FERRAM,;
					Posicione("SB1",1,xFilial("SB1")+ZDJ->ZDJ_FERRAM,"B1_DESC"),;
					SB2->B2_QATU-SB2->B2_QEMPSA,;
					fSalReaf(ZDJ->ZDJ_FERRAM),;
					ZDJ->ZDJ_OP,;
					ZDJ->ZDJ_VUMONT,;
					ZDJ->ZDJ_QTREAF,;
					ZDJ->ZDJ_ARESTA,;
					ZDJ->ZDJ_FMONT,;
					ZDJ->ZDJ_VUSET,;
					ZDJ->ZDJ_INDQUE,;
					ZDJ->ZDJ_NMAQ,;
					ZDJ->ZDJ_EMIN,;
					ZDJ->ZDJ_FORMUL,;
					.F.})

		ZDJ->(dbSkip())
		SB1->(dbGoTo(nB1Rec))
	ENDDO

Return .T.

//���������Ŀ
//� LEGENDA �
//�����������
User Function EST160LEG()

Local aLegenda :=	{ {"BR_VERDE"    , "Ferramentas Cadastradas"  },;
                      {"BR_VERMELHO" , "Ferramentas n�o Cadastradas" } }

BrwLegenda("Ferramentas x Pe�as", "Legenda", aLegenda)

Return  

//�����������������������Ŀ
//� CRIA A COR DA LEGENDA �
//�������������������������
Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"    , "Ferram. Cadastradas"  },;
                      {"BR_VERMELHO" , "Ferram. n�o Cadastr." } }

Local uRetorno := {}

Aadd(uRetorno, { 'U_ZDJXSB1()' , aLegenda[1][1] } )
Aadd(uRetorno, { '!U_ZDJXSB1()' , aLegenda[2][1] } )

Return(uRetorno)                                    

//�����������������������������������������������������������Ŀ
//� VERIFICA SE EXISTEM FERRAMENTAS CADASTRADAS NA TABELA ZDJ �
//�������������������������������������������������������������
User function ZDJXSB1()
	Local cItem := Posicione("ZDJ",1,xFilial("ZDJ")+SB1->B1_COD,"ZDJ_ITEM")
Return !Empty(cItem)

/*
//����������������������������������������������Ŀ
//� ABRE TELA PARA ALTERA��O DO INDICE DE REFUGO �
//������������������������������������������������
User Function EST160REF()      
Local bOk   := {|| fGrvRef()  }
Local bCanc := {|| oDlg:End() }

Private nIndRef := ZDJ->ZDJ_INDREF

	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
			
	oDlg  := MsDialog():New(0,0,70,400,"Indice de Refugo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"Indice de Refugo"},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(18,60,{|u| if(Pcount() > 0, nIndRef := u,nIndRef)},oDlg,40,8,PesqPict("ZDJ","ZDJ_INDREF"),,;
		,,,,,.T.,,,{||.T.},,,,,,,"nIndRef")

	oDlg:Activate(,,,.T.,{||.T.},,bEnchoice)
	
Return

//�������������������������������������Ŀ
//� ATUALIZA TODOS OS INDICES DE REFUGO �
//���������������������������������������
Static Function fGrvRef()
	
	dbSelectArea("ZDJ")
	SET FILTER TO
	dbGoTop()
	
	WHILE !EOF()
		RecLock("ZDJ",.F.)
			ZDJ->ZDJ_INDREF := nIndRef
		MsUnlock("ZDJ")
	
		ZDJ->(dbSkip())
	ENDDO
	
	oDlg:End()	
		
Return
                                   
*/                

Static Function fDuplica()
Local bOk   := {|| fGrvDupl()  }
Local bCanc := {|| oDlg:End() }
Local cTXTPrd := alltrim(SB1->B1_COD)+" - "+SB1->B1_DESC
Private cPrdDes := space(15)
Private cCC := space(9)
Private cPDesc := ''
Private cCDesc := ''

	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
			
	oDlg  := MsDialog():New(0,0,120,510,"Duplica��o de Ferramentas",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(10,10,{||"Duplicar as Ferramentas do produto: "+cTXTPrd},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(22,10,{||"Para o seguinte produto: "},oDlg,,,,,,.T.,,)
	
	oGet1 := tGet():New(20,75,{|u| if(Pcount() > 0, cPrdDes := u,cPrdDes)},oDlg,60,8,"@!",,;
		,,,,,.T.,,,{||f2VldPrd()},,,,,,"SB1","cPrdDes")

	oGet2 := tGet():New(20,140,{|u| if(Pcount() > 0, cPDesc := u,cPDesc)},oDlg,110,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cPDesc")

	oSay3 := TSay():New(34,10,{||"C.Custo"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(32,75,{|u| if(Pcount() > 0, cCC := u,cCC)},oDlg,45,8,"@!",{||fValCC()},;
		,,,,,.T.,,,{||.T.},,,,,,"CTT","cCC")
	
	oGet4 := tGet():New(32,125,{|u| if(Pcount() > 0, cCDesc := u,cCDesc)},oDlg,125,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cCDesc")

	oDlg:Activate(,,,.T.,{||.T.},,bEnchoice)

Return

Static Function f2VldPrd()

	If !Empty(cPrdDes)
		SB1->(dbSetOrder(1)) // FILIAL + COD
		If SB1->(dbSeek(xFilial("SB1")+cPrdDes))
		
			If SB1->B1_TIPO$"PA/CC"
				cPDesc := SB1->B1_DESC
				cCC := '34'+substr(SB1->B1_CC,3,7)
				oGet2:Refresh()
				oGet3:Refresh()
			Else
				alert('Produto deve ser do tipo PA ou CC')
				RETURN .F.
			Endif
			
		Else
			alert("Produto n�o encotnrado!")
			Return .F.
		EndIf
	EndIf
	
Return

Static Function fGrvDupl()
Local aMat := {}
    
    WHILE ZDJ->(!EOF()) .AND. ZDJ->ZDJ_PROD==cProd

		aAdd(aMat,{	ZDJ->ZDJ_INDREF ,; // 1  
					ZDJ->ZDJ_FERRAM ,; // 2  
					ZDJ->ZDJ_OP     ,; // 3
					ZDJ->ZDJ_VUMONT ,; // 4
					ZDJ->ZDJ_QTREAF ,; // 5
					ZDJ->ZDJ_ARESTA ,; // 6
					ZDJ->ZDJ_FMONT  ,; // 7
					ZDJ->ZDJ_VUSET  ,; // 8
					ZDJ->ZDJ_INDQUE ,; // 9
					ZDJ->ZDJ_NMAQ   ,; // 10
					ZDJ->ZDJ_EMIN   ,; // 11
					ZDJ->ZDJ_FORMUL }) // 12
	
		ZDJ->(dbSkip())
	EndDO
	
	For xM:=1 to Len(aMat)

		RecLock("ZDJ",.T.)
			ZDJ->ZDJ_FILIAL := xFilial("ZDJ")
			ZDJ->ZDJ_PROD   := cPrdDes
			ZDJ->ZDJ_CC     := cCC
			ZDJ->ZDJ_INDREF := aMat[xM][1]
			ZDJ->ZDJ_ITEM   := StrZero(xM,4)
			ZDJ->ZDJ_FERRAM := aMat[xM][2]
			ZDJ->ZDJ_OP     := aMat[xM][3]
			ZDJ->ZDJ_VUMONT := aMat[xM][4]
			ZDJ->ZDJ_QTREAF := aMat[xM][5]
			ZDJ->ZDJ_ARESTA := aMat[xM][6]
			ZDJ->ZDJ_FMONT  := aMat[xM][7]
			ZDJ->ZDJ_VUSET  := aMat[xM][8]
			ZDJ->ZDJ_INDQUE := aMat[xM][9]
			ZDJ->ZDJ_NMAQ   := aMat[xM][10]
			ZDJ->ZDJ_EMIN   := aMat[xM][11]
			ZDJ->ZDJ_FORMUL := aMat[xM][12]
		MsUnlock("ZDJ")
	
	Next

	Alert('Duplica��o efetuada com sucesso!')
		
	oDlg:End()
	
Return