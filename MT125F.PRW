/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT125F    �Autor  �Jo�o Felipe da Rosa � Data �  30/07/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � AP�S GRAVACAO DO PEDIDO EM ABERTO MATA125                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � COMPRAS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT125F()
Local nC3Rec := SC3->(Recno()) //guarda a posicao do sc3

//-- altera todos os produtos no campo b1_contrat como 's'
If ALTERA

	SB1->(dbSetOrder(1))//FILIAL + COD
	cNum := SC3->C3_NUM
	
	WHILE SC3->(!EOF()) .AND. SC3->C3_NUM==cNum
		If SB1->(dbSeek(xFilial("SB1")+SC3->C3_PRODUTO))
			Reclock("SB1",.F.)
				SB1->B1_CONTRAT := 'N'
			MsUnlock("SB1")
		EndIf
		SC3->(dbskip())
	ENDDO

Endif   

SC3->(dbGoTo(nC3Rec)) //retorna a posicao do sc3

Return