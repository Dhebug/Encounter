;Rooms.s

;TERMINAL_	
;SOFA	
;FIREPLACE
;TOILET   
;DRAWERS  
;ARMCHAIR 
;DESK     
;BED      
;SINK     
;BATH     
;BOOKCASE 
;CANDY    
;SPEAKER  
;HIFI     
;LAMP     
;COMPUTER 
;TAPESTREAMER
;HARDDISK    
;HARDDISK2   
;TAPESTREAMER
;FAGDISPENSER 
;TELEX        
;FILINGCABINET
;DOORWAY      
;SIMONCONSOLE

;By default (Template) the room consists of bg and walls
;A list is constructed for each room which contains headers and data.
;Header..		Data
;END		!
;PLATFORM		X(1 or 39),Y(Platform 0-7),Length(1 or 39)
;LIFTSHAFT	G(0-7),X(1-39),S(Bitmap)
;LIFTPLATFORMS	G(0-7),DL(Bitmap),CL(Bitmap)
;FURNITURE_	X(1 or 39),Y(Platform 0-7),FurnitureID(plundered(+128) puzzlepiece(+64))
;DROID		X(1 or 39),Y(Platform 0-7),Length of Rail(1-39),Type(0-15)
;ENTRANCE		X(1 or 39),Y(0-7)
;OBJECT		X(1-39),Y(0-199),ObjectID
;REPEATOBJECT	X(1-39),Y(0-199),ObjectID,Direction(0-1),Repeats(0-199)

;If we crunched, we could reduce X res to 0-31 then hold xy in single byte
;PLATFORM		X(1 or 39),Y(Platform 0-7),Length(1 or 39)
;LIFTSHAFT	G(0-7),X(1-39),S(Bitmap)
;LIFTPLATFORMS	G(0-7),DL(Bitmap),CL(Bitmap)
;			DL/CL in single byte
;FURNITURE_	X(1 or 39),Y(Platform 0-7),FurnitureID(plundered(+128) puzzlepiece(+64))
;DROID		X(1 or 39),Y(Platform 0-7),Length of Rail(1-39),Type(0-15)
;ENTRANCE		X(1 or 39),Y(0-7)
;OBJECT		X(1-39),Y(0-199),ObjectID
;REPEATOBJECT	X(1-39),Y(0-199),ObjectID,Direction(0-1),Repeats(0-199)


;#define	OBJ_TLSIMONBORDER		0
;#define	OBJ_TSIMONBORDER              1
;#define	OBJ_TRSIMONBORDER             2
;#define	OBJ_LSIMONBORDER              3
;#define	OBJ_RSIMONBORDER              4
;#define	OBJ_BLSIMONBORDER             5
;#define	OBJ_BSIMONBORDER              6
;#define	OBJ_BRSIMONBORDER             7
;#define	OBJ_SIMONBLACKCELL            8
;#define	OBJ_SIMONWHITECELL            9
;#define	OBJ_SIMONHIGHLIGHTEDCELL      10
;#define	OBJ_SIMONMARKEDCELL           11

Room_08	;Code Room(Simon Computer)
 .byt ENTRANCE
 .byt 1,1,0
;Display Top Border
 .byt OBJECT	;Display Top left simon border
 .byt 10,64
 .byt OBJ_TLSIMONBORDER
 
 .byt REPEATOBJECT	;Display Top simon border
 .byt 12,64
 .byt OBJ_TSIMONBORDER
 .byt REPEATOBJECTRIGHT
 .byt 16
 
 .byt OBJECT	;Display Top right simon border
 .byt 28,64
 .byt OBJ_TRSIMONBORDER
;Display left side border
 .byt REPEATOBJECT
 .byt 10,68
 .byt OBJ_LSIMONBORDER
 .byt REPEATOBJECTDOWN
 .byt 24
;Display right side border 
 .byt REPEATOBJECT
 .byt 28,68
 .byt OBJ_RSIMONBORDER
 .byt REPEATOBJECTDOWN
 .byt 24
;Display Bottom left border
 .byt OBJECT
 .byt 10,115
 .byt OBJ_BLSIMONBORDER
;Display Bottom border 
 .byt REPEATOBJECT
 .byt 12,115
 .byt OBJ_BSIMONBORDER
 .byt REPEATOBJECTRIGHT
 .byt 16
;Display Bottom right border
 .byt OBJECT
 .byt 28,115
 .byt OBJ_BRSIMONBORDER
;Display Black cells in all entries
 .byt REPEATOBJECT
 .byt 12,68
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 8
 .byt REPEATOBJECT
 .byt 12,80
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 8
 .byt REPEATOBJECT
 .byt 12,92
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 8
 .byt REPEATOBJECT
 .byt 12,104
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 8
;Display alt blocks with White cells
 .byt OBJECT	;1,0
 .byt 14,68
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;3,0
 .byt 18,68
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;5,0
 .byt 22,68
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;7,0
 .byt 26,68
 .byt OBJ_SIMONWHITECELL
 
 .byt OBJECT	;0,1
 .byt 12,80
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;2,1
 .byt 16,80
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;4,1
 .byt 20,80
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;6,1
 .byt 24,80
 .byt OBJ_SIMONWHITECELL

 .byt OBJECT	;1,2
 .byt 14,92
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;3,2
 .byt 18,92
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;5,2
 .byt 22,92
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;7,2
 .byt 26,92
 .byt OBJ_SIMONWHITECELL
 
 .byt OBJECT	;0,3
 .byt 12,104
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;2,3
 .byt 16,104
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;4,3
 .byt 20,104
 .byt OBJ_SIMONWHITECELL
 .byt OBJECT	;6,3
 .byt 24,104
 .byt OBJ_SIMONWHITECELL
;Now plot interconnecting console
 .byt OBJECT
 .byt 18,119
 .byt OBJ_SIMONBOTTOMPIPE
 
 .byt FURNITURE_
 .byt 16,7
 .byt SIMONCONSOLE
;
 .byt PLATFORM
 .byt 2,7,37
 
 .byt END

;END		!
;PLATFORM		X(1 or 39),Y(Platform 0-7),Length(1 or 39)
;LIFTSHAFT	G(0-7),X(1-39),L(Bitmap)
;LIFTPLATFORMS	G(0-7),DL(Bitmap),CL(Bitmap)
;	Must always be placed after Entrances, Furniture, Platforms and Lift Shafts
;FURNITURE_	X(1 or 39),Y(Platform 0-7),FurnitureID(plundered(+128) puzzlepiece(+64))
;DROID		X(1 or 39),Y(Platform 0-7),Length of Rail(1-39),Type(0-15)
;ENTRANCE		X(1 or 39),Y(0 or 1)
;	Must always be placed at the start of the Room
;OBJECT		X(1-39),Y(0-199),ObjectID
;REPEATOBJECT	Direction(0-1),Repeats(0-199),X(1-39),Y(0-199),ObjectID

;   T F            <
;-|---------------|-
; | S       F     |
;-=---------------=-
; |        H      
;-=---------------|-
;>| C             |
;-=---------------=-
Room_16
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt PLATFORM
 .byt 2,1,37
 
 .byt PLATFORM
 .byt 2,3,37
 
 .byt PLATFORM
 .byt 2,5,37
 
 .byt PLATFORM
 .byt 2,7,37
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 4,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 30,%01110000
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 30,%00000111
 
 .byt FURNITURE_
 .byt 10,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 14,1
 .byt FAGDISPENSER
 
 .byt FURNITURE_
 .byt 22,3
 .byt FIREPLACE
 
 .byt FURNITURE_
 .byt 20,5
 .byt HARDDISK2
 
 .byt FURNITURE_
 .byt 8,3
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 8,7
 .byt COMPUTER
 
 .byt FURNITURE_
 .byt 35,1
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00010101,%00010101
 
 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010000,%00010000
 
 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000001,%00000001
 
 .byt DROID
 .byt 7,1,21,0
 
 .byt DROID
 .byt 7,3,21,1
 
 .byt DROID
 .byt 7,5,21,0
 
 .byt DROID
 .byt 7,7,21,0
 
 .byt END

;       D
; K    ---   BL
;----       ----
;      ---   K
;|---       ----
;|     ---
;=---          <
;      ---------

Room_00
 .byt ENTRANCE
 .byt 39,1,0
 
 .byt PLATFORM
 .byt 2,2,12
 
 .byt PLATFORM
 .byt 2,4,12
 
 .byt PLATFORM
 .byt 2,6,12
 
 .byt PLATFORM
 .byt 16,1,10
 
 .byt PLATFORM
 .byt 16,3,10
 
 .byt PLATFORM
 .byt 16,5,10
 
 .byt PLATFORM
 .byt 16,7,23
 
 .byt PLATFORM
 .byt 28,2,11

 .byt PLATFORM
 .byt 28,4,11

 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%00001110

 .byt FURNITURE_
 .byt 24,7
 .byt TERMINAL_

 .byt FURNITURE_
 .byt 4,2
 .byt BOOKCASE

 .byt FURNITURE_
 .byt 19,1
 .byt DRAWERS
 
 .byt FURNITURE_
 .byt 28,2
 .byt BED
 
 .byt FURNITURE_
 .byt 35,2
 .byt LAMP

 .byt FURNITURE_
 .byt 30,4
 .byt BOOKCASE

 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000010,%00000010
 
 .byt DROID
 .byt 1,2,11,0

 .byt END

;-|-|-|--------------
; | | |             
; | | | -----------|-
; | | |            |
; | | | ----   ----=-
; | | |     ---
;-=-=-=-----   ------
Room_09
 .byt ENTRANCE
 .byt 1,0,0

; .byt ENTRANCE
; .byt 39,0,0
 
 .byt PLATFORM
 .byt 2,1,37
 
 .byt PLATFORM
 .byt 17,3,22
 
 .byt PLATFORM
 .byt 17,5,7
 
 .byt PLATFORM
 .byt 24,6,4
 
 .byt PLATFORM
 .byt 28,5,11
 
 .byt PLATFORM
 .byt 2,7,37
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 3,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 8,%01111111

 .byt LIFTSHAFT
 .byt GROUP2
 .byt 13,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 34,%00011100
 
 .byt FURNITURE_
 .byt 17,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 20,3
 .byt FAGDISPENSER

 .byt FURNITURE_
 .byt 28,3
 .byt COMPUTER
 
 .byt FURNITURE_
 .byt 17,5
 .byt TELEX
 
 .byt FURNITURE_
 .byt 28,5
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 31,5
 .byt HARDDISK

 .byt FURNITURE_
 .byt 31,7
 .byt TERMINAL_

 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000001,%00000001
 
 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000001,%00000001
 
 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000001,%00000001
 
 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %00000100,%00000100
 
 .byt DROID
 .byt 16,3,17,1

 .byt DROID
 .byt 16,5,6,0
 
; .byt DROID
; .byt 17,7,6,0
 
 .byt END

;                  <
;|------       -----
;|        
;|-------     -----|
;|                 |
;|--------    -----|
;|                 |
;=----------- -----=
Room_01
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt PLATFORM
 .byt 2,1,20
 
 .byt PLATFORM
 .byt 2,3,22
 
 .byt PLATFORM
 .byt 2,5,24
 
 .byt PLATFORM
 .byt 2,7,26
 
 .byt PLATFORM
 .byt 30,7,9
 
 .byt PLATFORM
 .byt 31,1,8

 .byt PLATFORM
 .byt 30,3,9

 .byt PLATFORM
 .byt 30,5,9
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%01111111	;Technically we could modify like 01010101 to make lift span larger steps
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 35,%00011111
 
 .byt FURNITURE_
 .byt 8,3
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 8,5
 .byt FAGDISPENSER

 .byt FURNITURE_
 .byt 10,7
 .byt DESK

 .byt FURNITURE_
 .byt 30,3
 .byt TELEX

 .byt FURNITURE_
 .byt 19,7
 .byt TERMINAL_

 .byt FURNITURE_
 .byt 31,7
 .byt TERMINAL_

 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000001,%00000001
 
 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000001,%00000001
 
 .byt DROID
 .byt 5,3,17,0

 .byt DROID
 .byt 30,5,2,0
 
 .byt DROID
 .byt 5,7,21,0
 
 .byt END

;                T <
;=-  O           ---
;|  ---     ---
;|-     ---     ----
;|  ---     ---
;|-     ---     SSS
;|T ---     --------
;|-    ----
Room_02
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt PLATFORM
 .byt 2,1,6
 
 .byt PLATFORM
 .byt 2,3,6

 .byt PLATFORM
 .byt 2,5,6

 .byt PLATFORM
 .byt 2,7,7

 .byt PLATFORM
 .byt 10,2,6

 .byt PLATFORM
 .byt 10,4,6

 .byt PLATFORM
 .byt 10,6,6

 .byt PLATFORM
 .byt 18,3,6

 .byt PLATFORM
 .byt 18,5,6

 .byt PLATFORM
 .byt 16,7,8

 .byt PLATFORM
 .byt 26,2,6

 .byt PLATFORM
 .byt 26,4,6

 .byt PLATFORM
 .byt 26,6,13
 
 .byt PLATFORM
 .byt 36,1,3
 
 .byt PLATFORM
 .byt 34,3,5

 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%01111111
 
 .byt FURNITURE_
 .byt 5,7
 .byt TELEX
 
 .byt FURNITURE_
 .byt 26,6
 .byt TAPESTREAMER

 .byt FURNITURE_
 .byt 30,6
 .byt TAPESTREAMER

 .byt FURNITURE_
 .byt 34,6
 .byt TAPESTREAMER

 .byt FURNITURE_
 .byt 12,6
 .byt TERMINAL_

 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01000000,%01000000
 
 .byt DROID
 .byt 16,7,5,0

 .byt DROID
 .byt 26,6,10,1
 
 .byt END

;    W  H             <
;   |------=     ---|--
;   |      | S L    |W
;   |      |--------|--
;   |      |        |
;   |------|     ---|
;>  | T             |
;---=---------------=--
Room_17
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt PLATFORM
 .byt 8,1,8
 
 .byt PLATFORM
 .byt 8,5,8
 
 .byt PLATFORM
 .byt 2,7,37
 
 .byt PLATFORM
 .byt 20,3,19
 
 .byt PLATFORM
 .byt 27,1,12
 
 .byt PLATFORM
 .byt 27,5,5
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 4,%01111111

 .byt LIFTSHAFT
 .byt GROUP1
 .byt 32,%01111111

 .byt LIFTSHAFT
 .byt GROUP2
 .byt 16,%01111100
 
 .byt FURNITURE_
 .byt 9,1
 .byt SPEAKER

 .byt FURNITURE_
 .byt 12,1
 .byt HIFI

 .byt FURNITURE_
 .byt 20,3
 .byt SOFA
 
 .byt FURNITURE_
 .byt 27,3
 .byt LAMP
 
 .byt FURNITURE_
 .byt 37,3
 .byt SPEAKER
 
 .byt FURNITURE_
 .byt 9,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000001,%00000001
 
 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000001,%00000001
 
 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %01000000,%01000000
 
 .byt DROID
 .byt 7,1,7,0

 .byt DROID
 .byt 19,3,11,0
 
 .byt DROID
 .byt 27,5,2,0
 
 .byt END
 
;> T
;=-----------------|
;|           K     |
;=-----------------=
;|       K C       |
;|-----------------=
;|    K          T |<
;|-----------------=
Room_18
 .byt ENTRANCE
 .byt 39,1,0
 
 .byt ENTRANCE
 .byt 1,0,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 2,5,37 

 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 35,%01111111
 
 .byt FURNITURE_
 .byt 7,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 31,7
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 26,3
 .byt BOOKCASE

 .byt FURNITURE_
 .byt 22,5
 .byt ARMCHAIR
 
 .byt FURNITURE_
 .byt 17,5
 .byt BOOKCASE

 .byt FURNITURE_
 .byt 10,7
 .byt BOOKCASE
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01010000,%01010000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010101,%00010101

 .byt DROID
 .byt 6,1,26,0

 .byt DROID
 .byt 6,3,26,0
 
 .byt DROID
 .byt 6,5,26,0
 
 .byt DROID
 .byt 6,7,26,0
 
 .byt END
 

;               T   <
;----|--------|------
;    | D   C  |      
;|---=--------=-----|
;|                  |
;=--------|---------=
;>  T     |
;---------=----------
Room_19
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt PLATFORM
 .byt 2,1,37
 
 .byt PLATFORM
 .byt 2,3,37
 
 .byt PLATFORM
 .byt 2,5,37

 .byt PLATFORM
 .byt 2,7,37

 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%00011100
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 11,%01110000
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 18,%00000111
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 27,%01110000
 
 .byt LIFTSHAFT
 .byt GROUP4
 .byt 35,%00011100

 .byt FURNITURE_
 .byt 32,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 15,3
 .byt DESK
 
 .byt FURNITURE_
 .byt 23,3
 .byt CANDY
 
 .byt FURNITURE_
 .byt 8,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000100,%00000100

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010000,%00010000

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000001,%00000001

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %00010000,%00010000

 .byt LIFTPLATFORMS
 .byt GROUP4
 .byt %00000100,%00000100

 .byt DROID
 .byt 15,1,9,0
 
 .byt DROID
 .byt 15,3,9,0
 
 .byt DROID
 .byt 22,5,10,0
 
 .byt DROID
 .byt 22,7,14,1
 
 .byt END
;
;>T
;-----=-|-=-----
;     | | |    B
;   --=-=-=------
;   D | | |
;-----|-=-|-|------
; C         |    T<
;-----------=   ---
;
;
Room_20
 .byt ENTRANCE
 .byt 1,0,0
 
 .byt ENTRANCE
 .byt 39,1,0
 
 .byt PLATFORM
 .byt 2,1,31
 
 .byt PLATFORM
 .byt 6,3,29
 
 .byt PLATFORM
 .byt 2,5,37 
 
 .byt PLATFORM
 .byt 2,7,26
 
 .byt PLATFORM
 .byt 32,7,7
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 10,%01111100
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 16,%01111100
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 22,%01111100
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 28,%00000111
 
 .byt FURNITURE_
 .byt 3,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 28,3
 .byt BED
 
 .byt FURNITURE_
 .byt 6,5
 .byt DRAWERS
 
 .byt FURNITURE_
 .byt 3,7
 .byt CANDY
 
 .byt FURNITURE_
 .byt 34,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01010000,%01010000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010100,%00010100

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %01010000,%01010000

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %00000001,%00000001

 .byt DROID
 .byt 26,3,6,0
 
 .byt DROID
 .byt 2,5,5,0
 
 .byt DROID
 .byt 2,7,23,0
 
 .byt END
;       D C
;|----------------|
;| FT          H  |
;|----------------=
;|     TT         |
;=----------------=
;|>T     C        |
;=----------------=
;
Room_10
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 2,5,37 
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 35,%01111111
 
 .byt FURNITURE_
 .byt 16,1
 .byt DESK
 
 .byt FURNITURE_
 .byt 24,1
 .byt COMPUTER
 
 .byt FURNITURE_
 .byt 8,3
 .byt FAGDISPENSER
 
 .byt FURNITURE_
 .byt 16,3
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 28,3
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 20,5
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 24,5
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 8,7
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 16,7
 .byt CANDY
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000101,%00000101

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010101,%00010101

 .byt DROID
 .byt 6,1,26,0
 
 .byt DROID
 .byt 6,3,26,0

 .byt DROID
 .byt 6,5,26,0

 .byt DROID
 .byt 6,7,26,0

 .byt END
; H              S
;|--  -   |   -----
;|   -    |  - F
;|  -     | - ----=
;=--      ||      |
;         ==------=
;   T     ||  D   |
;---------==------|
Room_11
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt PLATFORM
 .byt 2,1,9
 
 .byt PLATFORM
 .byt 14,1,4
 
 .byt PLATFORM
 .byt 30,1,9
 
 .byt PLATFORM
 .byt 12,2,2
 
 .byt PLATFORM
 .byt 27,2,2 
 
 .byt PLATFORM
 .byt 10,3,2 
 
 .byt PLATFORM
 .byt 25,3,2
 
 .byt PLATFORM
 .byt 29,3,7
 
 .byt PLATFORM
 .byt 2,4,8 
 
 .byt PLATFORM
 .byt 26,5,11
 
 .byt PLATFORM
 .byt 2,7,37
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%01111000
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 18,%00011111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 22,%00001111
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 35,%00011111
 
 .byt FURNITURE_
 .byt 7,1
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 34,1
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 29,3
 .byt FAGDISPENSER
 
 .byt FURNITURE_
 .byt 10,7
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 26,7
 .byt DESK
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00001000,%00001000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000101,%00000101

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000101,%00000101

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %00010100,%00010100

 .byt DROID
 .byt 29,1,8,0
 
 .byt DROID
 .byt 26,5,6,0
 
 .byt DROID
 .byt 25,7,8,0
 
 .byt END
;2345678901234567890123456789012345678
;>T                                  <
;--               --           -------
;           ----            --
;---              --                --
;            --             --
;----             --
;             -                  --
;-----            --           --

Room_21
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt ENTRANCE
 .byt 1,0,0

 .byt PLATFORM
 .byt 2,1,4 
 
 .byt PLATFORM
 .byt 2,3,5
 
 .byt PLATFORM
 .byt 2,5,6
 
 .byt PLATFORM
 .byt 2,7,7
 
 .byt PLATFORM
 .byt 11,2,6
 
 .byt PLATFORM
 .byt 12,4,4
 
 .byt PLATFORM
 .byt 13,6,3
 
 .byt PLATFORM
 .byt 20,1,4
 
 .byt PLATFORM
 .byt 20,3,4
 
 .byt PLATFORM
 .byt 20,5,4
 
 .byt PLATFORM
 .byt 20,7,4
 
 .byt PLATFORM
 .byt 28,2,3
 
 .byt PLATFORM
 .byt 28,4,3
 
 .byt PLATFORM
 .byt 32,1,7 
 
 .byt PLATFORM
 .byt 36,3,3
 
 .byt PLATFORM
 .byt 33,6,3
 
 .byt PLATFORM
 .byt 30,7,3
 
 .byt FURNITURE_
 .byt 3,1
 .byt TERMINAL_
 
 .byt DROID
 .byt 2,7,4,0
 
 .byt END
;
;|-- - - - - - -----
;|      D    B
;=-----------------|
;                  |
;|-----   --   ----=
;|>T
;=------------------
Room_12
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt PLATFORM
 .byt 2,1,6 
 
 .byt PLATFORM
 .byt 10,1,2
 
 .byt PLATFORM
 .byt 14,1,2
 
 .byt PLATFORM
 .byt 18,1,2
 
 .byt PLATFORM
 .byt 22,1,2
 
 .byt PLATFORM
 .byt 26,1,2
 
 .byt PLATFORM
 .byt 30,1,9
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 2,5,13
 
 .byt PLATFORM
 .byt 19,5,3
 
 .byt PLATFORM
 .byt 27,5,12
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%01110000
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 35,%00011100
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 2,%00000111
 
 .byt FURNITURE_
 .byt 32,1
 .byt ARMCHAIR
 
 .byt FURNITURE_
 .byt 16,3
 .byt DESK
 
 .byt FURNITURE_
 .byt 28,3
 .byt BOOKCASE
 
 .byt FURNITURE_
 .byt 9,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00010000,%00010000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000100,%00000100

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000001,%00000001

 .byt DROID
 .byt 6,3,26,0
 
 .byt DROID
 .byt 6,5,6,0
 
 .byt DROID
 .byt 27,5,5,0
 
 .byt END
;
; S   H   S         <
;-----------|----|---
;           |    | B
;|----|-----=----=---
;| B  |     |    |   
;=----=-----=----=---
;|>T  |          D
;=----=--------------

Room_22
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 2,5,37 
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%00011111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 10,%00011111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 18,%01111100
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 26,%01111100
 
 .byt FURNITURE_
 .byt 3,1
 .byt SPEAKER
 
 .byt FURNITURE_
 .byt 9,1
 .byt HIFI
 
 .byt FURNITURE_
 .byt 15,1
 .byt SPEAKER
 
 .byt FURNITURE_
 .byt 33,3
 .byt BOOKCASE
 
 .byt FURNITURE_
 .byt 6,5
 .byt BOOKCASE
 
 .byt FURNITURE_
 .byt 6,7
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 30,7
 .byt DESK
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000101,%00000101

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000101,%00000101

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00010100,%00010100

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %00010100,%00010100

 .byt DROID
 .byt 1,1,15,0
 
 .byt DROID
 .byt 22,3,1,0
 
 .byt DROID
 .byt 14,5,1,0
 
 .byt DROID
 .byt 13,7,24,1
 
 .byt END
;             B
;|------=    ----  ;
;|      |     D    ;
;|      |   -----  ;
;|      |     F
;|----- |   -----
;|<     |          >
;=------ -----------
Room_23
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt ENTRANCE
 .byt 39,1,0
 
 .byt PLATFORM
 .byt 2,1,15
 .byt PLATFORM
 .byt 25,1,8
 .byt PLATFORM
 .byt 25,3,10
 .byt PLATFORM
 .byt 6,5,10
 .byt PLATFORM
 .byt 25,5,10
 .byt PLATFORM
 .byt 2,7,37

 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 17,%01111111

 .byt FURNITURE_
 .byt 26,1
 .byt BED
 
 .byt FURNITURE_
 .byt 28,3
 .byt DRAWERS
 
 .byt FURNITURE_
 .byt 26,5
 .byt FIREPLACE
 
 .byt FURNITURE_
 .byt 7,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000001,%00000001

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %01000000,%01000000
 
 .byt DROID
 .byt 5,1,10,0
 
 .byt DROID
 .byt 24,3,9,0
 
 .byt DROID
 .byt 24,5,9,0
 
 .byt END

;>T
;-----------------=
;                 |
;----=----=----=--|
;    |    |    | 
;    |----|----|---
;-- T  S   F  A
;  ----------------

Room_13
 .byt ENTRANCE
 .byt 1,0,0
 
 .byt PLATFORM
 .byt 2,1,37
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 14,5,25
 
 .byt PLATFORM
 .byt 2,6,4 
 
 .byt PLATFORM
 .byt 7,7,32
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 9,%00011111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 18,%00011100
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 27,%00011100
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 35,%01110000
 
 .byt FURNITURE_
 .byt 7,1
 .byt TERMINAL_
 
; .byt FURNITURE_
; .byt 8,7
; .byt TERMINAL_

 .byt FURNITURE_
 .byt 13,7
 .byt SOFA
 
 .byt FURNITURE_
 .byt 20,7
 .byt FIREPLACE
 
 .byt FURNITURE_
 .byt 28,7
 .byt ARMCHAIR
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00010000,%00010000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010000,%00010000

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00010000,%00010000

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %01000000,%01000000

 .byt DROID
 .byt 8,1,24,0
 
 .byt DROID
 .byt 21,3,4,0
 
 .byt DROID
 .byt 13,5,3,0
 
 .byt DROID
 .byt 11,7,25,0
 
 .byt END
;       F  A
;|----------------|
;|                |
;= --  ------  -- =
;|                |
;=----  -|-   ----=
;<       |  T     >
;--------=---------
Room_24
 .byt ENTRANCE
 .byt 39,1,0
 
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 9,3,4
 
 .byt PLATFORM
 .byt 27,3,4
 
 .byt PLATFORM
 .byt 16,3,8
 
 .byt PLATFORM
 .byt 2,5,10
 
 .byt PLATFORM
 .byt 18,5,6
 
 .byt PLATFORM
 .byt 29,5,8
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%01111100
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 35,%01111100
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 19,%00000111
 
 .byt FURNITURE_
 .byt 14,1
 .byt FIREPLACE
 
 .byt FURNITURE_
 .byt 23,1
 .byt ARMCHAIR
 
 .byt FURNITURE_
 .byt 25,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00010100,%00010100

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010100,%00010100

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000001,%00000001

 .byt DROID
 .byt 5,1,28,0
 
 .byt DROID
 .byt 15,3,7,0
 
 .byt DROID
 .byt 5,5,5,0
 
 .byt DROID
 .byt 27,5,6,0
 
 .byt END
;T             <
;-------=-------
;       |
;---=---|---=---
;   |       |
;---=-------=---
;B  |  SB   |  T
;---|-------|---
Room_03
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 2,5,37 
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 18,%01110000
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 10,%00011111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 28,%00011111
 
 .byt FURNITURE_
 .byt 2,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 2,7
 .byt BATH
 
 .byt FURNITURE_
 .byt 16,7
 .byt SINK
 
 .byt FURNITURE_
 .byt 22,7
 .byt BASKET
 
 .byt FURNITURE_
 .byt 35,7
 .byt TOILET
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01000000,%01000000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010100,%00010100

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00010100,%00010100

 .byt DROID
 .byt 2,3,5,0
 
 .byt DROID
 .byt 31,3,5,0
 
 .byt DROID
 .byt 13,5,13,0
 
 .byt DROID
 .byt 14,7,12,0
 
 .byt END
;>               W
;-=--|--|--|--|----
; |  |  |  |  |  F
;-=--=--|--|--=----
;P|  |  |  |  | D
;-|--=--=--=--=----
; |  |  |  |  | T <
;-|--|--=--=--|----
Room_25
 .byt ENTRANCE
 .byt 1,0,0
 
 .byt ENTRANCE
 .byt 39,1,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 2,5,37 
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 6,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 12,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 18,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 24,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP4
 .byt 30,%01111111
 
 .byt FURNITURE_
 .byt 35,1
 .byt TOILET
 
 .byt FURNITURE_
 .byt 34,3
 .byt FRIDGE
 
 .byt FURNITURE_
 .byt 2,5
 .byt BASKET
 
 .byt FURNITURE_
 .byt 34,5
 .byt TELEX
 
 .byt FURNITURE_
 .byt 35,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01010000,%01010000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010100,%00010100

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000101,%00000101

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %00000101,%00000101

 .byt LIFTPLATFORMS
 .byt GROUP4
 .byt %00010100,%00010100

 .byt DROID
 .byt 21,3,0,0
 
 .byt DROID
 .byt 15,5,0,0
 
 .byt END
;
;=--------| TTTt
;|   T    |-----|
;=--------| D  T|
;|        |-----=
;|--------=
;|        |  T  <
;|--------=------
Room_04
 .byt ENTRANCE
 .byt 39,1,0
 
 .byt PLATFORM
 .byt 2,1,16
 
 .byt PLATFORM
 .byt 2,3,16
 
 .byt PLATFORM
 .byt 2,5,16
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt PLATFORM
 .byt 14,2,21
 
 .byt PLATFORM
 .byt 14,4,21
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 14,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 35,%00111000
 
 .byt FURNITURE_
 .byt 18,2
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 22,2
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 26,2
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 30,2
 .byt COMPUTER
 
 .byt FURNITURE_
 .byt 21,4
 .byt DESK
 
 .byt FURNITURE_
 .byt 29,4
 .byt TELEX
 
 .byt FURNITURE_
 .byt 32,7
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 8,3
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01010000,%01010000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000101,%00000101

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00001000,%00001000

 .byt DROID
 .byt 5,3,6,0
 
 .byt END
 
;T              T
;--     F     |------
;   ----------|
;             |------
;      |------=
;|-----|      |------
;|>T          |     <
;=------------|------
Room_26
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt ENTRANCE
 .byt 39,1,0
 
 .byt PLATFORM
 .byt 2,1,5
 
 .byt PLATFORM
 .byt 9,2,20
 
 .byt PLATFORM
 .byt 32,1,7 
 
 .byt PLATFORM
 .byt 2,5,10
 
 .byt PLATFORM
 .byt 12,4,16
 
 .byt PLATFORM
 .byt 32,3,7
 
 .byt PLATFORM
 .byt 32,5,7
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%00000111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 12,%00001100
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 28,%01111111
 
 .byt FURNITURE_
 .byt 2,1
 .byt TELEX
 
 .byt FURNITURE_
 .byt 14,2
 .byt FAGDISPENSER
 
 .byt FURNITURE_
 .byt 33,1
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 8,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000001,%00000001

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000100,%00000100

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00001000,%00001000

 .byt DROID
 .byt 8,2,18,0

 .byt DROID
 .byt 5,5,5,0
 
 .byt DROID
 .byt 15,4,11,0
 
 .byt DROID
 .byt 31,3,6,0
 
 .byt END

;>  T
;--=---|---|---=---=---
;H |   | H |   | H |     --
;--=---=---|---=---=---
;H |   | H |   | H |     --
;--|---=---=---|---=---
;H |   | H |   | H |     --
;--|---|---=---|---|---
Room_14
 .byt ENTRANCE
 .byt 1,0,0
 
 .byt PLATFORM
 .byt 2,1,31
 
 .byt PLATFORM
 .byt 2,3,31 
 
 .byt PLATFORM
 .byt 2,5,31 
 
 .byt PLATFORM
 .byt 2,7,31
 
 .byt PLATFORM
 .byt 35,2,4
 
 .byt PLATFORM
 .byt 35,4,4
 
 .byt PLATFORM
 .byt 35,6,4
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 5,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 12,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 19,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 26,%01111111
 
 .byt FURNITURE_
 .byt 9,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 2,3
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 2,5
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 2,7
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 16,3
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 16,5
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 16,7
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 23,3
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 23,5
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 35,6
 .byt HARDDISK
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01010000,%01010000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010100,%00010100

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000101,%00000101

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %01010100,%01010100

 .byt DROID
 .byt 9,3,0,0
 
 .byt DROID
 .byt 9,7,0,0
 
 .byt DROID
 .byt 23,7,0,0
 
 .byt DROID
 .byt 30,5,0,0
 
 .byt END
;                  T<
;                  --
;     ----------
;-=   D
;-|-|------------|---
;   | B      B   |
;---|------------|---
; T |   S   A    | T
;---=------------=---
Room_05
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt PLATFORM
 .byt 32,1,7
 
 .byt PLATFORM
 .byt 21,2,6
 
 .byt PLATFORM
 .byt 2,2,5
 
 .byt PLATFORM
 .byt 2,3,37
 
 .byt PLATFORM
 .byt 2,5,37 
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 4,%00110000
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 8,%00011111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 30,%00011111
 
 .byt FURNITURE_
 .byt 3,7
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 35,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 13,3
 .byt DESK
 
 .byt FURNITURE_
 .byt 13,5
 .byt BOOKCASE
 
 .byt FURNITURE_
 .byt 22,5
 .byt BOOKCASE
 
 .byt FURNITURE_
 .byt 12,7
 .byt SOFA
 
 .byt FURNITURE_
 .byt 24,7
 .byt ARMCHAIR
 
 .byt FURNITURE_
 .byt 35,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00100000,%00100000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000001,%00000001

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000001,%00000001

 .byt DROID
 .byt 20,2,5,0
 
 .byt DROID
 .byt 11,3,17,0
 
 .byt DROID
 .byt 11,5,17,0
 
 .byt DROID
 .byt 11,7,17,0
 
 .byt END
;             T  <
;       =--------|
; T     |        |
;---    =---|   -=
;       |   |
;--|----=---=
;>T|    |   |   T
;--=----|---=   --
Room_27
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt PLATFORM
 .byt 20,1,19
 
 .byt PLATFORM
 .byt 2,3,6
 
 .byt PLATFORM
 .byt 20,3,6
 
 .byt PLATFORM
 .byt 33,3,6
 
 .byt PLATFORM
 .byt 2,5,24
 
 .byt PLATFORM
 .byt 2,7,8
 
 .byt PLATFORM
 .byt 20,7,7
 
 .byt PLATFORM
 .byt 34,7,5
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 6,%00000111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 16,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 23,%00011111
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 35,%01110000
 
 .byt FURNITURE_
 .byt 30,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 2,3
 .byt TELEX
 
 .byt FURNITURE_
 .byt 2,7
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 34,7
 .byt TELEX
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000001,%00000001

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %01010100,%01010100

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000101,%00000101

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %00010000,%00010000

 .byt DROID
 .byt 20,3,0,0
 
 .byt END
;>         T    <
;--------=----=--
; D  T   |    |  
;--------=----=--
;        |    |T
;--=-=-=-|----|--
;H | | |  T F
;--|-|-|---------
Room_28
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt ENTRANCE
 .byt 1,0,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 2,5,37 
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 6,%00000111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 13,%00000111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 20,%00000111
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 27,%01111100
 
 .byt LIFTSHAFT
 .byt GROUP4
 .byt 31,%01111100
 
 .byt FURNITURE_
 .byt 21,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 3,3
 .byt DESK
 
 .byt FURNITURE_
 .byt 15,3
 .byt TELEX
 
 .byt FURNITURE_
 .byt 34,5
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 2,7
 .byt HARDDISK
 
 .byt FURNITURE_
 .byt 25,7
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 30,7
 .byt FAGDISPENSER
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000100,%00000100

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000100,%00000100

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000100,%00000100

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %01010000,%01010000

 .byt LIFTPLATFORMS
 .byt GROUP4
 .byt %01010000,%01010000

 .byt DROID
 .byt 10,5,0,0
 
 .byt DROID
 .byt 10,7,0,0
 
 .byt DROID
 .byt 1,3,24,0
 
 .byt DROID
 .byt 24,5,0,0
 
 .byt END
;> T              <
;--=------------=-
;  | B          |
;  |---       --|-
;  | C      =-  |
;-=|---     | --|-
; |  D      |-  |
;-|----       --|-
Room_29	;Control Room Door
 .byt ENTRANCE
 .byt 1,0,0
 
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 10,3,9 
 
 .byt PLATFORM
 .byt 31,3,8
 
 .byt PLATFORM
 .byt 24,4,6
 
 .byt PLATFORM
 .byt 2,5,17
 
 .byt PLATFORM
 .byt 31,5,8
 
 .byt PLATFORM
 .byt 24,6,6
 
 .byt PLATFORM
 .byt 2,7,17
 
 .byt PLATFORM
 .byt 31,7,8
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 6,%01111100
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 2,%00000111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 24,%00001110
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 34,%01111111
 
 .byt FURNITURE_
 .byt 12,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 11,3
 .byt BED
 
 .byt FURNITURE_
 .byt 12,5
 .byt DRAWERS
 
 .byt FURNITURE_
 .byt 10,7
 .byt DOORWAY
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01000000,%01000000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000100,%00000100

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00001000,%00001000

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %01000000,%01000000

 .byt DROID
 .byt 9,3,8,0
 
 .byt DROID
 .byt 9,5,8,0
 
 .byt END

;>T           T
;-------=-|-------
;  T    |-|   T
; ---   |-|-------
;  T          T
;-------|-|  ---
;       | |     T<
;-------|-=-------
  
Room_30
 .byt ENTRANCE
 .byt 39,1,0
 
 .byt ENTRANCE
 .byt 1,0,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 6,3,6 
 
 .byt PLATFORM
 .byt 20,3,19
 
 .byt PLATFORM
 .byt 2,5,22
 
 .byt PLATFORM
 .byt 31,5,5
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 18,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 23,%01111111
 
 .byt FURNITURE_
 .byt 4,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 31,1
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 6,3
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 31,3
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 6,5
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 31,5
 .byt TAPESTREAMER
 
 .byt FURNITURE_
 .byt 34,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01000000,%01000000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000001,%00000001

 .byt DROID
 .byt 26,1,11,0
 
 .byt DROID
 .byt 26,3,11,0
 
 .byt DROID
 .byt 1,5,15,0
 
 .byt DROID
 .byt 1,7,15,0
 
 .byt END

;>T
;----------|-|------
;          | |
;----|-|---=-=------
;    | |    D   C
;|-|-=-=------------
;| | T F T T T
;=-=----------------
Room_15
 .byt ENTRANCE
 .byt 1,0,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 2,5,37 
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%00000111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 8,%00000111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 14,%00011100
 
 .byt LIFTSHAFT
 .byt GROUP3
 .byt 20,%00011100
 
 .byt LIFTSHAFT
 .byt GROUP4
 .byt 26,%01110000
 
 .byt LIFTSHAFT
 .byt GROUP5
 .byt 32,%01110000
 
 .byt FURNITURE_
 .byt 7,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 25,5
 .byt DESK
 
 .byt FURNITURE_
 .byt 32,5
 .byt COMPUTER
 
 .byt FURNITURE_
 .byt 15,7
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 19,7
 .byt FAGDISPENSER
 
 .byt FURNITURE_
 .byt 25,7
 .byt TELEX
 
 .byt FURNITURE_
 .byt 29,7
 .byt TELEX
 
 .byt FURNITURE_
 .byt 33,7
 .byt TELEX
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00000001,%00000001

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000001,%00000001

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00000100,%00000100

 .byt LIFTPLATFORMS
 .byt GROUP3
 .byt %00000100,%00000100

 .byt LIFTPLATFORMS
 .byt GROUP4
 .byt %00010000,%00010000

 .byt LIFTPLATFORMS
 .byt GROUP5
 .byt %00010000,%00010000

 .byt DROID
 .byt 36,1,0,0
 
 .byt DROID
 .byt 1,3,11,0
 
 .byt DROID
 .byt 23,5,14,0
 
 .byt DROID
 .byt 11,7,26,0
 
 .byt END
; T              <
;--------=--------
;        |
;--------|--------
; D      |    BW
;--------|--------
;B       |     BT
;--------|--------
Room_06
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 2,5,37 
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 18,%01111111
 
 .byt FURNITURE_
 .byt 7,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 7,5
 .byt DRAWERS
 
 .byt FURNITURE_
 .byt 2,7
 .byt BATH
 
 .byt FURNITURE_
 .byt 28,5
 .byt BASKET
 
 .byt FURNITURE_
 .byt 31,5
 .byt WORKTOP
 
 .byt FURNITURE_
 .byt 32,7
 .byt BASKET
 
 .byt FURNITURE_
 .byt 35,7
 .byt TOILET
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01000000,%01000000

 .byt END
Room_07
 .byt ENTRANCE
 .byt 39,1,0
 
 .byt PLATFORM
 .byt 2,1,37 
 
 .byt PLATFORM
 .byt 2,3,37 
 
 .byt PLATFORM
 .byt 2,5,37 
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 2,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 18,%01111111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 35,%01111111
 
 .byt FURNITURE_
 .byt 6,1
 .byt WORKTOP
 
 .byt FURNITURE_
 .byt 13,1
 .byt FRIDGE
 
 .byt FURNITURE_
 .byt 26,1
 .byt CANDY
 
 .byt FURNITURE_
 .byt 30,7
 .byt TERMINAL_
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %00010101,%00010101

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00010101,%00010101

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00010101,%00010101

 .byt DROID
 .byt 5,1,11,0
 
 .byt DROID
 .byt 5,3,11,0
 
 .byt DROID
 .byt 5,7,11,0
 
 .byt DROID
 .byt 21,5,12,0
 
 .byt END
;                  |<
;----------=-      |
;  T F P T |    =--=-
;----------|    |
;B S  T  L |    |
;----------|    |
;>T    D        | C
;---------------=----
Room_31
 .byt ENTRANCE
 .byt 39,0,0
 
 .byt ENTRANCE
 .byt 1,1,0
 
 .byt PLATFORM
 .byt 2,1,15 
 
 .byt PLATFORM
 .byt 30,3,9
 
 .byt PLATFORM
 .byt 2,3,15
 
 .byt PLATFORM
 .byt 2,5,15
 
 .byt PLATFORM
 .byt 2,7,37 
 
 .byt PLATFORM
 .byt 22,2,3
 
 .byt LIFTSHAFT
 .byt GROUP0
 .byt 14,%01111100
 
 .byt LIFTSHAFT
 .byt GROUP1
 .byt 30,%00111111
 
 .byt LIFTSHAFT
 .byt GROUP2
 .byt 35,%01110000
 
 .byt FURNITURE_
 .byt 2,1
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 5,1
 .byt FRIDGE
 
 .byt FURNITURE_
 .byt 10,1
 .byt ARMCHAIR
 
 .byt FURNITURE_
 .byt 2,3
 .byt BATH
 
 .byt FURNITURE_
 .byt 7,3
 .byt SOFA
 
 .byt FURNITURE_
 .byt 8,5
 .byt FRIDGE
 
 .byt FURNITURE_
 .byt 3,5
 .byt LAMP
 
 .byt FURNITURE_
 .byt 6,7
 .byt TERMINAL_
 
 .byt FURNITURE_
 .byt 15,7
 .byt DESK
 
 .byt FURNITURE_
 .byt 34,7
 .byt CANDY
 
 .byt LIFTPLATFORMS
 .byt GROUP0
 .byt %01000000,%01000000

 .byt LIFTPLATFORMS
 .byt GROUP1
 .byt %00000001,%00000001

 .byt LIFTPLATFORMS
 .byt GROUP2
 .byt %00010000,%00010000

 .byt DROID
 .byt 1,1,11,0
 
 .byt DROID
 .byt 1,3,11,0
 
 .byt DROID
 .byt 1,5,11,0
 
 .byt DROID
 .byt 6,7,21,0
 
 .byt END
;Terminal - PlotRoom Template auto fills screen with dither so no need to worry about that aspect
;Composed of the following sections
;TL Monitor
;TopMonitor (With black top line)
;TR Monitor
;LeftMonitor ''
;RightMonitor
;WhitePad
;DR Diagonal
;UR Diagonal
;DL Diagonal

Room_32
;First display the basic shape of the monitor
 .byt DS_REPEATOBJECT	;Display top shell
 .byt 4,6
 .byt OBJ_SIMONWHITECELL
 .byt REPEATOBJECTRIGHT
 .byt 17

 .byt DS_REPEATOBJECT	;Display Black contents
 .byt 5,18
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 16
 
 .byt DS_REPEATOBJECT	;Display Black contents
 .byt 5,30
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 16
 
 .byt DS_REPEATOBJECT	;Display Black contents
 .byt 5,42
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 16
 
 .byt DS_REPEATOBJECT	;Display Black contents
 .byt 5,54
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 16
 
 .byt DS_REPEATOBJECT	;Display Black contents
 .byt 5,66
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 16
 
 .byt DS_REPEATOBJECT	;Display Black contents
 .byt 5,78
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 16
 
 .byt DS_REPEATOBJECT	;Display Black contents
 .byt 5,90
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 16
 
 .byt DS_REPEATOBJECT	;Display Black contents
 .byt 5,102
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 16
 
 .byt DS_REPEATOBJECT	;Display Black contents
 .byt 5,114
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 16

 .byt DS_REPEATOBJECT	;Display basic case
 .byt 1,144
 .byt MON_PART13
 .byt REPEATOBJECTRIGHT
 .byt 39
 
 .byt DS_REPEATOBJECT	;Display bottom Black edge borders
 .byt 4,139
 .byt MON_PART11
 .byt REPEATOBJECTRIGHT
 .byt 33
 
 
 .byt DS_REPEATOBJECT	;Display Monitors black plinth
 .byt 13,138
 .byt OBJ_SIMONBLACKCELL
 .byt REPEATOBJECTRIGHT
 .byt 7
 
 .byt DS_OBJECT	;Need to widen plinth by one byte on the right
 .byt 26,138
 .byt OBJ_SIMONBLACKCELL

 .byt DS_REPEATOBJECT	;Display bottom shell
 .byt 4,128
 .byt OBJ_SIMONWHITECELL
 .byt REPEATOBJECTRIGHT
 .byt 17

 .byt DS_REPEATOBJECT	;Display left shell
 .byt 3,12
 .byt OBJ_SIMONWHITECELL
 .byt REPEATOBJECTDOWN
 .byt 10

 .byt DS_REPEATOBJECT	;Display right shell
 .byt 36,12
 .byt OBJ_SIMONWHITECELL
 .byt REPEATOBJECTDOWN
 .byt 10

 .byt DS_OBJECT	;Display Top left corner of monitor
 .byt 2,5
 .byt MON_PART0

 
 .byt DS_OBJECT	;Display Top right corner of monitor
 .byt 37,5
 .byt MON_PART2

 .byt DS_OBJECT	;Display Left edge of case
 .byt 1,144
 .byt MON_PART14

 .byt DS_OBJECT	;Display Right edge of case
 .byt 37,144
 .byt MON_PART12
 
 .byt DS_OBJECT	;Display Bottom Left corner of monitor
 .byt 2,132
 .byt MON_PART10

 .byt DS_REPEATOBJECT	;Display monitors Right black outline
 .byt 38,12
 .byt MON_PART3
 .byt REPEATOBJECTDOWN
 .byt 21
 
 .byt DS_OBJECT	;Display Bottom right corner of monitor
 .byt 37,135
 .byt MON_PART9

 .byt DS_OBJECT	;Display TL Bevel
 .byt 5,18
 .byt MON_PART4
 
 .byt DS_OBJECT	;Display TR Bevel
 .byt 35,18
 .byt MON_PART5
 
 .byt DS_OBJECT	;Display BL Bevel
 .byt 5,122
 .byt MON_PART6
 
 .byt DS_REPEATOBJECT	;Display bottom bevel
 .byt 6,122
 .byt MON_PART8
 .byt REPEATOBJECTRIGHT
 .byt 28
 
 .byt DS_REPEATOBJECT	;Display Right bevel
 .byt 35,24
 .byt MON_PART1
 .byt REPEATOBJECTDOWN
 .byt 17

 .byt DS_OBJECT	;Display BR Bevel
 .byt 34,122
 .byt MON_PART7
 
 .byt DS_REPEATOBJECT	;Display monitors Left black outline
 .byt 2,12
 .byt MON_PART1
 .byt REPEATOBJECTDOWN
 .byt 20
 
 .byt DS_REPEATOBJECT	;Display top black outline of monitor
 .byt 4,5
 .byt MON_PART16
 .byt REPEATOBJECTRIGHT
 .byt 33

 .byt DS_REPEATOBJECT	;Display monitors Left black outline
 .byt 5,24
 .byt MON_PART17
 .byt REPEATOBJECTDOWN
 .byt 49
 
 .byt DS_REPEATOBJECT	;Display monitors Left black outline
 .byt 34,24
 .byt MON_PART18
 .byt REPEATOBJECTDOWN
 .byt 49
 
 .byt END
 

