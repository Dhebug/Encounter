@ECHO OFF

::
:: Set the build paremeters
::


SET XAINPUT=%XAINPUT%,NOISE,WHITE,WORLD

SET OSDKADDR=$500
SET OSDKLINK=-B
SET OSDKNAME=sp99

:: Include as wanted in memory. Note frame which goes up to the screen and 
:: THEN performs a .bss section with *=$c000 to include map and sound in overlay!

SET OSDKFILE= header
SET OSDKFILE=%OSDKFILE% NOISE\noise-start NOISE\groutines NOISE\isofuncs NOISE\auxiliar NOISE\clipping NOISE\collision NOISE\occlusions NOISE\spritemov NOISE\noise-tail
SET OSDKFILE=%OSDKFILE% WHITE\white 
SET OSDKFILE=%OSDKFILE% mapload sppic world\bkgpic disk sp1999 stringsc tail frame sound

:: List of files to put in the DSK file.
:: Implicitely includes BUILD/%OSDKNAME%.TAP
SET OSDKTAPNAME="SP99"
SET OSDKDISK=world\world.tap  run99.tap ..\intro\build\intro.tap 
SET OSDKDNAME=" -- SPACE:1999 --"
SET OSDKINIST="!RUN99.COM"



:: Uncomment to force to fullscreen mode
SET OSDKDOSBOX=

::SET OSDKCOMP=-O3

