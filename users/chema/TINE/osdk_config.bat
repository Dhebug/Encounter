@ECHO OFF

::
:: Set the build paremeters
::

SET XAINPUT=%XAINPUT%,OOBJ3D

SET OSDKADDR=$500
SET OSDKNAME=1337
SET OSDKCOMP=
SET OSDKLINK=-B



SET OSDKFILE=main
SET OSDKFILE=%OSDKFILE% oobj3d\lib3d oobj3d\LineDraw oobj3d\obj3d oobj3d\filler  
SET OSDKFILE=%OSDKFILE% oobj3d\clip oobj3d\mextra oobj3d\circle 
SET OSDKFILE=%OSDKFILE% graphics random ships data stars  radar tinefuncs
SET OSDKFILE=%OSDKFILE% text tineinc galaxy cockpit keyboard disk 
SET OSDKFILE=%OSDKFILE% tactics universe tineloop sound
SET OSDKFILE=%OSDKFILE% tail oobj3d\lib3dtab models music dictc


:: List of files to put in the DSK file.
:: Implicitely includes BUILD/%OSDKNAME%.TAP
SET OSDKTAPNAME="1337"
SET OSDKDISK=oobj3d\overlay.tap runme.tap intro.tap
::run99.tap ..\intro\build\intro.tap 
SET OSDKDNAME=" -- 1337 --"
SET OSDKINIST="?\"V1.20\":WAIT20:!RUNME.COM"

