
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
	lda (tmp0),y
	pha
	and #63
	lsr 
	ora	OldByte
	ora #64
	sta (tmp1),y

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
	lda tmp0
	adc #40
	sta tmp0
	bcc skip_src
	inc tmp0+1
	clc
skip_src

	lda tmp1
	adc #40
	sta tmp1
	bcc skip_dst
	inc tmp1+1
skip_dst

	dex
	bne LoopDisplayMakeShiftedLogo_Y
	rts




_DrawPreshiftLogos
	; 0
	lda #<_LabelPicture0
	sta tmp0
	lda #>_LabelPicture0
	sta tmp0+1
	lda #<_LabelPicture1
	sta tmp1
	lda #>_LabelPicture1
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 1
	lda #<_LabelPicture1
	sta tmp0
	lda #>_LabelPicture1
	sta tmp0+1
	lda #<_LabelPicture2
	sta tmp1
	lda #>_LabelPicture2
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 2
	lda #<_LabelPicture2
	sta tmp0
	lda #>_LabelPicture2
	sta tmp0+1
	lda #<_LabelPicture3
	sta tmp1
	lda #>_LabelPicture3
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 3
	lda #<_LabelPicture3
	sta tmp0
	lda #>_LabelPicture3
	sta tmp0+1
	lda #<_LabelPicture4
	sta tmp1
	lda #>_LabelPicture4
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 4
	lda #<_LabelPicture4
	sta tmp0
	lda #>_LabelPicture4
	sta tmp0+1
	lda #<_LabelPicture5
	sta tmp1
	lda #>_LabelPicture5
	sta tmp1+1
	jsr DisplayMakeShiftedLogo
	rts

; Severn Software logo: 215x51    -> 40*51=2040  *6=12240
; Defence Force logo: 216x74      -> 40*74=2960  *6=17760


_LabelPicture0	.dsb 2960
_LabelPicture1	.dsb 2960
_LabelPicture2	.dsb 2960
_LabelPicture3	.dsb 2960
_LabelPicture4	.dsb 2960
_LabelPicture5	.dsb 2960

_DistorterTable
    .word _LabelPicture0
    .word _LabelPicture1
    .word _LabelPicture2
    .word _LabelPicture3
    .word _LabelPicture4
    .word _LabelPicture5

