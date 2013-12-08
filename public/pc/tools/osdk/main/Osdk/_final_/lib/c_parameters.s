
get_2ptr
	ldy #0
	lda (sp),y
	sta op1
	iny
	lda (sp),y
	sta op1+1

	ldy #2
	lda (sp),y
	sta op2
	iny
	lda (sp),y
	sta op2+1
	rts

