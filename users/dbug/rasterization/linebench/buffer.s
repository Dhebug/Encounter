

	.zero
	
;	*= tmp1
	
e				.dsb 2	; Error decision factor (slope) 2 bytes in zero page
i				.dsb 1	; Number of pixels to draw (iteration counter) 1 byte in zp
dx				.dsb 1	; Width
dy				.dsb 1	; Height
_CurrentPixelX	.dsb 1
_CurrentPixelY	.dsb 1
_OtherPixelX	.dsb 1
_OtherPixelY	.dsb 1
	
	.text
	
	.dsb 256-(*&255)


;
; This code is used when the things are moving faster
; horizontally than vertically 
;
; dx<dy
;
draw_nearly_horizontal
.(
	; here we have DY in Y, and the OPCODE in A
	sta _outer_patch	; Write a (dex / nop / inx) instruction
	
	;
	; Initialize counter to dx+1
	;
	ldx dx
	inx
	stx i

	; Initialise e=dy*2-dx
	lda dy
	asl
	sta _path_e_dy_0+1	; dy
	sta e
	lda #0
	rol
	sta _path_e_dy_1+1	; dy+1
	sta 1+e

	sec
	lda e
	sbc dx
	sta e
	lda 1+e
	sbc #0
	sta 1+e

	; Compute dx*2
	lda dx
	asl
	sta _path_e_dx_0+1	;dx
	lda #0
	rol
	sta _path_e_dx_1+1	;dx+1

	;
	; Draw loop
	;
	ldx _CurrentPixelX
	ldy _TableDiv6,x
	sec
outer_loop
	lda _TableBit6Reverse,x		; 4
	eor (tmp0),y				; 5
	sta (tmp0),y				; 6

	lda 1+e
	bmi end_inner_loop

	; e=e-2*dx
	;sec
	lda e
_path_e_dx_0
	sbc #0
	sta e
	lda 1+e
_path_e_dx_1
	sbc #0
	sta 1+e
	
	; Update screen adress
	;clc					; 2
	lda tmp0+0			; 3
	adc #40				; 2
	sta tmp0+0			; 3
	bcc skip			; 2 (+1 if taken)
	inc tmp0+1			; 5
skip
	; ------------------Min=13 Max=17


end_inner_loop

_outer_patch
	inx
	ldy _TableDiv6,x

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
	rts
.)


	
	
_DrawLine
	;jmp _DrawLine
	;
	; Compute deltas and signs
	;
	
  	; Test Y value
.(
	sec
	lda _CurrentPixelY
	sbc _OtherPixelY
	sta dy
	beq end
	bcc cur_smaller

cur_bigger					; y1>y2
	; Swap X and Y
	; So we always draw from top to bottom
	lda _CurrentPixelY
	ldx _OtherPixelY
	sta _OtherPixelY
	stx _CurrentPixelY

	lda _CurrentPixelX
	ldx _OtherPixelX
	sta _OtherPixelX
	stx _CurrentPixelX
		
	jmp end
	
cur_smaller					; y1<y2
	; Absolute value
	eor #$ff
	adc #1
	sta dy
end
.)
	
	;
	; Initialise screen pointer
	;
	ldy _CurrentPixelY
	lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

  	; Test X value
.(
	sec
	lda _CurrentPixelX
	sbc _OtherPixelX
	sta dx
	beq draw_totaly_vertical
	bcc cur_smaller

cur_bigger					; x1>x2
	lda #$ca	; 0 DEC
	bne end

cur_smaller					; x1<x2
	; Absolute value
	eor #$ff
	adc #1
	sta dx
	
	lda #$e8	; 2 INC
end
.)

	; Compute slope and call the specialized code for mostly horizontal or vertical lines
	ldy dy
	beq draw_totaly_horizontal
	cpy dx
	bcs draw_nearly_vertical
	jmp draw_nearly_horizontal

draw_totaly_horizontal
.(
	; here we have DY in Y, and the OPCODE in A
	sta _outer_patch	; Write a (dex / nop / inx) instruction
	
	;
	; Initialize counter to dx+1
	;
	ldx dx
	inx
	stx i

	
	ldx _CurrentPixelX
	
	;
	; Draw loop
	;
outer_loop
	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
	eor (tmp0),y				; 5
	sta (tmp0),y				; 6

_outer_patch
	inx

	dec i
	bne outer_loop
	rts
.)	
	
draw_totaly_vertical
.(
	ldx _CurrentPixelX
	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
	sta _mask_patch+1
	
	ldx dy
	inx
	
	clc							; 2
loop
_mask_patch
	lda #0						; 2
	eor (tmp0),y				; 5
	sta (tmp0),y				; 6 => total = 13 cycles

	; Update screen adress
	lda tmp0+0					; 3
	adc #40						; 2
	sta tmp0+0					; 3
	bcc skip					; 2 (+1 if taken)
	inc tmp0+1					; 5
	clc							; 2
skip
	; ------------------Min=13 Max=17

	dex
	bne loop
	rts
.)
		
	;.dsb 256-(*&255)
	
;
; This code is used when the things are moving faster
; vertically than horizontally
;
; dy>dx
;
draw_nearly_vertical
	;jmp draw_nearly_vertical
.(	
	; here we have DY in Y, and the OPCODE in A
	sta _inner_patch	; Write a (dex / nop / inx) instruction
	; just increment en store to know the number of iterations
	iny
	sty i


	; Compute dx*2	
	lda dy
	asl
	sta _path_e_dx_0+1	;dx
	lda #0
	rol
	sta _path_e_dx_1+1	;dx+1
	
		
	; Normaly we should have swapped DX and DY, but instead just swap in the usage is more efficient
	; Initialise e
	lda dx
	asl
	sta _path_e_dy_0+1	; dy
	sta e
	lda #0
	rol
	sta _path_e_dy_1+1	; dy+1
	sta 1+e

	ldx _CurrentPixelX
	ldy _TableDiv6,x
	
	sec
	lda e
	sbc dy
	sta e
	lda 1+e
	sbc #0
	sta 1+e
	bmi end_inner_loop2	; n=1 ?
	
	;
	; Draw loop
	;
outer_loop
	lda _TableBit6Reverse,x		; 4
	eor (tmp0),y				; 5
	sta (tmp0),y				; 6
	; --------------------------=15

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

end_inner_loop

	dec i
	beq done

	.(
	; Update screen adress
	;clc					; 2
	lda tmp0+0			; 3
	adc #40				; 2
	sta tmp0+0			; 3
	bcc skip			; 2 (+1 if taken)
	inc tmp0+1			; 5
	clc
skip
	; ------------------Min=13 Max=17
	.)

	; e=e+2*dy
	lda e
_path_e_dy_0
	adc #0
	sta e
	lda 1+e
_path_e_dy_1
	adc #0
	sta 1+e
	bpl outer_loop

end_inner_loop2		
	lda _TableBit6Reverse,x		; 4
	eor (tmp0),y				; 5
	sta (tmp0),y				; 6
	; --------------------------=15
	
	bne end_inner_loop
	
done	
	rts
.)


