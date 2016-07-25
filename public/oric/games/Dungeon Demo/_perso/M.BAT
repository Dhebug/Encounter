srep "org $600" "org $a00" c:\oric\dev\lib16\header.s"
set memo=%path%
set path=c:\oric\DEV\BIN;C:\B;
set OCC=c:\oric\DEV\
set tmp=c:\oric\DEV\
set temp=c:\oric\DEV\
rem cc65 -O1 main.c
cc65 -O2 main.c graf.s timer.s
set path=%memo%
copy a.out ..\perso.com
copy a.out ..\a.out
