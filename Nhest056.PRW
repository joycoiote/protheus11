/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHEST056  � Autor � Alexandre R. Bento     Data � 28/06/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Controle de Orderm de Libera��o Portaria                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Rdmake                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Portaria                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"

User Function nhest056()

SetPrvt("CCADASTRO,AROTINA,")


cCadastro := OemToAnsi("Ordem de Libera��o de Materiais Pela Portaria")
aRotina := {{ "Pesquisa","AxPesqui"    ,  0 , 1},;
            { "Visualizacao",'U_NHEST039(2)'  , 0 , 2},;
            { "Portaria"   ,'U_NHEST039(8)' , 0,3}}


mBrowse( 6, 1,22,75,"SZM",,,,,,fCriaCor())
Return

Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_VERMELHO", "Fechado"  },;
  						{"BR_VERDE"   , "Aberto"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZM_HORAPOR <> " "', aLegenda[1][1] } )
Aadd(uRetorno, { 'ZM_HORAPOR = " "' , aLegenda[2][1] } )

Return(uRetorno)



