::@echo off

:: Create the folders we need
md build
pushd build
md files
popd

::
:: Build data for the game
::
SET PICTCONV=%OSDK%\Bin\PictConv.exe
SET SAMPLETWEAKER=%OSDK%\Bin\SampleTweaker.exe

:: Pictures
SET PARAMS=-f1 -d0 -o2 -u1 -t1

::%PICTCONV% %PARAMS% data\logo_fire.png build\files\logo_fire.hir

:: Color pictures
%PICTCONV% %PARAMS% data\title_screen.png build\files\title_screen.hir
%PICTCONV% %PARAMS% data\how_to_play.png build\files\how_to_play.hir
%PICTCONV% %PARAMS% data\GlobalGameJamOslo.png build\files\GlobalGameJamOslo.hir

:: Failures
%PICTCONV% %PARAMS% data\ending_giveup.png build\files\ending_giveup.hir
%PICTCONV% %PARAMS% data\ending_out_of_money.png build\files\ending_out_of_money.hir
%PICTCONV% %PARAMS% data\ending_out_of_time.png build\files\ending_out_of_time.hir

:: Victory
%PICTCONV% %PARAMS% data\ending_victory.png build\files\ending_victory.hir




:: Monochrome pictures
%PICTCONV% -f0 -f0 -o2 data\funcom_logo_240x200.png build\files\funcom_logo_240x200.hir
%PICTCONV% -f0 -f0 -o2 data\valp_outline.png build\files\valp_outline.hir
%PICTCONV% -f0 -f0 -o2 data\oslo_map.png build\files\oslo_map.hir

:: Locations
%PICTCONV% -f0 -f0 -o2 data\location_vigeland.png build\files\location_vigeland.hir
%PICTCONV% -f0 -f0 -o2 data\location_opera.png build\files\location_opera.hir
%PICTCONV% -f0 -f0 -o2 data\location_holmenkolen.png build\files\location_holmenkolen.hir
%PICTCONV% -f0 -f0 -o2 data\location_jernbanetorget.png build\files\location_jernbanetorget.hir
%PICTCONV% -f0 -f0 -o2 data\location_akerbrygge.png build\files\location_akerbrygge.hir
%PICTCONV% -f0 -f0 -o2 data\location_kingscastle.png build\files\location_kingscastle.hir
%PICTCONV% -f0 -f0 -o2 data\location_sognsvann.png build\files\location_sognsvann.hir
%PICTCONV% -f0 -f0 -o2 data\location_vikingship_museum.png build\files\location_vikingship_museum.hir
%PICTCONV% -f0 -f0 -o2 data\location_munch_museum.png build\files\location_munch_museum.hir
%PICTCONV% -f0 -f0 -o2 data\location_ibsen_museum.png build\files\location_ibsen_museum.hir
%PICTCONV% -f0 -f0 -o2 data\location_norwegian_folk_museum.png build\files\location_norwegian_folk_museum.hir
%PICTCONV% -f0 -f0 -o2 data\location_kon_tiki_museum.png build\files\location_kon_tiki_museum.hir
%PICTCONV% -f0 -f0 -o2 data\location_akershus_fortress.png build\files\location_akershus_fortress.hir
%PICTCONV% -f0 -f0 -o2 data\location_national_gallery.png build\files\location_national_gallery.hir
%PICTCONV% -f0 -f0 -o2 data\location_natural_history_museum.png build\files\location_natural_history_museum.hir

%PICTCONV% -f0 -f0 -o2 data\Font6x8.png build\files\Font6x8.hir
%PICTCONV% -f0 -f0 -o2 data\Font6x6.png build\files\Font6x6.hir

:: Sample

%SAMPLETWEAKER% data\Funcom-mono-8.raw build\files\FuncomJingle.raw
::%OSDK%\bin\Bin2Txt -s1 -f2 build\sample.raw sample.s _FuncomJingle
::echo _FuncomJingleEnd >> sample.s 


:: YM Musics
SET YM2MYM=%osdk%\Bin\ym2mym.exe -m15360
SET PARAMS=-f2 -h1 -s1

%YM2MYM% "data\Decade Reset.ym" build\files\DecadeReset.ym

::pause


