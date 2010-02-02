

	.dsb 256-(*&255)

_HiresAddrLow			.dsb 201

	.dsb 256-(*&255)

_HiresAddrHigh			.dsb 201
						
	.dsb 256-(*&255)

_TableDiv6				.dsb 256

_TableBit6Reverse		
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1

	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1

	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1

	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1
	.byt 32,16,8,4,2,1


_GenerateTables
.(

	; Generate screen offset data
.(
	lda #<$a000
	sta tmp0+0
	lda #>$a000
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
	sta tmp0+1	; cur div
	sta tmp0+2	; cur mod

	ldx #0
loop
	lda tmp0+1
	sta _TableDiv6,x

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







