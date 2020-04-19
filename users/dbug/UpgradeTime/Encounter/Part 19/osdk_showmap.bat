@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg


%osdk%\bin\MemMap.exe build\symbols_FirstProgram map_first.htm First %OSDK%\documentation\documentation.css
%osdk%\bin\MemMap.exe build\symbols_SecondProgram map_second.htm Second %OSDK%\documentation\documentation.css
explorer map_first.htm 
explorer map_second.htm


GOTO End


::
:: Outputs an error message
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
pause
GOTO End


:End

