@ECHO OFF
SET STARTADDR=$FE00
SET INPUTFN=GenericLoadSave
SET OUTTAP=x.tap
SET AUTOFLAG=1
c:\emulate\crosscompilers\osdk\bin\xa.exe %INPUTFN%.s -o Generic.bss -e xaerr.txt -l %INPUTFN%.txt
copy Generic.bss C:\FireFly\DSKBuilder /y
pause
