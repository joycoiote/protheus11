/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHQMT008  �Autor  �Jo�o Felipe da Rosa � Data �  04/02/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � CERTIFICADO DE CALIBRA��O                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP10 METROLOGIA                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#Include "Protheus.Ch"
#include "rwmake.ch"
#include "topconn.ch" 

User Function NHQMT008()

Local _nLin 
Local _nCol
Private oFont10
Private oPrint
Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

//CRIA OS OBJETOS DE IMPRESS�O
oPrint := TMSPrinter():New("Nome do Relat�rio")
oPrint:SetPortrait() //SetLandScape
oPrint:Setup()//chama janela para escolher impressora, orientacao da pagina etc...
	
oFont10  := TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
               
oPrint:Say(_nLin,_nCol,"Ol� Mundo!",oFont10)
		
oPrint:EndPage()// Finaliza a pagina
	
oPrint:Preview()// Visualiza a pagina  	

Return