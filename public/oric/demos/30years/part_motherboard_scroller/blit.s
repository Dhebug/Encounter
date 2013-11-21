

	.zero
	
_MapX	.dsb 1
_MapY	.dsb 1
	
	
	.text


_ClearScreen
.(
	lda #<$bb80
	sta tmp0+0
	lda #>$bb80
	sta tmp0+1

	ldx #28	
loop_y

	ldy #39
	lda #16
loop_x
	sta (tmp0),y
	dey
	bne loop_x
	
	; Yellow ink
	lda #3
	sta (tmp0),y
	
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	
	dex
	bne loop_y
		
	
	rts
.)



_HighlighteArea
.(
	
loop_y
	ldx _ScrollerCommandParam3
	ldy #0
loop_x
	lda (_ScrollerCommandParam1),y
	eor #128
	sta (_ScrollerCommandParam1),y
	iny
	dex
	bne loop_x
	
	clc
	lda _ScrollerCommandParam1+0
	adc #40
	sta _ScrollerCommandParam1+0
	bcc skip
	inc _ScrollerCommandParam2+0
skip
	
	dec _ScrollerCommandParam4
	bne loop_y
	rts
.)



_ShowMap
.(
	ldy _MapY
	sty __auto_low+1
	sty __auto_high+1

	lda #<__auto+1
	sta tmp0+0
	lda #>__auto+1
	sta tmp0+1

	ldx #0
loop_patch

__auto_low
	lda _ChapMapAddrLow,x
	ldy #0
	sta (tmp0),y
	
__auto_high	
	lda _ChapMapAddrHigh,x
	iny
	sta (tmp0),y

	clc
	lda tmp0+0
	adc #6
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	
	inx
	cpx #27
	bne loop_patch
	

	lda _MapX	
	clc
	adc #39
	tax
	
	ldy #39
loop	

__auto
	lda _LabelCharMap+0*213,x
	sta $bb80+1*40,y
	lda _LabelCharMap+1*213,x
	sta $bb80+2*40,y
	lda _LabelCharMap+2*213,x
	sta $bb80+3*40,y
	lda _LabelCharMap+3*213,x
	sta $bb80+4*40,y
	lda _LabelCharMap+4*213,x
	sta $bb80+5*40,y
	lda _LabelCharMap+5*213,x
	sta $bb80+6*40,y
	lda _LabelCharMap+6*213,x
	sta $bb80+7*40,y
	lda _LabelCharMap+7*213,x
	sta $bb80+8*40,y
	lda _LabelCharMap+8*213,x
	sta $bb80+9*40,y
	lda _LabelCharMap+9*213,x
	sta $bb80+10*40,y

	lda _LabelCharMap+10*213,x
	sta $bb80+11*40,y
	lda _LabelCharMap+11*213,x
	sta $bb80+12*40,y
	lda _LabelCharMap+12*213,x
	sta $bb80+13*40,y
	lda _LabelCharMap+13*213,x
	sta $bb80+14*40,y
	lda _LabelCharMap+14*213,x
	sta $bb80+15*40,y
	lda _LabelCharMap+15*213,x
	sta $bb80+16*40,y
	lda _LabelCharMap+16*213,x
	sta $bb80+17*40,y
	lda _LabelCharMap+17*213,x
	sta $bb80+18*40,y
	lda _LabelCharMap+18*213,x
	sta $bb80+19*40,y
	lda _LabelCharMap+19*213,x
	sta $bb80+20*40,y
		
	lda _LabelCharMap+20*213,x
	sta $bb80+21*40,y
	lda _LabelCharMap+21*213,x
	sta $bb80+22*40,y
	lda _LabelCharMap+22*213,x
	sta $bb80+23*40,y
	lda _LabelCharMap+23*213,x
	sta $bb80+24*40,y
	lda _LabelCharMap+24*213,x
	sta $bb80+25*40,y
	lda _LabelCharMap+25*213,x
	sta $bb80+26*40,y
	lda _LabelCharMap+26*213,x
	sta $bb80+27*40,y
	
	dex
	dey
	beq end
	jmp loop
end	
	rts
.)


_InitCharMapAddr
.(
	lda #<_LabelCharMap
	sta tmp0+0
	lda #>_LabelCharMap
	sta tmp0+1

	ldx #0
loop
	clc
	lda tmp0+0
	sta _ChapMapAddrLow,x
	adc #213
	sta tmp0+0

	lda tmp0+1
	sta _ChapMapAddrHigh,x
	adc #0
	sta tmp0+1
		
	inx
	bne loop

	rts
.)



;
; Allign the following data on a 256 bytes
; boundary in order to optimise the accessing code.
;
	.dsb 256-(*&255)

_ChapMapAddrLow		.dsb 256
_ChapMapAddrHigh	.dsb 256
	