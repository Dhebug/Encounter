_get_byte
	ldy #0
	lda (sp),y
	cmp _resident_blocks
	bcs get_byte2

	asl
	ldy #3
	adc (sp),y
	tax

	dey
	lda (sp),y
	adc _base_ptr
	sta tmp
	txa
	adc _base_ptr+1
	sta tmp+1

	ldy #0
	lda (tmp),y
	tax
	tya
	rts
	
get_byte2
	ldy #3
	lda (sp),y
	pha
	dey
	lda (sp),y
	pha
get_byte3
	jsr _fetch_page
	stx tmp
	sta tmp+1

	clc
	pla
	adc tmp
	sta tmp
	pla
	adc tmp+1
	sta tmp+1

	ldy #0
	lda (tmp),y
	tax
	tya
	rts
	
_get_word
	ldy #0
	lda (sp),y
	cmp _resident_blocks
	bcs get_word2

	asl
	ldy #3
	adc (sp),y
	tax

	dey
	lda (sp),y
	adc _base_ptr
	sta tmp
	txa
	adc _base_ptr+1
	sta tmp+1
get_word1
	ldy #1
	lda (tmp),y
	tax
	dey
	lda (tmp),y
	rts
	
get_word2
	pha	; save page
	ldy #3
	lda (sp),y
	pha
	dey
	lda (sp),y
	pha

	jsr _fetch_page
	stx tmp
	sta tmp+1

	clc
	pla
	tax
	adc tmp
	sta tmp
	pla
	tay
	adc tmp+1
	sta tmp+1

	pla
	inx
	bne get_word1
	iny
	cpy #2
	bne get_word1

	clc
	adc #1
	ldy #0
	sta (sp),y

	lda (tmp),y
	pha

	jsr _fetch_page
	stx tmp
	sta tmp+1

	ldy #0
	lda (tmp),y
	tax
	pla
	rts
	
_store
	ldy #0
	lda (sp),y
	tax
	iny
	lda (sp),y
store
	pha
	ldy _pc_offset
	lda (_pc_ptr),y
	bne store2

	sec
	lda _stack
	sbc #2
	sta _stack
	bcs *+4
	dec _stack+1

	ldy #0
	txa
	sta (_stack),y
	iny
	pla
	sta (_stack),y

	inc _pc_offset
	bne *+5
	jsr _fix_pc1
	rts

store2
	sta _param
	lda #0
	sta _param+1
	stx _param+2
	pla
	sta _param+3
	inc _pc_offset
	bne *+5
	jsr _fix_pc1
	jmp _put_var

hex20	.byte $20


_ret_value
	ldy #0
	lda (sp),y
ret_value_nz
	bne ret_value_true
ret_value_false
	lda #0
	beq ret_value
ret_value_z
	bne ret_value_false
ret_value_true
	lda #$80
ret_value
	ldy _pc_offset
	eor (_pc_ptr),y
	bmi dont_branch

	asl
	bmi short_branch
	lsr
	pha
	
	inc _pc_offset
	bne *+5
	jsr _fix_pc1

	ldy _pc_offset
	lda (_pc_ptr),y
	tax
	pla
	beq short_branch_x

	bit hex20
	beq *+4
	ora #$C0
	tay
	txa
	sec
	sbc #1
	bcs *+3
	dey
	clc
	adc _pc_offset
	sta _pc_offset
	tya
	adc _pc_offset+1
	sta _pc_offset+1
	jmp _fix_pc

dont_branch
	and #$40
	bne dont_branch2
	inc _pc_offset
	bne *+5
	jsr _fix_pc1
dont_branch2
	inc _pc_offset
	bne *+5
	jsr _fix_pc1
	rts
	
short_branch
	lsr
	and #$3f
	cmp #2
	bcs short_branch2
	jmp rtn
short_branch2
	sbc #1
	clc
	adc _pc_offset
	sta _pc_offset
	bcc *+5
	inc _pc_offset+1
	jmp _fix_pc
short_branch_x
	txa
	cmp #2
	bcs short_branch2
	jmp rtn
	
_Z_TO_WORD
 	ldy #0 
 	lda (sp),y 
 	sta tmp 
 	iny 
 	lda (sp),y 
 	sta tmp+1 
	lda (tmp),y
	tax
	dey
	lda (tmp),y
	rts
