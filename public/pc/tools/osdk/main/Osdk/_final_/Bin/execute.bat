@ECHO OFF

::
:: Store the current directory
::
SET _=%CD%

::
:: Initial checks to verify that everything is fine.
::
IF "%OSDK%"=="" GOTO ErCfg

::
:: Find which emulator we should run.
::
IF "%OSDKEMUL%"=="" GOTO LaunchOricutron
IF "%OSDKEMUL%"=="ORICUTRON" GOTO LaunchOricutron
IF "%OSDKEMUL%"=="EUPHORIC" GOTO LaunchEuphoric

ECHO == ERROR ==
ECHO The OSDKEMUL variable contains an invalid value
ECHO It shoul either be not set, or set to either EUPHORIC or ORICUTRON
ECHO ===========
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End

:LaunchEuphoric
CALL %OSDK%\Euphoric\osdk_euphoric.bat
GOTO End

:LaunchOricutron
CALL %OSDK%\Oricutron\osdk_oricutron.bat
GOTO End


::
:: Outputs an error message about configuration
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
ECHO ===========
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End

:End
CD %_%
