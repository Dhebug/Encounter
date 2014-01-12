10 REM Simple music player:
20 REM - Music files are loaded in $7600
30 REM - Register buffer in $6800
40 REM - Player binary code in $6500
50 REM Oric 1 compatible version
60 REM
70 HIMEM #6000 
80 TEXT:PAPER4:INK6:CLS
100 PRINT "Loading music player"
110 LOAD"MYMPLAYER.BIN"
120 CLS:GOSUB 1000:PRINT:PRINT"Number:Select music    Space:Quit"
130 GET A$
140 IF A$=" " THEN END
145 IF A$>="1" OR A$<="7" THEN GOTO 200
150 GOTO 120
160 REM
170 REM Loading music
180 REM
200 PRINT "Loading "+A$
210 LOAD"MUSIC"+A$+".BIN"
200 PRINT "Currently playing music "+A$
220 CALL#6500
230 PRINT"Press a key to continue"
240  GET A$
250 CALL#6503
270 GOTO 120
1000 REM
1001 REM MENU
1002 REM
1010 PRINT"   WELCOME TO THE ORIC "
1020 PRINT"ARCADE MUSIC GREATEST HITS"
1030 PRINT
1040 PRINT"CHOOSE THE MUSIC:"
1050 PRINT"1-Bubble Bobble"
1060 PRINT"2-Great Giana Sisters"
1070 PRINT"3-Rainbow Islands (Broken)"
1080 PRINT"4-Pac Mania"
1090 PRINT"5-Tetris"
1100 PRINT"6-Speedball"
1100 PRINT"7-Nebulus"
1500 RETURN

