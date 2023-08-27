@ECHO OFF
setlocal

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg

:: Create the folders we need
if not exist "build" md build
pushd build
if not exist "files" md files
popd

::
:: Build assets (this is for all the versions of the game)
::
call osdk_makedata.bat

:: Call the config script to get the list of versions to build
:: Returned into BUILD_LANGUAGES
call osdk_config.bat

:: For each language, build the version
for %%i in (%BUILD_LANGUAGES%) do (
  SET LANGUAGE=%%i
  call _build.bat
  IF ERRORLEVEL 1 GOTO Error
)

:: Build successful!
ECHO.
goto End


:Error
ECHO.
ECHO An Error has happened. Build stopped

:End
::pause
