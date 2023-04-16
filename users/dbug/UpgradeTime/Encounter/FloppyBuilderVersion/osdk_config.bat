@ECHO OFF

::
:: Set the build paremeters
::
SET OSDKBRIEF=NOPAUSE
SET OSDKADDR=
SET OSDKFILE=
SET OSDKNAME=EncounterHD
SET OSDKDISK=%OSDKNAME%.dsk

SET OSDKFILE_INTRO=intro_main common intro_utils loader_api irq audio keyboard time display last_module
SET OSDKFILE_GAME=game_main common game_misc game_data game_text game_utils loader_api irq audio keyboard time display last_module