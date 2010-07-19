@ECHO OFF

:: Defence Force logo
%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\dflogo.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_defenceforce.s _LabelPictureDefenceForce

:: Space station
%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\Space1999_logo.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_logo.s _LabelPictureLogo

:: Martin Landau
%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\oric_staring_martin_landeau_final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_landau.s _LabelPictureMartinLandau

:: Barbara Bain
%OSDK%\bin\PictConv -f0 -d0 -o2 Graphics\oric_staring_barbara_bain_final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_bain.s _LabelPictureBarbaraBain

:: Executive producer
%OSDK%\bin\PictConv -f0 -d0 -o2 Graphics\oric_executive_producer_gerry_anderson_final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_producer.s _LabelPictureProducer

:: ITC logo
%OSDK%\bin\PictConv -f0 -d0 -o2 Graphics\itc_logo.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_itc.s _LabelPictureItcLogo

:: this episode
%OSDK%\bin\PictConv -f0 -d0 -o2 Graphics\this_episode.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_episode.s _LabelPictureEpisode

:: Barry Morse
%OSDK%\bin\PictConv -f0 -d0 -o2 Graphics\oric_starring_barry_morse_final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_morse.s _LabelPictureBarryMorse

:: Producer
%OSDK%\bin\PictConv -f0 -d0 -o2 Graphics\oric_producer_sylvia_anderson_final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_sylvia.s _LabelPictureSylviaAnderson

:: Font
%OSDK%\bin\PictConv -f0 -d0 -o2 Graphics\space1999_font.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_font.s _LabelPictureFont

:: Various stuff (moonbase alpha logo...)
%OSDK%\bin\PictConv -f0 -d0 -o2 Graphics\pictures.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_misc.s _LabelPictureMisc

pause

