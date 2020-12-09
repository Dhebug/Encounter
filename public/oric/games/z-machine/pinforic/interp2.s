
_num_params .word 0
_param	.word 0,0,0,0
_opcode .word 0
paramptr .byte 0
modes	.byte 0

_interp
	lda _gflags
	cmp #5
	beq interpEnd
interpLoop
	ldy _pc_offset
	lda (_pc_ptr),y
	inc _pc_offset
	bne *+5
	jsr _fix_pc1
	sta _opcode

; jsr trace_pc
; jsr trace_opcode
	bit _opcode
	bpl oper2
	bvs oper3
	jmp oper1
interpEnd
	rts

oper2
	ldx #2
	stx _num_params
	bit _opcode
	bvs loadparam1
	ldx #1
loadparam1
	jsr load
	stx _param+0
	sta _param+1

	ldx #2
	lda #$20
	bit _opcode
	bne loadparam2
	ldx #1
loadparam2
	jsr load
	stx _param+2
	sta _param+3

	lda _opcode
	and #$1F
	jmp execute

oper3
;	lda #0
;	sta _param+0
;	sta _param+1
;	sta _param+2
;	sta _param+3
;	sta _param+4
;	sta _param+5
;	sta _param+6
;	sta _param+7
	ldy _pc_offset
	lda (_pc_ptr),y
	inc _pc_offset
	bne *+5
	jsr _fix_pc1
	sta modes

	ldx #0
	and #$C0
	cmp #$C0
	beq endparam
	asl
	rol
	rol
	tax
	jsr load
	stx _param
	sta _param+1

	ldx #1
	lda modes
	and #$30
	cmp #$30
	beq endparam
	lsr
	lsr
	lsr
	lsr
	tax
	jsr load
	stx _param+2
	sta _param+3

	ldx #2
	lda modes
	and #$0C
	cmp #$0C
	beq endparam
	lsr
	lsr
	tax
	jsr load
	stx _param+4
	sta _param+5

	ldx #3
	lda modes
	and #3
	cmp #3
	beq endparam
	tax
	jsr load
	stx _param+6
	sta _param+7
	ldx #4
endparam
	stx _num_params
	lda _opcode
	and #$3F

execute
	asl
	tax
	lda op2tab,x
	sta switch2+1
	lda op2tab+1,x
	sta switch2+2
	ldy #0
switch2
	jsr $0000
	jmp _interp


oper1
	lda _opcode
	cmp #$B0
	bcs misc
	lsr
	lsr
	lsr
	lsr
	and #3
	tax
	jsr load
	stx _param+0
	sta _param+1
	lda _opcode
	and #$0F
	asl
	tax
	lda op1tab,x
	sta switch1+1
	lda op1tab+1,x
	sta switch1+2
	ldy #0
switch1
	jsr $0000
	jmp _interp

misc
	and #$0F
	asl
	tax
	lda misctab,x
	sta switch+1
	lda misctab+1,x
	sta switch+2
	ldy #0
switch
	jsr $0000
	jmp _interp

invalid
	ldy #0
	lda #<(inv_opcode_msg)
	sta (sp),y
	iny
	lda #>(inv_opcode_msg)
	sta (sp),y
	iny
	jsr _printf
	jmp _exit

inv_opcode_msg 
	.byte "Invalid opcode !"
	.byte $0a,$00

unimplemented
	rts

op1tab
	.word _cp_zero
	.word _get_link
	.word _get_holds
	.word _get_loc
	.word _get_prop_len
	.word _inc_var
	.word _dec_var
	.word _print1

	.word invalid
	.word _remove_obj
	.word _p_obj
	.word _rtn
	.word _jump
	.word _print2
	.word _get_var
	.word _not

op2tab
	.word invalid
	.word _compare
	.word _LTE
	.word _GTE
	.word _dec_chk
	.word _inc_chk
	.word _check_loc
	.word _bit

	.word _or
	.word _and
	.word _test_attr
	.word _set_attr
	.word _clr_attr
	.word _put_var
	.word _transfer
	.word _load_word_array

	.word _load_byte_array
	.word _get_prop
	.word _get_prop_addr
	.word _next_prop
	.word _plus
	.word _minus
	.word _multiply
	.word _divide

	.word _mod
	.word invalid
	.word invalid
	.word invalid
	.word invalid
	.word invalid
	.word invalid
	.word invalid

	.word _gosub
	.word _save_word_array
	.word _save_byte_array
	.word _put_prop
	.word _input
	.word _print_char
	.word _print_num
	.word _pi_random

	.word _push
	.word _pop
	.word invalid
	.word invalid
	.word invalid
	.word invalid
	.word invalid
	.word invalid

	.word invalid
	.word invalid
	.word invalid
	.word unimplemented
	.word unimplemented
	.word _bell
	.word invalid
	.word invalid

	.word invalid
	.word invalid
	.word invalid
	.word invalid
	.word invalid
	.word invalid
	.word invalid
	.word invalid

misctab
	.word _rtn1
	.word _rtn0
	.word _wrt
	.word _writeln
	.word invalid
	.word _save
	.word _restore
	.word _restart

	.word _rts
	.word _pop_stack
	.word _quit
	.word _new_line
	.word _set_score
	.word invalid
	.word invalid
	.word invalid
