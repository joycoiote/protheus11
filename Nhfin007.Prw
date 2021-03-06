/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHFIN007 � Autor � Jose Roberto Gorski   � Data � 18/04/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Liberacao dos Adiantamentos de Viagens                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para New Hubner                                 ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SZ3,SE2                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


#include "rwmake.ch" 

User Function Nhfin007()  

	SetPrvt("_LFLAG,_CTIT,_NTAXA,_NVALOR,")

	Processa( {|| libera() } )

Return


Static Function Libera()

	If !MsgBox ("Tem Certeza que Deseja Liberar os Adiantamentos de Viagem","Escolha","YESNO")
	   Return
	Endif

	ProcRegua(SZ3->(RecCount()))

	SZ3->(DbGoTop())
	_lFlag := .f.
	While SZ3->(!Eof())
       // Condicao para tratamento dos registros marcados
      If Marked("Z3_OK") .And. Empty(SZ3->Z3_CP) // Alteracao feita em 25/07/00
         // Marca os Registros apontados
         _lFlag := .t.
      Else
          _lFlag := .f.
      Endif

      // Se Passou pelo Marked processa
      If _lFlag
         // Gerar Contas a Pagar
         GeraCP()
      EndIf

      DbSelectArea("SZ3")
      IncProc()
      SZ3->(DbSkip())
	EndDo

	SZ3->(DbGoTop())
	
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � GeraCP   � Autor �Jose Roberto Gorski    � Data � 18/04/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Geracao do Contas a Pagar                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico New Hubner                                      ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SZ3,SE2                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


Static Function GeraCP()

// Se a Moeda e diferente de real 1, perguntar qual a taxa da moeda 
// multiplicar pelo valor e gravar a taxa no sz3
	If SZ3->Z3_MOEDA <> "1"

      If SZ3->Z3_MOEDA == "2"
         _cTit := "Dolar"
      ElseIf SZ3->Z3_MOEDA == "3"
         _cTit := "DM"
      ElseIf SZ3->Z3_MOEDA == "4"
         _cTit := "Outras"   
      Endif
      
      _nTaxa := 0.00
      @ 0,0 TO 125,156 DIALOG oDlg1 TITLE "Atualiza Taxa"
      @ 001,005 TO 055,072 Title _cTit      
      @ 025,013 Say "Taxa: "
      @ 025,030 Get _nTaxa Picture "@E 999.99"
      @ 040,010 BMPBUTTON TYPE 01 ACTION Grava(1)
      Activate Dialog oDlg1 Centered
	Else
      _nValor := SZ3->Z3_VALOR
      _nTaxa := 0.00
      Grava(2)
	Endif

Return(nil)    


Static Function Grava(_nPos)

	If SZ3->Z3_MOEDA <> "1"
	   _nValor := SZ3->Z3_VALOR * _nTaxa
	Endif

	RecLock("SE2",.t.)
	  SE2->E2_FILIAL  := xFilial("SE2")
	  SE2->E2_PREFIXO := "ADT"
	  SE2->E2_NUM     := SZ3->Z3_NUM
	  SE2->E2_PARCELA := "A"
	  SE2->E2_TIPO    := "VL"
	  SE2->E2_NATUREZ := SZ3->Z3_NATUREZ
	  SE2->E2_MATR    := SZ3->Z3_MATR
	  SE2->E2_FORNECE := "999999"
	  SE2->E2_LOJA    := "01"
	  SE2->E2_NOMFOR  := "ADIANTAMENTO DE VIAGEM"
	  SE2->E2_EMISSAO := SZ3->Z3_EMISSAO
	  SE2->E2_VENCTO  := dDataBase
	  SE2->E2_VENCREA := dDataBase
	  SE2->E2_VALOR   := _nValor
	  SE2->E2_EMIS1   := dDataBase
	  SE2->E2_HIST    := "PGTO/" + SZ3->Z3_NUM + " P/" + SZ3->Z3_NOME
	  SE2->E2_SALDO   := _nValor
	  SE2->E2_VENCORI := dDataBase
	  SE2->E2_MOEDA   := 1   // Verificar com Dercy
	  SE2->E2_RATEIO  := "N"
	  SE2->E2_VLCRUZ  := _nValor
	  SE2->E2_OCORREN := "01"
	  SE2->E2_ORIGEM  := ""
	  SE2->E2_FLUXO   := "S"
	  SE2->E2_DESDOBR := "N"
	  SE2->E2_OBS     := "TITULO GERADO PELA ROTINA DE ADIANTAMENTO DE VIAGEM"
	  SE2->E2_CC      := SZ3->Z3_CC
	MsUnLock("SE2")
	
	// Marcar como Gerado titulo no financeiro
	RecLock("SZ3",.f.)
 	  SZ3->Z3_CP   := "X"
	  SZ3->Z3_TAXA := _nTaxa
	MsUnLock("SZ3")

	If _nPos == 1
	   Close(oDlg1)
	Endif
	
Return
