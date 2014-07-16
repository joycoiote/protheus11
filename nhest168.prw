/*                              
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST168  �Autor  �Jo�o Felipe da Rosa � Data �  12/07/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � ACERTO DE EMPENHO DE S.A. (B2_QEMPSA)                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHEST168()
Private cPerg := 'EST168'
Private cAl   := 'QEMPSA'

	CriaSx1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	
	mvpar01 := mv_par01 //evita erros caso seja usado outro parametro mv_par01

	Processa({|| fQuery(mvpar01) },"Gerando informa��es ...")
	showEmp()

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! showEmp                                                 !
+------------------+---------------------------------------------------------+
!Descri��o         ! Tela para altera��o dos empenhos em S.A. no SB2         !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa                                     !
+------------------+--------------------------------------------------------*/
Static Function showEmp()
Local aAlter       	:= {'EMP'}
Local nOpc         	:= 4 //ALTERACAO
Local cLinhaOk     	:= "AllwaysTrue"
Local cTudoOk      	:= "AllwaysTrue"
Local cIniCpos     	:= ""
Local nFreeze      	:= 000
Local nMax         	:= 999
Local cCampoOk     	:= "AllwaysTrue"
Local cSuperApagar 	:= ""
Local cApagaOk     	:= "AllwaysTrue"
Private aHead       := {}
Private aCol        := {}

	//--Cabecalho                        
	aAdd(aHead,{'Produto'       ,"PRD" ,                         "",15,0,'.F.','.t.','C','','V'})
	aAdd(aHead,{'Requisi��es'   ,"REQ" ,                         "",06,0,'.F.','.t.','N','','V'})
	aAdd(aHead,{'Quant Req'     ,"QTD" ,                         "",06,0,'.F.','.t.','N','','V'})
	aAdd(aHead,{'Empenho'       ,"EMP" ,PesqPict("SB2","B2_QEMPSA"),06,0,'.T.',   '','N','',   })

	//--Dados
	(cAl)->(dbGoTop())
	While (cAl)->(!eof())
		aAdd(aCol,{(cAl)->prd,; //produto
				   (cAl)->req,; //quantidade de requisicoes para o produto
				   (cAl)->qcp,; //quantidade somada no scp
				   (cAl)->qb2,; //quantidade de empenho no sb2
				   .F.})        //flag nao deletado
		
		(cAl)->(dbSkip())
	EndDo 
	
	(cAl)->(dbCloseArea())

	Define MsDialog oDlg Title "Acerto de Empenho de S.A. - "+SB1->B1_DESC OF oMainWnd Pixel From 0,0 To 320,500

	oGetD := MsNewGetDados():New(05,05,140,245,nOpc,cLinhaOk,cTudoOk,cIniCpos,;
	aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDlg,aHead,aCol)
                                                                      
	tButton():New(145,115,"&Acertar" ,oDlg,{||fAcerto()},40,10,,,,.T.)
    tButton():New(145,160,"&Gravar"  ,oDlg,{||fGrv()    },40,10,,,,.T.)
    tButton():New(145,205,"&Cancelar",oDlg,{||oDlg:End()},40,10,,,,.T.)
	       
	OGETD:LUPDATE := .T.  

	
	Activate MsDialog oDlg Centered

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! fQuery                                                  !
+------------------+---------------------------------------------------------+
!Descri��o         ! Seleciona os produtos com S.A e empenho no SB2          !
!                  ! diferentes.                                             !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa                                     !
+------------------+--------------------------------------------------------*/
Static Function fQuery(cLocal)

	beginSql Alias cAl

	SELECT
		xb2.prd, //produto
		xb2.qb2, //quantidade de empenho no b2
		xb2.qcp, //quantidade somadas em sa
		xb2.req  //total de requisicoes por produto
	FROM
		(
		SELECT
			B2_COD prd,
			B2_QEMPSA qb2,
			COALESCE( (
				SELECT
					sum(CP_QUANT - CP_QUJE)
				FROM
					%Table:SCP% CP (NOLOCK)
				WHERE
					CP.D_E_L_E_T_ = ' '
					AND CP.CP_PRODUTO = B2.B2_COD
					AND CP.CP_LOCAL = B2.B2_LOCAL
					AND CP.CP_STATUS <> 'E'
					AND CP_QUJE < CP_QUANT
					AND CP.CP_FILIAL = B2.B2_FILIAL
				GROUP BY
					CP.CP_PRODUTO
			),0)qcp,
			(
				SELECT
					COUNT(*)
				FROM
					%Table:SCP% CP2 (NOLOCK)
				WHERE
					CP2.D_E_L_E_T_ = ' '
					AND CP2.CP_PRODUTO = B2.B2_COD
					AND CP2.CP_LOCAL = B2.B2_LOCAL
					AND CP2.CP_STATUS <> 'E'
					AND CP2.CP_QUJE < CP2.CP_QUANT
					AND CP2.CP_FILIAL = B2.B2_FILIAL
			)req

		FROM
			%Table:SB2% B2 (NOLOCK)
		WHERE
			B2_LOCAL = %Exp:cLocal%
		) xb2
	WHERE
		(xb2.qb2 <> xb2.qcp)
			or
		(xb2.qb2 > 0 and xb2.qcp IS NULL)

	ORDER BY
		xb2.prd

	endSql

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! fGrv                                                    !
+------------------+---------------------------------------------------------+
!Descri��o         ! Faz a Grava��o das altera��es no SB2                    !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa                                     !
+------------------+--------------------------------------------------------*/
Static Function fGrv()

	SB2->(dbSetOrder(1)) //FILIAL + COD + LOCAL
	For xE := 1 to Len(oGetD:aCols)
		If SB2->(dbSeek(xFilial("SB2")+oGetD:aCols[xE][1]+MVPAR01))
			RecLock("SB2",.F.)
				SB2->B2_QEMPSA := oGetD:aCols[xE][4]
			MsUnlock("SB2")
		EndIf
	Next	

	oDlg:End()
	
Return


/*-----------------+---------------------------------------------------------+
!Nome              ! CriaSx1                                                 !
+------------------+---------------------------------------------------------+
!Descri��o         ! Cria perguntas                                          !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa                                     !
+------------------+--------------------------------------------------------*/
Static Function CriaSx1()
PutSx1(cPerg,"01","Local ?"       ,"Local ?"       ,"Local ?"       ,"mv_ch1","C",02,0,0,"G","",""   ,"","","mv_par01","","","","","","","","","","","","","","","","",{"Local"        ,"","",""},{"Local"        ,"","",""},{"Local"        ,"","",""},"")
Return

Static Function fAcerto()
Local nEmp := aScan(aHead,{|x|UPPER(Alltrim(x[2])) == "EMP"}) 
Local nQtd := aScan(aHead,{|x|UPPER(Alltrim(x[2])) == "QTD"}) 

	For x:=1 to Len(oGetD:aCols)
		oGetD:aCols[x][nEmp] := oGetD:aCols[x][nQtd]
	Next
	
	oGetD:Refresh()

Return