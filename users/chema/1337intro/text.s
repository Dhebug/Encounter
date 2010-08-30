
;
; This file should contain everything related to the display of text/sprites from a bitmap
;

; Our picture file contains a number of different fonts
; 6x12 lower case
; 8x9 upper case
; 11x19 lower case
; 18x18 Upper case
; each font contains letters from a-z, A-Z, numbers, and some punctation (9 signs)
; Total is 26+26+10+9=71 characters per font, 142 characters in total on the page

; For each character we need
; x0
; y0
; width
; height
; base line
; -> 5 bytes per character, x136=680 bytes

;                    a b c  d  e  f  g  h  i  j k l m n o p q r s t u v w x y z
;_FontCharX0		.byt 0,7,14,20,27,34,39,46,53,57
;_FontCharY0     .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;_FontCharWidth  .byt 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
;_FontCharHeight .byt 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
;_FontCharBase   .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8

; Should probably be exported automatically by PictConv with a dedicated format to extract rectangles.


	.zero

_CAR	.dsb 1

src_x	.dsb 1
src_y	.dsb 1
dst_x	.dsb 1
dst_y	.dsb 1
w 		.dsb 1
h 		.dsb 1

x		.dsb 1
y		.dsb 1

	.text


_FontUnpack
.(
	lda #<_BufferUnpack
	sta ptr_destination
	lda #>_BufferUnpack
	sta ptr_destination+1
	lda #<_LabelPictureFont
	sta ptr_source
	lda #>_LabelPictureFont
	sta ptr_source+1
 
	jmp _FileUnpack
.)

_FontInit
.(
	; Set the default base charset
	lda #0
	sta _FontCharOffset
	
	ldx #0
loop_clear
	sta _FontIndex,x
	inx
	bne loop_clear
	
loop_init	
	ldy _FontChars,x
	beq exit
	txa
	sta _FontIndex,y
	inx
	jmp loop_init
exit	
	rts
.)



/*
void DrawCar()
{
	unsigned char *psrc_line;
	unsigned char *pdst_line;
	unsigned char src_x,src_y;
	unsigned char w,h;
	unsigned char x,y;
	
	CAR+=FontCharOffset;
	
	psrc_line=BufferUnpack;
	pdst_line=(unsigned char*)0xa000;
		
	src_x=FontTableX0[CAR];
	src_y=FontTableY0[CAR];
	w =FontTableWidth[CAR];
	h =FontTableHeight[CAR];

	psrc_line+=src_y*40;
	pdst_line+=Y*40;
		
	for (y=0;y<=h;y++)
	{
		for (x=0;x<=w;x++)
		{
			unsigned char *psrc=psrc_line+TableDiv6[src_x+x];
			unsigned char *pdst=pdst_line+TableDiv6[X+x];
			
			if ((*psrc)&TableBit6Reverse[src_x+x])
			{
				// Draw pixel
				(*pdst)|=TableBit6Reverse[X+x];
			}
			else
			{
				// Erase pixel
				(*pdst)&=~TableBit6Reverse[X+x];
			}			
		}
		psrc_line+=40;
		pdst_line+=40;
	}
	X+=w+1;
}
*/

; X,Y,CAR
_DrawCar
.(
	; CAR+=FontCharOffset;
	clc
	lda _FontCharOffset
	adc _CAR
	sta _CAR
	
	; src_x=FontTableX0[CAR];
	; src_y=FontTableY0[CAR];
	; w =FontTableWidth[CAR];
	; h =FontTableHeight[CAR];
	ldx _CAR
	lda _FontTableX0,x
	sta src_x
	lda _FontTableY0,x
	sta src_y
	lda _FontTableWidth,x
	sta w
	lda _FontTableHeight,x
	sta h
	
	
	; psrc_line=BufferUnpack+src_y*40; -> tmp4
	ldy src_y
	clc
	lda _HiresAddrLow,y
	adc #<_BufferUnpack-$a000
	sta tmp4
	lda _HiresAddrHigh,y
	adc #>_BufferUnpack-$a000
	sta tmp4+1
	
	
	; pdst_line=(unsigned char*)0xa000+Y*40; -> tmp5
	ldy _Y
	lda _HiresAddrLow,y
	sta tmp5
	lda _HiresAddrHigh,y
	sta tmp5+1
	
	lda #0
	sta y
loop_y
	lda tmp4+0
	sta tmp2+0
	lda tmp4+1
	sta tmp2+1

	lda tmp5+0
	sta tmp3+0
	lda tmp5+1
	sta tmp3+1
	
	ldx _CAR
	lda _FontTableX0,x
	sta src_x

	ldx _X
	stx dst_x
	
	lda #0
	sta x
loop_x
	;		unsigned char *psrc=psrc_line+TableDiv6[src_x+x];
	;		unsigned char *pdst=pdst_line+TableDiv6[X+x];
	;		
	;		if ((*psrc)&TableBit6Reverse[src_x+x])
	;		{
	;			// Draw pixel
	;			(*pdst)|=TableBit6Reverse[X+x];
	;		}
	;		else
	;		{
	;			// Erase pixel
	;			(*pdst)&=~TableBit6Reverse[X+x];
	;		}
	ldx src_x
	lda _TableDiv6,x
	tay
	lda (tmp4),y
	and _TableBit6Reverse,x
	beq erase_pixel
draw_pixel	

	ldx dst_x
	lda _TableDiv6,x
	tay
	lda (tmp5),y
	ora _TableBit6Reverse,x
	sta (tmp5),y

	jmp end_pixel
	
erase_pixel	

	;ldx dst_x
	;lda _TableDiv6,x
	;tay
	;lda (tmp5),y
	;ora _TableBit6Reverse,x
	;sta (tmp5),y

	jmp end_pixel
	
end_pixel

	inc src_x
	inc dst_x
	
	ldx x
	inx
	stx x
	cpx w
	bne loop_x
	
	; psrc_line+=40;
	; pdst_line+=40;
	
	clc
	lda tmp4+0
	adc #40
	sta tmp4+0
	lda tmp4+1
	adc #0
	sta tmp4+1

	clc
	lda tmp5+0
	adc #40
	sta tmp5+0
	lda tmp5+1
	adc #0
	sta tmp5+1
		
	ldy y
	iny
	sty y
	cpy h
	bne loop_y	
		
	; X+=w+1;
	
	sec
	lda _X
	adc w
	sta _X
	
	rts
.)



/*
void DrawText(char *text)
{
	unsigned char car,x,y;
	unsigned char base_x;
	unsigned char base_y;
	
	base_x=*text++;
	base_y=*text++;
		
	x=base_x;
	y=base_y;
	while (car=*text++)
	{
		if (car==' ')
		{
			x+=FontTableWidth[0];
		}
		else
		if (car==10)
		{
			x=base_x;
			y+=*text++;
		}
		else
		if (car==1)
		{
			FontCharOffset=*text++;
		}
		else
		{
			X=x;
			Y=y;
			CAR=FontIndex[car];
			DrawCar();
			x=X;
		}
	}
}
*/

base_x	.byt 0
base_y	.byt 0

; A+X = text adress
_DrawTextAsm
.(
	sta tmp0+0
	stx tmp0+1

	ldy #0
	lda (tmp0),y
	sta base_x
	sta _X
	iny
	
	lda (tmp0),y
	sta base_y
	sta _Y
	iny
	
loop_car	
	lda (tmp0),y
	beq exit
	iny 
	cmp #32
	beq space
	cmp #10
	beq new_line
	cmp #4
	beq copy_attributes
	cmp #3
	beq offset_y
	cmp #2
	beq offset_x
	cmp #1
	beq change_base	

drawcar
	tax
	lda _FontIndex,x
	sta _CAR	
	sty tmp1
	jsr _DrawCar		; X,Y,CAR
	ldy tmp1
	jmp loop_car
				
offset_x
	clc
	lda _X
	adc (tmp0),y
	sta _X
	iny 
	jmp loop_car
	
space
	clc
	lda _X
	adc _FontTableWidth
	sta _X
	jmp loop_car
	
new_line
	lda base_x
	sta _X
offset_y	
	clc
	lda _Y
	adc (tmp0),y
	sta _Y
	iny 
	jmp loop_car
	
change_base
	lda (tmp0),y
	iny
	sta _FontCharOffset
	jmp loop_car
	
exit
	
	rts

copy_attributes
	;jmp copy_attributes
.(
	sty tmp1
	
	clc
	lda _X
	adc #5
	tax 
	lda _TableDiv6,x
	sta __patch_x2+1
	
	lda (tmp0),y
	tax
	
	ldy _Y
	lda _HiresAddrLow,y
	sta tmp2+0
	lda _HiresAddrHigh,y
	sta tmp2+1
loop	
	ldy #0
	lda (tmp2),y
__patch_x2	
	ldy #1
	sta (tmp2),y
	
	clc
	lda tmp2+0
	adc #40
	sta tmp2+0
	lda tmp2+1
	adc #0
	sta tmp2+1
	
	dex
	bne loop
	
	ldy tmp1
	iny 
	jmp loop_car
.)
	
.)





_FontChars
	.byt "abcdefghijklmnopqrstuvwxyz"
	.byt "0123456789"
	.byt ".,",59,58,"!?/'-"
	.byt "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	.byt 0
	
_FontCharOffset
	.byt 0

_FontIndex
	.dsb 256

	
	
_FontTableX0
	.byt 1,8,15,21,28,35,40,47,54,56,60,67,69,79,86,93
	.byt 100,107,111,116,120,126,134,146,153,160,167,172,176,181,186,191
	.byt 196,201,206,211,1,3,6,9,11,13,18,22,26,31,39,45
	.byt 53,60,66,71,80,87,89,94,100,105,115,122,131,137,146,152
	.byt 158,164,171,179,189,197,205,1,13,25,37,49,61,68,80,91
	.byt 95,101,112,116,134,145,157,169,181,187,195,202,213,223,1,13
	.byt 25,35,48,56,69,82,96,109,121,134,147,159,163,168,173,177
	.byt 181,192,201,209,1,18,30,49,64,74,83,103,115,119,128,141
	.byt 149,1,15,35,46,66,78,90,100,112,128,150,166,180
_FontTableY0
	.byt 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,15,15,15,15,15,15,15,15,15,15,15,15
	.byt 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
	.byt 15,15,15,15,15,15,15,32,32,32,32,32,32,32,32,32
	.byt 32,32,32,32,32,32,32,32,32,32,32,32,32,32,51,51
	.byt 51,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55
	.byt 55,55,55,55,76,76,76,76,76,76,76,76,76,76,76,76
	.byt 76,95,95,95,95,95,95,95,95,95,95,95,95,95
_FontTableWidth
	.byt 6,6,5,6,6,4,6,6,1,3,6,1,9,6,6,6
	.byt 6,3,4,3,5,7,11,6,6,6,4,3,4,4,4,4
	.byt 4,4,4,4,1,2,2,1,1,4,3,3,4,7,5,7
	.byt 6,5,4,8,6,1,4,5,4,9,6,8,5,8,5,5
	.byt 5,6,7,9,7,7,6,11,11,11,11,11,6,11,10,3
	.byt 5,10,3,17,10,11,11,11,5,7,6,10,9,15,11,11
	.byt 9,12,7,12,12,13,12,11,12,12,11,3,4,4,3,3
	.byt 10,8,7,7,16,11,18,14,9,8,19,11,3,8,12,7
	.byt 21,13,19,10,19,11,11,9,11,15,21,15,13,10
_FontTableHeight
	.byt 9,9,9,9,9,9,12,9,9,12,9,9,9,9,9,12
	.byt 12,9,9,9,9,9,9,9,12,9,9,9,9,9,9,9
	.byt 9,9,9,9,9,10,10,9,9,9,9,9,9,9,9,9
	.byt 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
	.byt 9,9,9,9,9,9,9,18,18,18,18,18,18,22,18,18
	.byt 22,18,18,18,18,18,22,22,18,18,18,18,18,18,18,22
	.byt 18,18,18,18,18,18,18,18,18,18,18,18,20,20,18,18
	.byt 18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18
	.byt 18,18,18,18,18,18,18,18,18,18,18,18,18,18





