::@echo off

:: Create the folders we need
md build
pushd build
md files
popd

::
:: Build data for the demo, is that a Slide Disk, or a Music Show?
::

:: Pictures
SET PICTCONV=%OSDK%\Bin\PictConv
SET PARAMS=-f1 -d0 -o2 -u1 -t1

::%PICTCONV% %PARAMS% data\logo_fire.png build\files\logo_fire.hir
%PICTCONV% %PARAMS% data\logo-defence_force-fra-out.png build\files\logo_defenceforce.hir
%PICTCONV% %PARAMS% data\demo_credits-fra-out.png build\files\demo_credits-fra-out.hir
%PICTCONV% %PARAMS% data\cake_no_flames.png build\files\cake_no_flames.hir
%PICTCONV% %PARAMS% data\party_outside.png build\files\party_outside.hir
%PICTCONV% %PARAMS% data\badestamp.png build\files\badestamp.hir
%PICTCONV% %PARAMS% data\big_screen.png build\files\big_screen.hir
%PICTCONV% %PARAMS% data\small_size_screens.png build\files\small_size_screens.hir
%PICTCONV% %PARAMS% data\screens_60x50.png build\files\screens_60x50.hir
%PICTCONV% %PARAMS% data\flame_anim_strip.png build\files\flame_anim_strip.hir
%PICTCONV% %PARAMS% data\logo_zerofx.png build\files\logo_zerofx.hir

:: Monochrome pictures
%PICTCONV% -f0 -f0 -o2 data\logos_3x120x100.png build\files\logos_3x120x100.hir
%PICTCONV% -f0 -f0 -o2 data\Font6x8_ArtDeco.png build\files\Font6x8_ArtDeco.hir
%PICTCONV% -f0 -f0 -o2 data\Font6x6.png build\files\Font6x6.hir
%PICTCONV% -f0 -f0 -o2 data\kindergarden_240.png build\files\kindergarden_240.hir
%PICTCONV% -f0 -f0 -o2 data\bonfire_anim_strip.png build\files\bonfire_anim_strip.hir
%PICTCONV% -f0 -f0 -o2 data\the_real_party.png build\files\the_real_party.hir

:: YM Musics
SET YM2MYM=%osdk%\Bin\ym2mym.exe -m15360
SET PARAMS=-f2 -h1 -s1

%YM2MYM% "data\Decade Reset.ym" build\files\DecadeReset.ym

::pause


