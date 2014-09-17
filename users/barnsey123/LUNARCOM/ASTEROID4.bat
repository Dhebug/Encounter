SET IMAGEPATH=VIDEO\ASTEROID4\
:: For Main Program
:: Full Screen Asteroid4
DEL %IMAGEPATH%\*.PNG

convert %IMAGEPATH%\ASTEROID4.gif -coalesce -crop 148x327+132+43 +repage -rotate +90 -resize 200x70 -ordered-dither o2x2 %IMAGEPATH%\ASTEROID4%%02d.PNG
cd %IMAGEPATH%
FOR %%a IN (*.PNG) DO (
%OSDK%\bin\pictconv -f0 -d0 -o2 %%a chunk.hir 
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak %%~na.s _%%~na
)