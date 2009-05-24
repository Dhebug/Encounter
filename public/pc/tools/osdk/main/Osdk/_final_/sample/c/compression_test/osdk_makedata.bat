@ECHO OFF
%OSDK%\bin\PictConv -f1 -d0 -o2 ..\..\data\picture.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak picture.s _LabelPicture
pause
