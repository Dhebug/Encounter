;lvlLiftCage.s
;This is essentially a separate game since it uses a separate game loop
;Holds..
; 1) lift cage swing frames
; 2) BG mask scroller
; 3) code for progression
; 4) BG Rocky plateau Byte scroll
LevelSettings	.byt %00000011

LevelExit
LevelUnpack
	lda #<$a000+11+95*40
	sta screen2
	lda #>$a000+11+95*40
	sta screen2+1
	rts

DetermineContourMap
	ldx HeroY
DetermineContourMap2
	lda #<LevelFloorTable
	sta ContourFloor
	lda #>LevelFloorTable
	sta ContourFloor+1
	lda #<LevelCeilingTable
	sta ContourCeiling
	lda #>LevelCeilingTable
	sta ContourCeiling+1
	rts
LevelCeilingTable
 .dsb 40,0
LevelFloorTable
 .dsb 13,39
 .dsb 29,58

;As Lift cage is swung and moved theoretically forward so to must the gravity bounce the cage
;and in so doing echo the bounce in the cable supporting it!
LevelRun
	lda LiftCageDelay
	clc
	adc #128
	sta LiftCageDelay
.(
	bcc skip2

	ldx LiftCageIndex
	lda Table1,x
	sta LiftCageFrame
	jsr PlotLiftCage
	lda LiftCageIndex
	clc
	adc #1
	cmp #12
	bcc skip1
	lda #00
skip1	sta LiftCageIndex
skip2
.)
	jsr ControlScroll
	jsr ManageCable
	rts

ManageCable
	;Default to frame0 until getrocksoff
	lda RockyPlateauPresent
.(
	bne skip1

	ldx LiftCageFrame	;0-6
	lda CablePosition,x
	bmi skip2
	beq skip1
	jsr DeleteCableFrame0
	jsr DeleteCableFrame2
	jsr PlotCableFrame1
	rts
skip2	jsr DeleteCableFrame1
	jsr DeleteCableFrame0
	jsr PlotCableFrame2
	rts
skip1	jsr DeleteCableFrame1
.)
	jsr DeleteCableFrame2
	jsr PlotCableFrame0
	rts




CablePosition
 .byt 0,1,128,128,128,1,0
Table1
 .byt 0,1,2,3,4,5,6,5,4,3,2,1
LiftCageIndex		.byt 0
LiftCageFrame		.byt 0
LiftCageDelay		.byt 0
DeleteMechanism
PlotLiftCage
	;Delete mechanism atop previous frame (relies on oddscn not used)
	ldy #05
	lda #64
.(
loop1	sta (screen2),y
	dey
	bpl loop1
.)
	ldx LiftCageFrame	;0-6
	lda LiftCageAddressLo,x
	sta source
	lda LiftCageAddressHi,x
	sta source+1
	lda LiftCageYLocLo,x
	clc
	adc LiftCageXPos,x
	sta screen
	sta screen2
	lda LiftCageYLocHi,x
	adc #00
	sta screen+1
	sta screen2+1
	ldx #30
.(
loop2	ldy #5
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1

	lda source
	adc #5
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



LiftCageAddressLo	;Numbers relate to angle so 10r is 10 degrees right
 .byt <LiftCage10l
 .byt <LiftCage5l
 .byt <LiftCage2l
 .byt <LiftCage0
 .byt <LiftCage2r
 .byt <LiftCage5r
 .byt <LiftCage10r
LiftCageAddressHi
 .byt >LiftCage10l
 .byt >LiftCage5l
 .byt >LiftCage2l
 .byt >LiftCage0
 .byt >LiftCage2r
 .byt >LiftCage5r
 .byt >LiftCage10r
;000000 000000 000000 001100  -1
;000000 000000 000000 011000  -1
;000000 000000 000011 000000  0
;000000 000000 000001 100000  0
;000000 000000 000000 110000  0
;000000 000000 000110 000000  +1
;000000 000000 001100 000000  +1
LiftCageXPos	;Index by Frame
 .byt 8,8,9,9,9,10,10
LiftCageYLocLo	;Index by Frame
 .byt <$a000+40*95
 .byt <$a000+40*96
 .byt <$a000+40*96
 .byt <$a000+40*97
 .byt <$a000+40*96
 .byt <$a000+40*96
 .byt <$a000+40*95
LiftCageYLocHi	;Index by Frame
 .byt >$a000+40*95
 .byt >$a000+40*96
 .byt >$a000+40*96
 .byt >$a000+40*97
 .byt >$a000+40*96
 .byt >$a000+40*96
 .byt >$a000+40*95

LiftCage10l	;5x30 (150) x 7 == 1050 Bytes
;		   X
 .byt $40,$40,$05,$4C,$40
 .byt $40,$40,$40,$40,$40
 .byt $40,$40,$06,$58,$40
 .byt $40,$02,$43,$7C,$40
 .byt $40,$06,$5E,$5E,$40
 .byt $02,$41,$78,$73,$60
 .byt $40,$06,$4F,$78,$70
 .byt $05,$43,$02,$4F,$7C
 .byt $40,$40,$40,$40,$40
 .byt $01,$43,$40,$05,$4C
 .byt $40,$03,$43,$40,$40
 .byt $01,$46,$40,$01,$4C
 .byt $40,$01,$43,$40,$40
 .byt $01,$46,$40,$01,$58
 .byt $40,$02,$5B,$58,$40
 .byt $01,$46,$40,$01,$58
 .byt $01,$43,$02,$46,$40
 .byt $01,$4C,$40,$40,$58
 .byt $40,$01,$43,$43,$40
 .byt $01,$4C,$40,$40,$70
 .byt $40,$06,$4D,$60,$40
 .byt $01,$4C,$40,$40,$70
 .byt $40,$06,$59,$60,$40
 .byt $01,$58,$40,$40,$70
 .byt $01,$41,$06,$70,$40
 .byt $03,$58,$01,$41,$60
 .byt $07,$43,$01,$50,$40
 .byt $07,$5F,$03,$41,$60
 .byt $40,$07,$7F,$78,$40
 .byt $40,$40,$07,$5F,$40
LiftCage5l
 .byt $40,$40,$05,$58,$40
 .byt $40,$40,$40,$40,$40
 .byt $40,$06,$43,$70,$40
 .byt $40,$02,$4E,$7C,$40
 .byt $40,$06,$78,$77,$40
 .byt $02,$43,$7F,$71,$70
 .byt $40,$06,$41,$7F,$7C
 .byt $05,$43,$40,$40,$40
 .byt $40,$03,$43,$05,$4C
 .byt $01,$43,$40,$40,$40
 .byt $40,$01,$43,$01,$4C
 .byt $01,$46,$40,$40,$40
 .byt $40,$02,$4D,$01,$58
 .byt $01,$46,$02,$58,$40
 .byt $01,$41,$60,$01,$58
 .byt $01,$46,$01,$43,$40
 .byt $40,$01,$43,$01,$58
 .byt $01,$46,$40,$40,$40
 .byt $40,$06,$4C,$01,$58
 .byt $01,$46,$06,$60,$40
 .byt $40,$06,$58,$01,$70
 .byt $01,$4C,$06,$70,$40
 .byt $40,$06,$70,$01,$70
 .byt $01,$4C,$06,$58,$40
 .byt $01,$41,$07,$01,$70
 .byt $03,$4C,$01,$48,$40
 .byt $07,$43,$40,$03,$70
 .byt $07,$4F,$7E,$4C,$40
 .byt $40,$07,$41,$7F,$70
 .byt $40,$40,$40,$40,$40
LiftCage2l
 .byt $40,$05,$43,$40,$40
 .byt $40,$40,$40,$40,$40
 .byt $40,$06,$43,$40,$40
 .byt $40,$02,$4F,$70,$40
 .byt $40,$06,$7F,$5C,$40
 .byt $02,$43,$73,$47,$40
 .byt $06,$4F,$7F,$7F,$60
 .byt $40,$40,$40,$40,$40
 .byt $05,$4C,$40,$41,$60
 .byt $40,$03,$46,$40,$40
 .byt $01,$4C,$40,$41,$60
 .byt $40,$01,$46,$40,$40
 .byt $01,$4C,$40,$41,$60
 .byt $40,$02,$47,$40,$40
 .byt $01,$4C,$40,$41,$60
 .byt $40,$02,$58,$70,$40
 .byt $01,$4C,$40,$41,$60
 .byt $01,$43,$46,$4C,$40
 .byt $01,$58,$40,$43,$40
 .byt $06,$40,$45,$40,$40
 .byt $01,$58,$40,$43,$40
 .byt $06,$40,$4D,$60,$40
 .byt $01,$58,$40,$43,$40
 .byt $06,$40,$59,$60,$40
 .byt $01,$58,$40,$43,$40
 .byt $01,$40,$60,$60,$40
 .byt $03,$58,$40,$43,$40
 .byt $07,$41,$60,$70,$40
 .byt $07,$5F,$7F,$7F,$40
 .byt $40,$40,$40,$40,$40
LiftCage0
 .byt $40,$05,$41,$60,$40
 .byt $40,$40,$40,$40,$40
 .byt $40,$06,$41,$60,$40
 .byt $40,$02,$47,$78,$40
 .byt $40,$06,$5D,$6E,$40
 .byt $02,$41,$71,$63,$60
 .byt $06,$47,$7F,$7F,$78
 .byt $40,$40,$40,$40,$40
 .byt $05,$46,$40,$40,$58
 .byt $40,$03,$41,$60,$40
 .byt $01,$46,$40,$40,$58
 .byt $40,$01,$41,$60,$40
 .byt $01,$46,$40,$40,$58
 .byt $40,$02,$46,$58,$40
 .byt $01,$46,$40,$40,$58
 .byt $40,$02,$58,$46,$40
 .byt $01,$46,$40,$40,$58
 .byt $01,$41,$61,$61,$60
 .byt $01,$46,$40,$40,$58
 .byt $06,$40,$42,$70,$40
 .byt $01,$46,$40,$40,$58
 .byt $06,$40,$46,$58,$40
 .byt $01,$46,$40,$40,$58
 .byt $06,$40,$4C,$4C,$40
 .byt $01,$46,$40,$40,$58
 .byt $01,$40,$48,$44,$40
 .byt $03,$46,$40,$40,$58
 .byt $07,$40,$58,$46,$40
 .byt $07,$47,$7F,$7F,$78
 .byt $40,$40,$40,$40,$40
LiftCage2r
 .byt $40,$40,$05,$70,$40
 .byt $40,$40,$40,$40,$40
 .byt $40,$40,$06,$70,$40
 .byt $40,$02,$43,$7C,$40
 .byt $40,$06,$4E,$7F,$40
 .byt $40,$02,$78,$73,$70
 .byt $06,$41,$7F,$7F,$7C
 .byt $40,$40,$40,$40,$40
 .byt $05,$41,$60,$40,$4C
 .byt $40,$40,$03,$58,$40
 .byt $01,$41,$60,$40,$4C
 .byt $40,$40,$01,$58,$40
 .byt $01,$41,$60,$40,$4C
 .byt $40,$40,$02,$78,$40
 .byt $01,$41,$60,$40,$4C
 .byt $40,$02,$43,$46,$40
 .byt $01,$41,$60,$40,$4C
 .byt $40,$01,$4C,$58,$70
 .byt $40,$01,$70,$40,$46
 .byt $40,$40,$06,$68,$40
 .byt $40,$01,$70,$40,$46
 .byt $40,$06,$41,$6C,$40
 .byt $40,$01,$70,$40,$46
 .byt $40,$06,$41,$66,$40
 .byt $40,$01,$70,$40,$46
 .byt $40,$01,$41,$41,$40
 .byt $40,$03,$70,$40,$46
 .byt $40,$07,$43,$41,$60
 .byt $40,$07,$7F,$7F,$7E
 .byt $40,$40,$40,$40,$40
LiftCage5r
 .byt $40,$05,$46,$40,$40
 .byt $40,$40,$40,$40,$40
 .byt $40,$06,$43,$70,$40
 .byt $40,$02,$4F,$5C,$40
 .byt $40,$06,$7B,$47,$40
 .byt $02,$43,$63,$7F,$70
 .byt $06,$4F,$7F,$60,$40
 .byt $40,$40,$40,$05,$70
 .byt $05,$4C,$03,$70,$40
 .byt $40,$40,$01,$40,$70
 .byt $01,$4C,$01,$70,$40
 .byt $40,$40,$01,$40,$58
 .byt $01,$46,$02,$6C,$40
 .byt $40,$02,$46,$01,$58
 .byt $01,$46,$01,$41,$60
 .byt $40,$01,$70,$01,$58
 .byt $01,$46,$01,$70,$40
 .byt $40,$40,$40,$01,$58
 .byt $01,$46,$06,$4C,$40
 .byt $40,$06,$41,$01,$58
 .byt $01,$43,$06,$46,$40
 .byt $40,$06,$43,$01,$4C
 .byt $01,$43,$06,$43,$40
 .byt $40,$06,$46,$01,$4C
 .byt $01,$43,$01,$40,$60
 .byt $40,$01,$44,$03,$4C
 .byt $03,$43,$40,$07,$70
 .byt $40,$07,$4C,$5F,$7C
 .byt $07,$43,$7F,$60,$40
 .byt $40,$40,$40,$40,$40
LiftCage10r
 .byt $40,$05,$4C,$40,$40
 .byt $40,$40,$40,$40,$40
 .byt $40,$06,$46,$40,$40
 .byt $40,$02,$4F,$70,$40
 .byt $40,$06,$5E,$5E,$40
 .byt $02,$41,$73,$47,$60
 .byt $06,$43,$47,$7C,$40
 .byt $02,$4F,$7C,$05,$70
 .byt $40,$40,$40,$40,$40
 .byt $05,$4C,$40,$01,$70
 .byt $40,$40,$03,$70,$40
 .byt $01,$4C,$40,$40,$58
 .byt $40,$40,$01,$70,$40
 .byt $01,$46,$40,$40,$58
 .byt $40,$02,$46,$76,$40
 .byt $01,$46,$40,$40,$58
 .byt $40,$02,$58,$01,$70
 .byt $01,$46,$40,$40,$4C
 .byt $40,$01,$70,$70,$40
 .byt $01,$43,$40,$40,$4C
 .byt $40,$06,$41,$6C,$40
 .byt $01,$43,$40,$40,$4C
 .byt $40,$06,$41,$66,$40
 .byt $01,$43,$40,$40,$46
 .byt $40,$06,$43,$01,$60
 .byt $01,$41,$60,$03,$46
 .byt $40,$01,$42,$07,$70
 .byt $03,$41,$60,$07,$7E
 .byt $07,$40,$47,$7F,$40
 .byt $40,$07,$7E,$40,$40
 .byt $40,$40,$40,$40,$40
LevelProse
 .byt "Up, up and away..                  "
 .byt "Swing, swing high                  "
 .byt "sweet chariot                      "
 .byt "If you catch this ryhme then       "
 .byt "catch that rythm.                  "
 .byt "                                   "
 .byt "                                   "
LevelScreen
#include "NoCage.s"

GetRocksOff
	lda #<$A001+103*40
	sta screen
	lda #>$A001+103*40
	sta screen+1

	ldx #62
.(
loop2	ldy #01
loop1	lda (screen),y
	dey
	sta (screen),y
	iny
	iny
	cpy #8
	bcc loop1

	lda screen
	clc
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1

	dex

	bne loop2
.)
	dec RockyPlateauPresent
	rts

;The scrollable screen area is 96x32 which equates to 16x16 Bytes
RockyPlateauPresent	.byt 7

ControlScroll
	lda RockyPlateauPresent
.(
	beq skip2
	jsr GetRocksOff		;hehe
skip2
	lda LandContourIndex
	cmp #255
	beq skip3

	jsr SmoothScrollLeft256byteMask
	jsr ssFillRightBitColumn
	jsr MonitorLHSColumn
	lsr rbcBit
	bcc skip1

	lda #32
	sta rbcBit
	inc LandContourIndex

	jsr ScrollDown256ByteMask
	jsr ssFillTopByteRow

skip1	jsr ssCombineAndZoom
skip3	rts
.)
ScrollXCount	.byt 0
rbcBit
 .byt 32

ssCombineAndZoom
	lda #<lcWorkWindow
	sta bgmask
	lda #>lcWorkWindow
	sta bgmask+1

	lda #<lcBackGround
	sta source
	lda #>lcBackGround
	sta source+1

	lda #<$a001+47*40
	sta screen
	lda #>$a001+47*40
	sta screen+1

	clc
	ldx #16
.(
loop2	ldy #15
loop1	lda (source),y
	and (bgmask),y
	sta (screen),y
	dey
	bpl loop1

	lda bgmask
	adc #16
	sta bgmask
	lda bgmask+1
	adc #00
	sta bgmask+1

	lda source
	adc #16
	sta source
	lda source+1
	adc #00
	sta source+1

	lda screen
	adc #80
	sta screen
	lda screen+1
	adc #00
	sta screen+1

	dex
	bne loop2
.)
	rts



ssFillRightBitColumn

	lda #<lcWorkWindow+15
	sta screen
	lda #>lcWorkWindow+15
	sta screen+1
	clc
	ldx #16
	ldy #00
.(
loop1	lda (screen),y
	and #%01111110
	sta (screen),y

	lda screen
	adc #16
	sta screen
	lda screen+1
	adc #00
	sta screen+1

	dex
	bne loop1
.)
	rts

ssFillTopByteRow
	;Fill row
	ldy LandContourIndex
	ldx LandContourLevels,y
	ldy lcXLOC,x
	lda #127
.(
loop1	sta lcWorkWindow,y
	dey
	bpl loop1
.)
	;Empty row right of LandContourLevel
	ldy LandContourIndex
	ldx LandContourLevels,y
	ldy lcXLOC,x
	lda lcBitMask,x
.(
loop1	sta lcWorkWindow,y
	lda #64
	iny
	cpy #16
	bcc loop1
.)

	rts
MonitorLHSColumn
	lda #<$a001+47*40
	sta screen
	lda #>$a001+47*40
	sta screen+1
	ldx #00
	ldy #00
.(
loop1	lda (screen),y
	and #%00100000
	bne skip1

	txa
	ldx LandContourIndex
	sta LHSContour,x
	rts

skip1	lda screen
	clc
	adc #80
	sta screen
	lda screen+1
	adc #00
	sta screen+1

	inx
	cpx #32
	bcc loop1
.)
	rts
LandContourIndex	.byt 0
LHSContour
 .dsb 256,0
LandContourLevels
 .byt 95
 .byt 91
 .byt 90
 .byt 87
 .byt 88
 .byt 91
 .byt 92
 .byt 92
 .byt 91
 .byt 89
 .byt 93
 .byt 89
 .byt 86
 .byt 88
 .byt 91
 .byt 92
 .byt 92
 .byt 95
 .byt 91
 .byt 87
 .byt 91
 .byt 91
 .byt 94
 .byt 92
 .byt 95
 .byt 95
 .byt 95
 .byt 95
 .byt 95
 .byt 95
 .byt 91
 .byt 89
 .byt 89
 .byt 86
 .byt 86
 .byt 82
 .byt 84
 .byt 83
 .byt 86
 .byt 86
 .byt 87
 .byt 84
 .byt 84
 .byt 82
 .byt 83
 .byt 81
 .byt 78
 .byt 76
 .byt 72
 .byt 68
 .byt 69
 .byt 67
 .byt 66
 .byt 63
 .byt 65
 .byt 68
 .byt 64
 .byt 60
 .byt 57
 .byt 56
 .byt 53
 .byt 56
 .byt 53
 .byt 50
 .byt 50
 .byt 50
 .byt 54
 .byt 51
 .byt 51
 .byt 49
 .byt 52
 .byt 48
 .byt 48
 .byt 49
 .byt 49
 .byt 53
 .byt 52
 .byt 52
 .byt 49
 .byt 52
 .byt 49
 .byt 51
 .byt 50
 .byt 51
 .byt 49
 .byt 50
 .byt 76
 .byt 70
 .byt 68
 .byt 63
 .byt 57
 .byt 52
 .byt 50
 .byt 48
 .byt 46
 .byt 44
 .byt 47
 .byt 48
 .byt 44
 .byt 43
 .byt 42
 .byt 42
 .byt 43
 .byt 39
 .byt 38
 .byt 39
 .byt 35
 .byt 37
 .byt 38
 .byt 35
 .byt 33
 .byt 36
 .byt 39
 .byt 39
 .byt 43
 .byt 46
 .byt 46
 .byt 49
 .byt 48
 .byt 49
 .byt 46
 .byt 48
 .byt 52
 .byt 48
 .byt 45
 .byt 45
 .byt 43
 .byt 43
 .byt 41
 .byt 43
 .byt 42
 .byt 42
 .byt 40
 .byt 38
 .byt 39
 .byt 36
 .byt 34
 .byt 36
 .byt 37
 .byt 39
 .byt 39
 .byt 41
 .byt 42
 .byt 44
 .byt 43
 .byt 40
 .byt 38
 .byt 42
 .byt 46
 .byt 45
 .byt 47
 .byt 49
 .byt 53
 .byt 57
 .byt 60
 .byt 95
 .byt 92
 .byt 90
 .byt 91
 .byt 87
 .byt 83
 .byt 80
 .byt 77
 .byt 76
 .byt 72
 .byt 70
 .byt 71
 .byt 67
 .byt 63
 .byt 60
 .byt 58
 .byt 59
 .byt 60
 .byt 56
 .byt 55
 .byt 50
 .byt 48
 .byt 44
 .byt 43
 .byt 46
 .byt 48
 .byt 48
 .byt 47
 .byt 51
 .byt 53
 .byt 52
 .byt 52
 .byt 51
 .byt 52
 .byt 49
 .byt 45
 .byt 41
 .byt 45
 .byt 47
 .byt 49
 .byt 49
 .byt 48
 .byt 49
 .byt 50
 .byt 53
 .byt 51
 .byt 50
 .byt 49
 .byt 50
 .byt 52
 .byt 52
 .byt 50
 .byt 48
 .byt 45
 .byt 44
 .byt 42
 .byt 44
 .byt 42
 .byt 38
 .byt 41
 .byt 43
 .byt 43
 .byt 41
 .byt 43
 .byt 40
 .byt 40
 .byt 42
 .byt 48
 .byt 70
 .byt 65
 .byt 60
 .byt 55
 .byt 52
 .byt 47
 .byt 48
 .byt 48
 .byt 48
 .byt 52
 .byt 49
 .byt 45
 .byt 44
 .byt 45
 .byt 45
 .byt 43
 .byt 43
 .byt 39
 .byt 39
 .byt 42
 .byt 41
 .byt 44
 .byt 40
 .byt 44
 .byt 41
 .byt 40
 .byt 40
 .byt 36
 .byt 38
 .byt 36
 .byt 39
 .byt 40
 .byt 37


lcXLOC		;Indexed by LandContourLevel
 .dsb 6,0
 .dsb 6,1
 .dsb 6,2
 .dsb 6,3
 .dsb 6,4
 .dsb 6,5
 .dsb 6,6
 .dsb 6,7
 .dsb 6,8
 .dsb 6,9
 .dsb 6,10
 .dsb 6,11
 .dsb 6,12
 .dsb 6,13
 .dsb 6,14
 .dsb 6,15
lcBitMask	;Indexed by LandContourLevel
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01100000,%01110000,%01111000,%01111100,%01111110,%01111111

SmoothScrollLeft256byteMask
	ldx #255
	clc
.(
loop1	lda lcWorkWindow,x
	rol
	cmp #128+64
	and #63
	ora #64
	sta lcWorkWindow,x
	dex
	bne loop1
	;process Entry 00
	lda lcWorkWindow
	rol
	and #63
	ora #64
	sta lcWorkWindow
.)
	rts

ScrollDown256ByteMask	;Arranged as 16x16
	ldx #255-16
.(
loop1	lda lcWorkWindow,x
	sta lcWorkWindow+16,x
	dex
	bne loop1
.)
	;Process Entry 00
	lda lcWorkWindow
	sta lcWorkWindow+16
	rts

;lcBackGround - Static sky and Clouds
;lcWorkWindow - The 16x16 Work area that is scrolled
;screen       - Where everything is combined to!
lcWorkWindow
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$40,$40
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$78,$40,$40
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$40,$40,$40
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$78,$40,$40,$40
 .byt $40,$40,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$40,$40,$40
 .byt $40,$40,$43,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$40,$40,$40,$40
 .byt $40,$40,$40,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$70,$40,$40,$40
 .byt $40,$40,$40,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$40,$40,$40,$40
 .byt $40,$40,$40,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$60,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$7F,$7F,$7F,$7F,$7F,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$43,$7F,$7F,$7F,$7F,$78,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$7F,$7F,$7F,$78,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
;
;
;.byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$70,$40,$40
;.byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7D,$78,$40,$40
;.byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$70,$40,$40,$40
;.byt $7E,$6A,$6F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$78,$40,$40,$40
;.byt $40,$40,$6B,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$40,$40,$40
;.byt $40,$40,$43,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$40,$40,$40,$40
;.byt $40,$40,$40,$7B,$7F,$7D,$7F,$7F,$7F,$7F,$7F,$7F,$70,$40,$40,$40
;.byt $40,$40,$40,$7B,$7B,$77,$7F,$7F,$7F,$7F,$7F,$7F,$40,$40,$40,$40
;.byt $40,$40,$40,$76,$6A,$6F,$7F,$7F,$7F,$7F,$7F,$60,$40,$40,$40,$40
;.byt $40,$40,$40,$40,$40,$6B,$7F,$7F,$7F,$7F,$40,$40,$40,$40,$40,$40
;.byt $40,$40,$40,$40,$40,$43,$7F,$7F,$7F,$7F,$78,$40,$40,$40,$40,$40
;.byt $40,$40,$40,$40,$40,$40,$7F,$7F,$7F,$78,$40,$40,$40,$40,$40,$40
;.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
;.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
;.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
;.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
lcBackGround
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$7F,$7A,$6A
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6B,$7F,$7F,$7F,$7A
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6F,$7F,$7F,$7F,$7F
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6B,$7F,$7F,$6A,$7F,$7F,$7F,$7F,$7F
 .byt $6A,$6A,$6A,$6A,$7F,$7A,$6A,$7F,$7F,$7F,$7E,$7F,$7F,$7F,$7F,$7F
 .byt $6A,$6A,$6A,$6F,$7F,$7F,$6B,$7F,$7F,$7F,$7E,$7F,$7F,$7F,$7F,$7F
 .byt $6A,$6A,$6A,$7F,$7F,$7F,$7B,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $6A,$6A,$6A,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $6B,$7F,$6B,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $6F,$7F,$7B,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F

PlotCableFrame0
	ldy #00
	ldx #22
.(
loop1	lda CableScreenLocationFrame0Lo,x
	sta screen
	lda CableScreenLocationFrame0Hi,x
	sta screen+1
	lda #%01000001
	sta (screen),y
	dex
	bpl loop1
.)
	rts
DeleteCableFrame0
	ldy #00
	ldx #22
.(
loop1	lda CableScreenLocationFrame0Lo,x
	sta screen
	lda CableScreenLocationFrame0Hi,x
	sta screen+1
	lda #%01000000
	sta (screen),y
	dex
	bpl loop1
.)
	rts

PlotCableFrame1
	ldy #00
	ldx #22
.(
loop1	lda CableScreenLocationFrame1Lo,x
	sta screen
	lda CableScreenLocationFrame1Hi,x
	sta screen+1
	lda #%01001000
	sta (screen),y
	dex
	bpl loop1
.)
	rts
DeleteCableFrame1
	ldy #00
	ldx #22
.(
loop1	lda CableScreenLocationFrame1Lo,x
	sta screen
	lda CableScreenLocationFrame1Hi,x
	sta screen+1
	lda #%01000000
	sta (screen),y
	dex
	bpl loop1
.)
	rts
PlotCableFrame2
	ldy #00
	ldx #22
.(
loop1	lda CableScreenLocationFrame2Lo,x
	sta screen
	lda CableScreenLocationFrame2Hi,x
	sta screen+1
	lda #%01001000
	sta (screen),y
	dex
	bpl loop1
.)
	rts
DeleteCableFrame2
	ldy #00
	ldx #22
.(
loop1	lda CableScreenLocationFrame2Lo,x
	sta screen
	lda CableScreenLocationFrame2Hi,x
	sta screen+1
	lda #%01000000
	sta (screen),y
	dex
	bpl loop1
.)
	rts

;ControlCable
CableScreenLocationFrame0Lo
 .byt <$a000+1+40*102
 .byt <$a000+2+40*102
 .byt <$a000+3+40*101
 .byt <$a000+4+40*100
 .byt <$a000+5+40*99
 .byt <$a000+6+40*98
 .byt <$a000+7+40*97
 .byt <$a000+8+40*96
 .byt <$a000+9+40*94
 .byt <$a000+10+40*92
 .byt <$a000+11+40*90
 .byt <$a000+12+40*88
 .byt <$a000+13+40*85
 .byt <$a000+14+40*82
 .byt <$a000+15+40*79
 .byt <$a000+16+40*76
 .byt <$a000+17+40*72
 .byt <$a000+18+40*68
 .byt <$a000+19+40*64
 .byt <$a000+20+40*60
 .byt <$a000+21+40*56
 .byt <$a000+22+40*52
 .byt <$a000+23+40*48
CableScreenLocationFrame0Hi
 .byt >$a000+1+40*102
 .byt >$a000+2+40*102
 .byt >$a000+3+40*101
 .byt >$a000+4+40*100
 .byt >$a000+5+40*99
 .byt >$a000+6+40*98
 .byt >$a000+7+40*97
 .byt >$a000+8+40*96
 .byt >$a000+9+40*94
 .byt >$a000+10+40*92
 .byt >$a000+11+40*90
 .byt >$a000+12+40*88
 .byt >$a000+13+40*85
 .byt >$a000+14+40*82
 .byt >$a000+15+40*79
 .byt >$a000+16+40*76
 .byt >$a000+17+40*72
 .byt >$a000+18+40*68
 .byt >$a000+19+40*64
 .byt >$a000+20+40*60
 .byt >$a000+21+40*56
 .byt >$a000+22+40*52
 .byt >$a000+23+40*48
CableScreenLocationFrame1Lo
 .byt <$a000+1+40*104
 .byt <$a000+2+40*104
 .byt <$a000+3+40*103
 .byt <$a000+4+40*102
 .byt <$a000+5+40*101
 .byt <$a000+6+40*100
 .byt <$a000+7+40*99
 .byt <$a000+8+40*98
 .byt <$a000+9+40*96
 .byt <$a000+10+40*94
 .byt <$a000+11+40*92
 .byt <$a000+12+40*90
 .byt <$a000+13+40*87
 .byt <$a000+14+40*84
 .byt <$a000+15+40*81
 .byt <$a000+16+40*78
 .byt <$a000+17+40*74
 .byt <$a000+18+40*70
 .byt <$a000+19+40*66
 .byt <$a000+20+40*62
 .byt <$a000+21+40*58
 .byt <$a000+22+40*54
 .byt <$a000+23+40*50
CableScreenLocationFrame1Hi
 .byt >$a000+1+40*104
 .byt >$a000+2+40*104
 .byt >$a000+3+40*103
 .byt >$a000+4+40*102
 .byt >$a000+5+40*101
 .byt >$a000+6+40*100
 .byt >$a000+7+40*99
 .byt >$a000+8+40*98
 .byt >$a000+9+40*96
 .byt >$a000+10+40*94
 .byt >$a000+11+40*92
 .byt >$a000+12+40*90
 .byt >$a000+13+40*87
 .byt >$a000+14+40*84
 .byt >$a000+15+40*81
 .byt >$a000+16+40*78
 .byt >$a000+17+40*74
 .byt >$a000+18+40*70
 .byt >$a000+19+40*66
 .byt >$a000+20+40*62
 .byt >$a000+21+40*58
 .byt >$a000+22+40*54
 .byt >$a000+23+40*50

CableScreenLocationFrame2Lo
 .byt <$a000+1+40*106
 .byt <$a000+2+40*106
 .byt <$a000+3+40*105
 .byt <$a000+4+40*104
 .byt <$a000+5+40*103
 .byt <$a000+6+40*102
 .byt <$a000+7+40*101
 .byt <$a000+8+40*100
 .byt <$a000+9+40*98
 .byt <$a000+10+40*96
 .byt <$a000+11+40*94
 .byt <$a000+12+40*92
 .byt <$a000+13+40*89
 .byt <$a000+14+40*86
 .byt <$a000+15+40*83
 .byt <$a000+16+40*80
 .byt <$a000+17+40*76
 .byt <$a000+18+40*72
 .byt <$a000+19+40*68
 .byt <$a000+20+40*64
 .byt <$a000+21+40*60
 .byt <$a000+22+40*56
 .byt <$a000+23+40*52
CableScreenLocationFrame2Hi
 .byt >$a000+1+40*106
 .byt >$a000+2+40*106
 .byt >$a000+3+40*105
 .byt >$a000+4+40*104
 .byt >$a000+5+40*103
 .byt >$a000+6+40*102
 .byt >$a000+7+40*101
 .byt >$a000+8+40*100
 .byt >$a000+9+40*98
 .byt >$a000+10+40*96
 .byt >$a000+11+40*94
 .byt >$a000+12+40*92
 .byt >$a000+13+40*89
 .byt >$a000+14+40*86
 .byt >$a000+15+40*83
 .byt >$a000+16+40*80
 .byt >$a000+17+40*76
 .byt >$a000+18+40*72
 .byt >$a000+19+40*68
 .byt >$a000+20+40*64
 .byt >$a000+21+40*60
 .byt >$a000+22+40*56
 .byt >$a000+23+40*52
