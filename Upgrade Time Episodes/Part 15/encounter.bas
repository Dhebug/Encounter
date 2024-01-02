#labels 
 '
 '                    Encounter
 '             (c) 1983 Severn Software
 '
 ' Updated by Mickaël Pointier aka Dbug/Defence-Force.
 ' To build this version, you need at least Bas2Tap 1.3
 '
 ' Basic documentation of the game internals:
 '
 ' Containers:
 ' 0 - None
 ' 1 - Bucket
 ' 2 - Box
 ' 3 - Fishing net
 ' 4 - 
 ' 5 - Plastic Bag
 ' 6 - Tin

 ' Container variables:
 ' WW - Water 
 ' Y  - Yellow Powder
 ' B  - Black Dust
 ' G  - Petrol
 ' EE - Gunpowder 
 ' PP - Dove 

 ' Items:
 ' PL=3  - Plastic Bag
 ' BD=4  - Black Dust
 ' KY=5  - Set of keys
 ' YP=7  - Gritty Yellow Powder
 ' BU=8  - Wooden Bucket
 ' RO=8  - Lenght of rope
 ' WA=8  - Some water
 ' PG=9  - Large dove    -- DV ?
 ' BX=14 - Cardboard Box
 ' TW=14 - Twine
 ' KN=16 - Silver Knife
 ' NE=17 - Fishing Net
 ' LD=19 - Ladder
 ' CR=11 - Abandonned Car
 ' BL=20 - Three .38 bullets
 ' ME=26 - Joint of meat
 ' BR=26 - Brown Bread
 ' TN=23 - Empty tobacco tin
 ' DG=24 - Alsatian dog
 ' TP=25 - Roll of Sticky Tape
 ' BK=25 - Chemistry book
 ' MA=30 - Box of matches
 ' CU=28 - Snooker Cue
 ' SA=21 - Heavy Safe
 ' NO=38 - Printed note
 ' GL=43 - Young girl tied up on the floor
 ' TT=36 - Roll of toilet tissue
 ' TG=34 - Thug asleep on the bed
 ' SB=99 - Small bottle
 ' HP=12 - Hose Pipe
 ' PT=99 - Some petrol
 ' GP=99 - Some gunpowder
 ' FU=99 - Fuse
 ' PU=99 - Pistol
 ' AB=99 - Acide burn
 ' BB=99 - Broken glass
 ' BM=99 - Bomb
 ' LP=99 - Loaded pistol
 ' HD=99 - Small Hole in the door
 ' OS=99 - Open Safe
 ' GF=99 - Young girl
 ' CP=20 - Locked Panel
 ' PO=99 - Open Panel
 ' RH=   - A rope hangs from the window


GameStart:  
 1 GOTO Initializations   ' Jump to game start

 ' Generic error message jumping back to the main interpreter
 10 PRINT:PRINT"Sorry, can't do that":GOTO WhatAreYouGoingToDoNow
 11 PRINT:PRINT"Eh ??":GOTO WhatAreYouGoingToDoNow
 12 PRINT:PRINT"Come again ?":GOTO WhatAreYouGoingToDoNow
 13 PRINT:PRINT"Let's try again, eh":GOTO WhatAreYouGoingToDoNow
 14 PRINT:PRINT"You aren't carrying one":GOTO WhatAreYouGoingToDoNow
 15 PRINT:PRINT"Sorry, that's full":GOTO WhatAreYouGoingToDoNow
 16 PRINT:PRINT"Okay":GOTO WhatAreYouGoingToDoNow
 17 PRINT:PRINT"You will have to DROP something":GOTO WhatAreYouGoingToDoNow
 18 PRINT:PRINT"Your bottle is full":GOTO WhatAreYouGoingToDoNow
 19 PRINT:PRINT"Your bucket is full":GOTO WhatAreYouGoingToDoNow
 20 PRINT:PRINT"It weighs too much":GOTO WhatAreYouGoingToDoNow
 21 PRINT:PRINT"It's locked":GOTO WhatAreYouGoingToDoNow
 22 PRINT:PRINT"It is open":GOTO WhatAreYouGoingToDoNow
 23 PRINT:PRINT"It's too steep":GOTO WhatAreYouGoingToDoNow
 24 PRINT:PRINT"Good idea":GOTO WhatAreYouGoingToDoNow
 25 PRINT:PRINT"No needless violence":GOTO WhatAreYouGoingToDoNow
 26 PRINT:PRINT"No, I don't think so":GOTO WhatAreYouGoingToDoNow
 27 PRINT:PRINT"You don't have any":GOTO WhatAreYouGoingToDoNow
 28 PRINT:PRINT"*CRASH*TINKLE* There is a funny smell.":GOTO WhatAreYouGoingToDoNow

 40 PRINT:PRINT"Don't be ridiculous":IFPT=ATHENPT=99  ' Empties the petrol...
 41 GOTO WhatAreYouGoingToDoNow

 ' Comment messages when player does actions
 57 PRINT:PRINT"The water spills out and drains away":RETURN
 58 PRINT:PRINT"The petrol spills out and evaporates":RETURN 

 ' Game start initialization
Initializations: 
 100 GOSUBInitializeGraphicMode:CLS:PL=3:BD=4:KY=5:YP=7:BU=8:RO=8:WA=8:PG=9:BX=14:TW=14:KN=16:NE=17
 101 LD=19:CR=11:BL=20:ME=26:BR=26:TN=23:DG=24:AV=1:TP=25:BK=25:MA=30:CU=28
 102 SA=21:NO=38:GL=43:TT=36:TG=34:AL=1:SB=99:HP=12:PT=99:GP=99:FU=99
 103 PU=99:AB=99:BB=99:BM=99:LP=99:HD=99:OS=99:GF=99:CP=20:PO=99:EC=8

 ' List of all locations
 1000 A=1:D$="You are in a deserted market square":GOSUB ShowLocationDescription
 1001 IF GL<=0THENPRINT"and you have made it - WELL DONE":P=P+200:EC=1:GOTO ShowFinalScore ' Victory!
 1002 GOSUB ShowLocation:D$="Exits lead North and East":GOSUB ShowPossibleDirections
 1003 GT=1003:LK=1000:N=1030:E=1010:GOTO RoomMovementDispatcher

 1010 A=2:D$="You are in a dark, seedy alley":GOSUB ShowLocationDescription
 1011 GOSUB ShowLocation:D$="Exits lead North, East and West":GOSUB ShowPossibleDirections
 1013 GT=1013:LK=1010:N=1040:E=1020:W=1000:GOTO RoomMovementDispatcher

 1020 A=3:D$="A long road stretches ahead of you":GOSUB ShowLocationDescription
 1021 GOSUB ShowLocation:D$="Exits lead North and West":GOSUB ShowPossibleDirections
 1023 GT=1023:LK=1020:N=1050:W=1010:GOTO RoomMovementDispatcher

 1030 A=4:D$="You are in a dark, damp tunnel":GOSUB ShowLocationDescription
 1031 GOSUB ShowLocation:D$="Exits lead North and South":GOSUB ShowPossibleDirections
 1033 GT=1033:LK=1030:N=1080:S=1000:GOTO RoomMovementDispatcher

 1040 A=5:D$="You are on the main street":GOSUB ShowLocationDescription
 1041 GOSUB ShowLocation:D$="Exits lead North, South and East":GOSUB ShowPossibleDirections
 1043 GT=1043:LK=1040:N=1090:S=1010:E=1050:GOTO RoomMovementDispatcher

 1050 A=6:D$="You are on a narrow path":GOSUB ShowLocationDescription
 1051 GOSUB ShowLocation:D$="Exits lead North, South, East and West":GOSUB ShowPossibleDirections
 1053 GT=1053=LK=1050:N=1100:S=1020:E=1060:W=1040:GOTO RoomMovementDispatcher

 1060 A=7:D$="You have fallen into a deep pit":GOSUB ShowLocationDescription
 1061 GOSUB ShowLocation:D$="There seems to be no way out":GOSUB ShowPossibleDirections
 1063 GT=1063:LK=1060:GOSUB WhatAreYouGoingToDoNow
 1065 IFOP=1THENOP=0:GOTO1050
 1069 GOTOGT

 1070 A=8:D$="You are near to an old-fashioned well":GOSUB ShowLocationDescription
 1071 GOSUB ShowLocation:D$="Exit to the East only":GOSUB ShowPossibleDirections
 1073 GT=1073:LK=1070:E=1080:GOTO RoomMovementDispatcher

 1080 A=9:D$="You are in a wooded avenue":GOSUB ShowLocationDescription
 1081 GOSUB ShowLocation:D$="Exits lead North, South, East and West":GOSUB ShowPossibleDirections
 1083 GT=1083:LK=1080:N=11110:S=1030:E=1090:W=1070:GOTO RoomMovementDispatcher

 1090 A=10:D$="You are on a wide gravel drive":GOSUB ShowLocationDescription
 1091 GOSUB ShowLocation:D$="Exits lead North, South, East and West":GOSUB ShowPossibleDirections
 1093 GT=1093:LK=1090:N=1120:S=1040:E=1100:W=1080:GOTO RoomMovementDispatcher

 1100 A=11:D$="You are in an open area of tarmac":GOSUB ShowLocationDescription
 1101 GOSUB ShowLocation:D$="Exits lead North, South and West":GOSUB ShowPossibleDirections
 1103 GT=1103:LK=1100:N=1130:S=1050:W=1090:GOTO RoomMovementDispatcher

 1110 A=12:D$="You are in a relaxing zen garden":GOSUB ShowLocationDescription
 1111 GOSUB ShowLocation:D$="Exits lead North and South":GOSUB ShowPossibleDirections
 1113 GT=1113:LK=1110:N=1140:S=1080:GOTO RoomMovementDispatcher

 1120 A=13:D$="You are on a huge area of lawn":GOSUB ShowLocationDescription
 1121 GOSUB ShowLocation:D$="Exits lead North, South and East":GOSUB ShowPossibleDirections
 1123 GT=1123:LK=1120:N=1200:S=1090:E=1130:GOSUB WhatAreYouGoingToDoNow
 1124 IF(LEFT$(A$,1)="N")AND(LD<=0)THENPRINT"The ladder does not fit":GOTO1123
 1126 GOTOGT

 1130 A=14:D$="You are in a small greenhouse":GOSUB ShowLocationDescription
 1131 GOSUB ShowLocation:D$="Exits lead North, South and West":GOSUB ShowPossibleDirections
 1133 GT=1133:LK=1130:N=1150:S=1100:W=1120:GOTO RoomMovementDispatcher

 1140 A=15:D$="You are on a lawn tennis court":GOSUB ShowLocationDescription
 1141 GOSUB ShowLocation:D$="Exits lead North and South":GOSUB ShowPossibleDirections
 1143 GT=1143:LK=1140:N=1160:S=1110:GOTO RoomMovementDispatcher

 1150 A=16:D$="You are in a vegetable plot":GOSUB ShowLocationDescription
 1151 GOSUB ShowLocation:D$="Exits lead North snd South":GOSUB ShowPossibleDirections
 1153 GT=1153:LK=1150:N=1180:S=1130:GOTO RoomMovementDispatcher

 1160 A=17:D$="You are standing by a fish pond":GOSUB ShowLocationDescription
 1161 GOSUB ShowLocation:D$="Exits lead South and East":GOSUB ShowPossibleDirections
 1163 GT=1163:LK=1160:S=1140:E=1170:GOTO RoomMovementDispatcher

 1170 A=18:D$="You are on a tiled patio":GOSUB ShowLocationDescription:PRINT"Above is a barred window" 
 1171 GOSUB ShowLocation:D$="Exits lead South, East and West":GOSUB ShowPossibleDirections
 1173 GT=1173:LK=1170:S=1280:E=1180:W=1160:GOSUB WhatAreYouGoingToDoNow
 1175 IF(LEFT$(A$,1)="S")AND(LD<=0)THENPRINT"The ladder does not fit":GOTO1173
 1179 GOTOGT

 1180 A=19:D$="You are in an apple orchard":GOSUB ShowLocationDescription
 1181 GOSUB ShowLocation:D$="Exits lead South and West":GOSUB ShowPossibleDirections
 1183 GT=1183:LK=1180:S=1150:W=1170:GOTO RoomMovementDispatcher

 1190 A=23:D$="You are in the lounge":GOSUB ShowLocationDescription
 1191 GOSUB ShowLocation:D$="Exits lead North and East":GOSUB ShowPossibleDirections
 1193 GT=1193:LK=1190:N=1230:E=1200:GOTO RoomMovementDispatcher

 1200 A=24:D$="You are in an imposing entrance hall":GOSUB ShowLocationDescription
 1201 GOSUB ShowLocation:IFAV=1THEN DogAttack
 1202 D$="Exits lead North, South, West and up":GOSUB ShowPossibleDirections
 1203 GT=1203:LK=1200:N=1250:S=1120:U=1240:W=1190:GOTO RoomMovementDispatcher

 1210 A=25:D$="This looks like a library." :GOSUB ShowLocationDescription
 1211 GOSUB ShowLocation:D$="The only exit is West":GOSUB ShowPossibleDirections
 1213 GT=1213:LK=1210:W=1250:GOTO RoomMovementDispatcher

 1230 A=26:D$="A dining room, or so it appears" :GOSUB ShowLocationDescription
 1231 GOSUB ShowLocation:D$="Exits lead North and South":GOSUB ShowPossibleDirections
 1233 GT=1233:LK=1230:N=1270:S=1190:GOTO RoomMovementDispatcher

 1240 A=27:D$="You are on a sweeping staircase":GOSUB ShowLocationDescription
 1241 GOSUB ShowLocation:D$="Choose up or down":GOSUB ShowPossibleDirections
 1243 GT=1243:LK=1240:U=1410:D=1200:GOTO RoomMovementDispatcher

 1250 A=31:D$="You are in a narrow passage":GOSUB ShowLocationDescription
 1251 GOSUB ShowLocation:D$="Exits lead North, South and East":GOSUB ShowPossibleDirections
 1253 GT=1253:LK=1250:N=1280:S=1200:E=1210:GOTO RoomMovementDispatcher

 1260 A=22:D$="You are on some gloomy, narrow steps":GOSUB ShowLocationDescription
 1261 GOSUB ShowLocation:D$="Choose up or down":GOSUB ShowPossibleDirections
 1263 GT=1263:LK=1260:U=1290:D=1300:GOTO RoomMovementDispatcher

 1270 A=28:D$="This looks like a games room":GOSUB ShowLocationDescription
 1271 GOSUB ShowLocation:D$="Exits lead South and East":GOSUB ShowPossibleDirections
 1273 GT=1273:LK=1270:S=1230:E=1280:GOTO RoomMovementDispatcher

 1280 A=29:D$="You find yourself in a sun-lounge":GOSUB ShowLocationDescription
 1281 GOSUB ShowLocation:D$="Exits lead North, South, East and West":GOSUB ShowPossibleDirections
 1283 GT=1283:LK=1280:N=1170:S=1250:E=1290:W=1270:GOTO RoomMovementDispatcher

 1290 A=30:D$="This is obviously the kitchen":GOSUB ShowLocationDescription
 1291 GOSUB ShowLocation:D$="Exits lead West and down":GOSUB ShowPossibleDirections
 1293 GT=1293:LK=1290:D=1260:W=1280:GOTO RoomMovementDispatcher

 1300 A=21:D$="This is a cold, damp cellar":GOSUB ShowLocationDescription
 1301 GOSUB ShowLocation:D$="Exits lead South and up":GOSUB ShowPossibleDirections
 1303 GT=1303:LK=1300:S=1310:U=1260:GOTO RoomMovementDispatcher

 1310 A=20:D$="This room is even darker than the last":GOSUB ShowLocationDescription
 1311 GOSUB ShowLocation:D$="The only way out is North":GOSUB ShowPossibleDirections
 1313 GT=1313:LK=1310:N=1300:GOTO RoomMovementDispatcher

 1320 A=32:D$="This seems to be a guest bedroom":GOSUB ShowLocationDescription
 1321 GOSUB ShowLocation:D$="The only exit it North":GOSUB ShowPossibleDirections
 1323 GT=1323:LK=1320:N=1400:GOTO RoomMovementDispatcher

 1330 A=33:D$="This is a child's bedroom":GOSUB ShowLocationDescription
 1331 GOSUB ShowLocation:D$="Exit to the North only":GOSUB ShowPossibleDirections
 1333 GT=1333:LK=1330:N=1360:GOTO RoomMovementDispatcher

 1340 A=34:D$="This must be the master bedroom":GOSUB ShowLocationDescription
 1341 GOSUB ShowLocation:D$="Exits lead North and West":GOSUB ShowPossibleDirections
 1343 GT=1343:LK=1340:N=1370:W=1360:GOTO RoomMovementDispatcher
 
 1350 A=35:D$="You are in a tiled shower-room":GOSUB ShowLocationDescription
 1351 GOSUB ShowLocation:D$="Exit to the North only":GOSUB ShowPossibleDirections
 1353 GT=1353:LK=1350:N=1380:GOTO RoomMovementDispatcher

 1360 A=37:D$="You have found the east gallery":GOSUB ShowLocationDescription
 1361 GOSUB ShowLocation:D$="Exits North, South, East and West":GOSUB ShowPossibleDirections
 1363 GT=1363:LK=1360:N=1390:S=1330:E=1340:W=1410:GOTO RoomMovementDispatcher
 
 1370 A=36:D$="This is a tiny toilet":GOSUB ShowLocationDescription
 1371 GOSUB ShowLocation:D$="Exit to the South only":GOSUB ShowPossibleDirections
 1373 GT=1373:LK=1370:S=1340:GOTO RoomMovementDispatcher

 1380 A=38:D$="This is a small box-room":GOSUB ShowLocationDescription
 1381 GOSUB ShowLocation:D$="Exits to the South and East":GOSUB ShowPossibleDirections
 1383 GT=1383:LK=1380:S=1350:E=1400:GOTO RoomMovementDispatcher
 
 1390 A=40:D$="You are in an ornate bathroom":GOSUB ShowLocationDescription
 1391 GOSUB ShowLocation:D$="Exit to the South only":GOSUB ShowPossibleDirections
 1393 GT=1393:LK=1390:S=1360:GOTO RoomMovementDispatcher

 1400 A=41:D$="This is the west gallery":GOSUB ShowLocationDescription
 1401 GOSUB ShowLocation:D$="Exits lead North, South, East and West":GOSUB ShowPossibleDirections
 1403 GT=1403:LK=1400:N=1420:S=1320:E=1410:W=1380:GOTO RoomMovementDispatcher
 
 1410 A=42:D$="You are on the main landing":GOSUB ShowLocationDescription
 1411 GOSUB ShowLocation:D$="Exits lead East, West and down":GOSUB ShowPossibleDirections
 1413 GT=1413:LK=1410:W=1400:E=1360:D=1240:GOTO RoomMovementDispatcher
 
 1420 A=39:D$="You see a padlocked steel-plated door":GOSUB ShowLocationDescription
 1421 GOSUB ShowLocation:D$="You can return to the South":GOSUB ShowPossibleDirections
 1423 GT=1423:LK=1420:S=1400:GOTO RoomMovementDispatcher

 ' Location picture loading
LoadPicture: 
 8800 K$=STR$(A)+".BIN"
 8801 IF(A=24)AND(DG=A)THEN K$="24"+STR$(AV)+".BIN"
 8802 IF(A=34)AND(TG=A)THEN K$="34"+STR$(AL)+".BIN"
 8805 SEARCH K$
 8810 IF EF=1 THEN LOAD K$ ELSE LOAD "NONE.BIN"
 8820 RETURN

 ' Show items on the location
ShowLocation: 
 8900 GOSUB LoadPicture
 9000 IT=0:PRINT:PRINT"I can see ";:IFWB=ATHENPRINT"the window is broken"
 9001 IFOS=ATHENPRINT"an open safe":IT=1
 9002 IFPL=ATHENPRINT"a plastic bag":IT=1
 9003 IFBD=ATHENPRINT"black dust":IT=1
 9004 IFPO=ATHENPRINT"an open panel on wall":IT=1
 9005 IFCP=ATHENPRINT"a locked panel on the wall":IT=1
 9006 IFYP=ATHENPRINT"gritty yellow powder":IT=1
 9007 IFBU=ATHENPRINT"a wooden bucket":IT=1
 9008 IFHD=ATHENPRINT"a small hole in the door":IT=1
 9009 IFWA=ATHENPRINT"some water":IT=1
 9010 IFPG=ATHENPRINT"a large dove":IT=1
 9011 IFBX=ATHENPRINT"a cardboard box":IT=1
 9012 IFTW=ATHENPRINT"some twine":IT=1
 9013 IFKN=ATHENPRINT"a silver knife":IT=1
 9014 IFNE=ATHENPRINT"a fishing net":IT=1
 9015 IFLD=ATHENPRINT"a ladder":IT=1:IF A=19 THEN !RESTORE GraphicDataLadder:CL=1:GOSUB DrawVectorItems
 9016 IFCR=ATHENPRINT"an abandoned car":IT=1
 9017 IFBL=ATHENPRINT"three .38 bullets":IT=1
 9018 IFME=ATHENPRINT"a joint of meat":IT=1
 9019 IFBR=ATHENPRINT"some brown bread":IT=1
 9020 IFTN=ATHENPRINT"an empty tobacco tin":IT=1
 9021 IF(DG=A)AND(AV=1)THENPRINT"an alsatian growling at you":IT=1
 9022 IF(DG=A)AND(AV=0)THENPRINT"the body of an alsatian dog":IT=1
 9023 IFTP=ATHENPRINT"a roll of sticky tape":IT=1
 9024 IFBK=ATHENPRINT"a chemistry book":IT=1:IF A=25 THEN !RESTORE GraphicDataLibraryBook:CL=0:GOSUB DrawVectorItems 
 9025 IFMA=ATHENPRINT"a box of matches":IT=1
 9026 IFCU=ATHENPRINT"a snooker cue":IT=1
 9027 IFLP=ATHENPRINT"a loaded pistol":IT=1
 9028 IFSA=ATHENPRINT"a heavy safe":IT=1
 9029 IFNO=ATHENPRINT"a printed note":IT=1
 9030 IFRH=ATHENPRINT"a rope hangs from the window":IT=1:RO=99
 9031 IFGL=ATHENPRINT"a young girl tied up on the floor":IT=1
 9032 IFTT=ATHENPRINT"a roll of toilet tissue":IT=1 
 9033 IF(TG=A)AND(AL=1)THENPRINT"a thug asleep on the bed":IT=1
 9034 IF(TG=A)AND(AL=0)THENPRINT"a thug lying dead on the bed":IT=1
 9036 IFHP=ATHENPRINT"a hose-pipe":IT=1
 9037 IFPT=ATHENPRINT"some petrol":IT=1
 9038 IFBB=ATHENPRINT"broken glass":IT=1
 9039 IFAB=ATHENPRINT"an acid burn":IT=1
 9040 IFSB=ATHENPRINT"a small bottle":IT=1
 9041 IFGF=ATHENPRINT"a young girl":IT=1
 9042 IF(CU=43)AND(HD=39)THENPRINT"a cue on the floor":IT=1
 9043 IFRO=ATHENPRINT"a length of rope":IT=1
 9044 IFFU=ATHENPRINT"a fuse":IT=1
 9045 IFGP=ATHENPRINT"some gunpowder":IT=1
 9046 IFKY=ATHENPRINT"a set of keys":IT=1
 9047 IFPU=ATHENPRINT"a pistol":IT=1
 9048 IFBM=ATHENPRINT"a bomb":IT=1
 9098 IFIT=0THENPRINT"nothing of interest here"
 9099 PRINT:RETURN

 ' Dog attack
DogAttack: 
 9100 GOSUB WhatAreYouGoingToDoNow
 9101 IF(AV=1)AND(DG<=0)THENPRINT:PRINT"AAAAAARRRGGGHHHH - he got you":KD=1:GOTO PlayerFailed
 9102 PRINT:GOTO1202

 ' Room movement dispatcher
RoomMovementDispatcher: 
 9900 GOSUB WhatAreYouGoingToDoNow:GOTOGT

 ' Ask the player for input
WhatAreYouGoingToDoNow: 
 10000 GOSUB VictoryFailureCheck
 10002 D$="What are you going to do now ?"
 10003 IFAR=1THENPLOT 20,26,1:PLOT 21,26,"Alarm"+STR$(20-TM)+CHR$(27)+"C"
 10004 PLOT 29,26,3:PLOT 30,26,"Moves "+STR$(501-NM)
 10005 AA$="":BB$="":A$="":B$="":GOSUB AskPlayer
 10007 XX=10
 10008 L=LEN(Q$)
 10009 FORJ=1TOL
 10010 IFMID$(Q$,J,1)=" "THENXX=J+1
 10012 NEXT
 10014 BB$=MID$(Q$,XX,L):AA$=LEFT$(Q$,XX-2)
 10015 B$=LEFT$(BB$,3):A$=LEFT$(AA$,3)
 10050 IFA$="GET"THEN ActionGet
 10053 IFA$="DRO"THEN ActionDrop
 10054 IFA$="THR"THEN ActionThrow
 10055 IFA$="KIL"THEN ActionKill
 10056 IFA$="OPE"THEN ActionOpen
 10057 IFA$="CLI"THEN ActionClimb
 10058 IFA$="FRI"THEN ActionFrisk
 10059 IFA$="MAK"THEN ActionMake
 10060 IF(A$="SYP")OR(A$="SIP")THEN ActionSyphon
 10061 IFA$="LOA"THEN ActionLoad
 10062 IF(A$="BLO")OR(A$="EXP")THEN ActionBlow
 10063 IFA$="USE"THEN ActionUse
 10064 IF(A$="STA")AND(A=11)THENPRINT:PRINT"How ?":GOTO10002
 10065 IFA$="REA"THEN ActionRead
 10066 IFA$="QUI"THEN ActionQuit
 10067 IFA$="SHO"THEN ActionShoot
 10068 IFA$="PRE"THEN ActionPress
 10090 IFL>1THEN10995
 10100 IFA$="L"THEN GT=LK:RETURN
 10101 IF(A$="N")AND(N<>0)THENGT=N:GOTO15000
 10102 IF(A$="S")AND(S<>0)THENGT=S:GOTO15000
 10103 IF(A$="E")AND(E<>0)THENGT=E:GOTO15000
 10104 IF(A$="W")AND(W<>0)THENGT=W:GOTO15000
 10105 IF(A$="U")AND(U<>0)THENGT=U:GOTO15000
 10106 IF(A$="D")AND(D<>0)THENGT=D:GOTO15000
 10107 IFA$="I"THEN DisplayInventory
 10990 IFL=1THEN10 ' Sorry can't do that
 10995 PRINT:PRINT"I don't know how to ";AA$;" something":GOTO WhatAreYouGoingToDoNow

 ' Get
ActionGet: 
 11000 IFIC>=7THEN17 ' You will have to DROP something
 ' Elements that require a container
 11001 IF(B$="DUS")AND(BD=A)THEN13000
 11002 IF(B$="POW")AND(YP=A)THEN13000
 11003 IF(B$="WAT")AND(WA=A)THEN13000
 11004 IF(B$="DOV")AND(PG=A)THEN13000
 11005 IF(B$="GUN")AND(GP=A)THEN13000         
 11006 IF(B$="PET")AND(PT=A)THEN13000
 ' Items that can just be put in the inventory directly
 11007 IF(B$="BAG")AND(PL=A)THENPL=0:GOTO15000
 11008 IF(B$="KEY")AND(KY=A)THENKY=0:GOTO15000
 11009 IF(B$="BUC")AND(BU=A)THENBU=0:GOTO15000  
 11010 IF(B$="ROP")AND(RO=A)THENRO=0:GOTO15000
 11016 IF(B$="BOX")AND(BX=A)THENBX=0:GOTO15000
 11018 IF(B$="TWI")AND(TW=A)THENTW=0:GOTO15000 
 11020 IF(B$="KNI")AND(KN=A)THENKN=0:GOTO15000
 11022 IF(B$="NET")AND(NE=A)THENNE=0:GOTO15000
 11024 IF(B$="LAD")AND(LD=A)THENLD=0:GOTO15000
 11026 IF(B$="HOS")AND(HP=A)THENHP=0:GOTO15000 
 11030 IF(B$="PIS")AND(PU=A)THENPU=0:GOTO15000
 11032 IF(B$="BUL")AND(BL=A)THENBL=0:GOTO15000
 11034 IF(B$="MEA")AND(ME=A)THENME=0:GOTO15000
 11038 IF(B$="NOT")AND(NO=A)THENNO=0:GOTO15000
 11040 IF(B$="MAT")AND(MA=A)THENMA=0:GOTO15000
 11044 IF(B$="CUE")AND(CU=A)THENCU=0:GOTO15000
 11046 IF(B$="BOO")AND(BK=A)THENBK=0:GOTO15000 
 11048 IF(B$="BRE")AND(BR=A)THENBR=0:GOTO15000
 11052 IF(B$="TAP")AND(TP=A)THENTP=0:GOTO15000
 11060 IF(B$="TIS")AND(TT=A)THENTT=0:GOTO15000
 11064 IF(B$="GIR")AND(GF=A)THENGL=0:GOTO15000
 11066 IF(B$="BOT")AND(SB=A)THENSB=0:GOTO15000
 11068 IF(B$="TIN")AND(TN=A)THENTN=0:GOTO15000
 11080 IF(B$="GLA")AND(BB=A)THENBB=0:GOTO15000
 11082 IF(B$="FUS")AND(FU=A)THENFU=0:GOTO15000 
 11087 IF(B$="BOM")AND(BM=A)THENBM=0:GOTO15000
 11074 IF(B$="THU")AND(TG=A)AND(AL=O)THENPRINT:PRINT"He's too heavy":GOTO WhatAreYouGoingToDoNow
 11075 IF(B$="THU")AND(TG=A)AND(AL=1)THENPRINT:PRINT"Not a good idea":GOTO WhatAreYouGoingToDoNow
 11077 IF(B$="DOG")AND(DG=A)AND(AV=0)THENDG=0:GOSUB LoadPicture:GOTO15000
 11078 IF(B$="DOG")AND(DG=A)AND(AV=1)THENPRINT:PRINT"Not a good idea":GOTO WhatAreYouGoingToDoNow
 11079 IF(B$="LIG")AND(A=20)AND(PO=A)THENPRINT:PRINT"Bulb's too hot":GOTO WhatAreYouGoingToDoNow
 11070 IF(B$="SAF")AND(SA=A)THEN20
 11072 IF(B$="CAR")AND(CR=A)THEN20
 11073 IF(B$="BED")AND((A=32)OR(A=33)OR(A=34))THEN20
 11071 IF(B$="GRE")AND(A=14)THENPRINT:PRINT"Don't be daft":GOTO WhatAreYouGoingToDoNow
 11084 IF(B$="BUT")AND(A=20)THENPRINT:PRINT"Try pressing it":GOTO WhatAreYouGoingToDoNow
 11085 IF(B$="WIN")AND(A=18)THENPRINT:PRINT"It's a bit too high":GOTO WhatAreYouGoingToDoNow
 11086 IF(B$="PAN")AND(A=20)THENPRINT:PRINT"It's fixed to the wall"GOTO15000
 11057 IFQ$="BAG"THENPRINT:PRINT"Sorry, it will suffocate":GOTO WhatAreYouGoingToDoNow
 11088 PRINT:PRINT"I can't see ";BB$;" anywhere":GOTO WhatAreYouGoingToDoNow

 ' Drop
ActionDrop: 
 11100 IF(B$="BAG")AND(PL<=0)THENPL=A:GOTO13700
 11102 IF(B$="DUS")AND(BD<=0)THEN13530
 11104 IF(B$="KEY")AND(KY<=0)THENKY=A:GOTO13700
 11106 IF(B$="POW")AND(YP<=0)THEN13520
 11108 IF(B$="BUC")AND(BU<=0)THENBU=A:GOTO13710
 11110 IF(B$="ROP")AND(RO<=0)THENRO=A:GOTO15000
 11112 IF(B$="WAT")AND(WA<=0)THENPRINT:PRINT"The water drains away":GOTO13500
 11114 IF(B$="DOV")AND(PG<=0)THEN13510
 11118 IF(B$="TWI")AND(TW<=0)THENTW=A:GOTO15000 
 11120 IF(B$="KNI")AND(KN<=0)THENKN=A:GOTO15000
 11122 IF(B$="NET")AND(NE<=0)THENNE=A:GOTO15000
 11124 IF(B$="LAD")AND(LD<=0)THENLD=A:GOTO15000
 11125 IF(B$="PIS")AND(LP<=0)THENLP=A:GOTO15000
 11126 IF(B$="PIS")AND(PU<=0)THENPU=A:GOTO15000
 11130 IF(B$="BUL")AND(BL<=0)THENBL=A:GOTO15000 
 11132 IF(B$="MEA")AND(ME<=0)THENME=A:GOTO15000
 11134 IF(B$="NOT")AND(NO<=0)THENNO=A:GOTO15000
 11136 IF(B$="MAT")AND(MA<=0)THENMA=A:GOTO15000
 11138 IF(B$="CUE")AND(CU<=0)THENCU=A:GOTO15000
 11140 IF(B$="BOO")AND(BK<=0)THENBK=A:GOTO15000
 11142 IF(B$="BRE")AND(BR<=0)THENBR=A:GOTO15000
 11144 IF(B$="TAP")AND(TP<=0)THENTP=A:GOTO15000
 11146 IF(B$="GUN")AND(GP<=0)THENGP=A:GOTO13540
 11148 IF(B$="TIS")AND(TT<=0)THENTT=A:GOTO15000
 11150 IF(B$="PET")AND(PT<=0)THENPRINT:PRINT"The petrol evaporates":GOTO13550
 11152 IF(B$="HOS")AND(HP<=0)THENHP=A:GOTO15000
 11154 IF(B$="GIR")AND(GL<=0)THENGL=A:GOTO15000
 11156 IF(B$="BOX")AND(BX<=0)THENBX=A:GOTO13720
 11158 IF(B$="DOG")AND(DG<=0)THENDG=A:GOTO15000
 11160 IF(B$="TIN")AND(TN<=0)THENTN=A:GOTO13740
 11162 IF(B$="BOT")AND(SB<=0)THENAB=A:BB=A:SB=99:GOTO28 ' *CRASH*TINKLE* There is a funny smell
 11164 IF(B$="FUS")AND(FU<=0)THENFU=A:GOTO1OOOO
 11165 PRINT:PRINT"Don't have ";BB$;" - check inventory":GOTO WhatAreYouGoingToDoNow

 ' Throw
ActionThrow: 
 11200 IF(B$="MEA")AND(ME<=0)THEN11210
 11201 IF(B$="BRE")AND(BR<=0)THEN11220
 11202 IF(B$="CUE")AND(CU<=0)THEN11230
 11203 IF(B$="BOT")AND(SB<=0)THEN11240
 11204 IF(B$="KNI")AND(KN<=0)THEN11250
 11205 IF(B$="ROP")AND(RO<=0)THEN11260
 11206 IF(B$="GLA")AND(BB<=0)THEN PRINT:PRINT"The fragments are too small to throw":GOTO WhatAreYouGoingToDoNow
 11208 PRINT:PRINT"Use the DROP command":GOTO WhatAreYouGoingToDoNow

 ' Throw meat
 11210 IF(DG=A)AND(AV=1)THENPRINT:PRINT"Dog eats meat":ME=99:DB=99:P=P+25:GOTO15000
 11211 ME=A:GOTO15000

 ' Throw bread
 11220 IFPG=ATHENPRINT:PRINT"Dove eats the bread":BR=99:GOTO15000
 11221 IF(DG=A)AND(AV=1)THENPRINT:PRINT"Dog sniffs bread - he is not happy"         
 11222 BR=A:GOTO15000

 ' Throw cue
 11230 IFDG=ATHENPRINT:PRINT"You have speared the dog":CU=A:AV=0:P=P+50:GOTO15000
 11231 IF(A=18)AND(WB=18)THEN11233
 11232 IF A=18THENPOKE#26B,16+1:PRINT:PRINT"The cue smashes the window":CU=39:WB=18:AR=1:GOTO14999
 11233 CU=A:GOTO15000

 ' Throw bottle
 11240 IFA<>39THEN28 ' *CRASH*TINKLE* There is a funny smell
 11241 PRINT:PRINT"Acid in the bottle burns small hole in the door":P=P+200
 11242 SB=99:GL=39:HD=39:BB=39:GOTO15000

 ' Throw knife
 11250 IFDG=ATHENPRINT:PRINT"You have killed the dog":P=P+50:KN=A:AV=0:GOSUB LoadPicture:GOTO15000
 11251 IF(GL=A)AND(HD=A)THENPRINT:PRINT"Girl cuts her bonds":KN=A:GL=99:GF=A
 11255 KN=A:IC=IC-1
 11256 IFRO=39THEN11264
 11259 IC=IC+1:GOTO15000

 ' Throw rope
 11260 IF(A<>39)AND(HD<>39)THENRIO=A:GOTO15000
 11262 IFGF<>39THENRO=A:GOTO15000
 11264 IFWB=0THENPRINT:PRINT"Girl breaks window and slides down rope"
 11265 IFWB=0THENPRINT:PRINT"Alarm starts ringing":WB=18:PLAY3,2,4,1:GOTO11270
 11266 IFWB=8THENPRINT:PRINT"Girl climbs out of window and down rope":GOTO WhatAreYouGoingToDoNow
 11268 RO=39:GOTO15000

 11270 GF=18:RH=18:RO=18:IC=IC-1:AR=1:P=P+100:GOTO WhatAreYouGoingToDoNow

 11275 GF=18:RH=18:RO=18:IC=IC-1:P=P+100:GOTO WhatAreYouGoingToDoNow

 ' Open
ActionOpen: 
 11300 IF(B$="DOO")AND(A=39)THEN21 ' It's locked
 11302 IF(B$="WIN")AND(A=18)THENPRINT:PRINT"It's thirty feet up":GOTO WhatAreYouGoingToDoNow
 11303 IF(B$="BOT")AND(SB<=0)THENPRINT:PRINT"The screw cap is stuck":GOTO WhatAreYouGoingToDoNow
 11304 IF(B$="CAR")AND(A=11)THENPRINT:PRINT"Nothing. Try the trunk":GOTO WhatAreYouGoingToDoNow
 11305 IF(B$="TRU")AND(A=11)THENPRINT:PRINT"Nothing here, either":GOTO WhatAreYouGoingToDoNow
 11306 IF(B$="TIN")AND(TF=0)AND(TN<=0)THENPRINT:PRINT"Nothing inside":GOSUB WhatAreYouGoingToDoNow
 11307 IF(B$="TIN")AND(TF=1)AND(TN<=0)THENPRINT:PRINT"Okay, it's open":GOSUB WhatAreYouGoingToDoNow
 11308 IF(B$="TAN")AND(A=11)AND(PA=1)THENPRINT:PRINT"It's already open":GOSUB WhatAreYouGoingToDoNow 
 11309 IF(B$="TAN")AND(A=11)THENPA=1:PRINT:PRINT"Okay, it's open":GOTO WhatAreYouGoingToDoNow
 11302 IF(B$="SAF")AND(A=21)AND(OS=99)THEN21 ' It's locked
 11304 IF(B$="SAF")AND(A=21)AND(OS=21)THEN22 ' It is open
 11311 IF(B$="PAN")AND(A=20)AND(PO=20)THEN22 ' It is open
 11312 IF(B$="PAN")AND(A=20)THEN21 ' It's locked
 11313 IF(B$="BOX")AND(XF=0)AND(BX<=0)THENPRINT:PRINT"Nothing inside":GOTO WhatAreYouGoingToDoNow
 11314 IF(B$="BOX")AND(XF=1)AND(BX<=0)THEN22 ' It is open
 11315 GOTO11 ' Eh??

 ' Climb
ActionClimb: 
 11320 IF(B$="WAL")AND(A=18)THEN23 ' It's too steep
 11321 IF(B$="WAL")AND(A=7)THEN23 ' It's too steep
 11322 IF(B$="LAD")AND(AD>0)THENPRINT:PRINT"You have no ladder":GOTO WhatAreYouGoingToDoNow
 11323 IF(B$="LAD")AND(A=18)THENPRINT:PRINT"Ladder is too short":GOTO WhatAreYouGoingToDoNow
 11324 IF(B$="LAD")AND(A=7)THENPRINT:PRINT"You are out":LD=7:IC=IC-1:OP=1
 11325 IFOP=1THENA=6:RETURN
 11326 GOTO10 ' Sorry can't do that

 ' Frisk
ActionFrisk: 
 11340 IF(B$="GIR")AND(GL<=0)THENPRINT:PRINT"Shame on you":GOTO WhatAreYouGoingToDoNow
 11341 IFB$="THU"THEN11343
 11342 PRINT:PRINT"I don't understand":GOTO WhatAreYouGoingToDoNow
 11343 IFFK=1THENPRINT:PRINT"You've already frisked him":GOTO WhatAreYouGoingToDoNow
 11344 IFAL=1THENPRINT:PRINT"I should subdue him first":GOTO WhatAreYouGoingToDoNow
 11345 PRINT"I've found a pistol.It is not loaded":PU=A:FK=1:P=P+50:GOTO WhatAreYouGoingToDoNow
 
 ' Kill
ActionKill: 
 11350 IF(B$="DOG")AND(A=24)AND(AV=1)THEN24 ' Good idea
 11352 IF(B$="GIR")AND(GL<=0)THEN26 ' No, I don't think so
 11354 IF(B$="DOV")AND(PG<=0)THEN25 ' No needless violence
 11356 IF(B$="THU")AND(A=34)AND(AL=1)THENPRINT:PRINT"I'm game. How":GOTO11360
 11358 GOTO11 ' Eh??

 ' Attempt at killing thug
 11360 PRINT:INPUTRR$:R$=LEFT$(RR$,3)
 11361 PRINT:PRINT"With what ?":PRINT:INPUTSS$:S$=LEFT$(SS$,3)
 11362 IFR$="STR"THEN11370
 11364 IFR$="STA"THEN11380
 11366 IFR$="HIT"THEN11390
 11368 IFR$="SUF"THEN11395 
 11369 GOTO12 ' Come again ?

 ' Strangle thug
 11370 IF(S$<>"TWI") THEN ELSE IF (TW<=0)THENPRINT:PRINT"CROAK":TW=A:IC=IC-1:GOTO11407 ELSE 27 ' You don't have any
 11372 IF(S$<>"ROP") THEN ELSE IF (RO<=0)THENPRINT:PRINT"CROAK":RO=A:IC=IC-1:GOTO11407 ELSE 27 ' You don't have any
 11374 IF(S$<>"HOS") THEN ELSE IF (HP<=0)THENPRINT:PRINT"CROAK":HP=A:IC=IC-1:GOTO11407 ELSE 27 ' You don't have any
 11376 GOTO12 ' Come again ?

 ' Stab thug
 11380 IF(S$<>"KNI") THEN ELSE IF (KN<=0)THENPRINT:PRINT"Messy":KN=A:IC=IC-1:GOTO11407 ELSE 27 ' You don't have any
 11382 GOTO12 ' Come again ?

 ' Hit thug
 11390 IF(S$<>"CUE") THEN ELSE IF (CU<=0)THENPRINT:PRINT"KRUNCH":CU=A:IC=IC+:GOTO11407 ELSE 27 ' You don't have any
 11392 PRINT:PRINT"You managed to wake him - he's not happy- he approaches.......":LOAD"342.BIN"
 11393 FORT=1TO500:NEXT:PRINT"**BANG**   you are dead":SHOOT:KT=1:GOTO PlayerFailed 

 ' Suffocate thug
 11395 IF(S$="BAG")AND(PL<=0)THEN11398
 11396 IF(S$="BAG")AND(PL>0)THEN27 ' You don't have any
 11397 PRINT:PRINT"What ???":GOTO WhatAreYouGoingToDoNow

 11398 IFPF=1THENPRINT:PRINT"Your bag is full":GOTO WhatAreYouGoingToDoNow
 11399 PRINT:PRINT"G-A-S-P !!!":AL=0:PL=A:IC=IC-1:P=P+50:GOTO WhatAreYouGoingToDoNow

 ' Make
ActionMake: 
 11400 IFB$="GUN"THEN11410
 11401 IFB$="FUS"THEN11420
 11402 IFB$="BOM"THEN11430
 11403 IFB$="NOI"THENPRINT"I'd keep quiet if I were you":GOTO WhatAreYouGoingToDoNow
 11406 GOTO10 ' Sorry can't do that

 ' Picture of dead thug
 11407 LOAD"340.BIN"
 11408 AL=0:P=P+50:GOTO WhatAreYouGoingToDoNow

 ' Make gunpowder
 11410 IF(YP=0)AND(BD=0)THENPRINT:PRINT"Okay, gunpowder ready":P=P+100:GOTO13600 
 11411 IF(YP<>0)AND(BD<>0)THEN10 ' Sorry, can't do that

 ' Make fuse
 11420 IF(TT=0)AND(PT=0)THENPRINT:PRINT"Okay, fuse ready":P=P+100:GOTO13670
 11421 GOTO10 ' Sorry can't do that

 ' Make bomb
 11430 IF(FU=0)AND(GP=0)AND(TN=0)THENPRINT:PRINT"Bomb ready":FU=99:GP=99:TN=99:BM=A:IC=IC-2:EE=0:P=P+200:GOTO WhatAreYouGoingToDoNow
 11431 GOTO10 ' Sorry can't do that

 ' Syphon petrol with the hose
ActionSyphon: 
 11450 IFB$="PET"THEN11452
 11451 GOTO11 ' Eh??

 11452 IF(PA=0)OR(A<>11)THEN10
 11453 PRINT:PRINT"What shall I use?"
 11454 PRINT:INPUTS$:IFLEFT$(S$,3)="HOS"THEN11456
 11455 GOTO10 ' Sorry can't do that

 11456 IFHP<>0THENPRINT:PRINT"You don't have one":GOTO WhatAreYouGoingToDoNow
 11457 PRINT:PRINT"Okay":PT=A:HP=A:GOTO13000

 ' Load pistol
ActionLoad: 
 11470 IFB$="PIS"THEN11472
 11471 GOTO10 ' Sorry can't do that
 
 11472 IF(PU<>0)OR(BL<>0)THEN10
 11473 IFLP=0THENPRINT:PRINT"It's already loaded":GOTO WhatAreYouGoingToDoNow
 11474 LP=0:PU=99:BL=99:PRINT:PRINT"Okay":IC=IC-1:GOTO WhatAreYouGoingToDoNow

 ' Blow things open
ActionBlow: 
 11500 IF(B$="SAF")AND(OS=21)THENPRINT:PRINT"It's already open":GOTO WhatAreYouGoingToDoNow
 11501 IF(B$="SAF")OR(B$="DOO")THEN11503
 11502 GOTO10 ' Sorry can't do that

 11503 IF(B$="SAF")AND(A<>21)THENPRINT:PRINT"I can't see a safe":GOTO WhatAreYouGoingToDoNow
 11504 IF(B$="DOO")AND(A<>39)THENPRINT:PRINT"I can't see a door":GOTO WhatAreYouGoingToDoNow
 11506 PRINT:PRINT"Using what ?":PRINT:INPUTZZ$:Z$=LEFT$(ZZ$,3) 
 11507 IFZ$="GUN"THEN11510
 11508 IFZ$="BOM"THEN11530
 11509 GOTO11 ' Eh??

 11510 IFGP<>0THENPRINT:PRINT"You don't have any":GOTO WhatAreYouGoingToDoNow
 11512 PRINT:PRINT"Okay, how shall we light it?"
 11514 PRINT:INPUTXX$:X$=LEFT$(XX$,3)
 11516 IF(X$="MAT")AND(MA=0)THENMA=99:GP=99:GOTO11525
 11518 IF(X$="PIS")AND(LP=0)THENLP=99:PI=0:GP=99:GOTO11525
 11520 IF(X$="PIS")AND(PI=0)THENPRINT:PRINT"CLICK  it isn't loaded":GOTO WhatAreYouGoingToDoNow
 11522 GOTO13 ' Let's try again, eh

 11525 PRINT:PRINT"****B*O*O*O*M*M*M****":EXPLODE
 11527 IFX$="MAT"THENPRINT:PRINT"You have been blown to bits":KE=1:GOTO PlayerFailed
 11528 IFX$="PIS"THENPRINT:PRINT"Lots of smoke but unsuccessful":GOTO PlayerFailed
 11530 IFBM<>0THENPRINT:PRINT"You don't have a bomb":GOTO WhatAreYouGoingToDoNow
 11532 PRINT:PRINT"Okay, how shall we light it?"
 11534 PRINT:INPUTXX$:X$=LEFT$(XX$,3)
 11536 IF(X$="MAT")AND(MA=0)THENMA=99:BM=99:GOTO11545
 11538 IF(X$="PIS")AND(LP=0)THENLP=99:PU=0:BM=99:QZ=1
 11539 IFQZ=1THENQZ=0:PRINT:PRINT"*BANG*BANG*BANG*":GOTO11545
 11540 IF(X$="PIS")AND(PU=0)THENPRINT:PRINT"CLICK  it isn't loaded":GOTO WhatAreYouGoingToDoNow
 11542 GOTO13 ' Let's try again, eh

 11545 PRINT:PRINT"****B*O*O*O*M*M*M****":EXPLODE  
 11546 IFB$="DOO"THENPRINT:PRINT"The door is untouched":GOTO WhatAreYouGoingToDoNow
 11547 PRINT:PRINT"The safe is open":SB=A:SA=99:OS=21:P=P+200:GOTO WhatAreYouGoingToDoNow

 ' Use
ActionUse: 
 11550 IFB$="KEY"THEN11552
 11551 GOTO10 ' Sorry can't do that

 11552 IFKY<>0THEN11165
 11553 IF(A=39)OR(A=21)OR(A=11)THEN11556
 11554 IFA=20THEN11560
 11555 PRINT:PRINT"I don't understand":GOTO WhatAreYouGoingToDoNow
 11556 PRINT:PRINT"The keys don't fit":GOTO WhatAreYouGoingToDoNow
 11560 PRINT:PRINT"It's open"
 11562 PRINT:PRINT"I see lots of lights and a red button" 
 11564 KY=20:IC=IC-1:CP=99:PO=20:GOTO WhatAreYouGoingToDoNow

 ' Read
ActionRead: 
 11570 IFB$<>"NOT"THEN11580
 11572 IF (N0<>0) AND (N0<>A) THEN 11165
 11573 PRINT:PRINT"I moved all your dangerous chemical":PRINT"products to the basement's safe - DAD":GOTO WhatAreYouGoingToDoNow

 11580 IFB$<>"BOO"THEN11 ' Eh??
 11582 IF (BK<>0) AND (BK<>A) THEN11165
 11583 PRINT:PRINT"...making fuses... salpeter... explosive... acide and steel... Complicated stuff!":GOTO WhatAreYouGoingToDoNow

 ' Quit
ActionQuit: 
 11600 PRINT:PRINT"Giving up ???? - are you sure ?"
 11602 K$=KEY$:IFK$="Y"THENGU=1:GOTO PlayerFailed
 11604 IFK$="N"THEN15000
 11606 GOTO11602  

 ' Shoot
ActionShoot: 
 11620 IFPU=0THENPRINT:PRINT"CLICK   it isn't loaded":GOTO WhatAreYouGoingToDoNow
 11622 IF(PU<>0)AND(LP<>0)THENPRINT:PRINT"You have no gun":GOTO WhatAreYouGoingToDoNow
 11623 PRINT:PRINT"*BANG*BANG*BANG*":LP=99:PU=0:SHOOT:WAIT25:SHOOT:WAIT25:SHOOT
 11624 IF(A=24)AND(AV=1)THENPRINT:PRINT"The dog is dead":P=P+50:AV=0
 11626 GOTO WhatAreYouGoingToDoNow

 ' Press
ActionPress: 
 11700 IFB$="BUT"THENGOTO11702
 11701 PRINT:PRINT"Press what ?":GOTO WhatAreYouGoingToDoNow
 11702 IF(PO<>20)OR(A<>20)THEN11088
 11704 IFAR=1THENPOKE#26B,16+4:PLOT 21,26,"        ":PRINT:PRINT"Alarm stops ringing":PING:AR=0:P=P+200:GOTO WhatAreYouGoingToDoNow
 11706 PRINT:PRINT"Oh - nothing happened":GOTO WhatAreYouGoingToDoNow

 ' Non called code
 12000 IF(GL=39)OR(GF=39)THENPRINT:PRINT"She cannot get through the hole":GOTO WhatAreYouGoingToDoNow
 12004 GF=0:GOTO15000

 ' Get dust/water/petrol/dove/powder
 13000 D$="Carry it in what?":GOSUB50400:QQ$=Q$:Q$=LEFT$(QQ$,3):IFQ$<>"IN "THEN13004
 13002 XX=10:L=LEN(QQ$):FORJ=1TOL:IFMID$(QQ$,J,1)=" "THENXX=J+1
 13003 NEXT:J$=MID$(QQ$,XX,L):Q$=LEFT$(J$,3)
 13004 IF(Q$="BUC")AND(BU<>0)THEN14 ' You aren't carrying one
 13005 IF(Q$="BOX")AND(BX<>0)THEN14 ' You aren't carrying one
 13006 IF(Q$="BOT")AND(SB<>0)THEN14 ' You aren't carrying one
 13007 IF(Q$="BAG")AND(PL<>0)THEN14 ' You aren't carrying one
 13008 IF(Q$="TIN")AND(TN<>0)THEN14 ' You aren't carrying one
 13009 IF(Q$="NET")AND(NE<>0)THEN14 ' You aren't carrying one
 13010 IF(Q$="BOT")AND(SB=0) THEN18 ' Your bottle is full
 13014 IFB$="GUN"THEN13250
 13015 IFB$="WAT"THEN13020
 13016 IFB$="DOV"THEN13050
 13017 IFB$="POW"THEN13100
 13018 IFB$="DUS"THEN13150
 13019 IFB$="PET"THEN13200

 ' Get water
 13020 IF(Q$="BUC")AND(BF=0)THENWA=0:BF=1:WW=1:GOTO15000
 13021 IF(Q$="BUC")AND(BF=1)THEN19 ' Your bucket is full
 13022 IF(Q$="BAG")AND(PF=0)THENWA=0:PF=1:WW=5:GOTO15000
 13023 IF(Q$="BAG")AND(PF=1)THEN15 ' Sorry that's full 
 13028 IF(Q$="TIN")AND(TF=0)THENWA=0:TF=1:WW=6:GOTO15000
 13029 IF(Q$="TIN")AND(TF=1)THEN15 ' Sorry that's full
 13030 GOTO40 ' Don't be ridiculous (and empties petrol)

 ' Get dove
 13050 IF(Q$="BUC")AND(BF=0)THENPG=0:BF=1:PP=1:GOTO15000
 13051 IF(Q$="BUC")AND(BF=1)THEN15 ' Sorry that's full
 13052 IF(Q$="BOX")AND(XF=0)THENPG=0:XF=1:PP=2:GOTO15000
 13053 IF(Q$="BOX")AND(XF=1)THEN15 ' Sorry that's full
 13054 IF(Q$="NET")AND(NF=0)THENPG=0:NF=1:PP=3:GOTO15000
 13055 IF(Q$="NET")AND(NF=1)THEN15 ' Sorry that's full
 13065 GOTO40 ' Don't be ridiculous (and empties petrol)

 ' Get powder
 13100 IF(Q$="BUC")AND(BF=0)THENYP=0:BF=1:Y=1:GOTO15000
 13101 IF(Q$="BUC")AND(BF=1)THEN15 ' Sorry that's full
 13102 IF(Q$="BOX")AND(XF=0)THENYP=0:XF=1:Y=2:GOTO15000
 13103 IF(Q$="BOX")AND(XF=1)THEN15 ' Sorry that's full
 13108 IF(Q$="BAG")AND(PF=0)THENYP=0:PF=1:Y=5:GOTO15000
 13109 IF(Q$="BAG")AND(PF=1)THEN15 ' Sorry that's full
 13110 IF(Q$="TIN")AND(TF=0)THENYP=0:TF=1:Y=6:GOTO15000
 13111 IF(Q$="TIN")AND(TF=1)THEN15 ' Sorry that's full
 13115 GOTO40 ' Don't be ridiculous (and empties petrol)

 ' Get dust
 13150 IF(Q$="BUC")AND(BF=0)THENBD=0:BF=1:B=1:GOTO15000
 13151 IF(Q$="BUC")AND(BF=1)THEN15 ' Sorry that's full
 13152 IF(Q$="BOX")AND(XF=0)THENBD=0:XF=1:B=2:GOTO15000 
 13153 IF(Q$="BOX")AND(XF=1)THEN15 ' Sorry that's full
 13158 IF(Q$="BAG")AND(PF=0)THENBD=0:PF=1:B=5:GOTO15000
 13159 IF(Q$="BAG")AND(PF=1)THEN15 ' Sorry that's full
 13160 IF(Q$="TIN")AND(TF=0)THENBD=0:TF=1:B=6:GOTO15000
 13161 IF(Q$="TIN")AND(TF=1)THEN15 ' Sorry that's full
 13165 GOTO40 ' Don't be ridiculous (and empties petrol) 

 ' Get petrol
 13200 IF(Q$="BUC")AND(BF=0)THENPT=0:BF=1:G=1:GOTO16 ' Okay
 13201 IF(Q$="BUC")AND(BF=1)THEN15 ' Sorry that's full
 13202 IF(Q$="BAG")AND(PF=0)THENPT=0:PF=1:G=5:GOTO16 ' Okay
 13203 IF(Q$="BAG")AND(PF=1)THEN15 ' Sorry that's full
 13208 IF(Q$="TIN")AND(TF=0)THENPT=0:TF=1:G=6:GOTO16 ' Okay
 13209 IF(Q$="TIN")AND(TF=1)THEN15 ' Sorry that's full
 13210 GOTO40 ' Don't be ridiculous (and empties petrol)

 ' Get gunpowder
 13250 IF(Q$="BUC")AND(BF=0)THENBF=1:EE=1:GP=0:IC=IC+1:GOTO16 ' Okay 
 13251 IF(Q$="BUC")AND(BF=1)THEN15 ' Sorry that's full
 13252 IF(Q$="BAG")AND(PF=0)THENPF=1:EE=5:GP=0:IC=IC+1:GOTO16 ' Okay
 13253 IF(Q$="BAG")AND(PF=1)THEN15 ' Sorry that's full
 13254 IF(Q$="BOX")AND(XF=0)THENXF=1:EE=2:GP=0:IC=IC+1:GOTO16 ' Okay
 13255 IF(Q$="BOX")AND(XF=1)THEN15 ' Sorry that's full
 13258 IF(Q$="TIN")AND(TF=0)THENTF=1:EE=6:GP=0:IC=IC+1:GOTO16 ' Okay 
 13259 IF(Q$="TIN")AND(TF=1)THEN15 ' Sorry that's full
 13260 GOTO40 ' Don't be ridiculous (and empties petrol)

 ' Water evaporates
 13500 IFWW=1THENBF=0:WW=0
 13502 IFWW=5THENPF=0:WW=0
 13503 IFWW=6THENTF=0:WW=0
 13505 WA=99:GOTO15000

 ' Free dove
 13510 IFPP=1THENBF=0:PP=0
 13511 IFPP=2THENXF=0:PP=0
 13512 IFPP=3THENNF=0:PP=0
 13515 PG=A:GOTO15000

 ' Drop yellow powder
 13520 IFY=1THENBF=0:Y=0
 13521 IFY=2THENXF=0:Y=0
 13523 IFY=5THENPF=0:Y=0
 13524 IFY=6THENTF=0:Y=0
 13525 YP=A:GOTO15000

 ' Drop black dust
 13530 IFB=1THENBF=0:B=0
 13531 IFB=2THENXF=0:B=0
 13533 IFB=5THENPF=0:B=0
 13534 IFB=6THENTF=0:B=0
 13535 BD=A:GOTO15000

 ' Drop gunpowder
 13540 IFEE=1THENBF=0:EE=0
 13541 IFEE=2THENXF=0:EE=0
 13542 IFEE=5THENPF=0:EE=0 
 13544 IFEE=6THENTF=0:EE=0
 13545 GP=A:GOTO15000

 ' Petrol evaporates
 13550 IFG=1THENBF=0:G=0
 13553 IFG=5THENPF=0:G=0 
 13554 IFG=6THENTF=0:G=0
 13555 PT=99:GOTO15000

 ' Make gunpowder
 13600 IF(Y=1)OR(B=1)THENBF=0
 13601 IF(Y=2)OR(B=2)THENXF=0
 13602 IF(Y=5)OR(B=5)THENPF=0
 13603 IF(Y=6)OR(B=6)THENTF=0
 13604 YP=99:BD=99:Y=0:B=0:GP=A:IC=IC-2:GOTO WhatAreYouGoingToDoNow

 ' Make bomb ?????? (code is not called anywhere)
 13660 BM=0
 13661 IFEE=1THENBF=0:EE=0
 13662 IFEE=2THENXF=0:EE=0
 13663 IFEE=5THENPF=0:EE=0
 13664 IFEE=6THENTF=0:EE=0 
 13669 GOTO WhatAreYouGoingToDoNow

 ' Make fuse
 13670 IFG=1THENBF=0:G=0
 13671 IFG=5THENPF=0:G=0
 13672 IFG=6THENTF=0:G=0 
 13674 TT=99:PT=99:G=0:FU=A:IC=IC-1:GOTO WhatAreYouGoingToDoNow

 ' Drop bag or key
 13700 IFWW=5THENWA=99:WW=0:GOSUB57 ' Water spills out and drains away
 13701 IFB=5THENBD=A:B=0
 13702 IFY=5THENYP=A:Y=0
 13703 IFG=5THENPT=99:G=0:GOSUB58 ' Petrol spills out and evaporates
 13704 IFEE=5THENGP=A:EE=0
 13705 IFPF=1THENPF=0:IC=IC-1
 13706 GOTO15000

 ' Drop bucket
 13710 IFWW=1THENWA=99:WW=0:GOSUB57 ' Water spills out and drains away
 13711 IFB=1THENBD=A:B=0
 13712 IFY=1THENYP=A:Y=0
 13713 IFG=1THENPT=99:G=0:GOSUB58 ' Petrol spills out and evaporates
 13714 IFEE=1THENGP=A:EE=0
 13715 IFPP=1THENPG=A
 13716 IFBF=1THENBF=0:IC=IC-1
 13717 GOTO15000

 ' Drop box
 13720 IFB=2THENBD=A:B=0
 13721 IFY=2THENYP=A:Y=0
 13722 IFPP=2THENPG=A:PP=0
 13723 IFEE=2THENGP=A:EE=0 
 13724 IFXF=1THENXF=0:IC=IC-1
 13725 GOTO15000

 ' ????
 13730 IFPP=3THENPG=A:PP=0 
 13731 IFNF=1THENNF=0:IC=IC-1
 13732 GOTO15000

 ' Drop tin
 13740 IFWW=6THENWA=99:WW=0:GOSUB57 ' Water spills out and drains away
 13741 IFB=6THENBD=A:B=0
 13742 IFY=6THENYP=A:Y=0
 13743 IFG=6THENPT=99:G=0:GOSUB58 ' Petrol spills out and evaporates
 13744 IFEE=6THENGP=A:EE=0
 13745 IFTF=1THENTF=0:IC=IC-1
 13746 GOTO15000  


 ' Inventory Display
DisplayInventory: 
 14000 IV=0
 14002 IFPL=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A plastic bag       ":IV=IV+1
 14003 IFBD=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some black dust     ":IV=IV+1
 14004 IFKY=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A set of keys       ":IV=IV+1
 14005 IFPU=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A pistol            ":IV=IV+1
 14006 IFYP=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some yellow powder  ":IV=IV+1
 14007 IFBU=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A wooden bucket     ":IV=IV+1
 14008 IFRO=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A length of rope    ":IV=IV+1
 14009 IFWA=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some water          ":IV=IV+1
 14010 IFPG=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A large dove        ":IV=IV+1
 14011 IFBL=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"3 bullets           ":IV=IV+1
 14012 IFKN=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A silver knife      ":IV=IV+1
 14013 IFTW=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some twine          ":IV=IV+1
 14014 IFME=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some meat           ":IV=IV+1
 14015 IFNO=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A printed note      ":IV=IV+1
 14016 IFMA=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A box of matches    ":IV=IV+1
 14017 IFCU=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A snooker cue       ":IV=IV+1
 14018 IFBK=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A large book        ":IV=IV+1
 14019 IFLD=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A ladder            ":IV=IV+1
 14020 IFBR=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some brown bread    ":IV=IV+1
 14021 IFTP=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some sticky tape    ":IV=IV+1
 14022 IFGP=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some gunpowder      ":IV=IV+1
 14023 IFTT=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some toilet tissue  ":IV=IV+1
 14024 IFPT=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some petrol         ":IV=IV+1
 14025 IFHP=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A hose-pipe         ":IV=IV+1
 14026 IFGL=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A girl              ":IV=IV+1
 14027 IFDG=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A dead dog          ":IV=IV+1
 14028 IFBB=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"Some broken glass   ":IV=IV+1
 14029 IFBX=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A cardboard box     ":IV=IV+1
 14030 IFNE=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A fishing net       ":IV=IV+1
 14031 IFSB=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A small bottle      ":IV=IV+1
 14032 IFTN=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A tobacco tin       ":IV=IV+1
 14034 IFBM=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A bomb              ":IV=IV+1
 14035 IFLP=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A loaded pistol     ":IV=IV+1
 14036 IFFU=0THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"A fuse              ":IV=IV+1
 14036 IFIV<7THEN PLOT 1+20*(IV-INT(IV/2)*2),23+INT(IV/2),"                    ":IV=IV+1
 14100 RETURN

 ' Alarm starts
 14999 PRINT:PRINT"Alarm starts ringing"                
 15000 IFA$="GET"THENIC=IC+1:GOSUB DisplayInventory:A$="L"
 15001 IFA$="MAK"THENIC=IC-2:GOSUB DisplayInventory:A$="L"
 15002 IFA$="DRO"THENIC=IC-1:GOSUB DisplayInventory:A$="L"
 15003 IFA$="THR"THENIC=IC-1:GOSUB DisplayInventory:A$="L"
 15005 N=0:S=0:E=0:W=0:U=0:D=0:PRINT:IT=0:RETURN  

 ' Victory/Failure Condition check
VictoryFailureCheck: 
 20000 IF AR=1 AND TM>19 THEN PRINT"You failed to silence the alarm":PRINT"in time and have been captured.":NM=NM*2:EC=5:GOTO ShowFinalScore 
 20002 NM=NM+1:IF NM>499 THEN PRINT"You have made your 500 moves":EC=6:GOTO ShowFinalScore
 20003 IFAR=1THENTM=TM+1
 20004 RETURN

 ' Failure
PlayerFailed: 
 30000 POKE#26B,16+1 
 30002 IFKD=1THENKL$="dog":EC=2:NM=NM*5:LOAD"242.BIN"
 30003 IFKT=1THENKL$="thug":EC=3:NM=NM*4    
 30004 IFKE=1THENKL$="explosion":EC=7:NM=NM*3
 30005 IFGU=1THENPRINT"You were unable to complete your task":EC=9:NM=NM*10
 30006 IF(GU=1)AND(NM<502)THENNM=502
 30007 IFGU=1THEN ShowFinalScore
 30010 CLS:PRINT"You have been killed by the ";KL$:GOTO ShowFinalScore 

 ' Show game score
ShowFinalScore: 
 30020 PRINT"Game score     ";P-NM" points":GOTO HandleHighScore
 
 ' Ladder
GraphicDataLadder: 
 40100 DATA "C",130,88,"D",188,116
 40111 DATA "C",123,89,"D",178,120
 40112 DATA "C",127,91,"D",134,90
 40113 DATA "C",132,94,"D",139,92
 40114 DATA "C",139,98,"D",145,95
 40115 DATA "C",144,101,"D",151,98
 40116 DATA "C",149,104,"D",158,101
 40117 DATA "C",155,107,"D",163,104
 40118 DATA "C",162,111,"D",170,107
 40119 DATA "C",168,114,"D",175,110
 40120 DATA "C",173,117,"D",183,113
 40121 DATA ""

 ' Library Book
GraphicDataLibraryBook: 
 40150 DATA "C",163,95,"D",148,86,"D",148,82,"D",164,80,"D",177,87,"D",177,91,"D",163,95,"D",163,91,"D",148,82,"C",163,91,"D",177,87
 40152 DATA "C",163,93,"D",177,89,"C",158,84,"D",163,83
 40154 DATA ""


 ' MIXED GRAPHIC MODE SETUP
InitializeGraphicMode: 
 50100 HIRES:TEXT:PAPER4:INK3:PRINTCHR$(17)
 50110 POKE #BB80,31         ' Switch to HIRES
 50112 POKE #A000+40*128,26  ' Switch to TEXT
 50140 DOKE #278,48000+19*40 ' Address of second line of the screen
 50145 DOKE #27A,48000+18*40 ' Address of first line of the screen
 50150 DOKE #27C,6*40       ' Number of characters to scroll
 50155 DOKE #27E,6          ' Number of lines of TEXT that can be scrolled
 50156 POKE #BB80+40*16,16:POKE #BB80+40*16+1,6:POKE #BB80+40*17,6    ' CYAN on BLACK
 50160 POKE #BB80+40*22,16:POKE #BB80+40*23,16
 50161 POKE #BB80+40*24,16:POKE #BB80+40*25,16
 50162 POKE #BB80+40*26,16:POKE #BB80+40*27,16
 50180 CLS
 50185 RETURN

 ' Information bar
ShowLocationDescription: 
 50200 PLOT 2,15,"                                      "
 50204 PLOT 1,16,"                                       "
 50205 PLOT 21-LEN(D$)/2,15,D$
 50210 RETURN

 ' Location information
ShowPossibleDirections: 
 50220 PLOT 1,16,"                                       "
 50225 PLOT 21-LEN(D$)/2,16,D$
 50230 RETURN
 
 ' Input box
AskPlayer: 
 50400 PLOT1,16+PEEK(#268),6:PRINTD$:PLOT1,16+PEEK(#268),2:PRINT">";
 50404 Q$=""
 50405 REPEAT
 50410 GET K$
 50430 IF K$=CHR$(127) AND (Q$<>"") THEN PRINT K$;:Q$=LEFT$(Q$,LEN(Q$)-1)
 50440 IF K$=" " OR (K$>="A" AND K$<="Z") THEN Q$=Q$+K$:PRINT K$;
 50450 UNTIL K$=CHR$(13) AND Q$<>""
 50460 PRINT
 50480 RETURN

 ' High Scores check : "Game score     ";P-NM" points"
HandleHighScore:
 50500 LOAD"SCORES",N
 50503 AD=#9C00
 50510 FOR I=1 TO #18
 50515 SC=DEEK(AD)-#8000
 50516 IF SC<P-NM THEN GOTO 50580
 50555 AD=AD+#13
 50560 NEXT
 50570 LOAD"DEMO":END

 50580 MOVE AD,#9DC8,AD+#13     ' Scroll old entries down
 50590 DOKE AD,(P-NM)+#8000     ' Actual score
 50600 POKE AD+2,EC             ' Ending condition
 50610 D$="New highscore! Your name please?":GOSUB AskPlayer
 50620 Q$="                "+Q$:L=LEN(Q$)
 50630 FOR I=1 TO 16:C$=MID$(Q$,L-16+I,1):POKE AD+2+I,ASC(C$):NEXT
 50640 SAVEO"SCORES",A#9C00,E#9DC8
 50650 LOAD"DEMO"

 ' Vector items drawing
DrawVectorItems: 
 50700 POKE #2C0,3   ' HIRES
 50710 REPEAT
 50715 READ C$
 50717 IF C$="C" THEN READ CX,CY:CURSET CX,CY,CL
 50718 IF C$="D" THEN READ DX,DY:DRAW DX-CX,DY-CY,CL:CX=DX:CY=DY
 50720 UNTIL C$=""
 50725 POKE #2C0,2   ' TEXT
 50730 RETURN


