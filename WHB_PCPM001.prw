/*---------------------------------------------------------------------------+
!                             FICHA T�CNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Rotina                                                  !
+------------------+---------------------------------------------------------+
!M�dulo            ! Compras/PCP                                             !
+------------------+---------------------------------------------------------+
!Nome              ! PWHBM001                                                !
+------------------+---------------------------------------------------------+
!Descri��o         ! MRP - Ferramentas                                       !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 18/02/2010                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZAC�ES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descri��o detalhada da atualiza��o      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+-------*/    

#Include 'Protheus.ch'
#Include 'Rwmake.ch'
#Include 'dbTree.ch'

user Function pWhbm001()

Local cTitulo := "MRP - Ferramentas"
Local aDescri := {}
Local aBotao  := {}
Local lOk     := .F.
Private cPerg := "PWHBM001  "
Private cAl   := "TRBMRPFER"
Private oGetDados
Private mvpar01
Private mvpar02
Private mvpar03
Private mvpar04
Private aTree := {}
Private aEmin := {}
Private nqtscs



	/*
	aTree[1] := Tipo (P ou F)
	aTree[1] := Codigo do Tree
	aTree[1] := Codigo do Produto
	aTree[1] := Codigo da Ferramenta
	*/
                                          
CriaSx1(cPerg)
Pergunte(cPerg, .F.)

//--Tela para breve descri��o da Rotina, e para bot�es Parametros, Ok e cancelar
AADD(aDescri,"Este programa processa o MRP - Ferramentas de acordo com a previs�o de vendas")
AADD(aDescri,"em conjunto com a Ferramentas X Opera��es, gerando tela para consulta e confirma��o")
AADD(aDescri,"para cri��o de solicita��o de compras de ferramentas.")
AADD(aBotao,{5, .T., {|| Pergunte(cPerg, .T.)}})
AADD(aBotao,{1, .T., {|o| o:oWnd:End(), lOk := .T.}})
AADD(aBotao,{2, .T., {|o| o:oWnd:End()}})
FormBatch(cTitulo,aDescri,aBotao)
	
If lOk
    
	//--Verifica parametro de data
	If mv_par01 > mv_par02
		Aviso("Data","Par�metros: Data inicial deve ser menor que data final.",{"Ok"},1)
	
	//--Verifica parametro de produto
	ElseIf mv_par03 > mv_par04
		Aviso("Produto","Par�metro: Produto inicial deve ser menor que o produto final.",{"Ok"},1)

	//--Se tudo ok, chama fun��es
	Else

		//--Backup dos parametros
		//--caso alguma fun��o chame um pergunte n�o dara problema aqui
		mvpar01 := mv_par01
		mvpar02 := mv_par02
		mvpar03 := mv_par03
		mvpar04 := mv_par04
		mvpar05 := mv_par05
		mvpar06 := mv_par06
		mvpar07 := mv_par07
				
		//--Calcula o Estoque M�nimo para as ferramentas
		Processa({|| U_MRPCalEMin(mvpar01,mvpar02,mvpar05,mvpar06) },"Calculando estoque m�nimo para as ferramentas!")
		
		//--A primeira fun��o � responsavel por fazer o relacionamento entre
		//--SHC - previsao e ZDJ - Ferramentas
		Processa({||pWhbProc()})

		//--Se o processamento retornar registros
		//--Vetor aTree tera registros
		If (Len(aTree) > 0)

			//--A segunda fun��o � responsavel por mostrar a tela de visualiza��o
			Processa({||pWhbView()})

		Else

			//--Avisa ao usuario que n�o a dados
			Aviso("Sem registros","N�o existem registros para serem apresentados, verifique os par�metros.",{"OK"},1)

		Endif
	Endif
		
Endif

//--Fecha Alias Temporario
If Select(cAl) > 0
	dbSelectArea(cAl)
	dbCloseArea()
Endif

Return

/*-----------------+---------------------------------------------------------+
!Nome              ! pWhbProc                                                !
+------------------+---------------------------------------------------------+
!Descri��o         ! Processamento do MRP - Ferramentas                      !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 19/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function pWhbProc()

Local aProd := {}
	/*
	aProd[1] := Saldo Atual
	aProd[2] := Entrada
	aProd[3] := Saida
	aProd[4] := Saldo Estoque
	aProd[5] := Necessidade
	*/
Local aFerr := {}
	/*
	aFerr[1] := Saldo Atual
	aFerr[2] := Necessidade
	aFerr[3] := Outras Necessidades
	aFerr[4] := Qtde Comprar
	aFerr[5] := Custo unitario
	aFerr[6] := Custo Total
	*/
Local cShc    := "TMP_SHC"
Local cSd1    := "TMP_SD1"
Local cSd2    := "TMP_SD2"
Local cOut    := "TMP_OUT"
Local nSaldo  := 0
Local nQtdPC  := 0
Local nQtdSC  := 0
Local cProd   := "P000000"
Local cFerr   := "F000000"
Local cWhere  := ""

//--Variaveis Montagem do arquivo Temporario
Local aCampos := {}
Local cNomeArq := CriaTrab(Nil,.F.)
Local cIndArq1 := CriaTrab(Nil,.F.)
Local cIndArq2 := CriaTrab(Nil,.F.)

//--Verifica se alias esta aberto
If Select(cAl) > 0
	dbSelectArea(cAl)
	dbCloseArea()
EndIf

//--Estrutura do arquivo temporario
aAdd(aCampos,{"DBTREE","C",07,0}) //-- Codigo do TREE
aAdd(aCampos,{"PRODUT","C",15,0}) //-- Codigo do produto
aAdd(aCampos,{"FERRAM","C",15,0}) //-- Codigo da Ferramenta
aAdd(aCampos,{"OPERAC","C",03,0}) //-- Codigo da Opera��o
aAdd(aCampos,{"CCUSTO","C",09,0}) //-- Codigo da Centro de Custo
aAdd(aCampos,{"SEQ"   ,"C",01,0}) //-- Sequencia que sera mostrado
aAdd(aCampos,{"TIPO"  ,"C",15,0}) //-- Tipo

//--FOR com as datas para montagem do arquivo temporario
//--Com colunas data
For xD := mvpar01 to mvpar02
	aAdd(aCampos,{"C"+DtoS(xD),"N",15,6}) //--Data      //ALTERADO P/ 6 CASAS DECIMAIS POR JO�O FELIPE

Next

//--Cria o Arquivo temporario
dbCreate(cNomeArq,aCampos)
dbUseArea(.T.,,cNomeArq,cAl,.F.,.F.)
IndRegua(cAl,cIndArq1,"DBTREE+SEQ",,,"Criando indice um...")
IndRegua(cAl,cIndArq2,"FERRAM",,,"Criando indice dois...")

dbClearIndex()
dbSetIndex(cIndArq1+OrdBagExt())
dbSetIndex(cIndArq2+OrdBagExt())

//--Tabela de produto vs opera��o
dbSelectArea("ZDJ")
dbSetOrder(1) //Filial+Produto+Ferramenta
dbGoTop()

//--Posiciona no registro do parametro inicial
dbSeek(xFilial("ZDJ")+mvpar03,.t.)

//--Regua
ProcRegua(0)

While !ZDJ->(Eof()) .And. ZDJ->ZDJ_PROD >= mvpar03 ; //--Maior ou igual ao parametro Produto De
                    .And. ZDJ->ZDJ_PROD <= mvpar04   //--Menor ou igual ao parametro Produto Para

	//-- filtro por ferramenta
	If ZDJ->ZDJ_FERRAM < mvpar05 .or.;
	   ZDJ->ZDJ_FERRAM > mvpar06
	   
	   ZDJ->(dbskip())
	   loop
	EndIf

	//--Incrementa regua
	IncProc("Produto: "+ZDJ->ZDJ_PROD)
	cWhere := ZDJ->ZDJ_PROD
	aProd := {}

	//--Abre os alias referentes ao produto do SDJ
	//--Necessidade
	//--Entradas
	//--Saidas
	abreProd(ZDJ->ZDJ_PROD,cShc,cSd1,cSd2)

	//--Verifica se o produto possui necessidades
	//--Se a consulta do SHC retornar Vazio, segnifica que n�o tem previsao de vendas
	If (cShc)->(Eof())

		//--Enquanto n�o for fim de arquivo e for o mesmo produto
		While !ZDJ->(Eof()) .And. ZDJ->ZDJ_PROD == cWhere

			//--Vai pulando de linha
			ZDJ->(dbSkip())		

		Enddo

		//--Depois faz Loop
		Loop

	Endif
	
	//--A primeira linha consulta saldo em estoque atual do dia da consulta
	aAdd(aProd,{U_MRPFSld(ZDJ->ZDJ_PROD),pBuscaValor(cSd1,mvpar01),pBuscaValor(cSd2,mvpar01),0,pBuscaValor(cShc,mvpar01)})
	
	//--Calcula saldo do pr�ximo dia
	//--Saldo inicial + ( Entradas - Saidas ) + Necessidade
	aProd[1,4] := aProd[1,1]+(aProd[1,2]-aProd[1,3])
	nSaldo := aProd[1,1]+(aProd[1,2]-aProd[1,3])+aProd[1,5]

	//--Agora do Saldo Inicial � composto pelo do dia anterior
	//--e inicial da data inicial + 1 at� a data final
	For xD := (mvpar01+1) to mvpar02

		//--Monta Saldos do Dia
		aAdd(aProd,{nSaldo,pBuscaValor(cSd1,xD),pBuscaValor(cSd2,xD),0,pBuscaValor(cShc,xD)})

		//--Calcula saldo do pr�ximo dia
		//--Saldo inicial + ( Entradas - Saidas ) + Necessidade
		aProd[Len(aProd),4] := aProd[Len(aProd),1]+(aProd[Len(aProd),2]-aProd[Len(aProd),3])
		nSaldo := aProd[Len(aProd),1]+(aProd[Len(aProd),2]-aProd[Len(aProd),3])+aProd[Len(aProd),5]
		
	Next

	//--Soma1 ao codigo Atual
	cProd := Soma1(cProd)
	//--Grava��o dos dados no arquivo temporario
	GravaTMP(aProd,"P",cProd,ZDJ->ZDJ_PROD,Space(TamSx3("B1_COD")[1]),SPACE(TamSx3("ZDJ_OP")[1]),ZDJ->(Recno()))
        
   // aEmin := {}
	//--Agora fara os calculos de ferramenta
	While !ZDJ->(Eof()) .And. ZDJ->ZDJ_PROD == cWhere

		//-- filtro por ferramenta
		If ZDJ->ZDJ_FERRAM < mvpar05 .or.;
		   ZDJ->ZDJ_FERRAM > mvpar06
		   
		   ZDJ->(dbskip())
		   loop
		EndIf

		aFerr := {}

		//-- Pega custo medio do produto usando armaz�m padr�o B1_LOCPAD
		nCusto := U_MRPFVUFor(ZDJ->ZDJ_FERRAM,'N')[1] //bCusto()
		consulNecess(cOut)
		
		//-- pega a quantidade de pedidos em aberto
		nQtdSC := U_MRPFQSCA(ZDJ->ZDJ_FERRAM)

		//-- pega a quantidade de scs em aberto
		nQtdPC := U_MRPFQPCA(ZDJ->ZDJ_FERRAM)

		//-- pega a quantidade de ferramenta que vai consumir at� o primeiro dia da necessidade
		nConAte := U_MRPFCons(ZDJ->ZDJ_FERRAM,date(),mvpar01-1)

		//-- consulta saldo em estoque atual do dia da consulta
        nSaldo := U_MRPFSld(ZDJ->ZDJ_FERRAM,.t.)
		 
		//-- Saldo em estoque + saldo em pedido de compras aberto + sc em aberto
		nSaldo += nQtdPC + nQtdSC

		//-- DIMINUI o saldo a consumir at� o primeiro dia de previsao de necessidades
		nSaldo -= Ceiling(nConAte)

		//-- Agora do Saldo Inicial � composto pelo do dia anterior
		//-- e inicial da data inicial + 1 at� a data final
		For xD := (mvpar01) to mvpar02
	
			//--Monta Saldos do Dia
			aAdd(aFerr,{nSaldo                        ,U_MRPFConP(aProd[(xD-mvpar01)+1,5])[1],bOutNecess(cOut,xD),0,nCusto,0})

			//--Calcula saldo do pr�ximo dia
			//--Saldo inicial - Necessidade
			//--Se saldo for maior oi igual
			If (nSaldo >= aFerr[Len(aFerr),3])
				//--Subtrai do saldo
				nSaldo -= aFerr[Len(aFerr),3]
				//-- e zera qtde a comprar
				aFerr[Len(aFerr),4] := 0
			
			//--se o saldo for menor
			Else
				//--Subtrai da qtde a comprar
				aFerr[Len(aFerr),4] := aFerr[Len(aFerr),3]
				aFerr[Len(aFerr),4] -= nSaldo
				//--zera saldo
				nSaldo := 0
			Endif

			//--Atualiza valor total
			aFerr[Len(aFerr),6] := aFerr[Len(aFerr),4]*aFerr[Len(aFerr),5]

			//--Atualiza o campo outras necessidade
			//--Necessidade total - necessidade desta ferramentaxproduto
			aFerr[Len(aFerr),3] -= aFerr[Len(aFerr),2]

		Next

		//--Soma1 ao codigo Atual
		cFerr := Soma1(cFerr)
		//--Grava��o dos dados no arquivo temporario
		GravaTMP(aFerr,"F",cFerr,ZDJ->ZDJ_PROD,ZDJ->ZDJ_FERRAM,ZDJ->ZDJ_OP,ZDJ->(Recno()))

		ZDJ->(dbSkip())

	Enddo

Enddo

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! consulNecess                                            !
+------------------+---------------------------------------------------------+
!Descri��o         ! consulta necessidade total de uma ferramentas para todos!
!                  ! os produtos                                             !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 05/03/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function consulNecess(cOut)

//--Fecha Alias Temporario se estiver aberto
If Select(cOut) > 0
	dbSelectArea(cOut)
	dbCloseArea()
Endif

//--Consulta a necessidade total por dia do periodo
beginSql Alias cOut
	select 
	  xdj.produto
	, xdj.data
	, sum(xdj.quant) quant
	, xdj.zdj_recno
	from (
		select
		  SHC.HC_PRODUTO produto
		, SHC.HC_DATA data
		, SUM(SHC.HC_QUANT) quant   
		, ZDJ.R_E_C_N_O_ zdj_recno
		from
			%table:ZDJ% ZDJ
		inner join
				%table:SHC% SHC
			on  SHC.HC_FILIAL = %xFilial:SHC%
			and SHC.HC_PRODUTO = ZDJ.ZDJ_PROD  
			and SHC.HC_DATA >= %Exp:mvpar01%
			and SHC.HC_DATA <= %Exp:mvpar02%
			and SHC.D_E_L_E_T_ = ' '
			
		where
			ZDJ.ZDJ_FILIAL = %xFilial:ZDJ%
		and ZDJ.ZDJ_FERRAM = %Exp:ZDJ->ZDJ_FERRAM%
		and ZDJ.D_E_L_E_T_ = ' '
		group by 
		  SHC.HC_PRODUTO 
		, SHC.HC_DATA
		, ZDJ.R_E_C_N_O_
	) xdj
	group by xdj.data, xdj.produto , xdj.zdj_recno
	order by xdj.data, xdj.produto
endSql

return

/*-----------------+---------------------------------------------------------+
!Nome              ! aliasProd                                               !
+------------------+---------------------------------------------------------+
!Descri��o         ! abre os alias SHC, SD1 e SD2                            !
!                  ! Para n�o fazer uma consulta por dia de cada produto,    !
!                  ! fa�o do periodo para cada produto                       !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 19/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function abreProd(cProd,cShc,cSd1,cSd2)

//--Fecha Alias Temporario se estiver aberto
If Select(cShc) > 0
	dbSelectArea(cShc)
	dbCloseArea()
Endif

//--Consulta as Previs�es de venda
beginSql Alias cShc
	select 
		HC_DATA       as data
	,   sum(HC_QUANT) as quant
	from 
		%table:SHC%
	where 
		HC_FILIAL  = %xFilial:SHC%
	and HC_PRODUTO = %Exp:cProd%
	and HC_DATA   >= %Exp:DtoS(mvpar01)%
	and HC_DATA   <= %Exp:DtoS(mvpar02)%
	and HC_MRPFE   = ' '
	and D_E_L_E_T_ = ' '
	group by
		HC_DATA	
endSql

//--Fecha Alias Temporario se estiver aberto
If Select(cSd1) > 0
	dbSelectArea(cSd1)
	dbCloseArea()
Endif

//--Consulta as Previs�es de venda
beginSql Alias cSd1
	select 
	    SF1.F1_DTDIGIT    as data
	,   sum(SD1.D1_QUANT) as quant
	from
	    %table:SF1% SF1
	inner join
	        %table:SD1% SD1
	    on  SD1.D1_FILIAL   = %xFilial:SD1%
	    and SD1.D1_COD      = %Exp:cProd%
	    and SD1.D1_DOC      = SF1.F1_DOC
	    and SD1.D1_SERIE    = SF1.F1_SERIE
	    and SD1.D1_FORNECE  = SF1.F1_FORNECE
	    and SD1.D1_LOJA     = SF1.F1_LOJA
	    and SD1.D1_FORMUL   = SF1.F1_FORMUL
	    and SD1.D1_ORIGLAN != 'LF'
	    and SD1.D1_REMITO   = '         '
	    and SD1.D_E_L_E_T_  = ' '
	inner join
	        %table:SF4% SF4
	    on  SF4.F4_FILIAL  = %xFilial:SF4%
	    and SF4.F4_CODIGO  = SD1.D1_TES
	    and SF4.F4_ESTOQUE = 'S'
	    and SD1.D_E_L_E_T_ = ' '
	where
	    SF1.F1_FILIAL  = %xFilial:SF1%
	and SF1.F1_DTDIGIT >= %Exp:DtoS(mvpar01)%
	and SF1.F1_DTDIGIT <= %Exp:DtoS(mvpar02)%
	and SF1.D_E_L_E_T_ = ' '
	group by SF1.F1_DTDIGIT
	order by SF1.F1_DTDIGIT
endSql

//--Fecha Alias Temporario se estiver aberto
If Select(cSd2) > 0
	dbSelectArea(cSd2)
	dbCloseArea()
Endif

//--Consulta as Previs�es de venda
beginSql Alias cSd2
	select 
	    SF2.F2_DTDIGIT    as data
	,   sum(SD2.D2_QUANT) as quant
	from
	    %table:SF2% SF2
	inner join
	        %table:SD2% SD2
	    on  SD2.D2_FILIAL   = %xFilial:SD2%
	    and SD2.D2_COD      = %Exp:cProd%
	    and SD2.D2_DOC      = SF2.F2_DOC
	    and SD2.D2_SERIE    = SF2.F2_SERIE
	    and SD2.D2_CLIENTE  = SF2.F2_CLIENTE
	    and SD2.D2_LOJA     = SF2.F2_LOJA
	    and SD2.D2_FORMUL   = SF2.F2_FORMUL
	    and SD2.D2_ORIGLAN != 'LF'
	    and SD2.D2_TPDCENV != '1A'
	    and SD2.D2_REMITO   = '         '
	    and SD2.D_E_L_E_T_  = ' '
	inner join
	        %table:SF4% SF4
	    on  SF4.F4_FILIAL  = %xFilial:SF4%
	    and SF4.F4_CODIGO  = SD2.D2_TES
	    and SF4.F4_ESTOQUE = 'S'
	    and SD2.D_E_L_E_T_ = ' '
	where
	    SF2.F2_FILIAL  = %xFilial:SF4%
	and SF2.F2_DTDIGIT >= %Exp:DtoS(mvpar01)%
	and SF2.F2_DTDIGIT <= %Exp:DtoS(mvpar02)%
	and SF2.D_E_L_E_T_ = ' '
	group by SF2.F2_DTDIGIT
	order by SF2.F2_DTDIGIT
endSql

Return

/*-----------------+---------------------------------------------------------+
!Nome              ! U_MRPFSld                                                  !
+------------------+---------------------------------------------------------+
!Descri��o         ! Calcula saldo do produto para todos os armazem para o   !
!                  ! dia expecificado                                        !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 20/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
User Function MRPFSld(cProd,lReaf) 

Local nRet := 0

default lReaf := .F.

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial()+cProd)

//--Seleciona tabela de Saldos
dbSelectArea("SB2")
dbSetOrder(1)
dbSeek(xFilial()+cProd)

While !Eof() .And. SB2->B2_FILIAL+SB2->B2_COD == xFilial("SB2")+cProd
	
	//--Pega somente a primeira possi��o do vetor de retorno
	//nRet += CalcEst(cProd,SB2->B2_LOCAL,dData)[1]
	nRet += SB2->B2_QATU
	
	//--Proxima linha
	SB2->(dbSkip())

Enddo

//--Ferramenta reafiada 
//--Se o quarto digito do do produto for <> 5
//--e se B1_TIPO diferente de "PA"
//--Podera ter uma ferramenta reafiada
If subStr(cProd,4,1) <> "5" .And. lReaf

	//--Verifica se Existe o produto
	If SB1->(dbSeek(xFilial()+subStr(cProd,1,3)+"5"+subStr(cProd,5,11)))

		SB2->(dbSeek(xFilial()+subStr(cProd,1,3)+"5"+subStr(cProd,5,11)))
		
		While !Eof() .And. SB2->B2_FILIAL+SB2->B2_COD == xFilial("SB1")+subStr(cProd,1,3)+"5"+subStr(cProd,5,11)
			
			//--Pega somente a primeira possi��o do vetor de retorno
			nRet += SB2->B2_QATU
			
			//--Proxima linha
			SB2->(dbSkip())
		
		Enddo

	Endif

Endif

Return nRet

/*-----------------+---------------------------------------------------------+
!Nome              ! pBuscaValor                                             !
+------------------+---------------------------------------------------------+
!Descri��o         ! Pega saldo de entradas ou saida ou provisao do dia      !
!                  ! especificado, de acordo com o alias passado             !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 20/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
Static Function pBuscaValor(xAl,dData) 

Local nRet := 0

//--Verifica se arquivo n�o esta em EOF
//--e se a data � igual ao do parametro
//--nunca sera menor
If !(xAl)->(Eof()) .And. DtoS(dData) == (xAl)->data
	
	//--Pega quantidade
	nRet := (xAl)->quant

	//--Proxima linha
	(xAl)->(dbSkip())

Endif

Return nRet

/*-----------------+---------------------------------------------------------+
!Nome              ! bOutNecess                                              !
+------------------+---------------------------------------------------------+
!Descri��o         ! faz o calculo da necessidade de todas as pe�as          !
!                  ! onde a ferramenta � aplicada                            !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 05/07/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa                                     !
+------------------+--------------------------------------------------------*/
Static Function bOutNecess(xAl,dData)

Local nRet := 0
Local nZDJRec := ZDJ->(Recno()) //guarda a posi��o da tabela ZDJ

//--Verifica se arquivo n�o esta em EOF
//--e se a data � igual ao do parametro
//--nunca sera menor
While !(xAl)->(Eof()) .And. DtoS(dData) == (xAl)->data
	          
	ZDJ->(dbGoTo((xAl)->zdj_recno))

	//--Pega quantidade
	nRet += U_MRPFConP((xAl)->quant)[1]

	//--Proxima linha
	(xAl)->(dbSkip())

EnddO

ZDJ->(dbGoTo(nZDJRec)) //Retorna a posicao da tabela ZDJ

Return nRet

/*-----------------+---------------------------------------------------------+
!Nome              ! U_MRPFConP                                              !
+------------------+---------------------------------------------------------+
!Descri��o         ! Calcula o Consumo Planejado da ferramenta de acordo com !
!                  ! previsao de vendas e indices da tabela ZDJ              !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 22/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa                                     !
+------------------+--------------------------------------------------------*/
User Function MRPFConP(nVol) 
Local nRet := 0
Local nVidaUt

	//calcula a Vida util
    If Subs(ZDJ->ZDJ_FERRAM,1,4) $ 'FE33/FE53'
   		nVidaUt := Round( ((ZDJ->ZDJ_VUMONT * (ZDJ->ZDJ_QTREAF+1) * ZDJ->ZDJ_ARESTA) / ZDJ->ZDJ_FMONT ),2)     
   	Else
     	nVidaUt := Round(  (ZDJ->ZDJ_VUMONT * (ZDJ->ZDJ_QTREAF+1)),2)
   	Endif

	//calcula o consumo planejado
	nRet := nVol / nVidaUt

Return {nRet,nVidaUt}


/*-----------------+---------------------------------------------------------+
!Nome              ! bCusto                                                  !
+------------------+---------------------------------------------------------+
!Descri��o         ! Pega o valor da �ltima compra do produto                !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 27/04/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa									 !
+------------------+--------------------------------------------------------*/

/*
static Function bCusto()

Local cAz := "TMPULTCOM"
Local nRet := 0

beginSql Alias cAz
	select
	    TOP 1
	    SD1.D1_CUSTO as custo, SD1.D1_QUANT AS qtde
	from
	    %table:SD1% SD1
	inner join
	        %table:SF4% SF4
	    on  SF4.F4_FILIAL  = %xFilial:SF4%
	    and SF4.F4_CODIGO  = SD1.D1_TES
	    and SF4.F4_ESTOQUE = 'S'
	    and SD1.D_E_L_E_T_ = ' '
	inner join
	        %table:SA2% SA2
	    on  SA2.A2_FILIAL = %xFilial:SA2%
	    and SA2.A2_COD    = SD1.D1_FORNECE
	    and SA2.A2_LOJA   = SD1.D1_LOJA
	    and SA2.D_E_L_E_T_ = ' '
	where
	    SD1.D1_FILIAL   = %xFilial:SD1%
	and SD1.D1_COD      = %Exp:ZDJ->ZDJ_FERRAM%
	and SD1.D1_ORIGLAN != 'LF'
	and SD1.D1_QUANT   != 0
	and SD1.D1_REMITO   = '         '
	and SD1.D_E_L_E_T_  = ' '
	order by SD1.D1_DTDIGIT DESC , D1_NUMSEQ DESC
endSql

If !(cAz)->(Eof())
	nRet := (cAz)->custo/(cAz)->qtde //--Ultimo custo unit / quant
Endif

(cAz)->(dbCloseArea())

Return nRet
*/

User Function MRPFVUFor(cProd,cTipo)
Local aArr   := {0,""}
Local cAlias := 'TMP3'
Local nSB1Rec := SB1->(Recno())          
	
    beginSql Alias cAlias
		select
		    TOP 1
		    SD1.D1_CUSTO as custo, SD1.D1_QUANT AS qtde,
	        SD1.D1_FORNECE+SD1.D1_LOJA as fornece
	
		from
		    %table:SD1% SD1
		inner join
		        %table:SF4% SF4
		    on  SF4.F4_FILIAL  = %xFilial:SF4%
		    and SF4.F4_CODIGO  = SD1.D1_TES
		    and SF4.F4_ESTOQUE = 'S'
		    and SD1.D_E_L_E_T_ = ' '
		inner join
		        %table:SA2% SA2
		    on  SA2.A2_FILIAL = %xFilial:SA2%
		    and SA2.A2_COD    = SD1.D1_FORNECE
		    and SA2.A2_LOJA   = SD1.D1_LOJA
		    and SA2.D_E_L_E_T_ = ' '
		where
		        SD1.D1_FILIAL   = %xFilial:SD1%
			and SD1.D1_COD      = %Exp:cProd%
			and SD1.D1_ORIGLAN != 'LF'
			and SD1.D1_QUANT   != 0	
			and SD1.D1_REMITO   = '         '
			and SD1.D_E_L_E_T_  = ' '
		order by SD1.D1_DTDIGIT DESC , D1_NUMSEQ DESC
   	endSql

   	If !(cAlias)->(Eof())
  	 	aArr[1] := (cAlias)->custo/(cAlias)->qtde //--Ultimo valor de custo
  	    aArr[2] := (cAlias)->fornece //--Fornecedor do Ultimo valor de custo
   	Else
  	    aArr[1] := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_VFER"+cTipo) // Busca o ultimo preco no cadastro do produto
 	    aArr[2] := " "
 	Endif

   	(cAlias)->(dbCloseArea())
   	SB1->(Dbgoto(nSB1Rec)) // volta o registro da ferramenta

Return aArr


/*-----------------+----------------------------------------------------------+
!Nome              ! U_MRPFQPCA                                               !
+------------------+----------------------------------------------------------+
!Descri��o         ! Traz a quantidade de PC em aberta para a Ferramenta      !
+------------------+----------------------------------------------------------+
!Data de Cria��o   ! 05/07/2010                                               !
+------------------+----------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa								      !
+------------------+---------------------------------------------------------*/
User Function MRPFQPCA(cFer)
Local nQuant := 0
Local cAlias := getNextAlias()

   	beginSql Alias cAlias


	select
	    TOP 1
	    SC7.C7_PRODUTO as prod, SUM(SC7.C7_QUANT-SC7.C7_QUJE) AS qtdeped
	from
	    %table:SC7% SC7
	where
	    SC7.C7_FILIAL = %xFilial:SC7%
		and SC7.C7_PRODUTO = %Exp:cFer%
    	and SC7.C7_RESIDUO != 'S'
    	and SC7.C7_QUJE < SC7.C7_QUANT    
    	and SUBSTRING(SC7.C7_PRODUTO,1,4) IN ('FE31','FE32','FE33','FE35','FE51','FE52','FE53','FE55')
		and SC7.C7_ENCER != 'E'
		and SC7.D_E_L_E_T_  = ' '
		group by SC7.C7_PRODUTO

   	endSql   	
   	
   	If !(cAlias)->(Eof())
  	     nQuant := (cAlias)->qtdeped //--Qtde dos pedidos em abertos
   	Endif

   	(cAlias)->(dbCloseArea())

Return nQuant


/*-----------------+----------------------------------------------------------+
!Nome              ! U_MRPFQSCA                                               !
+------------------+----------------------------------------------------------+
!Descri��o         ! Traz a quantidade de SC em aberta para a Ferramenta      !
+------------------+----------------------------------------------------------+
!Data de Cria��o   ! 02/02/2011                                               !
+------------------+----------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa								      !
+------------------+---------------------------------------------------------*/
User Function MRPFQSCA(cFer)
Local nQuant := 0
Local cAlias := getNextAlias()

   	beginSql Alias cAlias

		select
		    TOP 1
		    SC1.C1_PRODUTO as prod, SUM(SC1.C1_QUANT-SC1.C1_QUJE) AS qtdeped
		from
		    %table:SC1% SC1
		where
		    SC1.C1_FILIAL = %xFilial:SC1%
			and SC1.C1_PRODUTO = %Exp:cFer%
	    	and SC1.C1_RESIDUO != 'S'
	    	and SC1.C1_QUJE < SC1.C1_QUANT    
	    	and SUBSTRING(SC1.C1_PRODUTO,1,4) IN ('FE31','FE32','FE33','FE35','FE51','FE52','FE53','FE55')
			and SC1.D_E_L_E_T_  = ' '
			group by SC1.C1_PRODUTO

   	endSql   	
   	
   	If !(cAlias)->(Eof())
  	     nQuant := (cAlias)->qtdeped //--Qtde dos pedidos em abertos
   	Endif

   	(cAlias)->(dbCloseArea())

Return nQuant

/*-----------------+---------------------------------------------------------+
!Nome              ! GravaTMP                                                !
+------------------+---------------------------------------------------------+
!Descri��o         ! Grava��o no Arquivo temporario                          !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 22/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function GravaTMP(aDados,cTipo,cCodigo,cProd,cFerr,cOP,nZDJRecno)

Local xD

//--Montagem do Vetor para montagem do dbTree
aAdd(aTree,{cTipo,cCodigo,cProd,cFerr,cOP,nZDJRecno})

//--Percorre as linhas do vetor bidimencial
For nX := 1 To Len(aDados[1])

	//--Recebe valor do parametro de data inicial
	xD := mvpar01

	//--Grava��o
	RecLock(cAl,.T.)

	(cAl)->DBTREE := cCodigo
	(cAl)->PRODUT := cProd
	(cAl)->FERRAM := cFerr
	(cAl)->SEQ    := Str(nX,1)
	(cAl)->TIPO   := cTipo
	
	//--Se o Tipo igual a F
	If cTipo == "F"
		//--Grava Centro de Custo e Opera��o
		(cAl)->OPERAC := ZDJ->ZDJ_OP
		(cAl)->CCUSTO := ZDJ->ZDJ_CC
	Endif

	//--Percore as colunas
	For nY := 1 to Len(aDados)

		//--Grava nas datas
		(cAl)->&("C"+DtoS(xD)) := aDados[nY,nX]
		//--Adiciona 1 a data atual
		xD++

	Next
	
	MsUnLock()

Next

Return

/*-----------------+---------------------------------------------------------+
!Nome              ! pWhbView                                                !
+------------------+---------------------------------------------------------+
!Descri��o         ! Mostra tela de visualiza��o e confirma��o               !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 18/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function pWhbView()

Local oTree
Local oDlg
Local oPanel
Local oFont
Local aSize   := MsAdvSize()
Local nTop    := aSize[7]+23
Local nLeft   := 0+5
Local nBottom := aSize[6]-60
Local nRight  := aSize[5]-10
Local aButtons := {}

Private oQuant
Private oCusto

Define Font oFont  Name "Arial" SIZE 0,-9
Define Font oFont2 Name "Arial" SIZE 0,-12 Bold
Define MsDialog oDlg Title "MRP - Ferramentas" OF oMainWnd Pixel From nTop,nLeft To nBottom,nRight

//--Teste para ver se consulta fical mais Rapida
ultimaCompra("")

//-- botao para trazer o historico de entradas
aAdd(aButtons,{"HISTORIC",{||fHistEnt(oTree)},"Hist�rico mensal de entradas da Ferramenta","Hist�rico"})

//--Cria um painel
oPanel := TPanel():New(17,160,'',oDlg,oDlg:oFont,.T.,.T.,,,(nRight-nLeft)/2-160,((nBottom)/2)-2,.T.,.T. )

//--Coloca o dbTree dentro do painel
oTree := dbTree():New(17, 2,((nBottom)/2)+16,159,oDlg,,,.T.)
oTree:bChange := {|| mudaClique(@oTree,{0,0,((nBottom-nTop)/2)+17,(nRight-nLeft)/2-160},@oPanel) }
oTree:SetFont(oFont)
oTree:lShowHint := .F.

//--Monta o dbTree
MontaTree(@oTree)
mudaClique(@oTree,{0,0,((nBottom-nTop)/2)+17,(nRight-nLeft)/2-160},@oPanel)

//--Legenda
@ ((nBottom)/2)+18,05 Bitmap oBmp Resname "PMSEDT2" Of oDlg Size 8,8 Adjust NoBorder When .F. Pixel
@ ((nBottom)/2)+18,43 Bitmap oBmp Resname "PMSEDT3" Of oDlg Size 8,8 Adjust NoBorder When .F. Pixel
TSay():New(((nBottom)/2)+19,15,{||"Produto"   },oDlg,,oFont2,,,,.T.,CLR_BLUE,,,,,,,,)
TSay():New(((nBottom)/2)+19,53,{||"Ferramenta"},oDlg,,oFont2,,,,.T.,CLR_BLUE,,,,,,,,)

Activate MsDialog oDlg On Init EnchoiceBar(oDlg,{||oDlg:End(),Processa({||pWhbAglut()})},{||oDlg:End()},,aButtons)

Return

/*-----------------+---------------------------------------------------------+
!Nome              ! fHistEnt                                                !
+------------------+---------------------------------------------------------+
!Descri��o         ! Mostra tela de hist�rico de entradas das ferramentas    !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 09/07/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa                                     !
+------------------+--------------------------------------------------------*/
Static Function fHistEnt(oTree)
Local cFer              
Local aAlter       	:= {}
Local nOpc         	:= 0
Local cLinhaOk     	:= "AllwaysTrue"
Local cTudoOk      	:= "AllwaysTrue"
Local cIniCpos     	:= ""
Local nFreeze      	:= 0
Local nMax         	:= 12
Local cCampoOk     	:= "AllwaysTrue"
Local cSuperApagar 	:= ""
Local cApagaOk     	:= "AllwaysTrue"
Local aHead        	:= {}
Local aCol         	:= {}
Local nMesAtu       := Month(date())
Local nAnoAtu       := Year(date())

	cFer := subStr(oTree:GetPrompt(),1,15)
	
	//pega as entradas dos meses anteriores ao mes atual
	//ate o mes de janeiro
	For xM:=(nMesAtu-1) to 1 Step -1
		aAdd(aCol,{UPPER(Substr(MesExtenso(xM),1,3) + '/' + StrZero(nAnoAtu,4)),; //mes / ano
				   fQEntMes(cFer,StrZero(xM,2),StrZero(nAnoAtu,4)),; //quantidade de entradas no mes / ano
				   fQConMes(cFer,StrZero(xM,2),StrZero(nAnoAtu,4)),; //quantidade de consumo no mes / ano
				   .F.}) //flag deletado
	Next
	
	//se o mes atual for diferente de janeiro
	//deve trazer tambem o restante de entradas do ano anterior
	If nMesAtu<>1
		nAnoAtu -= 1 //diminui o ano atual
		For xM:=12 to nMesAtu Step -1
			aAdd(aCol,{UPPER(Substr(MesExtenso(xM),1,3) + '/' + StrZero(nAnoAtu,4)),; //mes / ano
					   fQEntMes(cFer,StrZero(xM,2),StrZero(nAnoAtu,4)),; //quantidade de entradas no mes / ano
					   fQConMes(cFer,StrZero(xM,2),StrZero(nAnoAtu,4)),; //quantidade de consumo no mes / ano
					   .F.}) //flag deletado
		Next
	EndIf
	
	Define MsDialog oDlgHist Title "Hist�rico de Entradas - "+cFer OF oMainWnd Pixel From 0,0 To 320,400
	
	TSay():New(05,05,{||"Ferramenta: " + cFer   },oDlgHist,,oFont2,,,,.T.,CLR_BLUE,,,,,,,,)
	
    tButton():New(145,155,"Fechar",oDlgHist,{||oDlgHist:End()},40,10,,,,.T.)

	//--Campo Fixo
	aAdd(aHead,{'M�s'      ,"MES","",20,0,'AllWaysTrue()','.t.','C','','V',,,'.F.'})
	aAdd(aHead,{'Entradas' ,"QTD","",10,0,'AllWaysTrue()','.t.','C','','V',,,'.F.'})
	aAdd(aHead,{'Consumo'  ,"QTD","",10,0,'AllWaysTrue()','.t.','C','','V',,,'.F.'})
		
	oGetDHist := MsNewGetDados():New(15,05,140,195,nOpc,cLinhaOk,cTudoOk,cIniCpos,;
	aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDlgHist,aHead,aCol)
	
	Activate MsDialog oDlgHist Centered
	
Return

/*-----------------+---------------------------------------------------------+
!Nome              ! mudaClique                                              !
+------------------+---------------------------------------------------------+
!Descri��o         ! Fun��o responsavel por atualizar o scroll com os informa!
!                  ! ��es do item do Tree clicado                            !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 18/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function mudaClique(oTree,aPos,oPanel)

Local cProd := ""
Local cCor := CLR_BLUE
Local aProd := {"Saldo Estoque",;
				"Entrada",;
				"Sa�da",;
				"Saldo Estoque",;
				"Necessidade"}
Local aFerr := {"Saldo Estoque",;
				"Necessidade",;
				"Outras Necessidades",;
				"Qtde Comprar",;
				"Custo Unit�rio",;
				"Custo Total"} 
				
Local aDados := {}
Local aRet   := {}
Local aVet   := {}
Local nQtdPC := 0
Local nQtdSC := 0 
Local nConAte := 0
Local nSaldoN := 0
Local nSaldoR := 0
Local nEmin   := 0
Local nSomaEmin := 0

Define Font oFont  Name "Arial" Size 0,-15 Bold
Define Font oFont2 Name "Arial" Size 0,-11 Bold

//--Oculta painel
oPanel:Hide()
oPanel:FreeChildren()

//--Se for produto
If subStr(oTree:GetCargo(),1,1) == "P"

	//--Monta Scroll
	oScroll := TScrollBox():New(oPanel,aPos[1],aPos[2],aPos[3],aPos[4])
	TSay():New(10,05,{||"PREVIS�O DE VENDAS"},oScroll,,oFont,,,,.T.,cCor,,,,,,,,)

    //--MontaGetDados
    //--1.Vetor com a posi��o do GetDados
    //--Objeto oScroll
    //--Objeto oTree
    //--Vetor com a descri��o das linhas (coluna tipo)
	aVet := MontaGetDados({30,2,95,aPos[4]-5},@oScroll,@oTree,aProd,".F.")
	
	TSay():New(110,05,{||"TOTAL A PRODUZIR: " + AllTrim(str(aVet[5])) },oScroll,,oFont2,,,,.T.,cCor,,,,,,,,)
	
    
//--Se for ferramenta	
Else

	//--Busca dados da ultima compra
	cProd := subStr(oTree:GetPrompt(),1,15)
	aDados := ultimaCompra(cProd)

	//-- pega a quantidade de pedidos de compra em aberto
	nQtdPC := U_MRPFQPCA(cProd)
	//-- pega a quantidade de sc em aberto
	nQtdSC := U_MRPFQSCA(cProd)
	
	nConAte := U_MRPFCons(cProd,date(),mv_par01-1)

	nSaldoN   := U_MRPFSld(cProd)
	nSaldoR   := U_MRPFSld(cProd,.T.) - nSaldoN
	nEmin     := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_EMIN")
   
	//--Monta scroll 
	oScroll := TScrollBox():New(oPanel,aPos[1],aPos[2],aPos[3],aPos[4])
	TSay():New(10,05,{||"DADOS DE COMPRA"},oScroll,,oFont,,,,.T.,cCor,,,,,,,,)

	TSay():New(25,05,{||"Ultimo Fornecedor:"}                 ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(25,60,{||allTrim(aDados[1])}                   ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)
	TSay():New(34,05,{||"Ultimo Pre�o:"}                      ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(34,60,{||TransForm(aDados[2],"999,999,999.99")},oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)
	TSay():New(43,05,{||"Quantidade:"}                        ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(43,60,{||TransForm(aDados[3],"999,999,999.99")},oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)
	TSay():New(52,05,{||"Data:"}                              ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(52,60,{||DtoC(StoD(aDados[4]))}                ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)
	TSay():New(61,05,{||"Valor Total:"}                       ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(61,60,{||TransForm(aDados[5],"999,999,999.99")},oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)
	TSay():New(70,05,{||"Saldo produto novo: "+cProd}         ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(70,60,{||transForm(nSaldoN,"999,999,999.99")}  ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)
	
	cProd := subStr(cProd,1,3)+"5"+subStr(cProd,5,11)
	dbSelectArea("SB1")
	dbSetOrder(1)

	If dbSeek(xFilial("SB1")+cProd) .And. subStr(oTree:GetPrompt(),4,1) <> "5"
		TSay():New(79,05,{||"Saldo produto reafiado: "+cProd}          ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
		TSay():New(79,60,{||transForm(nSaldoR,"999,999,999.99")} ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)
	Else
		TSay():New(79,05,{||"Saldo produto reafiado:"}                 ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
		TSay():New(79,60,{||"N�o Encontrado"}                          ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)
	Endif
	
	//-- MontaGetDados
    //-- 1.Vetor com a posi��o do GetDados
    //-- Objeto oScroll
    //-- Objeto oTree
    //-- Vetor com a descri��o das linhas (coluna tipo)
	aRet := MontaGetDados({136,2,208,aPos[4]-5},@oScroll,@oTree,aFerr,".F.")

	nSomaEmin := 0
	    
	nNecTot := CEILING(aRet[3] + aRet[2]) + nConAte
	
	nNecTot -= nSaldoR
	
	If nNecTot <= 0
		nSomaEmin := nEmin - (nSaldoN + nQtdPC + nQtdSC)
	Else
		nNecTot -= (nSaldoN + nQtdPC + nQtdSC)
		
		If nNecTot <= 0 
			nSomaEmin := nNecTot + nEmin
		Else
			nSomaEmin := nEmin
		EndIf
	EndIf

	nNecTot := Iif(nNecTot < 0,0,nNecTot) //se for menor que zero, recebe zero
	
	aRet[4] += Iif(nSomaEmin>0,nSomaEmin,0) //se o estoque for menor que o estoque minimo, soma a diferenca a necessidade
	
	//-- Arredonda o valor total a comprar
    aRet[4] := Ceiling(aRet[4])
   
	TSay():New(88,05,{||"Qtde em Pedidos em Aberto: "}                  ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(88,60,{||Transform(nQtdPC,"999,999,999.99")}             ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)

	TSay():New(97,05,{||"Consumo planejado para este produto:" }        ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(97,60,{|| TransForm(aRet[2],"999,999,999.99")}           ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)

	TSay():New(106,05,{||"Total outras necessidades:" }                 ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(106,60,{|| TransForm(aRet[3],"999,999,999.99")}          ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)

	TSay():New(115,05,{||"Consumo at� "+DtoC(mvpar01) }                 ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(115,60,{|| TransForm(Ceiling(nConAte),"999,999,999.99")} ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)

	TSay():New(124,05,{||"Estoque m�nimo " }                            ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(124,60,{|| TransForm(Ceiling(nEmin),"999,999,999.99")}   ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)

	TSay():New(211,05,{||"TOTAL GERAL"}             		            ,oScroll,,oFont ,,   ,,.T.,cCor,,   , ,,,,,)
	TSay():New(226,05,{||"Qtde Total Comprar:"}         		        ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	oQuant:= TSay():New(226,60,{||TransForm(aRet[4],"999,999,999.99")}  ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)
	TSay():New(235,05,{||"Valor Total:"}                    	        ,oScroll,,oFont2,,   ,,.T.,cCor,,   , ,,,,,)
	oCusto:= TSay():New(235,60,{||TransForm(aRet[6],"999,999,999.99")}  ,oScroll,,oFont2,,.t.,,.T.,cCor,,190,8,,,,,)

Endif

//--Mostra Painel
oPanel:Show()

Return

/*-----------------+---------------------------------------------------------+
!Nome              ! MontaTree                                               !
+------------------+---------------------------------------------------------+
!Descri��o         ! Popula/monta os dados no dbTree                         !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 18/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function MontaTree(oTree)

oTree:Hide()
oTree:Reset()
oTree:BeginUpdate()

oTree:TreeSeek("")

//--Percorre o Vetor para montar o tree
For nK := 1 to Len(aTree)

	//--Se for Tipo = P adiciona no nivel 1
	If aTree[nK,1] == "P"

		//--Adiciona item no nivel 1 do tree
		oTree:AddItem(aTree[nK,3]+" / "+Posicione("SB1",1,xFilial("SB1")+aTree[nK,3],"B1_DESC"),aTree[nK,2],"PMSEDT2",,,,1)
		//--Da um seek no nivel recem adicionado
		oTree:TreeSeek(aTree[nK,2])
	
	//--Se for tipo = F adiciona no nivel 2
	Else
		
		//--Adiciona item no segundo nivel, embaixo do ultimo primeiro
		oTree:AddItem(aTree[nK,4]+" / "+aTree[nK,5]+" / "+Posicione("SB1",1,xFilial("SB1")+aTree[nK,4],"B1_DESC"),aTree[nK,2],"PMSEDT3",,,,2)	

    Endif                     

Next

oTree:Refresh()
oTree:EndUpdate()

//--Volta para primeiro registro do tree
oTree:TreeSeek(aTree[1,2])

oTree:Show()

Return

/*-----------------+---------------------------------------------------------+
!Nome              ! MontaGetDados                                           !
+------------------+---------------------------------------------------------+
!Descri��o         ! Fun��o responsavel pela montagem da getDados para       !
!                  ! produtos e ferramentas                                  !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 19/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function MontaGetDados(aPos,oScroll,oTree,aLinhas,cWhen)

Local aAlter       	:= {}
Local nOpc         	:= 0
Local cLinhaOk     	:= "AllwaysTrue"
Local cTudoOk      	:= "AllwaysTrue"
Local cIniCpos     	:= ""
Local nFreeze      	:= 0
Local nMax         	:= 6
Local cCampoOk     	:= "AllwaysTrue"
Local cSuperApagar 	:= ""
Local cApagaOk     	:= "AllwaysTrue"
Local aHead        	:= {}
Local aCol         	:= {}
Local aDados := {}
Local aRet := {0,0,0,0,0,0}

//--Campo Fixo
aAdd(aHead,{'Tipo',"TIPO","",20,0,'AllWaysTrue()','.t.','C','','V',,,'.F.'})
aAdd(aDados,"Tipo")

//--Campos Data, variavel
For xD := mvpar01 to mvpar02
	aAdd(aHead,{DtoC(xD),"C"+DtoS(xD),'@E 999,999,999.99',12,2,"u_vFerr(M->C"+DtoS(xD)+",'C"+DtoS(xD)+"','"+oTree:GetCargo()+"')",'.t.','N','','V',,,cWhen})
	aAdd(aAlter,"C"+DtoS(xD))
Next

dbSelectArea(cAl)
(cAl)->(dbGoTop())
(cAl)->(dbSetOrder(1))

For nX := 1 To Len(aLinhas)

	//--Inicia com vetor auxiliar limpo
	aAux := {}

	//--Localiza o registro no arquivo temporario
	(cAl)->(dbSeek(oTree:GetCargo()+Str(nX,1)))
	
	//--Primeira coluna � do tipo
	aAdd(aAux,aLinhas[nX])

	//--Colunas com datas recebe valor
	For xD := mvpar01 To mvpar02
		aAdd(aAux,(cAl)->&("C"+DtoS(xD)))
		aRet[nX] += (cAl)->&("C"+DtoS(xD))
	Next

	//--Flag de registro deletado/n�o deletado
	aAdd(aAux,.F.)

	//--Adiciona a Linha no aCols
	aAdd(aCol,aClone(aAux))
Next

oGetDados := MsNewGetDados():New(aPos[1],aPos[2],aPos[3],aPos[4],nOpc,cLinhaOk,cTudoOk,cIniCpos,;
aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oScroll,aHead,aCol)

oGetDados:Refresh()

Return(aRet)

/*-----------------+---------------------------------------------------------+
!Nome              ! vFerr                                                   !
+------------------+---------------------------------------------------------+
!Descri��o         ! Atualiza��o do GetDados quando alterado campo Necessidade
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 24/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
user Function vFerr(nValor,cCampo,cCodTree)

Local aDados := {}
Local aAux := {}
Local nSaldo := {}
Local nQuant := 0
Local nCusto := 0

//--Se o usuario clicar e n�o alterar o valor n�o tem pq processar a atualiza��o
//--S� atualiza se for diferente
If oGetDados:aCols[oGetDados:nAt,aScan(oGetDados:aHeader,{|x|allTrim(x[2])==cCampo})] != nValor

	//--Como � valida��o o campo ainda n�o recebeu o valor digitado
	oGetDados:aCols[oGetDados:nAt,aScan(oGetDados:aHeader,{|x|allTrim(x[2])==cCampo})] := nValor
	
	//--Agora inverto colunas e linhas (mais facil de trabalhar)
	//--Percorre as linhas do vetor bidimencial
	//--Come�a da Coluna 2 (ignora TIPO) e termina no ultima coisa -1 (flag deletado)
	For nX := 2 To Len(oGetDados:aCols[1])-1
	
		//--Limpa vetor
		aAux := {}
	
		//--Percore as colunas
		For nY := 1 to Len(oGetDados:aCols)
	
			//--Adiciona ao vetor auxiliar as colunas de uma linha
			aAdd(aAux,oGetDados:aCols[nY,nX])
	
		Next
	
		//--Adiciona o vetor principal a linhas inteira
		aAdd(aDados,aClone(aAux))
	
	Next


	cMsg := ""
	For x := 1 to Len(aDados)
		cMsg += alltrim(str(aDados[x,1]))+"|"
		cMsg += alltrim(str(aDados[x,2]))+"|"
		cMsg += alltrim(str(aDados[x,3]))+"|"
		cMsg += alltrim(str(aDados[x,4]))+"|"
		cMsg += alltrim(str(aDados[x,5]))+chr(13)+chr(10)
	Next


	//--Pego o saldo Inicial
	nSaldo := aDados[1,1]
	
	//--Reprocessamento dos dados da Ferramento conforme altera��o da Necessidade
	For nS := 1 to Len(aDados)

		aDados[nS,1] := nSaldo

		//--Calcula saldo do pr�ximo dia
		//--Saldo inicial - Necessidade
		//--Se saldo for maior oi igual
		If (nSaldo >= aDados[nS,2])

			//--Subtrai do saldo
			nSaldo -= aDados[nS,2]
			
			//--e zera qtde a comprar
			aDados[nS,3] := 0
		
		//--se o saldo for menor
		Else

			//--Subtrai da qtde a comprar
			aDados[nS,3] := aDados[nS,2]
			aDados[nS,3] -= nSaldo

			//--zera saldo
			nSaldo := 0

		Endif

		//--Atualiza valor total
		aDados[nS,5] := aDados[nS,3]*aDados[nS,4]

		nQuant += aDados[nS,3]
		nCusto += aDados[nS,5]

	Next

	cMsg := ""
	For x := 1 to Len(aDados)
		cMsg += alltrim(str(aDados[x,1]))+"|"
		cMsg += alltrim(str(aDados[x,2]))+"|"
		cMsg += alltrim(str(aDados[x,3]))+"|"
		cMsg += alltrim(str(aDados[x,4]))+"|"
		cMsg += alltrim(str(aDados[x,5]))+chr(13)+chr(10)
	Next


	//--Depois de Re-Processado atualizado o GetDados e o Arquivo temporario
	For nX := 1 To Len(aDados[1])

		//--Recebe valor do parametro de data inicial
		xD := mvpar01

		//--Localiza o registros no arquivo temporario
		dbSelectArea(cAl)
		(cAl)->(dbSeek(cCodTree+Str(nX,1)))

		//--Altera��o
		RecLock(cAl,.F.)
		
		//--Percore as colunas
		For nY := 1 to Len(aDados)

			//--Grava nas datas
			(cAl)->&("C"+DtoS(xD)) := aDados[nY,nX]

			//--Atualiza do GetDados
			oGetDados:aCols[nX,nY+1] := aDados[nY,nX]

			//--Adiciona 1 a data atual
			xD++
	
		Next
	
		MsUnLock()
	
	Next

	oQuant:cCaption := TransForm(nQuant,"999,999,999.99")
	oCusto:cCaption := TransForm(nCusto,"999,999,999.99")
	
	//--Atualiza o GetDados
	oGetDados:Refresh()

Endif

Return(.T.)

/*-----------------+---------------------------------------------------------+
!Nome              ! ultimaCompra                                            !
+------------------+---------------------------------------------------------+
!Descri��o         ! Consuta dados da ultima compra                          !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 23/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function ultimaCompra(cProd)

Local cAz := "TMPULTCOM"
Local aRet := {}

beginSql Alias cAz
	select
	    TOP 1
	    SD1.D1_DTDIGIT as data
	,   SA2.A2_NOME    as nome
	,   SD1.D1_FORNECE as cod
	,   SD1.D1_LOJA    as loja
	,   SD1.D1_QUANT   as quant
	,   SD1.D1_CUSTO   as custo
	,   SD1.D1_TOTAL   as total
	from
	    %table:SD1% SD1
	inner join
	        %table:SF4% SF4
	    on  SF4.F4_FILIAL  = %xFilial:SF4%
	    and SF4.F4_CODIGO  = SD1.D1_TES
	    and SF4.F4_ESTOQUE = 'S'
	    and SD1.D_E_L_E_T_ = ' '
	inner join
	        %table:SA2% SA2
	    on  SA2.A2_FILIAL = %xFilial:SA2%
	    and SA2.A2_COD    = SD1.D1_FORNECE
	    and SA2.A2_LOJA   = SD1.D1_LOJA
	    and SA2.D_E_L_E_T_ = ' '
	where
	    SD1.D1_FILIAL   = %xFilial:SD1%
	and SD1.D1_COD      = %Exp:cProd%
	and SD1.D1_ORIGLAN != 'LF' 
	and SD1.D1_QUANT   != 0	
	and SD1.D1_REMITO   = '         '
	and SD1.D_E_L_E_T_  = ' '
	order by SD1.D1_DTDIGIT DESC , D1_NUMSEQ DESC
endSql

If !(cAz)->(Eof())

	aAdd(aRet,(cAz)->cod+"/"+(cAz)->loja+" - "+(cAz)->nome) //--Codigo/Loja - Nome
	aAdd(aRet,(cAz)->custo / (cAz)->quant ) //--Ultimo valo unitario
	aAdd(aRet,(cAz)->quant) //--quantidade
	aAdd(aRet,(cAz)->data)  //--Data
	aAdd(aRet,(cAz)->custo) //--total

Else

	aAdd(aRet,"N�o encontrado")
	aAdd(aRet,0)
	aAdd(aRet,0)
	aAdd(aRet,"")
	aAdd(aRet,0)

Endif

(cAz)->(dbCloseArea())

Return(aRet)


/*-----------------+---------------------------------------------------------+
!Nome              ! pWhbAglut                                               !
+------------------+---------------------------------------------------------+
!Descri��o         ! Inclus�o das solicita��es de compra Aglutinadas         !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 24/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function pWhbAglut()

Local cFerr   := ""
Local nQuant  := 0
Local aM110Cab := {}
Local aM110Itens := {}
Local cNumero := ""
Local cFiltro := '(cAl)->FERRAM != Space(TamSx3("B1_COD")[1]) .And. (cAl)->SEQ $ "2/3/4"'
Local cCusto  := ""
Local lErro   := .F.
Local cPadCst := subStr(superGetMv("MV_MRPCST",.f.,"ALMOXARI "),1,tamSx3("C1_CC")[1])

Local nConAte := 0
Local nQtdPC := 0
Local nQtdSC := 0
Local nSaldoN := 0
Local nSaldoR := 0
Local nEmin   := 0

dbSelectArea(cAl)
(cAl)->(dbSetOrder(2)) //Ferramenta+Seq
MsgRun("Preparando para gera��o de SCs aglutinadas. Aguarde...","Aguarde...",{||(cAl)->(DbSetFilter(&("{||"+cFiltro+"}"), cFiltro))})

//--Volta para primeiro registro
(cAl)->(dbGoTop())

//--Regua
ProcRegua((cAl)->(RecCount()))

//--Primeira Coisa a ser feita � aglutinar os valores por ferramenta
While !(cAl)->(Eof())

	IncProc("Aglutinando Itens ...")
	
	cFerr   := (cAl)->FERRAM
	nQuant  := 0
	cCusto  := ""
	nNecTot := 0
    
    nConAte := U_MRPFCons(cFerr,date(),mv_par01-1)
	nQtdPC  := U_MRPFQPCA(cFerr)
	nQtdSC  := U_MRPFQSCA(cFerr)
	nSaldoN := U_MRPFSld(cFerr)
	nSaldoR := U_MRPFSld(cFerr,.T.) - nSaldoN
	nEmin   := Posicione("SB1",1,xFilial("SB1")+cFerr,"B1_EMIN")

 	//estamos na linha de consumo planejado    (2)
	 
	//--Aglutina registros com mesma ferramenta
	For xD:=mvpar01 to mvpar02
		//--Soma saldos
		nNecTot += (cAl)->&("C"+DtoS(xD))
	Next
	
	(cAl)->(dbSkip())

    //estamos na linha de outras necessidades  (3)
	
	For xD:=mvpar01 to mvpar02
		//--Soma saldos
		nNecTot += (cAl)->&("C"+DtoS(xD))
	Next

	(cAl)->(dbSkip())
		
	//estamos na linha de necess. de compra    (4)
	
	//--Aglutina registros com mesma ferramenta
	For xD:=mvpar01 to mvpar02
		//--Soma saldos
		nQuant += (cAl)->&("C"+DtoS(xD))
	Next

	While !(cAl)->(Eof()) .and. (cAl)->FERRAM == cFerr
	
		//Grava os centros de custo onde � usada
		cCusto += allTrim((cAl)->CCUSTO)
	
		(cAl)->(dbSkip())

		//--Adiciona barra se n�o for o ultimo
		If !(cAl)->(Eof()) .and. (cAl)->FERRAM == cFerr
			cCusto += "/"
		Endif
	
	Enddo

	nSomaEmin := 0
	    
	nNecTot := Ceiling(nNecTot)
	    
	nNecTot += nConAte
	
	nNecTot -= nSaldoR
	
	If nNecTot <= 0
		nSomaEmin := nEmin - (nSaldoN + nQtdPC + nQtdSC)
	Else
		nNecTot -= (nSaldoN + nQtdPC + nQtdSC)

		If nNecTot <= 0 
			nSomaEmin := nNecTot + nEmin
		Else
			nSomaEmin := nEmin
		EndIf
	EndIf

	nQuant += Iif(nSomaEmin>0,nSomaEmin,0) //se o estoque for menor que o estoque minimo, soma a diferenca a necessidade
	
    //-- Arredonda a quantidade para cima
 	nQuant := Ceiling(nQuant)

	//--------------------------------------------------------
	//-- solicitacao de RUBENSVM quando for FE51 ou FE53
	//-- arredondar a quantidade da necessidade para um numero
	//-- multiplo do campo B1_LE (Lote econ�mico)
	//--------------------------------------------------------
	If AllTrim(Posicione("SB1",1,xFilial("SB1")+cFerr,"B1_GRUPO")) $ "FE51/FE53"
		nLE := Posicione("SB1",1,xFilial("SB1")+cFerr,"B1_LE")
		
		If nQuant < nLE
			nQuant := nLE
		Else
			nQuant := 	nQuant - (nQuant%nLE) + nLE
		EndIf
	EndIf
		
	//--S� inclui a Solicita��o se Qtde maior Zero
	If (nQuant <= 0)
		Loop
	EndIf

	aDias := {}

	//-- foi solicitado pelo almoxarifado que se a quantidade da ferramenta
	//-- for maior que 60, dividir em N solicita��es dentro do m�s.
	//-- referente ao chamado 11828 de Luisc no Portal
	//-- ** alterado pelo chamado 015646 de EdsonH no Portal **
	If nQuant <= 3
		
		// quando for quantidade menor ou igual a 3, gera sc para o primeiro dia
		aAdd(aDias,{ mvpar01 , nQuant })
		//aAdd(aDias,{ mvpar01+21 , nQuant })//quando for menor ou igual a 3 gera para a ultima semana
	Else
		nResto := nQuant%mvpar07 //encontra o resto
		nQuant := nQuant-nResto  //subtrai o resto

		nrescs := (mvpar02-mvpar01) % mvpar07 //resto da quantidade de scs a serem geradas
		nqtscs := ((mvpar02-mvpar01) - nrescs) / mvpar07 //dias de intervalo entre uma sc e outra
		      
		for xD:=1 to mvpar07
			aAdd(aDias,{ mvpar01 + (nqtscs * (xD-1))  , nQuant/mvpar07 + Iif(xD==1,nResto,0)}) //o resto fica para a primeira compra
		next
		
//		aAdd(aDias,{ mvpar01+7  , nQuant/mvpar07 })
//		aAdd(aDias,{ mvpar01+14 , nQuant/mvpar07 })
//		aAdd(aDias,{ mvpar01+21 , nQuant/mvpar07 })
	EndIf
	
	//percorre todos os dias	
	For xS := 1 to Len(aDias)
		
		//--Posiciona no produto
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+cFerr))
			
		SB2->(dbSetOrder(1))
		SB2->(dbSeek(xFilial("SB2")+cFerr+SB1->B1_LOCPAD))
	
		If !SB1->(Found())
			Loop
		EndIf
	
		//--Adequa o tamanho do conteudo da observa��o
		cCusto := subStr(cCusto,1,tamSx3("C1_OBS")[1])
	      
		//--Itens
		//--Muito cuidade ao mexer na estrutura do vetor abaixo.
		//--A partit dele seja gerado  log das SCs, ent�o, se precisar
		//--adicionar campos, coloque no final, depois do campo C1_TOTAL
		aAdd(aM110Itens,{{"C1_ITEM"    ,strZero(Len(aM110Itens)+1,tamSx3("C1_ITEM")[1]),Nil},;
						 {"C1_PRODUTO" ,SB1->B1_COD                    ,Nil},;
						 {"C1_UM"      ,SB1->B1_UM                     ,Nil},;
						 {"C1_QUANT"   ,aDias[xS][2]                   ,Nil},;
						 {"C1_OBS"     ,cCusto                         ,Nil},;
						 {"C1_CC"      ,cPadCst                        ,Nil},;
						 {"C1_DATPRF"  ,aDias[xS][1]                   ,Nil},;//							 {"C1_CCU"     ,cPadCst                        ,Nil},;
		                 {"C1_LOCAL"   ,SB1->B1_LOCPAD                 ,Nil},;
						 {"C1_VUNIT"   ,SB2->B2_CM1                    ,Nil},;
						 {"C1_TOTAL"   ,aDias[xS][2]*SB2->B2_CM1             ,Nil}})
	Next
	
Enddo

IncProc("Gravando as SC's Geradas ...")

//--Verifica se ha itens a serem gravados
If Len(aM110Itens) > 0

	//--Controle de transa��o
	begin Transaction

	//--Pega pr�ximo numero da SC
	cNumero := GetSxeNum("SC1","C1_NUM")// NextNumero("SC1",1,"C1_NUM",.T.)

	//--Cabe�alho
	aM110Cab := {}
	aAdd(aM110Cab,{"C1_NUM"    ,cNumero  ,Nil})
	aAdd(aM110Cab,{"C1_EMISSAO",dDataBase,Nil})
	aAdd(aM110Cab,{"C1_SOLICIT",cUserName})

	lMsErroAuto := .f.

	//-- Executa ExecAuto para grava��o da solicita��o de compras
	msExecAuto({|x,y| Mata110(x,y)},aM110Cab,aM110Itens)

	//--Erro
	If lMsErroAuto
		
		//--Cria o diret�rio se n�o existir
		MontaDir("Erro MRP\")
		//--Grava o erro no diret�rio
		MostraErro("\Erro MRP\","["+dtoS(dDataBase)+"]["+strTran(Time(),":",".")+"]["+allTrim(cFerr)+"].err")

		Aviso("SCs n�o geradas","N�o foi possivel fazer a grava��o das SCs, verifique o log.",{"Ok"},2)

		DisarmTransaction()
	
	Else
	
		//--Monta update para flegar as provis�es de vendas
		//--Caso for reprocessar, n�o ira encontrar nada
		cUpdate := " update "
		cUpdate +=      retSqlName("SHC")
		cUpdate += " set "
		cUpdate += " 	HC_MRPFE = 'P' "
		cUpdate += " where "
		cUpdate += " 	 HC_FILIAL   = '"+xFilial("SHC")+"' "
		cUpdate += " and HC_PRODUTO >= '"+mvpar03+"' "
		cUpdate += " and HC_PRODUTO <= '"+mvpar04+"' "
		cUpdate += " and HC_DATA    >= '"+DtoS(mvpar01)+"' "
		cUpdate += " and HC_DATA    <= '"+DtoS(mvpar02)+"' "
		cUpdate += " and D_E_L_E_T_  = ' ' "
		
		IncProc("Gravando Log ...")
		//--Grava o log das SCs
		gravaLog(cNumero,aM110Itens)

		//--Executa o comando
		tcSqlExec(cUpdate)
	
		Aviso("SCs geradas","As SCs foram geradas com sucesso",{"Ok"},2)
		
		cUpdate := " update "
		cUpdate +=      retSqlName("SC1")
		cUpdate += " set "
		cUpdate += " 	C1_CCU = SUBSTRING(C1_OBS,1,8)"
		cUpdate += " where "
		cUpdate += " 	 C1_NUM='"+cNumero+"'"
		cUpdate += " and D_E_L_E_T_  = ' ' "
		
		//--Executa o comando
		tcSqlExec(cUpdate)
		

	Endif
	
	ConfirmSx8()

	//--Controle de transa��o
	end Transaction

Endif

//--Limpa o filtro
(cAl)->(dbClearFilter())

Return

/*-----------------+---------------------------------------------------------+
!Nome              ! pWhbNoAgt                                               !
+------------------+---------------------------------------------------------+
!Descri��o         ! Inclus�o das solicita��es de compra nao Aglutinadas     !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 24/02/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/

/*
static Function pWhbNoAgt()

Local cFerr := ""
Local nQuant := 0
Local aM110Cab := {}
Local aM110Itens := {}
Local cNumero := ""
Local cFiltro := '(cAl)->FERRAM != Space(TamSx3("B1_COD")[1]) .And. (cAl)->SEQ $ "1#2"'
Local cCusto := ""
Local lErro := .F.
Local aSldAnt := {}

//	aSldAnt[1] := Codigo do produto
//	aSldAnt[2] := Saldo do dia anterior

Local aProds := {}

//	aProds[1] := Codigo do produto
//	aProds[2] := Codigo do CC
//	aProds[3] := Saldo inicial
//	aProds[4] := Necessidade
//	aProds[5] := Comprar
//	aProds[6] := Saldo Final

Local cPadCst := subStr(superGetMv("MV_MRPCST",.f.,"ALMOXARI "),1,tamSx3("C1_CC")[1])

alert('Esta op��o foi desativada!')
return


dbSelectArea(cAl)
(cAl)->(dbSetOrder(2)) //Ferramenta+Seq
MsgRun("Preparando para gera��o de SCs Separadas. Aguarde...","Aguarde...",{||(cAl)->(DbSetFilter(&("{||"+cFiltro+"}"), cFiltro))})

//--Regua
ProcRegua(mvpar02-mvpar01+1)

For xD := mvpar01 to mvpar02

	IncProc("Gerando dia "+DtoC(xD)+" ("+DtoC(mvpar01)+" at� "+DtoC(mvpar02)+")...")

	//--Volta para primeiro registro
	(cAl)->(dbGoTop())

	//--Primeira Coisa a ser feita � aglutinar os valores por ferramenta
	While !(cAl)->(Eof())
	
		cFerr := (cAl)->FERRAM
		aProds := {}
				
		//--Aglutina registros com mesma ferramenta
		While !(cAl)->(Eof()) .and. (cAl)->FERRAM == cFerr .And. (cAl)->SEQ == "1"

			//--Estamos na linha de saldo

			//--Se vetor vazio, carega primeira linha com saldo inicial
			If aScan(aSldAnt,{|x| x[1]=(cAl)->FERRAM}) == 0
	
				aAdd(aProds,{(cAl)->FERRAM,(cAl)->CCUSTO,(cAl)->&("C"+DtoS(xD)),0,0,0})

			//--se n�o pula linha sempre, porque � a linha de saldos
    		Else
				aAdd(aProds,{(cAl)->FERRAM,(cAl)->CCUSTO,aSldAnt[aScan(aSldAnt,{|x| x[1]=(cAl)->FERRAM}),2],0,0,0})
    			
    		Endif
            
			//--Proximo registro
			(cAl)->(dbSkip())

			//--Agora estamos na linha da necessidade

			//--Linha do vetor atual
			nL := Len(aProds)
			
			//--Necessidade do dia
			aProds[nL,4] := (cAl)->&("C"+DtoS(xD))
			
			//--Valor a comprar
			aProds[nL,5] := If(aProds[nL,4]>aProds[nL,3],aProds[nL,4]-aProds[nL,3],0)
			
			//--Saldo final
			aProds[nL,6] := If(aProds[nL,4]>=aProds[nL,3],0,aProds[nL,3]-aProds[nL,4])

			//--Verifica se j� existe no vetor de saldos
			If aScan(aSldAnt,{|x| x[1]=(cAl)->FERRAM}) != 0
				
				//--Se j�. muda o saldo
				aSldAnt[aScan(aSldAnt,{|x| x[1]=(cAl)->FERRAM}),2] := aProds[nL,6]

			Else
				
				//--Se n�o adiciona um novo
				aAdd(aSldAnt,{(cAl)->FERRAM,aProds[nL,6]})
			
			Endif

			(cAl)->(dbSkip())

		Enddo
        
		For nX := 1 To Len(aProds)

			//--S� inclui a Solicita��o se Qtde maior Zero
			If (aProds[nX,5] > 0)

				dbSelectArea("SC1")
				dbSetOrder(1)
				
				dbSelectArea("SB1")
				dbSetOrder(1)
				
				dbSelectArea("SB2")
				dbSetOrder(1)

				//--Posiciona no produto
				SB1->(dbSeek(xFilial("SB1")+aProds[nX,1])) 
				
				If !SB1->(Found())
					Loop
				EndIf
				
				SB2->(dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD))
	
				//--Adequa o tamanho do conteudo da observa��o
				cCusto := subStr(aProds[nX,2],1,tamSx3("C1_OBS")[1])
		
		        //--Itens
				//--Muito cuidade ao mexer na estrutura do vetor abaixo.
				//--A partit dele seja gerado  log das SCs, ent�o, se precisar
				//--adicionar campos, coloque no final, depois do campo C1_TOTAL
				aAdd(aM110Itens,{{"C1_ITEM"   ,strZero(Len(aM110Itens)+1,tamSx3("C1_ITEM")[1]),Nil},;
								 {"C1_PRODUTO",SB1->B1_COD                        ,Nil},;
								 {"C1_UM"     ,SB1->B1_UM                         ,Nil},;
								 {"C1_QUANT"  ,aProds[nX,4]                       ,Nil},;
								 {"C1_OBS"    ,cCusto                             ,Nil},;
								 {"C1_CC"     ,cPadCst                            ,Nil},;
								 {"C1_DATPRF" ,Iif(xD-SB1->B1_LT<dDatabase,dDatabase,xD-SB1->B1_LT)                      ,Nil},;//								 {"C1_CCU"    ,subStr(cCusto,1,8)                 ,Nil},;
				                 {"C1_LOCAL"  ,SB1->B1_LOCPAD                     ,Nil},;
								 {"C1_VUNIT"  ,SB2->B2_CM1                        ,Nil},;
								 {"C1_TOTAL"  ,aProds[nX,4]*SB2->B2_CM1           ,Nil}})
		
			Endif

		Next

	Enddo

Next

//--Verifica se ha itens a serem gravados
If Len(aM110Itens) > 0

	//--Controle de transa��o
	begin Transaction

	//--Pega pr�ximo numero da SC
	cNumero := GetSxeNum("SC1","C1_NUM") //NextNumero("SC1",1,"C1_NUM",.T.)

	//--Cabe�alho
	aM110Cab := {}
	aAdd(aM110Cab,{"C1_NUM"    ,cNumero  ,Nil})
	aAdd(aM110Cab,{"C1_EMISSAO",dDataBase,Nil})
	aAdd(aM110Cab,{"C1_SOLICIT",cUserName})

	lMsErroAuto := .f.

	//-- Executa ExecAuto para grava��o da solicita��o de compras
	msExecAuto({|x,y| Mata110(x,y)},aM110Cab,aM110Itens)

	//--Erro
	If lMsErroAuto
		
		//--Cria o diret�rio se n�o existir
		MontaDir("Erro MRP\")
		//--Grava o erro no diret�rio
		MostraErro("\Erro MRP\","["+dtoS(dDataBase)+"]["+strTran(Time(),":",".")+"]["+allTrim(cFerr)+"].err")

		Aviso("SCs n�o geradas","N�o foi possivel fazer a grava��o das SCs, verifique o log.",{"Ok"},2)

		DisarmTransaction()
	
	Else
	
		//--Monta update para flegar as provis�es de vendas
		//--Caso for reprocessar, n�o ira encontrar nada
		cUpdate := " update "
		cUpdate +=      retSqlName("SHC")
		cUpdate += " set "
		cUpdate += " 	HC_MRPFE = 'P' "
		cUpdate += " where "
		cUpdate += " 	 HC_FILIAL   = '"+xFilial("SHC")+"' "
		cUpdate += " and HC_PRODUTO >= '"+mvpar03+"' "
		cUpdate += " and HC_PRODUTO <= '"+mvpar04+"' "
		cUpdate += " and HC_DATA    >= '"+DtoS(mvpar01)+"' "
		cUpdate += " and HC_DATA    <= '"+DtoS(mvpar02)+"' "
		cUpdate += " and D_E_L_E_T_  = ' ' "
		
		//--Executa o comando
		tcSqlExec(cUpdate)
	
		Aviso("SCs geradas","As SCs foram geradas com sucesso",{"Ok"},2)

	Endif

	//--Controle de transa��o
	end Transaction

Endif

//--Limpa o filtro
(cAl)->(dbClearFilter())

Return
*/

/*-----------------+---------------------------------------------------------+
!Nome              ! gravaLog                                                !
+------------------+---------------------------------------------------------+
!Descri��o         ! Grava no log, espelho da solicita��o de compra          !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 08/03/2010                                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
static Function gravaLog(cNumero,aItens)

dbSelectArea("ZDX")

For nX := 1 to Len(aItens)

	recLock("ZDX",.t.)
		ZDX->ZDX_FILIAL := xFilial("ZDX")
		ZDX->ZDX_SOLIC  := cNumero
		ZDX->ZDX_USER   := cUserName
		ZDX->ZDX_DATA   := dDataBase
		ZDX->ZDX_HORA   := SubStr(Time(),1,5)
		ZDX->ZDX_ITEM   := aItens[nX,01,2] //--Item
		ZDX->ZDX_PRODUT := aItens[nX,02,2] //--Codigo do Produto
		ZDX->ZDX_UM     := aItens[nX,03,2] //--Unidade
		ZDX->ZDX_QUANT  := aItens[nX,04,2] //--Quantidade
		ZDX->ZDX_OBS    := aItens[nX,05,2] //--Observa��o
		ZDX->ZDX_CC     := aItens[nX,06,2] //--Centro de Custo
		ZDX->ZDX_DATPRF := aItens[nX,07,2] //--Data de Necessidade
	//	ZDX->ZDX_CCU    := aItens[nX,08,2] //--Centro de Custo Usado
		ZDX->ZDX_LOCAL  := aItens[nX,08,2] //--Armazem padrao
		ZDX->ZDX_VUNIT  := aItens[nX,09,2] //--Valor Unitario
		ZDX->ZDX_TOTAL  := aItens[nX,10,2] //--Valor Total
	msUnLock()

Next

Return

/*-----------------+---------------------------------------------------------+
!Nome              ! CriaSx1                                                 !
+------------------+---------------------------------------------------------+
!Descri��o         ! Cria perguntas                                          !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
Static Function CriaSx1()

PutSx1(cPerg,"01","Da Data?"           ,"Da Data?"        ,"Da data?"        ,"mv_ch1","D",08,0,0,"G","",""   ,"","","mv_par01","","","","","","","","","","","","","","","","",{"Da data"         ,"","",""},{"Da data"         ,"","",""},{"Da data"         ,"","",""},"")
PutSx1(cPerg,"02","At� a Data?"        ,"At� a Data?"     ,"At� a Data?"     ,"mv_ch2","D",08,0,0,"G","",""   ,"","","mv_par02","","","","","","","","","","","","","","","","",{"At� a data"      ,"","",""},{"At� a data"      ,"","",""},{"At� a data"      ,"","",""},"")
PutSx1(cPerg,"03","Do Produto?"        ,"Do Produto?"     ,"Do Produto?"     ,"mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03","","","","","","","","","","","","","","","","",{"Do produto"      ,"","",""},{"Do produto"      ,"","",""},{"Do produto"      ,"","",""},"")
PutSx1(cPerg,"04","At� o Produto?"     ,"At� o Produto?"  ,"At� o Produto?"  ,"mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04","","","","","","","","","","","","","","","","",{"At� o produto"   ,"","",""},{"At� o produto"   ,"","",""},{"At� o produto"   ,"","",""},"")
PutSx1(cPerg,"05","Da Ferramenta?"     ,"Da Ferramenta?"  ,"Da Ferramenta?"  ,"mv_ch5","C",15,0,0,"G","","FER","","","mv_par05","","","","","","","","","","","","","","","","",{"Da Ferramenta"   ,"","",""},{"Da Ferramenta"   ,"","",""},{"Da Ferramenta"   ,"","",""},"")
PutSx1(cPerg,"06","At� Ferramenta?"    ,"At� Ferramenta?" ,"At� Ferramenta?" ,"mv_ch6","C",15,0,0,"G","","FER","","","mv_par06","","","","","","","","","","","","","","","","",{"At� Ferramenta?" ,"","",""},{"At� Ferramenta?" ,"","",""},{"At� Ferramenta?" ,"","",""},"")
PutSx1(cPerg,"07","Gerar Quantas SC's ?","Gerar Quantas SC's ?" ,"Gerar Quantas SC's ?" ,"mv_ch7","N",10,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",{"Informe a quantidade de SC's que ser� gerada dentro do per�odo" ,"","",""},{"Gerar Quantas SC's ?" ,"","",""},{"Gerar Quantas SC's ?" ,"","",""},"")

Return

/*-----------------+---------------------------------------------------------+
!Nome              ! Ceiling                                                 !
+------------------+---------------------------------------------------------+
!Descri��o         ! Arredonda valor sempre pra cima                         !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
user Function Ceiling(nValor)

If Int(nValor) != nValor
	nValor := Int(nValor)+1
Endif

Return(nValor)


/*-----------------+---------------------------------------------------------+
!Nome              ! fQEntMes                                                !
+------------------+---------------------------------------------------------+
!Descri��o         ! TRAZ A QUANTIDADE DE ENTRADA NO MES/ANO                 !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa                                     !
+------------------+--------------------------------------------------------*/
Static Function fQEntMes(cProd,cMes,cAno)
Local cAlias := 'Q_ENT_MES'
Local nQuant := 0

	beginSql Alias cAlias
		select
			SUM(SD1.D1_QUANT) as quant
		from 
			%table:SD1% SD1
		inner join
	        %table:SF4% SF4
		    on  SF4.F4_FILIAL  = %xFilial:SF4%
		    and SF4.F4_CODIGO  = SD1.D1_TES
		    and SF4.F4_ESTOQUE = 'S'
		    and SD1.D_E_L_E_T_ = ' '
		where
		    SD1.D1_FILIAL       = %xFilial:SD1%
			and SD1.D1_COD      = %Exp:cProd%
			and SD1.D1_ORIGLAN != 'LF'
			and SD1.D1_QUANT   != 0
			and SD1.D1_REMITO   = '         '
			and SD1.D_E_L_E_T_  = ' '
			and MONTH(SD1.D1_EMISSAO) = %Exp:cMes%
			and YEAR(SD1.D1_EMISSAO) = %Exp:cAno%
	endSql
	
   	If !(cAlias)->(Eof())
  	 	nQuant := (cAlias)->quant //-- media de entrada por mes
	EndIf
          
	(cAlias)->(dbCloseArea())
	
Return nQuant

/*-----------------+---------------------------------------------------------+
!Nome              ! fQEntMes                                                !
+------------------+---------------------------------------------------------+
!Descri��o         ! TRAZ A QUANTIDADE DE CONSUMO NO MES/ANO                 !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa                                     !
+------------------+--------------------------------------------------------*/
Static Function fQConMes(cProd,cMes,cAno)
Local cAlias := 'Q_CON_MES'
Local nQuant := 0

	beginSql Alias cAlias
		select 
			SUM(D3_QUANT) as quant
		from
			%table:SD3% SD3
		where
			SD3.D3_FILIAL = %xFilial:SD3%
			and SD3.D3_TM > 500
			and SD3.D3_COD = %Exp:cProd%
			and SD3.D3_LOCAL = '31'
			and SD3.D_E_L_E_T_ = ' '
			and SD3.D3_ESTORNO <> 'S'
			and MONTH(SD3.D3_EMISSAO) = %Exp:cMes%
			and YEAR(SD3.D3_EMISSAO) = %Exp:cAno%
	endSql

   	If !(cAlias)->(Eof())
  	 	nQuant := (cAlias)->quant
	EndIf
          
	(cAlias)->(dbCloseArea())

Return nQuant


//���������������������������������������������������������Ŀ
//� TRAZ O CONSUMO PREVISTO AT� A DATA DA CHEGADA DO PEDIDO �
//�����������������������������������������������������������
User Function MRPFCons(cFer,dDtIni,dDtFim)
Local cAlias  := 'TMPCONS'
Local nQuant  := 0
Local nZDJRec := ZDJ->(Recno())

	beginSql Alias cAlias
		SELECT
			SUM(HC.HC_QUANT) AS quant
			, ZDJ.R_E_C_N_O_ AS zdjrec
		FROM
			SHCFN0 HC , ZDJFN0 ZDJ
		WHERE 
			ZDJ.ZDJ_FILIAL = %xFilial:ZDJ%
			AND HC.HC_FILIAL = %xFilial:SHC%
			AND ZDJ.ZDJ_PROD = HC.HC_PRODUTO
			AND HC.HC_DATA BETWEEN %Exp:DtoS(dDtIni)% AND %Exp:DtoS(dDtFim)%
            AND ZDJ.ZDJ_FERRAM = %Exp:cFer%
			AND HC.D_E_L_E_T_ = ' '
			AND ZDJ.D_E_L_E_T_ = ' '  
		GROUP BY ZDJ.R_E_C_N_O_ 
	endSql

	While (cAlias)->(!eof())
	
		ZDJ->(dbGoTo((cAlias)->zdjrec))
		//calcula o consumo planejado
		nQuant += U_MRPFConP((cAlias)->quant)[1]
		
		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbCloseArea())

	ZDJ->(dbGoTo(nZDJRec))
	
Return nQuant

/*----------------------------------------------
 *
 * CALCULA O ESTOQUE MINIMO DA FERRAMENTA
 *
 *--------------------------------------------*/
User Function MRPCalEMin(dDti,dDtf,cFerDe,cFerAte)
Local cAlias := 'EMIN'

	beginSql Alias cAlias
		SELECT 
			ZDJ.R_E_C_N_O_ zdjrecno , 
			ZDJ.ZDJ_PROD prod, 
			SUM(HC_QUANT) quant
		FROM 
			%Table:ZDJ% ZDJ, 
			%Table:SHC% SHC
		WHERE 
			SHC.HC_PRODUTO = ZDJ.ZDJ_PROD
			AND SHC.HC_FILIAL = %xFilial:SHC%
			AND ZDJ.ZDJ_FILIAL = %xFilial:ZDJ%
			AND SHC.HC_DATA BETWEEN %Exp:DtoS(dDti)% AND %Exp:DtoS(dDtf)%
			AND ZDJ.ZDJ_FERRAM BETWEEN %Exp:cFerDe% AND %Exp:cFerAte%
			AND ZDJ.D_E_L_E_T_ = ' '
			AND SHC.D_E_L_E_T_ = ' '
		GROUP BY 
			ZDJ.ZDJ_PROD,ZDJ.R_E_C_N_O_
		ORDER BY 
			ZDJ.ZDJ_PROD
	endSql
	
	(cAlias)->(dbGoTop())			
	
	ProcRegua(0)
	
	SB1->(dbSetOrder(1))
	
	aMat := {}
	
	While (cAlias)->(!eof())
		
		ZDJ->(dbGoTo((cAlias)->zdjrecno))
		IncProc(ZDJ->ZDJ_FERRAM)
		
		/*
		If ZDJ->ZDJ_FORMUL=='C'
			(cAlias)->(dbskip())
		Endif
        */
        
//		If ALLTRIM(ZDJ->ZDJ_FERRAM)=='FE33.065065'
		
		nQuant := U_MRPFConP((cAlias)->quant)[1] //Traz o consumo planejado da ferramenta
		
		/*------------------------------------------------------------------------------------------
		FOMULA A
		(((PRODU��O DO M�S /23)/ VIDA �TIL)* FERRAMENTA POR MONTAGEM * NUMERO DE M�QUINAS)*2
		
		FORMULA B
		(CONSUMO PLANEJADO/23)*FERRAMENTA POR MONTAGEM * NUMERO DE M�QUINAS * LEAD TIME.
		
		FORMULA C
			n�o atualiza, apenas obedece o que existe no campo B1_EMIN
		*------------------------------------------------------------------------------------------*/
		
		nLeadTime := Posicione("SB1",1,xFilial("SB1")+ZDJ->ZDJ_FERRAM,"B1_LT")
		nLeadTime := Iif(nLeadTime<=0,1,nLeadTime)

		If ZDJ->ZDJ_FORMUL=='A'
			nEmin := ((((cAlias)->quant / 23) / ZDJ->ZDJ_VUMONT) * ZDJ->ZDJ_FMONT * ZDJ->ZDJ_NMAQ) *2
		ElseIf ZDJ->ZDJ_FORMUL=='B'
		    nEmin := (nQuant/23) * ZDJ->ZDJ_FMONT * ZDJ->ZDJ_NMAQ * nLeadTime
		ElseIf ZDJ->ZDJ_FORMUL=='C'
			nEmin := ZDJ->ZDJ_EMIN
		Else
			nEmin := nQuant / 4
		EndIf

		_n:=aScan(aMat,{|x| x[1]==ZDJ->ZDJ_FERRAM})

		If _n==0
			aAdd(aMat,{ZDJ->ZDJ_FERRAM,; // 1-codigo da ferramenta
			           nQuant,;          // 2 - consumo planejado
			           nEmin})           // 3 - estoque minimo pre calculado
		Else
			aMat[_n][2] += nQuant        //acumula o consumo planejado
			aMat[_n][3] += nEmin         //acumula o estoque minimo para a ferramenta
		EndIf   
		
//		ENDIF

		(cAlias)->(dbSkip())
	EndDo

	aSort(aMat,,,{|x,y| x[1]<y[1] }) //ordena por ferramenta
	
	ProcRegua(len(amat))

	For xP:=1 to Len(aMat)
		
		IncProc('Atualizando cadastro de produtos: '+aMat[xP][1])
		
		nEmin := aMat[xP][3]
		
		nEmin := Iif(nEmin <= 0,1,Ceiling(nEmin))
		
		If SB1->(dbSeek(xFilial("SB1")+aMat[xP][1]))
			RecLock("SB1",.F.)
				SB1->B1_EMIN := nEmin
			MsUnlock("SB1")
		EndIf
	Next
	
	(cAlias)->(dbCloseArea())
	
Return
