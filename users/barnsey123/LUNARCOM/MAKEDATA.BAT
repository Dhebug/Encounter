@ECHO OFF

::%OSDK%\bin\pictconv -m0 -f0 -d1 -o4_Mask pics\MaskSmallOric2.png mask.s
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o3_MaskC pics\MaskSmallOric2.png mask.c
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o0 pics\MaskSmallOric2.png maskf0d1.tap
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o0 pics\xmas-mask2.png xmas.tap

::%OSDK%\bin\PictConv -f1 -d0 -o2 ..\..\data\picture.png %OSDK%\tmp\picture.hir
::%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
::%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak picture.s _LabelPicture

::%OSDK%\bin\pictconv -m0 -f0 -d1 -o2 pics\MaskSmallOric2.png mask.hir
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o2 pics\xmas-mask2.png mask.hir
::%OSDK%\bin\FilePack -p mask.hir mask.pak
::%OSDK%\bin\Bin2Txt -s1 -f2 mask.pak mask.s _LabelPicture

:: MonoChrome
%osdk%\BIN\pictconv -m0 -f0 -d1 -O0 pics\MANONMOON2.PNG manonmoon.tap
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\tycho-central.PNG tycho-central.tap
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\tycho-central-ground.PNG tycho-central-ground.tap
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\tycho-grid.PNG tycho-grid.tap
%osdk%\BIN\pictconv -m0 -f0 -d3 pics\tycho-blue.PNG tycho-blue-mono.tap
:: Color
%osdk%\BIN\pictconv -f2 -d1 pics\tycho-cross-section.PNG tycho-cross.tap
%osdk%\BIN\pictconv -f2 -d1 pics\tycho-tri-color-2-oric.PNG tycho-tri-color-2.tap
%osdk%\BIN\pictconv -f2 -d1 pics\tycho-central-color.PNG tycho-central-color.tap
%osdk%\BIN\pictconv -f2 -d1 pics\tycho-false-color-2.PNG tycho-false-color-2.tap
%osdk%\BIN\pictconv -f2 -d1 pics\tycho-blue.PNG tycho-blue.tap
pause
