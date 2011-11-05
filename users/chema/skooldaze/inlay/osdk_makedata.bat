@ECHO OFF
::%OSDK%\bin\pictconv -t1 -m0 -f1 -o5_PictureSkoolDazeTitle oric-title-picture-dbug.png skooldaze_title_converted.png
::%OSDK%\bin\pictconv -m0 -f1 -o5_PictureSkoolDazeTitle oric-title-picture-dbug.png skooldaze_title_converted.png

%OSDK%\bin\pictconv -m0 -f1 -n40 -o4_PictureSkoolDazeTitle oric-title-picture-dbug-top.png picture.s
%OSDK%\bin\pictconv -t1 -m0 -f1 -n40 -o4_PictureSkoolDazeScores oric-title-picture-dbug-bottom.png picture-bottom.s

pause
