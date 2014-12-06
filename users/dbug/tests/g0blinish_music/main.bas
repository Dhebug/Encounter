10 REM Simple music player:
20 REM - Music files are loaded in $6700
30 REM - Register buffer in $5900
40 REM - Player binary code in $5600
50 REM Oric 1 compatible version
60 REM
70 HIMEM #5000 
80 TEXT:PAPER4:INK6:CLS
100 PRINT "Loading music player"
110 LOAD"MYMPLAYER.BIN"
200 PRINT "Loading music data"
210 LOAD"MUSIC1.BIN"
200 PRINT "Playing music"
220 CALL#5600
230 PRINT"Press a key to stop
240 GET A$
250 CALL#5603

