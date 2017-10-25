@ECHO OFF


::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg

:: Generate character font
%osdk%\bin\pictconv -f0 -o4__charfont .\data\BFont6x8.png .\build\files\BFont6x8.asm


:: Compile the scripts
pushd scripts
::call ocomp.bat
popd
IF ERRORLEVEL 1 GOTO Error

:: Create the folders we need
md build
pushd build
md files
popd

:: Compile the tables
%osdk%\bin\xa -DASSEMBLER=XA tables.s -o .\build\files\tables.o
IF ERRORLEVEL 1 GOTO Error

:: Compile the auxiliar routines
%osdk%\bin\xa -DASSEMBLER=XA auxiliar.s -o .\build\files\auxiliar.o
IF ERRORLEVEL 1 GOTO Error


:: Delete the floppy, just to be sure
IF EXIST build\%OSDKDISK%  del /q build\%OSDKDISK%


:: Build the slide show parts of the demo
pushd floppycode

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

::PAUSE
:: Move out of floppycode folder
popd

:: Assemble the data
pushd resdata
ECHO.
ECHO Assembling resource data..
::%osdk%\bin\xa -DASSEMBLER=XA resource_data.s -o ..\build\files\resource_data.o

for %%f in (*.s) do (
ECHO Assembling %%f..
%osdk%\bin\xa -DASSEMBLER=XA %%f -o ..\build\files\%%~nf.o
IF ERRORLEVEL 1 GOTO Error
)

popd

:: Let's assemble the engine
echo Assembling OASIS...


::
:: Set the build paremeters
::
CALL osdk_config.bat


::
:: Launch the compilation of files
::
CALL %OSDK%\bin\make.bat %OSDKFILE%


pushd floppycode
:: Call FloppyBuilder once to create loader.cod
%osdk%\bin\FloppyBuilder build floppybuilderscript.txt


if "%FLOPPYPASS%"=="---" goto EndLoop
set FLOPPYPASS=%FLOPPYPASS%-
goto Loop


:EndLoop


:: Call FloppyBuilder another time to build the final disk
ECHO.
ECHO Building final floppy
%osdk%\bin\FloppyBuilder build floppybuilderscript.txt
popd
goto End






::
:: Outputs an error message
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End


:Error
ECHO == Errors found ==
:End
::pause
