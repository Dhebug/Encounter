; _foofoo	.byt 0			; 
_div8uLTQ	.byt 0
_div8uLB	.byt 0
_div8u
	ldy #0
	lda (sp),y
	sta _div8uLTQ
	ldy #2
	lda (sp),y
	sta _div8uLB
	;jmp _div8uout
	; http://6502org.wikidot.com/software-math-intdiv

	LDA #0
	LDX #8
	ASL _div8uLTQ
_div8uL1
	ROL
	CMP _div8uLB
	BCC _div8uL2
	SBC _div8uLB
_div8uL2
	ROL _div8uLTQ
	DEX
	BNE _div8uL1
_div8uout

	ldx _div8uLTQ
	lda #0
	rts


; _foofoo	.byt 0			; 
_div8sLTQ	.byt 0
_div8sLB	.byt 0
_div8sSIGN	.byt 0
_div8s
	ldx #0
	ldy #0
	lda (sp),y
	sta _div8sLTQ
	cmp #0
	bpl _div8spos1
	lda #0
	clc
	sbc _div8sLTQ
	sta _div8sLTQ
	inx
_div8spos1
	stx _div8sSIGN
	ldy #2
	lda (sp),y
	sta _div8sLB
	;jmp _div8sout
	; http://6502org.wikidot.com/software-math-intdiv

	LDA #0
	LDX #8
	ASL _div8sLTQ
_div8sL1
	ROL
	CMP _div8sLB
	BCC _div8sL2
	SBC _div8sLB
_div8sL2
	ROL _div8sLTQ
	DEX
	BNE _div8sL1
_div8sout
	ldx _div8sLTQ
	lda _div8sSIGN
	cmp #0
	
	beq _div8spos3
	lda #0
	clc
	sbc _div8sLTQ
	tax
	lda #$ff
	rts
_div8spos3
	lda #0
	rts

