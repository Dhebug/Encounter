; int strlen(char *s)
_strlen
	ldy #1
	lda (sp),y
	sta tmp+1
	dey
	lda (sp),y
	sta tmp
	ldx #0
	
looplen
	lda (tmp),y
	beq endstrlen
	iny
	bne looplen
	inc tmp+1
	inx
	bne looplen
endstrlen
	sty tmp
	txa
	ldx tmp
	rts
