#labels         ' Enable the usage of labels and automatic numbering
#optimize       ' Remove all comments, white spaces, etc... to make the code more compact


' Define the various items
#define Item_Reserved      			0          ' Reserved entry code
' Containers first
#define ItemBucket        			1          ' a wooden bucket
#define ItemCardboardBox  			2          ' a cardboard box
#define ItemFishingNet    			3          ' a fishing net
#define ItemPlasticBag    			4          ' a plastic bag
#define ItemTobaccoTin    			5          ' an empty tobacco tin
#define Item_Last_Container         5          ' ----- END CONTAINERS MARKER
' Then normal items
#define ItemBrokenWindow  			6          ' the window is broken
#define ItemOpenSafe  				7          ' an open safe
#define ItemBlackDust  				8          ' black dust
#define ItemOpenPanel  				9          ' an open panel on wall
#define ItemLockedPanel  			10          ' a locked panel on the wall
#define ItemYellowPowder  			11         ' gritty yellow powder
#define ItemSmallHoleInDoor 		12          ' a small hole in the door
#define ItemWater  					13          ' some water
#define ItemLargeDove  				14          ' a large dove
#define ItemTwine  					15          ' some twine
#define ItemSilverKnife  			16          ' a silver knife
#define ItemLadder  				17          ' a ladder
#define ItemAbandonedCar  			18          ' an abandoned car
#define ItemAlsatianDog  			19          ' Alsatian dog
#define ItemMeat  					20          ' a joint of meat
#define ItemBread  					21          ' some brown bread
#define ItemRollOfTape  			22          ' a roll of sticky tape
#define ItemChemistryBook  			23          ' a chemistry book
#define ItemBoxOfMatches  			24          ' a box of matches
#define ItemSnookerCue  			25          ' a snooker cue
#define ItemThug  					26          ' Thug'
#define ItemHeavySafe  				27          ' a heavy safe
#define ItemPrintedNote  			28          ' a printed note
#define ItemRope  					29          ' a length of rope
#define ItemRopeHangingFromWindow  	30          ' a rope hangs from the window
#define ItemRollOfToiletPaper  		31          ' a roll of toilet tissue~
#define ItemHosePipe  				32          ' a hose-pipe
#define ItemPetrol  				33          ' some petrol
#define ItemBrokenGlass  			34          ' broken glass
#define ItemAcidBurn  				35          ' an acid burn
#define ItemSmallBottle  			36          ' a small bottle
#define ItemFuse  					37          ' a fuse
#define ItemGunPowder  				38          ' some gunpowder
#define ItemKeys  					39          ' a set of keys
#define ItemNewspaper     			40          ' A newspaper
#define ItemBomb  					41          ' a bomb
#define ItemPistol 					42          ' a pistol
#define ItemBullets  				43          ' three .38 bullets
#define ItemYoungGirlOnFloor  		44          ' a young girl tied up on the floor
#define ItemYoungGirl  				45          ' a young girl

' End marker
#define ITEM_LAST 					45          '  ----- END MARKER

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
 ' CF(ItemBucket)  <- If container is full or not (contains the ID of the object in it)
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
 PRINT:PRINT"Don't be ridiculous":IF OL(ItemPetrol)=A THEN OL(ItemPetrol)=99  ' Empties the petrol...
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
 IF OL(ItemYoungGirlOnFloor)<=0THEN PRINT"and you have made it - WELL DONE":P=P+200:EC=1:GOTO ShowFinalScore ' Victory! 
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
 GOTO GT

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
 IF (LEFT$(A$,1)="N") AND (OL(ItemLadder)<=0) THEN PRINT"The ladder does not fit"
 GOTO GT

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
 IF (LEFT$(A$,1)="S") AND (OL(ItemLadder)<=0) THEN PRINT"The ladder does not fit"
 GOTO GT

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
 IF (AV=1) AND (DB=0) THEN PRINT:PRINT"AAAAAARRRGGGHHHH - he got you":KD=1:GOTO PlayerFailed
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
 FOR I=1 TO ITEM_LAST
   IF OL(I)=A THEN I$=I$+OD$(I)+"~m~j"
 NEXT

 PLOT 21-LEN(D$)/2,15,D$    ' Information bar with the name of the location
 PLOT 21-LEN(E$)/2,16,E$    ' Possible directions

 IF I$="" THEN PRINT"There is nothing of interest here~m~j" ELSE PRINT"I can see ";I$

 FR=FRE(0)   ' Garbage collection
 RETURN
 
RoomMovementDispatcher:
 GOSUB WhatAreYouGoingToDoNow:GOTO GT
 

WhatAreYouGoingToDoNow:           ' Ask the player for input
 GOSUB VictoryFailureCheck
AskHow:  
 IF AR=1 THENPLOT 20,26,1:PLOT 21,26,"Alarm"+STR$(20-TM)+CHR$(27)+"C"   ' Update the Alarm display
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

 ' Instruction dispatcher 
 INSTR"GET,DRO,THR,KIL,OPE,CLI,FRI,MAK,LOA,USE,REA,QUI,SHO,PRE,SYP,SIP,BLO,EXP",A$,1
 IF IN=0 OR LEN(A$)<>3THEN SkipInstr
 ON INT(IN/4)+1 GOTO ActionGet,ActionDrop,ActionThrow,ActionKill,ActionOpen,ActionClimb,ActionFrisk,ActionMake,ActionLoad,ActionUse,ActionRead,ActionQuit,ActionShoot,ActionPress,ActionSyphon,ActionSyphon,ActionBlow,ActionBlow

SkipInstr:
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

 FOR I=1 TO ITEM_LAST
   IF (OA$(I)=B$) AND (OL(I)=A) THEN FI=I:I=ITEM_LAST:NEXT:GOTO FoundItem
 NEXT I
'CantSeeItem: 
 PRINT:PRINT"I can't see ";BB$;" anywhere":GOTO WhatAreYouGoingToDoNow

FoundItem:  ' FI  contains the Found Item, can use OF$(FI) to check for FLAGS
 IF OC$(FI)<>"" THEN GetContainableProduct
 IF OF$(FI)="" THEN NoFlags
 INSTR OF$(FI),"H",1:IF IN<>0 THEN ErrorWeighsTooMuch      ' Things that are too heavy to move
NoFlags:
 ' Able to fetch it
 OL(FI)=0::GOTO UpdateInventory

 ' Items that can just be put in the inventory directly
 IF (B$="THU") AND (OL(ItemThug)=A) AND (AL=O) THEN PRINT:PRINT"He's too heavy":GOTO WhatAreYouGoingToDoNow
 IF (B$="THU") AND (OL(ItemThug)=A) AND (AL=1) THEN PRINT:PRINT"Not a good idea":GOTO WhatAreYouGoingToDoNow
 IF (B$="DOG") AND (OL(ItemAlsatianDog)=A) AND (AV=0) THEN OL(ItemAlsatianDog)=0:GOSUB LoadPicture:GOTO UpdateInventory
 IF (B$="DOG") AND (OL(ItemAlsatianDog)=A) AND (AV=1) THEN PRINT:PRINT"Not a good idea":GOTO WhatAreYouGoingToDoNow
 IF (B$="LIG") AND (A=LOC_DARKCELLARROOM) AND (OL(ItemOpenPanel)=A) THEN PRINT:PRINT"Bulb's too hot":GOTO WhatAreYouGoingToDoNow
 IF (B$="BED") AND ((A=LOC_GUESTBEDROOM) OR (A=LOC_CHILDBEDROOM) OR (A=LOC_MASTERBEDROOM)) THEN ErrorWeighsTooMuch
 IF (B$="GRE") AND (A=LOC_GREENHOUSE) THEN PRINT:PRINT"Don't be daft":GOTO WhatAreYouGoingToDoNow
 IF (B$="BUT") AND (A=LOC_DARKCELLARROOM) THEN PRINT:PRINT"Try pressing it":GOTO WhatAreYouGoingToDoNow
 IF (B$="WIN") AND (A=LOC_TILEDPATIO) THEN PRINT:PRINT"It's a bit too high":GOTO WhatAreYouGoingToDoNow
 IF (B$="PAN") AND (A=LOC_DARKCELLARROOM) THEN PRINT:PRINT"It's fixed to the wall"GOTO UpdateInventory
 IFQ$="BAG"THEN PRINT:PRINT"Sorry, it will suffocate":GOTO WhatAreYouGoingToDoNow
CantSeeItem: 
 PRINT:PRINT"I can't see ";BB$;" anywhere":GOTO WhatAreYouGoingToDoNow


GetContainableProduct:    ' Get dust/water/petrol/dove/powder
 D$="Carry it in what?":GOSUB AskPlayer:QQ$=Q$:Q$=LEFT$(QQ$,3)
 ' Find the container number:
 CN=0
 IF (Q$="BUC") THEN CN=ItemBucket:IF (OL(ItemBucket)>0) THEN ErrorNotCarryingOne
 IF (Q$="BOX") THEN CN=ItemCardboardBox:IF (OL(ItemCardboardBox)>0) THEN ErrorNotCarryingOne
 IF (Q$="BAG") THEN CN=ItemPlasticBag:IF (OL(ItemPlasticBag)>0) THEN ErrorNotCarryingOne
 IF (Q$="TIN") THEN CN=ItemTobaccoTin:IF (OL(ItemTobaccoTin)>0) THEN ErrorNotCarryingOne
 IF (Q$="NET") THEN CN=ItemFishingNet:IF (OL(ItemFishingNet)>0) THEN ErrorNotCarryingOne
 IF (Q$="BOT") THEN IF (OL(ItemSmallBottle)>0) THEN ErrorNotCarryingOne ELSE ErrorBottleFull

 ' Check if it already contains something
 IF CF(CN) THEN ErrorSorryThatsFull
 INSTR OC$(FI),Q$,1:IF IN=0 THEN MessageDontBeRidiculous
 CF(CN)=FI:OL(FI)=-CN:GOTO UpdateInventory


ActionDrop: 
 FOR I=1 TO ITEM_LAST
   IF (OA$(I)=B$) AND (OL(I)<=0) THEN FI=I:I=ITEM_LAST:NEXT:GOTO FoundItemToDrop
 NEXT I
 PRINT:PRINT"Don't have ";BB$;" - check inventory":GOTO WhatAreYouGoingToDoNow

FoundItemToDrop: ' FI  contains the Found Item, can use OF$(FI) to check for FLAGS
 IF FI<=Item_Last_Container THEN I=CF(FI):OL(FI)=A:CF(FI)=0:FI=I   ' Put the container on the location, while keeping track of the eventual content
 IF FI<=0 THEN UpdateInventory
 ' Special case for Water and Petrol that evaporates/disappear when dropped
 IF FI=ItemWater THEN OL(FI)=LOC_WELL:PRINT:PRINT"The water drains away":GOTO UpdateInventory
 IF FI=ItemPetrol THEN OL(FI)=99:PRINT:PRINT"The petrol evaporates":GOTO UpdateInventory
 OL(FI)=A:GOTO UpdateInventory

ActionThrow: 
 IF (B$="MEA") AND (OL(ItemMeat)<=0) THEN ThrowMeat
 IF (B$="BRE") AND (OL(ItemBread)<=0) THEN ThrowBread
 IF (B$="CUE") AND (OL(ItemSnookerCue)<=0) THEN ThrowCue
 IF (B$="BOT") AND (OL(ItemSmallBottle)<=0) THEN ThrowBottle
 IF (B$="KNI") AND (OL(ItemSilverKnife)<=0) THEN ThrowKnife
 IF (B$="ROP") AND (OL(ItemRope)<=0) THEN ThrowRope
 IF (B$="GLA") AND (OL(ItemBrokenGlass)<=0) THEN PRINT:PRINT"The fragments are too small to throw":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Use the DROP command":GOTO WhatAreYouGoingToDoNow

ThrowMeat: 
 IF (OL(ItemAlsatianDog)=A) AND (AV=1) THEN PRINT:PRINT"Dog eats meat":OL(ItemMeat)=99:DB=99:P=P+25:GOTO UpdateInventory
 OL(ItemMeat)=A:GOTO UpdateInventory

ThrowBread:
 IFPG=ATHEN PRINT:PRINT"Dove eats the bread":OL(ItemBread)=99:GOTO UpdateInventory
 IF (OL(ItemAlsatianDog)=A) AND (AV=1) THEN PRINT:PRINT"Dog sniffs bread - he is not happy"         
 OL(ItemBread)=A:GOTO UpdateInventory

ThrowCue:
 IF OL(ItemAlsatianDog)=A THEN PRINT:PRINT"You have speared the dog":OL(ItemSnookerCue)=A:GOTO KilledTheDog
 IF (A=LOC_TILEDPATIO) AND (WB=LOC_TILEDPATIO) THEN EndThrowCue
 IF A=LOC_TILEDPATIO THEN POKE#26B,16+1:PRINT:PRINT"The cue smashes the window":OL(ItemSnookerCue)=LOC_PADLOCKED_ROOM:WB=LOC_TILEDPATIO:AR=1:GOTO AlarmStartsRinging
EndThrowCue: 
 OL(ItemSnookerCue)=A:GOTO UpdateInventory

ThrowKnife:
 IF OL(ItemAlsatianDog)=A THEN PRINT:PRINT"You have killed the dog":P=P+50:OL(ItemSilverKnife)=A:GOTO KilledTheDog
 IF (OL(ItemYoungGirlOnFloor)=A) AND (OL(ItemSmallHoleInDoor)=A) THEN PRINT:PRINT"Girl cuts her bonds":OL(ItemSilverKnife)=A:OL(ItemYoungGirlOnFloor)=99:OL(ItemYoungGirl)=A
 OL(ItemSilverKnife)=A
 IF OL(ItemRope)=LOC_PADLOCKED_ROOM THEN GirlSlidesDownRope
 GOTO UpdateInventory

KilledTheDog:
 OD$(ItemAlsatianDog)="the body of an alsatian dog"
 AV=0:P=P+50:GOSUB LoadPicture:GOTO UpdateInventory

ThrowBottle:
 IFA<>39THEN MessageFunnySmell
 PRINT:PRINT"Acid in the bottle burns small hole in the door":P=P+200
 OL(ItemSmallBottle)=99:OL(ItemYoungGirlOnFloor)=LOC_PADLOCKED_ROOM:OL(ItemSmallHoleInDoor)=LOC_PADLOCKED_ROOM:OL(ItemBrokenGlass)=LOC_PADLOCKED_ROOM:GOTO UpdateInventory

ThrowRope:
 IF (A<>LOC_PADLOCKED_ROOM) AND (OL(ItemSmallHoleInDoor)<>LOC_PADLOCKED_ROOM) THEN OL(ItemRope)=A:GOTO UpdateInventory
 IF OL(ItemYoungGirl)<>LOC_PADLOCKED_ROOM THEN OL(ItemRope)=A:GOTO UpdateInventory
GirlSlidesDownRope:
 IF WB=0 THEN PRINT:PRINT"Girl breaks window and slides down rope"
 IF WB=0 THEN PRINT:PRINT"Alarm starts ringing":WB=LOC_TILEDPATIO:PLAY3,2,4,1:GOTO RingRing
 IF WB=8 THEN PRINT:PRINT"Girl climbs out of window and down rope":GOTO WhatAreYouGoingToDoNow
 OL(ItemRope)=LOC_PADLOCKED_ROOM:GOTO UpdateInventory
RingRing:
 OL(ItemYoungGirl)=LOC_TILEDPATIO:OL(ItemRopeHangingFromWindow)=LOC_TILEDPATIO:OL(ItemRope)=LOC_TILEDPATIO:AR=1:P=P+100:GOTO WhatAreYouGoingToDoNow
RingRingUnused:
 OL(ItemYoungGirl)=LOC_TILEDPATIO:OL(ItemRopeHangingFromWindow)=LOC_TILEDPATIO:OL(ItemRope)=LOC_TILEDPATIO:P=P+100:GOTO WhatAreYouGoingToDoNow

 ' Open
ActionOpen: 
 IF (B$="DOO") AND (A=LOC_PADLOCKED_ROOM) THEN MessageLocked
 IF (B$="WIN") AND (A=LOC_TILEDPATIO) THEN PRINT:PRINT"It's thirty feet up":GOTO WhatAreYouGoingToDoNow
 IF (B$="BOT") AND (OL(ItemSmallBottle)<=0) THEN PRINT:PRINT"The screw cap is stuck":GOTO WhatAreYouGoingToDoNow
 IF (B$="CAR") AND (A=LOC_TARMACAREA) THEN PRINT:PRINT"Nothing. Try the trunk":GOTO WhatAreYouGoingToDoNow
 IF (B$="TRU") AND (A=LOC_TARMACAREA) THEN PRINT:PRINT"Nothing here, either":GOTO WhatAreYouGoingToDoNow
 IF (B$="TIN") AND (CF(ItemTobaccoTin)=0) AND (OL(ItemTobaccoTin)<=0) THEN PRINT:PRINT"Nothing inside":GOSUB WhatAreYouGoingToDoNow
 IF (B$="TIN") AND (CF(ItemTobaccoTin)=1) AND (OL(ItemTobaccoTin)<=0) THEN PRINT:PRINT"Okay, it's open":GOSUB WhatAreYouGoingToDoNow
 IF (B$="TAN") AND (A=LOC_TARMACAREA) AND (PA=1) THEN PRINT:PRINT"It's already open":GOSUB WhatAreYouGoingToDoNow 
 IF (B$="TAN") AND (A=LOC_TARMACAREA) THEN PA=1:PRINT:PRINT"Okay, it's open":GOTO WhatAreYouGoingToDoNow
 IF (B$="SAF") AND (A=LOC_CELLAR) AND (OL(ItemOpenSafe)=99) THEN MessageLocked
 IF (B$="SAF") AND (A=LOC_CELLAR) AND (OL(ItemOpenSafe)=LOC_CELLAR) THEN MessageOpen
 IF (B$="PAN") AND (A=LOC_DARKCELLARROOM) AND (OL(ItemOpenPanel)=LOC_DARKCELLARROOM) THEN MessageOpen
 IF (B$="PAN") AND (A=LOC_DARKCELLARROOM) THEN MessageLocked
 IF (B$="BOX") AND (CF(ItemCardboardBox)=0) AND (OL(ItemCardboardBox)<=0) THEN PRINT:PRINT"Nothing inside":GOTO WhatAreYouGoingToDoNow
 IF (B$="BOX") AND (CF(ItemCardboardBox)=1) AND (OL(ItemCardboardBox)<=0) THEN MessageOpen
 GOTO ErrorEh

ActionClimb: 
 IF (B$="WAL") AND (A=LOC_TILEDPATIO) THEN MessageTooSteep
 IF (B$="WAL") AND (A=LOC_INSIDEHOLE) THEN MessageTooSteep
 IF (B$="LAD") AND (AD>0) THEN PRINT:PRINT"You have no ladder":GOTO WhatAreYouGoingToDoNow
 IF (B$="LAD") AND (A=LOC_TILEDPATIO) THEN PRINT:PRINT"Ladder is too short":GOTO WhatAreYouGoingToDoNow
 IF (B$="LAD") AND (A=LOC_INSIDEHOLE) THEN PRINT:PRINT"You are out":OL(ItemLadder)=LOC_INSIDEHOLE:OP=1:GOSUB DisplayInventory
 IF OP=1 THEN A=LOC_NARROWPATH:RETURN
 GOTO ErrorCantDoThat

ActionFrisk: 
 IF (B$="GIR") AND (OL(ItemYoungGirlOnFloor)<=0) THEN PRINT:PRINT"Shame on you":GOTO WhatAreYouGoingToDoNow
 IF B$="THU" THEN FriskThug
 PRINT:PRINT"I don't understand":GOTO WhatAreYouGoingToDoNow
FriskThug: 
 IF FK=1 THEN PRINT:PRINT"You've already frisked him":GOTO WhatAreYouGoingToDoNow
 IF AL=1 THEN PRINT:PRINT"I should subdue him first":GOTO WhatAreYouGoingToDoNow
 PRINT"I've found a pistol. It is not loaded":OL(ItemPistol)=A:FK=1:P=P+50:GOTO WhatAreYouGoingToDoNow
 
ActionKill: 
 IF (B$="DOG") AND (A=LOC_ENTRANCEHALL) AND (AV=1) THEN MessageGoodIdea
 IF (B$="GIR") AND (OL(ItemYoungGirlOnFloor)<=0) THEN MessageDontThinkSo
 IF (B$="DOV") AND (OL(ItemLargeDove)<=0) THEN MessageNoViolence
 IF (B$="THU") AND (A=LOC_MASTERBEDROOM) AND (AL=1) THEN PRINT:PRINT"I'm game. How":GOTO KillThug
 GOTO ErrorEh

KillThug: 
 PRINT:INPUTRR$:R$=LEFT$(RR$,3)
 PRINT:PRINT"With what ?":PRINT:INPUTSS$:S$=LEFT$(SS$,3)
 IF R$="STR" THEN M$="CROAK":O$="TWI,ROP,HOS":GOTO DoTryKillThug
 IF R$="STA" THEN M$="Messy":O$="KNI,CUE":GOTO DoTryKillThug
 IF R$="HIT" THEN M$="KRUNCH":O$="CUE":GOTO DoTryKillThug
 IF R$="SUF" THEN M$="G-A-S-P !!!":O$="BAG":GOTO DoTryKillThug
ThugWakesUp: 
 ' Failure leads to death...
 WAIT 50:PRINT:PRINT"You managed to wake him - he's not happy- he approaches.......":LOAD"342.BIN"
 WAIT 50:PRINT"**BANG**   you are dead":SHOOT:KT=1:GOTO PlayerFailed 

DoTryKillThug:
 INSTR O$,S$,1
 IF IN=0 OR LEN(S$)<>3 THEN ThugWakesUp
 FOR I=1 TO ITEM_LAST
   IF OA$(I)=S$ THEN FI=I:I=ITEM_LAST
 NEXT
 IF FI=ItemPlasticBag AND CF(ItemPlasticBag)>0 THEN PRINT:PRINT"Your bag is full":GOTO ThugWakesUp
 IF OL(FI)>0 THEN MessageDontHaveAny
 OL(FI)=A
 OD$(ItemThug)="a thug lying dead on the bed"
 PRINT:PRINT M$
 LOAD"340.BIN"
 AL=0:P=P+50:GOSUB DisplayInventory:GOTO WhatAreYouGoingToDoNow


ActionMake: 
 IF B$="GUN" THEN ActionMakeGunpowder
 IF B$="FUS" THEN ActionMakeFuse
 IF B$="BOM" THEN ActionMakeBomb
 IF B$="NOI" THEN PRINT"I'd keep quiet if I were you":GOTO WhatAreYouGoingToDoNow
 GOTO ErrorCantDoThat

ActionMakeGunpowder:                                   ' ItemYellowPowder + ItemBlackDust = ItemGunPowder
 IF (OL(ItemYellowPowder)>0) OR (OL(ItemBlackDust)>0) THEN ErrorCantDoThat 
 CF(-OL(ItemYellowPowder))=0:CF(-OL(ItemBlackDust))=0:OL(ItemYellowPowder)=99:OL(ItemBlackDust)=99:OL(ItemGunPowder)=A:PRINT:PRINT"Okay, gunpowder ready":P=P+100:GOSUB:UpdateInventory:GOTO WhatAreYouGoingToDoNow

ActionMakeFuse:                                        ' ItemRollOfToiletPaper + ItemPetrol = ItemFuse
 IF (OL(ItemRollOfToiletPaper)>0) OR (OL(ItemPetrol)>0) THEN ErrorCantDoThat 
 CF(-OL(ItemPetrol))=0:OL(ItemRollOfToiletPaper)=99:OL(ItemPetrol)=99:OL(ItemFuse)=A:PRINT:PRINT"Okay, fuse ready":P=P+100:GOSUB:UpdateInventory:GOTO WhatAreYouGoingToDoNow

ActionMakeBomb:                                        ' ItemFuse + ItemGunPowder + ItemTobaccoTin = ItemBomb
 IF (OL(ItemFuse)>0) OR (OL(ItemGunPowder)>0) OR (OL(ItemTobaccoTin)>0) THEN ErrorCantDoThat
 OL(ItemFuse)=99:OL(ItemGunPowder)=99:OL(ItemTobaccoTin)=99:OL(ItemBomb)=A:PRINT:PRINT"Bomb ready":P=P+200:GOSUB:UpdateInventory:GOTO WhatAreYouGoingToDoNow
 
ActionSyphon:   ' Syphon petrol with the hose
 IF B$<>"PET" THEN ErrorEh
 IF (PA=0)OR(A<>11) THEN ErrorCantDoThat
 PRINT:PRINT"What shall I use?"
 PRINT:INPUTS$:IFLEFT$(S$,3)<>"HOS"THEN ErrorCantDoThat
 IFHP<>0THEN PRINT:PRINT"You don't have one":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Okay":OL(ItemPetrol)=A:OL(ItemHosePipe)=A:GOTO GetContainableProduct

ActionLoad:     ' Load pistol
 IFB$<>"PIS"THEN ErrorCantDoThat
 IF (OL(ItemPistol)<>0) OR (OL(ItemBullets)<>0) THEN ErrorCantDoThat
 IF LP=1 THEN PRINT:PRINT"It's already loaded":GOTO WhatAreYouGoingToDoNow
 OD$(ItemPistol)="a loaded pistol":LP=1:OL(ItemBullets)=99:PRINT:PRINT"Okay":GOTO WhatAreYouGoingToDoNow
 
ActionBlow:    ' Blow things open
 IF (B$="SAF") AND (OL(ItemOpenSafe)=LOC_CELLAR) THEN PRINT:PRINT"It's already open":GOTO WhatAreYouGoingToDoNow
 IF (B$<>"SAF") AND (B$<>"DOO") THEN ErrorCantDoThat
 IF (B$="SAF") AND (A<>LOC_CELLAR) THEN PRINT:PRINT"I can't see a safe":GOTO WhatAreYouGoingToDoNow
 IF (B$="DOO") AND (A<>LOC_PADLOCKED_ROOM) THEN PRINT:PRINT"I can't see a door":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Using what ?":PRINT:INPUTZZ$:Z$=LEFT$(ZZ$,3) 
 IFZ$="GUN"THEN BlowWithGun
 IFZ$="BOM"THEN BlowWithBomb
 GOTO ErrorEh
BlowWithGun:
 IFGP<>0THEN PRINT:PRINT"You don't have any":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Okay, how shall we light it?"
 PRINT:INPUTXX$:X$=LEFT$(XX$,3)
 IF (X$="MAT") AND (OL(ItemBoxOfMatches)=0) THEN OL(ItemBoxOfMatches)=99:OL(ItemGunPowder)=99:GOTO DoBlow
 IF (X$="PIS") AND (OL(ItemPistol)=0) AND (LP=0) THEN PRINT:PRINT"CLICK  it isn't loaded":GOTO WhatAreYouGoingToDoNow
 IF (X$="PIS") AND (OL(ItemPistol)=0) AND (LP=1) THEN LP=0:OL(ItemGunPowder)=99:OD$(ItemPistol)="a pistol":GOTO DoBlow
 GOTO ErrorLetsTryAgain

DoBlow:
 PRINT:PRINT"****B*O*O*O*M*M*M****":EXPLODE
 IFX$="MAT"THEN PRINT:PRINT"You have been blown to bits":KE=1:GOTO PlayerFailed
 IFX$="PIS"THEN PRINT:PRINT"Lots of smoke but unsuccessful":GOTO PlayerFailed

BlowWithBomb: 
 IFBM<>0THEN PRINT:PRINT"You don't have a bomb":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Okay, how shall we light it?"
 PRINT:INPUTXX$:X$=LEFT$(XX$,3)
 IF (X$="MAT") AND (OL(ItemBoxOfMatches)=0) THENMA=99:OL(ItemBomb)=99:GOTO DoBlowDoor
 IF (X$="PIS") AND (OL(ItemPistol)=0) AND (LP=1) THEN LP=0:PI=0:OL(ItemGunPowder)=99:OD$(ItemPistol)="a pistol":QZ=1
 IF QZ=1 THEN QZ=0:PRINT:PRINT"*BANG*BANG*BANG*":GOTO DoBlowDoor
 IF (X$="PIS") AND (OL(ItemPistol)=0) AND (LP=0) THEN PRINT:PRINT"CLICK  it isn't loaded":GOTO WhatAreYouGoingToDoNow
 GOTO ErrorLetsTryAgain
DoBlowDoor:
 PRINT:PRINT"****B*O*O*O*M*M*M****":EXPLODE  
 IFB$="DOO"THEN PRINT:PRINT"The door is untouched":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"The safe is open":OL(ItemSmallBottle)=A:OL(ItemHeavySafe)=99:OL(ItemOpenSafe)=LOC_CELLAR:P=P+200:GOSUB:UpdateInventory:GOTO WhatAreYouGoingToDoNow

ActionUse: 
 IF B$<>"KEY" THEN ErrorCantDoThat
 IF OL(ItemKeys)<>0 THEN MessageDontHaveItem
 IF (A=LOC_PADLOCKED_ROOM) OR (A=LOC_CELLAR) OR (A=LOC_TARMACAREA) THEN MessageKeyDontFit
 IF A=LOC_DARKCELLARROOM THEN PanelIsOpen
 PRINT:PRINT"I don't understand":GOTO WhatAreYouGoingToDoNow

MessageKeyDontFit: 
 PRINT:PRINT"The keys don't fit":GOTO WhatAreYouGoingToDoNow

PanelIsOpen: 
 PRINT:PRINT"It's open"
 PRINT:PRINT"I see lots of lights and a red button" 
 OL(ItemKeys)=LOC_DARKCELLARROOM:OL(ItemLockedPanel)=99:OL(ItemOpenPanel)=LOC_DARKCELLARROOM:GOTO WhatAreYouGoingToDoNow

ActionRead: 
 IFB$<>"NOT"THEN ReadBook
 IF (OL(ItemPrintedNote)<>0) AND (OL(ItemPrintedNote)<>A) THEN MessageDontHaveItem
 PRINT:PRINT"I moved all your dangerous chemical":PRINT"products to the basement's safe - DAD":GOTO WhatAreYouGoingToDoNow
ReadBook:
 IFB$<>"BOO"THEN ErrorEh
 IF (OL(ItemChemistryBook)<>0) AND (OL(ItemChemistryBook)<>A) THEN MessageDontHaveItem
 PRINT:PRINT"...making fuses... salpeter... explosive... acide and steel... Complicated stuff!":GOTO WhatAreYouGoingToDoNow

ActionQuit: 
 PRINT:PRINT"Giving up ???? - are you sure ?"
 REPEAT
   K$=KEY$:IFK$="Y"THENGU=1:GOTO PlayerFailed
 UNTIL K$="N"
 GOTO UpdateInventory

ActionShoot: 
 IF LP=0 THEN PRINT:PRINT"CLICK   it isn't loaded":GOTO WhatAreYouGoingToDoNow
 IF (OL(ItemPistol)>0) THEN PRINT:PRINT"You have no gun":GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"*BANG*BANG*BANG*":LP=0:SHOOT:WAIT25:SHOOT:WAIT25:SHOOT
 IF (A=LOC_ENTRANCEHALL) AND (AV=1) THEN PRINT:PRINT"The dog is dead":P=P+50:AV=0
 GOTO WhatAreYouGoingToDoNow

ActionPress: 
 IFB$<>"BUT"THEN PRINT:PRINT"Press what ?":GOTO WhatAreYouGoingToDoNow
 IF (OL(ItemOpenPanel)<>20)OR(A<>20) THEN CantSeeItem
 IFAR=1THENPOKE#26B,16+4:PLOT 21,26,"        ":PRINT:PRINT"Alarm stops ringing":PING:AR=0:P=P+200:GOTO WhatAreYouGoingToDoNow
 PRINT:PRINT"Oh - nothing happened":GOTO WhatAreYouGoingToDoNow
 

 

DisplayInventory:    ' We display the user's inventory, but also coumt how many items it has
 IV=0:IH=0
 FOR I=1 TO ITEM_LAST
   IF OL(I)<=0 THEN PLOT 1+IH,23+IV/2,OD$(I)+LEFT$(ES$,20-LEN(OD$(I))):IV=IV+1:IH=20-IH
 NEXT
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
 IFGU=1THEN PRINT"You were unable to complete your task":EC=EC_GAVE_UP:NM=NM*10
 IF (GU=1) AND (NM<502) THENNM=502
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
 IF (A=LOC_ENTRANCEHALL) AND (OL(ItemAlsatianDog)=A) THEN K$="24"+STR$(AV)+".BIN"
 IF (A=LOC_MASTERBEDROOM) AND (OL(ItemThug)=A) THEN K$="34"+STR$(AL)+".BIN"
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
 AV=1  ' Dog is ALIVE
 AL=1  ' Thug is ALIVE
 EC=EC_SIMPLY_VANISHED                  ' Ending condition
 ES$="                                       " ' 39 spaces

 !RESTORE ItemList
 
 DIM OL(ITEM_LAST)            ' Object Location
 DIM OD$(ITEM_LAST)           ' Object Description
 DIM OA$(ITEM_LAST)           ' Object Abreviation
 DIM OF$(ITEM_LAST)           ' Object Flags
 DIM OC$(ITEM_LAST)           ' Object Container List (Where the object can be stored)
 REPEAT
    READ I
    IF I>=0 THEN READ OA$(I),OD$(I),OL(I),OF$(I),OC$(I)
 UNTIL I<0

 GOTO LocationMarketPlace ' Fall-through
' OL(ITEM_PA)'

' Flags:
' - H = HEAVY (Can't be moved)
' - D = DESTROYED/DISAPPEAR on DROP (water drains out, petrol evaporates)
'
' Fisc status variables:
' - LP = Loaded Pistol
' - PU
' - QZ
'
ItemList:
 ' Containers
 DATA ItemBucket,"BUC","a wooden bucket",LOC_WELL,"",""
 DATA ItemCardboardBox,"BOX","a cardboard box",LOC_GREENHOUSE,"",""
 DATA ItemFishingNet,"NET","a fishing net",LOC_FISHPND,"",""
 DATA ItemPlasticBag,"BAG","a plastic bag",LOC_MARKETPLACE,"",""                       ' LOC_ROAD
 DATA ItemTobaccoTin,"TIN","an empty tobacco tin",LOC_LOUNGE,"",""
 ' Item location
 DATA ItemNewspaper,"NEW","a newspaper",LOC_MARKETPLACE,"",""
 DATA ItemLockedPanel,"PAN","a locked panel on the wall",LOC_DARKCELLARROOM,"",""
 DATA ItemTwine,"TWI","some twine",LOC_GREENHOUSE,"",""
 DATA ItemSilverKnife,"KNI","a silver knife",LOC_VEGSGARDEN,"",""
 DATA ItemLadder,"LAD","a ladder",LOC_APPLE_TREES,"",""
 DATA ItemAbandonedCar,"CAR","an abandoned car",LOC_TARMACAREA,"H",""
 DATA ItemBullets,"BUL","three .38 bullets",LOC_DARKCELLARROOM,"",""
 DATA ItemMeat,"MEA","a joint of meat",LOC_DININGROOM,"",""
 DATA ItemBread,"BRE","some brown bread",LOC_DININGROOM,"",""
 DATA ItemRollOfTape,"TAP","a roll of sticky tape",LOC_LIBRARY,"",""
 DATA ItemChemistryBook,"BOO","a chemistry book",LOC_LIBRARY,"",""
 DATA ItemBoxOfMatches,"MAT","a box of matches",LOC_KITCHEN,"",""
 DATA ItemSnookerCue,"CUE","a snooker cue",LOC_GAMESROOM,"",""                         '  IF (OL(ItemSnookerCue)=LOC_GIRLROOM) AND (OL(ItemSmallHoleInDoor)=LOC_PADLOCKED_ROOM) THEN I$=I$+"a cue on the floor~m~j"
 DATA ItemHeavySafe,"SAF","a heavy safe",LOC_CELLAR,"H",""
 DATA ItemPrintedNote,"NOT","a printed note",LOC_BOXROOM,"",""
 DATA ItemYoungGirlOnFloor,"GIR","a young girl tied up on the floor",LOC_GIRLROOM,"",""
 DATA ItemRollOfToiletPaper,"TIS","a roll of toilet tissue" ,LOC_TINY_WC,"",""
 DATA ItemHosePipe,"HOS","a hose-pipe",LOC_ZENGARDEN,"",""
 DATA ItemRope,"ROP","a length of rope",LOC_WELL,"",""
 DATA ItemKeys,"KEY","a set of keys",LOC_MAINSTREET,"",""
 DATA ItemAlsatianDog,"DOG","an alsatian growling at you",LOC_ENTRANCEHALL,"",""
 DATA ItemThug,"THU","a thug asleep on the bed",LOC_MASTERBEDROOM,"H",""
 ' Items requiring a container
 DATA ItemYellowPowder,"POW","gritty yellow powder",LOC_INSIDEHOLE,"","BUC,BOX,BAG,TIN"
 DATA ItemBlackDust,"DUS","black dust",LOC_DARKTUNNEL,"","BUC,BOX,BAG,TIN"
 DATA ItemWater,"WAT","some water",LOC_WELL,"D","BUC,BAG,TIN"
 DATA ItemLargeDove,"DOV","a large dove",LOC_WOODEDAVENUE,"","BUC,BOX,NET"
 DATA ItemGunPowder,"GUN","some gunpowder",99,"","BUC,BOX,BAG,TIN"
 DATA ItemPetrol,"PET","some petrol",99,"D","BUC,BAG,TIN"
 ' Items not directly accessible (in safe, locked, need to be crafted, etc...)
 DATA ItemFuse,"FUS","a fuse",99,"",""
 DATA ItemPistol,"PIS","a pistol",99,"",""
 DATA ItemBomb,"BOM","a bomb",99,"",""
 DATA ItemBrokenGlass,"GLA","broken glass",99,"",""
 DATA ItemSmallBottle,"BOT","a small bottle",99,"",""
 DATA ItemBrokenWindow,"...","the window is broken",99,"",""
 DATA ItemOpenSafe,"...","an open safe",99,"H",""
 DATA ItemAcidBurn,"...","an acid burn",99,"",""
 DATA ItemYoungGirl,"...","a young girl",99,"",""
 DATA ItemOpenPanel,"...","an open panel on wall",99,"",""
 DATA ItemSmallHoleInDoor,"...","a small hole in the door",99,"",""
 DATA ItemRopeHangingFromWindow,"...","a rope hangs from the window",99,"",""
 
 DATA -1

