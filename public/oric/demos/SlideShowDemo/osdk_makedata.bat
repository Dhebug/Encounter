::
:: Build data for the demo, is that a Slide Disk, or a Music Show?
::
SET BIN2TXT=%osdk%\bin\bin2txt

SET PICTCONV=%OSDK%\Bin\PictConv
SET PICTCONV=D:\svn\public\pc\tools\osdk\main\Osdk\_final_\Bin\PictConv
SET PARAMS=-f1 -d0 -o2 -t1
SET PARAMS=-f1 -d0 -o2 
::goto EndPictures
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
:EndPictures
%PICTCONV% -f0 -f0 -o2 data\font_24x20.png build\files\font_24x20.hir



::goto EndMusics
SET PARAMS=-f2 -h1 -s1
SET YM2MYM=D:\svn\public\pc\tools\osdk\main\Osdk\_final_\Bin\ym2mym.exe

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

%YM2MYM% data\BigAlec-NoSecondPrize.ym build\files\music_no_second_prize.ym
%YM2MYM% data\JochenHippel-LeavingTerramis.YM build\files\music_leaving_terramis.ym
%YM2MYM% data\CUDDLY1.YM build\files\music_cuddly.ym
%YM2MYM% data\JochenHippel-RingsOfMedusa.YM build\files\music_rings_of_medusa.ym
%YM2MYM% data\northtar.ym build\files\northtar.ym
%YM2MYM% data\TEST.ym build\files\TEST.ym



:EndMusics

pause

