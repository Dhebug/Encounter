;
; itoa
;
_itoa
	ldy #0
	lda (sp),y
	sta op2
	iny
	lda (sp),y
	sta op2+1

	jsr itoa
	rts

bufconv
	.byt 0,0,0,0,0,0,0,0,0,0,0,0
itoa
	ldy #0
	sty bufconv
	lda op2+1
	bpl itoaloop
	lda #$2D	; minus sign
	sta bufconv
	sec
	lda #0
	sbc op2
	sta op2
	lda #0
	sbc op2+1
	sta op2+1
	
itoaloop
	jsr udiv10
	pha
	iny
	lda op2
	ora op2+1
	bne itoaloop
	
	ldx #0
	lda bufconv
	beq poploop
	inx
poploop
	pla
	clc
	adc #$30
	sta bufconv,x
	inx
	dey
	bne poploop
	lda #0
	sta bufconv,x
	ldx #<bufconv
	lda #>bufconv
	rts
			
;
; udiv10 op2= op2 / 10 and A= tmp2 % 10
;
udiv10
	lda #0
	ldx #16
	clc
udiv10lp
	rol op2
	rol op2+1
	rol 
	cmp #10
	bcc contdiv
	sbc #10
contdiv
	dex
	bne udiv10lp
	rol op2
	rol op2+1
    rts
        
