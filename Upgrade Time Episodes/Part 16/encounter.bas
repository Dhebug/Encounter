#labels         ' Enable the usage of labels and automatic numbering
#optimize       ' Remove all comments, white spaces, etc... to make the code more compact

' Define the various container
#define CNTNR_BUCKET 1
#define CNTNR_BOX    2
#define CNTNR_NET    3
#define CNTNR_BAG    5
#define CNTNR_TIN    6

' Define the various locations
#define LOC_MARKETPLACE      1
#define LOC_DARKALLEY        2
#define LOC_ROAD             3
#define LOC_DARKTUNNEL       4
#define LOC_MAINSTREET       5
#define LOC_NARROWPATH       6
#define LOC_INSIDEHOLE       7
#define LOC_WELL             8
#define LOC_WOODEDAVENUE     9
#define LOC_GRAVELDRIVE      10
#define LOC_TARMACAREA       11
#define LOC_ZENGARDEN        12
#define LOC_LAWN             13
#define LOC_GREENHOUSE       14
#define LOC_TENNISCOURT      15
#define LOC_VEGSGARDEN       16
#define LOC_FISHPND          17
#define LOC_TILEDPATIO       18
#define LOC_APPLE_TREES      19
#define LOC_LOUNGE           23
#define LOC_ENTRANCEHALL     24
#define LOC_LIBRARY          25
#define LOC_DININGROOM       26
#define LOC_LARGE_STAIRCASE  27
#define LOC_NARROWPASSAGE     31
#define LOC_NARROWSTAIRCASE   22
#define LOC_GAMESROOM         28
#define LOC_SUNLOUNGE         29
#define LOC_KITCHEN           30
#define LOC_CELLAR            21
#define LOC_DARKCELLARROOM    20
#define LOC_GUESTBEDROOM      32
#define LOC_CHILDBEDROOM      33
#define LOC_MASTERBEDROOM     34
#define LOC_SHOWERROOM        35
#define LOC_EASTGALLERY       37
#define LOC_TINY_WC           36
#define LOC_BOXROOM           38
#define LOC_PADLOCKED_ROOM    39
#define LOC_CLASSY_BATHROOM   40
#define LOC_WESTGALLERY       41
#define LOC_UP_STAIRS         42
#define LOC_GIRLROOM          43
#define LOC_NOWHERE           99

' Define the various ending conditions
 #define EC_SOLVED_THE_CASE       1
 #define EC_MAIMED_BY_A_DOG       2
 #define EC_SHOT_BY_A_THUG        3
 #define EC_FELL_IN_HOLE          4
 #define EC_TRIPPED_THE_ALARM     5
 #define EC_RAN_OUT_OF_TIME       6
 #define EC_BLOWN_UP              7
 #define EC_SIMPLY_VANISHED       8
 #define EC_GAVE_UP               9


GameStart:+1:0          ' Actual game start
 PAPER3:CLS
 GOTO Initializations   ' Jump to game start


 '
 '                    Encounter
 '             (c) 1983 Severn Software
 '
 ' Updated by Mickaël Pointier aka Dbug/Defence-Force.
 ' To build this version, you need at least Bas2Tap 1.3
 '
 ' The game code modifications assumes that we are running
 ' with Sedoric 3 (or higher), so we can use the following
 ' additions:
 '
 ' - INSTR
 ' - MOVE
 '
 ' Basic documentation of the game internals:
 '
 ' Containers:
 ' 0 - None
 ' 1 - Bucket             | BF   CF(CNTNR_BUCKET)
 ' 2 - Box                | XF   CF(CNTNR_BOX)
 ' 3 - Fishing net        | NF   CF(CNTNR_NET)
 ' 4 - 
 ' 5 - Plastic Bag        | PF   CF(CNTNR_BAG)
 ' 6 - Tin                | TF   CF(CNTNR_TIN)

 ' Container variables:
 ' WW - Water              -> WA
 ' Y  - Yellow Powder      -> YP 
 ' B  - Black Dust         -> BD
 ' G  - Petrol             -> PT
 ' EE - Gunpowder          -> GP
 ' PP - Dove               -> PG

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
 '
 ' Misc:
 ' OP = Out of pit
 '

 
ErrorCantDoThat:    ' Generic error message jumping back to the main interpreter
 PRINT:PRINT"Sorry, can't do that":GOTO WhatAreYouGoingToDoNow

ErrorEh:
 PRINT:PRINT"Eh ??":GOTO WhatAreYouGoingToDoNow

ErrorCommeAgain: 
 PRINT:PRINT"Come again ?":GOTO WhatAreYouGoingToDoNow

ErrorLetsTryAgain: 
 PRINT:PRINT"Let's try again, eh":GOTO WhatAreYouGoingToDoNow

ErrorNotCarryingOne:
 PRINT:PRINT"You aren't carrying one":GOTO WhatAreYouGoingToDoNow

ErrorSorryThatsFull:
 PRINT:PRINT"Sorry, that's full":GOTO WhatAreYouGoingToDoNow

ErrorDropSomething:
 PRINT:PRINT"You will have to DROP something":GOTO WhatAreYouGoingToDoNow

ErrorBottleFull:
 PRINT:PRINT"Your bottle is full":GOTO WhatAreYouGoingToDoNow

ErrorBucketFull: 
 PRINT:PRINT"Your bucket is full":GOTO WhatAreYouGoingToDoNow

ErrorWeighsTooMuch:
 PRINT:PRINT"It weighs too much":GOTO WhatAreYouGoingToDoNow

MessageLocked:
 PRINT:PRINT"It's locked":GOTO WhatAreYouGoingToDoNow

MessageOpen: 
 PRINT:PRINT"It is open":GOTO WhatAreYouGoingToDoNow

MessageTooSteep:
 PRINT:PRINT"It's too steep":GOTO WhatAreYouGoingToDoNow

MessageGoodIdea: 
 PRINT:PRINT"Good idea":GOTO WhatAreYouGoingToDoNow

MessageNoViolence: 
 PRINT:PRINT"No needless violence":GOTO WhatAreYouGoingToDoNow

MessageDontThinkSo: 
 PRINT:PRINT"No, I don't think so":GOTO WhatAreYouGoingToDoNow

MessageDontHaveAny: 
 PRINT:PRINT"You don't have any":GOTO WhatAreYouGoingToDoNow

MessageFunnySmell: 
 PRINT:PRINT"*CRASH*TINKLE* There is a funny smell.":GOTO WhatAreYouGoingToDoNow

MessageDontBeRidiculous:
 PRINT:PRINT"Don't be ridiculous":IF PT=A THEN PT=99  ' Empties the petrol...
 GOTO WhatAreYouGoingToDoNow

MessageWaterSpillsOut:
 PRINT:PRINT"The water spills out and drains away":RETURN

MessagePetrolSpillsOut: 
 PRINT:PRINT"The petrol spills out and evaporates":RETURN 


'
' List of all locations
'
LocationMarketPlace: 
 LK=§:A=LOC_MARKETPLACE:D$="You are in a deserted market square":E$="Exits lead North and East":GOSUB ShowLocation
 IF GL<=0THENPRINT"and you have made it - WELL DONE":P=P+200:EC=1:GOTO ShowFinalScore ' Victory! 
 GT=§:N=LocationDarkTunnel:E=LocationDarkAlley:GOTO RoomMovementDispatcher

LocationDarkAlley:
 LK=§:A=LOC_DARKALLEY:D$="You are in a dark, seedy alley":E$="Exits lead North, East and West":GOSUB ShowLocation
 GT=§:N=LocationMainStreet:E=LocationRoad:W=LocationMarketPlace:GOTO RoomMovementDispatcher

LocationRoad:
 LK=§:A=LOC_ROAD:D$="A long road stretches ahead of you":E$="Exits lead North and West":GOSUB ShowLocation
 GT=§:N=LocationNarrowPath:W=LocationDarkAlley:GOTO RoomMovementDispatcher

LocationDarkTunnel:
 LK=§:A=LOC_DARKTUNNEL:D$="You are in a dark, damp tunnel":E$="Exits lead North and South":GOSUB ShowLocation
 GT=§:N=LocationWoodedAvenue:S=LocationMarketPlace:GOTO RoomMovementDispatcher

LocationMainStreet:
 LK=§:A=LOC_MAINSTREET:D$="You are on the main street":E$="Exits lead North, South and East":GOSUB ShowLocation
 GT=§:N=LocationGravelDrive:S=LocationDarkAlley:E=LocationNarrowPath:GOTO RoomMovementDispatcher

LocationNarrowPath:
 LK=§:A=LOC_NARROWPATH:D$="You are on a narrow path":E$="Exits lead North, South, East and West":GOSUB ShowLocation
 GT=§:N=LocationTarmacArea:S=LocationRoad:E=LocationInsidePit:W=LocationMainStreet:GOTO RoomMovementDispatcher

LocationInsidePit:
 LK=§:A=LOC_INSIDEHOLE:D$="You have fallen into a deep pit":E$="There seems to be no way out":GOSUB ShowLocation
 GT=§:GOSUB WhatAreYouGoingToDoNow
 IFOP=1THENOP=0:GOTO LocationNarrowPath
 GOTOGT

LocationWell:
 LK=§:A=LOC_WELL:D$="You are near to an old-fashioned well":E$="Exit to the East only":GOSUB ShowLocation
 GT=§:E=LocationWoodedAvenue:GOTO RoomMovementDispatcher

LocationWoodedAvenue:
 LK=§:A=LOC_WOODEDAVENUE:D$="You are in a wooded avenue":E$="Exits lead North, South, East and West":GOSUB ShowLocation
 GT=§:N=LocationZenGarden:S=LocationDarkTunnel:E=LocationGravelDrive:W=LocationWell:GOTO RoomMovementDispatcher

LocationGravelDrive:
 LK=§:A=LOC_GRAVELDRIVE:D$="You are on a wide gravel drive":E$="Exits lead North, South, East and West":GOSUB ShowLocation
 GT=§:N=LocationFrontLawn:S=LocationMainStreet:E=LocationTarmacArea:W=LocationWoodedAvenue:GOTO RoomMovementDispatcher

LocationTarmacArea:
 LK=§:A=LOC_TARMACAREA:D$="You are in an open area of tarmac":E$="Exits lead North, South and West":GOSUB ShowLocation
 GT=§:N=LocationGreenhouse:S=LocationNarrowPath:W=LocationGravelDrive:GOTO RoomMovementDispatcher

LocationZenGarden:
 LK=§:A=LOC_ZENGARDEN:D$="You are in a relaxing zen garden":E$="Exits lead North and South":GOSUB ShowLocation
 GT=§:N=LocationTennisCourt:S=LocationWoodedAvenue:GOTO RoomMovementDispatcher

LocationFrontLawn:
 LK=§:A=LOC_LAWN:D$="You are on a huge area of lawn":E$="Exits lead North, South and East":GOSUB ShowLocation
 GT=§:N=LocationEntranceHall:S=LocationGravelDrive:E=LocationGreenhouse:GOSUB WhatAreYouGoingToDoNow
 IF(LEFT$(A$,1)="N")AND(LD<=0)THENPRINT"The ladder does not fit"
 GOTOGT

LocationGreenhouse:
 LK=§:A=LOC_GREENHOUSE:D$="You are in a small greenhouse":E$="Exits lead North, South and West":GOSUB ShowLocation
 GT=§:N=LocationVegetablePlot:S=LocationTarmacArea:W=LocationFrontLawn:GOTO RoomMovementDispatcher

LocationTennisCourt:
 LK=§:A=LOC_TENNISCOURT:D$="You are on a lawn tennis court":E$="Exits lead North and South":GOSUB ShowLocation
 GT=§:N=LocationFishPond:S=LocationZenGarden:GOTO RoomMovementDispatcher

LocationVegetablePlot:
 LK=§:A=LOC_VEGSGARDEN:D$="You are in a vegetable plot":E$="Exits lead North snd South":GOSUB ShowLocation
 GT=§:N=LocationAppleOrchard:S=LocationGreenhouse:GOTO RoomMovementDispatcher

LocationFishPond:
 LK=§:A=LOC_FISHPND:D$="You are standing by a fish pond":E$="Exits lead South and East":GOSUB ShowLocation
 GT=§:S=LocationTennisCourt:E=LocationTiledPatio:GOTO RoomMovementDispatcher

LocationTiledPatio:
 LK=§:A=LOC_TILEDPATIO:D$="You are on a tiled patio":E$="Exits lead South, East and West":PRINT"Above is a barred window":GOSUB ShowLocation
 GT=§:S=LocationSunLounge:E=LocationAppleOrchard:W=LocationFishPond:GOSUB WhatAreYouGoingToDoNow
 IF(LEFT$(A$,1)="S")AND(LD<=0)THENPRINT"The ladder does not fit"
 GOTOGT

LocationAppleOrchard:
 LK=§:A=LOC_APPLE_TREES:D$="You are in an apple orchard":E$="Exits lead South and West":GOSUB ShowLocation
 GT=§:S=LocationVegetablePlot:W=LocationTiledPatio:GOTO RoomMovementDispatcher

LocationLounge:
 LK=§:A=LOC_LOUNGE:D$="You are in the lounge":E$="Exits lead North and East":GOSUB ShowLocation
 GT=§:N=LocationDiningRoom:E=LocationEntranceHall:GOTO RoomMovementDispatcher

LocationEntranceHall:
 LK=§:A=LOC_ENTRANCEHALL:D$="You are in an imposing entrance hall"
 IFAV=0THEN E$="Exits lead North, South, West and up" ELSE E$=""
 GOSUB ShowLocation:IFAV=0 THEN NoDog
DogAttack: 
 GOSUB WhatAreYouGoingToDoNow
 IF(AV=1)AND(DB=0)THENPRINT:PRINT"AAAAAARRRGGGHHHH - he got you":KD=1:GOTO PlayerFailed
 PRINT
NoDog:
 DB=0:GT=§:N=LocationNarrowPassage:S=LocationFrontLawn:U=LocationSweepingStaircase:W=LocationLounge:GOTO RoomMovementDispatcher

LocationLibrary:
 LK=§:A=LOC_LIBRARY:D$="This looks like a library.":E$="The only exit is West":GOSUB ShowLocation
 GT=§:W=LocationNarrowPassage:GOTO RoomMovementDispatcher

LocationDiningRoom:
 LK=§:A=LOC_DININGROOM:D$="A dining room, or so it appears":E$="Exits lead North and South":GOSUB ShowLocation
 GT=§:N=LocationGamesRoom:S=LocationLounge:GOTO RoomMovementDispatcher

LocationSweepingStaircase:
 LK=§:A=LOC_LARGE_STAIRCASE:D$="You are on a sweeping staircase":E$="Choose up or down":GOSUB ShowLocation
 GT=§:U=LocationMainLanding:D=LocationEntranceHall:GOTO RoomMovementDispatcher

LocationNarrowPassage:
 LK=§:A=LOC_NARROWPASSAGE:D$="You are in a narrow passage":E$="Exits lead North, South and East":GOSUB ShowLocation
 GT=§:N=LocationSunLounge:S=LocationEntranceHall:E=LocationLibrary:GOTO RoomMovementDispatcher

LocationNarrowStaircase:
 LK=§:A=LOC_NARROWSTAIRCASE:D$="You are on some gloomy, narrow steps":E$="Choose up or down":GOSUB ShowLocation
 GT=§:U=LocationKitchen:D=LocationCellar:GOTO RoomMovementDispatcher

LocationGamesRoom:
 LK=§:A=LOC_GAMESROOM:D$="This looks like a games room":E$="Exits lead South and East":GOSUB ShowLocation
 GT=§:S=LocationDiningRoom:E=LocationSunLounge:GOTO RoomMovementDispatcher

LocationSunLounge:
 LK=§:A=LOC_SUNLOUNGE:D$="You find yourself in a sun-lounge":E$="Exits lead North, South, East and West":GOSUB ShowLocation
 GT=§:N=LocationTiledPatio:S=LocationNarrowPassage:E=LocationKitchen:W=LocationGamesRoom:GOTO RoomMovementDispatcher

LocationKitchen:
 LK=§:A=LOC_KITCHEN:D$="This is obviously the kitchen":E$="Exits lead West and down":GOSUB ShowLocation
 GT=§:D=LocationNarrowStaircase:W=LocationSunLounge:GOTO RoomMovementDispatcher

LocationCellar:
 LK=§:A=LOC_CELLAR:D$="This is a cold, damp cellar":E$="Exits lead South and up":GOSUB ShowLocation
 GT=§:S=LocationDarkCellarRoom:U=LocationNarrowStaircase:GOTO RoomMovementDispatcher

LocationDarkCellarRoom:
 LK=§:A=LOC_DARKCELLARROOM:D$="This room is even darker than the last":E$="The only way out is North":GOSUB ShowLocation
 GT=§:N=LocationCellar:GOTO RoomMovementDispatcher

LocationGuestBedroom:
 LK=§:A=LOC_GUESTBEDROOM:D$="This seems to be a guest bedroom":E$="The only exit it North":GOSUB ShowLocation
 GT=§:N=LocationWestGallery:GOTO RoomMovementDispatcher

LocationChildBedroom:
 LK=§:A=LOC_CHILDBEDROOM:D$="This is a child's bedroom":E$="Exit to the North only":GOSUB ShowLocation
 GT=§:N=LocationEastGallery:GOTO RoomMovementDispatcher

LocationMasterBedroom:
 LK=§:A=LOC_MASTERBEDROOM:D$="This must be the master bedroom":E$="Exits lead North and West":GOSUB ShowLocation
 GT=§:N=LocationTinyToilets:W=LocationEastGallery:GOTO RoomMovementDispatcher
 
LocationShowerRoom: 
 LK=§:A=LOC_SHOWERROOM:D$="You are in a tiled shower-room":E$="Exit to the North only":GOSUB ShowLocation
 GT=§:N=LocationBoxRoom:GOTO RoomMovementDispatcher

LocationEastGallery:
 LK=§:A=LOC_EASTGALLERY:D$="You have found the east gallery":E$="Exits North, South, East and West":GOSUB ShowLocation
 GT=§:N=LocationOrnateBathroom:S=LocationChildBedroom:E=LocationMasterBedroom:W=LocationMainLanding:GOTO RoomMovementDispatcher
 
LocationTinyToilets: 
 LK=§:A=LOC_TINY_WC:D$="This is a tiny toilet":E$="Exit to the South only":GOSUB ShowLocation
 GT=§:S=LocationMasterBedroom:GOTO RoomMovementDispatcher

LocationBoxRoom:
 LK=§:A=LOC_BOXROOM:D$="This is a small box-room":E$="Exits to the South and East":GOSUB ShowLocation
 GT=§:S=LocationShowerRoom:E=LocationWestGallery:GOTO RoomMovementDispatcher
 
LocationOrnateBathroom: 
 LK=§:A=LOC_CLASSY_BATHROOM:D$="You are in an ornate bathroom":E$="Exit to the South only":GOSUB ShowLocation
 GT=§:S=LocationEastGallery:GOTO RoomMovementDispatcher

LocationWestGallery:
 LK=§:A=LOC_WESTGALLERY:D$="This is the west gallery":E$="Exits lead North, South, East and West":GOSUB ShowLocation
 GT=§:N=LocationPadlockedDoor:S=LocationGuestBedroom:E=LocationMainLanding:W=LocationBoxRoom:GOTO RoomMovementDispatcher
 
LocationMainLanding: 
 LK=§:A=LOC_UP_STAIRS:D$="You are on the main landing":E$="Exits lead East, West and down":GOSUB ShowLocation
 GT=§:W=LocationWestGallery:E=LocationEastGallery:D=LocationSweepingStaircase:GOTO RoomMovementDispatcher
 
LocationPadlockedDoor: 
 LK=§:A=LOC_PADLOCKED_ROOM:D$="You see a padlocked steel-plated door":E$="You can return to the South":GOSUB ShowLocation
 GT=§:S=LocationWestGallery:GOTO RoomMovementDispatcher
 
 
' 
' This is the main location handler:
' - Loads the correct picture
' - Show items on the location 
' - Eventually draw vector items
' - Show the description
' x Show the possible directions
'
' Inputs: D$ contains the description of the place
'
ShowLocation:              
 PLOT 2,15,LEFT$(ES$,38):PLOT 1,16,ES$:GOSUB LoadPicture
 
 I$=""
 IF WB=A THEN I$=I$+"the window is broken~m~j"
 IF OS=A THEN I$=I$+"an open safe~m~j"
 IF PL=A THEN I$=I$+"a plastic bag~m~j"
 IF BD=A THEN I$=I$+"black dust~m~j"
 IF PO=A THEN I$=I$+"an open panel on wall~m~j"
 IF CP=A THEN I$=I$+"a locked panel on the wall~m~j"
 IF YP=A THEN I$=I$+"gritty yellow powder~m~j"
 IF BU=A THEN I$=I$+"a wooden bucket~m~j"
 IF HD=A THEN I$=I$+"a small hole in the door~m~j"
 IF WA=A THEN I$=I$+"some water~m~j"
 IF PG=A THEN I$=I$+"a large dove~m~j"
 IF BX=A THEN I$=I$+"a cardboard box~m~j"
 IF TW=A THEN I$=I$+"some twine~m~j"
 IF KN=A THEN I$=I$+"a silver knife~m~j"
 IF NE=A THEN I$=I$+"a fishing net~m~j"
 IF LD=A THEN I$=I$+"a ladder~m~j":IF A=LOC_APPLE_TREES THEN !RESTORE GraphicDataLadder:CL=1:GOSUB DrawVectorItems
 IF CR=A THEN I$=I$+"an abandoned car~m~j"
 IF BL=A THEN I$=I$+"three .38 bullets~m~j"
 IF ME=A THEN I$=I$+"a joint of meat~m~j"
 IF BR=A THEN I$=I$+"some brown bread~m~j"
 IF TN=A THEN I$=I$+"an empty tobacco tin~m~j"
 IF TP=A THEN I$=I$+"a roll of sticky tape~m~j"
 IF BK=A THEN I$=I$+"a chemistry book~m~j":IF A=LOC_LIBRARY THEN !RESTORE GraphicDataLibraryBook:CL=0:GOSUB DrawVectorItems 
 IF MA=A THEN I$=I$+"a box of matches~m~j"
 IF CU=A THEN I$=I$+"a snooker cue~m~j"
 IF LP=A THEN I$=I$+"a loaded pistol~m~j"
 IF SA=A THEN I$=I$+"a heavy safe~m~j"
 IF NO=A THEN I$=I$+"a printed note~m~j"
 IF RH=A THEN I$=I$+"a rope hangs from the window~m~j":RO=99
 IF GL=A THEN I$=I$+"a young girl tied up on the floor~m~j"
 IF TT=A THEN I$=I$+"a roll of toilet tissue~m~j" 
 IF HP=A THEN I$=I$+"a hose-pipe~m~j"
 IF PT=A THEN I$=I$+"some petrol~m~j"
 IF BB=A THEN I$=I$+"broken glass~m~j"
 IF AB=A THEN I$=I$+"an acid burn~m~j"
 IF SB=A THEN I$=I$+"a small bottle~m~j"
 IF GF=A THEN I$=I$+"a young girl~m~j"
 IF RO=A THEN I$=I$+"a length of rope~m~j"
 IF FU=A THEN I$=I$+"a fuse~m~j"
 IF GP=A THEN I$=I$+"some gunpowder~m~j"
 IF KY=A THEN I$=I$+"a set of keys~m~j"
 IF PU=A THEN I$=I$+"a pistol~m~j"
 IF BM=A THEN I$=I$+"a bomb~m~j"
 IF (DG<>A) THEN ELSE IF AV=1 THEN I$=I$+"an alsatian growling at you~m~j" ELSE I$=I$+"the body of an alsatian dog~m~j"
 IF (TG<>A) THEN ELSE IF AL=1 THEN I$=I$+"a thug asleep on the bed~m~j" ELSE I$=I$+"a thug lying dead on the bed~m~j"
 IF (CU=43) AND (HD=39) THEN I$=I$+"a cue on the floor~m~j"

 PLOT 21-LEN(D$)/2,15,D$    ' Information bar with the name of the location
 PLOT 21-LEN(E$)/2,16,E$    ' Possible directions

 IF I$="" THEN PRINT"There is nothing of interest here~m~j" ELSE PRINT"I can see ";I$

 FR=FRE(0)   ' Garbage collection
 RETURN
 
RoomMovementDispatcher:
 GOSUB WhatAreYouGoingToDoNow:GOTOGT
 

WhatAreYouGoingToDoNow:           ' Ask the player for input
 GOSUB VictoryFailureCheck
AskHow:  
 IFAR=1THENPLOT 20,26,1:PLOT 21,26,"Alarm"+STR$(20-TM)+CHR$(27)+"C"   ' Update the Alarm display
 PLOT 29,26,3:PLOT 30,26,"Moves "+STR$(501-NM)                        ' Update the Move counter

 AA$="":BB$="":A$="":B$="":D$="What are you going to do now ?":GOSUB AskPlayer
 XX=10
 L=LEN(Q$)
 FORJ=1TOL
   IFMID$(Q$,J,1)=" "THENXX=J+1
 NEXT
 AA$=LEFT$(Q$,XX-2):A$=LEFT$(AA$,3)   ' First word (plus abreviation)
 BB$=MID$(Q$,XX,L):B$=LEFT$(BB$,3)    ' Second word (plus abreviation)

 ' Debugging code:
 IF LEFT$(Q$,1)="!" THEN PRINT"--STOPPED--":STOP

 IF A$="GET" THEN ActionGet
 IF A$="DRO" THEN ActionDrop
 IF A$="THR" THEN ActionThrow
 IF A$="KIL" THEN ActionKill
 IF A$="OPE" THEN ActionOpen
 IF A$="CLI" THEN ActionClimb
 IF A$="FRI" THEN ActionFrisk
 IF A$="MAK" THEN ActionMake
 IF A$="LOA" THEN ActionLoad
 IF A$="USE" THEN ActionUse
 IF A$="REA" THEN ActionRead
 IF A$="QUI" THEN ActionQuit
 IF A$="SHO" THEN ActionShoot
 IF A$="PRE" THEN ActionPress

 IF (A$="SYP") OR (A$="SIP") THEN ActionSyphon
 IF (A$="BLO") OR (A$="EXP") THEN ActionBlow
 IF (A$="STA") AND (A=LOC_TARMACAREA) THEN PRINT:PRINT"How ?":GOTO AskHow
 IF L>1 THEN DontKnowHowTo
 IF A$="L" THEN GT=LK:RETURN
 IF (A$="N") AND (N<>0) THEN GT=N:GOTO UpdateInventory
 IF (A$="S") AND (S<>0) THEN GT=S:GOTO UpdateInventory
 IF (A$="E") AND (E<>0) THEN GT=E:GOTO UpdateInventory
 IF (A$="W") AND (W<>0) THEN GT=W:GOTO UpdateInventory
 IF (A$="U") AND (U<>0) THEN GT=U:GOTO UpdateInventory
 IF (A$="D") AND (D<>0) THEN GT=D:GOTO UpdateInventory
 IF A$="I" THEN DisplayInventory
 IF L=1 THEN ErrorCantDoThat
DontKnowHowTo: 
 PRINT:PRINT"I don't know how to ";AA$;" something":GOTO WhatAreYouGoingToDoNow

ActionGet: 
 IF IC>=7 THEN ErrorDropSomething
 ' Elements that require a container
 IF (B$="DUS") AND (BD=A) THEN GetContainableProduct
 IF (B$="POW") AND (YP=A) THEN GetContainableProduct
 IF (B$="WAT") AND (WA=A) THEN GetContainableProduct
 IF (B$="DOV") AND (PG=A) THEN GetContainableProduct
 IF (B$="GUN") AND (GP=A) THEN GetContainableProduct
 IF (B$="PET") AND (PT=A) THEN GetContainableProduct
 ' Items that can just be put in the inventory directly
 IF (B$="BAG") AND (PL=A) THENPL=0:GOTO UpdateInventory
 IF (B$="KEY") AND (KY=A) THENKY=0:GOTO UpdateInventory
 IF (B$="BUC") AND (BU=A) THENBU=0:GOTO UpdateInventory  
 IF (B$="ROP") AND (RO=A) THENRO=0:GOTO UpdateInventory
 IF (B$="BOX") AND (BX=A) THENBX=0:GOTO UpdateInventory
 IF (B$="TWI") AND (TW=A) THENTW=0:GOTO UpdateInventory 
 IF (B$="KNI") AND (KN=A) THENKN=0:GOTO UpdateInventory
 IF (B$="NET") AND (NE=A) THENNE=0:GOTO UpdateInventory
 IF (B$="LAD") AND (LD=A) THENLD=0:GOTO UpdateInventory
 IF (B$="HOS") AND (HP=A) THENHP=0:GOTO UpdateInventory 
 IF (B$="PIS") AND (PU=A) THENPU=0:GOTO UpdateInventory
 IF (B$="BUL") AND (BL=A) THENBL=0:GOTO UpdateInventory
 IF (B$="MEA") AND (ME=A) THENME=0:GOTO UpdateInventory
 IF (B$="NOT") AND (NO=A) THENNO=0:GOTO UpdateInventory
 IF (B$="MAT") AND (MA=A) THENMA=0:GOTO UpdateInventory
 IF (B$="CUE") AND (CU=A) THENCU=0:GOTO UpdateInventory
 IF (B$="BOO") AND (BK=A) THENBK=0:GOTO UpdateInventory 
 IF (B$="BRE") AND (BR=A) THENBR=0:GOTO UpdateInventory
 IF (B$="TAP") AND (TP=A) THENTP=0:GOTO UpdateInventory
 IF (B$="TIS") AND (TT=A) THENTT=0:GOTO UpdateInventory
 IF (B$="GIR") AND (GF=A) THENGL=0:GOTO UpdateInventory
 IF (B$="BOT") AND (SB=A) THENSB=0:GOTO UpdateInventory
 IF (B$="TIN") AND (TN=A) THENTN=0:GOTO UpdateInventory
 IF (B$="GLA") AND (BB=A) THENBB=0:GOTO UpdateInventory
 IF (B$="FUS") AND (FU=A) THENFU=0:GOTO UpdateInventory 
 IF (B$="BOM") AND (BM=A) THENBM=0:GOTO UpdateInventory
 IF (B$="THU") AND (TG=A) AND (AL=O) THEN PRINT:PRINT"He's too heavy":GOTO WhatAreYouGoingToDoNow
 IF (B$="THU") AND (TG=A) AND (AL=1) THEN PRINT:PRINT"Not a good idea":GOTO WhatAreYouGoingToDoNow
 IF (B$="DOG") AND (DG=A) AND (AV=0) THEN DG=0:GOSUB LoadPicture:GOTO UpdateInventory
 IF (B$="DOG") AND (DG=A) AND (AV=1) THEN PRINT:PRINT"Not a good idea":GOTO WhatAreYouGoingToDoNow
 IF (B$="LIG") AND (A=LOC_DARKCELLARROOM) AND (PO=A) THEN PRINT:PRINT"Bulb's too hot":GOTO WhatAreYouGoingToDoNow
 IF (B$="SAF") AND (SA=A) THEN ErrorWeighsTooMuch
 IF (B$="CAR") AND (CR=A) THEN ErrorWeighsTooMuch
 IF (B$="BED") AND ((A=LOC_GUESTBEDROOM) OR (A=LOC_CHILDBEDROOM) OR (A=LOC_MASTERBEDROOM)) THEN ErrorWeighsTooMuch
 IF (B$="GRE") AND (A=LOC_GREENHOUSE) THEN PRINT:PRINT"Don't be daft":GOTO WhatAreYouGoingToDoNow
 IF (B$="BUT") AND (A=LOC_DARKCELLARROOM) THEN PRINT:PRINT"Try pressing it":GOTO WhatAreYouGoingToDoNow
 IF (B$="WIN") AND (A=LOC_TILEDPATIO) THEN PRINT:PRINT"It's a bit too high":GOTO WhatAreYouGoingToDoNow
 IF (B$="PAN") AND (A=LOC_DARKCELLARROOM) THEN PRINT:PRINT"It's fixed to the wall"GOTO UpdateInventory
 IFQ$="BAG"THENPRINT:PRINT"Sorry, it will suffocate":GOTO WhatAreYouGoingToDoNow
CantSeeItem: 
 PRINT:PRINT"I can't see ";BB$;" anywhere":GOTO WhatAreYouGoingToDoNow

ActionDrop: 
 ' Drop things that are in containers
 IF (B$="DUS") AND (BD<=0) THEN CF(-BD)=0:BD=A:GOTO UpdateInventory
 IF (B$="POW") AND (YP<=0) THEN CF(-YP)=0:YP=A:GOTO UpdateInventory
 IF (B$="GUN") AND (GP<=0) THEN CF(-GP)=0:GP=A:GOTO UpdateInventory
 IF (B$="DOV") AND (PG<=0) THEN CF(-PG)=0:PG=A:GOTO UpdateInventory
 IF (B$="WAT") AND (WA<=0) THEN CF(-WA)=0:WA=99:PRINT:PRINT"The water drains away":GOTO UpdateInventory
 IF (B$="PET") AND (PT<=0) THEN CF(-PT)=0:PT=99:PRINT:PRINT"The petrol evaporates":GOTO UpdateInventory
 ' Drop actual containers 
 IF (B$="BUC") AND (BU<=0) THEN BU=A:CN=CNTNR_BUCKET:GOTO DropContainer
 IF (B$="BOX") AND (BX<=0) THEN BX=A:CN=CNTNR_BOX:GOTO DropContainer
 IF (B$="TIN") AND (TN<=0) THEN TN=A:CN=CNTNR_TIN:GOTO DropContainer
 IF (B$="BAG") AND (PL<=0) THEN PL=A:CN=CNTNR_BAG:GOTO DropContainer
 ' Drop normal items 
 IF (B$="KEY") AND (KY<=0) THEN KY=A:GOTO UpdateInventory
 IF (B$="ROP") AND (RO<=0) THEN RO=A:GOTO UpdateInventory
 IF (B$="TWI") AND (TW<=0) THEN TW=A:GOTO UpdateInventory 
 IF (B$="KNI") AND (KN<=0) THEN KN=A:GOTO UpdateInventory
 IF (B$="NET") AND (NE<=0) THEN NE=A:GOTO UpdateInventory
 IF (B$="LAD") AND (LD<=0) THEN LD=A:GOTO UpdateInventory
 IF (B$="PIS") AND (LP<=0) THEN LP=A:GOTO UpdateInventory
 IF (B$="PIS") AND (PU<=0) THEN PU=A:GOTO UpdateInventory
 IF (B$="BUL") AND (BL<=0) THEN BL=A:GOTO UpdateInventory 
 IF (B$="MEA") AND (ME<=0) THEN ME=A:GOTO UpdateInventory
 IF (B$="NOT") AND (NO<=0) THEN NO=A:GOTO UpdateInventory
 IF (B$="MAT") AND (MA<=0) THEN MA=A:GOTO UpdateInventory
 IF (B$="CUE") AND (CU<=0) THEN CU=A:GOTO UpdateInventory
 IF (B$="BOO") AND (BK<=0) THEN BK=A:GOTO UpdateInventory
 IF (B$="BRE") AND (BR<=0) THEN BR=A:GOTO UpdateInventory
 IF (B$="TAP") AND (TP<=0) THEN TP=A:GOTO UpdateInventory
 IF (B$="TIS") AND (TT<=0) THEN TT=A:GOTO UpdateInventory
 IF (B$="HOS") AND (HP<=0) THEN HP=A:GOTO UpdateInventory
 IF (B$="DOG") AND (DG<=0) THEN DG=A:GOTO UpdateInventory
 IF (B$="GIR") AND (GL<=0) THEN GL=A:GOTO UpdateInventory
 IF (B$="BOT") AND (SB<=0) THEN AB=A:BB=A:SB=99:GOTO MessageFunnySmell
 IF (B$="FUS") AND (FU<=0) THEN FU=A:GOTO WhatAreYouGoingToDoNow ' 10000 ' 1OOOO ???
MessageDontHaveItem: 
 PRINT:PRINT"Don't have ";BB$;" - check inventory":GOTO WhatAreYouGoingToDoNow

DropContainer: ' Call with CN containing the container
 IF WA=-CN THEN WA=99:GOSUB MessageWaterSpillsOut
 IF PT=-CN THEN PT=99:GOSUB MessagePetrolSpillsOut
 IF BD=-CN THEN BD=A
 IF YP=-CN THEN YP=A
 IF GP=-CN THEN GP=A
 CF(CN)=0
 GOTO UpdateInventory


ActionThrow: 
 IF(B$="MEA")AND(ME<=0)THEN ThrowMeat
 IF(B$="BRE")AND(BR<=0)THEN ThrowBread
 IF(B$="CUE")AND(CU<=0)THEN ThrowCue
 IF(B$="BOT")AND(SB<=0)THEN ThrowBottle
 IF(B$="KNI")AND(KN<=0)THEN ThrowKnife
 IF(B$="ROP")AND(RO<=0)THEN ThrowRope
 IF(B$="GLA")AND(BB<=0)THEN PRINT:PRINT"The fragments are too small to throw":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Use the DROP command":GOTO WhatAreYouGoingToDoNow

ThrowMeat: 
 IF(DG=A)AND(AV=1)THENPRINT:PRINT"Dog eats meat":ME=99:DB=99:P=P+25:GOTO UpdateInventory
 ME=A:GOTO UpdateInventory

ThrowBread:
 IFPG=ATHENPRINT:PRINT"Dove eats the bread":BR=99:GOTO UpdateInventory
 IF(DG=A)AND(AV=1)THENPRINT:PRINT"Dog sniffs bread - he is not happy"         
 BR=A:GOTO UpdateInventory

ThrowCue:
 IF DG=A THEN PRINT:PRINT"You have speared the dog":CU=A:AV=0:P=P+50:GOSUB LoadPicture:GOTO UpdateInventory
 IF (A=LOC_TILEDPATIO) AND (WB=18) THEN EndThrowCue
 IF A=LOC_TILEDPATIO THEN POKE#26B,16+1:PRINT:PRINT"The cue smashes the window":CU=39:WB=18:AR=1:GOTO AlarmStartsRinging
EndThrowCue: 
 CU=A:GOTO UpdateInventory

ThrowKnife:
 IF DG=A THEN PRINT:PRINT"You have killed the dog":P=P+50:KN=A:AV=0:GOSUB LoadPicture:GOTO UpdateInventory
 IF (GL=A) AND (HD=A) THENPRINT:PRINT"Girl cuts her bonds":KN=A:GL=99:GF=A
 KN=A
 IF RO=39 THEN GirlSlidesDownRope
 GOTO UpdateInventory

ThrowBottle:
 IFA<>39THEN MessageFunnySmell
 PRINT:PRINT"Acid in the bottle burns small hole in the door":P=P+200
 SB=99:GL=39:HD=39:BB=39:GOTO UpdateInventory

ThrowRope:
 IF(A<>39)AND(HD<>39)THENRIO=A:GOTO UpdateInventory
 IFGF<>39THENRO=A:GOTO UpdateInventory
GirlSlidesDownRope:
 IFWB=0THENPRINT:PRINT"Girl breaks window and slides down rope"
 IFWB=0THENPRINT:PRINT"Alarm starts ringing":WB=18:PLAY3,2,4,1:GOTO RingRing
 IFWB=8THENPRINT:PRINT"Girl climbs out of window and down rope":GOTO WhatAreYouGoingToDoNow
 RO=39:GOTO UpdateInventory
RingRing:
 GF=18:RH=18:RO=18:AR=1:P=P+100:GOTO WhatAreYouGoingToDoNow
RingRingUnused:
 GF=18:RH=18:RO=18:P=P+100:GOTO WhatAreYouGoingToDoNow

 ' Open
ActionOpen: 
 IF(B$="DOO")AND(A=LOC_PADLOCKED_ROOM)THEN MessageLocked
 IF(B$="WIN")AND(A=LOC_TILEDPATIO)THENPRINT:PRINT"It's thirty feet up":GOTO WhatAreYouGoingToDoNow
 IF(B$="BOT")AND(SB<=0)THENPRINT:PRINT"The screw cap is stuck":GOTO WhatAreYouGoingToDoNow
 IF(B$="CAR")AND(A=LOC_TARMACAREA)THENPRINT:PRINT"Nothing. Try the trunk":GOTO WhatAreYouGoingToDoNow
 IF(B$="TRU")AND(A=LOC_TARMACAREA)THENPRINT:PRINT"Nothing here, either":GOTO WhatAreYouGoingToDoNow
 IF(B$="TIN")AND(CF(CNTNR_TIN)=0)AND(TN<=0)THENPRINT:PRINT"Nothing inside":GOSUB WhatAreYouGoingToDoNow
 IF(B$="TIN")AND(CF(CNTNR_TIN)=1)AND(TN<=0)THENPRINT:PRINT"Okay, it's open":GOSUB WhatAreYouGoingToDoNow
 IF(B$="TAN")AND(A=LOC_TARMACAREA)AND(PA=1)THENPRINT:PRINT"It's already open":GOSUB WhatAreYouGoingToDoNow 
 IF(B$="TAN")AND(A=LOC_TARMACAREA)THENPA=1:PRINT:PRINT"Okay, it's open":GOTO WhatAreYouGoingToDoNow
 IF(B$="SAF")AND(A=LOC_CELLAR)AND(OS=99)THEN MessageLocked
 IF(B$="SAF")AND(A=LOC_CELLAR)AND(OS=21)THEN MessageOpen
 IF(B$="PAN")AND(A=LOC_DARKCELLARROOM)AND(PO=20)THEN MessageOpen
 IF(B$="PAN")AND(A=LOC_DARKCELLARROOM)THEN MessageLocked
 IF(B$="BOX")AND(CF(CNTNR_BOX)=0)AND(BX<=0)THENPRINT:PRINT"Nothing inside":GOTO WhatAreYouGoingToDoNow
 IF(B$="BOX")AND(CF(CNTNR_BOX)=1)AND(BX<=0)THEN MessageOpen
 GOTO ErrorEh

ActionClimb: 
 IF (B$="WAL") AND (A=LOC_TILEDPATIO) THEN MessageTooSteep
 IF (B$="WAL") AND (A=LOC_INSIDEHOLE) THEN MessageTooSteep
 IF (B$="LAD") AND (AD>0) THEN PRINT:PRINT"You have no ladder":GOTO WhatAreYouGoingToDoNow
 IF (B$="LAD") AND (A=LOC_TILEDPATIO) THEN PRINT:PRINT"Ladder is too short":GOTO WhatAreYouGoingToDoNow
 IF (B$="LAD") AND (A=LOC_INSIDEHOLE) THEN PRINT:PRINT"You are out":LD=7:OP=1:GOSUB DisplayInventory
 IF OP=1 THEN A=LOC_NARROWPATH:RETURN
 GOTO ErrorCantDoThat

ActionFrisk: 
 IF(B$="GIR")AND(GL<=0)THENPRINT:PRINT"Shame on you":GOTO WhatAreYouGoingToDoNow
 IFB$="THU"THEN FriskThug
 PRINT:PRINT"I don't understand":GOTO WhatAreYouGoingToDoNow
FriskThug: 
 IFFK=1THENPRINT:PRINT"You've already frisked him":GOTO WhatAreYouGoingToDoNow
 IFAL=1THENPRINT:PRINT"I should subdue him first":GOTO WhatAreYouGoingToDoNow
 PRINT"I've found a pistol.It is not loaded":PU=A:FK=1:P=P+50:GOTO WhatAreYouGoingToDoNow
 
ActionKill: 
 IF (B$="DOG") AND (A=LOC_ENTRANCEHALL) AND (AV=1) THEN MessageGoodIdea
 IF (B$="GIR") AND (GL<=0) THEN MessageDontThinkSo
 IF (B$="DOV") AND (PG<=0) THEN MessageNoViolence
 IF (B$="THU") AND (A=LOC_MASTERBEDROOM) AND (AL=1) THEN PRINT:PRINT"I'm game. How":GOTO KillThug
 GOTO ErrorEh

KillThug: 
 PRINT:INPUTRR$:R$=LEFT$(RR$,3)
 PRINT:PRINT"With what ?":PRINT:INPUTSS$:S$=LEFT$(SS$,3)
 IFR$="STR"THEN StrangleThug
 IFR$="STA"THEN StabThug
 IFR$="HIT"THEN HitThug
 IFR$="SUF"THEN SuffocateThug
 GOTO ErrorCommeAgain

StrangleThug: 
 IF (S$<>"TWI") THEN ELSE IF (TW<=0)THEN PRINT:PRINT"CROAK":TW=A:GOTO DeadThugPicture ELSE MessageDontHaveAny
 IF (S$<>"ROP") THEN ELSE IF (RO<=0)THEN PRINT:PRINT"CROAK":RO=A:GOTO DeadThugPicture ELSE MessageDontHaveAny
 IF (S$<>"HOS") THEN ELSE IF (HP<=0)THEN PRINT:PRINT"CROAK":HP=A:GOTO DeadThugPicture ELSE MessageDontHaveAny
 GOTO ErrorCommeAgain

StabThug: 
 IF(S$<>"KNI") THEN ELSE IF (KN<=0)THENPRINT:PRINT"Messy":KN=A:GOTO DeadThugPicture ELSE MessageDontHaveAny
 GOTO ErrorCommeAgain

HitThug: 
 IF(S$<>"CUE") THEN ELSE IF (CU<=0)THENPRINT:PRINT"KRUNCH":CU=A:GOTO DeadThugPicture ELSE MessageDontHaveAny
 PRINT:PRINT"You managed to wake him - he's not happy- he approaches.......":LOAD"342.BIN"
 FORT=1TO500:NEXT:PRINT"**BANG**   you are dead":SHOOT:KT=1:GOTO PlayerFailed 

SuffocateThug:
 IF(S$="BAG")AND(PL<=0)THEN SuffocateBagFull
 IF(S$="BAG")AND(PL>0)THEN MessageDontHaveAny
 PRINT:PRINT"What ???":GOTO WhatAreYouGoingToDoNow
SuffocateBagFull:
 IFCF(CNTNR_BAG)=1THENPRINT:PRINT"Your bag is full":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"G-A-S-P !!!":AL=0:PL=A:P=P+50:GOTO WhatAreYouGoingToDoNow

DeadThugPicture: 
 LOAD"340.BIN"
 AL=0:P=P+50:GOSUB DisplayInventory:GOTO WhatAreYouGoingToDoNow


ActionMake: 
 IF B$="GUN" THEN ActionMakeGunpowder
 IF B$="FUS" THEN ActionMakeFuse
 IF B$="BOM" THEN ActionMakeBomb
 IF B$="NOI" THEN PRINT"I'd keep quiet if I were you":GOTO WhatAreYouGoingToDoNow
 GOTO ErrorCantDoThat

ActionMakeGunpowder:                                   ' Yellow Powder (YP) + Black Dust (BD) = Gunpowder (GP)
 IF (YP>0) OR (BD>0) THEN ErrorCantDoThat 
 CF(-YP)=0:CF(-BD)=0:YP=99:BD=99:GP=A:PRINT:PRINT"Okay, gunpowder ready":P=P+100:GOSUB:UpdateInventory:GOTO WhatAreYouGoingToDoNow

ActionMakeFuse:                                        ' Toilet paper roll (TT) + Petrol (PT) = Fuse (FU)
 IF (TT>0) OR (PT>0) THEN ErrorCantDoThat 
 CF(-PT)=0:TT=99:PT=99:FU=A:PRINT:PRINT"Okay, fuse ready":P=P+100:GOSUB:UpdateInventory:GOTO WhatAreYouGoingToDoNow

ActionMakeBomb:                                        ' Fuse (FU) + Gunpowder (GP) + Tobacco Tin (TN) = Bomb (BM)
 IF (FU>0) OR (GP>0) OR (TN>0)THEN ErrorCantDoThat
 FU=99:GP=99:TN=99:BM=A:PRINT:PRINT"Bomb ready":P=P+200:GOSUB:UpdateInventory:GOTO WhatAreYouGoingToDoNow
 
ActionSyphon:   ' Syphon petrol with the hose
 IF B$<>"PET" THEN ErrorEh
 IF(PA=0)OR(A<>11)THEN ErrorCantDoThat
 PRINT:PRINT"What shall I use?"
 PRINT:INPUTS$:IFLEFT$(S$,3)<>"HOS"THEN ErrorCantDoThat
 IFHP<>0THENPRINT:PRINT"You don't have one":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Okay":PT=A:HP=A:GOTO GetContainableProduct

ActionLoad:     ' Load pistol
 IFB$<>"PIS"THEN ErrorCantDoThat
 IF(PU<>0)OR(BL<>0)THEN ErrorCantDoThat
 IFLP=0THENPRINT:PRINT"It's already loaded":GOTO WhatAreYouGoingToDoNow
 LP=0:PU=99:BL=99:PRINT:PRINT"Okay":GOTO WhatAreYouGoingToDoNow
 
ActionBlow:    ' Blow things open
 IF(B$="SAF")AND(OS=21)THENPRINT:PRINT"It's already open":GOTO WhatAreYouGoingToDoNow
 IF(B$<>"SAF")AND(B$<>"DOO")THEN ErrorCantDoThat
 IF(B$="SAF")AND(A<>21)THENPRINT:PRINT"I can't see a safe":GOTO WhatAreYouGoingToDoNow
 IF(B$="DOO")AND(A<>39)THENPRINT:PRINT"I can't see a door":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Using what ?":PRINT:INPUTZZ$:Z$=LEFT$(ZZ$,3) 
 IFZ$="GUN"THEN BlowWithGun
 IFZ$="BOM"THEN BlowWithBomb
 GOTO ErrorEh
BlowWithGun:
 IFGP<>0THENPRINT:PRINT"You don't have any":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Okay, how shall we light it?"
 PRINT:INPUTXX$:X$=LEFT$(XX$,3)
 IF (X$="MAT") AND (MA=0) THEN MA=99:GP=99:GOTO DoBlow
 IF (X$="PIS") AND (LP=0) THEN LP=99:PI=0:GP=99:GOTO DoBlow
 IF (X$="PIS") AND (PI=0) THEN PRINT:PRINT"CLICK  it isn't loaded":GOTO WhatAreYouGoingToDoNow
 GOTO ErrorLetsTryAgain

DoBlow:
 PRINT:PRINT"****B*O*O*O*M*M*M****":EXPLODE
 IFX$="MAT"THENPRINT:PRINT"You have been blown to bits":KE=1:GOTO PlayerFailed
 IFX$="PIS"THENPRINT:PRINT"Lots of smoke but unsuccessful":GOTO PlayerFailed

BlowWithBomb: 
 IFBM<>0THENPRINT:PRINT"You don't have a bomb":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Okay, how shall we light it?"
 PRINT:INPUTXX$:X$=LEFT$(XX$,3)
 IF(X$="MAT")AND(MA=0)THENMA=99:BM=99:GOTO DoBlowDoor
 IF(X$="PIS")AND(LP=0)THENLP=99:PU=0:BM=99:QZ=1
 IFQZ=1THENQZ=0:PRINT:PRINT"*BANG*BANG*BANG*":GOTO DoBlowDoor
 IF(X$="PIS")AND(PU=0)THENPRINT:PRINT"CLICK  it isn't loaded":GOTO WhatAreYouGoingToDoNow
 GOTO ErrorLetsTryAgain
DoBlowDoor:
 PRINT:PRINT"****B*O*O*O*M*M*M****":EXPLODE  
 IFB$="DOO"THENPRINT:PRINT"The door is untouched":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"The safe is open":SB=A:SA=99:OS=21:P=P+200:GOSUB:UpdateInventory:GOTO WhatAreYouGoingToDoNow

ActionUse: 
 IF B$<>"KEY" THEN ErrorCantDoThat
 IF KY<>0 THEN MessageDontHaveItem
 IF (A=LOC_PADLOCKED_ROOM) OR (A=LOC_CELLAR) OR (A=LOC_TARMACAREA)THEN MessageKeyDontFit
 IF A=LOC_DARKCELLARROOM THEN PanelIsOpen
 PRINT:PRINT"I don't understand":GOTO WhatAreYouGoingToDoNow

MessageKeyDontFit: 
 PRINT:PRINT"The keys don't fit":GOTO WhatAreYouGoingToDoNow

PanelIsOpen: 
 PRINT:PRINT"It's open"
 PRINT:PRINT"I see lots of lights and a red button" 
 KY=20:CP=99:PO=20:GOTO WhatAreYouGoingToDoNow

ActionRead: 
 IFB$<>"NOT"THEN ReadBook
 IF (N0<>0) AND (N0<>A) THEN MessageDontHaveItem
 PRINT:PRINT"I moved all your dangerous chemical":PRINT"products to the basement's safe - DAD":GOTO WhatAreYouGoingToDoNow
ReadBook:
 IFB$<>"BOO"THEN ErrorEh
 IF (BK<>0) AND (BK<>A) THEN MessageDontHaveItem
 PRINT:PRINT"...making fuses... salpeter... explosive... acide and steel... Complicated stuff!":GOTO WhatAreYouGoingToDoNow

ActionQuit: 
 PRINT:PRINT"Giving up ???? - are you sure ?"
 REPEAT
   K$=KEY$:IFK$="Y"THENGU=1:GOTO PlayerFailed
 UNTIL K$="N"
 GOTO UpdateInventory

ActionShoot: 
 IFPU=0THENPRINT:PRINT"CLICK   it isn't loaded":GOTO WhatAreYouGoingToDoNow
 IF(PU<>0)AND(LP<>0)THENPRINT:PRINT"You have no gun":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"*BANG*BANG*BANG*":LP=99:PU=0:SHOOT:WAIT25:SHOOT:WAIT25:SHOOT
 IF(A=LOC_ENTRANCEHALL)AND(AV=1)THENPRINT:PRINT"The dog is dead":P=P+50:AV=0
 GOTO WhatAreYouGoingToDoNow

ActionPress: 
 IFB$<>"BUT"THEN PRINT:PRINT"Press what ?":GOTO WhatAreYouGoingToDoNow
 IF(PO<>20)OR(A<>20)THEN CantSeeItem
 IFAR=1THENPOKE#26B,16+4:PLOT 21,26,"        ":PRINT:PRINT"Alarm stops ringing":PING:AR=0:P=P+200:GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Oh - nothing happened":GOTO WhatAreYouGoingToDoNow
 
GetContainableProduct:    ' Get dust/water/petrol/dove/powder
 D$="Carry it in what?":GOSUB AskPlayer:QQ$=Q$:Q$=LEFT$(QQ$,3)
 ' Find the container number:
 CN=0
 IF (Q$="BUC") THEN CN=CNTNR_BUCKET:IF (BU>0) THEN ErrorNotCarryingOne
 IF (Q$="BOX") THEN CN=CNTNR_BOX:IF (BX>0) THEN ErrorNotCarryingOne
 IF (Q$="BAG") THEN CN=CNTNR_BAG:IF (PL>0) THEN ErrorNotCarryingOne
 IF (Q$="TIN") THEN CN=CNTNR_TIN:IF (TN>0) THEN ErrorNotCarryingOne
 IF (Q$="NET") THEN CN=CNTNR_NET:IF (NE>0) THEN ErrorNotCarryingOne
 IF (Q$="BOT") THEN IF (SB>0) THEN ErrorNotCarryingOne ELSE ErrorBottleFull

 ' Check if it already contains something
 IF CF(CN)=1 THEN ErrorSorryThatsFull

 IF B$="GUN" THEN GetGunPowder
 IF B$="WAT" THEN GetWater
 IF B$="DOV" THEN GetDove
 IF B$="POW" THEN GetPowder
 IF B$="DUS" THEN GetDust
 IF B$="PET" THEN GetPetrol
 GOTO ErrorEh

GetWater: 
 INSTR"BUC,BAG,TIN",Q$,1:IF IN=0 THEN MessageDontBeRidiculous
 CF(CN)=1:WA=-CN:GOTO UpdateInventory

GetPetrol:
 INSTR"BUC,BAG,TIN",Q$,1:IF IN=0 THEN MessageDontBeRidiculous
 CF(CN)=1:PT=-CN:GOTO UpdateInventory

GetDove: 
 INSTR"BUC,BOX,NET",Q$,1:IF IN=0 THEN MessageDontBeRidiculous
 CF(CN)=1:PG=-CN:GOTO UpdateInventory

GetPowder: 
 INSTR"BUC,BOX,BAG,TIN",Q$,1:IF IN=0 THEN MessageDontBeRidiculous
 CF(CN)=1:YP=-CN:GOTO UpdateInventory

GetDust: 
 INSTR"BUC,BOX,BAG,TIN",Q$,1:IF IN=0 THEN MessageDontBeRidiculous
 CF(CN)=1:BD=-CN:GOTO UpdateInventory

GetGunPowder: 
 INSTR"BUC,BOX,BAG,TIN",Q$,1:IF IN=0 THEN MessageDontBeRidiculous
 CF(CN)=1:GP=-CN:GOTO UpdateInventory

 

DisplayInventory:    ' We display the user's inventory, but also coumt how many items it has
 IV=0:IH=0
 IF PL<=0 THEN PLOT 1+IH,23+IV/2,"A plastic bag       ":IV=IV+1:IH=20-IH
 IF BD<=0 THEN PLOT 1+IH,23+IV/2,"Some black dust     ":IV=IV+1:IH=20-IH
 IF KY<=0 THEN PLOT 1+IH,23+IV/2,"A set of keys       ":IV=IV+1:IH=20-IH
 IF PU<=0 THEN PLOT 1+IH,23+IV/2,"A pistol            ":IV=IV+1:IH=20-IH
 IF YP<=0 THEN PLOT 1+IH,23+IV/2,"Some yellow powder  ":IV=IV+1:IH=20-IH
 IF BU<=0 THEN PLOT 1+IH,23+IV/2,"A wooden bucket     ":IV=IV+1:IH=20-IH
 IF RO<=0 THEN PLOT 1+IH,23+IV/2,"A length of rope    ":IV=IV+1:IH=20-IH
 IF WA<=0 THEN PLOT 1+IH,23+IV/2,"Some water          ":IV=IV+1:IH=20-IH
 IF PG<=0 THEN PLOT 1+IH,23+IV/2,"A large dove        ":IV=IV+1:IH=20-IH
 IF BL<=0 THEN PLOT 1+IH,23+IV/2,"3 bullets           ":IV=IV+1:IH=20-IH
 IF KN<=0 THEN PLOT 1+IH,23+IV/2,"A silver knife      ":IV=IV+1:IH=20-IH
 IF TW<=0 THEN PLOT 1+IH,23+IV/2,"Some twine          ":IV=IV+1:IH=20-IH
 IF ME<=0 THEN PLOT 1+IH,23+IV/2,"Some meat           ":IV=IV+1:IH=20-IH
 IF NO<=0 THEN PLOT 1+IH,23+IV/2,"A printed note      ":IV=IV+1:IH=20-IH
 IF MA<=0 THEN PLOT 1+IH,23+IV/2,"A box of matches    ":IV=IV+1:IH=20-IH
 IF CU<=0 THEN PLOT 1+IH,23+IV/2,"A snooker cue       ":IV=IV+1:IH=20-IH
 IF BK<=0 THEN PLOT 1+IH,23+IV/2,"A large book        ":IV=IV+1:IH=20-IH
 IF LD<=0 THEN PLOT 1+IH,23+IV/2,"A ladder            ":IV=IV+1:IH=20-IH
 IF BR<=0 THEN PLOT 1+IH,23+IV/2,"Some brown bread    ":IV=IV+1:IH=20-IH
 IF TP<=0 THEN PLOT 1+IH,23+IV/2,"Some sticky tape    ":IV=IV+1:IH=20-IH
 IF GP<=0 THEN PLOT 1+IH,23+IV/2,"Some gunpowder      ":IV=IV+1:IH=20-IH
 IF TT<=0 THEN PLOT 1+IH,23+IV/2,"Some toilet tissue  ":IV=IV+1:IH=20-IH
 IF PT<=0 THEN PLOT 1+IH,23+IV/2,"Some petrol         ":IV=IV+1:IH=20-IH
 IF HP<=0 THEN PLOT 1+IH,23+IV/2,"A hose-pipe         ":IV=IV+1:IH=20-IH
 IF GL<=0 THEN PLOT 1+IH,23+IV/2,"A girl              ":IV=IV+1:IH=20-IH
 IF DG<=0 THEN PLOT 1+IH,23+IV/2,"A dead dog          ":IV=IV+1:IH=20-IH
 IF BB<=0 THEN PLOT 1+IH,23+IV/2,"Some broken glass   ":IV=IV+1:IH=20-IH
 IF BX<=0 THEN PLOT 1+IH,23+IV/2,"A cardboard box     ":IV=IV+1:IH=20-IH
 IF NE<=0 THEN PLOT 1+IH,23+IV/2,"A fishing net       ":IV=IV+1:IH=20-IH
 IF SB<=0 THEN PLOT 1+IH,23+IV/2,"A small bottle      ":IV=IV+1:IH=20-IH
 IF TN<=0 THEN PLOT 1+IH,23+IV/2,"A tobacco tin       ":IV=IV+1:IH=20-IH
 IF BM<=0 THEN PLOT 1+IH,23+IV/2,"A bomb              ":IV=IV+1:IH=20-IH
 IF LP<=0 THEN PLOT 1+IH,23+IV/2,"A loaded pistol     ":IV=IV+1:IH=20-IH
 IF FU<=0 THEN PLOT 1+IH,23+IV/2,"A fuse              ":IV=IV+1:IH=20-IH
 IC=IV
 IFIV<7THEN PLOT 1+IH,23+IV/2,"                    ":IV=IV+1:IH=20-IH  ' Erase the last element
 IFIV<7THEN PLOT 1+IH,23+IV/2,"                    ":IV=IV+1:IH=20-IH  ' Erase the last last element 
 RETURN


AlarmStartsRinging: 
 PRINT:PRINT"Alarm starts ringing"                
UpdateInventory: 
 GOSUB DisplayInventory:A$="L"
 N=0:S=0:E=0:W=0:U=0:D=0:PRINT:IT=0:RETURN  

VictoryFailureCheck: 
 IF AR=1 AND TM>19 THEN PRINT"You failed to silence the alarm":PRINT"in time and have been captured.":NM=NM*2:EC=EC_TRIPPED_THE_ALARM:GOTO ShowFinalScore 
 NM=NM+1:IF NM>499 THEN PRINT"You have made your 500 moves":EC=EC_RAN_OUT_OF_TIME:GOTO ShowFinalScore
 IFAR=1THENTM=TM+1
 RETURN

PlayerFailed: 
 POKE#26B,16+1 
 IFKD=1THENKL$="dog":EC=EC_MAIMED_BY_A_DOG:NM=NM*5:LOAD"242.BIN"
 IFKT=1THENKL$="thug":EC=EC_SHOT_BY_A_THUG:NM=NM*4    
 IFKE=1THENKL$="explosion":EC=EC_BLOWN_INTO_BITS:NM=NM*3
 IFGU=1THENPRINT"You were unable to complete your task":EC=EC_GAVE_UP:NM=NM*10
 IF(GU=1)AND(NM<502)THENNM=502
 IFGU=1THEN ShowFinalScore
 CLS:PRINT"You have been killed by the ";KL$:GOTO ShowFinalScore 

ShowFinalScore: 
 PRINT"Game score     ";P-NM" points":GOTO HandleHighScore
 
InitializeGraphicMode:          ' MIXED GRAPHIC MODE SETUP
 CLS:INK3:POKE#26A,10
 POKE #2C0,3:CURSET0,0,0:FILL 128,40,0:POKE #2C0,2   ' Briefly allow HIRES commands to fill the top half of screen in black and then revert back to TEXT

 POKE #BB80,31         ' Switch to HIRES
 POKE #A000+40*128,26  ' Switch to TEXT
 DOKE #278,48000+19*40 ' Address of second line of the screen
 DOKE #27A,48000+18*40 ' Address of first line of the screen
 DOKE #27C,6*40       ' Number of characters to scroll
 DOKE #27E,6          ' Number of lines of TEXT that can be scrolled
 POKE #BB80+40*16,16:POKE #BB80+40*16+1,6:POKE #BB80+40*17,6    ' CYAN on BLACK
 POKE #BB80+40*22,16:POKE #BB80+40*23,16
 POKE #BB80+40*24,16:POKE #BB80+40*25,16
 POKE #BB80+40*26,16:POKE #BB80+40*27,16
 POKE#26B,16+4:POKE#26C,3:CLS
 RETURN


AskPlayer:    ' Input box
 PLOT1,16+PEEK(#268),6:PRINTD$:PLOT1,16+PEEK(#268),2:PRINT">";
 Q$="":POKE#26A,11
 REPEAT
   GET K$
   IF K$="!" THEN Q$="!":K$=CHR$(13)
   IF K$=CHR$(127) AND (Q$<>"") THEN PRINT K$;:Q$=LEFT$(Q$,LEN(Q$)-1)
   IF K$=" " OR (K$>="A" AND K$<="Z") THEN Q$=Q$+K$:PRINT K$;
 UNTIL K$=CHR$(13) AND Q$<>""
 POKE#26A,10:PRINT
 RETURN


LoadPicture:               ' Location picture loading
 K$=STR$(A)+".BIN"
 IF (A=LOC_ENTRANCEHALL) AND (DG=A) THEN K$="24"+STR$(AV)+".BIN"
 IF (A=LOC_MASTERBEDROOM) AND (TG=A) THEN K$="34"+STR$(AL)+".BIN"
 SEARCH K$:IF EF=1 THEN LOAD K$ ELSE LOAD "NONE.BIN"
 RETURN


HandleHighScore:  ' High Scores check : "Game score     ";P-NM" points"
 LOAD"SCORES",N
 AD=#9C00
 FOR I=1 TO #18
   SC=DEEK(AD)-#8000
   IF SC<P-NM THEN InsertNewHighScore
   AD=AD+#13
 NEXT
 LOAD"DEMO":END

InsertNewHighScore:
 MOVE AD,#9DC8,AD+#13     ' Scroll old entries down
 DOKE AD,(P-NM)+#8000     ' Actual score
 POKE AD+2,EC             ' Ending condition
 D$="New highscore! Your name please?":GOSUB AskPlayer
 Q$="                "+Q$:L=LEN(Q$)
 FOR I=1 TO 16:C$=MID$(Q$,L-16+I,1):POKE AD+2+I,ASC(C$):NEXT
 SAVEO"SCORES",A#9C00,E#9DC8
 LOAD"DEMO"

DrawVectorItems:    ' Vector items drawing
 POKE #2C0,3   ' Allow HIRES graphical commands
 'POKE #21F,1
 POKE #213,255 ' Pattern
 REPEAT:READ C$:IF C$="C" THEN READ CX,CY:CURSET CX,CY,CL
   IF C$="D" THEN READ DX,DY:DRAW DX-CX,DY-CY,CL:CX=DX:CY=DY
 UNTIL C$=""
 'POKE #21F,0
 POKE #2C0,2   ' Allow TEXT specific commands
 RETURN


GraphicDataLadder:              ' Ladder
 DATA "C",130,88,"D",188,116
 DATA "C",123,89,"D",178,120
 DATA "C",127,91,"D",134,90
 DATA "C",132,94,"D",139,92
 DATA "C",139,98,"D",145,95
 DATA "C",144,101,"D",151,98
 DATA "C",149,104,"D",158,101
 DATA "C",155,107,"D",163,104
 DATA "C",162,111,"D",170,107
 DATA "C",168,114,"D",175,110
 DATA "C",173,117,"D",183,113
 DATA ""

GraphicDataLibraryBook:          ' Library Book
 DATA "C",163,95,"D",148,86,"D",148,82,"D",164,80,"D",177,87,"D",177,91,"D",163,95,"D",163,91,"D",148,82,"C",163,91,"D",177,87
 DATA "C",163,93,"D",177,89,"C",158,84,"D",163,83
 DATA ""


'
' Game start initialization 
' Was moved to the end to avoid the performance impact on the line count (GOTO search)
'
Initializations:      
 POKE#1A,96  ' Disable the READY message
 GOSUB InitializeGraphicMode

 ' Misc
 EC=EC_SIMPLY_VANISHED                  ' Ending condition
 ES$="                                       " ' 39 spaces

 ' Item location
 PL=LOC_ROAD
 BD=LOC_DARKTUNNEL
 KY=LOC_MAINSTREET
 YP=LOC_INSIDEHOLE
 BU=LOC_WELL:RO=LOC_WELL:WA=LOC_WELL
 PG=LOC_WOODEDAVENUE
 BX=LOC_GREENHOUSE:TW=LOC_GREENHOUSE
 KN=LOC_VEGSGARDEN
 NE=LOC_FISHPND
 LD=LOC_APPLE_TREES
 CR=LOC_TARMACAREA
 BL=LOC_DARKCELLARROOM:CP=LOC_DARKCELLARROOM
 ME=LOC_DININGROOM:BR=LOC_DININGROOM
 TN=LOC_LOUNGE
 DG=LOC_ENTRANCEHALL:AV=1
 TP=LOC_LIBRARY:BK=LOC_LIBRARY
 MA=LOC_KITCHEN
 CU=LOC_GAMESROOM
 SA=LOC_CELLAR
 NO=LOC_BOXROOM
 GL=LOC_GIRLROOM            ' Can't be accessed by the player (behind the steel door)
 TT=LOC_TINY_WC
 TG=LOC_MASTERBEDROOM:AL=1
 HP=LOC_ZENGARDEN
 
 ' Items not directly accessible (in safe, locked, need to be crafted, etc...)
 SB=99  ' Small bottle
 PT=99  ' Petrol
 GP=99  ' Gunpowder
 FU=99  ' Fuse
 PU=99  ' Pistol
 AB=99  ' Acid Burn
 BB=99  ' Broken Glass
 BM=99  ' Bomb
 LP=99  ' Loaded Pistol
 HD=99  ' Small hole in the door
 OS=99  ' Open Safe
 GF=99  ' Young girl
 PO=99  ' Open Panel
 GOTO LocationMarketPlace ' Fall-through

