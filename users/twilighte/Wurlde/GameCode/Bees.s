;Bees.s

;follow simple figure
BeeDriver
	ldx #05
.(
loop1
	;Sort new Bee position

	ldy BeeWaveNumber,x
	lda WaveTableXAddressLo,y
	sta source
	lda WaveTableXAddressHi,y
	sta source+1
	lda WaveTableYAddressLo,y
	sta header
	lda WaveTableYAddressHi,y
	sta header+1

	;Delete Bee
	jsr DeleteBee
	;
	ldy BeeWaveIndex,x
	lda BeeX,x
	clc
	adc (source),y
	sta BeeX,x
	lda BeeY,x
	clc
	adc (header),y
	sta BeeY,x
	;Plot Bee
	jsr PlotBee
	;Sort Figure wave
	dec BeeWaveIndex,x
	bpl skip1

	;Keep bee away from edges
	lda BeeX,x
	cmp #40
	bcc TendBeeRight
	cmp #200
	bcs TendBeeLeft
	lda BeeY,x
	cmp #37
	bcc TendBeeDown
	cmp #44
	bcs TendBeeUp
	;Bee Ok
	jsr SetupBeeOkWave
rent1	sta BeeWaveNumber,x
	lda #9
	sta BeeWaveIndex,x

skip1	dex
	bpl loop1

	jsr PlotHero
	rts

TendBeeRight
	;Check if need to tend bee vertically as well
	lda BeeY,x
	cmp #35
	bcc TendBeeDownRight
	cmp #48
	bcs TendBeeUpRight
	;Just Tend Right
	lda #3
	jmp rent1
TendBeeDownRight
	lda #5
	jmp rent1
TendBeeUpRight
;	jsr CheckLanded
	lda #7
	jmp rent1

TendBeeLeft
	lda BeeY,x
	cmp #35
	bcc TendBeeDownLeft
	cmp #48
	bcs TendBeeUpLeft
	;Just Tend Left
	lda #2
	jmp rent1
TendBeeDownLeft
	lda #4
	jmp rent1
TendBeeUpLeft
;	jsr CheckLanded
	lda #6
	jmp rent1
;By the time we reach these two, the tending of horizontal is redundant, so just rnd left or right
TendBeeDown
	lda rndRandom
	and #01
	clc
	adc #4
	jmp rent1
TendBeeUp
	lda rndRandom
	and #1
	clc
	adc #6
	jmp rent1

.)


SetupBeeOkWave
	lda rndRandom
	and #7
	;Prevent same wave being used immediately after
	cmp BeeWaveNumber,x
.(
	bne rent1
	sbc #01
	bpl rent1
	lda #7
rent1	rts
.)

DeleteBee	;3x2
	ldy BeeX,x
	lda BeesXOFS,y
	ldy BeeY,x
	clc
	adc SYLocl,y
	sta screen
	lda SYLoch,y
	adc #00
	sta screen+1
	lda #64
	ldy #40
	sta (screen),y
	iny
	sta (screen),y
	iny
	sta (screen),y
	ldy #120
	sta (screen),y
	iny
	sta (screen),y
	iny
	sta (screen),y
	rts
PlotBee
	ldy BeeX,x
	lda BeesSprite,y
	tay
	lda BeeFrameVectorLo,y
.(
	sta vector1+1
	lda BeeFrameVectorHi,y
	sta vector1+2

	ldy BeeX,x
	lda BeesXOFS,y
	ldy BeeY,x
	clc
	adc SYLocl,y
	sta screen
	lda SYLoch,y
	adc #00
	sta screen+1
	stx BeesTempX

	ldx #05
loop1
vector1	lda $dead,x
	ldy BeesScreenIndex,x
	sta (screen),y
	dex
	bpl loop1
.)
	ldx BeesTempX
	rts

WaveTableXAddressLo				;Tend Bee  Left  Right  Up  Down
 .byt <FigureC0X	;0 Clockwise circulate
 .byt <FigureA0X	;1 Anticlockwise Circulate
 .byt <FigureHLX	;2 Hover(Fly) Left                   x
 .byt <FigureHRX	;3 Hove(Fly) Right                         x
 .byt <FigureDLX	;4 Dive Left                         x                x
 .byt <FigureDRX	;5 Dive Right                              x          x
 .byt <FigureRLX	;6 Rise Left                         x           x
 .byt <FigureRRX	;7 Rise Right                              x     x
WaveTableXAddressHi
 .byt >FigureC0X	;Clockwise circulate
 .byt >FigureA0X	;Anticlockwise Circulate
 .byt >FigureHLX	;Hover(Fly) Left
 .byt >FigureHRX	;Hove(Fly) Right
 .byt >FigureDLX	;Dive Left
 .byt >FigureDRX	;Dive Right
 .byt >FigureRLX	;Rise Left
 .byt >FigureRRX	;Rise Right
WaveTableYAddressLo
 .byt <FigureC0Y	;Clockwise circulate
 .byt <FigureA0Y	;Anticlockwise Circulate
 .byt <FigureHLY	;Hover(Fly) Left
 .byt <FigureHRY	;Hove(Fly) Right
 .byt <FigureDLY	;Dive Left
 .byt <FigureDRY	;Dive Right
 .byt <FigureRLY	;Rise Left
 .byt <FigureRRY	;Rise Right
WaveTableYAddressHi
 .byt >FigureC0Y	;Clockwise circulate
 .byt >FigureA0Y	;Anticlockwise Circulate
 .byt >FigureHLY	;Hover(Fly) Left
 .byt >FigureHRY	;Hove(Fly) Right
 .byt >FigureDLY	;Dive Left
 .byt >FigureDRY	;Dive Right
 .byt >FigureRLY	;Rise Left
 .byt >FigureRRY	;Rise Right

FigureC0X	;Clockwise circulate
FigureA0Y	;Anticlockwise circulate
 .byt 1,1,1,1,0,255,255,255,255,0
FigureC0Y	;Clockwise circulate
FigureA0X	;Anticlockwise circulate
 .byt 255,0,0,1,1,1,0,0,255,255

FigureHLX	;Hover Left
FigureDLX	;Dive Left
FigureRLX	;Rise Left
 .byt 255,255,255,255,255
 .byt 255,255,255,255,255
FigureHLY	;Hover Left
FigureHRY	;Hover Right
 .byt 255,1,255,1,255,1,255,1,255,1
FigureHRX	;Hover Right
FigureDRX	;Dive Right
FigureRRX	;Rise Right
 .byt 1,1,1,1,1
 .byt 1,1,1,1,1
FigureDLY	;Dive Left
FigureDRY	;Dive Right
 .byt 1,0,1,0,1
 .byt 1,0,1,0,1
FigureRLY	;Rise Left
FigureRRY	;Rise Right
 .byt 255,0,255,0,255
 .byt 255,0,255,0,255
BeeWaveNumber
 .byt 0,1,0,1,0,1
BeeWaveIndex
 .byt 0,1,2,3,4,5
BeesScreenIndex
 .byt 40,41,42
 .byt 120,121,121
BeeX	;6
 .byt 30,78,127,132,126,182
BeeY
 .byt 65-23,58-23,61-23,65-23,68-23,60-23
BeesTempX	.byt 0
BeesSprite
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
BeesXOFS
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
 .dsb 6,16
 .dsb 6,17
 .dsb 6,18
 .dsb 6,19
 .dsb 6,20
 .dsb 6,21
 .dsb 6,22
 .dsb 6,23
 .dsb 6,24
 .dsb 6,25
 .dsb 6,26
 .dsb 6,27
 .dsb 6,28
 .dsb 6,29
 .dsb 6,30
 .dsb 6,31
 .dsb 6,32
 .dsb 6,33
 .dsb 6,34
 .dsb 6,35
 .dsb 6,36
 .dsb 6,37
 .dsb 6,38
 .dsb 6,39


BeeFrameVectorLo
 .byt <BeeFrame0
 .byt <BeeFrame1
 .byt <BeeFrame2
 .byt <BeeFrame3
 .byt <BeeFrame4
 .byt <BeeFrame5
BeeFrameVectorHi
 .byt >BeeFrame0
 .byt >BeeFrame1
 .byt >BeeFrame2
 .byt >BeeFrame3
 .byt >BeeFrame4
 .byt >BeeFrame5

BeeFrame0	;3x2
 .byt   3,%01101000,%01000000
; .byt 127,%01000111,%01111111
 .byt   1,%01010000,%01000000
; .byt 127,%01101111,%01111111
BeeFrame1
 .byt   3,%01110110,%01000000
; .byt 127,%01100011,%01111111
 .byt   1,%01001000,%01000000
; .byt 127,%01110111,%01111111
BeeFrame2
 .byt   3,%01001010,%01000000
; .byt 127,%01110001,%01111111
 .byt   1,%01000100,%01000000
; .byt 127,%01111011,%01111111
BeeFrame3
 .byt   3,%01000111,%01000000
; .byt 127,%01111000,%01111111
 .byt   1,%01000010,%01000000
; .byt 127,%01111101,%01111111
BeeFrame4
 .byt   3,%01000001,%01000000
; .byt 127,%01111100,%01011111
 .byt   1,%01000001,%01000000
; .byt 127,%01111110,%01111111
BeeFrame5
 .byt   3,%01000001,%01110000
; .byt 127,%01111110,%01001111
 .byt   1,%01000000,%01100000
; .byt 127,%01111111,%01011111
