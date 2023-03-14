@ECHO OFF

::
:: Set the build paremeters
::
SET OSDKBRIEF=NOPAUSE
SET OSDKADDR=
SET OSDKFILE=
SET OSDKNAME=EncounterHD
SET OSDKDISK=%OSDKNAME%.dsk

SET OSDKFILE_INTRO=intro_main intro_utils loader_api irq keyboard time display
SET OSDKFILE_GAME=game_main game_utils loader_api irq keyboard time display