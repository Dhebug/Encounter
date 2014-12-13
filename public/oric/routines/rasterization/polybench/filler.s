
/*
	*= $50

ap		.dsb 2
fp		.dsb 2
sp		.dsb 2
tmp0	.dsb 2
tmp1	.dsb 2
tmp2	.dsb 2
tmp3	.dsb 2
tmp4	.dsb 2
tmp5	.dsb 2
tmp6	.dsb 2
tmp7	.dsb 2
op1		.dsb 2
op2		.dsb 2
tmp		.dsb 2
reg0	.dsb 2
reg1	.dsb 2
reg2	.dsb 2
reg3	.dsb 2
reg4	.dsb 2
reg5	.dsb 2
reg6	.dsb 2
reg7	.dsb 2
*/

	.zero

	*= tmp1

_DY				.dsb 2	; tmp1
_DX				.dsb 2	; tmp2

_E				.dsb 2	; tmp3

	*= tmp1
	
StartOffset		.dsb 1	; tmp1
_S1				.dsb 1
LeftByte		.dsb 1	; tmp2
RightByte		.dsb 1
_NEW			.dsb 1	; tmp3
LinePattern		.dsb 1
	
	*= tmp4

_X0				.dsb 1
_Y0				.dsb 1
_X1				.dsb 1
_Y1				.dsb 1
_FlagFirst		.dsb 1
_OddEvenFlag	.dsb 1
_PolyY0 		.dsb 1
_PolyY1 		.dsb 1
	
	.text

	
#define COLOR_PAPER	4
#define COLOR_INK	3


	.dsb 256-(*&255)




_FillTablesASM
	;
	; Patch the code that detects odd or even lines
	;
	.(
	ldx #$F0	; BEQ
	lda	_OddEvenFlag
	bne skip
	ldx #$D0	; BNE
skip	
	stx __patch_oddevenflag
	.)
	
	;
	; Compute the adress of the pattern
	; No need to compute the highbyte since we have less than 256 bytes of patterns and the table is alligned on a page boundary
	;
	lda	_CurrentPattern
	sta	patch_pattern+1

	;
	; Compute the screen start adress
	;
	ldy	_PolyY0
	lda	_ScreenPtrLow,y
	sta	tmp0+0
	lda	_ScreenPtrHigh,y
	sta	tmp0+1

	ldy	_PolyY0
draw_loop_y
	;
	; Start Y
	;
	tya
	and	#1
__patch_oddevenflag	
	bne	draw_end		; bne=$D0 beq=$F0

	;
	; Compute the pattern value
	;
	tya
	and	#7
	tax
patch_pattern
	lda	_Pattern,x
	sta	LinePattern

	;
	; Compute the position in the line
	;
	ldx	_MinX,y 		; Get X0
	lda	_Mod6Left,x		; X offset 0
	sta	LeftByte
	lda	_Div6,x 		; X byte 0
	sta	StartOffset

	ldx	_MaxX,y 		; Get X1
	ldy	StartOffset		; Start offset
	lda	_Mod6Right,x	; X offset 1
	sta	RightByte

	sec
	lda	_Div6,x 		; X byte 1
	sbc	StartOffset
	beq	draw_one

draw_multiple
	;
	; X=Nb to draw
	;
	tax			; Nb to draw
	dex

	lda	LeftByte
	eor	#255
	and	(tmp0),y
	sta	_NEW

	lda	LeftByte
	and	LinePattern
	ora	_NEW

	sta	(tmp0),y
	iny

	; ----- 40*3=120
	
	lda UnrolledOffset,x
	sta __patch_jump+1
	lda	LinePattern
__patch_jump
	jmp UnrolledMultipleDraw	

draw_one
	lda	LeftByte		; compute the mask by intersecting the left and right masks
	and	RightByte
	tax					; Store the mask
	eor	#255			; Need to inverse the mask to "keep" the original parts of the screen
	and	(tmp0),y		; Intersect with the scren value
	sta	_NEW			; Save the masked out screen value

	txa					; Get the mask
	and	LinePattern		; Apply the pattern
	ora	_NEW			; Add the original screen value

	sta	(tmp0),y		; Write back to screen
		
EndMultipleDrawLoop	
draw_end
	;
	; End Y
	;
	;
	; Update screen ptr
	;
	.(
	clc				; 2
	lda	tmp0+0		; 3
	adc	#40			; 2
	sta	tmp0+0		; 3
	bcc skip		; 2/3
	inc	tmp0+1		; 5
skip	
	; --------------> 17/18
	.)

	;
	; Update Y position and local mini/max
	;
	inc	_PolyY0
	ldy	_PolyY0

	lda	#239
	sta	_MinX-1,y

	lda	#0
	sta	_MaxX-1,y

	cpy	_PolyY1
	;bcs	end_draw
	;jmp	draw_loop_y
	bcc	draw_loop_y

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


	.dsb 256-(*&255)
	
UnrolledMultipleDraw	
	; 40 instructions
	sta	(tmp0),y	; 2 bytes
	iny				; 1 byte
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	sta	(tmp0),y
	iny
	
draw_x_final
	lda	RightByte
	eor	#255
	and	(tmp0),y
	sta	_NEW

	lda	RightByte
	and	LinePattern
	ora	_NEW

	sta	(tmp0),y
	
	jmp EndMultipleDrawLoop		; 3 cycles

UnrolledOffset
	.byt 3*40
	         
	.byt 3*39
	.byt 3*38
	.byt 3*37
	.byt 3*36
	.byt 3*35
	.byt 3*34
	.byt 3*33
	.byt 3*32
	.byt 3*31
	.byt 3*30
		     
	.byt 3*29
	.byt 3*28
	.byt 3*27
	.byt 3*26
	.byt 3*25
	.byt 3*24
	.byt 3*23
	.byt 3*22
	.byt 3*21
	.byt 3*20
             
	.byt 3*19
	.byt 3*18
	.byt 3*17
	.byt 3*16
	.byt 3*15
	.byt 3*14
	.byt 3*13
	.byt 3*12
	.byt 3*11
	.byt 3*10
             
	.byt 3*9 
	.byt 3*8 
	.byt 3*7 
	.byt 3*6 
	.byt 3*5 
	.byt 3*4 
	.byt 3*3 
	.byt 3*2 
	.byt 3*1 
	.byt 3*0 
	

	
	.dsb 256-(*&255)




_AddLineASM
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
	lda	_Y1
	cmp	_PolyY1
	bcc	no_bottom
	sta	_PolyY1
no_bottom
	sec
	sbc	_Y0
	sta	_DY

	lda	_Y0
	cmp	_PolyY0
	bcs	no_top
	sta	_PolyY0
no_top

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
.(
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
	clc
no_max_1

	lda	_E
	adc	_DX
	sta	_E
	lda	_E+1
	adc	_DX+1
	sta	_E+1
	bmi	end_loop_e_left
loop_e_left
	inx
	
	.(
	sec
	lda	_E
	sbc	_DY
	sta	_E
	lda	_E+1
	sbc	#0
	sta	_E+1
	.)
	bpl	loop_e_left

end_loop_e_left
	iny
	cpy	_Y1
	bcc	loop_y_left
	rts
.)

go_compute_right
.(
	lda	_FlagFirst
	beq	loop_y_right_first_init
loop_y_right
	txa

	cmp	_MaxX,y
	bcc	no_max_2
	sta	_MaxX,y
no_max_2

	cmp	_MinX,y
	bcs	no_min_2
	sta	_MinX,y
	sec
no_min_2

	lda	_E
	sbc	_DX
	sta	_E
	lda	_E+1
	sbc	_DX+1
	sta	_E+1
	bmi	end_loop_e_right
loop_e_right
	dex
	.(
	sec
	lda	_E
	sbc	_DY
	sta	_E
	lda	_E+1
	sbc	#0
	sta	_E+1
	.)
	bpl	loop_e_right

end_loop_e_right
	iny
	cpy	_Y1
	bcc	loop_y_right
	rts
.)

loop_y_left_first_init
.(
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
	.(
	sec
	lda	_E
	sbc	_DY
	sta	_E
	lda	_E+1
	sbc	#0
	sta	_E+1
	.)
	bpl	loop_e_left_first

end_loop_e_left_first
	iny
	cpy	_Y1
	bcc	loop_y_left_first
	rts
.)

loop_y_right_first_init
.(
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
	.(
	sec
	lda	_E
	sbc	_DY
	sta	_E
	lda	_E+1
	sbc	#0
	sta	_E+1
	.)	
	bpl	loop_e_right_first

end_loop_e_right_first
	iny
	cpy	_Y1
	bcc	loop_y_right_first
	rts
.)

_ClearAndSwapFlag
	lda	_OddEvenFlag
	eor	#1
	sta	_OddEvenFlag
	bne	clear_odd

	;
	; Run the generated code (path 1)
	;
clear_even
	ldx	#COLOR_PAPER
	ldy	#COLOR_INK	
	
	lda #1
	sta __patch_loop_clear_scanline_start+1
	lda #39
	sta __patch_loop_clear_scanline_end+1
	jmp	clear_patch

	;
	; Run the generated code (path 2)
	;
clear_odd
	ldx	#COLOR_INK
	ldy	#COLOR_PAPER
	
	lda #1+40
	sta __patch_loop_clear_scanline_start+1
	lda #39+40
	sta __patch_loop_clear_scanline_end+1

clear_patch
	;
	; Contains 200 lines of "STX adr"/"STY adr"
	;
	.dsb 100*6

	;
	; Erase the scan lines
	;
	lda #64
__patch_loop_clear_scanline_start	
	ldy #1
loop_clear_scanline
	; Contains 100 lines of "STA adr,y"
	.dsb 100*3
	iny
__patch_loop_clear_scanline_end
	cpy #40
	beq end_loop_clear_scanline
	jmp loop_clear_scanline
end_loop_clear_scanline
	
	rts




; y=offset from "tmp0"
; a=increment
IncrementPointer
.(
	clc
	adc	tmp0+0,y
	sta	tmp0+0,y
	lda	tmp0+1,y
	adc	#0
	sta	tmp0+1,y
	rts
.)


InitClearPatch
.(
	lda	#<($a000+1)
	sta	tmp0
	lda	#>($a000+1)
	sta	tmp0+1

	lda	#<(clear_patch)
	sta	tmp1
	lda	#>(clear_patch)
	sta	tmp1+1
	
	lda	#<(loop_clear_scanline)
	sta	tmp2
	lda	#>(loop_clear_scanline)
	sta	tmp2+1
		
	ldx	#100
init_clear_loop
	;
	; Scan line eraser
	;
	ldy	#0	
	lda	#$99		; "STA adr,y" opcode
	sta	(tmp2),y

	iny
	lda	tmp0
	sta	(tmp2),y	; LOW adr

	iny
	lda	tmp0+1
	sta	(tmp2),y	; HIGH adr
	
	lda #3
	ldy #tmp2-tmp0
	jsr IncrementPointer

	;
	; Even lines
	;
	ldy	#0	
	lda	#$8e		; "STX adr" opcode
	sta	(tmp1),y

	iny
	lda	tmp0
	sta	(tmp1),y	; LOW adr

	iny
	lda	tmp0+1
	sta	(tmp1),y	; HIGH adr

	lda #3
	ldy #tmp1-tmp0
	jsr IncrementPointer

	lda #40
	ldy #tmp0-tmp0
	jsr IncrementPointer
		
	;
	; Odd lines
	;
	ldy	#0
	lda	#$8c		; "STY adr" opcode
	sta	(tmp1),y

	iny
	lda	tmp0
	sta	(tmp1),y	; LOW adr

	iny
	lda	tmp0+1
	sta	(tmp1),y	; HIGH adr

	lda #3
	ldy #tmp1-tmp0
	jsr IncrementPointer

	lda #40
	ldy #tmp0-tmp0
	jsr IncrementPointer
			
	dex
	bne	init_clear_loop
	rts
.)








_InitTables
.(
	lda	#200
	sta	_PolyY0
	lda	#0
	sta	_PolyY1
	sta	_FlagFirst
	sta _OddEvenFlag

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
.)




_DIV6	.byt	0
_MOD6	.byt	0


_ComputeDivMod
.(
	;sei

	lda	#0
	sta	_Y0

	ldx	#0
loop_div
	;
	; Store Div6
	;
	lda	_DIV6
	ldy	_Y0
	sta	_Div6,y

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

	ldx	#200
loop_screen_offset
src_1
	lda	#$00
dst_1
	sta	_ScreenPtrLow
src_2
	lda	#$a0
dst_2
	sta	_ScreenPtrHigh

	.(
	clc
	lda	src_1+1
	adc	#40
	sta	src_1+1
	bcc skip
	inc	src_2+1
skip	
	.)

	inc	dst_1+1
	inc	dst_2+1

	dex
	bne	loop_screen_offset


	jsr	InitClearPatch
	rts
.)










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



	.dsb 256-(*&255)

_Div6			.dsb 256
_Mod6Left		.dsb 256
_Mod6Right		.dsb 256
_ScreenPtrLow	.dsb 256
_ScreenPtrHigh	.dsb 256

_MinX			.dsb 256	; 200
_MaxX			.dsb 256	; 200

_Pattern
    ; Solid
    .byt 64+ 1+ 2+ 4+ 8+16+32
    .byt 64+ 1+ 2+ 4+ 8+16+32
    .byt 64+ 1+ 2+ 4+ 8+16+32
    .byt 64+ 1+ 2+ 4+ 8+16+32
    .byt 64+ 1+ 2+ 4+ 8+16+32
    .byt 64+ 1+ 2+ 4+ 8+16+32
    .byt 64+ 1+ 2+ 4+ 8+16+32
    .byt 64+ 1+ 2+ 4+ 8+16+32

    ; Vertical lines
    .byt 64+ 1+    4+   16	
    .byt 64+ 1+    4+   16	
    .byt 64+ 1+    4+   16	
    .byt 64+ 1+    4+   16	
    .byt 64+ 1+    4+   16	
    .byt 64+ 1+    4+   16	
    .byt 64+ 1+    4+   16	
    .byt 64+ 1+    4+   16	

    ; Diagonals
    .byt 64+ 1+	   16	
    .byt 64+ 	 8	
    .byt 64+       4 	
    .byt 64+    2+	      32
    .byt 64+ 1+	   16	
    .byt 64+ 	 8	
    .byt 64+       4 	
    .byt 64+    2+	      32

    ; Dithered
    .byt 64+ 1+    4+   16	
    .byt 64+    2+	 8+   32
    .byt 64+ 1+    4+   16	
    .byt 64+    2+	 8+   32
    .byt 64+ 1+    4+   16	
    .byt 64+    2+	 8+   32
    .byt 64+ 1+    4+   16	
    .byt 64+    2+	 8+   32

    ; Diagonals 2
    .byt 64+ 1+	   16	
    .byt 64+    2+	      32
    .byt 64+       4 	
    .byt 64+ 	 8	
    .byt 64+ 1+	   16	
    .byt 64+    2+	      32
    .byt 64+       4 	
    .byt 64+ 	 8	

    ; Crossings
    .byt 64+ 1+    4+   16	
    .byt 64			
    .byt 64+ 1+    4+   16	
    .byt 64			
    .byt 64+ 1+    4+   16	
    .byt 64			
    .byt 64+ 1+    4+   16	
    .byt 64			
        
_LeftPattern
	.byt 64+1+2+4+8+16+32
    .byt 64+1+2+4+8+16
    .byt 64+1+2+4+8
    .byt 64+1+2+4
    .byt 64+1+2
    .byt 64+1

_RightPattern
    .byt 64+63-(1+2+4+8+16+32)
    .byt 64+63-(1+2+4+8+16)
    .byt 64+63-(1+2+4+8)
    .byt 64+63-(1+2+4)
    .byt 64+63-(1+2)
    .byt 64+63-(1)

    