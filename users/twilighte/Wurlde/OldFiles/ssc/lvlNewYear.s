;lvlNewYear.s

;Each Screen must be provided with this routine
DetermineContourMap
	ldx HeroY
DetermineContourMap2
	ldy ContourMapPointer,x
	lda ContourMapFloorLo,y
	sta ContourFloor
	lda ContourMapFloorHi,y
	sta ContourFloor+1
	lda ContourMapCeilingLo,y
	sta ContourCeiling
	lda ContourMapCeilingHi,y
	sta ContourCeiling+1
	rts

ContourMapPointer
 .dsb 20,0
 .dsb 18,1
 .dsb 21,2
ContourMapFloorLo
 .byt <ContourFloor0
 .byt <ContourFloor1
 .byt <ContourFloor2
ContourMapFloorHi
 .byt >ContourFloor0
 .byt >ContourFloor1
 .byt >ContourFloor2
ContourMapCeilingLo
 .byt <ContourCeiling0
 .byt <ContourCeiling1
 .byt <ContourCeiling2
ContourMapCeilingHi
 .byt >ContourCeiling0
 .byt >ContourCeiling1
 .byt >ContourCeiling2
ContourFloor0	;Each Map is 40 bytes long
 .byt ccLeftBorder,0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0,0
 .dsb 39-18,17
 .byt ccRightExit
ContourFloor1
 .byt ccLeftBorder,0,0
 .byt 37,37,37,37
 .byt 0,0,0
 .dsb 29,35
 .byt ccRightExit
ContourFloor2
 .byt ccLeftExit
 .dsb 12,55
 .dsb 2,56
 .dsb 24,57
 .byt ccRightExit
ContourCeiling0
 .dsb 40,0
ContourCeiling2
 .byt 0,0,0
 .byt 40,40,40,40
 .byt 0,0,0
 .dsb 30,37
ContourCeiling1
 .byt 0,0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0,0
 .dsb 40-18,19


LevelExit
LevelUnpack
        rts
LevelRun
        rts

LevelProse
 .byt "Madrageth Priory..                 "
 .byt "                  Home to the poor "
 .byt "orphans of the First great war.    "
 .byt "Let the lamplight burn eternal     "
 .byt "in memory of their forgotten and   "
 .byt "wretched lives.                    "
 .byt "                                   "
LevelScreen
#include "NewYear.s"
