@ECHO OFF
SET STARTADDR=$400
SET INPUTFN=MicrodiscBootStrap
SET OUTTAP=x.tap
SET AUTOFLAG=1
c:\emulate\crosscompilers\osdk\bin\xa.exe %INPUTFN%.s -o microdisc.bss -e xaerr.txt -l %INPUTFN%.txt
copy microdisc.bss C:\FireFly\DSKBuilder /y
pause
