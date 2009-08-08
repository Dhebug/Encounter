@ECHO OFF
SET WMSLNAME=wmsl_code
SET STARTADDR=$C000
SET INPUTFN=%WMSLNAME%
SET OUTTAP=%WMSLNAME%.tap
%OSDK%\bin\xa.exe %INPUTFN%.s -o %SSCNAME%.bin -e xaerr.txt -l %INPUTFN%.txt
pause
