@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg

::
:: Convert pictures
::
::%OSDK%\bin\pictconv -u1 -m0 -f0 -o4_ScrollingBackground pics\ScrollingBackground.png scrolling_background.s
::%OSDK%\bin\pictconv -u1 -m0 -f0 -o4_ScrollingBackgroundIngame pics\ScrollingBackground_futura.png scrolling_background_ingame.s

%OSDK%\bin\pictconv -u1 -m0 -f0 -o4_ScrollingBackground pics\ScrollingBackground_futura.png scrolling_background.s

%OSDK%\bin\pictconv -u1 -m0 -f0 -o4_GameLogo pics\GameLogo.png game_logo.s
%OSDK%\bin\pictconv -u1 -m0 -f0 -o4_Font_6x8_FuturaFull pics\font_6x8_futura_full.png font_6x8_futura_full.s
%OSDK%\bin\pictconv -u1 -m0 -f0 -o4_Font_6x6 pics\font_6x6.png font_6x6.s
%OSDK%\bin\pictconv -u1 -m0 -f0 -o4_PlayerPod pics\PlayerPod.png player_pod.s
%OSDK%\bin\pictconv -u1 -m0 -f0 -o4_RoadSigns pics\road_signs.png road_signs.s

%OSDK%\bin\pictconv -u1 -m0 -f0 -o4_HighScoreCharacters pics\highscores.png highscores_characters.s


%OSDK%\bin\pictconv -u1 -m0 -f0 -o4_EnergySpeed pics\energy_speed.png energy_speed.s

%OSDK%\bin\pictconv -u1 -m0 -f0 -o1 pics\font_6x8_QuantumFx.png build\font6x8.tap


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
