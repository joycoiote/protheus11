
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa:PCP044 Autor:Jos� Henrique M Felipetto Data:12/02/11          ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PCP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHPCP044()

AxCadastro("ZEK")

Return

User Function PCPVAL44()

If M->ZEK_OPERA <  10
	alert("N�mero da Opera��o deve ser no m�nimo 10! ")
	Return .F.
EndIf

Return .T.