;WaveEngine.s

;Wave simulation
;Draws up to 32 random shifting waves within exact rectangle on screen
;Displays white wave only where row above(BG) contains %01111111

GenerateWaves	;Add new wave
	ldx WaveCount
	cpx #31
.(
	bcc skip4
	jmp skip5
skip4	;Generate new wave
	lda LevelWaveHorizonWidth
	jsr game_GetRNDRange
	adc LevelWaveHorizonLeft
	sta wsX,x
	lda LevelWaveHorizonHeight
	jsr game_GetRNDRange
	adc LevelWaveHorizonDown
	sta wsY,x
	jsr getrand
	and #63
	ora #64
	sta wsBitmap,x
	;plot bitmap
	ldy wsY,x
	lda SYLocl,y
	sta screen
	lda SYLoch,y
	sta screen+1
	ldy wsX,x
	iny
	lda (screen),y
	cmp #127
	bne skip5
	lda wsX,x
	clc
	adc #40
	tay

	lda #7
	sta (screen),y
	iny
	lda wsBitmap,x
	sta (screen),y

	inc WaveCount

skip5	;Process existing waves
	ldx WaveCount
	beq skip3
	dex

loop1	;Calc screen loc
	ldy wsY,x
	lda SYLocl,y
	sta screen
	lda SYLoch,y
	sta screen+1
	lda wsX,x
	clc
	adc #40
	tay
	lda #7
	sta (screen),y
	iny
	sty temp01
	lda wsBitmap,x
	asl
	;gradually reduce granularity
;	and rndRandom
	and #63
	sta wsBitmap,x
	bne skip1
	;nothing left to shift - Whilst still displaying, remove wave index
	ora #64
	ldy temp01
	sta (screen),y
	ldy WaveCount	;always Marks last wave
	dey
	lda wsX,y
	sta wsX,x
	lda wsY,y
	sta wsY,x
	lda wsBitmap,y
	sta wsBitmap,x
	dec WaveCount
	jmp skip2

skip1	ora #64
	ldy temp01
	sta (screen),y

skip2	dex
	bpl loop1
skip3	rts
.)


WaveCount	.byt 0
wsX
 .dsb 32,0
wsY
 .dsb 32,0
wsBitmap
 .dsb 32,0
LevelWaveHorizonWidth	.byt 39
LevelWaveHorizonLeft	.byt 1
LevelWaveHorizonHeight	.byt 15
LevelWaveHorizonDown	.byt 28
