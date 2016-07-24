::@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg


::
:: Set the build paremeters
::
CALL osdk_config.bat


::
:: Launch the compilation of files
::
CALL %OSDK%\bin\make.bat %OSDKFILE%

::@ECHO ON

::
:: Convert the picture
::
%osdk%\bin\pictconv -o0 -f1 -o1 data\solskogen.png build\logo.hir
::pause

::
:: Rename files so they have friendly names on the disk
::
%OSDK%\bin\taptap ren build\%OSDKNAME%.tap "MCP40" 0

::pause

ECHO Building DSK file
%OSDK%\bin\tap2dsk -iCLS:MCP40 build\%OSDKNAME%.TAP build\logo.hir build\%OSDKNAME%.dsk
%OSDK%\bin\old2mfm build\%OSDKNAME%.dsk


GOTO End


::
:: Outputs an error message
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End


:End
pause