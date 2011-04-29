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
:: Check if the program was compiled
::
IF NOT EXIST build\%OSDKNAME%.TAP GOTO ErBld

::
:: Copy the compiled program into Euphoric folder 
::
COPY build\%OSDKNAME%.TAP %OSDK%\Euphoric\%OSDKNAME%.TAP

::
:: Execute the emulator
::
SET ORIC=%OSDK%\Euphoric\
"C:\Program Files\VDMSound\dosdrv" 
set BLASTER=A220 I7 D1 H5 P330 T6
CALL %OSDK%\Euphoric\Euphoric.exe %OSDK%\Euphoric\%OSDKNAME%.TAP
GOTO End

SET ORIC=%OSDK%\Euphoric\
CALL %OSDK%\Euphoric\Euphoric.exe %OSDK%\Euphoric\%OSDKNAME%.TAP
GOTO End


::
:: Outputs an error message about configuration
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
GOTO End

::
:: Outputs an error message about compilation
::
:ErBld
ECHO == ERROR ==
ECHO Before executing this program, you need to build it.
ECHO Please run OSDK_BUILD.BAT before.
GOTO End

:End
