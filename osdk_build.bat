@ECHO OFF
setlocal

:: Create a ESC environment variable containing the escape character
:: See: https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011#file-win10colors-cmd
for /F %%a in ('"prompt $E$S & echo on & for %%b in (1) do rem"') do set "ESC=%%a"

echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo %ESC%[1mBuild started: %date% %time%%ESC%[0m
set ENCOUNTER_BUILD_START=%time%

::
:: Initial check.
:: Verify if the SDK is correctly configured
::
IF "%OSDK%"=="" GOTO ErCfg

::
:: Set the build parameters
::
CALL osdk_config.bat
SET LANGUAGE=%TEST_LANGUAGE%

:: Create the folders we need
if not exist "build" md build
pushd build
if not exist "files" md files
popd

::
:: Build assets (this is for all the versions of the game)
::
call osdk_makedata.bat
IF ERRORLEVEL 1 GOTO Error

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
    SET TEST_BUILT=%TEST_BUILT%X
  )
  for %%l in (%BUILD_FREQUENCIES%) do (
    SET FREQUENCY=%%l
    if "%FREQUENCY%"=="%TEST_FREQUENCY%" (
      SET TEST_BUILT=%TEST_BUILT%X
    )
    call bin\_build.bat
    IF ERRORLEVEL 1 GOTO Error
  )
)

:: If the test language was not part of the build list, we build it
if NOT "%TEST_BUILT%"=="XX" (  
  SET LANGUAGE=%TEST_LANGUAGE%
  SET FREQUENCY=%TEST_FREQUENCY%
  call bin\_build.bat
  IF ERRORLEVEL 1 GOTO Error
)

:Done


:: Build successfull!
ECHO.
goto End


:Error
ECHO.
ECHO %ESC%[41mAn Error has happened. Build stopped%ESC%[0m

:End
::pause
set OSDK_BUILD_START=%ENCOUNTER_BUILD_START%
set OSDK_BUILD_END=%time%
call %OSDK%\bin\ComputeTime.bat
echo %ESC%[1mBuild completed: %date% %time%%ESC%[0m
ECHO Total build time: %OSDK_BUILD_TIME%

echo.
echo.
