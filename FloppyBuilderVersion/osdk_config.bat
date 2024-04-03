@ECHO OFF

::
:: Set the build paremeters
::
SET VERSION=0.1

:: Versions we want to build (if undefined, it will only build TEST_LANGUAGE)
::SET BUILD_LANGUAGES=EN,FR

:: Version we want to launch when testing
SET TEST_LANGUAGE=EN
::SET TEST_LANGUAGE=FR

SET OSDKBRIEF=NOPAUSE
SET OSDKADDR=
SET OSDKFILE=
SET OSDKNAME=EncounterHD-%LANGUAGE%
SET OSDKDISK=%OSDKNAME%.dsk

SET OSDKFILE_SPLASH=splash_main splash_utils display_basic loader_api irq keyboard distorter costable last_module
SET OSDKFILE_INTRO=intro_main score common intro_utils intro_text loader_api irq audio keyboard time display_basic display akyplayer intro_music intro_music_typewriter last_module
SET OSDKFILE_GAME=game_main input_system bytestream common game_misc game_data game_text game_utils loader_api irq audio keyboard time display_basic display last_module
SET OSDKFILE_OUTRO=outro_main score outro_text input_system common outro_utils loader_api irq audio keyboard display_basic display last_module
