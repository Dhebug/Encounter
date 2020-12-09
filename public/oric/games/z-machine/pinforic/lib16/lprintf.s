;
; lprintf(str,...)
;
_lprintf
	ldy #0
	lda (sp),y
	sta tmp
	iny
	lda (sp),y
	sta tmp+1
	iny
        sty lsaveptrarg

	ldy #0
lformloop
	lda (tmp),y
	tax
        beq lendform
	cmp #$0A
        beq llinefeed
	cmp #$25	; if '%'
        beq lformfield
lcharput
        jsr $023e
	iny
        bne lformloop    ; size format string < 256
lendform
	rts
llinefeed
        jsr $023e
	ldx #$0D
        jmp lcharput
lformfield
	iny
	lda (tmp),y
        cmp #$64
        beq lprintint
        cmp #$73
        beq lprintstr
        cmp #$63
        beq lprintchar
        cmp #$78
        beq lprinthex
        jmp lcharput
lprintchar
        sty lsaveptrform
        ldy lsaveptrarg
	lda (sp),y
	tax
	iny
	iny
        sty lsaveptrarg
        ldy lsaveptrform
        jmp lcharput
lprintstr
	iny
        sty lsaveptrform
        ldy lsaveptrarg
	lda (sp),y
	sta op2
	iny
	lda (sp),y
	sta op2+1
	iny
        sty lsaveptrarg
	ldy #0
lprtsloop
	lda (op2),y
	tax
        beq lendprts
        jsr $023e
	iny
        bne lprtsloop
	inc op2+1
        jmp lprtsloop
lendprts
        ldy lsaveptrform
        jmp lformloop
lprintint
	iny
        sty lsaveptrform
        jsr lnextarg
	jsr itoa
	stx op2
	sta op2+1
	ldy #0
        jmp lprtsloop

lprinthex
	iny
        sty lsaveptrform
        jsr lnextarg
	lda op2+1
        jsr lhexbyte
	lda op2
        jsr lhexbyte
        ldy lsaveptrform
        jmp lformloop

lsaveptrform
        byte 0
lsaveform
        byte 0,0
lsaveptrarg
        byte 0

lhexbyte
	tay 
	lsr a
	lsr a
	lsr a
	lsr a
        jsr lnibble
	tya
	and #$0F
lnibble
	cmp #10
        bcc lchiffre
	adc #6
lchiffre
	adc #$30
	tax
        jmp $023e

lnextarg
        ldy lsaveptrarg
	lda (sp),y
	sta op2
	iny
	lda (sp),y
	sta op2+1
	iny
        sty lsaveptrarg
	rts
