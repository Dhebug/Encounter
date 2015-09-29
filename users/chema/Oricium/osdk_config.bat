@ECHO OFF

::
:: Set the build paremeters
::
SET OSDKLINK=-B
SET OSDKADDR=$500
SET OSDKNAME=ORICIUM
SET OSDKFILE=  mainloop tilemap data generator keyboard common hero scripts stars engine radar sprites enemies items sndeng sfx auxiliar level panel strings songs tileset 
:SET OSDKCOMP=-O3

:: List of files to put in the DSK file.
:: Implicitely includes BUILD/%OSDKNAME%.TAP
SET OSDKTAPNAME="ORICIUM"
SET OSDKDISK="SCREEN.TAP"
SET OSDKDNAME=" -- ORICIUM --"
SET OSDKINIST="QUIT:HIRES:!SCREEN.BIN:!ORICIUM.COM"