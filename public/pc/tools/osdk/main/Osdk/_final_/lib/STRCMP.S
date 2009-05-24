;int strcmp(s1, s2)
_strcmp
        jsr get_2ptr
        ldy #0

strcmploop
	lda (op1),Y
	cmp (op2),Y
	bne strcmpend
	cmp #0
	beq strcmpend0
	iny
	bne strcmploop
	inc op1+1
	inc op2+1
	jmp strcmploop

strcmpend0
	jmp retzero
strcmpend
	sec
	sbc (op2),Y
	tax
	lda #0
	bcs *+4
	lda #$ff
	rts

