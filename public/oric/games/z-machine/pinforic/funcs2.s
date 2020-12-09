_plus
        clc
        lda _param
        adc _param+2
        tax
        lda _param+1
        adc _param+3
        jmp store

_minus
        sec
        lda _param
        sbc _param+2
        tax
        lda _param+1
        sbc _param+3
        jmp store

_multiply
	lda _param
	sta op1
	lda _param+1
	sta op1+1
	lda _param+2
	sta op2
	lda _param+3
	sta op2+1
	jsr mul16u
	jmp store

_divide
	lda _param
	sta op1
	lda _param+1
	sta op1+1
	lda _param+2
	sta op2
	lda _param+3
	sta op2+1
	jsr div16u
	jmp store

_mod
	lda _param
	sta op1
	lda _param+1
	sta op1+1
	lda _param+2
	sta op2
	lda _param+3
	sta op2+1
	jsr mod16u
	jmp store

_pi_random
	lda _random1
	asl
	sta tmp
	lda _random1+1
	rol
	sta tmp+1
	lda _random2
	sta _random1
	lda _random2+1
	sta _random1+1
	bit _random2+1
	bpl pi_random1
	inc tmp
	bne pi_random1
	inc tmp+1
pi_random1
	lda _random2
	eor tmp
	sta _random2
	lda _random2+1
	eor tmp+1
	sta _random2+1
	ldx #0
	lda _param
	ora _param+1
	beq pi_random2
	lda _random2
	sta op1
	lda _random2+1
	and #$7f
	sta op1+1
	lda _param
	sta op2
	lda _param+1
	sta op2+1
	jsr mod16u
	inx
	bne pi_random2
	clc
	adc #1
pi_random2
	jmp store

_LTE
	lda _param
	cmp _param+2
	lda _param+1
	sbc _param+3
	bvc *+4
	eor #$80
	and #$80
	jmp ret_value
	
_GTE
	lda _param+2
	cmp _param
	lda _param+3
	sbc _param+1
	bvc *+4
	eor #$80
	and #$80
	jmp ret_value

_bit
        lda _param
        eor #$ff
        and _param+2
        bne ret_value0
        lda _param+1
        eor #$ff
        and _param+3
        bne ret_value0
        beq ret_value1

_or
        lda _param
        ora _param+2
        tax
        lda _param+1
        ora _param+3
        jmp store

_not
        lda _param
        eor #$ff
        tax
        lda _param+1
        eor #$ff
        jmp store

_and
        lda _param
        and _param+2
        tax
        lda _param+1
        and _param+3
        jmp store


_cp_zero
        lda _param
        ora _param+1
        bne ret_value0
	jmp ret_value_true
ret_value1
	lda #$80
	jmp ret_value

ret_value0
	lda #0
	jmp ret_value

_compare
        dec _num_params
        lda _param+3
        cmp _param+1
        bne compare2
        lda _param+2
        cmp _param+0
        beq ret_value1
compare2
        dec _num_params
        beq ret_value0
        lda _param+5
        cmp _param+1
        bne compare3
        lda _param+4
        cmp _param+0
        beq ret_value1
compare3
        dec _num_params
        beq ret_value0
        lda _param+7
        cmp _param+1
        bne ret_value0
        lda _param+6
        cmp _param+0
        beq ret_value1
        bne ret_value0
