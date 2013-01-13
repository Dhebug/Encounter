
/*
	0 16 noir
	1 17 rouge
	2 18 vert
	3 19 jaune
	4 20 bleu
	5 21 violet
	6 22 cyan
	7 23 blanc
*/


	.zero

_Rasters_AngleRed		.dsb 1
_Rasters_AngleGreen		.dsb 1
_Rasters_AngleBlue		.dsb 1

_Rasters_CurAngleRed	.dsb 1
_Rasters_CurAngleGreen	.dsb 1
_Rasters_CurAngleBlue	.dsb 1


	.text

_RideauCount	.byt 0
_RideauPos	.byt	0
_Rasters_DisplayOffset
	.byt 1





_Rasters_TableOrange
	.byt 16+0
	.byt 16+1
	.byt 16+3
	.byt 16+7
	.byt 16+7
	.byt 16+3
	.byt 16+1
	.byt 16+0

	.byt 0


_Rasters_TableBleu
	.byt 16+0
	.byt 16+4
	.byt 16+6
	.byt 16+7
	.byt 16+7
	.byt 16+6
	.byt 16+4
	.byt 16+0

	.byt 0


_RastersDitherTable
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 1
	.byt 0
	.byt 0
	.byt 1
	.byt 1
	.byt 0
	.byt 1
	.byt 0
	.byt 0
	.byt 1
	.byt 1
	.byt 0
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1




//Fg Bg
// 0-16	   noir
// 1-17	   rouge
// 2-18	   vert
// 3-19	   jaune
// 4-20	   bleu
// 5-21	   magenta
// 6-22	   cyan
// 7-23	   blanc
//

RasterRideau
	// 16 noirs
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16

	// 16 noirs
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16

	// 16 noirs
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
       // .byt	 16
       // .byt	 16
       // .byt	 16
       // .byt	 16
       // .byt	 16

	// Le raster
	.byt	20
	.byt	20
	.byt	22
	.byt	22
	.byt	18
	.byt	18
	.byt	19
	.byt	19
	.byt	17
	.byt	17
	.byt	21
	.byt	21
	.byt	20
	.byt	20
	.byt	20
	.byt	20

	// 16 noirs
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16


	// 16 noirs
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16
	.byt	16


_Rasters_Initialise
.(	  
	jsr _Rasters_InitialiseCostable
	jsr _Rasters_InitialiseVideoMode
	rts
.)





_Rasters_InitialiseVideoMode
.(
	jsr _Rasters_InitialiseVideo


	// Add some video inversion where required :)
	.(
	lda #<$bb80
	sta tmp0+0
	lda #>$bb80
	sta tmp0+1

	lda #<$a000
	sta tmp2+0
	lda #>$a000
	sta tmp2+1


	lda #24
	sta tmp1
	ldx #1
loop
	dex
	beq raster
noraster
	lda #128
	sta tmp1+1
	jmp endraster
raster
	ldx #6
	lda #0
	sta tmp1+1
endraster

	// Hires mode
	.(
	lda #8
	sta tmp3
	ldy #3
loop_inner
	lda #26
	eor tmp1+1
	sta (tmp2),y

	.(
	clc
	lda tmp2+0
	adc #40
	sta tmp2+0
	bcc skip
	inc tmp2+1
skip
	.)
	dec tmp3
	bne loop_inner
	.)


	// Text mode
	lda #36
	eor tmp1+1
	ldy #4
	sta (tmp0),y

	lda #11
	eor tmp1+1
	ldy #20
	sta (tmp0),y

	lda #36
	//eor tmp1+1
	ldy #21
	sta (tmp0),y

	lda #36
	//eor tmp1+1
	ldy #37
	sta (tmp0),y

	lda #36
	//eor tmp1+1
	ldy #38
	sta (tmp0),y


	lda #36
	eor tmp1+1
	ldy #39
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

	dec tmp1	
	bne loop
	.)

	/*
	lda #36
	sta $bb80+20
	sta $bb80+40*6+20
	sta $bb80+40*12+20
	sta $bb80+40*18+20
	sta $bb80+40*24+20

	lda #9
	sta $bb80+21
	sta $bb80+40*6+21
	sta $bb80+40*12+21
	sta $bb80+40*18+21
	sta $bb80+40*24+21

	lda #36
	sta $bb80+37
	sta $bb80+40*6+37
	sta $bb80+40*12+37
	sta $bb80+40*18+37
	sta $bb80+40*24+37
	
	sta $bb80+38
	sta $bb80+40*6+38
	sta $bb80+40*12+38
	sta $bb80+40*18+38
	sta $bb80+40*24+38
	*/
.)


_Rasters_InitialiseCostable
.(
	ldx #0
loop
	lda _BaseCosTable,x
	lsr
	lsr
	lsr
	tay
	lda _RastersDitherTable,y
	sta _CosTable,x
	dex
	bne loop
	rts
.)	



// Clear the raster color buffer
_RastersClearBuffer
.(
	// Clear all the buffers with
	// - Black paper
	// - White ink
	// - neutral Z value
	.(
	// Perform some crazy gradient calculation
	lda _Rasters_AngleRed
	sta _Rasters_CurAngleRed
	inc _Rasters_AngleRed

	lda _Rasters_AngleGreen
	sta _Rasters_CurAngleGreen
	inc _Rasters_AngleGreen
	inc _Rasters_AngleGreen

	lda _Rasters_AngleBlue
	sta _Rasters_CurAngleBlue
	inc _Rasters_AngleBlue
	inc _Rasters_AngleBlue
	inc _Rasters_AngleBlue

	// Initialize "rideau" value
	ldx	_RideauPos
	inx
	txa
	and	#63
	sta	_RideauPos

	clc
	lda	#<RasterRideau-1
	adc	_RideauPos
	sta	__rideau+1
	lda	#>RasterRideau-1
	adc	#0
	sta	__rideau+2

	lda #16
	sta _RideauCount


	ldx #0
loop
	ldy _Rasters_CurAngleRed
	lda _CosTable,y
	sta tmp0

	ldy _Rasters_CurAngleGreen
	lda _CosTable,y
	asl
	ora tmp0
	sta tmp0

	ldy _Rasters_CurAngleBlue
	lda _CosTable,y
	asl
	asl
	ora tmp0
	
	ora #16
	sta _TableRastersPaper,x

	.(
	ldy _RideauCount
	dey
	bne skip
	ldy #16
skip
	sty _RideauCount
	.)
__rideau
	lda	RasterRideau-1+16,y
	and #7
	sta _TableRastersInk,x


	inc	_Rasters_CurAngleRed
	inc	_Rasters_CurAngleGreen
	inc	_Rasters_CurAngleBlue


	inx
	cpx #200
	bne loop
	.)


	.(
	ldx #0
loop
	lda _Rasters_TableOrange,x
	beq end
	sta _TableRastersPaper,x
	sta _TableRastersPaper+96,x
	sta _TableRastersPaper+200-8,x
	and #7
	sta _TableRastersInk+48,x
	sta _TableRastersInk+144,x
	lda _Rasters_TableBleu,x
	sta _TableRastersPaper+48,x
	sta _TableRastersPaper+144,x
	and #7
	sta _TableRastersInk,x
	sta _TableRastersInk+96,x
	sta _TableRastersInk+200-8,x
	inx
	jmp loop
end
	.)
	rts
.)




// Display the content of the buffer 
// onto the screen
_RastersDisplayBuffer
.(
	jsr _RastersClearBuffer

	.(
	clc
	lda #<$a000
	adc _Rasters_DisplayOffset
	sta tmp0
	lda #>$a000
	adc #0
	sta tmp0+1

	ldx #0	
loop
	lda _TableRastersInk,x
	ldy #0
	sta (tmp0),y
	lda _TableRastersPaper,x
	inx
	iny
	sta (tmp0),y

	lda _TableRastersInk,x
	ldy #40
	sta (tmp0),y
	lda _TableRastersPaper,x
	inx
	iny
	sta (tmp0),y

	lda _TableRastersInk,x
	ldy #80
	sta (tmp0),y
	lda _TableRastersPaper,x
	inx
	iny
	sta (tmp0),y

	lda _TableRastersInk,x
	ldy #120
	sta (tmp0),y
	lda _TableRastersPaper,x
	inx
	iny
	sta (tmp0),y

	.(
	clc
	lda tmp0
	adc #160
	sta tmp0
	bcc skip
	inc tmp0+1
skip
	.)

	cpx #200
	bne loop
	.)

	rts
.)


