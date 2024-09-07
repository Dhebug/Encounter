@ECHO OFF

::
:: Set the build paremeters
:: 0.1 - Most of the original versions sents to XiA
:: 0.2 - Test version with new intro music
:: 0.3 - Test version with the new game start that shows the map, and printer output
SET VERSION=0.3

:: Versions we want to build (if undefined, it will only build TEST_LANGUAGE)
::SET BUILD_LANGUAGES=EN,FR

:: Version we want to launch when testing
SET TEST_LANGUAGE=EN
::SET TEST_LANGUAGE=FR

:: Module for which we want to enable the debug symbols.
::SET TEST_MODULE=SPLASH
::SET TEST_MODULE=INTRO
SET TEST_MODULE=GAME
::SET TEST_MODULE=OUTRO

:: Breakpoints for the various modules
SET BREAKPOINTS_GAME=_AskInput,_Initializations


SET FINAL_TARGET_DISK=S:\EncounterHD-EN.dsk

SET OSDKBRIEF=NOPAUSE
SET OSDKADDR=
SET OSDKFILE=
SET OSDKNAME=EncounterHD-%LANGUAGE%
SET OSDKDISK=%OSDKNAME%.dsk
SET OSDKVERBOSITY=1

:: These are the definition of the various files used by each module.
:: After a module has been built once, and as long as the files are not deleted, you can
:: then comment out the line to speed up compile time.
:: Obviously remember to enable them again else the changes you make will not be rebuilt!
SET OSDKFILE_SPLASH=splash_main splash_utils display_basic loader_api irq keyboard distorter costable last_module
SET OSDKFILE_INTRO=intro_main score common intro_utils intro_text loader_api irq audio keyboard time display_basic  akyplayer last_module
SET OSDKFILE_GAME=game_main input_system bytestream common game_misc game_data game_items game_locations game_text game_utils loader_api irq audio keyboard time display_basic display last_module
SET OSDKFILE_OUTRO=outro_main score outro_text input_system common outro_utils loader_api irq audio keyboard display_basic display last_module
