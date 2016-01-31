::@echo off

:: Create the folders we need
md build
pushd build
md files
popd

::
:: Build data for the game
::
SET PICTCONV=%OSDK%\Bin\PictConv.exe

:: Pictures
SET PARAMS=-f1 -d0 -o2 -u1 -t1

:: Color pictures
%PICTCONV% %PARAMS% data\title_screen.png build\files\title_screen.hir
%PICTCONV% %PARAMS% data\GlobalGameJamOslo.png build\files\GlobalGameJamOslo.hir

:: Monochrome pictures
%PICTCONV% -f0 -f0 -o2 data\Font6x8.png build\files\Font6x8.hir
%PICTCONV% -f0 -f0 -o2 data\Font6x6.png build\files\Font6x6.hir

::pause


