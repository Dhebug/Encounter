
	.zero

pos_y		.dsb 1
save_y		.dsb 1

	.text


; 16 entries
MiniTableUnroll
	.byt 0         ; The normal line of the picture
	.byt 255       ; A black line for special effect
	.byt 32
	.byt 29
	.byt 27
	.byt 26
	.byt 25
	.byt 24
	.byt 23
	.byt 22
	.byt 21
	.byt 20
	.byt 19
	.byt 17
	.byt 14
	.byt 10
	.byt 255       ; A black line for special effect



_PictureTransitionUnroll
.(
	ldy #238
loop_frame
	sty pos_y

	ldx #0
loop_roll
	lda MiniTableUnroll,x
	bmi no_wrap
	clc
	adc pos_y
no_wrap	
	tay

	lda _PictureLoadBufferAddrLow,y
	sta tmp0+0
	lda _PictureLoadBufferAddrHigh,y
	sta tmp0+1

	clc
	txa
	adc pos_y
	tay

	lda _ScreenAddrLow,y
	sta tmp1+0
	lda _ScreenAddrHigh,y
	sta tmp1+1

	; Copy from right to left to limit the attribute corruption effects
	ldy #40
loop
	lda (tmp0),y
	sta (tmp1),y
	dey
	bne loop

	inx
	cpx #16
	bne loop_roll

	jsr _VSync

	ldy pos_y
	iny  
	cpy #216
	bne loop_frame

	rts
.)



; A simple copy with multiple simultaneous displayed bands
; tmp0 -> tmp1 
; tmp2 -> tmp3 
; tmp4 -> tmp5
; tmp6 -> tmp7 
_PictureTransitionVenicianStore
.(
	ldx #0
loop_frame

	lda _PictureLoadBufferAddrLow,x
	sta tmp0+0
	lda _PictureLoadBufferAddrHigh,x
	sta tmp0+1

	lda _ScreenAddrLow,x
	sta tmp1+0
	lda _ScreenAddrHigh,x
	sta tmp1+1


	lda _PictureLoadBufferAddrLow+50,x
	sta tmp2+0
	lda _PictureLoadBufferAddrHigh+50,x
	sta tmp2+1

	lda _ScreenAddrLow+50,x
	sta tmp3+0
	lda _ScreenAddrHigh+50,x
	sta tmp3+1

	lda _PictureLoadBufferAddrLow+100,x
	sta tmp4+0
	lda _PictureLoadBufferAddrHigh+100,x
	sta tmp4+1

	lda _ScreenAddrLow+100,x
	sta tmp5+0
	lda _ScreenAddrHigh+100,x
	sta tmp5+1


	lda _PictureLoadBufferAddrLow+150,x
	sta tmp6+0
	lda _PictureLoadBufferAddrHigh+150,x
	sta tmp6+1

	lda _ScreenAddrLow+150,x
	sta tmp7+0
	lda _ScreenAddrHigh+150,x
	sta tmp7+1

	; Copy from right to left to limit the attribute corruption effects
	ldy #40
loop
	lda (tmp0),y
	sta (tmp1),y

	lda (tmp2),y
	sta (tmp3),y

	lda (tmp4),y
	sta (tmp5),y

	lda (tmp6),y
	sta (tmp7),y

	dey
	bne loop

	jsr _VSync

	inx
	cpx #50
	bne loop_frame

	rts
.)



; A simple copy from the top and bottom at the same time
; tmp0 -> tmp1 
; tmp2 -> tmp3 
_PictureTransitionFromTopAndBottom
.(
	ldx #0
	ldy #199
loop_frame

	lda _PictureLoadBufferAddrLow,x
	sta tmp0+0
	lda _PictureLoadBufferAddrHigh,x
	sta tmp0+1

	lda _ScreenAddrLow,x
	sta tmp1+0
	lda _ScreenAddrHigh,x
	sta tmp1+1

	lda _PictureLoadBufferAddrLow,y
	sta tmp2+0
	lda _PictureLoadBufferAddrHigh,y
	sta tmp2+1

	lda _ScreenAddrLow,y
	sta tmp3+0
	lda _ScreenAddrHigh,y
	sta tmp3+1

	sty save_y

	; Copy from right to left to limit the attribute corruption effects
	ldy #40
loop
	lda (tmp0),y
	sta (tmp1),y
	lda (tmp2),y
	sta (tmp3),y
	dey
	bne loop

	jsr _VSync

	ldy save_y
	dey
	inx
	cpx #100
	bne loop_frame

	rts
.)





_InitTransitionDataBuffer1
	lda #<_BufferPicture1-1
	sta tmp0+0
	lda #>_BufferPicture1-1
	sta tmp0+1
	jmp _InitTransitionData


_InitTransitionDataBuffer2
	lda #<_BufferPicture2-1
	sta tmp0+0
	lda #>_BufferPicture2-1
	sta tmp0+1
	jmp _InitTransitionData

_InitTransitionDataBuffer3
	lda #<_BufferPicture3-1
	sta tmp0+0
	lda #>_BufferPicture3-1
	sta tmp0+1
	jmp _InitTransitionData

_InitTransitionDataBuffer4
	lda #<_BufferPicture4-1
	sta tmp0+0
	lda #>_BufferPicture4-1
	sta tmp0+1
	jmp _InitTransitionData

_InitTransitionData
.(
	lda #<$a000-1
	sta tmp1+0
	lda #>$a000-1
	sta tmp1+1

	.(
	ldx #0
loop
	clc
	lda tmp0+0
	sta _PictureLoadBufferAddrLow,x
	adc #40
	sta tmp0+0
	lda tmp0+1
	sta _PictureLoadBufferAddrHigh,x
	adc #0
	sta tmp0+1

	clc
	lda tmp1+0
	sta _ScreenAddrLow,x
	adc #40
	sta tmp1+0
	lda tmp1+1
	sta _ScreenAddrHigh,x
	adc #0
	sta tmp1+1

	inx
	cpx #200
	bne loop	
	.)

	.(
loop
	lda #<_EmptySourceScanLine
	sta _PictureLoadBufferAddrLow,x
	lda #>_EmptySourceScanLine
	sta _PictureLoadBufferAddrHigh,x

	lda #<_EmptyDestinationScanLine
	sta _ScreenAddrLow,x
	lda #>_EmptyDestinationScanLine
	sta _ScreenAddrHigh,x

	inx
	bne loop	
	.)

	rts
.)


