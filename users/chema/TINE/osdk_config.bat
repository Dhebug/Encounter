@ECHO OFF

::
:: Set the build paremeters
::

SET XAINPUT=%XAINPUT%,OOBJ3D

SET OSDKADDR=$500
SET OSDKNAME=TINE
SET OSDKCOMP=
SET OSDKLINK=-B



SET OSDKFILE=main
SET OSDKFILE=%OSDKFILE% oobj3d\lib3d oobj3d\obj3d oobj3d\filler oobj3d\LineDraw 
SET OSDKFILE=%OSDKFILE% oobj3d\clip oobj3d\mextra oobj3d\circle oobj3d\debris
SET OSDKFILE=%OSDKFILE% data ships radar stars random tinefuncs
SET OSDKFILE=%OSDKFILE% dictc text tineinc galaxy cockpit graphics
SET OSDKFILE=%OSDKFILE% tactics universe tineloop keyboard disk sound tail
SET OSDKFILE=%OSDKFILE% oobj3d\lib3dtab models


:: List of files to put in the DSK file.
:: Implicitely includes BUILD/%OSDKNAME%.TAP
SET OSDKTAPNAME="TINE"
SET OSDKDISK=oobj3d\overlay.tap  
::run99.tap ..\intro\build\intro.tap 
SET OSDKDNAME=" -- 1337 --"
SET OSDKINIST="PAPER 0:INK 0:HIRES:TINE.COM"

