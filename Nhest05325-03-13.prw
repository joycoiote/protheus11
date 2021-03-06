/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST053  �Autor  �Marcos R Roquitski  � Data �  28/04/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Composicao do codigo do produto.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �WHB                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch" 
#INCLUDE "topconn.ch"   

User Function Nhest053()
	SetPrvt("_Sigla,_Grupo,_Etapa,_Compo,_Loja,_cGrupo,_cEtapa,_cCompo,_cNovo,cQuery,_cCombo,_aCombo,_cCarac,_cProt,_cArq,nB1Rec,_cMatr,_cPrensa")
	
	_cArq := Select()

	If SM0->M0_CODIGO = 'NH'
		_Cliente := Space(06)
		_Loja    := Space(02)
		_Sigla   := Space(02)
		_Grupo   := Space(02)
		_cGrupo  := Space(30)
		_Etapa   := Space(01)
		_cEtapa  := Space(30)
		_Compo   := Space(03)
		_cCompo  := Space(30)
		_cNovo   := 'N'
		_cCod    := Space(15)
		_cApqp   := Space(15)
		_aCombo  := {"Novo Projeto","Similar","Estrutura","Componente"}
		_cCombo  := " "
		_lCria   := .F.
		
		@ 200,050 To 480,500 Dialog oDlg Title OemToAnsi("Composicao do Codigo do Produto")
		@ 010,020 Say OemToAnsi("Projeto ") Size 35,8
		@ 025,020 Say OemToAnsi("Similar ") Size 35,8 
		@ 025,124 Say OemToAnsi("Estrutura") Size 30,8
		@ 040,020 Say OemToAnsi("Cliente     ") Size 35,8
		@ 040,140 Say OemToAnsi("Sigla       ") Size 35,8
		@ 055,020 Say OemToAnsi("Grupo       ") Size 35,8
		@ 070,020 Say OemToAnsi("Etapa       ") Size 35,8
		@ 085,020 Say OemToAnsi("Componente  ") Size 35,8

		@ 009,070 COMBOBOX _cCombo ITEMS _aCombo SIZE 50,10 object oCombo
		@ 024,070 Get _cCod         PICTURE "@!" F3 "SB1" Valid(fCod(_cCod)) When Substr(_cCombo,1,1) == 'S' Size 50,8
		@ 024,155 Get _cApqp        PICTURE "@!" F3 "SB1" Valid(fCod(_cApqp)) When Substr(_cCombo,1,1) == 'E' Size 50,8
		@ 039,070 Get _Cliente      PICTURE "@!" F3 "SA1" Valid(fCliente()) When Substr(_cCombo,1,1) $ 'NC' Size 20,8
		@ 039,102 Get _Loja         PICTURE "@!" Valid(fLoja()) When Substr(_cCombo,1,1) $ 'NC' Size 10,8
		@ 039,155 Get _Sigla        PICTURE "@!" Size 15,8 When .F.
		@ 054,070 Get _Grupo        PICTURE "@!" F3 "SZJ" Size 10,8 Valid(fGrupo()) When Substr(_cCombo,1,1) $ 'NC'
		@ 054,090 Get _cGrupo       PICTURE "@!" When .f. Size 83,8
		@ 069,070 Get _Etapa        PICTURE "@!" F3 "SZL" Size 06,8 Valid(fEtapa()) When Substr(_cCombo,1,1) == 'E'
		@ 069,090 Get _cEtapa       PICTURE "@!" When .f. Size 83,8 Object ocEtapa		                
		@ 084,070 Get _Compo        PICTURE "@!" F3 "SZK" Size 10,8 When Alltrim(_Etapa) == '5' Valid(fCompo())
		@ 084,098 Get _cCompo       PICTURE "@!" When .f. Size 75,8
   
		@ 110,070 BMPBUTTON TYPE 01 ACTION fGeraCodigo()
		@ 110,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

		Activate Dialog oDlg CENTERED

	Elseif SM0->M0_CODIGO = 'FN'

		_DescSi  := Space(03)
		_Loja    := Space(02)
		_Sigla   := Space(03)
		_Grupo   := Space(02)
		_cGrupo  := Space(30)
		_Etapa   := Space(01)
		_cEtapa  := Space(30)
		_Compo   := Space(03)
		_cCompo  := Space(30)
		_cNovo   := 'N'
		_cCod    := Space(15)
		_cApqp   := Space(15)
		_aCombo  := {"Prototipo","Similar","Estrutura","Componente","Fer.Forjaria"}
		//_aMatr   := {"1-Matriz Inferior","2-Matriz Superior","3-Componentes","4-Componentes","5-Componentes"}
		_aMatr   := {"00-MONTAGEM",;
					 "01-MATRIZ INFERIOR",;
					 "02-MATRIZ SUPERIOR",;
					 "03-PINO EXTRATOR INFERIOR",;
					 "04-PINO EXTRATOR SUPERIOR",;
					 "05-POSTI�O INFERIOR",;
					 "06-POSTI�O SUPERIOR",;
					 "07-APOIO FURADOR",;
					 "08-FACA",;
					 "09-EXTRATOR REBARBADOR",;
					 "10-EXTRATOR FURADOR",;
					 "11-PUN��O DE FURAR",;
					 "12-PUN��O DE REBARBAR",;
					 "13-CORPO PUN��O",;
					 "14-PONTA",;
					 "15-CONJUNTO PUN��O",;
					 "16-SUPORTE DO PUN��O",;
					 "17-COMPONENTES",;
					 "18-CONJ. SUP. GARRA",;
					 "19-SUP. PUN��O FURADOR",;
					 "20-SUP. PUN��O REBARBADOR",;
					 "21-PLACA DE CHOQUE",;
					 "22-POSTI�O CENTRAL",;
					 "23-ADAPTADOR INF.1�/2�/3� OP",;
					 "24-ADAPTADOR SUP.1�/2�/3� OP",;
					 "25-ADAPTADOR INF.4� OP",;
					 "26-ADAPTADOR SUP.4� OP",;
					 "27-ADAPTADOR INF.5� OP",;
					 "28-ADAPTADOR SUP.5� OP",;
					 "29-PORTA POSTI�O",;
					 "30-PINO CENTRAL",;
					 "31-PINO EXTREMIDADE",;
					 "32-CONJ. GARRA",;
					 "33-GARRA TARUGO",;
					 "34-GARRA 1� OP",;
					 "35-GARRA 2� OP",;
					 "36-GARRA 3� OP",;
					 "37-GARRA 4� OP",;
					 "38-GARRA 5� OP",;
					 "39-CHAVETA",;
					 "40-PORTA POSTI�O FURADOR",;
					 "41-POSTI�O INF. FURADOR",;
					 "42-CAPA POSTI�O INF.",;
					 "43-CAPA POSTI�O SUP.",;
					 "44-EXTRATOR",;
					 "45-CAPA POSTI�O",;
					 "46-PINO GUIA",;
					 "47-PORTA EXTRATOR"}
					 
		_aMatr2  := {"00-MONTAGEM",;
					 "01-MATERIA PRIMA",;
					 "02-TRAT. TERMICO",;
					 "03-USINAGEM",;
					 "04-BLOCO PADR�O",;
					 "05-PORTA POSTI�O P2500",;
					 "06-ADAPTADOR INF. 1�/2�/3� OP",;
					 "07-ADAPTADOR SUP. 1�/2�/3� OP",;
					 "08-ADAPTADOR STD.",;
					 "09-PINO EXTR. CENTRAL",;
					 "10-PINO EXTR. EXTREMIDADE",;
					 "11-CHAVETAS",;
					 "12-PINO EJETOR",;
					 "13-CAPA POSTI�O",;
					 "14-CAL�O P/ REBAIXAMENTO",;
					 "15-COMPONENTES MONTAGEM",;
					 "16-ACESSORIO MONTAGEM",;
					 "17-MOLAS",;
					 "18-CAL�O P/ MOLA",;
					 "19-ACESS. TRANSFER",;
					 "20-ACESS. ROLO LAMINADOR",;
					 "21-ROLO LAMINADOR",;
					 "22-PINO LIMITADOR",;
					 "23-LIMITADOR",;
					 "24-GUIA",;
					 "25-PLACA GUIA",;
					 "26-PLACA DE CHOQUE",;
					 "27-FLANGE FURADOR",;
					 "28-FLANDE REBARBADOR",;
					 "29-ADAPTADOR INF. 4� OP",;
					 "30-ADAPTADOR SUP. 4� OP",;
					 "31-ADAPTADOR INF. 5� OP",;
					 "32-ADAPTADOR SUP. 5� OP",;
					 "33-PORTA POSTI�O P1600",;
					 "34-CAL�O CARREGADOR",;
					 "35-CAL�O DO ALIMENTADOR",;
					 "36-SUPORTE DA PLACA GUIA",;
					 "37-CENTRALIZADOR DIREITO",;
					 "38-CENTRALIZADOR ESQUERDO",;
					 "39-CARREGADOR ALIMENTADOR",;
					 "40-CARREGADOR LAMIN. ALIVIO",;
					 "41-SUPORTE DA REGUA SUPERIOR",;
					 "42-EJETOR DO LAMINADO",;
					 "43-PORTA POSTI�O P3500",;
					 "44-CAL�O SUPERIOR",;
					 "45-REGUA SUPERIOR",;
					 "46-EJETOR",;
					 "47-PORTA MATRIZ INFERIOR",;
				     "48-PORTA MATRIZ SUPERIOR",;
					 "49-POSTI�O PADR�O INFERIOR",;
					 "50-POSTI�O PADR�O SUPERIOR"}
										 
	 	_cSeqX := space(2)
	 											
		_cCombo  := " "
		_lCria   := .F.
		
		@ 200,050 To 530,500 Dialog oDlg Title OemToAnsi("Composicao do Codigo do Produto")
		@ 010,020 Say OemToAnsi("Projeto ") Size 35,8
		@ 025,020 Say OemToAnsi("Similar ") Size 35,8 
		@ 025,124 Say OemToAnsi("Estrutura") Size 30,8
		@ 040,020 Say OemToAnsi("Sigla    ") Size 35,8
		@ 055,020 Say OemToAnsi("Grupo        ") Size 35,8
		@ 070,020 Say OemToAnsi("Etapa        ") Size 35,8
		@ 085,020 Say OemToAnsi("Componente   ") Size 35,8
		@ 100,020 Say OemToAnsi("C�d. Item")     Size 35,8
		@ 115,020 Say OemToAnsi("Sequencial")    Size 35,8
		@ 130,020 Say OemToAnsi("Prensa")        Size 35,8
		
		@ 009,070 COMBOBOX _cCombo ITEMS _aCombo SIZE 50,10 object oCombo
		@ 024,070 Get _cCod         PICTURE "@!" F3 "SB1" Valid(fCod(_cCod)) When Substr(_cCombo,1,1) == 'S' Size 50,8
		@ 024,155 Get _cApqp        PICTURE "@!" F3 "SB1" Valid(fCod(_cApqp)) When Substr(_cCombo,1,1) $ 'EF' Size 50,8
		@ 039,070 Get _Sigla        PICTURE "@!" F3 "CII" Valid(fCliFn()) When Substr(_cCombo,1,1) $ 'PC' Size 20,8
		@ 039,102 Get _DescSi       PICTURE "@!" Size 100,8 When .F. Object oDescSi
		@ 054,070 Get _Grupo        PICTURE "@!" F3 "SZJ" Size 10,8 Valid(fGrupo()) When Substr(_cCombo,1,1) $ 'PC'
		@ 054,092 Get _cGrupo       PICTURE "@!" When .f. Size 100,8
		@ 069,070 Get _Etapa        PICTURE "@!" F3 "SZL" Size 06,8 Valid(fEtapa()) When Substr(_cCombo,1,1) == 'E'
		@ 069,092 Get _cEtapa       PICTURE "@!" When .f. Size 100,8 Object ocEtapa
		@ 084,070 Get _Compo        PICTURE "@!" F3 "SZK" Size 10,8 When Alltrim(_Etapa) == '5' Valid(fCompo())
		@ 084,098 Get _cCompo       PICTURE "@!" When .f. Size 100,8     

		oCombo2 := TComboBox():New(99,70,{|u| if(Pcount() > 0,_cMatr := u,_cMatr)},;
			Iif(AllTrim(M->B1_GRUPO)$"FJ40/FJ46",_aMatr2,_aMatr),120,20,oDlg,,{||.T.},{||.T.},,,.T.,,,,{|| Substr(_cCombo,1,1)=="F"},,,,,"_cMatr")
        
	   	@ 114,070 Get _cSeqX        PICTURE "99" Size 20,8

		oCombo3 := TComboBox():New(128,70,{|u| if(Pcount() > 0,_cPrensa := u,_cPrensa)},;
		{"0=2500TON","1=1600TON","2=3500TON","3=0200TON"},120,20,oDlg,,{||.T.},{||.T.},,,.T.,,,,{|| AllTrim(M->B1_GRUPO)$"FJ40/FJ41/FJ42/FJ43/FJ44/FJ45/FJ46/FJ47/FJ48" .and. Substr(_cCombo,1,1)=="F" },,,,,"_cPrensa")

		@ 150,070 BMPBUTTON TYPE 01 ACTION fGeraCodFn()
		@ 150,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)

		Activate Dialog oDlg CENTERED

	Endif
	DbselectArea(_cArq)
	
Return

Static Function fCliente()
Local lReturn := .T.
	SA1->(DbSeek(xFilial("SA1") + _Cliente))
	If SA1->(Found())
		_Sigla := SA1->A1_SIGLA
	Else
		MsgBox("Cliente nao encontrado, Escolha um Cliente Valido !","STOP","Composicao do Codigo do Produto")
		lReturn := .F.
	Endif

	If SM0->M0_CODIGO = 'NH'
		If Substr(_cCombo,1,1) == 'N'
			_Etapa := '4'
		Elseif Substr(_cCombo,1,1) == 'C'
			_Etapa := '5'
		Endif
 	Endif


Return(lReturn)


Static Function fCliFn()
Local lReturn := .F.

	SX5->(DbSetOrder(1))
	
	If SX5->(DbSeek(xFilial("SX5")+"Z9"))                
 	   While !SX5->(Eof()) .And. SX5->X5_TABELA == "Z9"  

	      If Alltrim(SX5->X5_CHAVE) == Alltrim(_Sigla)
	         _DescSi := SX5->X5_DESCRI 
             ObjectMethod(oDescSi, "Refresh()")          
     		 lReturn := .T. 	   	             
             Exit // for�a saida do while pois j� encontrou
	      Endif
	      SX5->(DbSkip())
	   Enddo
    Else
		MsgBox("Cliente nao encontrado, Escolha um Cliente Valido !","STOP","Composicao do Codigo do Produto")
		lReturn := .F.
	Endif	   
	   
	If SM0->M0_CODIGO = 'FN'
		If Substr(_cCombo,1,1) == 'P'
			_Etapa := 'P'
			fEtapa()
 	    Elseif Substr(_cCombo,1,1) == 'C'
			_Etapa := '5'
			fEtapa()			
		Endif
	Endif
    

Return(lReturn)

Static Function fLoja()
Local lReturn := .T.
	SA1->(DbSeek(xFilial("SA1") + _Cliente + _Loja))
	If SA1->(Found())
		_Sigla := SA1->A1_SIGLA
	Else
		MsgBox("Cliente nao encontrado, Escolha um Cliente Valido !","STOP","Composicao do Codigo do Produto")
		lReturn := .F.
	Endif
Return(lReturn)


Static Function fGrupo()
Local lReturn := .T.
	SZJ->(DbSeek(xFilial("SZJ") + _Grupo))
	If !SZJ->(Found())
		MsgBox("Grupo nao encontrado, Escolha um Grupo Valido !","STOP","Composicao do Codigo do Produto")
		lReturn := .F.
	Else
		_cGrupo := SZJ->ZJ_DESCRI
	Endif
Return(lReturn)

Static Function fEtapa()
Local lReturn := .T.
	SZL->(DbSeek(xFilial("SZL") + _Etapa))
	If !SZL->(Found())
		MsgBox("Etapa nao encontrado, Escolha um Etapa Valida !","STOP","Composicao do Codigo do Produto")
		lReturn := .F.
	Else
		_cEtapa := SZL->ZL_DESCRI         
        ObjectMethod(ocEtapa, "Refresh()")		
	Endif
Return(lReturn)

Static Function fCompo()
Local lReturn := .T.
	SZK->(DbSeek(xFilial("SZK") + _Compo))
	If !SZK->(Found())	
		MsgBox("Componente nao encontrado, Escolha um Componente Valido !","STOP","Composicao do Codigo do Produto")
		lReturn := .F.
	Else
		_cCompo := SZK->ZK_DESCRI
	Endif
Return(lReturn)

Static Function fNovo()
Local lReturn := .F.
	If _cNovo $ ('SN')
		lReturn := .T.
	Endif		
Return(lReturn)

Static Function fGeraCodigo()
Local lReturn := .T., _cCodProd := '',_nSeq := 1
	fGeraSeq()
	If Substr(_cCombo,1,1) == 'C' // Componente
		_cCodProd := _Sigla + _Grupo + "." + _Etapa + "." + _Compo + "."
		SB1->(DbSeek(xFilial("SB1") + _cCodProd))
		While Substr(SB1->B1_COD,1,11) = _cCodProd
			_nSeq := Val(Substr(SB1->B1_COD,12,2))+1
			SB1->(DbSkip())
		Enddo
		_cCodProd += StrZero(_nSeq,2)
	Elseif Substr(_cCombo,1,1) == 'N' // Novo
		_cCodProd := _Sigla + _Grupo + "." + _Etapa + "." 
		DbSelectArea("TMP")
		TMP->(DbGoTop())  
		While !TMP->(Eof())
			_nSeq := Val(Substr(TMP->B1_COD,8,3))+1			
			TMP->(DbSkip()) 
		Enddo
		_cCodProd += StrZero(_nSeq,3)+".00"
		DbSelectArea("SB1")
	Elseif Substr(_cCombo,1,1) == 'S'
		_cCodProd := Substr(_cCod,1,11)
		SB1->(DbSeek(xFilial("SB1") + Substr(_cCod,1,11)))
		While Substr(SB1->B1_COD,1,11) = Substr(_cCod,1,11)
			_nSeq := Val(Substr(SB1->B1_COD,12,2)) + 1
			SB1->(DbSkip())
		Enddo
		_cCodProd := Substr(_cCod,1,11) + StrZero(_nSeq,2)
	Elseif Substr(_cCombo,1,1) == 'E' // Estrutura
		_cCodProd := Substr(_cApqp,1,5) + Alltrim(_Etapa) + Substr(_cApqp,7,7)
	Endif
	
	
	M->B1_CODITE := _cCodProd
	M->B1_COD    := _cCodProd
	If fValGrp(Substr(_cCodProd,1,4))
		M->B1_GRUPO  := Substr(_cCodProd,1,4)
	Endif	
	SB1->(DbSeek(xFilial("SB1") + _cCodProd))
	If SB1->(Found())
		MsgBox("Produto ja cadastrado ! Digite um produto valido ","STOP","Composicao do Produto")	
	Else
		M->B1_CODITE := _cCodProd
		M->B1_COD    := _cCodProd
		If fValGrp(Substr(_cCodProd,1,4))
			M->B1_GRUPO  := Substr(_cCodProd,1,4)
		Endif	
	Endif
	Close(oDlg)
	DbSelectArea("TMP")
    DbCloseArea()
	
Return

Static Function fValGrp(_pGrupo)
Local lReturn := .F.
	SBM->(DbSeek(xFilial("SBM") + _pGrupo))
	If SBM->(Found())
		lReturn := .T.
	Endif	
Return(lReturn)


Static Function fGeraCodFn()
Local lReturn := .T., _cCodProd := '',_nSeq := 1
	fGeraSeq()
	If Substr(_cCombo,1,1) == 'C' // Componente
		_cCodProd := _Sigla + _Grupo + "." + _Etapa + "." +"0"+ _Compo + "."
		SB1->(DbSeek(xFilial("SB1") + _cCodProd))
		While Substr(SB1->B1_COD,1,11) = _cCodProd
			_nSeq := Val(Substr(SB1->B1_COD,14,2))+1
			SB1->(DbSkip())
		Enddo
		_cCodProd += StrZero(_nSeq,2)
	Elseif Substr(_cCombo,1,1) == 'P' // Novo
		_cCodProd := _Sigla + _Grupo + "." + _Etapa + "." 
		DbSelectArea("TMP")
		TMP->(DbGoTop())  
		While !TMP->(Eof())
//			_nSeq := Val(Substr(TMP->B1_COD,9,3))+1			
			_nSeq := Val(TMP->B1_COD)+1						
			TMP->(DbSkip()) 
		Enddo
		_cCodProd += StrZero(_nSeq,4)+".00"
		DbSelectArea("SB1")
	Elseif Substr(_cCombo,1,1) == 'S'
		_cCodProd := Substr(_cCod,1,15)
		SB1->(DbSeek(xFilial("SB1") + Substr(_cCod,1,15)))
		While Substr(SB1->B1_COD,1,15) = Substr(_cCod,1,15)
			_nSeq := Val(Substr(SB1->B1_COD,14,2)) + 1
			SB1->(DbSkip())
		Enddo
		_cCodProd := Substr(_cCod,1,13) + StrZero(_nSeq,2)
	Elseif Substr(_cCombo,1,1) == 'E' // Estrutura
		_cCodProd := Substr(_cApqp,1,6) + Alltrim(_Etapa) + Substr(_cApqp,8,8)

	ElseIf Substr(_cCombo,1,1) == 'F' //Ferramental de Forjaria
		If Empty(M->B1_GRUPO)
			Alert("Digite o grupo do produto na aba CADASTRAIS!")
			_cCodProd := Space(15)
		Else
		
			If AllTrim(M->B1_GRUPO)$"FJ40/FJ46"
			
				If Empty(M->B1_FAMFOR)
					Alert("Digite a Fam�lia da Ferramenta da Forjaria na aba CADASTRAIS!")
					_cCodProd := Space(15)
				Endif
			
				_cCodProd := Substr(M->B1_GRUPO,1,4)+"."+_cPrensa+M->B1_FAMFOR+"."+Substr(_cMatr,1,2)+"."+_cSeqX
			Else
		
				_cCodProd := Substr(M->B1_GRUPO,1,4)+"."+_cPrensa+Substr(_cApqp,10,3)+"."+Substr(_cMatr,1,2)+"."
				
				/*
				cSeq := "01"
				nB1Rec := SB1->(Recno())
				SB1->(dbSetOrder(1))
				While .T.
					If SB1->(dbSeek(xFilial("SB1")+_cCodProd+cSeq))
						cSeq := StrZero(Val(cSeq)+1,2)
					Else
						exit
					EndIf
		
				EndDo
				*/
				
				cSeq := _cSeqX
					
				_cCodProd := _cCodProd + cSeq
				
			   // SB1->(dbGoTo(nB1Rec))

			Endif
		EndIf
	    
	Endif
	M->B1_CODITE := _cCodProd
	M->B1_COD    := _cCodProd
	If fValGrp(Substr(_cCodProd,1,4))
		M->B1_GRUPO  := Substr(_cCodProd,1,4)
	Endif	
	SB1->(DbSeek(xFilial("SB1") + _cCodProd))
	If SB1->(Found())
		MsgBox("Produto ja cadastrado ! Digite um produto valido ","STOP","Composicao do Produto")	
	Else
	    If Len(_cCodProd) < 15 .And. Subs(Alltrim(_cCodProd),12,1)=="."
			M->B1_CODITE := Space(15)
			M->B1_COD    := Space(15)
		    MsgBox("Esta faltando digito no Codigo do Produto ! Digite um produto valido ","STOP","Composicao do Produto")
		Else
			M->B1_CODITE := _cCodProd
			M->B1_COD    := _cCodProd
			If fValGrp(Substr(_cCodProd,1,4))
				M->B1_GRUPO  := Substr(_cCodProd,1,4)
			Endif	

		Endif
	Endif	
	Close(oDlg)
	DbSelectArea("TMP")
    DbCloseArea()
	
Return

Static Function fCod(cParam)
Local lReturn := .T.
	SB1->(DbSeek(xFilial("SB1") + cParam))
	If !SB1->(Found())
		IF !AllTrim(M->B1_GRUPO)$"FJ40/FJ41/FJ42/FJ43/FJ44/FJ45/FJ46/FJ47/FJ48"
			MsgBox("Produto nao cadastrado ! Digite um produto valido ","STOP","Composicao do Produto")
			lReturn := .F.
		Endif
	Endif
Return(lReturn)


Static Function fGeraSeq()                   
                            
	If SM0->M0_CODIGO = 'FN'
		If Substr(_cCombo,1,1) == 'P' // Novo
			cQuery := "SELECT SUBSTRING(B1.B1_COD,9,4) AS B1_COD FROM " +  RetSqlName( 'SB1' ) + " B1 "
			cQuery += " WHERE B1.B1_COD LIKE '%.P.%' "
   		    cQuery += " AND D_E_L_E_T_ = ' ' "             
			cQuery += " GROUP BY SUBSTRING(B1.B1_COD,9,4) "    
			cQuery += " ORDER BY SUBSTRING(B1.B1_COD,9,4) "    
	  //      MemoWrit('C:\TEMP\EST053.SQL',cQuery)		
			TCQUERY cQuery NEW ALIAS "TMP"
		Else
			cQuery := "SELECT * FROM " +  RetSqlName( 'SB1' ) + " B1 "
			cQuery += " WHERE B1.B1_COD LIKE '" + _Sigla + "%' "			
			cQuery += " AND D_E_L_E_T_ = ' ' "
			cQuery += " ORDER BY SUBSTRING(B1.B1_COD,7,6) "
	//        MemoWrit('C:\TEMP\EST053.SQL',cQuery)				
			TCQUERY cQuery NEW ALIAS "TMP"
		Endif	
	ElseIf SM0->M0_CODIGO = 'NH'		
		cQuery := "SELECT * FROM " +  RetSqlName( 'SB1' ) + " B1 "
		cQuery += " WHERE B1.B1_COD LIKE '%.4.%' "
		cQuery += " AND D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY SUBSTRING(B1.B1_COD,6,5) "
		TCQUERY cQuery NEW ALIAS "TMP"
	Endif
	
Return

