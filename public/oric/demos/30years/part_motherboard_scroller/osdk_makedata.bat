::@ECHO OFF

::%OSDK%\bin\PictConv -f1 -d0 -o4 data\mobo_240x200.png picture.s

set MUSIC=bach
::set MUSIC=SyntaxTerror-MadMax
::set MUSIC=ROFM1   -- unknow format
::set MUSIC=CUDDLY1 -- unknow format
::set MUSIC=NONAME  -- unknow format
::set MUSIC=JAMBLV4 -- unknow format
::set MUSIC=BA_MUS1  :: 8535 - Killer (all buggy it seems and out of stream)

D:\svn\public\pc\tools\osdk\main\Osdk\_final_\Bin\ym2mym.exe data\bach.YM %osdk%\TMP\bach.mym
%osdk%\bin\bin2txt -f2 -h1 -s1 %osdk%\TMP\bach.mym  music.s _Music


pause
