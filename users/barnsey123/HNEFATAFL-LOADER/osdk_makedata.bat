@ECHO OFF

::%OSDK%\bin\pictconv -m0 -f0 -d1 -o4_Mask pics\MaskSmallOric2.png mask.s
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o3_MaskC pics\MaskSmallOric2.png mask.c
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o0 pics\MaskSmallOric2.png maskf0d1.tap


::%OSDK%\bin\PictConv -f1 -d0 -o2 ..\..\data\picture.png %OSDK%\tmp\picture.hir
::%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
::%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak picture.s _LabelPicture

%OSDK%\bin\pictconv -m0 -f0 -d1 -o2 pics\MaskSmallOric2.png mask.hir
%OSDK%\bin\FilePack -p mask.hir mask.pak
%OSDK%\bin\Bin2Txt -s1 -f2 mask.pak mask.s _LabelPicture
pause