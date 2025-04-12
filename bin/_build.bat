@ECHO OFF
setlocal

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%LANGUAGE%"=="" GOTO ErCfg

echo.
echo %ESC%[93m============ Building the %LANGUAGE% version of the game ============%ESC%[0m
echo.

::
:: Set the build paremeters
::
CALL osdk_config.bat

:: Basic configuration checks
IF "%PRODUCT_TYPE%"=="" goto ProductTypeError
IF "%OSDKDISK%"=="" goto OSDKDISKError

:: Make sure we build the right version
SET OSDKNAME=%BASENAME%-%LANGUAGE%
IF "%PRODUCT_TYPE%"=="GAME_DEMO"    SET OSDKDISK=%OSDKNAME%-%FREQUENCY%-Demo-v%VERSION%.dsk
IF "%PRODUCT_TYPE%"=="GAME_RELEASE" SET OSDKDISK=%OSDKNAME%-%FREQUENCY%-v%VERSION%.dsk
IF "%PRODUCT_TYPE%"=="TEST_MODE"    SET OSDKDISK=%OSDKNAME%-%FREQUENCY%-Test-v%VERSION%.dsk
IF "%FINAL_TARGET_DISK%"=="" GOTO EndDeleteCopy
IF EXIST %FINAL_TARGET_DISK%\%OSDKNAME%-%FREQUENCY%*.DSK  del %FINAL_TARGET_DISK%\%OSDKNAME%-%FREQUENCY%*.DSK
IF "%FINAL_TARGET_DISK2%"=="" GOTO EndDeleteCopy
IF EXIST %FINAL_TARGET_DISK2%\%OSDKNAME%-%FREQUENCY%*.DSK  del %FINAL_TARGET_DISK2%\%OSDKNAME%-%FREQUENCY%*.DSK
:EndDeleteCopy
IF "%FINAL_TARGET_HFE%"=="" GOTO EndDeleteHFE
IF EXIST %FINAL_TARGET_HFE%  del %FINAL_TARGET_HFE%
:EndDeleteHFE



:: Delete the floppy, just to be sure
IF EXIST build\%OSDKDISK%  del build\%OSDKDISK%


:: Build the slide show parts of the demo
pushd code

SET OSDKCPPFLAGS=-DLANGUAGE_%LANGUAGE% -DFREQUENCY_%FREQUENCY% -DPRODUCT_TYPE_%PRODUCT_TYPE% 
SET OSDKXAPARAMS=-DLANGUAGE_%LANGUAGE% -DFREQUENCY_%FREQUENCY% -DPRODUCT_TYPE_%PRODUCT_TYPE% 

:: Then this retarded code is called twice in a loop:
:: The reason is, that we are including 'loader.cod' inside the loader, but the content is valid only after FloppyBuilder created the layout.
:: In order to create the layout, FloppyBuilder needs to know the files, and their size.
:: In order to know their size, it needs to find them, which means they have to exist, which means they have to be assembled, which is not doable without a valid 'loader.cod'
:: Our (ugly) solution is to assemble the whole thing until it gets stable.
:: A possibility is to have FloppyBuilder return a crc of the floppy it generated, if the crc is the same twice in a row, then the data is stable...

:: -P Inhibit generation of linemarkers in the output from the preprocessor. This might be useful when running the preprocessor on something that is not C code, and will be sent to a program which might be confused by the linemarkers.
:: If you really need to change the search order for system directories, use the -nostdinc and/or -isystem options.
%OSDK%\bin\cpp.exe -P -DOSDKDISK=%OSDKDISK% -DLANGUAGE_%LANGUAGE% -DFREQUENCY_%FREQUENCY% -DPRODUCT_TYPE_%PRODUCT_TYPE% -DDISK_TRACKS=%DISK_TRACKS% -DDISK_SECTORS=%DISK_SECTORS% -DDISK_INTERLEAVE=%DISK_INTERLEAVE% -DDISK_SIDES=%DISK_SIDES% floppybuilderscript_master.txt floppybuilderscript.txt

:: Call FloppyBuilder once to create loader.cod
%osdk%\bin\FloppyBuilder init floppybuilderscript.txt >..\build\floppy_builder_error.txt
IF ERRORLEVEL 1 GOTO FloppyBuilderError

ECHO ---------------- 1st pass ---------------- 
set DISPLAYINFO=0
SET OSDKXAPARAMS=-DLANGUAGE_%LANGUAGE% -DFREQUENCY_%FREQUENCY% -DPRODUCT_TYPE_%PRODUCT_TYPE% -DDISPLAYINFO=0
call ..\bin\_build_pass.bat > NUL
::IF ERRORLEVEL 1 GOTO Error

ECHO ---------------- 2nd pass ---------------- 
set DISPLAYINFO=1
SET OSDKXAPARAMS=-DLANGUAGE_%LANGUAGE% -DFREQUENCY_%FREQUENCY% -DPRODUCT_TYPE_%PRODUCT_TYPE% -DDISPLAYINFO=1
call ..\bin\_build_pass.bat
IF ERRORLEVEL 1 GOTO Error

:: Call FloppyBuilder another time to build the final disk
ECHO.
ECHO %ESC%[95m== Building final floppy ==%ESC%[0m
%osdk%\bin\FloppyBuilder build floppybuilderscript.txt >..\build\floppy_builder_error.txt
IF ERRORLEVEL 1 GOTO FloppyBuilderError
type ..\build\floppy_builder_error.txt

IF "%FINAL_TARGET_DISK%"=="" GOTO EndCopy
ECHO Copying ..\build\%OSDKDISK% to %FINAL_TARGET_DISK%\%OSDKDISK%
copy ..\build\%OSDKDISK% %FINAL_TARGET_DISK%\%OSDKDISK%
IF "%FINAL_TARGET_DISK2%"=="" GOTO EndCopy
ECHO Copying ..\build\%OSDKDISK% to %FINAL_TARGET_DISK2%\%OSDKDISK%
copy ..\build\%OSDKDISK% %FINAL_TARGET_DISK2%\%OSDKDISK%
:EndCopy
IF "%FINAL_TARGET_HFE%"=="" GOTO EndCopyHFE
ECHO Converting ..\build\%OSDKDISK% to %FINAL_TARGET_HFE%
..\bin\hxcfe.exe -finput:"..\build\%OSDKDISK%" -conv:HXC_HFE -foutput:"%FINAL_TARGET_HFE%" >..\build\hxc_error.txt
IF NOT EXIST %FINAL_TARGET_HFE% GOTO HxCError
:EndCopyHFE


popd
goto End

:ProductTypeError
ECHO %ESC%[41m
ECHO "PRODUCT_TYPE is empty"
ECHO %ESC%[0m
goto ConfigurationError

:OSDKDISKError
ECHO %ESC%[41m
ECHO "OSDKDISK is empty"
ECHO %ESC%[0m
goto ConfigurationError

:ConfigurationError
ECHO %ESC%[41m
ECHO The osdk_config.bat has not been configured properly
ECHO %ESC%[0m
EXIT /b 1
goto End

:HxCError
:: Prints the floppy builder error in red to make sure we don't miss it
ECHO %ESC%[41m
type ..\build\hxc_error.txt
ECHO %ESC%[0m
popd
goto Error

:FloppyBuilderError
:: Prints the floppy builder error in red to make sure we don't miss it
ECHO %ESC%[41m
type ..\build\floppy_builder_error.txt
ECHO %ESC%[0m
popd

:Error
::Errors are reported by the top script
::ECHO.
ECHO An Error has happened. Build stopped

:End
::pause
