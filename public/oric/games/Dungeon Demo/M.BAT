set memo=%path%
set path=c:\oric\DEV\BIN;C:\B;
set OCC=c:\oric\DEV\
set tmp=c:\oric\DEV\
set temp=c:\oric\DEV\
rem cc65 -O1 main.c
cc65 -O2 main.c graf.s timer.s maze.s
set path=%memo%
