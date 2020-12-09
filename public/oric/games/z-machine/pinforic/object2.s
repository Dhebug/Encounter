obj_num .byte 0

_cut_obj
	ldy #0
	lda (sp),y
	tax
	iny
	lda (sp),y
	pha
	iny
	lda (sp),y
	tay
	pla
cut_obj
	stx tmp1
	sta tmp1+1
	sty obj_num

	ldy #4
	lda (tmp1),y 
	beq cut_obj2

	jsr obj_addr
	stx tmp0 
	sta tmp0+1 

	ldy #6 
	lda (tmp0),y 
	cmp obj_num
	bne cut_obj6

	dey
	lda (tmp1),y 
	iny
	sta (tmp0),y
	jmp cut_obj4 

cut_obj6
	lda (tmp0),y 
	jsr obj_addr 
	stx tmp0 
	sta tmp0+1 
	ldy #5 
	lda (tmp0),y 
	cmp obj_num
	bne cut_obj6

	ldy #5 
	lda (tmp1),y 
	sta (tmp0),y 

cut_obj4
	ldy #4 
	lda #0 
	sta (tmp1),y 
	iny
	sta (tmp1),y 
cut_obj2
	rts

_obj_addr
	ldy #0
	lda (sp),y
obj_addr
	sta tmp
	ldx _objd+2
	lda #0
	tay
mul9
	clc
	adc tmp
	bcc *+3
	iny
	dex
	bne mul9

	clc
	adc _objd
	tax
	tya
	adc _objd+1
	tay

	clc
	txa
	adc _objd+4
	tax
	tya
	adc _objd+5
	rts

_transfer
	lda _param+2
	jsr obj_addr
	stx tmp2
	sta tmp2+1

	lda _param
	jsr obj_addr
	stx tmp3
	sta tmp3+1

	ldy _param
	jsr cut_obj

	ldy #6
	lda (tmp2),y
	dey
	sta (tmp3),y

	dey
	lda _param+2
	sta (tmp3),y
	
	ldy #6
	lda _param
	sta (tmp2),y
	rts

_remove_obj
	lda _param
	jsr obj_addr
	ldy _param
	jmp cut_obj

power2tab .byte $80,$40,$20,$10,$08,$04,$02,$01

_test_attr
	lda _param
	jsr obj_addr	
	stx tmp
	sta tmp+1

	lda _param+2
	and #7
	tax
	lda _param+2
	lsr
	lsr
	lsr
	tay
	lda (tmp),y
	and power2tab,x
	jmp ret_value_nz

_set_attr
	lda _param
	jsr obj_addr	
	stx tmp
	sta tmp+1

	lda _param+2
	and #7
	tax
	lda _param+2
	lsr
	lsr
	lsr
	tay
	lda (tmp),y
	ora power2tab,x
	sta (tmp),y
	rts

_clr_attr
	lda _param
	jsr obj_addr	
	stx tmp
	sta tmp+1

	lda _param+2
	and #7
	tax
	lda _param+2
	lsr
	lsr
	lsr
	tay
	lda power2tab,x
	eor #$ff
	and (tmp),y
	sta (tmp),y
	rts

_get_loc
	lda _param
	jsr obj_addr
	stx tmp
	sta tmp+1

	ldy #4
	lda (tmp),y
	tax
	lda #0
	jmp store

_get_holds
	lda _param
	jsr obj_addr
	stx tmp
	sta tmp+1

	ldy #6
	lda (tmp),y
	pha
	tax
	lda #0
	jsr store
	pla
	jmp ret_value_nz

_get_link
	lda _param
	jsr obj_addr
	stx tmp
	sta tmp+1

	ldy #5
	lda (tmp),y
	pha
	tax
	lda #0
	jsr store
	pla
	jmp ret_value_nz

_check_loc
	lda _param
	jsr obj_addr
	stx tmp
	sta tmp+1

	ldy #4
	lda (tmp),y
	cmp _param+2
	jmp ret_value_z
