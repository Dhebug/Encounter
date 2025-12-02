@ECHO OFF

set GW_FOLDER=D:\Oric\tools\greaseweazle-1.22
set GW=%GW_FOLDER%\gw.exe
set GW_DEVICE=COM8
set GW_DRIVE=0
set GW_GEOMETRY=c=0-41:h=0,1:step=1
set GW_HFE_FILE=%1

IF EXIST %GW_HFE_FILE% goto HfeFileExists
ECHO EROR: Could not find '%GW_HFE_FILE%' source file 
goto End

:HfeFileExists
GOTO DoWrite
ECHO Getting GreaseWeazle infos
%GW% info

%gw% rpm --nr 10 --drive=0

ECHO.
ECHO Please insert floppy disk in drive %GW_DRIVE%
pause

:DoWrite
ECHO Writing disk to device
%GW% write --device=%GW_DEVICE% --drive=%GW_DRIVE% --tracks=%GW_GEOMETRY% %GW_HFE_FILE%


:End
ECHO.
ECHO.
::pause
