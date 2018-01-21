::@echo off


::
:: Build data for the game
::
SET PICTCONV=%OSDK%\Bin\PictConv.exe
SET SAMPLETWEAKER=%OSDK%\Bin\SampleTweaker.exe

:: Pictures
SET PARAMS=-f1 -d0 -o2 -u1 -t1

:: Color pictures
%PICTCONV% -f6 -o5 ggjoslo3.png ggjoslo3-converted.png


::pause


