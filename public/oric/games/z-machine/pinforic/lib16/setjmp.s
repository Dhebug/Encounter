; _setjmp(jmp_buf env)
; nb: jmp_buf is an array of structures (only 1 element actually),
;     so its address is on the stack

__setjmp
	ldy #1
	lda (sp),y
	sta tmp+1
	dey
	lda (sp),y
	sta tmp

	lda ap
	sta (tmp),y
	iny
	lda ap+1
	sta (tmp),y
	iny

	lda fp
	sta (tmp),y
	iny
	lda fp+1
	sta (tmp),y
	iny

	lda sp
	sta (tmp),y
	iny
	lda sp+1
	sta (tmp),y
	iny

	ldx #0
setjmp_saveregs
	lda reg0,x
	sta (tmp),y
	iny
	inx
	cpx #16
	bne setjmp_saveregs

	ldx #0
setjmp_savetmps
	lda tmp0,x
	sta (tmp),y
	iny
	inx
	cpx #16
	bne setjmp_savetmps

	tsx
	lda $0101,x
	sta (tmp),y
	iny
	lda $0102,x
	sta (tmp),y
	iny

	txa
	sta (tmp),y

	lda #0
	tax
	rts



; longjmp(jmp_buf env, int val)

_longjmp
	ldy #3
	lda (sp),y
	sta op2+1
	dey
	lda (sp),y
	sta op2
	dey
	lda (sp),y
	sta tmp+1
	dey
	lda (sp),y
	sta tmp

	lda (tmp),y
	sta ap
	iny
	lda (tmp),y
	sta ap+1
	iny

	lda (tmp),y
	sta fp
	iny
	lda (tmp),y
	sta fp+1
	iny

	lda (tmp),y
	sta sp
	iny
	lda (tmp),y
	sta sp+1
	iny

	ldx #0
setjmp_getregs
	lda (tmp),y
	sta reg0,x
	iny
	inx
	cpx #16
	bne setjmp_getregs

	ldx #0
setjmp_gettmps
	lda (tmp),y
	sta tmp0,x
	iny
	inx
	cpx #16
	bne setjmp_gettmps

	iny
	iny
	lda (tmp),y
	tax
	txs

	dey
	lda (tmp),y
	sta $0102,x
	dey
	lda (tmp),y
	sta $0101,x

	ldx op2
	lda op2+1
	rts
