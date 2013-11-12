::@ECHO OFF

:: The Alchemie X logo
%OSDK%\bin\PictConv -f1 -d0 -o2 data\alchimie-logo-oric.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak alchimie_logo.s _LabelPictureAlchemieLogo

:: The Kindergarden logo
%OSDK%\bin\PictConv -f1 -d0 -o2 data\kindergarden-logo-oric.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak kindergarden_logo.s _LabelPictureKindergardenLogo

:: The evolution picture
%OSDK%\bin\PictConv -f1 -d0 -o2 data\evolution.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak evolution_logo.s _LabelPictureEvolution

:: The Xnitzy ship
%OSDK%\bin\pictconv -t1 -m0 -f1 -o4_PictureShip data\XNITZY-ship.png pic_ship.s

:: The Music
set MUSIC=Platoon-Whittaker
D:\svn\public\pc\tools\osdk\main\Osdk\_final_\Bin\ym2mym.exe data\%MUSIC%.YM %OSDK%\tmp\%MUSIC%.mym
%osdk%\bin\bin2txt -f2 -h1 -s1 %OSDK%\tmp\%MUSIC%.mym  music.s _Music


pause
