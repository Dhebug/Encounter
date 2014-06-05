
;
;
; Simple code used to display a 240x24 pixels inlay in the 3 bottom lines of text in hires
;
;



_CharMapDraw
	; put neutral attributes
	ldx #0
	lda #0					; BLACK INK
	sta $bb80+(40*25),x
	sta $bb80+(40*26),x
	sta $bb80+(40*27),x

	lda #32
	sta tmp0+0
	lda #32+39
	sta tmp0+1


	; Write characters
CharMapDrawLoop
	inx
	lda tmp0
	inc tmp0
	sta $bb80+(40*25),x		; STD 32=>
	sta $bb80+(40*27),x		; ALT 32=>
	lda tmp0+1
	inc tmp0+1
	sta $bb80+(40*26),x		; STD 32+40=>
	cpx #39
	bne CharMapDrawLoop


	; change the characters while 
	; all is black on screen
	jsr CharMapReconfigurate


	; put display attributes
	ldx #0
	lda #8+128				; STD TEXT
	sta $bb80+(40*25),x
	sta $bb80+(40*26),x
	lda #9+128				; ALT TEXT
	sta $bb80+(40*27),x
	rts



// 9800 => std chars
// 9c00 => alt chars

CharMapReconfigurateLine

	ldx #0
CharMapReconfigurateLineLoopX
	inx
	stx tmp3

	txa

	clc
	adc tmp0
	sta tmp1
	lda tmp0+1
	adc #0
	sta tmp1+1

	ldx #0
	ldy #0
CharMapReconfigurateLineLoopY
	lda (tmp1),y
	sta (tmp2),y

	clc
	lda tmp1
	adc #40
	sta tmp1
	bcc skip_inc
	inc tmp1+1
skip_inc

	inc tmp2
	bne skip_inc_2
	inc tmp2+1
skip_inc_2

	inx
	cpx #8
	bne CharMapReconfigurateLineLoopY

	ldx tmp3
	cpx #39
	bne CharMapReconfigurateLineLoopX

	clc
	lda tmp0
	adc #<40*8
	sta tmp0
	lda tmp0+1
	adc #>40*8
	sta tmp0+1

	rts



CharMapReconfigurate
	;jmp CharMapReconfigurate

	lda #<_LabelPicture
	sta tmp0
	lda #>_LabelPicture
	sta tmp0+1

	lda #<$9800+32*8
	sta tmp2
	lda #>$9800+32*8
	sta tmp2+1

	jsr CharMapReconfigurateLine

	jsr CharMapReconfigurateLine


	lda #<$9c00+32*8
	sta tmp2
	lda #>$9c00+32*8
	sta tmp2+1

	jsr CharMapReconfigurateLine

	rts


