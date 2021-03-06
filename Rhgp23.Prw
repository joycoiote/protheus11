#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Rhgp23()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,_NLI,_NTOT13,_NTOTFO")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> 	#DEFINE PSAY SAY
#ENDIF

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿛rograma  � RHGP19          � M.GracaNCarvalho      � Data � 23.12.99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escri뇙o � Resumo de Periodos Aquisitivo de Ferias/Faltas/Saldos     낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿞intaxe   � Chamada padr꼘 para programas em RDMake.                  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""

cabec1:="";cabec2:="";cabec3:="";wnrel:=""

nOrdem:=0
tamanho:="M"
limite :=132
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Relatorio"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "RHGP23"
cPerg    := ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//�                                                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//Pergunte("RHGP19",.F.)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel := "RHGP23"
wnRel := SetPrint("SRA",NomeProg,,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

cabec1 := "."
cabec2 := "."
cabec3 := "." 

#IFDEF WINDOWS
    RptStatus({|| RHG023()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>     RptStatus({|| Execute(RHG023)})  //-- Chamada do Relatorio.
	Return Nil
#ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function RHG023
Static Function RHG023()
                
DbSelectArea("SRI")
DbSetOrder(01)

DbSelectArea("SRC")
DbSetOrder(01)

DbSelectArea("SRA")
DbSetOrder(06)
SRA->(DbgoTop())
SRA->(SetRegua(RecCount()))
_NLI:=1
_NTOT13:=0.00
_NTOTFO:=0.00
While SRA->(!Eof()) 
   IncRegua()
   If (SRA->RA_DEMISSA<CTOD("01/12/99") .AND. SRA->RA_DEMISSA<>CTOD("  /  /  "))  .or. SRA->RA_SITFOLH=="T"
      SRA->(DbSkip())
      Loop
   EndIf   
   @ _NLI  , 01 pSay SRA->RA_MAT
   @ _NLI  , 08 pSay SRA->RA_NOME
   @ _NLI  , 39 pSay SRA->RA_DEMISSA
   @ _NLI  , 50 pSay SRA->RA_PIS
   SRI->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"738",.T.))
   If SRA->RA_FILIAL==SRI->RI_FILIAL .and. SRA->RA_MAT==SRI->RI_MAT .and. SRI->RI_PD=="738"                                                        
      @ _NLI  , 62 pSay SRI->RI_VALOR PICTURE "999,999.99"
      _NTOT13:=_NTOT13+SRI->RI_VALOR
   EndIf   
   SRC->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"738",.T.))
   If SRA->RA_FILIAL==SRC->RC_FILIAL .and. SRA->RA_MAT==SRC->RC_MAT .and. SRC->RC_PD=="738"                                                        
      @ _NLI  , 73 pSay SRC->RC_VALOR PICTURE "999,999.99"
      _NTOTFO:=_NTOTFO+SRC->RC_VALOR
   EndIf   
   @ _NLI  , 84 pSay SRI->RI_VALOR+SRC->RC_VALOR PICTURE "999,999.99"
   _NLI:=_NLI+1
   IF _NLI>65
      _NLI:=1
   ENDIF   
   SRA->(DbSkip())
Enddo
@ _NLI,62 PSAY _NTOT13 PICTURE "999,999.99"
@ _NLI,73 PSAY _NTOTFO PICTURE "999,999.99"
RetIndex("SRA")

RestScreen(3,0,24,79,cSavScr1)
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
