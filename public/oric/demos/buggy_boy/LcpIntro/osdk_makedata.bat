@ECHO OFF

::ECHO Convert Karhu bear picture
%OSDK%\bin\PictConv -f1 -d0 -o2 data\karhu_240x200.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak picture.s _LabelPicture

::ECHO Convert VScroll border picture
%OSDK%\bin\PictConv -f0 -d0 -o2 data\border_84x224.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pat_picture.s _LabelPicture

::ECHO Convert VScroll font
%OSDK%\bin\PictConv -f0 -d0 -o4 data\font_16x28.png pat_font.s

::ECHO Convert music
%OSDK%\bin\Bin2Txt -s1 -f2 data\tune.mym music.s _MusicData


pause

