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
SET PARAMS=-f1 -d0 -o2 -u1

%PICTCONV% %PARAMS% data\twilighte_im_title.png build\files\twilighte_im_title.hir
%PICTCONV% %PARAMS% data\twilighte_whitehall.png build\files\twilighte_whitehall.hir
%PICTCONV% %PARAMS% data\twilighte_im_sprites.png build\files\twilighte_im_sprites.hir
%PICTCONV% %PARAMS% data\space_1999_sparks.png build\files\space_1999_sparks.hir
%PICTCONV% %PARAMS% data\twilighte_otype_1.png build\files\twilighte_otype_1.hir
%PICTCONV% %PARAMS% data\dbug_karhu.png build\files\dbug_karhu.hir
%PICTCONV% %PARAMS% data\dbug_space1999_planets.png build\files\dbug_space1999_planets.hir
%PICTCONV% %PARAMS% data\dbug_atmos_connectors.png build\files\dbug_atmos_connectors.hir
%PICTCONV% %PARAMS% data\dbug_space1999.png build\files\dbug_space1999.hir
%PICTCONV% %PARAMS% data\dbug_1337_logo.png build\files\dbug_1337_logo.hir
%PICTCONV% %PARAMS% data\dbug_oric1.png build\files\dbug_oric1.hir
%PICTCONV% %PARAMS% data\twilighte_tol_title.png build\files\twilighte_tol_title.hir
%PICTCONV% %PARAMS% data\twilighte_tol_doors.png build\files\twilighte_tol_doors.hir
%PICTCONV% %PARAMS% data\skooldaze.png build\files\skooldaze.hir
%PICTCONV% %PARAMS% data\toxic_slime.png build\files\toxic_slime.hir
%PICTCONV% %PARAMS% data\twilighte_ripped.png build\files\twilighte_ripped.hir
%PICTCONV% %PARAMS% data\murder_on_the_atlantic.png build\files\murder_on_the_atlantic.hir
%PICTCONV% %PARAMS% data\damsel.gif build\files\damsel.hir
%PICTCONV% %PARAMS% data\dbug_windows95.gif build\files\dbug_windows95.hir
%PICTCONV% %PARAMS% data\dbug_yessagician.gif build\files\dbug_yessagician.hir
%PICTCONV% %PARAMS% data\diamond_2.gif build\files\diamond_2.hir
%PICTCONV% %PARAMS% data\exocet_blueface.gif build\files\exocet_blueface.hir
%PICTCONV% %PARAMS% data\exocet_fists.gif build\files\exocet_fists.hir
%PICTCONV% %PARAMS% data\exocet_moonguy.gif build\files\exocet_moonguy.hir
%PICTCONV% %PARAMS% data\karate_2.gif build\files\karate_2.hir
%PICTCONV% %PARAMS% data\mooz_oric.gif build\files\mooz_oric.hir
%PICTCONV% %PARAMS% data\mooz_supertomato.gif build\files\mooz_supertomato.hir
%PICTCONV% %PARAMS% data\prez_story.gif build\files\prez_story.hir
%PICTCONV% %PARAMS% data\tomb_1.gif build\files\tomb_1.hir
%PICTCONV% %PARAMS% data\trois_mats.gif build\files\trois_mats.hir
%PICTCONV% %PARAMS% data\twilighte_beast.gif build\files\twilighte_beast.hir
%PICTCONV% %PARAMS% data\twilighte_dragons.gif build\files\twilighte_dragons.hir
%PICTCONV% %PARAMS% data\twilighte_pegasus.gif build\files\twilighte_pegasus.hir
%PICTCONV% %PARAMS% data\twilighte_sonix.gif build\files\twilighte_sonix.hir
%PICTCONV% %PARAMS% data\mooz_barbitoric.gif build\files\mooz_barbitoric.hir
%PICTCONV% %PARAMS% data\mondrian.png build\files\mondrian.hir

%PICTCONV% %PARAMS% data\output-buffy.png  build\files\output-buffy.hir
%PICTCONV% %PARAMS% data\output-homer.png  build\files\output-homer.hir
%PICTCONV% %PARAMS% data\output-lena.png  build\files\output-lena.hir
%PICTCONV% %PARAMS% data\Flowers.bmp build\files\flowers_gloky.hir
%PICTCONV% %PARAMS% data\pinky-indecence.bmp build\files\pinky-indecence.hir
%PICTCONV% %PARAMS% data\pinky-breast.bmp build\files\pinky-breast.hir
%PICTCONV% %PARAMS% data\einstein.png build\files\einstein.hir
%PICTCONV% %PARAMS% data\eastwood.bmp build\files\eastwood.hir

%PICTCONV% %PARAMS% data\output-mire.png  build\files\output-mire.hir

:: Monochrome pictures
%PICTCONV% -f0 -f0 -o2 data\title_picture.png build\files\title_picture.hir
%PICTCONV% -f0 -f0 -o2 data\title_picture_2.png build\files\title_picture_2.hir
%PICTCONV% -f0 -f0 -o2 data\british_board_censors.png build\files\british_board_censors.hir
%PICTCONV% -f0 -f0 -o2 data\Font6x8_ArtDeco.png build\files\Font6x8_ArtDeco.hir
%PICTCONV% -f0 -f0 -o2 data\Font12x16_ArtDeco.png build\files\Font12x16_ArtDeco.hir

%PICTCONV% -f0 -f0 -o4 data\loading_data.png code\loading_data.s


:: YM Musics
SET YM2MYM=%osdk%\Bin\ym2mym.exe -m15360
SET PARAMS=-f2 -h1 -s1

%YM2MYM% "data\BeBop.ym" build\files\BeBop.ym

%YM2MYM% "data\Bitmap Mania.ym" build\files\ChrisMad.BitmapMania.ym
%YM2MYM% "data\Best Part of The Creation.ym" build\files\BigAlec-BestPartOfCreation.ym
%YM2MYM% "data\Arsch.ym" build\files\ChristianHellmanzik-Arsch.ym
%YM2MYM% "data\Thrust.ym" build\files\Thrust.ym
%YM2MYM% "data\Onslaught 2.ym" build\files\TonyWilliams-Onslaught2.ym
%YM2MYM% "data\Xenon 1.ym" build\files\Xenon.ym
%YM2MYM% "data\For your Loader #1.ym" build\files\Jess-BmgsLoader.ym 
%YM2MYM% "data\Zynaps 1.ym" build\files\Zynaps.ym
%YM2MYM% "data\Cuddly - Resetscreen.ym" build\files\CuddlyResetScreen.YM 
%YM2MYM% "data\Weird Dreams 1.ym" build\files\WeirdDreams.ym
%YM2MYM% "data\Deflektor 1.ym" build\files\Deflektor.ym
%YM2MYM% "data\Rampage 1.ym" build\files\Rampage.ym
%YM2MYM% "data\Cuddly - 3D doc.ym" build\files\JochenHippel-Cuddly-3DDoc.ym
%YM2MYM% "data\Foxx-Startunnel.ym" build\files\ChristianHellmanzik-StarTunnel.ym
%YM2MYM% "data\Rings of Medusa 1 - title.ym" build\files\music_rings_of_medusa.ym
%YM2MYM% "data\Escape from the Planet of the Robot Monsters 1.ym" build\files\MattFurniss-EscapeFromThePlanetOfRobotMonsters.ym 



pause


