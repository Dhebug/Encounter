@ECHO OFF
setlocal

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%LANGUAGE%"=="" GOTO ErCfg

:: Call XA to rebuild the loader
ECHO %ESC%[96m== Assembling bootsectors ==%ESC%[0m
SET XAPARAMS=-DASSEMBLER=XA -DOSDKNAME=%OSDKNAME% -DFREQUENCY_%FREQUENCY% -DVERSION=%VERSION% -DPRODUCT_TYPE_%PRODUCT_TYPE% -DLANGUAGE_%LANGUAGE%
%osdk%\bin\xa %XAPARAMS% sector_1-jasmin.asm -o ..\build\files\sector_1-jasmin.o
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa %XAPARAMS% sector_2-microdisc.asm -o ..\build\files\sector_2-microdisc.o -l ..\build\files\sector_2-microdisc.symbols.txt
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa %XAPARAMS% sector_3.asm -o ..\build\files\sector_3.o
IF ERRORLEVEL 1 GOTO Error

IF NOT "%DISK_SEDORIC_COPYABLE%"=="1" GOTO EndSedoricSectors
ECHO %ESC%[96m== Assembling Sedoric compatible information ==%ESC%[0m
:: Assemble sector_sedoric_directory FIRST and export its Entries* labels as xa equates so sector_sedoric_bitmap can #include them to auto-compute the file count.
%osdk%\bin\xa %XAPARAMS% sector_sedoric_directory.asm -o ..\build\files\sector_sedoric_directory.o -E ..\build\files\sector_sedoric_directory.equ -P Entries
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa %XAPARAMS% sector_sedoric_bitmap.asm -o ..\build\files\sector_sedoric_bitmap.o
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa %XAPARAMS% sector_sedoric_system.asm -o ..\build\files\sector_sedoric_system.o
IF ERRORLEVEL 1 GOTO Error
%osdk%\bin\xa %XAPARAMS% sector_sedoric_descriptor.asm -o ..\build\files\sector_sedoric_descriptor.o
IF ERRORLEVEL 1 GOTO Error
:EndSedoricSectors

ECHO.
ECHO %ESC%[96m== Assembling loader ==%ESC%[0m
%osdk%\bin\xa -DASSEMBLER=XA -DFREQUENCY_%FREQUENCY% -DDISPLAYINFO=%DISPLAYINFO% loader.asm -o ..\build\files\loader.o -l ..\build\symbols_Loader
IF ERRORLEVEL 1 GOTO Error

::IF NOT EXIST BUILD\symbols GOTO NoSymbol

SET OSDKCPPFLAGSCOPY=-DLANGUAGE_%LANGUAGE% -DFREQUENCY_%FREQUENCY% -DVERSION=\"%VERSION%\" -DPRODUCT_TYPE_%PRODUCT_TYPE% 
SET OSDKXAPARAMSCOPY=%OSDKXAPARAMS%
SET OSDKDISK=

::
:: Kernel (resident shared code: IRQ, audio, keyboard, music player)
::
IF "%OSDKFILE_KERNEL%"=="" GOTO EndKernel
ECHO.
ECHO %ESC%[96m== Compiling the kernel ==%ESC%[0m

SET OSDKLINK=-b -S ..\build\symbols_Loader -r LANGUAGE_%LANGUAGE%
SET OSDKADDR=$400
SET OSDKNAME=KernelProgram
SET OSDKFILE=%OSDKFILE_KERNEL%
SET OSDKCPPFLAGS=%OSDKCPPFLAGSCOPY% -DMODULE_KERNEL
SET OSDKXAPARAMS=%OSDKXAPARAMSCOPY% -DMODULE_KERNEL -E ..\build\kernel_exports.h
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\KernelProgram.o >NUL
copy build\symbols ..\build\symbols_Kernel >NUL

:EndKernel

SET OSDKADDR=


::
:: Splash program
::
IF "%OSDKFILE_SPLASH%"=="" GOTO EndSplash
ECHO.
ECHO %ESC%[96m== Compiling the splash screen ==%ESC%[0m

SET OSDKLINK=-S ..\build\symbols_Kernel -g ..\build\kernel_exports.h -t _KernelEndText -r LANGUAGE_%LANGUAGE%
SET OSDKNAME=SplashProgram
SET OSDKFILE=%OSDKFILE_SPLASH%
SET OSDKCPPFLAGS=%OSDKCPPFLAGSCOPY% -DMODULE_SPLASH -DKERNEL_RESIDENT
SET OSDKXAPARAMS=%OSDKXAPARAMSCOPY% -DMODULE_SPLASH -DKERNEL_RESIDENT
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\SplashProgram.o >NUL
copy build\symbols+..\build\symbols_Loader+..\build\symbols_Kernel ..\build\symbols_SplashProgram >NUL
IF %TEST_MODULE%==SPLASH COPY build\symbols+..\build\symbols_Loader+..\build\symbols_Kernel %OSDK%\Oricutron\symbols >NUL
IF %TEST_MODULE%==SPLASH SET BREAKPOINTS=%BREAKPOINTS_SPLASH%
:EndSplash


::
:: Intro program
::
IF "%OSDKFILE_INTRO%"=="" GOTO EndIntro
ECHO.
ECHO %ESC%[96m== Compiling the intro ==%ESC%[0m

SET OSDKLINK=-S ..\build\symbols_Kernel -g ..\build\kernel_exports.h -t _KernelEndText -r LANGUAGE_%LANGUAGE%
SET OSDKNAME=IntroProgram
SET OSDKFILE=%OSDKFILE_INTRO%
SET OSDKCPPFLAGS=%OSDKCPPFLAGSCOPY% -DMODULE_INTRO -DKERNEL_RESIDENT
SET OSDKXAPARAMS=%OSDKXAPARAMSCOPY% -DMODULE_INTRO -DKERNEL_RESIDENT
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\IntroProgram.o >NUL
copy build\symbols+..\build\symbols_Loader+..\build\symbols_Kernel ..\build\symbols_IntroProgram >NUL
IF %TEST_MODULE%==INTRO COPY build\symbols+..\build\symbols_Loader+..\build\symbols_Kernel %OSDK%\Oricutron\symbols >NUL
IF %TEST_MODULE%==INTRO SET BREAKPOINTS=%BREAKPOINTS_INTRO%
:EndIntro


::
:: Outro program
::
IF "%OSDKFILE_OUTRO%"=="" GOTO EndOutro
ECHO.
ECHO %ESC%[96m== Compiling the outro ==%ESC%[0m

SET OSDKLINK=-S ..\build\symbols_Kernel -g ..\build\kernel_exports.h -t _KernelEndText -r LANGUAGE_%LANGUAGE%
SET OSDKNAME=OutroProgram
SET OSDKFILE=%OSDKFILE_OUTRO%
SET OSDKCPPFLAGS=%OSDKCPPFLAGSCOPY% -DMODULE_OUTRO -DKERNEL_RESIDENT
SET OSDKXAPARAMS=%OSDKXAPARAMSCOPY% -DMODULE_OUTRO -DKERNEL_RESIDENT
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\OutroProgram.o >NUL
copy build\symbols+..\build\symbols_Loader+..\build\symbols_Kernel ..\build\symbols_OutroProgram >NUL
IF %TEST_MODULE%==OUTRO COPY build\symbols+..\build\symbols_Loader+..\build\symbols_Kernel %OSDK%\Oricutron\symbols >NUL
IF %TEST_MODULE%==OUTRO SET BREAKPOINTS=%BREAKPOINTS_OUTRO%
:EndOutro


::
:: Main program
::
IF "%OSDKFILE_GAME%"=="" GOTO EndGame
ECHO.
ECHO %ESC%[96m== Compiling the game ==%ESC%[0m

SET OSDKLINK=-S ..\build\symbols_Kernel -g ..\build\kernel_exports.h -t _KernelEndText -r LANGUAGE_%LANGUAGE%
SET OSDKNAME=GameProgram
SET OSDKFILE=%OSDKFILE_GAME%
SET OSDKCPPFLAGS=%OSDKCPPFLAGSCOPY% -DMODULE_GAME -DKERNEL_RESIDENT
SET OSDKXAPARAMS=%OSDKXAPARAMSCOPY% -DMODULE_GAME -DKERNEL_RESIDENT
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\GameProgram.o >NUL
::copy build\symbols+..\build\symbols_Loader+..\build\symbols_Kernel+..\build\symbols_MonkeyKing ..\build\symbols_GameProgram >NUL
copy build\symbols+..\build\symbols_Loader+..\build\symbols_Kernel ..\build\symbols_GameProgram >NUL
IF %TEST_MODULE%==GAME COPY ..\build\symbols_GameProgram %OSDK%\Oricutron\symbols >NUL
IF %TEST_MODULE%==GAME SET BREAKPOINTS=%BREAKPOINTS_GAME%
:EndGame


::
:: Monkey King
::
IF "%OSDKFILE_KING%"=="" GOTO EndMonkeyKing
ECHO.
ECHO %ESC%[96m== Compiling Monkey King ==%ESC%[0m

SET OSDKLINK=-b -S ..\build\symbols_GameProgram -t _Minigame
SET OSDKNAME=monkey_king
SET OSDKFILE=%OSDKFILE_KING%
SET OSDKCPPFLAGS=%OSDKCPPFLAGSCOPY% -DMODULE_MONKEY_KING
SET OSDKXAPARAMS=%OSDKXAPARAMSCOPY% -DMODULE_MONKEY_KING
CALL %OSDK%\bin\make.bat %OSDKFILE%
IF ERRORLEVEL 1 GOTO Error
copy build\final.out ..\build\files\monkey_king.o >NUL
copy build\symbols ..\build\symbols_MonkeyKing >NUL
:EndMonkeyKing

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
EXIT /b 1

:End

