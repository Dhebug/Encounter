

#define	MANDEL_ITER_BIS	19
#define MAX_MANDEL_ITER	512

//#define MANDEL_X_POS	64
//#define MANDEL_Y_POS	64

#define MANDEL_X_POS	32
#define MANDEL_Y_POS	92

#define MANDEL_WINDOWS_Y	30

	.zero

	//*= 128

screen_1	.dsb 2
screen_2	.dsb 2
screen_3	.dsb 2
screen_4	.dsb 2

big_buff	.dsb 2
x_buff		.dsb 1

accu_1		.dsb 1
accu_2		.dsb 1

_c			.dsb 2
_d			.dsb 2
_b			.dsb 2

_x1			.dsb 2
_y1			.dsb 2
_xn			.dsb 2
_yn			.dsb 2

_x			.dsb 1
_y			.dsb 1
_w			.dsb 1
_h			.dsb 1

_n			.dsb 1

_ref_pixel	.dsb 1

_axn		.dsb 2
_ayn		.dsb 2

_tempfastdiv	.dsb 1

greetings_pointer	.dsb 2

	.text


#define MANDEL_TEXT_OFFSET(size)	19-((size)*3-1)/2


_Mandel_GreetingList
	.byt MANDEL_TEXT_OFFSET(6) ,0,"ACTIVE",0
	.byt MANDEL_TEXT_OFFSET(5) ,0,"ANTIC",0
	.byt MANDEL_TEXT_OFFSET(7) ,0,"BLOCKOS",0
	.byt MANDEL_TEXT_OFFSET(12)+1,0,"BOOZE DESIGN",0
	.byt MANDEL_TEXT_OFFSET(7) ,0,"CAMELOT",0
	.byt MANDEL_TEXT_OFFSET(6) ,0,"COSINE",0
	.byt MANDEL_TEXT_OFFSET(4) ,0,"CNCD",0
	.byt MANDEL_TEXT_OFFSET(8) ,0,"CREATORS",0
	.byt MANDEL_TEXT_OFFSET(5) ,0,"CREST",0
	.byt MANDEL_TEXT_OFFSET(7) ,0,"DEFIERS",0
	.byt MANDEL_TEXT_OFFSET(9) ,0,"DEKADENCE",0
	.byt MANDEL_TEXT_OFFSET(5) ,0,"DEPTH",0
	.byt MANDEL_TEXT_OFFSET(3) ,0,"DHS",0
	.byt MANDEL_TEXT_OFFSET(9) ,0,"DUAL CREW",0
	.byt MANDEL_TEXT_OFFSET(9) ,0,"EPHIDRENA",0
	.byt MANDEL_TEXT_OFFSET(7) ,0,"EQUINOX",0
	.byt MANDEL_TEXT_OFFSET(6) ,0,"EXTEND",0
	.byt MANDEL_TEXT_OFFSET(9) ,0,"FAIRLIGHT",0
	.byt MANDEL_TEXT_OFFSET(10),0,"FARBRAUSCH",0
	.byt MANDEL_TEXT_OFFSET(9) ,0,"FLASH INC",0
	.byt MANDEL_TEXT_OFFSET(5) ,0,"FOCUS",0
	.byt MANDEL_TEXT_OFFSET(3) ,0,"G.P",0
	.byt MANDEL_TEXT_OFFSET(7) ,0,"HAUJOBB",0
	.byt MANDEL_TEXT_OFFSET(6) ,0,"HITMEN",0
	.byt MANDEL_TEXT_OFFSET(8) ,0,"INSTINCT",0
	.byt MANDEL_TEXT_OFFSET(3) ,0,"ISO",0
	.byt MANDEL_TEXT_OFFSET(7) ,0,"KEWLERS",0
	.byt MANDEL_TEXT_OFFSET(6) ,0,"LAXITY",0
	.byt MANDEL_TEXT_OFFSET(7) ,0,"M AND M",0
	.byt MANDEL_TEXT_OFFSET(3) ,0,"MFX",0
	.byt MANDEL_TEXT_OFFSET(9) ,0,"NECTARINE",0
	.byt MANDEL_TEXT_OFFSET(5) ,0,"NOICE",0
	.byt MANDEL_TEXT_OFFSET(6) ,0,"NONAME",0
	.byt MANDEL_TEXT_OFFSET(6) ,0,"ONEWAY",0
	.byt MANDEL_TEXT_OFFSET(9) ,0,"ONSLAUGHT",0
	.byt MANDEL_TEXT_OFFSET(6) ,0,"OXYRON",0
	.byt MANDEL_TEXT_OFFSET(5) ,0,"PADUA",0
	.byt MANDEL_TEXT_OFFSET(9) ,0,"PANORAMIC",0
	.byt MANDEL_TEXT_OFFSET(8) ,0,"PHANTASY",0
	.byt MANDEL_TEXT_OFFSET(5) ,0,"PLUSH",0
	.byt MANDEL_TEXT_OFFSET(10),0,"POPSY TEAM",0
	.byt MANDEL_TEXT_OFFSET(3) ,0,"PWP",0
	.byt MANDEL_TEXT_OFFSET(10),0,"SECTOR ONE",0
	.byt MANDEL_TEXT_OFFSET(7) ,0,"SCOOPEX",0
	.byt MANDEL_TEXT_OFFSET(5) ,0,"SHAPE",0
	.byt MANDEL_TEXT_OFFSET(10),0,"SPACEBALLS",0
	.byt MANDEL_TEXT_OFFSET(10),0,"RAZOR 1911",0
	.byt MANDEL_TEXT_OFFSET(11),0,"RETROCODERS",0
	.byt MANDEL_TEXT_OFFSET(10),0,"THE DREAMS",0
	.byt MANDEL_TEXT_OFFSET(5) ,0,"TRIAD",0
	.byt					2  ,0,"WRATHDESIGNS",0
	.byt MANDEL_TEXT_OFFSET(11),0,"WWW.C64.ORG",0
	.byt MANDEL_TEXT_OFFSET(12),0,"WWW.ORIC.ORG",0

	.byt 0

_Mandel_GreetingsRasters_Offset
	.byt 0

_Mandel_GreetingsRasters

_Mandel_GreetingsRasters_Blue
	.byt 0 // not visible
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 6
	.byt 4
	.byt 4
	.byt 4
	.byt 6
	.byt 6
	.byt 4
	.byt 4
	.byt 6
	.byt 6
	.byt 6
	.byt 4
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 7
	.byt 6
	.byt 6
	.byt 7
	.byt 6
	.byt 7
	.byt 7

_Mandel_GreetingsRasters_Red
	.byt 0 // not visible
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 3
	.byt 1
	.byt 1
	.byt 1
	.byt 3
	.byt 3
	.byt 1
	.byt 1
	.byt 3
	.byt 3
	.byt 3
	.byt 1
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 7
	.byt 3
	.byt 3
	.byt 7
	.byt 3
	.byt 7
	.byt 7

_Mandel_GreetingsRasters_Green
	.byt 0 // not visible
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 3
	.byt 2
	.byt 2
	.byt 2
	.byt 3
	.byt 3
	.byt 2
	.byt 2
	.byt 3
	.byt 3
	.byt 3
	.byt 2
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 7
	.byt 3
	.byt 3
	.byt 7
	.byt 3
	.byt 7
	.byt 7

_Mandel_GreetingsRasters_Buarkish
	.byt 0 // not visible
	.byt 1
	.byt 2
	.byt 5
	.byt 3
	.byt 7
	.byt 2
	.byt 4
	.byt 2
	.byt 1
	.byt 3
	.byt 2
	.byt 2
	.byt 7
	.byt 3
	.byt 3
	.byt 2
	.byt 3
	.byt 6
	.byt 6
	.byt 3
	.byt 5
	.byt 3
	.byt 4
	.byt 2
	.byt 3
	.byt 5
	.byt 7

#define MANDEL_NAME_AREA $a000+40*170

//	.byt "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?. ",0
// Each char is 3*28
// Maximum of 13 characters per line (13*3)=39
_Mandel_DisplayGreetings
//	sei
//	jmp _Mandel_DisplayGreetings
.(
	//
	// Read start offset, 0 means => End of things
	//
	ldy #0
	lda (greetings_pointer),y
	.(
	bne skip
	// End of greeting list
	rts
skip
	.)
	clc
	adc #<MANDEL_NAME_AREA
	sta tmp1+0
	lda #0
	adc #>MANDEL_NAME_AREA
	sta tmp1+1	
	
	.(
	inc greetings_pointer+0
	bne skip
	inc greetings_pointer+1
skip
	.)


	//
	// Read raster color
	//
	ldy #0
	lda (greetings_pointer),y
	sta _Mandel_GreetingsRasters_Offset
	
	.(
	inc greetings_pointer+0
	bne skip
	inc greetings_pointer+1
skip
	.)


	.(
	//
	// Cleanup the name area
	//
	lda #<MANDEL_NAME_AREA
	sta tmp0+0
	lda #>MANDEL_NAME_AREA
	sta tmp0+1

	ldx #28
loop_y
	ldy #2
	lda #64
loop_x
	sta (tmp0),y
	iny
	cpy #40
	bne loop_x

	//
	// Rasters
	//
	txa
	clc
	adc _Mandel_GreetingsRasters_Offset
	tay
	lda _Mandel_GreetingsRasters-1,y
	ldy #0
	sta (tmp0),y

	.(
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	dex
	bne loop_y
	.)


loop_character
	ldy #0
	lda (greetings_pointer),y
	.(
	inc greetings_pointer+0
	bne skip
	inc greetings_pointer+1
skip
	.)

	.(
	cmp #0
	bne skip
	jmp end
skip
	.)
	tax
	lda _ScrollMapping,x
	tax
	lda _FontAddrLow,x
	sta tmp0+0
	lda _FontAddrHigh,x
	sta tmp0+1

	ldx #28
loop
	ldy #0
	lda (tmp0),y
	sta (tmp1),y
	iny
	lda (tmp0),y
	sta (tmp1),y
	iny
	lda (tmp0),y
	sta (tmp1),y

	.(
	clc
	lda tmp0+0
	adc #3
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
	bne loop

	.(
	sec
	lda tmp1+0
	sbc #<40*28-3
	sta tmp1+0
	lda tmp1+1
	sbc #>40*28-3
	sta tmp1+1
	.)

	jmp loop_character

end
	
	rts
.)



_Mandle_ColorizeBigBuffer
.(
	lda #<_BigBuffer
	sta tmp0+0
	lda #>_BigBuffer
	sta tmp0+1

	ldx #33
	stx tmp1
loop_outer
	ldy #0
loop_inner
	lda (tmp0),y
	tax
	lda _RasterLine,x 
	sta (tmp0),y
	dey
	bne loop_inner
	inc tmp0+1
	dec tmp1
	bne loop_outer

	rts
.)




_Mandle_ClearBigBuffer
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


// _BigBuffer is equivalent to a 128x64 picture, that when zoomed in 2x2
// give us a 256x128 resolution, not bad !
// 
_Mandle_BlitBigBuffer
	//sei
.(
	pha
	txa
	pha
	tya
	pha

	lda #<$a000+(40*MANDEL_WINDOWS_Y)
	sta screen_1
	lda #>$a000+(40*MANDEL_WINDOWS_Y)
	sta screen_1+1

	lda #<$a000+(40*(MANDEL_WINDOWS_Y+1))
	sta screen_2
	lda #>$a000+(40*(MANDEL_WINDOWS_Y+1))
	sta screen_2+1



	lda #<_BigBuffer
	sta tmp0+0
	lda #>_BigBuffer
	sta tmp0+1

	lda #64
	sta tmp1
loop_y

	//jmp	loop_y


	//
	// First read a bloc of 114 bytes, and push them on stack 
	// (40-1)*3=117
	//
	ldy #0
loop_fill
	lda (tmp0),y
	pha
	iny
	cpy #117
	bne loop_fill

	//
	// Increment pointer on big buffer
	//
	.(
	clc
	lda tmp0
	adc #128
	sta tmp0
	bcc skip
	inc tmp0+1
skip
	.)

	//
	// Write colors
	//
	ldy #0
	lda #1
	sta (screen_1),y
	lda #16+4
	sta (screen_2),y
	iny

	//
	// And then remove pixels from stack
	//
loop_x
	pla
	tax
	asl
	asl
	asl
	asl
	and #%110000
	sta accu_1

	txa
	asl
	asl
	and #%110000
	sta accu_2


	pla
	tax
	asl
	asl
	and #%001100
	ora accu_1
	sta accu_1

	txa
	and #%001100
	ora accu_2
	sta accu_2


	pla
	tax
	and #%000011
	ora accu_1
	ora #64
	sta (screen_1),y

	txa
	lsr
	lsr
	and #%000011
	ora accu_2
	ora #64
	sta (screen_2),y

	iny

	cpy #40
	bne loop_x


	.(
	clc
	lda screen_1
	adc #80
	sta screen_1
	bcc skip_1
	inc screen_1+1
	clc
skip_1
	.)

	.(
	clc
	lda screen_2
	adc #80
	sta screen_2
	bcc skip_2
	inc screen_2+1
skip_2
	.)

	dec tmp1
	beq end
	jmp loop_y

end

	pla
	tay
	pla
	tax
	pla

	jsr _Mandel_DisplayGreetings
	rts
.)




_Mandel_InitDisplay
.(
	//
	// Prepare the tone mapping
	//
	jsr _VScroll_GenerateScrollMapping

	//
	// Initialise the pointer on greetings
	//
	lda #<_Mandel_GreetingList
	sta greetings_pointer+0
	lda #>_Mandel_GreetingList
	sta greetings_pointer+1

	//
	// Start by clearing the buffer to avoid surprises
	//
	jsr _Mandle_ClearBigBuffer

	//
	// Prepare the table of colors
	//
	ldy	#0
loop_screen_offset
src_1
	lda	#<_BigBuffer
	sta	_BufferAddrLow,y

src_2
	lda	#>_BigBuffer
	sta	_BufferAddrHigh,y

	clc
	lda	src_1+1
	adc	#128
	sta	src_1+1
	bcc skip
	inc	src_2+1
skip

	iny
	cpy #200
	bne	loop_screen_offset

	//
	// Draw some rasters, and the blue colors for mandelbrot
	//
	lda #16+1
	sta $a000+40*(MANDEL_WINDOWS_Y-2)
	sta $a000+40*(MANDEL_WINDOWS_Y+128+1)

	lda #16+3
	sta $a000+40*(MANDEL_WINDOWS_Y-3)
	sta $a000+40*(MANDEL_WINDOWS_Y+128+2)

	lda #16+7
	sta $a000+40*(MANDEL_WINDOWS_Y-4)
	sta $a000+40*(MANDEL_WINDOWS_Y+128+3)

	lda #16+3
	sta $a000+40*(MANDEL_WINDOWS_Y-5)
	sta $a000+40*(MANDEL_WINDOWS_Y+128+4)

	lda #16+1
	sta $a000+40*(MANDEL_WINDOWS_Y-6)
	sta $a000+40*(MANDEL_WINDOWS_Y+128+5)

	//
	// Blit the buffer to get the colors
	//
	jsr _Mandle_BlitBigBuffer

	rts
.)






//	y=200
//	do
//	{
//		y-=2
 //
//		ptr_buffer=ColorBuffer
 //
//		x=230
//		do
//		{
//			compute_outer()
 //
//			*ptr_buffer++=n
//		}
//		while (x)
 //
//		display_buffer()
//	}
//	while (y)

//xpos	.byt 0




_Mandel_ComputeParameters
	//jmp _Mandel_ComputeParameters
.(
	//
	// big_buff=_BigBuffer+(_y*128)
	//
	/*
	clc
	lda _y
	ror
	sta big_buff+1
	lda #0
	ror
	sta big_buff+0
	clc
	lda big_buff+0
	adc #<_BigBuffer
	sta big_buff+0
	lda big_buff+1
	adc #>_BigBuffer
	sta big_buff+1
	*/
	ldy _y
	lda _BufferAddrLow,y
	sta big_buff+0
	lda _BufferAddrHigh,y
	sta big_buff+1

	
	// X1=-64+(x*2)
	clc
	lda _x
	rol
	sta _x1+0
	lda #0
	rol
	sta _x1+1

	sec
	lda _x1+0
	sbc #<MANDEL_X_POS
	sta _x1+0
	lda _x1+1
	sbc #>MANDEL_X_POS
	sta _x1+1


	// y1=-64+(y*2)
	clc
	lda _y
	rol
	sta _y1+0
	lda #0
	rol
	sta _y1+1

	sec
	lda _y1+0
	sbc #<MANDEL_Y_POS
	sta _y1+0
	lda _y1+1
	sbc #>MANDEL_Y_POS
	sta _y1+1
	

	rts
.)


//
// Call with initialized values for:
// _x
// _y
// _w
//
// _x1
// _y1
//
_Mandel_HLine
.(
	jsr _Mandel_ComputeParameters

	lda _w
	pha

loop_x
	clc
	lda _x1+0
	sta _xn+0
	adc #2
	sta _x1+0
	lda _x1+1
	sta _xn+1
	adc #0
	sta _x1+1

	lda _y1+0
	sta _yn+0
	lda _y1+1
	sta _yn+1

	jsr _compute_outer

	// Store pixel in buffer
	lda _n
	ldy _x
	sta (big_buff),y
	inc _x

	dec	_w
	bne loop_x

	pla
	sta _w

	rts
.)



//
// Call with initialized values for:
// _x
// _y
// _h
//
// _x1
// _y1
//
_Mandel_VLine
.(
	jsr _Mandel_ComputeParameters

	lda _h
	pha

loop_y
	clc
	lda _y1+0
	sta _yn+0
	adc #2
	sta _y1+0
	lda _y1+1
	sta _yn+1
	adc #0
	sta _y1+1

	lda _x1+0
	sta _xn+0
	lda _x1+1
	sta _xn+1

	jsr _compute_outer

	// Store pixel in buffer
	lda _n
	ldy _x
	sta (big_buff),y

	clc
	lda big_buff+0
	adc #128
	sta big_buff+0
	bcc skip
	inc big_buff+1
skip

	dec	_h
	bne loop_y

	pla
	sta _h

	rts
.)





//
// Check if the value in the rect is homogeneous
//
_Mandel_CheckRect
.(
	/*
	clc
	lda _y
	ror
	sta big_buff+1
	lda #0
	ror
	sta big_buff+0
	clc
	lda big_buff+0
	adc #<_BigBuffer
	sta big_buff+0
	sta screen_1+0
	lda #>_BigBuffer
	adc big_buff+1
	sta big_buff+1
	sta screen_1+1
	*/

	ldy _y
	lda _BufferAddrLow,y
	sta big_buff+0
	sta screen_1+0
	lda _BufferAddrHigh,y
	sta big_buff+1
	sta screen_1+1


	// Read the comparison value
	ldy _x
	lda (big_buff),y
	sta _ref_pixel

	// Check the rectangle around
	clc
	lda _x
	adc _w
	sta x_buff

	.(
	// Top part
	ldy _x
	ldx _w
	inx
loop
	lda (big_buff),y
	cmp _ref_pixel
	bne found_different
	iny
	dex
	bne loop
	.)

	.(
	// Left and right part
	ldx _h
	inx
loop
	ldy _x
	lda (big_buff),y
	cmp _ref_pixel
	bne found_different
	ldy x_buff
	lda (big_buff),y
	cmp _ref_pixel
	bne found_different

	clc
	lda big_buff+0
	adc #128
	sta big_buff+0
	bcc skip
	inc big_buff+1
skip

	iny
	dex
	bne loop
	.)

	.(
	// Bottom part
	ldy _x
	ldx _w
	inx
loop
	lda (big_buff),y
	cmp _ref_pixel
	bne found_different
	iny
	dex
	bne loop
	.)

found_similar
	//
	// Fill the box with solid color
	//
	.(
	lda _h
	sta tmp0
loop_y

	ldx _w
	ldy _x
	lda _ref_pixel
loop_x
	sta (screen_1),y
	iny
	dex
	bne loop_x

	clc
	lda screen_1+0
	adc #128
	sta screen_1+0
	bcc skip
	inc screen_1+1
skip
	
	dec tmp0
	bne loop_y
	.)
	lda #0
	rts

found_different
	lda #1
	rts
.)



// (0,0)-(127,63)
_Mandel_Divide
	//jmp _Mandel_Divide
.(
	// VBL Check draw
	.(
	lda _VblCounter
	cmp #60
	bcc skip
	jsr _Mandle_BlitBigBuffer
	lda #0
	sta _VblCounter
skip
	.)

	//lda _w
	//beq quit
	//cmp #1
	//beq quit
	lda _h
	//beq quit
	cmp #1
	beq quit

	jsr _Mandel_CheckRect
	cmp #0
	bne recurse
quit
	rts

recurse

	.(
	lda _x
	pha
	lda _y
	pha
	lda _w
	pha
	lda _h
	pha


	// h_line
	lda _h
	lsr
	clc
	adc _y
	sta _y

	inc _x
	dec _w

	jsr _Mandel_HLine

	pla
	sta _h
	pla
	sta _w
	pla
	sta _y
	pla
	sta _x
	.)

	.(
	lda _x
	pha
	lda _y
	pha
	lda _w
	pha
	lda _h
	pha

	// v_line
	lda _w
	lsr
	clc
	adc _x
	sta _x

	inc _y
	dec _h

	jsr _Mandel_VLine

	pla
	sta _h
	pla
	sta _w
	pla
	sta _y
	pla
	sta _x
	.)

	//jsr _Mandle_BlitBigBuffer

	.(
	lda _w
	pha
	lda _h
	pha

	lsr _w
	lsr _h

	lda _h
	cmp #1
	beq skip_recurse


	// 0,0
	jsr _Mandel_Divide

	// 1,0
	lda _x
	pha
	clc
	adc _w
	sta _x
	jsr _Mandel_Divide
	pla
	sta _x

	// 0,1
	lda _y
	pha
	clc
	adc _h
	sta _y
	jsr _Mandel_Divide
	pla
	sta _y

	// 1,1
	lda _x
	pha
	clc
	adc _w
	sta _x
	lda _y
	pha
	clc
	adc _h
	sta _y
	jsr _Mandel_Divide
	pla
	sta _y
	pla
	sta _x

skip_recurse

	pla
	sta _h
	pla
	sta _w

	.)

	rts
.)


//
// Optimised recursive version of fractalus
//
_Mandel_DrawFractal
.(
    /*
	.(
	lda #0
	sta _y

loop
	lda #0
	sta _x

	lda #128
	sta _w

	jsr _Mandel_HLine
	jsr _Mandle_BlitBigBuffer

	inc _y
	ldy _y
	cpy #64
	bne loop
	rts
	.)
	*/
	
	/*
	.(
	lda #0
	sta _x
loop
	lda #0
	sta _y

	lda #64
	sta _h

	jsr _Mandel_VLine
	jsr _Mandle_BlitBigBuffer

	inc _x
	ldy _x
	cpy #128
	bne loop
	rts
	.)
	*/
	

	// h_line(0,0,largeur,XO,YO,PAS,buf,screen,pitch);
	lda #0
	sta _x

	lda #0
	sta _y

	lda #128
	sta _w

	jsr _Mandel_HLine


	// h_line(0+1,0+largeur,largeur,XO+PAS,YO+((reel)largeur)*PAS,PAS,buf,screen,pitch);
	lda #0
	sta _x

	lda #64
	sta _y

	lda #128
	sta _w

	jsr _Mandel_HLine

	
	// v_line(0,0+1,largeur,XO,YO+PAS,PAS,buf,screen,pitch);
	lda #0
	sta _x

	lda #0
	sta _y

	lda #64
	sta _h

	jsr _Mandel_VLine
	

	// v_line(0+largeur,0,largeur,XO+((reel)largeur)*PAS,YO,PAS,buf,screen,pitch);
	lda #128
	sta _x

	lda #0
	sta _y

	lda #64
	sta _h

	jsr _Mandel_VLine



	jsr _Mandle_BlitBigBuffer


	// division(0,0,PAS,XO,YO,largeur,buf,screen,pitch);

	lda #0
	sta _VblCounter

	lda #0
	sta _x
	lda #0
	sta _y
	lda #128
	sta _w
	lda #64
	sta _h

	jsr _Mandel_Divide

	jsr _Mandle_BlitBigBuffer


	// Don't forget to restore AddrTables :)
	jsr _Tables_InitialiseScreenAddrTable


	/*
	h_line(0,0,largeur,XO,YO,PAS,buf,screen,pitch);

	v_line(0+largeur,0,largeur,XO+((reel)largeur)*PAS,YO,PAS,buf,screen,pitch);

	h_line(0+1,0+largeur,largeur,XO+PAS,YO+((reel)largeur)*PAS,PAS,buf,screen,pitch);

	v_line(0,0+1,largeur,XO,YO+PAS,PAS,buf,screen,pitch);

	division(0,0,PAS,XO,YO,largeur,buf,screen,pitch);
	*/

	rts
.)






//	x-=2
//	n=pr
//	x1=x-80
//	y1=y-100
//	xn=x1
//	yn=y1
//
//
//	do
//	{
//		compute_inner()
//	}
//	while ( (n!=0) && ((abs(xn)+abs(yn))<=d3) )

_outer_exit
	rts

_compute_outer
	//	n=pr
	lda #MANDEL_ITER_BIS
	sta _n

compute_outer_loop
	jsr _compute_inner

	//	n--
	dec _n	
	beq _outer_exit

	// ABS(xn)
	lda _xn+1
	bmi xn_neg
	sta _axn+1
	lda _xn
	sta _axn
	jmp xn_abs

xn_neg
	sec
	lda #0
	sbc _xn
	sta _axn
	lda #0
	sbc _xn+1
	sta _axn+1
xn_abs


	// ABS(yn)
	lda _yn+1
	bmi yn_neg
	sta _ayn+1
	lda _yn
	sta _ayn
	jmp yn_abs

yn_neg
	sec
	lda #0
	sbc _yn
	sta _ayn
	lda #0
	sbc _yn+1
	sta _ayn+1
yn_abs

	// sum axn+ayn => axn
	// if axn+ayn<=d3 exit loop
	clc
	lda _axn
	adc _ayn
	sta _axn
	lda _axn+1
	adc _ayn+1
	cmp #>MAX_MANDEL_ITER
	bcc compute_outer_loop

	lda _axn
	cmp #<MAX_MANDEL_ITER
	bcc compute_outer_loop

end_outer
	rts




//	d=xn+yn
//	b=xn-yn
//	c=xn*yn
//
//	xn=d*b/d1-x1
//	yn=c/d2-y1
//
//	n--

_compute_inner
	//	d=xn+yn
	clc
	lda _xn
	adc _yn
	sta _d
	lda _xn+1
	adc _yn+1
	sta _d+1

	//	b=xn-yn
	sec
	lda _xn
	sbc _yn
	sta _b
	lda _xn+1
	sbc _yn+1
	sta _b+1

	//	c=xn*yn
	lda _xn 
	sta op1 
	lda _xn+1 
	sta op1+1 
	lda _yn
	sta op2 
	lda _yn+1 
	sta op2+1 
	jsr mul16i 
	stx _c 
	sta _c+1 

	//	yn=c/d2-y1	
	ldx _c+1
	ldy _c

	lda _TableDiv32_low,x
	and #%11111000
	sta _tempfastdiv

	lda _TableDiv32_low,y
	and #%00000111
	ora _tempfastdiv
	sec
	sta _c
	sbc _y1
	sta _yn
	lda _TableDiv32_high,x
	sbc _y1+1
	sta _yn+1


	//	xn=d*b/d1-x1
	lda _d 
	sta op1 
	lda _d+1 
	sta op1+1 
	lda _b
	sta op2 
	lda _b+1 
	sta op2+1 
	jsr mul16i 
	stx op1 
	sta op1+1

	ldx op1+1
	ldy op1

	lda _TableDiv64_low,x
	and #%11111100
	sta _tempfastdiv

	lda _TableDiv64_low,y
	and #%00000011
	ora _tempfastdiv
	sec
	sta op1
	sbc _x1
	sta _xn
	lda _TableDiv64_high,x
	sbc _x1+1
	sta _xn+1
		 
	rts


/*
// unsigned 16bit multply op1 x op2
mandel_mul16u
	lda #0
	sta tmp
	sta tmp+1
	ldy #16
mandel_mult1
	asl tmp
	rol tmp+1
	rol op1
	rol op1+1
	bcc mandel_mult2
	clc
	lda op2
	adc tmp
	sta tmp
	lda op2+1
	adc tmp+1
	sta tmp+1
	bcc mandel_mult2
	inc op1
mandel_mult2
	dey
	bne mandel_mult1
	ldx tmp
	lda tmp+1
	rts

mandel_mul16i
	lda op1+1
	bpl mandel_mul16u
	sec
	lda #0
	sbc op1
	sta op1
	lda #0
	sbc op1+1
	sta op1+1
	jsr mandel_mul16u
	sec
	lda #0
	sbc tmp
	tax
	lda #0
	sbc tmp+1
	rts
*/
