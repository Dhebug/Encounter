_prop_addr
	ldy #0
	lda (sp),y
	tax
	iny
	lda (sp),y
prop_addr
	stx tmp
	sta tmp+1

	clc
	ldy #8
	lda (tmp),y
	adc _base_ptr
	sta tmp0
	dey
	lda (tmp),y
	adc _base_ptr+1
	sta tmp0+1

	ldy #0
	lda (tmp0),y
	asl
	ora #1
	clc
	adc tmp0
	tax
	lda #0
	adc tmp0+1
	rts

_next_addr
	ldy #0
	lda (sp),y
	tax
	iny
	lda (sp),y
next_addr
	stx tmp
	sta tmp+1

	ldy #0
	lda (tmp),y
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc #2
	adc tmp
	tax
	lda #0
	adc tmp+1
	rts

prop_num .byte  0

search_prop1
	ldx tmp0
	lda tmp0+1
	jsr next_addr 
search_prop
	stx tmp0
	sta tmp0+1

	ldy #0 
	lda (tmp0),y 
	and #$1f
	cmp prop_num
	beq search_prop2
	bcs search_prop1
search_prop2
	ldx tmp0
	lda tmp0+1
	rts

_next_prop
	lda _param+2 
	sta prop_num 

	lda _param 
	jsr obj_addr 
	jsr prop_addr

	ldy prop_num 
	beq next_prop2

	jsr search_prop
	jsr next_addr

next_prop2
	stx tmp0
	sta tmp0+1
	ldy #0 
	lda (tmp0),y 
	and #$1f
	tax
	lda #0
	jmp store

_put_prop
	lda _param+2 
	sta prop_num 

	lda _param 
	jsr obj_addr 
	jsr prop_addr
	jsr search_prop
	stx tmp0
	sta tmp0+1

	ldy #0 
	lda (tmp0),y 
	iny
	and #$20
	beq put_prop2

	lda _param+5
	sta (tmp0),y
	iny
put_prop2
	lda _param+4
	sta (tmp0),y
	rts

_get_prop
	lda _param+2 
	sta prop_num 

	lda _param 
	jsr obj_addr 
	jsr prop_addr
	jsr search_prop
	stx tmp0
	sta tmp0+1
	bcs get_prop2

	lda prop_num
	sec
	sbc #1
	asl
	ldy #0
	bcc *+4
	ldy #$ff

	clc
	adc _objd 
	sta tmp0
	tya
	adc _objd+1 
	sta tmp0+1
	ldy #0
	jmp get_prop4
get_prop2
	lda (tmp0),y 
	iny
	and #$20
	beq get_prop3
get_prop4
	iny
	lda (tmp0),y
	tax
	dey
	lda (tmp0),y
	jmp store
get_prop3
	lda (tmp0),y
	tax
	lda #0
	jmp store 

_get_prop_addr
	lda _param+2 
	sta prop_num 

	lda _param 
	jsr obj_addr 
	jsr prop_addr
	jsr search_prop
	bcs get_prop_addr2
	ldx #0
	txa
	jmp store
get_prop_addr2
	tay
	inx
	bne get_prop_addr3
	iny

get_prop_addr3
	sec
	txa
	sbc _base_ptr
	tax
	tya
	sbc _base_ptr+1
	jmp store

_get_prop_len
	clc
	lda _base_ptr
	adc _param
	sta tmp
	lda _base_ptr+1
	adc _param+1
	sta tmp+1

	lda tmp
	bne *+4
	dec tmp+1
	dec tmp

	ldy #0
	lda (tmp),y
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc #1
	tax
	lda #0
	jmp store

array_page .word 0
array_offset .word 0

_load_word_array
	lda _param+2
	asl
	tax
	lda _param+3
	rol
	tay

	txa
	adc _param+0
	tax
	tya
	adc _param+1
	pha

	and #1
	ldy #3
	sta (sp),y
	dey
	txa
	sta (sp),y

	pla
	lsr
	ldy #0
	sta (sp),y
	tya
	iny
	sta (sp),y
	ldy #4
	jsr _get_word
	jmp store

_load_byte_array
	ldy #2
	clc
	lda _param+2
	adc _param+0
	sta (sp),y
	iny
	lda _param+3
	adc _param+1
	tax

	and #1
	sta (sp),y
	txa
	lsr
	ldy #0
	sta (sp),y
	tya
	iny
	sta (sp),y
	ldy #4
	jsr _get_byte
	jmp store

_save_word_array
	lda _param+2
	asl
	tax
	lda _param+3
	rol
	tay

	clc
	txa
	adc _param
	tax
	tya
	adc _param+1
	tay

	txa
	adc _base_ptr
	sta tmp
	tya
	adc _base_ptr+1
	sta tmp+1

	ldy #1
	lda _param+4
	sta (tmp),y
	dey
	lda _param+5
	sta (tmp),y

	rts

_save_byte_array
	clc
	lda _param+2
	adc _param
	tax
	lda _param+3
	adc _param+1
	tay

	txa
	adc _base_ptr
	sta tmp
	tya
	adc _base_ptr+1
	sta tmp+1
	
	ldy #0
	lda _param+4
	sta (tmp),y

	rts
