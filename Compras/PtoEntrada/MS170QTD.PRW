/**********************************************************************************************************************************/
/** Compras                                                                                                                      **/
/** ponto de entrada sera utilizado para atualizar a quantidade a ser comprada.                                                  **/
/** RSAC Solu��es                                                                                                                **/
/** Data: 17/07/2013                                                                                                             **/
/** WHB FUNDICAO SA                                                                                                              **/
/**********************************************************************************************************************************/
/** Data       | Respons�vel                    | Descri��o                                                                      **/
/**********************************************************************************************************************************/
/** 17/07/2013 | Esteferson Moura               | Cria��o da rotina/procedimento.                                                **/
/**********************************************************************************************************************************/
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/**********************************************************************************************************************************/
/** user function MS170QTD                                                                                                       **/
/** recupera a posicao do produto no array e atualiza a quantidade.                                                              **/
/**********************************************************************************************************************************/
/** Par�metro  | Tipo | Tamanho | Descri��o                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
user function MS170QTD
	
	// retorno
	local nQtdAtu := 0
	// posicao produto
	local nPos    := aScan( aProdPP, {|x| AllTrim(x[1])+x[2] == AllTrim(TRBSB1->B1_COD)+TRBSB1->B1_LOCPAD } )
	
	
	// produto encontrado
	if nPos > 0
		// atualiza quantidade de compra
		nQtdAtu := aProdPP[nPos][3]
		
	endIf
	
return( nQtdAtu )
