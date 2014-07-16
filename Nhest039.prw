/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHEST039  � Autor � Alexandre R. Bento     Data � 28/06/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Controle de Orderm de Libera��o                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Rdmake                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Expedi��o/ PCP / Controladoria / Portaria                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"

User Function nhest039(cPar01)
SetPrvt("_cDoc,_cCli,_dData,_cHora,_cTransp,_cMot,_cRG,_cPCam,_cPCar,_x,_lPrim,_dDataEn,_cHoraEn,_cNFExc")
SetPrvt("_cModTrans,nMax,aHeader,aCols,oMultiline,cQuery,cQuery1,oBtMed,aMed,nLdlg,nCdlg,_SolNor,nI,_aPri,_cPri,_cTPCarg")  
SetPrvt("_cPar,_cExpNom,_dExpDat,_cExpHor,_cConNom,_dConDat,_cConHor,_cPorNom,_dPorDat,_cPorHor,_cObs,_lNFExc")
SetPrvt("_cTPCarg,_cFrete,_nValFre,_nValPed,_nValICM,_dDtEntr,_cHrEntr,_cLacre,_Linha,_cObsexp,_cOrdCar,_cHrJan,_cHrJanF,_cDesCli")

DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10                                                                  
_lNFExc  := .F.
 nMax    := 1        
 _cDoc   := SZM->ZM_DOC
_cCli    := Space(37)
_cDesCli := Space(30)
_cNFExc  := Space(20)
_dData   := date()
_cHora   := time()   
_cTransp := Space(30)
_cMot    := Space(30)
_cRG     := Space(10)
_cPCam   := Space(08)
_cPCar   := Space(08)
_cDesc   := Space(30)
_cProd   := Space(15)  
_dExpDat := Space(08)
_cExpHor := Space(05)  
_cExpNom := Space(30)
_cModTrans := ""
_dConDat := Space(08)
_cConHor := Space(05)  
_cConNom := Space(30)
_cObs    := Space(100)
_dPorDat := Space(08)
_cPorHor := Space(05)  
_cPorNom := Space(30)
_dDataEn := Space(08)
_cHoraEn := Space(05)               
_cTPCarg := Space(10)
_cFrete  := Space(06)
_nValFre := 0        
_nValPed := 0                             
_nValICM := 0        
_dDtEntr := Space(08)
_cHrEntr := Space(05)  
_cLacre  := Space(50)
_cHrJan  := Space(05)
_cHrJanF := Space(05)
_cObsexp := Space(100)
_cOrdCar := Space(100)

_cPar    := cPar01 // receber visualiza�ao ou impressao      
_lPrim   := .F.
_aPri    := {" ","1","2" ,"3","4","5","6","7","8","9","10","11","12"}
_cPri    := " "

Private nOpc   := 0
Private bOk    := {||nOpc:=1,_SolNor:End()}
Private bCancel:= {||nOpc:=0,_SolNor:End()} 
Private cPerg := "EST021"                                

Processa({|| Gerando1() }, OemToAnsi("Ordem de Libera��o"))

   TMP->(DbCloseArea())

Return

Static Function Gerando1()

	PROCREGUA(0)
	
	INCPROC()
	
   cQuery := "SELECT SA4.A4_NOME,SA4.A4_TEL,SB1.B1_DESC,SZM.*,SZN.*, "
   cQuery += " 'CLIENTE' = "
   cQuery += "CASE "
   cQuery += "   WHEN SF2.F2_TIPO = 'B' THEN "
   cQuery += "        (SELECT SA2.A2_NOME FROM " +  RetSqlName( 'SA2' ) +" SA2 " 
   cQuery += "         WHERE SA2.D_E_L_E_T_ = ' ' AND SA2.A2_COD = SF2.F2_CLIENTE "
   cQuery += "         AND SA2.A2_LOJA = SF2.F2_LOJA) "
   cQuery += "   ELSE "
   cQuery += "        (SELECT SA1.A1_NOME FROM " +  RetSqlName( 'SA1' ) +" SA1 " 
   cQuery += "         WHERE SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SF2.F2_CLIENTE "
   cQuery += "         AND SA1.A1_LOJA = SF2.F2_LOJA) "
   cQuery += "END "
   cQuery += "FROM " +  RetSqlName( 'SZM' ) +" SZM, " +  RetSqlName( 'SZN' ) +" SZN, "+ RetSqlName( 'SB1' ) +" SB1, "
   cQuery += RetSqlName( 'SA4' ) +" SA4, "  + RetSqlName( 'SF2' ) +" SF2"   
   cQuery += " WHERE SF2.F2_DOC = SZN.ZN_NFISCAL "
   cQuery += " AND SF2.F2_SERIE = SZN.ZN_SERIE "     
   cQuery += " AND SZM.ZM_FILIAL = '" + xFilial("SZM")+ "'" 
   cQuery += " AND SZN.ZN_FILIAL = '" + xFilial("SZN")+ "'" 
   cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"    
   cQuery += " AND SA4.A4_FILIAL = '" + xFilial("SA4")+ "'"    
   cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2")+ "'"       
   cQuery += " AND SZM.ZM_DOC = '" + _cDoc + "' "                                                                                                   
   cQuery += " AND SZM.ZM_DOC = SZN.ZN_DOC" 
   cQuery += " AND SZN.ZN_COD = SB1.B1_COD"
   cQuery += " AND SZM.ZM_TRANSP = SA4.A4_COD"
   cQuery += " AND SZM. D_E_L_E_T_ = ' ' AND SZN. D_E_L_E_T_ = ' '" 
   cQuery += " AND SB1. D_E_L_E_T_ = ' ' AND SF2. D_E_L_E_T_ = ' '" 
   cQuery += " AND SA4. D_E_L_E_T_ = ' '" 
   cQuery += " ORDER BY SZM.ZM_FILIAL,SZM.ZM_DOC ASC"    


	//TCQuery Abre uma workarea com o resultado da query
	//MemoWrit('C:\TEMP\NHEST039.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"      
	TcSetField("TMP","ZM_DATAENT","D")  // Muda a data de string para date    
	TcSetField("TMP","ZM_DATAEXP","D")  // Muda a data de string para date    
	TcSetField("TMP","ZM_DATACON","D")  // Muda a data de string para date    
	TcSetField("TMP","ZM_DATAPOR","D")  // Muda a data de string para date    
	TcSetField("TMP","ZM_DTENTRE","D")  // Muda a data de string para date    
	
	DbSelectArea("TMP")
	TMP->(DBGotop())       
	If Empty(TMP->ZM_DOC)
	   TMP->(DbCloseArea()) //Fecha a area da consulta
	   DbClearFil(NIL)
	   IF SZM->(Dbseek(xFilial("SZM")+_cDoc))
	      SA1->(DbSetOrder(1))
	      If SA1->(DbSeek(xFilial("SA1")+SZM->ZM_CLIENTE+SZM->ZM_LOJA))
	         _cDesCli := SA1->A1_NOME
	      
	      Else                    
	         SA2->(DbSetOrder(1))
	         If SA2->(DbSeek(xFilial("SA2")+SZM->ZM_CLIENTE+SZM->ZM_LOJA))
	            _cDesCli := SA2->A2_NOME
	         Endif
	      Endif
	      fGerNFEx()
	      _lNFExc := .T.
	   Else
	      MsgBox("Nenhuma Orderm de Libera��o Encontrada","Aten�ao","ALERT") 
	      DbSelectArea("TMP")
	      DbCloseArea()
	      return
	   Endif   
	Endif
	
	//Alert("nhEST039  "+Strzero(paramixb,1))
	If _cPar == 2 .Or. _cPar == 5 .Or. _cPar == 9 //visualiza��o ou exclus�o ou frete/entrega
	   Processa( {|| fRptDet() }, "Aguarde Pesquisando...")
	Elseif _cPar == 6   
	   Processa( {|| fRelOrd() }, "Aguarde Imprimindo...")
	Elseif _cPar == 7   
	   Processa( {|| fRptDet() }, "Aguarde Gravando...")   
	Elseif _cPar == 8   
	   Processa( {|| fPortari() }, "Aguarde Gravando...")      
	Endif   
	
Return


Static Function fGerNFEx() 
//Local cQuery1   

// cQuery1 := "DECLARE @CLIENTE CHAR(30) SET @CLIENTE = '"+_cDesCli + "' "
   cQuery1 := "SELECT SA4.A4_NOME, SA4.A4_TEL, SB1.B1_DESC,SZM.*,SZN.* "
   cQuery1 += "FROM " +  RetSqlName( 'SZM' ) +" SZM, " +  RetSqlName( 'SZN' ) +" SZN, "+ RetSqlName( 'SB1' ) +" SB1, "
   cQuery1 += RetSqlName( 'SA4' ) +" SA4 "
   cQuery1 += " WHERE SZM.ZM_FILIAL = '" + xFilial("SZM")+ "'" 
   cQuery1 += " AND SZN.ZN_FILIAL = '" + xFilial("SZN")+ "'" 
   cQuery1 += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"    
   cQuery1 += " AND SA4.A4_FILIAL = '" + xFilial("SA4")+ "'"    
   cQuery1 += " AND SZM.ZM_DOC = '" + _cDoc + "' "                                                                                                   
   cQuery1 += " AND SZM.ZM_DOC = SZN.ZN_DOC" 
   cQuery1 += " AND SZN.ZN_COD = SB1.B1_COD"
   cQuery1 += " AND SZM.ZM_TRANSP = SA4.A4_COD"
   cQuery1 += " AND SZM. D_E_L_E_T_ = ' ' AND SZN. D_E_L_E_T_ = ' '" 
   cQuery1 += " AND SB1. D_E_L_E_T_ = ' '" 
   cQuery1 += " AND SA4. D_E_L_E_T_ = ' '" 
   cQuery1 += " ORDER BY SZM.ZM_FILIAL,SZM.ZM_DOC ASC"    


//TCQuery Abre uma workarea com o resultado da query
MemoWrit('C:\TEMP\NHEST039a.SQL',cQuery1)
TCQUERY cQuery1 NEW ALIAS "TMP"      
TcSetField("TMP","ZM_DATAENT","D")  // Muda a data de string para date    
TcSetField("TMP","ZM_DATAEXP","D")  // Muda a data de string para date    
TcSetField("TMP","ZM_DATACON","D")  // Muda a data de string para date    
TcSetField("TMP","ZM_DATAPOR","D")  // Muda a data de string para date    
TcSetField("TMP","ZM_DTENTRE","D")  // Muda a data de string para date    

Return

Static Function fRptDet()  
Local lExcOrdLib := .t. // variavel para validar a exclusao da ordem de liberacao
aHeader     := {}
aCols       := {}
_cCli       := Space(40)
_lPrim      := .F.
_aModTrans  := {"Carreta","Truck","Bug","Outro"}

Aadd(aHeader,{"Nota"       , "UM",  "@!"               ,13,0,".F.","","C",""}) //03
Aadd(aHeader,{"Emissao"    , "ZN_EMISSAO"  ,"99/99/9999" ,10,0,".F.","","C","SZN"}) //06
Aadd(aHeader,{"Produto"    , "UM"  ,Repli("!",40)      ,40,0,".F.","","C",""}) //03
Aadd(aHeader,{"Quantidade" , "UM"  ,Repli("!",12)      ,12,0,".F.","","C",""}) //03
Aadd(aHeader,{"Volume"     , "UM",  "@!"               ,02,0,".F.","","C",""}) //03
Aadd(aHeader,{"NF Remessa" , "ZN_NFRET", "@!"          ,41,0,".F.","","C","SZN"}) //03

TMP->(DBGotop())       

While !TMP->(EOF())
	  
   If !_lPrim 
	  _cDoc     := TMP->ZM_DOC
      _cCli     := TMP->ZM_CLIENTE+"-"+TMP->ZM_LOJA+"-"+ Iif( Empty(_cDesCli),TMP->CLIENTE,_cDesCli)

      _cTransp  := TMP->ZM_TRANSP+"-"+TMP->A4_NOME         
	  _dData    := DTOC(TMP->ZM_DATAEXP)      
	  _cHora    := TMP->ZM_HORAEXP         
      _cMot     := TMP->ZM_MOTORIS
      _cRG      := TMP->ZM_RGMOTOR
      _cPCam    := TMP->ZM_PLACACM
      _cPCar    := TMP->ZM_PLACACR
	  _dExpDat  := TMP->ZM_DATAEXP
      _cExpHor  := TMP->ZM_HORAEXP
  	  _cExpNom  := TMP->ZM_EXPEDI
	  _dConDat  := TMP->ZM_DATACON
	  _cConHor  := TMP->ZM_HORACON
	  _cConNom  := TMP->ZM_CONFERE
	  _dPorDat  := TMP->ZM_DATAPOR
	  _cPorHor  := TMP->ZM_HORAPOR
	  _cPorNom  := TMP->ZM_PORTARI
	  _cObs     := TMP->ZM_OBS
	  _cObsExp  := TMP->ZM_OBSEXP	  
	  _dDataEn  := DtoC(TMP->ZM_DATAENT)
      _cHoraEn  := TMP->ZM_HORAENT
      _cPri     := TMP->ZM_PRIORI  
      _cTPCarg  := TMP->ZM_TPCARGA
      _cFrete   := TMP->ZM_FRETE
      _nValFre  := TMP->ZM_VALFRET
      _nValPed  := TMP->ZM_VALPED
      _nValICM  := TMP->ZM_VALICM      
      
      _dDtEntr  := TMP->ZM_DTENTRE
      _cHrEntr  := TMP->ZM_HRENTRE  
      _cLacre   := TMP->ZM_LACRE
      _cHrJan   := TMP->ZM_HRJANEL
	  _cHrJanF  := TMP->ZM_HRJAFIM  	               
      
      IF !EMPTY(VAL(TMP->ZM_MODTRAN))
	    _cModTrans := _aModTrans[VAL(TMP->ZM_MODTRAN)]
	  ELSE
	  	_cModTrans := ""
	  EndIf
	  
      _cOrdCar   := TMP->ZM_ORDCARR
      
	  _lPrim := .T.
   Endif 
   Aadd(aCols,{TMP->ZN_NFISCAL+"-"+TMP->ZN_SERIE,;                        
               DTOC(TMP->ZM_DATAEXP),;                             
               " "+Subs(TMP->ZN_COD,1,15)+"-"+TMP->B1_DESC,;    
               Transform(TMP->ZN_QUANT,"@E 9999999.99"),Transform(TMP->ZN_VOLUME,"@E 99"),;
               Iif(Empty(Alltrim(TMP->ZN_NFRET))," ",Alltrim(TMP->ZN_NFRET)),.F.})
   If _lNFExc
      If Alltrim(TMP->ZN_OBS)$"EXCLUIDA"
         If !TMP->ZN_NFISCAL$_cNFExc
            _cNFExc := Iif(Empty(Alltrim(_cNFExc)),TMP->ZN_NFISCAL,_cNFExc+"-"+TMP->ZN_NFISCAL)        
         Endif   
      Endif       
   Endif   
   TMP->(DbSkip())
	
EndDo

nMax := Len(aCols)
 
Define MsDialog _SolNor Title OemToAnsi("Ordem de Libera��o de Materiais") From 015,015 To 550,790 Pixel 
@ 018,006 To 115,372 Title OemToAnsi("  Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8            
@ 025,030 Get _cDoc Picture "@!"  When .F. Size 030,8 Object oDoc            
//oDoc:SetFont(oFont)

@ 027,070 Say "Cliente:" Size 30,8            
@ 025,090 Get _cCli  Picture "@!" When .F.  Size 170,8 Object oCli

@ 027,270 Say "Data:" Size 30,8
@ 025,285 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData
@ 025,335 Get _cHora Picture "99:99:99" When .F. Size 25,8 Object oHora

@ 040,010 Say "Transportadora:" Size 050,8            
@ 038,050 Get _cTransp Picture "@!" When .F. Size 120,8 Object oTransp

@ 040,175 Say "Dt Entrada:" Size 030,8 object oDtEntrada  
@ 038,205 Get _dDataEn Picture "99/99/9999" When .F. Size 35,8 Object oDataEn
@ 040,243 Say "Hr Entrada:" Size 030,8 object oHrEntrada            
@ 038,270 Get _cHoraEn Picture "@!" When .F. Size 25,8 Object oHoraEn

@ 053,010 Say OemToAnsi("Placa Caminh�o:") Size 050,8                    
@ 051,050 Get _cPCam Picture "!!!-!!!!" When .F. Size 030,8 Object oPCam             
@ 053,095 Say OemToAnsi("Placa Carreta :") Size 050,8
@ 051,135 Get _cPCar Picture "!!!-!!!!" When .F. Size 030,8 Object oPCar                                 

//@ 053,205 Say "Tipo Carga:" Size 050,8 
//@ 051,235 Get _cTPCarg Picture "@!" When .F. Size 030,8 Object oTPCarg  


@ 053,175 Say "Hr.Jan. Ini:" Size 025,8  object oHrja             
@ 051,205 Get _cHrJan Picture "!!:!!" When .F. Size 10,8 Object oHrJan             

@ 053,243 Say "Hr.Jan.Fim:" Size 030,8  object oHrjafim             
@ 051,270 Get _cHrJanF Picture "!!:!!" When .F. Size 10,8 Object oHrJanfim             

@ 053,310 Say "Prioridade:" Size 040,8 object oTPri  
  oTPri:Setfont(oFont10)                                          

@ 051,355 Get _cPri Picture "@!" When .F. Size 010,8 Object oPri  
         

@ 065,010 Say "Motorista :" Size 050,8            
@ 063,050 Get _cMot Picture "@!" When .F. Size 100,8 Object oMot             
@ 065,153 Say "RG :" Size 010,8                    
@ 063,163 Get _cRG Picture "@!" When .F. Size 040,8 Object oRG  

@ 065,218 Say "Tipo Carga:" Size 050,8 
@ 063,248 Get _cTPCarg Picture "@!" When .F. Size 030,8 Object oTPCarg  

@ 065,293 Say "Mod. Transp.:" Size 050,8
@ 063,330 Get _cModTrans Picture "@!" When .F. Size 040,8 Object oModTrans

@ 077,010 Say OemToAnsi("Num Frete :")  Size 050,8
@ 075,050 Get _cFrete Picture "@!" When(_cPar == 9) Size 035,8 Object oFrete
             
@ 077,95 Say OemToAnsi("Valor Frete :") Size 050,8
@ 075,125 Get _nValFre Picture "999,999.99" When(_cPar == 9) Size 050,8 Object oValFre

@ 077,180 Say OemToAnsi("Valor Pedagio :") Size 050,8
@ 075,220 Get _nValPed Picture "999,999.99" When(_cPar == 9) Size 050,8 Object oValPed

@ 077,280 Say OemToAnsi("Valor ICMS :") Size 050,8
@ 075,320 Get _nValICM Picture "999,999.99" When(_cPar == 9) Size 050,8 Object oValICM

@ 089,010 Say OemToAnsi("Num Lacre :") Size 050,8
@ 087,050 Get _cLacre Picture "@!" When(_cPar == 9) Size 125,8 Object oLacre

@ 089,190 Say OemToAnsi("Obs Exp:") Size 050,8
@ 087,220 Get _cObsexp Picture "@!" When(_cPar == 9) Size 150,8 Object oObsexp

@ 101,010 Say OemToAnsi("Ordem Entrega:") Size 050,8
@ 099,050 Get _cOrdCar Picture "@!" When(_cPar == 9) Size 320,8 Object oOrdCar

@ 117,006 To 212,372 Title OemToAnsi("  Informa��es ")  
@ 127,008 TO 210,370 MULTILINE MODIFY OBJECT oMultiline

@ 215,010 Say "Expedidor:" Color CLR_GREEN  Size 050,8            
@ 215,050 Get UsrFullName(_cExpNom) Picture "@!" When .F. Size 140,8 Object oExpNom             

@ 215,200 Say "Hora:" Color CLR_GREEN  Size 020,8            
@ 215,220 Get _cExpHor Picture "@!" When .F. Size 40,8 Object oExpHor
             
@ 215,290 Say "Data:" Color CLR_GREEN  Size 020,8            
@ 215,310 Get _dExpDat Picture "@!" When .F. Size 40,8 Object oExpDat
                   
If !Empty(_cConNom) //mostra somente se j� foi lirado pelo conferente
   @ 227,010 Say "Conferente:" Color CLR_GREEN  Size 050,8            
   @ 227,050 Get UsrFullName(_cConNom) Picture "@!" When .F. Size 140,8 Object oConNom             
   @ 227,200 Say "Hora:" Color CLR_GREEN  Size 020,8            
   @ 227,220 Get _cConHor Picture "@!" When .F. Size 40,8 Object oConHor
   @ 227,290 Say "Data:" Color CLR_GREEN  Size 020,8            
   @ 227,310 Get _dConDat Picture "@!" When .F. Size 40,8 Object oConDat
Endif   

If !Empty(_cPorNom)//mostra somente se j� foi lirado pela portaria
   @ 239,010 Say "Portaria :" Color CLR_GREEN  Size 050,8            
   @ 239,050 Get UsrFullName(_cPorNom) Picture "@!" When .F. Size 140,8 Object oPorNom             
   @ 239,200 Say "Hora:" Color CLR_GREEN  Size 020,8            
   @ 239,220 Get _cPorHor Picture "@!" When .F. Size 40,8 Object oPorHor
   @ 239,290 Say "Data:" Color CLR_GREEN  Size 020,8            
   @ 239,310 Get _dPorDat Picture "@!" When .F. Size 40,8 Object oPorDat
Endif   
                              
If !Empty(_cObs)//mostra somente se existe Observa�ao na Ordem de libera��o
   @ 251,010 Say "Obs :" Color CLR_GREEN  Size 050,8
   @ 251,030 Get _cObs Picture "@!" When .F. Size 320,8 Object oOBS             
Endif

if _cPar == 7   
   @ 251,010 Say "Obs :" Color CLR_GREEN  Size 050,8            
   @ 251,030 Get _cObs Picture "@!" Size 320,8 Object oOBS             
Endif

oMultiline:nMax := Len(aCols) //n�o deixa o usuario adicionar mais uma linha no multiline
Activate MsDialog _SolNor On Init EnchoiceBar(_SolNor,bOk,bCancel,,) Centered

If _lNFExc // Verifica se a Nota amarrada a Ordem de Solicita��o foi excluida

   MsgBox("A Nota  " + _cNFExc + "  Foi Excluida desta Ordem de Liberacao ","Aten�ao","STOP") 
   If nopc == 1 .And. _cPar <> 9 // se nao for A opcao de  Frete/entrega sai fora
      return  
   Endif   
Endif

If nopc == 1 .And. _cPar == 5 //exclus�o

   SZM->(DbsetOrder(1)) //filial+doc
   SD2->(DbsetOrder(3)) //filial+doc+serie+cliente+loja+codigo+item
   
   If SZM->(Dbseek(xFilial("SZM")+_cDoc))

	  SZN->(Dbseek(xFilial("SZN")+_cDoc)) 
		
		If !Empty(SZM->ZM_PORTARI)

	    	ZAF->(DbSetOrder(2)) //FILIAL+DOC+SERIE 
	      	While SZN->(!EOF()) .AND. SZN->ZN_FILIAL==xFilial('SZN') .AND. SZN->ZN_DOC == _cDoc		      
		    	
		    	//-- verifica se existe solic. de exclusao de nf
	    	  	If !ZAF->(dbseek(xFilial('ZAF')+SZN->ZN_NFISCAL+SZN->ZN_SERIE))
	    	  		lExcOrdLib := .f.
	    	  	Endif
	    	 
	    	 	SZN->(dbskip())
	    	 Enddo
      	EndIf
      	
      	SZN->(dbgotop())
      	SZN->(Dbseek(xFilial("SZN")+_cDoc))
      
		If lExcOrdLib 
			If MsgYesNo("Ordem j� liberada pela portaria, deseja continuar?")
      	
		      	While SZN->(!EOF()) .AND. SZN->ZN_FILIAL==xFilial('SZN') .AND. SZN->ZN_DOC == _cDoc
	    	      	SD2->(Dbseek(xFilial("SD2")+SZN->ZN_NFISCAL+SZN->ZN_SERIE+SZM->ZM_CLIENTE+SZM->ZM_LOJA+SZN->ZN_COD))                                
	              	While SD2->(!EOF()) .And. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == SZN->ZN_NFISCAL+SZN->ZN_SERIE+SZM->ZM_CLIENTE+SZM->ZM_LOJA
	        			If !Empty(SD2->D2_ORDLIB) .And. SD2->D2_QUANT == SZN->ZN_QUANT
	                    RecLock("SD2",.F.)
	                    	SD2->D2_ORDLIB = ' ' //libera a nota para gerar outra ordem de libera��o
	                    MsUnlock("SD2")
	                  	Endif   
	                  	
	                  	SD2->(Dbskip())
	               	Enddo   
	
	               	RecLock("SZN",.F.)
	                 	SZN->(Dbdelete())
	               	MsUnlock("SZN")   
	            
	               	SZN->(Dbskip())
				Enddo 
	
	            RecLock("SZM",.F.)
	               SZM->(Dbdelete())
	            MsUnlock("SZM")   
			EndIf	
  	  	Else
	  		Alert('Ordem j� liberada pela portaria!'+CHR(13)+CHR(10)+'Para excluir � necess�ria a Solic. de Exclus�o da(s) NF(s)!')
  		Endif
   	Else
   	  	Alert("Libera��o "+_cDoc+" n�o encontrada!")
   	Endif   

ElseIf nopc == 1 .And. _cPar == 7 //conferente
   SZM->(DbsetOrder(1)) //filial+doc
   If SZM->(Dbseek(xFilial("SZM")+_cDoc))
      If Empty(SZM->ZM_HORACON) //.And. Empty(SZM->ZM_PORTARI) //verifica se realmente esta em aberto a ord. de libera��o pelo conferente
         Begin Transaction  
            RecLock("SZM",.F.)
        	   SZM->ZM_CONFERE := __cUserID 
	           SZM->ZM_HORACON := Time()
	           SZM->ZM_DATACON := Date()
               SZM->ZM_OBS     := _cObs	           
            MsUnlock("SZM")   
         End Transaction  
      Endif   
   Endif                
ElseIf nopc == 1 .And. _cPar == 9 //Frete data entrega
   SZM->(DbsetOrder(1)) //filial+doc
   If SZM->(Dbseek(xFilial("SZM")+_cDoc))
      Begin Transaction  
         RecLock("SZM",.F.)
      	   SZM->ZM_FRETE   := _cFrete 
	       SZM->ZM_VALFRET := _nValFre  
	       SZM->ZM_VALPED  := _nValPed  
	       SZM->ZM_VALICM  := _nValICM  	       	       
	       SZM->ZM_DTENTRE := _dDtEntr
           SZM->ZM_HRENTRE := _cHrEntr
        MsUnlock("SZM")   
     End Transaction  
   Endif                
Endif

Return

//Grava�ao da Portaria
Static Function fPortari()
   SZM->(DbsetOrder(1)) //filial+doc
   If SZM->(Dbseek(xFilial("SZM")+_cDoc))                                                                
   //verifica se realmente esta em aberto a ord. de libera��o pela portaria e j� foi fechada pelo conferente  
      If Empty(SZM->ZM_HORAPOR) .And. Empty(SZM->ZM_HORACON)
         If MsgBox("Ordem de Libera��o numero "+SZM->ZM_DOC +" Nao foi Liberada pelo Conferente"+Chr(13)+;
                   "Confirma a Liberacao Mesmo Assim","Aten�ao","YESNO") 

	         Begin Transaction  
	            RecLock("SZM",.F.)
	         	   SZM->ZM_PORTARI := __cUserID 
		           SZM->ZM_HORAPOR := Time()
		           SZM->ZM_DATAPOR := Date()
	            MsUnlock("SZM")                         
	         
	         	//-- DE ACORDO COM A OS NUMERO: 062054
	         	//-- NAO DEVE MAIS FECHAR O CADASTRO DE VEICULO APENAS PELA PLACA
	         	//-- DEVE UTILIZAR AMARACAO COM O CAMPO ZM_CODPLAC
	         	
			    /*
			    SO5->(DbSetOrder(4))
                SO5->(Dbseek(xFilial("SO5")+TMP->ZM_PLACACM))
                While !SO5->(EOF()) .And. TMP->ZM_PLACACM == SO5->O5_PLACA
        
                   If Empty(SO5->O5_HORASAI)             
	                  RecLock("SO5",.F.)
	  	                 SO5->O5_DTSAIDA := Date() //Data de saida do veiculo
    		             SO5->O5_HORASAI := Time() // hora de saida do veiculo         	     
	                  MsUnlock("SO5")     
                   Endif
                   exit //se achou for�a a saida do loop
                   SO5->(Dbskip())
                Enddo
                */
                
	         End Transaction  
	     Else
            MsgBox("Ordem de Libera��o numero "+SZM->ZM_DOC +" Nao foi Liberada","Aten�ao","ALERT") 
         Endif   
      Elseif Empty(SZM->ZM_HORAPOR)
	        
	         Begin Transaction  
	            RecLock("SZM",.F.)
	         	   SZM->ZM_PORTARI := __cUserID 
		           SZM->ZM_HORAPOR := Time()
		           SZM->ZM_DATAPOR := Date()
	            MsUnlock("SZM")   
	            
	         	//-- DE ACORDO COM A OS NUMERO: 062054
	         	//-- NAO DEVE MAIS FECHAR O CADASTRO DE VEICULO APENAS PELA PLACA
	         	//-- DEVE UTILIZAR AMARACAO COM O CAMPO ZM_CODPLAC
	         	
			    /*
			    SO5->(DbSetOrder(4))
                SO5->(Dbseek(xFilial("SO5")+TMP->ZM_PLACACM))
                While !SO5->(EOF()) .And. TMP->ZM_PLACACM == SO5->O5_PLACA
        
                   If Empty(SO5->O5_HORASAI)             
	                  RecLock("SO5",.F.)
	  	                 SO5->O5_DTSAIDA := Date() //Data de saida do veiculo
    		             SO5->O5_HORASAI := Time() // hora de saida do veiculo         	     
	                  MsUnlock("SO5")     
                      exit //se achou for�a a saida do loop	                  
                   Endif
                   SO5->(Dbskip())
                Enddo   
                */
                
	         End Transaction  
      Endif   
   Endif                
   
Return   

//Grava�ao do conferente
Static Function fConfere()
   SZM->(DbsetOrder(1)) //filial+doc
   If SZM->(Dbseek(xFilial("SZM")+_cDoc))
      If Empty(SZM->ZM_HORACON)//verifica se realmente esta em aberto a ord. de libera��o pelo conferente
         Begin Transaction  
            RecLock("SZM",.F.)
        	   SZM->ZM_CONFERE := __cUserID 
	           SZM->ZM_HORACON := Time()
	           SZM->ZM_DATACON := Date()
            MsUnlock("SZM")   
         End Transaction  
      Endif   
   Endif                
   
Return   


Static Function fRelOrd()

//SetPrvt("NQTDE1,NQTDE2,NQTDE3,nEtq")

cString   := "SZM"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Ordem de Libera��o de Materiais")           	
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST039"
nLastKey  := 0
titulo    := "ORDEM DE LIBERA��O DE MATERIAIS / ROTEIRO DE ENTREGA"
Cabec1    := " "
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHEST039"
_cPerg    := "EST039" 
//aOrd      := {OemToAnsi("Por Produto"),OemToAnsi("Por Etiqueta")} // ' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '

//AjustaSx1()                                                               
                     
/*
If !Pergunte(_cPerg,.T.)
    Return(nil)
Endif   
*/
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

//if aReturn[8] == 2 //ordem por etiqueta
//   Cabec1    := "COD PRODUTO    COD.CLIENTE    DESCRI��O DO PRODUTO            ETIQ    DOC    ALM LOCALIZ      QTDE "
//Endif   

Processa( {|| RptDetail() },"Imprimindo...")

//Close TMP

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function RptDetail()
Local _lVerif := .F.
Local _nVol := 0 //inicializa o total de volumes

PROCREGUA(0)

_aModTrans  := {"CARRETA","TRUCK","BUG","OUTRO"}

IF !EMPTY(VAL(TMP->ZM_MODTRAN))
	_cModTrans := _aModTrans[VAL(TMP->ZM_MODTRAN)]
ELSE
 	_cModTrans := ""
EndIf
	  
_cOrdCar := TMP->ZM_ORDCARR

TMP->(Dbgotop())

Cabec1 := "Num.Liberacao : "+TMP->ZM_DOC +Space(03)+"Cliente : "+TMP->ZM_CLIENTE+"-"+TMP->ZM_LOJA+"-"+Iif( Empty(_cDesCli),TMP->CLIENTE,_cDesCli ) +Space(20)+TMP->ZM_HORAEXP+Space(07)+Dtoc(TMP->ZM_DATAEXP)

//Traz o endere�o do cliente no cabecalho
SA1->(DbSetOrder(1)) // filial + cod + loja
SA1->(DbSeek(xFilial("SA1")+TMP->ZM_CLIENTE+TMP->ZM_LOJA))
If SA1->(Found())
	Cabec2 := "Endere�o: "+SA1->A1_END+" "+ALLTRIM(SA1->A1_MUN)+" - "+SA1->A1_EST
Else
	Cabec2 := ""
EndIf

Cabec(Titulo,Cabec1,Cabec2,NomeProg, Tamanho,nTipo)

@ Prow() + 1, 000 Psay OemToAnsi("Transportadora : ")+TMP->ZM_TRANSP+"-"+TMP->A4_NOME+Space(10)+"Tel.: "+TMP->A4_TEL
@ Prow() + 2, 000 Psay OemToAnsi("Placa Caminh�o : ")+TMP->ZM_PLACACM+Space(20)+" Placa Carreta :"+TMP->ZM_PLACACR+Space(10)+"Data Entrada:"+DtoC(TMP->ZM_DATAENT)+"    Hora Entrada:"+TMP->ZM_HORAENT

If !Empty(TMP->ZM_LACRE)
   @ Prow() + 1, 000 Psay OemToAnsi("Num Lacre : ")+TMP->ZM_LACRE
Endif                                                            
If !Empty(TMP->ZM_OBSEXP)
   @ Prow() + 1, 000 Psay OemToAnsi("Obs Expedidor: ")+TMP->ZM_OBSEXP
Endif                                                            

_cMot    := TMP->ZM_MOTORIS
_cRG     := TMP->ZM_RGMOTOR                                                   
_cExpNom := UsrFullName(TMP->ZM_EXPEDI) 
_dConDat := Dtoc(TMP->ZM_DATACON)
_cConHor := TMP->ZM_HORACON
_cConNom := UsrFullName(TMP->ZM_CONFERE)
_dPorDat := Dtoc(TMP->ZM_DATAPOR)
_cPorHor := TMP->ZM_HORAPOR
_cPorNom := UsrFullName(TMP->ZM_PORTARI)
_cObs    := Alltrim(TMP->ZM_OBS)
_cObsexp := Alltrim(TMP->ZM_OBSEXP)

@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medi��o
@ Prow() + 1, 000 Psay OemToAnsi(" NOTA           EMISSAO       PRODUTO                                           C.CUSTO             QTDE   VOL   NF S.REMESSA")
          
_Linha = 13

SD2->(dbsetorder(3)) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

While !TMP->(EOF())

INCPROC()

if Prow() > 60
       Cabec(Titulo,Cabec1,"",NomeProg, Tamanho,nTipo)
       @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medi��o
       @ Prow() + 1, 000 Psay OemToAnsi(" NOTA           EMISSAO       PRODUTO                                           C.CUSTO             QTDE   VOL   NF S.REMESSA")
       @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medi��o
endif
   If TMP->ZN_COD == 'IVE18.4.0133.01' .Or. ;
      TMP->ZN_COD == 'IVE18.4.0133.00'
		_lVerif := .T.		
   EndIf

   @ Prow() + 1, 000 Psay TMP->ZN_NFISCAL+"-"+TMP->ZN_SERIE
   @ Prow()    , 015 Psay DTOC(TMP->ZM_DATAEXP) 
   @ Prow()    , 028 Psay Subs(TMP->ZN_COD,1,15)+"-"+TMP->B1_DESC

   If SD2->(dbSeek(xFilial("SD2")+TMP->ZN_NFISCAL+TMP->ZN_SERIE+TMP->ZM_CLIENTE+TMP->ZM_LOJA+Subs(TMP->ZN_COD,1,15))) 
	   @ Prow()    , 080 Psay SD2->D2_CCUSTO
   Endif

   @ Prow()    , 095 Psay Transform(TMP->ZN_QUANT,"@E 9999999.99")
   @ Prow()    , 108 Psay Transform(TMP->ZN_VOLUME,"@E 99")   
   @ Prow()    , 113 Psay Alltrim(TMP->ZN_NFRET)
   _nVol += TMP->ZN_VOLUME //Soma todos os volumes            

   TMP->(DbSkip())
EndDo
@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medi��o
@ Prow() + 1, 086 Psay OemToAnsi("  Total de Volumes: ")+Strzero(_nVol,2)
@ Prow() + 1, 000 Psay OemToAnsi("Motorista : ")+Alltrim(_cMot)+Space(01)+"RG :"+_cRG
@ Prow()    , 070 Psay OemToAnsi("Expedidor :") + _cExpNom
@ Prow() + 2, 000 Psay OemToAnsi("Ass. Motorista ____________________________ ")
@ Prow()    , 070 Psay OemToAnsi("Ass. Expedidor ____________________________ ")

If !Empty(_cConNom)
   @ Prow() + 2, 000 Psay OemToAnsi("Conferente:")+_cConNom
   @ Prow()    , 050 Psay OemToAnsi("Hora :")+_cConHor
   @ Prow()    , 070 Psay OemToAnsi("Data :")+_dConDat        
   If !Empty(_cObs)
      @ Prow() + 1, 000 Psay OemToAnsi("OBS :")+_cObs   
   Endif   
Endif       

If !Empty(_cPorNom)
   @ Prow() + 2, 000 Psay OemToAnsi("Portaria:")+_cPorNom
   @ Prow()    , 050 Psay OemToAnsi("Hora :")+_cPorHor
   @ Prow()    , 070 Psay OemToAnsi("Data :")+_dPorDat
Endif
If _lVerif 
	@ Prow()+2  , 000 Psay OemToAnsi("Empilhamento m�ximo 2        (   )")
	@ Prow()+1  , 000 Psay OemToAnsi("Cintamento da Carga/Caminh�o (   )")
EndIf

@ Prow()+2  , 000 Psay OemToAnsi("MODALIDADE DE TRANSPORTE: "+_cModTrans)
@ Prow()+2  , 000 Psay OemToAnsi("ORDEM DE ENTREGA:"+_cOrdCar)

Return(nil) 

