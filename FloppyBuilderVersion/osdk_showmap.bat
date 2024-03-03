@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg


%osdk%\bin\MemMap.exe -s30 build\symbols_SplashProgram map_splash.htm Splash %OSDK%\documentation\documentation.css
%osdk%\bin\MemMap.exe -s30 build\symbols_IntroProgram map_intro.htm Introduction %OSDK%\documentation\documentation.css
%osdk%\bin\MemMap.exe -s30 build\symbols_OutroProgram map_outro.htm Credits %OSDK%\documentation\documentation.css
%osdk%\bin\MemMap.exe -s30 build\symbols_GameProgram map_game.htm Game %OSDK%\documentation\documentation.css
explorer map_splash.htm 
explorer map_intro.htm 
explorer map_outro.htm 
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

