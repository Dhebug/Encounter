// ============================================================================
//
//						Tables.s
//
// ============================================================================
//
// This file contains all the bss tables used through the demo.
//
// ============================================================================

	.zero

ptr_dst
ptr_dst_low			.dsb 1
ptr_dst_high		.dsb 1

squared_value		.dsb 2
nOddValue			.dsb 1
yy					.dsb 1

y					.dsb 1
x					.dsb 1
nSquareRoot			.dsb 1

x0					.dsb 1
x1					.dsb 1
x2					.dsb 1
x3					.dsb 1

	.text


_DIV6	.byt	0
_MOD6	.byt	0

_LeftPattern
	.byt 1+2+4+8+16+32
	.byt 1+2+4+8+16
	.byt 1+2+4+8
	.byt 1+2+4
	.byt 1+2
	.byt 1


_RightPattern
	.byt 63-(1+2+4+8+16+32)
	.byt 63-(1+2+4+8+16)
	.byt 63-(1+2+4+8)
	.byt 63-(1+2+4)
	.byt 63-(1+2)
	.byt 63-(1)

_ShadingTable
	.byt %000000
	.byt %000001
	.byt %010010
	.byt %100101
	.byt %100101
	.byt %110110
	.byt %111011
	.byt %111111



_TablesInit
	//jmp _TablesInit
.(
	;sei
	
	//
	// Clear the BSS section
	//
	.(
	lda #0

	ldx #<_BssStart_
	stx ptr_dst_low
	ldx #>_BssStart_
	stx ptr_dst_high

	ldx #((_BssEnd_-_BssStart_)+1)/256
loop_outer
	tay
loop_inner
	sta (ptr_dst),y
	dey
	bne loop_inner
	inc ptr_dst_high
	dex
	bne loop_outer
	.)


	//
	// Generate multiple of 6 data table
	//
.(
	lda #0
	sta tmp0+0	// cur mul
	sta tmp0+1	// cur div
	sta tmp0+2	// cur mod

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


	.(
	lda	#0
	sta	tmp0

	ldx	#0
loop_div
	;
	; Store Div6
	;
	lda	_DIV6
	ldy	tmp0

	;
	; Store Mod6
	;
	ldy	_MOD6
	lda	_LeftPattern,y
	ldy	tmp0
	ora #64
	sta	_Mod6Left,y

	ldy	_MOD6
	lda	_RightPattern,y
	ldy	tmp0
	ora #64
	sta	_Mod6Right,y


	;
	; Update Div/Mod
	;
	inc	_MOD6
	lda	_MOD6
	cmp	#6
	bne	no_update
	lda	#0
	sta	_MOD6
	inc	_DIV6
no_update

	;
	; Inc Y
	;
	inc	tmp0
	ldy	tmp0
	bne	loop_div
	.)

	jsr _Tables_InitialiseScreenAddrTable

	rts
.)



//
// Generate screen pointer adresses
//
_Tables_InitialiseScreenAddrTable
.(
	lda #<$a000
	sta tmp0+0
	lda #>$a000
	sta tmp0+1

	ldx	#0
loop
	lda	tmp0+0
	sta	_HiresAddrLow,x
	lda	tmp0+1
	sta	_HiresAddrHigh,x

	clc
	lda	tmp0+0
	adc	#40
	sta	tmp0+0
	bcc skip
	inc	tmp0+1
skip

	inx
	cpx #200
	bne	loop
	rts
.)


/*

Distance=SQR(DX^2 + DY^2)

90*90=

Let's say we have a 2x2 resolution, maximum values for a 240x200 screens become 
120x100 from the center, which divided by two means a max squared distance of 60*60+50*50=3600+2500=6100 entries
SQR(6100)=78

http://en.wikipedia.org/wiki/Square_number
// The nth square number can be calculated from the previous two by adding the (n - 1)th square to itself, 
// subtracting the (n - 2)th square number, and adding 2 (n2 = 2(n - 1)2 - (n - 2)2 + 2). 
// For example, 2×52 - 42 + 2 = 2×25 - 16 + 2 = 50 - 16 + 2 = 36 = 62.

// So for example, 52 = 25 = 1 + 3 + 5 + 7 + 9.


If the explosion is in the top half of the screen, that's 40x89 bytes = 3560 bytes.
But considering we compute only one line on two, it's only 40x44 bytes= 1760 bytes
But considering we compute only one half on two, it's only 20x50 bytes= 1000 bytes

6100+1760=7860 bytes, which fits perfectly in the 8000 bytes depacking buffer :D

If for fast lookup we add the square table, we also have to store 60*2 additional values (to store from 0*0 to 60*60=3600)


void GenerateSquareTables()
{
	unsigned char nOddValue=1;
	unsigned char nTemp;
	unsigned int squared_value=0;
	unsigned char n=1;
	unsigned char* ptr_root_table;

	SquareRootTable[0]=0;
	
	SquareTableLow[0] =0;
	SquareTableHigh[0]=0;
	
	ptr_root_table=SquareRootTable+1;
	
	do
	{		
		squared_value+=nOddValue;
		nOddValue+=2;
		
		if (n<60)
		{
			SquareTableLow[n] =squared_value&255;
			SquareTableHigh[n]=(squared_value>>8);
		}
				
		nTemp=nOddValue;
		while (nTemp)
		{
			*ptr_root_table++=n;
			nTemp--;
		}
		
		n++;
	}
	while (n!=77);	// 77*77
}
	
extern unsigned char 	SquareRootTable[6100];
extern unsigned int 	SquareTable[60];
	
_SquareRootTable	= _BufferUnpack				// 6100 bytes long
_SquareTable		= _SquareRootTable+6100		// 60*2=120 bytes long
*/	


_GenerateSquareTables
	;jmp _GenerateSquareTables
.(
	; Initialise the first entries
	lda #0
	sta _SquareRootTable	
	sta _SquareTableLow
	sta _SquareTableHigh
	sta squared_value+0
	sta squared_value+1

	lda #<_SquareRootTable+1
	sta __patch_root_table+1
	lda #>_SquareRootTable+1
	sta __patch_root_table+2
			
	ldx #1				; n=1
	stx nOddValue
	
loop_start
	; squared_value+=nOddValue;
	.(
	clc
	lda squared_value+0
	adc nOddValue+0
	sta squared_value+0
	bcc skip
	inc squared_value+1
skip
	.)
		
	; if (n<60)
	; {
	;	SquareTableLow[n] =squared_value&255;
	;	SquareTableHigh[n]=(squared_value>>8);
	; }
	.(
	cpx #60
	bcs skip
	
	lda squared_value+0
	sta _SquareTableLow,x
	
	lda squared_value+1
	sta _SquareTableHigh,x
skip	
	.)
		
	; nTemp=nOddValue;
	; while (nTemp)
	; {
	;    *ptr_root_table++=n;
	;    nTemp--;
	; }	
	ldy nOddValue
inner_loop	
__patch_root_table
	stx $1234	
	.(
	inc	__patch_root_table+1
	bne skip
	inc	__patch_root_table+2
skip
	.)
	dey
	bne inner_loop
	
	; nOddValue+=2;
	inc nOddValue
	inc nOddValue
		
	inx					; n++;
	
loop_test	
	cpx #82				; while (n!=77);	// 77*77
	bne loop_start
	
	rts
.)


/*
void CreateHalfDisc()
{
	unsigned char x,y;
	unsigned char* ptr_part_buffer;
	unsigned char* ptr_screen;
	unsigned int nSquareDistance;
	unsigned char nSquareRoot;
	unsigned char xx,yy;

	ptr_part_buffer=DiscPartTable;
	yy=58;
	for (y=0;y<60;y++)
	{
		xx=0;
		for (x=0;x<20;x++)
		{
			nSquareDistance =((unsigned int)SquareTableHigh[xx]<<8)|SquareTableLow[xx];
			nSquareDistance+=((unsigned int)SquareTableHigh[yy]<<8)|SquareTableLow[yy];
			nSquareRoot=SquareRootTable[nSquareDistance];	
			ptr_part_buffer[x]=nSquareRoot;
			xx+=3;
		}
		yy--;
	
		ptr_part_buffer+=20;
	}
}
*/

// Part one, generate the right part
_CreateHalfDisc
.(
	lda #<_DiscPartTable
	sta tmp0+0
	
	lda #>_DiscPartTable
	sta tmp0+1
	
	ldy #58
loop_y
	sty yy

	; nSquareDistance+=((unsigned int)SquareTableHigh[yy]<<8)|SquareTableLow[yy];
	
	clc
	lda #<_SquareRootTable
	adc _SquareTableLow,y
	sta tmp1+0
	lda #>_SquareRootTable
	adc _SquareTableHigh,y
	sta tmp1+1

	ldy #0
	ldx #0
loop_x
	; nSquareDistance+=((unsigned int)SquareTableHigh[xx]<<8)|SquareTableLow[xx];
	; ptr_part_buffer[x]=SquareRootTable[nSquareDistance];	
	clc
	lda _SquareTableLow,x
	adc tmp1+0
	sta __patch+1
	lda _SquareTableHigh,x
	adc tmp1+1
	sta __patch+2
		
__patch
	lda $1234
	
	sta (tmp0),y
	
	inx
	inx
	;inx		// 3x inx gives a circle, 2x inx gives a flatish elipsoid
	
	iny
	cpy #20
	bne loop_x

	; ptr_part_buffer+=20;
	clc
	lda tmp0+0
	adc #20
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
		
	ldy yy
	dey
	bne loop_y
	
	rts
.)



/*
void MirrorTheDisc()
{
	unsigned char* ptr_part_buffer;
	unsigned char* ptr_full_buffer;
	unsigned char x,y;
	unsigned char nSquareRoot;

	ptr_part_buffer=DiscPartTable;
	ptr_full_buffer=DiscFullTable;
	for (y=0;y<60;y++)
	{
		for (x=0;x<20;x++)
		{
			nSquareRoot=*ptr_part_buffer++;
			nSquareRoot>>=1;
			
			ptr_full_buffer[20+x]=nSquareRoot;
			ptr_full_buffer[20-x]=nSquareRoot;

			ptr_full_buffer[20+x+40]=nSquareRoot+1;
			ptr_full_buffer[20-x+40]=nSquareRoot+1;
		}
		ptr_full_buffer+=80;
	}
}
*/


// Part two, generate the complete palette
// This part erase the content of SquareTable and SquareRootTable
_MirrorTheDisc
.(
	; ptr_part_buffer=DiscPartTable;
	; ptr_full_buffer=DiscFullTable;
	lda #<_DiscPartTable
	sta tmp0+0	
	lda #>_DiscPartTable
	sta tmp0+1

	lda #<_DiscFullTable
	sta tmp1+0	
	lda #>_DiscFullTable
	sta tmp1+1

	lda #60
	sta y
loop_y
	
	lda #20
	sta x0
	sta x1
	lda #20+40
	sta x2
	sta x3

	ldy #0
loop_x
	; nSquareRoot=*ptr_part_buffer++;
	; nSquareRoot>>=1;
	sty x
	lda (tmp0),y
	lsr 
	sta nSquareRoot
	
	; ptr_full_buffer[20+x]=nSquareRoot;
	; ptr_full_buffer[20-x]=nSquareRoot;
	ldy x0
	dec x0
	sta (tmp1),y
	ldy x1
	inc x1
	sta (tmp1),y

	inc nSquareRoot
	lda nSquareRoot
	
	; ptr_full_buffer[20+x+40]=nSquareRoot+1;
	; ptr_full_buffer[20-x+40]=nSquareRoot+1;
	ldy x2
	dec x2
	sta (tmp1),y
	ldy x3
	inc x3
	sta (tmp1),y
	
	ldy x
	iny
	cpy #20
	bne loop_x

	; ptr_part_buffer+=40;
	.(
	clc
	lda tmp0+0
	adc #20
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	; ptr_full_buffer+=80;
	.(
	clc
	lda tmp1+0
	adc #80
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip
	.)
		
	dec y
	bne loop_y
	rts	
.)


/*
	unsigned char x,y;
	unsigned char* ptr_full_buffer;
	unsigned char* ptr_screen;
	unsigned char xx,yy;

	// Pass 1, generate the green area
	ptr_full_buffer=DiscFullTable+40;
	ptr_screen=(unsigned char*)0xa000+40;
	for (y=1;y<120;y++)
	{
		ptr_full_buffer[0]=0;
		for (x=1;x<40;x++)
		{
			if (ptr_full_buffer[x-40]>=254)
			{
				// If some graphics detected higher in the column, force as graphics
				ptr_full_buffer[x]=255;
			}
			else
			{
				if (ptr_screen[x]!=64)
				{
					// There is graphics here
					ptr_full_buffer[x]=255;
				}
				else
				if (ptr_screen[x+40]!=64)
				{
					// Graphics lower
					ptr_full_buffer[x]=254;
				}
			}
		}
		ptr_full_buffer+=40;
		ptr_screen+=40;
	}
*/

// Pass 1, generate the green area
_FilterTheDisc1
.(
	;ptr_screen=(unsigned char*)0xa000+40;
	;ptr_full_buffer=DiscFullTable+40;
	lda #<$a000
	sta tmp0+0	
	lda #>$a000
	sta tmp0+1

	lda #<_DiscFullTable
	sta tmp1+0	
	lda #>_DiscFullTable
	sta tmp1+1

	lda #119
	sta y
loop_y
	; ptr_full_buffer[0]=0;
	ldy #0
	sta (tmp1),y
	
	lda #0+39
	sta x0
	
	lda #40+39
	sta x1
	
	lda #80+39
	sta x2
loop_x
	
	ldy x0
	lda (tmp1),y
	
	cmp #254
	bcc test_for_graphics
	
	;		if (ptr_full_buffer[x]>=254)
	;		{
	;			// If some graphics detected higher in the column, force as graphics
	;			ptr_full_buffer[x+40]=255;
	;		}
propagate_masking
	lda #255
	bne do_change

	;		else
	;		{
	;			if (ptr_screen[x+40]!=64)
	;			{
	;				// There is graphics here
	;				ptr_full_buffer[x+40]=255;
	;			}
	;			else
	;			if (ptr_screen[x+80]!=64)
	;			{
	;				// Graphics lower
	;				ptr_full_buffer[x+40]=254;
	;			}
	;		}
test_for_graphics
	ldy x1
	lda (tmp0),y
	cmp #64
	bne graphics_here
	
	ldy x2
	lda (tmp0),y
	cmp #64
	beq end_test

graphics_lower	
	lda #254
	bne do_change
	
graphics_here
	lda #255
	bne do_change

do_change
	;				ptr_full_buffer[x+40]=???;
	ldy x1
	sta (tmp1),y
	
end_test
	
	dec x1
	dec x2
	dec x0
	bne loop_x
	
	; ptr_screen+=40;
	.(
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	; ptr_full_buffer+=40;
	.(
	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip
	.)
	
	dec y
	bne loop_y
		
	rts
.)


/*
	// pass two, other stuff
	ptr_full_buffer=DiscFullTable+40;
	for (y=1;y<120;y++)
	{
		for (x=1;x<39;x++)
		{
			if (ptr_full_buffer[x]<254)
			{
				// Empty area, we scan around
				if (ptr_full_buffer[x-1]==255)
				{
					ptr_full_buffer[x]=254;
				}
				else
				if (ptr_full_buffer[x+1]==255)
				{
					ptr_full_buffer[x]=254;
				}
			}
		}
		ptr_full_buffer+=40;
		ptr_screen+=40;
	}
*/

_FilterTheDisc2
.(
	;ptr_full_buffer=DiscFullTable+40;
	lda #<_DiscFullTable
	sta tmp0+0	
	lda #>_DiscFullTable
	sta tmp0+1

	lda #120
	sta y
loop_y
	; ptr_full_buffer[0]=0;
	ldy #0
	sta (tmp1),y
	
	lda #37
	sta x0
	
	lda #38
	sta x1
	
	lda #39
	sta x2
	
loop_x
	;		if (ptr_full_buffer[x]<254)
	;		{
	;		}
	ldy x1
	lda (tmp0),y
	cmp #254
	bcs end_test
	
	;			// Empty area, we scan around
	;			if (ptr_full_buffer[x-1]==255)
	;			{
	;				ptr_full_buffer[x]=254;
	;			}
	;			else
	;			if (ptr_full_buffer[x+1]==255)
	;			{
	;				ptr_full_buffer[x]=254;
	;			}
	ldy x0
	lda (tmp0),y
	cmp #255
	beq fill

	ldy x2
	lda (tmp0),y
	cmp #255
	bne end_test

fill
	lda #254
	ldy x1
	sta (tmp0),y

end_test	
	
	dec x1
	dec x2
	dec x0
	bne loop_x
	
	; ptr_full_buffer+=40;
	.(
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)
	
	dec y
	bne loop_y
		

	rts
.)


.bss

*=$C000

//	.dsb 256-(*&255)

_BssStart_

// Used by:
// - Polyfiller
// - Lines
// - Mandelbrot
_TableMul6				.dsb 256
_TableDiv6				.dsb 256
_TableMod6				.dsb 256
						
// Used by:
// - Polyfiller
_Mod6Left				.dsb 256
_Mod6Right				.dsb 256
_MinX					.dsb 256
_MaxX					.dsb 256

_BufferAddrLow
_HiresAddrLow			.dsb 176
_TextAddrLow			.dsb 80
_BufferAddrHigh
_HiresAddrHigh			.dsb 176
_TextAddrHigh			.dsb 80
		
_BufferUnpack			.dsb 8000				

_SquareRootTable	= _BufferUnpack				// 6680 bytes long
_SquareTableLow		= _SquareRootTable+6680		// 60 bytes long
_SquareTableHigh	= _SquareTableLow+60		// 60 bytes long
_DiscPartTable		= _SquareTableHigh+60		// 20*60=1200 bytes long

_DiscFullTable		= _BufferUnpack				// 40*100=4000

_BssEnd_

.text



