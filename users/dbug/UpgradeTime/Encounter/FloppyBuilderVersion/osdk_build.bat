@ECHO OFF
setlocal

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg

:: Create the folders we need
md build
pushd build
md files
popd

::
:: Set the build paremeters
::
CALL osdk_config.bat

::
:: Build assets
::
call osdk_makedata.bat

:: Delete the floppy, just to be sure
IF EXIST build\%OSDKDISK%  del build\%OSDKDISK%


:: Build the slide show parts of the demo
pushd code

:: Then this retarded code is called twice in a loop:
:: The reason is, that we are including 'loader.cod' inside the loader, but the content is valid only after FloppyBuilder created the layout.
:: In order to create the layout, FloppyBuilder needs to know the files, and their size.
:: In order to know their size, it needs to find them, which means they have to exist, which means they have to be assembled, which is not doable without a valid 'loader.cod'
:: Our (ugly) solution is to assemble the whole thing until it gets stable.
:: A possibility is to have FloppyBuilder return a crc of the floppy it generated, if the crc is the same twice in a row, then the data is stable...

:: Call FloppyBuilder once to create loader.cod
%osdk%\bin\FloppyBuilder init floppybuilderscript.txt


set FLOPPYPASS=-

:Loop
echo %FLOPPYPASS%
:: Call XA to rebuild the loader
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

::IF NOT EXIST BUILD\symbols GOTO NoSymbol

::
:: Main program
::
ECHO.
ECHO Assembling the first part

SET OSDKLINK=
SET OSDKADDR=$400
SET OSDKNAME=IntroProgram
SET OSDKFILE=%OSDKFILE_INTRO%
SET OSDKDISK=
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\IntroProgram.o
copy build\symbols ..\build\symbols_IntroProgram

::pause

::goto blaskip
::
:: Main program
::
ECHO.
ECHO Assembling the second part

SET OSDKLINK=
SET OSDKADDR=$400
SET OSDKNAME=GameProgram
SET OSDKFILE=%OSDKFILE_GAME%
SET OSDKDISK=
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\GameProgram.o
copy build\symbols ..\build\symbols_GameProgram
:blaskip



:: Call FloppyBuilder once to create loader.cod
%osdk%\bin\FloppyBuilder build floppybuilderscript.txt

if "%FLOPPYPASS%"=="--" goto EndLoop
set FLOPPYPASS=%FLOPPYPASS%-
goto Loop


:EndLoop


:: Call FloppyBuilder another time to build the final disk
ECHO.
ECHO Building final floppy
%osdk%\bin\FloppyBuilder build floppybuilderscript.txt
popd
goto End

:Error
ECHO.
ECHO An Error has happened. Build stopped

:End
::pause
