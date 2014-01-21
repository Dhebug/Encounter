@ECHO OFF


::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg


::
:: Set the build paremeters
::
CALL osdk_config.bat


::
:: Launch the compilation of files
::
CALL %OSDK%\bin\make.bat %OSDKFILE%


GOTO End


::
:: Outputs an error message
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End


:End
copy /b %OSDK%HNEFATAFL-LOADER\HNEFBAT.TAP+%OSDK%HNEFATAFL-LOADER\BUILD\HNEFATAFL-LOAD.TAP+%OSDK%HNEFATAFL\BUILD\HNEFATAFL-MAIN.TAP %OSDK%HNEFATAFL-LOADER\HNEFATAFL.TAP

%OSDK%bin\tap2dsk.exe -i"!HNEFBAT"  %OSDK%HNEFATAFL-LOADER\HNEFATAFL.TAP %OSDK%HNEFATAFL-LOADER\HNEFATAFL.DSK
%OSDK%bin\old2mfm.exe %OSDK%HNEFATAFL-LOADER\HNEFATAFL.DSK
copy %OSDK%HNEFATAFL-LOADER\HNEFATAFL.DSK %OSDK%ORICUTRON\DISKS

pause