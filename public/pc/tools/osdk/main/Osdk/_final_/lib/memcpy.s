; void memcpy(ptr dst, ptr src, int n)
; new VERY FAST version 8-)

_memcpy
.(
	jsr get_2ptr
	ldy #4
	sec
	lda #0
	sbc (sp),y
	sta tmp
	tax
	iny
	cmp #1
	lda (sp),y
	adc #0
	tay
	beq return

	sec
	lda op1
	sbc tmp
	sta memcpyloop+4
	lda op1+1
	sbc #0
	sta memcpyloop+5

	sec
	lda op2
	sbc tmp
	sta memcpyloop+1
	lda op2+1
	sbc #0
	sta memcpyloop+2

memcpyloop
	lda $2211,x
	sta $5544,x
	inx
	bne memcpyloop
	inc memcpyloop+2
	inc memcpyloop+5
	dey
	bne memcpyloop
return
	rts
.)

	
