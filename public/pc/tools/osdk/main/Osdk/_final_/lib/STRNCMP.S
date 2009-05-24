;int strncmp(char *s1, char *s2, int n)
_strncmp
        jsr get_2ptr
        ldy #5
        lda (sp),y      ; get n
        sta tmp         ; tmp=hi(n)
        dey
        lda (sp),y
        tax             ; x=lo(n)
        ldy #0

strncmploop
        dex             ; decrease n
        cpx #$ff
        bne strncmp1
        dec tmp
        lda tmp
        cmp #$ff
        beq strncmpend0 ; n<0?

strncmp1
        lda (op1),Y
	cmp (op2),Y
        bne strncmpend
	cmp #0
        beq strncmpend0
	iny
        bne strncmploop
	inc op1+1
	inc op2+1
        jmp strncmploop

strncmpend0
	jmp retzero
strncmpend
	sec
	sbc (op2),Y
	tax
	lda #0
	bcs *+4
	lda #$ff
	rts

