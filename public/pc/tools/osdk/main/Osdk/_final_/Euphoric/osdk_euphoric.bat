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
SET OSDKEUPHORIC=euphoric.exe

:: - Tape or Disk based
IF     "%OSDKDISK%"=="" SET OSDKEUPHORIC=%OSDKEUPHORIC% OSDK.TAP
IF NOT "%OSDKDISK%"=="" SET OSDKEUPHORIC=%OSDKEUPHORIC% -d OSDK.DSK


::
:: Check if the program was compiled
:: Then copy the compiled program into Euphoric folder 
::
IF EXIST build\%OSDKNAME%.TAP GOTO OkFile
IF EXIST build\%OSDKNAME%.DSK GOTO OkFile
IF EXIST %OSDKDISK% GOTO OkFile
GOTO ErBld

:OkFile
COPY build\%OSDKNAME%.TAP %OSDK%\Euphoric\OSDK.TAP >NUL
COPY build\%OSDKNAME%.DSK %OSDK%\Euphoric\OSDK.DSK >NUL
COPY build\symbols %OSDK%\Euphoric\symbols >NUL


::
:: Special detection to see if we should run Euphoric
:: directly, or using an alternate system (like DOSBox)
::
IF "%OSDKDOSBOX%"=="" GOTO RunDefault

::
:: Execute the emulator (DosBOX Version)
::
:RunDosBox
TYPE %OSDK%\BIN\dosbox.conf > %OSDK%\Euphoric\dosbox.conf
ECHO mount c %osdk%\Euphoric >> %OSDK%\Euphoric\dosbox.conf
ECHO c:  >> %OSDK%\Euphoric\dosbox.conf
ECHO SET ORIC=c:\ >> %OSDK%\Euphoric\dosbox.conf
ECHO %OSDKEUPHORIC%  >> %OSDK%\Euphoric\dosbox.conf
CD %OSDK%\Euphoric
"%OSDKDOSBOX%"
GOTO End



::
:: Execute the emulator in fullscreen default mode
::
:RunDefault
SET ORIC=%OSDK%\Euphoric\
CD %OSDK%\Euphoric
CALL %OSDKEUPHORIC%
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
