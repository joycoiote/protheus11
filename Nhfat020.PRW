/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHFAT020 �Autor  � Alexandre R. Bento    � Data � 14/02/07 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gera o arquivo de Aviso de Embarque p/ BOSCH               ���
���          � Vers�o 4 - 11                                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Faturamento                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "AP5MAIL.CH"
User Function NHFAT020()

SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,x ")   
SetPrvt("_cArqITP,_cArqAE1,_cArqNF2,_cArqAE2,_cArqAE4,_cArqAE3,_cArqTE1,_cArqFTP,cDtaHor ")
SetPrvt("_aITP,_aAE1,_aNF2,_caAE2,_aAE4,_aAE3,_aFTP,_aTE1, _aDBF,nAux,cCod,nFTP,cIPI,cICM,cDesc")
SetPrvt("aRotina,cCadastro,_cCliente,_cLoja,_cPlanta,_cNotas,_clEmb,a_email,cPerg,_aMatriz")
SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cNome,_aFile,nI,_cEdi,_cCam")

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
lConectou
lEnviado
cMensagem := 'Erro ao se conectar no servidor: ' 
CRLF := chr(13)+chr(10)   // PULA LINHA  
cMSG := ""        
cPerg   := "FAT020"                                
_lEmb   := .F. //verifica se gerou o aviso de embarque                                   
nPbruto :=  0
_cArqDBF:=SPACE(12) 
_cArqFTP:=SPACE(12) 
_cArqITP:=SPACE(12)                                                           
_cArqAE1:=SPACE(12) 
_cArqNF2:=SPACE(12) 
_cArqAE2:=SPACE(12) 
_cArqAE4:=SPACE(12) 
_cArqAE3:=SPACE(12) 
_cArqTE1:=SPACE(12) 
_cNotas :=SPACE(200) 
_cNome  := UsrFullName(__cUserID)
_aFile  := {}
_aMatriz:= {} 
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Da Nota ?                                    �
//� mv_par02     // Ate a Nota ?                                 �
//����������������������������������������������������������������

//cNovaLinha := Chr(13) + Chr(10)
//_cEdi      := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   // "V:\mdicom\Parceiro\WHBCOMP\Out\"
//_cEdi      := "C:\AP8\"
//_cCam     := "BSC"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
             // "V:\mdicom\Parceiro\WHBCOMP\Out\VLK"

//cARQEXP    := _cEDI + _cCam            
//While File(cARQEXP)        
//  _cCam   := SUBS(_cCam,1,7) +  StrZero(Val(SUBS(_cCam,8,1))+1,1)+".TXT" 
//   cARQEXP := _cEDI + _cCam
//Enddo

//cARQ  := FCreate(cARQEXP)
//----------------------------------------------------------------------------------------------------
//  VERIFICACAO DA EMPRESA
//----------------------------------------------------------------------------------------------------
IF SM0->M0_CODIGO <> "FN" //empresa new hubner	
   Msgbox("Esta Rotina So Pode Ser Utilizada na Fundicao!!!" ,"Atencao","ALERT" )  
   Return
Endif

cNovaLinha := Chr(13) + Chr(10)
_cEdi      := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   // "V:\mdicom\Parceiro\WHBCOMP\Out\"
_cCam     := "BCH"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
             // "V:\mdicom\Parceiro\WHBCOMP\Out\VLK"
cARQEXP    := _cEDI + _cCam            
While File(cARQEXP)        
   _cCam   := SUBS(_cCam,1,7) +  StrZero(Val(SUBS(_cCam,8,1))+1,1)+".TXT" 
   cARQEXP := _cEDI + _cCam
Enddo

cARQ  := FCreate(cARQEXP)
AjustaSx1()

If Pergunte(cPerg,.T.)
	Processa({|| Gerando() }, "Gerando Aviso de Embarque para BOSCH ")
EndIf

//Close TMP

If File( _cArqDBF )   
   fErase(_cArqDBF)  // Deleta arquivo de dados temporario
   fErase(_cArqITP)  
   fErase(_cArqAE1)
   fErase(_cArqAE2)
   fErase(_cArqAE3)
   fErase(_cArqAE4)
   fErase(_cArqTE1)
   fErase(_cArqNF2)
   fErase(_cArqFTP)
  
Endif  

//Manda e-mail de confirma��o da gera��o do aviso de embarque da volks
If _lEmb //verifica se gerou o aviso de embarque                                   
  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

     cMsg += '<html>' + CRLF
	 cMsg += '<head>' + CRLF
	 cMsg += '<title> E X E M P L O </title>' + CRLF
	 cMsg += '</head>' + CRLF
     cMsg += ' <P><IMG SRC="WHBL.BMP" ALIGN=BOTTOM><b><font size="5" face="Times New Roman">'+CRLF+'          Aviso de Embarque</font></b></P>'+ CRLF	 
	 cMsg += '<b><font size="3" face="Arial"> Email Enviado Atraves do Sistema Protheus</font></b>' + CRLF+CRLF
	 cMsg += '<font size="2" face="Arial">Aviso de Embarque Enviado para Bosch as '+time() +' na data: '+Dtoc(ddatabase)+'</font>' + CRLF
     cMsg += CRLF	 
     cMsg += '<font size="2" face="Arial"> Notas enviadas  '+CRLF
     cMsg += _cNotas+'</font>' + CRLF	 
     cMsg += CRLF	 
     cMsg += CRLF	 
     cMsg += '<font size="2" face="Arial"> Aviso de Embarque Gerado Por '+_cNome+'</font>' + CRLF	 
	 cMsg += '</body>' + CRLF
	 cMsg += '</html>' + CRLF
  	    	              

 	 a_email = 'lista-fiscal@whbbrasil.com.br'
 //	 a_email = 'alexandrerb@whbbrasil.com.br'
     _aFile := { "\SigaAdv\WHBL.BMP" }
	 If lConectou
		Send Mail from 'protheus@whbbrasil.com.br' To a_email;
		SUBJECT '***** AVISO DE EMBARQUE PARA BOSCH ***** ';
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
	
Endif

Return

Static Function Gerando()
   
   cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI," 
   cQuery += "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
   cQuery += "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI,D2.D2_CF,A7.A7_NLINPED"
   cQuery += " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7 "
   cQuery += " WHERE D2.D2_EMISSAO BETWEEN '" + DTOS(Mv_par01) + "' AND '" + DTOS(Mv_par02) + "' " 
   cQuery += " AND D2.D2_CLIENTE = '000002' "//AND D2.D2_LOJA = '01'" 
   cQuery += " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE " //AND D2.D2_TES IN ('613','605')"
   cQuery += " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE"
   cQuery += " AND C6.C6_NUM = D2.D2_PEDIDO AND C6.C6_ITEM = D2.D2_ITEMPV"   
   cQuery += " AND D2.D2_CLIENTE = A7.A7_CLIENTE AND D2.D2_LOJA = A7.A7_LOJA"
   cQuery += " AND B1.B1_COD = D2.D2_COD AND A7.A7_PRODUTO = D2.D2_COD"      
   cQuery += " AND D2.D2_TES = '576'"
//--   cQuery += " AND B1.B1_COD LIKE 'EC01%'"         
   cQuery += " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ = ' ' AND A7. D_E_L_E_T_ = ' ' " 
   cQuery += " ORDER BY D2.D2_DOC,D2.D2_SERIE,D2.D2_COD ASC"    

// MemoWrit('C:\TEMP\FAT020.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")

fCriaDBF()  // Cria arquivos temporarios de aviso de embarque para DaimlerChrysler

TMP->(DBGotop())            
If Empty(TMP->D2_DOC)
   Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal")
   FClose(cARQ)         
   fErase(cArQEXP)  // Deleta arquivo de dados pois n�o foi selecionado nenhuma nota
   TMP->(DbCloseArea())
   DBF->(DbCloseArea())
   AE1->(DbCloseArea())
   AE2->(DbCloseArea())
   AE3->(DbCloseArea())
   AE4->(DbCloseArea())
   TE1->(DbCloseArea())
   NF2->(DbCloseArea())
   FTP->(DbCloseArea())
   Return
Endif

While !TMP->(EOF())

   nI := Ascan(_aMatriz, {|x| x[1]+x[2]+x[3] == TMP->D2_DOC+TMP->D2_SERIE+TMP->D2_COD})   
   If nI <> 0
      _aMatriz[nI][4] += TMP->D2_QUANT //Soma a qtde quando tiver mais de uma vez o produto na mesma nota fiscal 
      _aMatriz[nI][7] += TMP->D2_TOTAL //Soma a qtde quando tiver mais de uma vez o produto na mesma nota fiscal       
      _aMatriz[nI][10] += TMP->D2_VALICM //Soma a qtde quando tiver mais de uma vez o produto na mesma nota fiscal 
      _aMatriz[nI][11] += TMP->D2_VALIPI //Soma a qtde quando tiver mais de uma vez o produto na mesma nota fiscal  
      _aMatriz[nI][18] += TMP->D2_DESCON //Soma a qtde quando tiver mais de uma vez o produto na mesma nota fiscal  
      _aMatriz[nI][20] += TMP->D2_BASEICM //Soma a qtde quando tiver mais de uma vez o produto na mesma nota fiscal        
   
   Else
   
      Aadd(_aMatriz,{TMP->D2_DOC,TMP->D2_SERIE,TMP->D2_COD,TMP->D2_QUANT,TMP->D2_EMISSAO,TMP->A7_CODCLI,TMP->D2_TOTAL,;
                  TMP->D2_ITEM,TMP->D2_TES,TMP->D2_VALICM,TMP->D2_VALIPI,TMP->A7_PCCLI,TMP->D2_UM,;
				  TMP->B1_POSIPI,TMP->D2_IPI,TMP->D2_PRCVEN,TMP->D2_DESC,TMP->D2_DESCON,TMP->D2_PICM,TMP->D2_BASEICM})
	    
   Endif							  

     
   TMP->(DbSkip())
Enddo
//XXXXXXXXXXXXXXXXXXXXXXXXXXX

//--ALERT(" TOTAL DE REG  " + STRZERO(len(_aMatriz),3) )
For nI:=1 to Len(_aMatriz)
   RecLock("DBF",.T.)
      DBF->Nota    := _aMatriz[nI] [1] // Nota
      DBF->Serie   := _aMatriz[nI] [2] // Serie
//      DBF->Dta     := Subs(TMP->D2_EMISSAO,7,2)+"/"+Subs(TMP->D2_EMISSAO,5,2)+"/"+Subs(TMP->D2_EMISSAO,1,4)
      DBF->Dta     := Subs(_aMatriz[nI] [5],7,2)+"/"+Subs(_aMatriz[nI] [5],5,2)+"/"+Subs(_aMatriz[nI] [5],1,4)
      DBF->Prodcli := _aMatriz[nI] [6] // codigo do cliente
      DBF->Prodwhb := _aMatriz[nI] [3] // Produto
      DBF->Total   := _aMatriz[nI] [7] // Total
   MsUnlock("DBF")
                    //Transform(TMP->D2_TOTAL,"@e 999,999,999,999.99")
Next nI  
     

//XXXXXXXXXXXXXXXXXXXXXXXXXXX
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
cCadastro := OemToAnsi("Selecione o Nota - <ENTER> Marca/Desmarca")
aRotina := { {"Marca Tudo"    ,'U_fMarcabh()', 0 , 4 },;
             {"Desmarca Tudo" ,'U_fDesmarbh()', 0 , 1 },;
             {"Legenda"       ,'U_fLegbh()', 0 , 1 } }

MarkBrow("DBF","OK" ,"DBF->OK",aCampos,,cMarca)

//Static Function fGera()

ProcRegua(TMP->(RecCount()))

TMP->(DbGoTop())
DBF->(DbGoTop())
nFTP := 1
_lEmb := .F. //verifica se gerou o aviso de embarque                                   
While !TMP->(eof()) .And. !DBF->(eof())     

   
   If !EMPTY(DBF->OK)
      
	  IncProc("Gerando Aviso de Embarque")

      //---------------  SEGMENTO AE1v0 - COMPLEMENTO DADOS DA NF 
       _lEmb := .T. //verifica se gerou o aviso de embarque                                                                      
       _cNotas := ALLTRIM(_cNotas) +" "+ TMP->D2_DOC + CRLF                 
       
	   RecLock("AE1",.T.)               
	   AE1->IdentSeg   := "AE1"
	   AE1->NumNF      := SUBS(TMP->D2_DOC,4,6)
	   AE1->SerNF      := Subs(TMP->D2_SERIE,1,2)
	   AE1->DataNF     := Subs(TMP->D2_EMISSAO,3,6)
	   AE1->QItNf      := StrZero(Val(TMP->D2_ITEM),3)                             
	   
	   AE1->VlToNF     := StrZero(TMP->D2_TOTAL,17,2)
	   AE1->VlToNF     := Stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"") //elimina o ponto
  	   AE1->VlToNF     := Stuff(AE1->VlToNF,1,0,"0")  // Insere o primeiro caracter
  	   
	   AE1->QCDec      := "0"  // QTDE de casas decimais
	   AE1->CFO        := TMP->D2_CF // "610" //Cfo da BOSCH TES 576 TMP->D2_TES   
//	   AE1->VlToICM    := Transform(TMP->D2_VALICM,"@e 99999999999999999.99")            
	   
	   AE1->VlToICM    := StrZero(TMP->D2_VALICM,17,2)
	   AE1->VlToICM    := Stuff(AE1->VlToICM,AT(".",AE1->VlToICM),1,"") //elimina o ponto
  	   AE1->VlToICM    := Stuff(AE1->VlToICM,1,0,"0")  // Insere o primeiro caracter
  
	   AE1->DataVen    := Subs(Dtos(dDatabase+7),3,6)
	   AE1->EspNF      := "00" //simples remessa //Iif(Alltrim(TMP->D2_TES) == "613","02","00")

//  AE1->VlIPI      := Transform(TMP->D2_VALIPI, "@e 99999999999999999.99")
  	   AE1->VlIPI      := StrZero(TMP->D2_VALIPI,17,2)
	   AE1->VlIPI      := Stuff(AE1->VlIPI,AT(".",AE1->VlIPI),1,"") //elimina o ponto
  	   AE1->VlIPI      := Stuff(AE1->VlIPI,1,0,"0")  // Insere o primeiro caracter

	   AE1->CodFabEn   := Space(03)
	   AE1->DataPrNF   := Iif((Val(Time())+14) > 24,Subs(Dtos(dDatabase+1),3,6),Subs(Dtos(dDatabase),3,6)) // verificar
	   AE1->IdentPer   := Space(04)
	   AE1->DescNO     := Space(20)
	   AE1->DataEmb    := Subs(Dtos(dDatabase),3,6) 
	   AE1->HoraEmb    := Subs(Time(),1,5)
	   AE1->HoraEmb    := Stuff(AE1->HoraEmb,AT(".",AE1->HoraEmb),1,"") //elimina o (:) dois pontos do hora
//	   AE1->Espaco     := Space(10)
	   MsUnlock("AE1")

       FWrite(cArq,(AE1->(IdentSeg+NumNF+SerNF+DataNF+QItNf+VlToNF+QCDec+CFO+VlToICM+DataVen+EspNF+VlIPI+CodFabEn+DataPrNF+IdentPer+DescNO+DataEmb+HoraEmb)+cNovaLinha))    

       nFTP += 1  //Controle de qtde de segmentos
    
//---------------- SEGMENTO AE2v0 - DADOS DO ITEM                         
    
      // Retira os espacos do codigo do produto
       cCod := Alltrim(TMP->A7_CODCLI) //Codigo da amarracao prod x cliente
//       Alert ( " codigo antes " + cCod)
       nAux := AT(" ",cCod)
       While nAux <> 0
       
          cCod := Stuff(cCod,nAux,1,"")   
          nAux := AT(" ",cCod)
           
       Enddo
                                 
//       Alert ( " codigo depois " + cCod)
       
	   Reclock("AE2",.T.)
	   AE2->IdentSeg    := "AE2"
	   AE2->NumItNF     := StrZero(Val(TMP->D2_ITEM),3)                             
	   AE2->NumPed      := TMP->A7_PCCLI           
	   AE2->CodItem     := Strzero(Val(TMP->A7_NLINPED),5)+ cCod //Codigo da amarracao prod x cliente

  	   AE2->QINF        := StrZero(TMP->D2_QUANT,9,0)
 
	   AE2->UnMedNF     := IIF(TMP->D2_UM$"UN","PC",TMP->D2_UM)
	   AE2->CodClasF    := "00"+TMP->B1_POSIPI

       cIPI              := StrZero(TMP->D2_IPI,5,2)
	   AE2->AliIPI      := Stuff(cIPI,AT(".",cIPI),1,"") //elimina o ponto
   
  	   AE2->VlItem      := StrZero(TMP->D2_PRCVEN,12,5)
	   AE2->VlItem      := Stuff(AE2->VlItem,AT(".",AE2->VlItem),1,"") //elimina o ponto
  	   AE2->VlItem      := Stuff(AE2->VlItem,1,0,"0")  // Insere o primeiro caracter
	   
	   AE2->QItEst      := StrZero(TMP->D2_QUANT,9,0)
   
	   AE2->UnMedEs     := IIF(TMP->D2_UM$"UN","PC",TMP->D2_UM)
	   AE2->QtUniCom    := StrZero(TMP->D2_QUANT,9,0)
	   AE2->UnMedCo     := IIF(TMP->D2_UM$"UN","PC",TMP->D2_UM)
	   AE2->CodTpFo     := "P"  // P= Producao
//	   AE2->QtPerDe     := Transform(TMP->D2_DESC,"@e 99.99")

  	   cDesc             := StrZero(TMP->D2_DESC,4,2)
	   AE2->QtPerDe     := Stuff(cDesc,AT(".",cDesc),1,"") //elimina o ponto
//  	   AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter
   
  	   AE2->VlToDes     := StrZero(TMP->D2_DESCON,11,2)
	   AE2->VlToDes     := Stuff(AE2->VlToDes,AT(".",AE2->VlToDes),1,"") //elimina o ponto
  	   AE2->VlToDes     := Stuff(AE2->VlToDes,1,0,"0")  // Insere o primeiro caracter
  	   AE2->AltTec      := Space(04)
  	   AE2->Espaco      := Space(01)  

	   MsUnlock("AE2")

       FWrite(cArq,(AE2->(IdentSeg+NumItNF+NumPed+CodItem+QINF+UnMedNF+CodClasF+AliIPI+VlItem+QItEst+UnMedEs+QtUniCom+UnMedCo+CodTpFo+QtPerDe+VlToDes+AltTec)+cNovaLinha))      
       nFTP += 1  //Controle de qtde de segmentos

//-------------  SEGMENTO AE4v3 - DADOS COMPLEMENTARES DO ITEM                  


	   RecLock("AE4",.T.)             
	   AE4->IdentSeg  := "AE4"

  	   cICM            := StrZero(TMP->D2_PICM,5,2)
	   AE4->AlICM     := Stuff(cICM,AT(".",cICM),1,"") //elimina o ponto
//  	   AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter
	   
  	   AE4->BasICM    := StrZero(TMP->D2_BASEICM,17,2)
	   AE4->BasICM    := Stuff(AE4->BasICM,AT(".",AE4->BasICM),1,"") //elimina o ponto
  	   AE4->BasICM    := Stuff(AE4->BasICM,1,0,"0")  // Insere o primeiro caracter

  	   AE4->VlICMAp    := StrZero(TMP->D2_VALICM,17,2)
	   AE4->VlICMAp    := Stuff(AE4->VlICMAp,AT(".",AE4->VlICMAp),1,"") //elimina o ponto
  	   AE4->VlICMAp    := Stuff(AE4->VlICMAp,1,0,"0")  // Insere o primeiro caracter
	   
  	   AE4->VlIPIAp    := StrZero(TMP->D2_VALIPI,17,2)
	   AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,AT(".",AE4->VlIPIAp),1,"") //elimina o ponto
  	   AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,1,0,"0")  // Insere o primeiro caracter

	   AE4->CodSiTr   := "00"
	   AE4->NumDesIt  := Space(30)
	   AE4->DatValDe  := Subs(TMP->D2_EMISSAO,3,6) //Subs(Dtos(dDatabase),3,6) 
	   AE4->PedRev    := Space(13) 
	   AE4->PesoLiq   := Space(05) 
	   AE4->MulPre    := Space(01) 
	   AE4->PreTot    := Strzero(Val(AE4->PreTot),12,2)                                  
   	   AE4->PreTot    := Stuff(AE4->PreTot,AT(".",AE4->PreTot),1,"0") //Troca o ponto por zero
	   AE4->SitTri	  := Space(01)   	   	   
	   MsUnlock("AE4") 

       FWrite(cArq,(AE4->(IdentSeg+AlICM+BasICM+VlICMAp+VlIPIAp+CodSiTr+NumDesIt+DatValDe+PedRev+PesoLiq+MulPre+PreTot+SitTri)+cNovaLinha))          
       nFTP += 1  //Controle de qtde de segmentos

//------------  SEGMENTO AE3v0 - DADOS ADICIONAIS DE COMERCIAL.                 


/*	
   RecLock("AE3",.T.)
	   AE3->IdentSeg := "AE3"
	   AE3->IdentFat := "57290355001585"
	   AE3->IdentCob := "57290355001585"
	   AE3->IdentEnt := Space(14)
	   AE3->Espaco   := Space(30)
	   MsUnlock("AE3")
       
       FWrite(cArq,(AE3->(IdentSeg+IdentFat+IdentCob+IdentEnt+Espaco)+cNovaLinha))             
       nFTP += 1  //Controle de qtde de segmentos    
 
      RecLock("TE1",.T.)
	   TE1->IdentSeg := "TE1"
	   TE1->Texto1   := Space(40)
	   TE1->Texto2   := Space(40)
	   TE1->Texto3   := Space(40)
	   TE1->Espaco   := Space(05)
	   MsUnlock("TE1")
       
      FWrite(cArq,(TE1->(IdentSeg+Texto1+Texto2+Texto3+Espaco)+cNovaLinha))             
      nFTP += 1  //Controle de qtde de segmentos                                                
*/ 
            
   EndIf
   DBF->(DbSkip())
   TMP->(DbSkip())
EndDo    

If nFTP > 1
//-------------  SEGMENTO FTPv0 - Segmento Final Mensagem                    
   nFTP += 1  //Controle de qtde de segmentos
   RecLock("FTP",.T.)
   FTP->IdentSeg := "FTP"
   FTP->NumCont  := "00000"
   FTP->QtdeSeg  :=StrZero(nFTP,9)
   FTP->NumToVl  :="00000000000000000"
   FTP->CatOper  := Space(01)
   FTP->Espaco   := Space(36)
   MsUnlock("FTP")          
    
   FWrite(cArq,(FTP->(IdentSeg+NumCont+QtdeSeg+NumToVl+CatOper+ Espaco)+cNovaLinha))                
   FClose(cARQ)            
 Else
    Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal")
    FClose(cARQ)         
    fErase(cArQEXP)  // Deleta arquivo de dados pois n�o foi selecionado nenhuma nota
 Endif  


TMP->(DbCloseArea())
DBF->(DbCloseArea())
AE1->(DbCloseArea())
AE2->(DbCloseArea())
AE3->(DbCloseArea())
AE4->(DbCloseArea())
TE1->(DbCloseArea())
NF2->(DbCloseArea())
FTP->(DbCloseArea())

Return
 

Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := Space(10)
cPerg   := "FAT020    "

aRegs   := {}


// VERSAO 811
//
//               G        O    P                     P                     P                     V        T   T  D P G   V  V          D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//               R        R    E                     E                     E                     A        I   A  E R S   A  A          E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//               U        D    R                     R                     R                     R        P   M  C E C   L  R          F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//               P        E    G                     S                     E                     I        O   A  I S |   I  0          0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//               O        M    U                     P                     N                     A        |   N  M E |   D  1          1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//               |        |    N                     A                     G                     V        |   H  A L |   |  |          |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//               |        |    T                     |                     |                     L        |   O  L | |   |  |          |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//               |        |    |                     |                     |                     |        |   |  | | |   |  |          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
aadd(aRegs,{cPerg,"01","Data Inicial       ?","Data Inicial       ?","Data Inicial       ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Data Final         ?","Data Final         ?","Data Final         ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aadd(aRegs,{cPerg,"02","Cliente            ?","Cliente            ?","Cliente            ?","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aadd(aRegs,{cPerg,"02","Loja               ?","Loja               ?","Loja               ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})


cUltPerg := aRegs[Len(aRegs)][2]

If !SX1->(DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
  	  SX1->(DbDelete())
      MsUnLock('SX1')  
      SX1->(DbSkip())
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock('SX1')

       DbCommit()
   Next
EndIf

dbSelectArea(_sAlias)

Return
                                     

Static Function fCriaDBF()

//��������������������������������������������������������������Ŀ
//� Criando Arquivo Temporario para posterior impressao          �
//����������������������������������������������������������������
_cArqITP  := CriaTrab(NIL,.f.)
_cArqITP += ".DBF"
_aITP := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aITP,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aITP,{"NumComu"    ,"C", 03,0})         // Numero Mensagem Comunicacao     M    A       3    0    4    6
AADD(_aITP,{"NumVer"     ,"C", 02,0})         // Numero da Versao da Mensagem    M    N       2    0    7    8
AADD(_aITP,{"NumCont"    ,"C", 05,0})         // Numero de Controle Movimento    O    N       5    0    9   13
AADD(_aITP,{"IdentMov"   ,"C", 12,0})         // Ident. Geracao Movimento        M    N      12    0   14   25
AADD(_aITP,{"IdentTra"   ,"C", 14,0})         // Identificacao do Transmissor    M    N      14    0   26   39
AADD(_aITP,{"IdentRec"   ,"C", 14,0})         // Identificacao do Receptor       M    N      14    0   40   53
AADD(_aITP,{"CodIntTr"   ,"C", 08,0})         // Codigo Interno Transmissor      O    A       8    0   54   61
AADD(_aITP,{"CodIntRe"   ,"C", 08,0})         // Codigo Interno Receptor         O    A       8    0   62   69
AADD(_aITP,{"NomTrans"   ,"C", 25,0})         // Nome do Transmissor             O    A      25    0   70   94
AADD(_aITP,{"NomRece"    ,"C", 25,0})         // Nome do Receptor                O    A      25    0   95  119
AADD(_aITP,{"Espaco"     ,"C", 09,0})         // Espaco                          M    A       9    0  120  128

DbCreate(_cArqITP,_aITP)
DbUseArea(.T.,,_cArqITP,"ITP",.F.) 


RecLock("ITP",.T.)             
   ITP->IdentSeg  := "ITP"
   ITP->NumComu   := "004"
   ITP->NumVer    := "11"
   ITP->NumCont   := "00001" // Fazer este numero sequencia atraves de MV_VOLKS
   cDtaHor         := Subs(Dtos(dDatabase),3,6)+Stuff(TIME(),AT(":",TIME()),1,"")  // DATA+HHMMSS
   ITP->IdentMov  := Stuff(cDtaHor,AT(":",cDtaHor),1,"")  // DATA+HHMMSS tira o segundo :
   ITP->IdentTra  := "01261681000104" //  "73355174000140"
   ITP->IdentRec  := "45990181003013" //CGC Bosch
   ITP->CodIntTr  := "27036071"
   ITP->CodIntRe  := "6171" //Codigo do cliente bosch
   ITP->NomTrans  := "01261681000104"//Identificacao do cgc whb fundicao
   ITP->NomRece   := "ROBERT BOSCH LTDA"	
   ITP->Espaco    := Space(09)

MsUnlock("ITP")

  FWrite(cArq,(ITP->(IdentSeg+NumComu+NumVer+NumCont+IdentMov+IdentTra+IdentRec+CodIntTr+CodIntRe+NomTrans+NomRece+Espaco)+cNovaLinha)) 
  DbSelectArea("ITP")
  DbCloseArea()
  
// Close ITP
// ------- Segmento AE1 -----------
_cArqAE1  := CriaTrab(NIL,.f.)
_cArqAE1 += ".DBF"
_aAE1 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE1,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE1,{"NumNF"      ,"C", 06,0})         //  NUMERO DA NF ORIGEM             M    N       6    0    4    9
AADD(_aAE1,{"SerNF"      ,"C", 04,0})         // SERIE DA NOTA FISCAL ORIGEM     M    A       4    0   10   13
AADD(_aAE1,{"DataNF"     ,"C", 06,0})         // DATA DA NOTA FISCAL             M    D       6    0   14   19
AADD(_aAE1,{"QItNf"      ,"C", 03,0})         // QTDE ITENS POR NOTA FISCAL      M    N       3    0   20   22
AADD(_aAE1,{"VlToNF"     ,"C", 17,2})         // VALOR TOTAL DA NOTA FISCAL      M    N      17    2   23   39
AADD(_aAE1,{"QCDec"      ,"C", 01,0})         // QUANTIDADE DE CASAS DECIMAIS    M    N       1    0   40   40
AADD(_aAE1,{"CFO"        ,"C", 03,0})         // CODIGO FISCAL DE OPERACAO       M    N       3    0   41   43
AADD(_aAE1,{"VlToICM"    ,"C", 17,2})         // VALOR TOTAL DO ICMS APLICADO    M    N      17    2   44   60
AADD(_aAE1,{"DataVen"    ,"C", 06,0})         // DATA VENCIMENTO DO DOCUMENTO    M    D       6    0   61   66
AADD(_aAE1,{"EspNF"      ,"C", 02,0})         // ESPECIE DA NOTA FISCAL          M    N       2    0   67   68
AADD(_aAE1,{"VlIPI"      ,"C", 17,2})         // VALOR IPI APLICADO              M    N      17    2   69   85
AADD(_aAE1,{"CodFabEn"   ,"C", 03,0})         // CODIGO DA FABRICA ENTREGA       O    A       3    0   86   88
AADD(_aAE1,{"DataPrNF"   ,"C", 06,0})         // DATA PREVISAO ENTREGA DA NF     O    D       6    0   89   94
AADD(_aAE1,{"IdentPer"   ,"C", 04,0})         // IDENT. DO PERIODO DE ENTREGA    O    N       4    0   95   98
AADD(_aAE1,{"DescNO"     ,"C", 20,0})         // DESCR.DA NATUREZA DA OPERA��O   O    A      20    0   99  118
AADD(_aAE1,{"DataEmb"    ,"C", 06,0})         // Data de embarque da mercadoria  M    D       6    0   14   19
AADD(_aAE1,{"HoraEmb"    ,"C", 04,0})         // HOra do embarque da mercadoria  M    D       6    0   14   19
//AADD(_aAE1,{"Espaco"     ,"C", 09,0})         // Espaco                          M    A      19    0  119  128

DbCreate(_cArqAE1,_aAE1)
DbUseArea(.T.,,_cArqAE1,"AE1",.F.) 
    
//---------------  SEGMENTO NF2v0 - COMPLEMENTO DADOS DA NF                    


_cArqNF2  := CriaTrab(NIL,.f.)
_cArqNF2 += ".DBF"
_aNF2 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aNF2,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aNF2,{"VlDesAc"    ,"C", 17,2})         // VALOR DESPESAS ACESSORIAS       O    N      17    2    4   20
AADD(_aNF2,{"VlFrete"    ,"C", 17,2})         // VALOR DO FRETE                  O    N      17    2   21   37
AADD(_aNF2,{"VlSegu"     ,"C", 17,2})         // VALOR DO SEGURO                 O    N      17    2   38   54
AADD(_aNF2,{"VlDesc"     ,"C", 17,2})         // VALOR DO DESCONTO DA NF         O    N      17    2   55   71
AADD(_aNF2,{"Espaco"     ,"C", 57,0})         // Espaco                          M    A      57    0   72  128

DbCreate(_cArqNF2,_aNF2)
DbUseArea(.T.,,_cArqNF2,"NF2",.F.) 


/*               SEGMENTO NF3v0 - ALTERNATIVAS VCTO C/ DESC. NF                 

   Seq  Elem  Nome                            Uso  Tipo  Tam  Dec  Posicao
   ---  ----  ------------------------------  ---  ----  ---  ---  --------

     1  0001  Identificacao Tipo de Segmento  M    A       3    0    1    3
     2  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0    4    9
     3  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   10   13
     4  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   14   19
     5  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   20   23
     6  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   24   29
     7  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   30   33
     8  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   34   39
     9  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   40   43
    10  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   44   49
    11  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   50   53
    12  0085  DATA VENCIMENTO DO DOCUMENTO    O    D       6    0   54   59
    13  0086  QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2   60   63
    14  9999  Espaco                          M    A      65    0   64  128

*/



//---------------- SEGMENTO AE2v0 - DADOS DO ITEM                         

_cArqAE2  := CriaTrab(NIL,.f.)
_cArqAE2 += ".DBF"
_aAE2 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE2,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE2,{"NumItNF"    ,"C", 03,0})         // NUMERO DO ITEM NA NOTA FISCAL   M    N       3    0    4    6
AADD(_aAE2,{"NumPed"     ,"C", 12,0})         // NUMERO DO PEDIDO DE COMPRA      M    A      12    0    7   18
AADD(_aAE2,{"CodItem"    ,"C", 30,0})         // CODIGO DO ITEM                  M    A      30    0   19   48
AADD(_aAE2,{"QINF"       ,"C", 09,0})         // QTDE ITEM UNIDADE NOTA FISCAL   M    N       9    0   49   57
AADD(_aAE2,{"UnMedNF"    ,"C", 02,0})         // UNIDADE MEDIDA NOTA FISCAL      M    A       2    0   58   59
AADD(_aAE2,{"CodClasF"   ,"C", 10,0})         // CODIGO DE CLASSIFICACAO FISCAL  M    N      10    0   60   69
AADD(_aAE2,{"AliIPI"     ,"C", 04,2})         // ALIQUOTA IPI                    M    N       4    2   70   73
AADD(_aAE2,{"VlItem"     ,"C", 12,5})         // VALOR DO ITEM                   M    N      17    2   74   90
AADD(_aAE2,{"QItEst"     ,"C", 09,0})         // QTDE ITEM UNIDADE ESTOQUE       O    N       9    0   91   99
AADD(_aAE2,{"UnMedEs"    ,"C", 02,0})         // UNIDADE MEDIDA ESTOQUE          O    A       2    0  100  101
AADD(_aAE2,{"QtUniCom"   ,"C", 09,0})         // QTDE UNIDADE DE COMPRA          O    N       9    0  102  110
AADD(_aAE2,{"UnMedCo"    ,"C", 02,0})         // UNIDADE MEDIDA COMPRA           O    A       2    0  111  112
AADD(_aAE2,{"CodTpFo"    ,"C", 01,0})         // CODIGO DO TIPO DE FORNECIMENTO  O    A       1    0  113  113
AADD(_aAE2,{"QtPerDe"    ,"C", 04,2})         // QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2  114  117
AADD(_aAE2,{"VlToDes"    ,"C", 11,2})         // VALOR TOTAL DESCONTO ITEM       O    N      11    2  118  128
AADD(_aAE2,{"AltTec"     ,"C", 04,0})         // alteracao tecnica do item       M    A      05    0  128  128
AADD(_aAE2,{"Espaco"     ,"C", 01,0})         // Espaco                          M    A      05    0  128  128

DbCreate(_cArqAE2,_aAE2)
DbUseArea(.T.,,_cArqAE2,"AE2",.F.) 


//-------------  SEGMENTO AE4v3 - DADOS COMPLEMENTARES DO ITEM                  

_cArqAE4  := CriaTrab(NIL,.f.)
_cArqAE4 += ".DBF"
_aAE4 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE4,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE4,{"AlICM"      ,"C", 04,2})         // ALIQUOTA ICMS                   M    N       4    2    4    7
AADD(_aAE4,{"BasICM"     ,"C", 17,2})         // BASE DE CALCULO DO ICMS         M    N      17    2    8   24
AADD(_aAE4,{"VlICMAp"    ,"C", 17,2})         // VALOR DO ICMS APLICADO          M    N      17    2   25   41
AADD(_aAE4,{"VlIPIAp"    ,"C", 17,2})         // VALOR DO IPI APLICADO           M    N      17    2   42   58
AADD(_aAE4,{"CodSiTr"    ,"C", 02,0})         // CODIGO DE SITUACAO TRIBUTARIA   M    A       2    0   59   60
AADD(_aAE4,{"NumDesIt"   ,"C", 30,0})         // NUMERO DESENHO DO ITEM          O    A      30    0   61   90
AADD(_aAE4,{"DatValDe"   ,"C", 06,0})         // DATA DE VALIDADE DESENHO        O    D       6    0   91   96
AADD(_aAE4,{"PedRev"     ,"C", 13,0})         // pedido da revenda               O    D       6    0   91   96                                                                                                              
AADD(_aAE4,{"PesoLiq"    ,"C", 05,0})         // peso liquido do item            O    D       6    0   91   96
AADD(_aAE4,{"MulPre"     ,"C", 01,0})         // multiplicador de preco unitario O    D       6    0   91   96
AADD(_aAE4,{"PreTot"     ,"C", 12,2})         // preco total da mercadoria       O    D       6    0   91   96
AADD(_aAE4,{"SitTri"     ,"C", 01,0})         // Situa�ao tributaria federal     M    A      10    0   97  128


DbCreate(_cArqAE4,_aAE4)
DbUseArea(.T.,,_cArqAE4,"AE4",.F.) 
  
 
//------------  SEGMENTO AE3v0 - DADOS ADICIONAIS DE COMERCIAL.                 


_cArqAE3  := CriaTrab(NIL,.f.)
_cArqAE3 += ".DBF"
_aAE3 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE3,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE3,{"IdentFat"   ,"C", 14,0})         // IDENT. LOCAL FATURAMENTO        M    N      14    0    4   17
AADD(_aAE3,{"IdentCob"   ,"C", 14,0})         // IDENT. DO LOCAL DE COBRANCA     M    N      14    0   18   31
AADD(_aAE3,{"IdentEnt"   ,"C", 14,0})         // IDENT. LOCAL DE ENTREGA         M    A      14    0   32   45
AADD(_aAE3,{"Espaco"     ,"C", 83,0})         // Espaco                          M    A      83    0   46  128

DbCreate(_cArqAE3,_aAE3)
DbUseArea(.T.,,_cArqAE3,"AE3",.F.)       
    
 

//--------------- SEGMENTO TE1v0 - TEXTO LIVRE                          

_cArqTE1  := CriaTrab(NIL,.f.)
_cArqTE1 += ".DBF"
_aTE1 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aTE1,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aTE1,{"Texto1"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0    4   43
AADD(_aTE1,{"Texto2"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0   44   83
AADD(_aTE1,{"Texto3"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0   84  123
AADD(_aTE1,{"Espaco"     ,"C", 05,0})         // Espaco                          M    A       5    0  124  128

DbCreate(_cArqTE1,_aTE1)
DbUseArea(.T.,,_cArqTE1,"TE1",.F.) 
   

//-------------  SEGMENTO FTPv0 - Segmento Final Mensagem                    
                    
                    
_cArqFTP  := CriaTrab(NIL,.f.)
_cArqFTP += ".DBF"
_aFTP := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aFTP,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aFTP,{"NumCont"    ,"C", 05,0})         // Numero de Controle Movimento    O    N       5    0    4    8
AADD(_aFTP,{"QtdeSeg"    ,"C", 09,0})         // Quantidade de Segmentos         M    N       9    0    9   17
AADD(_aFTP,{"NumToVl"    ,"C", 17,0})         // Numero Total de Valores         O    N      17    2   18   34
AADD(_aFTP,{"CatOper"    ,"C", 01,0})         // Categoria da Operacao           O    A       1    0   35   35
AADD(_aFTP,{"Espaco"     ,"C", 93,0})         // Espaco                          M    A      93    0   36  128

DbCreate(_cArqFTP,_aFTP)
DbUseArea(.T.,,_cArqFTP,"FTP",.F.) 
  

// ------- Segmento para mostrar no browse -----------

_cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aDBF := {}
                                                  // Nome              
AADD(_aDBF,{"OK"         ,"C", 02,0})         // Identificacao Marca
AADD(_aDBF,{"Nota"       ,"C", 09,0})         //  NUMERO DA NF 
AADD(_aDBF,{"Serie"      ,"C", 02,0})         // SERIE DA NOTA FISCAL 
AADD(_aDBF,{"Dta"        ,"C", 10,0})         // DATA DA NOTA FISCAL 
AADD(_aDBF,{"Prodcli"    ,"C", 15,2})         // Codigo do produto cliente
AADD(_aDBF,{"Prodwhb"    ,"C", 15,2})         // Codigo do produto new hubner
AADD(_aDBF,{"Total"      ,"N", 17,2})         // VALOR TOTAL DA NOTA FISCAL 
AADD(_aDBF,{"Espaco"     ,"C", 63,0})         // ESPACO

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"DBF",.F.) 
  

Return                                

User Function fLegbh()

Private aCores := {{ "ENABLE"  , "Nota nao Selecionada" },;
                   { "DISABLE" , "Nota Selecionada" }}

BrwLegenda(cCadastro,"Legenda",aCores)

Return

//marca todas as notas
User Function fMarcabh()

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
User Function fDesMarbh()

   DBF->(DbGoTop())
   While !DBF->(eof())     
      
      RecLock("DBF")
         DBF->OK := "  "
      MsUnlock("DBF")
      DBF->(Dbskip())
   Enddo   
   MarkBRefresh()
Return
