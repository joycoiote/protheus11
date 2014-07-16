/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE197  �Autor  �Marcos R. Roquitski � Data �  08/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia e-mail apos emissao do aviso previo.                  ��
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhgpe197()

SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome")

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT")) //'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))  //'siga'
lConectou
lEnviado
cMensagem := '' 
CRLF := chr(13)+chr(10)
cMSG := ""
lEnd := .F.   
e_email = .F.                         

fEnviaEmail()

Return(.t.)


Static Function fEnviaEmail()
Local lRet     := .F.
Local _nTotPro := 0
Local _nTotDes := 0
Local _nZero   := 0
Local _cMes    := Space(20)
Local _cDesctt := Space(30)
Local _cDescf  := Space(20) 
	
	_cDescf := Space(20)
	SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
	If SRJ->(Found())
		_cDescf := SRJ->RJ_DESC
	Endif		
 
	_cDesctt := Space(30)
	CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))
	If CTT->(Found())
		_cDesctt := CTT->CTT_DESC01
	Endif		

	lRet      := .F.
	_cMail    := "" 
	_cMail    := "marcosvs@whbbrasil.com.br;alexandrerb@whbbrasil.com.br"
	_cMat     := "Matricula..: " + SRA->RA_MAT 
	_cNome    := "Nome.......: " + SRA->RA_NOME  
	_cFuncao  := "Funcao.....: " + SRA->RA_CODFUNC + ' ' + _cDescf
	_cCcusto  := "C. de Custo: " + SRA->RA_CC + ' ' + _cDesctt
	e_email   := .T.                                   

	If !Empty(_cMail)

		cMsg += '</tr>'
		cMsg += '</table>'
        
		cMsg += '</head>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">Funcion�rio em ** AVISO PR�VIO **, favor providenciar desligamento do sistema.</font></b>' + CRLF
		cMsg += '</tr>' + CRLF

	    cMsg += '<tr>'
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + _cMat  + '</font></b>' + CRLF
	    cMsg += '<tr>'
	    cMsg += '<b><font size="4" face="Courier">' + _cNome  + '</font></b>' + CRLF
	    cMsg += '<tr>'
	    cMsg += '<b><font size="4" face="Courier">' + _cFuncao + '</font></b>' + CRLF
	    cMsg += '<tr>'
	    cMsg += '<b><font size="4" face="Courier">' + _cCcusto + '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF

	    cMsg += '<b><font size="4" face="Courier">' + "Atenciosamente,"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + "Depto Pessoal"+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF
		cMsg += '</body>' + CRLF
		cMsg += '</html>' + CRLF

		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail); 
			SUBJECT 'Aviso Previo';
			BODY cMsg;
			RESULT lEnviado
			If !lEnviado
				Get mail error cMensagem
				Alert(cMensagem)
	    	Endif
		Else
			Alert("Erro ao se conectar no servidor: " + cServer)		
		Endif
		lRet := .F.
	Endif	
	ZRA->(DbSkip())


Return(.T.)