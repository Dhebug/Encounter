@ECHO OFF
SET STARTADDR=$400
SET INPUTFN=JasminBootStrap
SET OUTTAP=x.tap
SET AUTOFLAG=1
c:\emulate\crosscompilers\osdk\bin\xa.exe %INPUTFN%.s -o jasmin.bss -e xaerr.txt -l %INPUTFN%.txt
copy jasmin.bss C:\FireFly\DSKBuilder /y
pause
