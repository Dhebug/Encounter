;Sea
;Swell height
;SeaLevel

#define HIRES	$EC33
 .zero
 
screen	.dsb 2
temp01	.dsb 1
WaveFrac1	.dsb 1
WaveFrac2	.dsb 1

 .text
*=$500


Driver	jsr HIRES

	ldx #59
.(
loop1	lda SYLocl,x
	sta screen
	lda SYLoch,x
	sta screen+1
	ldy #0
	lda #4
	sta (screen),y
	ldy #41
	lda #$14
	sta (screen),y
	cpx #31
	bcc skip1
	ldy #39
	lda #127
loop2	sta (screen),y
	dey
	bne loop2
skip1	dex
	bpl loop1
.)	


	lda #77
	sta WaveFrac1
	lda #110
	sta WaveFrac2
	sei
.(
loop2	ldx #39
loop1	lda WaveFracCount1,x
	adc WaveFrac1
	sta WaveFracCount1,x
	lda WaveIntersectionIndex1,x
	adc #00
	sta WaveIntersectionIndex1,x

	lda WaveFracCount2,x
	sbc WaveFrac2
	sta WaveFracCount2,x
	lda WaveIntersectionIndex2,x
	sbc #00
	sta WaveIntersectionIndex2,x
	inc WaveFrac2
	ldy WaveIntersectionIndex1,x
	lda SineTable,y
	ldy WaveIntersectionIndex2,x
	lsr
	clc
	adc SineTable,y
;	lsr
;	lsr
skip1	clc
	adc #20
	tay
	jsr PlotByte
	dex
	bne loop1
	jsr BigDelay
	jmp loop2
.)

BigDelay	ldx #40
.(
loop2	ldy #64
loop1	nop
	dey
	bpl loop1
	dex
	bne loop2
.)
	rts

PlotByte
	txa
	clc
	adc SYLocl,y
	sta screen
	lda SYLoch,y
	adc #00
	sta screen+1
;	;If height step greater than one then plot inverse
;	lda #127
;	cpy temp01
;.(
;	beq skip1
;	lda #127+128
;skip1	pha
;.)
	sty temp01
	ldy #00
	lda #64
	sta (screen),y
	ldy #80
	sta (screen),y
	lda #127
	ldy #160
	sta (screen),y
	;lda #127
	ldy #240
	sta (screen),y
	ldy temp01
	rts

SineTable	;Expand to 256
 .byt 1,1,1,2,2,3,4,5,6,7,8,9,9,10,10,10,11,11,11,11
 .byt 10,10,10,9,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0

 .byt 1,1,1,1,2,2,2,3,3,4,4,5,6,7,8,9,9,9,9,8,8,7,7,6,6,5,5,4,3,3,2,2,1,1,1,0,0,0,0,0
 .byt 1,1,2,3,4,5,6,7,8,9,9,8,8,8,7,7,6,5,4,3,2,1,1,2,2,3,3,4,4,4,4
 .byt 3,3,3,2,2,2,1,1,1
 .byt 1,1,1,2,2,3,4,5,6,7,8,9,9,10,10,10,11,11,11,11
 .byt 10,10,10,9,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0

 
 .byt 1,2,3,4,5,6,7,8,9,10,10,11,11,11,12,12,12,12,12,13,13,13,13,14,14,14,14,14,14
 .byt 13,13,13,13,12,12,12,12,12,11,11,11,10,10,9,8,7,6,5,4,3,2
 
 .byt 1,2,3,4,4,5,5,5,6,6,6,6,5,5,5,4,4,3,2,1,1,1,1,0,0,0,0,0,0
; .byt 10,10,10,9,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0
; .byt 1,1,1,2,2,3,4,5,6,7,8,9,9,10,10,10,11,11,11,11
; .byt 10,10,10,9,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0
 .byt 1,1,1,2,2,3,4,4,4,4,3,3,3,2,2,2
WaveIntersectionIndex1
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 .byt 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40
WaveIntersectionIndex2
 .byt 1+128,2+128,3+128,4+128,5+128,6+128,7+128,8+128,9+128,10+128,11+128,12+128,13+128,14+128,15+128
 .byt 16+128,17+128,18+128,19+128,20+128,21+128,22+128,23+128,24+128,25+128,26+128,27+128,28+128
 .byt 29+128,30+128,31+128,32+128,33+128,34+128,35+128,36+128,37+128,38+128,39+128,40+128
WaveFracCount1
 .dsb 39,0
WaveFracCount2
 .dsb 39,0

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


;In this way can work relative to centre-point(pivot).
;0-31 Attribute
;32-47 Rows Up(16)
;48-63 Rows Down(16)
;64-127 Bitmap
;128-191 Steps Left(64)
;192-255 Steps Right(64)
; .byt UP+15,RIGHT+5,%01111100
; .byt DOWN+1,$10,$14
; .byt DOWN+1,LEFT+2,%01111110,%01000000
; .byt 
;
;
;
;
;HeroAndOarFrame00
; .byt MOVE+1,%01110000,%01011111
; .byt MOVE+38,3,%01000111
; .byt MOVE+40,%01110000,%01011111
; .byt MOVE+38,1,%01000111
; .byt MOVE+40,%01100000,%01011111
; .byt MOVE+38,2,%01000111
; .byt MOVE+39,%01110000,%01000000,%01001111
; .byt MOVE+37,1,%01000111,%01110000
; .byt MOVE+39,%01110000,%01000100,%01000011
; .byt MOVE+39,6,%01011000
; .byt MOVE+39,%01111000,%01000000,%01000000
; .byt MOVE+120,MOVE+119,%01000110,%01000111
; .byt 
; 
;Ideally..
;Waves generated on WaveBuffer which is 40x32
;Boat angle calculated
;WaveBuffer copied to ScreenBuffer(40x32)
;Boat frame plotted on ScreenBuffer
;Hero+Oar plotted on ScreenBuffer
;ScreenBuffer copied to Screen
;
;
;
;~ on 0
;4 on 0
;
;7 on 4
;4 on 0

;Wave Buffer is 40x28
;Screen Buffer is 40x42 to encompass rowing boat

