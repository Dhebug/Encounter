@ECHO OFF
SET STARTADDR=$9fc5
SET INPUTFN=fantasboot
SET OUTTAP=fan.tap
SET AUTOFLAG=0
c:\osdk\bin\xa.exe %INPUTFN%.s -o fantas.sec -e xaerr.txt -l %INPUTFN%.txt
pause

