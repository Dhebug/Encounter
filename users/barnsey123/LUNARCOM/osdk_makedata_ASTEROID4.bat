@ECHO OFF
:: Full Screen Asteroid2
:: Enable variable changes within FOR loops
SETLOCAL EnableDelayedExpansion
SET MAINPATH=%OSDK%\LUNARCOM\
SET IMAGEPATH=VIDEO\ASTEROID4\
:: For Main Program
::DEL %IMAGEPATH%\*.PNG
::convert %IMAGEPATH%\ASTEROID4.gif -coalesce -crop 148x327+132+43 +repage -rotate +90 -resize 186x84 -ordered-dither o2x2 %IMAGEPATH%\ASTEROID4%%02d.PNG
::convert %IMAGEPATH%\ASTEROID4.gif -coalesce -crop 148x327+132+43 +repage -rotate +90 -resize 186x84 -ordered-dither o2x2 %IMAGEPATH%\ASTEROID4out.gif

::convert %IMAGEPATH%\ASTEROID400.PNG %IMAGEPATH%\ASTEROID440.PNG  -evaluate-sequence mean -ordered-dither o2x2 %IMAGEPATH%\ASTEROID441.PNG
pause
:: Change directory to the IMAGEPATH
CD "%IMAGEPATH%"
FOR %%a IN (*.PNG) DO (
%OSDK%\bin\pictconv -f0 -d0 -o2 %%a chunk.hir 
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak %%~na.s _%%~na
)
CD "..\.."
COPY "%IMAGEPATH%*.s" .

