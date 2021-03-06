#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Rhgp20()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

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
SetPrvt("M_PAG,NOMEPROG,_NLI,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> 	#DEFINE PSAY SAY
#ENDIF

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿛rograma  � RHGP20          � M.GracaNCarvalho      � Data � 14.10.99 낢�
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
nomeprog := "RHGP20"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//�                                                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel := "RHGP20"
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
    RptStatus({|| RHG020()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>     RptStatus({|| Execute(RHG020)})  //-- Chamada do Relatorio.
	Return Nil
#ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function RHG020
Static Function RHG020()
                
DbSelectArea("SRF")
DbSetOrder(01)

DbSelectArea("SRA")
DbSetOrder(01)
SRA->(DbgoTop())
SRA->(SetRegua(RecCount()))

m_pag    := 1

@ 01  , 01 pSay Chr(15)
@ 02  , 01 pSay "MATRIC NOME                           ADMISSAO   PERIODO AQUISITIVO    F_VCDA F_TIRA FALT_V F_PROP FALT_P"
@ 03  , 01 pSay "______ ______________________________ __________ _____________________ ______ ______ ______ ______ ______"
@ 04  , 01 pSay " "
_NLI:=6
SRA->(dbGoTop())
While SRA->(!Eof())
   IncRegua()
   If SRA->RA_SITFOLH=="D" .or. SRA->RA_SITFOLH=="T"
      SRA->(DbSkip())
      Loop
   EndIf   
   If _NLI> 58
      @ 02  , 01 pSay "MATRIC NOME                           ADMISSAO   PERIODO AQUISITIVO    F_VCDA F_TIRA FALT_V F_PROP FALT_P"
      @ 03  , 01 pSay "______ ______________________________ __________ _____________________ ______ ______ ______ ______ ______"
      @ 04  , 01 pSay " "
      _NLI:=6
   Endif
   SRF->(DbSeek(xFilial()+SRA->RA_MAT,.T.))
   @ _NLI  , 01 pSay SRA->RA_MAT
   @ _NLI  , 08 pSay SRA->RA_NOME
   @ _NLI  , 39 pSay SRA->RA_ADMISSA
   @ _NLI  , 50 pSay SRF->RF_DATABAS
   @ _NLI  , 61 pSay SRF->RF_DATABAS+365.25
   @ _NLI  , 72 pSay SRF->RF_DFERVAT Picture "99.9"
   @ _NLI  , 79 pSay SRF->RF_DFERANT Picture "99.9"
   @ _NLI  , 86 pSay SRF->RF_DFALVAT Picture "99.9"
   @ _NLI  , 93 pSay SRF->RF_DFERAAT Picture "99.9"
   @ _NLI  ,100 pSay SRF->RF_DFALAAT Picture "99.9"
   _NLI:=_NLI+2
   SRA->(DbSkip())
Enddo


RestScreen(3,0,24,79,cSavScr1)
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
