@ECHO OFF
::%OSDK%\bin\PictConv -f0 -d0 -o4 pics\inlay2.png inlay.s
%OSDK%\bin\PictConv -f0 -d1 -o4 pics\inlay2.png inlay.s

::%OSDK%\bin\PictConv -f0 -d0 -o5 picture\pattern.png test.png
::%OSDK%\bin\Bin2Txt -s1 -f2 picture\sota.raw sota.s _LabelSota
pause