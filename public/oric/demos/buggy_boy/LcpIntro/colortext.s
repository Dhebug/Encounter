



#define GRAB_ADRESS		$9800
#define SCREEN_HIRES	$a000
#define CHARTABLE		$B400+8*36
#define SCREEN_TEXT		$BB80
#define SCREEN_END		$BFE0


// Offscreen adresses
//#define PLASMA_ADRESS	$bb80
//#define PLASMA_ADRESS	$b018	//afa0


#define	Red		tmp1
#define RedV	tmp1+1
#define Green	tmp2
#define GreenV	tmp2+1
#define Blue	tmp3
#define BlueV	tmp3+1

Char	
	.byt 0



TableRVB
	.byt 3	// BLUE
	.byt 1	//  RED
	.byt 2	//  GREEN
	.byt 4	//  BLUE
	.byt 1	// RED	
	.byt 2	// GREEN
	.byt 4	// BLUE 
	.byt 7	//  RED

TableDither
	.byt 0 +64	//   0/100
	.byt 36+64	//  33/100
	.byt 54+64	//  66/100
	.byt 63+64	// 100/100

_LogBuffer1		
	.word 2

_LogBuffer2		
	.word 2


MemoPicture	.dsb 2



_Rasters_InitialiseVideo
.(
	//
	// Write $9800 in zéro page
	//
	lda #<GRAB_ADRESS
	sta tmp0
	lda #>GRAB_ADRESS
	sta tmp0+1

	ldy #0

	//
	// Fill HIRES part of screen
	// with a neutral value 64
	//
	.(
	lda #64
loop
	sta (tmp0),y
	iny
	bne skip
	inc tmp0+1
skip
	ldx tmp0+1
	cpx #>SCREEN_TEXT
	bne loop
	cpy #<SCREEN_TEXT
	bne loop
	.)

	//
	// Fill TEXT part of screen
	// with a neutral value 36
	// (correspond to R,G,B = 0,0,0
	//
	.(
	lda #36			
loop
	sta (tmp0),y
	iny
	bne skip
	inc tmp0+1
skip
	ldx tmp0+1
	cpx #>SCREEN_END
	bne loop
	cpy #<SCREEN_END
	bne loop
	.)


	// We must set the 200 HIRES
	// scan-lines to the values we want !
	// For instance, we want to change the
	// INK color, and then switch back to
	// TEXT mode.

	//
	// Write $a000 in zéro page
	//
	.(
	lda #<SCREEN_HIRES
	sta tmp0
	lda #>SCREEN_HIRES
	sta tmp0+1

	lda #200
	sta tmp1

	/*
	ldx #0
loop
	lda TableRVB,x	// Get raster color
	ldy #1
	sta (tmp0),y
	iny
	lda #26			//+128		// back to text mode
	sta (tmp0),y
	iny
	lda #16			// Black paper <= For DYCP scroller
	sta (tmp0),y
	*/

	
	ldx #0
loop
	lda TableRVB,x	// Get raster color
	ldy #1
	sta (tmp0),y
	iny
	lda #16			// Black paper <= For DYCP scroller
	sta (tmp0),y
	iny
	lda #26			//+128		// back to text mode
	sta (tmp0),y
	

	/*	
	ldy #1
	ldx #0
loop
	lda TableRVB,x	// Get raster color
	sta (tmp0),y
	iny
	lda #26					// back to text mode
	sta (tmp0),y
	dey
	*/	

	clc
	lda tmp0
	adc #40
	sta tmp0
	bcc skip
	inc tmp0+1
skip
	inx
	txa
	and #7
	tax

	dec tmp1
	bne loop
	.)



	// We have to set the 25 displayable
	// TEXT line, for calling HIRES mode.

	//
	// Write $bb80 in zéro page
	//
	.(
	lda #<SCREEN_TEXT
	sta tmp0
	lda #>SCREEN_TEXT
	sta tmp0+1

	ldy #0
	ldx #25
loop
	// Move to hires mode
	lda #30			
	sta (tmp0),y

	clc
	lda tmp0
	adc #40
	sta tmp0
	bcc skip
	inc tmp0+1
skip

	dex
	bne loop
	.)

	rts
.)




_Colortext_InitialiseVideo
.(
	//
	// Write $9800 in zéro page
	//
	lda #<GRAB_ADRESS
	sta tmp0
	lda #>GRAB_ADRESS
	sta tmp0+1

	ldy #0

	//
	// Fill HIRES part of screen
	// with a neutral value 64
	//
	.(
	lda #64
loop
	sta (tmp0),y
	iny
	bne skip
	inc tmp0+1
skip
	ldx tmp0+1
	cpx #>SCREEN_TEXT
	bne loop
	cpy #<SCREEN_TEXT
	bne loop
	.)

	//
	// Fill TEXT part of screen
	// with a neutral value 36
	// (correspond to R,G,B = 0,0,0
	//
	.(
	lda #36			
loop
	sta (tmp0),y
	iny
	bne skip
	inc tmp0+1
skip
	ldx tmp0+1
	cpx #>SCREEN_END
	bne loop
	cpy #<SCREEN_END
	bne loop
	.)


	// We must set the 200 HIRES
	// scan-lines to the values we want !
	// For instance, we want to change the
	// INK color, and then switch back to
	// TEXT mode.

	//
	// Write $a000 in zéro page
	//
	.(
	lda #<SCREEN_HIRES
	sta tmp0
	lda #>SCREEN_HIRES
	sta tmp0+1

	lda #200
	sta tmp1

	/*
	ldx #0
loop
	lda TableRVB,x	// Get raster color
	ldy #1
	sta (tmp0),y
	iny
	lda #26			//+128		// back to text mode
	sta (tmp0),y
	iny
	lda #16			// Black paper <= For DYCP scroller
	sta (tmp0),y
	*/

	/*
	ldx #0
loop
	lda TableRVB,x	// Get raster color
	ldy #1
	sta (tmp0),y
	iny
	lda #16			// Black paper <= For DYCP scroller
	sta (tmp0),y
	iny
	lda #26			//+128		// back to text mode
	sta (tmp0),y
	*/

		
	ldy #1
	ldx #0
loop
	lda TableRVB,x	// Get raster color
	sta (tmp0),y
	iny
	lda #26					// back to text mode
	sta (tmp0),y
	dey
	

	clc
	lda tmp0
	adc #40
	sta tmp0
	bcc skip
	inc tmp0+1
skip
	inx
	txa
	and #7
	tax

	dec tmp1
	bne loop
	.)



	// We have to set the 25 displayable
	// TEXT line, for calling HIRES mode.

	//
	// Write $bb80 in zéro page
	//
	.(
	lda #<SCREEN_TEXT
	sta tmp0
	lda #>SCREEN_TEXT
	sta tmp0+1

	ldy #0
	ldx #25
loop
	// Move to hires mode
	lda #30			
	sta (tmp0),y

	clc
	lda tmp0
	adc #40
	sta tmp0
	bcc skip
	inc tmp0+1
skip

	dex
	bne loop
	.)

	rts
.)




_Colortext_InitialiseRGBTables
.(
	//
	// Then, we have to initialise RGB tables to null values. 
	//	
	.(
	lda #0
	ldx #0
loop
	sta _RedValue,x
	sta _GreenValue,x
	sta _BlueValue,x
	inx
	bne loop
	.)


	lda #36
	sta Char

	//
	// Write $B400+8*36 in zéro page
	//
	lda #<CHARTABLE
	sta tmp0
	lda #>CHARTABLE
	sta tmp0+1

	ldx #0
generate_a_loop_blue
	stx Blue
	lda	TableDither,x
	sta	BlueV

	ldx #0
generate_a_loop_green
	stx Green
	lda	TableDither,x
	sta	GreenV

	ldx #0
generate_a_loop_red
	stx Red

	// Write character dithering

	lda #64
	ldy #0
	sta (tmp0),y
	ldy #7
	sta (tmp0),y

	lda	TableDither,x
	ldy #1
	sta (tmp0),y
	ldy #4
	sta (tmp0),y

	lda GreenV
	ldy #2
	sta (tmp0),y
	ldy #5
	sta (tmp0),y

	lda BlueV
	ldy #3
	sta (tmp0),y
	ldy #6
	sta (tmp0),y

	.(
	clc
	lda tmp0
	adc #8
	sta tmp0
	bcc skip
	inc tmp0+1
skip
	.)

	// RedValue[c]=red//
	// GreenValue[c]=green//
	// BlueValue[c]=blue//

	ldx Char

	lda Red
	sta _RedValue,x
	lda Green
	sta _GreenValue,x
	lda Blue
	sta _BlueValue,x

	inc Char

	ldx Red
	inx
	cpx #4
	bne generate_a_loop_red

	inc Char

	.(
	clc
	lda tmp0
	adc #8
	sta tmp0
	bcc skip_it
	inc tmp0+1
skip_it
	.)

	ldx Green
	inx
	cpx #4
	bne generate_a_loop_green

	ldx Blue
	inx
	cpx #4
	bne generate_a_loop_blue
	rts
.)


_InitColorText
	.(
	jsr _Colortext_InitialiseVideo
	jsr _Colortext_InitialiseRGBTables
	rts
	.)










_FlipBuffer
	clc
	lda	_LogBuffer1
	adc #3-1
	sta	tmp0
	lda	_LogBuffer1+1
	adc #0
	sta	tmp0+1

	lda	#<($bb80+3-1)
	sta	tmp1
	lda	#>($bb80+3-1)
	sta	tmp1+1

	ldx #25
flip_loop_y
	ldy #37
flip_loop_x
	lda	(tmp0),y
	sta	(tmp1),y
	dey
	bne	flip_loop_x

	.(
	clc
	lda	tmp0
	adc	#40
	sta	tmp0
	bcc skip
	inc tmp0+1
skip
	.)

	.(
	clc
	lda	tmp1
	adc	#40
	sta	tmp1
	bcc skip
	inc tmp1+1
skip
	.)

	dex
	bne	flip_loop_y

	rts







/*
void FadeToBlack()
{
	int		x,y;
	unsigned char c,r,g,b;
	unsigned char *ptr_screen;
	char	flag;	
	do
	{
		flag=0;
		ptr_screen=(unsigned char*)0xbb80+3;
		for (y=0;y<25;y++)
		{
			for (x=0;x<37;x++)
			{
				c=ptr_screen[x];
				
				if (c!=36)
				{
					r=RedValue[c];
					g=GreenValue[c];
					b=BlueValue[c];

					if (r)	r--;
					if (g)	g--;
					if (b)	b--;

					flag=1;
					ptr_screen[x]=PIXEL_4(r,g,b);
				}
			}
			ptr_screen+=40;
		}
	}
	while (flag);
}
*/


//	sta	tmp0+0
//	sta	tmp0+1



_FadeToBlack
	pha
	tya
	pha
	txa
	pha

fade_main_loop
	lda	#<($bb80+2)
	sta	tmp0+0
	lda	#>($bb80+2)
	sta	tmp0+1

	lda #0
	sta tmp0+2



	ldx #25
fade_screen_loop_y


	ldy #37
fade_screen_loop_x
	lda (tmp0),y
	cmp #36
	beq fade_screen_skip 

	sty	tmp0+3

	// Memorise the value

	tay

	// extract RGB components

	ldx _RedValue,y
	stx Red
	ldx _GreenValue,y
	stx Green
	ldx _BlueValue,y
	stx Blue

	ldx Red
	beq fade_end_red
	dex
	stx Red
	jmp fade_finish_pixel

fade_end_red
	ldx Green
	beq fade_end_green
	dex
	stx Green
	jmp fade_finish_pixel

fade_end_green
	ldx Blue
	ldx _BlueValue,y
	beq fade_end_blue
	dex
	stx Blue
fade_end_blue


fade_finish_pixel

	// Rebuild RGB value

	lda #36
	clc
	adc Red
	ldy Green
	adc _TableMul5,y
	ldy Blue
	adc _TableMul20,y


	// Store the new value

	ldy	tmp0+3
	sta (tmp0),y

	// Indicate we need to do yet another loop

	lda #1
	sta tmp0+2
fade_screen_skip
	dey
	bne fade_screen_loop_x



	clc
	lda	tmp0+0
	adc	#40
	sta	tmp0+0
	lda	tmp0+1
	adc	#0
	sta	tmp0+1

	dex
	bne fade_screen_loop_y


	
	//
	// Check if we have some more iterations to perform
	//
	lda tmp0+2
	bne fade_main_loop

	pla
	tax
	pla
	tay
	pla
	rts



_ScreenColor .byt 0

//
// Piece of code that clear the screen
//
_EraseScreen
	pha
	tya
	pha
	txa
	pha

	clc
	lda	_LogBuffer1
	adc #3-1
	sta	erase_screen_loop_x+1
	lda	_LogBuffer1+1
	adc #0
	sta	erase_screen_loop_x+2

	ldy #25
erase_screen_loop_y
	lda _ScreenColor
	ldx #37
erase_screen_loop_x
	sta $1234,x
	dex
	bne erase_screen_loop_x

	clc
	lda	erase_screen_loop_x+1
	adc	#40
	sta	erase_screen_loop_x+1
	lda	erase_screen_loop_x+2
	adc	#0
	sta	erase_screen_loop_x+2

	dey
	bne erase_screen_loop_y

	pla
	tax
	pla
	tay
	pla
	rts





















/*
void FadeToBlack()
{
	int		x,y;
	unsigned char c,r,g,b;
	unsigned char *ptr_screen;
	char	flag;	
	do
	{
		flag=0;
		ptr_screen=(unsigned char*)0xbb80+3;
		for (y=0;y<25;y++)
		{
			for (x=0;x<37;x++)
			{
				c=ptr_screen[x];
				
				if (c!=36)
				{
					r=RedValue[c];
					g=GreenValue[c];
					b=BlueValue[c];

					if (r)	r--;
					if (g)	g--;
					if (b)	b--;

					flag=1;
					ptr_screen[x]=PIXEL_4(r,g,b);
				}
			}
			ptr_screen+=40;
		}
	}
	while (flag);
}
*/


//	sta	tmp0+0
//	sta	tmp0+1

//Red		.byt	0
//Green	.byt	0
//Blue	.byt	0




/*
void DisplayPicture()
{
	int				x,y,dx,dy;
	unsigned char *ptr_screen;
	unsigned char *ptr_picture;
	unsigned char *ptr_picture_line;
	x=MoveX;
	y=MoveY;
	dx=MoveDX;
	dy=MoveDY;
	ptr_picture_line=Picture+x+y*256;
	ptr_screen=(unsigned char*)0xbb80+3;
	for (y=0;y<25;y++)
	{
		ptr_picture=ptr_picture_line;
		for (x=0;x<37;x++)
		{
			ptr_screen[x]=*ptr_picture;
			ptr_picture+=dx;
		}
		ptr_picture_line+=dy;
		ptr_screen+=40;
	}
}
*/






