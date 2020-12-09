_look_up
	ldx #6 
	lda #8 
	jsr enter 

	ldy #0 
	lda (ap),y 
	sta (sp),y 
	ldy #1 
	lda (ap),y 
	sta (sp),y 

	ldy #2 
	jsr _encode 

	lda _num_vocab_words 
	sta reg4 
	lda _num_vocab_words+1 
	sta reg4+1 

	lda _vocab_entry_size 
	sta reg5 
	lda _vocab_entry_size+1 
	sta reg5+1 

	lda reg4 
	sta tmp 
	lda reg4+1 
	ldx #1 
	beq *+8 
	lsr 
	ror tmp 
	dex 
	bne *-4 
	ldx tmp 
	stx reg4 
	sta reg4+1 

Llookup46
	lda reg5 
	asl 
	sta reg5 
	lda reg5+1 
	rol 
	sta reg5+1 

	lda reg4 
	sta tmp 
	lda reg4+1 
	ldx #1 
	beq *+8 
	lsr 
	ror tmp 
	dex 
	bne *-4 
	ldx tmp 
	stx reg4 
	sta reg4+1 

Llookup47
	lda reg4 
	ora reg4+1 
	beq *+5 
	jmp Llookup46 

	clc 
	lda reg5 
	adc _strt_vocab_table 
	sta tmp0 
	lda reg5+1 
	adc _strt_vocab_table+1 
	sta tmp0+1 

	sec 
	lda tmp0 
	sbc _vocab_entry_size 
	sta reg0 
	lda tmp0+1 
	sbc _vocab_entry_size+1 
	sta reg0+1 

	lda #0 
	sta reg7 
	lda #0 
	sta reg7+1 

Llookup49
	lsr reg5+1
	ror reg5
	ldy #0
	lda (reg0),y
	cmp _coded+1
	bcc Llookup52
	bne Llookup62
	iny
	lda (reg0),y
	cmp _coded
	bcc Llookup52
	bne Llookup62
	iny
	lda (reg0),y
	cmp _coded+3
	bcc Llookup52
	bne Llookup62
	iny
	lda (reg0),y
	cmp _coded+2
	bcc Llookup52
	bne Llookup62
	lda #1
	sta reg7
	jmp Llookup53
Llookup52
	clc 
	lda reg5 
	adc reg0 
	sta reg0 
	lda reg5+1 
	adc reg0+1 
	sta reg0+1 

	lda _end_vocab_table 
	cmp reg0 
	lda _end_vocab_table+1 
	sbc reg0+1 
	bcc *+5 
	jmp Llookup63 
 
 

	lda _end_vocab_table 
	sta reg0 
	lda _end_vocab_table+1 
	sta reg0+1 

	jmp Llookup63 

Llookup62
	sec 
	lda reg0 
	sbc reg5 
	sta reg0 
	lda reg0+1 
	sbc reg5+1 
	sta reg0+1 

Llookup63
Llookup53
Llookup50
	lda reg5 
	cmp _vocab_entry_size 
	lda reg5+1 
	sbc _vocab_entry_size+1 
	bcs *+5 
	jmp Llookup66 
 

	lda reg7
	beq Llookup49
Llookup66
	lda reg7 
	ora reg7+1 
	beq *+5 
	jmp Llookup67 

	lda #0 
	sta reg6 
	lda #0 
	sta reg6+1 

	jmp Llookup68 

Llookup67
	sec 
	lda reg0 
	sbc _base_ptr 
	sta reg6 
	lda reg0+1 
	sbc _base_ptr+1 
	sta reg6+1 

Llookup68
	ldy #2
	lda (ap),y
	sta tmp0
	iny
	lda (ap),y
	sta tmp0+1

	ldy #1 
	lda reg6 
	sta (tmp0),y 
	dey
	lda reg6+1
	sta (tmp0),y

	jmp leave 
