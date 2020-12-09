trace1 .byte "[%x]"
	.byte 0
trace2 .byte "%x\012"
	.byte 0
trace3 .byte "[%x:%x]"
	.byte 0

_print_stack_ptr
	pha
	txa
	pha
	tya
	pha
	ldy #0
	lda #<(trace3)
	sta (sp),y
	iny
	lda #>(trace3)
	sta (sp),y
	iny
	lda (_stack_var_ptr),y
	sta (sp),y
	iny
	lda (_stack_var_ptr),y
	sta (sp),y
	iny
	lda sp
	sta (sp),y
	iny
	lda sp+1
	sta (sp),y
	iny
	jsr _printf
	pla
	tay
	pla
	tax
	pla
	rts

trace_opcode
	pha
	txa
	pha
	tya
	pha
	ldy #0
	lda #<(trace2)
	sta (sp),y
	iny
	lda #>(trace2)
	sta (sp),y
	iny
	lda _opcode
	sta (sp),y
	iny
	lda #0
	sta (sp),y
	iny
	jsr _printf
	pla
	tay
	pla
	tax
	pla
	rts
trace_fmt .byte "[%x:%x]"
	.byte 0

trace_pc
	pha
	txa
	pha
	tya
	pha
	ldy #0
	lda #<(trace_fmt)
        sta (sp),y
        iny
        lda #>(trace_fmt)
        sta (sp),y
        iny
	lda _pc_page
	sta (sp),y
	iny
	lda _pc_page+1
	sta (sp),y
	iny
	lda _pc_offset
	sta (sp),y
	iny
	lda _pc_offset+1
	sta (sp),y
        jsr _printf 
	pla
	tay
	pla
	tax
	pla
	rts
