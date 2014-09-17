@ECHO ON
:: Full Screen SkeletonF
:: Enable variable changes within FOR loops
SETLOCAL EnableDelayedExpansion
SET MAINPATH=%OSDK%\LUNARCOM\
SET IMAGEPATH=VIDEO\SKELETONS\
:: For Main Program
:: FEMALE SKELETON
CD "%IMAGEPATH%"
DEL "*.PNG"
convert female-skeleton-walking.gif -coalesce -resize 84x192 SKELETONF%%02d.PNG
:: Change directory to the IMAGEPATH
:: Read all PNG files in the IMAGEPATH dir (PNG's created from above IM convert cmd) 
FOR %%a IN (*.PNG) DO (
	::%OSDK%\bin\pictconv -m0 -f0 -d1 -o4_Mask pics\MaskSmallOric2.png mask.s
	::%OSDK%\bin\pictconv -f0 -d1 -o4_SKELETONF %%a %%~na.s
	%OSDK%\bin\pictconv -f0 -d1 -o2 %%a chunk.hir
	%OSDK%\bin\FilePack -p chunk.hir chunk.pak
	%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak %MAINPATH%\%%~na.s _%%~na
)
pause
