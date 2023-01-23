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


%osdk%\bin\Bas2Tap -b2t1 menu.bas build\menu.tap

::
:: Launch the compilation of files
::
CALL %OSDK%\bin\make.bat %OSDKFILE%
GOTO End

ECHO Making big file
COPY Build\Tape2disk.tap+Build\Tape2disk.tap Build\Tape2disk_big.tap
DEL Build\Tape2disk.tap
REN Build\Tape2disk_big.tap Tape2disk.tap
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
