@ECHO OFF

:: Redundant stuff
::%OSDK%\bin\pictconv -m0 -f0 -o4_TitleTiles pics\defence-force2.png defence.s
::%OSDK%\bin\pictconv -m0 -f0 -o4_RunicTiles pics\runes.png runes.s
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o4_Mask pics\MaskSmallOric2.png mask.s
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o3_MaskC pics\MaskSmallOric2.png mask.c
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o0 pics\MaskSmallOric2.png maskf0d1.tap
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o0 pics\xmas-mask2.png xmas.tap
::%OSDK%\bin\PictConv -f1 -d0 -o2 ..\..\data\picture.png %OSDK%\tmp\picture.hir
::%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
::%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak picture.s _LabelPicture

:: For Main Program

:: Main player piece and board tiles
%OSDK%\bin\pictconv -m0 -f0 -o4_PictureTiles pics\tiles6.png pictiles.s
:: Explosion sequence of a taken tile
%OSDK%\bin\pictconv -m0 -f0 -o4_ExplodeTiles pics\explode.png explode.s
:: Border tiles for Trophy Screen
%OSDK%\bin\pictconv -m0 -f0 -o4_BorderTiles2 pics\bordertiles2.png border.s
:: The central timer sequence pictures
%OSDK%\bin\pictconv -m0 -f0 -o4_TimerTiles pics\timer5.png timer.s

pause
