// hopefully faster HIRES scroll than memcpy
	.zero

//_HRLines					.dsb 1

	.text

_ScrollHiresUp1
	; init pointers
	lda #$a0
	sta _ScrollHiresUp1_l2+2
	sta _ScrollHiresUp1_l2+5
	lda #00
	sta _ScrollHiresUp1_l2+4
	lda #40
	sta _ScrollHiresUp1_l2+1
	;
	ldx #33
_ScrollHiresUp1_l1
	ldy #0
_ScrollHiresUp1_l2
	lda $a000+40,y
	sta $a000,y
	iny
	cpy #6*40
	bne _ScrollHiresUp1_l2

	; add to pointers
	clc
	lda #<(6*40)
	adc _ScrollHiresUp1_l2+1
	sta _ScrollHiresUp1_l2+1
	lda #>(6*40)
	adc _ScrollHiresUp1_l2+2
	sta _ScrollHiresUp1_l2+2

	clc
	lda #<(6*40)
	adc _ScrollHiresUp1_l2+4
	sta _ScrollHiresUp1_l2+4
	lda #>(6*40)
	adc _ScrollHiresUp1_l2+5
	sta _ScrollHiresUp1_l2+5

	dex
	bne _ScrollHiresUp1_l1

	; last line after 6 * 33
	ldy #0
_ScrollHiresUp1_l3
	lda $a000+198*40+40,y
	sta $a000+198*40,y
	iny
	cpy #1*40
	bne _ScrollHiresUp1_l3

	rts

