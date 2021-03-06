#INCLUDE "mdtr700.ch"
#Include "FIVEWIN.Ch"
Static nLimite_Dias_Epi
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MDTR700  � Autor �Denis Hyroshi de Souza � Data � 21/10/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o |Perfil Profissiografico Previdenciario  -  P.P.P.           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MDTR700()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Nhmdt004()
//Inicializa constante.
nLimite_Dias_Epi := 30
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
PRIVATE titulo   := STR0006 //"Perfil Profissiografico Previdenciario"
PRIVATE cPerg    :="MDT700"
PRIVATE cabec1, cabec2
PRIVATE cAlias
PRIVATE cDescr
Private nSizeSI3,nSizeSRJ
PRIVATE cEmpPPP := SM0->M0_CODIGO
nSizeSI3 := If((TAMSX3("I3_CUSTO")[1]) < 1,9,(TAMSX3("I3_CUSTO")[1]))
nSizeSRJ := If((TAMSX3("RJ_FUNCAO")[1]) < 1,5,(TAMSX3("RJ_FUNCAO")[1]))
PRIVATE cTypeEnd
PRIVATE lNGMDTPS := .F.
Private cAliasRES := "SRA"
Private cCNomeRES := "SRA->RA_NOME"
Private cCdNitRES := "SRA->RA_PIS"
Private nTamanRES := 6
Private lNG2M400  := .F.

SX6PPPRES() // Verifica conteudo do parametro MV_MDTRESP

cAlias := "SI3"   
cDescr := "SI3->I3_DESC"

Dbselectarea("SX6")
Dbsetorder(1)
If Dbseek(xFilial("SX6")+"MV_MCONTAB")        
	If Alltrim(GETMV("MV_MCONTAB")) == "CTB"
		cAlias := "CTT"
		cDescr := "CTT->CTT_DESC01"
	Endif
Endif

If Dbseek(xFilial("SX6")+"MV_NGMDTPS")
	If Alltrim(GETMV("MV_NGMDTPS")) == "S"
		lNGMDTPS := .T.
	Endif
Endif

If Dbseek(xFilial("SX6")+"MV_NG2M400")
	If Alltrim(GETMV("MV_NG2M400")) == "S"
		lNG2M400 := .T.
	Endif
Endif
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // De  Matricula                        �
//� mv_par02             // Ate Matricula                        �
//� mv_par03             // De  Centro de Custo                  �
//� mv_par04             // Ate Centro de Custo                  �
//� mv_par05             // De  Funcao                           �
//� mv_par06             // Ate Funcao                           �
//� mv_par07             // Considerar Risco                     �
//� mv_par08             // Descricao das Atividades             �
//� mv_par09             // Tipo de Endereco                     �
//� mv_par10             // Comprovante de Entrega               �
//� mv_par11             // Termo de Responsabilidade            �
//� mv_par12             // Listar Observ. Epi's                 �
//� mv_par13             // Tipo de Impressao                    �
//� mv_par14             // Observacao                           �
//� mv_par15             // Exames Complementares                �
//� mv_par16             // Imp. Result. Exames                  �
//� mv_par17             // Exames NR7                           �
//����������������������������������������������������������������
DbSelectArea("SX1")
DbSetOrder(01)
If !DbSeek(cPerg+"01")
   Reclock('SX1',.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "01"
   SX1->X1_VARIAVL := "mv_ch1"
   SX1->X1_PERGUNT := "De Matricula?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := 06
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"                                              
   SX1->X1_VALID   := "If(Empty(Mv_par01),.t.,ExistCpo('SRA',mv_par01))"
   SX1->X1_VAR01   := "mv_par01"
   SX1->X1_F3      := "SRA"
   SX1->(MsUnLock())
Else
	If Alltrim(SX1->X1_VALID) != "If(Empty(Mv_par01),.t.,ExistCpo('SRA',mv_par01))"
		Reclock('SX1',.F.)
		SX1->X1_VALID   := "If(Empty(Mv_par01),.t.,ExistCpo('SRA',mv_par01))"
		SX1->X1_PERGUNT := "De Matricula?"
		SX1->(MsUnLock())
	Endif	
endif     
lIncSX1 := .f.
If !DbSeek(cPerg+"02")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "Ate Matricula?"
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif	                                   
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "02"
   SX1->X1_VARIAVL := "mv_ch2"
   SX1->X1_PERGUNT := "Ate Matricula?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := 06
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"                                              
   SX1->X1_VALID   := "If(AteCodigo('SRA',Mv_par01,Mv_par02,6),.t.,.f.)"
   SX1->X1_VAR01   := "mv_par02"
   SX1->X1_F3      := "SRA"
   SX1->(MsUnLock())
Endif

lIncSX1 := .f.
If !DbSeek(cPerg+"03")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "De Centro de Custo?"
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif	                                   
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "03"
   SX1->X1_VARIAVL := "mv_ch3"
   SX1->X1_PERGUNT := "De Centro de Custo?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := nSizeSI3
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"                                              
   SX1->X1_VALID   := "If(Empty(Mv_par03),.t.,Existcpo('"+cAlias+"',Mv_par03))"
   SX1->X1_VAR01   := "mv_par03"
   SX1->X1_F3      := cAlias
   SX1->(MsUnLock())
Endif     
If !DbSeek(cPerg+"04")
   Reclock('SX1',.T.) 
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "04"
   SX1->X1_VARIAVL := "mv_ch4"
   SX1->X1_PERGUNT := "Ate Centro de Custo?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := nSizeSI3
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"                                              
   SX1->X1_VALID   := "if(atecodigo('"+cAlias+"',mv_par03,mv_par04,"+StrZero(nSizeSI3,2)+"),.t.,.f.)"
   SX1->X1_VAR01   := "mv_par04"
   SX1->X1_F3      := cAlias
   SX1->(MsUnLock())
Endif
If !DbSeek(cPerg+"05")
   Reclock('SX1',.T.) 
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "05"
   SX1->X1_VARIAVL := "mv_ch5"
   SX1->X1_PERGUNT := "De Funcao?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := nSizeSRJ
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"                                              
   SX1->X1_VALID   := "If(Empty(Mv_par05),.t.,Existcpo('SRJ',Mv_par05))"
   SX1->X1_VAR01   := "mv_par05"
   SX1->X1_F3      := "SRJ"
   SX1->(MsUnLock())
Endif
If !DbSeek(cPerg+"06")
   Reclock('SX1',.T.) 
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "06"
   SX1->X1_VARIAVL := "mv_ch6"
   SX1->X1_PERGUNT := "Ate Funcao?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := nSizeSRJ
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"                                              
   SX1->X1_VALID   := "if(atecodigo('SRJ',mv_par05,mv_par06,5),.t.,.f.)"
   SX1->X1_VAR01   := "mv_par06"
   SX1->X1_F3      := "SRJ"
   SX1->(MsUnLock())
Endif
If !DbSeek(cPerg+"07")
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "07"
   SX1->X1_PERGUNT := "Considerar Risco   ?"
   SX1->X1_VARIAVL := "mv_ch7"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par07"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Todos"
   SX1->X1_DEF02   := "Consta no PPP"   
   MsUnLock("SX1")
ENDIF    
lIncSX1 := .f.
If !DbSeek(cPerg+"08")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_DEF03) != "Cargo e Tarefa"
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif	                                   
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "08"
   SX1->X1_PERGUNT := "Desc. das Atividad.?"
   SX1->X1_VARIAVL := "mv_ch8"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par08"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Tarefa"
   SX1->X1_DEF02   := "Cargo"
   SX1->X1_DEF03   := "Cargo e Tarefa"
   MsUnLock("SX1")
ENDIF
lIncSX1 := .f.
If !DbSeek(cPerg+"09")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "Representante Empr.?" .or. SX1->X1_TAMANHO != nTamanRES .or. ;
		Alltrim(SX1->X1_F3) != cAliasRES
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif	                                   
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "09"
   SX1->X1_PERGUNT := "Representante Empr.?"
   SX1->X1_VARIAVL := "mv_ch9"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := nTamanRES
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"                                              
   SX1->X1_VALID   := "ExistCpo('"+cAliasRES+"',mv_par09)"
   SX1->X1_VAR01   := "mv_par09"
   SX1->X1_F3      := cAliasRES   
   SX1->X1_DEF01   := Space(Len(SX1->X1_DEF01))
   SX1->X1_DEF02   := Space(Len(SX1->X1_DEF02))
   MsUnLock("SX1")
ENDIF   
lIncSX1 := .f.
If !DbSeek(cPerg+"10")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "Comprov. de Entrega?"
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "10"
   SX1->X1_PERGUNT := "Comprov. de Entrega?"
   SX1->X1_VARIAVL := "mv_cha"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par10"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Nao"
   SX1->X1_DEF02   := "Sim"
   MsUnLock("SX1")
Endif
lIncSX1 := .f.
If !DbSeek(cPerg+"11")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "Termo Responsab.?"
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "11"
   SX1->X1_VARIAVL := "mv_chb"
   SX1->X1_PERGUNT := "Termo Responsab.?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := 06
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"                                              
   SX1->X1_VALID   := "If(Empty(Mv_par11),.t.,Existcpo('TMZ',Mv_par11))"
   SX1->X1_VAR01   := "mv_par11"
   SX1->X1_F3      := "TMZ"
   SX1->(MsUnLock())
Endif
lIncSX1 := .f.
If !DbSeek(cPerg+"12")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "Listar Observ. Epis?"
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "12"
   SX1->X1_PERGUNT := "Listar Observ. Epis?"
   SX1->X1_VARIAVL := "mv_chc"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par12"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Nao"
   SX1->X1_DEF02   := "Sim"
   SX1->X1_F3      := "   "
   MsUnLock("SX1")
Endif
lIncSX1 := .f.
If !DbSeek(cPerg+"13")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "Tipo de Impressao?"
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "13"
   SX1->X1_PERGUNT := "Tipo de Impressao?"
   SX1->X1_VARIAVL := "mv_chd"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par13"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Tela"
   SX1->X1_DEF02   := "Impressora"
   SX1->X1_F3      := "   "
   MsUnLock("SX1")
Endif
lIncSX1 := .f.
If !DbSeek(cPerg+"14")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "Observacao"
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "14"
   SX1->X1_VARIAVL := "mv_che"
   SX1->X1_PERGUNT := "Observacao"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := 06
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"                                              
   SX1->X1_VALID   := "If(Empty(Mv_par14),.t.,Existcpo('TMZ',Mv_par14))"
   SX1->X1_VAR01   := "mv_par14"
   SX1->X1_F3      := "TMZ"
   SX1->(MsUnLock())
Endif
lIncSX1 := .f.
If !DbSeek(cPerg+"15")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "Exames Complementar." .or. !("Nenhum" $ SX1->X1_DEF03)
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "15"
   SX1->X1_PERGUNT := "Exames Complementar."
   SX1->X1_VARIAVL := "mv_chf"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par15"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Relac. ao Risco"
   SX1->X1_DEF02   := "Todos"
   SX1->X1_DEF03   := "Nenhum"
   SX1->X1_F3      := "   "
   MsUnLock("SX1")
Endif
lIncSX1 := .f.
If !DbSeek(cPerg+"16")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "Imp. Result. Exames?" .or. Alltrim(SX1->X1_DEF03) != "NR7 Apto/Inapto"
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "16"
   SX1->X1_PERGUNT := "Imp. Result. Exames?"
   SX1->X1_VARIAVL := "mv_chg"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par16"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Sim"
   SX1->X1_DEF02   := "Nao"
   SX1->X1_DEF03   := "NR7 Apto/Inapto"
   SX1->X1_F3      := "   "
   MsUnLock("SX1")
Endif
lIncSX1 := .f.
If !DbSeek(cPerg+"17")
	Reclock('SX1',.T.) 
	lIncSX1 := .t.
Else                   
	If Alltrim(SX1->X1_PERGUNT) != "Exames NR7?"
		Reclock('SX1',.F.) 
		lIncSX1 := .t.
	Endif	
Endif
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "17"
   SX1->X1_PERGUNT := "Exames NR7?"
   SX1->X1_VARIAVL := "mv_chh"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par17"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Sim"
   SX1->X1_DEF02   := "Nao"
   MsUnLock("SX1")
Endif

If pergunte(cPerg,.T.)
	Processa({|lEnd| R700Imp()}) // MONTE TELA PARA ACOMPANHAMENTO DO PROCESSO.
Endif
Return NIL
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R700Imp  � Autor �Denis Hyroshi de Souza � Data �21/10/2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MDTR700                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function R700Imp(lEnd,wnRel,titulo,tamanho)
Private aTM5Combo := PPPMDTCbox("TM5_NATEXA"," ",1)
Private aTMBCombo := PPPMDTCbox("TMB_MATBIO"," ",1)
Private oPrintPPP
Private lin := 0,nPaginaPPP := 0
Private lin2 := 0
Private oFont06,oFont07,oFont08,oFont09,oFont09n,oFont08n,oFont10,oFont11,oFont12,oFont13,oFont14,oFont15,oFont10n
oFont06 := TFont():New("Courier New",06,06,,.F.,,,,.F.,.F.)
oFont07 := TFont():New("Courier New",07,07,,.F.,,,,.F.,.F.)
oFont08 := TFont():New("Courier New",08,08,,.F.,,,,.F.,.F.)
oFont08n := TFont():New("Courier New",08,08,,.T.,,,,.F.,.F.)
oFont09 := TFont():New("Courier New",09,09,,.F.,,,,.F.,.F.)
oFont09n := TFont():New("Courier New",09,09,,.T.,,,,.F.,.F.)
oFont10 := TFont():New("Courier New",10,10,,.F.,,,,.F.,.F.)
oFont10n := TFont():New("Courier New",10,10,,.T.,,,,.F.,.F.)
oFont11 := TFont():New("Courier New",11,11,,.F.,,,,.F.,.F.)
oFont12 := TFont():New("Courier New",12,12,,.T.,,,,.T.,.T.)
oFont13 := TFont():New("Courier New",13,13,,.T.,,,,.F.,.F.)
oFont14 := TFont():New("Courier New",14,14,,.T.,,,,.F.,.F.)
oFont15 := TFont():New("Courier New",15,15,,.T.,,,,.F.,.F.)

oPrintPPP	:= TMSPrinter():New(OemToAnsi(STR0006)) //"Perfil Profissiografico Previdenciario"
oPrintPPP:Setup()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
aDBF := {}
AADD(aDBF,{"NUMRIS"   ,"C",09,0}) 
AADD(aDBF,{"CODAGE"   ,"C",06,0}) 
AADD(aDBF,{"AGENTE"   ,"C",40,0}) 
AADD(aDBF,{"MAT"      ,"C",06,0}) 
AADD(aDBF,{"DT_DE"    ,"D",08,0}) 
AADD(aDBF,{"DT_ATE"   ,"D",08,0}) 
AADD(aDBF,{"SETOR"    ,"C",nSizeSI3,0}) 
AADD(aDBF,{"FUNCAO"   ,"C",nSizeSRJ,0}) 
AADD(aDBF,{"TAREFA"   ,"C",06,0}) 
AADD(aDBF,{"INTENS"   ,"N",09,3}) 
AADD(aDBF,{"UNIDAD"   ,"C",06,0}) 
AADD(aDBF,{"TECNIC"   ,"C",40,0}) 
AADD(aDBF,{"PROTEC"   ,"C",01,0}) 
AADD(aDBF,{"EPC"      ,"C",01,0})
AADD(aDBF,{"GRISCO"   ,"C",01,0})
AADD(aDBF,{"NUMCAP"   ,"C",12,0})
AADD(aDBF,{"INDEXP"   ,"C",01,0})
AADD(aDBF,{"ATIVO"    ,"C",01,0})
AADD(aDBF,{"OBSINT"   ,"C",20,0})

cArqTrab := CriaTrab(aDBF,.t.)
cIDX1 := SUBSTR(cArqTrab,1,7)+"1"
cIDX2 := SUBSTR(cArqTrab,1,7)+"2"
cIDX3 := SUBSTR(cArqTrab,1,7)+"3"
Use (cArqTrab) NEW Exclusive Alias TRBTN0
#IFDEF CDX
   INDEX ON dtos(DT_DE)+dtos(DT_ATE)+NUMRIS TAG (cIDX1) TO (cArqTrab)
   INDEX ON GRISCO+AGENTE+Str(INTENS,9,3)+TECNIC+EPC+PROTEC+NUMCAP TAG (cIDX2) TO (cArqTrab)
   INDEX ON GRISCO+AGENTE+Str(INTENS,9,3)+TECNIC+dtos(DT_DE)+dtos(DT_ATE) TAG (cIDX3) TO (cArqTrab)
#ELSE
   INDEX ON dtos(DT_DE)+dtos(DT_ATE)+NUMRIS TAG (cIDX1) TO (cArqTrab)
   INDEX ON GRISCO+AGENTE+Str(INTENS,9,3)+TECNIC+EPC+PROTEC+NUMCAP TAG (cIDX2) TO (cArqTrab)
   INDEX ON GRISCO+AGENTE+Str(INTENS,9,3)+TECNIC+dtos(DT_DE)+dtos(DT_ATE) TAG (cIDX3) TO (cArqTrab)
   SET INDEX TO (cIDX1),(cIDX2),(cIDX3)
#ENDIF

aDBF1 := {}
AADD(aDBF1,{"DTDE"  ,"D",8,0}) 
AADD(aDBF1,{"DTATE" ,"D",8,0}) 
AADD(aDBF1,{"CNPJ"  ,"C",20,0}) 
AADD(aDBF1,{"TIPINS","N",01,0}) 
AADD(aDBF1,{"CUSTO" ,"C",nSizeSI3,0}) 
AADD(aDBF1,{"FILIAL","C",2,0})
AADD(aDBF1,{"MAT"   ,"C",6,0})
AADD(aDBF1,{"CARGO" ,"C",5,0})
AADD(aDBF1,{"CODFUN","C",nSizeSRJ,0})
AADD(aDBF1,{"DESFUN","C",25,0})
AADD(aDBF1,{"GFIP"  ,"C",2,0}) 

cArqTrab1 := CriaTrab(aDBF1)
Use (cArqTrab1) NEW Exclusive Alias TRBPPP
INDEX ON DTOS(DTDE) TO (cArqTrab1)

aDBF2 := {}
AADD(aDBF2,{"DTINI" ,"D",08,0}) 
AADD(aDBF2,{"DTFIM" ,"D",08,0}) 
AADD(aDBF2,{"FILIAL","C",02,0}) 
AADD(aDBF2,{"CODIGO","C",12,0}) 
AADD(aDBF2,{"NOME"  ,"C",40,0}) 
AADD(aDBF2,{"NIT"   ,"C",11,0}) 
AADD(aDBF2,{"INDFUN","C",01,0}) 
AADD(aDBF2,{"REGNUM","C",12,0}) 

cArqTrab2 := CriaTrab(aDBF2)
Use (cArqTrab2) NEW Exclusive Alias TRBTMK
INDEX ON INDFUN+DTOS(DTINI)+DTOS(DTFIM)+REGNUM+NOME TO (cArqTrab2)

aDBF3 := {}
AADD(aDBF3,{"EXAME" ,"C",06,0})
AADD(aDBF3,{"NOMEXA","C",50,0})
AADD(aDBF3,{"DTPRO" ,"D",08,0})
AADD(aDBF3,{"DTRES" ,"D",08,0})
AADD(aDBF3,{"NATEXA","C",01,0})
AADD(aDBF3,{"RESULT","C",01,0})
AADD(aDBF3,{"REFERE","C",01,0})
AADD(aDBF3,{"ESTAVE","C",01,0})
AADD(aDBF3,{"AGRAVA","C",01,0})
AADD(aDBF3,{"AUDIO" ,"C",01,0})

cArqTrabX := CriaTrab(aDBF3,.t.)
cIDXX1 := SUBSTR(cArqTrabX,1,7)+"1"
cIDXX2 := SUBSTR(cArqTrabX,1,7)+"2"
Use (cArqTrabX) NEW Exclusive Alias TRBTM5
#IFDEF CDX
   INDEX ON DTOS(DTRES)+EXAME TAG (cIDXX1) TO (cArqTrabX)
   INDEX ON DTOS(DTPRO)+EXAME TAG (cIDXX2) TO (cArqTrabX)
#ELSE
   INDEX ON DTOS(DTRES)+EXAME TAG (cIDXX1) TO (cArqTrabX)
   INDEX ON DTOS(DTPRO)+EXAME TAG (cIDXX2) TO (cArqTrabX)
   SET INDEX TO (cIDXX1),(cIDXX2)
#ENDIF

aDBF2 := {}
AADD(aDBF2,{"DTINI" ,"D",08,0}) 
AADD(aDBF2,{"NUMCAP","C",12,0}) 

cArqTrab2 := CriaTrab(aDBF2)
Use (cArqTrab2) NEW Exclusive Alias TRBTNF
INDEX ON DTOS(DTINI)+NUMCAP TO (cArqTrab2)
//��������������������������������������������������������������Ŀ
//� Inicio do Relatorio                                          �
//����������������������������������������������������������������

DbSelectArea("SRA")
DbSetOrder(1)
DbSeek(xFilial("SRA")+MV_PAR01,.t.)
ProcRegua(reccount()) // MONTA A REGUA DE ACOMPANHAMENTO

While !eof() .and. xFilial("SRA") == SRA->RA_FILIAL .and.  SRA->RA_MAT <= Mv_par02

   IncProc()  // INCREMENTO DA REGUA DE ACOMPAHAMENTO.          

   If SRA->RA_CC < Mv_par03 .or. SRA->RA_CC > Mv_par04
       DbSkip()
       Loop
   Endif    
   If SRA->RA_CODFUNC < Mv_par05 .or. SRA->RA_CODFUNC > Mv_par06
       DbSkip()
       Loop
   Endif    

   Dbselectarea("TRBTN0")
   Zap
   Dbselectarea("TRBPPP")
   Zap
   Dbselectarea("TRBTMK")
   Zap                 
   Dbselectarea("TRBTM5")
   Zap   
   Dbselectarea("TRBTNF")
   Zap

   nPaginaPPP := 1
   DbSelectArea("SRA")   
   Matricula := SRA->RA_MAT  
   NGMDT700() //Chamada da funcao que imprime o PPP       

   DbSelectArea("SRA")   
   DbSkip()
End
//��������������������������������������������������������������Ŀ
//� Devolve a condicao original do arquivo principal             �
//����������������������������������������������������������������
RetIndex("SRA")    
Dbselectarea("TRBTN0")
Dbclosearea()
Dbselectarea("TRBPPP")
Dbclosearea()
Dbselectarea("TRBTMK")
Dbclosearea()                 
Dbselectarea("TRBTM5")
Dbclosearea()
Dbselectarea("TRBTNF")
Dbclosearea()
Set Filter To

If mv_par13 == 1 
	oPrintPPP:Preview()
Else
	oPrintPPP:Print()
Endif

dbSelectArea("SRA")
dbSetorder(1)
dbSelectArea("TM0")
dbSetorder(1)
dbSelectArea("TM5")
dbSetorder(1)
dbSelectArea("TMY")
dbSetorder(1)
Return NIL   
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � NGMDT700 � Autor �Denis Hyroshi de Souza � Data � 21/10/02 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime o Perfil Profissiografico Previdenciario           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/    
Static Function NGMDT700()
Local aHist := {}, aAUDIO := {},xx,i,LinhaCorrente,nInd
Private aNUMCAPS := {}
Private aFuncao := {}
Private aFichasUsa := {}
Private aCargoSv  := {}
Private aCargo  := {}
Private aMatriculas := {}
Private aRiscos := {}
Private aCat  := {}
Private lFindCLI := .f.
Private aAREASRA := SRA->(GetArea())

aHist  := NG700HISTO() // Retorna o historico profissiografico do funcionario    

NG700SESMT() //Busca os Usuarios do SESMT

RestArea(aAREASRA)

NG700EXAME()   //  Retorna os exames feitos pelo funcionario   

Dbselectarea("TM0")
Dbsetorder(3)
Dbseek(xFilial("TM0")+SRA->RA_MAT)
Dbselectarea("SR6")
Dbsetorder(1)
Dbseek(xFilial("SR6")+SRA->RA_TNOTRAB)

If lNGMDTPS
	Dbselectarea("SA1")
	Dbsetorder(1)
	If TM0->(FieldPos("TM0_CLIENT")) > 0
		If Dbseek(xFilial("SA1")+TM0->TM0_CLIENT)
			lFindCLI := .t.
		Endif
	Endif
	
	If !lFindCLI
		If TM0->(FieldPos("TM0_CC")) > 0
			If Dbseek(xFilial("SA1")+Substr(TM0->TM0_CC,1,6))
				lFindCLI := .t.
			Endif
		Endif
	Endif
	
	If !lFindCLI
		If Dbseek(xFilial("SA1")+Substr(SRA->RA_CC,1,6))
			lFindCLI := .t.
		Endif
	Endif	
Endif

lin := 100
oPrintPPP:StartPage()
If File("\SIGAADV\LOGOPPP.BMP") //Imprime logotipo da previdencia social
	oPrintPPP:SayBitMap(lin,1000,"\SIGAADV\LOGOPPP.BMP",400,130)
Endif
lin := 180
oPrintPPP:Say(lin+100,600,"PERFIL PROFISSIOGR�FICO PREVIDENCI�RIO - PPP",oFont13)
oPrintPPP:Box(lin+200,50,lin+580,2350)

//PRIMEIRA PARTE
oPrintPPP:Say(lin+220,90,"I",oFont13)
oPrintPPP:Line(lin+200,150,lin+280,150)
oPrintPPP:Say(lin+220,160,"SE��O DE DADOS ADMINISTRATIVOS",oFont13)
oPrintPPP:Line(lin+280,50,lin+280,2350)
oPrintPPP:Line(lin+280,800,lin+380,800)
oPrintPPP:Line(lin+280,2000,lin+380,2000)
oPrintPPP:Say(lin+285,60,"1-CNPJ do Domic�lio Tribut�rio/CEI",oFont09)
If lNGMDTPS
	If !Empty(SA1->A1_CGC)
		oPrintPPP:Say(lin+330,60,Transform(SA1->A1_CGC,"@R 99999999/9999-99"),oFont10)
	Endif
Else
	If !Empty(SM0->M0_CGC)
		If SM0->M0_TPINSC == 2 
			oPrintPPP:Say(lin+330,60,Transform(SM0->M0_CGC,"@R 99999999/9999-99"),oFont10)
		Else
			oPrintPPP:Say(lin+330,60,Transform(SM0->M0_CGC,"@R 99.999.99999/99"),oFont10)
		Endif
	Endif
Endif
oPrintPPP:Say(lin+285,810,"2-Nome Empresarial",oFont09)
If lNGMDTPS
	oPrintPPP:Say(lin+330,810,Substr(SA1->A1_NOME,1,40),oFont10)
Else
	oPrintPPP:Say(lin+330,810,Substr(SM0->M0_NOMECOM,1,40),oFont10)
Endif
oPrintPPP:Say(lin+285,2010,"3-CNAE",oFont09)
If lNGMDTPS
	oPrintPPP:Say(lin+330,2010,Transform(SA1->A1_ATIVIDA,"@R 999999-9"),oFont10)
Else
	oPrintPPP:Say(lin+330,2010,Transform(SM0->M0_CNAE,"@R 999999-9"),oFont10)
Endif
oPrintPPP:Line(lin+380,50,lin+380,2350)
oPrintPPP:Line(lin+380,1600,lin+480,1600)
oPrintPPP:Line(lin+380,2000,lin+480,2000)
oPrintPPP:Say(lin+385,60,"4-Nome do Trabalhador",oFont09)
oPrintPPP:Say(lin+430,60,SRA->RA_NOME,oFont10)
oPrintPPP:Say(lin+385,1610,"5-BR/PDH",oFont09)
If SRA->(FieldPos("RA_BRPDH")) > 0
	cBRPDH := "NA"
	If SRA->RA_BRPDH == "1"
		cBRPDH := "BR"
	Elseif SRA->RA_BRPDH == "2"
		cBRPDH := "PDH"
	Endif
	oPrintPPP:Say(lin+430,1610,cBRPDH,oFont10)
Endif
oPrintPPP:Say(lin+385,2010,"6-NIT",oFont09)
If !Empty(SRA->RA_PIS)
	oPrintPPP:Say(lin+430,2010,Transform(SRA->RA_PIS,"@R 999.99999.99-9"),oFont10)
Endif
oPrintPPP:Line(lin+480,50,lin+480,2350)
oPrintPPP:Line(lin+480,500,lin+580,500)
oPrintPPP:Line(lin+480,800,lin+580,800)
oPrintPPP:Line(lin+480,1400,lin+580,1400)
oPrintPPP:Line(lin+480,1800,lin+580,1800)
oPrintPPP:Say(lin+485,60,"7-Data do Nascimento",oFont09)
oPrintPPP:Say(lin+530,60,NGPPPDATE(SRA->RA_NASC),oFont10)
oPrintPPP:Say(lin+485,510,"8-Sexo(F/M)",oFont09)
oPrintPPP:Say(lin+530,520,Upper(SRA->RA_SEXO),oFont10)
oPrintPPP:Say(lin+485,810,"9-CTPS(N�, S�rie e UF)",oFont09)
oPrintPPP:Say(lin+530,810,SRA->RA_NUMCP+"/"+SRA->RA_SERCP+" - "+SRA->RA_UFCP,oFont10)
oPrintPPP:Say(lin+485,1410,"10-Data de Admiss�o",oFont09)
oPrintPPP:Say(lin+530,1410,NGPPPDATE(SRA->RA_ADMISSA),oFont10)
oPrintPPP:Say(lin+485,1810,"11-Regime Revezamento",oFont09)
If SR6->(FieldPos("R6_REVEZAM")) > 0
	If !EMPTY(Substr(SR6->R6_REVEZAM,1,20))
		oPrintPPP:Say(lin+530,1810,Substr(SR6->R6_REVEZAM,1,20),oFont09)
	Else
		oPrintPPP:Say(lin+530,1810,"NA",oFont10)
	ENdif
Else
	oPrintPPP:Say(lin+530,1810,"NA",oFont10)
Endif
lin := 760
oPrintPPP:Line(lin,50,lin+60,50)
oPrintPPP:Say(lin+10,70,"12",oFont11)
oPrintPPP:Line(lin,150,lin+60,150)
oPrintPPP:Say(lin+10,160,"CAT REGISTRADA",oFont11)
oPrintPPP:Line(lin,2350,lin+60,2350)
oPrintPPP:Line(lin+60,50,lin+60,2350)
SomaLinha()
oPrintPPP:Line(lin,50,lin+50,50)
oPrintPPP:Say(lin+5,60,"12.1-Data do Registro",oFont09)
oPrintPPP:Line(lin,625,lin+50,625)
oPrintPPP:Say(lin+5,635,"12.2-N�mero da CAT",oFont09)
oPrintPPP:Line(lin,1200,lin+50,1200)
oPrintPPP:Say(lin+5,1210,"12.1-Data do Registro",oFont09)
oPrintPPP:Line(lin,1775,lin+50,1775)
oPrintPPP:Say(lin+5,1785,"12.2-N�mero da CAT",oFont09)
oPrintPPP:Line(lin,2350,lin+50,2350)
oPrintPPP:Line(lin+50,50,lin+50,2350)

lPosi := .f.
lLen  := .f.
If len(acat) > 0
	For xx := 1 to len(aCat)
		If len( acat ) == xx
			lLen := .t.
		EndIf	
		nResto := Mod(xx,2)
		If nResto = 1 .and. lLen
			SomaLinha(50)
			oPrintPPP:Line(lin,50,lin+50,50)
			oPrintPPP:Say(lin+5,60,NGPPPDATE(aCat[xx][1]),oFont10)
			oPrintPPP:Line(lin,625,lin+50,625)
			oPrintPPP:Say(lin+5,635,Transform(aCat[xx][2],"@R 9999999999-9/99"),oFont10)
			oPrintPPP:Line(lin,1200,lin+50,1200)
			oPrintPPP:Line(lin,1775,lin+50,1775)
			oPrintPPP:Line(lin,2350,lin+50,2350)
			oPrintPPP:Line(lin+50,50,lin+50,2350)
		Elseif nResto = 0
			SomaLinha(50)
			oPrintPPP:Line(lin,50,lin+50,50)
			oPrintPPP:Say(lin+5,60,NGPPPDATE(aCat[xx-1][1]),oFont10)
			oPrintPPP:Line(lin,625,lin+50,625)
			oPrintPPP:Say(lin+5,635,Transform(aCat[xx-1][2],"@R 9999999999-9/99"),oFont10)
			oPrintPPP:Line(lin,1200,lin+50,1200)
			oPrintPPP:Say(lin+5,1210,NGPPPDATE(aCat[xx][1]),oFont10)
			oPrintPPP:Line(lin,1775,lin+50,1775)
			oPrintPPP:Say(lin+5,1785,Transform(aCat[xx][2],"@R 9999999999-9/99"),oFont10)
			oPrintPPP:Line(lin,2350,lin+50,2350)
			oPrintPPP:Line(lin+50,50,lin+50,2350)
		EndIf
	Next xx
Else
	SomaLinha(50)
	oPrintPPP:Line(lin,50,lin+50,50)
	oPrintPPP:Line(lin,625,lin+50,625)
	oPrintPPP:Line(lin,1200,lin+50,1200)
	oPrintPPP:Line(lin,1775,lin+50,1775)
	oPrintPPP:Line(lin,2350,lin+50,2350)
	oPrintPPP:Line(lin+50,50,lin+50,2350)
Endif

SomaLinha(50)
oPrintPPP:Line(lin,50,lin+60,50)
oPrintPPP:Say(lin+10,70,"13",oFont11)
oPrintPPP:Line(lin,150,lin+60,150)
oPrintPPP:Say(lin+5,160,"LOTA��O E ATRIBUI��O",oFont11)
oPrintPPP:Line(lin,2350,lin+60,2350)
oPrintPPP:Line(lin+60,50,lin+60,2350)
SomaLinha()
oPrintPPP:Line(lin,50,lin+50,50)
oPrintPPP:Say(lin+5,60,"13.1-Per�odo",oFont09)
oPrintPPP:Line(lin,550,lin+50,550)
oPrintPPP:Say(lin+5,560,"13.2-CNPJ/CEI",oFont09)
oPrintPPP:Line(lin,850,lin+50,850)
oPrintPPP:Say(lin+5,860,"13.3-Setor",oFont09)
oPrintPPP:Line(lin,1200,lin+50,1200)
oPrintPPP:Say(lin+5,1210,"13.4-Cargo",oFont09)
oPrintPPP:Line(lin,1550,lin+50,1550)
oPrintPPP:Say(lin+5,1560,"13.5-Fun��o",oFont09)
oPrintPPP:Line(lin,1900,lin+50,1900)
oPrintPPP:Say(lin+5,1910,"13.6-CBO",oFont09)
oPrintPPP:Line(lin,2080,lin+50,2080)
oPrintPPP:Say(lin+5,2090,"13.7-C�d. GFIP",oFont08)
oPrintPPP:Line(lin,2350,lin+50,2350)
oPrintPPP:Line(lin+50,50,lin+50,2350)
Somalinha(50)
lin2 := 0
If len(aHist) > 0
	For i := 1 to len(aHist)
		lin2 := 0
		llinha := .f.
		lSetor := .f.
		lCargo := .f.
		lFuncc := .f.
		
		If Len(aHist[i][5]) > 17 .and. !Empty(Memoline(aHist[i][5],17,1))
			lSetor := .t.
		Endif
		If Len(aHist[i][6]) > 17 .and. !Empty(Memoline(aHist[i][6],17,1))
			lCargo := .t.
		Endif
		If Len(aHist[i][7]) > 17 .and. !Empty(Memoline(aHist[i][7],17,1))
			lFuncc := .t.
		Endif
		If lSetor .or. 	lCargo .or. lFuncc
			lLinha := .t.
			lin2 := 10
		Endif
		
		oPrintPPP:Line(lin,50,lin+50+(lin2*2),50)
		cDtPPP := NGPPPDATE(aHist[i][3])+" a "
		cDtPPP += If(i==len(aHist),If(Empty(SRA->RA_DEMISSA),"__/__/____",NGPPPDATE(aHist[i][4])),NGPPPDATE(aHist[i][4]))
		oPrintPPP:Say(lin+5+lin2,60,cDtPPP,oFont09)
		oPrintPPP:Line(lin,550,lin+50+(lin2*2),550)
		If aHist[i][11] == 2
			oPrintPPP:Say(lin+5+lin2,560,Transform(aHist[i][10],"@R 99999999/9999-99"),oFont08) // CNPJ
		Else
			oPrintPPP:Say(lin+5+lin2,560,Transform(aHist[i][10],"@R 99.999.99999/99"),oFont08) // CEI
		Endif
		oPrintPPP:Line(lin,850,lin+50+(lin2*2),850)
		If lSetor
			oPrintPPP:Say(lin+2,855,Memoline(aHist[i][5],17,1),oFont09) // Centro de Custo
			oPrintPPP:Say(lin+37,855,Memoline(aHist[i][5],17,2),oFont09) // Centro de Custo
		Else
			oPrintPPP:Say(lin+5+lin2,855,Substr(aHist[i][5],1,17),oFont09) // Centro de Custo
		Endif
		oPrintPPP:Line(lin,1200,lin+50+(lin2*2),1200)		
		If lCargo
			oPrintPPP:Say(lin+2,1205,Memoline(aHist[i][6],17,1),oFont09) // Cargo
			oPrintPPP:Say(lin+37,1205,Memoline(aHist[i][6],17,2),oFont09) // Cargo
		Else
			oPrintPPP:Say(lin+5+lin2,1205,Substr(aHist[i][6],1,17),oFont09) // Cargo
		Endif
		oPrintPPP:Line(lin,1550,lin+50+(lin2*2),1550)
		If lFuncc
			oPrintPPP:Say(lin+2,1555,Memoline(aHist[i][7],17,1),oFont09) // Funcao
			oPrintPPP:Say(lin+37,1555,Memoline(aHist[i][7],17,2),oFont09) // Funcao
		Else
			oPrintPPP:Say(lin+5+lin2,1555,Substr(aHist[i][7],1,17),oFont09) // Funcao
		Endif		
		oPrintPPP:Line(lin,1900,lin+50+(lin2*2),1900)
		oPrintPPP:Say(lin+5+lin2,1910,aHist[i][8],oFont09) // CBO
		oPrintPPP:Line(lin,2080,lin+50+(lin2*2),2080)
		oPrintPPP:Say(lin+5+lin2,2090,aHist[i][9],oFont09) // GFIP
		oPrintPPP:Line(lin,2350,lin+50+(lin2*2),2350)
		oPrintPPP:Line(lin+50+(lin2*2),50,lin+50+(lin2*2),2350)

		If lLinha //Registro sera impresso em duas linhas
			Somalinha(70)
		Else
			Somalinha(50) //Registro sera impresso em uma linha
		Endif

	Next i
Else
	oPrintPPP:Line(lin,50,lin+50,50)
	oPrintPPP:Say(lin+5+lin2,60,"__/__/____ a __/__/____",oFont09)
	oPrintPPP:Line(lin,550,lin+50,550)
	oPrintPPP:Line(lin,850,lin+50,850)
	oPrintPPP:Line(lin,1200,lin+50,1200)		
	oPrintPPP:Line(lin,1550,lin+50,1550)
	oPrintPPP:Line(lin,1900,lin+50,1900)
	oPrintPPP:Line(lin,2080,lin+50,2080)
	oPrintPPP:Line(lin,2350,lin+50,2350)
	oPrintPPP:Line(lin+50,50,lin+50,2350)
	Somalinha(50)
Endif
oPrintPPP:Line(lin,50,lin+60,50)
oPrintPPP:Say(lin+10,70,"14",oFont11)
oPrintPPP:Line(lin,150,lin+60,150)
oPrintPPP:Say(lin+10,160,"PROFISSIOGRAFIA",oFont11)
oPrintPPP:Line(lin,2350,lin+60,2350)
oPrintPPP:Line(lin+60,50,lin+60,2350)
SomaLinha()
oPrintPPP:Line(lin,50,lin+50,50)
oPrintPPP:Say(lin+5,60,"14.1-Per�odo",oFont09)
oPrintPPP:Line(lin,550,lin+50,550)
oPrintPPP:Say(lin+5,560,"14.2-Descri��o das Atividades",oFont09)
oPrintPPP:Line(lin,2350,lin+50,2350)
oPrintPPP:Line(lin+50,50,lin+50,2350)
SomaLinha(50)
If !ATIV700R()//IMPRIME DESCRICAO DAS ATIVIDADES
	oPrintPPP:Line(lin,50,lin+50,50)
	oPrintPPP:Line(lin,550,lin+50,550)
	oPrintPPP:Line(lin,2350,lin+50,2350)
	oPrintPPP:Line(lin+50,50,lin+50,2350)
	SomaLinha(50)              
Endif

//SEGUNDA PARTE
If lin != 380
	Somalinha(30)
	oPrintPPP:Line(lin,50,lin,2350)
Endif
oPrintPPP:Line(lin,50,lin+80,50)
oPrintPPP:Line(lin,2350,lin+80,2350)
oPrintPPP:Line(lin+80,50,lin+80,2350)
oPrintPPP:Say(lin+20,70,"II",oFont13)
oPrintPPP:Line(lin,150,lin+80,150)
oPrintPPP:Say(lin+20,160,"SE��O DE REGISTROS AMBIENTAIS",oFont13)
Somalinha(80)
oPrintPPP:Line(lin,50,lin+60,50)
oPrintPPP:Say(lin+10,70,"15",oFont11)
oPrintPPP:Line(lin,150,lin+60,150)
oPrintPPP:Say(lin+10,160,"EXPOSI��O A FATORES DE RISCOS",oFont11)
oPrintPPP:Line(lin,2350,lin+60,2350)
oPrintPPP:Line(lin+60,50,lin+60,2350)
//IMPRIMIR RISCO
Somalinha()
oPrintPPP:Line(lin,50,lin+80,50)
oPrintPPP:Say(lin+5,60,"15.1-Per�odo",oFont09)
oPrintPPP:Line(lin,550,lin+80,550)
oPrintPPP:Say(lin+5,560,"15.2-",oFont09)
oPrintPPP:Say(lin+45,560,"Tipo",oFont09)
oPrintPPP:Line(lin,670,lin+80,670)
oPrintPPP:Say(lin+5,680,"15.3-Fator de",oFont09)
oPrintPPP:Say(lin+45,680,"Risco",oFont09)
oPrintPPP:Line(lin,1050,lin+80,1050)
oPrintPPP:Say(lin+5,1060,"15.4-Intens.",oFont09)
oPrintPPP:Say(lin+45,1060,"/Conc.",oFont09)
oPrintPPP:Line(lin,1300,lin+80,1300)
oPrintPPP:Say(lin+5,1310,"15.5-T�cnica",oFont09)
oPrintPPP:Say(lin+45,1310,"Utilizada",oFont09)
oPrintPPP:Line(lin,1650,lin+80,1650)
oPrintPPP:Say(lin+5,1660,"15.6-EPC",oFont09)
oPrintPPP:Say(lin+45,1660,"Eficaz",oFont09)
oPrintPPP:Line(lin,1850,lin+80,1850)
oPrintPPP:Say(lin+5,1860,"15.7-EPI",oFont09)
oPrintPPP:Say(lin+45,1860,"Eficaz",oFont09)
oPrintPPP:Line(lin,2050,lin+80,2050)
oPrintPPP:Say(lin+5,2060,"15.8-C.A. EPI",oFont09)
oPrintPPP:Line(lin,2350,lin+80,2350)
oPrintPPP:Line(lin+80,50,lin+80,2350)
Somalinha(80)

RECLASS_RISCOS() //Reclassifica os riscos
lin2 := 0
lNot := .t.
Dbselectarea("TRBTN0")   
Dbsetorder(1)
Dbgotop()
While !eof()
	If TRBTN0->ATIVO != "S"
		Dbselectarea("TRBTN0")
		Dbskip()
		Loop
	Endif
	lin2 := 0
	llinha := .f.
	lFator := .f.
	lTecUt := .f.
	lObsIn := .f.
		
	If Len(Alltrim(TRBTN0->AGENTE)) > 20 .and. !Empty(Memoline(Alltrim(TRBTN0->AGENTE),20,1))
		lFator := .t.
	Endif
	If Len(Alltrim(TRBTN0->TECNIC)) > 20 .and. !Empty(Memoline(Alltrim(TRBTN0->TECNIC),20,1))
		lTecUt := .t.
	Endif
	If Len(Alltrim(TRBTN0->OBSINT)) > 15 .and. (TRBTN0->INTENS == 0 .or. Empty(TRBTN0->INTENS))
		lObsIn := .t.
	Endif
	If lFator .or. lTecUt .or. lObsIn
		lLinha := .t.
		lin2 := 10
	Endif

	oPrintPPP:Line(lin,50,lin+50+(lin2*2),50)
	cDtPPP := NGPPPDATE(TRBTN0->DT_DE)+" a "
	cDtPPP += If(TRBTN0->DT_ATE == dDataBase .and. Empty(SRA->RA_DEMISSA),"__/__/____",NGPPPDATE(TRBTN0->DT_ATE))
	oPrintPPP:Say(lin+5+lin2,60,cDtPPP,oFont09) //Periodo de Exposicao
	oPrintPPP:Line(lin,550,lin+50+(lin2*2),550)
	
	cGrau_Risco := " "
	Do Case
		Case TRBTN0->GRISCO == "1" ; cGrau_Risco := "F"
		Case TRBTN0->GRISCO == "2" ; cGrau_Risco := "Q"
		Case TRBTN0->GRISCO == "3" ; cGrau_Risco := "B"
		Case TRBTN0->GRISCO == "4" ; cGrau_Risco := "E"
		Case TRBTN0->GRISCO == "5" ; cGrau_Risco := "M"
	End Case
	
	// Tipo de Risco
	oPrintPPP:Say(lin+5+lin2,580,cGrau_Risco,oFont11)
	oPrintPPP:Line(lin,670,lin+50+(lin2*2),670)
	
	// Fator de Risco
	If lFator
		oPrintPPP:Say(lin+2,675,Substr(Alltrim(TRBTN0->AGENTE),1,20),oFont08) 
		oPrintPPP:Say(lin+37,675,Substr(Alltrim(TRBTN0->AGENTE),21,20),oFont08)
	Else
		oPrintPPP:Say(lin+5+lin2,675,Substr(Alltrim(TRBTN0->AGENTE),1,20),oFont08)
	Endif
	oPrintPPP:Line(lin,1050,lin+50+(lin2*2),1050)
	
	// Intensidade/Concentracao
	If TRBTN0->INTENS == 0 .or. Empty(TRBTN0->INTENS)
		If !Empty(TRBTN0->OBSINT)
			If lObsIn
				oPrintPPP:Say(lin+2,1055,MemoLine(TRBTN0->OBSINT,15,1),oFont07) 
				oPrintPPP:Say(lin+37,1055,MemoLine(TRBTN0->OBSINT,15,2),oFont07)
			Elseif Len(Alltrim(TRBTN0->OBSINT)) <= 12
				oPrintPPP:Say(lin+5+lin2,1055,Substr(Alltrim(TRBTN0->OBSINT),1,12),oFont08)
			Else
				oPrintPPP:Say(lin+5+lin2,1055,Substr(Alltrim(TRBTN0->OBSINT),1,15),oFont07)
			Endif
		Else
			oPrintPPP:Say(lin+5+lin2,1055,Space(7)+"NA",oFont08)
		Endif
	ElseIf (TRBTN0->INTENS >= 1000 .and. Len(Alltrim(TRBTN0->UNIDAD)) > 5) .or.;
		   (TRBTN0->INTENS >= 10000 .and. Len(Alltrim(TRBTN0->UNIDAD)) > 4)

		oPrintPPP:Say(lin+5+lin2,1055,Alltrim(Substr(Transform(TRBTN0->INTENS,"@E 99,999.999"),1,9))+;
		" "+Alltrim(TRBTN0->UNIDAD),oFont07)
	Else
		oPrintPPP:Say(lin+5+lin2,1055,Alltrim(Substr(Transform(TRBTN0->INTENS,"@E 99,999.999"),1,9))+;
		" "+Alltrim(TRBTN0->UNIDAD),oFont08)
	Endif
	oPrintPPP:Line(lin,1300,lin+50+(lin2*2),1300)

	// Tecnica Utilizada
	If !Empty(TRBTN0->TECNIC)
		If lTecUt
			oPrintPPP:Say(lin+2,1305,Substr(Alltrim(TRBTN0->TECNIC),1,20),oFont08) 
			oPrintPPP:Say(lin+37,1305,Substr(Alltrim(TRBTN0->TECNIC),21,20),oFont08)
		Else
			oPrintPPP:Say(lin+5+lin2,1305,Substr(Alltrim(TRBTN0->TECNIC),1,20),oFont08)
		Endif
	Else
		oPrintPPP:Say(lin+5+lin2,1305,"NA",oFont09)
	Endif
	oPrintPPP:Line(lin,1650,lin+50+(lin2*2),1650)
	
	// EPC Eficaz
	oPrintPPP:Say(lin+5+lin2,1660,If(TRBTN0->EPC == "N","NAO","SIM"),oFont09)
	oPrintPPP:Line(lin,1850,lin+50+(lin2*2),1850)

	// EPI Eficaz
	oPrintPPP:Say(lin+5+lin2,1860,If(TRBTN0->PROTEC == "N","NAO","SIM"),oFont09)
	oPrintPPP:Line(lin,2050,lin+50+(lin2*2),2050)
	
	// N. Cert. Aprov. EPI
	oPrintPPP:Say(lin+5+lin2,2060,If(TRBTN0->PROTEC == "N","NA",TRBTN0->NUMCAP),oFont09)
	oPrintPPP:Line(lin,2350,lin+50+(lin2*2),2350)	
	oPrintPPP:Line(lin+50+(lin2*2),50,lin+50+(lin2*2),2350)

    lNot := .f.

	If lLinha //Registro sera impresso em duas linhas
		Somalinha(70)
	Else
		Somalinha(50) //Registro sera impresso em uma linha
	Endif
	
	Dbskip()
End           
If lNot
	oPrintPPP:Line(lin,50,lin+50,50)
	oPrintPPP:Say(lin+5+lin2,60,"__/__/____ a __/__/____",oFont09)
	oPrintPPP:Line(lin,550,lin+50,550)
	oPrintPPP:Line(lin,670,lin+50,670)
	oPrintPPP:Line(lin,1050,lin+50,1050)
	oPrintPPP:Line(lin,1300,lin+50,1300)
	oPrintPPP:Line(lin,1650,lin+50,1650)
	oPrintPPP:Line(lin,1850,lin+50,1850)
	oPrintPPP:Line(lin,2050,lin+50,2050)
	oPrintPPP:Line(lin,2350,lin+50,2350)
	oPrintPPP:Line(lin+50,50,lin+50,2350)
	Somalinha(50)
Endif
//FIM RISCO
oPrintPPP:Line(lin,50,lin+60,50)
oPrintPPP:Say(lin+10,70,"16",oFont11)
oPrintPPP:Line(lin,150,lin+60,150)
oPrintPPP:Say(lin+10,160,"RESPONS�VEL PELOS REGISTROS AMBIENTAIS",oFont11)
oPrintPPP:Line(lin,2350,lin+60,2350)
oPrintPPP:Line(lin+60,50,lin+60,2350)
Somalinha()
oPrintPPP:Line(lin,50,lin+80,50)
oPrintPPP:Say(lin+5,60,"16.1-Per�odo",oFont09)
oPrintPPP:Line(lin,550,lin+80,550)
oPrintPPP:Say(lin+5,560,"16.2-NIT",oFont09)
oPrintPPP:Line(lin,880,lin+80,880)
oPrintPPP:Say(lin+5,890,"16.3-Registro Conselho",oFont09)
oPrintPPP:Say(lin+45,890,"de Classe",oFont09)
oPrintPPP:Line(lin,1350,lin+80,1350)
oPrintPPP:Say(lin+5,1360,"16.4-Nome do Profissional Legalmente Habilitado",oFont09)
oPrintPPP:Line(lin,2350,lin+80,2350)
oPrintPPP:Line(lin+80,50,lin+80,2350)
Somalinha(30)
lFirst := .t.
Dbselectarea("TRBTMK")
Dbsetorder(1)
Dbseek("4")
While !eof() .and. "4" == TRBTMK->INDFUN
	If (TRBTMK->DTINI > (If(Empty(SRA->RA_DEMISSA),dDataBase,SRA->RA_DEMISSA))) .or. ;
	   (!Empty(TRBTMK->DTFIM) .and. TRBTMK->DTFIM < SRA->RA_ADMISSA)
	
		Dbselectarea("TRBTMK")
		Dbskip()
		Loop
	Endif
	Somalinha(50,lFirst)
	lFirst := .f.
	oPrintPPP:Line(lin,50,lin+50,50)
	cDtPPP := NGPPPDATE(If(TRBTMK->DTINI < SRA->RA_ADMISSA,SRA->RA_ADMISSA,TRBTMK->DTINI))+" a "
	If Empty(TRBTMK->DTFIM)
		cDtPPP += NGPPPDATE(SRA->RA_DEMISSA)
	Else	
		If Empty(SRA->RA_DEMISSA)
			cDtPPP += NGPPPDATE(If(TRBTMK->DTFIM > dDataBase,SRA->RA_DEMISSA,TRBTMK->DTFIM))
		Else
			cDtPPP += NGPPPDATE(If(TRBTMK->DTFIM > SRA->RA_DEMISSA,SRA->RA_DEMISSA,TRBTMK->DTFIM))
		Endif		
	Endif
	
	oPrintPPP:Say(lin+5,60,cDtPPP,oFont09)
	oPrintPPP:Line(lin,550,lin+50,550)
	If !EMPTY(TRBTMK->NIT)
		oPrintPPP:Say(lin+5,560,Transform(TRBTMK->NIT,"@R 999.99999.99-9"),oFont08) // NIT
	Endif
	oPrintPPP:Line(lin,880,lin+50,880)
	oPrintPPP:Say(lin+5,890,TRBTMK->REGNUM,oFont09) // Registro MTB
	oPrintPPP:Line(lin,1350,lin+50,1350)
	oPrintPPP:Say(lin+5,1360,Substr(TRBTMK->NOME,1,40),oFont09) // Nome
	oPrintPPP:Line(lin,2350,lin+50,2350)
	oPrintPPP:Line(lin+50,50,lin+50,2350)

	Dbselectarea("TRBTMK")
	Dbskip()
End
If lFirst
	Somalinha(50,.t.)
	oPrintPPP:Line(lin,50,lin+50,50)
	oPrintPPP:Say(lin+5,60,"__/__/____ a __/__/____",oFont09)	
	oPrintPPP:Line(lin,550,lin+50,550)
	oPrintPPP:Line(lin,880,lin+50,880)
	oPrintPPP:Line(lin,1350,lin+50,1350)
	oPrintPPP:Line(lin,2350,lin+50,2350)
	oPrintPPP:Line(lin+50,50,lin+50,2350)
Endif


//TERCEIRA PARTE
Somalinha(80)
If lin != 380
	oPrintPPP:Line(lin,50,lin,2350)
Endif
oPrintPPP:Line(lin,50,lin+80,50)
oPrintPPP:Line(lin,2350,lin+80,2350)
oPrintPPP:Line(lin+80,50,lin+80,2350)
oPrintPPP:Say(lin+20,60,"III",oFont13)
oPrintPPP:Line(lin,150,lin+80,150)
oPrintPPP:Say(lin+20,160,"SE��O DE RESULTADOS DE MONITORA��O BIOL�GICA",oFont13)
Somalinha(80)
oPrintPPP:Line(lin,50,lin+60,50)
oPrintPPP:Say(lin+10,70,"17",oFont11)
oPrintPPP:Line(lin,150,lin+60,150)
oPrintPPP:Say(lin+10,160,"EXAMES M�DICOS CL�NICOS E COMPLEMENTARES",oFont11)
oPrintPPP:Line(lin,2350,lin+60,2350)
oPrintPPP:Line(lin+60,50,lin+60,2350)
Somalinha()
//IMPRIMIR EXAMES
oPrintPPP:Line(lin,50,lin+50,50)
oPrintPPP:Say(lin+5,60,"17.1-Data",oFont09)
oPrintPPP:Line(lin,300,lin+50,300)
oPrintPPP:Say(lin+5,310,"17.2-Tipo",oFont09)
oPrintPPP:Line(lin,540,lin+50,540)
oPrintPPP:Say(lin+5,550,"17.3-Natureza",oFont09)
oPrintPPP:Line(lin,1200,lin+50,1200)
oPrintPPP:Say(lin+5,1210,"17.4-Exame(R/S)",oFont09)
oPrintPPP:Line(lin,1530,lin+50,1530)
oPrintPPP:Say(lin+5,1540,"17.5-Indica��o de Resultados",oFont09)
oPrintPPP:Line(lin,2350,lin+50,2350)
oPrintPPP:Line(lin+50,50,lin+50,2350)
Somalinha(50)
lin2 := 0
nTRBTM5 := 0
Dbselectarea("TRBTM5")
Dbsetorder(1) 
Dbgotop()
While !eof()		
	nTRBTM5++
	
	If TRBTM5->RESULT == "2" .and. !EMPTY(TRBTM5->AUDIO) .and. TRBTM5->REFERE != "1" .and. mv_par16 != 2
		If lin+200 > 3000
			Somalinha(,,.t.)
		Endif	
	Endif

	lNomExa := .f.
	lin2    := 0
	If Len(Alltrim(TRBTM5->NOMEXA)) > 30 .and. !Empty(Memoline(Alltrim(TRBTM5->NOMEXA),30,1))
		lNomExa := .t.
		lin2 := 10
	Endif

	oPrintPPP:Line(lin,50,lin+50+(lin2*2),50)
	
	// Data do Resultado
	oPrintPPP:Say(lin+5+lin2,60,NGPPPDATE(TRBTM5->DTRES),oFont09)
	oPrintPPP:Line(lin,300,lin+50+(lin2*2),300)
	
	// Natureza do Exame
	If (nIND := aScan(aTM5combo,{|x| Upper(Substr(x,1,1)) == Substr(TRBTM5->NATEXA,1,1)})) > 0
		oPrintPPP:Say(lin+5+lin2,310,Upper(Substr(aTM5combo[nIND],3,1)),oFont09)
	Endif	
	oPrintPPP:Line(lin,540,lin+50+(lin2*2),540)


	// Nome do Exame
	If lNomExa
		oPrintPPP:Say(lin+2,545,Memoline(Alltrim(TRBTM5->NOMEXA),30,1),oFont09) 
		oPrintPPP:Say(lin+37,545,Memoline(Alltrim(TRBTM5->NOMEXA),30,2),oFont09)
	Else
		oPrintPPP:Say(lin+5+lin2,550,Substr(TRBTM5->NOMEXA,1,30),oFont09)
	Endif
    oPrintPPP:Line(lin,1200,lin+50+(lin2*2),1200)
    
	//Referencial ou Sequencial
	If !EMPTY(TRBTM5->REFERE)
		oPrintPPP:Say(lin+5+lin2,1210,If(TRBTM5->REFERE!="1","S","R"),oFont09)
	Endif
	oPrintPPP:Line(lin,1530,lin+50+(lin2*2),1530)

	If TRBTM5->RESULT == "2" .and. !EMPTY(TRBTM5->AUDIO) .and. TRBTM5->REFERE != "1" .and. mv_par16 != 2
		
		//Indicacao do Resultado
		oPrintPPP:Say(lin+5+lin2,1540,If(TRBTM5->RESULT=="1","( ) ","( ) ")+"Normal",oFont09)
		oPrintPPP:Line(lin,1770,lin+50+(lin2*2),1770)
		oPrintPPP:Say(lin+5+lin2,1780,If(TRBTM5->RESULT=="2","( ) ","( ) ")+"Alterado",oFont09)
		oPrintPPP:Line(lin,2350,lin+50+(lin2*2),2350)

		Somalinha(50+(lin2*2))
		oPrintPPP:Say(lin-5,1830,If(!Empty(TRBTM5->ESTAVE),"( ) ","( ) ")+"Est�vel",oFont09)
		oPrintPPP:Say(lin+35,1830,If(!Empty(TRBTM5->AGRAVA),"( ) ","( ) ")+"Agravamento",oFont09)
		oPrintPPP:Say(lin+75,1880,If(TRBTM5->AGRAVA=="S","( ) ","( ) ")+"Ocupacional",oFont09)
		oPrintPPP:Say(lin+115,1880,If(TRBTM5->AGRAVA=="N","( ) ","( ) ")+"N�o Ocupacional",oFont09)

		oPrintPPP:Line(lin,50,lin+160,50)
		oPrintPPP:Line(lin,300,lin+160,300)
		oPrintPPP:Line(lin,540,lin+160,540)
	    oPrintPPP:Line(lin,1200,lin+160,1200)
		oPrintPPP:Line(lin,1530,lin+160,1530)
		oPrintPPP:Line(lin,1770,lin+160,1770)
		oPrintPPP:Line(lin,2350,lin+160,2350)
		oPrintPPP:Line(lin+160,50,lin+160,2350)
		Somalinha(160)

	Elseif Mv_par16 == 3 .and. Alltrim(TRBTM5->EXAME) == "NR7"
		//Indicacao do Resultado
		
		oPrintPPP:Say(lin+5+lin2,1540,If(TRBTM5->RESULT=="1","( ) ","( ) ")+"Apto",oFont09)
		oPrintPPP:Line(lin,1770,lin+50+(lin2*2),1770)
		oPrintPPP:Say(lin+5+lin2,1780,If(TRBTM5->RESULT=="2","( ) ","( ) ")+"Inapto",oFont09)
		oPrintPPP:Line(lin,2350,lin+50+(lin2*2),2350)
		
		oPrintPPP:Line(lin+50+(lin2*2),50,lin+50+(lin2*2),2350)
		Somalinha(50+(lin2*2))	
	Else
		//Indicacao do Resultado
		
		oPrintPPP:Say(lin+5+lin2,1540,If(TRBTM5->RESULT=="1" .and. mv_par16 != 2,"( ) ","( ) ")+"Normal",oFont09)
		oPrintPPP:Line(lin,1770,lin+50+(lin2*2),1770)
		oPrintPPP:Say(lin+5+lin2,1780,If(TRBTM5->RESULT=="2" .and. mv_par16 != 2,"( ) ","( ) ")+"Alterado",oFont09)
		oPrintPPP:Line(lin,2350,lin+50+(lin2*2),2350)
		
		oPrintPPP:Line(lin+50+(lin2*2),50,lin+50+(lin2*2),2350)
		Somalinha(50+(lin2*2))	
	Endif

	/*
    oPrintPPP:Line(lin,1200,lin+50+(lin2*2),1200)
	oPrintPPP:Line(lin,1530,lin+50+(lin2*2),1530)    
    
    
	oPrintPPP:Line(lin,2350,lin+50+(lin2*2),2350)
	oPrintPPP:Line(lin+50+(lin2*2),50,lin+50+(lin2*2),2350)
	Somalinha(50+(lin2*2))	
	*/		
	Dbskip()
End
If nTRBTM5 == 0
	If lin+200 > 3000
		Somalinha(,,.t.)
	Endif	                                        
	
	oPrintPPP:Say(lin+5,60,"__/__/____",oFont09)
	oPrintPPP:Say(lin+5,1540,"( ) Normal",oFont09)
	oPrintPPP:Say(lin+5,1780,"( ) Alterado",oFont09)
	oPrintPPP:Say(lin+45,1830,"( ) Est�vel",oFont09)
	oPrintPPP:Say(lin+85,1830,"( ) Agravamento",oFont09)
	oPrintPPP:Say(lin+125,1880,"( ) Ocupacional",oFont09)
	oPrintPPP:Say(lin+165,1880,"( ) N�o Ocupacional",oFont09)

	oPrintPPP:Line(lin,50,lin+210,50)
	oPrintPPP:Line(lin,300,lin+210,300)
	oPrintPPP:Line(lin,540,lin+210,540)
    oPrintPPP:Line(lin,1200,lin+210,1200)
	oPrintPPP:Line(lin,1530,lin+210,1530)
	oPrintPPP:Line(lin,1770,lin+210,1770)
	oPrintPPP:Line(lin,2350,lin+210,2350)
	oPrintPPP:Line(lin+210,50,lin+210,2350)
	Somalinha(210)
Endif

//FIM EXAMES
oPrintPPP:Line(lin,50,lin+60,50)
oPrintPPP:Say(lin+10,70,"18",oFont11)
oPrintPPP:Line(lin,150,lin+60,150)
oPrintPPP:Say(lin+10,160,"RESPONS�VEL PELA MONITORA��O BIOL�GICA",oFont11)
oPrintPPP:Line(lin,2350,lin+60,2350)
oPrintPPP:Line(lin+60,50,lin+60,2350)
Somalinha()
oPrintPPP:Line(lin,50,lin+80,50)
oPrintPPP:Say(lin+5,60,"18.1-Per�odo",oFont09)
oPrintPPP:Line(lin,550,lin+80,550)
oPrintPPP:Say(lin+5,560,"18.2-NIT",oFont09)
oPrintPPP:Line(lin,880,lin+80,880)
oPrintPPP:Say(lin+5,890,"18.3-Registro Conselho",oFont09)
oPrintPPP:Say(lin+45,890,"de Classe",oFont09)
oPrintPPP:Line(lin,1350,lin+80,1350)
oPrintPPP:Say(lin+5,1360,"18.4-Nome do Profissional Legalmente Habilitado",oFont09)
oPrintPPP:Line(lin,2350,lin+80,2350)
oPrintPPP:Line(lin+80,50,lin+80,2350)
Somalinha(30)
lFirst := .t.
Dbselectarea("TRBTMK")
Dbsetorder(1)
Dbseek("1")
While !eof() .and. "1" == TRBTMK->INDFUN
	If (TRBTMK->DTINI > (If(Empty(SRA->RA_DEMISSA),dDataBase,SRA->RA_DEMISSA))) .or. ;
	   (!Empty(TRBTMK->DTFIM) .and. TRBTMK->DTFIM < SRA->RA_ADMISSA)
	
		Dbselectarea("TRBTMK")
		Dbskip()
		Loop
	Endif
	Somalinha(50,lFirst)
	lFirst := .f.
	oPrintPPP:Line(lin,50,lin+50,50)
	cDtPPP := NGPPPDATE(If(TRBTMK->DTINI < SRA->RA_ADMISSA,SRA->RA_ADMISSA,TRBTMK->DTINI))+" a "
	If Empty(TRBTMK->DTFIM)
		cDtPPP += NGPPPDATE(SRA->RA_DEMISSA)
	Else	
		If Empty(SRA->RA_DEMISSA)
			cDtPPP += NGPPPDATE(If(TRBTMK->DTFIM > dDataBase,SRA->RA_DEMISSA,TRBTMK->DTFIM))
		Else
			cDtPPP += NGPPPDATE(If(TRBTMK->DTFIM > SRA->RA_DEMISSA,SRA->RA_DEMISSA,TRBTMK->DTFIM))
		Endif		
	Endif
	oPrintPPP:Say(lin+5,60,cDtPPP,oFont09)
	oPrintPPP:Line(lin,550,lin+50,550)
	If !EMPTY(TRBTMK->NIT)
		oPrintPPP:Say(lin+5,560,Transform(TRBTMK->NIT,"@R 999.99999.99-9"),oFont08) // NIT
	Endif
	oPrintPPP:Line(lin,880,lin+50,880)
	oPrintPPP:Say(lin+5,890,TRBTMK->REGNUM,oFont09) // Registro MTB
	oPrintPPP:Line(lin,1350,lin+50,1350)
	oPrintPPP:Say(lin+5,1360,Substr(TRBTMK->NOME,1,40),oFont09) // Nome
	oPrintPPP:Line(lin,2350,lin+50,2350)
	oPrintPPP:Line(lin+50,50,lin+50,2350)

	Dbselectarea("TRBTMK")
	Dbskip()
End 
If lFirst
	Somalinha(50,.t.)
	oPrintPPP:Line(lin,50,lin+50,50)
	oPrintPPP:Say(lin+5,60,"__/__/____ a __/__/____",oFont09)	
	oPrintPPP:Line(lin,550,lin+50,550)
	oPrintPPP:Line(lin,880,lin+50,880)
	oPrintPPP:Line(lin,1350,lin+50,1350)
	oPrintPPP:Line(lin,2350,lin+50,2350)
	oPrintPPP:Line(lin+50,50,lin+50,2350)
Endif


//QUARTA PARTE 
Somalinha(80)
If lin+920 > 3000
	Somalinha(,,.t.)
Endif
If lin != 380
	oPrintPPP:Line(lin,50,lin,2350)
Endif
oPrintPPP:Line(lin,50,lin+80,50)
oPrintPPP:Line(lin,2350,lin+80,2350)
oPrintPPP:Line(lin+80,50,lin+80,2350)
oPrintPPP:Say(lin+20,70,"IV",oFont13)
oPrintPPP:Line(lin,150,lin+80,150)
oPrintPPP:Say(lin+20,160,"RESPONS�VEIS PELAS INFORMA��ES",oFont13)
Somalinha(80)
txtPPP := "Declaramos, para todos os fins de direito, que as informa��es prestadas neste documento s�o "
txtPPP += "ver�dicas e foram transcritas fielmente dos registros administrativos, das demostra��es "
txtPPP += "ambientais e dos programas m�dicos de responsabilidade da empresa. � de nosso conhecimento que "
txtPPP += "a presta��o de informa��es falsas neste documento constitui crime de falsifica��o de documento "
txtPPP += "p�blico, nos termos do art. 297 do C�digo Penal e, tamb�m, que tais informa��es s�o de car�ter "
txtPPP += "privativo do trabalhador, constituindo crime, nos termos da Lei n� 9.029/95, pr�ticas "
txtPPP += "discriminat�rias decorrentes de sua exigibilidade por outrem, bem como se sua divulga��o para "
txtPPP += "terceiros, ressalvado quando exigido pelos �rg�os p�blicos competentes."
nLinhasMemo := MLCOUNT(txtPPP,130)
For LinhaCorrente := 1 To nLinhasMemo
	If LinhaCorrente == 1
		oPrintPPP:Line(lin,50,lin+55,50)
		oPrintPPP:Say(lin+15,60,MemoLine(txtPPP,130,LinhaCorrente),oFont08)
		oPrintPPP:Line(lin,2350,lin+55,2350)
		If LinhaCorrente == nLinhasMemo
			oPrintPPP:Line(lin+55,50,lin+55,2350)
		Endif
		SomaLinha(55)
	Else
		oPrintPPP:Line(lin,50,lin+45,50)
		oPrintPPP:Line(lin,2350,lin+45,2350)
		oPrintPPP:Say(lin+5,60,MemoLine(txtPPP,130,LinhaCorrente),oFont08)
		If LinhaCorrente == nLinhasMemo
			oPrintPPP:Line(lin+45,50,lin+45,2350)
		Endif
		Somalinha(45,LinhaCorrente != nLinhasMemo)
	Endif
Next
Dbselectarea(cAliasRES)
Dbsetorder(1)
Dbseek(xFilial(cAliasRES)+Mv_par09)

oPrintPPP:Line(lin,50,lin+60,50)
oPrintPPP:Say(lin+10,60,"19-Data Emiss�o PPP",oFont10)
oPrintPPP:Line(lin,500,lin+60,500)
oPrintPPP:Say(lin+10,520,"20",oFont11)
oPrintPPP:Line(lin,580,lin+60,580)
oPrintPPP:Say(lin+10,590,"REPRESENTANTE LEGAL DA EMPRESA",oFont11)
oPrintPPP:Line(lin,2350,lin+60,2350)
oPrintPPP:Line(lin+60,50,lin+60,2350)
Somalinha()
oPrintPPP:Line(lin,50,lin+500,50)
oPrintPPP:Line(lin,2350,lin+500,2350)
oPrintPPP:Line(lin+500,50,lin+500,2350)
oPrintPPP:Line(lin+100,500,lin+100,2350)
oPrintPPP:Line(lin,500,lin+500,500)
oPrintPPP:Say(lin+10,510,"20.1-NIT",oFont09)
If !Empty(&cCdNitRES)
	oPrintPPP:Say(lin+55,510,Transform(&cCdNitRES,"@R 999.99999.99-9"),oFont10)
Endif
oPrintPPP:Line(lin,1300,lin+500,1300)
oPrintPPP:Say(lin+10,1310,"20.2-Nome",oFont09)
oPrintPPP:Say(lin+55,1310,Substr(&cCNomeRES,1,40),oFont10)

oPrintPPP:Say(lin+170,150,NGPPPDATE(dDataBase),oFont10)
oPrintPPP:Say(lin+440,785,"(Carimbo)",oFont09)
oPrintPPP:Line(lin+430,1450,lin+430,2250)
oPrintPPP:Say(lin+440,1700,"(Assinatura)",oFont09)
Somalinha(500)

Somalinha(20)
oPrintPPP:Line(lin,50,lin,2350)
oPrintPPP:Line(lin,50,lin+80,50)
oPrintPPP:Line(lin,2350,lin+80,2350)
oPrintPPP:Line(lin+80,50,lin+80,2350)
oPrintPPP:Say(lin+20,60,"OBSERVA��ES",oFont13)
Somalinha(80)
Dbselectarea("TMZ")
Dbsetorder(1)
Dbseek(xFilial("TMZ")+Mv_par14)
nLinhasMemo := MLCOUNT(TMZ->TMZ_DESCRI,130)
For LinhaCorrente := 1 To nLinhasMemo
	If LinhaCorrente == 1
		oPrintPPP:Line(lin,50,lin+55,50)
		oPrintPPP:Say(lin+15,60,MemoLine(TMZ->TMZ_DESCRI,130,LinhaCorrente),oFont08)
		oPrintPPP:Line(lin,2350,lin+55,2350)
		If LinhaCorrente == nLinhasMemo
			oPrintPPP:Line(lin+55,50,lin+55,2350)
		Endif
		SomaLinha(55)
	Else
		oPrintPPP:Line(lin,50,lin+45,50)
		oPrintPPP:Line(lin,2350,lin+45,2350)
		oPrintPPP:Say(lin+5,60,MemoLine(TMZ->TMZ_DESCRI,130,LinhaCorrente),oFont08)
		If LinhaCorrente == nLinhasMemo
			oPrintPPP:Line(lin+45,50,lin+45,2350)
		Endif
		Somalinha(45,LinhaCorrente != nLinhasMemo)
	Endif
Next
If nLinhasMemo < 1
	oPrintPPP:Line(lin,50,lin+90,50)
	oPrintPPP:Line(lin,2350,lin+90,2350)
	oPrintPPP:Line(lin+90,50,lin+90,2350)
	Somalinha(90)
Endif
If mv_par12 == 2
	For nInd := 1 to Len(aNUMCAPS)
		If nInd == 1
			oPrintPPP:Line(lin,50,lin+60,50)
			oPrintPPP:Say(lin+10,70,"OBSERVA��ES REFERENTES AOS EPI'S",oFont11)
			oPrintPPP:Line(lin,2350,lin+60,2350)
			oPrintPPP:Line(lin+60,50,lin+60,2350)
			Somalinha(60)
		Endif
			oPrintPPP:Line(lin,50,lin+40,50)
			oPrintPPP:Line(lin,2350,lin+40,2350)
			oPrintPPP:Say(lin+5,60,Substr("C.A. :"+aNUMCAPS[nInd,1]+" - "+aNUMCAPS[nInd,2],1,105),oFont09)
			If nInd == Len(aNUMCAPS)
				oPrintPPP:Line(lin+40,50,lin+40,2350)
			Endif
			Somalinha(40,nInd != Len(aNUMCAPS))
	Next nInd
Endif

RestArea(aAREASRA)

oPrintPPP:Say(3100,1170,Str(nPaginaPPP,3),oFont09n)
oPrintPPP:EndPage()
nPaginaPPP++

If Mv_par10 == 2
	MDTERMO700()
Endif

Return
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �NG700VECAT� Autor �Denis Hyroshi de Souza � Data � 21/10/02 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Verifica se o Funcionario tem Cat impresso.                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/  
Static Function NG700VECAT(cFilialTM0,nFicha)
Local lSai := .f. 

Dbselectarea("TNC")
Dbsetorder(1)
Dbseek(xFilial("TNC",cFilialTM0))

While !Eof() .and. xFilial("TNC",cFilialTM0) == TNC->TNC_FILIAL
 
	If nFicha = TNC->TNC_NUMFIC .And. !Empty(TNC->TNC_DTEMIS)
	   
		cCat := TNC->TNC_ACIDEN
	   
		If TNC->(FieldPos('TNC_CATINS')) > 0 
			If !Empty(TNC->TNC_CATINS)
				cCat := TNC->TNC_CATINS
			Else
				Dbselectarea("TNC")
				Dbskip()
				Loop
			Endif
		Endif	   
		If aScan(aCat,{|x| Dtos(x[1])+x[2] == Dtos(TNC->TNC_DTEMIS)+SubStr(cCat,1,13) }) <= 0
			AADD(aCat,{TNC->TNC_DTEMIS,SubStr(cCat,1,13)})
		Endif

	Endif
	Dbskip()
End

Return
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �NG700HISTO� Autor �Denis Hyroshi de Souza � Data � 21/10/02 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Carrega os dados do historico do funcionario               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/  
Static Function NG700HISTO()  
Local aHistory := {},nWWW,nXYZ,nBeg
Local cCBO        := " " // Guarda o CBO da Funcao
Local lFimPPP     := .f. // Verifica se acabou o historico de setores
Local dINIPPP     := SRA->RA_ADMISSA //Data Inicio do PPP
Local dFIMPPP     := If(empty(SRA->RA_DEMISSA),dDataBase,SRA->RA_DEMISSA) // Data limite p/ uma transferencia
Local dFINALPPP   := dFIMPPP //Data final do PPP
Local aDadosPPP   := {} //Grava dados do historico de setores
Local cDesFunPPP  := Space(25) //Descricao da Funcao do periodo anterior
Local cDesFunFOR  := Space(25) //Descricao da Funcao do periodo anterior
Local cFuncaoPPP  := Space(Len(SRA->RA_CODFUNC)) // Funcao do periodo anterior
Local cFuncaoFOR  := Space(Len(SRA->RA_CODFUNC)) // Funcao do periodo anterior
Local lAchou      := .t. //Variavel de Controle
Local lInicio     := .t. //Variavel de Controle
Local dDataFOR    := ctod("  /  /  ")
Local cKeyFil     := SRA->RA_FILIAL // Filial origem
Local cKeyMat     := SRA->RA_MAT // Matricula origem
Local cKeyCus     := SRA->RA_CC // Centro Custo origem
Local cCondCus    := Space(Len(SRA->RA_CC))
Local cCondALL    := Space(10)
Local lFirstSRE   := .t. //Indica se eh o primeiro SRE
Local lFirst      := .t.
Local lAchouSRE   := .f.
Local nTotRegPPP  := 0,nRegPPP := 0
Local lPrimeiro   := .t.,_dFimPPP  := ctod("  /  /  ")
Local cFunAnter   := Space(5) //Funcao Anterior, para verificar se nao esta gravando funcao igual
Local cRA_CODFUNC := SRA->RA_CODFUNC //Se nao achar transf. de funcao o programa adota a funcao atual
Private dDtTransf := CtoD("  /  /  "),cFilTNF := "  "

While !lFimPPP
	lPrimeiro := .t.
	_dFimPPP  := ctod("  /  /  ")
	cCondCus  := cKeyCus
	cCondALL  := cEmpPPP+cKeyFil+cKeyMat
	Dbselectarea("SRE")
	Dbsetorder(2) 
	Dbseek(cCondALL)
	While !eof() .and. cCondALL == SRE->RE_EMPP+SRE->RE_FILIALP+SRE->RE_MATP

			If SRE->RE_EMPP == SRE->RE_EMPD .and. SRE->RE_FILIALP == SRE->RE_FILIALD .and. ;
				SRE->RE_MATP == SRE->RE_MATD .and. SRE->RE_CCP == SRE->RE_CCD
				Dbselectarea("SRE")
				Dbskip()
				Loop
			Endif

			If (If(lFirstSRE,SRE->RE_DATA > dFIMPPP,SRE->RE_DATA >= dFIMPPP)) .or. ;
				SRE->RE_DATA < dINIPPP
				Dbselectarea("SRE")
				Dbskip()
				Loop
			Endif
			If SRE->RE_CCP != cCondCus
				Dbselectarea("SRE")
				Dbskip()
				Loop
			Endif

			lFirstSRE := .f.
			If lPrimeiro
				cKeyFil := SRE->RE_FILIALD
				cKeyMat := SRE->RE_MATD
				cKeyCus := SRE->RE_CCD
				aADD(aDadosPPP,{SRE->RE_DATA,dFimPPP,SRE->RE_FILIALP,SRE->RE_MATP,SRE->RE_CCP})			
				_dFimPPP := SRE->RE_DATA
			Else
				If SRE->RE_DATA > aDadosPPP[Len(aDadosPPP)][1]
					cKeyFil := SRE->RE_FILIALD
					cKeyMat := SRE->RE_MATD
					cKeyCus := SRE->RE_CCD
					aDadosPPP[Len(aDadosPPP)][1] := SRE->RE_DATA
					_dFimPPP := SRE->RE_DATA
				Endif
			Endif
			lPrimeiro := .f.

			If SRE->RE_EMPD != cEmpPPP 	// O funcionario esta mudando de empresa, portanto, o processo para aqui
				lFimPPP := .t.
			Else
				lFimPPP := .f.
			Endif			

			Dbselectarea("SRE")
			Dbskip()
	End
	If lPrimeiro
		lFimPPP := .t.
		If SRA->RA_ADMISSA < dFimPPP
			aADD(aDadosPPP,{SRA->RA_ADMISSA,dFimPPP,cKeyFil,cKeyMat,cKeyCus})
		Endif
	Else
		dFimPPP := _dFimPPP
    Endif	
End

If Len(aDadosPPP) == 0
	aADD(aDadosPPP,{SRA->RA_ADMISSA,dFINALPPP,SRA->RA_FILIAL,SRA->RA_MAT,SRA->RA_CC})
Endif

If Len(aDadosPPP) > 1
	For nWWW := Len(aDadosPPP) to 1 Step -1
		Dbselectarea("SR7")
		Dbsetorder(1)
		If Dbseek(aDadosPPP[nWWW][3]+aDadosPPP[nWWW][4]+DTOS(dINIPPP))
			If SR7->R7_DATA == dINIPPP
				cFuncaoPPP := SR7->R7_FUNCAO
				cDesFunPPP := SR7->R7_DESCFUN
				Exit
			Endif
		Endif
	Next nWWW
Endif

lAchouSRE := .f.

aSRArea := SRA->(GetArea())
For nXYZ := Len(aDadosPPP) to 1 Step -1
	If nXYZ != Len(aDadosPPP)
		cFunAnter := cFuncaoPPP
	Else
		cFunAnter := Space(5)
	Endif

	If (aScan(aMatriculas,{|x| x[1]+x[2] == aDadosPPP[nXYZ][3]+aDadosPPP[nXYZ][4]})) <= 0  
		aADD(aMatriculas,{aDadosPPP[nXYZ][3],aDadosPPP[nXYZ][4]})//MAtriculas Utilizadas pelo funcionario na empresa
	Endif

	aAreaAtual := {}
	aAreaVelha := {}
	dDtTermino := CtoD("  /  /    ")
	lAchou     := .t.
	lInicio    := .t.
	lFirst     := .t.
	Dbselectarea("SR7")
	Dbsetorder(1)
	Dbseek(aDadosPPP[nXYZ][3]+aDadosPPP[nXYZ][4]+Dtos(aDadosPPP[nXYZ][1]),.t.)
	While !eof() .and. aDadosPPP[nXYZ][3]+aDadosPPP[nXYZ][4] == SR7->R7_FILIAL+SR7->R7_MAT .and.;
		(If(nXYZ != 1,SR7->R7_DATA < aDadosPPP[nXYZ][2],SR7->R7_DATA <= aDadosPPP[nXYZ][2]))

		cCNPJ := Space(10)
		nTIPINS := 2
		aAreaEMP := SM0->(GetArea())
		
		If lNGMDTPS
			Dbselectarea("SA1")
			Dbsetorder(1)
			Dbseek(xFilial("SA1",aDadosPPP[nXYZ][3])+Substr(aDadosPPP[nXYZ][5],1,6))
			cCNPJ := SA1->A1_CGC
		Else
			Dbselectarea("SM0")
			Dbseek(cEmpPPP+aDadosPPP[nXYZ][3])
			cCNPJ := SM0->M0_CGC
			nTIPINS := SM0->M0_TPINSC
		Endif
		RestArea(aAreaEMP)

		Dbselectarea("SRJ")
		Dbsetorder(1)
		Dbseek(xFilial("SRJ",aDadosPPP[nXYZ][3])+SR7->R7_FUNCAO)

		Dbselectarea("TRBPPP")
		Dbsetorder(1)
		If !Dbseek(DTOS(SR7->R7_DATA)) .and. SR7->R7_FUNCAO != cFunAnter
			lAchouSRE := .t.
			Reclock("TRBPPP",.t.)
			TRBPPP->DTDE   := SR7->R7_DATA
			TRBPPP->DTATE  := aDadosPPP[nXYZ][2]
			TRBPPP->CNPJ   := cCNPJ
			TRBPPP->TIPINS := nTIPINS
			TRBPPP->FILIAL := aDadosPPP[nXYZ][3]
			TRBPPP->MAT    := aDadosPPP[nXYZ][4]
			TRBPPP->CUSTO  := aDadosPPP[nXYZ][5]
			TRBPPP->CARGO  := SRJ->RJ_CARGO
			TRBPPP->CODFUN := SR7->R7_FUNCAO
			TRBPPP->DESFUN := If(!Empty(SR7->R7_DESCFUN),SR7->R7_DESCFUN,SRJ->RJ_DESC)
			Msunlock("TRBPPP")
			cFunAnter := SR7->R7_FUNCAO
		Else
			Dbselectarea("SR7")
			Dbskip()
			Loop
		Endif
		
		//Guarda ultimo registro do arquivo de trabalho TRBPPP. Para alterar a data fim no proximo laco.
		aAreaAtual := TRBPPP->(GetArea()) 

		cFuncaoFOR := SR7->R7_FUNCAO
		cDesFunFOR := SR7->R7_DESCFUN
		dDtTermino := SR7->R7_DATA //Variavel para alterar a data fim do registro anterior

		If lFirst //Se for a primeira vez que entrou no laco
			dDataFOR := SR7->R7_DATA
			lFirst := .f.
		Else
			RestArea(aAreaVelha)
			If !eof() .and. !bof()
				Reclock("TRBPPP",.f.)
				TRBPPP->DTATE  := dDtTermino //Altera a data fim do registro anterior
				Msunlock("TRBPPP")
			Endif
			RestArea(aAreaAtual)
		Endif
		
		aAreaVelha := TRBPPP->(GetArea()) 
		
		If aDadosPPP[nXYZ][1] == SR7->R7_DATA
			//Variavel de controle. Para saber se existe mudanca de funcao no comeco da transferencia
			lInicio := .f. 
		Endif
		
		//Variavel de controle. Para saber se houve mudanca de funcao
		lAchou := .f. 

		Dbselectarea("SR7")
		Dbskip()
	End 

	If lAchou // se nao achou nenhuma mudanca de funcao
		cCNPJ := Space(10)
		nTIPINS := 2
		aAreaEMP := SM0->(GetArea())
		
		If lNGMDTPS
			Dbselectarea("SA1")
			Dbsetorder(1)
			Dbseek(xFilial("SA1",aDadosPPP[nXYZ][3])+Substr(aDadosPPP[nXYZ][5],1,6))
			cCNPJ := SA1->A1_CGC
		Else
			Dbselectarea("SM0")
			Dbseek(cEmpPPP+aDadosPPP[nXYZ][3])
			cCNPJ := SM0->M0_CGC
			nTIPINS := SM0->M0_TPINSC
		Endif
		RestArea(aAreaEMP)

		Dbselectarea("SRJ")
		Dbsetorder(1)
		Dbseek(xFilial("SRJ",aDadosPPP[nXYZ][3])+cFuncaoPPP)
		
		Dbselectarea("TRBPPP")
		Dbsetorder(1)
		If !Dbseek(DTOS(aDadosPPP[nXYZ][1]))
			Reclock("TRBPPP",.t.)
			TRBPPP->DTDE   := aDadosPPP[nXYZ][1]
			TRBPPP->DTATE  := aDadosPPP[nXYZ][2]
			TRBPPP->CNPJ   := cCNPJ
			TRBPPP->TIPINS := nTIPINS
			TRBPPP->CUSTO  := aDadosPPP[nXYZ][5]
			TRBPPP->FILIAL := aDadosPPP[nXYZ][3]
			TRBPPP->MAT    := aDadosPPP[nXYZ][4]
			TRBPPP->CARGO  := SRJ->RJ_CARGO
			TRBPPP->CODFUN := cFuncaoPPP
			TRBPPP->DESFUN := If(Empty(cDesFunPPP),SRJ->RJ_DESC,cDesFunPPP)
			cFuncaoFOR   := cFuncaoPPP
			cDesFunFOR   := cDesFunPPP
			Msunlock("TRBPPP")
		Endif
	Elseif lInicio // se nao achou nenhuma mudanca de funcao no inicio da mudanca de setor
		cCNPJ := Space(10)
		nTIPINS := 2
		aAreaEMP := SM0->(GetArea())
		
		If lNGMDTPS
			Dbselectarea("SA1")
			Dbsetorder(1)
			Dbseek(xFilial("SA1",aDadosPPP[nXYZ][3])+Substr(aDadosPPP[nXYZ][5],1,6))
			cCNPJ := SA1->A1_CGC
		Else
			Dbselectarea("SM0")
			Dbseek(cEmpPPP+aDadosPPP[nXYZ][3])
			cCNPJ := SM0->M0_CGC
			nTIPINS := SM0->M0_TPINSC
		Endif
		RestArea(aAreaEMP)

		Dbselectarea("SRJ")
		Dbsetorder(1)
		Dbseek(xFilial("SRJ",aDadosPPP[nXYZ][3])+cFuncaoPPP)
		
		Dbselectarea("TRBPPP")
		Dbsetorder(1)
		If !Dbseek(DTOS(aDadosPPP[nXYZ][1]))
			Reclock("TRBPPP",.t.)
			TRBPPP->DTDE   := aDadosPPP[nXYZ][1]
			TRBPPP->DTATE  := dDataFOR
			TRBPPP->CNPJ   := cCNPJ
			TRBPPP->TIPINS := nTIPINS
			TRBPPP->CUSTO  := aDadosPPP[nXYZ][5]
			TRBPPP->FILIAL := aDadosPPP[nXYZ][3]
			TRBPPP->MAT    := aDadosPPP[nXYZ][4]
			TRBPPP->CARGO  := SRJ->RJ_CARGO
			TRBPPP->CODFUN := cFuncaoPPP
			TRBPPP->DESFUN := If(Empty(cDesFunPPP),SRJ->RJ_DESC,cDesFunPPP)
			Msunlock("TRBPPP")
		Endif
	Endif
	cFuncaoPPP := cFuncaoFOR
	cDesFunPPP := cDesFunFOR
Next 
RestArea(aSRArea)

If !lAchouSRE
	Begin Sequence
		Dbselectarea("SRJ")
		Dbsetorder(1)
		If Dbseek(xFilial("SRJ")+cRA_CODFUNC)
			Dbselectarea("TRBPPP")
			Dbgotop()
			While !eof()
				RecLock("TRBPPP",.f.)
				TRBPPP->CODFUN := cRA_CODFUNC
				TRBPPP->DESFUN := SRJ->RJ_DESC
				TRBPPP->CARGO  := SRJ->RJ_CARGO
				MsUnLock("TRBPPP")
				Dbskip()
			End
			Break
		Endif
		For nBeg := Len(aMatriculas) to 1 step -1
			Dbselectarea("SRJ")
			Dbsetorder(1)
			If Dbseek(xFilial("SRJ",aMatriculas[nBeg,1])+cRA_CODFUNC)
				Dbselectarea("TRBPPP")
				Dbgotop()
				While !eof()
					RecLock("TRBPPP",.f.)
					TRBPPP->CODFUN := cRA_CODFUNC
					TRBPPP->DESFUN := SRJ->RJ_DESC
					TRBPPP->CARGO  := SRJ->RJ_CARGO
					MsUnLock("TRBPPP")
					Dbskip()
				End
				Break
			Endif
		Next nBeg
	End Sequence
Endif

nRegPPP := 0
lAchouGFIP := .f.
cGFIPant := "00"
Dbselectarea("TRBPPP")
nTotRegPPP := TRBPPP->(Reccount())
Dbsetorder(1)
Dbgotop()
While !eof()
	lAchou := .f.
	nRegPPP++

	Dbselectarea("SR9")
	Dbsetorder(1)
	Dbseek(TRBPPP->FILIAL+TRBPPP->MAT+"RA_OCORREN")
	While !eof() .and. TRBPPP->FILIAL+TRBPPP->MAT == SR9->R9_FILIAL+SR9->R9_MAT .and.;
		"RA_OCORREN" == SR9->R9_CAMPO .and. !lAchou
		
	    If TRBPPP->DTDE > SR9->R9_DATA .or. ;
	    (If(nTotRegPPP != nRegPPP,TRBPPP->DTATE <= SR9->R9_DATA,TRBPPP->DTATE < SR9->R9_DATA))
	    	Dbselectarea("SR9")
	    	Dbskip()
	    	Loop
	    Endif

		lAchou := .t.
		lAchouGFIP := .t.
		Dbselectarea("TRBPPP")
		cGFIPant := Alltrim(SR9->R9_DESC)
		RecLock("TRBPPP",.f.)
		TRBPPP->GFIP := Alltrim(SR9->R9_DESC)
		Msunlock("TRBPPP")

	   	Dbselectarea("SR9")
	   	Dbskip()
	End
	
	Dbselectarea("TRBPPP")
	If !lAchou
		RecLock("TRBPPP",.f.)
		TRBPPP->GFIP := cGFIPant
		Msunlock("TRBPPP")
	Endif
	if Empty(TRBPPP->GFIP) .or. TRBPPP->GFIP == "00"
		RecLock("TRBPPP",.f.)
		TRBPPP->GFIP := "00"
		MsUnLock("TRBPPP")

		Dbselectarea(cAlias)
		Dbsetorder(1)
		If Dbseek(xFilial(cAlias,TRBPPP->FILIAL)+TRBPPP->CUSTO)
			If cAlias == "SI3"
				If FieldPos("I3_OCORREN") > 0 
					If !Empty(SI3->I3_OCORREN)
						Dbselectarea("TRBPPP")
						RecLock("TRBPPP",.f.)
						TRBPPP->GFIP := SI3->I3_OCORREN
						MsUnLock("TRBPPP")
					Endif
				Endif
			Else
				If FieldPos("CTT_OCORRE") > 0
					If !Empty(CTT->CTT_OCORRE)
						Dbselectarea("TRBPPP")
						RecLock("TRBPPP",.f.)
						TRBPPP->GFIP := CTT->CTT_OCORRE
						MsUnLock("TRBPPP")
					Endif
				Endif
			Endif
		Endif
	Endif
	
   	Dbselectarea("TRBPPP")
   	Dbskip()
End

If !lAchouGFIP
	Dbselectarea("TRBPPP")
	Dbgotop()
	While !eof()
		If !Empty(SRA->RA_OCORREN) .or. Substr(SRA->RA_OCORREN,1,2) == "00"
			RecLock("TRBPPP",.f.)
			TRBPPP->GFIP := SRA->RA_OCORREN
			MsUnLock("TRBPPP")
		Else
			Dbselectarea(cAlias)
			Dbsetorder(1)
			If Dbseek(xFilial(cAlias,TRBPPP->FILIAL)+TRBPPP->CUSTO)
				If cAlias == "SI3"
					If FieldPos("I3_OCORREN") > 0 
						If !Empty(SI3->I3_OCORREN)
							RecLock("TRBPPP",.f.)
							TRBPPP->GFIP := SI3->I3_OCORREN
							MsUnLock("TRBPPP")
						Endif
					Endif
				Else
					If FieldPos("CTT_OCORRE") > 0
						If !Empty(CTT->CTT_OCORRE)
							RecLock("TRBPPP",.f.)
							TRBPPP->GFIP := CTT->CTT_OCORRE
							MsUnLock("TRBPPP")
						Endif
					Endif
				Endif
			Endif
		Endif
		If Empty(TRBPPP->GFIP)
			RecLock("TRBPPP",.f.)
			TRBPPP->GFIP := "00"
			MsUnLock("TRBPPP")
		Endif

		Dbselectarea("TRBPPP")
		Dbskip()
	End
Endif

lTroca    := .t.
cTrocaFun := " "
//Executa os historicos
Dbselectarea("TRBPPP")
nRegTRB := TRBPPP->(RECCOUNT())
nConTRB := 0
Dbgotop()
While !eof()
	nConTRB++
	
	If nConTRB > 1
		If cFilTNF != TRBPPP->FILIAL
			dDtTransf := TRBPPP->DTDE
			cFilTNF   := TRBPPP->FILIAL
		Endif
	Else
		cFilTNF := TRBPPP->FILIAL
	Endif

	Dbselectarea("TM0")
	Dbsetorder(3)
	If Dbseek(xFilial("TM0",TRBPPP->FILIAL)+TRBPPP->MAT)
		If (aScan(aFichasUsa,{|x| x[1]+x[2]+DTOS(x[3])+DTOS(x[4]) == TRBPPP->FILIAL+TM0->TM0_NUMFIC+DTOS(TRBPPP->DTDE)+DTOS(TRBPPP->DTATE-If(nRegTRB == nConTRB,0,1))})) <= 0  
			aADD(aFichasUsa,{TRBPPP->FILIAL,TM0->TM0_NUMFIC,TRBPPP->DTDE,TRBPPP->DTATE-If(nRegTRB == nConTRB,0,1)})//Fichas Utilizadas pelo funcionario na empresa
			NG700VECAT(TRBPPP->FILIAL,TM0->TM0_NUMFIC) //Verifica se existe CAT para a Ficha Medica do Funcionario
		Endif
	Endif

	Dbselectarea("SRJ")
	Dbsetorder(1)
	Dbseek(xFilial("SRJ",TRBPPP->FILIAL)+TRBPPP->CODFUN)
	cCBO  := SRJ->RJ_CBO
	If FieldPos("RJ_CODCBO") > 0 .and. Year(TRBPPP->DTATE) >= 2003
		lTroca := .f.
		If !Empty(SRJ->RJ_CODCBO)
			cCBO := SRJ->RJ_CODCBO
		Endif
	Endif
	cTrocaFun := TRBPPP->CODFUN

	Dbselectarea("SQ3")
	Dbsetorder(1)
	If !Dbseek(xFilial("SQ3",TRBPPP->FILIAL)+TRBPPP->CARGO+TRBPPP->CUSTO) 
		Dbselectarea("SQ3")
		Dbsetorder(1)
		Dbseek(xFilial("SQ3",TRBPPP->FILIAL)+TRBPPP->CARGO)
		
		If aScan(aCargoSv,{|x| x[1]+x[2] == TRBPPP->FILIAL+TRBPPP->CARGO}) <= 0
			aAdd(aCargoSv,{TRBPPP->FILIAL,TRBPPP->CARGO,""})
		Endif
	Else
		If aScan(aCargoSv,{|x| x[1]+x[2]+x[3] == TRBPPP->FILIAL+TRBPPP->CARGO+TRBPPP->CUSTO}) <= 0
			aAdd(aCargoSv,{TRBPPP->FILIAL,TRBPPP->CARGO,TRBPPP->CUSTO})
		Endif
	Endif
	strCargo := SQ3->Q3_DESCSUM
	
	cCNPJtrb := TRBPPP->CNPJ
	cTIPOtrb := TRBPPP->TIPINS
	Dbselectarea(cAlias)
	Dbsetorder(1)
	If Dbseek(xFilial(cAlias,TRBPPP->FILIAL)+TRBPPP->CUSTO)
		If cAlias == "SI3"
			If FieldPos("I3_TIPO") > 0 .and. FieldPos("I3_CEI") > 0
				If !Empty(SI3->I3_CEI)
					cTIPOtrb := If(SI3->I3_TIPO=="1",2,1)
					cCNPJtrb := SI3->I3_CEI
				Endif
			Endif
		Else
			If FieldPos("CTT_TIPO") > 0 .and. FieldPos("CTT_CEI") > 0
				If !Empty(CTT->CTT_CEI)
					cTIPOtrb := If(CTT->CTT_TIPO=="1",2,1)
					cCNPJtrb := CTT->CTT_CEI
				Endif
			Endif
		Endif
	Endif
	strCCusto := &cDescr

	//Adiciona dados para o Historico do Funcionario
	AADD(aHistory,{TRBPPP->FILIAL,TRBPPP->MAT,TRBPPP->DTDE,TRBPPP->DTATE-If(nRegTRB == nConTRB,0,1),;
	Alltrim(strCCusto),	Alltrim(strCargo),Alltrim(TRBPPP->DESFUN),cCBO,TRBPPP->GFIP,cCNPJtrb,cTIPOtrb})

	//Verifica se o funcionario executou alguma tarefa 

	NG700TAREF(TRBPPP->FILIAL,TRBPPP->MAT,TRBPPP->DTDE,TRBPPP->DTATE-If(nRegTRB == nConTRB,0,1),TRBPPP->CUSTO,TRBPPP->CODFUN,TM0->TM0_NUMFIC)

	Dbselectarea("TRBPPP")
	Dbskip()	
End

Return aHistory  
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �NG700RISCO� Autor �Denis Hyroshi de Souza � Data � 21/10/02 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Verifica os riscos que o funcionario esteve exposto        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/  
Static Function NG700RISCO(cFilFun,cFichaM,cTarefa,cCusto,cFuncc,Mat,dIniRisco,dFinRisco,nParam)
Local xEpis,xx
_cTarefa := cTarefa
_centrCusto  := cCusto
_cFuncc  := cFuncc 
cMatric  := Mat
nRisco   := space(9)

If nParam > 0
    For xx := 1 to nParam  
   		If xx == 1    
			_centrCusto := cCusto
			_cFuncc     := cFuncc 
			_cTarefa    := "*     " 	    
    	ElseIf xx == 2    
			_centrCusto := "*"+Space(nSizeSI3-1)
			_cFuncc     := "*"+Space(nSizeSRJ-1)
			_cTarefa    := "*     " 	
        ElseIf xx == 3
        	_centrCusto := cCusto
        	_cFuncc     := "*"+Space(nSizeSRJ-1)
        	_cTarefa    := "*     " 	
        ElseIf xx == 4
        	_centrCusto := "*"+Space(nSizeSI3-1)
        	_cFuncc     := cFuncc     
        	_cTarefa    := "*     " 	
   		ElseIf xx == 5    
			_centrCusto := cCusto
			_cFuncc     := cFuncc 
			_cTarefa    := cTarefa 
        ElseIf xx == 6    
			_centrCusto := "*"+Space(nSizeSI3-1)
			_cFuncc     := "*"+Space(nSizeSRJ-1)
			_cTarefa    := cTarefa 
        ElseIf xx == 7
        	_centrCusto := cCusto
        	_cFuncc     := "*"+Space(nSizeSRJ-1)
        	_cTarefa    := cTarefa 
        ElseIf xx == 8
        	_centrCusto := "*"+Space(nSizeSI3-1)
        	_cFuncc     := cFuncc     
        	_cTarefa    := cTarefa 
        EndIf             

		DbSelectArea("TN0")
		DbSetOrder(5)
		IF DbSeek(xFilial("TN0") + _centrCusto + _cFuncc) // + _cTarefa )
			Do While !EOF()                                   .AND. ;
				TN0->TN0_CC     == _centrCusto                .AND. ;
				TN0->TN0_CODFUN == _cFuncc                    .AND. ;
				TN0->TN0_FILIAL == xFilial("TN0")

				//TN0->TN0_CODTAR == _cTarefa                   .AND. ;
				//TN0->TN0_FILIAL == xFilial("TN0",cFilFun)
	        
		        lStart  := .f.              
				dInicioRis := dIniRisco
				dFimRis    := dFinRisco

		 		dtAval := TN0->TN0_DTRECO	
		    	If dtAval > dFimRis .or. Empty(TN0->TN0_DTAVAL)
			    	Dbselectarea("TN0")
			    	Dbskip()
			    	Loop
			    Endif	     
	            If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM <  dInicioRis
			    	Dbselectarea("TN0")
			    	Dbskip()
			    	Loop
			    Endif	                 			                       
				If dtAval >= dInicioRis  .and. dtAval <= dFimRis 	
				    lStart  := .t.
					If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
						dFimRis := TN0->TN0_DTELIM
					Endif  
					dInicioRis := dtAval 		
				Elseif dtAval < dInicioRis .and. (Empty(TN0->TN0_DTELIM) .OR. TN0->TN0_DTELIM >= dInicioRis)  
					lStart  := .t.			
					If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
						dFimRis := TN0->TN0_DTELIM
					Endif  		
				Endif                        	
				If lStart
					
					//Apaga todos os registros do arquivo temporario onde estao os EPI's entregues
					Dbselectarea("TRBTNF")
					ZAP
					lFirst     := .t.
					lAchouIni  := .t.

					Dbselectarea("TNX")
					Dbsetorder(1)
					Dbseek(xFilial("TNX",cFilFun)+TN0->TN0_NUMRIS)
					While !eof() .and. xFilial("TNX",cFilFun) == TNX->TNX_FILIAL .and. ;
						TN0->TN0_NUMRIS == TNX->TNX_NUMRIS

						Dbselectarea("TNF")
						Dbsetorder(2)
						Dbseek(xFilial("TNF",cFilFun)+TNX->TNX_EPI) 
						While !eof() .and. xFilial("TNF",cFilFun) == TNF->TNF_FILIAL .and. ;
							TNX->TNX_EPI == TNF->TNF_CODEPI
							
							cNUMCAP := Space(12)
							If TNF->TNF_MAT != Mat
								Dbselectarea("TNF")
								Dbskip()
								Loop
							Endif
							If TNF->TNF_DTENTR < dInicioRis .or. TNF->TNF_DTENTR > dFimRis
								Dbselectarea("TNF")
								Dbskip()                  
								Loop
							Endif

							lFirst := .f.
							If TNF->TNF_DTENTR == dInicioRis
								//lAchouIni  := .f.
							Endif

							If TNF->(FieldPos("TNF_NUMCAP")) <= 0
								Dbselectarea("TN3")
								Dbsetorder(1)
								If Dbseek(xFilial("TN3",cFilFun)+TNF->TNF_FORNEC+TNF->TNF_LOJA+TNF->TNF_CODEPI)
									cNUMCAP := TN3->TN3_NUMCAP
									If aSCAN(aNUMCAPS,{|x| x[1] == TN3->TN3_NUMCAP}) == 0 .and. !Empty(TN3->TN3_OBSAVA)
										aADD(aNUMCAPS,{TN3->TN3_NUMCAP,TN3->TN3_OBSAVA})
									Endif
								Endif
							Else
								cNUMCAP := TNF->TNF_NUMCAP
								Dbselectarea("TN3")
								Dbsetorder(3)
								If Dbseek(xFilial("TN3",cFilFun)+TNF->TNF_FORNEC+TNF->TNF_LOJA+TNF->TNF_CODEPI+TNF->TNF_NUMCAP)
									If aSCAN(aNUMCAPS,{|x| x[1] == TNF->TNF_NUMCAP}) == 0 .and. !Empty(TN3->TN3_OBSAVA)
										aADD(aNUMCAPS,{TNF->TNF_NUMCAP,TN3->TN3_OBSAVA})
									Endif
								Endif
							Endif
							
							Dbselectarea("TRBTNF")
							Dbgotop()
							If !Dbseek(DTOS(TNF->TNF_DTENTR)+cNUMCAP)
								RecLock("TRBTNF",.t.)
								TRBTNF->DTINI  := TNF->TNF_DTENTR
								TRBTNF->NUMCAP := cNUMCAP
							Endif
							Dbselectarea("TNF")
							Dbskip()
					    End
						Dbselectarea("TNX")
						Dbskip()
					End
					
					//Busca Epi entregue antes de exposicao ao risco
					If lAchouIni
						//dDtUltimo := ctod("  /  /  ")
						Dbselectarea("TNX")
						Dbsetorder(1)
						Dbseek(xFilial("TNX",cFilFun)+TN0->TN0_NUMRIS)
						While !eof() .and. xFilial("TNX",cFilFun) == TNX->TNX_FILIAL .and. ;
							TN0->TN0_NUMRIS == TNX->TNX_NUMRIS
	
							Dbselectarea("TNF")
							Dbsetorder(2)
							Dbseek(xFilial("TNF",cFilFun)+TNX->TNX_EPI) 
							While !eof() .and. xFilial("TNF",cFilFun) == TNF->TNF_FILIAL .and. ;
								TNX->TNX_EPI == TNF->TNF_CODEPI

								cNUMCAP := Space(12)
								If TNF->TNF_MAT != Mat
									Dbselectarea("TNF")
									Dbskip()
									Loop
								Endif

								If TNF->(FieldPos("TNF_NUMCAP")) <= 0
									Dbselectarea("TN3")
									Dbsetorder(1)
									If Dbseek(xFilial("TN3",cFilFun)+TNF->TNF_FORNEC+TNF->TNF_LOJA+TNF->TNF_CODEPI)
										cNUMCAP := TN3->TN3_NUMCAP
										If aSCAN(aNUMCAPS,{|x| x[1] == TN3->TN3_NUMCAP}) == 0 .and. !Empty(TN3->TN3_OBSAVA)
											aADD(aNUMCAPS,{TN3->TN3_NUMCAP,TN3->TN3_OBSAVA})
										Endif
									Endif
								Else
									cNUMCAP := TNF->TNF_NUMCAP
									Dbselectarea("TN3")
									Dbsetorder(3)
									If Dbseek(xFilial("TN3",cFilFun)+TNF->TNF_FORNEC+TNF->TNF_LOJA+TNF->TNF_CODEPI+TNF->TNF_NUMCAP)
										If aSCAN(aNUMCAPS,{|x| x[1] == TNF->TNF_NUMCAP}) == 0 .and. !Empty(TN3->TN3_OBSAVA)
											aADD(aNUMCAPS,{TNF->TNF_NUMCAP,TN3->TN3_OBSAVA})
										Endif
									Endif
								Endif

								If TNF->TNF_DTENTR < dInicioRis .and. TNF->TNF_DTENTR >= dDtTransf
									Dbselectarea("TRBTNF")
									Dbgotop()
									If !Dbseek(DTOS(dInicioRis)+cNUMCAP)
										RecLock("TRBTNF",.t.)
										TRBTNF->DTINI  := dInicioRis
										TRBTNF->NUMCAP := cNUMCAP
										lFirst := .f.
									Endif
								Endif

								Dbselectarea("TNF")
								Dbskip()
						    End
							Dbselectarea("TNX")
							Dbskip()
						End
					Endif
					
					//Cria historico de epi's entregues
					If !lFirst
						Dbselectarea("TRBTNF")
						Dbsetorder(1)
						Dbgotop()

						If TRBTNF->DTINI > dInicioRis+nLimite_Dias_Epi
							NGGRAVA700(cFilFun,cFichaM,cCusto,cFuncc,Mat,dInicioRis,TRBTNF->DTINI-1,Space(12),"N")
						Else
							RecLock("TRBTNF",.f.)
							TRBTNF->DTINI := dInicioRis
							Msunlock("TRBTNF")
						Endif
						
						aEPIS := {}
						Dbselectarea("TRBTNF") 
						Dbgotop()
						While !eof()
							cSvCA := TRBTNF->NUMCAP
							lFirstTRB := .t.
							dDtIniTRB := CTOD("  /  /    ")

							While !eof() .and. cSvCA == TRBTNF->NUMCAP
								If lFirstTRB
									lFirstTRB := .f.
									dDtIniTRB := TRBTNF->DTINI
								Endif
								Dbselectarea("TRBTNF")
								Dbskip()
							End

//							If eof()
							aADD(aEPIS,{dDtIniTRB,dFimRis,cSvCA})
//							Else
//								aADD(aEPIS,{dDtIniTRB,TRBTNF->DTINI-1,cSvCA})
//							Endif

						End

						For xEpis := 1 to Len(aEPIS)
							NGGRAVA700(cFilFun,cFichaM,cCusto,cFuncc,Mat,aEPIS[xEpis,1],aEPIS[xEpis,2],;
									aEPIS[xEpis,3],"S")
						Next xEpis

					Else
						NGGRAVA700(cFilFun,cFichaM,cCusto,cFuncc,Mat,dInicioRis,dFimRis,Space(12),"N")
					Endif
				Endif		

				DbSelectArea("TN0")
				DbSkip()
			EndDO
		Endif
	Next xx
Endif
Return
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �NG700TAREF� Autor �Denis Hyroshi de Souza � Data � 21/10/02 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Busca as tarefas do funcionario no periodo                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function NG700TAREF(Fil,Mat,dDTde,dDTate,cCusto,cFuncc,cFicha)
        
Local cTarefa := "*"

_Fil    := Fil
_cFicha := cFicha
_cCusto := cCusto
_cFuncc := cFuncc                           
_Mat := Mat    
_dDTinicio  := dDTde
_dDTfim := dDTate
lStart  := .f. 

// Busca os riscos que o funcinario esta exposto nessas condicoes			
Dbselectarea("TN6")
Dbsetorder(2)
Dbseek(xFilial("TN6",_Fil)+_Mat)
While !eof() .and. xFilial("TN6",_Fil) == TN6->TN6_FILIAL .and. _Mat == TN6->TN6_MAT   
	
	_dDTinicio  := dDTde
	_dDTfim := dDTate 
    If TN6->TN6_DTINIC > _dDTfim .or. (TN6->TN6_DTTERM < _dDTinicio  .and. !Empty(TN6->TN6_DTTERM))
    	Dbselectarea("TN6")
    	Dbskip()
    	Loop
    Endif	     
    
	If TN6->TN6_DTINIC >= _dDTinicio  .and. TN6->TN6_DTINIC <= _dDTfim 	
	    lStart  := .t.
		If TN6->TN6_DTTERM < _dDTfim .and. !Empty(TN6->TN6_DTTERM)
			_dDTfim := TN6->TN6_DTTERM 
		Endif  
		_dDTinicio := TN6->TN6_DTINIC 
	
	Elseif TN6->TN6_DTINIC < _dDTinicio .and. (TN6->TN6_DTTERM >= _dDTinicio  .OR. Empty(TN6->TN6_DTTERM))
		lStart  := .t.			
		If TN6->TN6_DTTERM < _dDTfim .and. !Empty(TN6->TN6_DTTERM)
			_dDTfim := TN6->TN6_DTTERM 
		Endif  		
	Endif                          
	
	cTarefa := TN6->TN6_CODTAR    
	
	If lStart  
		NG700RISCO(_Fil,_cFicha,cTarefa,_cCusto,_cFuncc,_Mat,_dDTinicio,_dDTfim,8)
	Endif
	
	Dbselectarea("TN6")
	Dbskip()
End                 
cTarefa := "*     "
NG700RISCO(_Fil,_cFicha,cTarefa,_cCusto,_cFuncc,_Mat,dDTde,dDTate,4)
Return
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �NG700EXAME� Autor �Denis Hyroshi de Souza � Data � 21/10/02 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o�Busca os exames do funcionario para imprimir no PPP         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/  
Static Function NG700EXAME()
Local lTM9_ORIG,xRi,xExa
Local lAchouTM9    := .f.
Local cMaterial    := ""
Local cResultado   := ""
Local cRefere      := ""
Local cEstavel     := ""
Local cAgravamento := ""

Dbselectarea("TM9")
lTM9_ORIG := If(FieldPos("TM9_ODORIG") > 0 .and. FieldPos("TM9_OEORIG") > 0,.t.,.f.)

For xExa := 1 to Len(aFichasUsa)
	Dbselectarea("TM5")
	Dbsetorder(1)
	Dbseek(xFilial("TM5",aFichasUsa[xExa,1])+aFichasUsa[xExa,2])
	While !eof() .and. xFilial("TM5",aFichasUsa[xExa,1]) == TM5->TM5_FILIAL .and.;
		aFichasUsa[xExa,2] == TM5->TM5_NUMFIC

		If Empty(TM5->TM5_DTRESU) .or. TM5->TM5_ORIGEX != '2'
			Dbselectarea("TM5")
			Dbskip()
			Loop
		Endif
		
		If xExa == 1 .and. TM5->TM5_NATEXA == "1" // Primeiro Periodo e Ex. Admissional
			If aFichasUsa[xExa,4] < TM5->TM5_DTRESU
				Dbselectarea("TM5")
				Dbskip()
				Loop
			Endif
		ElseIf xExa == Len(aFichasUsa) .and. TM5->TM5_NATEXA == "5" // Ultimo Periodo e Ex. Demissional
			If aFichasUsa[xExa,3] > TM5->TM5_DTRESU
				Dbselectarea("TM5")
				Dbskip()
				Loop
			Endif
		Else
		    If aFichasUsa[xExa,4] < TM5->TM5_DTRESU .or. aFichasUsa[xExa,3] > TM5->TM5_DTRESU	
				Dbselectarea("TM5")
				Dbskip()
				Loop
			Endif
		Endif

		If (Alltrim(TM5->TM5_EXAME) != "NR7" .and. Mv_par15 != 2) .or.;
			(Alltrim(TM5->TM5_EXAME) == "NR7" .and. !Empty(TM5->TM5_NUMASO)) .or.;
			(Alltrim(TM5->TM5_EXAME) == "NR7" .and. Mv_par17 == 2)

			Dbselectarea("TM5")
			Dbskip()
			Loop
		Endif

    	Dbselectarea("TRBTM5")
    	Dbsetorder(1)
    	If !Dbseek(DTOS(TM5->TM5_DTRESU)+TM5->TM5_EXAME)
	
			Dbselectarea("TM4")
			Dbsetorder(1)
			If !Dbseek(xFilial("TM4",aFichasUsa[xExa,1])+TM5->TM5_EXAME)
				Dbselectarea("TM5")
				Dbskip()
				Loop
			Endif

			lAchouTM9    := .f.
			cMaterial    := ""
			cResultado   := TM5->TM5_INDRES
			cRefere      := ""
			cEstavel     := ""
			cAgravamento := ""

			If TM4->TM4_INDRES == "4"
				Dbselectarea("TM9")
				Dbsetorder(1)
				If Dbseek(xFilial("TM9",aFichasUsa[xExa,1])+TM5->TM5_NUMFIC+DTOS(TM5->TM5_DTPROG)+TM5->TM5_EXAME)
					lAchouTM9 := .t.
					If TM9->TM9_OERESU > TM9->TM9_ODRESU
						cResultado   := IF(TM9->TM9_OERESU != "1","2","1")
						cRefere      := TM9->TM9_OEREFE
						cEstavel     := IF(TM9->TM9_OERESU $ "2/3/4","X"," ")
						cAgravamento := IF(TM9->TM9_OERESU != "5"," ",If(lTM9_ORIG,If(TM9->TM9_OEORIG=="2","N","S"),"X"))
					Else
						cResultado   := IF(TM9->TM9_ODRESU != "1","2","1")
						cRefere      := TM9->TM9_ODREFE
						cEstavel     := IF(TM9->TM9_ODRESU $ "2/3/4","X"," ")
						cAgravamento := IF(TM9->TM9_ODRESU != "5"," ",If(lTM9_ORIG,If(TM9->TM9_ODORIG=="2","N","S"),"X"))
					Endif
				Endif					
			Endif

			TRBTM5->(DBAPPEND())
			TRBTM5->EXAME  := TM5->TM5_EXAME
			TRBTM5->NOMEXA := TM4->TM4_NOMEXA
			TRBTM5->DTPRO  := TM5->TM5_DTPROG
			TRBTM5->DTRES  := TM5->TM5_DTRESU
			TRBTM5->NATEXA := TM5->TM5_NATEXA
			If Mv_par16 != 2
				TRBTM5->RESULT := cResultado
			Endif
			If TM4->TM4_INDRES == "4"
				TRBTM5->AUDIO  := If(lAchouTM9,"S"," ")
				TRBTM5->REFERE := cRefere
				If cResultado == "2"
					TRBTM5->ESTAVE := cEstavel
					TRBTM5->AGRAVA := cAgravamento
				Endif
			ElseIf TM5->(FieldPos("TM5_EXAREF")) > 0
				TRBTM5->REFERE := If(TM5->TM5_EXAREF!="1","2","1")
			Endif
	    Endif
	    Dbselectarea("TM5")
		Dbskip()
	End
	Dbselectarea("TMY")
	Dbsetorder(3)
	Dbseek(xFilial("TMY",aFichasUsa[xExa,1])+aFichasUsa[xExa,2])
	While !eof() .and. xFilial("TMY",aFichasUsa[xExa,1]) == TMY->TMY_FILIAL .and.;
		aFichasUsa[xExa,2] == TMY->TMY_NUMFIC .and. Mv_par17 == 1

		If xExa == 1 .and. TMY->TMY_NATEXA == "1" // Primeiro Periodo e Aso Admissional
			If aFichasUsa[xExa,4] < TMY->TMY_DTPROG
				Dbselectarea("TMY")
				Dbskip()
				Loop
			Endif
		ElseIf xExa == Len(aFichasUsa) .and. TMY->TMY_NATEXA == "5" // Ultimo Periodo e Aso Demissional
			If aFichasUsa[xExa,3] > TMY->TMY_DTPROG
				Dbselectarea("TMY")
				Dbskip()
				Loop
			Endif
		Else
		    If aFichasUsa[xExa,4] < TMY->TMY_DTPROG .or. aFichasUsa[xExa,3] > TMY->TMY_DTPROG
				Dbselectarea("TMY")
				Dbskip()
				Loop
			Endif
		Endif

    	Dbselectarea("TRBTM5")
    	Dbsetorder(1)
    	If !Dbseek(DTOS(TMY->TMY_DTPROG)+"NR7") .and. !Empty(TMY->TMY_DTPROG)
	
			Dbselectarea("TM4")
			Dbsetorder(1)
			If !Dbseek(xFilial("TM4",aFichasUsa[xExa,1])+"NR7")
				Dbselectarea("TMY")
				Dbskip()
				Loop
			Endif
			
			TRBTM5->(DBAPPEND())
			TRBTM5->EXAME  := TM4->TM4_EXAME
			TRBTM5->NOMEXA := TM4->TM4_NOMEXA
			TRBTM5->DTPRO  := TMY->TMY_DTPROG
			TRBTM5->DTRES  := TMY->TMY_DTPROG
			TRBTM5->NATEXA := TMY->TMY_NATEXA
			If Mv_par16 != 2
				TRBTM5->RESULT := If(TMY->TMY_INDPAR=='2','2','1')
			Endif
	    Endif
	    Dbselectarea("TMY")
		Dbskip()
	End
Next xExa

If Mv_par15 == 3 
	Return
Endif

For xRi := 1 to Len(aRiscos)
	Dbselectarea("TN2")
	Dbsetorder(1)
	Dbseek(xFilial("TN2",aRiscos[xRi,1])+aRiscos[xRi,2])
    While !eof() .and. xFilial("TN2",aRiscos[xRi,1]) == TN2->TN2_FILIAL .and. ;
        TN2->TN2_NUMRIS == aRiscos[xRi,2]
        
		Dbselectarea("TM5")
		Dbsetorder(6)
		Dbseek(xFilial("TM5",aRiscos[xRi,1])+aRiscos[xRi,5]+TN2->TN2_EXAME)
		While !eof() .and. xFilial("TM5",aRiscos[xRi,1]) == TM5->TM5_FILIAL .and. ;
			aRiscos[xRi,5] == TM5->TM5_NUMFIC .AND. TN2->TN2_EXAME == TM5->TM5_EXAME 		
			
		    If !Empty(TM5->TM5_DTRESU) .and. TM5->TM5_ORIGEX == '2' .and. Alltrim(TM5->TM5_EXAME) != "NR7"

			    If  (dDataBase < TM5->TM5_DTRESU .and. TM5->TM5_NATEXA != "5") .or. ;
			    	(SRA->RA_ADMISSA > TM5->TM5_DTRESU	.and. TM5->TM5_NATEXA != "1")

					Dbselectarea("TM5")
					Dbskip()
					Loop
				Endif

		    	Dbselectarea("TRBTM5")
		    	Dbsetorder(1)
		    	If !Dbseek(DTOS(TM5->TM5_DTRESU)+TM5->TM5_EXAME)

					Dbselectarea("TM4")
					Dbsetorder(1)
					If !Dbseek(xFilial("TM4",aRiscos[xRi,1])+TM5->TM5_EXAME)
						Dbselectarea("TM5")
						Dbskip()
						Loop
					Endif

					lAchouTM9    := .f.
					cMaterial    := ""
					cResultado   := TM5->TM5_INDRES
					cRefere      := ""
					cEstavel     := ""
					cAgravamento := ""

					If TM4->TM4_INDRES == "2"
						Dbselectarea("TMB")
						Dbsetorder(1)
						If Dbseek(xFilial("TMB",aRiscos[xRi,1])+aRiscos[xRi,6]+TM5->TM5_EXAME)					
							If TMB->(FieldPos("TMB_MATBIO")) > 0
								If (nIND := aScan(aTMBcombo,{|x| Upper(Substr(x,1,1)) == Substr(TMB->TMB_MATBIO,1,1)})) > 0
									cMaterial := Alltrim(Substr(aTMBcombo[nIND],3,15))
								Endif
							Endif
						Endif
					Elseif TM4->TM4_INDRES == "4"
						Dbselectarea("TM9")
						Dbsetorder(1)
						If Dbseek(xFilial("TM9",aRiscos[xRi,1])+aRiscos[xRi,5]+DTOS(TM5->TM5_DTPROG)+TM5->TM5_EXAME)
							lAchouTM9 := .t.
							If TM9->TM9_OERESU > TM9->TM9_ODRESU
								cResultado   := IF(TM9->TM9_OERESU != "1","2","1")
								cRefere      := TM9->TM9_OEREFE
								cEstavel     := IF(TM9->TM9_OERESU $ "2/3/4","X"," ")
								cAgravamento := IF(TM9->TM9_OERESU != "5"," ",If(lTM9_ORIG,If(TM9->TM9_OEORIG=="2","N","S"),"X"))
							Else
								cResultado   := IF(TM9->TM9_ODRESU != "1","2","1")
								cRefere      := TM9->TM9_ODREFE
								cEstavel     := IF(TM9->TM9_ODRESU $ "2/3/4","X"," ")
								cAgravamento := IF(TM9->TM9_ODRESU != "5"," ",If(lTM9_ORIG,If(TM9->TM9_ODORIG=="2","N","S"),"X"))
							Endif
						Endif					
					Endif
					
					cExame := Substr(Alltrim(TM4->TM4_NOMEXA),1,If(len(cMaterial)==0,50,47)-len(cMaterial))
					cExame += If(len(cMaterial) > 0," - ","")+Upper(cMaterial) 

					TRBTM5->(DBAPPEND())
					TRBTM5->EXAME  := TM5->TM5_EXAME
					TRBTM5->NOMEXA := cExame
					TRBTM5->DTPRO  := TM5->TM5_DTPROG
					TRBTM5->DTRES  := TM5->TM5_DTRESU
					TRBTM5->NATEXA := TM5->TM5_NATEXA
					If Mv_par16 != 2
						TRBTM5->RESULT := cResultado
					Endif
					If TM4->TM4_INDRES == "4"
						TRBTM5->AUDIO  := If(lAchouTM9,"S"," ")
						TRBTM5->REFERE := cRefere
						If cResultado == "2"
							TRBTM5->ESTAVE := cEstavel
							TRBTM5->AGRAVA := cAgravamento
						Endif
					ElseIf TM5->(FieldPos("TM5_EXAREF")) > 0
						TRBTM5->REFERE := If(TM5->TM5_EXAREF!="1","2","1")
					Endif
				Endif	
		    Endif 	
		    Dbselectarea("TM5")
			Dbskip()
		End                
		Dbselectarea("TN2")
		Dbskip()		
	End
Next xRi
Return
 /*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �NGGRAVA700� Autor �Denis Hyroshi de Souza � Data � 21/10/02 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Grava arquivo de trabalho contendo os riscos do funcionario���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/  
Static Function NGGRAVA700(cFilFun,cFichaM,cCusto,cFuncc,Mat,dInicioRis,dFimRis,cNUMCAP,cEpiFunc)

Local lSave  := .f.
Local lAchouRisco := .f.
Local cEXPOSICAO := " "
Private lEpiFunc := IF(cEpiFunc=="S",.t.,.f.)
Private lEpcFunc := IF(TN0->(FieldPos("TN0_EPC")) > 0,If(TN0->TN0_EPC=="1",.t.,.f.),.f.)
Private _cNUMCAP := cNUMCAP
Private cTECNICA := Space(40)
If mv_par07 == 2 .and. TN0->TN0_LISASO $ "12"
	Return .t.
Endif    

cCondRis := cFilFun+TN0->TN0_NUMRIS+DTOS(dInicioRis)+DTOS(dFimRis)+cFichaM
If aSCAN(aRiscos,{|x| x[1]+x[2]+DTOS(x[3])+DTOS(x[4])+x[5] == cCondRis}) <= 0
	aAdd(aRiscos,{cFilFun,TN0->TN0_NUMRIS,dInicioRis,dFimRis,cFichaM,TN0->TN0_AGENTE}) // Adiciona o numero do risco na array aRISCOS
Endif

If TN0->(FieldPos('TN0_INDEXP')) > 0 
	cEXPOSICAO := TN0->TN0_INDEXP
Endif         
If TN0->(FieldPos('TN0_TECUTI')) > 0 
	cTECNICA := TN0->TN0_TECUTI+Space(40-Len(TN0->TN0_TECUTI))
Endif

cEpiant := " "

Dbselectarea("TMA")
Dbsetorder(1)
If !Dbseek(xFilial("TMA",cFilFun)+TN0->TN0_AGENTE)
	Return .t.
Endif

cNOME_AGENTE := 'TMA->TMA_NOMAGE'
If TMA->(FieldPos("TMA_SUBATI")) > 0
	If TMA->TMA_GRISCO == "2" .and. !Empty(TMA->TMA_SUBATI)// se for agente quimico, pegar a substancia ativa como descricao.
		cNOME_AGENTE := 'Substr(TMA->TMA_SUBATI,1,40)'
	Endif
Endif
cKeyRisco := 'TMA->TMA_GRISCO+'+cNOME_AGENTE+'+Str(TN0->TN0_QTAGEN,9,3)+'
cKeyRisco += 'cTECNICA+IF(lEpcFunc,"S","N")+IF(lEpiFunc,"S","N")+_cNUMCAP'

Dbselectarea("TRBTN0")
Dbsetorder(2)
If !Dbseek(&cKeyRisco)
	lSave  := .t.
Else      
	dtstart := dInicioRis
	dtstop  := dFimRis   
	nRecOld := nil
	Dbselectarea("TRBTN0")
	Dbsetorder(2)	
	Dbseek(&cKeyRisco)
	While !eof() .and. &cKeyRisco == TRBTN0->(GRISCO+AGENTE+Str(INTENS,9,3)+TECNIC+EPC+PROTEC+NUMCAP)
	
		If TRBTN0->DT_DE <= dtstart .and. TRBTN0->DT_ATE >= dtstart-1
			If dtstop > TRBTN0->DT_ATE   
				RecLock("TRBTN0",.F.)
				TRBTN0->DT_ATE := dtstop 
				dtstart := TRBTN0->DT_DE 
				Msunlock("TRBTN0")     
				aAreaTRB := TRBTN0->(GetArea())
				If nRecOld != nil				
					Dbselectarea("TRBTN0")
					Dbgoto(nRecOld)
					TRBTN0->(Dbdelete())           
				Endif
				RestArea(aAreaTRB)
			Endif    
			lAchouRisco := .t.
			nRecOld := recno()			 
			
		Elseif TRBTN0->DT_DE <= dtstop+1 .and. TRBTN0->DT_ATE >= dtstop
			If dtstart < TRBTN0->DT_DE     
				RecLock("TRBTN0",.F.)
				TRBTN0->DT_DE := dtstart   
				dtstop := TRBTN0->DT_ATE 
				Msunlock("TRBTN0")    
				aAreaTRB := TRBTN0->(GetArea())
				If nRecOld != nil				
					Dbselectarea("TRBTN0")
					Dbgoto(nRecOld)
					TRBTN0->(Dbdelete())           
				Endif				
				RestArea(aAreaTRB)
			Endif    
			lAchouRisco := .t.
			nRecOld := recno()
							
		Elseif TRBTN0->DT_DE > dtstart .and. TRBTN0->DT_ATE < dtstop   
			RecLock("TRBTN0",.F.)
			TRBTN0->DT_DE := dtstart  
			TRBTN0->DT_ATE := dtstop  
			Msunlock("TRBTN0")    
			aAreaTRB := TRBTN0->(GetArea())
			If nRecOld != nil				
				Dbselectarea("TRBTN0")
				Dbgoto(nRecOld)
				TRBTN0->(Dbdelete())           
			Endif	
			RestArea(aAreaTRB)
			lAchouRisco := .t.		
			nRecOld := recno()
		Endif                           
		Dbskip()
		
	End
	If !lAchouRisco
		lSave := .t.
	Endif
Endif

If lSave 
	Dbselectarea("TRBTN0")
	TRBTN0->(DBAPPEND())
	TRBTN0->NUMRIS := TN0->TN0_NUMRIS
	TRBTN0->CODAGE := TN0->TN0_AGENTE
	If TMA->(FieldPos("TMA_SUBATI")) > 0
		If !Empty(TMA->TMA_SUBATI) .and. TMA->TMA_GRISCO == "2"
			TRBTN0->AGENTE := Substr(TMA->TMA_SUBATI,1,40)
		Else
			TRBTN0->AGENTE := TMA->TMA_NOMAGE
		Endif
	Else
		TRBTN0->AGENTE := TMA->TMA_NOMAGE	
	Endif
	TRBTN0->GRISCO := TMA->TMA_GRISCO
	TRBTN0->NUMCAP := _cNUMCAP
	TRBTN0->MAT    := cMatric
	TRBTN0->DT_DE  := dInicioRis 
	TRBTN0->DT_ATE := dFimRis
	TRBTN0->SETOR  := _centrCusto
	TRBTN0->FUNCAO := _cFuncc
	TRBTN0->TAREFA := _cTarefa
	TRBTN0->INTENS := TN0->TN0_QTAGEN
	TRBTN0->UNIDAD := TN0->TN0_UNIMED
	TRBTN0->TECNIC := Substr(cTECNICA,1,40)
	TRBTN0->PROTEC := If(lEpiFunc,"S","N")
	TRBTN0->EPC    := If(lEpcFunc,"S","N")
	TRBTN0->INDEXP := cEXPOSICAO
	TRBTN0->ATIVO  := "S"
	If TN0->(FieldPos("TN0_OBSINT")) > 0
		TRBTN0->OBSINT := TN0->TN0_OBSINT
	Endif
Endif
Return 
/*/
����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � SomaLinha� Autor �Denis Hyroshi de Souza � Data � 21/10/02 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Incrementa Linha inicial                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function Somalinha(_li,_pula,_linha)

If _li != nil
	lin += _li
Else         
	lin += 60
Endif

If lin > 3000 .or. _linha
	If _pula
		oPrintPPP:Line(lin,50,lin,2350)
	Endif
	oPrintPPP:Say(3100,1170,Str(nPaginaPPP,3),oFont09n)
	oPrintPPP:EndPage()
	nPaginaPPP++
	oPrintPPP:StartPage()
	lin := 380
	oPrintPPP:Say(280,600,"PERFIL PROFISSIOGR�FICO PREVIDENCI�RIO - PPP",oFont13)
	oPrintPPP:Line(lin,50,lin,2350)
Endif
Return     
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �ATIV700R  � Autor �Denis Hyroshi de Souza � Data � 04/04/03 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/                                  
Static Function ATIV700R()
If IMPFUN700()
	Return .t.
Endif
If Mv_par08 == 1
	If !IMPTAR700()
		If IMPCGO700()
			Return .t.
		Endif
	Else
		Return .t.
	Endif
ElseIf Mv_par08 == 2	 
	If !IMPCGO700()
		If IMPTAR700()
			Return .t.
		Endif
	Else
		Return .t.
	Endif
Else
	IMPTAR700()
	IMPCGO700()
Endif    
Return .f.
//***********************************************/
//***********************************************/
Static Function IMPTAR700()    
Local aTarFunc := {}
Local nTar,nTary,nTarx,LinhaCorrente
Local lRetorno := .f.
nLinTar := 3

For nTar := 1 to Len(aMatriculas)
	Dbselectarea("TN6")
	Dbsetorder(2)
	Dbseek(xFilial("TN6",aMatriculas[nTar,1])+aMatriculas[nTar,2])
	While !eof() .and. xFilial("TN6",aMatriculas[nTar,1]) == TN6->TN6_FILIAL .and. ;
										aMatriculas[nTar,2] == TN6->TN6_MAT   	
		Dbselectarea("TN5")
		Dbsetorder(1)
		If Dbseek(xFilial("TN5",aMatriculas[nTar,1])+TN6->TN6_CODTAR)
			If !Empty(TN5->TN5_DESTAR)
				If aSCAN(aTarFunc,{|x| X[1] == TN5->TN5_NOMTAR}) < 1
					AADD(aTarFunc,{TN5->TN5_NOMTAR,TN6->TN6_CODTAR,aMatriculas[nTar,1],TN6->TN6_DTINIC,TN6->TN6_DTTERM})	
				Endif
			Endif
		Endif	
		Dbselectarea("TN6")
		Dbskip()	                                		
	End    
Next nTar

//Ordenando tarefas por ordem cronologica
For nTarx := 1 to Len(aTarFunc)-1
	For nTary := nTarx+1 to Len(aTarFunc)
		If aTarFunc[nTarx,4] > aTarFunc[nTary,4]
		     aTemp           := aClone(aTarFunc[nTarx])
		     aTarFunc[nTarx] := aClone(aTarFunc[nTary])
		     aTarFunc[nTary] := aClone(aTemp)
		Endif
	Next nTary
Next nTarx

For nTar := 1 to Len(aTarFunc)
	Dbselectarea("TN5")
	Dbsetorder(1)
	If !Dbseek(xFilial("TN5",aTarFunc[nTar,3])+aTarFunc[nTar,2])
		Loop
	Endif
	lTemDesc := .f.
	nLinhasMemo := MLCOUNT(TN5->TN5_DESTAR,100)
	For LinhaCorrente := 1 To nLinhasMemo
		  lRetorno := .t.
		  If LinhaCorrente == 1
			    lTemDesc := .t.
				oPrintPPP:Line(lin,50,lin+50,50)
				cDtPPP := NGPPPDATE(aTarFunc[nTar,4])+" a "
				cDtPPP += NGPPPDATE(aTarFunc[nTar,5])
				oPrintPPP:Say(lin+5,60,cDtPPP,oFont09)
				oPrintPPP:Line(lin,550,lin+50,550)
				oPrintPPP:Say(lin+5,560,TN5->TN5_NOMTAR,oFont09)
				oPrintPPP:Line(lin,2350,lin+50,2350)
				SomaLinha(50)
		  Endif
		  oPrintPPP:Line(lin,50,lin+40,50)
		  oPrintPPP:Line(lin,550,lin+40,550)
		  oPrintPPP:Line(lin,2350,lin+40,2350)
		  oPrintPPP:Say(lin+5,560,Transform(MemoLine(TN5->TN5_DESTAR,100,LinhaCorrente),"@!"),oFont08)
		  If LinhaCorrente == nLinhasMemo
				oPrintPPP:Line(lin+40,50,lin+40,2350)
		  Endif
		  Somalinha(40,LinhaCorrente != nLinhasMemo)
	Next
	Dbselectarea("TN5")
	If FieldPos("TN5_DESCR1") > 0 .and. lTemDesc
		nLinhasMemo := MLCOUNT(TN5->TN5_DESCR1,100)
		For LinhaCorrente := 1 To nLinhasMemo
			  oPrintPPP:Line(lin,50,lin+40,50)
			  oPrintPPP:Line(lin,550,lin+40,550)
			  oPrintPPP:Line(lin,2350,lin+40,2350)
			  oPrintPPP:Say(lin+5,560,Transform(MemoLine(TN5->TN5_DESCR1,100,LinhaCorrente),"@!"),oFont08)
			  If LinhaCorrente == nLinhasMemo
					oPrintPPP:Line(lin+40,50,lin+40,2350)
			  Endif
			  Somalinha(40,LinhaCorrente != nLinhasMemo)
		Next
	Endif
	If FieldPos("TN5_DESCR2") > 0 .and. lTemDesc
		nLinhasMemo := MLCOUNT(TN5->TN5_DESCR2,100)
		For LinhaCorrente := 1 To nLinhasMemo
			  oPrintPPP:Line(lin,50,lin+40,50)
			  oPrintPPP:Line(lin,550,lin+40,550)
			  oPrintPPP:Line(lin,2350,lin+40,2350)
			  oPrintPPP:Say(lin+5,560,Transform(MemoLine(TN5->TN5_DESCR2,100,LinhaCorrente),"@!"),oFont08)
			  If LinhaCorrente == nLinhasMemo
					oPrintPPP:Line(lin+40,50,lin+40,2350)
			  Endif
			  Somalinha(40,LinhaCorrente != nLinhasMemo)
		Next
	Endif
	If FieldPos("TN5_DESCR3") > 0 .and. lTemDesc
		nLinhasMemo := MLCOUNT(TN5->TN5_DESCR3,100)
		For LinhaCorrente := 1 To nLinhasMemo
			  oPrintPPP:Line(lin,50,lin+40,50)
			  oPrintPPP:Line(lin,550,lin+40,550)
			  oPrintPPP:Line(lin,2350,lin+40,2350)
			  oPrintPPP:Say(lin+5,560,Transform(MemoLine(TN5->TN5_DESCR3,100,LinhaCorrente),"@!"),oFont08)
			  If LinhaCorrente == nLinhasMemo
					oPrintPPP:Line(lin+40,50,lin+40,2350)
			  Endif
			  Somalinha(40,LinhaCorrente != nLinhasMemo)
		Next
	Endif
	If FieldPos("TN5_DESCR4") > 0 .and. lTemDesc
		nLinhasMemo := MLCOUNT(TN5->TN5_DESCR4,100)
		For LinhaCorrente := 1 To nLinhasMemo
			  oPrintPPP:Line(lin,50,lin+40,50)
			  oPrintPPP:Line(lin,550,lin+40,550)
			  oPrintPPP:Line(lin,2350,lin+40,2350)
			  oPrintPPP:Say(lin+5,560,Transform(MemoLine(TN5->TN5_DESCR4,100,LinhaCorrente),"@!"),oFont08)
			  If LinhaCorrente == nLinhasMemo
					oPrintPPP:Line(lin+40,50,lin+40,2350)
			  Endif
			  Somalinha(40,LinhaCorrente != nLinhasMemo)
		Next
	Endif
Next nTar
Return lRetorno
//***********************************************/
//***********************************************/
Static Function IMPCGO700()
local LinhaCorrente,nFx
Local lRetorno := .f.
Local lFirst := .t.
Local dIniCar, dFimCar

	Dbselectarea("TRBPPP")
	Dbgotop()
	While !eof()
		Store CtoD("  /  /    ") to dIniCar,dFimCar
		cCodCargo := TRBPPP->CARGO
		cFilCargo := xFilial("SQ3",TRBPPP->FILIAL)
		cCusCargo := CARGOCC700(TRBPPP->FILIAL,TRBPPP->CARGO,TRBPPP->CUSTO)
		lFirst := .t.
		While !eof() .and. cCodCargo == TRBPPP->CARGO .and. cFilCargo == xFilial("SQ3",TRBPPP->FILIAL) .and.;
							cCusCargo == CARGOCC700(TRBPPP->FILIAL,TRBPPP->CARGO,TRBPPP->CUSTO)
			If lFirst
				dIniCar := TRBPPP->DTDE
				dFimCar := TRBPPP->DTATE
				lFirst  := .f.
			Else
				If dFimCar < TRBPPP->DTATE			
					dFimCar := TRBPPP->DTATE
				Endif
			Endif
			
			Dbselectarea("TRBPPP")
			Dbskip()
		End
		aADD(aCargo,{dIniCar,dFimCar,cFilCargo,cCodCargo,cCusCargo})
	End
	
	For nFx := 1 to Len(aCargo)
		Dbselectarea("SQ3")
		Dbsetorder(1)
		If Dbseek(xFilial("SQ3",aCargo[nFx][3])+aCargo[nFx][4]+aCargo[nFx][5])
			cMemo := MSMM(SQ3->Q3_DESCDET)    
			nLinhasMemo := MLCOUNT(cMemo,100)
			If !lNG2M400
				nLinhasMemo := If(nLinhasMemo > 5,5,nLinhasMemo)
			Endif
			For LinhaCorrente := 1 To nLinhasMemo
				lRetorno := .t.
				If LinhaCorrente == 1
					oPrintPPP:Line(lin,50,lin+50,50)
					cDtPPP := NGPPPDATE(aCargo[nFx][1])+" a "
					cDtPPP += If(nFx == Len(aCargo),If(Empty(SRA->RA_DEMISSA),"__/__/____",NGPPPDATE(aCargo[nFx][2])),NGPPPDATE(aCargo[nFx][2]-1))
					oPrintPPP:Say(lin+5,60,cDtPPP,oFont09)
					oPrintPPP:Line(lin,550,lin+50,550)
					oPrintPPP:Say(lin+5,560,Transform(SQ3->Q3_DESCSUM,"@!"),oFont09)
					oPrintPPP:Line(lin,2350,lin+50,2350)
					SomaLinha(50)
				Endif
				oPrintPPP:Line(lin,50,lin+40,50)
				oPrintPPP:Line(lin,550,lin+40,550)
				oPrintPPP:Line(lin,2350,lin+40,2350)
				oPrintPPP:Say(lin+5,560,Transform(MemoLine(cMemo,100,LinhaCorrente),"@!"),oFont08)
				If LinhaCorrente == nLinhasMemo
					oPrintPPP:Line(lin+40,50,lin+40,2350)
				Endif
				Somalinha(40,LinhaCorrente != nLinhasMemo)
			Next LinhaCorrente   
		Endif	
	Next nFx
Return lRetorno
//***********************************************/
//***********************************************/
Static Function CARGOCC700(cFILIAL,cCARGO,cCUSTO)
Local cRet := Space(nSizeSI3)
Local aAreaTRBE := TRBPPP->(GetArea())
Local aAreaSIX  := SIX->(GetArea())
Local aArea     := GetArea()

DBSELECTAREA("SIX")
DBSETORDER(1)
IF DBSEEK("SQ31")
	If "Q3_CARGO" $ SIX->CHAVE .and. "Q3_CC" $ SIX->CHAVE
		Dbselectarea("SQ3")
		Dbsetorder(1)
		If Dbseek(xFilial("SQ3",cFILIAL)+cCARGO+cCUSTO)
			cRet := cCUSTO
		Endif
	Endif
Endif

RestArea(aAreaTRBE)
RestArea(aAreaSIX)
RestArea(aArea)
Return cRet
//***********************************************/
//***********************************************/
Static Function IMPFUN700()
Local lRetorno := .f.
Local lFirst := .t.
Local dIniFun, dFimFun,LinhaCorrente,nFx

Dbselectarea("SRJ")
If FieldPos("RJ_MEMOATI") > 0
	Dbselectarea("TRBPPP")
	Dbgotop()
	While !eof()
		Store CtoD("  /  /    ") to dIniFun,dFimFun
		cCodFuncao := TRBPPP->CODFUN
		cFilFuncao := xFilial("SRJ",TRBPPP->FILIAL)
		lFirst := .t.
		While !eof() .and. cCodFuncao == TRBPPP->CODFUN .and. cFilFuncao == xFilial("SRJ",TRBPPP->FILIAL)
			If lFirst
				dIniFun := TRBPPP->DTDE
				dFimFun := TRBPPP->DTATE
				lFirst  := .f.
			Else
				If dFimFun < TRBPPP->DTATE			
					dFimFun := TRBPPP->DTATE
				Endif
			Endif
			
			Dbselectarea("TRBPPP")
			Dbskip()
		End
		aADD(aFuncao,{dIniFun,dFimFun,cFilFuncao,cCodFuncao})
	End
	
	For nFx := 1 to Len(aFuncao)
		Dbselectarea("SRJ")
		Dbsetorder(1)
		If Dbseek(xFilial("SRJ",aFuncao[nFx][3])+aFuncao[nFx][4])
			cMemo := SRJ->RJ_MEMOATI
			nLinhasMemo := MLCOUNT(cMemo,100)
			If !lNG2M400
				nLinhasMemo := If(nLinhasMemo > 5,5,nLinhasMemo)
			Endif
			For LinhaCorrente := 1 To nLinhasMemo
				lRetorno := .t.
				If LinhaCorrente == 1
					oPrintPPP:Line(lin,50,lin+50,50)
					cDtPPP := NGPPPDATE(aFuncao[nFx][1])+" a "
					cDtPPP += If(nFx == Len(aFuncao),If(Empty(SRA->RA_DEMISSA),"__/__/____",NGPPPDATE(aFuncao[nFx][2])),NGPPPDATE(aFuncao[nFx][2]-1))
					oPrintPPP:Say(lin+5,60,cDtPPP,oFont09)
					oPrintPPP:Line(lin,550,lin+50,550)
					oPrintPPP:Say(lin+5,560,Transform(SRJ->RJ_DESC,"@!"),oFont09)
					oPrintPPP:Line(lin,2350,lin+50,2350)
					SomaLinha(50)
				Endif
				oPrintPPP:Line(lin,50,lin+40,50)
				oPrintPPP:Line(lin,550,lin+40,550)
				oPrintPPP:Line(lin,2350,lin+40,2350)
				oPrintPPP:Say(lin+5,560,Transform(MemoLine(cMemo,100,LinhaCorrente),"@!"),oFont08)
				If LinhaCorrente == nLinhasMemo
					oPrintPPP:Line(lin+40,50,lin+40,2350)
				Endif
				Somalinha(40,LinhaCorrente != nLinhasMemo)
			Next LinhaCorrente   
		Endif	
	Next nFx		
Endif
Return lRetorno	
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �MDTERMO700  Autor �Denis Hyroshi de Souza � Data � 04/04/03 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
                                  
Static Function MDTERMO700()   
Local LinhaCorrente

Dbselectarea("TM0")
Dbsetorder(3)
Dbseek(xFilial("TM0")+SRA->RA_MAT)
Dbselectarea(cAlias)
Dbsetorder(1)
Dbseek(xFilial(cAlias)+SRA->RA_CC) 
Dbselectarea("SRJ")
Dbsetorder(1)
Dbseek(xFilial("SRJ")+SRA->RA_CODFUNC)
Dbselectarea("SR6")
Dbsetorder(1)
Dbseek(xFilial("SR6")+SRA->RA_TNOTRAB)

oPrintPPP:StartPage()
lin := 180
oPrintPPP:Say(lin+100,220,"COMPROVANTE DE ENTREGA DO PERFIL PROFISSIOGR�FICO PREVIDENCI�RIO (PPP)",oFont13)
oPrintPPP:Box(lin+200,50,lin+580,2350)
oPrintPPP:Say(lin+220,60,"DADOS ADMINISTRATIVOS",oFont13)
oPrintPPP:Line(lin+280,50,lin+280,2350)
oPrintPPP:Line(lin+280,800,lin+380,800)
oPrintPPP:Line(lin+280,2000,lin+380,2000)
oPrintPPP:Say(lin+285,60,"CNPJ do Domic�lio Tribut�rio/CEI",oFont09)
If lNGMDTPS
	If !Empty(SA1->A1_CGC)
		oPrintPPP:Say(lin+330,60,Transform(SA1->A1_CGC,"@R 99999999/9999-99"),oFont10)
	Endif
Else
	If !Empty(SM0->M0_CGC)
		If SM0->M0_TPINSC == 2 
			oPrintPPP:Say(lin+330,60,Transform(SM0->M0_CGC,"@R 99999999/9999-99"),oFont10)
		Else
			oPrintPPP:Say(lin+330,60,Transform(SM0->M0_CGC,"@R 99.999.99999/99"),oFont10)
		Endif
	Endif
Endif
oPrintPPP:Say(lin+285,810,"Nome Empresarial",oFont09)
If lNGMDTPS
	oPrintPPP:Say(lin+330,810,Substr(SA1->A1_NOME,1,40),oFont10)
Else
	oPrintPPP:Say(lin+330,810,Substr(SM0->M0_NOMECOM,1,40),oFont10)
Endif
oPrintPPP:Say(lin+285,2010,"CNAE",oFont09)
If lNGMDTPS
	oPrintPPP:Say(lin+330,2010,Transform(SA1->A1_ATIVIDA,"@R 999999-9"),oFont10)
Else
	oPrintPPP:Say(lin+330,2010,Transform(SM0->M0_CNAE,"@R 999999-9"),oFont10)
Endif
oPrintPPP:Line(lin+380,50,lin+380,2350)
oPrintPPP:Line(lin+380,1600,lin+480,1600)
oPrintPPP:Line(lin+380,2000,lin+480,2000)
oPrintPPP:Say(lin+385,60,"Nome do Trabalhador",oFont09)
oPrintPPP:Say(lin+430,60,SRA->RA_NOME,oFont10)
oPrintPPP:Say(lin+385,1610,"BR/PDH",oFont09)
If SRA->(FieldPos("RA_BRPDH")) > 0
	cBRPDH := "NA"
	If SRA->RA_BRPDH == "1"
		cBRPDH := "BR"
	Elseif SRA->RA_BRPDH == "2"
		cBRPDH := "PDH"
	Endif
	oPrintPPP:Say(lin+430,1610,cBRPDH,oFont10)
Endif
oPrintPPP:Say(lin+385,2010,"NIT",oFont09)
If !Empty(SRA->RA_PIS)
	oPrintPPP:Say(lin+430,2010,Transform(SRA->RA_PIS,"@R 999.99999.99-9"),oFont10)
Endif
oPrintPPP:Line(lin+480,50,lin+480,2350)
oPrintPPP:Line(lin+480,500,lin+580,500)
oPrintPPP:Line(lin+480,800,lin+580,800)
oPrintPPP:Line(lin+480,1400,lin+580,1400)
oPrintPPP:Line(lin+480,1800,lin+580,1800)
oPrintPPP:Say(lin+485,60,"Data do Nascimento",oFont09)
oPrintPPP:Say(lin+530,60,NGPPPDATE(SRA->RA_NASC),oFont10)
oPrintPPP:Say(lin+485,510,"Sexo(F/M)",oFont09)
oPrintPPP:Say(lin+530,520,Upper(SRA->RA_SEXO),oFont10)
oPrintPPP:Say(lin+485,810,"CTPS(N�, S�rie e UF)",oFont09)
oPrintPPP:Say(lin+530,810,SRA->RA_NUMCP+"/"+SRA->RA_SERCP+" - "+SRA->RA_UFCP,oFont10)
oPrintPPP:Say(lin+485,1410,"Data de Admiss�o",oFont09)
oPrintPPP:Say(lin+530,1410,NGPPPDATE(SRA->RA_ADMISSA),oFont10)
oPrintPPP:Say(lin+485,1810,"Regime Revezamento",oFont09)
If SR6->(FieldPos("R6_REVEZAM")) > 0
	If !EMPTY(Substr(SR6->R6_REVEZAM,1,20))
		oPrintPPP:Say(lin+530,1810,Substr(SR6->R6_REVEZAM,1,20),oFont09)
	Else
		oPrintPPP:Say(lin+530,1810,"NA",oFont10)
	ENdif
Else
	oPrintPPP:Say(lin+530,1810,"NA",oFont10)
Endif
Somalinha(580)
oPrintPPP:Line(lin,50,lin+100,50)
oPrintPPP:Say(lin+5,60,"Matr�cula",oFont09)
oPrintPPP:Say(lin+50,60,SRA->RA_MAT,oFont10)
oPrintPPP:Line(lin,500,lin+100,500)
oPrintPPP:Say(lin+5,510,"Centro de Custo",oFont09)
oPrintPPP:Say(lin+50,510,&cDescr,oFont10)
oPrintPPP:Line(lin,1400,lin+100,1400)
oPrintPPP:Say(lin+5,1410,"Fun��o",oFont09)
oPrintPPP:Say(lin+50,1410,SRJ->RJ_DESC,oFont10)
oPrintPPP:Line(lin,2350,lin+100,2350)
oPrintPPP:Line(lin+100,50,lin+100,2350)
Somalinha(100)
oPrintPPP:Line(lin,50,lin+80,50)
oPrintPPP:Say(lin+20,60,"TERMO DE RESPONSABILIDADE",oFont13)
oPrintPPP:Line(lin,2350,lin+80,2350)
oPrintPPP:Line(lin+80,50,lin+80,2350)
Somalinha(80)
Dbselectarea("TMZ")
Dbsetorder(1)
Dbseek(xFilial("TMZ")+Mv_par11)
nLinhasMemo := MLCOUNT(TMZ->TMZ_DESCRI,130)
For LinhaCorrente := 1 To nLinhasMemo
	If LinhaCorrente == 1
		oPrintPPP:Line(lin,50,lin+55,50)
		oPrintPPP:Say(lin+15,60,MemoLine(TMZ->TMZ_DESCRI,130,LinhaCorrente),oFont08)
		oPrintPPP:Line(lin,2350,lin+55,2350)
		If LinhaCorrente == nLinhasMemo
			oPrintPPP:Line(lin+55,50,lin+55,2350)
		Endif
		SomaLinha(55)
	Else
		oPrintPPP:Line(lin,50,lin+45,50)
		oPrintPPP:Line(lin,2350,lin+45,2350)
		oPrintPPP:Say(lin+5,60,MemoLine(TMZ->TMZ_DESCRI,130,LinhaCorrente),oFont08)
		If LinhaCorrente == nLinhasMemo
			oPrintPPP:Line(lin+45,50,lin+45,2350)
		Endif
		Somalinha(45,LinhaCorrente != nLinhasMemo)
	Endif
Next
If nLinhasMemo < 1
	oPrintPPP:Line(lin,50,lin+90,50)
	oPrintPPP:Line(lin,2350,lin+90,2350)
	oPrintPPP:Line(lin+90,50,lin+90,2350)
	Somalinha(90)
Endif
If lin+250 > 3000
	Somalinha(,,.t.)
Endif
oPrintPPP:Line(lin,50,lin+250,50)
oPrintPPP:Line(lin,2350,lin+250,2350)
oPrintPPP:Line(lin+250,50,lin+250,2350)
If lNGMDTPS
	cDataCid := alltrim(SA1->A1_MUN)+", "+StrZero(Day(dDataBase),2)+" de "+MesExtenso(Month(dDataBase))
	cDataCid += " de "+Str(Year(dDataBase),4)
Else
	cDataCid := alltrim(SM0->M0_CIDCOB)+", "+StrZero(Day(dDataBase),2)+" de "+MesExtenso(Month(dDataBase))
	cDataCid += " de "+Str(Year(dDataBase),4)
Endif
oPrintPPP:Say(lin+20,60,cDataCid,oFont09)

oPrintPPP:Line(lin+190,850,lin+190,1550)
oPrintPPP:Say(lin+200,950,"(Assinatura do Funcion�rio)",oFont08)

oPrintPPP:Say(3100,1170,Str(nPaginaPPP,3),oFont09n)
oPrintPPP:EndPage()
nPaginaPPP++
Return .t.

Static Function NGPPPDATE(dDtPPP)
Local cRet,cDia,cMes,cAno
If Empty(dDtPPP)
	Return "__/__/____"
Endif

cDia := Strzero(Day(dDtPPP),2)
cMes := Strzero(Month(dDtPPP),2)
cAno := Substr(Str(Year(dDtPPP),4),1,4)

cRet := cDia+"/"+cMes+"/"+cAno

Return cRet
/*/
����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �NG700SESMT� Autor �Denis Hyroshi de Souza � Data � 14/12/03 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Busca usuarios do sesmt para impressao do PPP              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MDTR700                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function NG700SESMT()
Dbselectarea("TMK")
Dbsetorder(1)
Dbgotop()
While !eof()
	If aSCAN(aMatriculas,{|x| x[1] == TMK->TMK_FILIAL}) < 1 .and. !Empty(TMK->TMK_FILIAL)
		Dbselectarea("TMK")
		Dbskip()
		Loop
	Endif
	If !(TMK->TMK_INDFUN $ "1/4")
		Dbselectarea("TMK")
		Dbskip()
		Loop
	Endif
	
	Dbselectarea("TRBTMK")
	Dbgotop()
	If !Dbseek(TMK->TMK_INDFUN+DTOS(TMK->TMK_DTINIC)+DTOS(TMK->TMK_DTTERM)+TMK->TMK_NUMENT+TMK->TMK_NOMUSU)
		TRBTMK->(DbAppend())
		TRBTMK->DTINI  := TMK->TMK_DTINIC
		TRBTMK->DTFIM  := TMK->TMK_DTTERM
		TRBTMK->FILIAL := TMK->TMK_FILIAL
		TRBTMK->CODIGO := TMK->TMK_CODUSU
		TRBTMK->NOME   := TMK->TMK_NOMUSU
		TRBTMK->INDFUN := TMK->TMK_INDFUN
		If TMK->(FieldPos("TMK_NIT")) > 0
			TRBTMK->NIT    := TMK->TMK_NIT
		Endif
		TRBTMK->REGNUM := TMK->TMK_NUMENT
	Endif

	Dbselectarea("TMK")
	Dbskip()
End

/*/
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
��� Fun��o   �RECLASS_RISCOS� Autor �Denis Hyroshi de Souza � Data � 14/12/03 ���
�����������������������������������������������������������������������������Ĵ��
��� Descri��o� Reclassifica os riscos                                         ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      � MDTR700                                                        ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
/*/
Static Function RECLASS_RISCOS()
Local cChave

//Agrupa riscos que foram separados na mudanca de Filial/Matricula/Setor/Funcao
Dbselectarea("TRBTN0")
Dbsetorder(3)
Dbgotop()
While !eof()
	If TRBTN0->PROTEC != "S"
		Dbselectarea("TRBTN0")
		Dbskip()
		Loop
	Endif
	cChave    := TRBTN0->(GRISCO+AGENTE+Str(INTENS,9,3)+TECNIC)
	dtstart   := TRBTN0->DT_DE
	dtstop    := TRBTN0->DT_ATE
	nRecOld   := Recno()

	Dbselectarea("TRBTN0")
	Dbskip()
	While !eof() .and. cChave == TRBTN0->(GRISCO+AGENTE+Str(INTENS,9,3)+TECNIC)
		If TRBTN0->PROTEC == "S"
			Dbselectarea("TRBTN0")
			Dbskip()
			Loop
		Endif
		If TRBTN0->DT_DE == dtstop+1

			RecLock("TRBTN0",.F.)
			TRBTN0->ATIVO := "N"
			Msunlock("TRBTN0")
			aAreaTRB := TRBTN0->(GetArea())
			dtstop   := TRBTN0->DT_ATE

			Dbselectarea("TRBTN0")
			Dbgoto(nRecOld)
			RecLock("TRBTN0",.F.)
			TRBTN0->DT_ATE := dtstop
			Msunlock("TRBTN0")

			RestArea(aAreaTRB)
		Endif
		Dbskip()
	End
	Dbselectarea("TRBTN0")
	Dbgoto(nRecOld)
	Dbskip()
End

Dbselectarea("TRBTN0")
Dbsetorder(2)
Dbgotop()
While !eof()
	If TRBTN0->ATIVO != "S"
		Dbselectarea("TRBTN0")
		Dbskip()
		Loop
	Endif

	cKeyRisco := TRBTN0->(GRISCO+AGENTE+Str(INTENS,9,3)+TECNIC+EPC+PROTEC+NUMCAP)
	dtstart   := TRBTN0->DT_DE
	dtstop    := TRBTN0->DT_ATE
	nRecOld   := Recno()

	While !eof() .and. cKeyRisco == TRBTN0->(GRISCO+AGENTE+Str(INTENS,9,3)+TECNIC+EPC+PROTEC+NUMCAP)
		If TRBTN0->ATIVO != "S"
			Dbselectarea("TRBTN0")
			Dbskip()
			Loop
		Endif
		If TRBTN0->DT_DE == dtstop+1
			RecLock("TRBTN0",.F.)
			TRBTN0->ATIVO := "N"
			Msunlock("TRBTN0")
			aAreaTRB := TRBTN0->(GetArea())
			dtstop   := TRBTN0->DT_ATE

			Dbselectarea("TRBTN0")
			Dbgoto(nRecOld)
			RecLock("TRBTN0",.F.)
			TRBTN0->DT_ATE := dtstop
			Msunlock("TRBTN0")

			RestArea(aAreaTRB)
		Endif
		Dbskip()
	End
	Dbselectarea("TRBTN0")
	Dbgoto(nRecOld)
	Dbskip()
End
Return nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �MDTCBOX   � Autor � Denis Hyroshi de Souza� Data � 27.11.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta Combo Box para exibir na tela                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �MDTCbox(cCampo)                                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Array com combo box                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Campo que tera o Combo Box anexado                 ���
���          � ExpC2 = String contendo item a nao ser apresentado "56"    ���
���          � ExpN1 = Tamanho a ser verificado a cada item da string     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PPPMDTCbox(cCampo,cForaCombo,nLenGrava)

Local aArray1	:= {}
Local aArray2	:= {}
Local aSaveArea	:= GetArea()

Local cVar,nCont

DEFAULT cForaCombo := ""
DEFAULT nLenGrava  := 1

dbSelectArea("SX3")
dbSetOrder(2)
MsSeek(cCampo)

cVar 	:= X3CBox()

If Empty(cVar)
	Return aArray2
Endif

aArray1	:= RetSx3Box(cVar,,,1)    

For nCont := 1 To Len(aArray1)
	If cForaCombo <> "" .And. Left(aArray1[nCont][1], nLenGrava) $ cForaCombo
		Loop
	Endif
	AADD(aArray2,aArray1[nCont][1])
Next nCont	

RestArea(aSaveArea)

Return aArray2

/*/
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
��� Fun��o   �SX6PPPRES     � Autor �Denis Hyroshi de Souza � Data � 26/01/04 ���
�����������������������������������������������������������������������������Ĵ��
��� Descri��o� Verifica conteudo do parametro sx6 e se nao existir inclui     ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      � MDTR700                                                        ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
/*/
static Function SX6PPPRES()

Dbselectarea("SX6")
Dbsetorder(1)
If Dbseek(xFilial("SX6")+"MV_MDTRESP")
	If Alltrim(GETMV("MV_MDTRESP")) == "2"
		cAliasRES := "TMK"
		cCNomeRES := "TMK->TMK_NOMUSU"
		cCdNitRES := "TMK->TMK_NIT"
		nTamanRES := 12
	Endif
Endif

Return
