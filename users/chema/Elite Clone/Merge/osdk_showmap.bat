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
:: Generate the HTML file
::
%OSDK%\bin\MemMap.exe build\symbols build\map.htm %OSDKNAME% %OSDK%\documentation\documentation.css

::
:: Display the HTML file
::
explorer build\map.htm

GOTO End


::
:: Outputs an error message
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
pause
GOTO End


:End

