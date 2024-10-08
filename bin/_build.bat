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

:: Delete the floppy, just to be sure
IF EXIST build\%OSDKDISK%  del build\%OSDKDISK%


:: Build the slide show parts of the demo
pushd code

SET OSDKCPPFLAGS=-DLANGUAGE_%LANGUAGE% -DPRODUCT_TYPE_%PRODUCT_TYPE% 
SET OSDKXAPARAMS=-DLANGUAGE_%LANGUAGE% -DPRODUCT_TYPE_%PRODUCT_TYPE% 

:: Then this retarded code is called twice in a loop:
:: The reason is, that we are including 'loader.cod' inside the loader, but the content is valid only after FloppyBuilder created the layout.
:: In order to create the layout, FloppyBuilder needs to know the files, and their size.
:: In order to know their size, it needs to find them, which means they have to exist, which means they have to be assembled, which is not doable without a valid 'loader.cod'
:: Our (ugly) solution is to assemble the whole thing until it gets stable.
:: A possibility is to have FloppyBuilder return a crc of the floppy it generated, if the crc is the same twice in a row, then the data is stable...

:: -P Inhibit generation of linemarkers in the output from the preprocessor. This might be useful when running the preprocessor on something that is not C code, and will be sent to a program which might be confused by the linemarkers.
:: If you really need to change the search order for system directories, use the -nostdinc and/or -isystem options.
%OSDK%\bin\cpp.exe -P -DOSDKDISK=%OSDKDISK% -DLANGUAGE_%LANGUAGE% -DPRODUCT_TYPE_%PRODUCT_TYPE% floppybuilderscript_master.txt floppybuilderscript.txt

:: Call FloppyBuilder once to create loader.cod
%osdk%\bin\FloppyBuilder init floppybuilderscript.txt >..\build\floppy_builder_error.txt
IF ERRORLEVEL 1 GOTO FloppyBuilderError

ECHO ---------------- 1st pass ---------------- 
set DISPLAYINFO=0
SET OSDKXAPARAMS=-DLANGUAGE_%LANGUAGE% -DPRODUCT_TYPE_%PRODUCT_TYPE% -DDISPLAYINFO=0
call ..\bin\_build_pass.bat > NUL
::IF ERRORLEVEL 1 GOTO Error

ECHO ---------------- 2nd pass ---------------- 
set DISPLAYINFO=1
SET OSDKXAPARAMS=-DLANGUAGE_%LANGUAGE% -DPRODUCT_TYPE_%PRODUCT_TYPE% -DDISPLAYINFO=1
call ..\bin\_build_pass.bat
IF ERRORLEVEL 1 GOTO Error

:: Call FloppyBuilder another time to build the final disk
ECHO.
ECHO %ESC%[95m== Building final floppy ==%ESC%[0m
%osdk%\bin\FloppyBuilder build floppybuilderscript.txt
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
