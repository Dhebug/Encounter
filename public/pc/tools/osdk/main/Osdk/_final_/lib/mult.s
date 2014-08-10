; unsigned 16bit multply op1 x op2 -> tmp
mul16u
	lda #0
	sta tmp
	sta tmp+1
	ldy #16
mult1
	asl tmp
	rol tmp+1
	rol op1
	rol op1+1
	bcc mult2
	clc
	lda op2
	adc tmp
	sta tmp
	lda op2+1
	adc tmp+1
	sta tmp+1
	bcc mult2
	inc op1
mult2
	dey
	bne mult1
	ldx tmp
	lda tmp+1
	rts

mul16i
	lda op1+1
	bpl mul16u
	sec
	lda #0
	sbc op1
	sta op1
	lda #0
	sbc op1+1
	sta op1+1
	jsr mul16u
	sec
	lda #0
	sbc tmp
	tax
	lda #0
	sbc tmp+1
	rts
