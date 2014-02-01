::@ECHO OFF

ECHO.
ECHO Assembling bootsectors
%osdk%\bin\xa basic11b.tas -o basic11b.o
IF ERRORLEVEL 1 GOTO Error

goto End

:Error
ECHO.
ECHO An Error has happened. Build stopped

:End
pause
