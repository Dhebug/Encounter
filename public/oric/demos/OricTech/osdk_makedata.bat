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

:: Charmap
%PICTCONV% -f5 -d0 -o2 data\VIP_Scroll.png build\files\VIPScroll.hir
%PICTCONV% -f5 -d0 -o2 data\font_30x40.png build\files\font_30x40.hir
%PICTCONV% -f5 -d0 -o2 data\overlay.png build\files\overlay.hir
::pause

%PICTCONV% -f0 -d0 -o2 data\Font6x8.png build\files\Font6x8.hir
%PICTCONV% -f0 -d0 -o2 data\Font6x6.png build\files\Font6x6.hir

%PICTCONV% -f0 -d0 -o2 data\vip_rasters.png build\files\vip_rasters.hir
%PICTCONV% -f0 -d0 -o2 data\cloud.png build\files\cloud.hir
%PICTCONV% -f0 -d0 -o2 data\rain_drop.png build\files\rain_drop.hir
%PICTCONV% -f0 -d0 -o2 data\long_scroller.png build\files\long_scroller.hir

%PICTCONV% -f1 -d0 -o2 -t0 data\SoundWarning.png build\files\SoundWarning.hir


:: Sample

%SAMPLETWEAKER% data\Sample.raw build\files\BoomTschak.raw
%SAMPLETWEAKER% data\SampleDefence.raw build\files\SampleDefence.raw
%SAMPLETWEAKER% data\SampleForce.raw build\files\SampleForce.raw
%SAMPLETWEAKER% data\SampleHa.raw build\files\SampleHa.raw
%SAMPLETWEAKER% data\SampleYeah.raw build\files\SampleYeah.raw
%SAMPLETWEAKER% data\SampleChimeLoopStart.raw build\files\SampleChimeLoopStart.raw
%SAMPLETWEAKER% data\SampleChimeLoopEnd.raw build\files\SampleChimeLoopEnd.raw
%SAMPLETWEAKER% data\SampleMusicNonStop.raw build\files\SampleMusicNonStop.raw
%SAMPLETWEAKER% data\SampleTechnoPop.raw build\files\SampleTechnoPop.raw


:: YM Musics
::SET YM2MYM=%osdk%\Bin\ym2mym.exe -m15360

SET YM2MYM=%osdk%\Bin\ym2mym.exe -m15360 -df2900

:: Should cut the music at about 58 seconds (58*50=2900)
:: 8868 frames in the music
:: 		length	124152	unsigned long (8868*14=124152)

%YM2MYM% "data\ThalionIntro.ym" build\files\ThalionIntro.mym

::pause


