@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg


C:\sources\pc\tools\Oric\MemMap\MemMap_debug.exe build\symbols map.htm LcpIntro %OSDK%\documentation\documentation.css
explorer map.htm


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

