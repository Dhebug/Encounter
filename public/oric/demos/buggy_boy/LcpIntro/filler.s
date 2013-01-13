



	.zero

_FlagFirst	.dsb 1
_X0			.dsb 1
_Y0			.dsb 1
_X1			.dsb 1
_Y1			.dsb 1

	.text


#define _PolyY0 tmp7
#define _PolyY1 tmp7+1


#define _S0		tmp1
#define _S1		tmp1+1
#define _B0		tmp1+2
#define _B1		tmp1+3

#define _DY	tmp1
#define _DX	tmp2

#define _E	tmp3

	.dsb 256-(*&255)




_FillTablesASM
.(
	//
	// Compute the screen start adress
	//
	ldy	_PolyY0
	lda	_HiresAddrLow,y
	sta	tmp0+0
	lda	_HiresAddrHigh,y
	sta	tmp0+1

draw_loop_y
	;
	; Start Y
	;

	;
	; Compute the position in the line
	;
	lda	_MinX,y 	; Get X0
	tax
	lda	_Mod6Left,x	; X offset 0
	sta	_B0
	lda	_TableDiv6,x 	; X byte 0
	sta	_S0

	lda	_MaxX,y 	; Get X1
	ldy	_S0		; Start offset
	tax
	lda	_Mod6Right,x	; X offset 1
	sta	_B1

	sec
	lda	_TableDiv6,x 	; X byte 1
	sbc	_S0
	bne	draw_multiple

draw_one
	lda	_B0
	and	_B1
	eor	(tmp0),y
	sta	(tmp0),y

	jmp draw_end

draw_multiple
	;
	; X=Nb to draw
	;
	tax			; Nb to draw

	lda	_B0
	eor	(tmp0),y
	sta	(tmp0),y
	iny

	dex
	beq	draw_x_final
draw_loop_x
	lda	(tmp0),y
	eor #1+2+4+8+16+32
	sta	(tmp0),y
	iny
	dex
	bne	draw_loop_x

draw_x_final
	lda	_B1
	eor	(tmp0),y
	sta	(tmp0),y

draw_end
	;
	; End Y
	;
	//
	// Update screen ptr
	//
	.(
	clc
	lda	tmp0+0
	adc	#40
	sta	tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	//lda	tmp0+1
	//adc	#0
	//sta	tmp0+1

	;
	; Update Y position and local mini/max
	;
	ldy	_PolyY0

	lda	#239
	sta	_MinX,y

	lda	#0
	sta	_MaxX,y

	iny
	sty	_PolyY0

	cpy	_PolyY1
	bcs	end_draw
	jmp	draw_loop_y

end_draw
	;
	; Clear Global Y mini/maxi
	;
	lda	#200
	sta	_PolyY0
	lda	#0
	sta	_PolyY1
	sta	_FlagFirst
	rts
.)




	.dsb 256-(*&255)




_AddLineASM
.(
	lda	_Y0
	cmp	_Y1
	bcc	no_swap_values
	bne	swap_values

	; Null height, so, we leave
	rts

swap_values

	; Swap X's
	ldx	_X0
	ldy	_X1
	stx	_X1
	sty	_X0

	; Swap Y's
	ldx	_Y0
	ldy	_Y1
	stx	_Y1
	sty	_Y0

no_swap_values
	; Store height
	sec
	lda	_Y1
	sbc	_Y0
	sta	_DY

	lda	_Y0
	cmp	_PolyY0
	bcs	no_top
	sta	_PolyY0
no_top

	lda	_Y1
	cmp	_PolyY1
	bcc	no_bottom
	sta	_PolyY1
no_bottom

	;
	; Compute line width
	; And init E
	;
	sec
	lda	_X1
	sbc	_X0
	sta	_DX
	lda	#0
	sbc	#0
	sta	_E
	sta	_E+1
	sta	_DX+1

	;
	; Common inits
	;
	ldy	_Y0
	ldx	_X0

	txa
	cmp	_X1
	bcs	go_compute_right

go_compute_left
	lda	_FlagFirst
	beq	loop_y_left_first_init

loop_y_left
	txa

	cmp	_MinX,y
	bcs	no_min_1
	sta	_MinX,y
no_min_1

	cmp	_MaxX,y
	bcc	no_max_1
	sta	_MaxX,y
no_max_1

	clc
	lda	_E
	adc	_DX
	sta	_E
	lda	_E+1
	adc	_DX+1
	sta	_E+1
	bmi	end_loop_e_left
loop_e_left
	inx
	sec
	lda	_E
	sbc	_DY
	sta	_E
	lda	_E+1
	sbc	#0
	sta	_E+1
	bpl	loop_e_left

end_loop_e_left
	iny
	cpy	_Y1
	bcc	loop_y_left
	rts


go_compute_right
	lda	_FlagFirst
	beq	loop_y_right_first_init
loop_y_right
	txa

	cmp	_MinX,y
	bcs	no_min_2
	sta	_MinX,y
no_min_2

	cmp	_MaxX,y
	bcc	no_max_2
	sta	_MaxX,y
no_max_2

	sec
	lda	_E
	sbc	_DX
	sta	_E
	lda	_E+1
	sbc	_DX+1
	sta	_E+1
	bmi	end_loop_e_right
loop_e_right
	dex
	sec
	lda	_E
	sbc	_DY
	sta	_E
	lda	_E+1
	sbc	#0
	sta	_E+1
	bpl	loop_e_right

end_loop_e_right
	iny
	cpy	_Y1
	bcc	loop_y_right
	rts


loop_y_left_first_init
	lda	#1
	sta	_FlagFirst
	clc
loop_y_left_first
	txa			; NZ, not C
	sta	_MinX,y
	sta	_MaxX,y

	lda	_E
	adc	_DX
	sta	_E
	lda	_E+1
	adc	_DX+1
	sta	_E+1
	bmi	end_loop_e_left_first
loop_e_left_first
	inx
	sec
	lda	_E
	sbc	_DY
	sta	_E
	lda	_E+1
	sbc	#0
	sta	_E+1
	bpl	loop_e_left_first

end_loop_e_left_first
	iny
	cpy	_Y1
	bcc	loop_y_left_first
	rts


loop_y_right_first_init
	lda	#1
	sta	_FlagFirst
loop_y_right_first
	txa
	sta	_MinX,y
	sta	_MaxX,y

	sec
	lda	_E
	sbc	_DX
	sta	_E
	lda	_E+1
	sbc	_DX+1
	sta	_E+1
	bmi	end_loop_e_right_first
loop_e_right_first
	dex
	sec
	lda	_E
	sbc	_DY
	sta	_E
	lda	_E+1
	sbc	#0
	sta	_E+1
	bpl	loop_e_right_first

end_loop_e_right_first
	iny
	cpy	_Y1
	bcc	loop_y_right_first
	rts
.)








_Filler_ClearMinMaxTable
	lda	#200
	sta	_PolyY0
	lda	#0
	sta	_PolyY1

	lda	#239
	ldx	#200
loop_init_min
	dex
	sta	_MinX,x
	bne	loop_init_min

	lda	#0
	ldx	#200
loop_init_max
	dex
	sta	_MaxX,x
	bne	loop_init_max
	rts













; Calculate some RANDOM values
; Not accurate at all, but who cares ?
; For what I need it's enough.

_RandomValueLow
	 .byt 23
_RandomValue
_RandomValueHigh
	.byt 35


_GetRand	
	 lda _RandomValueHigh
	 sta tmp1
	 lda _RandomValueLow
	 asl 
	 rol tmp1
	 asl 
	 rol tmp1
; asl
; rol temp1
; asl
; rol temp1
	 clc
	 adc _RandomValueLow
	 pha
	 lda tmp1
	 adc _RandomValueHigh
	 sta _RandomValueHigh
	 pla
	 adc #$11
	 sta _RandomValueLow
	 lda _RandomValueHigh
	 adc #$36
	 sta _RandomValueHigh
	 jmp	*+3
	 rts
	 

