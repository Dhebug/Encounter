@ECHO OFF

::
:: Set the build paremeters
::

SET XAINPUT=%XAINPUT%,OOBJ3D

SET OSDKADDR=$500
SET OSDKNAME=TINE
SET OSDKCOMP=
::SET OSDKLINK=-B


SET OSDKFILE=oobj3d\lib3dtab oobj3d\lib3d oobj3d\obj3d oobj3d\filler oobj3d\LineDraw models radar shiptest main


:: List of files to put in the DSK file.
:: Implicitely includes BUILD/%OSDKNAME%.TAP
::SET OSDKTAPNAME="TINE"
::SET OSDKDISK=world\world.tap  run99.tap ..\intro\build\intro.tap 
::SET OSDKDNAME=" -- ELITE --"
::SET OSDKINIST="TINE.COM"


SET OSDKDOSBOX=c:\archivos de programa\DOSBox-0.65\dosbox.exe

