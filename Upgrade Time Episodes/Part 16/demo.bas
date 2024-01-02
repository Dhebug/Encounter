
  '0 GET K$

 15 REPEAT
 16 PAPER3:INK4:CLS:F=FRE(0):POKE#26A,10

 17 MOVE#B400,#BB80,#9800                              ' Move the font from TEXT to HIRES area
 18 POKE #2C0,3:CURSET0,0,0:FILL 200,40,0:POKE #2C0,2  ' Clear the entire screen area
 19 POKE #BFDF,31                                      ' HIRES switch attribute
 20 LOAD"TITLE.BIN"                                    ' Load the title picture
 21 K$=""
 22 POKE#26B,16+3:POKE#26C,4:PRINT@2,25;"  Encounter ";CHR$(96);" 1983 Severn Software":PRINT"Redux Additions ";CHR$(96);" 2018 Defence-Force";
 25 WT=500:GOSUB 1000
 26 POKE #2C0,3:CURSET0,0,0:FILL200,40,0:POKE #2C0,2:PAPER0:INK0:CLS:POKE #BFDF,26
 27 WT=50:GOSUB 1000:MOVE#9800,#9F80,#B400
 28 ' GET K$
 29 IF K$="" THEN WT=600:GOSUB 100
 30 IF K$="" THEN WT=1200:GOSUB 400
 35 IF K$="" THEN GOSUB 500
 40 UNTIL K$<>""

 50 CLS:PAPER0:INK0:POKE#26A,10:POKE#BB80,0:POKE#BB80+35,0:Z$=CHR$(27)
 60 PRINT@15,11;Z$;"N";Z$;"CLOADING"
 70 PRINT@15,12;Z$;"N";Z$;"ALOADING"  
 80 LOAD"ENCOUNTER"

 90 PRINT"SHOULD NEVER REACH HERE":PING:ZAP:SHOOT:EXPLODE:GET K$
 95 GOTO 16



 100 '
 101 ' Hall of fame / Employee of the month
 102 ' 
 110 PAPER0:CLS:DOKE #278,48000:DOKE #27A,48000:DOKE #27C,40*28:DOKE #27E,28:CLS
 111 LOAD"SCORES",N
 115 A$="Leaderboard":FOR I=1 TO LEN(A$):POKE#BB80+13+I,ASC(MID$(A$,I,1)):NEXT
 120 POKE#BB80,16+1:POKE#BB80+1,3

 130 RS$(1)="BSolved the case"   
 140 RS$(2)="EMaimed by a dog"   
 150 RS$(3)="AShot by a thug"    
 160 RS$(4)="CFell into a pit"   
 170 RS$(5)="CTripped the alarm" 
 180 RS$(6)="FRan out of time"   
 190 RS$(7)="ABlown into bits"   
 200 RS$(8)="GSimply Vanished!"   
 210 RS$(9)="HGave up..."   

 300 AD=#9C00:SC=#BB80+80:Z$=CHR$(27)
 310 FOR I=1 TO #18
 315 REM PRINT@#10-LEN(NA$),I;NA$;Z$;"D"
 316 MOVE AD+3,AD+19,SC:POKESC+16,4
 320 PRINT@#11,I;DEEK(AD)-#8000
 321 PRINT@#16,I;Z$;RS$(PEEK(AD+2))
 355 AD=AD+#13
 356 SC=SC+#28
 360 NEXT
 380 GOTO 1000


 400 ' 
 401 ' User manual
 402 '
 431 CLS:PAPER3:POKE#BB80,16+3:POKE#BB80+35,3:PRINT:PRINT Z$"A           How to play"
 432 PRINT:PRINT"Your task is to find and rescue a"
 433 PRINT"young girl kidnapped by thugs."
 434 PRINT:PRINT"Give orders using VERBS and NOUNS"
 435 PRINT"eg:EMP(ty) BOT(tle) or GET KEY(s)"
 436 PRINT:PRINT;Z$"A   MOVEMENT            VERBS"
 437 PRINT:PRINT"N:NORTH S:SOUTH   GET DROP THROW KILL"
 438 PRINT"W:WEST E:EAST     HIT MAKE CLIMB QUIT"   
 439 PRINT"U:UP D:DOWN       OPEN LOAD FRISK USE"
 440 PRINT"L:Look                READ PRESS BLOW"
 441 PRINT;Z$"A              NOTES";Z$"D    SHOOT SIPHON"
 442 PRINT:PRINT"Everything you need is here but you":PRINT"may have to manufacture some items."
 443 PRINT:PRINT"The mission fails if the movement or":PRINT"alarm counters reaches zero."
 444 PRINT:PRINT"Drawing and annotating a map helps." 
 444 PRINT:PRINT"Good luck, you will need it..." 
 450 GOTO 1000

 500 '
 501 ' Story
 502 '
 510 POKE#26B,16+7:POKE#26C,0:CLS
 515 PRINT:PRINT:PRINT:F=FRE(0)
 518 M$="Wednesday, September 1st, 1982"+CHR$(13)+CHR$(13)+CHR$(13):GOSUB 50500
 520 M$="I remember it like if it was yesterday"+CHR$(13)+CHR$(13):GOSUB 50500
 520 M$="My client had asked me to save their"+CHR$(13)+"daughter who had been kidnapped by"+CHR$(13):GOSUB 50500
 530 M$="some vilains who hide in a posh house"+CHR$(13)+"in the middle of nowhere."+CHR$(13)+CHR$(13):GOSUB 50500
 540 M$="I was given carte blanche on how to"+CHR$(13)+"solve the issue..."+CHR$(13):GOSUB 50500
 550 M$="...using lethal force if necessary."+CHR$(13)+CHR$(13)+CHR$(13):GOSUB 50500
 560 M$="I parked my car on the market place"+CHR$(13)+"and approached discretely by foot to"+CHR$(13):GOSUB 50500
 565 M$="not alert them from my presence..."+CHR$(13)+CHR$(13):GOSUB 50500
 570 WT=500:GOSUB 1000
 580 RETURN


 1000 '
 1001 ' Temporization/wait key
 1002 '
 1005 IF K$<>"" THEN RETURN
 1010 DOKE 630,0
 1020 REPEAT
 1030 K$=KEY$
 1040 UNTIL K$<>"" OR (WT<>0 AND (65535-DEEK(630))> WT)
 1050 RETURN

 
 50500 '
 50501 ' Typewriter intro style
 50502 ' Input: M$ contains the sentence
 50503 '
 50504 IF K$<>"" THEN RETURN
 50510 FOR I=1 TO LEN(M$):C$=MID$(M$,I,1)
 50515 K$=KEY$:IF K$<>"" THEN RETURN
 50520 IF C$=CHR$(13) THEN CALL#FB2A:PRINT:WAIT 8+RND(1)*12 ELSE CALL#FB14:PRINT C$;:WAIT 0+RND(1)*5
 50530 NEXT I
 50540 RETURN 


