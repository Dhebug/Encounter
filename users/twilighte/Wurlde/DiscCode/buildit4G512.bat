@ECHO OFF
SET STARTADDR=$FD00
SET INPUTFN=Generic512
SET AUTOFLAG=1
c:\emulate\crosscompilers\osdk\bin\xa.exe %INPUTFN%.s -o Generic512.bin -e xaerr.txt -l %INPUTFN%.txt
copy Generic512.bin C:\OSDK\bin /y
pause
