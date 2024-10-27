@ECHO OFF

::
:: Set the build paremeters
:: 0.1 - Most of the original versions sents to XiA
:: 0.2 - Test version with new intro music
:: 0.3 - Test version with the new game start that shows the map, and printer output
:: 0.4 - First version of the game 100% playable from start to finish - 1 second delay per fade  - game finished with 1:30:30 remaining
:: 0.5 - First pass of bug fixes, added some audio as well, colorful intro title - 4 seconds delay per fade -
:: 0.6 - Added some sound effects, better scores handling, music in the end credits
:: 0.7 - Game over music, achievements, loading messages
:: 0.8 - Version to Dom, Symon, eXplOit3r
:: 0.8.1 - Changed the title picture, fixed the achievements not saving, added some sounds
:: 0.8.2 - Added KBFR, KBUK, interactible door, better error sounds and messages
:: 0.8.3 - Added a configuration menu, quite a few bug fixes as well
:: 0.8.4 - Added support for second shift key, twine is fully changed, help is colored, new cross, inventory limit
:: 0.8.5 - The map can be navigated with arrows, quite a few changes all over the place really
:: 0.8.6 - Keyboard improvements, CTRL+DEL, misc fixes to the end sequence, fixed the intro TEXT to HIRES glitch
:: 0.8.7 - Fixed the HELP bug, improved arrow navigation, added some information on the recipes, interactive windows
:: 0.8.8 - Numerous little tweaks, added alarm sensor, blinking alarm light, interactive tv and console, tombstone image
::
SET VERSION=0.8.8
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
IF "%PRODUCT_TYPE%"=="GAME_RELEASE" SET OSDKDISK=%OSDKNAME%-v%VERSION%.dsk
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
SET OSDKFILE_SPLASH=splash_main splash_utils display_basic loader_api irq audio keyboard distorter costable akyplayer last_module
SET OSDKFILE_INTRO=intro_main score common intro_utils intro_text loader_api irq audio keyboard time display_basic akyplayer last_module
SET OSDKFILE_GAME=game_main input_system input_utils bytestream common game_misc game_data game_items game_locations game_text game_utils loader_api irq printer audio keyboard time display_basic display akyplayer last_module
SET OSDKFILE_OUTRO=outro_main score outro_text input_system input_utils common outro_utils loader_api irq audio keyboard display_basic display akyplayer last_module
