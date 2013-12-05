@ECHO OFF

%OSDK%\bin\pictconv -m0 -f0 -o4_PictureTiles pics\tiles6.png pictiles.s
%OSDK%\bin\pictconv -m0 -f0 -o4_ExplodeTiles pics\explode.png explode.s
%OSDK%\bin\pictconv -m0 -f0 -o4_BorderTiles2 pics\bordertiles2.png border.s
%OSDK%\bin\pictconv -m0 -f0 -o4_TitleTiles pics\defence-force2.png defence.s
%OSDK%\bin\pictconv -m0 -f0 -o4_RunicTiles pics\runes.png runes.s
%OSDK%\bin\pictconv -m0 -f0 -o4_TimerTiles pics\timer5.png timer.s
%OSDK%\bin\pictconv -m0 -f0 -d1 -o4_Mask pics\MaskSmallOric2.png mask.s
%OSDK%\bin\pictconv -m0 -f0 -d1 -o3_MaskC pics\MaskSmallOric2.png mask.c
%OSDK%\bin\pictconv -m0 -f0 -d1 -o0 pics\MaskSmallOric2.png maskf0d1.tap
pause
