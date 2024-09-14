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

SET OSDKCPPFLAGSCOPY=-DLANGUAGE_%LANGUAGE% -DVERSION=\"%VERSION%\" -DPRODUCT_TYPE_%PRODUCT_TYPE% 
SET OSDKXAPARAMSCOPY=%OSDKXAPARAMS%

::
:: Splash program
::
IF "%OSDKFILE_SPLASH%"=="" GOTO EndSplash
ECHO.
ECHO %ESC%[96m== Compiling the splash screen ==%ESC%[0m

SET OSDKLINK=
SET OSDKADDR=$400
SET OSDKNAME=SplashProgram
SET OSDKFILE=%OSDKFILE_SPLASH%
SET OSDKDISK=
SET OSDKCPPFLAGS=%OSDKCPPFLAGSCOPY% -DMODULE_SPLASH
SET OSDKXAPARAMS=%OSDKXAPARAMSCOPY% -DMODULE_SPLASH
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\SplashProgram.o >NUL
copy build\symbols ..\build\symbols_SplashProgram >NUL
IF %TEST_MODULE%==SPLASH COPY build\symbols %OSDK%\Oricutron\symbols >NUL
IF %TEST_MODULE%==SPLASH SET BREAKPOINTS=%BREAKPOINTS_SPLASH%
:EndSplash


::
:: Intro program
::
IF "%OSDKFILE_INTRO%"=="" GOTO EndIntro
ECHO.
ECHO %ESC%[96m== Compiling the intro ==%ESC%[0m

SET OSDKLINK=
SET OSDKADDR=$400
SET OSDKNAME=IntroProgram
SET OSDKFILE=%OSDKFILE_INTRO%
SET OSDKDISK=
SET OSDKCPPFLAGS=%OSDKCPPFLAGSCOPY% -DMODULE_INTRO
SET OSDKXAPARAMS=%OSDKXAPARAMSCOPY% -DMODULE_INTRO
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\IntroProgram.o >NUL
copy build\symbols ..\build\symbols_IntroProgram >NUL
IF %TEST_MODULE%==INTRO COPY build\symbols %OSDK%\Oricutron\symbols >NUL
IF %TEST_MODULE%==INTRO SET BREAKPOINTS=%BREAKPOINTS_INTRO%
:EndIntro


::
:: Outro program
::
IF "%OSDKFILE_OUTRO%"=="" GOTO EndOutro
ECHO.
ECHO %ESC%[96m== Compiling the outro ==%ESC%[0m

SET OSDKLINK=
SET OSDKADDR=$400
SET OSDKNAME=OutroProgram
SET OSDKFILE=%OSDKFILE_OUTRO%
SET OSDKDISK=
SET OSDKCPPFLAGS=%OSDKCPPFLAGSCOPY% -DMODULE_OUTRO
SET OSDKXAPARAMS=%OSDKXAPARAMSCOPY% -DMODULE_OUTRO
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\OutroProgram.o >NUL
copy build\symbols ..\build\symbols_OutroProgram >NUL
IF %TEST_MODULE%==OUTRO COPY build\symbols %OSDK%\Oricutron\symbols >NUL
IF %TEST_MODULE%==OUTRO SET BREAKPOINTS=%BREAKPOINTS_OUTRO%
:EndOutro


::
:: Main program
::
IF "%OSDKFILE_GAME%"=="" GOTO EndGame
ECHO.
ECHO %ESC%[96m== Compiling the game ==%ESC%[0m

SET OSDKLINK=
SET OSDKADDR=$400
SET OSDKNAME=GameProgram
SET OSDKFILE=%OSDKFILE_GAME%
SET OSDKDISK=
SET OSDKCPPFLAGS=%OSDKCPPFLAGSCOPY% -DMODULE_GAME
SET OSDKXAPARAMS=%OSDKXAPARAMSCOPY% -DMODULE_GAME
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\GameProgram.o >NUL
copy build\symbols ..\build\symbols_GameProgram >NUL
IF %TEST_MODULE%==GAME COPY build\symbols %OSDK%\Oricutron\symbols >NUL
IF %TEST_MODULE%==GAME SET BREAKPOINTS=%BREAKPOINTS_GAME%
:EndGame

::
:: Generate the breakpoint file is necessary:
:: Each of the symbols mentionned in the BREAKPOINTS variable is exported in a text file
:: each line contains a single entry starting by "bs" (Breakpoint Set) followed by the symbol namme.
::
setlocal EnableDelayedExpansion
(for %%a in (%BREAKPOINTS%) do (
  set "out=%%~a"  
  echo bs !out:@= !
))> %OSDK%\Oricutron\Breakpoints.txt
type %OSDK%\Oricutron\Breakpoints.txt
endlocal
set OSDKBREAKPOINTS=:Breakpoints.txt

:: Call FloppyBuilder once to create loader.cod
%osdk%\bin\FloppyBuilder build floppybuilderscript.txt >..\build\floppy_builder_error.txt
IF ERRORLEVEL 1 GOTO FloppyBuilderError

popd
goto End

:FloppyBuilderError
:: Prints the floppy builder error in red to make sure we don't miss it
ECHO %ESC%[41m
type ..\build\floppy_builder_error.txt
ECHO %ESC%[0m
popd

:Error
ECHO.
ECHO %ESC%[41mAn Error has happened. Build stopped%ESC%[0m

:End

