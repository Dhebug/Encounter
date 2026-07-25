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

SET OSDKBRIEF=NOPAUSE

::
:: Initial check.
:: Verify if the SDK is correctly configured
::
IF "%OSDK%"=="" GOTO ErCfg

::
:: Verify the OSDK is recent enough for this project.
:: The actual version comparison lives in %OSDK%\bin\checkversion.bat (added in
:: OSDK %OSDK_REQUIRED%). An OSDK too old to contain it cannot report a version, so it
:: is treated as too old. A missing feature means the build would not work -> hard stop.
::
SET OSDK_REQUIRED=2.0
IF NOT EXIST "%OSDK%\bin\checkversion.bat" GOTO ErVersion
CALL "%OSDK%\bin\checkversion.bat" %OSDK_REQUIRED%
IF ERRORLEVEL 1 GOTO ErVersion

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


::
:: Outputs an error message
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End


::
:: Outputs a version error message
::
:ErVersion
ECHO == ERROR ==
ECHO This project requires OSDK %OSDK_REQUIRED% or newer.
ECHO Your OSDK is too old, or cannot report its version.
ECHO Update your OSDK, or verify %OSDK%\bin\checkversion.bat is present.
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End


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

:: Warn if any module's file list is missing (commented out in osdk_config.bat for fast iteration).
:: A real release must rebuild every module from source — anything else uses cached .o files.
if "%OSDKFILE_KERNEL%"=="" goto :partial_build
if "%OSDKFILE_SPLASH%"=="" goto :partial_build
if "%OSDKFILE_INTRO%"==""  goto :partial_build
if "%OSDKFILE_GAME%"==""   goto :partial_build
if "%OSDKFILE_OUTRO%"==""  goto :partial_build
if "%OSDKFILE_KING%"==""   goto :partial_build
goto :build_done
:partial_build
ECHO.
ECHO %ESC%[48;5;130;37m Test build: one or more OSDKFILE_* modules are commented out in osdk_config.bat %ESC%[0m
:build_done

echo.
echo.
