;Scoreboard.s
;Control..
;1) Visitor window
;2) Visitor Health
;3) Exit Arrows
;4) Sword presence
;5) Hourglass
;6) Attribute bars
;7) Hero Health
;8) Inventory items
;9) Map Management

;LevelExits
;B0 Exit North
;B1 Exit East
;B2 Exit South
;B3 Exit West
;B4 Exit North Danger
;B5 Exit East
;B6 Exit South
;B7 Exit West

;Executed after each new screen loaded
ExitArrows
	;Reset all exits to none
	ldx #03
	lda ExitArrowScreenLocationLo,x
	sta screen
	lda ExitArrowScreenLocationHi,x
	sta screen+1

	lda ExitArrowNoExitGraphicLo,x
	sta source
	lda ExitArrowNoExitGraphicHi,x
	sta source+1
	lda ExitArrowWidth,x
	sta eaWidth
	lda ExitArrowHeight,x
	tax
.(
loop2	ldy eaWidth
	dey
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda source
	clc
	adc eaWidth
	sta source
	lda source+1
	adc #00
	sta source+1
	lda screen
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	dex
	bne loop2
.)
	rts

;	ldx #07
;	lda LevelExits
;	and eaBitpos,x
;	beq


ExitArrowWidth	;NESW
 .byt 2,3,4,2
ExitArrowHeight
 .byt 4,7,5,7


ExitArrowScreenLocationLo
ExitArrowScreenLocationHi
ExitArrowNoExitGraphicLo
ExitArrowNoExitGraphicHi

ExitArrowNorthGraphic_NoExit
 .byt 0,%01001100
 .byt 0,$ef
 .byt %01101000,64
 .byt 0,%01001100
ExitArrowNorthGraphic_Exit
 .byt 2,%01001100
 .byt 5,$ef
 .byt %01101000,64
 .byt 2,%01001100
ExitArrowNorthGraphic_Danger
 .byt 1,%01001100
 .byt 6,$ef
 .byt %01101000,64
 .byt 1,%01001100

ExitArrowEastGraphic_NoExit
 .byt 64,0,%01100000
 .byt 64,7,%01000000
 .byt 0,%01001010,%01111000
 .byt 0,%01001010,%01111100
 .byt 0,%01001010,%01111000
 .byt 0,%01000000,%01110000
 .byt 64,0,%01100000
ExitArrowEastGraphic_Exit
 .byt 64,2,%01100000
 .byt 64,7,%01010000
 .byt 2,%01001010,%01111000
 .byt 2,%01001010,%01111100
 .byt 2,%01001010,%01111000
 .byt 2,%01000000,%01110000
 .byt 64,2,%01100000
ExitArrowEastGraphic_Danger
 .byt 64,1,%01100000
 .byt 64,7,%01010000
 .byt 1,%01001010,%01111000
 .byt 1,%01001010,%01111100
 .byt 1,%01001010,%01111000
 .byt 1,%01000000,%01110000
 .byt 64,1,%01100000


ExitArrowSouthGraphic_NoExit
 .byt 64,0,%01111111,1
 .byt 4,%01100000,64,64
 .byt 0,%01000011,%01111111,%01110000
 .byt %01000010,5,$40,4
 .byt %01010100,0,%01001100,4
ExitArrowSouthGraphic_Exit
 .byt 64,2,%01111111,1
 .byt 4,%01100000,64,64
 .byt 2,%01000011,%01111111,%01110000
 .byt %01000010,5,$e7,4
 .byt %01010100,2,%01001100,4
ExitArrowSouthGraphic_Danger
 .byt 64,1,%01111111,1
 .byt 4,%01100000,64,64
 .byt 1,%01000011,%01111111,%01110000
 .byt %01000010,6,$e7,4
 .byt %01010100,1,%01001100,4

ExitArrowWestGraphic_NoExit
 .byt 0,%01000001
 .byt 0,%01000010
 .byt 0,%01000111
 .byt 0,%01001111
 .byt 0,%01000111
 .byt 0,%01000011
 .byt 0,%01000001
ExitArrowWestGraphic_Exit
 .byt 2,%01000001
 .byt 7,%01000010
 .byt 2,%01000111
 .byt 2,%01001111
 .byt 2,%01000111
 .byt 2,%01000011
 .byt 2,%01000001
ExitArrowWestGraphic_Danger
 .byt 1,%01000001
 .byt 7,%01000010
 .byt 1,%01000111
 .byt 1,%01001111
 .byt 1,%01000111
 .byt 1,%01000011
 .byt 1,%01000001


eaWidth		.byt 0
eaBitpos
 .byt 1,2,4,8,16,32,64,128

;**************** Map Management
;Outside maps confined to Single level

GameMap_Outside_ScreenIDs
 .byt 00,01,02,03,04,05,06,07
 .byt 08,
GameMap_Outside_DangerFlags
 .byt 0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0

