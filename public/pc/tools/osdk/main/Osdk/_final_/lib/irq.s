_install_irq_handler
	ldx #<$024A
	lda #>$024A
	jmp chain_handler

_chain_irq_handler
	ldx $0245
	lda $0246
	jmp chain_handler

_uninstall_irq_handler
	ldx old_handler
	lda old_handler+1
	php
	sei
	stx $0245
	sta $0246
	plp
	rts

chain_handler
	stx jmp_old_handler+1
	sta jmp_old_handler+2

	ldy #0
	lda (sp),y
	sta jsr_C_handler+1
	iny
	lda (sp),y
	sta jsr_C_handler+2
	ldx $0245
	lda $0246
	stx old_handler
	sta old_handler+1
	ldx #<irq_handler
	lda #>irq_handler
	php
	sei
	stx $0245
	sta $0246
	plp
	rts

old_handler	.word	0

irq_handler
	pha
	txa
	pha
	tya
	pha
	inc sp+1
	ldy #2*11-1	; tmp0..7 + tmp + op1 + op2
savetmp lda tmp0,y
	sta (sp),y
	dey
	bpl savetmp
	clc
	lda sp
	adc #2*11	; tmp0..7 + tmp + op1 + op2
	sta sp
	bcc *+4
	inc sp+1
jsr_C_handler
	jsr 0000
	lda sp
	sec
	sbc #2*11	; tmp0..7 + tmp + op1 + op2
	sta sp
	bcs *+4
	dec sp+1
	ldy #2*11-1	; tmp0..7 + tmp + op1 + op2
resttmp lda (sp),y
	sta tmp0,y
	dey
	bpl resttmp
	dec sp+1
	pla
	tay
	pla
	tax
	pla
jmp_old_handler
	jmp 0000
