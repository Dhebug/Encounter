%OSDK%\bin\xa overlay.s -o overlay.out
%OSDK%\bin\header -a0 overlay.out overlay.tap $500
%OSDK%\bin\taptap ren overlay.tap "DATA" 0
pause