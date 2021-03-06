/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA070TIT  �Autor  �Marcos R. Roquitski � Data �  09/16/09   ���
c������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada apos confirmacao da Baixa.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#INCLUDE "rwmake.ch"

User Function FA070TIT()

Local nSalvRec  := Recno()
Local nImpostos := 0
Local _cTipos   := Alltrim(GETMV("MV_TIPOS")) 
Local cTitAnt   := (SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
// Baixa parcial, baixa imposto integral.

If Alltrim(GETMV("MV_FA070TI")) == 'S' .AND. SE1->E1_SALDO > 0

	nSalvRec:=Recno()

	//������������������������������������������������������������������Ŀ
	//�Verifica se h� abatimentos para voltar a carteira                 �
	//��������������������������������������������������������������������
	SE1->(DbSetOrder(2))
		
	If DbSeek(xFilial("SE1")+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
		While !Eof() .and. cTitAnt == (SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
			If Alltrim(SE1->E1_TIPO) $ _cTipos
				RecLock("SE1",.F.)				
				SE1->E1_MOVIMEN := dDataBase
				SE1->E1_BAIXA   := dDataBase
				SE1->E1_SALDO   := 0
				MsUnlock("SE1")				
			Endif	
			SE1->(dbSkip())
		EndDo
	Endif
	dbGoto(nSalvRec)
Endif

Return(.T.)
