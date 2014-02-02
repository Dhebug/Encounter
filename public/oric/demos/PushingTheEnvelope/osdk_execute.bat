@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated,
::
IF "%OSDK%"=="" GOTO ErCfg

::
:: Set the build paremeters
::
CALL osdk_config.bat

::
:: Run the emulator using the common batch
::
CALL %OSDK%\bin\execute.bat
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
::pause