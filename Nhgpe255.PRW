/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE255 �Autor  �Marcos R Roquitski  � Data �  22/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueia transferencia funcionario linha.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch" 
#include "Font.ch" 
#include "Colors.ch" 


User Function Nhgpe255()

	If MsgBox("Bloquea Rotina de de ** TRANSFERENCIA FUNCIONARIO LINHA ?.","Bloqueio de Transferencia","YESNO")

		SX6->(DbSeek(xFilial("SRA")+"MV_GPEM099"))
		If SX6->(Found())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "S"
			MsUnlock("SX6")

			Alert("** TRANSFERENCIA FUNCIONARIO LINHA,  BLOQUEADA para manutencao.") 
		Else
			Alert("Parametro MV_GPEM099 Nao cadastrado. Verifique no cadastro de parametros!")	

		Endif	
	
	Else
	
		SX6->(DbSeek(xFilial("SRA")+"MV_GPEM099"))
		If SX6->(Found())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "N"
			MsUnlock("SX6")

			Alert("** TRANSFERENCIA FUNCIONARIO LINHA,  LIBERADA para manutencao.")

		Else

			Alert("Parametro MV_GPEM099 Nao cadastrado. Verifique no cadastro de parametros!")	

		Endif	
		
	Endif
	
Return
