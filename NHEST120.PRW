/*                              
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NHEST120        � Joao Felipe da Rosa   � Data � 03/07/08 ���
������������������������������������������������������������������������Ĵ��
���Descricao � Etiquetas de Recebimento para Identificacao do Produto.   ���
������������������������������������������������������������������������Ĵ��
���Uso       � SigaEst                                                   ���
������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������
�������������������������������������������������������������������D��������*/
*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.ch"
User Function NHEST120()    

SetPrvt("nNumNf,nQtdeEtq,,aEtiq,cPorta,_CodBarra,_cItem,_cNFSaida,_cCodigo,_cSerie,_cDescPrd")
_cNFSaida := Space(9)
_cITEM	  := Space(3)
_cCodigo  := Space(15)              
_Item     := space(6)              
_cSerie   := Space(3)
nQtdeEtq  := 0

Processa({|| EtiqMark() }, "Etiqueta de Produto")
//Processa({|| gerando()  },"Gerando Dados para a Impressao")

Return(nil)
           
//���������������������������Ŀ
//� MONTA A TELA DE PERGUNTAS �
//�����������������������������
Static Function EtiqMark()

	oFonteG1 := TFont():New("Arial",,12,,.t.,,,,,.f.)
    oFonteG2 := TFont():New("Arial",,16,,.F.,,,,,.f.)
    oFonteG3 := TFont():New("Arial",,20,,.t.,,,,,.f.)
    oFonteG4 := TFont():New("Arial",,30,,.t.,,,,,.f.)
    oFonteP  := TFont():New("Arial",,10,,.t.,,,,,.f.)
    oFonteP2 := TFont():New("Helvetic",,07,,.t.,,,,,.f.)
                                                                           
	@ 150,050 To 390,550 Dialog DlgDadosEmb Title "Informe o Numero da NF de Saida"
	@ 020,015 Say OemToAnsi("Numero da NF Saida:") Size 50,8 OBJECT olnf
	@ 018,070 Get _cNFSaida PICTURE "@!" F3 "SF2" Size 35,8	object oNFSaida
	@ 020,115 Say OemToAnsi("Serie:") Size 25,8 object olserie
	@ 018,130 Get _cSerie   PICTURE "@!" Size 10,8 valid fNfSerie() object oSerie
	@ 040,015 Say OemToAnsi("Item da NF Saida:") Size 50,8 object olitem 
//	@ 040,070 MSCOMBOBOX oItem VAR _cItem ITEMS _aItens SIZE 30,8 OF DlgDadosEmb PIXEL ON CHANGE fAtuPrd()
	@ 038,070 Get _cItem    PICTURE "@!" Size 20, 8 object oItem VALID fAtuPrd()
	@ 060,015 Say OemToAnsi("Codigo do Produto:")  Size 80,8 object olprd
	@ 058,070 Get _cCodigo  PICTURE "@!" Size 50, 8  WHEN .F. object oCodigo
	@ 058,123 Get _cDescPrd PICTURE "@!" Size 120, 8 WHEN .F. object oDescPrd
	@ 080,015 Say OemToAnsi("Quantidade Etiqueta:") Size 50,8 object olqtd
	@ 078,070 Get nQtdeEtq    PICTURE "99999" Size 20,8 Valid(nQtdeEtq >=0) object oqtd
	@ 100,185 BMPBUTTON TYPE 01 ACTION Gerando()
	@ 100,215 BMPBUTTON TYPE 02 ACTION Close(DlgDadosEmb)
	Activate Dialog DlgDadosEmb CENTERED
	        
Return

//��������������������Ŀ
//� ATUALIZA O PRODUTO �
//����������������������
Static Function fAtuPrd()
Local _lItm := .F.
SD2->(DbSetOrder(3))//filial + doc + serie + ...
SD2->(DbSeek(xFilial("SD2")+_cNFSaida+_cSerie))
SB1->(DBSETORDER(1)) // FILIAL + PROD
If SD2->(Found())
	
	WHILE SD2->(!EOF()) .AND. SD2->D2_DOC == _cNFSaida .AND. SD2->D2_SERIE == _cSerie
		If _cItem == RIGHT(SD2->D2_ITEM,2)
			_lItm := .T.
			_cCodigo := SD2->D2_COD
			SB1->(DBSEEK(XFILIAL("SB2")+SD2->D2_COD))
			IF SB1->(FOUND())
				_cDescPrd   := SB1->B1_DESC
			ENDIF
		ENDIF
					
		SD2->(DBSKIP())
	ENDDO
EndIf       

If !_lItm 
	Alert("Item inv�lido!")
	Return .F.
Endif

ObjectMethod(oCodigo,  "Refresh()")
ObjectMethod(oDescPrd, "Refresh()")

Return

//�����������������������Ŀ
//� VALIDA A NOTA E SERIE �
//�������������������������
Static Function fNfSerie()

	SD2->(DbSetOrder(3))//filial + doc + serie + ...
	IF !SD2->(DBSEEK(XFILIAL("SD2")+_cNfSaida+_cSerie))
		Alert("Nota Fiscal ou Serie incorreta")
		Return .F.
	Else
		AtuItem()
	Endif
	
Return .T.

//��������������������Ŀ
//� IMPRIME A ETIQUETA �
//����������������������
Static Function ImpEtiq()
Local nEtiq
   	oPr := tAvPrinter():New("Protheus")
    TMP->(DbGoTop())
    ProcRegua(TMP->(RecCount()))
	nEtiq := Val(GetMv("MV_ETQVW")) //Pega o qtde de etq que j� foram enviadas	  

	  For i := 1 To nQtdeEtq

		nEtiq++    

		oPr:StartPage()

    	oPr:Line(0050,0020,0050,2350) // Horizontal 1� linha 
		oPr:Line(0050,0020,1900,0020) // vertical DIREITA  1
		oPr:Line(0050,2350,1900,2350) // vertical PARTE 1
                                                    
		oPr:Line(0050,1165,0600,1165) // vertical MEIO 1

		oPr:Line(0450,1550,0600,1550) // vertical PEQUENA 1
		oPr:Line(0450,1950,0600,1950) // vertical PEQUENA 2

		oPr:Line(0300,0020,0300,2350) // Horizontal 2� linha 
		oPr:Line(0450,1165,0450,2350) // Horizontal 4� linha 	
		oPr:Line(0600,0020,0600,2350) // Horizontal 4� linha  

   		oPr:Line(0950,0020,0950,2350) 
  		oPr:Line(1300,0020,1300,1165)
		oPr:Line(1600,0020,1600,2350) 
		oPr:Line(1900,0020,1900,2350) 

		oPr:Line(0950,1165,1900,1165) 
		oPr:Line(1100,1165,1100,2350) 
		oPr:Line(1450,1165,1450,2350) 
		oPr:Line(1450,1600,1600,1600) // vertical PEQUENA 1

	    oPr:Say(0060,0050,OemtoAnsi("Destinatario / Receiver"), oFonteP2)
	     oPr:Say(0100,0050,TMP->A1_NOME, oFonteG2)
   	     oPr:Say(0200,0050,TMP->A1_END, oFonteG1)
	    oPr:Say(0060,1200,OemtoAnsi("Emissao da Nota Fiscal / Note-Tax Issuance"), oFonteP2)
		 oPr:Say(0100,1200,DTOC(STOD(TMP->D2_EMISSAO)), oFonteG2)	    
	    oPr:Say(0320,0050,OemtoAnsi("No.Documento / Advice Note NBR (P)"), oFonteP2)
	     oPr:Say(0360,0050,TMP->D2_DOC, oFonteG2)   
//     	 MSBAR("CODE3_9",4.1,1.0,TMP->D2_DOC ,oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFonteG3,"CODE3_9",.F.) //imprime cod. de barra da NF
	 //    MSBAR("CODE3_9",6.5,1.0,UPPER("P")+Alltrim(ETQ->PRODUTO),oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFont12,"CODE3_9",.F.) //imprime cod. de barra	         	 
 		 MSBAR("CODE3_9",3.4,1.0,TMP->D2_DOC ,oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barraS correto
    	oPr:Say(0320,1200,OemtoAnsi("Endereco Fornecedor / Supplier Adress."), oFonteP2)

    	 If SM0->M0_CODIGO == "NH"  //empresa FUNDICAO
		  oPr:Say(0380,1200,"WHB COMPONENTES AUTOMOTIVOS S\A", oFonteG1)
    	 Elseif SM0->M0_CODIGO == "FN"  //empresa FUNDICAO
		  oPr:Say(0380,1200,"WHB FUNDICAO S\A", oFonteG1)
		 EndIf

  	 	oPr:Say(0470,1200,OemtoAnsi("P.Liq./Net WT (KG)                P.Bruto / Grow WT (KG)             Caixa / Boxes "), oFonteP2)    
//		 oPr:Say(0510,1200,Transform(TMP->F2_PLIQUI,"@e 9999,99")+Space(27)+Transform(TMP->F2_PBRUTO,"@e 9999,99")+Space(27)+;
//		                   Iif(ALLTRIM(_cCodigo)$"VW03.1.153.00/VW03.1.153.01/VW03.4.153.00/VW03.4.153.01","60","0"), oFonteG1)


		oPr:Say(0620,0050,OemtoAnsi("No Refer�ncia / Part Number (P)"), oFonteP2)
    	 oPr:Say(0660,0050,TMP->B1_CODAP5, oFonteG3)
//     	 MSBAR("CODE3_9",7.0,1.0,OemtoAnsi(TMP->B1_CODAP5),oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFonteG3,"CODE3_9",.F.) //imprime cod. de barra
		MSBAR("CODE3_9",6.1,1.0,OemtoAnsi(TMP->B1_CODAP5),oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barras
		oPr:Say(0970,0050,OemtoAnsi("Quantidade / Quantity (Q)"), oFonteP2)
    	 oPr:Say(1010,0350, Transform(TMP->F2_VOLUME1,"@e 9999") , oFonteG3)
//     	 MSBAR("CODE3_9",9.9,1.0, Transform(TMP->F2_VOLUME1,"@e 9999"),oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFonteG3,"CODE3_9",.F.) //imprime cod. de barra
		MSBAR("CODE3_9",8.9,1.0,Transform(TMP->F2_VOLUME1,"@e 9999"),oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barras
		oPr:Say(0970,1200,OemtoAnsi("Descricao / Description"), oFonteP2)   
    	 oPr:Say(1010,1200,TMP->B1_DESC, oFonteG2)
		oPr:Say(1120,1200,OemtoAnsi("Ref. Embalegem / Box"), oFonteP2)
//		 oPr:Say(1160,1600,OemtoAnsi("000000"), oFonteG2)		 
//		 MSBAR("CODE3_9",5.7,6.0,OemtoAnsi("000000"),oPr,NIL,   NIL,NIL,0.0194,0.6,NIL,oFonteG1,"CODE3_9",.F.) //imprime cod. de barra
		oPr:Say(1320,0050,OemtoAnsi("Fornecedor / Supplier (V)"), oFonteP2)
		 oPr:Say(1360,0350,OemtoAnsi("CZG1"), oFonteG2)		 
//     	 MSBAR("CODE3_9",12.6,1.0,OemtoAnsi("CZG1"),oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFonteG3,"CODE3_9",.F.) //imprime cod. de barra
	     MSBAR("CODE3_9",11.6,1.0,OemtoAnsi("CZG1"),oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barras
		oPr:Say(1470,1200,OemtoAnsi("Data / Date                                       Mudanca Eng. / Eng.Change"), oFonteP2)
//		 oPr:Say(1510,1200,OemtoAnsi("P"+Space(40)+DTOC(TMP->QDH_DTREDE)), oFonteG2)
		oPr:Say(1620,0050,OemtoAnsi("No. Refer. / Serial (S/M/G)"), oFonteP2)
  		 oPr:Say(1650,0350,StrZero(nEtiq,6), oFonteG2)
//     	 MSBAR("CODE3_9",15.0,1.0,StrZero(nEtiq,6),oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFonteG3,"CODE3_9",.F.) //imprime cod. de barra
	     MSBAR("CODE3_9",14.0,1.0,StrZero(nEtiq,6),oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barras
 		oPr:Say(1620,1200,OemtoAnsi("No. Lote / Charge N.(H)"), oFonteP2)
  //		 oPr:Say(1650,1600,OemtoAnsi("000"), oFonteG2)
    //     MSBAR("CODE3_9",7.7,6.0,OemtoAnsi("000"),oPr,NIL,   NIL,NIL,0.0194,0.6,NIL,oFonteG1,"CODE3_9",.F.) //imprime cod. de barra
		
		oPr:EndPage()
next 
	oPr:End()
	oPr:Preview()

   	if SX6->(DbSeek(xFilial()+"MV_ETQVW"))
   		
	    RecLock("SX6",.F.)
		   SX6->X6_CONTEUD := Strzero(nEtiq,6) //Grava numero final da etiqueta
		MsUnlock("SX6")
	else 
		alert('Falta par�metro MV_ETQVW!')
	endif
    
    MS_FLUSH()
   	TMP->(DbCloseArea())
   	

        
Return

//����������������������������臎臎�
//� ATUALIZA OS DADOS DA NOTA �
//����������������������������臎臎�
Static Function AtuItem()

SD2->(DbSetOrder(3))//filial + doc + serie + ...
SD2->(DbSeek(xFilial("SD2")+_cNFSaida+_cSerie))
SB1->(DBSETORDER(1)) // FILIAL + PROD
If SD2->(Found())
	_cItem   := SD2->D2_ITEM
	_cCodigo := SD2->D2_COD
	SB1->(DBSEEK(XFILIAL("SB2")+SD2->D2_COD))
	IF SB1->(FOUND())
		_cDescPrd   := SB1->B1_DESC
	ENDIF
Else
	MsgBox("Nota Fiscal n�o encontrada!")
EndIf

ObjectMethod(oNFSaida, "Refresh()")
ObjectMethod(oItem,    "Refresh()")
ObjectMethod(oCodigo,  "Refresh()")
ObjectMethod(oDescPrd, "Refresh()")

Return(.T.)

//-----------------------------------------------------------------------------------------------------
// Grava sequencial da etiqueta
//-----------------------------------------------------------------------------------------------------
Static Function GravaDados()

	nEtiq := Val(GetMv("MV_ETQVWF")) //Pega o qtde de etq que j� foram enviadas   
	SX6->(DbSeek(xFilial()+"MV_ETQVWF"))
    RecLock("SX6",.F.)
	   SX6->X6_CONTEUD:= Strzero(nEtiq,6) //Grava numero final da etiqueta
	MsUnlock("SX6")
    Close(DlgDadosEmb)

Return(.T.)

//-----------------------------------------------------------------------------------------------------
// GERANDO DADOS ARQUIVO TMP
//-----------------------------------------------------------------------------------------------------
Static Function Gerando()

	cQuery := "SELECT A1.A1_COD,A1.A1_NOME,A1.A1_END,D2.D2_DOC,D2.D2_SERIE,D2.D2_QUANT, D2.D2_EMISSAO, "
	cQuery += " F2.F2_VOLUME1, F2.F2_PLIQUI, F2.F2_PBRUTO, B1.B1_DESC, B1.B1_CODAP5"
	cQuery += " FROM "+RetSqlName("SA1")+" A1,"+RetSqlName("SD2")+" D2,"+RetSqlName("SB1")+" B1,"
	cQuery += RetSqlName("SF2")+" F2"
	cQuery += " WHERE B1.B1_COD = D2.D2_COD  "
	cQuery += " AND D2.D2_DOC = F2.F2_DOC"
	cQuery += " AND D2.D2_SERIE = F2.F2_SERIE"
	cQuery += " AND D2.D2_DOC = '" + _cNFSaida + "'"
	cQuery += " AND D2.D2_SERIE = '"+ _cSerie + "'"
	cQuery += " AND D2.D2_ITEM = '" + _cItem + "'"
	cQuery += " AND D2_CLIENTE = A1_COD "
	cQuery += " AND D2_LOJA = A1_LOJA "	
	cQuery += " AND D2.D2_FILIAL = '" + xFilial("SD2")+ "' AND D2.D_E_L_E_T_ = '' "
	cQuery += " AND B1.B1_FILIAL = '" + xFilial("SB1")+ "' AND B1.D_E_L_E_T_ = '' "
	cQuery += " AND A1.A1_FILIAL = '" + xFilial("SA1")+ "' AND A1.D_E_L_E_T_ = '' "
	cQuery += " AND F2.F2_FILIAL = '" + xFilial("SF2")+ "' AND F2.D_E_L_E_T_ = '' " 
	MemoWrit('C:\TEMP\EST101.SQL',cQuery)		
	TCQUERY cQuery NEW ALIAS "TMP" 

	Close(DlgDadosEmb)

	ImpEtiq()

Return


