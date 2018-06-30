@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated,
::
IF "%OSDK%"=="" GOTO ErCfg

::
:: Then we create the correct Euphoric command line call
:: depending of parameters we have:
:: - Rom choice
:: - Machine choice
::
SET OSDKORICUTRON=oricutron.exe

:: - Tape or Disk based
IF     "%OSDKDISK%"=="" SET OSDKORICUTRON=%OSDKORICUTRON% -t OSDK.TAP -s symbols
IF NOT "%OSDKDISK%"=="" SET OSDKORICUTRON=%OSDKORICUTRON% -d OSDK.DSK -s symbols 
::-k jasmin


::
:: Check if the program was compiled
:: Then copy the compiled program into Euphoric folder 
::
IF EXIST build\%OSDKNAME%.TAP GOTO OkFile
IF EXIST build\%OSDKNAME%.DSK GOTO OkFile
IF EXIST %OSDKDISK% GOTO OkFile
GOTO ErBld

:OkFile
COPY build\%OSDKNAME%.TAP %OSDK%\Oricutron\OSDK.TAP >NUL
COPY build\%OSDKNAME%.DSK %OSDK%\Oricutron\OSDK.DSK >NUL
COPY build\symbols %OSDK%\Oricutron\symbols >NUL


::
:: Execute the emulator in fullscreen default mode
::
:RunDefault
PUSHD %OSDK%\Oricutron
START %OSDKORICUTRON%
POPD
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

::
:: Outputs an error message about compilation
::
:ErBld
ECHO == ERROR ==
ECHO Before executing this program, you need to build it.
ECHO Please run OSDK_BUILD.BAT before.
ECHO ===========
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End

:End
