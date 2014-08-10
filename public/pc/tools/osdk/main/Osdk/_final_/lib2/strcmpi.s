;int strcmpi(char *s1, char *s2)
_strcmpi
	jsr get_2ptr
	ldy #0

strcmpiloop
        lda (op2),Y     ; toupper(*s2), store in tmp
        sty tmp2
        tax
        jsr _touppermc
        ldy tmp2
        stx tmp

        lda (op1),Y     ; toupper(*s1), compare with tmp
        sty tmp2
        tax
        jsr _touppermc
        ldy tmp2
        txa
        cmp tmp

        bne strcmpiend
	cmp #0
        beq strcmpiend0
	iny
        bne strcmpiloop
	inc op1+1
	inc op2+1
        jmp strcmpiloop

strcmpiend0
	jmp retzero
strcmpiend
	sec
        sbc tmp
	tax
	lda #0
	bcs *+4
	lda #$ff
	rts

