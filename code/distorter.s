
    .zero

OldByte	.dsb 1

    .text

DisplayMakeShiftedLogo

	ldx #74
LoopDisplayMakeShiftedLogo_Y

	lda #0
	sta OldByte
	ldy #0
LoopDisplayMakeShiftedLogo_X
	lda (tmp6),y
	pha
	and #63
	lsr 
	ora	OldByte
	ora #64
	sta (tmp7),y

	pla
	and #1
	asl
	asl
	asl
	asl
	asl
	sta OldByte

	iny 
	cpy #40
	bne LoopDisplayMakeShiftedLogo_X

	clc
	lda tmp6
	adc #40
	sta tmp6
	bcc skip_src
	inc tmp6+1
	clc
skip_src

	lda tmp7
	adc #40
	sta tmp7
	bcc skip_dst
	inc tmp7+1
skip_dst

    txa
    pha
    ; Try to get the menu working during pre-calc
    jsr _CheckOptionMenuInput
    pla
    tax

	dex
	bne LoopDisplayMakeShiftedLogo_Y

	rts




_DrawPreshiftLogos
	; 0
	lda #<_LabelPicture0
	sta tmp6
	lda #>_LabelPicture0
	sta tmp6+1
	lda #<_LabelPicture1
	sta tmp7
	lda #>_LabelPicture1
	sta tmp7+1
	jsr DisplayMakeShiftedLogo

	; 1
	lda #<_LabelPicture1
	sta tmp6
	lda #>_LabelPicture1
	sta tmp6+1
	lda #<_LabelPicture2
	sta tmp7
	lda #>_LabelPicture2
	sta tmp7+1
	jsr DisplayMakeShiftedLogo

	; 2
	lda #<_LabelPicture2
	sta tmp6
	lda #>_LabelPicture2
	sta tmp6+1
	lda #<_LabelPicture3
	sta tmp7
	lda #>_LabelPicture3
	sta tmp7+1
	jsr DisplayMakeShiftedLogo

	; 3
	lda #<_LabelPicture3
	sta tmp6
	lda #>_LabelPicture3
	sta tmp6+1
	lda #<_LabelPicture4
	sta tmp7
	lda #>_LabelPicture4
	sta tmp7+1
	jsr DisplayMakeShiftedLogo

	; 4
	lda #<_LabelPicture4
	sta tmp6
	lda #>_LabelPicture4
	sta tmp6+1
	lda #<_LabelPicture5
	sta tmp7
	lda #>_LabelPicture5
	sta tmp7+1
	jmp DisplayMakeShiftedLogo

; The buffers are defined in BSS in last_module.s
_DistorterTable
    .word _LabelPicture0
    .word _LabelPicture1
    .word _LabelPicture2
    .word _LabelPicture3
    .word _LabelPicture4
    .word _LabelPicture5

