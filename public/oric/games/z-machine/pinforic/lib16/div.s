;
; op1/op2 (16-bit signed)
;
div16i
	lda op1+1	;dividend sign
	eor op2+1
	pha		;sign of quotient
	jsr unsign
	jsr div16u	;unsigned divide
	pla		;sign of quotient
	bmi resign
	lda op1+1
	rts

;
; op1 % op2 (16-bit signed)
;
mod16i
	lda op1+1	;dividend sign
	pha		;sign of modulo
	jsr unsign
	jsr mod16u	;unsigned modulo
	pla		;sign of modulo
	bmi resignmod
	lda tmp+1
	rts

resignmod
	stx op1
	lda tmp+1
	sta op1+1
resign
	sec
	lda #0
	sbc op1
	tax
	lda #0
	sbc op1+1
	rts

unsign
	lda op1+1
	bpl unsign1
	sec
	lda #0
	sbc op1
	sta op1
	lda #0
	sbc op1+1
	sta op1+1
unsign1
	lda op2+1
	bpl unsign2
	sec
	lda #0
	sbc op2
	sta op2
	lda #0
	sbc op2+1
	sta op2+1
unsign2
	rts
;
; op1/op2 (16-bit unsigned)
;
div16u
	lda op2
	ora op2+1
	beq zerodiv

	lda #0
	sta tmp
	sta tmp+1
	
	ldx #16
	asl op1
	rol op1+1
udiv2
	rol tmp
	rol tmp+1
	sec
	lda tmp
	sbc op2
	tay
	lda tmp+1
	sbc op2+1
	bcc udiv3
	sty tmp
	sta tmp+1
udiv3
	rol op1
	rol op1+1
	dex
	bne udiv2
	ldx op1
	lda op1+1
	rts
;
; op1%op2 (16-bit unsigned)
;
mod16u
	jsr div16u
	ldx tmp
	lda tmp+1
	rts

zerodiv
	ldx #$85
	jmp $C47E


