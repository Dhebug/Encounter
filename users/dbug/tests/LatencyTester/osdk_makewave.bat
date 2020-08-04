
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
echo %OSDKNAME% > build\name.txt
%osdk%\bin\tap2wav.exe build\%OSDKNAME%.tap slow.wav
%osdk%\bin\tap2cd.exe build\%OSDKNAME%.tap fast.wav <build\name.txt
GOTO End


::
:: Outputs an error message
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
IF "%OSDKBRIEF%"=="" PAUSE
pause
GOTO End


:End
