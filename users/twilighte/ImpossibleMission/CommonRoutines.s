;CommonRoutines.s

nl_screen
	lda #40
AddScreen
	clc
	adc screen
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts	

SubScreen
.(
	sta vector1+1
	lda screen
	sec
vector1	sbc #00
.)
	sta screen
	lda screen+1
	sbc #00
	sta screen+1
	rts
AddSource	
	clc
	adc source
	sta source
	lda source+1
	adc #00
	sta source+1
	rts
	
FlushInputBuffer
	lda InputRegister
	bne FlushInputBuffer
	rts
	

;X==
; CONTROLLER_LEFT
; CONTROLLER_RIGHT
; CONTROLLER_FIRE
; CONTROLLER_UP
; CONTROLLER_DOWN
GetSpecificKey
	jsr FlushInputBuffer
.(
loop1	cpx InputRegister
	bne loop1
.)
	rts

;A==X
;Y==Y
;creates loc in screen
FetchCollisionMapLocation
	clc
FetchCollisionMapLocation2
	adc CollisionMapYLOCL_ForPixelYPOS,y
	sta screen
	lda CollisionMapYLOCH_ForPixelYPOS,y
	adc #00
	sta screen+1
	rts


GetRandomNumber
         lda rndRandom+1
         sta rndTemp
         lda rndRandom
         asl
         rol rndTemp
         asl
         rol rndTemp
         clc
         adc rndRandom
         adc VIA_T1CL
         pha
         lda rndTemp
         adc rndRandom+1
         sta rndRandom+1
         pla
         adc #$11
         sta rndRandom
         lda rndRandom+1
         adc #$36
         sta rndRandom+1
         rts

Display_LiftResets
	lda LiftResets	;0-99
	jsr CalcTensAndUnits
	sta $0201
	stx $0200
	jsr SetupTextBuffer4Line
	sta $0202
dlrRent1	ldx #23
	ldy #172
	lda #0
	jmp DisplayTextLine
	
CalcTensAndUnits
	ldx #47
	sec
.(
loop1	inx
	sbc #10
	bcs loop1
.)
	adc #58
	rts

Display_RobotSnoozes
	lda RobotSnoozes	;0-99
 	jsr CalcTensAndUnits
	sta $0201
	stx $0200
	jsr SetupTextBuffer4Line
	sta $0202
	ldx #28
	ldy #172
	lda #0
	jmp DisplayTextLine
	
AddHundredsScore
	ldx #1

	jmp ScoreSkip
AddUnitsScore
	ldx #02
ScoreSkip	jsr AddScore

Display_Score
	lda Score
	jsr SplitScore
	sta $0201
	stx $0200
	lda Score+1
	jsr SplitScore
	sta $0203
	stx $0202
	lda Score+2
	jsr SplitScore
	sta $0205
	stx $0204
	jsr SetupTextBuffer4Line
	sta $0206
	ldx #24
	ldy #163
	lda #00
	jmp DisplayTextLine
	
AddScore	sed
	clc
.(	
loop1	adc Score,x
	sta Score,x
	bcc skip1
	lda #00
	dex
	bpl loop1
skip1	cld
.)
	rts

SplitScore
	pha
	lsr
	lsr
	lsr
	lsr
	clc
	adc #48
	tax
	pla
	and #15
	adc #48
	rts

	

DisplayAudioState
	;Uses 38 and 47 chars
	lda #38
	ldx AudioFlag
.(
	bpl skip1
	lda #47
skip1	sta $0200
.)
	jsr SetupTextBuffer4Line
	sta $0201
	lda #1
	ldx #23
	ldy #154
	jmp DisplayTextLine


SetupTextBuffer4Line
	lda #2
	sta line+1
	lda #00
	sta line
	rts

CopyRoom2BGBuffer
	jsr SetupRoom2BGBuffer
	ldx #150
.(
loop2	ldy #39
loop1	lda (screen),y
	sta (source),y
	dey
	bpl loop1
	jsr nl_screen
	lda #40
	jsr AddSource
	dex
	bne loop2
.)
	rts	

SetupRoom2BGBuffer
	lda #<BGBuffer
	sta source
	lda #>BGBuffer
	sta source+1
	lda #<$A000
	sta screen
	lda #>$A000
	sta screen+1
	rts

;A==Row(0-149)
;Store result in A(Lo) and Y(Hi)
CalcBGBufferRowAddress
	ldy #00
	sty cbaTemp01
	;(x8)+(x32)
	asl
	rol cbaTemp01
	asl
	rol cbaTemp01
	asl
	rol cbaTemp01
	sta cbaTemp02
	ldy cbaTemp01
	sty cbaTemp03
	lda cbaTemp02
	asl
	rol cbaTemp01
	asl
	rol cbaTemp01
	adc cbaTemp02
	sta cbaTemp02
	lda cbaTemp01
	adc cbaTemp03
	sta cbaTemp01
	lda cbaTemp02
	adc #<BGBuffer
	sta cbaTemp02 
	lda cbaTemp01
	adc #>BGBuffer
	tay
	lda cbaTemp02
	rts

;Both BGBuffer and CollisionMap and placed alongside each other to provide 7040 bytes for sample
;at start of first game. Because of size of sample, its formatted as 2 bit which provides 28160 samples.
	
;BGBuffer needs to be one row more than 150 for it seems that lift shafts plotted on ground attempt to
;write to next row.
BGBuffer
 .dsb 6040,$40
;This memory (collision map) is used both for the Collision Map (CMAP) and Screen Map(SMAP) in the
;Maint lift shaft.
;For Rooms..
;B0-4	Objects
;	00    COL_BACKGROUND
;	01    COL_WALL
;	02    COL_ENTRANCE
;	03    COL_PLATFORM
;	04    COL_CHASM
;	05    COL_MAINFOYERLIFT
;	06    -
;	07    -
;	08-13 COL_FURNITUREITEM00-11
;	14-1C COL_LIFTPLATFORM0-7
;	1D-1F -
;B5-7	Enemies
;	1      Spark
;	2      Orb
;	3-7(6) Robots
;For Corridors(Lift Shaft)..
;B0-6	Cell Codes
;	00    LSM_BACKGROUND
;	01    LSM_WALL
;	02    LSM_ENTRANCE
;	03    LSM_PLATFORM
;	04    -
;	05    LSM_FOYERLIFT
;For Note Table
;B0-7
;	0-31 Sequence Index
;	128  No Note
CollisionMap
 .dsb 40*25,0

WaitUntilSFXFinished
	lda AudioFlag
.(
	bpl skip1
loop1	lda sfx_Status,x
	bne loop1
skip1	rts
.)

SilenceSFX
	sei
	lda #00
	sta sfx_Status
	sta sfx_Status+1
	sta sfx_Status+2
	sta ay_Volume
	sta ay_Volume+1
	sta ay_Volume+2
	jsr SendAYBank
	cli	
	rts

DisplayDifficulty
	ldx GameDifficulty
	inx
	txa
	jsr CalcTensAndUnits
	sta $0201
	stx $0200
	jsr SetupTextBuffer4Line
	sta $0202
	ldx #28
	ldy #154
	lda #0
	jmp DisplayTextLine
