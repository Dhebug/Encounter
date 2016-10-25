

#define TOOL_HAND_DRAW			0
#define TOOL_LINE				1
#define TOOL_RECTANGLE			2
#define TOOL_RECTANGLE_FILLED	3
#define TOOL_ELLIPSE			4
#define TOOL_ELLIPSE_FILLED		5
#define TOOL_FLOOD_FILL			5



_MemorizedByte			.byt 64
_PtrCurrentByte			.byt 0,0


_FlagRedrawPicture		.byt 0
_FlagRedrawZoomer		.byt 0
_FlagRedrawInverse		.byt 0
_FlagRedrawInfos		.byt 0

_FlagDisplayZoomer		.byt 1

_FlagProtectedAttribute	.byt 0		; 0=kill attributes 1=always keep attributes

; 0=hand draw
; 1=lines
; 2=rectangles
; 3=rectangles (filled)
; 4=ellipses
; 5=ellipses (filled)
; 6=flood fill
_CurrentTool			.byt 1		


_HiresAddrLow			.dsb 201
_HiresAddrHigh			.dsb 201
						
_TableBit6Reverse		.byt 32,16,8,4,2,1
_TableBit6				.byt 1,2,4,8,16,32
_TableMul6				.dsb 256
_TableDiv6				.dsb 256
_TableMod6				.dsb 256
						
_HiresSizePos			.byt 0
_HiresSizeView			.byt 0
						
_PixelDrawMode			.byt 0		; 0=write 1=erase 2=reverse [WER] keys
_FlagPixelMode			.byt 1		; 0=byte 1=pixel 

;_CurrentPixelX			.byt 120	; Coordinate X of edited pixel/byte
;_CurrentPixelY			.byt 100	; Coordinate Y of edited pixel/byte
;_OtherPixelX			.byt 120	; Coordinate X of other edited pixel/byte (lines/box)
;_OtherPixelY			.byt 100	; Coordinate Y of other edited pixel/byte

_CurrentPixelX			.byt 0	; Coordinate X of edited pixel/byte
_CurrentPixelY			.byt 0	; Coordinate Y of edited pixel/byte
_OtherPixelX			.byt 120	; Coordinate X of other edited pixel/byte (lines/box)
_OtherPixelY			.byt 100	; Coordinate Y of other edited pixel/byte

_ToolWidth				.byt 123	; Width (ABS(_OtherPixelX-_CurrentPixelX))
_ToolHeight				.byt 098	; Height (ABS(_OtherPixelY-_CurrentPixelY))


_CurrentZoomPixelBit	.byt 0		; Bit number in the zoomed window
_CurrentZoomPixelX		.byt 1		; X Position of zoomed window pixel         
_CurrentZoomPixelY		.byt 2		; Y Position of zoomed window pixel 

_CurrentZoomX			.byt 0		; X Position of zoomed window         
_CurrentZoomY			.byt 0		; Y Position of zoomed window         
_CurrentLineCount		.byt 6		; Number of lines in the zoomed window
						
_CurrentDisplayCode		.byt 0		; 0=colored pixels 1=display codes 
						
						
current_ink				.byt 0
current_paper			.byt 0
						
bloc_attribmask			.dsb 6		; 0=??? 1=ink 2=paper 3=pixels
bloc_invertmask			.dsb 6		; 0/128 - 
bloc_byte				.dsb 6		; byte value
bloc_ink				.dsb 6		; current ink color
bloc_paper				.dsb 6		; current paper color
bloc_pixels				.dsb 6		; masked pixels
						
scan_counter			.byt 0




_GenerateTables
.(

	; Generate screen offset data
.(
	lda #$00
	sta tmp0+0
	lda #$00
	sta tmp0+1

	ldx #0
loop
	; generate two bytes screen adress
	clc
	lda tmp0+0
	sta _HiresAddrLow,x
	adc #40
	sta tmp0+0
	lda tmp0+1
	sta _HiresAddrHigh,x
	adc #0
	sta tmp0+1

	inx
	cpx #201
	bne loop
.)


	; Generate multiple of 6 data table
.(
	lda #0
	sta tmp0+0	; cur mul
	sta tmp0+1	; cur div
	sta tmp0+2	; cur mod

	ldx #0
loop
	lda tmp0+0
	clc
	sta _TableMul6,x
	adc #6
	sta tmp0+0

	lda tmp0+1
	sta _TableDiv6,x

	lda tmp0+2
	sta _TableMod6,x

	ldy tmp0+2
	iny
	cpy #6
	bne skip_mod
	ldy #0
	inc tmp0+1
skip_mod
	sty tmp0+2

	inx
	bne loop
.)

.)
	rts



_DisplaySeparationLines
.(
	ldx	_HiresSizeView
	lda _HiresAddrLow,x
	sta loop+1

	clc
	lda _HiresAddrHigh,x
	adc #$a0
	sta loop+2

	lda #16+7
	ldx #0
loop
	sta $1234,x
	sta $a000+199*40,x
	
	inx
	cpx #40
	bne loop
.)
	rts



_DisplayPicture
.(
	clc
	ldx _HiresSizePos
	lda #<_BufferMain1
	adc _HiresAddrLow,x
	sta _src1+1
	lda #>_BufferMain1
	adc _HiresAddrHigh,x
	sta _src1+2

	lda #<$a000
	sta _dst1+1
	lda #>$a000
	sta _dst1+2

	; Starts by copying a multiple of 256 values
	ldx	_HiresSizeView
	lda _HiresAddrHigh,x
	tax
loop_bloc
	ldy #0
loop_line
_src1
	lda $1234,y
_dst1
	sta $1234,y
	dey
	bne loop_line
	inc _src1+2
	inc _dst1+2
	dex
	bne loop_bloc



	; Then finish by copying the last bytes
	lda _src1+1
	sta _src2+1
	lda _src1+2
	sta _src2+2

	lda _dst1+1
	sta _dst2+1
	lda _dst1+2
	sta _dst2+2

	ldx	_HiresSizeView
	ldy _HiresAddrLow,x
	beq quit
	dey
	beq quit
loop_line2
_src2
	lda $1234,y
_dst2
	sta $1234,y
	dey
	cpy #255
	bne loop_line2
quit
.)
	rts



	


_DisplayZoomer
	lda _CurrentDisplayCode
	beq bla2

bla1
	jsr _DisplayZoomer_Codes
	jsr _DisplaySelection
	rts

bla2
	jsr _DisplayZoomer_Colored
	jsr _DisplaySelection
	rts



_DisplaySelection
.(
	;
	; Compute the position of the bloc on screen
	;
	sec
	lda _CurrentLineCount
	sbc _CurrentZoomPixelY
	asl			; x2
	sta tmp0
	asl			; x4
	clc
	adc tmp0	; x4+x2=x6
	sta tmp0
	lda #199
	sec 
	sbc tmp0
	clc
	tax
	clc
	lda #<$a000
	adc _HiresAddrLow,x
	sta tmp0+0
	lda #>$a000
	adc _HiresAddrHigh,x
	sta tmp0+1

	clc
	lda tmp0+0
	adc #3
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip

	lda _FlagPixelMode
	beq DisplaySelectedByte

DisplaySelectedPixel
.(
	clc
	lda tmp0+0
	ldx _CurrentZoomPixelX
	adc _TableMul6,x 
	sta tmp0+0
	bcc skip2
	inc tmp0+1
skip2

	clc
	lda #40*0+0
	adc	_CurrentZoomPixelBit
	tay
	lda #16+1
	sta (tmp0),y

	tya
	clc
	adc #40
	tay
	lda #16+3
	sta (tmp0),y


	clc
	lda #40*4+0
	adc	_CurrentZoomPixelBit
	tay
	lda #16+5
	sta (tmp0),y

	tya
	clc
	adc #40
	tay
	lda #16+4
	sta (tmp0),y

	rts
.)

DisplaySelectedByte
.(
	clc
	lda tmp0+0
	ldx _CurrentZoomPixelX
	adc _TableMul6,x 
	sta tmp0+0
	bcc skip2
	inc tmp0+1
skip2

	ldy #40*0+0
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y

	ldy #40*1+0
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y

	ldy #40*4
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y

	ldy #40*5
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y
	iny
	lda (tmp0),y
	eor #128
	sta (tmp0),y

	rts
.)
.)


_DisplayZoomer_Colored
.(
	;
	; Compute the pointer on the top of the picture to be zoomed 
	;
	clc
	ldx _CurrentZoomY
	lda #<_BufferMain1
	adc _HiresAddrLow,x
	sta tmp0+0
	lda #>_BufferMain1
	adc _HiresAddrHigh,x
	sta tmp0+1

	;
	; Then the pointer on the screen
	;
	lda _CurrentLineCount
	asl			; x2
	sta tmp1
	asl			; x4
	clc
	adc tmp1	; x4+x2=x6
	sta tmp1
	lda #199
	sec 
	sbc tmp1
	tax
	clc
	lda #<$a000
	adc _HiresAddrLow,x
	sta tmp2+0
	lda #>$a000
	adc _HiresAddrHigh,x
	sta tmp2+1

	ldx _CurrentLineCount
	stx	scan_counter
loop_scanline
	;
	; Copy scanline adress
	;
	clc
	lda tmp2+0
	sta tmp1+0
	adc #40*6
	sta tmp2+0
	lda tmp2+1
	sta tmp1+1
	adc #0
	sta tmp2+1

	;
	; Initialize ink an paper colors
	;
	lda #7
	sta current_ink
	lda #0
	sta current_paper

	;
	; Scan the current line, in order to know what the current ink and paper value are 
	;
.(
	ldy #0
	ldx _CurrentZoomX
	beq skip_pre_scan

pre_scan_loop
	; Fetch a byte from picture
	lda (tmp0),y
	and #64
	bne end_attribute
	lda (tmp0),y
	and #63
	cmp #8
	bcc is_ink
	and #7
	cmp #8
	bcs end_attribute

is_paper
	sta current_paper
	jmp end_attribute

is_ink
	sta current_ink

end_attribute
	iny
	dex		
	bne pre_scan_loop

skip_pre_scan
.)

	;
	; Draw the paper / ink indicators on the left side
	;
	lda #16

	ldy #40*0+0
	sta (tmp1),y
	ldy #40*4+0
	sta (tmp1),y

	ldy #40*0+1
	sta (tmp1),y
	ldy #40*4+1
	sta (tmp1),y


	lda current_paper
	ora #16

	ldy #40*1+0
	sta (tmp1),y
	ldy #40*2+0
	sta (tmp1),y
	ldy #40*3+0
	sta (tmp1),y


	lda current_ink
	ora #16

	ldy #40*1+1
	sta (tmp1),y
	ldy #40*2+1
	sta (tmp1),y
	ldy #40*3+1
	sta (tmp1),y


	lda #16+7

	ldy #40*5+0
	sta (tmp1),y

	ldy #40*5+1
	sta (tmp1),y

	ldy #40*0+2
	sta (tmp1),y
	ldy #40*1+2
	sta (tmp1),y
	ldy #40*2+2
	sta (tmp1),y
	ldy #40*3+2
	sta (tmp1),y
	ldy #40*4+2
	sta (tmp1),y
	ldy #40*5+2
	sta (tmp1),y


	ldy #40*0+39
	sta (tmp1),y
	ldy #40*1+39
	sta (tmp1),y
	ldy #40*2+39
	sta (tmp1),y
	ldy #40*3+39
	sta (tmp1),y
	ldy #40*4+39
	sta (tmp1),y
	ldy #40*5+39
	sta (tmp1),y

	;
	; Decode the next 6 bytes, storing values in small tables
	;
.(
	ldy _CurrentZoomX
	ldx #0

scan_loop
	; Start by initialising bloc colors
	lda current_paper
	sta bloc_paper,x
	lda current_ink
	sta bloc_ink,x

	; Fetch a byte from picture
	lda (tmp0),y
	bmi is_inverted
is_not_inverted
	cmp #32
	bcs is_pixels
	cmp #8
	bcc is_ink
	and #7
	cmp #8
	bcs end_bloc

is_paper
	sta current_paper
	sta bloc_paper,x
	jmp end_attribute

is_ink
	sta current_ink
	sta bloc_ink,x
	jmp end_attribute

is_pixels
	and #63
	asl
	asl
	sta bloc_pixels,x
	jmp end_bloc


is_inverted
	and #127	; clear the video inverse flag
	cmp #32
	bcs is_inverted_pixels
	cmp #8
	bcc is_inverted_ink
	and #7
	cmp #8
	bcs end_bloc

is_inverted_paper
	sta current_paper
	eor #7
	sta bloc_paper,x
	jmp end_attribute

is_inverted_ink
	sta current_ink
	eor #7
	sta bloc_paper,x
	jmp end_attribute

is_inverted_pixels
	and #63
	asl
	asl
	sta bloc_pixels,x

	lda current_paper
	eor #7
	sta bloc_paper,x
	lda current_ink
	eor #7
	sta bloc_ink,x
	jmp end_bloc

end_attribute
	lda #0
	sta bloc_pixels,x

end_bloc

	iny
	inx		
	cpx #6
	beq end_scan_loop
	jmp scan_loop
end_scan_loop
.)


	;
	; And now, display the 6 pixels
	;
	;
	; Next scanline
	;
	clc
	lda tmp1+0
	adc #3
	sta tmp1+0
	bcc skip_inc_dst
	inc tmp1+1
skip_inc_dst


	;
	; Display colored pixels
	;
.(
	ldx #0
bloc_draw_loop

	; Bloc 0
	lda bloc_ink+0
	asl bloc_pixels+0
	bcs end_0
	lda bloc_paper+0
end_0
	ora #16

	ldy #40*0+6*0
	sta (tmp1),y
	ldy #40*1+6*0
	sta (tmp1),y
	ldy #40*2+6*0
	sta (tmp1),y
	ldy #40*3+6*0
	sta (tmp1),y
	ldy #40*4+6*0
	sta (tmp1),y
	ldy #40*5+6*0
	sta (tmp1),y

	; Bloc 1
	lda bloc_ink+1
	asl bloc_pixels+1
	bcs end_1
	lda bloc_paper+1
end_1
	ora #16

	ldy #40*0+6*1
	sta (tmp1),y
	ldy #40*1+6*1
	sta (tmp1),y
	ldy #40*2+6*1
	sta (tmp1),y
	ldy #40*3+6*1
	sta (tmp1),y
	ldy #40*4+6*1
	sta (tmp1),y
	ldy #40*5+6*1
	sta (tmp1),y

	; Bloc 2
	lda bloc_ink+2
	asl bloc_pixels+2
	bcs end_2
	lda bloc_paper+2
end_2
	ora #16

	ldy #40*0+6*2
	sta (tmp1),y
	ldy #40*1+6*2
	sta (tmp1),y
	ldy #40*2+6*2
	sta (tmp1),y
	ldy #40*3+6*2
	sta (tmp1),y
	ldy #40*4+6*2
	sta (tmp1),y
	ldy #40*5+6*2
	sta (tmp1),y

	; Bloc 3
	lda bloc_ink+3
	asl bloc_pixels+3
	bcs end_3
	lda bloc_paper+3
end_3
	ora #16

	ldy #40*0+6*3
	sta (tmp1),y
	ldy #40*1+6*3
	sta (tmp1),y
	ldy #40*2+6*3
	sta (tmp1),y
	ldy #40*3+6*3
	sta (tmp1),y
	ldy #40*4+6*3
	sta (tmp1),y
	ldy #40*5+6*3
	sta (tmp1),y

	; Bloc 4
	lda bloc_ink+4
	asl bloc_pixels+4
	bcs end_4
	lda bloc_paper+4
end_4
	ora #16

	ldy #40*0+6*4
	sta (tmp1),y
	ldy #40*1+6*4
	sta (tmp1),y
	ldy #40*2+6*4
	sta (tmp1),y
	ldy #40*3+6*4
	sta (tmp1),y
	ldy #40*4+6*4
	sta (tmp1),y
	ldy #40*5+6*4
	sta (tmp1),y

	; Bloc 5
	lda bloc_ink+5
	asl bloc_pixels+5
	bcs end_5
	lda bloc_paper+5
end_5
	ora #16

	ldy #40*0+6*5
	sta (tmp1),y
	ldy #40*1+6*5
	sta (tmp1),y
	ldy #40*2+6*5
	sta (tmp1),y
	ldy #40*3+6*5
	sta (tmp1),y
	ldy #40*4+6*5
	sta (tmp1),y
	ldy #40*5+6*5
	sta (tmp1),y

end_draw_bloc
	clc
	lda tmp1+0
	adc #1
	sta tmp1+0
	bcc skip_inc
	inc tmp1+1
skip_inc

	iny 
	inx
	cpx #6
	beq end_bloc_draw_loop
	jmp bloc_draw_loop
end_bloc_draw_loop
.)
end_draw_bloc


	;
	; Next scanline
	;
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip_inc_src
	inc tmp0+1
skip_inc_src

	dec scan_counter
	beq end_zoomer
	jmp loop_scanline

end_zoomer
	rts
.)










_DisplayZoomer_Codes
.(
	;
	; Compute the pointer on the top of the picture to be zoomed 
	;
	clc
	ldx _CurrentZoomY
	lda #<_BufferMain1
	adc _HiresAddrLow,x
	sta tmp0+0
	lda #>_BufferMain1
	adc _HiresAddrHigh,x
	sta tmp0+1

	;
	; Then the pointer on the screen
	;
	lda _CurrentLineCount
	asl			; x2
	sta tmp1
	asl			; x4
	clc
	adc tmp1	; x4+x2=x6
	sta tmp1
	lda #199
	sec 
	sbc tmp1
	tax
	clc
	lda #<$a000
	adc _HiresAddrLow,x
	sta tmp2+0
	lda #>$a000
	adc _HiresAddrHigh,x
	sta tmp2+1

	ldx _CurrentLineCount
	stx	scan_counter
loop_scanline
	;
	; Copy scanline adress
	;
	clc
	lda tmp2+0
	sta tmp1+0
	adc #40*6
	sta tmp2+0
	lda tmp2+1
	sta tmp1+1
	adc #0
	sta tmp2+1

	;
	; Initialize ink an paper colors
	;
	lda #7
	sta current_ink
	lda #0
	sta current_paper

	;
	; Scan the current line, in order to know what the current ink and paper value are 
	;
.(
	ldy #0
	ldx _CurrentZoomX
	beq skip_pre_scan

pre_scan_loop
	; Fetch a byte from picture
	lda (tmp0),y
	and #64
	bne end_attribute
	lda (tmp0),y
	and #63
	cmp #8
	bcc is_ink
	and #7
	cmp #8
	bcs end_attribute

is_paper
	sta current_paper
	jmp end_attribute

is_ink
	sta current_ink

end_attribute
	iny
	dex		
	bne pre_scan_loop

skip_pre_scan
.)

	;
	; Draw the paper / ink indicators on the left side
	;
	lda #16+7

	ldy #40*0+0
	sta (tmp1),y
	ldy #40*1+0
	sta (tmp1),y
	ldy #40*2+0
	sta (tmp1),y
	ldy #40*3+0
	sta (tmp1),y
	ldy #40*4+0
	sta (tmp1),y
	ldy #40*5+0
	sta (tmp1),y


	ldy #40*0+1
	sta (tmp1),y
	ldy #40*1+1
	sta (tmp1),y
	ldy #40*2+1
	sta (tmp1),y
	ldy #40*3+1
	sta (tmp1),y
	ldy #40*4+1
	sta (tmp1),y
	ldy #40*5+1
	sta (tmp1),y


	ldy #40*0+2
	sta (tmp1),y
	ldy #40*1+2
	sta (tmp1),y
	ldy #40*2+2
	sta (tmp1),y
	ldy #40*3+2
	sta (tmp1),y
	ldy #40*4+2
	sta (tmp1),y
	ldy #40*5+2
	sta (tmp1),y


	ldy #40*0+39
	sta (tmp1),y
	ldy #40*1+39
	sta (tmp1),y
	ldy #40*2+39
	sta (tmp1),y
	ldy #40*3+39
	sta (tmp1),y
	ldy #40*4+39
	sta (tmp1),y
	ldy #40*5+39
	sta (tmp1),y



	;
	; Decode the next 6 bytes, storing values in small tables
	;
.(
	ldy _CurrentZoomX
	ldx #0

scan_loop
	; Start by initialising bloc colors
	lda current_paper
	sta bloc_paper,x
	lda current_ink
	sta bloc_ink,x

	lda #0
	sta bloc_invertmask,x
	sta bloc_attribmask,x

	; Fetch a byte from picture
	lda (tmp0),y
	sta bloc_byte,x
	bpl skip_inversion

	; handle inversion here
	and #127	; clear the video inverse flag
	pha
	lda #128
	sta bloc_invertmask,x
	pla

skip_inversion
	cmp #32
	bcs is_pixels
	cmp #8
	bcc is_ink
	and #7
	cmp #8
	bcs end_bloc

is_paper
	sta current_paper
	sta bloc_paper,x

	lda #2
	sta bloc_attribmask,x

	jmp end_bloc

is_ink
	sta current_ink
	sta bloc_ink,x

	lda #1
	sta bloc_attribmask,x

	jmp end_bloc

is_pixels
	and #63
	asl
	asl
	sta bloc_pixels,x

	lda #3
	sta bloc_attribmask,x

end_bloc

	lda bloc_invertmask,x
	beq end_color_inversion
	lda current_paper
	eor #7
	sta bloc_paper,x
	lda current_ink
	eor #7
	sta bloc_ink,x
end_color_inversion

	iny
	inx		
	cpx #6
	beq end_scan_loop
	jmp scan_loop
end_scan_loop
.)


	;
	; And now, display the 6 pixels
	;
	;
	; Next scanline
	;
	clc
	lda tmp1+0
	adc #3
	sta tmp1+0
	bcc skip_inc_dst
	inc tmp1+1
skip_inc_dst


.(
	ldx #0
bloc_draw_loop

	; Precompute values
	lda bloc_byte,x
	lsr
	lsr
	lsr
	lsr
	tay
	lda _SmallHexaDigitsTableLow,y
	sta tmp3+0
	lda _SmallHexaDigitsTableHigh,y
	sta tmp3+1

	lda bloc_byte,x
	and #$0F
	tay
	lda _SmallHexaDigitsTableLow,y
	sta tmp4+0
	lda _SmallHexaDigitsTableHigh,y
	sta tmp4+1

	; Bloc 0 - Blue ink
	lda #128+4

	ldy #40*0+0
	sta (tmp1),y
	ldy #40*1+0
	sta (tmp1),y
	ldy #40*2+0
	sta (tmp1),y
	ldy #40*3+0
	sta (tmp1),y
	ldy #40*4+0
	sta (tmp1),y
	ldy #40*5+0
	sta (tmp1),y

	; Bloc 1 - First digit
	ldy #0
	lda (tmp3),y
	eor bloc_invertmask,x
	ldy #40*0+1
	sta (tmp1),y
	ldy #1
	lda (tmp3),y
	eor bloc_invertmask,x
	ldy #40*1+1
	sta (tmp1),y
	ldy #2
	lda (tmp3),y
	eor bloc_invertmask,x
	ldy #40*2+1
	sta (tmp1),y
	ldy #3
	lda (tmp3),y
	eor bloc_invertmask,x
	ldy #40*3+1
	sta (tmp1),y
	ldy #4
	lda (tmp3),y
	eor bloc_invertmask,x
	ldy #40*4+1
	sta (tmp1),y
	ldy #5
	lda (tmp3),y
	;eor bloc_invertmask,x
	ldy #40*5+1
	sta (tmp1),y

	; Bloc 2 - Second digit
	ldy #0
	lda (tmp4),y
	eor bloc_invertmask,x
	ldy #40*0+2
	sta (tmp1),y
	ldy #1
	lda (tmp4),y
	eor bloc_invertmask,x
	ldy #40*1+2
	sta (tmp1),y
	ldy #2
	lda (tmp4),y
	eor bloc_invertmask,x
	ldy #40*2+2
	sta (tmp1),y
	ldy #3
	lda (tmp4),y
	eor bloc_invertmask,x
	ldy #40*3+2
	sta (tmp1),y
	ldy #4
	lda (tmp4),y
	eor bloc_invertmask,x
	ldy #40*4+2
	sta (tmp1),y
	ldy #5
	lda (tmp4),y
	;eor bloc_invertmask,x
	ldy #40*5+2
	sta (tmp1),y



	lda bloc_attribmask,x
	bne attribute_value_unknown_end	; 0

attribute_value_unknown
	; Bloc 3 - Unknown attribute 
	lda #128+64

	ldy #40*0+3
	sta (tmp1),y
	ldy #40*1+3
	sta (tmp1),y
	ldy #40*2+3
	sta (tmp1),y
	ldy #40*3+3
	sta (tmp1),y
	ldy #40*4+3
	sta (tmp1),y
	ldy #40*5+3
	sta (tmp1),y

	; Bloc 4 - Unknown attribute 
	lda #16+7+128

	ldy #40*0+4
	sta (tmp1),y
	ldy #40*1+4
	sta (tmp1),y
	ldy #40*2+4
	sta (tmp1),y
	ldy #40*3+4
	sta (tmp1),y
	ldy #40*4+4
	sta (tmp1),y
	ldy #40*5+4
	sta (tmp1),y

	jmp end_bloc_4

attribute_value_unknown_end
	tay
	dey
	bne attribute_value_ink_end		; 1

attribute_value_ink
	; Bloc 3 
	lda #128+64

	ldy #40*0+3
	sta (tmp1),y
	ldy #40*1+3
	sta (tmp1),y
	ldy #40*2+3
	sta (tmp1),y
	ldy #40*3+3
	sta (tmp1),y
	ldy #40*4+3
	sta (tmp1),y
	ldy #40*5+3
	sta (tmp1),y

	; Bloc 4 - Attribute value
	lda #16+7+128

	ldy #40*0+4
	sta (tmp1),y
	ldy #40*5+4
	sta (tmp1),y

	lda bloc_byte,x
	and #7
	ora #16

	ldy #40*1+4
	sta (tmp1),y
	ldy #40*2+4
	sta (tmp1),y
	ldy #40*3+4
	sta (tmp1),y
	ldy #40*4+4
	sta (tmp1),y

	jmp end_bloc_4


attribute_value_ink_end
	dey
	bne attribute_value_paper_end	; 2

attribute_value_paper
	; Bloc 3 
	lda #16+7+128

	ldy #40*0+3
	sta (tmp1),y
	ldy #40*5+3
	sta (tmp1),y

	lda bloc_byte,x
	and #7
	ora #16

	ldy #40*1+3
	sta (tmp1),y
	ldy #40*2+3
	sta (tmp1),y
	ldy #40*3+3
	sta (tmp1),y
	ldy #40*4+3
	sta (tmp1),y

	; Bloc 4 - Attribute value
	lda #16+7+128		;28+64+%000011

	ldy #40*0+4
	sta (tmp1),y
	ldy #40*1+4
	sta (tmp1),y
	ldy #40*2+4
	sta (tmp1),y
	ldy #40*3+4
	sta (tmp1),y
	ldy #40*4+4
	sta (tmp1),y
	ldy #40*5+4
	sta (tmp1),y

	jmp end_bloc_4

attribute_value_paper_end


pixel_pattern
	; Bloc 3 - Pixel pattern
	lda #128+64

	ldy #40*0+3
	sta (tmp1),y
	ldy #40*1+3
	sta (tmp1),y
	ldy #40*2+3
	sta (tmp1),y
	ldy #40*3+3
	sta (tmp1),y
	ldy #40*4+3
	sta (tmp1),y
	ldy #40*5+3
	sta (tmp1),y

	; Bloc 4 - Pixel pattern
	lda #128+64

	ldy #40*1+4
	sta (tmp1),y
	ldy #40*2+4
	sta (tmp1),y
	ldy #40*3+4
	sta (tmp1),y
	ldy #40*4+4
	sta (tmp1),y
	ldy #40*5+4
	sta (tmp1),y

	lda bloc_pixels,x
	lsr 
	lsr 
	ora #128+64

	ldy #40*0+4
	sta (tmp1),y


end_bloc_4

	; Bloc 5 - Black Separator
	lda #16+7+128		;28+64+%000011

	ldy #40*0+5
	sta (tmp1),y
	ldy #40*1+5
	sta (tmp1),y
	ldy #40*2+5
	sta (tmp1),y
	ldy #40*3+5
	sta (tmp1),y
	ldy #40*4+5
	sta (tmp1),y
	ldy #40*5+5
	sta (tmp1),y


	clc
	lda tmp1+0
	adc #6
	sta tmp1+0
	bcc skip_inc
	inc tmp1+1
skip_inc

	iny 
	inx
	cpx #6
	beq end_bloc_draw_loop
	jmp bloc_draw_loop
end_bloc_draw_loop
.)


	;
	; Next scanline
	;
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip_inc_src
	inc tmp0+1
skip_inc_src

	dec scan_counter
	beq end_zoomer
	jmp loop_scanline

end_zoomer
.)
	rts




_PixelModeText			.byt "BYTE","PIXL"
_PixelDrawModeText		.byt "WRTE","ERSE","RVRS"
_ProtectedAttributeText	.byt "FREE","PROT"

_IconDataLine0			.byt 128+9,"ABCD",128+8
_IconDataLine1			.byt 128+9,"EFGH",128+8
_IconDataLine2			.byt 128+9,"IJKL",128+8


_MessageXYSimple	.byt 16+4,"000,000 ",128+16,0
_MessageXYDouble	.byt 16+4,"000:000 ",16+1,"000:000 ",16+4,"000x000 ",128+16,0


_TableNeedDoubleCursor
	.byt 0		; 0=hand draw          
	.byt 1		; 1=lines              
	.byt 1		; 2=rectangles         
	.byt 1		; 3=rectangles (filled)
	.byt 1		; 4=ellipses           
	.byt 1		; 5=ellipses (filled)  
	.byt 0		; 6=flood fill         


; (000,000)->(000,000)=(000x000)

; =========================================
; Display information in the 3 lines of text
; =========================================

; 0         1         2         3
; 0123456789012345678901234567890123456789
; ----------------------------------------
;                             !ABCD!xBYTE.
;                             !EFGH!xWRTE.
;                             !IJKL!xPROT.
; ----------------------------------------
_DisplayInformation
.(
	; Are we drawing in PIXEL or BYTE mode ?
.(
	lda _FlagRedrawInfos
	bne ok_display
	; Quit display
	rts

ok_display
	lda #0
	sta _FlagRedrawInfos

	lda #16+4
	sta $bb80+(40*25)+39-5

	ldx #0
	lda _FlagPixelMode
	beq byte_mode
	ldx #4
byte_mode
	lda _PixelModeText+0,x
	sta $bb80+(40*25)+39-4
	lda _PixelModeText+1,x
	sta $bb80+(40*25)+39-3
	lda _PixelModeText+2,x
	sta $bb80+(40*25)+39-2
	lda _PixelModeText+3,x
	sta $bb80+(40*25)+39-1
.)

	; Erase, Draw, Inverse, or do nothing ?
.(
	lda #16+1
	sta $bb80+(40*26)+39-5

	lda _PixelDrawMode
	asl
	asl
	tax
	lda _PixelDrawModeText+0,x
	sta $bb80+(40*26)+39-4
	lda _PixelDrawModeText+1,x
	sta $bb80+(40*26)+39-3
	lda _PixelDrawModeText+2,x
	sta $bb80+(40*26)+39-2
	lda _PixelDrawModeText+3,x
	sta $bb80+(40*26)+39-1
.)

	; Attributes are protected or not ???
.(
	lda #16+4
	sta $bb80+(40*27)+39-5

	lda _FlagProtectedAttribute
	asl
	asl
	tax
	lda _ProtectedAttributeText+0,x
	sta $bb80+(40*27)+39-4
	lda _ProtectedAttributeText+1,x
	sta $bb80+(40*27)+39-3
	lda _ProtectedAttributeText+2,x
	sta $bb80+(40*27)+39-2
	lda _ProtectedAttributeText+3,x
	sta $bb80+(40*27)+39-1
.)


	; Display the value of the currently 
	; selected byte, to paint in byte mode
	; 12345678
	; PIXL
	; INK
	; PAPR
.(
	ldy #0
	lda (tmp0),y			; Get the byte from picture
	bpl is_not_inverted
	and #127				; clear the video inverse flag
is_not_inverted
	cmp #32
	bcs operation_on_pixels

operation_on_attribute
operation_on_pixels


	;
	; Display an icon showing what is the current tool
	; One icon is made of 24x24 pixels => 4x24 bytes => 96 bytes;
	; To draw that icon, we switch to ALTERNATE charset, then draw 4 characters, then back to STD
	;
	; 0=hand draw
	; 1=lines
	; 2=rectangles
	; 3=rectangles (filled)
	; 4=ellipses
	; 5=ellipses (filled)
	; 6=flood fill
	ldx _CurrentTool
	lda _LargeIconsTableLow,x
	sta tmp0+0
	lda _LargeIconsTableHigh,x
	sta tmp0+1

.(
	; Reconfigurate the characters from A to L
	ldy #0
	ldx #0
loop_outer
	lda #8
	sta tmp1	; counter

loop
	lda (tmp0),y
	sta $9c00+65*8,x
	iny

	lda (tmp0),y
	sta $9c00+66*8,x
	iny

	lda (tmp0),y
	sta $9c00+67*8,x
	iny

	lda (tmp0),y
	sta $9c00+68*8,x
	iny

	inx
	dec tmp1
	bne loop

	cpy #96
	beq end

	clc
	txa
	adc #32-8
	tax

	jmp loop_outer

end
.)


.(
	;
	; Display the character matrix and attribute codes
	;
	ldx #0
loop
	lda _IconDataLine0,x
	sta $bb80+(40*25)+28,x

	lda _IconDataLine1,x
	sta $bb80+(40*26)+28,x

	lda _IconDataLine2,x
	sta $bb80+(40*27)+28,x
	
	inx
	cpx #6
	bne loop

.)

.)

.(
	;
	; Display the line with the coordinates
	;
	ldx _CurrentTool
	ldy _TableNeedDoubleCursor,x
	bne double_coordinates
	lda #<_MessageXYSimple
	sta tmp0+0
	lda #>_MessageXYSimple
	sta tmp0+1
	jmp end

double_coordinates
	lda #<_MessageXYDouble
	sta tmp0+0
	lda #>_MessageXYDouble
	sta tmp0+1
end
.)

.(
	ldy #0
loop
	lda (tmp0),y
	beq end
	sta $bb80+(40*25)+0,y
	iny
	jmp loop
end
.)	

	;
	; In the case we have double display
	; display the second set of coordinates
	;
	ldx _CurrentTool
	ldy _TableNeedDoubleCursor,x
	bne draw_second_cursor
	rts

draw_second_cursor
	; X cursor coordinate
	ldx _OtherPixelX
	lda _DecimalNumber100,x
	sta $bb80+(40*25)+10
	lda _DecimalNumber10,x
	sta $bb80+(40*25)+11
	lda _DecimalNumber1,x
	sta $bb80+(40*25)+12


	; Y cursor coordinate
	ldx _OtherPixelY
	lda _DecimalNumber100,x
	sta $bb80+(40*25)+14
	lda _DecimalNumber10,x
	sta $bb80+(40*25)+15
	lda _DecimalNumber1,x
	sta $bb80+(40*25)+16

	rts
.)




_DisplayCursorCoordinates
.(
	; X cursor coordinate
	ldx _CurrentPixelX
	lda _DecimalNumber100,x
	sta $bb80+(40*25)+1
	lda _DecimalNumber10,x
	sta $bb80+(40*25)+2
	lda _DecimalNumber1,x
	sta $bb80+(40*25)+3


	; Y cursor coordinate
	ldx _CurrentPixelY
	lda _DecimalNumber100,x
	sta $bb80+(40*25)+5
	lda _DecimalNumber10,x
	sta $bb80+(40*25)+6
	lda _DecimalNumber1,x
	sta $bb80+(40*25)+7
	

	ldx _CurrentTool
	ldy _TableNeedDoubleCursor,x
	bne draw_dimensions
	rts

draw_dimensions
	; Width
	ldx _ToolWidth
	lda _DecimalNumber100,x
	sta $bb80+(40*25)+19
	lda _DecimalNumber10,x
	sta $bb80+(40*25)+20
	lda _DecimalNumber1,x
	sta $bb80+(40*25)+21


	; Height
	ldx _ToolHeight
	lda _DecimalNumber100,x
	sta $bb80+(40*25)+23
	lda _DecimalNumber10,x
	sta $bb80+(40*25)+24
	lda _DecimalNumber1,x
	sta $bb80+(40*25)+25

	rts
.)





	;
	; Display an icon showing what is the current tool
	; One icon is made of 24x24 pixels => 4x24 bytes => 96 bytes;
	; To draw that icon, we switch to ALTERNATE charset, then draw 4 characters, then back to STD
	;
	; 0=hand draw
	; 1=lines
	; 2=rectangles
	; 3=rectangles (filled)
	; 4=ellipses
	; 5=ellipses (filled)
	; 6=flood fill

_DisplayToolMenu
.(
	;
	; Clear the text lines pour inform the user of the menu mode
	;
	jsr _ClearHiresTextScreenPart


	;
	; Clear the hires area where we will display our icons
	; Just to avoid brainless management
	; We have to clear 24 lines of 40 bytes...
	;
.(
	lda #64
	ldx #0
loop
	sta $a000+(199-27-3)*40+256*0,x
	sta $a000+(199-27-3)*40+256*1,x
	sta $a000+(199-27-3)*40+256*2,x
	sta $a000+(199-27-3)*40+256*3,x
	sta $a000+(199-27-3)*40+256*4,x
	dex
	bne loop
.)

	;
	; Draw some "cool" raster bars to enclose the icons.
	; That way we get a "futuristic" look.
	;
	lda #16
	sta $a000+(199)*40
	sta $a000+(199-27)*40

	lda #16+4
	sta $a000+(199-1)*40
	sta $a000+(199-27-1)*40

	lda #16+6
	sta $a000+(199-2)*40
	sta $a000+(199-27-2)*40

	lda #16+7
	sta $a000+(199-3)*40
	sta $a000+(199-27-3)*40

	;
	; Now, display the icon of each tool in the HIRES area of the screen
	;
.(
	ldx #0
	stx tmp1+0	; Tool counter
	stx tmp1+1	; Tool offset
next_tool
	;
	; Draw the icon picture
	; icon number (for keyboard selection)
	; and icon name also
	;
	ldx tmp1+0
	lda _DecimalNumber1+1,x
	cpx _CurrentTool
.(
	bne skip
	ora #128
skip
.)
	ldy tmp1+1
	sta $bb80+(40*25)+5+2,y

	lda _LargeIconsTableLow,x
	sta tmp0+0
	lda _LargeIconsTableHigh,x
	sta tmp0+1

	clc
	lda #<$a000+(199-27)*40+1+5
	adc tmp1+1
	sta dst+1
	lda #>$a000+(199-27)*40+1+5
	sta dst+2

	ldy #0
loop_y
	ldx #0
loop_x
	lda (tmp0),y
	iny
dst
	sta $a000,x
	inx 
	cpx #4
	bne loop_x

	clc
	lda dst+1
	adc #40
	sta dst+1
	bcc skip
	inc dst+2
skip
	cpy #96
	bne loop_y


	inc tmp1+0

	inc tmp1+1
	inc tmp1+1
	inc tmp1+1
	inc tmp1+1
	;inc tmp1+1

	ldx tmp1+0
	cpx #7

	bne next_tool
.)



	rts
.)


