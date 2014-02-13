@ECHO OFF
:: Full Screen Asteroid2
:: Enable variable changes within FOR loops
SETLOCAL EnableDelayedExpansion
SET MAINPATH=%OSDK%\LUNARCOM\
SET IMAGEPATH=VIDEO\ASTEROID2\
:: For Main Program
DEL %IMAGEPATH%\*.PNG
convert %IMAGEPATH%\ASTEROID2.gif -coalesce -resize 198x155 -ordered-dither o2x2,6 %IMAGEPATH%\ASTEROID2%%02d.PNG
:: Change directory to the IMAGEPATH
CD "%IMAGEPATH%"
:: set DUMMY file name (for when the 1st PNG is processed)
SET OLDFILE="DUMMY"
:: Read all PNG files in the IMAGEPATH dir (PNG's created from above IM convert cmd) 
FOR %%a IN (*.PNG) DO (
	:: The first file needs to  be processed differently
	IF !OLDFILE! == "DUMMY" (
		%OSDK%\bin\pictconv -f0 -d0 -o2 %%a chunk.hir
		%OSDK%\bin\FilePack -p chunk.hir chunk.pak
		%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak %MAINPATH%\%%~na.s _%%~na
	) ELSE (
		:: Create MASK of changes (the current %a file compared to OLDFILE)
		compare -metric AE -fuzz 20%% !OLDFILE! "%%a" -compose Src -highlight-color White -lowlight-color Black %%~na_Mask.png
		:: Use MASK to extract only the changed pixels from original image 
		convert %%a %%~na_Mask.png -alpha Off -compose CopyOpacity -composite %%~na_X.png
		:: Add Black Backround (remove the transparency)
		convert %%~na_X.png -background Black -flatten %%~na_X.png
		:: use OSDK to produce final, compressed .s files
		%OSDK%\bin\pictconv -f0 -d0 -o2 %%~na_X.png chunk.hir 
		%OSDK%\bin\FilePack -p chunk.hir chunk.pak
		%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak %MAINPATH%\%%~na.s _%%~na
	)
:: Set OLDFILE to be the current file (next file is compared with this one)
SET OLDFILE="%%a"
)

pause
