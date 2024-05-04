@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg

CALL osdk_config.bat

::
:: Splash program
::
IF "%OSDKFILE_SPLASH%"=="" GOTO EndSplash
%osdk%\bin\MemMap.exe -s30 build\symbols_SplashProgram map_splash.htm Splash %OSDK%\documentation\documentation.css
explorer map_splash.htm 
:EndSplash

::
:: Intro program
::
IF "%OSDKFILE_INTRO%"=="" GOTO EndIntro
%osdk%\bin\MemMap.exe -s30 build\symbols_IntroProgram map_intro.htm Introduction %OSDK%\documentation\documentation.css
explorer map_intro.htm 
:EndIntro

::
:: Outro program
::
IF "%OSDKFILE_OUTRO%"=="" GOTO EndOutro
%osdk%\bin\MemMap.exe -s30 build\symbols_OutroProgram map_outro.htm Credits %OSDK%\documentation\documentation.css
explorer map_outro.htm 
:EndOutro

::
:: Main program
::
IF "%OSDKFILE_GAME%"=="" GOTO EndGame
%osdk%\bin\MemMap.exe -s30 build\symbols_GameProgram map_game.htm Game %OSDK%\documentation\documentation.css
explorer map_game.htm
:EndGame

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

