@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg

::
:: Convert data here
::
MD BUILD
%OSDK%\bin\pictconv -u1 -m0 -f0 -o1 data\font_6x8_mystery.png build\font.tap

%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\title.png build\title.tap

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
