


	.dsb 256-(*&255)

_TableBit6				.byt 1,2,4,8,16,32

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


#define e	tmp1	; 2 bytes in zero page
#define i	tmp1+2	; 1 byte in zp
#define s1	tmp1+3	; 0=dec 2=inc 4=nop
#define s2	tmp1+4	; 0=dec 2=inc 4=nop
#define x1	tmp1+5
#define y1	tmp1+6
#define x2	tmp1+7
#define y2	tmp1+8
#define dx	tmp1+9
#define dy	tmp1+10


; 00 = Decrement = 0
; 01 = Increment = 2
; 10 = Rien		 = 4
; 11 = Rien      = 6

; 0  = X
; 1  = Y

_DrawLineOpcodes
				; 42 1
	.byt $CA	; 00 0	 DEC X
	.byt $88	; 00 1	 DEC Y
	.byt $E8	; 01 0	 INC X
	.byt $C8	; 01 1	 INC Y
	.byt $EA	; 10 0	 NOP
	.byt $EA	; 10 1	 NOP
	.byt $EA	; 11 0	 NOP
	.byt $EA	; 11 1	 NOP


	.dsb 256-(*&255)


_CurrentPixelX	.byt 0
_CurrentPixelY	.byt 0
_OtherPixelX	.byt 0
_OtherPixelY	.byt 0


_DrawHLine
.(
	pha
	txa
	pha
	tya
	pha

	//
	// Compute the screen start adress
	//
	ldy	_CurrentPixelY
	lda	_HiresAddrLow,y
	sta	tmp0+0
	lda	_HiresAddrHigh,y
	sta	tmp0+1

	//
	// Compute the position in the line
	//
	lda	_CurrentPixelX 	// Get X0
	tax
	lda	_Mod6Left,x		// X offset 0
	sta	_B0
	lda	_TableDiv6,x 	// X byte 0
	sta	_S0

	lda	_OtherPixelX 	// Get X1
	ldy	_S0				// Start offset
	tax
	lda	_Mod6Right,x	// X offset 1
	sta	_B1

	sec
	lda	_TableDiv6,x 	// X byte 1
	sbc	_S0
	bne	draw_multiple

draw_one
	lda	_B0
	and	_B1
	eor	(tmp0),y
	sta	(tmp0),y
	jmp draw_end


draw_multiple
	//
	// X=Nb to draw
	//
	tax			// Nb to draw

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
	//
	// End Y
	//
	pla
	tay
	pla
	tax
	pla
	rts
.)



_DrawLine
	lda _OtherPixelX
	sta x2

	;
	; Compute deltas and signs
	;
  ; Test X value
.(
	lda _CurrentPixelX
	sta x1
	cmp x2
	beq equal
	bcc cur_smaller

cur_bigger					; x1>x2
	sec
	sbc x2
	sta dx

	lda #0	; DEC
	sta s1
	jmp end

equal
	lda #4	; NOP
	sta s1

	lda #0
	sta dx
	jmp end

cur_smaller					; x1<x2
	sec
	lda x2
	sbc x1
	sta dx

	lda #2	; INC
	sta s1
end
.)


	lda _OtherPixelY
	sta y2

  ; Test Y value
.(
	lda _CurrentPixelY
	sta y1
	cmp y2
	beq equal
	bcc cur_smaller

cur_bigger					; y1>y2
	sec
	sbc y2
	sta dy

	lda #0
	sta s2
	jmp end

equal
	lda #4	; NOP
	sta s2

	lda #0
	sta dy
	jmp end

cur_smaller					; y1<y2
	sec
	lda y2
	sbc y1
	sta dy

	lda #2
	sta s2
end
.)


.(
	;
	; Compute slope
	;
	lda dy
	cmp dx
	bcc dy_smaller

dy_bigger					; dy>dx
	ldx dx
	stx dy
	sta dx

	lda #0	; X
	ora s1
	tax

	lda #1	; Y
	ora s2
	tay

	jmp draw_verticaly


dy_smaller					; dx<dy
	lda #1	; Y
	ora s2
	tax

	lda #0	; X
	ora s1
	tay
	jmp draw_horizontaly
end
.)

	.dsb 256-(*&255)


;
; This code is used when the things are moving faster
; horizontally than vertically 
;
draw_horizontaly
.(
	;
	; Patch the code
	;
	lda _DrawLineOpcodes,y
	sta _outer_patch

.(
	lda _DrawLineOpcodes,x

	cmp #$c8
	beq go_down

go_up
	lda #$38	; sec
	sta _patch_screen_clc
	lda #$e9	; sbc (immediate)
	sta _patch_screen_adc
	lda #$b0	; bcs
	sta	_patch_screen_bcc
	lda #$c6	; dec (zero page)
	sta	_patch_screen_inc
	jmp end_choice

go_down
	lda #$18	; clc
	sta _patch_screen_clc
	lda #$69	; adc (immediate)
	sta _patch_screen_adc
	lda #$90	; bcc
	sta	_patch_screen_bcc
	lda #$e6	; inc (zero page)
	sta	_patch_screen_inc

end_choice
.)


	;
	; Initialize counter
	;
	ldx dx
	inx
	stx i


	; Initialise e
	clc
	lda dy
	adc dy
	sta _path_e_dy_0+1	; dy
	sta e
	lda #0
	adc #0
	sta _path_e_dy_1+1	; dy+1
	sta 1+e

	sec
	lda e
	sbc dx
	sta e
	lda 1+e
	sbc #0
	sta 1+e



	clc
	lda dx
	adc dx
	sta _path_e_dx_0+1	;dx
	lda #0
	adc #0
	sta _path_e_dx_1+1	;dx+1


	;
	; Initialise start coordinates
	;
	ldx x1
	ldy y1

	lda _HiresAddrLow,y
	sta tmp0+0
	lda _HiresAddrHigh,y
	sta tmp0+1

	;
	; Draw loop
	;
outer_loop

.(
	ldy _TableDiv6,x
	lda (tmp0),y
	eor _TableBit6Reverse,x
	sta (tmp0),y
.)

inner_loop
	lda 1+e
	bmi end_inner_loop

_inner_patch	

	; Update screen adress
_patch_screen_clc
	clc
	lda tmp0+0
_patch_screen_adc
	adc #40
	sta tmp0+0
_patch_screen_bcc
	bcc skip
_patch_screen_inc
	inc tmp0+1
skip

	; e=e-2*dx
	sec
	lda e
_path_e_dx_0
	sbc #0
	sta e
	lda 1+e
_path_e_dx_1
	sbc #0
	sta 1+e

	bpl _inner_patch
end_inner_loop

_outer_patch
	inx

	; e=e+2*dy
	clc
	lda e
_path_e_dy_0
	adc #0
	sta e
	lda 1+e
_path_e_dy_1
	adc #0
	sta 1+e

	dec i
	bne outer_loop

end_line
.)
	rts



	.dsb 256-(*&255)

;
; This code is used when the things are moving faster
; vertically than horizontally
;
draw_verticaly
	;jmp draw_verticaly
.(	
	;
	; Patch the code
	; $88	; 00 1	 DEC Y
	; $C8	; 01 1	 INC Y
	;
	lda _DrawLineOpcodes,x
	sta _inner_patch

.(
	lda _DrawLineOpcodes,y
	
	cmp #$c8
	beq go_down

go_up
	lda #$38	; sec
	sta _patch_screen_clc
	lda #$e9	; sbc (immediate)
	sta _patch_screen_adc
	lda #$b0	; bcs
	sta	_patch_screen_bcc
	lda #$c6	; dec (zero page)
	sta	_patch_screen_inc
	jmp end_choice

go_down
	lda #$18	; clc
	sta _patch_screen_clc
	lda #$69	; adc (immediate)
	sta _patch_screen_adc
	lda #$90	; bcc
	sta	_patch_screen_bcc
	lda #$e6	; inc (zero page)
	sta	_patch_screen_inc

end_choice
.)


	;
	; Initialize counter
	;
	ldx dx
	inx
	stx i


	; Initialise e
	clc
	lda dy
	adc dy
	sta _path_e_dy_0+1	; dy
	sta e
	lda #0
	adc #0
	sta _path_e_dy_1+1	; dy+1
	sta 1+e

	sec
	lda e
	sbc dx
	sta e
	lda 1+e
	sbc #0
	sta 1+e



	clc
	lda dx
	adc dx
	sta _path_e_dx_0+1	;dx
	lda #0
	adc #0
	sta _path_e_dx_1+1	;dx+1


	;
	; Initialise start coordinates
	;
	ldx x1
	ldy y1

	;
	; Initialise screen pointer
	;
	lda _HiresAddrLow,y
	sta tmp0+0
	lda _HiresAddrHigh,y
	sta tmp0+1

	ldy _TableDiv6,x

	;
	; Draw loop
	;
outer_loop

.(
	lda (tmp0),y
	eor _TableBit6Reverse,x
	sta (tmp0),y
.)

inner_loop
	lda 1+e
	bmi end_inner_loop

_inner_patch
	inx

	ldy _TableDiv6,x

	; e=e-2*dx
	sec
	lda e
_path_e_dx_0
	sbc #0
	sta e
	lda 1+e
_path_e_dx_1
	sbc #0
	sta 1+e

	bpl _inner_patch
end_inner_loop

	; Update screen adress
_patch_screen_clc
	clc
	lda tmp0+0
_patch_screen_adc
	adc #40
	sta tmp0+0
_patch_screen_bcc
	bcc skip
_patch_screen_inc
	inc tmp0+1
skip

	; e=e+2*dy
	clc
	lda e
_path_e_dy_0
	adc #0
	sta e
	lda 1+e
_path_e_dy_1
	adc #0
	sta 1+e

	dec i
	bne outer_loop

end_line
.)
	rts





						


