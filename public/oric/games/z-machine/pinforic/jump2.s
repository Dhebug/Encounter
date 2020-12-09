vars	.byte 0
local_offset .byte 0

gosub1
	ldx _param 
	lda _param+1 
	jmp store

_gosub
	lda _param 
	ora _param+1 
	beq gosub1

	sec
	lda _stack
	sbc #6
	sta _stack
	bcs *+4
	dec _stack+1

	ldy #4 
	lda _pc_page 
	sta (_stack),y 
	iny 
	lda _pc_page+1 
	sta (_stack),y 

	ldy #2 
	lda _pc_offset 
	sta (_stack),y 
	iny 
	lda _pc_offset+1 
	sta (_stack),y 

	sec
	lda _stack_base 
	sbc _stack_var_ptr
	sta tmp1
	lda _stack_base+1 
	sbc _stack_var_ptr+1 
	sta tmp1+1

	asl
	ror tmp1+1
	ror tmp1

	ldy #0 
	lda tmp1 
	sta (_stack),y 
	iny 
	lda tmp1+1 
	sta (_stack),y 

	ldx _param+1
	lda #0
	stx _pc_page 
	sta _pc_page+1 

	lda _param 
	asl 
	sta _pc_offset 
	lda #0
	rol 
	sta _pc_offset+1 

	ldy #0 
	jsr _fix_pc 

	sec
	lda _stack 
	sbc #2
	sta _stack_var_ptr 
	lda _stack+1 
	sbc #0
	sta _stack_var_ptr+1 

	ldy #0 
	jsr _next_byte 
	stx vars
	txa
	asl
	sta local_offset

	sec
	lda _stack
	sbc local_offset
	sta _stack
	bcs *+4
	dec _stack+1

	dec _num_params 

	ldx #2
	ldy local_offset
	jmp gosub6 

gosub3
	clc
	lda _pc_offset
	adc #2
	sta _pc_offset
	bcc gosub4
	txa
	pha
	tya
	pha
	jsr _fix_pc1
	pla
	tay
	pla
	tax
gosub4
	dey
	lda _param+1,x
	sta (_stack),y
	dey
	lda _param,x
	sta (_stack),y
	inx
	inx
	dec _num_params 
	dec vars
gosub6
	lda _num_params 
	beq gosub8

	lda vars 
	bne gosub3 

gosub8
	sty local_offset
	jmp gosub10 

gosub9
	dec vars

	ldy _pc_offset
	lda (_pc_ptr),y
	inc _pc_offset
	bne *+5
	jsr _fix_pc1
	
	ldy local_offset
	dey
	sta (_stack),y
	sty local_offset

	ldy _pc_offset
	lda (_pc_ptr),y
	inc _pc_offset
	bne *+5
	jsr _fix_pc1

	ldy local_offset
	dey
	sta (_stack),y
	sty local_offset

gosub10
	lda vars
	bne gosub9
	rts

_rts
	ldy #0
	lda (_stack),y
	sta _param
	iny
	lda (_stack),y
	sta _param+1
	clc
	lda _stack
	adc #2
	sta _stack
	bcc *+4
	inc _stack+1
	jmp _rtn

_rtn0
	lda #0
	beq rtn
_rtn1
	lda #1
rtn
	sta _param
	lda #0
	sta _param+1
_rtn
	clc
	lda _stack_var_ptr
	sta tmp
	adc #8
	sta _stack
	lda _stack_var_ptr+1
	sta tmp+1
	adc #0
	sta _stack+1

	ldy #2
	lda (tmp),y
	asl
	sta tmp0
	iny
	lda (tmp),y
	rol
	sta tmp0+1

	sec
	lda _stack_base
	sbc tmp0
	sta _stack_var_ptr
	lda _stack_base+1
	sbc tmp0+1
	sta _stack_var_ptr+1

	iny
	lda (tmp),y
	sta _pc_offset
	iny
	lda (tmp),y
	sta _pc_offset+1

	iny
	lda (tmp),y
	sta _pc_page
	iny
	lda (tmp),y
	sta _pc_page+1

	jsr _fix_pc

	ldx _param 
	lda _param+1 
	jmp store

_jump
	clc
	lda _pc_offset
	adc _param
	tax
	lda _pc_offset+1
	adc _param+1
	tay

	sec
	txa
	sbc #2
	sta _pc_offset
	tya
	sbc #0
	sta _pc_offset+1

_fix_pc
	lda _pc_offset+1
	sta tmp
	and #1
	sta _pc_offset+1

	lda tmp
	asl
	ror tmp

	clc
	lda _pc_page
	adc tmp
	sta _pc_page
	
	cmp _cur_page
	beq fix_pc2

	sta _cur_page

	cmp _resident_blocks
	bcs fix_pc3

	ldx _base_ptr
	stx _prog_block_ptr
	stx _pc_ptr
	asl
	adc _base_ptr+1
	sta _prog_block_ptr+1
	adc _pc_offset+1
	sta _pc_ptr+1
	rts

fix_pc3
	jsr fetch_page
	stx _prog_block_ptr
	stx _pc_ptr
	sta _prog_block_ptr+1
fix_pc2
	clc
	lda _prog_block_ptr+1
	adc _pc_offset+1
	sta _pc_ptr+1
	rts


_pop_stack
	clc
	lda _stack
	adc #2
	sta _stack
	bcc *+4
	inc _stack+1
	rts

