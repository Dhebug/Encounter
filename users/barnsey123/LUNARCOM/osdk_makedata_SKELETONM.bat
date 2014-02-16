::@ECHO OFF
:: Full Screen Asteroid2
:: Enable variable changes within FOR loops
SETLOCAL EnableDelayedExpansion
::SET MAINPATH=%OSDK%\LUNARCOM\
SET IMAGEPATH=VIDEO\SKELETONS\
:: MALE SKELETON
CD "%IMAGEPATH%"
DEL "*.PNG"
convert male-skeleton-walking.gif -coalesce -resize 54x129 SKELETONM%%02d.PNG
FOR %%a IN (*.PNG) DO (
	%OSDK%\bin\pictconv -f0 -d0 -o2 %%a chunk.hir
	%OSDK%\bin\FilePack -p chunk.hir chunk.pak
	%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ..\%%~na.s _%%~na
)
pause
