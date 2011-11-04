@ECHO OFF

::
:: Set the build paremeters
::
SET OSDKADDR=$500
SET OSDKNAME=ORIGA
SET OSDKTAPNAME=INTRO

SET OSDKFILE=main rout_keyboard rout_divers rout_text rout_hires
SET OSDKFILE=%OSDKFILE% graphs\origa_font graphs\origa_titre graphs\origa_graph graphs\origa_sprite 

::SET OSDKDISK=DSKORIGA
::SET OSDKINIT=INTRO