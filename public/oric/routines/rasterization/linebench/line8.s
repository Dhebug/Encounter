; History of timings...
;649
;614 (replacing the update of tmp0)
;607

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
save_y			.dsb 1

	.text
	
	.dsb 256-(*&255)

; nop $ea
; inx $e8 11101000
; dex $ca 11001010
; iny $c8 11001000
; dey $88 10001000



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
	.(
	lda tmp0+0					; 3
	adc #40						; 2
	sta tmp0+0					; 3
	bcc skip					; 2 (+1 if taken)
	inc tmp0+1					; 5
	clc							; 2
skip
	.)
	; ------------------Min=13 Max=17

	dex
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
	;
	; Compute deltas and signs
	;
	
  	; Test Y value
.(
	sec
	lda _CurrentPixelY
	sbc _OtherPixelY
	beq end
	bcc cur_smaller

cur_bigger					; y1>y2
	; Swap X and Y
	; So we always draw from top to bottom
	ldy _CurrentPixelY
	ldx _OtherPixelY
	sty _OtherPixelY
	stx _CurrentPixelY

	ldy _CurrentPixelX
	ldx _OtherPixelX
	sty _OtherPixelX
	stx _CurrentPixelX
		
	jmp end
	
cur_smaller					; y1<y2
	; Absolute value
	eor #$ff
	adc #1
end
	sta dy
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
	sta save_a				; 3
	
	jmp draw_pixel
		
loop 
__auto_stepx
	inx             		; Step in x
	lda save_a				; 3
__auto_ady
	adc #00					; 2 +DY
	sta save_a				; 3
	bcc draw_pixel 			; Time to step in y?
	
__auto_dx   
	sbc #00     			; 2 -DX
	sta save_a				; 3
	
	; Set the new screen adress
	.(
	lda tmp0+0			; 3
	adc #40				; 2
	sta tmp0+0			; 3
	bcc skip			; 2 (+1 if taken)
	inc tmp0+1			; 5
skip
	.)
	 
draw_pixel
	; Draw the pixel
	ldy _TableDiv6,x
	lda _TableBit6Reverse,x
	eor (tmp0),y
	sta (tmp0),y
  
__auto_cpx
	cpx #00					; At the endpoint yet?
	bne loop
	rts	
	.)			
	
draw_totaly_horizontal_8
.(
	; here we have DY in Y, and the OPCODE in A
	sta _outer_patch	; Write a (dex / nop / inx) instruction
	
	ldx _OtherPixelX
	sta __auto_cpx+1
	
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

__auto_cpx	
	cpx #00					; At the endpoint yet?
	bne outer_loop
	rts
.)	
	
	
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
	sty __auto_dy+1

	lda dx
	sta __auto_adx+1
		
	lda _OtherPixelY
	sta __auto_cpy+1
	
	ldx _CurrentPixelX   	;Plotting coordinates
	ldy _CurrentPixelY   	;in X and Y
	
	lda #00     			;Saves us a CMP
	sec
	sbc dx					; -DX
		
	jmp draw_pixel
	
loop 
	iny             		; Step in y
__auto_adx
	adc #00					; +DX
	bcc skip    			; Time to step in x?
	
__auto_stepx
	inx            			; Step in x
		
__auto_dy  
	sbc #00     			; -DY
 
skip 
	; Set the new screen adress
	sta save_a
	.(
	; Update screen adress
	lda tmp0+0					; 3
	adc #40						; 2
	sta tmp0+0					; 3
	bcc skip2					; 2 (+1 if taken)
	inc tmp0+1					; 5
	clc							; 2
skip2
	.)

draw_pixel	
	; Draw the pixel
	sty save_y
	ldy _TableDiv6,x
	lda _TableBit6Reverse,x
	eor (tmp0),y
	sta (tmp0),y
	lda save_a
	ldy save_y
  
__auto_cpy
	cpy #00				; At the endpoint yet?
	bne loop
	rts	
	.)
