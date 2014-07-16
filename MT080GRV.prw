
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT080GRV  �Autor:Jos� Henrique M Felipetto Data:08/21/12 	  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada ap�s a grava��o da TES                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cadastro de TES/FAT         								  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT080GRV()
	
	

//������������������������������������������������������Ŀ
//�Bloco de c�digo que envia e-mail avisando que uma TES �
//�foi inclu�da, e n oconte�do suas informa��es.         �
//��������������������������������������������������������
cMsg := "<html>"
cMsg += "<div style='background:#ffffff;font-family:arial;font-size:12px;margin:0px'>"
cMsg += "<table cellpadding='0' cellspacing='5' width='100%' style='font-family:arial;font-size:12px;margin:0px'>"
cMsg += "<tr> <td bgcolor='#cccccc' width='10'>&nbsp;</td>"
cMsg += "<td bgcolor='#efefef' style='color:#666666;font-size:18px' height='30' valign='middle'>"
cMsg += "&nbsp;&nbsp;Aviso de inclus�o de TES"
cMsg += "</td> </tr> "
cMsg += "<tr><td colspan='3'><ul><li>TES: " + SF4->F4_CODIGO + " </li> <li> CFOP: " + SF4->F4_CF + " </li> <li> Usu�rio: " + Alltrim(Upper(cUsername)) + " </li> </ul> "
cMsg += " </td></tr></table><hr></div>"
  
cTo := Iif(SM0->M0_CODIGO$"IT","fiscal@itesapar.com.br","lista-fiscal@whbbrasil.com.br;contabil@whbbrasil.com.br")
	//cTo := "josemf@whbbrasil.com.br"

oMail          := Email():New()
oMail:cMsg     := cMsg
oMail:cAssunto := "*** INCLUS�O DE TES ***"
oMail:cTo      := cTo
oMail:Envia()
//��������������������������������������������������������

Return
