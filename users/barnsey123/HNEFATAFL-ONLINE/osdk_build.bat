@ECHO OFF


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
:: CALL %OSDK%\bin\make.bat %OSDKFILE%
CALL %OSDKBIN%\make.bat %OSDKFILE%

%OSDKBIN%\tap2dsk.exe -i"!HNEFLITE" BUILD\HNEFLITE.TAP HNEFATAFL-ONLINE.DSK
%OSDKBIN%\old2mfm.exe HNEFATAFL-ONLINE.DSK

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