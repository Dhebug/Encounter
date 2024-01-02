@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg


%osdk%\bin\MemMap.exe build\symbols_IntroProgram map_intro.htm First %OSDK%\documentation\documentation.css
%osdk%\bin\MemMap.exe build\symbols_GameProgram map_game.htm Second %OSDK%\documentation\documentation.css
explorer map_intro.htm 
explorer map_game.htm


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

