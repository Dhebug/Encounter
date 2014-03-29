::@ECHO OFF
setlocal

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg

::
:: Set the build paremeters
::
CALL osdk_config.bat

:: Delete the floppy, just to be sure
del build\BORN1983.dsk

:: Create the folders we need
md build
pushd build
md files
popd

:: 
:: Build the intro/demo first.
:: The loading of parts is done in the loader itself so we have no internal dependencies there.
::
ECHO.
ECHO Assembling intro program
pushd part_hires_picture
call osdk_build.bat
popd

ECHO.
ECHO Assembling motherboard intro
pushd part_motherboard_scroller
call osdk_build.bat
popd


:: Build the loader
pushd disk_system

:: Then this retarded code is called twice in a loop:
:: The reason is, that we are including 'loader.cod' inside the loader, but the content is valid only after FloppyBuilder created the layout.
:: In order to create the layout, FloppyBuilder needs to know the files, and their size.
:: In order to know their size, it needs to find them, which means they have to exist, which means they have to be assembled, which is not doable without a valid 'loader.cod'
:: Our (ugly) solution is to assemble the whole thing until it gets stable.
:: A possibility is to have FloppyBuilder return a crc of the floppy it generated, if the crc is the same twice in a row, then the data is stable...

:: Call FloppyBuilder once to create loader.cod
%osdk%\bin\FloppyBuilder init floppybuilderscript.txt
popd

set FLOPPYPASS=-

:Loop
echo %FLOPPYPASS%


pushd disk_system
:: Call XA to rebuild the loa
ECHO.
ECHO Assembling bootsectors
%osdk%\bin\xa -DASSEMBLER=XA sector_1-jasmin.asm -o ..\build\files\sector_1-jasmin.o
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa -DASSEMBLER=XA sector_2-microdisc.asm -o ..\build\files\sector_2-microdisc.o
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa -DASSEMBLER=XA sector_3.asm -o ..\build\files\sector_3.o
IF ERRORLEVEL 1 GOTO Error

ECHO.
ECHO Assembling loader
%osdk%\bin\xa -DASSEMBLER=XA loader.asm -o ..\build\files\loader.o
IF ERRORLEVEL 1 GOTO Error
popd

::SET OSDKDISK=

:: Call FloppyBuilder once to create loader.cod
pushd disk_system
%osdk%\bin\FloppyBuilder build floppybuilderscript.txt
popd

if "%FLOPPYPASS%"=="--" goto EndLoop
set FLOPPYPASS=%FLOPPYPASS%-
goto Loop


:EndLoop


:: Call FloppyBuilder another time to build the final disk
ECHO.
ECHO Building final floppy
pushd disk_system
%osdk%\bin\FloppyBuilder build floppybuilderscript.txt
popd
goto End

:Error
ECHO.
ECHO An Error has happened. Build stopped

:End
pause
