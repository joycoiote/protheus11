/*
+-----------------------------------------------------------------------------------------+
| Autor: Jo�o Felipe da Rosa                                                              |
| Data:  14/02/2008                                                                       |
+-----------------------------------------------------------------------------------------+
|Array: O par�metro tem a seguinte estrutura:                                             |
|{nSaldo,SB2->B2_COD,SB2->B2_LOCAL}                                                       |
|nSaldo -> Saldo calculado pelo sistema                                                   |
|SB2->B2_COD -> C�dido do produto                                                         |
|SB2->B2_LOCAL -> Armaz�m do produto                                                      |
|Retorno                                                                                  |
+-----------------------------------------------------------------------------------------+
|LOCALIZA��O   : Localizado na fun��o A170Point  (Gera��o  das  solicita��es  de  compra).|
|EM QUE PONTO : � executado dentro do la�o onde  � feito o c�lculo  do  saldo  do  produto|
|de todos os almoxarifados. O resultado do c�lculo do saldo � guardado na vari�vel nSaldo.|
|O ponto de entrada � executado ap�s a  atualiza��o  desta  vari�vel,  produto  a  produto|
|(todos os almoxarifados) .                                                               |
+-----------------------------------------------------------------------------------------+

*/

#include "topconn.ch"

User Function MT170SLD( )

Local nQuant:= PARAMIXB[1]
Local cProd := PARAMIXB[2]
Local cLocal:= PARAMIXB[3]
Local nNewSaldo := 0
Local cQuery,  cQuery2

cQuery := "SELECT SUM(C1_QUANT - C1_QUJE) AS C1_QUANT FROM "+RetSqlName('SC1')
cQuery += " WHERE SUBSTRING(C1_CONTA,1,6) = '104020'"
cQuery += " AND C1_PRODUTO = '"+cprod+"'"
cQuery += " AND C1_QUJE <> C1_QUANT"
cQuery += " AND C1_LOCAL = '"+clocal+"'"
cQuery += " AND C1_RESIDUO = ' '"
cQuery += " AND D_E_L_E_T_ = ' '"

TCQUERY cQuery NEW ALIAS 'TRA1'

cQuery2 := "SELECT SUM(C7_QUANT - C7_QUJE) AS C7_QUANT FROM "+RetSqlName('SC7')
cQuery2 += " WHERE SUBSTRING(C7_CONTA,1,6) = '104020'"
cQuery2 += " AND C7_PRODUTO = '"+cprod+"'"
cQuery2 += " AND C7_QUJE <> C7_QUANT"
cQuery2 += " AND C7_LOCAL = '"+clocal+"'"
cQuery2 += " AND C7_RESIDUO = ' '"
cQuery2 += " AND D_E_L_E_T_ = ' '"

TCQUERY cQuery2 NEW ALIAS 'TRB'
         
nNewSaldo := nquant - (TRA1->C1_QUANT + TRB->C7_QUANT)

/*If '045005'$cprod

//-- Manipula��o pelo usu�rio do saldo do produto
ALERT(nquant)
ALERT(cprod)
ALERT(clocal)

EndIf
*/

TRA1->(DbCloseArea())
TRB->(DbCloseArea())

Return (nNewSaldo)



