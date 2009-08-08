@ECHO OFF
cd SSC_Modules
SET SSCNAME=sscm-om3s1
SET STARTADDR=$C000
SET INPUTFN=%SSCNAME%
SET OUTTAP=%SSCNAME%.tap
SET AUTOFLAG=1
%OSDK%\bin\xa.exe %INPUTFN%.s -o %SSCNAME%.bin -e xaerr.txt -l %INPUTFN%.txt
pause
