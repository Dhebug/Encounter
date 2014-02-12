::@ECHO OFF
SET MAINPATH=%OSDK%\LUNARCOM\
SET IMAGEPATH=VIDEO\ASTEROID2\
:: For Main Program

:: Full Screen Asteroid2
DEL %IMAGEPATH%\*.PNG
::convert %IMAGEPATH%\ASTEROID2.gif -coalesce -resize 198x155 -ordered-dither h4x4a %IMAGEPATH%\ASTEROID2%%02d.PNG
convert %IMAGEPATH%\ASTEROID2.gif -coalesce -resize 198x155 -ordered-dither o2x2,6 %IMAGEPATH%\ASTEROID2%%02d.PNG

::convert %IMAGEPATH%\ASTEROID2.GIF -coalesce -resize 198x155 -ordered-dither o3x3,6 %IMAGEPATH%\ASTEROID2%%02d.PNG
::convert %IMAGEPATH%\ASTEROID2.GIF -coalesce -resize 198x155 -ordered-dither checks,6 %IMAGEPATH%\ASTEROID2%%02d.PNG

::compare %IMAGEPATH%\ASTEROID200.png %IMAGEPATH%\ASTEROID201.png %IMAGEPATH%\ASTEROID201D.png
:: routine below not working. Supposed to list all the PNGs and ignoring the first one compare all subsequent files with the previous outputting an blahbal_X.PNG
 	which should contain ONLY the differences
CD "%IMAGEPATH%"
SET OLDFILE=FRED
FOR %%a IN (*.PNG) DO (
IF "%OLDFILE%"=="FRED" COPY "%%a" "%%~na_X.png"  
IF NOT "%OLDFILE%"=="FRED" compare -metric AE -fuzz 20% %OLDFILE% %%a -compose Src -highlight-color White -lowlight-color Black %%~na_X.png 
%OSDK%\bin\pictconv -f0 -d0 -o2 %%~na_X.png chunk.hir 
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak %MAINPATH%\%%~na.s _%%~na
SET OLDFILE=%%a
)

REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID200.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID200.s _ASTEROID200
REM 
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID201.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID201.s _ASTEROID201
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID202.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID202.s _ASTEROID202
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID203.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID203.s _ASTEROID203
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID204.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID204.s _ASTEROID204
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID205.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID205.s _ASTEROID205
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID206.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID206.s _ASTEROID206
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID207.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID207.s _ASTEROID207
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID208.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID208.s _ASTEROID208
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID209.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID209.s _ASTEROID209
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID210.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID210.s _ASTEROID210
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID211.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID211.s _ASTEROID211
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID212.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID212.s _ASTEROID212
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID213.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID213.s _ASTEROID213
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID214.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID214.s _ASTEROID214
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID215.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID215.s _ASTEROID215
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID216.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID216.s _ASTEROID216
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID217.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID217.s _ASTEROID217
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID218.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID218.s _ASTEROID218
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID219.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID219.s _ASTEROID219
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID220.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID220.s _ASTEROID220
REM 
REM %OSDK%\bin\pictconv -f0 -d0 -o2 %IMAGEPATH%\ASTEROID221.png chunk.hir
REM %OSDK%\bin\FilePack -p chunk.hir chunk.pak
REM %OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak ASTEROID221.s _ASTEROID221




pause
