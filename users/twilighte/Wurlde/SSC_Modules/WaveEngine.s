;WaveEngine.s

;Wave simulation
;Draws up to 32 random shifting waves within exact rectangle on screen
;Displays white wave only where row above(BG) contains %01111111

;Expand this routine so that waves appear small then growing then shrinking
;The idea is the byte data is scrolled on from an established random number,
;and left to scroll off left. This means byte is initially empty, then takes
;on bits which eventually all trail off left. This would be more accurate!

GenerateWaves
	lda WaveDelay
	clc
	adc #64
	sta WaveDelay
.(
	bcs skip6
	rts
skip6	ldx WaveCount
	cpx #31
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
	lda #63
	jsr game_GetRNDRange
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
	;Now check if new wave is over empty background otherwise abort
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


WaveDelay	.byt 0
WaveCount	.byt 0
wsX
 .dsb 32,0
wsY
 .dsb 32,0
wsBitmap
 .dsb 32,0

SYLocl
 .byt <$a758
 .byt <$a758+80*1
 .byt <$a758+80*2
 .byt <$a758+80*3
 .byt <$a758+80*4
 .byt <$a758+80*5
 .byt <$a758+80*6
 .byt <$a758+80*7
 .byt <$a758+80*8
 .byt <$a758+80*9
 .byt <$a758+80*10
 .byt <$a758+80*11
 .byt <$a758+80*12
 .byt <$a758+80*13
 .byt <$a758+80*14
 .byt <$a758+80*15
 .byt <$a758+80*16
 .byt <$a758+80*17
 .byt <$a758+80*18
 .byt <$a758+80*19
 .byt <$a758+80*20
 .byt <$a758+80*21
 .byt <$a758+80*22
 .byt <$a758+80*23
 .byt <$a758+80*24
 .byt <$a758+80*25
 .byt <$a758+80*26
 .byt <$a758+80*27
 .byt <$a758+80*28
 .byt <$a758+80*29
 .byt <$a758+80*30
 .byt <$a758+80*31
 .byt <$a758+80*32
 .byt <$a758+80*33
 .byt <$a758+80*34
 .byt <$a758+80*35
 .byt <$a758+80*36
 .byt <$a758+80*37
 .byt <$a758+80*38
 .byt <$a758+80*39
 .byt <$a758+80*40
 .byt <$a758+80*41
 .byt <$a758+80*42
 .byt <$a758+80*43
 .byt <$a758+80*44
 .byt <$a758+80*45
 .byt <$a758+80*46
 .byt <$a758+80*47
 .byt <$a758+80*48
 .byt <$a758+80*49
 .byt <$a758+80*50
 .byt <$a758+80*51
 .byt <$a758+80*52
 .byt <$a758+80*53
 .byt <$a758+80*54
 .byt <$a758+80*55
 .byt <$a758+80*56
 .byt <$a758+80*57
 .byt <$a758+80*58
 .byt <$a758+80*59
SYLoch
 .byt >$a758
 .byt >$a758+80*1
 .byt >$a758+80*2
 .byt >$a758+80*3
 .byt >$a758+80*4
 .byt >$a758+80*5
 .byt >$a758+80*6
 .byt >$a758+80*7
 .byt >$a758+80*8
 .byt >$a758+80*9
 .byt >$a758+80*10
 .byt >$a758+80*11
 .byt >$a758+80*12
 .byt >$a758+80*13
 .byt >$a758+80*14
 .byt >$a758+80*15
 .byt >$a758+80*16
 .byt >$a758+80*17
 .byt >$a758+80*18
 .byt >$a758+80*19
 .byt >$a758+80*20
 .byt >$a758+80*21
 .byt >$a758+80*22
 .byt >$a758+80*23
 .byt >$a758+80*24
 .byt >$a758+80*25
 .byt >$a758+80*26
 .byt >$a758+80*27
 .byt >$a758+80*28
 .byt >$a758+80*29
 .byt >$a758+80*30
 .byt >$a758+80*31
 .byt >$a758+80*32
 .byt >$a758+80*33
 .byt >$a758+80*34
 .byt >$a758+80*35
 .byt >$a758+80*36
 .byt >$a758+80*37
 .byt >$a758+80*38
 .byt >$a758+80*39
 .byt >$a758+80*40
 .byt >$a758+80*41
 .byt >$a758+80*42
 .byt >$a758+80*43
 .byt >$a758+80*44
 .byt >$a758+80*45
 .byt >$a758+80*46
 .byt >$a758+80*47
 .byt >$a758+80*48
 .byt >$a758+80*49
 .byt >$a758+80*50
 .byt >$a758+80*51
 .byt >$a758+80*52
 .byt >$a758+80*53
 .byt >$a758+80*54
 .byt >$a758+80*55
 .byt >$a758+80*56
 .byt >$a758+80*57
 .byt >$a758+80*58
 .byt >$a758+80*59
