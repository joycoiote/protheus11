#include "rwmake.ch"

User Function TXTDBF()
Local cArq := ""


cArq    := cGetFile()

ft_fuse(cArq)



While ! ft_feof()

    //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    //� Neste momento, ja temos uma linha lida. Gravamos os valores �
    //� obtidos retirando-os da linha lida.                         �
    //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
     cBuff := ft_freadln()
     alert(cBuff)
     ft_fskip()
EndDo

ft_fuse()

Return
