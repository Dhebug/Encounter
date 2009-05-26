@ECHO OFF

goto Bla

:: Space station
%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\240x200\Space1999_logo.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_logo.s _LabelPictureLogo

:: Martin Landau
%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\240x200\oric_staring_martin_landeau_final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_landau.s _LabelPictureMartinLandau

:: Barbara Bain
%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\240x200\oric_staring_barbara_bain_final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_bain.s _LabelPictureBarbaraBain

:: Executive producer
%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\240x200\oric_executive_producer_gerry_anderson_final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_producer.s _LabelPictureProducer

:: ITC logo
%OSDK%\bin\PictConv -f0 -d0 -o2 Graphics\240x200\itc_logo.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_itc.s _LabelPictureItcLogo

:: this episode
%OSDK%\bin\PictConv -f0 -d0 -o2 Graphics\240x200\this_episode.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_episode.s _LabelPictureEpisode

:: Barry Morse
%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\240x200\oric_starring_barry_morse_final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_morse.s _LabelPictureBarryMorse

:: Producer
%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\240x200\oric_producer_sylvia_anderson_final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak pic_sylvia.s _LabelPictureSylviaAnderson


:: Font
%OSDK%\bin\PictConv -f0 -d0 -o5 Graphics\240x200\space1999_font.png font.png


:: Screen detail 1
::%OSDK%\bin\PictConv -f0 -o2 Graphics\240x200\scene1finalb.png %OSDK%\tmp\picture.hir
%OSDK%\bin\PictConv -f0 -o2 Graphics\240x200\scene4final.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak scene1.s _Labelscene1

:: Screen detail 2
%OSDK%\bin\PictConv -f0 -o2 Graphics\240x200\scene3finalb.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak scene2.s _Labelscene2

:Bla
%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\240x200\out-scene4-3.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak scene1.s _Labelscene1

%OSDK%\bin\PictConv -f1 -d0 -o2 Graphics\240x200\out-scene3-3.png %OSDK%\tmp\picture.hir
%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak scene2.s _Labelscene2



pause