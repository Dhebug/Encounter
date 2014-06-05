

#define _X0	tmp4
#define _Y0	tmp4+1
#define _X1	tmp5
#define _Y1	tmp5+1



#define _alpha	tmp1
#define _beta	tmp1+1
#define _gamma	tmp2
#define _pag	tmp2+1
#define _mag	tmp3
#define _pbg	tmp3+1
#define _mbg	tmp4

#define _xp	tmp5
#define _yp	tmp6
#define _zp	tmp7

#define _v1	reg0
#define _v2	reg0+1
#define _v3	reg1
#define _v4	reg1+1
#define _v5	reg2
#define _v6	reg2+1
#define _v7	reg3
#define _v8	reg3+1

_CurrentColor .byt 0

_ZMax .byt 0

_PointAlpha	.byt 0,64,128,192,0,64,128,192
_PointBeta	.byt 32,32,32,32,192,192,192,192

_PointFinalX .dsb 8
_PointFinalY .dsb 8
_PointFinalZ .dsb 8


_CubeDataList
	.byt 0,1,2,3,1	; RED
	.byt 4,5,6,7,2	; GREEN
	.byt 0,1,5,4,3	; YELLOW
	.byt 1,2,6,5,4	; BLUE
	.byt 2,3,7,6,5	; MAGENTA
	.byt 3,0,4,7,6	; CYAN

pa .byt 0	
pb .byt 0	
pc .byt 0	
pd .byt 0	
pp .byt 0	

data_offset .byt 0



_AddFaceQuit
	rts

_AddFace
	; test if this is one of the far faces...
	clc
	lda data_offset
	tay
	adc #5
	sta data_offset

	lda _CubeDataList,y
	sta pa
	tax
	lda _PointFinalZ,x
	cmp _ZMax
	beq _AddFaceQuit

	iny
	lda _CubeDataList,y
	sta pb
	tax
	lda _PointFinalZ,x
	cmp _ZMax
	beq _AddFaceQuit

	iny
	lda _CubeDataList,y
	sta pc
	tax
	lda _PointFinalZ,x
	cmp _ZMax
	beq _AddFaceQuit

	iny
	lda _CubeDataList,y
	sta pd
	tax
	lda _PointFinalZ,x
	cmp _ZMax
	beq _AddFaceQuit

	iny
	lda _CubeDataList,y
	sta pp



	; A-B
	ldx pa
	lda _PointFinalX,x
	sta _X0
	lda _PointFinalY,x
	sta _Y0
	ldx pb
	lda _PointFinalX,x
	sta _X1
	lda _PointFinalY,x
	sta _Y1
	jsr _AddLineASM

	; B-C
	ldx pb
	lda _PointFinalX,x
	sta _X0
	lda _PointFinalY,x
	sta _Y0
	ldx pc
	lda _PointFinalX,x
	sta _X1
	lda _PointFinalY,x
	sta _Y1
	jsr _AddLineASM

	; C-D
	ldx pc
	lda _PointFinalX,x
	sta _X0
	lda _PointFinalY,x
	sta _Y0
	ldx pd
	lda _PointFinalX,x
	sta _X1
	lda _PointFinalY,x
	sta _Y1
	jsr _AddLineASM

	; D-A
	ldx pd
	lda _PointFinalX,x
	sta _X0
	lda _PointFinalY,x
	sta _Y0
	ldx pa
	lda _PointFinalX,x
	sta _X1
	lda _PointFinalY,x
	sta _Y1
	jsr _AddLineASM

	lda pp
	sta _CurrentColor
	rts


_DrawCube
	;jmp	_DrawCube

	ldy #0
	sty data_offset
	jsr _AddFace
	jsr _AddFace
	jsr _AddFace
	jsr _AddFace
	jsr _AddFace
	jsr _AddFace

	jsr _FillTablesASM
	rts



_RotatePoints	
	lda	#0
	sta	_ZMax

	ldx	#0
loop_next_point
	clc
	lda	_PointAlpha,x
	adc	_Ca
	sta	_alpha

	lda	_PointBeta,x
	sta	_beta

	lda	_Cb
	sta	_gamma

	;
	; Calcule tous les sin et cos
	;
	clc
	lda	_alpha
	adc	_gamma
	tay
	lda	_TabSin8,y
	sta	_v1
	lda	_TabCos8,y
	sta	_v7

	sec
	lda	_alpha
	sbc	_gamma
	tay
	lda	_TabSin8,y
	sta	_v2
	lda	_TabCos8,y
	sta	_v8

	clc
	lda	_beta
	adc	_gamma
	tay
	lda	_TabSin8,y
	sta	_v5
	lda	_TabCos8,y
	sta	_v3

	sec
	lda	_beta
	sbc	_gamma
	tay
	lda	_TabSin8,y
	sta	_v6
	lda	_TabCos8,y
	sta	_v4

	;
	; Store final coordinates
	;
	; xp=Cosinus Alpha
	;
	ldy	_alpha
	lda	_TabCos8,y
	asl
	cmp	#$80
	adc	#120
	sta	_PointFinalX,x

	;
	; Calcul de YP
	;
	lda	_v1
	cmp	#$80
	adc	_v2
	sbc	_v3
	adc	_v4
	cmp	#$80
	;ror		
	adc	#100
	sta	_yp
	sta	_PointFinalY,x

	;
	; Calcul de ZP
	;
	lda	_v5
	cmp	#$80
	adc	_v6
	adc	_v7
	sbc	_v8
	cmp	#$80
	ror	
	adc	#64
	sta	_zp
	sta	_PointFinalZ,x

	cmp	_ZMax
	;blt	continue_point
	bcc	continue_point
	sta	_ZMax
continue_point


	inx
	cpx	#8		 ; Number of points
	beq	end_points
	jmp	loop_next_point

end_points
	rts














#define _S0		tmp1
#define _S1		tmp1+1
#define _B0		tmp1+2
#define _B1		tmp1+3
#define _N		tmp1+4
#define _NEW	tmp1+5
#define _OLD	tmp1+6
#define _PAT	tmp1+7


	.dsb 256-(*&255)


FillTableRazLine
	lda #0
	sta _TableRightPosX,x
	sta	_MaxX,x 	; Reset XMAX

	lda	#239
	sta	_MinX,x 	; Reset XMIN

	inx
	cpx #200
	bne LoopFillTable
	rts


_FillTablesASM
	ldx #0
LoopFillTable

	; Right part
	lda	_MaxX,x 	; Get X1
	beq FillTableRazLine
	cmp	_MinX,x 	; Test with X0
	beq FillTableRazLine
	tay
	lda	#0
	sta	_MaxX,x 	; Reset XMAX
	lda _OsdkTableDiv6,y
	sta _TableRightPosX,x
	lda _OsdkTableMod6,y
	tay
	lda _RightPattern,y
	sta _TableRightMask,x

	; Left part
	ldy	_MinX,x 	; Get X0
	lda	#239
	sta	_MinX,x 	; Reset XMIN
	lda _OsdkTableDiv6,y
	sta _TableLeftPosX,x
	lda _OsdkTableMod6,y
	tay
	lda _LeftPattern,y
	sta _TableLeftMask,x


	inx
	cpx #200
	bne LoopFillTable
	rts





#define _DY	tmp1
#define _DX	tmp2

#define _E	tmp3





	.dsb 256-(*&255)

_AddLineASM
	;lda	_X0
	;cmp	_X1
	;beq	quit_line_asm

	lda	_Y0
	cmp	_Y1
	bcc	no_swap_values
	bne	swap_values

quit_line_asm
	; Null height, or Null width so, we leave
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

	;
	; Compute line width
	; And init E
	;
	sec
	lda	_X1
	sbc	_X0
	sta	_DX
	lda	#0	; Sign extension on 16 bits !
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

loop_y_left
	lda _CurrentColor 
	and _TableLeftColor,y
	beq skip_1

	txa

	cmp	_MinX,y
	bcs	no_min_1
	sta	_MinX,y
no_min_1

	cmp	_MaxX,y
	bcc	no_max_1
	sta	_MaxX,y
no_max_1

skip_1
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

loop_y_right
	lda _CurrentColor 
	and _TableLeftColor,y
	beq skip_2

	txa

	cmp	_MinX,y
	bcs	no_min_2
	sta	_MinX,y
no_min_2

	cmp	_MaxX,y
	bcc	no_max_2
	sta	_MaxX,y
no_max_2

skip_2
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






_InitTables
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


