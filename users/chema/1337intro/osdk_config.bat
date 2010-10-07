@ECHO OFF
ECHO ON

::
:: Set the build paremeters
::

SET XAINPUT=%XAINPUT%,OOBJ3D

SET OSDKADDR=$500
SET OSDKNAME=INTRO
SET OSDKCOMP=
::SET OSDKLINK=-B


SET OSDKFILE=oobj3d\lib3d oobj3d\obj3d 
SET OSDKFILE=%OSDKFILE%  oobj3d\LineDraw models pack text pic_font
SET OSDKFILE=%OSDKFILE%  sun shipscenes scenes stars disk sound tharpack badguy 
SET OSDKFILE=%OSDKFILE%  pic_defenceforce logo draw_df_logo texture starwars main overlay


:: List of files to put in the DSK file.
:: Implicitely includes BUILD/%OSDKNAME%.TAP
SET OSDKTAPNAME="INTRO"
SET OSDKDISK="overlay.tap"
SET OSDKDNAME=" -- 1337 --"
SET OSDKINIST="HIRES:!INTRO.COM"


::SET OSDKDOSBOX=c:\archivos de programa\DOSBox-0.73\dosbox.exe

