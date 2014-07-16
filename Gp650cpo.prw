/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GP650CPO  �Autor  �Microsiga           � Data �  08/29/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada apos gravacao RC1.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
  
/***************************************************************************/
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/***************************************************************************/
user function gp650cpo()

	If Alltrim(SM0->M0_CODIGO) == 'IT'
	                       
		Alert('GP650')
		DbSelectArea("RC1")
		Reclock("RC1",.F.)
		RC1->RC1_INTEGR := "0"
		MsUnlock("RC1")

		U_Nhgpe269(1)

	Endif	

Return(.t.)
