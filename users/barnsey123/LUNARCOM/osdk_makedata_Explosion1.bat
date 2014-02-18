@ECHO OFF
:: 96x75 Explosion1
:: Enable variable changes within FOR loops
SETLOCAL EnableDelayedExpansion
SET MAINPATH=%OSDK%\LUNARCOM\
SET IMAGEPATH=VIDEO\EXPLOSIONS-FIRE\

CD "%IMAGEPATH%"
DEL "*.PNG"
convert animated_explosion_gif.gif -coalesce -resize 96x75 EXPLOSION1%%02d.PNG
:: Change directory to the IMAGEPATH

:: set DUMMY file name (for when the 1st PNG is processed)
:: Read all PNG files in the IMAGEPATH dir (PNG's created from above IM convert cmd) 
FOR %%a IN (*.PNG) DO (
	%OSDK%\bin\pictconv -f0 -d1 -o2 %%a chunk.hir
	::%OSDK%\bin\pictconv -f2 -o2 %%a chunk.hir
	::%OSDK%\bin\pictconv -f6 -o2 %%a chunk.hir
	%OSDK%\bin\FilePack -p chunk.hir chunk.pak
	%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak %MAINPATH%\%%~na.s _%%~na
)
pause
