/*                                      
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHPCP018  �Autor  �Jo�o Felipe da Rosa � Data �  03/12/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � FICHA T�CNICA DE PRODU��O                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ENGENHARIA WHB                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLOR.CH"
#INCLUDE "FONT.CH"                           
#INCLUDE "MSOLE.CH"
//#INCLUDE "DBTREE.CH"

User Function Nhpcp018()

Private cCadastro
Private aRotina
private aSize      := MsAdvSize()
Private cStartPath := GetSrvProfString("Startpath","")
If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif               

cStartPath += "FT\"

/*
//TABELAS USADAS 

AXCADASTRO("ZB5") //CABECALHO
AXCADASTRO("ZBD")
AXCADASTRO("ZBC")
AXCADASTRO("ZB5")
AXCADASTRO("ZBE")
AXCADASTRO("ZBF")
AXCADASTRO("ZBG")
AXCADASTRO("ZBH")
AXCADASTRO("ZD2")
AXCADASTRO("ZD3")
AXCADASTRO("ZD4")
AXCADASTRO("ZD5")
AXCADASTRO("ZD6")
AXCADASTRO("ZD7")
AXCADASTRO("ZD8")
AXCADASTRO("ZDB")
*/

cCadastro := "Cadastro de Ficha T�cnica de Equipamentos"
aRotina   := {{ "Pesquisa"   ,"AxPesqui"     ,0,1},;
              { "Visualizar" ,"U_fPCP18(1)"  ,0,2},;
              { "Incluir"    ,"U_fPCP18(2)"  ,0,3},;
              { "Alterar"    ,"U_fPCP18(3)"  ,0,4},;
              { "Aprovar"    ,"U_PCP18A"     ,0,3},;
              { "Gera FT"    ,"U_GeraFT()"   ,0,3},;
              { "Aprovadores","U_PCP18APR()" ,0,3},;
              { "Legenda"    ,"U_PCP018LEG()",0,2}}

DbSelectArea("ZB5")
ZB5->(DbGotop())
mBrowse(,,,,"ZB5",,,,,,fCriaCor())

Return

//���������������Ŀ
//� CRIA AS CORES �
//�����������������
Static Function fCriaCor()
	Local aLegenda :=	{ {"BR_VERDE"   , OemToAnsi("Aprovado")    },;
  						  {"BR_AMARELO" , OemToAnsi("N�o Aprovado")},;
  						  {"BR_CINZA"   , OemToAnsi("Obsoleto")    }}

	Local uRetorno := {}
    Aadd(uRetorno, { 'ZB5_ULTREV == "S" .AND. ZB5_STATUS == "A" ' , aLegenda[1][1] } )	
	Aadd(uRetorno, { 'ZB5_ULTREV == "S" .AND. ZB5_STATUS == "P" ' , aLegenda[2][1] } )
	Aadd(uRetorno, { 'ZB5_ULTREV == "N" .AND. ZB5_STATUS == "O" ' , aLegenda[3][1] } )
Return(uRetorno)

//���������Ŀ
//� LEGENDA �
//�����������
User Function PCP018LEG()

Local aLegenda :=	{ {"BR_VERDE"   , OemToAnsi("Aprovado")    },;
					  {"BR_AMARELO" , OemToAnsi("N�o Aprovado")},;
 					  {"BR_CINZA"   , OemToAnsi("Obsoleto")    }}
  					  
BrwLegenda(OemToAnsi("Ficha T�cnica"), "Legenda", aLegenda)

Return  

//������������������Ŀ
//� FUNCAO PRINCIPAL �
//��������������������
User Function fPCP18(nParam)

private nPar      := nParam
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 100, 100 , 50, 100}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)

Private cZb5NumFT   := Space(16)
Private cZb5oP      := Space(06)
Private cZb5Peca    := Space(15)
Private cZb5Ap5Num  := Space(16)
Private cZb5Rev     := Space(03)
Private cZb5Tciclo  := Space(08)
Private cZb5OpDesc  := Space(100)
Private cZb5Elab    := Space(15)
Private dZb5DtElab  := Ctod(Space(08))
Private cZb5Aprova  := Space(15)
Private dZb5DtAprov := Ctod(Space(08))
Private cZb5Status  := Space(01)
Private cZb5MotRev  := Space(50)
Private dZb5DtRev   := Ctod(Space(08))
Private cZb5ResRev  := Space(15)
Private cZB5Tipo    := ""
Private cDescProd   := ""
Private cDescCC     := ""
Private nST9PosX    := 0
Private nST9PosY    := 0
Private cCC         := Space(9)
Private cPlCont     := Space(15)

private aHeader     := {}
private aCols       := {}
private aItmFer     := {}
private aItmTest    := {}
private aItmInsp    := {}
private aParTest    := {}
private aItmPro     := {}
private aItmCoord   := {}
private aMontCom    := {}
private aMaq        := {}
private aFer        := {}
private aDisp       := {}
private aLav        := {}
private aMont       := {}
private aTest       := {}
private aInsp       := {}
Private aTipo       := {"1=Usinagem","2=Lavadora","3=Montagem","4=Teste","5=Inspe��o"}             

private cArq01      := ""
private cArq02      := ""
private cBMP01      := ""
private cBMP02      := ""
private cBMP03_1    := ""
private cBMP03_2    := ""
private cBMP04      := ""
private cBMP05      := ""
private cBMP06      := ""
private cBMP07      := ""

Private _CRLF       := chr(13)+chr(10)

//-- INCLUIR --//
If nPar == 2     
	cZb5Rev     := "000"
	cZb5Elab    := UPPER(AllTrim(cUserName))
	dZb5DtElab  := Date()
	cZb5Aprova  := ""
	dZb5DtAprov := CTOD("  /  /  ")
	cZb5ResRev  := ""
	dZb5DtRev   := CTOD("  /  /  ")
EndIf

//-- VISUALIZAR ou ALTERAR--//

If nPar == 1 .Or. nPar == 3

	//Carrega os dados para visualiza��o, altera��o
	cZb5NumFT   := ZB5->ZB5_NUM
	cZb5oP      := ZB5->ZB5_OP
	cZb5OpDesc  := ZB5->ZB5_OPDESC
	cZb5Peca    := ZB5->ZB5_PECA
	cCC         := ZB5->ZB5_CC
	cZB5Tipo    := ZB5->ZB5_TIPO
	
	CTT->(DBSETORDER(1))
	If CTT->(DBSEEK(XFILIAL("CTT")+cCC))
		cDescCC := CTT->CTT_DESC01
	EndIf

	DbSelectArea("SB1")
	DbSetOrder(1) //FILIAL + COD PRODUTO
	If DbSeek(xFilial("SB1")+ALLTRIM(ZB5->ZB5_PECA))
		cZb5Ap5Num  := SB1->B1_CODAP5
		cDescProd   := SB1->B1_DESC
	EndIf
		
	cZb5Rev       := ZB5->ZB5_REV
	cZb5Tciclo    := ZB5->ZB5_TCICLO
	cPlCont       := ZB5->ZB5_PC
	cZb5Elab      := ZB5->ZB5_ELABOR
	dZb5DtElab    := ZB5->ZB5_DTELAB
	cZb5Aprova    := ZB5->ZB5_APROVA
	dZb5DtAprov   := ZB5->ZB5_DTAPRV
	cZb5ResRev    := ZB5->ZB5_RESREV
	dZb5DtRev     := ZB5->ZB5_DTREV
	
	//cZb5Status  := Space(01)

	//RECUPERA AS VARI�VEIS DAS M�QUINAS
	DbSelectArea("ZBH")
	DbSetOrder(1) //ZBH_FILIAL+ZBH_NUM+ZBH_REV+ZBH_ITEM
	If DbSeek(xFilial("ZBH")+cZb5NumFt+cZb5Rev)
		ST9->(DbSetOrder(1))// FILIAL + COD BEM + ITEM
		While !Eof() .AND. ZBH->ZBH_NUM == cZb5NumFt .AND. ZBH->ZBH_REV == cZb5Rev
			ST9->(DbSeek(xFilial("ST9")+ALLTRIM(ZBH->ZBH_BEM)))
			aAdd(aMaq,{ZBH->ZBH_ITEM,;
						    ZBH->ZBH_BEM,;
						    ST9->T9_NOME,;
						    ST9->T9_POSX,;
						    ST9->T9_POSY,;
						    ZBH->ZBH_PROGP1,;
						    ZBH->ZBH_PROGP2,;
						    ZBH->ZBH_CONSOS,;
						    ZBH->ZBH_PRESRI,;
						    ZBH->ZBH_PRESAC,;
						    Iif(!Empty(ZBH->ZBH_IMG01),cStartPath+ZBH->ZBH_IMG01,"")})
			DbSkip()
		EndDo
	Else
		aAdd(aMaq,{"","","","","",0,0,0,"",0,""})
	EndIf

	//RECUPERA AS VARI�VEIS DO DISPOSITIVO
	DbSelectArea("ZBG")
	DbSetOrder(1)//ZBG_FILIAL+ZBG_NUM+ZBG_REV+ZBG_ITEM
	If DbSeek(xFilial("ZBG")+cZb5NumFt+cZb5Rev)
		While !Eof() .AND. ZBG->ZBG_NUM == cZb5NumFt .AND. ZBG->ZBG_REV == cZb5Rev
            aAdd(aDisp,{ZBG->ZBG_ITEM,;
            		    ZBG->ZBG_NDISP1,;
            		    ZBG->ZBG_LETRA1,;
            		    ZBG->ZBG_NDISP2,;
            		    ZBG->ZBG_LETRA2,;
            		    ZBG->ZBG_PFIXD1,;
            		    ZBG->ZBG_PFIXD2,;
            		    ZBG->ZBG_QTDPCD,;
            		    Iif(!Empty(ZBG->ZBG_IMG01),cStartPath+ZBG->ZBG_IMG01,"")})
			DbSkip()
		EndDo
	Else
		aAdd(aDisp,{"","","","","",0,0,0,""})
	EndIf

	//RECUPERA AS VARI�VEIS DE FERRAMENTAS
	SB1->(DBSETORDER(1))
	ZBJ->(DbSetOrder(1)) // FILIAL + NUMONT
	DbSelectArea("ZBF")
	DbSetOrder(1) //ZBF_FILIAL+ZBF_NUM+ZBF_REV+ZBF_ITEM
	If DbSeek(xFilial("ZBF")+cZb5NumFt+cZb5Rev)
		While !Eof() .AND. ZBF->ZBF_NUM == cZb5NumFt .AND. ZBF->ZBF_REV == cZb5Rev
			
			ZBJ->(DBSEEK(XFILIAL("ZBJ")+ZBF->ZBF_NUMONT))

			aAdd(aFer,{ZBF->ZBF_ITEM,;
					   ZBF->ZBF_NUMONT,;
					   Iif(!Empty(ZBJ->ZBJ_IMG01),cStartPath+ZBJ->ZBJ_IMG01,""),;
					   Iif(!Empty(ZBF->ZBF_IMG02),cStartPath+ZBF->ZBF_IMG02,""),;
					   {},;
					   {},;
					   {}})
					  
			//RECUPERA OS ITENS DA MONTAGEM DE FERRAMENTAS
			ZBC->(DBSETORDER(1)) //ZBC_FILIAL+ZBC_NUMONT+ZBC_ITEM
			IF ZBC->(DBSEEK(XFILIAL("ZBC")+ZBF->ZBF_NUMONT))
				WHILE ZBC->(!EOF()) .AND. ZBC->ZBC_NUMONT == ZBF->ZBF_NUMONT
				    SB1->(DBSEEK(XFILIAL("SB1")+ZBC->ZBC_COD))

				    aAdd(aFer[Len(aFer)][5],{ZBC->ZBC_ITEM,;
				    						 ZBC->ZBC_QTDE,;
				    					     ZBC->ZBC_COD,;
				    					     SB1->B1_DESC,;
				    					     ZBC->ZBC_POS,;
				    					     .F.})
				
			    	ZBC->(DBSKIP())
				ENDDO
			ENDIF
			
			//RECUPERA AS VARIAVEIS DO PROCESSO
			ZBD->(DBSETORDER(1))//ZBD_FILIAL+ZBD_NUM+ZBD->ZBD_REV+ZBD_NUMONT
			IF ZBD->(DBSEEK(XFILIAL("ZBD")+cZb5NumFt+cZb5Rev+ZBF->ZBF_NUMONT))
				WHILE ZBD->(!EOF()) .AND. ZBD->ZBD_NUM == cZb5NumFt .AND. ZBD->ZBD_NUMONT == ZBF->ZBF_NUMONT .AND. ZBD->ZBD_REV == cZb5Rev
					aAdd(aFer[Len(aFer)][6],{ZBD->ZBD_ITEM,;
											 ZBD->ZBD_DIAMET,;
					                         ZBD->ZBD_VC,;
					                         ZBD->ZBD_RPM,;
					                         ZBD->ZBD_QDENTE,;
					                         ZBD->ZBD_MMDENT,;
					                         ZBD->ZBD_MMMIN,;
					                         ZBD->ZBD_VIDA,;
					                         .F.})
					ZBD->(DBSKIP())
				ENDDO
			ENDIF
			        
			//RECUPERA AS COORDENADAS DE USINAGEM
			ZBE->(DBSETORDER(1))//ZBE_FILIAL+ZBE_NUM+ZBE_REV+ZBE_NUMONT+ZBE_ITEM
			IF ZBE->(DBSEEK(XFILIAL("ZBE")+cZb5NumFt+cZb5Rev+ZBF->ZBF_NUMONT))
				WHILE ZBE->(!EOF()) .AND. ZBE->ZBE_NUM == cZb5NumFt .AND. ZBE->ZBE_NUMONT == ZBF->ZBF_NUMONT .AND. ZBF->ZBF_REV == cZb5Rev
					aAdd(aFer[Len(aFer)][7],{ZBE->ZBE_ITEM,;
											 ZBE->ZBE_X,;
										     ZBE->ZBE_Y,;
										     ZBE->ZBE_Z,;
										     ZBE->ZBE_NFURO,;
										     .F.})
					ZBE->(DBSKIP())
			    ENDDO
			ENDIF
			
			DbSkip()
		EndDo
	Else
		aAdd(aFer,{"","","","",{},{},{}})
	EndIf
	
	//�����������������������Ŀ
	//� RECUPERA AS LAVADORAS �
	//�������������������������
	DbSelectArea("ZD2")
	DbSetOrder(1)//ZD2_FILIAL+ZD2_NUM+ZD2_REV+ZD2_ITEM
	If DbSeek(xFilial("ZD2")+cZb5NumFt+cZb5Rev)
		While !Eof() .AND. ZD2->ZD2_NUM == cZb5NumFt .AND. ZD2->ZD2_REV == cZb5Rev
            aAdd(aLav,{ZD2->ZD2_ITEM,;
					   ZD2->ZD2_BEM,;
					   ZD2->ZD2_PRDBAN,;
					   ZD2->ZD2_TEMBAN,;
					   ZD2->ZD2_CONBAN,;
					   ZD2->ZD2_TLAVAG,;
					   ZD2->ZD2_TSECAG,;
					   ZD2->ZD2_TSOPRO,;
					   ZD2->ZD2_PRESSA,;
					   ZD2->ZD2_PCCICL,;
					   Iif(!Empty(ZD2->ZD2_IMG01),cStartPath+ZD2->ZD2_IMG01,"")})
			dbSkip()
		EndDo
	Else
		aAdd(aLav,{"","","","","",0,0,0,0,0,""})
	EndIf
	
	//���������������������������������������������������������Ŀ
	//� RECUPERA OS DADOS DO EQUIPAMENTO DE MONTAGEM / MONTAGEM �
	//�����������������������������������������������������������
	dbSelectArea("ZD3")
	dbSetOrder(1) //FILIAL + NUM + REV + ITEM
	If dbSeek(xFilial("ZD3")+cZb5NumFt+cZb5Rev)
		While !Eof() .AND. ZD3->ZD3_NUM==cZb5NumFt .AND. ZD3->ZD3_REV==cZb5Rev
			aAdd(aMont,{ZD3->ZD3_ITEM,;
						ZD3->ZD3_BEM,;
						ZD3->ZD3_PUHD,;
						Iif(!Empty(ZD3->ZD3_IMG01),cStartPath+ZD3->ZD3_IMG01,""),;
						{}})

			//RECUPERA OS COMPONENTES DO EQUIPAMENTO DE MONTAGEM / MONTAGE
			ZD6->(DBSETORDER(1)) //ZD6_FILIAL+ZD6_NUM+ZD6_REV+ZD6_ITEMFT+ZD6_ITEM
			IF ZD6->(DBSEEK(XFILIAL("ZD6")+ZD3->ZD3_NUM+ZD3->ZD3_REV+ZD3->ZD3_ITEM))
				WHILE ZD6->(!EOF()) .AND. ZD6->ZD6_NUM==ZD3->ZD3_NUM .AND. ZD6->ZD6_REV==ZD3->ZD3_REV .AND. ZD6->ZD6_ITEMFT==ZD3->ZD3_ITEM
				    SB1->(DBSEEK(XFILIAL("SB1")+ZD6->ZD6_COD))

				    aAdd(aMont[Len(aMont)][5],{ZD6->ZD6_ITEM,;
				    					       ZD6->ZD6_COD,;
				    					       SB1->B1_DESC,;
				    					       ZD6->ZD6_QTDE,;
				    					       ZD6->ZD6_POS,;
				    					       .F.})
				
			    	ZD6->(DBSKIP())
				ENDDO
			ENDIF
			
			dbSkip()
	    EndDo
	Else
		aAdd(aMont,{"","","","",{}})
    EndIf
    
	//�����������������������������������������������Ŀ
	//� RECUPERA OS DADOS DOS TESTES DE ESTANQUEIDADE �
	//�������������������������������������������������
    dbSelectArea("ZD4")
    dbSetOrder(1)//FILIAL + NUM + REV + ITEM
    If dbSeek(xFilial("ZD4")+cZb5NumFt+cZb5Rev)
 		While !Eof() .AND. ZD4->ZD4_NUM==cZb5NumFt .AND. ZD4->ZD4_REV==cZb5Rev
 			aAdd(aTest,{ZD4->ZD4_ITEM,;
 						ZD4->ZD4_BEM,;
 						Iif(!Empty(ZD4->ZD4_IMG01),cStartPath+ZD4->ZD4_IMG01,""),;
 						{},;
 						{}})
 						
			//RECUPERA OS ITENS DE TESTE DE ESTANQUEIDADE
			ZD7->(dbSetOrder(1)) // FILIAL + NUMFT + REV + ITEMFT + ITEM
			IF ZD7->(DBSEEK(XFILIAL("ZD7")+ZD4->ZD4_NUM+ZD4->ZD4_REV+ZD4->ZD4_ITEM))
				WHILE ZD7->(!EOF()) .AND. ZD7->ZD7_NUM==ZD4->ZD4_NUM .AND. ZD7->ZD7_REV==ZD4->ZD4_REV .AND. ZD7->ZD7_ITEMFT==ZD4->ZD4_ITEM
				    SB1->(DBSEEK(XFILIAL("SB1")+ZD7->ZD7_COD))

				    aAdd(aTest[Len(aTest)][4],{ZD7->ZD7_ITEM,;
				    					       ZD7->ZD7_COD,;
				    					       SB1->B1_DESC,;
				    					       ZD7->ZD7_QTDE,;
				    					       ZD7->ZD7_POS,;
				    					       .F.})
				
			    	ZD7->(DBSKIP())
				ENDDO
			ENDIF
			
			//RECUPERA OS PARAMETROS DE TESTE DE ESTANQUEIDADE
			ZD8->(dbSetOrder(1)) // FILIAL + NUMFT + REV + ITEMFT + ITEM + LETRA
			IF ZD8->(DBSEEK(XFILIAL("ZD8")+ZD4->ZD4_NUM+ZD4->ZD4_REV+ZD4->ZD4_ITEM))
				
				WHILE ZD8->(!EOF()) .AND. ZD8->ZD8_NUM==ZD4->ZD4_NUM .AND. ZD8->ZD8_REV==ZD4->ZD4_REV .AND. ZD8->ZD8_ITEMFT==ZD4->ZD4_ITEM

				    aAdd(aTest[Len(aTest)][5],{ZD8->ZD8_ITEM,;
				    					       ZD8->ZD8_TIPO,;
				    					       ZD8->ZD8_MEDIDO,;
				    					       ZD8->ZD8_PROG,;
				    					       {}})
				    
				    aColsPar := {}
				    cZD8Itm := ZD8->ZD8_ITEM
				    While cZD8Itm == ZD8->ZD8_ITEM
				        aAdd(aColsPar,{ZD8->ZD8_LETRA,ZD8->ZD8_PARAM,ZD8->ZD8_VALOR,.F.})
			    		ZD8->(DBSKIP())
			 		EndDo
			 		
			 		aTest[Len(aTest)][5][Len(aTest[Len(aTest)][5])][5] := aColsPar
			 		
				ENDDO
			ELSE
				aAdd(aTest[Len(aTest)][5],{Space(4),Space(40),Space(30),Space(15),{}})
				
			ENDIF
 		
 			dbSkip()
    	EndDo
    Else
    	aAdd(aTest,{"","","",{},{}})	
    EndIf

	//�����������������������Ŀ
	//� RECUPERA AS INSPECOES �
	//�������������������������
	DbSelectArea("ZD5")
	DbSetOrder(1)//ZD5_FILIAL+ZD5_NUM+ZD5_REV+ZD5_ITEM
	If DbSeek(xFilial("ZD5")+cZb5NumFt+cZb5Rev)
		While !Eof() .AND. ZD5->ZD5_NUM == cZb5NumFt .AND. ZD5->ZD5_REV == cZb5Rev
            aAdd(aInsp,{ZD5->ZD5_ITEM,;
					    ZD5->ZD5_BEM,;
					    Iif(!Empty(ZD5->ZD5_IMG01),cStartPath+ZD5->ZD5_IMG01,""),;
					    {}})
			
			//RECUPERA OS ITENS DA INSPECAO (EQUIPAMENTOS / FERRAMENTAS)
			ZDB->(DBSETORDER(1)) //ZDB_FILIAL+ZDB_NUM+ZDB_REV+ZDB_ITEMFT+ZDB_ITEM
			IF ZDB->(DBSEEK(XFILIAL("ZDB")+ZD5->ZD5_NUM+ZD5->ZD5_REV+ZD5->ZD5_ITEM))
				WHILE ZDB->(!EOF()) .AND. ZDB->ZDB_NUM==ZD5->ZD5_NUM .AND. ZDB->ZDB_REV==ZD5->ZD5_REV .AND. ZDB->ZDB_ITEMFT==ZD5->ZD5_ITEM
				    SB1->(DBSEEK(XFILIAL("SB1")+ZDB->ZDB_COD))

				    aAdd(aInsp[Len(aInsp)][4],{ZDB->ZDB_ITEM,;
				    					       ZDB->ZDB_COD,;
				    					       SB1->B1_DESC,;
				    					       .F.})
				
			    	ZDB->(DBSKIP())
				ENDDO
			ENDIF
					    
			dbSkip()
		EndDo
	Else
		aAdd(aInsp,{"","","",{}})
	EndIf
		
EndIf

oDlgFolder := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"F I C H A    T � C N I C A",,,,,,,,,.T.)

@ 077,000 FOLDER oFolder PROMPTS OemToAnsi("Equipamento"),;
								 OemToAnsi("Dispositivo"),;
								 OemToAnsi("Ferramenta"),;
								 OemToAnsi("Lavadora"),;
								 OemToAnsi("Equip. Montagem"),;
								 OemToAnsi("Teste"),;
								 OemToAnsi("Inspe��o"),;
								 OemToAnsi("Cadastrais") SIZE (aSize[5]/2)+3,(aSize[6]/2) OF oDlgFolder PIXEL

//���������������������������������������������������������������������������������Ŀ
//� Botoes definidos apenas para o folder nao perder o Foco na troca de Folders     �
//�����������������������������������������������������������������������������������
DEFINE SBUTTON FROM 5000,5000 TYPE 6 ACTION .T. ENABLE OF oFolder:aDialogs[1] // botao oculto Folder 1
DEFINE SBUTTON FROM 5000,5000 TYPE 6 ACTION .T. ENABLE OF oFolder:aDialogs[2] // botao oculto Folder 2
DEFINE SBUTTON FROM 5000,5000 TYPE 6 ACTION .T. ENABLE OF oFolder:aDialogs[3] // botao oculto Folder 3
DEFINE SBUTTON FROM 5000,5000 TYPE 6 ACTION .T. ENABLE OF oFolder:aDialogs[4] // botao oculto Folder 4
DEFINE SBUTTON FROM 5000,5000 TYPE 6 ACTION .T. ENABLE OF oFolder:aDialogs[5] // botao oculto Folder 3
DEFINE SBUTTON FROM 5000,5000 TYPE 6 ACTION .T. ENABLE OF oFolder:aDialogs[6] // botao oculto Folder 4
DEFINE SBUTTON FROM 5000,5000 TYPE 6 ACTION .T. ENABLE OF oFolder:aDialogs[7] // botao oculto Folder 3
DEFINE SBUTTON FROM 5000,5000 TYPE 6 ACTION .T. ENABLE OF oFolder:aDialogs[8] // botao oculto Folder 4

@ 15, 005 To 072,(aSize[5]/2)-2 Title OemToAnsi("CABE�ALHO") 

@ 25, 010 SAY OemToAnsi("N�mero") PIXEL color CLR_HBLUE
@ 23, 035 GET oFtNum VAR cZb5NumFT Picture "@!" When .F. SIZE 060,08 PIXEL OF oDlgFolder
 
@ 25, 105 SAY OemToAnsi("C�d. Pe�a WHB") PIXEL color CLR_HBLUE
@ 23, 145 MSGET cZb5Peca Picture "@!" WHEN(nPar==2)SIZE 060,08 F3 "SB1" OF oDlgFolder PIXEL VALID fGeraNumFT()
@ 23, 207 MSGET oDescProd VAR cDescProd Picture "@!" WHEN .F. SIZE 150,08 OF oDlgFolder PIXEL

@ 25, 362 SAY OemToAnsi("No. Pe�a Cliente") PIXEL 
@ 23, 405 MSGET oAp5Num VAR cZb5Ap5Num Picture "@!" WHEN .F. SIZE 080,08 OF oDlgFolder PIXEL

@ 42, 010 SAY OemToAnsi("Opera��o") PIXEL color CLR_HBLUE
@ 40, 035 GET cZb5Op Picture "@!" WHEN(nPar==2) SIZE 030,08 OF oDlgFolder PIXEL VALID fGeraNumFT()
@ 40, 067 GET cZb5OpDesc Picture "@!" WHEN(nPar==2 .or. nPar==3) SIZE 290,08 OF oDlgFolder PIXEL

@ 42, 362 SAY OemToAnsi("Tempo Ciclo") PIXEL color CLR_HBLUE
@ 40, 395 MSGET cZb5Tciclo Picture "99:99:99" WHEN(nPar==2 .or. nPar==3) SIZE 030,08 OF oDlgFolder PIXEL

@ 42, 440 SAY OemToAnsi("Revis�o") PIXEL
@ 40, 467 MSGET cZb5Rev Picture "999" WHEN(.F.) SIZE 015,08 OF oDlgFolder PIXEL

oSay1 := tSay():New(59,10,{||"Plano de Controle:"},oDlgFolder,,,,,,.T.,,)

oGet1 := tGet():New(57,67,{|u| if(Pcount()>0,cPlCont:=u,cPlCont)},oDlgFolder,60,8,"@!",{||fValPlCont()},;
					,,,,,.T.,,,{|| nPar==2 .Or. nPar==3},,,,,,"QDH2","cPlCont")
					
oBt1 := tButton():New(57,130,"Visualizar",oDlgFolder,{||fPlanCont()},30,10,,,,.T.)

oSay2 := tSay():New(59,200,{||"C.Custo"},oDlgFolder,,,,,,.T.,,)
oGet2 := tGet():New(57,220,{|u| if(Pcount()>0,cCC := u, cCC)},oDlgFolder,;
    		 30,8,"@!",{||fValCC()},,,,,,.T.,,,{||nPar==2 .Or. nPar==3},,,,,,"CTT","cCC")

oGet3 := tGet():New(57,253,{|u| if(Pcount()>0,cDescCC := u, cDescCC)},oDlgFolder,;
    		 105,8,"@!",/*valid*/,,,,,,.T.,,,{||.F.},,,,,,,"cDescCC")

oSay8  := tSay():New(59,362,{||"Tipo"},oDlgFolder,,,,,,.T.,CLR_HBLUE,)
oCombo := TComboBox():New(57,395,{|u| if(Pcount() > 0,cZB5Tipo := u,cZB5Tipo)},;
		aTipo,90,20,oDlgFolder,,{||fBloqAba()},,,,.T.,,,,{||nPar==2},,,,,"cZB5Tipo")


/**************
* EQUIPAMENTO *
**************/

@ 005,040 LISTBOX oLbx FIELDS HEADER ;
"Item","Equipamento","Descricao","Pos. X","Pos. Y","Prog. Pallet 1","Prog. Pallet 2",;
"Conc. �leo Sol�vel","Pres. Refrig. Interna","Press�o Ar Compr." ;
   SIZE aPosObj[2,4],aPosObj[2,3] PIXEL OF oFolder:aDialogs[1]  //ON DBLCLICK( u_fDet(oLbx:nAt))//,oDlg:End())

oLbx:SetArray( aMaq )

If nPar == 2
	aAdd(aMaq,{"","","","","",0,0,0,"",0,""})
EndIf

oLbx:bLine := {|| {aMaq[oLbx:nAt,1],;  // ITEM
				   aMaq[oLbx:nAt,2],;  // M�QUINA
	               aMaq[oLbx:nAt,3],;  // DESCRICAO
   		           aMaq[oLbx:nAt,4],;  // POS. X
       		       aMaq[oLbx:nAt,5],;  // POS. Y
           		   aMaq[oLbx:nAt,6],;  // PROG. PALLET 1
          	       aMaq[oLbx:nAt,7],;  // PROG. PALLET 2
                   aMaq[oLbx:nAt,8],;  // CONCENTRACAO DE OLEO SOL�VEL
 	               aMaq[oLbx:nAt,9],;  // PRESSAO REFRIGERA��O INTERNA
   		           aMaq[oLbx:nAt,10]}} // PRESS�O AR COMPRIMIDO
oLbx:Refresh()                  

@ 005,005 BUTTON "&Visualizar" SIZE 030,010 OF oFolder:aDialogs[1] PIXEL ACTION fMaqCad(1)
@ 015,005 BUTTON "&Incluir"    SIZE 030,010 OF oFolder:aDialogs[1] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fMaqCad(2)
@ 025,005 BUTTON "&Alterar"    SIZE 030,010 OF oFolder:aDialogs[1] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fMaqCad(3)
@ 035,005 BUTTON "&Excluir"    SIZE 030,010 OF oFolder:aDialogs[1] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fMaqCad(4)

/**************
* DISPOSITIVO *
**************/

@ 005,040 LISTBOX oLbx2 FIELDS HEADER ;
"Item","Disp. Pallet 1","Letra 1","Disp. Pallet 2","Letra 2", "Press. Fix. 1","Press. Fix. 2","Qtd P�/Disp";
   SIZE aPosObj[2,4],aPosObj[2,3] PIXEL OF oFolder:aDialogs[2] 

oLbx2:SetArray(aDisp)

If nPar == 2//incluir
	aAdd(aDisp,{"","","","","",0,0,0,""})
EndIf

oLbx2:bLine := {|| {aDisp[oLbx2:nAt,1],;  // ITEM
					aDisp[oLbx2:nAt,2],;  // N� DISPOSITIVO PALLET 1
					aDisp[oLbx2:nAt,3],;  // LETRA 1
				    aDisp[oLbx2:nAt,4],;  // N� DISPOSITIVO PALLET 2
					aDisp[oLbx2:nAt,5],;  // LETRA 2
	                aDisp[oLbx2:nAt,6],;  // PRESS�O DE FIXA��O DISPOSITIVO 1
   		            aDisp[oLbx2:nAt,7],;  // PRESS�O DE FIXA��O DISPOSITIVO 2
   		            aDisp[oLbx2:nAt,8]}}  // QUANTIDADE DE PE�AS / DISPOSITIVO
oLbx2:Refresh()

@ 005,005 BUTTON "&Visualizar" SIZE 030,010 OF oFolder:aDialogs[2] PIXEL ACTION fDispCad(1)
@ 015,005 BUTTON "&Incluir"    SIZE 030,010 OF oFolder:aDialogs[2] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fDispCad(2)
@ 025,005 BUTTON "&Alterar"    SIZE 030,010 OF oFolder:aDialogs[2] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fDispCad(3)
@ 035,005 BUTTON "&Excluir"    SIZE 030,010 OF oFolder:aDialogs[2] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fDispCad(4)

/**************
* FERRAMENTAS *
**************/

@ 005,040 LISTBOX oLbx3 FIELDS HEADER ;
"Item","N. Montagem";
   SIZE aPosObj[2,4],aPosObj[2,3] PIXEL OF oFolder:aDialogs[3] 

oLbx3:SetArray(aFer)

If nPar == 2
	aAdd(aFer,{"","","","",{},{},{}})
EndIf

oLbx3:bLine := {|| {aFer[oLbx3:nAt,1],;  // ITEM
					aFer[oLbx3:nAt,2]}}  // N� MONTAGEM
oLbx3:Refresh()

@ 005,005 BUTTON "&Visualizar" SIZE 030,010 OF oFolder:aDialogs[3] PIXEL ACTION fFerCad(1)
@ 015,005 BUTTON "&Incluir"    SIZE 030,010 OF oFolder:aDialogs[3] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fFerCad(2)
@ 025,005 BUTTON "&Alterar"    SIZE 030,010 OF oFolder:aDialogs[3] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fFerCad(3)
@ 035,005 BUTTON "&Excluir"    SIZE 030,010 OF oFolder:aDialogs[3] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fFerCad(4)

/***********
* LAVADORA *
***********/

@ 005,040 LISTBOX oLbx4 FIELDS HEADER ;
"Item","Equipamento","Produto","Temperatura","Concentra��o","Tempo Lav.","Tempo Sec.","Tempo Sopro","Press�o","Pe�as/Ciclo";
   SIZE aPosObj[2,4],aPosObj[2,3] PIXEL OF oFolder:aDialogs[4] 

oLbx4:SetArray(aLav)

If nPar == 2
	aAdd(aLav,{"","","","","",0,0,0,0,0,""})
EndIf

oLbx4:bLine := {|| {aLav[oLbx4:nAt,1],;  // ITEM
					aLav[oLbx4:nAt,2],;  // EQUIP
					aLav[oLbx4:nAt,3],;  // PRODUTO
					aLav[oLbx4:nAt,4],;  // TEMPERATURA
					aLav[oLbx4:nAt,5],;  // CONCENTRACAO
					aLav[oLbx4:nAt,6],;  // TEMPO LAVAGEM
					aLav[oLbx4:nAt,7],;  // TEMPO SECAGEM
					aLav[oLbx4:nAt,8],;  // TEMPO DE SOPRO
					aLav[oLbx4:nAt,9],;  // PRESSAO
					aLav[oLbx4:nAt,10]}} // P�/CICLO

oLbx4:Refresh()

@ 005,005 BUTTON "&Visualizar" SIZE 030,010 OF oFolder:aDialogs[4] PIXEL ACTION fLavCad(1)
@ 015,005 BUTTON "&Incluir"    SIZE 030,010 OF oFolder:aDialogs[4] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fLavCad(2)
@ 025,005 BUTTON "&Alterar"    SIZE 030,010 OF oFolder:aDialogs[4] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fLavCad(3)
@ 035,005 BUTTON "&Excluir"    SIZE 030,010 OF oFolder:aDialogs[4] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fLavCad(4)

/**********************************
* EQUIPAMENTO MONTAGEN / MONTAGEM *
**********************************/

@ 005,040 LISTBOX oLbx5 FIELDS HEADER ;
"Item","Equipamento","Press�o";
   SIZE aPosObj[2,4],aPosObj[2,3] PIXEL OF oFolder:aDialogs[5] 

oLbx5:SetArray(aMont)

If nPar == 2
	aAdd(aMont,{"","","","",{}})
EndIf

oLbx5:bLine := {|| {aMont[oLbx5:nAt,1],;  // ITEM
					aMont[oLbx5:nAt,2],;  // EQUIP
					aMont[oLbx5:nAt,3]}}  // PRESS�O

oLbx5:Refresh()

@ 005,005 BUTTON "&Visualizar" SIZE 030,010 OF oFolder:aDialogs[5] PIXEL ACTION fMontCad(1)
@ 015,005 BUTTON "&Incluir"    SIZE 030,010 OF oFolder:aDialogs[5] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fMontCad(2)
@ 025,005 BUTTON "&Alterar"    SIZE 030,010 OF oFolder:aDialogs[5] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fMontCad(3)
@ 035,005 BUTTON "&Excluir"    SIZE 030,010 OF oFolder:aDialogs[5] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fMontCad(4)

/*********
* TESTES *
*********/

@ 005,040 LISTBOX oLbx6 FIELDS HEADER ;
"Item","Equipamento";
   SIZE aPosObj[2,4],aPosObj[2,3] PIXEL OF oFolder:aDialogs[6]

oLbx6:SetArray(aTest)

If nPar == 2
	aAdd(aTest,{"","","",{},{}})
EndIf

oLbx6:bLine := {|| {aTest[oLbx6:nAt,1],;  // ITEM
					aTest[oLbx6:nAt,2]}}  // EQUIPAMENTO

oLbx6:Refresh()

@ 005,005 BUTTON "&Visualizar" SIZE 030,010 OF oFolder:aDialogs[6] PIXEL ACTION fTestCad(1)
@ 015,005 BUTTON "&Incluir"    SIZE 030,010 OF oFolder:aDialogs[6] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fTestCad(2)
@ 025,005 BUTTON "&Alterar"    SIZE 030,010 OF oFolder:aDialogs[6] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fTestCad(3)
@ 035,005 BUTTON "&Excluir"    SIZE 030,010 OF oFolder:aDialogs[6] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fTestCad(4)

/***********
* INSPECAO *
***********/

@ 005,040 LISTBOX oLbx7 FIELDS HEADER ;
"Item","Equipamento";
   SIZE aPosObj[2,4],aPosObj[2,3] PIXEL OF oFolder:aDialogs[7]

oLbx7:SetArray(aInsp)

If nPar == 2
	aAdd(aInsp,{"","","",{}})
EndIf

oLbx7:bLine := {|| {aInsp[oLbx7:nAt,1],;  // ITEM
					aInsp[oLbx7:nAt,2]}}   // EQUIPAMENTO

oLbx7:Refresh()

@ 005,005 BUTTON "&Visualizar" SIZE 030,010 OF oFolder:aDialogs[7] PIXEL ACTION fInspCad(1)
@ 015,005 BUTTON "&Incluir"    SIZE 030,010 OF oFolder:aDialogs[7] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fInspCad(2)
@ 025,005 BUTTON "&Alterar"    SIZE 030,010 OF oFolder:aDialogs[7] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fInspCad(3)
@ 035,005 BUTTON "&Excluir"    SIZE 030,010 OF oFolder:aDialogs[7] WHEN(nPar==2 .Or. nPar==3) PIXEL ACTION fInspCad(4)

/*************
* CADASTRAIS *
*************/

oSay3 := tSay():New(10,10,{||"Elaborador"},oFolder:aDialogs[8],,,,,,.T.,,)
oGet4 := tGet():New(8,50,{|u| if(Pcount()>0,cZb5Elab:=u,cZb5Elab)},oFolder:aDialogs[8],60,8,"@!",{||},;
					,,,,,.T.,,,{||.F.},,,,,,,"cZb5Elab")

oSay4 := tSay():New(10,210,{||"Data Elab."},oFolder:aDialogs[8],,,,,,.T.,,)
oGet5 := tGet():New(8,250,{|u| if(Pcount()>0,dZb5DtElab:=u,dZb5DtElab)},oFolder:aDialogs[8],40,8,"99/99/99",{||},;
					,,,,,.T.,,,{||.F.},,,,,,,"dZb5DtElab")

oSay3 := tSay():New(22,10,{||"Aprovador"},oFolder:aDialogs[8],,,,,,.T.,,)
oGet4 := tGet():New(20,50,{|u| if(Pcount()>0,cZb5Aprova:=u,cZb5Aprova)},oFolder:aDialogs[8],60,8,"@!",{||},;
					,,,,,.T.,,,{||.F.},,,,,,,"cZb5Aprova")

oSay4 := tSay():New(22,210,{||"Data Aprov."},oFolder:aDialogs[8],,,,,,.T.,,)
oGet5 := tGet():New(20,250,{|u| if(Pcount()>0,dZb5DtAprov:=u,dZb5DtAprov)},oFolder:aDialogs[8],40,8,"99/99/99",{||},;
					,,,,,.T.,,,{||.F.},,,,,,,"dZb5DtAprov")

oSay3 := tSay():New(34,10,{||"Resp. Revis�o"},oFolder:aDialogs[8],,,,,,.T.,,)
oGet4 := tGet():New(32,50,{|u| if(Pcount()>0,cZb5ResRev:=u,cZb5ResRev)},oFolder:aDialogs[8],60,8,"@!",{||},;
					,,,,,.T.,,,{||.F.},,,,,,,"cZb5ResRev")

oSay4 := tSay():New(34,210,{||"Data Revis�o"},oFolder:aDialogs[8],,,,,,.T.,,)
oGet5 := tGet():New(32,250,{|u| if(Pcount()>0,dZb5DtRev:=u,dZb5DtRev)},oFolder:aDialogs[8],40,8,"99/99/99",{||},;
					,,,,,.T.,,,{||.F.},,,,,,,"dZb5DtRev")
	
//If nPar==2 .or. nPar==3 .or. nPar==1 //incluir ou alterar
	fBloqAba()
//EndIf

ACTIVATE MSDIALOG oDlgFolder ON INIT EnchoiceBar(oDlgFolder,{|| fGravaFT()},{||oDlgFolder:End()},,)

Return(nil)

//�����������������������������������������4�
//� INCLUI UM EQUIPAMENTO NA FICHA TECNICA �
//�����������������������������������������4�
Static Function fMaqCad(nMPar)
Local bOk       := {|| fGrvMaq()}
Local bCanc     := {||oDlgMaq:End()}
Local bEnchoice := {||EnchoiceBar(oDlgMaq,bOk,bCanc)}
Local lCheck1   := 0
Private nMaqPar := nMPar
Private lApaga  := .T. 

Private cZbHBem     := Space(15)
Private cZbHdBem    := Space(40)
Private cZbHProg1   := Space(16)
Private cZbHProg2   := Space(16)
Private nZbHConsos  := 0
Private cZbHPresri  := Space(8)
Private nZbHPresAc  := 0

   	If nMaqPar != 2 //diferente de INCLUIR
		If fAEmpty(aMaq)
			Alert("N�o h� �tens selecionados!")
			Return .F.
		EndIf
    EndIf
    
	oDlgMaq := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"FICHA T�CNICA DE FABRICA��O - EQUIPAMENTO",,,,,CLR_BLACK,CLR_WHITE,,oDlgFolder,.T.)

	oTitImg1 := tSay():New(020,005,{||"Layout de Equipamento"},oDlgMaq,,,,,,.T.,,)
	//IMAGEM MAQUINA
	oSBox1 := TScrollBox():New(oDlgMaq,030,005, 105,150,.T.,.T.,.T.)
	@ 000,000 BITMAP FILE cBMP01 PIXEL OF oSBox1 object obmp1 // NOBORDER
	
	oCheck1 := tCheckBox():New(138,05,"Ajustar",{|u|if(pcount()>0,lCheck1:=u,lCheck1)};
		,oDlgMaq,30,8,/*Reservado*/,{||fAjustImg(obmp1,oSBox1)},,,,,,.T.)
	
	If nMaqPar == 2 .or. nMaqPar == 3
		@ 140,090 BUTTON "&Alterar"    SIZE 030,008 OF oDlgMaq PIXEL ACTION fAltImg(obmp1)
	EndIf
	
	@ 140,125 BUTTON "&Visualizar" SIZE 030,008 OF oDlgMaq PIXEL ACTION fVisuDes(obmp1:cbmpfile)
	
	@ 020, 220 SAY OemToAnsi("VALORES DE REFER�NCIA") OF oDlgMaq PIXEL
	
	@ 040, 175 SAY OemToAnsi("C�d. da Maquina") OF oDlgMaq PIXEL
	@ 038, 250 MSGET cZbHBem Picture "@!" WHEN(nMaqPar ==2 .or. nMaqPar == 3) F3 "ST9" SIZE 040,08 OF oDlgMaq PIXEL VALID fBem(cZbHBem,1)
	@ 038, 292 MSGET oZbHdbem VAR cZbHdBem Picture "@!" WHEN .F. SIZE 150,08 OF oDlgMaq PIXEL
	
	@ 055, 175 SAY OemToAnsi("Localiza��o da Maquina") OF oDlgMaq PIXEL
	@ 055, 250 SAY OemToAnsi("Pos. X") OF oDlgMaq PIXEL
	@ 053, 270 MSGET oST9posx VAR nST9PosX Picture "@!" When .F. SIZE 030,08 OF oDlgMaq PIXEL
	@ 055, 310 SAY OemToAnsi("Pos. Y") OF oDlgMaq PIXEL
	@ 053, 330 MSGET oST9posy VAR nST9PosY Picture "@!" When .F. SIZE 030,08 OF oDlgMaq PIXEL
	
	@ 070, 175 SAY OemToAnsi("No. Programa Pallet 1") OF oDlgMaq PIXEL 
	@ 068, 250 GET cZbHProg1 Picture "@!" WHEN(nMaqPar ==2 .or. nMaqPar == 3) SIZE 040,08 OF oDlgMaq PIXEL
	
	@ 085, 175 SAY OemToAnsi("No. Programa Pallet 2") OF oDlgMaq PIXEL 
	@ 083, 250 GET cZbHProg2 Picture "@!" WHEN(nMaqPar ==2 .or. nMaqPar == 3) SIZE 040,08 OF oDlgMaq PIXEL
		
	@ 100, 175 SAY OemToAnsi("Concentracao Oleo") OF oDlgMaq PIXEL 
	@ 098, 250 GET nZbHConsos Picture "@E 99999" WHEN(nMaqPar ==2 .or. nMaqPar == 3) SIZE 040,08 OF oDlgMaq PIXEL
	oPercent := tSay():New(100,295,{||"%"},oDlgMaq,,,,,,.T.,,)
	
	@ 115, 175 SAY OemToAnsi("Pressao Refr. Interna") OF oDlgMaq PIXEL 
	@ 113, 250 GET cZbHPresri Picture "@!" WHEN(nMaqPar ==2 .or. nMaqPar == 3) SIZE 040,08 OF oDlgMaq PIXEL
	
	@ 130, 175 SAY OemToAnsi("Pressao Ar Comprimido") OF oDlgMaq PIXEL 
	@ 128, 250 GET nZbHPresAc Picture "@E 99999" WHEN(nMaqPar ==2 .or. nMaqPar == 3) SIZE 040,08 OF oDlgMaq PIXEL
	oBar := tSay():New(130,295,{||"Bar"},oDlgMaq,,,,,,.T.,,)
	
	If nMaqPar == 1 .OR. nMaqPar == 3 .Or. nMaqPar == 4 //visual ou alterar
		cZbHBem := oLbx:AARRAY[oLbx:nAt][2]
		DbSelectArea("ST9")
		DbSetOrder(1)//filial + bem
		If DbSeek(xFilial("ST9")+cZbhBem)
		  	cZbHdBem := ST9->T9_NOME
			nST9PosX := ST9->T9_POSX
			nST9PosY := ST9->T9_POSY
		EndIf
		cZbHProg1  := oLbx:AARRAY[oLbx:nAt][6] 
		cZbHProg2  := oLbx:AARRAY[oLbx:nAt][7]
		nZbHConsos := oLbx:AARRAY[oLbx:nAt][8]
		cZbHPresri := oLbx:AARRAY[oLbx:nAt][9]
		nZbHPresAc := oLbx:AARRAY[oLbx:nAt][10]

		obmp1:cbmpfile  := "/SYSTEM/FT/teste.jpg" //apaga do objeto o endere�o da imagem atual 
		obmp1:cbmpfile  := aMaq[oLbx:nAt][11]   //atribui o endere�o da nova imagem
		obmp1:lautosize := .F.
		obmp1:lautosize := .T.      //for�a o tamanho da imagem
		obmp1:lvisible  := .T.      //for�a a visualiza��o da imagem
	EndIf

	oDlgMaq:Activate(,,,.F.,{||fEndMaq()},,bEnchoice)
	
Return

//����������������������������������������4�
//� INCLUI UM DISPOSITIVO NA FICHA TECNICA �
//����������������������������������������4�
Static Function fDispCad(nDPar)
Local bOk        := {||fGrvDisp()}
Local bCanc      := {||oDlgDisp:End()}
Local bEnchoice  := {||EnchoiceBar(oDlgDisp,bOk,bCanc)}
Local lCheck2    := 0
Private nDispPar := nDPar

Private c1ZbGDisp   := SPACE(15)
Private c2ZbGDisp   := SPACE(15)
Private c1ZbGLetra  := SPACE(01)
Private c2ZbGLetra  := SPACE(01)
Private n1ZbGPFix   := 0
Private n2ZbGPFix   := 0
Private nZbGQtdPD   := 0

   	If nDispPar != 2 //diferente de INCLUIR
		If fAEmpty(aDisp)
			Alert("N�o h� �tens selecionados!")
			Return .F.
		EndIf
    EndIf
    
	oDlgDisp := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"FICHA T�CNICA DE FABRICA��O - DISPOSITIVO",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oTitImg2 := tSay():New(020,005,{||"Esquema de Fixa��o e Localiza��o"},oDlgDisp,,,,,,.T.,,)
	//IMAGEM DO DISPOSITIVO
	oSBox2 := TScrollBox():New(oDlgDisp,030,005, 105,150,.T.,.T.,.T.)
	@ 000,000 BITMAP FILE cBMP02 PIXEL OF oSBox2 object obmp2 // NOBORDER
	
	oCheck2 := tCheckBox():New(138,05,"Ajustar",{|u|if(pcount()>0,lCheck2:=u,lCheck2)};
		,oDlgDisp,30,8,/*Reservado*/,{||fAjustImg(obmp2,oSBox2)},,,,,,.T.)

	If nDispPar == 2 .or. nDispPar == 3
		@ 140,090 BUTTON "&Alterar"    SIZE 030,008 OF oDlgDisp PIXEL ACTION fAltImg(obmp2)
	EndIf
	
	@ 140,125 BUTTON "&Visualizar" SIZE 030,008 OF oDlgDisp PIXEL ACTION fVisuDes(obmp2:cbmpfile)
	
	@ 020, 220 SAY OemToAnsi("VALORES DE REFER�NCIA") OF oDlgDisp PIXEL
	

	@ 050, 175 SAY OemToAnsi("No. Dispositivo Pallet 1") OF oDlgDisp PIXEL 
	oGet1 := tGet():New(48,260,{|u| if(Pcount()>0,c1ZbGDisp:=u,c1ZbGDisp)},oDlgDisp,60,8,"@!",{||fValDisp(c1ZbGDisp,1)},;
					,,,,,.T.,,,{||nDispPar==2 .or. nDispPar==3},,,,,,"ZBN","c1ZbGDisp")
	@ 048, 320 MSGET o1ZbGLetra VAR c1ZbGLetra Picture "@!" WHEN(nDispPar==2 .or. nDispPar==3) SIZE 005,08 OF oDlgDisp PIXEL
	

	@ 065, 175 SAY OemToAnsi("No. Dispositivo Pallet 2") OF oDlgDisp PIXEL 
	oGet3 := tGet():New(63,260,{|u| if(Pcount()>0,c2ZbGDisp:=u,c2ZbGDisp)},oDlgDisp,60,8,"@!",{||fValDisp(c2ZbGDisp,2)},;
					,,,,,.T.,,,{||nDispPar==2 .or. nDispPar==3},,,,,,"ZBN","c2ZbGDisp")
	@ 063, 320 MSGET o2ZbGLetra VAR c2ZbGLetra Picture "@!" WHEN(nDispPar==2 .or. nDispPar==3) SIZE 005,08 OF oDlgDisp PIXEL
	

	@ 080, 175 SAY OemToAnsi("Press�o de Fixa��o Dispositivo 1") OF oDlgDisp PIXEL 
	oGet5 := tGet():New(78,260,{|u| if(Pcount()>0,n1ZbGPfix:=u,n1ZbGPfix)},oDlgDisp,40,8,"@E 99999",{||.T.},;
					,,,,,.T.,,,{||(nDispPar ==2 .or. nDispPar == 3) .AND. !Empty(c1ZbGDisp)},,,,,,,"n1ZbGPfix")
	@ 080, 305 SAY OemToAnsi("bar") OF oDlgDisp PIXEL 


	@ 095, 175 SAY OemToAnsi("Press�o de Fixa��o Dispositivo 2") OF oDlgDisp PIXEL 
	oGet6 := tGet():New(93,260,{|u| if(Pcount()>0,n2ZbGPfix:=u,n2ZbGPfix)},oDlgDisp,40,8,"@E 99999",{||.T.},;
					,,,,,.T.,,,{||(nDispPar ==2 .or. nDispPar == 3) .AND. !Empty(c2ZbGDisp)},,,,,,,"n2ZbGPfix")
	@ 095, 305 SAY OemToAnsi("bar") OF oDlgDisp PIXEL
	
	@ 110, 175 SAY OemToAnsi("Quantidade de Pe�as/Dispositivo") OF oDlgDisp PIXEL 
	@ 108, 260 GET nZbGQtdPD Picture "@E 99999" WHEN(nDispPar ==2 .or. nDispPar == 3) SIZE 040,08 OF oDlgDisp PIXEL   
		
	If nDispPar == 1 .OR. nDispPar == 3 .Or. nDispPar == 4 //visual ou alterar
		c1ZbGDisp  := oLbx2:AARRAY[oLbx2:nAt][2]
		c1ZbGLetra := oLbx2:AARRAY[oLbx2:nAt][3]
		c2ZbGDisp  := oLbx2:AARRAY[oLbx2:nAt][4]
		c2ZbGLetra := oLbx2:AARRAY[oLbx2:nAt][5]
		n1ZbGPfix  := oLbx2:AARRAY[oLbx2:nAt][6]
		n2ZbGPFix  := oLbx2:AARRAY[oLbx2:nAt][7]
		nZbGQtdPD  := oLbx2:AARRAY[oLbx2:nAt][8]
		
		obmp2:cbmpfile  := "/SYSTEM/FT/teste.jpg" //apaga do objeto o endere�o da imagem atual 
		obmp2:cbmpfile  := aDisp[oLbx2:nAt][9]   //atribui o endere�o da nova imagem
		obmp2:lautosize := .F.
		obmp2:lautosize := .T.      //for�a o tamanho da imagem
		obmp2:lvisible  := .T.      //for�a a visualiza��o da imagem
	EndIf

	oDlgDisp:Activate(,,,.F.,{||fEndDisp()},,bEnchoice)
	
Return

//������������������������������������������Ŀ
//� INCLUI UMA MONTAGEM DE FERRAMENTAS NA FT �
//��������������������������������������������
Static Function fFerCad(nFPar)
Local bOk           := {||fGrvFer()}
Local bCanc         := {||oDlgFer:End()}
Local bEnchoice     := {||EnchoiceBar(oDlgFer,bOk,bCanc)}
Local lCheck31      := 0
Local lCheck32      := 0
Private nFerPar     := nFPar
private cZbCNumMont := space(15) //numero da montagem da ficha t�cnica de ferramentas

   	If nFerPar != 2 //diferente de INCLUIR
		If fAEmpty(aFer)
			Alert("N�o h� �tens selecionados!")
			Return .F.
		EndIf
    EndIf
    
	oDlgFer := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"FICHA T�CNICA DE FABRICA��O - FERRAMENTAS",,,,,CLR_BLACK,CLR_WHITE,,,.T.)


	@ 020,005 Say "N� Montagem: " SIZE 040,008 OF oDlgFer PIXEL
	@ 018,045 MSGet cZbCNumMont  F3 "ZBJ" WHEN(nFerPar==2) SIZE 060,008 OF oDlgFer PIXEL Valid fAtuMont()


	//IMAGEM FERRAMENTA 1
	oTitImg3 := tSay():New(035,005,{||"Layout de Ferramenta"},oDlgFer,,,,,,.T.,,)

	oSBox3_1 := TScrollBox():New(oDlgFer,045,005,105,150,.T.,.T.,.T.)
	@ 000,000 BITMAP FILE cBMP03_1 PIXEL OF oSBox3_1 object obmp3_1 // NOBORDER
	
	oCheck31 := tCheckBox():New(153,05,"Ajustar",{|u|if(pcount()>0,lCheck31:=u,lCheck31)};
		,oDlgFer,30,8,,{||fAjustImg(obmp3_1,oSBox3_1)},,,,,,.T.)

	@ 155,125 BUTTON "&Visualizar" SIZE 030,008 OF oDlgFer PIXEL ACTION fVisuDes(obmp3_1:cbmpfile)

	//IMAGEM FERRAMENTA 2
	oTitImg4 := tSay():New(035,160,{||"Localiza��o de Usinagem"},oDlgFer,,,,,,.T.,,)

	oSBox3_2 := TScrollBox():New(oDlgFer,045,160,105,150,.T.,.T.,.T.)
	@ 000,000 BITMAP FILE cBMP03_2 PIXEL OF oSBox3_2 object obmp3_2 // NOBORDER
	
	oCheck32 := tCheckBox():New(153,160,"Ajustar",{|u|if(pcount()>0,lCheck32:=u,lCheck32)};
		,oDlgFer,30,8,/*Reservado*/,{||fAjustImg(obmp3_2,oSBox3_2)},,,,,,.T.)
		
	If nFerPar == 2 .or. nFerPar == 3
		@ 155,245 BUTTON "&Alterar"    SIZE 030,008 OF oDlgFer PIXEL ACTION fAltImg(obmp3_2)
	EndIf
	
	@ 155,280 BUTTON "&Visualizar" SIZE 030,008 OF oDlgFer PIXEL ACTION fVisuDes(obmp3_2:cbmpfile)

	//botao1                                   
	@ 350,005 BTNBMP oBtn01 RESOURCE "CTBREPLA" SIZE 130,24 OF oDlgFer PIXEL ACTION fItensMontFe()
	oBtn01:cCaption:= PADR(OemToAnsi("&ITENS"),32)
	oBtn01:cToolTip:= OemToAnsi("Itens da Montagem de Ferramentas "+cZbCNumMont)

	//botao2
	

	oBtn02:cCaption:= PADR(OemToAnsi("&PROCESSO"),32)
	oBtn02:cToolTip:= OemToAnsi("Vari�veis do Processo")
	
	//botao3
	@ 450,005 BTNBMP oBtn03 RESOURCE "LINE" SIZE 130,24 OF oDlgFer PIXEL ACTION fCoord()
	oBtn03:cCaption:= PADR(OemToAnsi("&COORDENADAS"),32)
	oBtn03:cToolTip:= OemToAnsi("Coordenadas de Usinagem")

	If nFerPar == 1 .OR. nFerPar == 3 .Or. nFerPar == 4 //visual, alterar ou excluir

		cZbCNumMont     := aFer[oLbx3:nAt][2] 	  //numero montagem
		oDlgFer:cCaption := cZbCNumMont
		oDlgFer:cTitle   := cZbCNumMont
		aItmFer          := aFer[oLbx3:nAt][5] 	  //array com os itens das ferramentas
		aItmPro          := aFer[oLbx3:nAt][6] 	  //array com os itens do processo
		aItmCoord        := aFer[oLbx3:nAt][7] 	  //array com os itens das coordenadas
		
		obmp3_1:cbmpfile  := "/SYSTEM/FT/teste.jpg" //apaga do objeto o endere�o da imagem atual 
		obmp3_1:cbmpfile  := aFer[oLbx3:nAt][3]     //atribui o endere�o da nova imagem
		obmp3_1:lautosize := .F.
		obmp3_1:lautosize := .T.      			  //for�a o tamanho da imagem
		obmp3_1:lvisible  := .T.      			  //for�a a visualiza��o da imagem
		
		obmp3_2:cbmpfile  := "/SYSTEM/FT/teste.jpg" //apaga do objeto o endere�o da imagem atual 
		obmp3_2:cbmpfile  := aFer[oLbx3:nAt][4]     //atribui o endere�o da nova imagem
		obmp3_2:lautosize := .F.
		obmp3_2:lautosize := .T.          		  //for�a o tamanho da imagem
		obmp3_2:lvisible  := .T.                    //for�a a visualiza��o da imagem

	EndIf

	oDlgFer:Activate(,,,.F.,{||fEndFer()},,bEnchoice)

Return

//����������������������Ŀ
//� CADASTRO DA LAVADORA �
//������������������������
Static Function fLavCad(nLPar)
Local bOk       := {|| fGrvLav()}
Local bCanc     := {||oDlgLav:End()}
Local bEnchoice := {||EnchoiceBar(oDlgLav,bOk,bCanc)}
Local lCheck4   := 0
Private nLavPar := nLPar
                            
Private cZD2Bem  := Space(15) //codigo do bem
Private cZD2dBem := ""        //descricao do bem
Private cZD2PBan := Space(25) //produto do banho
Private cZD2TBan := Space(10) //temperatura do banho
Private cZD2CBan := Space(10) //concentracao do banho
Private nZD2TLav := 0         //tempo de lavagem (segundos)
Private nZD2TSec := 0         //tempo de secagem (segundos)
Private nZD2TSop := 0         //tempo de sopro (segundos)
Private nZD2Pres := 0         //press�o
Private nZD2PpCi := 0         //pe�as por ciclo

   	If nLavPar != 2 //diferente de INCLUIR
		If fAEmpty(aLav)
			Alert("N�o h� �tens selecionados!")
			Return .F.
		EndIf
    EndIf
    
	oDlgLav := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"FICHA T�CNICA DE FABRICA��O - LAVADORA",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oTitImg4 := tSay():New(020,005,{||"Layout de Equipamento"},oDlgLav,,,,,,.T.,,)
	
	//IMAGEM MAQUINA
	oSBox4 := TScrollBox():New(oDlgLav,030,005, 105,150,.T.,.T.,.T.)
	@ 000,000 BITMAP FILE cBMP04 PIXEL OF oSBox4 object obmp4 // NOBORDER
	
	oCheck4 := tCheckBox():New(138,05,"Ajustar",{|u|if(pcount()>0,lCheck4:=u,lCheck4)};
		,oDlgLav,30,8,/*Reservado*/,{||fAjustImg(obmp4,oSBox4)},,,,,,.T.)
	
	If nLavPar == 2 .or. nLavPar == 3
		@ 140,090 BUTTON "&Alterar"    SIZE 030,008 OF oDlgLav PIXEL ACTION fAltImg(obmp4)
	EndIf
	
	@ 140,125 BUTTON "&Visualizar" SIZE 030,008 OF oDlgLav PIXEL ACTION fVisuDes(obmp4:cbmpfile)
	
	@ 020, 220 SAY OemToAnsi("VALORES DE REFER�NCIA") OF oDlgLav PIXEL
	
	@ 040, 175 SAY OemToAnsi("C�d. da Maquina") OF oDlgLav PIXEL
	@ 038, 250 MSGET cZD2Bem Picture "@!" WHEN(nLavPar ==2 .or. nLavPar == 3) F3 "ST9" SIZE 040,08 OF oDlgLav PIXEL VALID fBem(cZD2Bem,2)
	@ 038, 292 MSGET oZD2dbem VAR cZD2DBem Picture "@!" WHEN .F. SIZE 150,08 OF oDlgLav PIXEL
	
	@ 055, 175 SAY OemToAnsi("Localiza��o da Maquina") OF oDlgLav PIXEL
	@ 055, 250 SAY OemToAnsi("Pos. X") OF oDlgLav PIXEL
	@ 053, 270 MSGET oST9posx VAR nST9PosX Picture "@!" When .F. SIZE 030,08 OF oDlgLav PIXEL
	@ 055, 310 SAY OemToAnsi("Pos. Y") OF oDlgLav PIXEL
	@ 053, 330 MSGET oST9posy VAR nST9PosY Picture "@!" When .F. SIZE 030,08 OF oDlgLav PIXEL
	
	oSay1 := TSay():New(70,175,{||"Produto do Banho"},oDlgLav,,,,,,.T.,,)
	oGet1 := tGet():New(68,250,{|u| if(Pcount() > 0, cZD2PBan := u,cZD2PBan)},oDlgLav,90,8,"@!",/*valid*/,;
		,,,,,.T.,,,{||nLavPar ==2 .or. nLavPar == 3},,,,,,,"cZD2PBan")

	oSay2 := TSay():New(85,175,{||"Temperatura do Banho"},oDlgLav,,,,,,.T.,,)
	oGet2 := tGet():New(83,250,{|u| if(Pcount() > 0, cZD2TBan := u,cZD2TBan)},oDlgLav,50,8,"@!",/*valid*/,;
		,,,,,.T.,,,{||nLavPar ==2 .or. nLavPar == 3},,,,,,,"cZD2TBan")

	oSay3 := TSay():New(100,175,{||"Concentra��o do Banho"},oDlgLav,,,,,,.T.,,)
	oGet3 := tGet():New(098,250,{|u| if(Pcount() > 0, cZD2CBan := u,cZD2CBan)},oDlgLav,50,8,"@!",/*valid*/,;
		,,,,,.T.,,,{||nLavPar ==2 .or. nLavPar == 3},,,,,,,"cZD2CBan")

	oSay3 := TSay():New(115,175,{||"Tempo de Lavagem"},oDlgLav,,,,,,.T.,,)
	oGet3 := tGet():New(113,250,{|u| if(Pcount() > 0, nZD2TLav := u,nZD2TLav)},oDlgLav,50,8,"@e 99,999",/*valid*/,;
		,,,,,.T.,,,{||nLavPar ==2 .or. nLavPar == 3},,,,,,,"nZD2TLav")
	oSay4 := TSay():New(115,305,{||"s"},oDlgLav,,,,,,.T.,,)

	oSay5 := TSay():New(130,175,{||"Tempo de Secagem"},oDlgLav,,,,,,.T.,,)
	oGet4 := tGet():New(128,250,{|u| if(Pcount() > 0, nZD2TSec := u,nZD2TSec)},oDlgLav,50,8,"@e 99,999",/*valid*/,;
		,,,,,.T.,,,{||nLavPar ==2 .or. nLavPar == 3},,,,,,,"nZD2TSec")
	oSay6 := TSay():New(130,305,{||"s"},oDlgLav,,,,,,.T.,,)
	
	oSay7 := TSay():New(145,175,{||"Tempo de Sopro"},oDlgLav,,,,,,.T.,,)
	oGet5 := tGet():New(143,250,{|u| if(Pcount() > 0, nZD2TSop := u,nZD2TSop)},oDlgLav,50,8,"@e 99,999",/*valid*/,;
		,,,,,.T.,,,{||nLavPar ==2 .or. nLavPar == 3},,,,,,,"nZD2TSop")
	oSay8 := TSay():New(145,305,{||"s"},oDlgLav,,,,,,.T.,,)

	oSay9 := TSay():New(160,175,{||"Press�o"},oDlgLav,,,,,,.T.,,)
	oGet6 := tGet():New(158,250,{|u| if(Pcount() > 0, nZD2Pres := u,nZD2Pres)},oDlgLav,50,8,"@e 99,999",/*valid*/,;
		,,,,,.T.,,,{||nLavPar ==2 .or. nLavPar == 3},,,,,,,"nZD2Pres")
	oSay10 := TSay():New(160,305,{||"bar"},oDlgLav,,,,,,.T.,,)
	
	oSay11 := TSay():New(175,175,{||"Pe�as por Ciclo"},oDlgLav,,,,,,.T.,,)
	oGet7  := tGet():New(173,250,{|u| if(Pcount() > 0, nZD2PpCi := u,nZD2PpCi)},oDlgLav,50,8,"@e 999",/*valid*/,;
		,,,,,.T.,,,{||nLavPar ==2 .or. nLavPar == 3},,,,,,,"nZD2PpCi")
	
	If nLavPar == 1 .OR. nLavPar == 3 .Or. nLavPar == 4 //visual ou alterar
		cZD2Bem  := aLav[oLbx4:nAt][2]
		ST9->(dbSetOrder(1)) //filial + codbem
		ST9->(dbSeek(xFilial("ST9")+cZD2Bem))
		cZD2dBem := ST9->T9_NOME
		nST9PosX := ST9->T9_POSX
		nST9PosY := ST9->T9_POSY
    	cZD2PBan := aLav[oLbx4:nAt][3]
		cZD2TBan := aLav[oLbx4:nAt][4]
		cZD2CBan := aLav[oLbx4:nAt][5]
		nZD2TLav := aLav[oLbx4:nAt][6]
		nZD2TSec := aLav[oLbx4:nAt][7]
		nZD2TSop := aLav[oLbx4:nAt][8]
		nZD2Pres := aLav[oLbx4:nAt][9]
		nZD2PpCi := aLav[oLbx4:nAt][10]
		
		obmp4:cbmpfile  := "/SYSTEM/FT/teste.jpg" //apaga do objeto o endere�o da imagem atual
		obmp4:cbmpfile  := aLav[oLbx:nAt][11]     //atribui o endere�o da nova imagem
		obmp4:lautosize := .F.
		obmp4:lautosize := .T.                    //for�a o tamanho da imagem
		obmp4:lvisible  := .T.                    //for�a a visualiza��o da imagem
	EndIf

	oDlgLav:Activate(,,,.F.,{||fEndLav()},,bEnchoice)
	
Return

//������������������������������������������������Ŀ
//� CADASTRO DO EQUIPAMENTO DE MONTAGEM / MONTAGEM �
//��������������������������������������������������
Static Function fMontCad(nMParam)
Local bOk        := {||fGrvMont()}
Local bCanc      := {||oDlgMont:End()}
Local bEnchoice  := {||EnchoiceBar(oDlgMont,bOk,bCanc)}
Local lCheck5    := 0
Private nMontPar := nMParam
                            
Private cZD3Bem   := Space(15) //codigo do bem
Private cZD3dBem  := ""        //descricao do bem
Private cZD3PUHP  := Space(10)

   	If nMontPar != 2 //diferente de INCLUIR
		If fAEmpty(aMont)
			Alert("N�o h� �tens selecionados!")
			Return .F.
		EndIf
    EndIf
    
	oDlgMont := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"FICHA T�CNICA DE FABRICA��O - MONTAGEM",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oTitImg5 := tSay():New(020,005,{||"Layout de Equipamento"},oDlgMont,,,,,,.T.,,)
	
	//IMAGEM MAQUINA
	oSBox5 := TScrollBox():New(oDlgMont,030,005, 105,150,.T.,.T.,.T.)
	@ 000,000 BITMAP FILE cBMP05 PIXEL OF oSBox5 object obmp5 // NOBORDER
	
	oCheck5 := tCheckBox():New(138,05,"Ajustar",{|u|if(pcount()>0,lCheck5:=u,lCheck5)};
		,oDlgMont,30,8,/*Reservado*/,{||fAjustImg(obmp5,oSBox5)},,,,,,.T.)
	
	If nMontPar == 2 .or. nMontPar == 3
		@ 140,090 BUTTON "&Alterar"    SIZE 030,008 OF oDlgMont PIXEL ACTION fAltImg(obmp5)
	EndIf
	
	@ 140,125 BUTTON "&Visualizar" SIZE 030,008 OF oDlgMont PIXEL ACTION fVisuDes(obmp5:cbmpfile)
	
	@ 020, 220 SAY OemToAnsi("VALORES DE REFER�NCIA") OF oDlgMont PIXEL
	
	@ 040, 175 SAY OemToAnsi("C�d. da Maquina") OF oDlgMont PIXEL
	@ 038, 250 MSGET cZD3Bem Picture "@!" WHEN(nMontPar ==2 .or. nMontPar == 3) F3 "ST9" SIZE 040,08 OF oDlgMont PIXEL VALID fBem(cZD3Bem,3)
	@ 038, 292 MSGET oZD3dbem VAR cZD3DBem Picture "@!" WHEN .F. SIZE 150,08 OF oDlgMont PIXEL
	
	@ 055, 175 SAY OemToAnsi("Localiza��o da Maquina") OF oDlgMont PIXEL
	@ 055, 250 SAY OemToAnsi("Pos. X") OF oDlgMont PIXEL
	@ 053, 270 MSGET oST9posx VAR nST9PosX Picture "@!" When .F. SIZE 030,08 OF oDlgMont PIXEL
	@ 055, 310 SAY OemToAnsi("Pos. Y") OF oDlgMont PIXEL
	@ 053, 330 MSGET oST9posy VAR nST9PosY Picture "@!" When .F. SIZE 030,08 OF oDlgMont PIXEL
	
	oSay1 := TSay():New(70,175,{||"Press�o Unidade Hidr�ulica/Pneum�tica"},oDlgMont,,,,,,.T.,,)
	oGet1 := tGet():New(68,280,{|u| if(Pcount() > 0, cZD3PUHP := u,cZD3PUHP)},oDlgMont,45,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nMontPar ==2 .or. nMontPar == 3},,,,,,,"cZD3PUHP")

	//botao1
	@ 310,005 BTNBMP oBtn01 RESOURCE "CTBREPLA" SIZE 130,24 OF oDlgMont PIXEL ACTION fMontCom()
	oBtn01:cCaption:= PADR(OemToAnsi("&COMPONENTES"),32)
	oBtn01:cToolTip:= OemToAnsi("Componentes do Equipamento de Montagem")


	If nMontPar == 1 .OR. nMontPar == 3 .Or. nMontPar == 4 //visual ou alterar ou excluir
		cZD3Bem  := aMont[oLbx5:nAt][2]
		ST9->(dbSetOrder(1)) //filial + codbem
		ST9->(dbSeek(xFilial("ST9")+cZD3Bem))
		cZD3dBem := ST9->T9_NOME
		nST9PosX := ST9->T9_POSX
		nST9PosY := ST9->T9_POSY
    	cZD3Bem  := aMont[oLbx5:nAt][2]
    	cZD3PUHP := aMont[oLbx5:nAt][3]

		obmp5:cbmpfile  := "/SYSTEM/FT/teste.jpg" //apaga do objeto o endere�o da imagem atual 
		obmp5:cbmpfile  := aMont[oLbx5:nAt][4]    //atribui o endere�o da nova imagem
		obmp5:lautosize := .F.
		obmp5:lautosize := .T.                    //for�a o tamanho da imagem
		obmp5:lvisible  := .T.                    //for�a a visualiza��o da imagem

    	aMontCom := aMont[oLbx5:nAt][5]
	EndIf

	oDlgMont:Activate(,,,.F.,{||fEndMont()},,bEnchoice)

Return

//������������������������������������Ŀ
//�CADATRO DOS TESTES DE ESTANQUEIDADE �
//��������������������������������������
Static Function fTestCad(nTParam)
Local bOk        := {||fGrvTest()}
Local bCanc      := {||oDlgTest:End()}
Local bEnchoice  := {||EnchoiceBar(oDlgTest,bOk,bCanc)}
Local lCheck6    := 0
Private nTestPar := nTParam
                            
Private cZD4Bem  := Space(15) //codigo do bem
Private cZD4dBem := ""        //descricao do bem

   	If nTestPar != 2 //diferente de INCLUIR
		If fAEmpty(aTest)
			Alert("N�o h� �tens selecionados!")
			Return .F.
		EndIf
    EndIf
    
	oDlgTest := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"FICHA T�CNICA DE FABRICA��O - TESTE ESTANQUEIDADE",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oTitImg6 := tSay():New(020,005,{||"Layout de Equipamento"},oDlgTest,,,,,,.T.,,)
	
	//IMAGEM MAQUINA
	oSBox6 := TScrollBox():New(oDlgTest,030,005, 105,150,.T.,.T.,.T.)
	@ 000,000 BITMAP FILE cBMP06 PIXEL OF oSBox6 object obmp6 // NOBORDER
	
	oCheck6 := tCheckBox():New(138,05,"Ajustar",{|u|if(pcount()>0,lCheck6:=u,lCheck6)};
		,oDlgTest,30,8,,{||fAjustImg(obmp6,oSBox6)},,,,,,.T.)
	
	If nTestPar == 2 .or. nTestPar == 3
		@ 140,090 BUTTON "&Alterar"    SIZE 030,008 OF oDlgTest PIXEL ACTION fAltImg(obmp6)
	EndIf
	
	@ 140,125 BUTTON "&Visualizar" SIZE 030,008 OF oDlgTest PIXEL ACTION fVisuDes(obmp6:cbmpfile)
	
	@ 020, 220 SAY OemToAnsi("VALORES DE REFER�NCIA") OF oDlgTest PIXEL
	
	@ 040, 175 SAY OemToAnsi("C�d. da Maquina") OF oDlgTest PIXEL
	@ 038, 250 MSGET cZD4Bem Picture "@!" WHEN(nTestPar==2 .or. nTestPar==3) F3 "ST9" SIZE 040,08 OF oDlgTest PIXEL VALID fBem(cZD4Bem,4)
	@ 038, 292 MSGET oZD4dbem VAR cZD4DBem Picture "@!" WHEN .F. SIZE 150,08 OF oDlgTest PIXEL
	
	@ 055, 175 SAY OemToAnsi("Localiza��o da Maquina") OF oDlgTest PIXEL
	@ 055, 250 SAY OemToAnsi("Pos. X") OF oDlgTest PIXEL
	@ 053, 270 MSGET oST9posx VAR nST9PosX Picture "@!" When .F. SIZE 030,08 OF oDlgTest PIXEL
	@ 055, 310 SAY OemToAnsi("Pos. Y") OF oDlgTest PIXEL
	@ 053, 330 MSGET oST9posy VAR nST9PosY Picture "@!" When .F. SIZE 030,08 OF oDlgTest PIXEL
	
	//botao1
	@ 310,005 BTNBMP oBtn01 RESOURCE "CTBREPLA" SIZE 130,24 OF oDlgTest PIXEL ACTION fTestItm()
	oBtn01:cCaption:= PADR(OemToAnsi("&VEDA��ES"),32)
	oBtn01:cToolTip:= OemToAnsi("Itens do teste de estanqueidade")

//	oSay1 := TSay():New(185,05,{||},oDlgMont,,,,,,.T.,,)

	oGrpPar := tGroup():New(175,5,270,400,"Par�metros",oDlgTest,,,.T.)
	
	@ 185,045 LISTBOX oLbxPar FIELDS HEADER ;
	"Item","Tipo","Medidor","Programa";
	   SIZE 350,80 PIXEL OF oDlgTest
	
	@ 185,010 BUTTON "&Visualizar" SIZE 030,010 OF oDlgTest PIXEL ACTION fTestPar(1)
	@ 195,010 BUTTON "&Incluir"    SIZE 030,010 OF oDlgTest WHEN(nTestPar==2 .or. nTestPar==3) PIXEL ACTION fTestPar(2)
	@ 205,010 BUTTON "&Alterar"    SIZE 030,010 OF oDlgTest WHEN(nTestPar==2 .or. nTestPar==3) PIXEL ACTION fTestPar(3)
	@ 215,010 BUTTON "&Excluir"    SIZE 030,010 OF oDlgTest WHEN(nTestPar==2 .or. nTestPar==3) PIXEL ACTION fTestPar(4)

	If nTestPar == 1 .OR. nTestPar == 3 .Or. nTestPar == 4 //visual ou alterar

		cZD4Bem  := aTest[oLbx6:nAt][2]
		ST9->(dbSetOrder(1)) //filial + codbem
		ST9->(dbSeek(xFilial("ST9")+cZD4Bem))
		cZD4dBem := ST9->T9_NOME
		nST9PosX := ST9->T9_POSX
		nST9PosY := ST9->T9_POSY

		obmp6:cbmpfile  := "/SYSTEM/FT/teste.jpg" //apaga do objeto o endere�o da imagem atual 
		obmp6:cbmpfile  := aTest[oLbx6:nAt][3]    //atribui o endere�o da nova imagem
		obmp6:lautosize := .F.
		obmp6:lautosize := .T.                    //for�a o tamanho da imagem
		obmp6:lvisible  := .T.                    //for�a a visualiza��o da imagem

    	aItmTest := aTest[oLbx6:nAt][4]
    	aParTest := aTest[oLbx6:nAt][5]
	EndIf

	If nTestPar == 2 //incluir
		aParTest := {}
		aAdd(aParTest,{Space(4),Space(40),Space(30),Space(15),{}})
	EndIf
	
	oLbxPar:SetArray(aParTest)
	
	oLbxPar:bLine := {|| {aParTest[oLbxPar:nAt,1],;  // ITEM
						  aParTest[oLbxPar:nAt,2],;  // TIPO
						  aParTest[oLbxPar:nAt,3],;  // MEDIDOR
						  aParTest[oLbxPar:nAt,4]}}  // PROGRAMA

	oLbxPar:Refresh()

	oDlgTest:Activate(,,,.F.,{||fEndTest()},,bEnchoice)

Return

//������������������������
//� CADASTRO DA INSPECAO �
//������������������������
Static Function fInspCad(nInsParam)
Local bOk        := {||fGrvInsp()}
Local bCanc      := {||oDlgInsp:End()}
Local bEnchoice  := {||EnchoiceBar(oDlgInsp,bOk,bCanc)}
Local lCheck7    := 0
Private nInspPar := nInsParam
                            
Private cZD5Bem  := Space(15) //codigo do bem
Private cZD5dBem := ""        //descricao do bem
/*
Private cZD5fLuz := Space(15) //fonte de luz
Private cZD5Rasq := Space(15) //rasquete
Private cZD5Vare := Space(15) //vareta
Private cZD5MInd := Space(15) //mercador industrial
Private cDesfLuz := ""  
Private cDesRasq := ""  
Private cDesVare := ""  
Private cDesMInd := ""  
*/

   	If nInspPar != 2 //diferente de INCLUIR
		If fAEmpty(aInsp)
			Alert("N�o h� �tens selecionados!")
			Return .F.
		EndIf
    EndIf
    
	oDlgInsp := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"FICHA T�CNICA DE FABRICA��O - INSPE��O",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oTitImg7 := tSay():New(020,005,{||"Layout de Inspe��o"},oDlgInsp,,,,,,.T.,,)
	
	//IMAGEM MAQUINA
	oSBox7 := TScrollBox():New(oDlgInsp,030,005, 105,150,.T.,.T.,.T.)
	@ 000,000 BITMAP FILE cBMP07 PIXEL OF oSBox7 object obmp7 // NOBORDER
	
	oCheck7 := tCheckBox():New(138,05,"Ajustar",{|u|if(pcount()>0,lCheck7:=u,lCheck7)};
		,oDlgInsp,30,8,,{||fAjustImg(obmp7,oSBox7)},,,,,,.T.)
	
	If nInspPar == 2 .or. nInspPar == 3
		@ 140,090 BUTTON "&Alterar"    SIZE 030,008 OF oDlgInsp PIXEL ACTION fAltImg(obmp7)
	EndIf
	
	@ 140,125 BUTTON "&Visualizar" SIZE 030,008 OF oDlgInsp PIXEL ACTION fVisuDes(obmp7:cbmpfile)
	
	@ 020, 220 SAY OemToAnsi("VALORES DE REFER�NCIA") OF oDlgInsp PIXEL
	
	@ 040, 175 SAY OemToAnsi("C�d. da Maquina") OF oDlgInsp PIXEL
	@ 038, 250 MSGET cZD5Bem Picture "@!" WHEN(nInspPar==2 .or. nInspPar==3) F3 "ST9" SIZE 040,08 OF oDlgInsp PIXEL VALID fBem(cZD5Bem,5)
	@ 038, 292 MSGET oZD5dbem VAR cZD5DBem Picture "@!" WHEN .F. SIZE 150,08 OF oDlgInsp PIXEL
	
	@ 055, 175 SAY OemToAnsi("Localiza��o da Maquina") OF oDlgInsp PIXEL
	@ 055, 250 SAY OemToAnsi("Pos. X") OF oDlgInsp PIXEL
	@ 053, 270 MSGET oST9posx VAR nST9PosX Picture "@!" When .F. SIZE 030,08 OF oDlgInsp PIXEL
	@ 055, 310 SAY OemToAnsi("Pos. Y") OF oDlgInsp PIXEL
	@ 053, 330 MSGET oST9posy VAR nST9PosY Picture "@!" When .F. SIZE 030,08 OF oDlgInsp PIXEL
	
	//botao1
	@ 310,005 BTNBMP oBtn01 RESOURCE "CTBREPLA" SIZE 190,24 OF oDlgInsp PIXEL ACTION fInspItm()
	oBtn01:cCaption:= PADR(OemToAnsi("&EQUIPAMENTOS/FERRAMENTAS"),32)
	oBtn01:cToolTip:= OemToAnsi("Itens do teste de estanqueidade")


/*
	oSay1 := TSay():New(70,175,{||"Fonte de Luz"},oDlgInsp,,,,,,.T.,,)
	oGet1 := tGet():New(68,250,{|u| if(Pcount() > 0, cZD5fLuz := u,cZD5fLuz)},oDlgInsp,60,8,"@!",{||fPrdInsp(cZD5fLuz,1)},;
		,,,,,.T.,,,{||nInspPar ==2 .or. nInspPar == 3},,,,,,"SB1","cZD5fLuz")
	oGet2 := tGet():New(68,312,{|u| if(Pcount() > 0, cDesfLuz := u,cDesfLuz)},oDlgInsp,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesfLuz")

	oSay2 := TSay():New(85,175,{||"Rasquete"},oDlgInsp,,,,,,.T.,,)
	oGet3 := tGet():New(83,250,{|u| if(Pcount() > 0, cZD5Rasq := u,cZD5Rasq)},oDlgInsp,60,8,"@!",{||fPrdInsp(cZD5Rasq,2)},;
		,,,,,.T.,,,{||nInspPar ==2 .or. nInspPar == 3},,,,,,"SB1","cZD5Rasq")
	oGet4 := tGet():New(83,312,{|u| if(Pcount() > 0, cDesRasq := u,cDesRasq)},oDlgInsp,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesRasq")

	oSay3 := TSay():New(100,175,{||"Vareta"},oDlgInsp,,,,,,.T.,,)
	oGet5 := tGet():New(98,250,{|u| if(Pcount() > 0, cZD5Vare := u,cZD5Vare)},oDlgInsp,60,8,"@!",{||fPrdInsp(cZD5Vare,3)},;
		,,,,,.T.,,,{||nInspPar ==2 .or. nInspPar == 3},,,,,,"SB1","cZD5Vare")
	oGet6 := tGet():New(98,312,{|u| if(Pcount() > 0, cDesVare := u,cDesVare)},oDlgInsp,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesVare")

	oSay4 := TSay():New(115,175,{||"Marcador Industrial"},oDlgInsp,,,,,,.T.,,)
	oGet7 := tGet():New(113,250,{|u| if(Pcount() > 0, cZD5MInd := u,cZD5MInd)},oDlgInsp,60,8,"@!",{||fPrdInsp(cZD5MInd,4)},;
		,,,,,.T.,,,{||nInspPar ==2 .or. nInspPar == 3},,,,,,"SB1","cZD5MInd")
	oGet8 := tGet():New(113,312,{|u| if(Pcount() > 0, cDesMInd := u,cDesMInd)},oDlgInsp,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesMInd")
*/		

	If nInspPar == 1 .OR. nInspPar == 3 .Or. nInspPar == 4 //visual ou alterar ou excluir

		cZD5Bem  := aInsp[oLbx7:nAt][2]
		ST9->(dbSetOrder(1)) //filial + codbem
		ST9->(dbSeek(xFilial("ST9")+cZD5Bem))
		cZD5dBem := ST9->T9_NOME
		nST9PosX := ST9->T9_POSX
		nST9PosY := ST9->T9_POSY
		
		obmp7:cbmpfile  := "/SYSTEM/FT/teste.jpg" //apaga do objeto o endere�o da imagem atual 
		obmp7:cbmpfile  := aInsp[oLbx7:nAt][3]    //atribui o endere�o da nova imagem
		obmp7:lautosize := .F.
		obmp7:lautosize := .T.                    //for�a o tamanho da imagem
		obmp7:lvisible  := .T.                    //for�a a visualiza��o da imagem
		
		aItmInsp := aInsp[oLbx7:nAt][4]

	EndIf

	oDlgInsp:Activate(,,,.F.,{||fEndInsp()},,bEnchoice)

Return

//���������������������������������������������Ŀ
//� ENCERRA A JANELA DE CADASTRO DE EQUIPAMENTO �
//�����������������������������������������������
Static Function fEndMaq()

	cZbHBem    := Space(15)
	cZbHdBem   := ""
	nST9PosX   := 0 
	nST9PosY   := 0 
	cZbHProg1  := Space(16)
	cZbHProg2  := Space(16)
	nZbHConsos := 0
	cZbHPresri := Space(8)
	nZbHPresAc := 0

Return .T.                           

//���������������������������������������������Ŀ
//� ENCERRA A JANELA DE CADASTRO DE DISPOSITIVO �
//�����������������������������������������������
Static Function fEndDisp()

	c1ZbGDisp  := space(15)
	c2ZbGDisp  := space(15)
	c1ZbGLetra := Space(1)
	c2ZbGLetra := Space(1)
	n1ZbGPfix  := 0
	n2ZbGPFix  := 0
	nZbGQtdPD  := 0
	
Return .T. 

//���������������������������������������������Ŀ
//� ENCERRA A JANELA DE CADASTRO DE FERRAMENTAS �
//�����������������������������������������������
Static Function fEndFer()

	cZbCNumMont := space(15)
 	obmp3_1:cbmpfile := ""
 	obmp3_2:cbmpfile := ""
 	aItmFer          := {}
 	aItmPro          := {}
 	aItmCoord        := {}
 	cZbCNumMont      := Space(15)

Return .T.                           

//������������������������������������������Ŀ
//� ENCERRA A JANELA DO CADASTRO DE LAVADORA �
//��������������������������������������������
Static Function fEndLav()

	cZD2Bem  := Space(15) //codigo do bem
	cZD2dBem := ""        //descricao do bem
	nST9PosX := 0 
	nST9PosY := 0 
	cZD2PBan := Space(25) //produto do banho
	cZD2TBan := Space(10) //temperatura do banho
	cZD2CBan := Space(10) //concentracao do banho
	nZD2TLav := 0         //tempo de lavagem (segundos)
	nZD2TSec := 0         //tempo de secagem (segundos)
	nZD2TSop := 0         //tempo de sopro (segundos)
	nZD2Pres := 0         //press�o
	nZD2PpCi := 0         //pe�as por ciclo
	obmp4:cbmpfile := ""
		
Return .T.

//���������������������������������������������������������Ŀ
//� ENCERRA A JANELA DO CADASTRO DO EQUIPAMENTO DE MONTAGEM �
//�����������������������������������������������������������
Static Function fEndMont()

	cZD3Bem  := Space(15) //codigo do bem
	nST9PosX := 0 
	nST9PosY := 0 
	cZD3dBem := ""        //descricao do bem
	cZD3PUHP := Space(10)
	aMontCom := {}
	obmp5:cbmpfile := ""
	
Return .T.

//��������������������������������������������������������Ŀ
//� ENCERRA A JANELA DO CADASTRO DO TESTE DE ESTANQUEIDADE �
//����������������������������������������������������������
Static Function fEndTest()

	cZD4Bem := Space(15) //codigo do bem
	nST9PosX := 0 
	nST9PosY := 0 
	cZD4dBem := ""        //descricao do bem
	aItmTest := {}
	aParTest := {}
	obmp6:cbmpfile := ""	

Return .T.

//������������������������������������������Ŀ
//� ENCERRA A JANELA DE CADASTRO DE INSPECAO �
//��������������������������������������������
Static Function fEndInsp()

	cZD5Bem  := Space(15) //codigo do bem
	cZD5dBem := ""        //descricao do bem
	nST9PosX := 0 
	nST9PosY := 0 
	obmp7:cbmpfile := ""	
	aItmInsp := {}
	
Return .T.

//���������������������������������Ŀ
//�GRAVA A M�QUINA NA FICHA T�CNICA �
//�����������������������������������
Static Function fGrvMaq()
Local nItem   := 1

	If nMaqPar == 2//inclui
		//se for a primeira inclus�o, apaga a primeira linha em branco
		If fAEmpty(aMaq)
			aMaq := {}
		EndIf
	
		//PEGA O PR�XIMO N�MERO DO �TEM
		For _x := 1 to Len(aMaq)
			nItem := Val(aMaq[_x][1])+1
		Next

		aAdd(aMaq,{StrZero(nItem,4),cZbHBem,cZbHdBem,nST9PosX,nST9PosY,cZbHProg1,cZbHProg2,nZbHConsos,cZbHPresri,nZbHPresAc,obmp1:cbmpfile})
		
		oLbx:Refresh(.F.)
    ElseIf nMaqPar == 3 //alterar
    
    	aMaq[oLbx:nAt][2]  := cZbHBem
    	aMaq[oLbx:nAt][3]  := cZbHdBem
    	aMaq[oLbx:nAt][4]  := nST9PosX
    	aMaq[oLbx:nAt][5]  := nST9PosY
    	aMaq[oLbx:nAt][6]  := cZbHProg1
    	aMaq[oLbx:nAt][7]  := cZbHProg2
    	aMaq[oLbx:nAt][8]  := nZbHConsos
    	aMaq[oLbx:nAt][9]  := cZbHPresri
    	aMaq[oLbx:nAt][10] := nZbHPresAc
    	aMaq[oLbx:nAt][11] := obmp1:cbmpfile
    	
	ElseIf nMaqPar == 4 //excluir
		If Len(aMaq) == 1
			aMaq := {}
			aAdd(aMaq,{"","","","","",0,0,0,"",0,""})
		Else
			aDel(aMaq,oLbx:nAt)
			_aMaq := {}
			For _x := 1 to Len(aMaq)
				If !ValType(aMaq[_x])$"U"
					aAdd(_aMaq,aMaq[_x])
				EndIf
			Next
			aMaq := aClone(_aMaq)
		EndIf
	EndIf 

	oLbx:SetArray( aMaq )
	oLbx:bLine := {|| {aMaq[oLbx:nAt,1],;  // �TEM
					   aMaq[oLbx:nAt,2],;  // M�QUINA
    	               aMaq[oLbx:nAt,3],;  // DESCRICAO
        	           aMaq[oLbx:nAt,4],;  // POS. X
            	       aMaq[oLbx:nAt,5],;  // POS. Y
                	   aMaq[oLbx:nAt,6],;  // PROG. PALLET 1
            	       aMaq[oLbx:nAt,7],;  // PROG. PALLET 2
	                   aMaq[oLbx:nAt,8],;  // CONCENTRACAO DE OLEO SOL�VEL
    	               aMaq[oLbx:nAt,9],;  // PRESSAO REFRIGERA��O INTERNA
        	           aMaq[oLbx:nAt,10]}} // PRESS�O AR COMPRIMIDO 
	
	Close(oDlgMaq)
		
Return

//��������������������������������������Ŀ
//� GRAVA O DISPOSITIVO NA FICHA TECNICA �
//����������������������������������������
Static Function fGrvDisp()
Local nItem   := 1

	If nDispPar == 2//inclui

		//se for a primeira inclus�o, apaga a primeira linha em branco
		If fAEmpty(aDisp)
			aDisp := {}
		EndIf

		//PEGA O PR�XIMO N�MERO DO �TEM
		For _x := 1 to Len(aDisp)
			nItem := Val(aDisp[_x][1])+1
		Next

		aAdd(aDisp,{StrZero(nItem,4),c1ZbGDisp,c1ZbGLetra,c2ZbGDisp,c2ZbGLetra,n1ZbGPfix,n2ZbGPFix,nZbGQtdPD,obmp2:cbmpfile})
		    
		oLbx2:Refresh(.F.)
    ElseIf nDispPar == 3 //alterar
    
    	aDisp[oLbx2:nAt][2] := c1ZbGDisp
    	aDisp[oLbx2:nAt][3] := c1ZbGLetra
    	aDisp[oLbx2:nAt][4] := c2ZbGDisp
    	aDisp[oLbx2:nAt][5] := c2ZbGLetra
    	aDisp[oLbx2:nAt][6] := n1ZbGPfix
    	aDisp[oLbx2:nAt][7] := n2ZbGPFix
    	aDisp[oLbx2:nAt][8] := nZbGQtdPD
    	aDisp[oLbx2:nAt][9] := obmp2:cbmpfile

	ElseIf nDispPar == 4 //excluir
		If Len(aDisp) == 1
			aDisp := {}
			aAdd(aDisp,{"","","","","",0,0,0,""})
		Else
			aDel(aDisp,oLbx2:nAt)
			_aDisp := {}
			For _x := 1 to Len(aDisp)
				If !ValType(aDisp[_x])$"U"
					aAdd(_aDisp,aDisp[_x])
				EndIf
			Next
			aDisp := aClone(_aDisp)
		EndIf
	EndIf 

	oLbx2:SetArray(aDisp)
	oLbx2:bLine := {|| {aDisp[oLbx2:nAt,1],;  // ITEM
						aDisp[oLbx2:nAt,2],;  // N� DISPOSITIVO PALLET 1
						aDisp[oLbx2:nAt,3],;  // LETRA 1
					    aDisp[oLbx2:nAt,4],;  // N� DISPOSITIVO PALLET 2
					    aDisp[oLbx2:nAt,5],;  // LETRA 2
	        	        aDisp[oLbx2:nAt,6],;  // PRESS�O DE FIXA��O DISPOSITIVO 1
   		        	    aDisp[oLbx2:nAt,7],;  // PRESS�O DE FIXA��O DISPOSITIVO 2
   		            	aDisp[oLbx2:nAt,8]}}  // QUANTIDADE DE PE�AS / DISPOSITIVO
	
	Close(oDlgDisp)

Return

//��������������������������Ŀ
//� GRAVA A FERRAMENTA NA FT �
//����������������������������
Static Function fGrvFer()
Local nItem   := 1

	If Empty(cZbCNumMont)
		Alert("Informe o n�mero da montagem!")
		Return
	EndIf

	If nFerPar == 2//inclui
		//se for a primeira inclus�o, apaga a primeira linha em branco
		If fAEmpty(aFer)
        	aFer := {}
  		EndIf
	
		//PEGA O PR�XIMO N�MERO DO �TEM
		For _x := 1 to Len(aFer)
			nItem := Val(aFer[_x][1])+1
		Next
		
		aAdd(aFer,{StrZero(nItem,4),cZbCNumMont,obmp3_1:cbmpfile,obmp3_2:cbmpfile,aItmFer,aItmPro,aItmCoord})
		    
		oLbx3:Refresh(.F.)
    ElseIf nFerPar == 3 //alterar
    
    	aFer[oLbx3:nAt][2] := cZbCNumMont
    	aFer[oLbx3:nAt][3] := obmp3_1:cbmpfile
    	aFer[oLbx3:nAt][4] := obmp3_2:cbmpfile
    	aFer[oLbx3:nAt][5] := aItmFer
    	aFer[oLbx3:nAt][6] := aItmPro
    	aFer[oLbx3:nAt][7] := aItmCoord
    	
	ElseIf nFerPar == 4 //excluir
		If Len(aFer) == 1
			aFer := {}
			aAdd(aFer,{"","","","",{},{},{}})
		Else
			aDel(aFer,oLbx3:nAt)
			_aFer := {}
			For _x := 1 to Len(aFer)
				If !ValType(aFer[_x])$"U"
					aAdd(_aFer,aFer[_x])
				EndIf
			Next
			aFer := aClone(_aFer)
		EndIf
	EndIf 

	oLbx3:SetArray(aFer)
	oLbx3:bLine := {|| {aFer[oLbx3:nAt,1],;  // ITEM
						aFer[oLbx3:nAt,2]}}  // NUM MONTAGEM
	
	Close(oDlgFer)

Return

//������������������������Ŀ
//� GRAVA A LAVADORA NA FT �
//��������������������������
Static Function fGrvLav()
Local nItem   := 1

	If nLavPar == 2//inclui
		//se for a primeira inclus�o, apaga a primeira linha em branco
		If fAEmpty(aLav)
        	aLav := {}
  		EndIf
	
		//PEGA O PR�XIMO N�MERO DO �TEM
		For _x := 1 to Len(aLav)
			nItem := Val(aLav[_x][1])+1
		Next
		
		aAdd(aLav,{StrZero(nItem,4),cZD2Bem,cZD2PBan,cZD2TBan,cZD2CBan,nZD2TLav,nZD2TSec,nZD2TSop,nZD2Pres,nZD2PpCi,obmp4:cbmpfile})
		    
		oLbx4:Refresh(.F.)
		
    ElseIf nLavPar == 3 //alterar
    
    	aLav[oLbx4:nAt][2]  := cZD2Bem
    	aLav[oLbx4:nAt][3]  := cZD2PBan
    	aLav[oLbx4:nAt][4]  := cZD2TBan
    	aLav[oLbx4:nAt][5]  := cZD2CBan
    	aLav[oLbx4:nAt][6]  := nZD2TLav
    	aLav[oLbx4:nAt][7]  := nZD2TSec
    	aLav[oLbx4:nAt][8]  := nZD2TSop
    	aLav[oLbx4:nAt][9]  := nZD2Pres
    	aLav[oLbx4:nAt][10] := nZD2PpCi
    	aLav[oLbx4:nAt][11] := obmp4:cbmpfile
    	
	ElseIf nLavPar == 4 //excluir
		If Len(aLav) == 1
			aLav := {}
			aAdd(aLav,{"","","","","",0,0,0,0,0,""})
		Else
			aDel(aLav,oLbx4:nAt)
			_aLav := {}
			For _x := 1 to Len(aLav)
				If !ValType(aLav[_x])$"U"
					aAdd(_aLav,aLav[_x])
				EndIf
			Next
			aLav := aClone(_aLav)
		EndIf
	EndIf 

	oLbx4:SetArray(aLav)
	oLbx4:bLine := {|| {aLav[oLbx4:nAt,1],;  // ITEM
						aLav[oLbx4:nAt,2],;  // EQUIP
						aLav[oLbx4:nAt,3],;  // PRODUTO
						aLav[oLbx4:nAt,4],;  // TEMPERATURA
						aLav[oLbx4:nAt,5],;  // CONCENTRACAO
						aLav[oLbx4:nAt,6],;  // TEMPO LAVAGEM
						aLav[oLbx4:nAt,7],;  // TEMPO SECAGEM
						aLav[oLbx4:nAt,8],;  // TEMPO DE SOPRO
						aLav[oLbx4:nAt,9],;  // PRESSAO
						aLav[oLbx4:nAt,10]}} // P�/CICLO
	
	oDlgLav:End()
Return

//������������������������������Ŀ
//� GRAVA O CADASTRO DA MONTAGEM �
//��������������������������������
Static Function fGrvMont()
Local nItem   := 1

	If nMontPar == 2//inclui
		//se for a primeira inclus�o, apaga a primeira linha em branco
		If fAEmpty(aMont)
        	aMont := {}
  		EndIf
	
		//PEGA O PR�XIMO N�MERO DO �TEM
		For _x := 1 to Len(aMont)
			nItem := Val(aMont[_x][1])+1
		Next

		aAdd(aMont,{StrZero(nItem,4),cZD3Bem,cZD3PUHP,obmp5:cbmpfile,aMontCom})
		    
		oLbx5:Refresh(.F.)
    ElseIf nMontPar == 3 //alterar
    
    	aMont[oLbx5:nAt][2] := cZD3Bem
    	aMont[oLbx5:nAt][3] := cZD3PUHP
    	aMont[oLbx5:nAt][4] := obmp5:cbmpfile
    	aMont[oLbx5:nAt][5] := aMontCom

	ElseIf nMontPar == 4 //excluir
		If Len(aMont) == 1
			aMont := {}
			aAdd(aMont,{"","","","",{}})
		Else
			aDel(aMont,oLbx5:nAt)
			_aMont := {}
			For _x := 1 to Len(aMont)
				If !ValType(aMont[_x])$"U"
					aAdd(_aMont,aMont[_x])
				EndIf
			Next
			
			aMont := aClone(_aMont)
		EndIf
	EndIf 

	oLbx5:SetArray(aMont)
	oLbx5:bLine := {|| {aMont[oLbx5:nAt,1],;  // ITEM
						aMont[oLbx5:nAt,2],;  // EQUIP
						aMont[oLbx5:nAt,3]}}  // PRESSAO DE UNIDADE HIDRAULICA PNEUMATICA
	
	oDlgMont:End()

Return

//���������������������������������������������Ŀ
//� GRAVA O CADASTRO DE TESTE DE ESTANQUEIDADE  �
//�����������������������������������������������
Static Function fGrvTest()
Local nItem   := 1

	If nTestPar == 2//inclui
		//se for a primeira inclus�o, apaga a primeira linha em branco
		If fAEmpty(aTest)
        	aTest := {}
  		EndIf
	
		//PEGA O PR�XIMO N�MERO DO �TEM
		For _x := 1 to Len(aTest)
			nItem := Val(aTest[_x][1])+1
		Next

		aAdd(aTest,{StrZero(nItem,4),cZD4Bem,obmp6:cbmpfile,aItmTest,aParTest})
		    
		oLbx6:Refresh(.F.)
    ElseIf nTestPar == 3 //alterar
    
    	aTest[oLbx6:nAt][2] := cZD4Bem
    	aTest[oLbx6:nAt][3] := obmp6:cbmpfile
    	aTest[oLbx6:nAt][4] := aItmTest
    	aTest[oLbx6:nAt][5] := aParTest
    	
	ElseIf nTestPar == 4 //excluir
		If Len(aTest) == 1
			aTest := {}
			aAdd(aTest,{"","","",{},{}})
		Else
			aDel(aTest,oLbx6:nAt)
			_aTest := {}
			For _x := 1 to Len(aTest)
				If !ValType(aTest[_x])$"U"
					aAdd(_aTest,aTest[_x])
				EndIf
			Next
			
			aTest := aClone(_aTest)
		EndIf
	EndIf 

	oLbx6:SetArray(aTest)
	oLbx6:bLine := {|| {aTest[oLbx6:nAt,1],;  // ITEM
						aTest[oLbx6:nAt,2]}}  // EQUIP
	
	oDlgTest:End()

Return

//������������������������������Ŀ
//� GRAVA O CADASTRO DE INSPE��O �
//��������������������������������
Static Function fGrvInsp()
Local nItem   := 1

	If nInspPar == 2//inclui
		//se for a primeira inclus�o, apaga a primeira linha em branco
		If fAEmpty(aInsp)
        	aInsp := {}
  		EndIf
	
		//PEGA O PR�XIMO N�MERO DO �TEM
		For _x := 1 to Len(aInsp)
			nItem := Val(aInsp[_x][1])+1
		Next

		aAdd(aInsp,{StrZero(nItem,4),cZD5Bem,obmp7:cbmpfile,aItmInsp})
		    
		oLbx7:Refresh(.F.)
		
    ElseIf nInspPar == 3 //alterar

    	aInsp[oLbx7:nAt][2] := cZD5Bem
		aInsp[oLbx7:nAt][3] := obmp7:cbmpfile
		aInsp[oLbx7:nAt][4] := aItmInsp
    	
	ElseIf nInspPar == 4 //excluir
		If Len(aInsp) == 1
			aInsp := {}
			aAdd(aInsp,{"","","",{}})
		Else
			aDel(aInsp,oLbx7:nAt)
			_aInsp := {}
			For _x := 1 to Len(aInsp)
				If !ValType(aInsp[_x])$"U"
					aAdd(_aInsp,aInsp[_x])
				EndIf
			Next
			
			aInsp := aClone(_aInsp)
		EndIf
	EndIf 

	oLbx7:SetArray(aInsp)
	oLbx7:bLine := {|| {aInsp[oLbx7:nAt,1],;  // ITEM
						aInsp[oLbx7:nAt,2]}}   // EQUIP

	oDlgInsp:End()

Return

//�����������������������������������������4�
//� COMPONENTES DO EQUIPAMENTO DE MONTAGEM �
//�����������������������������������������4�
Static Function fMontCom()

	aCols   := {}
	aHeader := {}

    aadd(aHeader,{"Item"     , "ZD6_ITEM" , PesqPict('ZD6', 'ZD6_ITEM') , 04, 00, '.F.'                     , '' , 'C', 'ZD6', ''})
    aadd(aHeader,{"C�digo"   , "ZD6_COD"  , PesqPict('ZD6', 'ZD6_COD')  , 15, 00, 'U_PCP18PRD("M->ZD6_COD")', '' , 'C', 'ZD6', ''}) 
    aadd(aHeader,{"Descri��o", "B1_DESC"  , PesqPict('SB1', 'B1_DESC')  , 50, 00, '.F.'		                , '' , 'C', 'SB1', ''}) 
    aadd(aHeader,{"Qtde"     , "ZD6_QTDE" , PesqPict('ZD6', 'ZD6_QTDE'), 05, 00, '.T.'                     , '' , 'N', 'ZD6', ''}) 
	aadd(aHeader,{"Posi��o"  , "ZD6_POS"  , PesqPict('ZD6', 'ZD6_POS')  , 02, 00, '.T.'         		    , '' , 'N', 'ZD6', ''})    

	If nPar == 1 //VISUALIZACAO
		For _x := 1 to Len(aHeader)
			aHeader[_x][6] := '.F.'
		Next
	EndIf
	
	For _x := 1 to Len(aMontCom)                                   	
		aAdd(aCols,aMontCom[_x])
	Next

	DEFINE MSDIALOG oDlgComp FROM 000,000 TO 300,650  TITLE "Componentes" PIXEL
	
	@ 005,005 TO 130, 323 MULTILINE DELETE MODIFY OBJECT oMultiline

	@ 135,238 BUTTON "&Ok"       SIZE 040,010 ACTION fGrvComp() object oBtn2
	@ 135,283 BUTTON "&Cancelar" SIZE 040,010 ACTION oDlgComp:End() object oBtn3
	
	ACTIVATE MSDIALOG oDlgComp

Return

//�����������������������������������Ŀ
//� ITENS DOS TESTES DE ESTANQUEIDADE �
//�������������������������������������
Static Function fTestItm()

	aCols   := {}
	aHeader := {}

    aadd(aHeader,{"Item"     , "ZD7_ITEM" , PesqPict('ZD7', 'ZD7_ITEM') , 04, 00, '.F.'                     , '' , 'C', 'ZD7', ''})
    aadd(aHeader,{"C�digo"   , "ZD7_COD"  , PesqPict('ZD7', 'ZD7_COD')  , 15, 00, 'U_PCP18PRD("M->ZD7_COD")', '' , 'C', 'ZD7', ''}) 
    aadd(aHeader,{"Descri��o", "B1_DESC"  , PesqPict('SB1', 'B1_DESC')  , 50, 00, '.F.'		                , '' , 'C', 'SB1', ''}) 
    aadd(aHeader,{"Qtde"     , "ZD7_QTDE" , PesqPict('ZD7', 'ZD7_QTDE') , 05, 00, '.T.'                     , '' , 'N', 'ZD7', ''}) 
	aadd(aHeader,{"Posi��o"  , "ZD7_POS"  , PesqPict('ZD7', 'ZD7_POS')  , 02, 00, '.T.'         		    , '' , 'N', 'ZD7', ''})    

	If nPar == 1 //VISUALIZACAO
		For _x := 1 to Len(aHeader)
			aHeader[_x][6] := '.F.'
		Next
	EndIf
	
	For _x := 1 to Len(aItmTest)
		aAdd(aCols,aItmTest[_x])
	Next

	DEFINE MSDIALOG oDlgItens FROM 000,000 TO 300,650  TITLE "Itens" PIXEL
	
	@ 005,005 TO 130, 323 MULTILINE DELETE MODIFY OBJECT oMultiline

	@ 135,238 BUTTON "Ok"       SIZE 040,010 ACTION fGrvItmT() object oBtn2
	@ 135,283 BUTTON "Cancelar" SIZE 040,010 ACTION oDlgItens:End() object oBtn3
	
	ACTIVATE MSDIALOG oDlgItens

Return

//��������������������������������������Ŀ
//� PARAMETROS DO TESTE DE ESTANQUEIDADE �
//����������������������������������������
Static Function fTestPar(nTesPar)
Private nTsPar   := nTesPar
Private cZD8Tipo := Space(40)
Private cZD8Medi := Space(30)
Private cZD8Prog := Space(15)
Private	aCols    := {}
Private	aHeader  := {}

    aadd(aHeader,{"Item"      , "ZD8_LETRA"  , PesqPict('ZD8', 'ZD8_LETRA')  , 01, 00, '.T.'  , '' , 'C', 'ZD8', ''})
    aadd(aHeader,{"Par�metro" , "ZD8_PARAM"  , PesqPict('ZD8', 'ZD8_PARAM')  , 20, 00, '.T.'  , '' , 'C', 'ZD8', ''})
    aadd(aHeader,{"Valor"     , "ZD8_VALOR"  , PesqPict('ZD8', 'ZD8_VALOR')  , 15, 00, '.T.'  , '' , 'C', 'ZD8', ''})

	If nTsPar==1 .OR. nTsPar==4  //VISUALIZACAO OU EXCLUSAO
		For _x := 1 to Len(aHeader)
			aHeader[_x][6] := '.F.'
		Next
	EndIf
	
	If nTsPar!=2 //incluir, alterar ou excluir
		If fAEmpty(aParTest)
			Alert("N�o h� �tens selecionados!")
			Return
		EndIf

		cZD8Tipo := aParTest[oLbxPar:nAt][2]
		cZD8Medi := aParTest[oLbxPar:nAt][3]
		cZD8Prog := aParTest[oLbxPar:nAt][4]
		
		For _x := 1 to Len(aParTest[oLbxPar:nAt][5])
			aAdd(aCols,aParTest[oLbxPar:nAt][5][_x])
		Next
	EndIf

	DEFINE MSDIALOG oDlgItem FROM 000,000 TO 500,400  TITLE "Par�metros" PIXEL
	
	oSay1 := TSay():New(10,10,{||"Tipo de Teste"},oDlgItem,,,,,,.T.,,)
	oGet1 := tGet():New(08,50,{|u| if(Pcount() > 0, cZD8Tipo := u, cZD8Tipo)},oDlgItem,130,8,"@!",,;
		,,,,,.T.,,,{||nTsPar==2 .or. nTsPar==3},,,,,,,"cZD8Tipo")

	oSay2 := TSay():New(22,10,{||"Medidor"},oDlgItem,,,,,,.T.,,)
	oGet2 := tGet():New(20,50,{|u| if(Pcount() > 0, cZD8Medi := u, cZD8Medi)},oDlgItem,100,8,"@!",,;
		,,,,,.T.,,,{||nTsPar==2 .or. nTsPar==3},,,,,,,"cZD8Medi")

	oSay3 := TSay():New(34,10,{||"Programa"},oDlgItem,,,,,,.T.,,)
	oGet3 := tGet():New(32,50,{|u| if(Pcount() > 0, cZD8Prog := u, cZD8Prog)},oDlgItem,60,8,"@!",,;
		,,,,,.T.,,,{||nTsPar==2 .or. nTsPar==3},,,,,,,"cZD8Prog")

	@ 48,005 TO 230, 198 MULTILINE DELETE MODIFY OBJECT oMultiline
	
	If nTsPar==1 .or. nTsPar==4
		oMultiline:nMax := Len(aCols) //n�o deixa o usuario adicionar mais uma linha no multiline
	EndIf

	@ 235,113 BUTTON "Ok"       SIZE 040,010 ACTION fGrvParT() object oBtn2
	@ 235,158 BUTTON "Cancelar" SIZE 040,010 ACTION oDlgItem:End() object oBtn3
	
	ACTIVATE MSDIALOG oDlgItem

Return

//������������������������������������������������Ŀ
//� ITENS DA INSPE��O (EQUIPAMENTOS / FERRAMENTAS) �
//��������������������������������������������������
Static Function fInspItm()

	aCols   := {}
	aHeader := {}

    aadd(aHeader,{"Item"     , "ZDB_ITEM" , PesqPict('ZDB', 'ZDB_ITEM') , 04, 00, '.F.'                     , '' , 'C', 'ZDB', ''})
    aadd(aHeader,{"C�digo"   , "ZDB_COD"  , PesqPict('ZDB', 'ZDB_COD')  , 15, 00, 'U_PCP18PRD("M->ZDB_COD")', '' , 'C', 'ZDB', ''}) 
    aadd(aHeader,{"Descri��o", "B1_DESC"  , PesqPict('SB1', 'B1_DESC')  , 50, 00, '.F.'		                , '' , 'C', 'SB1', ''}) 

	If nPar == 1 //VISUALIZACAO
		For _x := 1 to Len(aHeader)
			aHeader[_x][6] := '.F.'
		Next
	EndIf
	
	For _x := 1 to Len(aItmInsp)
		aAdd(aCols,aItmInsp[_x])
	Next

	DEFINE MSDIALOG oDlgItem FROM 000,000 TO 300,650  TITLE "Itens" PIXEL
	
	@ 005,005 TO 130, 323 MULTILINE DELETE MODIFY OBJECT oMultiline

	@ 135,238 BUTTON "Ok"       SIZE 040,010 ACTION fGrvItmI() object oBtn1
	@ 135,283 BUTTON "Cancelar" SIZE 040,010 ACTION oDlgItem:End() object oBtn2
	
	ACTIVATE MSDIALOG oDlgItem

Return

//���������������������������������Ŀ
//� ITENS DA MONTAGEM DA FERRAMENTA �
//�����������������������������������
Static Function fItensMontFe()

	aCols   := {}
	aHeader := {}

    aadd(aHeader,{"Item"     , "ZBC_ITEM" , PesqPict('ZBC', 'ZBC_ITEM') , 04, 00, '.F.'         , '' , 'C', 'ZBC', ''})
    aadd(aHeader,{"Qtde"     , "ZBC_QTDE" , PesqPict('ZBC', 'ZBC_QTDE') , 05, 00, '.F.'         , '' , 'N', 'ZBC', ''}) 
    aadd(aHeader,{"C�digo"   , "ZBC_COD"  , PesqPict('ZBC', 'ZBC_COD')  , 15, 00, '.F.'/*'U_PCP18PRD()'*/, '' , 'C', 'ZBC', ''}) 
    aadd(aHeader,{"Descri��o", "B1_DESC"  , PesqPict('SB1', 'B1_DESC')  , 50, 00, '.F.'		    , '' , 'C', 'SB1', ''}) 
	aadd(aHeader,{"Posi��o"  , "ZBC_POS"  , PesqPict('ZBC', 'ZBC_POS')  , 02, 00, '.F.'		    , '' , 'N', 'ZBC', ''})    
	 
	If nPar == 1
		For _x := 1 to Len(aHeader)
			aHeader[_x][6] := '.F.'
		Next
	EndIf
		
	For _x := 1 to Len(aItmFer)
		aAdd(aCols,aItmFer[_x])
	Next
	
	DEFINE MSDIALOG oDlgItens FROM 000,000 TO 300,620  TITLE "Itens da Montagem "+cZbCNumMont PIXEL
	
	@ 005,005 TO 130, 308 MULTILINE DELETE MODIFY OBJECT oMultiline 

	oMultiline:nMax := Len(aCols) //n�o deixa o usuario adicionar mais uma linha no multiline
	
//	@ 135,178 BUTTON "&Desenho"  SIZE 040,010 ACTION FEDESEN() object oBtn1
	@ 135,223 BUTTON "&Ok"       SIZE 040,010 ACTION fGrvItmF() object oBtn2
	@ 135,268 BUTTON "&Cancelar" SIZE 040,010 ACTION Close(oDlgItens) object oBtn3
	
	ACTIVATE MSDIALOG oDlgItens

Return

//�����������������������Ŀ
//� VARIAVEIS DO PROCESSO �
//�������������������������
Static Function fProcesso()

	aCols   := {}
	aHeader := {}

    aadd(aHeader,{"Item"   	     , "ZBD_ITEM"   , PesqPict('ZBD', 'ZBD_ITEM')   , 04, 00, '.F.'   , '' , 'N', 'ZBD', ''}) 
    aadd(aHeader,{"�"   	     , "ZBD_DIAMET" , PesqPict('ZBD', 'ZBD_DIAMET') , 05, 02, '.T.'   , '' , 'N', 'ZBD', ''}) 
    aadd(aHeader,{"vc"  	     , "ZBD_VC"     , PesqPict('ZBD', 'ZBD_VC')     , 05, 02, '.T.'   , '' , 'N', 'ZBD', ''}) 
    aadd(aHeader,{"n"		     , "ZBD_RPM"    , PesqPict('ZBD', 'ZBD_RPM')    , 05, 02, '.T.'	  , '' , 'N', 'ZBD', ''}) 
	aadd(aHeader,{"z"    	     , "ZBD_QDENTE" , PesqPict('ZBD', 'ZBD_QDENTE') , 05, 02, '.T.'	  , '' , 'N', 'ZBD', ''})    
	aadd(aHeader,{"fz"  	     , "ZBD_MMDENT" , PesqPict('ZBD', 'ZBD_MMDENT') , 02, 02, '.T.'	  , '' , 'N', 'ZBD', ''})    
	aadd(aHeader,{"vf"  	     , "ZBD_MMMIN"  , PesqPict('ZBD', 'ZBD_MMMIN')  , 05, 02, '.T.'	  , '' , 'N', 'ZBD', ''})    
	aadd(aHeader,{"vida util/p�" , "ZBD_VIDA"   , PesqPict('ZBD', 'ZBD_VIDA')   , 06, 00, '.T.'	  , '' , 'N', 'ZBD', ''})               

	If nPar == 1
		For _x := 1 to Len(aHeader)
			aHeader[_x][6] := '.F.'
		Next
	EndIf

	For _x := 1 to Len(aItmPro)
		aAdd(aCols,aItmPro[_x])
	Next
	
	DEFINE MSDIALOG oDlgItens FROM 000,000 TO 300,470  TITLE "Vari�veis do Processo" PIXEL
	
	@ 005,005 TO 130, 233 MULTILINE DELETE MODIFY OBJECT oMultiline 

	If(nPar == 1)//visualizar
		oMultiline:nMax := Len(aCols) //n�o deixa o usuario adicionar mais uma linha no multiline
	EndIf
	
	@ 135,103 BUTTON "&Legenda"  SIZE 040,010 ACTION fLegPro() object oBtn3
	@ 135,148 BUTTON "&Ok"       SIZE 040,010 ACTION fGrvItmP() object oBtn1
	@ 135,193 BUTTON "&Cancelar" SIZE 040,010 ACTION Close(oDlgItens) object oBtn2
	
	ACTIVATE MSDIALOG oDlgItens

Return 

//������������������������������������������Ŀ
//� MOSTRA LEGENDA DAS VARIAVEIS DO PROCESSO �
//��������������������������������������������
Static Function fLegPro()

	oDlgLeg := MsDialog():New(0,0,180,160,"Legenda",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
			
	oSay1 := tSay():New(10,05,{||"�  - Di�metro"            },oDlgLeg,,,,,,.T.,,)
	oSay1 := tSay():New(20,05,{||"vc - Velocidade de Corte" },oDlgLeg,,,,,,.T.,,)
	oSay1 := tSay():New(30,05,{||"n  - Rota��o"             },oDlgLeg,,,,,,.T.,,)
	oSay1 := tSay():New(40,05,{||"z  - N�mero de Facas"     },oDlgLeg,,,,,,.T.,,)
	oSay1 := tSay():New(50,05,{||"fz - Avan�o por Faca"     },oDlgLeg,,,,,,.T.,,)
	oSay1 := tSay():New(60,05,{||"vf - Velocidade de Avan�o"},oDlgLeg,,,,,,.T.,,)

	oBtn1 := tButton():New(75,35,"Fechar"  ,oDlgLeg,{||oDlgLeg:End()},40,10,,,,.T.)

	oDlgLeg:Activate(,,,.T.,{||.T.},,{||})


Return

//��������������������������Ŀ
//� VARIAVEIS DO COORDENADAS �
//����������������������������                 
Static Function fCoord()

	aCols   := {}
	aHeader := {}

    aadd(aHeader,{"Item"    , "ZBE_ITEM"  , "@!"                         , 04, 00, '.F.' , '' , 'N', 'ZBE', ''}) 
    aadd(aHeader,{"X"       , "ZBE_X"     , "@e 9,999.99"                , 05, 02, '.T.' , '' , 'N', 'ZBE', ''}) 
    aadd(aHeader,{"Y"       , "ZBE_Y"     , PesqPict('ZBE', 'ZBE_Y')     , 05, 02, '.T.' , '' , 'N', 'ZBE', ''}) 
    aadd(aHeader,{"Z"       , "ZBE_Z"     , PesqPict('ZBE', 'ZBE_Z')     , 05, 02, '.T.' , '' , 'N', 'ZBE', ''}) 
	aadd(aHeader,{"N. Furo" , "ZBE_NFURO" , PesqPict('ZBE', 'ZBE_NFURO') , 05, 00, '.T.' , '' , 'N', 'ZBE', ''})    
           
	If nPar == 1
		For _x := 1 to Len(aHeader)
			aHeader[_x][6] := '.F.'
		Next
	EndIf

	For _x := 1 to Len(aItmCoord)
		aAdd(aCols,aItmCoord[_x])
	Next
	
	DEFINE MSDIALOG oDlgItens FROM 000,000 TO 300,370  TITLE "Coordenadas de Usinagem" PIXEL
	
	@ 005,005 TO 130, 183 MULTILINE DELETE MODIFY OBJECT oMultiline 

	If(nPar == 1)//visualizar
		oMultiline:nMax := Len(aCols) //n�o deixa o usuario adicionar mais uma linha no multiline
	EndIf
	
	@ 135,098 BUTTON "&Ok"       SIZE 040,010 ACTION fGrvItmC() object oBtn1
	@ 135,143 BUTTON "&Cancelar" SIZE 040,010 ACTION Close(oDlgItens) object oBtn2
	
	ACTIVATE MSDIALOG oDlgItens

Return 

//����������������������Ŀ
//� VALIDA O DISPOSITIVO �
//������������������������
Static Function fValDisp(cDisp,nDisp)
	
	ZBN->(dbSetOrder(1))// FILIAL + DISP + LETRA
	ZBN->(dbSeek(xFilial("ZBN")+cDisp))
	If ZBN->(!Found())
		If !Empty(cDisp)
			Alert("Dispositivo n�o encontrado!")
			Return .F.
		Else
			If nDisp==1
				c1ZbGLetra := Space(1)
			 	o1ZbGLetra:Refresh()
				n1ZbGPfix := 0
			 	oGet5:Refresh()
		 	ElseIf nDisp==2
				c2ZbGLetra := Space(1)
			 	o2ZbGLetra:Refresh()
				n2ZbGPfix := 0
			 	oGet6:Refresh()
		 	EndIf
		EndIf
	EndIf
		
Return .T.

//����������������������������������
//� VERIFICA SE O ARRAY EST� VAZIO �
//����������������������������������
Static Function fAEmpty(aArray)
	For _x := 1 to Len(aArray)
		If !Empty(aArray[1][_x])
			Return .F. //array n�o vazio
		EndIf
	Next
Return .T. //array vazio

//��������������������������������������������������������������Ŀ
//� ATUALIZA OS DADOS DA MONTAGEM A PARTIR DO NUMERO DA MONTAGEM �
//����������������������������������������������������������������
Static Function fAtuMont()

	If Empty(cCC)
		Alert("O campo do Centro de Custo no cabe�alho da FT n�o pode estar vazio!")
		Return .F.
	EndIf
	
	If !Empty(cZbCNumMont) .and. cCC != cZbCNumMont
		Alert("N�mero da montagem n�o cont�m o Centro de Custo da FT!")
		Return .F.
	EndIf
	
	ZBF->(DbSetOrder(1)) //FILIAL + NUMFT + REV + ITEM
	IF ZBF->(DbSeek(xFilial("ZBF")+cZb5NumFt+cZb5Rev))
		WHILE ZBF->(!EOF()) .AND. ZBF->ZBF_NUM == cZb5NumFt .AND. ZBF->ZBF_REV == cZb5Rev
			
			If ZBF->ZBF_NUMONT == cZbCNumMont
				Alert("Numero da montagem j� existe para esta FT!")
				Return .F.                   
			EndIf
			
			ZBF->(DbSkip())
	    ENDDO
	EndIf

	aItmFer := {}
	
	ZBC->(DbSetOrder(1)) //filial + numont + item
	If ZBC->(DbSeek(xFilial("ZBC")+cZbCNumMont))
		While ZBC->(!Eof()) .AND. ZBC->ZBC_NUMONT == cZbCNumMont
		    SB1->(DBSEEK(XFILIAL("SB1")+ZBC->ZBC_COD))

			aAdd(aItmFer,{ZBC->ZBC_ITEM,;
			              ZBC->ZBC_QTDE,;
		    			  ZBC->ZBC_COD,;
	    				  SB1->B1_DESC,;
	    				  ZBC->ZBC_POS,;
	    				  .F.})
				
	        ZBC->(DbSkip())
		EndDo
	EndIf
	
	ZBJ->(DbSetOrder(1)) // FILIAL + NUMONT
	ZBJ->(dbSeek(xFilial("ZBJ")+cZbCNumMont))
	
	If ZBJ->(!Found())
		Alert("N�mero da montagem n�o encontrado!")
		Return .F.
	EndIf
	
	obmp3_1:cbmpfile  := "/SYSTEM/FT/teste.jpg" //apaga do objeto o endere�o da imagem atual 
	obmp3_1:cbmpfile  := cStartPath + ZBJ->ZBJ_IMG01 //cStartPath + aFer[oLbx3:nAt][3]     //atribui o endere�o da nova imagem
	obmp3_1:lautosize := .F.
	obmp3_1:lautosize := .T.      			  //for�a o tamanho da imagem
	obmp3_1:lvisible  := .T.      			  //for�a a visualiza��o da imagem
	
	//atualiza o titulo da janela
	oDlgFer:cCaption := cZbCNumMont
	oDlgFer:cTitle   := cZbCNumMont

Return

//���������������������������������������Ŀ
//� ABRE O DOCUMENTO DO PLANO DE CONTROLE �
//�����������������������������������������
Static Function fPlanCont()

Local cMvSave   := "CELEWIN400"  
Local lView     := GetMv( "MV_QDVIEW" ) 
Local cPView    := Alltrim( GetMv( "MV_QDPVIEW" ) )
Local lAchou    := .F.
Local aQPath    := QDOPATH()
Local cQPath    := aQPath[1]
Local cQPathTrm := aQPath[3]
Local cTexto

QDH->(DbSetOrder(1)) // Ultima revisao
QDH->(DbSeek(xFilial("QDH")+cPlCont)) //  + ZA7->ZA7_FERRV))	        
While QDH->QDH_DOCTO == cPlCont
	lAchou := .T.
	QDH->(DbSkip())
Enddo

If lAchou

	QDH->(DbSkip(-1))	
	
    cTexto := Alltrim(QDH->QDH_NOMDOC)
	
	If !File(cQPathTrm+cTexto)
		CpyS2T(cQPath+cTexto,cQPathTrm,.T.)
	EndIf
	
	If UPPER(Right(Alltrim(cTexto),4))$".CEL"

		fRename(cQPathTrm+cTexto,cQPathTrm+StrTran(UPPER(cTexto),".CEL",".DOC"))

		cTexto := StrTran(UPPER(cTexto),".CEL",".DOC")
		
		oWordTmp := OLE_CreateLink("TMsOleWord97")
		OLE_SetProperty( oWordTmp, oleWdVisible,   .T. )
		OLE_SetProperty( oWordTmp, oleWdPrintBack, .F. )
		OLE_OpenFile( oWordTmp, ( cQPathTrm + Alltrim(cTexto) ),.F., cMvSave, cMvSave )

		Aviso("", "Alterne para o programa do Ms-Word para visualizar o documento ou clique no botao para fechar.", {"Fechar"})

		OLE_CloseLink( oWordTmp )
	ELSE			
		QA_OPENARQ(cQPathTrm+cTexto)
	ENDIF

Else
	MsgBox("Documento nao encontrado!","Cadastro de documento","STOP")
Endif

Return

//�������������������������������������Ŀ
//� VALIDA O CAMPO DO PLANO DE CONTROLE �
//���������������������������������������
Static Function fValPlCont()

	QDH->(DBSETORDER(1))
	IF !QDH->(DBSEEK(XFILIAL("QDH")+cPlCont)) .and. !Empty(cPlCont)
	    Alert("Documento n�o encontrado!")
	    Return .F.
	EndIf

Return .T.



//����������������������������������������������������Ŀ
//� INICIALIZA O CAMPO ITEM DA TABELA ZBD E ZBE NO SX3 �
//������������������������������������������������������
User Function FTItmIni(cTab)
Local nItem1 := 0
Local nItem2 := 0

	If cTab == "ZBD"
		ZBD->(DbSetOrder(1))
		If ZBD->(DbSeek(xfilial("ZBD")+cZb5NumFt+cZb5Rev+cZbCNumMont))
			WHILE ZBD->(!EOF()) .AND. ZBD->ZBD_NUM == cZb5NumFt .AND. ZBD->ZBD_NUMONT == cZbCNumMont .AND. ZBD->ZBD_REV == cZb5Rev
				nItem1 := VAL(ZBD->ZBD_ITEM)
				ZBD->(DBSKIP())
			ENDDO
		EndIf
	ElseIf cTab == "ZBE"
		ZBE->(DbSetOrder(1))
		If ZBE->(DbSeek(xfilial("ZBE")+cZb5NumFt+cZb5Rev+cZbCNumMont))
			WHILE ZBE->(!EOF()) .AND. ZBE->ZBE_NUM == cZb5NumFt .AND. ZBE->ZBE_NUMONT == cZbCNumMont .AND. ZBE->ZBE_REV == cZb5Rev
				nItem1 := VAL(ZBE->ZBE_ITEM)
				ZBE->(DBSKIP())
			ENDDO
		EndIf
	EndIf	

    If Len(aCols)==1 .AND. aCols[1][1]==1
		nItem2 := 0
	Else
		For _x:=1 to Len(aCols)-1
			nItem2 := VAL(aCols[_x][1])
		Next
	EndIf

	nItem2++

	nItem := Iif(nItem2 > nItem1,nItem2,nItem1)

Return StrZero(nItem,4)

//�����������������������������Ŀ
//� TRAZ A DESCRICAO DO PRODUTO �
//�������������������������������
User Function PCP18PRD(cField)
Local nPosDes := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="B1_DESC" })

	DBSELECTAREA("SB1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SB1")+&(cField))
		aCols[n][nPosDes] := SB1->B1_DESC
		oMultiline:Refresh()
	ELSE
		ALERT("Produto n�o encontrado")
		Return .F.
	ENDIF

Return .T.

//����������������������������������������Ŀ
//� GRAVA ITENS DA MONTAGEM DE FERRAMENTAS �
//������������������������������������������
Static Function fGrvItmF()

	If nPar != 1
		aItmFer := {}
		For _x := 1 to Len(aCols)
			aAdd(aItmFer,aCols[_x])
		Next
	EndIf

	Close(oDlgItens)
Return

//�������������������������4�
//� GRAVA ITENS DA PROCESSO �                                             
//�������������������������4�
Static Function fGrvItmP()
	        
	If nPar != 1
		aItmPro := {}
		For _x := 1 to Len(aCols)
			aAdd(aItmPro,aCols[_x])
		Next
	EndIf

	Close(oDlgItens)
Return

//������������������������������������������Ŀ
//� GRAVA OS ITENS DA COORDENADA DE USINAGEM �
//��������������������������������������������
Static Function fGrvItmC()

	If nPar != 1
		aItmCoord := {}
		For _x := 1 to Len(aCols)
			aAdd(aItmCoord,aCols[_x])
		Next
	EndIf

	Close(oDlgItens)
Return

//�������������������������������������������������Ŀ
//� GRAVA OS COMPONENTES DO EQUIPAMENTO DE MONTAGEM �
//���������������������������������������������������
Static Function fGrvComp()

	If nPar != 1
		aMontCom := {}
		For _x := 1 to Len(aCols)
			aAdd(aMontCom,aCols[_x])
		Next
	EndIf

	Close(oDlgComp)

Return

//�������������������������������������������������Ŀ
//� GRAVA OS COMPONENTES DO EQUIPAMENTO DE MONTAGEM �
//���������������������������������������������������
Static Function fGrvItmT()

	If nPar != 1
		aItmTest := {}
		For _x := 1 to Len(aCols)
			aAdd(aItmTest,aCols[_x])
		Next
	EndIf

	Close(oDlgItens)

Return

//������������������������������������������Ŀ
//� GRAVA OS ITENS DO TESTE DE ESTANQUEIDADE �
//��������������������������������������������
Static Function fGrvParT()
Local nItem   := 1
	
	If nTsPar==2//inclui
		//se for a primeira inclus�o, apaga a primeira linha em branco
		If fAEmpty(aParTest)
        	aParTest := {}
  		EndIf

		//PEGA O PR�XIMO N�MERO DO �TEM
		For _x := 1 to Len(aParTest)
			nItem := Val(aParTest[_x][1])+1
		Next
	
		aAdd(aParTest,{StrZero(nItem,4),cZD8Tipo,cZD8Medi,cZD8Prog,aCols})
		    
		oLbxPar:Refresh(.F.)
    ElseIf nTsPar == 3 //alterar
    
    	aParTest[oLbxPar:nAt][2] := cZD8Tipo
    	aParTest[oLbxPar:nAt][3] := cZD8Medi
    	aParTest[oLbxPar:nAt][4] := cZD8Prog
    	aParTest[oLbxPar:nAt][5] := aCols
    	
	ElseIf nTsPar == 4 //excluir
		If Len(aParTest) == 1
			aParTest := {}
			aAdd(aParTest,{"","","","",{}})
		Else
			aDel(aParTest,oLbx5:nAt)
			_aParTest := {}
			For _x := 1 to Len(aParTest)
				If !ValType(aParTest[_x])$"U"
					aAdd(_aParTest,aParTest[_x])
				EndIf
			Next
			
			aParTest := aClone(_aParTest)
		EndIf
	EndIf 

	oLbxPar:SetArray(aParTest)
	oLbxPar:bLine := {|| {aParTest[oLbxPar:nAt][1],;
						  aParTest[oLbxPar:nAt][2],;
				    	  aParTest[oLbxPar:nAt][3],;
    					  aParTest[oLbxPar:nAt][4]}}
	
	Close(oDlgItem)

Return

//����������������������������Ŀ
//� GRAVA OS ITENS DA INSPE��O �
//������������������������������
Static Function fGrvItmI()

	If nPar != 1
		aItmInsp := {}
		For _x := 1 to Len(aCols)
			aAdd(aItmInsp,aCols[_x])
		Next
	EndIf

	Close(oDlgItem)

Return

//�������������������������������������������������Ŀ
//� BLOQUEIA AS ABAS DA FT DEPENDENDO DO TIPO DA FT �
//���������������������������������������������������
Static Function fBloqAba()

	oFolder:aDialogs[1]:BWhen := Iif(Substr(cZB5Tipo,1,1)=="1",{||.T.},{||.F.})
	oFolder:aDialogs[2]:BWhen := Iif(Substr(cZB5Tipo,1,1)=="1",{||.T.},{||.F.})
	oFolder:aDialogs[3]:BWhen := Iif(Substr(cZB5Tipo,1,1)=="1",{||.T.},{||.F.})
	oFolder:aDialogs[4]:BWhen := Iif(Substr(cZB5Tipo,1,1)=="2",{||.T.},{||.F.})//LAVADORA
	oFolder:aDialogs[5]:BWhen := Iif(Substr(cZB5Tipo,1,1)=="3",{||.T.},{||.F.})//MONTAGEM
	oFolder:aDialogs[6]:BWhen := Iif(Substr(cZB5Tipo,1,1)=="4",{||.T.},{||.F.})//TESTES
	oFolder:aDialogs[7]:BWhen := Iif(Substr(cZB5Tipo,1,1)=="5",{||.T.},{||.F.})//INSPECAO

	If Substr(cZB5Tipo,1,1)=="1"
   		oFolder:nOption := 1
    ElseIf Substr(cZB5Tipo,1,1)=="2"
    	oFolder:nOption := 4
	ElseIf Substr(cZB5Tipo,1,1)=="3"
		oFolder:nOption := 5
    ElseIf Substr(cZB5Tipo,1,1)=="4"
    	oFolder:nOption := 6
	ElseIf Substr(cZB5Tipo,1,1)=="5"
		oFolder:nOption := 7
	EndIf
	
Return

//���������������������������������������������������Ŀ
//� TRAZ A DESCRICAO DO PRODUTO NA ROTINA DE INSPECAO �
//�����������������������������������������������������
Static Function fPrdInsp(cProd,nNum)

	SB1->(dbSetOrder(1)) // FILIAL + COD
	SB1->(dbSeek(xFilial("SB1")+cProd))
	If SB1->(Found())
		If nNum==1
			cDesfLuz := SB1->B1_DESC
			oGet2:Refresh()
		ElseIf nNum==2
		    cDesRasq := SB1->B1_DESC
		    oGet4:Refresh()
		ElseIf nNum==3
			cDesVare := SB1->B1_DESC
			oGet6:Refresh()
		ElseIf nNum==4
			cDesMInd := SB1->B1_DESC
			oGet8:Refresh()
		EndIf
	Else
		If !Empty(cProd)
			Alert("Produto n�o encontrado!")
			Return .F.
		EndIf
	EndIf

Return .T.

//�����������������������Ŀ
//� REDIMENSIONA A IMAGEM �
//�������������������������
Static Function fAjustImg(objimg,objscroll)
	If objimg:lautosize 
		objimg:lautosize := .F.
		objimg:nWidth    := 300
		objimg:nHeight   := 210
		objimg:lstretch  := .T.
		objscroll:nstyle := 0
	Else
		objimg:lstretch  := .f.
		objimg:nWidth    := 0
		objimg:nHeight   := 0
		objimg:lautosize := .t.
		objscroll:nstyle := 7
	EndIf
Return 

//������������������������������������Ŀ
//� TELA PARA BUSCAR A IMAGEM          �
//� parametro: oImg = objeto da imagem �
//��������������������������������������
Static Function fAltImg(oImg)
Local cBMP 
Local cArq01 := ""
Local cTipo  := ""

	cTipo := "Arquivos tipo     (*.JPG)  | *.JPG | "
	cTipo += "Desenhos          (*.BMP)  | *.BMP | "
	cTipo += "Desenhos          (*.GIF)  | *.GIF   "
	    
	cArq01 := cGetFile(cTipo,,0,,.T.,49)

	//valida o formato do arquivo
	If !Empty(cArq01) .AND. !UPPER(Right(cArq01,4))$".JPG/.BMP/.GIF" 
		Alert("Formato do arquivo inv�lido!"+_CRLF+;
			  "Por favor, escolha um arquivo de imagem do tipo jpg, gif ou bmp")
		Return
	EndIf
	 
	oImg:cbmpfile  := "/SYSTEM/FT/teste.jpg" //apaga do objeto o endere�o da imagem atual 
	oImg:cbmpfile  := cArq01  //atribui o endere�o da nova imagem
	oImg:lautosize := .F.
	oImg:lautosize := .T.      //for�a o tamanho da imagem
	oImg:lvisible  := .T.      //for�a a visualiza��o da imagem

Return

//����������������������Ŀ
//� GRAVA OS DADOS DA FT �
//������������������������
Static Function fGravaFT()
Local cImgTmp := ""	
Local lRev    := .F.
Local cResRev := ""
Local cMotRev := ""
	
	If nPar==3 //Alterar
		ZB5->(DbSetOrder(1)) //Filial + Num + Revisao
		ZB5->(DbSeek(xFilial("ZB5")+cZb5NumFt+cZb5Rev))
		
		If ZB5->ZB5_STATUS=="A"
			If !(MsgYesNo("Esta altera��o ir� gerar uma nova revis�o. Esta revis�o ficar� pendente. Deseja continuar?"))
				Return
			EndIf
	                  
			oDlgRev  := MsDialog():New(0,0,210,400,"Ficha T�cnica",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
		
			oSay1 := TSay():New(10,10,{||"Motivo Revis�o"},oDlgRev,,,,,,.T.,CLR_HBLUE,)
			
			oMemo1 := tMultiget():New(22,10,{|u|if(Pcount()>0,cMotRev:=u,cMotRev)},;
				oDlgRev,183,60,,,,,,.T.,,,{||.T.})
			
			oBtn1 := tButton():New(88,153,"Ok"      ,oDlgRev,{||oDlgRev:End()},40,10,,,,.T.)
		
			oDlgRev:Activate(,,,.T.,{||fValRev(cMotRev)},,{||})
					
			lRev := .T.
			nPar := 2 //muda para inclus�o para inserir uma nova revis�o
			
		EndIf
	EndIf	
	
	/*********
	* INCLUI *
	*********/
	If nPar == 2

		If !fValidaFT()
			Return
		EndIf

		cZb5Rev := "000"		

		If lRev
			//ATUALIZA A REVISAO
			ZB5->(DBSETORDER(1)) //FILIAL + NUM + REV
			IF ZB5->(DBSEEK(XFILIAL("ZB5")+cZb5NumFt))
				WHILE ZB5->(!EOF()) .AND. ZB5->ZB5_NUM == cZb5NumFt
	
				    cZb5Rev  := StrZero(Val(ZB5->ZB5_REV)+1,3) //Pega o pr�ximo n�mero da revis�o
					dZB5DtElab   := ZB5->ZB5_DTELAB
				    cZb5Elab := ZB5->ZB5_ELABOR
				    cResRev   := Alltrim(UPPER(cUserName))
				    
				    RecLock("ZB5",.F.)
				    	ZB5->ZB5_ULTREV := 'N'//Marca que n�o � mais a �ltima revis�o
				    	ZB5->ZB5_STATUS := 'O'
				    MsUnLock("ZB5")
	
					ZB5->(DBSKIP())
	
				EndDo
			EndIf
		EndIf


		Begin Transaction
		
		//��������������������Ŀ
		//� INCLUI O CABECALHO �
		//����������������������
		RecLock("ZB5",.T.)
			ZB5->ZB5_FILIAL := XFILIAL("ZB5")
			ZB5->ZB5_PECA   := cZb5Peca
			ZB5->ZB5_OP     := cZb5Op
			ZB5->ZB5_NUM    := cZb5NumFt
			ZB5->ZB5_REV    := cZb5Rev
			ZB5->ZB5_TCICLO := cZb5Tciclo
			ZB5->ZB5_OPDESC := cZb5OpDesc
			ZB5->ZB5_ELABOR := cZb5Elab
			ZB5->ZB5_DTELAB := dZb5DtElab
			ZB5->ZB5_APROVA := ""
			ZB5->ZB5_DTAPRV := CTOD("  /  /  ")
			ZB5->ZB5_STATUS := "P"
			ZB5->ZB5_MOTREV := cMotRev
			ZB5->ZB5_DTREV  := Date()
			ZB5->ZB5_RESREV := cResRev
			ZB5->ZB5_ULTREV := "S"
			ZB5->ZB5_PC     := cPlCont
			ZB5->ZB5_CC     := cCC
			ZB5->ZB5_TIPO   := cZB5Tipo
	    MsUnLock("ZB5")
	    
		//������������������������Ŀ
		//� INCLUI OS EQUIPAMENTOS �
		//��������������������������
	    For _x := 1 to Len(aMaq)

	    	//copia a imagem da m�quina
			cImgTmp := STRTRAN(cZb5NumFt,"/","_")+ "maq" +aMaq[_x][1]+Right(AllTrim(aMaq[_x][11]),4)

			If !empty(aMaq[_x][11]) .and. !(cStartPath+cImgTmp$aMaq[_x][11])
				If __CopyFile(aMaq[_x][11],cStartPath+cImgTmp)
					aMaq[_x][11] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem do Equipamento "+aMaq[_x][1]+"!")
					aMaq[_x][11] := ""
				EndIf
			Else
				aMaq[_x][11] := STRTRAN(aMaq[_x][11],cStartPath,"")	
			EndIf
					
			RecLock("ZBH",.T.)
				ZBH->ZBH_FILIAL := xFilial("ZBH")
				ZBH->ZBH_NUM    := cZb5NumFt  
				ZBH->ZBH_REV    := cZb5Rev
				ZBH->ZBH_ITEM   := aMaq[_x][1]
				ZBH->ZBH_BEM    := aMaq[_x][2]
				ZBH->ZBH_PROGP1 := aMaq[_x][6]
				ZBH->ZBH_PROGP2 := aMaq[_x][7]
				ZBH->ZBH_CONSOS := aMaq[_x][8]
				ZBH->ZBH_PRESRI := aMaq[_x][9]
				ZBH->ZBH_PRESAC := aMaq[_x][10]
				ZBH->ZBH_IMG01  := aMaq[_x][11]
			MsUnLock("ZBH")
	    Next
	    
		//������������������������Ŀ
		//� INCLUI OS DISPOSITIVOS �
		//��������������������������
	    For _x := 1 to Len(aDisp)
	    
			//copia a imagem do dispositivo
			cImgTmp := STRTRAN(cZb5NumFt,"/","_")+"dis"+aDisp[_x][1]+Right(AllTrim(aDisp[_x][9]),4)
			
			If !empty(aDisp[_x][9]) .AND. !(cStartPath+cImgTmp$aDisp[_x][9])
				If __CopyFile(aDisp[_x][9],cStartPath + cImgTmp)
					aDisp[_x][9] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem do Dispositivo "+aDisp[_x][1]+"!")
					aDisp[_x][9] := ""
				EndIf
			Else
				aDisp[_x][9] := STRTRAN(aDisp[_x][9],cStartPath,"")
			EndIf
				 
	    	RecLock("ZBG",.T.)
	    		ZBG->ZBG_FILIAL := xFilial("ZBG")
	    		ZBG->ZBG_NUM    := cZb5NumFt
	    		ZBG->ZBG_REV    := cZb5Rev
	    		ZBG->ZBG_ITEM   := aDisp[_x][1]
	    		ZBG->ZBG_NDISP1 := aDisp[_x][2]
	    		ZBG->ZBG_LETRA1 := aDisp[_x][3]
	    		ZBG->ZBG_NDISP2 := aDisp[_x][4]
	    		ZBG->ZBG_LETRA2 := aDisp[_x][5]
	    		ZBG->ZBG_PFIXD1 := aDisp[_x][6]
	    		ZBG->ZBG_PFIXD2 := aDisp[_x][7]
	    		ZBG->ZBG_QTDPCD := aDisp[_x][8]
	    		ZBG->ZBG_IMG01  := aDisp[_x][9]
	    	MsUnLock("ZBG")
	    Next

		//������������������������������������Ŀ
		//� INCLUI AS MONTAGENS DE FERRAMENTAS �
		//��������������������������������������
	    For _x := 1 to Len(aFer)
    		
			cImgTmp := STRTRAN(cZb5NumFt,"/","_")+"fe2"+aFer[_x][1]+Right(AllTrim(aFer[_x][4]),4)

			If !Empty(aFer[_x][4]) .AND. !(cStartPath+cImgTmp$aFer[_x][4])
				If __CopyFile(aFer[_x][4],cStartPath + cImgTmp)
					aFer[_x][4] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem 2 da Ferramenta "+aFer[_x][1]+"!")
					aFer[_x][4] := ""
				EndIf
			Else
				aFer[_x][4] := STRTRAN(aFer[_x][4],cStartPath,"")
			EndIf
			
			//ZBF-MONTAGEM DE FERRAMENTAS
    	    RecLock("ZBF",.T.)
    	    	ZBF->ZBF_FILIAL := xFilial("ZBF")
   		    	ZBF->ZBF_NUM    := cZb5NumFt
   		    	ZBF->ZBF_REV    := cZb5Rev
   		    	ZBF->ZBF_ITEM   := aFer[_x][1]
   	    		ZBF->ZBF_NUMONT := aFer[_x][2]
    	    	ZBF->ZBF_IMG02  := aFer[_x][4]
   		    MsUnLock("ZBF")

	    	//Grava as vari�veis do processo
	    	For _j := 1 to Len(aFer[_x][6])
				If !(aFer[_x][6][_j][len(aFer[_x][6][_j])])//nao pega se estiver deletado
		    		RecLock("ZBD",.T.)
						ZBD->ZBD_FILIAL := xFilial("ZBD")
						ZBD->ZBD_NUM    := cZb5NumFt
						ZBD->ZBD_REV    := cZb5Rev
						ZBD->ZBD_NUMONT := aFer[_x][2]
						ZBD->ZBD_ITEM   := aFer[_x][6][_j][1]
						ZBD->ZBD_DIAMET	:= aFer[_x][6][_j][2]
						ZBD->ZBD_VC     := aFer[_x][6][_j][3]
						ZBD->ZBD_RPM    := aFer[_x][6][_j][4]
						ZBD->ZBD_QDENTE := aFer[_x][6][_j][5]
						ZBD->ZBD_MMDENT := aFer[_x][6][_j][6]
						ZBD->ZBD_MMMIN  := aFer[_x][6][_j][7]
						ZBD->ZBD_VIDA   := aFer[_x][6][_j][8]
		    		MsUnLock("ZBD")
		    	EndIf
	    	Next

			//grava os itens das coordenadas de usinagem
			For _j := 1 to Len(aFer[_x][7])
				If !(aFer[_x][7][_j][len(aFer[_x][7][_j])])//nao pega se estiver deletado
					RecLock("ZBE",.T.)
						ZBE->ZBE_FILIAL := XFILIAL("ZBE")
						ZBE->ZBE_NUM    := cZb5NumFt
						ZBE->ZBE_REV    := cZb5Rev
						ZBE->ZBE_NUMONT := aFer[_x][2]
						ZBE->ZBE_ITEM   := aFer[_x][7][_j][1]
						ZBE->ZBE_X      := aFer[_x][7][_j][2]
						ZBE->ZBE_Y      := aFer[_x][7][_j][3]
						ZBE->ZBE_Z      := aFer[_x][7][_j][4]
						ZBE->ZBE_NFURO  := aFer[_x][7][_j][5]
					MsUnLock("ZBE")		
				EndIf
			Next 
    	Next 
    	
		//���������������������Ŀ
		//� INCLUI AS LAVADORAS �
		//�����������������������
		For _x:=1 to Len(aLav)
	    	//copia a imagem da lavadora
			cImgTmp := STRTRAN(Alltrim(cZb5NumFt),"/","_")+ "lav" +aLav[_x][1]+Right(AllTrim(aLav[_x][11]),4)

			If !empty(aLav[_x][11]) .and. !(cStartPath+cImgTmp$aLav[_x][11])
				If __CopyFile(aLav[_x][11],cStartPath+cImgTmp)
					aLav[_x][11] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem da Lavadora "+aLav[_x][1]+"!")
					aLav[_x][11] := ""
				EndIf
			Else
				aLav[_x][11] := STRTRAN(aLav[_x][11],cStartPath,"")	
			EndIf

			RecLock("ZD2",.T.)
				ZD2->ZD2_FILIAL := xFilial("ZD2")
				ZD2->ZD2_NUM    := cZb5NumFt
				ZD2->ZD2_REV    := cZb5Rev
				ZD2->ZD2_ITEM   := aLav[_x][1]
				ZD2->ZD2_BEM    := aLav[_x][2]
				ZD2->ZD2_PRDBAN := aLav[_x][3]
				ZD2->ZD2_TEMBAN := aLav[_x][4]
				ZD2->ZD2_CONBAN := aLav[_x][5]
				ZD2->ZD2_TLAVAG := aLav[_x][6]
				ZD2->ZD2_TSECAG := aLav[_x][7]
				ZD2->ZD2_TSOPRO := aLav[_x][8]
				ZD2->ZD2_PRESSA := aLav[_x][9]
				ZD2->ZD2_PCCICL := aLav[_x][10]
				ZD2->ZD2_IMG01  := aLav[_x][11]
			MsUnLock("ZD2")
		
		Next
		
		//�����������������������������������������������Ŀ
		//� INCLUI OS EQUIPAMENTOS DE MONTAGEM / MONTAGEM �
		//�������������������������������������������������
        For _x:=1 to Len(aMont)
	    	//copia a imagem do equipamento de montagem
			cImgTmp := STRTRAN(Alltrim(cZb5NumFt),"/","_")+ "mon" +aMont[_x][1]+Right(AllTrim(aMont[_x][4]),4)

			If !empty(aMont[_x][4]) .and. !(cStartPath+cImgTmp$aMont[_x][4])
				If __CopyFile(aMont[_x][4],cStartPath+cImgTmp)
					aMont[_x][4] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem da Montgem "+aMont[_x][1]+"!")
					aMont[_x][4] := ""
				EndIf
			Else
				aMont[_x][4] := STRTRAN(aMont[_x][4],cStartPath,"")	
			EndIf

			RecLock("ZD3",.T.)
				ZD3->ZD3_FILIAL := xFilial("ZD3")
				ZD3->ZD3_NUM    := cZb5NumFt
				ZD3->ZD3_REV    := cZb5Rev
				ZD3->ZD3_ITEM   := aMont[_x][1]
				ZD3->ZD3_BEM    := aMont[_x][2]
				ZD3->ZD3_PUHD   := aMont[_x][3]
				ZD3->ZD3_IMG01  := aMont[_x][4]
			MsUnLock("ZD2")
			
	    	//Grava os componentes do equipamento de montagem
	    	For _j := 1 to Len(aMont[_x][5])
				If !(aMont[_x][5][_j][len(aMont[_x][5][_j])])//nao pega se estiver deletado
		    		RecLock("ZD6",.T.)
						ZD6->ZD6_FILIAL := xFilial("ZD6")
						ZD6->ZD6_NUM    := cZb5NumFt
						ZD6->ZD6_REV    := cZb5Rev
						ZD6->ZD6_ITEMFT := aMont[_x][1]
						ZD6->ZD6_ITEM   := aMont[_x][5][_j][1]
						ZD6->ZD6_COD	:= aMont[_x][5][_j][2]
						ZD6->ZD6_QTDE   := aMont[_x][5][_j][4]
						ZD6->ZD6_POS    := aMont[_x][5][_j][5]
		    		MsUnLock("ZD6")
		    	EndIf
	    	Next
        Next
        
		//�����������������������������������Ŀ
		//� INCLUI OS TESTES DE ESTANQUEIDADE �
		//�������������������������������������
		For _x:=1 to Len(aTest)

	    	//copia a imagem do equipamento de montagem
			cImgTmp := STRTRAN(Alltrim(cZb5NumFt),"/","_")+ "tes" +aTest[_x][1]+Right(AllTrim(aTest[_x][3]),4)

			If !empty(aTest[_x][3]) .and. !(cStartPath+cImgTmp$aTest[_x][3])
				If __CopyFile(aTest[_x][3],cStartPath+cImgTmp)
					aTest[_x][3] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem do Teste "+aTest[_x][1]+"!")
					aTest[_x][3] := ""
				EndIf
			Else
				aTest[_x][3] := STRTRAN(aTest[_x][3],cStartPath,"")	
			EndIf

			RecLock("ZD4",.T.)
				ZD4->ZD4_FILIAL := xFilial("ZD4")
				ZD4->ZD4_NUM    := cZb5NumFt
				ZD4->ZD4_REV    := cZb5Rev
				ZD4->ZD4_ITEM   := aTest[_x][1]
				ZD4->ZD4_BEM    := aTest[_x][2]
				ZD4->ZD4_IMG01  := aTest[_x][3]
			MsUnLock("ZD4")
			
			//Grava os itens dos testes de estanqueidade
			//Percorre o array aItmTest que � o aTest[_x][4]
			aItmTest := aTest[_x][4]
			For _j:=1 to Len(aItmTest)
				If !aItmTest[_j][len(aItmTest[_j])] //nao pega quando estiver deletado
					RecLock("ZD7",.T.)
						ZD7->ZD7_FILIAL := xFilial("ZD7")
						ZD7->ZD7_NUM    := cZb5NumFt
						ZD7->ZD7_REV    := cZb5Rev
						ZD7->ZD7_ITEMFT := aTest[_x][1]
						ZD7->ZD7_ITEM   := aItmTest[_j][1]
						ZD7->ZD7_COD    := aItmTest[_j][2]
						ZD7->ZD7_QTDE   := aItmTest[_j][4]
						ZD7->ZD7_POS    := aItmTest[_j][5]
			        MsUnLock("ZD7")
			    EndIf
			Next
			
			//Grava os parametros dos testes de estanqueidade
			//Percorre o array aParTest, que � o aTest[_x][5]
			aParTest := aTest[_x][5]
			For _j:=1 to Len(aParTest)
				//Percorre o acols do aParTest
				aColsPar := aParTest[_j][5]
				For _y:=1 to Len(aColsPar)
					If !aColsPar[_y][len(aColsPar[_y])] //nao pega quando estiver deletado
						RecLock("ZD8",.T.)
							ZD8->ZD8_FILIAL := xFilial("ZD8")
							ZD8->ZD8_NUM    := cZb5NumFt
							ZD8->ZD8_REV    := cZb5Rev
							ZD8->ZD8_ITEMFT := aTest[_x][1]
							ZD8->ZD8_ITEM   := aParTest[_j][1]
							ZD8->ZD8_TIPO   := aParTest[_j][2]
							ZD8->ZD8_MEDIDO := aParTest[_j][3]
							ZD8->ZD8_PROG   := aParTest[_j][4]
							ZD8->ZD8_LETRA  := aColsPar[_y][1]
							ZD8->ZD8_PARAM  := aColsPar[_y][2]
							ZD8->ZD8_VALOR  := aColsPar[_y][3]
						MsUnlock("ZD8")					
				    EndIf
			    Next
			Next
        Next

		//���������������������Ŀ
		//� INCLUI AS INSPECOES �
		//�����������������������
		For _x:=1 to Len(aInsp)
	    	//copia a imagem da Inspadora
			cImgTmp := STRTRAN(Alltrim(cZb5NumFt),"/","_")+ "ins" +aInsp[_x][1]+Right(AllTrim(aInsp[_x][3]),4)

			If !empty(aInsp[_x][3]) .and. !(cStartPath+cImgTmp$aInsp[_x][3])
				If __CopyFile(aInsp[_x][3],cStartPath+cImgTmp)
					aInsp[_x][3] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem da Inspe��o "+aInsp[_x][1]+"!")
					aInsp[_x][3] := ""
				EndIf
			Else
				aInsp[_x][3] := STRTRAN(aInsp[_x][3],cStartPath,"")	
			EndIf

			RecLock("ZD5",.T.)
				ZD5->ZD5_FILIAL := xFilial("ZD5")
				ZD5->ZD5_NUM    := cZb5NumFt
				ZD5->ZD5_REV    := cZb5Rev
				ZD5->ZD5_ITEM   := aInsp[_x][1]
				ZD5->ZD5_BEM    := aInsp[_x][2]
				ZD5->ZD5_IMG01  := aInsp[_x][3]
			MsUnLock("ZD5")
			
	    	//Grava os itens da inspecao
	    	For _j := 1 to Len(aInsp[_x][4])
				If !(aInsp[_x][4][_j][len(aInsp[_x][4][_j])])//nao pega se estiver deletado
		    		RecLock("ZDB",.T.)
						ZDB->ZDB_FILIAL := xFilial("ZDB")
						ZDB->ZDB_NUM    := cZb5NumFt
						ZDB->ZDB_REV    := cZb5Rev
						ZDB->ZDB_ITEMFT := aInsp[_x][1]
						ZDB->ZDB_ITEM   := aInsp[_x][4][_j][1]
						ZDB->ZDB_COD	:= aInsp[_x][4][_j][2]
		    		MsUnLock("ZDB")
		    	EndIf
	    	Next

		Next

		End Transaction
		
	EndIf
	
	/**********
	* ALTERAR *
	**********/
	If nPar == 3
		
		If !fValidaFT()
			Return
		EndIf
		
		//ZB5 - CABECALHO DA FICHA T�CNICA
		ZB5->(DbSetOrder(1)) //Filial + Num + Revisao
		ZB5->(DbSeek(xFilial("ZB5")+cZb5NumFt+cZb5Rev))
		
		If ZB5->ZB5_STATUS=="A"
			If !(MsgYesNo("Esta altera��o tornar� a Ficha T�cnica pendente. Deseja continuar?"))
				Return
			EndIf
		EndIf
		
		Begin Transaction 

		RecLock("ZB5",.F.)
			ZB5->ZB5_PC     := cPlCont
			ZB5->ZB5_STATUS := 'P'
			ZB5->ZB5_TCICLO := cZb5Tciclo
			ZB5->ZB5_OPDESC := cZb5OpDesc
			ZB5->ZB5_CC     := cCC
		MsUnlock("ZB5")
		
		//ZBH - EQUIPAMENTOS DA F.T.
		ZBH->(DbSetOrder(1)) //Filial + NumFT + Rev + Item
		
		For _x:=1 to Len(aMaq)

	    	//copia a imagem da m�quina
			cImgTmp := AllTrim(STRTRAN(cZb5NumFt,"/","_"))+"maq"+aMaq[_x][1]+Right(AllTrim(aMaq[_x][11]),4)
			aMaq[_x][11] := StrTran(aMaq[_x][11],cStartPath,"")	
				
			If !Empty(aMaq[_x][11]) .AND. !(cImgTmp$aMaq[_x][11])
				If __CopyFile(aMaq[_x][11],cStartPath + cImgTmp)
					aMaq[_x][11] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem do Equipamento "+aMaq[_x][1]+"!")
					aMaq[_x][11] := ""
				EndIf
			EndIf

			If ZBH->(DbSeek(xFilial("ZBH")+cZb5NumFt+cZb5Rev+aMaq[_x][1]))
	
				RecLock("ZBH",.F.)
					ZBH->ZBH_BEM    := aMaq[_x][2]
					ZBH->ZBH_PROGP1 := aMaq[_x][6]
					ZBH->ZBH_PROGP2 := aMaq[_x][7]
					ZBH->ZBH_CONSOS := aMaq[_x][8]
					ZBH->ZBH_PRESRI := aMaq[_x][9]
					ZBH->ZBH_PRESAC := aMaq[_x][10]
					ZBH->ZBH_IMG01  := aMaq[_x][11]
				MsUnLock("ZBH")
			Else
				RecLock("ZBH",.T.)
					ZBH->ZBH_FILIAL := xFilial("ZBH")
					ZBH->ZBH_NUM    := cZb5NumFt
					ZBH->ZBH_REV    := cZb5Rev
					ZBH->ZBH_ITEM   := aMaq[_x][1]
					ZBH->ZBH_BEM    := aMaq[_x][2]
					ZBH->ZBH_PROGP1 := aMaq[_x][6]
					ZBH->ZBH_PROGP2 := aMaq[_x][7]
					ZBH->ZBH_CONSOS := aMaq[_x][8]
					ZBH->ZBH_PRESRI := aMaq[_x][9]
					ZBH->ZBH_PRESAC := aMaq[_x][10]
					ZBH->ZBH_IMG01  := aMaq[_x][11]
				MsUnLock("ZBH")
			
			EndIf
	    Next
		 
		//VERIFICA SE N�O EXISTEM ALGUM ITEM NA TABELA QUE TENHA SIDO EXCLU�DO NO ARRAY AMAQ	
		ZBH->(DbSetOrder(1)) //filial + numft + rev + item
		If ZBH->(DbSeek(xFilial("ZBH")+cZb5NumFt+cZb5Rev))
			WHILE ZBH->(!EOF()) .AND. ZBH->ZBH_NUM == cZb5NumFt .AND. ZBH->ZBH_REV == cZb5Rev
				_n := aScan(aMaq,{|x| x[1] == ZBH->ZBH_ITEM})
				
				If _n==0
					//apaga a imagem do diretorio
					If File(cStartPath + ZBH->ZBH_IMG01)
						fErase(cStartPath + ZBH->ZBH_IMG01)
					EndIf                                

					RecLock("ZBH",.F.)
						ZBH->(DBDELETE())
					MsUnLock("ZBH")
				EndIf

				ZBH->(DBSKIP())
		    ENDDO
		EndIf
		
		//ZBG - DISPOSITIVOS DA F.T.
		ZBG->(DbSetOrder(1)) // FILIAL + NUMFT + REV + ITEM
		
		For _x:=1 to Len(aDisp)

			//copia a imagem do dispositivo
			cImgTmp := AllTrim(STRTRAN(cZb5NumFt,"/","_")) + "dis"+aDisp[_x][1]+Right(AllTrim(aDisp[_x][9]),4)
			aDisp[_x][9] := StrTran(aDisp[_x][9],cStartPath,"")

			If !Empty(aDisp[_x][9]) .AND. !(cImgTmp$aDisp[_x][9])
				If __CopyFile(aDisp[_x][9],cStartPath + cImgTmp)
					aDisp[_x][9] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem do Dispositivo "+aDisp[_x][1]+"!")
					aDisp[_x][9] := ""
				EndIf
			EndIf

			If ZBG->(DbSeek(xFilial("ZBG")+cZb5NumFt+cZb5Rev+aDisp[_x][1]))
					
		    	RecLock("ZBG",.F.)
		    		ZBG->ZBG_NDISP1 := aDisp[_x][2]
		    		ZBG->ZBG_LETRA1 := aDisp[_x][3]
		    		ZBG->ZBG_NDISP2 := aDisp[_x][4]
		    		ZBG->ZBG_LETRA2 := aDisp[_x][5]
		    		ZBG->ZBG_PFIXD1 := aDisp[_x][6]
		    		ZBG->ZBG_PFIXD2 := aDisp[_x][7]
		    		ZBG->ZBG_QTDPCD := aDisp[_x][8]
		    		ZBG->ZBG_IMG01  := aDisp[_x][9]
		    	MsUnLock("ZBG")
			Else
		    	RecLock("ZBG",.T.)
		    		ZBG->ZBG_FILIAL := xFilial("ZBG")
		    		ZBG->ZBG_NUM    := cZb5NumFt
		    		ZBG->ZBG_REV    := cZb5Rev
		    		ZBG->ZBG_ITEM   := aDisp[_x][1]
		    		ZBG->ZBG_NDISP1 := aDisp[_x][2]
		    		ZBG->ZBG_LETRA1 := aDisp[_x][3]
		    		ZBG->ZBG_NDISP2 := aDisp[_x][4]
		    		ZBG->ZBG_LETRA2 := aDisp[_x][5]
		    		ZBG->ZBG_PFIXD1 := aDisp[_x][6]
		    		ZBG->ZBG_PFIXD2 := aDisp[_x][7]
		    		ZBG->ZBG_QTDPCD := aDisp[_x][8]
		    		ZBG->ZBG_IMG01  := aDisp[_x][9]
		    	MsUnLock("ZBG")
			
			End
		Next
		     
		//VERIFICA SE N�O EXISTE ALGUM ITEM NA TABELA ZAG QUE TENHA SIDO EXCLUIDO DO ARRAY ADISP
		ZBG->(DbSetOrder(1)) //FILIAL + NUMFT + REV + ITEM
		If ZBG->(DbSeek(xFilial("ZBG")+cZb5NumFt+cZb5Rev))
			WHILE ZBG->(!EOF()) .AND. ZBG->ZBG_NUM == cZb5NumFt .AND. ZBG->ZBG_REV == cZb5Rev
				_n := aScan(aDisp,{|x| x[1] == ZBG->ZBG_ITEM})
				
				If _n==0
					//apaga a imagem do diretorio
					If File(cStartPath + ZBG->ZBG_IMG01)
						fErase(cStartPath + ZBG->ZBG_IMG01)
					EndIf
				
					RecLock("ZBG",.F.)
						ZBG->(DBDELETE())
					MsUnLock("ZBG")
				EndIf

				ZBG->(DBSKIP())
		    ENDDO
		EndIf

		//ZBF - MONTAGENS DE FERRAMENTAS DA F.T.
		ZBF->(DbSetOrder(1)) // FILIAL + NUMFT + REV + ITEM
		For _x:=1 to Len(aFer)

			cImgTmp := AllTrim(STRTRAN(cZb5NumFt,"/","_"))+"fe2"+aFer[_x][1]+Right(AllTrim(aFer[_x][4]),4)
            aFer[_x][4] := StrTran(aFer[_x][4],cStartPath,"")
            
			If !Empty(aFer[_x][4]) .AND. !(cImgTmp$aFer[_x][4])
				If __CopyFile(aFer[_x][4],cStartPath + cImgTmp)
					aFer[_x][4] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem 2 da Ferramenta "+aFer[_x][1]+"!")
					aFer[_x][4] := ""
				EndIf
			EndIf

			If ZBF->(DbSeek(xFilial("ZBF")+cZb5NumFT+cZb5Rev+aFer[_x][1]))
	    	    RecLock("ZBF",.F.)
    	    		ZBF->ZBF_NUMONT := aFer[_x][2]
	    	    	ZBF->ZBF_IMG02  := aFer[_x][4]
    		    MsUnLock("ZBF")
		    Else
	    	    RecLock("ZBF",.T.)
	    	    	ZBF->ZBF_FILIAL := xFilial("ZBF")
    		    	ZBF->ZBF_NUM    := cZb5NumFt
    		    	ZBF->ZBF_REV    := cZb5Rev
    		    	ZBF->ZBF_ITEM   := aFer[_x][1]
    	    		ZBF->ZBF_NUMONT := aFer[_x][2]
	    	    	ZBF->ZBF_IMG02  := aFer[_x][4]
    		    MsUnLock("ZBF")
		    EndIf
			
			//ZBC - ITENS DA MONTAGEM DE FERRAMENTAS
			//NAO E MAIS GRAVADO NESTA ROTINA. GRAVADO NA ROTINA NHEST143
			
			//ZBD - VARIAVEIS DO PROCESSO 
			ZBD->(DbSetOrder(1)) // FILIAL + NUMFT + REV + NUMONT + ITEM
	    	For _j := 1 to Len(aFer[_x][6])

				If !(aFer[_x][6][_j][len(aFer[_x][6][_j])])//nao pega se estiver deletado
					If ZBD->(DbSeek(xFilial("ZBD")+cZb5NumFt+cZb5Rev+aFer[_x][2]+aFer[_x][6][_j][1]))
			    		RecLock("ZBD",.F.)
							ZBD->ZBD_DIAMET	:= aFer[_x][6][_j][2]
							ZBD->ZBD_VC     := aFer[_x][6][_j][3]
							ZBD->ZBD_RPM    := aFer[_x][6][_j][4]
							ZBD->ZBD_QDENTE := aFer[_x][6][_j][5] 
							ZBD->ZBD_MMDENT := aFer[_x][6][_j][6]
							ZBD->ZBD_MMMIN  := aFer[_x][6][_j][7]
							ZBD->ZBD_VIDA   := aFer[_x][6][_j][8]
		    			MsUnLock("ZBD")
		    		Else
			    		RecLock("ZBD",.T.)
							ZBD->ZBD_FILIAL := xFilial("ZBD")
							ZBD->ZBD_NUM    := cZb5NumFt
							ZBD->ZBD_REV    := cZb5Rev
							ZBD->ZBD_NUMONT := aFer[_x][2]
							ZBD->ZBD_ITEM   := aFer[_x][6][_j][1]
							ZBD->ZBD_DIAMET	:= aFer[_x][6][_j][2]
							ZBD->ZBD_VC     := aFer[_x][6][_j][3]
							ZBD->ZBD_RPM    := aFer[_x][6][_j][4]
							ZBD->ZBD_QDENTE := aFer[_x][6][_j][5] 
							ZBD->ZBD_MMDENT := aFer[_x][6][_j][6]
							ZBD->ZBD_MMMIN  := aFer[_x][6][_j][7]
							ZBD->ZBD_VIDA   := aFer[_x][6][_j][8]
		    			MsUnLock("ZBD")		    	
			    	EndIf
			    Else
				    If ZBD->(DbSeek(xFilial("ZBD")+cZb5NumFt+cZb5Rev+aFer[_x][2]+aFer[_x][6][_j][1]))
				    	RecLock("ZBD",.F.)
				    		ZBD->(DbDelete())
				    	MsUnLock("ZBD")
				    EndIf
			    EndIf
	    	Next

			//ZBE - COORDENADAS DE USINAGEM
			ZBE->(DbSetOrder(1)) //Filial + NumFt + Rev + NumMont + Item
		
			For _j := 1 to Len(aFer[_x][7])
			
				If !(aFer[_x][7][_j][len(aFer[_x][7][_j])]) //nao pega se estiver deletado
					If ZBE->(DbSeek(xFilial("ZBE")+cZb5NumFt+cZb5Rev+aFer[_x][2]+aFer[_x][7][_j][1]))
	
						RecLock("ZBE",.F.)
							ZBE->ZBE_X      := aFer[_x][7][_j][2]
							ZBE->ZBE_Y      := aFer[_x][7][_j][3]
							ZBE->ZBE_Z      := aFer[_x][7][_j][4]
							ZBE->ZBE_NFURO  := aFer[_x][7][_j][5]
						MsUnLock("ZBE")		
					Else 
						RecLock("ZBE",.T.)
							ZBE->ZBE_FILIAL := XFILIAL("ZBE")
							ZBE->ZBE_NUM    := cZb5NumFt              
							ZBE->ZBE_REV    := cZb5Rev
							ZBE->ZBE_NUMONT := aFer[_x][2]
							ZBE->ZBE_ITEM   := aFer[_x][7][_j][1]
							ZBE->ZBE_X      := aFer[_x][7][_j][2]
							ZBE->ZBE_Y      := aFer[_x][7][_j][3]
							ZBE->ZBE_Z      := aFer[_x][7][_j][4]
							ZBE->ZBE_NFURO  := aFer[_x][7][_j][5]
						MsUnLock("ZBE")		
					EndIf
				Else
					If ZBE->(DbSeek(xFilial("ZBE")+cZb5NumFt+cZb5Rev+aFer[_x][2]+aFer[_x][7][_j][1]))
						RecLock("ZBE",.F.)
							ZBE->(DbDelete())
						MsUnlock("ZBE")
					EndIf
				EndIf
			Next 

		Next
		
		//VERIFICA SE NAO EXISTE ALGUM ITEM NA TABELA ZBF QUE TENHA SIDO EXCLUIDO DO ARRAY AFER
		ZBF->(DbSetOrder(1)) //FILIAL + NUM + REV
		If ZBF->(DbSeek(xFilial("ZBF")+cZb5NumFt+cZb5Rev))
			WHILE ZBF->(!EOF()) .AND. ZBF->ZBF_NUM == cZb5NumFt .AND. ZBF->ZBF_REV == cZb5Rev
				_n := aScan(aFer,{|x| x[1] == ZBF->ZBF_ITEM})
				
				If _n==0
					//apaga a imagem do diretorio
					If File(cStartPath + ZBF->ZBF_IMG02)
						fErase(cStartPath + ZBF->ZBF_IMG02)
					EndIf
					
					//APAGA TODAS AS VARIAVEIS DO PROCESSO
					ZBD->(DBSETORDER(1))//ZBD_FILIAL+ZBD_NUM+ZBD->ZBD_REV+ZBD_NUMONT
					IF ZBD->(DBSEEK(XFILIAL("ZBD")+cZb5NumFt+cZb5Rev+ZBF->ZBF_NUMONT))
		    	
						WHILE ZBD->(!EOF()) .AND. ZBD->ZBD_NUM == cZb5NumFt .AND. ZBD->ZBD_NUMONT == ZBF->ZBF_NUMONT .AND. ZBD->ZBD_REV == cZb5Rev
						
							RecLock("ZBD",.F.)
								ZBD->(DbDelete())
							MsUnLock("ZBD")
							
							ZBD->(DBSKIP())
						ENDDO
					ENDIF
					
					//APAGA TODAS AS COORDENADAS DE USINAGEM
					ZBE->(DBSETORDER(1))//ZBE_FILIAL+ZBE_NUM+ZBE_REV+ZBE_NUMONT+ZBE_ITEM
					IF ZBE->(DBSEEK(XFILIAL("ZBE")+cZb5NumFt+cZb5Rev+ZBF->ZBF_NUMONT))
						WHILE ZBE->(!EOF()) .AND. ZBE->ZBE_NUM == cZb5NumFt .AND. ZBE->ZBE_NUMONT == ZBF->ZBF_NUMONT .AND. ZBF->ZBF_REV == cZb5Rev

							RecLock("ZBE",.F.)
								ZBE->(DbDelete())
							MsUnLock("ZBE")
							
							ZBE->(DBSKIP())
					    ENDDO
					ENDIF
							
					//APAGA A MONTAGEM DE FERRAMENTAS
					RecLock("ZBF",.F.)
						ZBF->(DBDELETE())
					MsUnLock("ZBF")

				EndIf
				
				ZBF->(DBSKIP())
		    ENDDO
		EndIf
		
		//���������������������Ŀ
		//� ALTERA AS LAVADORAA �
		//�����������������������
		ZD2->(dbSetOrder(1))
		For _x:=1 to Len(aLav)

	    	//copia a imagem da lavadora
			cImgTmp := AllTrim(STRTRAN(cZb5NumFt,"/","_"))+"lav"+aLav[_x][1]+Right(AllTrim(aLav[_x][11]),4)
			aLav[_x][11] := StrTran(aLav[_x][11],cStartPath,"")	
				
			If !Empty(aLav[_x][11]) .AND. !(cImgTmp$aLav[_x][11])
				If __CopyFile(aLav[_x][11],cStartPath + cImgTmp)
					aLav[_x][11] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem da Lavadora "+aLav[_x][1]+"!")
					aLav[_x][11] := ""
				EndIf
			EndIf

			If ZD2->(DbSeek(xFilial("ZD2")+cZb5NumFt+cZb5Rev+aLav[_x][1]))
				RecLock("ZD2",.F.)
					ZD2->ZD2_BEM    := aLav[_x][2]
					ZD2->ZD2_PRDBAN := aLav[_x][3]
					ZD2->ZD2_TEMBAN := aLav[_x][4]
					ZD2->ZD2_CONBAN := aLav[_x][5]
					ZD2->ZD2_TLAVAG := aLav[_x][6]
					ZD2->ZD2_TSECAG := aLav[_x][7]
					ZD2->ZD2_TSOPRO := aLav[_x][8]
					ZD2->ZD2_PRESSA := aLav[_x][9]
					ZD2->ZD2_PCCICL := aLav[_x][10]
					ZD2->ZD2_IMG01  := aLav[_x][11]
				MsUnLock("ZD2")				
			Else
				RecLock("ZD2",.T.)
					ZD2->ZD2_FILIAL := xFilial("ZD2")
					ZD2->ZD2_NUM    := cZb5NumFt
					ZD2->ZD2_REV    := cZb5Rev
					ZD2->ZD2_ITEM   := aLav[_x][1]
					ZD2->ZD2_BEM    := aLav[_x][2]
					ZD2->ZD2_PRDBAN := aLav[_x][3]
					ZD2->ZD2_TEMBAN := aLav[_x][4]
					ZD2->ZD2_CONBAN := aLav[_x][5]
					ZD2->ZD2_TLAVAG := aLav[_x][6]
					ZD2->ZD2_TSECAG := aLav[_x][7]
					ZD2->ZD2_TSOPRO := aLav[_x][8]
					ZD2->ZD2_PRESSA := aLav[_x][9]
					ZD2->ZD2_PCCICL := aLav[_x][10]
					ZD2->ZD2_IMG01  := aLav[_x][11]
				MsUnLock("ZD2")			
			EndIf
	    Next
		 
		//VERIFICA SE N�O EXISTEM ALGUM ITEM NA TABELA QUE TENHA SIDO EXCLU�DO NO ARRAY ALAV
		ZD2->(DbSetOrder(1)) //filial + numft + rev + item
		If ZD2->(DbSeek(xFilial("ZD2")+cZb5NumFt+cZb5Rev))
			WHILE ZD2->(!EOF()) .AND. ZD2->ZD2_NUM == cZb5NumFt .AND. ZD2->ZD2_REV == cZb5Rev
				_n := aScan(aLav,{|x| x[1] == ZD2->ZD2_ITEM})
				
				If _n==0
					//apaga a imagem do diretorio
					If File(cStartPath + ZD2->ZD2_IMG01)
						fErase(cStartPath + ZD2->ZD2_IMG01)
					EndIf                                

					RecLock("ZD2",.F.)
						ZD2->(DBDELETE())
					MsUnLock("ZD2")
				EndIf

				ZD2->(DBSKIP())
		    ENDDO
		EndIf

		//�����������������������������������������������Ŀ
		//� ALTERA OS EQUIPAMENTOS DE MONTAGEM / MONTAGEM �
		//�������������������������������������������������
		ZD3->(dbSetOrder(1))// FILIAL + NUM + REV + ITEM
        For _x:=1 to Len(aMont)
			//copia a imagem do equipamento de montagem
			cImgTmp := AllTrim(STRTRAN(cZb5NumFt,"/","_"))+"mon"+aMont[_x][1]+Right(AllTrim(aMont[_x][4]),4)
            aMont[_x][4] := StrTran(aMont[_x][4],cStartPath,"")
            
			If !Empty(aMont[_x][4]) .AND. !(cImgTmp$aMont[_x][4])
				If __CopyFile(aMont[_x][4],cStartPath + cImgTmp)
					aMont[_x][4] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem da Montagem "+aMont[_x][1]+"!")
					aMont[_x][4] := ""
				EndIf
			EndIf

			If ZD3->(DbSeek(xFilial("ZD3")+cZb5NumFT+cZb5Rev+aMont[_x][1]))
				RecLock("ZD3",.F.)
					ZD3->ZD3_BEM    := aMont[_x][2]
					ZD3->ZD3_PUHD   := aMont[_x][3]
					ZD3->ZD3_IMG01  := aMont[_x][4]
				MsUnLock("ZD3")
		    Else
				RecLock("ZD3",.T.)
					ZD3->ZD3_FILIAL := xFilial("ZD3")
					ZD3->ZD3_NUM    := cZb5NumFt
					ZD3->ZD3_REV    := cZb5Rev
					ZD3->ZD3_ITEM   := aMont[_x][1]
					ZD3->ZD3_BEM    := aMont[_x][2]
					ZD3->ZD3_PUHD   := aMont[_x][3]
					ZD3->ZD3_IMG01  := aMont[_x][4]
				MsUnLock("ZD3")
		    EndIf

			//ZD6 - COMPONENTES DOS EQUIPAMENTOS DE MONTAGEM
			ZD6->(DbSetOrder(1)) //Filial + NumFt + Rev + ITEMFT + Item
		
			For _j:=1 to Len(aMont[_x][5])
			
				If !(aMont[_x][5][_j][len(aMont[_x][5][_j])]) //nao pega se estiver deletado
					If ZD6->(DbSeek(xFilial("ZD6")+cZb5NumFt+cZb5Rev+aMont[_x][1]+aMont[_x][5][_j][1]))
						RecLock("ZD6",.F.)
							ZD6->ZD6_COD	:= aMont[_x][5][_j][2]
							ZD6->ZD6_QTDE   := aMont[_x][5][_j][4]
							ZD6->ZD6_POS    := aMont[_x][5][_j][5]
						MsUnLock("ZD6")		
					Else 
						RecLock("ZD6",.T.)
							ZD6->ZD6_FILIAL := xFilial("ZD6")
							ZD6->ZD6_NUM    := cZb5NumFt
							ZD6->ZD6_REV    := cZb5Rev
							ZD6->ZD6_ITEMFT := aMont[_x][1]
							ZD6->ZD6_ITEM   := aMont[_x][5][_j][1]
							ZD6->ZD6_COD	:= aMont[_x][5][_j][2]
							ZD6->ZD6_QTDE   := aMont[_x][5][_j][4]
							ZD6->ZD6_POS    := aMont[_x][5][_j][5]
						MsUnLock("ZD6")		
					EndIf
				Else
					If ZD6->(DbSeek(xFilial("ZD6")+cZb5NumFt+cZb5Rev+aMont[_x][1]+aMont[_x][5][_j][1]))
						RecLock("ZD6",.F.)
							ZD6->(DbDelete())
						MsUnlock("ZD6")
					EndIf
				EndIf
			Next 
		Next
		
		//VERIFICA SE NAO EXISTE ALGUM ITEM NA TABELA ZBF QUE TENHA SIDO EXCLUIDO DO ARRAY AMONT
		ZD3->(DbSetOrder(1)) //FILIAL + NUM + REV + ITEM
		If ZD3->(DbSeek(xFilial("ZD3")+cZb5NumFt+cZb5Rev))
			WHILE ZD3->(!EOF()) .AND. ZD3->ZD3_NUM == cZb5NumFt .AND. ZD3->ZD3_REV == cZb5Rev
				_n := aScan(aMont,{|x| x[1] == ZD3->ZD3_ITEM})
				
				If _n==0
					//apaga a imagem do diretorio
					If File(cStartPath + ZD3->ZD3_IMG01)
						fErase(cStartPath + ZD3->ZD3_IMG01)
					EndIf
					
					//APAGA TODAS AS COORDENADAS DE EQUIPAMENTO DE MONTAGEM
					ZD6->(DBSETORDER(1))//ZD6_FILIAL+ZD6_NUM+ZD6->ZD6_REV+ZD6_ITEMFT+ZD6_ITEM
					IF ZD6->(DBSEEK(XFILIAL("ZD6")+cZb5NumFt+cZb5Rev+ZD3->ZD3_ITEM))
		    	
						WHILE ZD6->(!EOF()) .AND. ZD6->ZD6_NUM==cZb5NumFt .AND. ZD6->ZD6_REV==cZb5Rev .AND. ZD6->ZD6_ITEMFT==ZD3->ZD3_ITEM 
						
							RecLock("ZD6",.F.)
								ZD6->(DbDelete())
							MsUnLock("ZD6")
							
							ZD6->(DBSKIP())
						ENDDO
					ENDIF
							
					//APAGA A MONTAGEM DE FERRAMENTAS
					RecLock("ZD3",.F.)
						ZD3->(DBDELETE())
					MsUnLock("ZD3")

				EndIf
				
				ZD3->(DBSKIP())
		    ENDDO
		EndIf

		//�����������������������������������Ŀ
		//� ALTERA OS TESTES DE ESTANQUEIDADE �
		//�������������������������������������
		ZD4->(dbSetOrder(1))// FILIAL + NUM + REV + ITEM
        For _x:=1 to Len(aTest)
			//copia a imagem do equipamento de montagem
			cImgTmp := AllTrim(STRTRAN(cZb5NumFt,"/","_"))+"tes"+aTest[_x][1]+Right(AllTrim(aTest[_x][3]),4)
            aTest[_x][3] := StrTran(aTest[_x][3],cStartPath,"")
            
			If !Empty(aTest[_x][3]) .AND. !(cImgTmp$aTest[_x][3])
				If __CopyFile(aTest[_x][3],cStartPath + cImgTmp)
					aTest[_x][3] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem da Montagem "+aTest[_x][1]+"!")
					aTest[_x][3] := ""
				EndIf
			EndIf

			If ZD4->(DbSeek(xFilial("ZD4")+cZb5NumFT+cZb5Rev+aTest[_x][1]))
				RecLock("ZD4",.F.)
					ZD4->ZD4_BEM    := aTest[_x][2]
					ZD4->ZD4_IMG01  := aTest[_x][3]
				MsUnLock("ZD4")
		    Else
				RecLock("ZD4",.T.)
					ZD4->ZD4_FILIAL := xFilial("ZD4")
					ZD4->ZD4_NUM    := cZb5NumFt
					ZD4->ZD4_REV    := cZb5Rev
					ZD4->ZD4_ITEM   := aTest[_x][1]
					ZD4->ZD4_BEM    := aTest[_x][2]
					ZD4->ZD4_IMG01  := aTest[_x][3]
				MsUnLock("ZD4")
		    EndIf

			//ZD7 - ITENS DOS TESTES DE ESTANQUEIDADE
			ZD7->(DbSetOrder(1)) //Filial + NumFt + Rev + ITEMFT + Item
			For _j:=1 to Len(aTest[_x][4])
			
				If !(aTest[_x][4][_j][len(aTest[_x][4][_j])]) //nao pega se estiver deletado
					If ZD7->(DbSeek(xFilial("ZD7")+cZb5NumFt+cZb5Rev+aTest[_x][1]+aTest[_x][4][_j][1]))
						RecLock("ZD7",.F.)
							ZD7->ZD7_COD	:= aTest[_x][4][_j][2]
							ZD7->ZD7_QTDE   := aTest[_x][4][_j][4]
							ZD7->ZD7_POS    := aTest[_x][4][_j][5]
						MsUnLock("ZD7")		
					Else 
						RecLock("ZD7",.T.)
							ZD7->ZD7_FILIAL := xFilial("ZD7")
							ZD7->ZD7_NUM    := cZb5NumFt
							ZD7->ZD7_REV    := cZb5Rev
							ZD7->ZD7_ITEMFT := aTest[_x][1]
							ZD7->ZD7_ITEM   := aTest[_x][4][_j][1]
							ZD7->ZD7_COD	:= aTest[_x][4][_j][2]
							ZD7->ZD7_QTDE   := aTest[_x][4][_j][4]
							ZD7->ZD7_POS    := aTest[_x][4][_j][5]
						MsUnLock("ZD7")		
					EndIf
				Else
					If ZD7->(DbSeek(xFilial("ZD7")+cZb5NumFt+cZb5Rev+aTest[_x][1]+aTest[_x][4][_j][1]))
						RecLock("ZD7",.F.)
							ZD7->(DbDelete())
						MsUnlock("ZD7")
					EndIf
				EndIf
			Next
	
			//ZD8 - PARAMETROS DOS TESTES DE ESTANQUEIDADE
			ZD8->(dbSetOrder(1)) //FILIAL + NUM + REV + ITEMFT + ITEM + LETRA
			aParTest := aTest[_x][5]
			For _j:=1 to Len(aParTest)

				aColsPar := aParTest[_j][5]

				For _y:=1 to Len(aColsPar)
						
					If !aColsPar[_y][len(aColsPar[_y])] //nao pega quando estiver deletado
						If ZD8->(dbSeek(xFilial("ZD8")+cZb5NumFt+cZb5Rev+aTest[_x][1]+aParTest[_j][1]+aColsPar[_y][1]))
							RecLock("ZD8",.F.)
								ZD8->ZD8_PARAM := aColsPar[_y][2]
								ZD8->ZD8_VALOR := aColsPar[_y][3]
							MsUnLock("ZD8")
						Else
							RecLock("ZD8",.T.)
								ZD8->ZD8_FILIAL := xFilial("ZD8")
								ZD8->ZD8_NUM    := cZb5NumFt
								ZD8->ZD8_REV    := cZb5Rev
								ZD8->ZD8_ITEMFT := aTest[_x][1]
								ZD8->ZD8_ITEM   := aParTest[_j][1]
								ZD8->ZD8_TIPO   := aParTest[_j][2]
								ZD8->ZD8_MEDIDO := aParTest[_j][3]
								ZD8->ZD8_PROG   := aParTest[_j][4]
								ZD8->ZD8_LETRA  := aColsPar[_y][1]
								ZD8->ZD8_PARAM  := aColsPar[_y][2]
								ZD8->ZD8_VALOR  := aColsPar[_y][3]
							MsUnLock("ZD8")
						EndIf
					Else
						If ZD8->(dbSeek(xFilial("ZD8")+cZb5NumFt+cZb5Rev+aTest[_x][1]+aParTest[_j][1]+aColsPar[_y][1]))
							RecLock("ZD8",.F.)
								ZD8->(dbDelete())
							MsUnLock("ZD8")
						EndIf		
				   	EndIf
				
				Next
			Next
			
			//verifica se existe algum item na tabela ZB8 que tenha sido excluido do array aParTest
			If ZD8->(dbSeek(xFilial("ZD8")+cZb5NumFt+cZb5Rev+aTest[_x][1]))
				WHILE ZD8->(!Eof()) .and. ZD8->ZD8_NUM==cZb5NumFt .AND. ZD8->ZD8_REV==cZb5Rev .AND. ZD8->ZD8_ITEMFT==aTest[_x][1]
					
					nRecZD8 := ZD8->(RecNo())
					
					_n := aScan(aParTest,{|x| x[1]==ZD8->ZD8_ITEM})
					
					If _n==0
						cItmZD8 := ZD8->ZD8_ITEM
						
						//apagar todos os parametros de teste de estanqueidade
						ZD8->(dbSeek(xFilial("ZD8")+cZb5NumFt+cZb5Rev+aTest[_x][1]+cItmZD8))
						WHILE ZD8->(!EOF()) .AND. ZD8->ZD8_NUM==cZb5NumFt .AND. ;
						                          ZD8->ZD8_REV==cZb5Rev .AND. ;
						                          ZD8->ZD8_ITEMFT==aTest[_x][1] .AND. ;
						                          ZD8->ZD8_ITEM==cItmZD8
						    RecLock("ZD8",.F.)
						    	ZD8->(dbDelete())
						    MsUnlock("ZD8")                      
						                          
							ZD8->(DBSKIP())						                          
						ENDDO
					
					EndIf
					
					ZD8->(dbGoTo(nRecZD8))
				
					ZD8->(dbSkip())
                ENDDO
			EndIf
			
		Next	
		//VERIFICA SE NAO EXISTE ALGUM ITEM NA TABELA ZD4 QUE TENHA SIDO EXCLUIDO DO ARRAY aTest
		ZD4->(DbSetOrder(1)) //FILIAL + NUM + REV + ITEM
		If ZD4->(DbSeek(xFilial("ZD4")+cZb5NumFt+cZb5Rev))
			WHILE ZD4->(!EOF()) .AND. ZD4->ZD4_NUM == cZb5NumFt .AND. ZD4->ZD4_REV == cZb5Rev
				_n := aScan(aTest,{|x| x[1] == ZD4->ZD4_ITEM})
				
				If _n==0
					//apaga a imagem do diretorio
					If File(cStartPath + ZD4->ZD4_IMG01)
						fErase(cStartPath + ZD4->ZD4_IMG01)
					EndIf
					
					//APAGA TODAS OS ITENS DO TESTE DE ESTANQUEIDADE
					ZD7->(DBSETORDER(1))//ZD7_FILIAL+ZD7_NUM+ZD7->ZD7_REV+ZD7_ITEMFT+ZD7_ITEM
					IF ZD7->(DBSEEK(XFILIAL("ZD7")+cZb5NumFt+cZb5Rev+ZD4->ZD4_ITEM))
		    	
						WHILE ZD7->(!EOF()) .AND. ZD7->ZD7_NUM==cZb5NumFt .AND. ZD7->ZD7_REV==cZb5Rev .AND. ZD7->ZD7_ITEMFT==ZD4->ZD4_ITEM 
						
							RecLock("ZD7",.F.)
								ZD7->(DbDelete())
							MsUnLock("ZD7")
							
							ZD7->(DBSKIP())
						ENDDO
					ENDIF
					
					//APAGA TODOS OS PARAMETROS DE TESTE DE ESTANQUEIDADE
					ZD8->(dbSetOrder(1))
					If ZD8->(dbSeek(xFilial("ZD8")+cZb5NumFt+cZb5Rev+ZD4->ZD4_ITEM))
						WHILE ZD8->(!EOF()) .AND. ZD8->ZD8_NUM==cZb5NumFt .AND. ZD8->ZD8_REV==cZb5Rev .AND. ZD8->ZD8_ITEMFT==ZD4->ZD4_ITEM 
						
							RecLock("ZD8",.F.)
								ZD8->(DbDelete())
							MsUnLock("ZD8")
							
							ZD8->(DBSKIP())
						ENDDO
					ENDIF
							
					//APAGA A MONTAGEM DE FERRAMENTAS
					RecLock("ZD4",.F.)
						ZD4->(DBDELETE())
					MsUnLock("ZD4")

				EndIf
				
				ZD4->(DBSKIP())
		    ENDDO
		EndIf

		//���������������������Ŀ
		//� ALTERA AS INSPECOES �
		//�����������������������
		ZD5->(dbSetOrder(1))
		For _x:=1 to Len(aInsp)

	    	//copia a imagem da Inspe��o
			cImgTmp := AllTrim(STRTRAN(cZb5NumFt,"/","_"))+"ins"+aInsp[_x][1]+Right(AllTrim(aInsp[_x][3]),4)
			aInsp[_x][3] := StrTran(aInsp[_x][3],cStartPath,"")	
				
			If !Empty(aInsp[_x][3]) .AND. !(cImgTmp$aInsp[_x][3])
				If __CopyFile(aInsp[_x][3],cStartPath + cImgTmp)
					aInsp[_x][3] := cImgTmp
				Else
					Alert("Imposs�vel copiar Imagem da Inspe��o "+aInsp[_x][1]+"!")
					aInsp[_x][3] := ""
				EndIf
			EndIf

			If ZD5->(DbSeek(xFilial("ZD5")+cZb5NumFt+cZb5Rev+aInsp[_x][1]))
				RecLock("ZD5",.F.)
					ZD5->ZD5_BEM    := aInsp[_x][2]
					ZD5->ZD5_IMG01  := aInsp[_x][3]
				MsUnLock("ZD5")
			Else
				RecLock("ZD5",.T.)
					ZD5->ZD5_FILIAL := xFilial("ZD5")
					ZD5->ZD5_NUM    := cZb5NumFt
					ZD5->ZD5_REV    := cZb5Rev
					ZD5->ZD5_ITEM   := aInsp[_x][1]
					ZD5->ZD5_BEM    := aInsp[_x][2]
					ZD5->ZD5_IMG01  := aInsp[_x][3]
				MsUnLock("ZD5")			
			EndIf
			
			//ZDB - ITENS DA INSPE��O (EQUIPAMENTOS / FERRAMENTAS)
			ZDB->(DbSetOrder(1)) //Filial + NumFt + Rev + ITEMFT + Item
		
			For _j:=1 to Len(aInsp[_x][4])
			
				If !(aInsp[_x][4][_j][len(aInsp[_x][4][_j])]) //nao pega se estiver deletado
					If ZDB->(DbSeek(xFilial("ZDB")+cZb5NumFt+cZb5Rev+aInsp[_x][1]+aInsp[_x][4][_j][1]))
						RecLock("ZDB",.F.)
							ZDB->ZDB_COD	:= aInsp[_x][4][_j][2]
						MsUnLock("ZDB")		
					Else 
						RecLock("ZDB",.T.)
							ZDB->ZDB_FILIAL := xFilial("ZDB")
							ZDB->ZDB_NUM    := cZb5NumFt
							ZDB->ZDB_REV    := cZb5Rev
							ZDB->ZDB_ITEMFT := aInsp[_x][1]
							ZDB->ZDB_ITEM   := aInsp[_x][4][_j][1]
							ZDB->ZDB_COD	:= aInsp[_x][4][_j][2]
						MsUnLock("ZDB")		
					EndIf
				Else
					If ZDB->(DbSeek(xFilial("ZDB")+cZb5NumFt+cZb5Rev+aInsp[_x][1]+aInsp[_x][4][_j][1]))
						RecLock("ZDB",.F.)
							ZDB->(DbDelete())
						MsUnlock("ZDB")
					EndIf
				EndIf
			Next
			
	    Next
		 
		//VERIFICA SE N�O EXISTEM ALGUM ITEM NA TABELA QUE TENHA SIDO EXCLU�DO NO ARRAY AINSP
		ZD5->(DbSetOrder(1)) //filial + numft + rev + item
		If ZD5->(DbSeek(xFilial("ZD5")+cZb5NumFt+cZb5Rev))
			WHILE ZD5->(!EOF()) .AND. ZD5->ZD5_NUM == cZb5NumFt .AND. ZD5->ZD5_REV == cZb5Rev
				_n := aScan(aInsp,{|x| x[1] == ZD5->ZD5_ITEM})
				
				If _n==0
					//apaga a imagem do diretorio
					If File(cStartPath + ZD5->ZD5_IMG01)
						fErase(cStartPath + ZD5->ZD5_IMG01)
					EndIf
					
					//APAGA TODOS OS ITENS DA INSPECAO (EQUIPAMENTO / FERRAMENTAS)
					ZDB->(DBSETORDER(1))//ZDB_FILIAL+ZDB_NUM+ZDB->ZDB_REV+ZDB_ITEMFT+ZDB_ITEM
					IF ZDB->(DBSEEK(XFILIAL("ZDB")+cZb5NumFt+cZb5Rev+ZD5->ZD5_ITEM))
		    	
						WHILE ZDB->(!EOF()) .AND. ZDB->ZDB_NUM==cZb5NumFt .AND. ZDB->ZDB_REV==cZb5Rev .AND. ZDB->ZDB_ITEMFT==ZD5->ZD5_ITEM 
						
							RecLock("ZDB",.F.)
								ZDB->(DbDelete())
							MsUnLock("ZDB")
							
							ZDB->(DBSKIP())
						ENDDO
						
					ENDIF

					//EXCLUI A INSPECAO
					RecLock("ZD5",.F.)
						ZD5->(DBDELETE())
					MsUnLock("ZD5")
				EndIf

				ZD5->(DBSKIP())
		    ENDDO
		EndIf

		End Transaction

	EndIf
	
	oDlgFolder:End()
Return

//��������������A�
//� VALIDA A FT �
//��������������A�
Static Function fValidaFT()

	If nPar==3//alterar
		If ZB5->ZB5_ULTREV=="N"
			Alert("N�o � poss�vel alterar! Documento n�o est� em sua �ltima revis�o.")
			Return .F.
		EndIf
	EndIf
	
	//codigo da peca
	If Empty(cZb5Peca)
		MsgBox("C�digo da pe�a em branco!"+_CRLF+;
				"Digite o c�digo da pe�a.","Pe�a em branco","ALERT")
		Return .F.
	EndIf 
	//numero da ft
	IF Empty(cZb5NumFT)
		MsgBox("C�digo da Ficha T�cnica em branco!"+_CRLF+;
				"Digite o c�digo da pe�a e a Opera��o.","N�mero da FT em branco","ALERT")
		Return .F.
	EndIf
	//operacao
	If Empty(cZb5oP)
		MsgBox("Opera��o em branco!"+_CRLF+;
				"Digite a Opera��o.","Opera��o em branco","ALERT")
		Return .F.
	EndIf
	
	//M�quina
	If fAEmpty(aMaq)
		aMaq := {}
	EndIf
	
	If fAEmpty(aDisp)
		aDisp := {}
	EndIf
	
	If fAEmpty(aFer)
		aFer := {}
	EndIf

	If fAEmpty(aLav)
		aLav := {}
	EndIf
	
	If fAEmpty(aMont)
		aMont := {}
	EndIf
	
	If fAEmpty(aTest)
		aTest := {}
	EndIf
	
	If fAEmpty(aInsp)
		aInsp := {}
	EndIf

Return .T.

//���������������������������������������������Ŀ
//� VALIDA O CENTRO DE CUSTO E TRAZ A DESCRICAO �
//�����������������������������������������������
Static Function fValCC()

	CTT->(dbSetOrder(1)) 
	If CTT->(dbSeek(xFilial("CTT")+cCC))
		cDescCC := CTT->CTT_DESC01
		oGet2:Refresh()
	Else
		Alert("Centro de Custo n�o encontrado!")
		Return .F.
	EndIf
	
Return .T.

//����������������������Ŀ
//� MONTA O NUMERO DA FT �
//������������������������
Static Function fGeraNumFT()
Local cNewFtNum := ""

	IF !EMPTY(cZb5Peca)
		DBSELECTAREA("SB1")
		DBSETORDER(1)//FILIAL + COD PRODUTO
		IF !DBSEEK(XFILIAL("SB1")+cZb5Peca)
			Alert("Produto n�o encontrado!")
			Return .F.
		Else
			cDescProd  := SB1->B1_DESC
			cZb5Ap5Num := SB1->B1_CODAP5
			cCC        := SB1->B1_CC
			
			CTT->(DBSETORDER(1))//FILIAL + CCUSTO
			IF CTT->(DBSEEK(XFILIAL("CTT")+cCC))
				cDescCC := CTT->CTT_DESC01
			ENDIF
			
			oGet2:Refresh()
			oGet3:Refresh()
			oDescProd:Refresh()
			oAp5Num:Refresh()
		Endif
	EndIf
			
	If !EMPTY(cZb5Peca)
		cNewFtNum := "FT"+ALLTRIM(SUBSTR(cZb5Peca,3,13))
	EndIf
	
	IF !EMPTY(cZb5Op)
		cNewFtNum += "/"+RIGHT(ALLTRIM(cZb5Op),2)
	EndIf

	If !Empty(cZb5Peca) .AND. !Empty(cZb5Op)
		DBSELECTAREA("ZB5")
		DBSETORDER(1)//FILIAL + NUM FT + REVISAO
		If DBSEEK(XFILIAL("ZB5")+cNewFtNum)
			Alert("FT j� existe para esta Pe�a x Opera��o!"+_CRLF+;
				  "Informe outra Pe�a ou Opera��o.")
			Return .F.
		EndIf
	EndIf
		
	cZb5NumFT := cNewFtNum
	oFtNum:Refresh()
	
Return .T.
          
//�������������������������Ŀ
//� TRAZ A DESCRICAO DO BEM �
//���������������������������
Static Function fBem(cBem,nTab)

	DbSelectArea("ST9")
	DbSetOrder(1) //FILIAL + COD BEM
	If DbSeek(xFilial("ST9")+cBem)
	
	    If nTab==1 //ZBH
			cZbHdBem := ST9->T9_NOME
			oZbHdbem:Refresh()
		ElseIf nTab==2 //ZD2
		    cZD2dBem := ST9->T9_NOME
		    oZD2dBem:Refresh()
		ElseIf nTab==3 //ZD3
			cZD3dBem := ST9->T9_NOME
			oZD3dBem:Refresh()
		ElseIf nTab==4 //ZD4
			cZD4dBem := ST9->T9_NOME
			oZD4dBem:Refresh() 
		ElseIf nTab==5 //ZD5
			cZD5dBem := ST9->T9_NOME
			oZD5dBem:Refresh() 
		EndIf
		
		nST9posx := ST9->T9_POSX
		nST9posY := ST9->T9_POSY
		oST9posx:Refresh()
		oST9posy:Refresh()
	Else
		Alert("M�quina n�o foi encontrada!"+_CRLF+;
			  "Informe um c�digo de m�quina existente.")
		Return .F.
	Endif
	
Return .T.
                         
//����������������������������������������Ŀ
//� FUNCAO PARA APROVADORES DA FICHA TECNICA �
//������������������������������������������
User Function PCP18Apr()
Private aHeader := {}
Private aCols   := {}

	aAdd(aHeader,{"Login","ZBM_LOGIN","@!",25,0,".T.","","C","ZBM"})
    
	ZBM->(DbSetOrder(1))
	ZBM->(DbGoTop())
	While ZBM->(!EOF())
		aAdd(aCols,{ZBM->ZBM_LOGIN,.F.})
		ZBM->(DbSkip())
	EndDo

	oDlgApr := MsDialog():New(0,0,200,400,"Ficha T�cnica",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	//monta o getdados
	oGetD := MsGetDados():New(05,05,80,195,;
	                          4,"AllwaysTrue",;
	                          "AllwaysTrue","",;
	                          .T.,nil,nil,.F.,;
	                          200,nil,"AllwaysTrue",;
	                          nil,"AllwaysTrue",;
	                          oDlgApr) 

	oBtn1 := tButton():New(85,110,"Gravar"  ,oDlgApr,{||fGrvApr()},40,10,,,,.T.)
	oBtn2 := tButton():New(85,155,"Cancelar",oDlgApr,{||oDlgApr:End()},40,10,,,,.T.)
	oDlgApr:Activate(,,,.T.,{||.T.},,{||})
	
Return              

//��������������������&
//� GRAVA O APROVADOR �
//��������������������&�
Static Function fGrvApr()

	If !(ALLTRIM(cUserName)$"PATRICIAFF/JOAOFR")
		Alert("Usu�rio sem permiss�o para gravar aprovadores!")
		oDlgApr:End()
		Return
	EndIf
          
	ZBM->(DbSetOrder(1)) //ZBM_FILIAL + ZBM_LOGIN
	For _x:=1 to Len(aCols)
		If !(aCols[_x][len(aHeader)+1]) //nao pega se estiver deletado
			ZBM->(DBSEEK(XFILIAL("ZBM")+aCols[_x][1]))
			If ZBM->(!Found())
				RecLock("ZBM",.T.)
					ZBM->ZBM_FILIAL := xFilial("ZBM")
					ZBM->ZBM_LOGIN  := aCols[_x][1]
				MsUnLock("ZBM")
			EndIf
		Else
			If ZBM->(DBSEEK(XFILIAL("ZBM")+aCols[_x][1]))
				RecLock("ZBM",.F.)
					ZBM->(DBDELETE())
				MsUnLock("ZBM")
			EndIf
		EndIf
	Next
	
	oDlgApr:End()
Return

//������������������������Ŀ
//� APROVA A FICHA TECNICA �
//��������������������������
User Function PCP18A() 
Local   lAut    := .F. //autorizado para aprovar
Private cMotRev := ""

	If ZB5->ZB5_STATUS != "P"
		Alert("A Ficha T�cnica deve estar pendente para aprovar!")
		Return
	EndIf

	//verifica se usu�rio est� autorizado para aprovar	
	ZBM->(DbGoTop())
	WHILE ZBM->(!EOF()) 
		If UPPER(ALLTRIM(ZBM->ZBM_LOGIN))$UPPER(ALLTRIM(CUSERNAME))
			lAut := .T.
			EXIT
		EndIf
		ZBM->(DbSkip())
	ENDDO
	
	If !lAut
		Alert("Usu�rio sem permiss�o para aprovar!")
		Return 
	EndIf

	oDlg  := MsDialog():New(0,0,210,400,"Ficha T�cnica",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(10,10,{||"Motivo Revis�o"},oDlg,,,,,,.T.,CLR_HBLUE,)
	
	oMemo1 := tMultiget():New(22,10,{|u|if(Pcount()>0,cMotRev:=u,cMotRev)},;
		oDlg,183,60,,,,,,.T.,,,{||.T.})
	
	oBtn1 := tButton():New(88,108,"Aprovar" ,oDlg,{||fAprova() },40,10,,,,.T.)
	oBtn2 := tButton():New(88,153,"Cancelar",oDlg,{||oDlg:End()},40,10,,,,.T.)
	oDlg:Activate(,,,.T.,{||.T.},,{||})

Return

//�������������������Ŀ
//� GRAVA A APROVACAO �
//���������������������
Static Function fAprova()
Local cNumFt := ZB5->ZB5_NUM
Local cRev   := ZB5->ZB5_REV
Local nRec   := ZB5->(RecNo())

	If Empty(cMotRev)
		Alert("Informe o motivo da revis�o!")
		Return
	EndIf
		
	ZB5->(DbGoTop())
	ZB5->(DbSetOrder(1)) // filial + numft + rev
	ZB5->(DbSeek(xFilial("ZB5")+cNumFt))

	//Apaga se existir outra revisao anterior
	If ZB5->(Found())
		WHILE ZB5->(!EOF()) .AND. ZB5->ZB5_NUM == cNumFt
			If ZB5->ZB5_ULTREV=="N"
			    RecLock("ZB5",.F.)
			    	ZB5->(DbDelete())
				MsUnlock("ZB5")
			EndIf
			
			ZB5->(DbSkip())
		ENDDO
    EndIf         

	ZB5->(DbGoTo(nRec))
	
	RecLock("ZB5",.F.)
		ZB5->ZB5_STATUS := "A"
		ZB5->ZB5_DTAPRV := Date()
		ZB5->ZB5_APROVA := ALLTRIM(UPPER(CUSERNAME))
	MsUnlock("ZB5")
	oDlg:End()

Return

//�������������������Ŀ
//� VISUALIZA DESENHO �
//���������������������
Static Function fVisuDes(cImg)
Local aQPath    := QDOPATH()
Local cQPathTrm := aQPath[3]
	
	cImg := StrTran(cImg,cStartPath,"")

	If Empty(cImg)
		Alert("Imagem n�o dispon�vel!")
		Return
	EndIf
	
	If File(cImg)
		QA_OPENARQ(cImg)
	ElseIf File(cStartPath+cImg)
		CpyS2T(cStartPath+cImg,cQPathTrm,.T.)
		QA_OPENARQ(cQPathTrm+cImg)
 	Else
		Alert("Imagem n�o encontrada!")
		Return	
	EndIf
		
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GERAFT  �Autor  �Jo�o Felipe          � Data �  18/03/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria uma p�gina HTML para exibir a Ficha T�cnica no IE     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GeraFT() 
Local cPAG     := ""
Local nOFile
Local cArqHtml := AllTrim(StrTran(ZB5->ZB5_NUM,"/","_"))+".html"

	nOFile := Fcreate(cStartPath+cArqHtml)
	
	If !File(cStartPath+StrTran(ZB5->ZB5_NUM,"/","_")+".html")
		Alert("Arquivo principal n�o pode ser criado!")
		Return
	EndIf

	//Cabe�alho padr�o do HTML
	cPAG := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"'
	cPAG += ' "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	cPAG += '<html xmlns="http://www.w3.org/1999/xhtml">'
	cPAG += '<head>'
	cPAG += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
	cPAG += '<title>Ficha T�cnica</title>'

	//Aqui � montada uma p�gina central onde cont�m os links para as folhas de ferramenta
	cPAG += '<body>'
	cPAG += '<table border="1" cellpadding="0" cellspacing="0" width="100%">'

	
	/***********
	* USINAGEM *
	***********/
	If ZB5->ZB5_TIPO=="1"	
	
		//Links dos equipamentos
		cPAG += '  <tr bgcolor="#aabbcc"><td>EQUIPAMENTO</td></tr>'
		
		ZBH->(DbSetOrder(1))//FILIAL + NUMFT + REV + ITEM
		ZBH->(DbSeek(xFilial("ZBH")+ZB5->ZB5_NUM+ZB5->ZB5_REV))
		
		WHILE ZBH->(!EOF()) .AND. ZBH->ZBH_NUM == ZB5->ZB5_NUM .AND. ZBH->ZBH_REV == ZB5->ZB5_REV
			cPag += '<tr><td><a href="'+fMontaFT(1,ZBH->ZBH_ITEM)+'" target="_blank">'+ZBH->ZBH_ITEM+'</a></td></tr>'
			ZBH->(DBSKIP())
		ENDDO
	
		//Links dos dispositivos
	    cPAG += '  <tr bgcolor="#aabbcc"><td>DISPOSITIVO</td></tr>'
	
		ZBG->(DbSetOrder(1))//FILIAL + NUMFT + REV + ITEM
		ZBG->(DbSeek(xFilial("ZBG")+ZB5->ZB5_NUM+ZB5->ZB5_REV))
	
		WHILE ZBG->(!EOF()) .AND. ZBG->ZBG_NUM == ZB5->ZB5_NUM .AND. ZBG->ZBG_REV == ZB5->ZB5_REV
			cPag += '<tr><td><a href="'+fMontaFT(2,ZBG->ZBG_ITEM)+'" target="_blank">'+ZBG->ZBG_ITEM+'</a></td></tr>'
			ZBG->(DBSKIP())
		ENDDO
	
		//Links das ferramentas
		cPAG += '  <tr bgcolor="#aabbcc"><td>FERRAMENTA</td></tr>'
		
		ZBF->(DbSetOrder(1))//FILIAL + NUMFT + REV + ITEM
		ZBF->(DbSeek(xFilial("ZBF")+ZB5->ZB5_NUM+ZB5->ZB5_REV))
	
		WHILE ZBF->(!EOF()) .AND. ZBF->ZBF_NUM == ZB5->ZB5_NUM .AND. ZBF->ZBF_REV == ZB5->ZB5_REV
			cPag += '<tr><td><a href="'+fMontaFT(3,ZBF->ZBF_ITEM)+'" target="_blank">'+ZBF->ZBF_ITEM+'</a></td></tr>'
			ZBF->(DBSKIP())
		ENDDO
	
	/***********
	* LAVADORA *
	***********/
	ElseIf ZB5->ZB5_TIPO=="2"
	
		cPAG += ' <tr bgcolor="#aabbcc"><td>LAVADORA</td></tr>'

		ZD2->(DbSetOrder(1))//FILIAL + NUMFT + REV + ITEM
		ZD2->(DbSeek(xFilial("ZD2")+ZB5->ZB5_NUM+ZB5->ZB5_REV))//ZD2->ZD2_NUM+ZD2->ZD2_REV))
	
		WHILE ZD2->(!EOF()) .AND. ZD2->ZD2_NUM == ZB5->ZB5_NUM .AND. ZD2->ZD2_REV == ZB5->ZB5_REV
			cPag += '<tr><td><a href="'+fMontaFT(4,ZD2->ZD2_ITEM)+'" target="_blank">'+ZD2->ZD2_ITEM+'</a></td></tr>'
			ZD2->(DBSKIP())
		ENDDO

	/**********************************
	* EQUIPAMENTO MONTAGEM / MONTAGEM *
	**********************************/	
	ElseIf ZB5->ZB5_TIPO=="3"
		
		cPAG += ' <tr bgcolor="#aabbcc"><td>EQUIPAMENTO MONTAGEM</td></tr>'

		ZD3->(DbSetOrder(1))//FILIAL + NUMFT + REV + ITEM
		ZD3->(DbSeek(xFilial("ZD3")+ZB5->ZB5_NUM+ZB5->ZB5_REV))
		WHILE ZD3->(!EOF()) .AND. ZD3->ZD3_NUM==ZB5->ZB5_NUM .AND. ZD3->ZD3_REV==ZB5->ZB5_REV
			cPag += '<tr><td><a href="'+fMontaFT(5,ZD3->ZD3_ITEM)+'" target="_blank">'+ZD3->ZD3_ITEM+'</a></td></tr>'
			ZD3->(DBSKIP())
		ENDDO
		
		cPAG += ' <tr bgcolor="#aabbcc"><td>MONTAGEM</td></tr>'

		ZD3->(DbSeek(xFilial("ZD3")+ZB5->ZB5_NUM+ZB5->ZB5_REV))
		WHILE ZD3->(!EOF()) .AND. ZD3->ZD3_NUM==ZB5->ZB5_NUM .AND. ZD3->ZD3_REV==ZB5->ZB5_REV
			cPag += '<tr><td><a href="'+fMontaFT(6,ZD3->ZD3_ITEM)+'" target="_blank">'+ZD3->ZD3_ITEM+'</a></td></tr>'
			ZD3->(DBSKIP())
		ENDDO
	
	/*****************************
	* TESTES / PARAMETROS TESTES *
	*****************************/	
	ElseIf ZB5->ZB5_TIPO=="4"
	
		cPAG += ' <tr bgcolor="#aabbcc"><td>TESTE DE ESTANQUEIDADE</td></tr>'	
		ZD4->(DbSetOrder(1))//FILIAL + NUMFT + REV + ITEM
		ZD4->(DbSeek(xFilial("ZD4")+ZB5->ZB5_NUM+ZB5->ZB5_REV))
		WHILE ZD4->(!EOF()) .AND. ZD4->ZD4_NUM==ZB5->ZB5_NUM .AND. ZD4->ZD4_REV==ZB5->ZB5_REV
			cPag += '<tr><td><a href="'+fMontaFT(7,ZD4->ZD4_ITEM)+'" target="_blank">'+ZD4->ZD4_ITEM+'</a></td></tr>'
			ZD4->(DBSKIP())
		ENDDO
		
		cPAG += ' <tr bgcolor="#aabbcc"><td>PAR�METROS DOS TESTES</td></tr>'

		ZD4->(DbSeek(xFilial("ZD4")+ZB5->ZB5_NUM+ZB5->ZB5_REV))
		WHILE ZD4->(!EOF()) .AND. ZD4->ZD4_NUM==ZB5->ZB5_NUM .AND. ZD4->ZD4_REV==ZB5->ZB5_REV
			cPag += '<tr><td><a href="'+fMontaFT(8,ZD4->ZD4_ITEM)+'" target="_blank">'+ZD4->ZD4_ITEM+'</a></td></tr>'
			ZD4->(DBSKIP())
		ENDDO

	/***********
	* INSPECAO *
	***********/
	ElseIf ZB5->ZB5_TIPO=="5"
	
		cPAG += ' <tr bgcolor="#aabbcc"><td>INSPE��O</td></tr>'	
		ZD5->(DbSetOrder(1))//FILIAL + NUMFT + REV + ITEM
		ZD5->(DbSeek(xFilial("ZD5")+ZB5->ZB5_NUM+ZB5->ZB5_REV))
		WHILE ZD5->(!EOF()) .AND. ZD5->ZD5_NUM==ZB5->ZB5_NUM .AND. ZD5->ZD5_REV==ZB5->ZB5_REV
			cPag += '<tr><td><a href="'+fMontaFT(9,ZD5->ZD5_ITEM)+'" target="_blank">'+ZD5->ZD5_ITEM+'</a></td></tr>'
			ZD5->(DBSKIP())
		ENDDO

	EndIf
	cPAG += '</table>'
	cPAG += '</body>'

	Fwrite(nOFile,cPAG)
	
	FClose(nOFile)

	ShellExecute( "open", "iexplore.exe","\\192.168.1.14\Protheus10\Protheus_Data\system\FT\"+cArqHtml,"",5 )

Return

Static Function fMontaFT(nParam,cItm)
Local nPar      := nParam //1=equipamento, 2=dispositivo, 3=ferramentas
Local cHTML     := ""
Local nOutFile
Local cImg1     := ""
Local _aFicha   := {"maq","dis","fer","lav","mon","emo","tes","pte","ins"}
Local cLink     := ""
Local cArqHtml  := AllTrim(StrTran(ZB5->ZB5_NUM,"/","_"))+_aFicha[nPar]+cItm+".html"
Local cZD8Item  := ""

	nOutFile := Fcreate(cStartPath+cArqHtml)
	
	If !File(cStartPath+StrTran(ZB5->ZB5_NUM,"/","_")+_aFicha[nPar]+cItm+".html")
		Alert("Arquivo n�o pode ser criado.")
		Return
	EndIf
		
	//Cabe�alho padr�o do HTML
	cHTML := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"'
	cHTML += ' "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	cHTML += '<html xmlns="http://www.w3.org/1999/xhtml">'
	cHTML += '<head>'
	cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
	cHTML += '<title>Ficha T�cnica</title>'
	
	//Folha de estilos
	cHTML += '<style type="text/css">'
	cHTML += 'body{'
	cHTML += '	margin:0px;'
	cHTML += '	font-family:Arial, Helvetica, sans-serif;'
	cHTML += '	font-size:12PX'
	cHTML += '}'
	
	cHTML += '#tab_principal{'
	cHTML += '  table-layout:fixed;'
	cHTML += '	width:1430px;'
	cHTML += '	height:960px;'
//	cHTML += '	margin:5px;'
	cHTML += '}'
	
	cHTML += '#td_cabec{'
	cHTML += '  height:17%;
	cHTML += '}'
	
	cHTML += '#td_corpo{'
	cHTML += '  height:83%;
	cHTML += '}'

	cHTML += '.titulo{'
	cHTML += ' 	height:50%;'
	cHTML += '  font-size:12px;'
	cHTML += '  vertical-align:top'
	cHTML += '}'
	
	cHTML += '.info{'
//	cHTML += '  height:50%;'
	cHTML += '	font-weight:bold;'
	cHTML += '  vertical-align:middle'
	cHTML += '}'

	cHTML += '.info_bd{'
	cHTML += '	font-weight:bold;
	cHTML += '  font-size:14px;
	cHTML += '}'

	cHTML += '</style>'
	cHTML += '</head>'
	
	//Corpo do documento
	cHTML += '<body>'
	
	//�����������������Ŀ
	//� CABECALHO DA FT �
	//�������������������

	cHTML += '<table id="tab_principal" cellpadding="0" cellspacing="0"><tr><td id="td_cabec">'
	cHTML += '  <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="1"><tr>'
	cHTML += '    <td rowspan="4" align="center">'
	cHTML += '      <img src="file://192.168.1.14/Protheus10/Protheus_data/System/WHBL.bmp" width="150" height="62"/>'
	cHTML += '    </td>'
	cHTML += '    <td align="center" colspan="6" height="25%" style="font-size:18px">'

	If nPar==1
		cHTML += '      <strong>FICHA T�CNICA DE FABRICA��O - EQUIPAMENTO</strong>'
	ElseIf nPar==2
		cHTML += '      <strong>FICHA T�CNICA DE FABRICA��O - DISPOSITIVO</strong>'
	ElseIf nPar==3
		cHTML += '      <strong>FICHA T�CNICA DE FABRICA��O - FERRAMENTAS</strong>'
	ElseIf nPar==4
		cHTML += '      <strong>FICHA T�CNICA DE FABRICA��O - LAVADORA</strong>'
	ElseIf nPar==5
		cHTML += '      <strong>FICHA T�CNICA DE FABRICA��O - EQUIPAMENTO MONTAGEM</strong>'
	ElseIf nPar==6
		cHTML += '      <strong>FICHA T�CNICA DE FABRICA��O - MONTAGEM</strong>'
	ElseIf nPar==7
		cHTML += '      <strong>FICHA T�CNICA DE FABRICA��O - TESTE DE ESTANQUEIDADE</strong>'
	ElseIf nPar==8
		cHTML += '      <strong>FICHA T�CNICA DE FABRICA��O - PAR�METROS TESTE DE ESTANQUEIDADE</strong>'
	ElseIf nPar==9
		cHTML += '      <strong>FICHA T�CNICA DE FABRICA��O - INSPE��O</strong>'
	EndIf

	cHTML += '    </td>'

	cHTML += '  </tr>'
	cHTML += '  <tr>'

	cHTML += '    <td height="25%">'
	cHTML += '      <div align="left" class="titulo">N� Documento</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:18px">'+ZB5->ZB5_NUM+'</span></div>'
	cHTML += '    </td>'
	cHTML += '    <td rowspan="3" width="80px" height="75%">'
	cHTML += '      <div class="titulo">OP. N�:</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:38px">'+ZB5->ZB5_OP+'</span></dov>'
	cHTML += '    </td>'
	cHTML += '    <td height="25%">'
	cHTML += '      <div class="titulo">N� PE�A WHB: </div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:16px">'+ZB5->ZB5_PECA+'</span></div>'
	cHTML += '    </td>'
	
	SB1->(DbSetOrder(1))//Filial + Cod
	SB1->(DBSEEK(xFilial("SB1")+ZB5->ZB5_PECA))
	
	cHTML += '    <td height="25%">'
	cHTML += '      <div class="titulo">NOME DA PE�A:</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:16px">'+SB1->B1_DESC+'</span>'
	cHTML += '    </td>'
	cHTML += '    <td height="25%">'
	cHTML += '      <div class="titulo">N� PE�A CLIENTE:</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:16px">'+SB1->B1_CODAP5+'</span>'
	cHTML += '    </td>'
	cHTML += '    <td height="25%">'
	cHTML += '      <div style="titulo">P�G.</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:16px">1/1</span></div>'
	cHTML += '    </td>'

	cHTML += '  </tr>'
	cHTML += '  <tr>'

	cHTML += '    <td rowspan="2" height="50%">'
	cHTML += '      <div class="titulo">Descri��o da Opera��o:</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:16px">'+ZB5->ZB5_OPDESC+'</span></div>'
	cHTML += '    </td>'
	cHTML += '    <td rowspan="2" height="50%">'
	cHTML += '      <div class="titulo">ELABORADO POR:</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:16px">'+ZB5->ZB5_ELABOR+'</span></div>'
	cHTML += '    </td>'
	cHTML += '    <td rowspan="2" height="50%">'
	cHTML += '      <div class="titulo">DATA ELABORA��O:</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:16px">'+DTOC(ZB5->ZB5_DTELAB)+'</span></div>'
	cHTML += '    </td>'
	cHTML += '    <td colspan="2" height="25%">'
	cHTML += '      <div class="titulo">TEMPO CICLO:</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:16px">'+ZB5->ZB5_TCICLO+' MIN</span></div>'
	cHTML += '    </td>'

	cHTML += '  </tr>'
	cHTML += '  <tr>'

	cHTML += '    <td height="25%">'
	cHTML += '      <div class="titulo">APROVADO POR:</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:16px">'+ZB5->ZB5_APROVA+'</span></div>'
	cHTML += '    </td>'
	cHTML += '    <td height="25%">'
	cHTML += '      <div class="titulo">DATA APROVA��O:</div>'
	cHTML += '      <div align="center" class="info"><span style="font-size:16px">'+DTOC(ZB5->ZB5_DTAPRV)+'</span></div>'
	cHTML += '    </td>'

	cHTML += '  </tr>'
	cHTML += '</table></td></tr>'

	cHTML += '<tr><td id="td_corpo">'
	cHTML += '<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="1" style="border-collapse:collapse">'
	
	//���������������
	//� EQUIPAMENTO �
	//���������������
	If nPar == 1
		
		ST9->(DbSetOrder(1))//FILIAL + CODBEM
		ST9->(DbSeek(xFilial("ST9")+ZBH->ZBH_BEM))

		cHTML += '  <tr >'
		cHTML += '    <td width="70%" align="center" height="6%"><strong>LAY OUT DE EQUIPAMENTO</strong></td>'
		cHTML += '    <td width="30%" colspan="3" align="center"><strong>VALORES DE REFER�NCIA</strong></td>'
		cHTML += '  </tr >'
		
		cImg1 := STRTRAN(UPPER(ZBH->ZBH_IMG01),"\SYSTEM\FT\","")
	
		cHTML += '  <tr >'
		cHTML += '    <td rowspan="30" align="center" height="94%">'

		If File(cStartPath+cImg1)
			cHTML += '  	<img src="'+cImg1+'" width="1000" height="700"/>'
		Else
			cHTML += '&nbsp;Sem Imagem'
		EndIf

		cHTML += '    </td>'
		cHTML += '  </tr >'
	
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">N� M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZBH->ZBH_BEM+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">DESCRI��O DA M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+Substr(ST9->T9_NOME,1,30)+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">LOCALIZA��O DA M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;X: '+STR(ST9->T9_POSX)+', Y:'+STR(ST9->T9_POSY)+' </span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">N� PROGRAMA PALLET 1: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZBH->ZBH_PROGP1+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">N&ordm;. PROGRAMA PALLET 2: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZBH->ZBH_PROGP2+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>
		cHTML += '    <td colspan="2">CONCENTRA��O DE �LEO SOL�VEL: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+STR(ZBH->ZBH_CONSOS)+'%</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">PRESS�O REFRIGERA��O INTERNA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+Lower(ZBH->ZBH_PRESRI)+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">PRESS�O AR COMPRIMIDO: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+STR(ZBH->ZBH_PRESAC)+'bar</span></td>'
		cHTML += '  </tr>'
		
		For _x := 1 to 18
			cHTML += '	  <tr>'
			cHTML += '	    <td colspan="2">&nbsp;</td>'
			cHTML += '	    <td>&nbsp;</td>'
			cHTML += '	  </tr>'
		Next

	ElseIf nPar == 2 //dispositivo

		cHTML += '  <tr>'
		cHTML += '    <td width="70%" height="6%" align="center"><strong>ESQUEMA DE FIXA��O E LOCALIZA��O</strong></td>'
		cHTML += '    <td width="30%" colspan="3" align="center"><strong>VALORES DE REFER�NCIA</strong></td>'
		cHTML += '  </tr>'
		
		cImg1 := STRTRAN(UPPER(ZBG->ZBG_IMG01),"\SYSTEM\FT\","")
	
		cHTML += '  <tr >'
		cHTML += '    <td rowspan="32" align="center" height="87%">'
 
		If File(cStartPath+cImg1)
			cHTML += '  	<img src="'+cImg1+'" width="925" height="645"/>'		
		Else
			cHTML += '&nbsp;Sem Imagem'
		EndIf

		cHTML += '    </td>'
		cHTML += '  </tr >'
	
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">N� DISPOSITIVO PALLET 1: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZBG->ZBG_NDISP1+' - '+ZBG->ZBG_LETRA1+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">N� DISPOSITIVO PALLET 2: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZBG->ZBG_NDISP2+' - '+ZBG->ZBG_LETRA2+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">PRESS�O DE FIXA��O DISPOSITIVO 1: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+STR(ZBG->ZBG_PFIXD1)+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">PRESS�O DE FIXA��O DISPOSITIVO 2: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+STR(ZBG->ZBG_PFIXD2)+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">QUANTIDADE DE PE�AS/DISPOSITIVO </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+STR(ZBG->ZBG_QTDPCD)+'</span></td>'
		cHTML += '  </tr>'

		For _x := 1 to 23
			cHTML += '	  <tr >'
			cHTML += '	    <td colspan="2">&nbsp;</td>'
			cHTML += '	    <td>&nbsp;</td>'
			cHTML += '	  </tr>'
		Next

	ElseIf nPar == 3 //ferramenta
		
		cHTML += '  <tr>'
		cHTML += '    <td align="center" height="6%"><strong>LAYOUT DE FERRAMENTA / LOCALIZA��O DE USINAGEM</strong></td>'
		cHTML += '    <td align="center"><strong>N� MONTAGEM '+ZBF->ZBF_NUMONT+'</strong></td>'
		cHTML += '    <td align="center"><strong>Coordenadas de Usinagem</strong></td>'
  		cHTML += '  </tr>'

		ZBJ->(DbSetOrder(1))
		ZBJ->(DbSeek(xFilial("ZBJ")+ZBF->ZBF_NUMONT))
		
		cImg1 := STRTRAN(UPPER(ZBJ->ZBJ_IMG01),"\SYSTEM\FT\","")
		cImg2 := STRTRAN(UPPER(ZBF->ZBF_IMG02),"\SYSTEM\FT\","")
	
		cHTML += '  <tr>'
		cHTML += '    <td align="center" height="47%">'

		If File(cStartPath+cImg1)
			cHTML += '  	<img src="'+cImg1+'" width="500" height="350"/>'
		Else
			cHTML += '&nbsp;Sem Imagem'
		EndIf

		cHTML += '    </td>'
		cHTML += '    <td height="47%">'

		//ITENS DA MONTAGEM DE FERRAMENTAS
		
		cHTML += '      <table cellpadding="0" cellspacing="0" width="100%" height="100%" border="1" style="border-collapse:collapse">'
		cHTML += '        <tr style="font-weight:bold">'
		cHTML += '          <td align="center">QTDE.</td>'
		cHTML += '  	    <td align="center">DESCRI��O</td>'
		cHTML += '  	    <td align="center">POS.</td>'
		cHTML += '  	    <td align="center">C�DIGO WHB</td>'
		cHTML += '        </tr>'

		nItens := 0

		ZBC->(DbSetOrder(1)) //FILIAL + NUMONT + ITEM
		If ZBC->(DbSeek(xFilial("ZBC")+ZBF->ZBF_NUMONT))

			SB1->(DBSETORDER(1))
			
			While ZBC->(!EOF()) .AND. ZBC->ZBC_NUMONT == ZBF->ZBF_NUMONT

				cHTML += '	      <tr>'
				cHTML += '	        <td align="center">'+ALLTRIM(STR(ZBC->ZBC_QTDE))+'</td>'
			
				IF SB1->(DbSeek(xFilial("SB1")+ZBC->ZBC_COD))
					cHTML += '  	    <td>'+SB1->B1_DESC+'</td>'
				Else
					cHTML += '          <td>&nbsp;</td>'
				EndIf
			
				cHTML += '	        <td align="center">'+ALLTRIM(STR(ZBC->ZBC_POS))+'</td>'
				cHTML += '	        <td>'+ZBC->ZBC_COD+'</td>'    
				cHTML += '        </tr>'
			        
				nItens++
				
				ZBC->(DbSkip())
			ENDDO		
		ENDIF
    	
		For _x := 1 to (14-nItens)
			cHTML += '	      <tr>'
			cHTML += '	        <td>&nbsp;</td>'
			cHTML += '  	    <td>&nbsp;</td>'    
			cHTML += '	        <td>&nbsp;</td>'
			cHTML += '	        <td>&nbsp;</td>'    
			cHTML += '        </tr>'
		Next

		cHTML += '      </table>'
		cHTML += '    </td>'
		cHTML += '    <td rowspan="2" height="94%">'		

		//COORDENADAS DE USINAGEM
		
		cHTML += '      <table cellpadding="0" cellspacing="0" width="100%" border="1" height="100%" style="border-collapse:collapse">'
		cHTML += '        <tr style="font-weight:bold">'
		cHTML += '  	    <td align="center">X</td>'
		cHTML += '  	    <td align="center">Y</td>'
		cHTML += '  	    <td align="center">Z</td>'
		cHTML += '  	    <td align="center">N� FURO</td>'
		cHTML += '        </tr>'
                
		nItens := 0

		ZBE->(DbSetOrder(1)) // FILIAL + NUMFT + REV + NUMONT + ITEM
		IF ZBE->(DbSeek(xFilial("ZBE")+ZB5->ZB5_NUM+ZB5->ZB5_REV+ZBF->ZBF_NUMONT))
			While ZBE->(!EOF()) .AND. ZB5->ZB5_NUM == ZBE->ZBE_NUM .AND. ZBE->ZBE_NUMONT == ZBF->ZBF_NUMONT .AND. ZBF->ZBF_REV == ZB5->ZB5_REV
			
				cHTML += '        <tr>'
				cHTML += '	        <td align="center">'+ALLTRIM(STR(ZBE->ZBE_X))+'</td>'
				cHTML += '  	    <td align="center">'+ALLTRIM(STR(ZBE->ZBE_Y))+'</td>'    
				cHTML += '	        <td align="center">'+ALLTRIM(STR(ZBE->ZBE_Z))+'</td>'
				cHTML += '	        <td align="center">'+ALLTRIM(STR(ZBE->ZBE_NFURO))+'</td>'    
				cHTML += '	      </tr>'
				
				nItens++
				
                ZBE->(DbSkip())
		    EndDo
        EndIf
        
		For _x := 1 to (30-nItens)
			cHTML += '        <tr>'
			cHTML += '	        <td>&nbsp;</td>'
			cHTML += '  	    <td>&nbsp;</td>'    
			cHTML += '	        <td>&nbsp;</td>'
			cHTML += '	        <td>&nbsp;</td>'    
			cHTML += '	      </tr>'
		Next

		cHTML += '      </table>'
		cHTML += '    </td>'
		cHTML += '  </tr>'

		cHTML += '  <tr >'
		cHTML += '    <td align="center">'

		If File(cStartPath+cImg2)
			cHTML += '  	<img src="'+cImg2+'" width="500" height="350"/>'
		Else
			cHTML += '&nbsp;Sem Imagem'
		EndIf

		cHTML += '    </td>'

		cHTML += '    <td height="47%">'		

		//VARI�VEIS DO PROCESSO
		
		cHTML += '      <table cellpadding="0" cellspacing="0" width="100%" height="100%" border="1" style="border-collapse:collapse">'

		cHTML += '	      <tr style="font-weight:bold">'
		cHTML += '	        <td align="center">�</td>'
		cHTML += '	        <td align="center">vc</td>'
		cHTML += '	        <td align="center">n</td>'
		cHTML += '	        <td align="center">z</td>'
		cHTML += '	        <td align="center">fz</td>'
		cHTML += '	        <td align="center">vf</td>'
		cHTML += '	        <td align="center">&nbsp;</td>'
		cHTML += '	      </tr>'

		cHTML += '	      <tr>'
		cHTML += '	        <td>&nbsp;</td>'
		cHTML += '	        <td align="center">m/min</td>'    
		cHTML += '	        <td align="center">rpm</td>'
		cHTML += '	        <td align="center">qtde. dentes</td>'    
		cHTML += '	        <td align="center">mm/dente</td>'
		cHTML += '	        <td align="center">mm/min</td>'    
		cHTML += '	        <td align="center">Vida �til / P�</td>'
		cHTML += '	      </tr>'
		             
		nItens := 0
		
		ZBD->(DbSetOrder(1)) // FILIAL + NUMFT + REV + NUMONT + ITEM
		If ZBD->(DbSeek(xFilial("ZBD")+ZB5->ZB5_NUM+ZB5->ZB5_REV+ZBF->ZBF_NUMONT))
		
			While ZBD->(!EoF()) .AND. ZBD->ZBD_NUM == ZB5->ZB5_NUM .AND. ZBD->ZBD_NUMONT == ZBF->ZBF_NUMONT .AND. ZBF->ZBF_REV == ZB5->ZB5_REV
			
				cHTML += '	  <tr>'
				cHTML += '	    <td align="center">'+ALLTRIM(STR(ZBD->ZBD_DIAMET))+'</td>'
				cHTML += '	    <td align="center">'+ALLTRIM(STR(ZBD->ZBD_VC))+'</td>'    
				cHTML += '	    <td align="center">'+ALLTRIM(STR(ZBD->ZBD_RPM))+'</td>'
				cHTML += '	    <td align="center">'+ALLTRIM(STR(ZBD->ZBD_QDENTE))+'</td>'    
				cHTML += '	    <td align="center">'+ALLTRIM(STR(ZBD->ZBD_MMDENT))+'</td>'
				cHTML += '	    <td align="center">'+ALLTRIM(STR(ZBD->ZBD_MMMIN))+'</td>'
				cHTML += '	    <td align="center">'+ALLTRIM(STR(ZBD->ZBD_VIDA))+'</td>'
				cHTML += '	  </tr>'
			
				nItens++
    	    	ZBD->(DbSkip())

    		EndDo
   		EndIf
   		
		For _x := 1 to (11-nItens)
			cHTML += '	  <tr>'
			cHTML += '	    <td>&nbsp;</td>'
			cHTML += '	    <td>&nbsp;</td>'    
			cHTML += '	    <td>&nbsp;</td>'
			cHTML += '	    <td>&nbsp;</td>'    
			cHTML += '	    <td>&nbsp;</td>'
			cHTML += '	    <td>&nbsp;</td>'    
			cHTML += '	    <td>&nbsp;</td>'
			cHTML += '	  </tr>'
		Next

		cHTML += '    <tr>'
		cHTML += '      <td colspan="7" align="center">REVIS�ES</td>'
		cHTML += '    </tr>'

    	cHTML += '    <tr>'
	    cHTML += '      <td colspan="2">MOTIVO:</td>'
	    cHTML += '      <td colspan="5">'+ZB5->ZB5_MOTREV+'</td>'
    	cHTML += '    </tr>'
	    
    	cHTML += '    <tr>'
	    cHTML += '      <td>REV.:</td>'
	    cHTML += '      <td colspan="2">'+ZB5->ZB5_REV+'</td>'
	    cHTML += '      <td>DATA</td>'
	    cHTML += '      <td>'+DTOC(ZB5->ZB5_DTREV)+'</td>'
	    cHTML += '      <td>RESPONS.</td>'
	    cHTML += '      <td>'+ZB5->ZB5_RESREV+'</td>'
    	cHTML += '    </tr>'

	EndIf

	//������������
	//� LAVADORA �
	//������������
	If nPar==4
		
		ST9->(DbSetOrder(1))//FILIAL + CODBEM
		ST9->(DbSeek(xFilial("ST9")+ZD2->ZD2_BEM))

		cHTML += '  <tr >'
		cHTML += '    <td width="70%" align="center" height="6%"><strong>LAY OUT DE EQUIPAMENTO</strong></td>'
		cHTML += '    <td width="30%" colspan="3" align="center"><strong>VALORES DE REFER�NCIA</strong></td>'
		cHTML += '  </tr >'
		
		cImg1 := STRTRAN(UPPER(ZD2->ZD2_IMG01),"\SYSTEM\FT\","")
	
		cHTML += '  <tr >'
		cHTML += '    <td rowspan="32" align="center" height="94%">'

		If File(cStartPath+cImg1)
			cHTML += '  	<img src="'+cImg1+'" width="1000" height="700"/>'
		Else
			cHTML += '&nbsp;Sem Imagem'
		EndIf

		cHTML += '    </td>'
		cHTML += '  </tr >'
	
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">N� M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZD2->ZD2_BEM+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">DESCRI��O DA M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ST9->T9_NOME+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">LOCALIZA��O DA M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;X: '+STR(ST9->T9_POSX)+', Y:'+STR(ST9->T9_POSY)+' </span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">PRODUTO DO BANHO: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZD2->ZD2_PRDBAN+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">TEMPERATURA DO BANHO: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZD2->ZD2_TEMBAN+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>
		cHTML += '    <td colspan="2">CONCENTRA��O DO BANHO: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZD2->ZD2_CONBAN+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">TEMPO DE LAVAGEM (segundos): </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+STR(ZD2->ZD2_TLAVAG)+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">TEMPO DE SECAGEM (segundos): </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+STR(ZD2->ZD2_TSECAG)+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">TEMPO DE SOPRO (segundos): </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+STR(ZD2->ZD2_TSOPRO)+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">PRESS�O (bar): </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+STR(ZD2->ZD2_PRESSA)+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">PE�AS POR CICLO: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+STR(ZD2->ZD2_PCCICL)+'</span></td>'
		cHTML += '  </tr>'
		
		For _x := 1 to 17
			cHTML += '	  <tr >
			cHTML += '	    <td colspan="2">&nbsp;</td>
			cHTML += '	    <td>&nbsp;</td>    
			cHTML += '	  </tr>
		Next

	EndIf
	
	//������������������������
	//� EQUIPAMENTO MONTAGEM �
	//������������������������
	If nPar==5
		
		ST9->(DbSetOrder(1))//FILIAL + CODBEM
		ST9->(DbSeek(xFilial("ST9")+ZD3->ZD3_BEM))

		cHTML += '  <tr >'
		cHTML += '    <td width="70%" align="center" height="6%"><strong>LAY OUT DE EQUIPAMENTO DE MONTAGEM</strong></td>'
		cHTML += '    <td width="30%" colspan="3" align="center"><strong>VALORES DE REFER�NCIA</strong></td>'
		cHTML += '  </tr >'
		
		cImg1 := STRTRAN(UPPER(ZD3->ZD3_IMG01),"\SYSTEM\FT\","")
	
		cHTML += '  <tr >'
		cHTML += '    <td rowspan="32" align="center" height="94%">'

		If File(cStartPath+cImg1)
			cHTML += '  	<img src="'+cImg1+'" width="1000" height="700"/>'
		Else
			cHTML += '&nbsp;Sem Imagem'
		EndIf

		cHTML += '    </td>'
		cHTML += '  </tr >'
	
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">N� M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZD3->ZD3_BEM+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">DESCRI��O DA M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ST9->T9_NOME+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">LOCALIZA��O DA M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;X: '+STR(ST9->T9_POSX)+', Y:'+STR(ST9->T9_POSY)+' </span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">PRESS�O UNIDADE HIDR�ULICA/PNEUM�TICA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZD3->ZD3_PUHD+' Bar</span></td>'
		cHTML += '  </tr>'
		
		For _x := 1 to 24
			cHTML += '	  <tr >
			cHTML += '	    <td colspan="2">&nbsp;</td>
			cHTML += '	    <td>&nbsp;</td>    
			cHTML += '	  </tr>
		Next

	EndIf
    
	//������������
	//� MONTAGEM �
	//������������
	If nPar==6
		
		ST9->(DbSetOrder(1))//FILIAL + CODBEM
		ST9->(DbSeek(xFilial("ST9")+ZD3->ZD3_BEM))

		cHTML += '  <tr >'
		cHTML += '    <td width="70%" align="center" height="6%"><strong>LAY OUT DE EQUIPAMENTO DE MONTAGEM</strong></td>'
		cHTML += '    <td width="30%" colspan="4" align="center"><strong>VALORES DE REFER�NCIA</strong></td>'
		cHTML += '  </tr >'
		
		cImg1 := ""//STRTRAN(UPPER(ZD3->ZD3_IMG01),"\SYSTEM\FT\","")
	
		cHTML += '  <tr >'
		cHTML += '    <td rowspan="32" align="center" height="94%">'

		If File(cStartPath+cImg1)
			cHTML += '  	<img src="'+cImg1+'" width="1000" height="700"/>'
		Else
			cHTML += '&nbsp;Sem Imagem'
		EndIf

		cHTML += '    </td>'
		cHTML += '  </tr >'
	
		cHTML += '  <tr>'
		cHTML += '    <td align="center">QTDE. </td>'
		cHTML += '    <td align="center">DESCRI��O</td>'
		cHTML += '    <td align="center">POS</td>'
		cHTML += '    <td align="center">C�DIGO WHB</td>'
		cHTML += '  </tr>'
		                                         
		ZD6->(dbSetOrder(1)) //FILIAL + NUM + REV + ITEMFT + ITEM
		ZD6->(dbSeek(xFilial("ZD6")+ZB5->ZB5_NUM+ZB5->ZB5_REV+ZD3->ZD3_ITEM))
		
		nItem := 0
		
		SB1->(dbSetOrder(1)) //filial + cod 
		While ZD6->(!Eof()) .AND. ZD6->ZD6_NUM==ZB5->ZB5_NUM .AND. ZD6->ZD6_REV==ZB5->ZB5_REV .AND. ZD6->ZD6_ITEMFT==ZD3->ZD3_ITEM
		
			SB1->(dbSeek(xFilial("SB1")+ZD6->ZD6_COD))
		    cHTML += '  <tr>'
			cHTML += '    <td>'+STR(ZD6->ZD6_QTDE)+'</td>'
			cHTML += '    <td>'+SB1->B1_DESC+'</td>'
			cHTML += '    <td>'+STR(ZD6->ZD6_POS)+'</td>'
			cHTML += '    <td>'+ZD6->ZD6_COD+'</td>'
		    cHTML += '  </tr>'
		    
		    nItem++
			
			ZD6->(dbSkip())
		EndDo
		
		For _x := 1 to (27-nItem)
			cHTML += '	  <tr >
			cHTML += '	    <td colspan="4">&nbsp;</td>
			cHTML += '	  </tr>
		Next
		
		//REVISAO
		cHTML += '    <tr>'
		cHTML += '      <td colspan="4" align="center">REVIS�ES</td>'
		cHTML += '    </tr>'
		    
		cHTML += '    <tr>'
		cHTML += '      <td>MOTIVO:</td>'
		cHTML += '      <td colspan="3">'+ZB5->ZB5_MOTREV+'</td>'
		cHTML += '    </tr>'

		cHTML += '    <tr>'
		cHTML += '      <td>REV.: '+ZB5->ZB5_REV+'</td>'
		cHTML += '      <td>DATA: '+DTOC(ZB5->ZB5_DTREV)+'</td>'
		cHTML += '      <td colspan="2">RESPONS.: '+ZB5->ZB5_RESREV+'</td>'
		cHTML += '    </tr>'

	EndIf
	
	//����������
	//� TESTES �
	//����������
	If nPar==7
		
		ST9->(DbSetOrder(1))//FILIAL + CODBEM
		ST9->(DbSeek(xFilial("ST9")+ZD4->ZD4_BEM))

		cHTML += '  <tr >'
		cHTML += '    <td width="70%" align="center" height="6%"><strong>LAY OUT DE EQUIPAMENTO</strong></td>'
		cHTML += '    <td width="30%" colspan="4" align="center"><strong>VALORES DE REFER�NCIA</strong></td>'
		cHTML += '  </tr >'
		
		cImg1 := STRTRAN(UPPER(ZD4->ZD4_IMG01),"\SYSTEM\FT\","")
	
		cHTML += '  <tr >'
		cHTML += '    <td rowspan="32" align="center" height="94%">'

		If File(cStartPath+cImg1)
			cHTML += '  	<img src="'+cImg1+'" width="1000" height="700"/>'
		Else
			cHTML += '&nbsp;Sem Imagem'
		EndIf

		cHTML += '    </td>'
		cHTML += '  </tr >'
	
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">N� M�QUINA: </td>'
		cHTML += '    <td colspan="2"><span class="info_bd">&nbsp;'+ZD4->ZD4_BEM+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">DESCRI��O DA M�QUINA: </td>'
		cHTML += '    <td colspan="2"><span class="info_bd">&nbsp;'+ST9->T9_NOME+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">LOCALIZA��O DA M�QUINA: </td>'
		cHTML += '    <td colspan="2"><span class="info_bd">&nbsp;X: '+STR(ST9->T9_POSX)+', Y:'+STR(ST9->T9_POSY)+' </span></td>'
		cHTML += '  </tr>'

		cHTML += '  <tr>'
		cHTML += '    <td align="center">QTDE. </td>'
		cHTML += '    <td align="center">DESCRI��O</td>'
		cHTML += '    <td align="center">POS</td>'
		cHTML += '    <td align="center">C�DIGO WHB</td>'
		cHTML += '  </tr>'
		                                         
		ZD7->(dbSetOrder(1)) //FILIAL + NUM + REV + ITEMFT + ITEM
		ZD7->(dbSeek(xFilial("ZD7")+ZB5->ZB5_NUM+ZB5->ZB5_REV+ZD4->ZD4_ITEM))

		nItem := 0
		
		SB1->(dbSetOrder(1)) //filial + cod 
		While ZD7->(!Eof()) .AND. ZD7->ZD7_NUM==ZB5->ZB5_NUM .AND. ZD7->ZD7_REV==ZB5->ZB5_REV .AND. ZD7->ZD7_ITEMFT==ZD4->ZD4_ITEM
		
			SB1->(dbSeek(xFilial("SB1")+ZD7->ZD7_COD))
		    cHTML += '  <tr>'
			cHTML += '    <td>'+STR(ZD7->ZD7_QTDE)+'</td>'
			cHTML += '    <td>'+SB1->B1_DESC+'</td>'
			cHTML += '    <td>'+STR(ZD7->ZD7_POS)+'</td>'
			cHTML += '    <td>'+ZD7->ZD7_COD+'</td>'
		    cHTML += '  </tr>'
		    
		    nItem++
			
			ZD7->(dbSkip())
		EndDo
		
		For _x := 1 to (23-nItem)
			cHTML += '	  <tr >
			cHTML += '	    <td colspan="4">&nbsp;</td>
			cHTML += '	  </tr>
		Next
		
		//REVISAO
		cHTML += '    <tr>'
		cHTML += '      <td colspan="4" align="center">REVIS�ES</td>'
		cHTML += '    </tr>'
		    
		cHTML += '    <tr>'
		cHTML += '      <td>MOTIVO:</td>'
		cHTML += '      <td colspan="3">'+ZB5->ZB5_MOTREV+'</td>'
		cHTML += '    </tr>'

		cHTML += '    <tr>'
		cHTML += '      <td>REV.: '+ZB5->ZB5_REV+'</td>'
		cHTML += '      <td>DATA: '+DTOC(ZB5->ZB5_DTREV)+'</td>'
		cHTML += '      <td colspan="2">RESPONS.: '+ZB5->ZB5_RESREV+'</td>'
		cHTML += '    </tr>'

	EndIf
	
	//������������������������
	//� PARAMETROS DE TESTES �
	//������������������������
	If nPar==8
		
		cHTML += '  <tr>'
		cHTML += '    <td width="100%" align="center" height="5%"><strong>PAR�METROS DOS TESTES</strong></td>'
		cHTML += '  </tr >'

		cHTML += '  <tr>'
		cHTML += '    <td height="95%">'
		cHTML += '      <table cellpadding="0" cellspacing="10" width="100%" height="100%">'
		cHTML += '       <tr>'
                                                                            
		aParam := {}
		_x     := 0
		
		ZD8->(dbSetOrder(1)) // FILIAL + NUMFT + REV + ITEMFT + ITEM + LETRA
		ZD8->(dbSeek(xFilial("ZD8")+ZB5->ZB5_NUM+ZB5->ZB5_REV+ZB4->ZB4_ITEM))
		While ZD8->(!EOF()) .AND. ZD8->ZD8_NUM==ZB5->ZB5_NUM .AND. ZD8->ZD8_REV==ZB5->ZB5_REV .AND. ZD8->ZD8_ITEMFT==ZD4->ZD4_ITEM .AND. _x < 8
        	aAdd(aParam,{ZD8->ZD8_TIPO, ZD8->ZD8_MEDIDO,ZD8->ZD8_PROG,{}})

            cZD8Item := ZD8->ZD8_ITEM
			
			While ZD8->(!EOF()) .AND. ZD8->ZD8_NUM==ZB5->ZB5_NUM .AND. ZD8->ZD8_REV==ZB5->ZB5_REV .AND. ZD8->ZD8_ITEMFT==ZD4->ZD4_ITEM .AND. ZD8->ZD8_ITEM==cZD8Item
				aAdd(aParam[len(aParam)][4],{ZD8->ZD8_LETRA,ZD8->ZD8_PARAM,ZD8->ZD8_VALOR})

				ZD8->(dbSkip())
			EndDo

  			_x++
  		EndDo
  		
  		//faz o aParam ficar com 8 posicoes
  		For x:=1 to (8-_x)
  			aAdd(aParam,{"","","","","",""})
  		Next
 		  
 		_x := 0
 		
		For x:=1 to len(aParam) //len(aParam) deve ser == 8
		
			cHTML += '    <td width="25%" height="45%" valign="top">
			cHTML += '      <table border="1" style="border-collapse:collapse" width="100%" height="100%">'
			cHTML += '        <tr>'
			cHTML += '          <td colspan="3" align="center">'
			cHTML += '            <strong>Tipo de Teste: </strong>'+aParam[x][1]+' <br />'
			cHTML += '            <strong>Medidor: </strong>'+aParam[x][2]+'     <br />'
			cHTML += '            <strong>Programa: </strong>'+aParam[x][3]+'      <br />'
			cHTML += ' 	  	    </td>'
			cHTML += '        </tr>'
			cHTML += '        <tr>'
			cHTML += '          <td align="center"><strong>Item</strong></td>'
			cHTML += '          <td><strong>Par�metro</strong></td>'
			cHTML += '          <td><strong>Valor</strong></td>'
			cHTML += '        </tr>'		

            nLetras  := 0
			
			For y:=1 to Iif(len(aParam[x][4])<=12,len(aParam[x][4]),12)
			
			
				cHTML += '        <tr>'
				cHTML += '          <td align="center">'+aParam[x][4][y][1]+'</td>'
				cHTML += '          <td>'+aParam[x][4][y][2]+'</td>'
				cHTML += '          <td>'+aParam[x][4][y][3]+'</td>'
				cHTML += '        </tr>'
				
				nLetras++

				ZD8->(dbSkip())
			Next

			For y:=1 to (12-nLetras)
				cHTML += '        <tr>'
				cHTML += '          <td>&nbsp;</td>'
				cHTML += '          <td>&nbsp;</td>'
				cHTML += '          <td>&nbsp;</td>'
				cHTML += '        </tr>'		
			Next
	
			cHTML += '      </table></td>'
			
			ZD8->(dbSkip())
	        
	        _x++
	        
	        If _x==4
	        	cHTML += '</tr><tr>'
	        ElseIf _x==8
	        	cHTML += '</tr>'
	        	cHTML += '  <td colspan="3">&nbsp;</td>'
  		        cHTML += '  <td width="25%">'
  		        cHTML += '    <table cellspace="0" cellpadding="0" border="1" style="border-collapse:collapse" width="100%">'
 				cHTML += '      <tr><td colspan="3" align="center">REVIS�ES</td></tr>'
        		cHTML += '      </tr>'
		    
				cHTML += '      <tr>'
				cHTML += '        <td>MOTIVO:</td>'
				cHTML += '        <td colspan="2">'+ZB5->ZB5_MOTREV+'</td>'
				cHTML += '      </tr>'
		
				cHTML += '      <tr>'
				cHTML += '        <td>REV.: '+ZB5->ZB5_REV+'</td>'
				cHTML += '        <td>DATA: '+DTOC(ZB5->ZB5_DTREV)+'</td>'
				cHTML += '        <td>RESPONS.: '+ZB5->ZB5_RESREV+'</td>'
				cHTML += '      </tr>'
				cHTML += '    </table></td></tr>'
	        	
	        	cHTML += '</table>'

	        	exit

	        EndIf
	        
		Next
			
		cHTML += '    </td>'
		cHTML += '  </tr>'

    EndIf
    
	//������������
	//� INSPE��O �
	//������������
	If nPar==9
		
		ST9->(DbSetOrder(1))//FILIAL + CODBEM
		ST9->(DbSeek(xFilial("ST9")+ZD5->ZD5_BEM))

		cHTML += '  <tr >'
		cHTML += '    <td width="70%" align="center" height="6%"><strong>LAY OUT DE EQUIPAMENTO</strong></td>'
		cHTML += '    <td width="30%" colspan="3" align="center"><strong>EQUIPAMENTOS E/OU FERRAMENTAS</strong></td>'
		cHTML += '  </tr >'
		
		cImg1 := STRTRAN(UPPER(ZD5->ZD5_IMG01),"\SYSTEM\FT\","")
	
		cHTML += '  <tr >'
		cHTML += '    <td rowspan="32" align="center" height="94%">'

		If File(cStartPath+cImg1)
			cHTML += '  	<img src="'+cImg1+'" width="1000" height="700"/>'
		Else
			cHTML += '&nbsp;Sem Imagem'
		EndIf

		cHTML += '    </td>'
		cHTML += '  </tr >'
	
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">N� M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ZD5->ZD5_BEM+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">DESCRI��O DA M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;'+ST9->T9_NOME+'</span></td>'
		cHTML += '  </tr>'
		cHTML += '  <tr>'
		cHTML += '    <td colspan="2">LOCALIZA��O DA M�QUINA: </td>'
		cHTML += '    <td><span class="info_bd">&nbsp;X: '+STR(ST9->T9_POSX)+', Y:'+STR(ST9->T9_POSY)+' </span></td>'
		cHTML += '  </tr>'


		cHTML += '  <tr>'
		cHTML += '    <td colspan="2" align="center">DESCRI��O</td>'
		cHTML += '    <td align="center">C�DIGO WHB</td>'
		cHTML += '  </tr>'

		ZDB->(dbSetOrder(1)) // FILIAL + NUMFT + REV + ITEMFT + ITEM
		SB1->(dbSetOrder(1)) // FILIAL + COD
		
		nItem := 0        

		ZDB->(dbSeek(xFilial("ZDB")+ZB5->ZB5_NUM+ZB5->ZB5_REV+ZD5->ZD5_ITEM))
		While ZDB->(!EOF()) .AND. ZDB->ZDB_NUM==ZB5->ZB5_NUM .AND. ZDB->ZDB_REV==ZB5->ZB5_REV .AND. ZDB->ZDB_ITEMFT==ZD5->ZD5_ITEM

			SB1->(dbSeek(xFilial("SB1")+ZDB->ZDB_COD))            

			cHTML += '  <tr>'
			cHTML += '    <td colspan="2" align="center">'+SB1->B1_DESC+'</td>'
			cHTML += '    <td align="center"><span class="info_bd">&nbsp;'+ZDB->ZDB_COD+'</span></td>'
			cHTML += '  </tr>'
			
			nItem++
		
			ZDB->(dbSkip())
		
		EndDo
		
		For _x := 1 to (24-nItem)
			cHTML += '	  <tr>'
			cHTML += '	    <td colspan="2">&nbsp;</td>'
			cHTML += '	    <td>&nbsp;</td>'
			cHTML += '	  </tr>'
		Next

	EndIf

	//���������Ŀ
	//� REVISAO �
	//�����������
	If nPar == 2 .or. nPar == 1 .or. nPar==4 .or. nPar==5 .or. nPar==9
		cHTML += '    <tr>'
		cHTML += '      <td colspan="3" align="center">REVIS�ES</td>'
		cHTML += '    </tr>'
		    
		cHTML += '    <tr>'
		cHTML += '      <td>MOTIVO:</td>'
		cHTML += '      <td colspan="2">'+ZB5->ZB5_MOTREV+'</td>'
		cHTML += '    </tr>'

		cHTML += '    <tr>'
		cHTML += '      <td>REV.: '+ZB5->ZB5_REV+'</td>'
		cHTML += '      <td>DATA: '+DTOC(ZB5->ZB5_DTREV)+'</td>'
		cHTML += '      <td>RESPONS.: '+ZB5->ZB5_RESREV+'</td>'
		cHTML += '    </tr>'
	
		If nPar == 2
			cHTML += '<tr><td colspan="4" height="7%"><img src="legdisp.gif" /></td>'
			cHTML += '</tr>'
		EndIf
	EndIf

	cHTML += '    </table>'
	cHTML += '  </tr>'
	cHTML += '</table>'
	
	cHTML += '</body>'
	cHTML += '</html>'
	
	Fwrite(nOutFile,cHTML)
	
	FClose(nOutFile)
	
	cLink := "\\192.168.1.14\Protheus10\Protheus_Data\system\FT\"+cArqHtml
	
Return cLink

//����������������������������Ŀ
//� VALIDA O MOTIVO DA REVISAO �
//������������������������������
Static Function fValRev(cMot)

	If Empty(cMot)
		Alert("Informe o motivo da revis�o!")
		Return .F.
	EndIf

Return .T.
