
	.zero

_U		.dsb 1
_U1		.dsb 1
_V		.dsb 1
_V1		.dsb 1
_IU		.dsb 1
_IU1	.dsb 1
_IV		.dsb 1
_IV1	.dsb 1
_MU		.dsb 1
_MU1	.dsb 1
_MV		.dsb 1
_MV1	.dsb 1

	.text

/*
  +-------+
00|*      |
01|*      |
02|*      |
03|*   ***|
04|*** *  |
05|    *  |
06|    *  |
07|*** ***|
08|* *    |
09|***    |
10|*      |
11|*   ***|
12|      *|
13|*** ***|
14|* * *  |
15|* * ***|
16|* *    |
17|*** ***|
18|    * *|
19|* * * *|
20|* * * *|
21|*** ***|
22|  *    |
23|  *    |
  +-------+
*/


_RotoZoom_LcpLogo
	.byt "*      "
	.byt "*      "
	.byt "*      "
	.byt "*   ***"
	.byt "*** *  "
	.byt "    *  "
	.byt "    *  "
	.byt "*** ***"
	.byt "* *    "
	.byt "***    "
	.byt "*      "
	.byt "*   ***"
	.byt "      *"
	.byt "*** ***"
	.byt "* * *  "
	.byt "* * ***"
	.byt "* *    "
	.byt "*** ***"
	.byt "    * *"
	.byt "* * * *"
	.byt "* * * *"
	.byt "*** ***"
	.byt "  *    "
	.byt "  *    "





_RotoZoom_patterns
	// A
	.byt %110100
	.byt %111010
	.byt %110100
	.byt %011010
	.byt %011101
	.byt %001110
	.byt %000111
	.byt %000011

	// B
	.byt %000000
	.byt %000010
	.byt %000101
	.byt %001010
	.byt %010101
	.byt %011010
	.byt %110100
	.byt %111010

	// C
	.byt %000001
	.byt %000001
	.byt %000001
	.byt %000010
	.byt %000010
	.byt %100100
	.byt %001000
	.byt %100000

	// D
	.byt %110000
	.byt %001000
	.byt %000100
	.byt %000010
	.byt %000010
	.byt %000001
	.byt %000001
	.byt %000001

	// E
	.byt %111000
	.byt %101101
	.byt %010011
	.byt %100011
	.byt %000111
	.byt %100110
	.byt %000111
	.byt %001110

	// F
	.byt %001101
	.byt %001110
	.byt %001100
	.byt %011010
	.byt %011100
	.byt %011010
	.byt %010100
	.byt %100000

	// G
	.byt %110000
	.byt %100111
	.byt %001000
	.byt %010011
	.byt %010110
	.byt %010101
	.byt %010100
	.byt %010101

	// H
	.byt %010100
	.byt %010101
	.byt %010100
	.byt %010101
	.byt %010011
	.byt %001000
	.byt %100111
	.byt %110000

	// I
	.byt %000011
	.byt %111001
	.byt %000100
	.byt %110010
	.byt %001010
	.byt %011010
	.byt %111010
	.byt %111010

	// J
	.byt %111010
	.byt %111010
	.byt %111010
	.byt %111010
	.byt %110010
	.byt %000100
	.byt %111001
	.byt %000011

_RotoZoom_patterns_glow
	// 0
	.byt %000000
	.byt %000000
	.byt %000000
	.byt %001000
	.byt %000000
	.byt %000000
	.byt %000000
	.byt %000000

	// 1
	.byt %000000
	.byt %000000
	.byt %000000
	.byt %001100
	.byt %001100
	.byt %000000
	.byt %000000
	.byt %000000

	// 2
	.byt %000000
	.byt %000000
	.byt %001100
	.byt %011110
	.byt %011110
	.byt %001100
	.byt %000000
	.byt %000000

	// 3
	.byt %000000
	.byt %011110
	.byt %111111
	.byt %111111
	.byt %111111
	.byt %111111
	.byt %011110
	.byt %000000

	// 4
	.byt %000000
	.byt %000000
	.byt %011110
	.byt %111111
	.byt %111111
	.byt %011110
	.byt %000000
	.byt %000000

	// 5
	.byt %000000
	.byt %000000
	.byt %001100
	.byt %011110
	.byt %011110
	.byt %001100
	.byt %000000
	.byt %000000

	// 6
	.byt %000000
	.byt %000000
	.byt %000000
	.byt %001100
	.byt %001100
	.byt %000000
	.byt %000000
	.byt %000000
	
	// 7
	.byt %000000
	.byt %000000
	.byt %000000
	.byt %001000
	.byt %000000
	.byt %000000
	.byt %000000
	.byt %000000



_RotoZoom_DrawHorizontalSegment
.(
loop
	lda #69
	ldy #0
	sta (tmp0),y
	lda #70
	ldy #40
	sta (tmp0),y

	clc
	lda tmp0+0
	adc #1
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip

	dex
	bne loop
	
	rts
.)



_RotoZoom_DrawVerticalSegment
.(
loop
	lda #65
	ldy #0
	sta (tmp0),y
	lda #67
	ldy #1
	sta (tmp0),y
	lda #66
	ldy #40
	sta (tmp0),y
	lda #68
	ldy #41
	sta (tmp0),y

	clc
	lda tmp0+0
	adc #80
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip

	dex
	bne loop
	
	rts
.)


RotoZoom_CharSequence		.byt 0


_RotoZoom_MoveCharacters
.(
	//
	// Zoom the dots
	//
	.(
	lda RotoZoom_CharSequence
	clc
	adc #8
	sta RotoZoom_CharSequence

	ldy RotoZoom_CharSequence
	ldx #8*8
loop
	tya
	and #63
	tay
	lda _RotoZoom_patterns_glow-1,y
	sta $b400+"0"*8-1,x

	iny

	dex
	bne loop
	.)

	//
	// Scroll the screws up
	// AC 
	// BD
	//
	.(
	lda $b400+"A"*8
	pha
	lda $B400+"C"*8
	pha

	ldx #0
loop
	lda $b400+"A"*8+1,x
	sta $b400+"A"*8,x
	lda $B400+"C"*8+1,x
	sta $B400+"C"*8,x

	inx
	cpx #16
	bne loop 

	pla
	sta $B400+"C"*8+15
	pla
	sta $b400+"A"*8+15
   	.)

	//
	// Scroll the screews right
	// EF
	//
	.(
	ldx #0
loop
	lda $b400+"E"*8,x
	cmp #32
	rol
	and #%00111111
	sta $b400+"E"*8,x
	inx
	cpx #16
	bne loop
	.)


	rts
.)


_RotoZoom_Initialise
.(
	jsr _Text_RedefineCharset

	//
	// Redefine characters
	//
	.(
	ldx #8*10
loop
	lda _RotoZoom_patterns-1,x
	sta $b400+65*8-1,x

	dex
	bne loop
	.)

	//
	// Draw border patterns
	//
	lda #<$bb80+40*2+1
	sta tmp0+0
	lda #>$bb80+40*2+1
	sta tmp0+1
	ldx #12
	jsr _RotoZoom_DrawVerticalSegment

	lda #<$bb80+40*2+10
	sta tmp0+0
	lda #>$bb80+40*2+10
	sta tmp0+1
	ldx #10
	jsr _RotoZoom_DrawVerticalSegment

	lda #<$bb80+40*24+38
	sta tmp0+0
	lda #>$bb80+40*24+38
	sta tmp0+1
	ldx #1
	jsr _RotoZoom_DrawVerticalSegment

	//
	// Horizontal segments
	//
	lda #<$bb80+3
	sta tmp0+0
	lda #>$bb80+3
	sta tmp0+1
	ldx #7
	jsr _RotoZoom_DrawHorizontalSegment

	lda #<$bb80+40*26+3
	sta tmp0+0
	lda #>$bb80+40*26+3
	sta tmp0+1
	ldx #35
	jsr _RotoZoom_DrawHorizontalSegment

	lda #<$bb80+40*22+12
	sta tmp0+0
	lda #>$bb80+40*22+12
	sta tmp0+1
	ldx #26
	jsr _RotoZoom_DrawHorizontalSegment

	//
	// Corner jewels
	//
	ldx #"G"+128
	stx $bb80+40*0+1
	stx $bb80+40*0+10
	stx $bb80+40*22+10
	stx $bb80+40*22+38
	stx $bb80+40*26+1
	stx $bb80+40*26+38

	inx
	stx $bb80+40*1+1
	stx $bb80+40*1+10
	stx $bb80+40*23+10
	stx $bb80+40*23+38
	stx $bb80+40*27+1
	stx $bb80+40*27+38

	inx
	stx $bb80+40*0+2
	stx $bb80+40*0+11
	stx $bb80+40*22+11
	stx $bb80+40*22+39
	stx $bb80+40*26+2
	stx $bb80+40*26+39

	inx
	stx $bb80+40*1+2
	stx $bb80+40*1+11
	stx $bb80+40*23+11
	stx $bb80+40*23+39
	stx $bb80+40*27+2
	stx $bb80+40*27+39

	//
	// Terminate by Yellow ink on the left
	//
	.(
	lda #<$bb80
	sta tmp0+0
	lda #>$bb80
	sta tmp0+1
	ldx #28
loop
	ldy #0
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
	bne loop
	.)


	//
	// Display LCP logo
	//
	.(
	lda #<$bb80+40*2+3
	sta tmp0+0
	lda #>$bb80+40*2+3
	sta tmp0+1

	ldy #0
	sty tmp1

	ldx #24
	stx tmp1+1
loop

	ldy #0
loop_x
	ldx tmp1
	inc tmp1
	lda _RotoZoom_LcpLogo,x
	cmp #" "
	beq space

	lda tmp1
	and #7
	clc
	adc #"0"

space
	sta (tmp0),y

	iny
	cpy #7
	bne loop_x

	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip

	dec tmp1+1
	bne loop
	.)

	rts
.)




/*
void DisplayRotoZoom()
{
	unsigned char	*screen_adress;
	unsigned int	x,y;

	screen_adress	=(unsigned char*)0xBB80+3;
	for (y=0;y<25;y++)
	{
		U=MU;
		MU-=IV;

		V=MV;
		MV+=IU;

		for (x=0;x<37;x++)
		{			
			Adress=(unsigned int)Picture;
			*(((unsigned char*)&Adress)+0)+=*(((unsigned char*)&U)+1);
			*(((unsigned char*)&Adress)+1)+=(*(((unsigned char*)&V)+1))&63;

			*screen_adress=*((unsigned char*)Adress);

			screen_adress++;
			U+=IU;
			V+=IV;
		}
		screen_adress+=3;
	}
}
*/



#define SCREEN_TEXT	$bb80-1+12






//
// Totaly stupid rotozoom that uses no texture at all :)
//
_DisplayRotoZoomAsm	
.(
	ldy #28	//40
loop_draw_x	

	//		U=MU;
	//		MU-=IV;
	sec
	lda _MU
	sta _U
	sbc _IV
	sta _MU

	lda _MU1
	sta _U1
	sbc _IV1
	sta _MU1

	//		V=MV;
	//		MV+=IU;
	clc
	lda _MV
	sta _V
	adc _IU
	sta _MV
	lda _MV1
	sta _V1
	adc _IU1
	sta _MV1


	// 0
	ldx #28-6
loop
	clc
	lda	_U
	adc _IU
	sta _U
	lda _U1
	adc _IU1
	sta _U1
	rol
	php

	clc
	lda	_V
	adc _IV
	sta _V
	lda _V1
	adc _IV1
	sta _V1
	plp
	rol
	rol
	and #3
	ora #16

	pha

	dex
	bne loop


	pla
	sta	SCREEN_TEXT+40*0,y
	pla
	sta	SCREEN_TEXT+40*1,y
	pla
	sta	SCREEN_TEXT+40*2,y
	pla
	sta	SCREEN_TEXT+40*3,y
	pla
	sta	SCREEN_TEXT+40*4,y
	pla
	sta	SCREEN_TEXT+40*5,y
	pla
	sta	SCREEN_TEXT+40*6,y
	pla
	sta	SCREEN_TEXT+40*7,y
	pla
	sta	SCREEN_TEXT+40*8,y
	pla
	sta	SCREEN_TEXT+40*9,y
	pla
	sta	SCREEN_TEXT+40*10,y
	pla
	sta	SCREEN_TEXT+40*11,y
	pla
	sta	SCREEN_TEXT+40*12,y
	pla
	sta	SCREEN_TEXT+40*13,y
	pla
	sta	SCREEN_TEXT+40*14,y
	pla
	sta	SCREEN_TEXT+40*15,y
	pla
	sta	SCREEN_TEXT+40*16,y
	pla
	sta	SCREEN_TEXT+40*17,y
	pla
	sta	SCREEN_TEXT+40*18,y
	pla
	sta	SCREEN_TEXT+40*19,y
	pla
	sta	SCREEN_TEXT+40*20,y
	pla
	sta	SCREEN_TEXT+40*21,y
	/*
	pla
	sta	SCREEN_TEXT+40*22,y
	pla
	sta	SCREEN_TEXT+40*23,y
	pla
	sta	SCREEN_TEXT+40*24,y
	pla
	sta	SCREEN_TEXT+40*25,y
	pla
	sta	SCREEN_TEXT+40*26,y
	pla
	sta	SCREEN_TEXT+40*27,y
	*/

	dey
	beq end
	jmp loop_draw_x

end
	rts
.)






_DisplayRotoZoomAsm_WithTexture	
.(
	lda	#<$bb80+2
	sta	screen_adr+1
	lda	#>$bb80+2
	sta	screen_adr+2

	ldy #25
loop_draw_y	

	//		U=MU;
	//		MU-=IV;
	sec
	lda _MU
	sta _U
	sbc _IV
	sta _MU

	lda _MU1
	sta _U1
	sbc _IV1
	sta _MU1

	//		V=MV;
	//		MV+=IU;
	clc
	lda _MV
	sta _V
	adc _IU
	sta _MV
	lda _MV1
	sta _V1
	adc _IU1
	sta _MV1

	//		for (x=0;x<37;x++)

	// 37 columns
	ldx	#37		
loop_draw_x

	//			Adress=(unsigned int)Picture;
	//			*(((unsigned char*)&Adress)+0)+=*(((unsigned char*)&U)+1);
	//			U+=IU;
	//			*(((unsigned char*)&Adress)+1)+=(*(((unsigned char*)&V)+1))&63;
	//			V+=IV;

	clc
	lda	_U
	adc _IU
	sta _U
	lda _U1
	adc _IU1
	sta _U1


	clc
	lda	_V
	adc _IV
	sta _V
	lda _V1
	adc _IV1
	sta _V1


	lda _U1
	and #63
	clc
	ror
	sta tmp0+1
	lda #0
	ror
	sta tmp0+0

	lda _V1
	and #127
	ora tmp0+0
	sta tmp0+0

	/*
	lda _U1
	and #63
	sta tmp0+0

	lda _V1
	asl
	asl
	asl
	asl
	asl
	asl
	ora tmp0+0
	sta tmp0+0

	lda _V1
	lsr
	lsr
	and #15
	sta tmp0+1
	*/

	clc
	lda #<_BigBuffer
	adc tmp0+0
	sta _adr_read_pixel+1

	lda #>_BigBuffer
	adc tmp0+1
	sta _adr_read_pixel+2

_adr_read_pixel
	lda	$1234

	//lda #16+1

	//			*screen_adress=*((unsigned char*)Adress);
	//			screen_adress++;

screen_adr
	sta	$bb80,x

	dex
	bne	loop_draw_x

	//		screen_adress+=3;

	clc
	lda	screen_adr+1
	adc	#40
	sta	screen_adr+1
	bcc display_rotozoom_skip
	inc screen_adr+2
display_rotozoom_skip

	dey
	beq end
	jmp loop_draw_y

end
	rts
.)










