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


_TablesInit
	//jmp _TablesInit
.(

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
	sta	_Y0

	ldx	#0
loop_div
	;
	; Store Div6
	;
	lda	_DIV6
	ldy	_Y0
	//sta	_Div6,y

	;
	; Store Mod6
	;
	ldy	_MOD6
	lda	_LeftPattern,y
	ldy	_Y0
	sta	_Mod6Left,y

	ldy	_MOD6
	lda	_RightPattern,y
	ldy	_Y0
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
	inc	_Y0
	ldy	_Y0
	bne	loop_div
	.)



	//
	// Precompute a table of multiplication by 5
	//
	.(
	lda #0
	ldx #0
loop
	sta _TableMul5,x
	clc
	adc #5
	inx	
	bne loop
	.)

	//
	// Precompute a table of multiplication by 20
	//
	.(
	lda #0
	ldx #0
loop
	sta _TableMul20,x
	clc
	adc #20
	inx	
	bne loop
	.)

	jsr _Tables_InitialiseScreenAddrTable

	jsr _Tables_InitialiseCostable

	jsr _Tables_InitialiseMandelDivide

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


//
// Recopie the base cos table to the cos table
//
_Tables_InitialiseCostable
.(
	ldx #0
loop
	lda _BaseCosTable,x
	sta _CosTable,x
	dex
	bne loop
	rts
.)	



//
// We need to generate a table to divide values
// by 64, and by 32, meaning the result of what
// we have when shifted by 6, and shifted by 5
// with sign extension
// 
_Tables_InitialiseMandelDivide
	//jmp _Tables_InitialiseMandelDivide
.(
	// 16 bits value
	// High     Low
	// Before: fedcba98 76543210
	// After:  .....fed cba98765

	//        76543210 .
	// ROR => .7654321 0
	// ROR => 0.765432 1
	// ROR => 10.76543 2
	// ROR => 210.7654 3
	// ROR => 3210.765 4

	ldx #0
loop
	// Get A
	txa

	// Perform sign extension
	cmp #128
	ror
	cmp #128
	ror
	cmp #128
	ror
	cmp #128
	ror
	cmp #128
	ror

	sta _TableDiv32_high,x

	cmp #128
	ror

	sta _TableDiv64_high,x

	// Rotate the value of 5 to the right = rotate 3 to the left
	// Rotate the value of 6 to the right = rotate 2 to the left

	// Get A
	txa

	cmp #128
	rol
	cmp #128
	rol

	sta _TableDiv64_low,x

	cmp #128
	rol

	sta _TableDiv32_low,x


	inx
	bne loop

	rts
.)




	.bss

	*=$C000

_BssStart_

// A 8192 bytes long buffer that can be used as:
// - 32 buffers of 256 bytes for complex calculations
// - A 8000 bytes long back buffer for HIRES animation
// - Whatever else shit I can manage to think about
_BigBuffer				.dsb 256*33	// +1

// Used by:
// - ColorText
_RotateTableLeft		//.dsb 256*6
_TableMul5				.dsb 256
_TableMul20				.dsb 256

// Used by:
// - Polyfiller
// - Lines
// - Mandelbrot
_TableMul6				.dsb 256
_TableDiv6				.dsb 256
_TableMod6				.dsb 256

// Used by:
// - Mandelbrot
_TableDiv64_low			.dsb 256
_TableDiv64_high		.dsb 256
_TableDiv32_low			.dsb 256
_TableDiv32_high		.dsb 256
						
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
						
_RedValue				.dsb 256
_GreenValue				.dsb 256
_BlueValue				.dsb 256

_CosTable				.dsb 256


//
// A serie of buffers that will contain the one pixel shifted version of scrolls
//
_RotateTableRight			//.dsb 256*6
_Final_Scroll_Buffer
_Scroll_Circular_Buffer
_Scroll_Circular_Buffer_0	.dsb 256
_Scroll_Circular_Buffer_1	.dsb 256
_Scroll_Circular_Buffer_2	.dsb 256
_Scroll_Circular_Buffer_3	.dsb 256
_Scroll_Circular_Buffer_4	.dsb 256
_Scroll_Circular_Buffer_5	.dsb 256
_Scroll_Circular_Buffer_6	.dsb 256
_Scroll_Circular_Buffer_7	.dsb 256

_TableRastersPaper			.dsb 200
							.dsb 56
_TableRastersInk			.dsb 200
							.dsb 56

// For VScroller => probably optimisable
// 28*8=224
/*
_ScrollBuffer		.dsb 256*3	
_ShiftTableBit		.dsb 256
_ShiftTableByte		.dsb 256
_ScrollMapping		.dsb 256
_FontAddrLow		.dsb 256
_FontAddrHigh		.dsb 256
*/
#define _ScrollBuffer		_BigBuffer
#define _ShiftTableBit		_ScrollBuffer+256*3
#define _ShiftTableByte		_ShiftTableBit+256

#define _ScrollMapping		_Scroll_Circular_Buffer_6	//_ShiftTableByte+256 //_Scroll_Circular_Buffer
#define _FontAddrLow		_ScrollMapping+256
#define _FontAddrHigh		_FontAddrLow+256



//_Buffer_RotoZoom			.dsb 64*64	// 4096 bytes

_Scroller_TwoChars_Buffer
_Scroller_TwoChars_Buffer_0	.dsb 2*8
_Scroller_TwoChars_Buffer_1	.dsb 2*8
_Scroller_TwoChars_Buffer_2	.dsb 2*8
_Scroller_TwoChars_Buffer_3	.dsb 2*8
_Scroller_TwoChars_Buffer_4	.dsb 2*8
_Scroller_TwoChars_Buffer_5	.dsb 2*8




_BssEnd_

	.text



