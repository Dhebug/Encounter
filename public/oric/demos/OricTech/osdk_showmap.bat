@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg


%osdk%\bin\MemMap.exe build\symbols_intro map_intro.htm Intro %OSDK%\documentation\documentation.css
%osdk%\bin\MemMap.exe build\symbols_techtech map_techtech.htm TechTech %OSDK%\documentation\documentation.css
explorer map_intro.htm 
explorer map_techtech.htm


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

