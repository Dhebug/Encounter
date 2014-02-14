@ECHO OFF
:: Full Screen Asteroid2
:: Enable variable changes within FOR loops
SETLOCAL EnableDelayedExpansion
SET MAINPATH=%OSDK%\LUNARCOM\
SET IMAGEPATH=VIDEO\SKELETONS\
:: For Main Program
DEL %IMAGEPATH%\*.PNG
convert %IMAGEPATH%\female-skeleton-walking.gif -coalesce -resize 84x192 %IMAGEPATH%\SKELETONF%%02d.PNG
:: Change directory to the IMAGEPATH
CD "%IMAGEPATH%"
:: set DUMMY file name (for when the 1st PNG is processed)
:: Read all PNG files in the IMAGEPATH dir (PNG's created from above IM convert cmd) 
FOR %%a IN (*.PNG) DO (
	:: The first file needs to  be processed differently
	::IF !OLDFILE! == "DUMMY" (
	%OSDK%\bin\pictconv -f0 -d1 -o2 %%a chunk.hir
	%OSDK%\bin\FilePack -p chunk.hir chunk.pak
	%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak %MAINPATH%\%%~na.s _%%~na
)

pause
