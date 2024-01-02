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

:: For each language, build the version, making sure to write down if we built the test version.
:: If it was not part of BUILD_LANGUAGES then we need to build it separately.
:: This is for making it easier and faster to build stuff during development, just keep BUILD_LANGUAGES undefined and change TEST_LANGUAGE to test
SET TEST_BUILT=
for %%i in (%BUILD_LANGUAGES%) do (
  SET LANGUAGE=%%i
  if "%LANGUAGE%"=="%TEST_LANGUAGE%" (
    SET TEST_BUILT=%LANGUAGE%
  )
  call _build.bat
  IF ERRORLEVEL 1 GOTO Error
)

:: If the test language was not part of the build list, we build it
if NOT "%TEST_BUILT%"=="%TEST_LANGUAGE%" (
  SET LANGUAGE=%TEST_LANGUAGE%
  call _build.bat
)

:Done

:: Build successful!
ECHO.
goto End


:Error
ECHO.
ECHO An Error has happened. Build stopped

:End
::pause
