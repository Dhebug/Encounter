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
:: 0.8.9 - Input checking while entering commands, inventory scroll with the keyboard, visible ladder, keyboard buffer flushed
:: 0.9.0 - Numerous improvements to the French version, CTRL+DEL removes entire words, fixed the black tape bug, clock is stop when game ends
:: 0.9.1 - Quite a few bug fixes, 99% finished French version, quite a few things moved around, many descriptions added
:: 0.9.2 - Faster loads, second documentation page, disapearing containers fix, escape shows help, text fixes
:: 0.9.3 - Fixed a couple of crash bugs, improved the container check, fixed some typos
:: 0.9.4 - Mostly French fixes, but also a tweak on the count down timer, and inspecting the basement window from the lader now works
:: 0.9.5 - Improvements to the TP, dove, sound volume, and plenty of small bug fixes and items behaviors
:: 0.9.6 - Changed the up and down arrows, scores are now cyan instead of blue, text fixes, improvements to the bomb and safe interactions
:: 0.9.7 - Fixed a bunch of issues when throwing, droping or taking some items, escaping the bomb and how error messages are shown
:: 0.9.8 - Renamed the suit in French, improved the mortar and pit interactions, fixed sound corruption issue
:: 0.9.9 - Mostly small tweaks and fixed all over
:: 1.0.0 - Launch day version: Mostly small tweaks and fixed all over
:: 1.0.1 - Added 50hz versions, typo fixes, more interactions, added a keyboard buffer 
:: 1.0.2 - Improved some scene graphics, sleeping thung sound, feedback on more items
:: 1.0.3 - Added some key press waits after elements that take a long time to read, fixed the UK map
:: 1.0.4 - Optimized HandleByteStream and PrintInventory, added a Coleco image, revamped the alarm system, tweaked timings and key presses
:: 1.0.5 - The parser does not allow anymore adding more keywords than what the command supports
:: 1.0.6 - Fixed the "use key", small explosion, some typo fix, and alarm triggering
:: 1.1.0 - New version of Oricutron, new controller based menu option system
:: 1.1.1 - Polished the joystick mode, press key indicator, copyright date updated
:: 1.1.2 - Usable Oric 1, 18 sectors per track, kleptomaniac message
:: 1.2.0 - Fixed highscore truncation, playable minigame, added two achievements
:: 1.2.1 - Added detailed images for the well and the trashcan, and a new Dune novel item
:: 1.2.2 - Shifted back the achievement list to the left to avoid some French achievements to corrupt the screen
:: 1.2.3 - The intro now requires ESC to quit, demo updated to give access to the main floor of the mansion
:: 1.2.4 - Improved the controls when playing with Joystick, fixed a few incorrect error messages as well
:: 1.2.5 - Updated Joystick support in Oricutron, fixed a typo, added a message when trying to use the bucket
:: 1.2.6 - Reordered list of words, improved net handling, improved containers selection, fixes to the inventory size limits
:: 1.2.7
::
SET VERSION=1.2.7
SET BASENAME=EncounterHD

:: Disk geometry parameters: These are passed to the floppy builder and will impact the floppy disk format.
:: The original release of Encounter used 17 sectors per track, 42 tracks, 2 sides, and an interleave of 6.
:: New versions will use 18 sectors per track (interleave value is still to be determined)
:: BITMAP is an additional sector used to make the disk compatible with the SEDORIC DIR and BACKUP commands
SET DISK_SIDES=2
SET DISK_TRACKS=42
SET DISK_SECTORS=18
SET DISK_INTERLEAVE=6
SET DISK_WITH_BITMAP=0
SET EXPORT_HFE_VERSION=0
SET EXPORT_IMD_VERSION=0

:: Versions we want to build (if undefined, it will only build TEST_LANGUAGE)
SET BUILD_LANGUAGES=EN,FR
SET BUILD_FREQUENCIES=60HZ,50HZ

:: Version we want to launch when testing
SET TEST_LANGUAGE=EN
SET TEST_LANGUAGE=FR

:: Frequency we want to launch when testing
SET TEST_FREQUENCY=50HZ
SET TEST_FREQUENCY=60HZ

:: To distinguish the way the game is built
SET PRODUCT_TYPE=GAME_DEMO
SET PRODUCT_TYPE=TEST_MODE
SET PRODUCT_TYPE=GAME_RELEASE


:: Module for which we want to enable the debug symbols.
::SET TEST_MODULE=SPLASH
::SET TEST_MODULE=INTRO
SET TEST_MODULE=GAME
::SET TEST_MODULE=OUTRO

:: Breakpoints for the various modules
SET BREAKPOINTS_SPLASH= 
SET BREAKPOINTS_INTRO=
SET BREAKPOINTS_GAME=
SET BREAKPOINTS_OUTRO=

SET OSDKBRIEF=NOPAUSE
SET OSDKADDR=
SET OSDKFILE=
SET OSDKNAME=%BASENAME%-%TEST_LANGUAGE%-%TEST_FREQUENCY%
IF "%PRODUCT_TYPE%"=="GAME_DEMO"    SET OSDKDISK=%OSDKNAME%-Demo-v%VERSION%.dsk
IF "%PRODUCT_TYPE%"=="GAME_RELEASE" SET OSDKDISK=%OSDKNAME%-v%VERSION%.dsk
IF "%PRODUCT_TYPE%"=="TEST_MODE"    SET OSDKDISK=%OSDKNAME%-Test-v%VERSION%.dsk
SET OSDKVERBOSITY=1

SET FINAL_TARGET_DISK=C:\Projects\Encounter\SteamContent\Game\
SET FINAL_TARGET_DISK2=C:\Projects\Encounter\ItchIoContent\Game\
::SET FINAL_TARGET_HFE=F:\DiskTest_s%DISK_SECTORS%_i%DISK_INTERLEAVE%.hfe

:: Emulator settings
SET OSDKEMUL=ORICUTRON
SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS% -m atmos
SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS%-R soft --scanlines off
::SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS%-R soft --scanlines on
::SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS%-R opengl --scanlines on
::SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS% -k microdisc
::SET OSDKEMULPARAMS=%SET OSDKEMULPARAMS% -k jasmin

:: These are the definition of the various files used by each module.
:: After a module has been built once, and as long as the files are not deleted, you can
:: then comment out the line to speed up compile time.
:: Obviously remember to enable them again else the changes you make will not be rebuilt!
SET OSDKFILE_SPLASH=splash_main splash_utils display_basic loader_api irq audio keyboard distorter costable akyplayer last_module
SET OSDKFILE_INTRO=intro_main score common intro_utils intro_text loader_api irq audio keyboard time display_basic akyplayer last_module
SET OSDKFILE_GAME=game_main input_system input_utils bytestream common game_data game_items game_locations game_text game_utils loader_api irq audio keyboard time display_basic display akyplayer last_module
SET OSDKFILE_OUTRO=outro_main score outro_text  input_utils common outro_utils loader_api irq audio keyboard display_basic display akyplayer last_module
