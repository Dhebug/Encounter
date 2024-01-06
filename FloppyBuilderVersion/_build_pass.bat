@ECHO OFF
setlocal

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%LANGUAGE%"=="" GOTO ErCfg

:: Call XA to rebuild the loader
ECHO == Assembling bootsectors ==
%osdk%\bin\xa -DASSEMBLER=XA -DOSDKNAME=%OSDKNAME% -DVERSION=%VERSION% sector_1-jasmin.asm -o ..\build\files\sector_1-jasmin.o
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa -DASSEMBLER=XA -DOSDKNAME=%OSDKNAME% -DVERSION=%VERSION% sector_2-microdisc.asm -o ..\build\files\sector_2-microdisc.o -l ..\build\files\sector_2-microdisc.symbols.txt
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa -DASSEMBLER=XA -DOSDKNAME=%OSDKNAME% -DVERSION=%VERSION% sector_3.asm -o ..\build\files\sector_3.o
IF ERRORLEVEL 1 GOTO Error

ECHO.
ECHO == Assembling loader ==
%osdk%\bin\xa -DASSEMBLER=XA -DDISPLAYINFO=%DISPLAYINFO% loader.asm -o ..\build\files\loader.o
IF ERRORLEVEL 1 GOTO Error

::IF NOT EXIST BUILD\symbols GOTO NoSymbol

::
:: Main program
::
ECHO.
ECHO == Compiling the intro ==

SET OSDKLINK=
SET OSDKADDR=$400
SET OSDKNAME=IntroProgram
SET OSDKFILE=%OSDKFILE_INTRO%
SET OSDKDISK=
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\IntroProgram.o >NUL
copy build\symbols ..\build\symbols_IntroProgram >NUL
::pause

::
:: Main program
::
ECHO.
ECHO == Compiling the game ==

SET OSDKLINK=
SET OSDKADDR=$400
SET OSDKNAME=GameProgram
SET OSDKFILE=%OSDKFILE_GAME%
SET OSDKDISK=
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\GameProgram.o >NUL
copy build\symbols ..\build\symbols_GameProgram >NUL
:blaskip

:: Call FloppyBuilder once to create loader.cod
%osdk%\bin\FloppyBuilder build floppybuilderscript.txt >NUL

popd
goto End

:Error
ECHO.
ECHO An Error has happened. Build stopped

:End

