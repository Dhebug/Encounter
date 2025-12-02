@ECHO OFF

set GW_FOLDER=C:\oric\greaseweazle-1.22
set GW_DEVICE=COM4
set GW_DRIVE=0
set GW_GEOMETRY=c=0-41:h=0,1:step=1

ECHO Cleaning disk
%GW% clean --device=%GW_DEVICE% --drive=%GW_DRIVE% --cyls=42 --linger=300

:End
ECHO.
ECHO.
::pause
