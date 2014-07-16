/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE181  �Autor  �Marcos R. Roquitski � Data �  18/06/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao campo RA_TPDEFFI                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function Nhgpe181()

SetPrvt("lEnd")
lEnd := .t.
If Alltrim(M->RA_TPDEFFI) == "0" .and. Alltrim(M->RA_DEFIFIS) == "1"
	Alert("Atencao, favor informar o tipo de deficiencia fisica")
	lEnd := .f.
Endif	
Return(lEnd)
