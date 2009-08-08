@ECHO OFF
SET STARTADDR=$500
SET INPUTFN=Driver
SET OUTTAP=dhs.tap
SET AUTOFLAG=1
d:\emulate\crosscompilers\osdk\bin\xa.exe %INPUTFN%.s -o final.out -e xaerr.txt -l %INPUTFN%.txt
d:\emulate\crosscompilers\osdk\bin\header.exe -a%AUTOFLAG% final.out %OUTTAP% %STARTADDR%
copy %OUTTAP% c:\emulate\oric\shared /Y
pause
