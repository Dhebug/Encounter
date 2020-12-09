_next_word
	ldy _pc_offset
        lda (_pc_ptr),y
	pha
        inc _pc_offset
        bne nextword1
	jsr _fix_pc1
	jsr _next_byte
        pla
	rts
nextword1
	iny
	lda (_pc_ptr),y
        inc _pc_offset
        bne nextword2
	jsr _fix_pc1
nextword2
        tax
	pla
        rts

_fix_pc1
	inc _pc_ptr+1
        inc _pc_offset+1
        ldx _pc_offset+1
        cpx #2
        bne pc_fixed
	pha
        jsr _fix_pc
        pla
pc_fixed
	rts

_next_byte
        ldy _pc_offset
        lda (_pc_ptr),y
        inc _pc_offset
        bne nextbyte2
	jsr _fix_pc1
nextbyte2
        tax
        lda #0
        rts

load
        dex
        bmi _next_word	; mode 0 : immediate word
        beq _next_byte	; mode 1 : immediate byte
			; mode 2 : variable
        ldy _pc_offset
        lda (_pc_ptr),y
        inc _pc_offset
        bne *+5
	jsr _fix_pc1
        tax
        beq load0
	jmp load_var
load0
			; variable #0 : pops from stack
        ldy #0
        lda (_stack),y
        tax
        iny
        lda (_stack),y
	tay

	clc
	lda _stack
	adc #2
	sta _stack
	bcc *+4
	inc _stack+1
	tya
        rts

_get_var
	lda _param
	jsr load_var
	jmp store

_load_var
	ldy #0
	lda (sp),y
load_var
	bne load_var2
; variable #0 : current stack value
	ldy #0
	lda (_stack),y
	tax
	iny
	lda (_stack),y
	rts
load_var2
	cmp #$10
	bcs load_var3
; local variables #1 to #15
	sbc #0		; carry=0 so substract 1

	asl
	sta tmp

	sec
	lda _stack_var_ptr
	sbc tmp
	sta tmp
	lda _stack_var_ptr+1
	sbc #0
	sta tmp+1

	ldy #0
	lda (tmp),y
	tax
	iny
	lda (tmp),y
	rts
load_var3
; global variables
	sbc #$10

	asl
	tax
	lda #0
	rol
	tay

	txa
	adc _global_ptr
	sta tmp
	tya
	adc _global_ptr+1
	sta tmp+1

	ldy #1
	lda (tmp),y
	tax
	dey
	lda (tmp),y
	rts

_put_var
	lda _param
	bne put_var2
	
	ldy #0
	lda _param+2
	sta (_stack),y
	iny
	lda _param+3
	sta (_stack),y
	rts
put_var2
	cmp #$10
	bcs put_var3
	sbc #0
	asl
	sta tmp
	sec
	lda _stack_var_ptr
	sbc tmp
	sta tmp
	lda _stack_var_ptr+1
	sbc #0
	sta tmp+1
	ldy #0
	lda _param+2
	sta (tmp),y
	iny
	lda _param+3
	sta (tmp),y
	rts
put_var3
	sbc #$10
	asl
	tax
	lda #0
	rol
	tay

	txa
	adc _global_ptr
	sta tmp
	tya
	adc _global_ptr+1
	sta tmp+1

	ldy #1
	lda _param+2
	sta (tmp),y
	dey
	lda _param+3
	sta (tmp),y
	rts

_push
	sec
	lda _stack
	sbc #2
	sta _stack
	bcs *+4
	dec _stack+1
	ldy #0
	lda _param
	sta (_stack),y
	iny
	lda _param+1
	sta (_stack),y
	rts

_pop
	ldy #0
	lda (_stack),y
	sta _param+2
	iny
	lda (_stack),y
	sta _param+3

	clc
	lda _stack
	adc #2
	sta _stack
	bcc *+4
	inc _stack+1
	jmp _put_var

_inc_var
	lda _param
	jsr load_var
	sta _param+3
	inx
	stx _param+2
	bne *+5
	inc _param+3
	jmp _put_var

_dec_var
	lda _param
	jsr load_var
	sta _param+3
	txa
	bne *+5
	dec _param+3
	dex
	stx _param+2
	jmp _put_var

_inc_chk
	lda _param+3
	pha
	lda _param+2
	pha
	jsr _inc_var
	lda _param+2
	sta _param
	lda _param+3
	sta _param+1
	pla
	sta _param+2
	pla
	sta _param+3
	jmp _GTE

_dec_chk
	lda _param+3
	pha
	lda _param+2
	pha
	jsr _dec_var
	lda _param+2
	sta _param
	lda _param+3
	sta _param+1
	pla
	sta _param+2
	pla
	sta _param+3
	jmp _LTE
