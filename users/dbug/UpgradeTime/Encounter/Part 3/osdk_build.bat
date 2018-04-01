@ECHO OFF
TITLE OSDK

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
%OSDK%\bin\tap2dsk -iCLS:ENCOUNTER %OSDKNAME%.TAP font.tap title.tap NONE.tap 1.tap 2.tap 3.tap 4.tap 5.tap 6.tap 7.tap 8.tap 9.tap 10.tap 11.tap 12.tap 13.tap 14.tap 15.tap 16.tap 17.tap 18.tap 19.tap 20.tap 21.tap 22.tap 23.tap 24.tap 25.tap 26.tap 27.tap 28.tap 29.tap 30.tap 31.tap 32.tap 33.tap 34.tap 35.tap 36.tap 37.tap 38.tap 39.tap 40.tap 41.tap 42.tap %OSDKNAME%.dsk
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
