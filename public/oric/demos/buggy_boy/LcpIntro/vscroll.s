
	.zero

_MainLoopDelay			.dsb 2

	.text


// Picture is 14*224=3136 bytes unpacked
//                   2534 bytes packed
//                    602 bytes winning...
#define VSCROLL_SPLIT_POSITION	26
#define VSCROLL_PICTURE_WIDTH	14

_CharacterRedefOne
	.byt %000000
	.byt %011110
	.byt %010010
	.byt %010010
	.byt %010010
	.byt %010010
	.byt %011110
	.byt %000000

	.byt %111111
	.byt %100000
	.byt %100000
	.byt %100000
	.byt %100000
	.byt %100000
	.byt %100000
	.byt %100000

	.byt %111111
	.byt %000001
	.byt %000001
	.byt %000001
	.byt %000001
	.byt %000001
	.byt %000001
	.byt %000001

	.byt %100000
	.byt %100000
	.byt %100000
	.byt %100000
	.byt %100000
	.byt %100000
	.byt %100000
	.byt %111111

	.byt %000001
	.byt %000001
	.byt %000001
	.byt %000001
	.byt %000001
	.byt %000001
	.byt %000001
	.byt %111111



_ScrollerMappingTable
	.byt "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?. ",0

_ScrollerPtr
	.word _ScrollerMessage
	
_ScrollerMessage
	/*
	.byt "CREDITS GOES TO   "
	.byt "MERMAID FOR SIDE GRAPHIC   "
	.byt "TWILIGHTE FOR INTRO MUSIC   "
	.byt "DMASC FOR MAIN MUSIC   "
	.byt "DBUG FOR WHAT REMAINS        "
	*/
	.byt "THIS DEMO WAS MADE BY MERMAID DMASC TWILIGHTE AND DBUG        "
	.byt 0


_AngleVal0	.byt 0
_AngleVal1	.byt 0

_AngleInc0	.byt 7
_AngleInc1	.byt 5



CharCounter		.byt 1
PtrLetterLow	.byt 0
PtrLetterHigh	.byt 0

#define BASECHARSET	$b400+32*8-32


_VScroll_ClearBigBuffer
.(
	lda #<_BigBuffer
	sta tmp0+0
	lda #>_BigBuffer
	sta tmp0+1

	lda #0
	ldx #33
loop_outer
	ldy #0
loop_inner
	sta (tmp0),y
	dey
	bne loop_inner
	inc tmp0+1
	dex
	bne loop_outer

	rts
.)



_VScroll_DisplayScroller
.(
	lda _AngleVal0
	sta reg0+0			; Angle 2
	clc
	adc _AngleInc0
	sta _AngleVal0

	lda _AngleVal1
	tax
	clc
	adc _AngleInc1
	sta _AngleVal1
	lda _CosTable,x
	sta reg0+1			; Base sine 


	lda #<_RotateTableLeft
	sta tmp0+0
	lda #<_RotateTableRight
	sta tmp1+0


	; We starts at 32 in order to avoid having to check
	; if X reaches 224 (28*8). By starting at 32 we 
	; just have to check if it wraps around 0
	ldx #32
loop_y
	ldy reg0+0			; Angle 2
	inc	reg0+0
	lda _CosTable,y
	clc
	adc reg0+1			; Base sine
	sta reg0+2			; sine

	tay
	lda _ShiftTableBit,y
	pha

	clc
	adc #>_RotateTableLeft
	sta tmp0+1

	clc
	pla
	adc #>_RotateTableRight
	sta tmp1+1

	lda _ScrollBuffer-32+256*0+2,x
	sta _ScrollBuffer-32+256*0,x
	sta tmp2+0
	lda _ScrollBuffer-32+256*1+2,x
	sta _ScrollBuffer-32+256*1,x
	sta tmp2+1
	lda _ScrollBuffer-32+256*2+2,x
	sta _ScrollBuffer-32+256*2,x
	sta tmp2+2

	tay
	lda (tmp0),y
	ldy tmp2+0
	ora (tmp1),y
	pha

	ldy tmp2+1
	lda (tmp0),y
	ldy tmp2+2
	ora (tmp1),y
	pha
	
	ldy tmp2+0
	lda (tmp0),y
	ldy tmp2+1
	ora (tmp1),y
	pha


	ldy reg0+2			; sine
	lda _ShiftTableByte,y
	tay
	beq pos_0
	dey
	beq pos_1

pos_2
	pla
	sta BASECHARSET+28*8*1,x
	pla
	sta BASECHARSET+28*8*2,x
	pla
	sta BASECHARSET+28*8*0,x

	inx
	bne loop_y
	beq quit

pos_1
	pla
	sta BASECHARSET+28*8*2,x
	pla
	sta BASECHARSET+28*8*0,x
	pla
	sta BASECHARSET+28*8*1,x

	inx
	bne loop_y
	beq quit

pos_0
	pla
	sta BASECHARSET+28*8*0,x
	pla
	sta BASECHARSET+28*8*1,x
	pla					 
	sta BASECHARSET+28*8*2,x

end

	inx
	beq quit
	jmp loop_y
	;bne loop_y
quit
.)


;// Each letter is 28*3=84 bytes
.(
	;// Handle new character
	dec CharCounter
	bne continue_letter

new_letter
	lda _ScrollerPtr+0
	sta tmp0+0
	lda _ScrollerPtr+1
	sta tmp0+1
	ldy #0
	lda (tmp0),y
	bne not_end

	//
	// Wrap the scroller and tell us it's finished
	// 
	lda #1
	sta _SystemEffectTrigger

	lda #<_ScrollerMessage
	sta _ScrollerPtr+0

	lda #>_ScrollerMessage
	sta _ScrollerPtr+1
	jmp new_letter

not_end
	tay
	ldx _ScrollMapping,y

.(
	inc _ScrollerPtr+0
	bne skip
	inc _ScrollerPtr+1
skip
.)

	lda _FontAddrLow,x
	sta PtrLetterLow
	lda _FontAddrHigh,x
	sta PtrLetterHigh

	lda #14
	sta CharCounter
							  
continue_letter

	lda PtrLetterLow
	sta tmp0+0
	lda PtrLetterHigh
	sta tmp0+1

	ldy #0
	lda (tmp0),y
	sta _ScrollBuffer+256*0+28*8
	iny
	lda (tmp0),y
	sta _ScrollBuffer+256*1+28*8
	iny
	lda (tmp0),y				  
	sta _ScrollBuffer+256*2+28*8
	iny
	lda (tmp0),y
	sta _ScrollBuffer+256*0+28*8+1
	iny
	lda (tmp0),y
	sta _ScrollBuffer+256*1+28*8+1
	iny
	lda (tmp0),y
	sta _ScrollBuffer+256*2+28*8+1

.(
	clc
	lda PtrLetterLow
	adc #3*2
	sta PtrLetterLow
	bcc skip
	inc PtrLetterHigh
skip
.)

	rts
.)




_VScroll_ClearScrollerBuffer
.(
	ldx #28*8
	lda #0
loop
	sta _ScrollBuffer+256*0-1,x
	sta _ScrollBuffer+256*1-1,x
	sta _ScrollBuffer+256*2-1,x
	dex
	bne loop
	
	rts
.)




_VScroll_DrawClearCharMap
.(
	lda #64
	ldx #0
loop
	sta $b400+256*0,x
	sta $b400+256*1,x
	sta $b400+256*2,x
	sta $b400+256*3,x
	dex
	bne loop
	rts
.)




_VScroll_GenerateScrollMapping
.(
	ldx #0
	lda #0
clear_loop
	sta _ScrollMapping,x
	bne clear_loop

breakpoint
	;jmp breakpoint

.(
	ldx #0
init_loop
	ldy _ScrollerMappingTable,x
	beq end
	txa
	sta _ScrollMapping,y
	inx
	jmp init_loop
end
.)

.(
	lda #<_LabelPicture_Font
	sta tmp0+0
	lda #>_LabelPicture_Font
	sta tmp0+1
	ldx #0
loop
	lda tmp0+0
	sta _FontAddrLow,x
	lda tmp0+1
	sta _FontAddrHigh,x

	clc
	lda tmp0+0
	adc #28*3
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip

	inx
	bne loop
.)

	rts
.)


_VScroll_GenerateShifts
.(
	ldx #0
	ldy #0
	stx tmp1
loop
	tya
	sta _ShiftTableBit,x

	lda tmp1
	sta _ShiftTableByte,x

	iny
	cpy #6
	bne skip
	ldy #0
	inc tmp1
	lda tmp1
	cmp #3
	bne skip
	sty tmp1
skip

	inx
	bne loop

	rts
.)




_VScroll_GenerateRolls
.(
	lda #<_RotateTableLeft
	sta tmp0+0
	lda #>_RotateTableLeft
	sta tmp0+1

	lda #<_RotateTableRight
	sta tmp1+0
	lda #>_RotateTableRight
	sta tmp1+1

	ldx #0
loop_shift	
	stx tmp2

	ldy #0
loop_value
	;// Shift left part
	;// value_left=(((value&63)<<shift)&63)|64;
	tya
	and #63
	ldx tmp2
.(
	beq skip_shift
shift_loop
	asl
	dex
	bne shift_loop
skip_shift
.)
	ora #64
	sta (tmp0),y


	;// Shift right part
	;// value_right=( ( ((value&63)<<(shift+2))>>8)  &63)|64;
	lda #0
	sta tmp3
	tya
	and #63
	ldx tmp2
	inx
	inx
.(
shift_loop
	asl
	rol tmp3

	dex
	bne shift_loop
.)
	lda tmp3
	ora #64
	sta (tmp1),y

	iny
	bne loop_value

	inc tmp0+1
	inc tmp1+1

	ldx tmp2
	inx
	cpx #6
	bne loop_shift
	rts
.)



_VScroll_Initialize
	jsr _VScroll_UnpackPicture
	jsr _VScroll_InitMode_HiresPart
	jsr _VScroll_WriteScrollChars
	jsr _VScroll_WriteMessage
	jsr _VScroll_InitialiseCostable
	jsr _VScroll_ClearBigBuffer
	jsr _VScroll_GenerateRolls
	jsr _VScroll_GenerateShifts
	jsr _VScroll_GenerateScrollMapping
	jsr _VScroll_ClearScrollerBuffer
	rts



_VScroll_InitialiseCostable
.(
	ldx #0
loop
	lda _BaseCosTable,x
	lsr
	lsr
	lsr
	lsr
	sta _CosTable,x
	dex
	bne loop
	rts
.)	



_VScroll_TableMessagePos
	.byt 0,1,40,41

_VScroll_WriteMessage
.(
	.(
	//
	// Write LCP message
	//
	lda #128|32+28*3+0
	ldx #0
loop
	ldy _VScroll_TableMessagePos,x

	// L
	sta $bb80+40*3+5,y
	sta $bb80+40*5+5,y
	sta $bb80+40*7+5,y
	sta $bb80+40*7+7,y

	// C
	sta $bb80+40*9+11,y
	sta $bb80+40*9+13,y
	sta $bb80+40*11+11,y
	sta $bb80+40*13+11,y
	sta $bb80+40*15+11,y
	sta $bb80+40*15+13,y

	// P
	sta $bb80+40*17+17,y
	sta $bb80+40*17+19,y
	sta $bb80+40*17+21,y
	sta $bb80+40*19+17,y
	sta $bb80+40*19+21,y
	sta $bb80+40*21+17,y
	sta $bb80+40*21+19,y
	sta $bb80+40*21+21,y
	sta $bb80+40*23+17,y
	sta $bb80+40*25+17,y

	//clc
	//adc #1
	inx
	cpx #4
	bne loop
	.)


	.(
	//
	// Redefine a character for the LCP message
	//
	
	ldx #8 //*4
loop
	lda _CharacterRedefOne-1,x
	sta $b400+(32+28*3)*8-1,x
	dex
	bne loop
	
	/*
	lda #%101010
	sta $b400+(32+28*3)*8+0
	sta $b400+(32+28*3)*8+2
	sta $b400+(32+28*3)*8+4
	sta $b400+(32+28*3)*8+6
	lda #%010101
	sta $b400+(32+28*3)*8+1
	sta $b400+(32+28*3)*8+3
	sta $b400+(32+28*3)*8+5
	sta $b400+(32+28*3)*8+7
	*/
	.)
	
	rts
.)




_VScroll_UnpackPicture
.(
	lda #<_BigBuffer
	sta tmp1
	lda #>_BigBuffer
	sta tmp1+1

	// Source adress
	lda #<_LabelPicture
	sta tmp0
	lda #>_LabelPicture
	sta tmp0+1

	jsr _System_DataUnpack
	rts
.)



_VScroll_WriteScrollChars
.(
	lda #<$bb80
	sta tmp0+0
	lda #>$bb80
	sta tmp0+1

	ldx #0
loop_y
	clc
	txa
	adc #32
	ldy #2
loop_x
	sta (tmp0),y
	.(
	clc
	adc #28
	cmp #32+28*3
	bcc skip
	clc
	txa
	adc #32
skip
	.)

	iny
	cpy #VSCROLL_SPLIT_POSITION-1
	bne loop_x

	.(
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	inx
	cpx #28
	bne loop_y

	rts
.)


_VScroll_InitMode_HiresPart
.(
	.(
	// 
	// Set the video mode for the hires part of the screen
	// 128 lines of PURES HIRES bitmap, can include color changes
	//
	lda #<_BigBuffer-VSCROLL_SPLIT_POSITION
	sta tmp0+0
	lda #>_BigBuffer-VSCROLL_SPLIT_POSITION
	sta tmp0+1

	lda #<$a000
	sta tmp1+0
	lda #>$a000
	sta tmp1+1

	ldx #128+1
loop_y
	// Switch to TEXT 50hz
	ldy #0
	lda #26
	sta (tmp1),y

	iny
loop_x
	lda (tmp0),y
	ora #128
	sta (tmp1),y

	iny 
	cpy #40
	bne loop_x

	.(
	clc
	lda tmp0+0
	adc #VSCROLL_PICTURE_WIDTH
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	.(
	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip
	.)

	dex
	bne loop_y
	.)

	.(
	//
	// Set the video mode for the 16 first lines of TEXT/128 lines of HIRES
	//
	lda #<$bb80
	sta tmp1+0
	lda #>$bb80
	sta tmp1+1

	ldx #15+1
loop_y
	// PAPER change
	ldy #1
	lda #16+4+128
	sta (tmp1),y

	// Switch to TEXT 50hz
	ldy #VSCROLL_SPLIT_POSITION-1
	lda #30|128
	sta (tmp1),y

	.(
	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip
	.)

	dex
	bne loop_y
	.)


	.(
	//
	// Generate the charset for the middle part of the picture
	//
	lda #<_BigBuffer+VSCROLL_PICTURE_WIDTH*16*8
	sta tmp0+0
	lda #>_BigBuffer+VSCROLL_PICTURE_WIDTH*16*8
	sta tmp0+1

	lda #<$bb80+16*40
	sta tmp1+0
	lda #>$bb80+16*40
	sta tmp1+1

	// ptr_charset=((unsigned char*)0xb800)+car*8;
	lda #<$b800+8*32
	sta tmp3+0
	lda #>$b800+8*32
	sta tmp3+1

	lda #32
	sta tmp2+0	// current char
	
	ldx #8
	stx tmp4+0
loop_y
	// STD Text change
	ldy #0
	lda #8
	sta (tmp1),y

	// PAPER change
	ldy #1
	lda #16+4+128
	sta (tmp1),y

	// ALT Text
	ldy #VSCROLL_SPLIT_POSITION-1
	lda #9|128
	sta (tmp1),y

	ldx #VSCROLL_SPLIT_POSITION
	stx tmp4+1
loop_x
	
	.(
	lda #0
	sta tmp2+1
	ldy #VSCROLL_PICTURE_WIDTH*7
	ldx #8
loop_check_block
	lda (tmp0),y
	pha
	cmp #64
	beq skip
	// We found a non zero bloc
	lda #1
	sta tmp2+1
skip

	tya
	sec
	sbc #VSCROLL_PICTURE_WIDTH
	tay

	dex
	bne loop_check_block
	.)

	//
	// If it was an empty block, just copy a "space" instead
	//
	lda tmp2+1
	bne use_a_char

use_a_space
	ldy tmp4+1
	//lda #32+128
	lda #16+4+128
	sta (tmp1),y
	pla
	pla
	pla
	pla
	pla
	pla
	pla
	pla
	jmp end

use_a_char
	lda tmp2+0
	cmp #112
	bcs use_a_space

	ldy tmp4+1
	lda tmp2+0
	ora #128
	sta (tmp1),y
	inc tmp2+0

	ldy #0
loop_copy_char
	pla
	//eor #1
	sta (tmp3),y
	iny
	cpy #8
	bne loop_copy_char

	// ptr_charset+=8
	.(
	clc
	lda tmp3+0
	adc #8
	sta tmp3+0
	bcc skip
	inc tmp3+1
skip
	.)

end
	.(
	inc tmp0+0
	bne skip
	inc tmp0+1
skip
	.)

	inc tmp4+1
	ldx tmp4+1
	cpx #40
	bne loop_x

	.(
	clc
	lda tmp0+0
	adc #VSCROLL_PICTURE_WIDTH*7
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	.(
	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip
	.)

	dec tmp4+0
	beq end_of_display
	jmp loop_y

end_of_display
	.)


	.(
	//
	// Generate the charset for the last line of the middle part of the picture
	//
	lda #<_BigBuffer+VSCROLL_PICTURE_WIDTH*24*8
	sta tmp0+0
	lda #>_BigBuffer+VSCROLL_PICTURE_WIDTH*24*8
	sta tmp0+1

	lda #<$bb80+24*40
	sta tmp1+0
	lda #>$bb80+24*40
	sta tmp1+1

	// ptr_charset=((unsigned char*)0xb800)+car*8;
	lda #<$b400+8*(32+28*3+1)
	sta tmp3+0
	lda #>$b400+8*(32+28*3+1)
	sta tmp3+1

	lda #32+28*3+1
	sta tmp2+0	// current char
	
	//sei
	//jmp loop_y
	// STD Text change
	ldy #0
	lda #8
	sta (tmp1),y

	// PAPER change
	ldy #1
	lda #16+4+128
	sta (tmp1),y

	// Dummy pad
	ldy #VSCROLL_SPLIT_POSITION-1
	lda #16+4+128
	sta (tmp1),y

	ldx #VSCROLL_SPLIT_POSITION
	stx tmp4+1
loop_x
	
	.(
	lda #0
	sta tmp2+1
	ldy #VSCROLL_PICTURE_WIDTH*7
	ldx #8
loop_check_block
	lda (tmp0),y
	pha
	cmp #64
	beq skip
	// We found a non zero bloc
	lda #1
	sta tmp2+1
skip

	tya
	sec
	sbc #VSCROLL_PICTURE_WIDTH
	tay

	dex
	bne loop_check_block
	.)

	//
	// If it was an empty block, just copy a "space" instead
	//
	lda tmp2+1
	bne use_a_char

use_a_space
	ldy tmp4+1
	//lda #32+28*3+128
	lda #16+4+128
	sta (tmp1),y
	pla
	pla
	pla
	pla
	pla
	pla
	pla
	pla
	jmp end

use_a_char
	lda tmp2+0
	cmp #112
	//bcs use_a_space

	ldy tmp4+1
	lda tmp2+0
	ora #128
	sta (tmp1),y
	inc tmp2+0

	ldy #0
loop_copy_char
	pla
	//eor #1
	sta (tmp3),y
	iny
	cpy #8
	bne loop_copy_char

	// ptr_charset+=8
	.(
	clc
	lda tmp3+0
	adc #8
	sta tmp3+0
	bcc skip
	inc tmp3+1
skip
	.)

end
	.(
	inc tmp0+0
	bne skip
	inc tmp0+1
skip
	.)

	inc tmp4+1
	ldx tmp4+1
	cpx #40
	bne loop_x

end_of_display
	.)



	.(
	//
	// Generate the charset for the bottom part of the picture
	//
	lda #<_BigBuffer+VSCROLL_PICTURE_WIDTH*25*8
	sta tmp0+0
	lda #>_BigBuffer+VSCROLL_PICTURE_WIDTH*25*8
	sta tmp0+1

	lda #<$bb80+25*40
	sta tmp1+0
	lda #>$bb80+25*40
	sta tmp1+1

	// ptr_charset=((unsigned char*)0xb800)+car*8;
	lda #<$9800+8*33
	sta tmp3+0
	lda #>$9800+8*33
	sta tmp3+1

	lda #33
	sta tmp2+0	// current char
	
	ldx #3
	stx tmp4+0

loop_y
	// Switch to TEXT 50hz
	ldy #0
	lda #26
	sta (tmp1),y

	// PAPER change
	ldy #1
	lda #16+4+128
	sta (tmp1),y

	// Switch to HIRES 50hz
	ldy #VSCROLL_SPLIT_POSITION-1
	lda #30|128
	sta (tmp1),y

	ldx #VSCROLL_SPLIT_POSITION
	stx tmp4+1
loop_x
	
	.(
	ldy #VSCROLL_PICTURE_WIDTH*7
	ldx #8
loop_check_block
	lda (tmp0),y
	pha

	tya
	sec
	sbc #VSCROLL_PICTURE_WIDTH
	tay

	dex
	bne loop_check_block
	.)

	ldy tmp4+1
	lda tmp2+0
	ora #128
	sta (tmp1),y
	inc tmp2+0

	ldy #0
loop_copy_char
	pla
	sta (tmp3),y
	iny
	cpy #8
	bne loop_copy_char

	// ptr_charset+=8
	.(
	clc
	lda tmp3+0
	adc #8
	sta tmp3+0
	bcc skip
	inc tmp3+1
skip
	.)

end
	.(
	inc tmp0+0
	bne skip
	inc tmp0+1
skip
	.)

	inc tmp4+1
	ldx tmp4+1
	cpx #40
	bne loop_x

	.(
	clc
	lda tmp0+0
	adc #VSCROLL_PICTURE_WIDTH*7
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	.(
	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip
	.)

	dec tmp4+0
	beq end_of_display
	jmp loop_y

end_of_display
	.)

	rts
.)



_VScroll_MainLoop
.(
	// Then do some animation :)

	lda #0
	sta _SystemEffectTrigger
loop
	jsr _VScroll_DisplayScroller
	jsr _VSync

	//jmp loop

	lda _SystemEffectTrigger
	beq loop

	rts
.)


/*
xx	.byt 0	
yy	.byt 0

temp	.byt 0,0
addr	.byt 0,0

_DrawPixel
	ldy yy
	lda TableLow,y
	sta tmp0+0
	lda TableHigh,y
	sta tmp0+1
	ldx xx
	lda #$ff
	sta (tmp0),y
	rts



TableLow	.dsb 25
TableHigh	.dsb 25

temp		.dsb 2

#define base_adress $800

_ComputeTable
	lda #<base_adress
	sta temp+0
	lda #>base_adress
	sta temp+1

	ldy #0
loop
	clc
	lda temp+0
	sta TableLow,y
	adc #40
	sta temp+0
	lda temp+1
	sta TableHigh,y
	adc #0
	sta temp+1

	iny
	cpy #25
	bne loop
	rts
*/





	



