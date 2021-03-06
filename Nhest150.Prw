/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST150  �Autor  �Jo�o Felipe da Rosa � Data �  23/07/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � LAN�AMENTO DE REFUGO                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#INCLUDE "protheus.ch"

User Function NHEST150()

Private aRotina, cCadastro

//axcadastro("ZD0")
//axcadastro("ZD1")

cCadastro := "Lan�amento de Refugo"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_EST150(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_EST150(3)" 	, 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"U_EST150(4)"  , 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"U_EST150(5)"  , 0 , 5})
aAdd(aRotina,{ "Defeitos"       ,"U_DEF150()"   , 0 , 3})

mBrowse(6,1,22,75,"ZD0",,,,,,fCriaCor())

Return

//��������������������
//� TELA DO CADASTRO �
//��������������������
User Function EST150(nParam) 
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private nPar 	  := nParam  
Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)
Private cNum      := ""
Private cTurno    := 0
Private aTurno    := {"1=Primeiro","2=Segundo","3=Terceiro"}
Private dData     := date()
Private cProd     := Space(15)
Private cDesProd  := ""       
Private cStatus   := 0
Private aStatus   := {"L=Liberado","C=Car�ncia","D=Desenvolvimento"}
Private nExped    := 0
Private nRefugo   := 0
Private nInspec   := 0
Private nPRef     := 0
Private aHeader   := {}
Private aCols     := {}

	aAdd(aHeader,{"Item"       , "ZD1_ITEM"    , PesqPict("ZD1","ZD1_ITEM")   , 04,00, ".F."           ,"","C","ZD1"})
	aAdd(aHeader,{"Defeito"    , "ZD1_DEFEIT"  , PesqPict("ZD1","ZD1_DEFEIT") , 06,00, "U_EST150PR()"  ,"","C","ZD1"})
	aAdd(aHeader,{"Descri��o"  , "B1_DESC"     , PesqPict("SB1","B1_DESC")    , 50,00, ".F."           ,"","C","SB1"})
	aAdd(aHeader,{"Quantidade" , "ZD1_QUANT"   , PesqPict("ZD1","ZD1_QUANT")  , 06,00, "U_EST150Re()"  ,"","N","ZD1"})

	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir 
		cNum := GetSxENum("ZD0","ZD0_NUM")
		bOk := {|| fInclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
	ElseIf nPar==4 //alterar
		fCarrega()
		bOk := {|| fAltera()}
	ElseIf nPar==5 //excluir
		fCarrega()
		bOk := {|| fExclui()}
	EndIf
	
	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)

	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Lan�amento de Refugo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"N�mero"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oSay2 := TSay():New(20,50,{||cNum},oDlg,,oFont1,,,,.T.,,)

	oSay3 := TSay():New(20,130,{||"Data"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(18,170,{|u| if(Pcount() > 0, dData := u,dData)},oDlg,40,8,PesqPict("ZD0","ZD0_DATA"),{||.T.},;
		,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"dData")

	oSay4 := TSay():New(32,10,{||"Produto"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(30,50,{|u| if(Pcount() > 0, cProd := u,cProd)},oDlg,70,8,PesqPict("ZD0","ZD0_PROD"),{||fProd()},;
		,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,"SB1","cProd")
	oGet3 := tGet():New(30,121,{|u| if(Pcount() > 0, cDesProd := u,cDesProd)},oDlg,150,8,PesqPict("SB1","B1_DESC"),{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesProd")

	oSay5 := TSay():New(44,10,{||"Turno"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo1 := TComboBox():New(42,50,{|u| if(Pcount() > 0,cTurno := u,cTurno)},;
		aTurno,50,20,oDlg,,{||},,,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"cTurno")

	oSay6 := TSay():New(44,130,{||"Status"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo2 := TComboBox():New(42,170,{|u| if(Pcount() > 0,cStatus := u,cStatus)},;
		aStatus,50,20,oDlg,,{||},,,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"cStatus")

	oSay7 := TSay():New(56,10,{||"Expedido"},oDlg,,,,,,.T.,,)
	oGet4 := tGet():New(54,50,{|u| if(Pcount() > 0, nExped := u,nExped)},oDlg,50,8,PesqPict("ZD0","ZD0_EXPED"),{||fIncRef()},;
		,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"nExped")
	
	oSay8 := TSay():New(68,10,{||"Refugo"},oDlg,,,,,,.T.,,)
	oGet5 := tGet():New(66,50,{|u| if(Pcount() > 0, nRefugo := u,nRefugo)},oDlg,50,8,PesqPict("ZD0","ZD0_REFUGO"),{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"nRefugo")

	oSay9 := TSay():New(80,10,{||"Inspecionado"},oDlg,,,,,,.T.,,)
	oGet6 := tGet():New(78,50,{|u| if(Pcount() > 0, nInspec := u,nInspec)},oDlg,50,8,PesqPict("ZD0","ZD0_INSPEC"),{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"nInspec")

	oSay10 := TSay():New(92,10,{||"% Refugo"},oDlg,,,,,,.T.,,)
	oGet7  := tGet():New(90,50,{|u| if(Pcount() > 0, nPRef := u,nPRef)},oDlg,50,8,"@e 99%",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"nPRef")

    // cria o getDados
	oGeTD := MsGetDados():New( /*aPosObj[2,1]*/ 104     ,; //superior
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
	                           200              ,; // nMax
	                           nil              ,; // cCampoOk
	                           "AllwaysTrue()"  ,; // CSUPERDEL
	                           nil              ,; // uPar2
	                           "AllwaysTrue()"  ,; // CDELOK
	                           oDlg              ; // oWnd
	                          )
                               
	If nPar==2 .Or. nPar==5 //visualizar e excluir
		oGetD:nMax := Len(aCols)
	EndIf
	
	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

//��������Ŀ
//� VALIDA �
//����������
Static Function fValida()

	If Empty(dData)
		alert("Informe a data!")
		Return .F.
	EndIf
	
	If Empty(cProd)
		alert("Informe o produto!")
		Return .F.
	EndIf
	
	If Empty(cTurno)
		alert("Informe o turno!")
		Return .F.
	EndIf
	
	If Empty(cStatus)
		alert("Informe o status!")
		Return .F.
	EndIf
	
	//verifica duplicidade de defeitos
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1]
			For y:=1 to Len(aCols)
				If !aCols[y][len(aHeader)+1]
				
				    If y!=x .AND. aCols[x][2]==aCols[y][2] 
				    	Alert("Existe defeito duplicado!")
				    	Return .F.
				    EndIf
				EndIf
			Next
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
	
	RecLock("ZD0",.T.)
		ZD0->ZD0_FILIAL := xFilial("ZD0")
		ZD0->ZD0_NUM    := cNum 
		ZD0->ZD0_DATA   := dData
		ZD0->ZD0_PROD   := cProd
		ZD0->ZD0_TURNO  := cTurno
		ZD0->ZD0_STATUS := cStatus
		ZD0->ZD0_EXPED  := nExped
		ZD0->ZD0_REFUGO := nRefugo
		ZD0->ZD0_INSPEC := nInspec
	MsUnlock("ZD0")
	
	//ITENS DO LANCAMENTO DE REFUGO
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] //nao pega quando estiver deletado
			RecLock("ZD1",.T.)
				ZD1->ZD1_FILIAL := xFilial("ZD1")
				ZD1->ZD1_NUM    := cNum 
				ZD1->ZD1_ITEM   := aCols[x][1]
				ZD1->ZD1_DEFEIT := aCols[x][2]
				ZD1->ZD1_QUANT  := aCols[x][4]
			MsUnlock("ZD1")
	    EndIf
	Next

	ConfirmSx8()
	
	oDlg:End()

Return

//��������Ŀ
//� ALTERA �
//����������
Static Function fAltera()
	
	If !fValida()
		Return
	EndIf

	RecLock("ZD0",.F.)
		ZD0->ZD0_DATA   := dData
		ZD0->ZD0_PROD   := cProd
		ZD0->ZD0_TURNO  := cTurno
		ZD0->ZD0_STATUS := cStatus
		ZD0->ZD0_EXPED  := nExped
		ZD0->ZD0_REFUGO := nRefugo
		ZD0->ZD0_INSPEC := nInspec
	MsUnlock("ZD0")
	        
	ZD1->(dbSetOrder(1)) // filial + num + item
	
	//ITENS DO LANCAMENTO DE REFUGO
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] //nao pega quando estiver deletado
			If ZD1->(dbSeek(xFilial("ZD1")+cNum+aCols[x][1]))
				RecLock("ZD1",.F.)
					ZD1->ZD1_DEFEIT := aCols[x][2]
					ZD1->ZD1_QUANT  := aCols[x][4]
				MsUnlock("ZD1")
			Else
				RecLock("ZD1",.T.)
					ZD1->ZD1_FILIAL := xFilial("ZD1")
					ZD1->ZD1_NUM    := cNum 
					ZD1->ZD1_ITEM   := aCols[x][1]
					ZD1->ZD1_DEFEIT := aCols[x][2]
					ZD1->ZD1_QUANT  := aCols[x][4]
				MsUnlock("ZD1")
			EndIf
	    Else
	    	If ZD1->(dbSeek(xFilial("ZD1")+cNum+aCols[x][1]))
				RecLock("ZD1",.F.)
					ZD1->(dbDelete())
				MsUnlock("ZD1")
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
		RecLock("ZD0",.F.)
			ZD0->(dbDelete())
		MsUnLock("ZD0")
		
		ZD1->(dbSetOrder(1)) // filial + num + item
		ZD1->(dbSeek(xFilial("ZD1")+cNum))
		
		WHILE ZD1->(!EOF()) .AND. ZD1->ZD1_NUM==cNum
			
			RecLock("ZD1",.F.)
				ZD1->(dbDelete())
			MsUnlock("ZD1")

			ZD1->(dbSkip())
		ENDDO
	EndIf	
	
	oDlg:End()

Return

//���������������������������������Ŀ
//� TRAZ OS DADOS PARA VISUALIZACAO �
//�����������������������������������
Static Function fCarrega()

	cNum  := ZD0->ZD0_NUM
	dData := ZD0->ZD0_DATA

	cNum    := ZD0->ZD0_NUM
	dData   := ZD0->ZD0_DATA
	cProd   := ZD0->ZD0_PROD
	
	SB1->(dbSetOrder(1)) // FILIAL + COD
	SB1->(dbSeek(xFilial('SB1')+cProd))
	cDesProd := SB1->B1_DESC
	
	cTurno  := ZD0->ZD0_TURNO
	cStatus := ZD0->ZD0_STATUS
	
	nExped  := ZD0->ZD0_EXPED
	nRefugo := ZD0->ZD0_REFUGO
	nInspec := ZD0->ZD0_INSPEC
	nPRef   := (nRefugo/nExped)*100

	ZD1->(dbSetOrder(1)) // filial + num + item
	ZD1->(dbSeek(xFilial("ZD1")+cNum))
		
	SX5->(dbSetOrder(1)) //filial + tabela + chave

	WHILE ZD1->(!EOF()) .AND. ZD1->ZD1_NUM==cNum
	   	SX5->(dbSeek(xFilial("SX5")+"AC"+ZD1->ZD1_DEFEIT))

		aAdd(aCols,{ZD1->ZD1_ITEM,ZD1->ZD1_DEFEIT,SX5->X5_DESCRI,ZD1->ZD1_QUANT,.F.})			

		ZD1->(dbSkip())
	ENDDO
	
Return

//�������������������������������������Ŀ
//� VALIDA O PRODUTO E TRAZ A DESCRICAO �
//���������������������������������������
Static Function fProd()

	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+cProd))
		cDesProd := SB1->B1_DESC
		oGet3:Refresh()
	Else
		Alert("Produto n�o encontrado!")
		Return .F.
	EndIf	

Return .T.

//�������������������������������
//� INICIALIZADOR DO CAMPO ITEM �
//�������������������������������
User Function ZD1ITEM()
Local cItem := ""
Local nItem := n

    For x:=1 to Len(aCols)-1
    	If Val(aCols[x][1]) >= nItem
	    	nItem := Val(aCols[x][1])+1
	    EndIf
	Next    

	cItem := StrZero(nItem,4)

Return cItem

//��������������������������������
//� INCREMENTA O CAMPO DO REFUGO �
//��������������������������������
User Function EST150Re()
Local nQuant := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZD1_QUANT"})

	nRefugo := M->ZD1_QUANT
	
	//atualiza o campo de refugo
    For x:=1 to Len(aCols)
  		If x!=n
  			nRefugo += aCols[x][nQuant]
  		EndIf
    Next
	oGet5:Refresh()

	fIncRef()
	
Return .T.

Static Function fIncRef()
	
	//atualiza o campo inspecionado
	nInspec	:= nRefugo + nExped
	oGet6:Refresh()	

	//atualiza a porcentagem de refugo
	nPRef := (nRefugo/nInspec)*100
	oGet7:Refresh()

Return .T.

//�������������������������������������Ŀ
//� ABRE TELA PARA CADASTRO DE DEFEITOS �
//���������������������������������������
User Function DEF150()
Private aHeader   := {}
Private aCols     := {}
         
	aAdd(aHeader,{"C�digo"     , "X5_CHAVE"    , "@E 999999" , 06,00, ".T."   ,"","C","SX5"})
	aAdd(aHeader,{"Defeito"    , "X5_DESCRI"   , "@!"        , 50,00, ".T."   ,"","C","SX5"})

	//CARREGA TODOS OS DEFEITOS DA TABELA AC DO SX5
	SX5->(dbGoTop())
	SX5->(dbSetOrder(1))//X5_FILIAL+X5_TABELA+X5_CHAVE
	
	SX5->(dbSeek(xFilial("SX5")+"AC")) // AC = TABELA DE DEFEITOS DE REFUGO
	
	While SX5->(!EOF()) .AND. SX5->X5_TABELA=="AC"
		aAdd(aCols,{SX5->X5_CHAVE,SX5->X5_DESCRI,.F.})
    	SX5->(dbSkip())
	EndDo

    //MONTA A TELA
	oDlg  := MsDialog():New(0,0,400,300,"Defeitos de Refugo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

    // cria o getDados
	oGeTD := MsGetDados():New( 5                ,; //superior
	                           5                ,; //esquerda
	                           175              ,; //inferior
	                           145              ,; //direita
	                           4                ,; // nOpc
	                           "AllwaysTrue"    ,; // CLINHAOK
	                           "AllwaysTrue"    ,; // CTUDOOK
	                           ""               ,; // CINICPOS
	                           .T.              ,; // LDELETA
	                           nil              ,; // aAlter
	                           nil              ,; // uPar1
	                           .F.              ,; // LEMPTY
	                           200              ,; // nMax
	                           nil              ,; // cCampoOk
	                           "AllwaysTrue()"  ,; // CSUPERDEL
	                           nil              ,; // uPar2
	                           "AllwaysTrue()"  ,; // CDELOK
	                           oDlg              ; // oWnd
	                          )
	                          
    oBtn1 := tButton():New(180,105,"Ok",oDlg,{||fGrvDef()},40,10,,,,.T.)

	oDlg:Activate(,,,.T.,{||.T.},,{||})

Return

//��������������������
//� GRAVA OS DEFEITOS �
//��������������������
Static Function fGrvDef()

	SX5->(dbGoTop())
	SX5->(dbSetOrder(1))//X5_FILIAL+X5_TABELA+X5_CHAVE

	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] //nao pega quando estiver deletado
		   	If SX5->(dbSeek(xFilial("SX5")+"AC"+aCols[x][1]))
		    	RecLock("SX5",.F.)
		    		SX5->X5_DESCRI  := aCols[x][2]
					SX5->X5_DESCSPA := aCols[x][2]
		    		SX5->X5_DESCENG := aCols[x][2]
		   		MsUnLock("SX5")
		   	Else
		   		RecLock("SX5",.T.)
		   			SX5->X5_FILIAL  := xFilial("SX5")
		   			SX5->X5_TABELA  := "AC"
		   			SX5->X5_CHAVE   := aCols[x][1]
		    		SX5->X5_DESCRI  := aCols[x][2]
					SX5->X5_DESCSPA := aCols[x][2]
		    		SX5->X5_DESCENG := aCols[x][2]
		   		MsUnLock("SX5")
		   	EndIf
		Else
		   	If SX5->(dbSeek(xFilial("SX5")+"AC"+aCols[x][1]))
		    	RecLock("SX5",.F.)
		    		SX5->(dbDelete())
		   		MsUnLock("SX5")
			EndIf		   
		EndIf
	Next
	
	oDlg:End()

Return

//�����������������������������������������������Ŀ
//� VALIDA O CODIGO DO DEFEITO E TRAZ A DESCRICAO �
//�������������������������������������������������
User Function EST150PR()

	//verifica duplicidade de defeitos
	For x:=1 to Len(aCols)
		If n!=x .AND. M->ZD1_DEFEIT==aCols[x][2] .AND. !aCols[x][len(aHeader)+1]
			Alert("Defeito j� informado!")
			Return .F.
		EndIf
    Next

	SX5->(dbSetOrder(1))//X5_FILIAL+X5_TABELA+X5_CHAVE
	If SX5->(dbSeek(xFilial("SX5")+"AC"+M->ZD1_DEFEIT))
		aCols[n][3] := SX5->X5_DESCRI
		oGetD:Refresh()	
	Else
		Alert("Defeito n�o encontrado!")
		Return .F.
	EndIf
Return .T.