@ECHO OFF
setlocal

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%LANGUAGE%"=="" GOTO ErCfg

:: Call XA to rebuild the loader
ECHO %ESC%[96m== Assembling bootsectors ==%ESC%[0m
%osdk%\bin\xa -DASSEMBLER=XA -DOSDKNAME=%OSDKNAME% -DVERSION=%VERSION% sector_1-jasmin.asm -o ..\build\files\sector_1-jasmin.o
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa -DASSEMBLER=XA -DOSDKNAME=%OSDKNAME% -DVERSION=%VERSION% sector_2-microdisc.asm -o ..\build\files\sector_2-microdisc.o -l ..\build\files\sector_2-microdisc.symbols.txt
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa -DASSEMBLER=XA -DOSDKNAME=%OSDKNAME% -DVERSION=%VERSION% sector_3.asm -o ..\build\files\sector_3.o
IF ERRORLEVEL 1 GOTO Error

ECHO.
ECHO %ESC%[96m== Assembling loader ==%ESC%[0m
%osdk%\bin\xa -DASSEMBLER=XA -DDISPLAYINFO=%DISPLAYINFO% loader.asm -o ..\build\files\loader.o
IF ERRORLEVEL 1 GOTO Error

::IF NOT EXIST BUILD\symbols GOTO NoSymbol

::
:: Intro program
::
ECHO.
ECHO %ESC%[96m== Compiling the intro ==%ESC%[0m

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
:: Outro program
::
ECHO.
ECHO %ESC%[96m== Compiling the outro ==%ESC%[0m

SET OSDKLINK=
SET OSDKADDR=$400
SET OSDKNAME=OutroProgram
SET OSDKFILE=%OSDKFILE_OUTRO%
SET OSDKDISK=
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\OutroProgram.o >NUL
copy build\symbols ..\build\symbols_OutroProgram >NUL
::pause

::
:: Main program
::
ECHO.
ECHO %ESC%[96m== Compiling the game ==%ESC%[0m

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
ECHO %ESC%[41mAn Error has happened. Build stopped%ESC%[0m

:End

