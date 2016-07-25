srep "org $a00" "org $600" c:\oric\dev\lib16\header.s"
set memo=%path%
set path=c:\oric\DEV\BIN;C:\B;
set OCC=c:\oric\DEV\
set tmp=c:\oric\DEV\
set temp=c:\oric\DEV\
rem cc65 -O1 main.c
cc65 -O2 main.c
set path=%memo%
copy a.out ..\loader.com
copy a.out ..\d\loader.com
