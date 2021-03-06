/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! NHFAT035.PRW                                            !
+------------------+---------------------------------------------------------+
!Descricao         ! Gerar aviso de embarque para GM - General Motors        +
+------------------+---------------------------------------------------------+
!Autor             ! Edenilson Santos                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 27/05/2013                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "AP5MAIL.CH"

User Function NHFAT035()

SetPrvt("_cArqITP,cArqBGM,cArqBG1,_cArqDTL,_cArqEQD,_cArqCPS,_cArqLIN,_cArqFTP,cArqINI,cDtaHor,_cArqDBF ")
SetPrvt("_aITP,aBGM,aBG1,aDTL,aEQD,aCPS,aLIN,aFTP, aDBF,aINI,nAux,cCod,nFTP,cDesc")
SetPrvt("aRotina,cCadastro,_cCliente,_cLoja,_cPlanta,_cNotas,_lEmb,a_email,cPerg,cTime,_cFabri")
SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cNome,_aFile,_cEdi,_cCam,cCont,_cCGC,_cDoca")
Private cQuery
Private lConectou := .F.
Private lEnviado
cServer	  := Alltrim(GETMV("MV_RELSERV")) 	//"192.168.1.4"
cAccount  := Alltrim(GETMV("MV_RELACNT"))	//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))	//'siga'
cMensagem := 'Erro ao se conectar no servidor: ' 
cMSG      := ""        
cPerg     := "FAT035"                                
nFTP      := 0
_cArqDBF  := SPACE(12) 
_cArqITP  := SPACE(12)                                                           
cArqBGM	  := SPACE(12) 
cArqDTL	  := SPACE(12) 
cArqEQD	  := SPACE(12) 
cArqCPS	  := SPACE(12) 
cArqLIN	  := SPACE(12) 
cArqFTP	  := SPACE(12)
aFile  	  := {}
_lEmb     := .F. //verifica se gerou o aviso de embarque                                   
CRLF      := chr(13)+chr(10)   // PULA LINHA  
cNovaLinha:= Chr(13) + Chr(10)
cTime     := Time()  
_cPlanta  := ""
_nCPS     := 0

_cEdi      := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   
_cCam     := "GMB"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
cARQEXP    := _cEDI + _cCam            

While File(cARQEXP)        
   _cCam   := SUBS(_cCam,1,7) +  StrZero(Val(SUBS(_cCam,8,1))+1,1)+".TXT" 
   cARQEXP := _cEDI + _cCam
Enddo
                            
cARQEXP := "C:\TEMP\AVISOGMB.TXT"                        
cARQ  := FCreate(cARQEXP)

If Pergunte(cPerg,.T.)
	Processa({|| Gerando() }, "Gerando aviso de embarque para GM.")   
endif

If File( _cArqDBF )   
   fErase(_cArqDBF)  // Deleta arquivo de dados temporario
   fErase(_cArqITP)  
   fErase(cArqBGM)
   fErase(cArqBG1)
   fErase(cArqDTL)
   fErase(cArqEQD)
   fErase(cArqCPS)
   fErase(cArqLIN)
   fErase(cArqFTP)
Endif 

If _lEmb //verifica se gerou o aviso de embarque                                   
  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	 cMsg += '<html>' + CRLF
	 cMsg += '<head>' + CRLF
	 cMsg += '<title> Relat�rio de embarque  </title>' + CRLF
	 cMsg += '</head>' + CRLF
     cMsg += ' <P><IMG SRC="WHBL.BMP" ALIGN=BOTTOM><b><font size="5" face="Times New Roman">'+CRLF+'          Aviso de Embarque</font></b></P>'+ CRLF	 
	 cMsg += '<b><font size="3" face="Arial"> Email Enviado Atraves do Sistema Protheus</font></b>' + CRLF+CRLF
	 cMsg += '<font size="2" face="Arial">Aviso de embarque enviado para General Motors as: '+time() +' na data: '+Dtoc(ddatabase)+'</font>' + CRLF
     cMsg += CRLF	 
     cMsg += '<font size="2" face="Arial"> Notas enviadas  '+CRLF
     cMsg += _cNotas+'</font>' + CRLF	 
     cMsg += CRLF	 
     cMsg += CRLF	 
     cMsg += '<font size="2" face="Arial"> Aviso de embarque gerado por: </font>' + CRLF	 
	 cMsg += '</body>' + CRLF
	 cMsg += '</html>' + CRLF
EndIf

If Select("TRA2") > 1
	TRA2->(DbCloseArea())
Endif
DBF->(DbCloseArea())
BGM->(DbCloseArea())
BG1->(DbCloseArea())
DTL->(DbCloseArea())
CPS->(DbCloseArea())
EQD->(DbCloseArea())
LIN->(DbCloseArea())
FTP->(DbCloseArea()) 	    	              

IF SM0->M0_CODIGO == "NH"  //empresa Usinagem
 	    //a_email := 'lista-fiscal@whbbrasil.com.br;'
   	  a_email := 'josemf@whbbrasil.net;'
ElseIF SM0->M0_CODIGO == "FN"  //empresa Fundicao 	 
      a_email := 'josemf@whbbrasil.net;'
Endif   
     
     _aFile := { "\SigaAdv\WHBL.BMP" }
	 If lConectou
		Send Mail from 'protheus@whbbrasil.com.br' To a_email;
		SUBJECT '***** AVISO DE EMBARQUE PARA GENERAL MOTORS '+Upper(_cPlanta)+' ***** ';
		BODY cMsg;                      
        ATTACHMENT _aFile[1];		
		RESULT lEnviado
	    If !lEnviado
			Get mail error cMensagem
		 	Alert(cMensagem)
    	EndIf                             
	 	 
	 else
		Alert("Erro ao se conectar no servidor: " + cServer)		
	 Endif   
	If File(cARQEXP)
   		FClose(cARQ)         
   		if !_lEmb
      		fErase(cArQEXP)  // Deleta arquivo de dados pois n�o foi selecionado nenhuma nota
   		Endif   
	Endif
Return

Static Function fCriaDBF()
//��������������������������������������������������������������Ŀ
//� Criando Arquivo Temporario para posterior impressao          �
//����������������������������������������������������������������
// Segmento DBF
_cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aDBF := {}
                                                  // Nome              
AADD(_aDBF,{"OK"         ,"C", 02,0})         // Identificacao Marca
AADD(_aDBF,{"Nota"       ,"C", 09,0})         //  NUMERO DA NF 
AADD(_aDBF,{"Serie"      ,"C", 02,0})         // SERIE DA NOTA FISCAL 
AADD(_aDBF,{"Dta"        ,"C", 10,0})         // DATA DA NOTA FISCAL 
AADD(_aDBF,{"Prodcli"    ,"C", 15,2})         // Codigo do produto cliente
AADD(_aDBF,{"Prodwhb"    ,"C", 15,2})         // Codigo do produto WHB
AADD(_aDBF,{"Total"      ,"N", 17,2})         // VALOR TOTAL DA NOTA FISCAL 
AADD(_aDBF,{"Espaco"     ,"C", 63,0})         // ESPACO

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"DBF",.F.)

// Segmento Inicial 
cArqINI := CriaTrab(NIL,.f.)
cArqINI += ".DBF"
aINI := {}

AADD(aINI,{"IdentSeg"    ,"C",03,0})
AADD(aINI,{"VersInter"      ,"C",02,0})
AADD(aINI,{"NumInter"     ,"C",30,0})
AADD(aINI,{"NumDes"       ,"C",30,0})
AADD(aINI,{"NumRefIn"       ,"C",05,0})

DbCreate(cArqINI,aINI)
DbUseArea(.T.,,cArqINI,"INI",.F.)

// Monta Tempor�rio INICIAL
   RecLock("INI",.T.)             
   INI->IdentSeg  := "SII"  
   INI->VersInter   := "00" 
   INI->NumInter    := IIF(SM0->M0_CODIGO == "NH","73355174000140","01261681000104")  //empresa Usinagem OU Fundicao // Numero do CGC DO FORNECEDOR
   INI->NumDes   := _cCGC//N�mero do CGC DA GM 
   INI->NumRefIn :=  "00000"
   MsUnlock("INI")
   FWrite(cArq,(INI->(IdentSeg+VersInter+NumInter+NumDes+NumRefIn)+cNovaLinha))
   nFTP += 1 
   DbSelectArea("INI")
   DbCloseArea()

// Arquivo ITP
_cArqITP  := CriaTrab(NIL,.f.)
_cArqITP += ".DBF"
_aITP := {}
                                                  
AADD(_aITP,{"IdentSeg"   ,"C", 03,0})        
AADD(_aITP,{"NumComu"    ,"C", 03,0})         
AADD(_aITP,{"NumVer"     ,"C", 02,0})        
AADD(_aITP,{"NumCont"    ,"C", 05,0})        
AADD(_aITP,{"IdentGer"   ,"C", 12,0})         
AADD(_aITP,{"IdentTra"   ,"C", 14,0})         
AADD(_aITP,{"IdentRec"   ,"C", 14,0})        
AADD(_aITP,{"CodIntTr"   ,"C", 08,0})         
AADD(_aITP,{"CodIntRe"   ,"C", 08,0})         
AADD(_aITP,{"NomTrans"   ,"C", 25,0})         
AADD(_aITP,{"NomRece"    ,"C", 25,0})        
AADD(_aITP,{"Espaco"     ,"C", 09,0})         

DbCreate(_cArqITP,_aITP)
DbUseArea(.T.,,_cArqITP,"ITP",.F.)  

// Monta o Arquivo Tempor�rio do ITP
RecLock("ITP",.T.)             
   ITP->IdentSeg  := "ITP"
   ITP->NumComu   := "ASN"
   ITP->NumVer    := "02"
   ITP->NumCont   := Space(05)
   ITP->IdentGer  :=  Dtos(dDatabase) + Stuff(TIME(),AT(":",TIME()),1,"")  // DATA+HHMMSS
   ITP->IdentTra  := IIF(SM0->M0_CODIGO == "NH","73355174000140","01261681000104") // CGC DO FORNECEDOR
   ITP->IdentRec  := _cCGC
   ITP->CodIntTr  := space(08)
   ITP->CodIntRe  := space(08)
   ITP->NomTrans  := space(25)
   ITP->NomRece   := space(25)
   ITP->Espaco    := Space(09)
   nFTP += 1
MsUnlock("ITP")
	FWrite(cArq,(ITP->(IdentSeg+NumComu+NumVer+NumCont+IdentGer+IdentTra+IdentRec+CodIntTr+CodIntRe+NomTrans+NomRece+Espaco)+cNovaLinha)) 
  	DbSelectArea("ITP")
  	DbCloseArea()
//----------------------------------------- Segmento BGMv0 - Dados Gerais do Documento(1 em cada ITP)
cArqBGM := CriaTrab(NIL,.f.)
cArqBGM += ".DBF"
aBGM := {}

AADD(aBGM,{"IdentSeg"    ,"C",03,0})
AADD(aBGM,{"NumAsn"      ,"C",03,0})
AADD(aBGM,{"FuncMen"     ,"C",03,0})
AADD(aBGM,{"DhDoc"       ,"C",03,0})
AADD(aBGM,{"DhEmb"    	 ,"C",03,0})
AADD(aBGM,{"UnPeBru"  	 ,"C",03,0})
AADD(aBGM,{"PeBru"    	 ,"C",12,0})
AADD(aBGM,{"UnMePeLi"    ,"C",03,0})
AADD(aBGM,{"PeLi"      	 ,"C",12,0})
AADD(aBGM,{"UnMeQEm"     ,"C",03,0})
AADD(aBGM,{"TotEmb"      ,"C",12,0})
AADD(aBGM,{"TiTrans"     ,"C",03,0})
AADD(aBGM,{"NumTrans"    ,"C",30,0})
AADD(aBGM,{"Esp"         ,"C",08,0})

DbCreate(cArqBGM,aBGM)
DbUseArea(.T.,,cArqBGM,"BGM",.F.)
//-------------------------------------------------------- Segmento BG1v0 - Dados Gerais e Identifica��es
cArqBG1 := CriaTrab(NIL,.F.)
cArqBG1 += ".DBF"
aBG1 := {}

AADD(aBG1,{"IdentSeg"    ,"C",03,0})
AADD(aBG1,{"DhEst"    	 ,"C",12,0})
AADD(aBG1,{"IdVend"    	 ,"C",20,0})
AADD(aBG1,{"CodInVend"   ,"C",17,0})
AADD(aBG1,{"Esp"    	 ,"C",76,0}) 

DbCreate(cArqBG1,aBG1)
DbUseArea(.T.,,cArqBG1,"BG1",.F.)
// --------------------------------------------------- Segmento DTLv1 - Endere�os e Transporte(somente 1 em cada ITP)
cArqDTL := CriaTrab(NIL,.F.)
cArqDTL += ".DBF"
aDTL := {}

AADD(aDTL,{"IdentSeg"    ,"C",03,0})
AADD(aDTL,{"CodProg"     ,"C",12,0})
AADD(aDTL,{"CodEntr"     ,"C",20,0})
AADD(aDTL,{"IdForn"      ,"C",22,0})
AADD(aDTL,{"DunsLocEmb"  ,"C",10,0})
AADD(aDTL,{"CodResSol"   ,"C",10,0})
AADD(aDTL,{"DocDes"      ,"C",20,0})
AADD(aDTL,{"QuaTrans"    ,"C",03,0})
AADD(aDTL,{"ModTrans"    ,"C",03,0})
AADD(aDTL,{"CodTrans"    ,"C",10,0})
AADD(aDTL,{"RaMerc"      ,"C",03,0})
AADD(aDTL,{"CodExc"      ,"C",03,0})
AADD(aDTL,{"NumTrans"    ,"C",10,0})
AADD(aDTL,{"Esp"      ,"C",07,0})

DbCreate(cArqDTL,aDTL)
DbUseArea(.T.,,cArqDTL,"DTL",.F.)
//------------------------------------------------    Segmento EQDv0 - Detalhes de Equipamentos

cArqEQD := CriaTrab(NIL,.F.)
cArqEQD += ".DBF"
aEQD := {}

AADD(aEQD,{"IdentSeg"     ,"C",03,0})
AADD(aEQD,{"QualEqui"     ,"C",03,0})
AADD(aEQD,{"IdentEquip"     ,"C",17,0})
AADD(aEQD,{"Esp"     ,"C",105,0})

DbCreate(cArqEQD,aEQD)
DbUseArea(.T.,,cArqEQD,"EQD",.F.)
//----------------------------------------------- Segmento CPSv0 - Detalhes do Item

cArqCPS := CriaTrab(NIL,.F.)
cArqCPS += ".DBF"
aCPS 	:= {}

AADD(aCPS,{"IdentSeg"    ,"C",03,0})
AADD(aCPS,{"NumSeIt"     ,"C",04,0})
AADD(aCPS,{"Esp"         ,"C",121,0})

DbCreate(cArqCPS,aCPS)
DbUseArea(.T.,,cArqCPS,"CPS",.F.)
//------------------------------------------------------------ Segmento LINv1 - DADOS DO ITEM

cArqLIN := CriaTrab(NIL,.F.)
cArqLIN += ".DBF"
aLIN := {}

AADD(aLIN,{"IdentSeg",           "C" , 03,0})  
AADD(aLIN,{"CodItem",            "C" , 30,0})
AADD(aLIN,{"QtAdeEmb",          	 "C" , 12,0})
AADD(aLIN,{"UnAcu",         	 "C" , 03,0})
AADD(aLIN,{"QtdeEmb",            "C" , 12,0})
AADD(aLIN,{"UnEmb",              "C" , 03,0})
AADD(aLIN,{"NumPed",             "C" , 30,0})
AADD(aLIN,{"AnoReg",             "C" , 04,0})
AADD(aLIN,{"CodOri",             "C" , 02,0})
AADD(aLIN,{"Esp",                "C" , 29,0})

DbCreate(cArqLIN,aLIN)
DbUseArea(.T.,,cArqLIN,"LIN",.F.)
//----------------------------------------------- Segmento FTPv0 - Segmento Final de Mensagem


cArqFTP := CriaTrab(NIL,.F.)
cArqFTP += ".DBF"
aFTP := {}

AADD(aFTP,{"IdentSeg",               "C", 03,0}) 
AADD(aFTP,{"NumMovi",                "C", 05,0})
AADD(aFTP,{"QtdeSeg",                "C", 09,0})
AADD(aFTP,{"NumToVal",               "C", 17,0})
AADD(aFTP,{"CatOpe",                 "C", 01,0})
AADD(aFTP,{"Esp",                    "C", 93,0})

DbCreate(cArqFTP,aFTP)
DbUseArea(.T.,,cArqFTP,"FTP",.F.)
Return  

Static Function Gerando()
IF SM0->M0_CODIGO == "NH"  //empresa Usinagem
   If mv_par01 == 1 // Sao Jos� dos Campos - SP
      _cCliente := "900004"
      _cLoja    := "02"                     
     _cPlanta  	:= " S�o Jose dos Campos"
     _cFabri  	:= "4J"
     _cCGC := "59275792000826"
     _cDoca := "DOCA - 50"
   Endif
ElseIF SM0->M0_CODIGO == "FN"  //empresa Fundicao
	If mv_par01 == 1// S�o Jos� dos Campos - SP
      _cCliente := "900024"
      _cLoja    := "02"                     
      _cPlanta  := " Sao Jose dos Campos"
      _Fabri    := "4J"
      _cCGC := "59275792000826"
      _cDoca := "DOCA - 30"
      /*GMO24.4.0063.00     DOCA - 30                                         
      GMB01.4.0201.00      DOCA -  40                                                 
      GMO22.4.0064.00      DOCA -  45*/       
 	Elseif mv_par01 == 2 // Sorocaba 
      _cCliente := "900024"
	  _cLoja    := "03"
      _cPlanta  := " Sorocaba"
      _cFabri   := "09"
      _cCGC := "59275792008991"
      _cDoca := "DOCA - A215"
   Endif
Endif

cQuery := " SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI," 
cQuery += " D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_CF,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
cQuery += " A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI,B1.B1_QTDACUM"
cQuery += " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7"
cQuery += " WHERE D2.D2_EMISSAO BETWEEN '" + DTOS(mv_par02) + "' AND '" + DTOS(mv_par03) + "' " 
cQuery += " AND D2.D2_CLIENTE = '" + _cCliente + "' AND D2.D2_LOJA = '" + _cLoja + "' " 
cQuery += " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE AND D2.D2_TES IN ('542','503','573','613','605','576')"
cQuery += " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE"
cQuery += " AND D2.D2_CLIENTE = A7.A7_CLIENTE AND D2.D2_LOJA = A7.A7_LOJA"
cQuery += " AND B1.B1_COD = D2.D2_COD AND A7.A7_PRODUTO = D2.D2_COD"  
cQuery += " AND C6.C6_PRODUTO = D2.D2_COD"         
cQuery += " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ = ' ' AND A7. D_E_L_E_T_ = ' '"  
cQuery += " ORDER BY D2.D2_DOC ASC"    
TCQUERY cQuery New Alias "TRA2" 
DbSelectArea("TRA2")


TRA2->(DBGotop())            
If Empty(TRA2->D2_DOC)
	Alert("Aten��o! Nenhuma uma nota fiscal foi selecionada.O programa ser� fechado." )
	FClose(cARQ)         
	fErase(cArQEXP)  // Deleta arquivo de dados pois n�o foi selecionado nenhuma nota
	TRA2->(DbCloseArea())
   	Return
Endif
fCriaDBF() 
While !TRA2->(EOF())
	RecLock("DBF",.T.)
		DBF->Nota    := TRA2->D2_DOC
		DBF->Serie   := Alltrim(TRA2->D2_SERIE)
		DBF->Dta     := Subs(TRA2->D2_EMISSAO,7,2)+"/"+Subs(TRA2->D2_EMISSAO,5,2)+"/"+Subs(TRA2->D2_EMISSAO,1,4)
		DBF->Prodcli := TRA2->A7_CODCLI
		DBF->Prodwhb := TRA2->D2_COD
		DBF->Total   := TRA2->D2_TOTAL
 		MsUnlock("DBF")
  	TRA2->(DbSkip())
Enddo
cMarca  := GetMark()
aCampos := {}   
Aadd(aCampos,{"OK"        ,"C", "  "             ,"@!"})
Aadd(aCampos,{"NOTA"      ,"C", "Nota"           ,"@!"})
Aadd(aCampos,{"SERIE"     ,"C", "Serie"          ,"@!"})
Aadd(aCampos,{"DTA"       ,"C", "Data"           ,"@!"})
Aadd(aCampos,{"PRODCLI"   ,"C", "Prod. Cliente"  ,"@!"})
Aadd(aCampos,{"PRODWHB"   ,"C", "Prod. WHB"      ,"@!"})
Aadd(aCampos,{"TOTAL"     ,"N", "Total"          ,"@e 999,999,999,999.99"})
Aadd(aCampos,{"ESPACO"    ,"C", "  "             ,"@!"})

DBF->(DbGoTop())
cCadastro := OemToAnsi("Selecione a Nota - <ENTER> Marca/Desmarca")
aRotina := { {"Marca Tudo"    ,'U_fMarcGM()', 0 , 4 },;
             {"Desmarca Tudo" ,'U_fDesmarGM()', 0 , 1 },;
             {"Legenda"       ,'U_fLeGM()', 0 , 1 } }

MarkBrow("DBF","OK" ,"DBF->OK",aCampos,,cMarca)

ProcRegua(TRA2->(RecCount()))

TRA2->(DbGoTop())
DBF->(DbGoTop())

_lEmb := .F. //verifica se gerou o aviso de embarque                                   

While TRA2->(!eof()) .And. DBF->(!eof())     
	If !EMPTY(DBF->OK)
		IncProc("Gerando aviso de embarque para GM " + _cPlanta + ".")
	 	//---------------  SEGMENTO BGM - COMPLEMENTO DADOS DA NF 
  		_lEmb := .T. //verifica se gerou o aviso de embarque                                                                      
   		_cNotas := ALLTRIM(_cNotas) +" "+ TRA2->D2_DOC + CRLF 
		// Segmento BGM
		RecLock("BGM",.T.)             
   			BGM->IdentSeg  := "BGM"
   			BGM->NumAsn := StrZero(Val(TRA2->D2_DOC + TRA2->D2_SERIE))  	// N�mero do ASN 
   			BGM->FuncMen := "9" 				  	// Fun��o da Mensagem
   			BGM->DhDoc := TRA2->D2_EMISSAO + Stuff(TIME(),AT(":",TIME()),1,"")  // Data de Emiss�o
	   		BGM->DhEmb := TRA2->D2_EMISSAO + Stuff(TIME(),AT(":",TIME()),1,"")  // Data de Embarque 
   			BGM->UnPeBru := TRA2->D2_UM												  // Unidade de Medida Peso Bruto
   			BGM->PeBru := Str(TRA2->C5_PBRUTO)      								  // Peso Bruto
   			BGM->UnMePeLi := TRA2->D2_UM                  							  // Unidade de Medida Peso l�quido
   			BGM->PeLi := Str(TRA2->B1_PESO)         								  // Peso L�quido
   			BGM->UnMeQem := TRA2->D2_UM                   								  // Unidade de Medida da quantidade embarcada
   			BGM->TotEmb := Str(TRA2->D2_QUANT)      								  // Qtde total do embarque
   			BGM->TiTrans := "MB"
   			BGM->NumTrans := StrZero(Val(TRA2->D2_DOC + TRA2->D2_SERIE))  	  		  // N�mero da Transportador
   			BGM->Esp := Space(08)
   		MsUnlock("BGM")
   		FWrite(cArq,(BGM->(IdentSeg+NumAsn+FuncMen+DhDoc+DhEmb+UnPeBru+PeBru+UnMePeLi+PeLi+UnMeQem+TotEmb+TiTrans+NumTrans+Esp)+cNovaLinha)) 
   		nFTP += 1 
   		_nCPS += 1
   		// Segmento DTL
    	RecLock("DTL",.T.)             
   			DTL->IdentSeg 		:= "DTL"
   			DTL->CodProg 		:= "88835"
   			DTL->CodEntr 		:= _cFabri 
		   	DTL->IdForn    		:= Space(22)
		   	DTL->DunsLocEmb 	:= Space(10)
		   	DTL->CodResSol		:= Space(10)
   			DTL->DocDes 		:= _cFabri
   			DTL->QuaTrans 		:= "12"
   			DTL->ModTrans 		:= "J"
   			DTL->CodTrans 		:= "RODO"
   			DTL->RaMerc  		:= Space(03)
   			DTL->NumTrans		:= Space(10)
		   	DTL->Esp			:= space(7)
		MsUnlock("DTL")
       // Codigo da fabrica 4J - S�O JOS� DOS CAMPOS 09 - SOROCABA
	   If TRA2->D2_CLIENTE+TRA2->D2_LOJA == "90002402" .Or. TRA2->D2_CLIENTE+TRA2->D2_LOJA == "90000402"//S�o Jos� dos Campos
          	DTL->CodEntr   := "4J"	    
       ElseIf TRA2->D2_CLIENTE+TRA2->D2_LOJA == "90002403"  //Sorocaba          
          	DTL->CodEntr   := "09"	                         	           
       Else
          	Alert("Uma nota que n�o � da General Motors foi selecionada. Rode o aviso novamente!.")
          	exit //for�a a sa�da do programa
   	   Endif
	   MsUnlock("TRA2")
       FWrite(cArq,(DTL->(IdentSeg+CodProg+CodEntr+IdForn+DunsLocEmb+CodResSol+DocDes+QuaTrans+ModTrans+CodTrans+RaMerc+CodExc+NumTrans+Esp)+cNovaLinha)) 
	   nFTP += 1  //Controle de qtde de segmentos
	   // Segmento EQD
	   RecLock("EQD",.T.)             
   			EQD->IdentSeg  		:= "EQD"
   			EQD->QualEqui 		:= "TE"
   			EQD->IdentEquip 	:= "RODOVIARIO"
   			EQD->Esp 			:= space(105)
	   MsUnlock("EQD")
	   FWrite(cArq,(EQD->(IdentSeg+QualEqui+IdentEquip+Esp)+cNovaLinha))
   	   nFTP += 1
   	   // Segmento CPS
   	   RecLock("CPS",.T.)             
   			CPS->IdentSeg  := "CPS"
   			CPS->NumSeIt := Strzero(_nCPS,4)
   			CPS->Esp := space(121)
   	   MsUnlock("CPS")
   	   FWrite(cArq,(CPS->(IdentSeg+NumSeIt+Esp)+cNovaLinha))
   	   nFTP += 1
   	   // Segmento LIN
   	   RecLock("LIN",.T.)             
   			LIN->IdentSeg  		:= "LIN" 
   			LIN->CodItem 		:= TRA2->A7_CODCLI
   			LIN->QtAdeEmb 		:= Str(TRA2->D2_QUANT) // Criar campo SA7_QNTDEACUM
   			LIN->UnAcu 			:= TRA2->D2_UM
   			LIN->QtdeEmb 		:= Str(TRA2->D2_QUANT) 
   			LIN->UnEmb 			:= TRA2->D2_UM
   			LIN->NumPed 		:= TRA2->A7_PCCLI
   			LIN->AnoReg 		:= Strzero(Year(dDatabase)) // ARRUMAAR
   			LIN->CodOri 		:= Space(2)
   			LIN->Esp 			:= space(29)
   		MsUnlock("LIN")
   		FWrite(cArq,(lin->(IdentSeg+CodItem+QtAdeEmb+UnAcu+QtdeEmb+UnEmb+NumPed+AnoReg+CodOri+Esp)+cNovaLinha))
   		nFTP += 1
 Endif
	DBF->(DbSkip())
	TRA2->(DbSkip())
EndDo
 	// Segmento FTP  
   	If nFTP > 1
   		nFTP += 1
   		RecLock("FTP",.T.)             
   			FTP->IdentSeg		:= "FTP"
   			FTP->NumMovi        := Space(05)
   			FTP->QtdeSeg 		:= Str(nFTP,4)
   			FTP->NumToVal		:= Space(17)
   			FTP->CatOpe			:= Space(01) 
   			FTP->Esp 			:= space(93)
		MsUnlock("FTP")
   		FWrite(cArq,(FTP->(IdentSeg+NumMovi+QtdeSeg+NumToVal+CatOpe+Esp)+cNovaLinha))
   		fClose(cArq)
   	Else
    	Alert("Aten��o!N�o foi Selecionada nenhuma nota fiscal")
    	FClose(cARQ)         
    	fErase(cArQEXP)  // Deleta arquivo de dados pois n�o foi selecionado nenhuma nota
   	Endif
Return  

User Function fLeGM()
Private aCores := {{ "ENABLE"  , "Nota n�o selecionada" },;
                   { "DISABLE" , "Nota selecionada" }}
BrwLegenda(cCadastro,"Legenda",aCores)
Return
//marca todas as notas
User Function fMarcGM()
DBF->(DbGoTop())
   While !DBF->(eof())     
      RecLock("DBF")
         DBF->OK := cMarca
      MsUnlock("DBF")
      DBF->(Dbskip())
   Enddo   
   MarkBRefresh()
Return
//desmarca todas as notas
User Function fDesMarGM()
DBF->(DbGoTop())
   While !DBF->(eof())     
      RecLock("DBF")
         DBF->OK := "  "
      MsUnlock("DBF")
      DBF->(Dbskip())
   Enddo   
   MarkBRefresh()
Return