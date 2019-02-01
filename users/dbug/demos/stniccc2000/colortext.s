

;		message=ptr_message;
;		ptr_screen=ScreenAdress+3;
;		line=3;
;		while (line--)
;		{
;			col=6;
;			while (col--)
;			{
;				c=*message++;
;				ptr_char=((unsigned char*)0xfc78)+((c-32)<<3);
;
;				y=8;
;				while (y--)
;				{
;					bit=*ptr_char++;
;					if (bit & 32)	ptr_screen[0]=color;	// Pixel
;					if (bit & 16)	ptr_screen[1]=color;	// Pixel
;					if (bit & 8)	ptr_screen[2]=color;	// Pixel
;					if (bit & 4)	ptr_screen[3]=color;	// Pixel
;					if (bit & 2)	ptr_screen[4]=color;	// Pixel
;					if (bit & 1)	ptr_screen[5]=color;	// Pixel
;					ptr_screen+=40;
;				}
;				ptr_screen+=6-40*8;
;
;			}
;			ptr_screen+=40*8+4;
;		}

;unsigned char _CharColor;
;unsigned char *PtrMessage;

; tmp 0 -> char
; tmp 1 -> screen
; tmp 2 -> temp save
; tmp 3 -> 

DrawChar
	; Get the pointer on the char set

pos_message
	lda $1234

	;lda #65
	sec
	sbc #32
	sta tmp3
	lda #0
	sta tmp3+1

	clc
	lda tmp3
	adc tmp3
	sta tmp3
	lda tmp3+1
	adc tmp3+1
	sta tmp3+1

	clc
	lda tmp3
	adc tmp3
	sta tmp3
	lda tmp3+1
	adc tmp3+1
	sta tmp3+1

	clc
	lda tmp3
	adc tmp3
	sta tmp3
	lda tmp3+1
	adc tmp3+1
	sta tmp3+1

	clc
	lda #<($fc78)
	adc tmp3
	sta tmp0
	lda #>($fc78)
	adc tmp3+1
	sta tmp0+1

	;lda #<($fc78+(66-32)*8)
	;sta tmp0
	;lda #>($fc78+(66-32)*8)
	;sta tmp0+1





	ldy #0
draw_char_vert
	lda (tmp0),y
	sty tmp2

	ror
	bcc char_skip_0
	tax
	ldy #5
	lda _CharColor
	sta	(tmp1),y
	txa
char_skip_0

	ror
	bcc char_skip_1
	tax
	ldy #4
	lda _CharColor
	sta	(tmp1),y
	txa
char_skip_1

	ror
	bcc char_skip_2
	tax
	ldy #3
	lda _CharColor
	sta	(tmp1),y
	txa
char_skip_2

	ror
	bcc char_skip_3
	tax
	ldy #2
	lda _CharColor
	sta	(tmp1),y
	txa
char_skip_3

	ror
	bcc char_skip_4
	tax
	ldy #1
	lda _CharColor
	sta	(tmp1),y
	txa
char_skip_4

	ror
	bcc char_skip_5
	tax
	ldy #0
	lda _CharColor
	sta	(tmp1),y
	txa
char_skip_5


	; Increase screen adress

	clc
	lda	tmp1
	adc	#40
	sta	tmp1
	lda	tmp1+1
	adc	#0
	sta	tmp1+1

	ldy tmp2
	iny
	cpy #8
	bne	draw_char_vert

	; Increase screen adress to go next char...

	clc
	lda	tmp1
	adc	#<(6-40*8)
	sta	tmp1
	lda	tmp1+1
	adc	#>(6-40*8)
	sta	tmp1+1

	clc
	lda pos_message+1
	adc #1
	sta pos_message+1
	lda pos_message+2
	adc #0
	sta pos_message+2

	rts



DrawLine
	jsr DrawChar
	jsr DrawChar
	jsr DrawChar
	jsr DrawChar
	jsr DrawChar
	jsr DrawChar

	;			ptr_screen+=40*8+4;

	clc
	lda	tmp1
	adc	#<(40*8+4)
	sta	tmp1
	lda	tmp1+1
	adc	#>(40*8+4)
	sta	tmp1+1
	rts



_DrawText
	clc
	lda _ScreenAdress
	adc #3
	sta tmp1
	lda _ScreenAdress+1
	adc #0
	sta tmp1+1

	lda _PtrMessage
	sta pos_message+1
	lda _PtrMessage+1
	sta pos_message+2

	jsr DrawLine
	jsr DrawLine
	jsr DrawLine
	rts




_PlasmaOffset		.byt	0
_PlasmaOffset_2 	.byt	0


//#define ;PLASMA_ADRESS	$bb80
#define PLASMA_ADRESS	$afa0


_FlipBuffer
	lda	#<($afa0+3-1)
	sta	tmp0
	lda	#>($afa0+3-1)
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

	clc
	lda	tmp0
	adc	#40
	sta	tmp0
	lda	tmp0+1
	adc	#0
	sta	tmp0+1

	clc
	lda	tmp1
	adc	#40
	sta	tmp1
	lda	tmp1+1
	adc	#0
	sta	tmp1+1

	dex
	bne	flip_loop_y

	rts


_DrawPlasma
	lda	_PlasmaOffset_2
	sta	_PlasmaOffset
	inc	_PlasmaOffset_2

	lda	#<(PLASMA_ADRESS+3-1)
	sta	tmp1
	lda	#>(PLASMA_ADRESS+3-1)
	sta	tmp1+1

	ldx	#25
plasma_y_loop
	;
	; Add Plasma OFFSET
	;
	lda	_PlasmaOffset
	inc	_PlasmaOffset
	tay

	clc
	lda	_XPlasma
	adc	_CosTable,y

	clc
	adc	#<(_RasterLine-1)
	sta	tmp0
	lda	#0
	adc	#>(_RasterLine-1)
	sta	tmp0+1


	;
	; Display loop
	;
	ldy	#37
plasma_x_loop
	lda	(tmp0),y
	sta	(tmp1),y
	dey
	bne	plasma_x_loop

	clc
	lda	tmp1
	adc	#40
	sta	tmp1
	lda	tmp1+1
	adc	#0
	sta	tmp1+1



	;
	; Grugru
	;
	txa
	and	#1
	beq	odd
even
	inc	tmp0
	jmp	end_loop_y

odd
	dec	tmp0

end_loop_y


	dex
	bne	plasma_y_loop


	rts










;void FadeToBlack()
;{
;	int		x,y;
;	unsigned char c,r,g,b;
;	unsigned char *ptr_screen;
;	char	flag;	
;	do
;	{
;		flag=0;
;		ptr_screen=(unsigned char*)0xbb80+3;
;		for (y=0;y<25;y++)
;		{
;			for (x=0;x<37;x++)
;			{
;				c=ptr_screen[x];
;				
;				if (c!=36)
;				{
;					r=RedValue[c];
;					g=GreenValue[c];
;					b=BlueValue[c];
;
;					if (r)	r--;
;					if (g)	g--;
;					if (b)	b--;
;
;					flag=1;
;					ptr_screen[x]=PIXEL_4(r,g,b);
;				}
;			}
;			ptr_screen+=40;
;		}
;	}
;	while (flag);
;}



;	sta	tmp0+0
;	sta	tmp0+1

Red		.byt	0
Green	.byt	0
Blue	.byt	0


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

	; Memorise the value

	tay

	; extract RGB components

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

	; Rebuild RGB value

	lda #36
	clc
	adc Red
	ldy Green
	adc _Mul5,y
	ldy Blue
	adc _Mul20,y


	; Store the new value

	ldy	tmp0+3
	sta (tmp0),y

	; Indicate we need to do yet another loop

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


	
	;
	; Check if we have some more iterations to perform
	;
	lda tmp0+2
	bne fade_main_loop

	pla
	tax
	pla
	tay
	pla
	rts






;
; Piece of code that clear the screen
;
_EraseScreen
	pha
	tya
	pha
	txa
	pha

	lda	#<($bb80+2)
	sta	erase_screen_loop_x+1
	lda	#>($bb80+2)
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




;void DisplayPicture()
;{
;	int				x,y,dx,dy;
;	unsigned char *ptr_screen;
;	unsigned char *ptr_picture;
;	unsigned char *ptr_picture_line;
;	x=MoveX;
;	y=MoveY;
;	dx=MoveDX;
;	dy=MoveDY;
;	ptr_picture_line=Picture+x+y*256;
;	ptr_screen=(unsigned char*)0xbb80+3;
;	for (y=0;y<25;y++)
;	{
;		ptr_picture=ptr_picture_line;
;		for (x=0;x<37;x++)
;		{
;			ptr_screen[x]=*ptr_picture;
;			ptr_picture+=dx;
;		}
;		ptr_picture_line+=dy;
;		ptr_screen+=40;
;	}
;}


MemoPicture	.dsb 2

;
; Display a picture
;
_DisplayPicture
	pha
	tya
	pha
	txa
	pha

	;	ptr_picture_line=Picture+x+y*256;
	clc
	lda	#<(_Picture)
	adc _MoveX
	sta	MemoPicture
	lda	#>(_Picture)
	adc _MoveX+1
	adc _MoveY
	sta	MemoPicture+1

	lda	#<($bb80+3)
	sta	patch_display_screen+1
	lda	#>($bb80+3)
	sta	patch_display_screen+2

	ldy #25
display_screen_loop_y

	;		ptr_picture=ptr_picture_line;
	clc
	lda MemoPicture
	sta patch_display_picture+1
	adc _MoveDY
	sta MemoPicture
	lda MemoPicture+1
	sta patch_display_picture+2
	adc _MoveDY+1
	sta MemoPicture+1

	ldx #0
display_screen_loop_x

patch_display_picture
	lda $1234
patch_display_screen
	sta $1234,x

	clc
	lda patch_display_picture+1
	adc _MoveDX
	sta patch_display_picture+1
	lda patch_display_picture+2
	adc _MoveDX+1
	sta patch_display_picture+2

	inx
	cpx #37
	bne display_screen_loop_x

	clc
	lda	patch_display_screen+1
	adc	#40
	sta	patch_display_screen+1
	lda	patch_display_screen+2
	adc	#0
	sta	patch_display_screen+2

	dey
	bne display_screen_loop_y

	pla
	tax
	pla
	tay
	pla
	rts




;	for (red=0;red<4;red++)
;	{
;		for (green=0;green<4;green++)
;		{
;			for (blue=0;blue<4;blue++)
;			{
;				c=PIXEL_4(red,green,blue);
;				RedValue[c]=red;
;				GreenValue[c]=green;
;				BlueValue[c]=blue;
;			}
;		}
;	}

_GenerateRGBTable

	; First, precompute the tables of multiplication
	
	lda #0
	ldx #0
_generate_mul_table_5
	sta _Mul5,x
	clc
	adc #5
	inx	
	bne _generate_mul_table_5

	lda #0
	ldx #0
_generate_mul_table_20
	sta _Mul20,x
	clc
	adc #20
	inx	
	bne _generate_mul_table_20


	; Then, we have to put 0 in each component for any char we do not master
	
	lda #0
	ldx #0
_generate_clear_tables
	sta _RedValue,x
	sta _GreenValue,x
	sta _BlueValue,x
	dex
	bne _generate_clear_tables

	; Finaly generate the real table of RGB components

	lda #0
	sta Red
generate_loop_red
	lda #0
	sta Green
generate_loop_green
	lda #0
	sta Blue
generate_loop_blue
	;				c=PIXEL_4(red,green,blue);
	lda #36
	clc
	adc Red
	ldx Green
	adc _Mul5,x
	ldx Blue
	adc _Mul20,x
	
	tax

	;				RedValue[c]=red;
	;				GreenValue[c]=green;
	;				BlueValue[c]=blue;
	lda Red
	sta _RedValue,x
	lda Green
	sta _GreenValue,x
	lda Blue
	sta _BlueValue,x

	ldx Blue
	inx
	stx Blue
	cpx #4
	bne generate_loop_blue
	
	ldx Green
	inx
	stx Green
	cpx #4
	bne generate_loop_green

	ldx Red
	inx
	stx Red
	cpx #4
	bne generate_loop_red

	rts



;
; All the tables for the new video
; mode pixel format conversion
;
; #define PIXEL_4(r,g,b)	(36+  ((r))  +  (((g))*5) +  (((b))*20))
;

	.dsb 256-(*&255)

_RedValue	.dsb 256
_GreenValue .dsb 256
_BlueValue	.dsb 256
_Mul5		.dsb 256
_Mul20		.dsb 256



