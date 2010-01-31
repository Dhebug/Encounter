

	.zero
	
;	*= tmp1
	
;e				.dsb 2	; Error decision factor (slope) 2 bytes in zero page
;i				.dsb 1	; Number of pixels to draw (iteration counter) 1 byte in zp
;dx				.dsb 1	; Width
;dy				.dsb 1	; Height
;_CurrentPixelX	.dsb 1
;_CurrentPixelY	.dsb 1
;_OtherPixelX	.dsb 1
;_OtherPixelY	.dsb 1
	
save_a			.dsb 1
save_x			.dsb 1
save_y			.dsb 1

	.text
	
	.dsb 256-(*&255)

; nop $ea
; inx $e8 11101000
; dex $ca 11001010
; iny $c8 11001000
; dey $88 10001000

	

draw_nearly_horizontal_8 
	.(
	; here we have DY in Y, and the OPCODE in A
	sta __auto_stepx	; Write a (dex / nop / inx) instruction
	sty __auto_ady+1
	
	lda dx
	sta __auto_dx+1
	
	lda _OtherPixelX
	sta __auto_cpx+1
	
	ldx _CurrentPixelX   	;Plotting coordinates
	ldy _CurrentPixelY   	;in X and Y
	
	lda #00     			;Saves us a CMP
	sec
	sbc dy					; -DY
	
	; Draw the first pixel
	sta save_a
	sty save_y
	ldy _TableDiv6,x
	lda _TableBit6Reverse,x
	eor (tmp0),y
	sta (tmp0),y
	lda save_a
	ldy save_y
	
	clc
	beq test_done
loop 
__auto_stepx
	inx             		; Step in x
__auto_ady
	adc #00					; +DY
	bcc NOPE    			; Time to step in y?
	iny            			; Step in y
	
	; Set the new screen adress
	sta save_a
	lda _HiresAddrLow,y
	sta tmp0+0
	lda _HiresAddrHigh,y
	sta tmp0+1
	lda save_a
	
__auto_dx   
	sbc #00     			; -DX
 
NOPE 
	; Draw the pixel
	sta save_a
	sty save_y
	ldy _TableDiv6,x
	lda _TableBit6Reverse,x
	eor (tmp0),y
	sta (tmp0),y
	lda save_a
	ldy save_y
  
test_done	
__auto_cpx
	cpx #00				; At the endpoint yet?
	bne loop
	rts	
	.)

	
;
; Expects the following variables to be set when called:
; _CurrentPixelX
; _CurrentPixelY
; _OtherPixelX
; _OtherPixelY
;	
_DrawLine8
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
	beq draw_totaly_vertical_8
	bcc cur_smaller

cur_bigger					; x1>x2
	lda #$ca				; dex
	bne end

cur_smaller					; x1<x2
	; Absolute value
	eor #$ff
	adc #1
	sta dx
	
	lda #$e8				; inx
end
.)

	; Compute slope and call the specialized code for mostly horizontal or vertical lines
	ldy dy
	beq draw_totaly_horizontal_8
	cpy dx
	bcs draw_nearly_vertical_8
	jmp draw_nearly_horizontal_8

draw_totaly_horizontal_8
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
	
draw_totaly_vertical_8
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
draw_nearly_vertical_8 
	.(
	; here we have DY in Y, and the OPCODE in A
	sta __auto_stepx	; Write a (dex / nop / inx) instruction
	
	lda dy
	sta __auto_dy+1

	lda dx
	sta __auto_adx+1
		
	lda _OtherPixelY
	sta __auto_cpy+1
	
	ldx _CurrentPixelX   	;Plotting coordinates
	ldy _CurrentPixelY   	;in X and Y
	
	lda #00     			;Saves us a CMP
	sec
	sbc dx					; -DX
	
	; Draw the first pixel
	sta save_a
	sty save_y
	ldy _TableDiv6,x
	lda _TableBit6Reverse,x
	eor (tmp0),y
	sta (tmp0),y
	lda save_a
	ldy save_y
	
	clc
	beq test_done
loop 
	iny             		; Step in y
__auto_adx
	adc #00					; +DX
	bcc NOPE    			; Time to step in x?
	
__auto_stepx
	inx            			; Step in x
		
__auto_dy  
	sbc #00     			; -DY
 
NOPE 
	; Set the new screen adress
	sta save_a
	lda _HiresAddrLow,y
	sta tmp0+0
	lda _HiresAddrHigh,y
	sta tmp0+1

	; Draw the pixel
	sty save_y
	ldy _TableDiv6,x
	lda _TableBit6Reverse,x
	eor (tmp0),y
	sta (tmp0),y
	lda save_a
	ldy save_y
  
test_done	
__auto_cpy
	cpy #00				; At the endpoint yet?
	bne loop
	rts	
	.)
