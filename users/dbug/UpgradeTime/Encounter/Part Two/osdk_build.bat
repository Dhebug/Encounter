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

CALL osdk_makedata.bat

::
:: Launch the compilation of files
::
CALL %OSDK%\bin\make.bat %OSDKFILE%

::pause

::ECHO ON
ECHO Building DSK file
pushd build
%OSDK%\bin\tap2dsk -iCLS:ENCOUNTER %OSDKNAME%.TAP font.tap title.tap %OSDKNAME%.dsk
%OSDK%\bin\old2mfm %OSDKNAME%.dsk
popd 

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
