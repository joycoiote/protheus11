
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  NHPCP002� Autor �  Alexandre R. Bento  � Data � 29/04/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Nao permitir qtde maior que o saldo da OP                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Apontamento de OP                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"              

User Function NHPCP002()       
		
		SC2->(DbSetOrder(1)) // Filial + Num + Item + Sequencia + ItemGrd
		If SC2->(DbSeek(xFilial("SC2")+M->D3_OP))
		
		   If (SC2->C2_QUANT - SC2->C2_QUJE) < M->D3_QUANT
		      MsgBox("Quantidade Digitada Maior que Saldo na OP ","Atencao","ALERT")
		      M->D3_QUANT := SC2->C2_QUANT - SC2->C2_QUJE
		   Endif
		Endif
    
   
Return(M->D3_QUANT)
