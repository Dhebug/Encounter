;int strncmpi(char *s1, char *s2, int n)
_strncmpi
	jsr get_2ptr

        ldy #5
        lda (sp),y      ; get n
        sta tmp+1       ; tmp+1=hi(n)
        dey
        lda (sp),y
        sta tmp         ; tmp=lo(n)
	ldy #0

strncmpiloop
        ldx tmp
        dex             ; decrease n
        stx tmp
        cpx #$ff
        bne strncmpi1
        ldx tmp+1
        dex
        stx tmp+1
        cpx #$ff
        beq strncmpiend0 ; n<0?

strncmpi1
        lda (op2),Y     ; toupper(*s2), store in tmp
        sty tmp2
        tax
        jsr _touppermc
        ldy tmp2
        stx tmp1

        lda (op1),Y     ; toupper(*s1), compare with tmp
        sty tmp2
        tax
        jsr _touppermc
        ldy tmp2
        txa
        cmp tmp1

        bne strncmpiend
	cmp #0
        beq strncmpiend0
	iny
        bne strncmpiloop
	inc op1+1
	inc op2+1
        jmp strncmpiloop

strncmpiend0
	jmp retzero
strncmpiend
	sec
        sbc tmp1
	tax
	lda #0
	bcs *+4
	lda #$ff
	rts

