// ============================================================================
//
//						Tables.s
//
// ============================================================================
//
// This file contains all the bss tables used through the demo.
//
// ============================================================================



	.text

_Y0		.byt	0
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
	// Clear the zero page
	lda #0
	
	ldx #_zp_end_-_zp_start_
loop
	sta _zp_start_-1,x
	dex
	bne loop
.)

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
	
	jsr _Tables_InitialiseScreenAddrTable

	jsr _Tables_InitialiseCharacterAddrTable

	rts
.)



//
// Generate screen pointer adresses
//
_Tables_InitialiseScreenAddrTable
.(
	.(
	// Initialise HIRES
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
	.)
	
	.(
	// Initialise TEXT
	lda #<$bb80
	sta tmp0+0
	lda #>$bb80
	sta tmp0+1

	ldx	#0
loop
	lda	tmp0+0
	sta	_TextAddrLow+0,x
	sta	_TextAddrLow+1,x
	sta	_TextAddrLow+2,x
	sta	_TextAddrLow+3,x
	sta	_TextAddrLow+4,x
	sta	_TextAddrLow+5,x
	sta	_TextAddrLow+6,x
	sta	_TextAddrLow+7,x
	
	lda	tmp0+1
	sta	_TextAddrHigh+0,x
	sta	_TextAddrHigh+1,x
	sta	_TextAddrHigh+2,x
	sta	_TextAddrHigh+3,x
	sta	_TextAddrHigh+4,x
	sta	_TextAddrHigh+5,x
	sta	_TextAddrHigh+6,x
	sta	_TextAddrHigh+7,x

	clc
	lda	tmp0+0
	adc	#40
	sta	tmp0+0
	bcc skip
	inc	tmp0+1
skip

	inx
	inx
	inx
	inx
	inx
	inx
	inx
	inx
	
	cpx #224
	bne	loop
	.)
	
	rts
.)


//
// Generate character pointer adresses
//
_Tables_InitialiseCharacterAddrTable
.(
	lda #<$b400
	sta tmp0+0
	lda #>$b400
	sta tmp0+1

	ldx	#0
loop
	lda	tmp0+0
	sta	_CharAddrLow,x
	lda	tmp0+1
	sta	_CharAddrHigh,x

	clc
	lda	tmp0+0
	adc	#8
	sta	tmp0+0
	bcc skip
	inc	tmp0+1
skip

	inx
	bne	loop
	rts
.)





	//.bss

	;//*=$C000

_BssStart_


// Used by:
// - Polyfiller
// - Lines
// - Mandelbrot
_TableMul6				.dsb 256
_TableDiv6				.dsb 256
_TableMod6				.dsb 256

_CharAddrLow			.dsb 256
_CharAddrHigh			.dsb 256
						
// Used by:
// - Polyfiller
_Mod6Left				.dsb 256
_Mod6Right				.dsb 256
_MinX					.dsb 256
_MaxX					.dsb 256

//_BufferAddrLow
_HiresAddrLow			.dsb 256
//_BufferAddrHigh
_HiresAddrHigh			.dsb 256

_TextAddrHigh			.dsb 256
_TextAddrLow			.dsb 256
						



_BssEnd_

	.text



