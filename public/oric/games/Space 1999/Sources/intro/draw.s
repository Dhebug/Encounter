// ============================================================================
//
//						Draw.s
//
// ============================================================================
//
// Code that draw the planet
//
// ============================================================================

	.zero

_X0		.dsb 1
_X1		.dsb 1
_Y		.dsb 1
_CX		.dsb 1
_CY		.dsb 1
_RAY	.dsb 1

_x		.dsb 1
_y		.dsb 1
_a		.dsb 1


y_modulo_3			.dsb 1

ptr_scanline
ptr_scanline_low	.dsb 1
ptr_scanline_high	.dsb 1

shading_offset_low	.dsb 1
shading_offset_high	.dsb 1

shading_step_low	.dsb 1
shading_step_high	.dsb 1


left_mask			.dsb 1
right_mask			.dsb 1

left_offset			.dsb 1

block_lenght		.dsb 1

shading_table		.dsb 1

	.text


_DrawDisc
.(
	;unsigned char x;
	;int y;
	;char a;	

	;
	; Top part
	;

	;y = RAY;
	;x = 0;
	;a = RAY/2;
	lda #0
	sta _x
	
	lda _RAY
	sta _y
	
	lsr
	sta _a
	;do
	;{
.(
loop
	;	x++;
	;	a-=x;
	inc _x
	
	sec
	lda _a
	sbc _x
	sta _a
	;	if (a<0)
	bpl test
	
neg
	;		X0=CX-x;
	;		X1=CX+x;
	;		Y=CY-y;
	;		DrawSegment();
	sec
	lda _CX
	sbc _x
	sta _X0
	
	clc
	lda _CX
	adc _x
	sta _X1
	
	sec
	lda _CY
	sbc _y	
	sta _Y
	
	jsr _DrawSegment
		
	;		Y=CY+y;
	;		DrawSegment();
	clc
	lda _CY
	adc _y	
	sta _Y
	
	jsr _DrawSegment

	;		a+=y;
	;		y--;
	clc
	lda _a
	adc _y
	sta _a
	
	dec _y
		
test
	;while (x<y);
	lda _x
	cmp _y
	bcc loop
	
	
.)	
	
	lda _y
	beq end_of_disc
;jmp end_of_disc
	;
	; Middle part
	;
	// Now more or less reverse the above to get the other eighth
	;a = -RAY/2 - 1;
	lda _RAY
	lsr
	sta tmp
	
	sec
	lda #0
	sbc tmp
	sec
	sbc #1
	sta _a
		
	;do
	;{	
.(
loop
	;	X0=CX-x;
	;	X1=CX+x;
	;	Y=CY-y;
	;	DrawSegment();
	sec
	lda _CX
	sbc _x
	sta _X0
	
	clc
	lda _CX
	adc _x
	sta _X1
	
	sec
	lda _CY
	sbc _y	
	sta _Y
	
	jsr _DrawSegment
	
	;	Y=CY+y;
	;	DrawSegment();
	clc
	lda _CY
	adc _y	
	sta _Y
	
	jsr _DrawSegment
	
	;	a+=y;
	;	y--;
	clc
	lda _a
	adc _y
	sta _a
	
	dec _y
	
	;	if (a>0)
	;	{
	;		x++;
	;		a-=x;
	;	}
	;}
	lda _a
	bmi end_test
	
	inc _x
	
	sec
	lda _a
	sbc _x
	sta _a
	
end_test	
	;while (y>0)
	lda _y
	bne loop
	
.)

	;
	; Final segment in the middle
	; Actually that one is not drawn at all due to the odd/even line thingy :)
	;
	sec
	lda _CX
	sbc _RAY
	sta _X0
	
	clc
	lda _CX
	adc _RAY
	sta _X1
	
	lda _CY
	sta _Y
	
	jsr _DrawSegment
end_of_disc

	rts
.)
	

_DrawSegment
.(
	;unsigned char left_offset=TableDiv6[x0];
	;unsigned char left_mask=64|Mod6Left[x0];
	ldx _X0
	
	lda _TableDiv6,x
	sta left_offset
	
	lda _Mod6Left,x
	sta left_mask

		
	;unsigned char right_offset=TableDiv6[x1];
	;unsigned char block_lenght=right_offset-left_offset;
	;unsigned char right_mask=64|Mod6Right[x1];
	;unsigned int shading_step=SteppingTableDitherWord[block_lenght];
	ldx _X1
	
	lda _Mod6Right,x
	sta right_mask
	
	lda _TableDiv6,x
	sec
	sbc left_offset
	sta block_lenght
		
	tax
	lda _SteppingTableDitherLow,x
	sta shading_step_low
	lda _SteppingTableDitherHigh,x
	sta shading_step_high
	
	;unsigned int shading_offset=gShadingAngle;
	;shading_offset		<<=8;
	lda _Y
	asr a
	clc
	adc _gShadingAngle
	sta shading_offset_high
	lda #0
	sta shading_offset_low

	
	; 
	;unsigned int offset_line=HiresAddrHigh[y];
	;offset_line<<=8;
	;offset_line|=HiresAddrLow[y];
	
	;ptr_line=(unsigned char*)offset_line;

	ldy _Y
	lda _HiresAddrLow,y
	sta ptr_scanline_low
	lda _HiresAddrHigh,y
	sta ptr_scanline_high
	
	tya
	and #3
	sta y_modulo_3

	
	;if (y&1)
	;{
	;	ptr_line[left_offset-1]=4;	// Blue
	;}
	;else
	;{
	;	ptr_line[left_offset-1]=2;	// Green
	;	//ptr_line[left_offset-1]=0;	// Black
	;}
	.(
	ldy left_offset
	
	lda _Y
	and #1
	beq even
	
odd
	lda #4	;4	;+16
	sta (ptr_scanline),y
	jmp end
		
even
	rts
	lda #5	;2	;+16
	sta (ptr_scanline),y
	
end	
	iny
	.)
	
	;
	; Check if it's more than one byte long
	; if (!block_lenght)
	;
	.(
	lda block_lenght
	bne long_line
	
short_line	
	// Same block segment
	;shading_table=CosTableDither[shading_offset>>8];
	;shading_value=64|LabelBumpReconf[shading_table|(y&3)];	
	;ptr_line[left_offset]=left_mask&right_mask&shading_value;
	ldx shading_offset_high
	lda _CosTableDither,x
	ora y_modulo_3
	tax
	lda _LabelBumpReconf,x
	and left_mask
	and right_mask
	
	sta (ptr_scanline),y
	
	rts
		
long_line	
	// Repeat segment
	;shading_offset+=shading_step;
	clc
	lda shading_offset_low
	adc shading_step_low
	sta shading_offset_low
	lda shading_offset_high
	tax
	adc shading_step_high
	sta shading_offset_high
	
	;shading_table=CosTableDither[shading_offset>>8];
	;shading_value=64|LabelBumpReconf[shading_table|(y&3)];
	;ptr_line[left_offset]=left_mask&shading_value;
	lda _CosTableDither,x
	ora y_modulo_3
	tax
	lda _LabelBumpReconf,x
	and left_mask
	
	sta (ptr_scanline),y
	iny
				
	;
	; Loop on intermediate elements
	;
	dec block_lenght
	beq end
loop	
	;	shading_offset+=shading_step;
	clc
	lda shading_offset_low
	adc shading_step_low
	sta shading_offset_low
	lda shading_offset_high
	tax
	adc shading_step_high
	sta shading_offset_high
		
	;	shading_table=CosTableDither[shading_offset>>8];
	;	shading_value=64|LabelBumpReconf[shading_table|(y&3)];
	;	ptr_line[left_offset]=64+32+16+8+4+2+1&shading_value;
	lda _CosTableDither,x
	ora y_modulo_3
	tax
	lda _LabelBumpReconf,x
	
	sta (ptr_scanline),y
	iny
	
	dec block_lenght
	bne loop
end	
	
	;
	; Final bloc
	;
	;shading_table=CosTableDither[shading_offset>>8];
	;shading_value=64|LabelBumpReconf[shading_table|(y&3)];
	;ptr_line[left_offset]=right_mask&shading_value;
	ldx shading_offset_high	
	lda _CosTableDither,x
	ora y_modulo_3
	tax
	lda _LabelBumpReconf,x
	and right_mask
	
	sta (ptr_scanline),y
	.)
	
	rts
.)


// 8000/256=31.25
_FlipToScreen
.(
	ldx #0
loop_x	
	lda _BufferUnpack+256*0,x
	sta $a000+256*0,x
	lda _BufferUnpack+256*1,x
	sta $a000+256*1,x
	lda _BufferUnpack+256*2,x
	sta $a000+256*2,x
	lda _BufferUnpack+256*3,x
	sta $a000+256*3,x
	lda _BufferUnpack+256*4,x
	sta $a000+256*4,x
	lda _BufferUnpack+256*5,x
	sta $a000+256*5,x
	lda _BufferUnpack+256*6,x
	sta $a000+256*6,x
	lda _BufferUnpack+256*7,x
	sta $a000+256*7,x
	lda _BufferUnpack+256*8,x
	sta $a000+256*8,x
	lda _BufferUnpack+256*9,x
	sta $a000+256*9,x
	
	lda _BufferUnpack+256*10,x
	sta $a000+256*10,x
	lda _BufferUnpack+256*11,x
	sta $a000+256*11,x
	lda _BufferUnpack+256*12,x
	sta $a000+256*12,x
	lda _BufferUnpack+256*13,x
	sta $a000+256*13,x
	lda _BufferUnpack+256*14,x
	sta $a000+256*14,x
	lda _BufferUnpack+256*15,x
	sta $a000+256*15,x
	lda _BufferUnpack+256*16,x
	sta $a000+256*16,x
	lda _BufferUnpack+256*17,x
	sta $a000+256*17,x
	lda _BufferUnpack+256*18,x
	sta $a000+256*18,x
	lda _BufferUnpack+256*19,x
	sta $a000+256*19,x
	
	lda _BufferUnpack+256*20,x
	sta $a000+256*20,x
	lda _BufferUnpack+256*21,x
	sta $a000+256*21,x
	lda _BufferUnpack+256*22,x
	sta $a000+256*22,x
	lda _BufferUnpack+256*23,x
	sta $a000+256*23,x
	lda _BufferUnpack+256*24,x
	sta $a000+256*24,x
	lda _BufferUnpack+256*25,x
	sta $a000+256*25,x
	lda _BufferUnpack+256*26,x
	sta $a000+256*26,x
	lda _BufferUnpack+256*27,x
	sta $a000+256*27,x
	lda _BufferUnpack+256*28,x
	sta $a000+256*28,x
	lda _BufferUnpack+256*29,x
	sta $a000+256*29,x
	
	lda _BufferUnpack+256*30,x
	sta $a000+256*30,x

	dex
	beq end
	jmp loop_x
end

	rts
.)




/*
void DrawNuclearBoom(unsigned char base)
{
	unsigned char color_value;
	unsigned char x,y;
	unsigned char* ptr_screen;
	unsigned char* ptr_full_buffer;
	unsigned int nSquareDistance;
	unsigned char nSquareRoot;
	
	ptr_screen=(unsigned char*)0xa000;
	ptr_full_buffer=DiscFullTable;
	for (y=0;y<110;y++)
	{
		for (x=1;x<40;x++)
		{
			nSquareRoot=ptr_full_buffer[x];
			if (nSquareRoot==255)
			{
				// Do nothing
				ptr_screen[x]=16+2;
			}
			else
			if (nSquareRoot==254)
			{
				ptr_screen[x]=16;
			}
			else
			{	
				color_value=16+BoomColor[(base+nSquareRoot)&15];
				ptr_screen[x]=color_value;
			}	
		}
		ptr_screen+=40;
		ptr_full_buffer+=40;		
	}
}
*/

; White, yellow, red, magenta, blue, dark
_GlowColor
	.byt 16+7,16+3,16+1,16+5,16+4,16+0


_BoomColorMinus16
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0	; 16
_BoomColor
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0	; 16
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0	; 16
	.byt 16+0,16+0,16+0,16+0,16+0
	; 37 values
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0	; 16
	
	;.byt 16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1
	;.byt 16+7,16+7,16+7,16+3,16+7,16+3,16+3,16+1,16+3,16+1,16+5,16+1,16+5,16+4,16+0,16+0
	;.byt 16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1
	;.byt 16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1
	;.byt 16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1
	;.byt 16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1
	;.byt 16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1
	
_BoomColorBase	.byt 0
_BoomCounter	.byt 0

bob
_DrawNuclearBoom
.(
	lda #<_DiscFullTable
	sta __patch_src+1
	lda #>_DiscFullTable
	sta __patch_src+2

	lda #<$a000
	sta __patch_dst+1
	lda #>$a000
	sta __patch_dst+2
	
	lda #110
	sta _BoomCounter
loop_y

	ldy #39
loop_x
__patch_src
	lda $1234,y
	cmp #254
	bcs test_high

patch_color
	; color_value=16+BoomColor[(base+nSquareRoot)&15];
	; ptr_screen[x]=color_value;
	;clc
	;adc _BoomColorBase
	;and #15
	tax 
	lda _BoomColor,x
	
do_it	
__patch_dst
	sta $1234,y
skip_it	
	
	dey
	bne loop_x

	.(
	clc
	lda	__patch_src+1
	adc	#40
	sta	__patch_src+1
	sta	__patch_dst+1
	bcc skip
	inc	__patch_src+2
	inc	__patch_dst+2
skip
	.)
			
	dec _BoomCounter
	bne loop_y
	rts	

test_high
	cmp #255
	beq do_nothing
	
paper_black
	lda #16
	bne do_it	
	
do_nothing	
	lda #16+2
	bne skip_it	
	bne do_it	
.)
