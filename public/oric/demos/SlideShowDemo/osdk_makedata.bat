::
:: Build data for the demo, is that a Slide Disk, or a Music Show?
::
SET BIN2TXT=%osdk%\bin\bin2txt

SET PICTCONV=%OSDK%\Bin\PictConv
::SET PICTCONV=D:\svn\public\pc\tools\osdk\main\Osdk\_final_\Bin\PictConv
SET PARAMS=-f1 -d0 -o2 -t1
SET PARAMS=-f1 -d0 -o2 
::goto EndPictures
::%PICTCONV% %PARAMS% data\decal_euler.png build\files\decal_euler.hir

%PICTCONV% %PARAMS% data\twilighte_im_title.png build\files\twilighte_im_title.hir
%PICTCONV% %PARAMS% data\twilighte_whitehall.png build\files\twilighte_whitehall.hir
%PICTCONV% %PARAMS% data\twilighte_im_sprites.png build\files\twilighte_im_sprites.hir
%PICTCONV% %PARAMS% data\space_1999_sparks.png build\files\space_1999_sparks.hir
%PICTCONV% %PARAMS% data\twilighte_otype_1.png build\files\twilighte_otype_1.hir
%PICTCONV% %PARAMS% data\dbug_assembler2002.png build\files\dbug_assembler2002.hir
%PICTCONV% %PARAMS% data\dbug_karhu.png build\files\dbug_karhu.hir
%PICTCONV% %PARAMS% data\defence_force.png build\files\defence_force.hir
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
%PICTCONV% %PARAMS% data\karate.gif build\files\karate.hir
%PICTCONV% %PARAMS% data\karate_2.gif build\files\karate_2.hir
%PICTCONV% %PARAMS% data\krillys.gif build\files\krillys.hir
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
%PICTCONV% %PARAMS% data\mooz_santa.png build\files\mooz_santa.hir
%PICTCONV% %PARAMS% data\mondrian.png build\files\mondrian.hir


%PICTCONV% %PARAMS% data\output-buffy.png  build\files\output-buffy.hir
%PICTCONV% %PARAMS% data\output-dog.png  build\files\output-dog.hir
%PICTCONV% %PARAMS% data\output-homer.png  build\files\output-homer.hir
%PICTCONV% %PARAMS% data\output-lena.png  build\files\output-lena.hir
%PICTCONV% %PARAMS% data\Flowers.bmp build\files\flowers_gloky.hir
%PICTCONV% %PARAMS% data\pinky-indecence.bmp build\files\pinky-indecence.hir
%PICTCONV% %PARAMS% data\pinky-breast.bmp build\files\pinky-breast.hir


%PICTCONV% %PARAMS% -t1 data\output-mire.png  build\files\output-mire.hir


:EndPictures

:: Monochrome pictures
%PICTCONV% -f0 -f0 -o2 data\title_picture.png build\files\title_picture.hir
%PICTCONV% -f0 -f0 -o2 data\title_picture_2.png build\files\title_picture_2.hir
%PICTCONV% -f0 -f0 -o2 data\british_board_censors.png build\files\british_board_censors.hir
%PICTCONV% -f0 -f0 -o2 data\font_24x20.png build\files\font_24x20.hir
%PICTCONV% -f0 -f0 -o2 data\Font6x8_ArtDeco.png build\files\Font6x8_ArtDeco.hir
%PICTCONV% -f0 -f0 -o2 data\Font12x16_ArtDeco.png build\files\Font12x16_ArtDeco.hir
%PICTCONV% -f0 -f0 -o2 data\font_16x16.png build\files\font_16x16.hir

::goto EndMusics
SET PARAMS=-f2 -h1 -s1
SET YM2MYM=%osdk%\Bin\ym2mym.exe

:: Too large
::%YM2MYM% data\BigAlec-Judge.ym build\files\music_back.ym      <- 28 kb
::%YM2MYM% data\BigAlec-Locomotion.ym build\files\music_back.ym <- 17kb

:: Fail to convert

:: Works but sounds like crap :S
::%YM2MYM% data\mav.YM build\files\music_back.ym
::%YM2MYM% data\sabotr2.YM build\files\music_back.ym

:: Works but are not awesome
::%YM2MYM% data\1943.YM build\files\music_back.ym      :: Oldschool game music, not awesome
::%YM2MYM% data\northtar.YM build\files\music_back.ym
::%YM2MYM% data\puzznic.YM build\files\music_back.ym
::%YM2MYM% data\robocop.YM build\files\music_back.ym
::%YM2MYM% data\1943.YM build\files\music_back.ym

:: Work fine but somewhat got truncated?
::%YM2MYM% data\Jess-BmgsLoader.ym build\files\music_back.ym

:: Work fine:
::%YM2MYM% data\BACH.YM build\files\music_back.ym      :: Classic relaxing
::%YM2MYM% data\COUNT02.YM build\files\music_back.ym   :: Works ok
::%YM2MYM% data\COUNT05.YM build\files\music_back.ym   :: Bien pechu - loading screen/please wait style
::%YM2MYM% data\COUNT06.YM build\files\music_back.ym   :: Stressante
::%YM2MYM% data\Turrican-MadMax.YM build\files\music_back.ym  :: Not the best Turrican one
::%YM2MYM% data\SyntaxTerror-MadMax.YM build\files\music_back.ym  :: Definitely a nice one
::%YM2MYM% data\BitmapMania-ChrisMad.YM build\files\music_back.ym :: Typical ChrisMad, funny and punchy
::%YM2MYM% data\Platoon-Whittaker.YM build\files\music_back.ym    :: Classic Whittaker, that works
::%YM2MYM% data\SONG_356.YM build\files\music_back.ym             :: Not bad, not exciting either
::%YM2MYM% data\PYM_INTR.YM build\files\music_back.ym             :: Nice one!
::%YM2MYM% data\JAMBLV4.YM build\files\music_back.ym              :: The one we used in the 4th Charts :) Would be almost re-doable on the Oric actually :D
::%YM2MYM% data\NONAME.YM build\files\music_back.ym               :: Forgot the name of that one, but it was cool!
::BigAlec-NoSecondPrize
::BigAlec-Reality
::%YM2MYM% data\DavidWhittaker-BeyondTheIcePalace.ym build\files\DavidWhittaker-BeyondTheIcePalace.ym 
::%YM2MYM% data\DavidWhittaker-ReturnToGenesis.ym build\files\DavidWhittaker-ReturnToGenesis.ym 
::%YM2MYM% data\DavidWhittaker-Custodian.YM build\files\DavidWhittaker-Custodian.YM
::%YM2MYM% data\TonyWilliams-Onslaught1.ym build\files\TonyWilliams-Onslaught1.ym

%YM2MYM% data\BigAlec-NoSecondPrize.ym build\files\music_no_second_prize.ym
%YM2MYM% data\JochenHippel-LeavingTerramis.YM build\files\music_leaving_terramis.ym
%YM2MYM% data\CUDDLY1.YM build\files\music_cuddly.ym
%YM2MYM% data\JochenHippel-RingsOfMedusa.YM build\files\music_rings_of_medusa.ym
%YM2MYM% data\northtar.ym build\files\northtar.ym
%YM2MYM% data\BeBop.ym build\files\BeBop.ym
%YM2MYM% data\BigAlec-BestPartOfCreation.ym build\files\BigAlec-BestPartOfCreation.ym

%YM2MYM% data\ChrisMad.BitmapMania.ym build\files\ChrisMad.BitmapMania.ym
%YM2MYM% data\ChristianHellmanzik-Arsch.ym build\files\ChristianHellmanzik-Arsch.ym
%YM2MYM% data\ChristianHellmanzik-StarTunnel.ym build\files\ChristianHellmanzik-StarTunnel.ym

%YM2MYM% data\CuddlyMegaballs.YM build\files\CuddlyMegaballs.YM 
%YM2MYM% data\Jess-BmgsLoader.ym build\files\Jess-BmgsLoader.ym 
%YM2MYM% data\JochenHippel-Cuddly-3DDoc.ym build\files\JochenHippel-Cuddly-3DDoc.ym 
%YM2MYM% data\MattFurniss-EscapeFromThePlanetOfRobotMonsters.ym build\files\MattFurniss-EscapeFromThePlanetOfRobotMonsters.ym 
%YM2MYM% data\LTK-MageMix.YM build\files\LTK-MageMix.YM 

%YM2MYM% data\StefanJerowowski-Spherical.ym build\files\StefanJerowowski-Spherical.ym
%YM2MYM% data\SABOTR2.ym build\files\SABOTR2.ym
%YM2MYM% data\TonyWilliams-Onslaught2.ym build\files\TonyWilliams-Onslaught2.ym
%YM2MYM% data\PYM_INTR.YM build\files\PYM_INTR.YM


:EndMusics

pause

