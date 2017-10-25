@ECHO OFF

::
:: Set the build paremeters
::
SET OSDKLINK=-B
SET OSDKADDR=$c000
SET OSDKNAME=B7
SET OSDKFILE=main  
SET OSDKFILE=%OSDKFILE% data floppycode\loader_api keyboard thread engine core  mouse verbexec object
SET OSDKFILE=%OSDKFILE% inventory box script functions text resource sndeng
SET OSDKFILE=%OSDKFILE% dialog debug 

