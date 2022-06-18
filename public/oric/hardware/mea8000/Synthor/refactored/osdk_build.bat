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
CALL %OSDK%\bin\make.bat %OSDKFILE%

CALL %OSDK%\bin\header -a0 -h1 data1.bin build\data1.tap $A000
CALL %OSDK%\bin\header -a0 -h1 data2.bin build\data2.tap $6B00

::pause

::ECHO ON
ECHO Building DSK file
pushd build
%OSDK%\bin\tap2dsk -iCLS:SYNTHOR2 %OSDKNAME%.TAP data1.tap data2.tap %OSDKNAME%.dsk
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
