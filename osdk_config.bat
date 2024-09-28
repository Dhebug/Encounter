@ECHO OFF

::
:: Set the build paremeters
:: 0.1 - Most of the original versions sents to XiA
:: 0.2 - Test version with new intro music
:: 0.3 - Test version with the new game start that shows the map, and printer output
:: 0.4 - First version of the game 100% playable from start to finish - 1 second delay per fade  - game finished with 1:30:30 remaining
:: 0.5 - First pass of bug fixes, added some audio as well, colorful intro title - 4 seconds delay per fade -
::
SET VERSION=0.5
SET BASENAME=EncounterHD

:: Versions we want to build (if undefined, it will only build TEST_LANGUAGE)
::SET BUILD_LANGUAGES=EN,FR

:: Version we want to launch when testing
SET TEST_LANGUAGE=EN
::SET TEST_LANGUAGE=FR

:: To distinguish the way the game is built
::SET PRODUCT_TYPE=GAME_DEMO
SET PRODUCT_TYPE=GAME_RELEASE
::SET PRODUCT_TYPE=TEST_MODE


:: Module for which we want to enable the debug symbols.
::SET TEST_MODULE=SPLASH
::SET TEST_MODULE=INTRO
SET TEST_MODULE=GAME
::SET TEST_MODULE=OUTRO

:: Breakpoints for the various modules
SET BREAKPOINTS_GAME=_AskInput,_Initializations


SET FINAL_TARGET_DISK=G:\games\EncounterHD-EN.dsk

SET OSDKBRIEF=NOPAUSE
SET OSDKADDR=
SET OSDKFILE=
SET OSDKNAME=%BASENAME%-%LANGUAGE%
IF "%PRODUCT_TYPE%"=="GAME_DEMO"    SET OSDKDISK=%OSDKNAME%-Demo-v%VERSION%.dsk
IF "%PRODUCT_TYPE%"=="GAME_RELEASE" SET OSDKDISK=%OSDKNAME%-%LANGUAGE%-v%VERSION%.dsk
IF "%PRODUCT_TYPE%"=="TEST_MODE"    SET OSDKDISK=%OSDKNAME%-Test-v%VERSION%.dsk
SET OSDKVERBOSITY=1

SET FINAL_TARGET_DISK=G:\games\%OSDKDISK%

:: Emulator settings
SET OSDKEMUL=ORICUTRON
SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS% -m atmos
::SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS%-R soft --scanlines off
SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS%-R opengl --scanlines on
::SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS% -k microdisc
::SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS% -k jasmin

:: These are the definition of the various files used by each module.
:: After a module has been built once, and as long as the files are not deleted, you can
:: then comment out the line to speed up compile time.
:: Obviously remember to enable them again else the changes you make will not be rebuilt!
SET OSDKFILE_SPLASH=splash_main splash_utils display_basic loader_api irq keyboard distorter costable last_module
SET OSDKFILE_INTRO=intro_main score common intro_utils intro_text loader_api irq audio keyboard time display_basic  akyplayer last_module
SET OSDKFILE_GAME=game_main input_system bytestream common game_misc game_data game_items game_locations game_text game_utils loader_api irq printer audio keyboard time display_basic display last_module
SET OSDKFILE_OUTRO=outro_main score outro_text input_system common outro_utils loader_api irq audio keyboard display_basic display last_module
