@ECHO OFF

::
:: Set the build paremeters
::
SET VERSION=0.1

:: Versions we want to build
SET BUILD_LANGUAGES=EN,FR
SET BUILD_LANGUAGES=FR

:: Version we want to launch when testing
SET TEST_LANGUAGE=EN
SET TEST_LANGUAGE=FR

SET OSDKBRIEF=NOPAUSE
SET OSDKADDR=
SET OSDKFILE=
SET OSDKNAME=EncounterHD-%LANGUAGE%
SET OSDKDISK=%OSDKNAME%.dsk

SET OSDKFILE_INTRO=intro_main common intro_utils loader_api irq audio keyboard time display last_module
SET OSDKFILE_GAME=game_main common game_misc game_data game_text game_utils loader_api irq audio keyboard time display last_module
