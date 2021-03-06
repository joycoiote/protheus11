#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch"
#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � E205BLQ �Autor  �Douglas de S. Dourado� Data � 04/09/2012�  ��
�������������������������������������������������������������������������͹��
���Desc.     �Valida se produto est� bloqueado temporariamente(Invent�rio)���
���															         	  ���
�������������������������������������������������������������������������͹��
���Uso       � AP11 - ESTOQUE E CUSTOS - NHEST205                         ���
���	         � Confere na tabela se produto est� bloqueado para execu��o  ���
���			 de alguma opera��o (Exemp: Invent�rio)	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function E205BLQ(produto,alm)
Private cQuery, lBloqueia := .F., lAviso := .F. 

cQuery := " SELECT * "     
cQuery += " FROM " + RetSqlName("ZEZ") + " ZEZ" 
cQuery += " WHERE  ZEZ_PROD = '" + produto + "' " 
cQuery += " AND ZEZ_ALM = '" + alm + "' "
cQuery += " AND ZEZ_DTFIM >= '" + DtoS(Date()) + "' "
cQuery += " AND ZEZ.D_E_L_E_T_ = '' AND ZEZ_FILIAL = '" +xFilial("ZEZ") + "' " 

TCQUERY cQuery NEW ALIAS "TRA2"  // Criando ALIAS

TCSETFIELD("TRA2","TRA2->ZEZ_DTINI","D") 
TCSETFIELD("TRA2","TRA2->ZEZ_DTFIM","D")
                                         
    
	// Caso o select traga algum produto
	IF  !TRA2->(Eof()) 		
		While !TRA2->(Eof()) .AND. TRA2->ZEZ_PROD == produto .AND. TRA2->ZEZ_ALM == alm
	      	If fPeriodo(TRA2->ZEZ_PROD,TRA2->ZEZ_ALM)
		      	exit
		    Else 
	      	 	TRA2->(DbSkip())
	        EndIf	    						
		EndDo				
	EndIf
                                  
	  	If lBloqueia // Caso produto esteja bloqueado
	  	   
		  	   //verifica se a variavel que controla o erro via coletor est� declarada
		  	   if Type("MsgRetWMS")=="C"                                              
		  			//retorna o erro ao coletor
		  			MsgRetWMS := "Este produto est� bloqueado para movimenta��o! Inventario ! ( P.E. - E205BLQ)"	
		  	   else		  	 
			   MsgBox("Este produto est� bloqueado para movimenta��o!"+ chr(13) +chr(10) + chr(13) + chr(10) + ;
				     "Per�odo do bloqueio: Do dia "+DtoC(TRA2->ZEZ_DTINI)+" at� dia "+DtoC(TRA2->ZEZ_DTFIM)+ " das ";
					 +TRA2->ZEZ_HRINI+" at� �s "+TRA2->ZEZ_HRFIM+ chr(13) +chr(10) + chr(13) + chr(10) + ;
					 " Motivo: "+Alltrim(TRA2->ZEZ_MOTIV) +chr(10) + chr(13) + chr(10) + ;
					 " Respons�vel pelo bloqueio: "+UsrFullName(TRA2->ZEZ_LOGIN),;
					 " Aviso de Bloqueio do produto "+TRA2->ZEZ_PROD,"STOP")
			  endif		 
				 
				 	
	 	   TRA2->(DbCloseArea())
		   Return .F.                       	
		EndIf 	

		If lAviso  // Caso produto esteja dentro da situa��o de aviso 
		
		       //verifica se a variavel que controla o erro via coletor est� declarada
		  	   if Type("MsgRetWMS")=="C"                                              
		  			//retorna o erro ao coletor
		  		   MsgRetWMS := "Este produto est� bloqueado para movimenta��o! Inventario ! ( P.E. - E205BLQ)"	
		  	   else			
				   MsgBox("Este produto ir� ser bloqueado para movimenta��o durante o seguinte per�odo:"+ chr(13) +chr(10) + chr(13) + chr(10) + ;
					     "Do dia "+DtoC(TRA2->ZEZ_DTINI)+" at� dia "+DtoC(TRA2->ZEZ_DTFIM)+ " das ";
						 +TRA2->ZEZ_HRINI+" at� �s "+TRA2->ZEZ_HRFIM+ chr(13) +chr(10) + chr(13) + chr(10) + ;
						 " Motivo: "+Alltrim(TRA2->ZEZ_MOTIV) +chr(10) + chr(13) + chr(10) + ;
						 " Respons�vel: "+UsrFullName(TRA2->ZEZ_LOGIN),;
						 " Aviso Pr�vio de Bloqueio de Movimenta��o do produto "+TRA2->ZEZ_PROD,"INFO")						
			   endif
			   
	   	   TRA2->(DbCloseArea())
		   Return .T.
		EndIf 
		
		TRA2->(DbCloseArea())  	 	

RETURN .T.  

// Verifica situa��o do produto atual do ALIAS TRA2
Static Function fPeriodo(produto,alm)
Local nHora := Substr(Time(),1,5)  // Pega a hora atual
	
	// Verifica se est� no per�odo de bloqueio
	If DtoS(TRA2->ZEZ_DTINI) <= DtoS(DATE()) .AND. DtoS(TRA2->ZEZ_DTFIM) >= DtoS(DATE()) // Verifica a data
		IF nHora >= TRA2->ZEZ_HRINI .AND. nHora <= TRA2->ZEZ_HRFIM // Verifica o hor�rio
		   lBloqueia := .T. // Faz o bloqueio do produto
		   Return .T.	
		Else
		   Return .F.	
		EndIf
		   
	// Verifica se est� no per�odo de aviso de bloqueio
	ElseIf DtoS(TRA2->ZEZ_DTINI) > DtoS(DATE()) .AND. DtoS(TRA2->ZEZ_DTFIM) > DtoS(DATE())
	
	    IF DATE() >= (TRA2->ZEZ_DTINI - TRA2->ZEZ_DIAS) .AND. DATE() < TRA2->ZEZ_DTINI
	       lAviso := .T.
	       Return .T.
	    EndIf		  	
	
	// Caso n�o esteja bloqueado e nem com aviso, valida automaticamente   
	Else    	
		   Return .F.	   
	EndIf   	   	
		
Return 