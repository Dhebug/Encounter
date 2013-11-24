@ECHO OFF

::%OSDK%\bin\PictConv -f0 -d0 -o4BallData -n4 data\ball_24x32.png ball_24x32.s
%OSDK%\bin\PictConv -f0 -d0 -o4BallData data\ball_6x128.png ball_24x32.s

pause