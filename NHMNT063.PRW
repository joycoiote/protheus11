/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHMNT063  � Autor � Douglas de Dourado� Data  �  26/02/13   ���
�������������������������������������������������������������������������͹��
���Descricao � CADASTRO DE MATERIAS (PARA AUXILIAR ROTINA NHMNT062)       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Chamada Padr�o                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#INCLUDE "rwmake.ch"
User Function NHMNT063()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZG6"

dbSelectArea("ZG6")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Material",cVldAlt,cVldExc)

Return