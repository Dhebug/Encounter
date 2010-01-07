#include "params.h"

#ifndef FILLEDPOLYS


;#define e	tmp1	; 2 bytes in zero page
;#define i	tmp1+2	; 1 byte in zp
;#define dx	tmp1+9
;#define dy	tmp1+10

.zero
	
;	*= 52
;_CurrentPixelX	.dsb 1
;_CurrentPixelY	.dsb 1
;_OtherPixelX	.dsb 1
;_OtherPixelY	.dsb 1
;	*= tmp1
	
e				.dsb 2	; Error decision factor (slope) 2 bytes in zero page
i				.dsb 1	; Number of pixels to draw (iteration counter) 1 byte in zp
dx				.dsb 1	; Width
dy				.dsb 1	; Height
_CurrentPixelX	.dsb 1
_CurrentPixelY	.dsb 1
_OtherPixelX	.dsb 1
_OtherPixelY	.dsb 1


#define _LargeX0	X1
#define _LargeY0	Y1
#define _LargeX1	X2
#define _LargeY1	Y2

;_LargeX0		.dsb 2
;_LargeY0		.dsb 2
;_LargeX1		.dsb 2
;_LargeY1		.dsb 2

_LargeX			.dsb 2
_LargeY			.dsb 2
_ClipCode       .dsb 1
_ClipCode0		.dsb 1
_ClipCode1		.dsb 1

#ifdef USE_ACCURATE_CLIPPING
				.dsb 1
#endif				
_ClipX0         .dsb 2
#ifdef USE_ACCURATE_CLIPPING
				.dsb 1
#endif				
_ClipY0         .dsb 2
#ifdef USE_ACCURATE_CLIPPING
				.dsb 1
#endif				
_ClipX1         .dsb 2
#ifdef USE_ACCURATE_CLIPPING
				.dsb 1
#endif				
_ClipY1         .dsb 2
#ifdef USE_ACCURATE_CLIPPING
				.dsb 1
#endif				
_ClipXc         .dsb 2
#ifdef USE_ACCURATE_CLIPPING
				.dsb 1
#endif				
_ClipYc         .dsb 2

	

	
	.text

; Have 4 free bytes here )

;; To include double-buffer (on and off)
double_buff .byt $ff


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
	;eor (tmp0),y				; 5
    ora (tmp0),y				; 5
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
	;eor (tmp0),y				; 5
    ora (tmp0),y				; 5
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
	;eor (tmp0),y				; 5
    ora (tmp0),y
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
		
.dsb 256-(*&255)
	
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
	;eor (tmp0),y				; 5
    ora (tmp0),y				; 5
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

;;;;;;;;; SOLVING EXTRA PIXEL BUG
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
	
;;;;;;;;; SOLVING EXTRA PIXEL BUG

;	bmi end_inner_loop2	; n=1 ?

	bpl outer_loop

;	dec i
;	bne outer_loop
;	rts

end_inner_loop2		
	lda _TableBit6Reverse,x		; 4
	;eor (tmp0),y				; 5
    ora (tmp0),y				; 5
	sta (tmp0),y				; 6
	; --------------------------=15

;	dec i						; 5
	bne end_inner_loop

done	
	rts
.)



_GenerateTables
.(

	; Generate screen offset data
.(
    lda double_buff
    beq toscreen
    
    lda #<buffer
	sta tmp0+0
	lda #>buffer
	sta tmp0+1
    jmp nextstep
toscreen
    lda #<$a000
    sta tmp0+0
	lda #>$a000
    sta tmp0+1
nextstep

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





_ClipComputeMidPoint
.(	
	;	xc=(x0+x1)>>1;
	clc
#ifdef USE_ACCURATE_CLIPPING
	lda _ClipX0-1
	adc _ClipX1-1
	sta _ClipXc-1
#endif
	lda _ClipX0+0
	adc _ClipX1+0
	sta _ClipXc+0

	lda _ClipX0+1
	adc _ClipX1+1
	sta _ClipXc+1
	
	lda _ClipXc+1
	cmp #$80
	ror _ClipXc+1
	ror _ClipXc+0
#ifdef USE_ACCURATE_CLIPPING
	ror _ClipXc-1
#endif

	;	yc=(y0+y1)>>1;
	clc
#ifdef USE_ACCURATE_CLIPPING
	lda _ClipY0-1
	adc _ClipY1-1
	sta _ClipYc-1
#endif
	lda _ClipY0+0
	adc _ClipY1+0
	sta _ClipYc+0

	lda _ClipY0+1
	adc _ClipY1+1
	sta _ClipYc+1
	
	lda _ClipYc+1
	cmp #$80
	ror _ClipYc+1
	ror _ClipYc+0
#ifdef USE_ACCURATE_CLIPPING
	ror _ClipYc-1	
#endif
	rts
.)

_ClipMoveP1
.(
	; x1=xc;
	lda _ClipXc+0
	sta _ClipX1+0
	lda _ClipXc+1
	sta _ClipX1+1
#ifdef USE_ACCURATE_CLIPPING
	lda _ClipXc-1
	sta _ClipX1-1
#endif
	
	; y1=yc;
	lda _ClipYc+0
	sta _ClipY1+0
	lda _ClipYc+1
	sta _ClipY1+1
#ifdef USE_ACCURATE_CLIPPING
	lda _ClipYc-1
	sta _ClipY1-1
#endif	
	rts
.)

_ClipMoveP0	
.(
	; x0=xc;
	lda _ClipXc+0
	sta _ClipX0+0
	lda _ClipXc+1
	sta _ClipX0+1
#ifdef USE_ACCURATE_CLIPPING
	lda _ClipXc-1
	sta _ClipX0-1
#endif	

	; y0=yc;
	lda _ClipYc+0
	sta _ClipY0+0
	lda _ClipYc+1
	sta _ClipY0+1
#ifdef USE_ACCURATE_CLIPPING
	lda _ClipYc-1
	sta _ClipY0-1
#endif	
	rts
.)
	

_ClipReturnPc
.(
	; LargeX=ClipXc;
	lda _ClipXc+0
	sta _LargeX+0
	lda _ClipXc+1
	sta _LargeX+1

	; LargeY=ClipYc;
	lda _ClipYc+0
	sta _LargeY+0
	lda _ClipYc+1
	sta _LargeY+1

	rts
.)

_ClipReturnP0
.(
	; LargeX=LargeX0;
	lda _LargeX0+0
	sta _LargeX+0
	lda _LargeX0+1
	sta _LargeX+1

	; LargeY=LargeY0;
	lda _LargeY0+0
	sta _LargeY+0
	lda _LargeY0+1
	sta _LargeY+1

	rts
.)

_ClipReturnP1
.(
	; LargeX=LargeX1;
	lda _LargeX1+0
	sta _LargeX+0
	lda _LargeX1+1
	sta _LargeX+1

	; LargeY=LargeY1;
	lda _LargeY1+0
	sta _LargeY+0
	lda _LargeY+1
	sta _LargeY+1

	rts
.)

_ClipSetNormalStartPoints
.(
	;	x0=LargeX0;
	;	y0=LargeY0;
	lda _LargeX0+0
	sta _ClipX0+0
	lda _LargeX0+1
	sta _ClipX0+1

	lda _LargeY0+0
	sta _ClipY0+0
	lda _LargeY0+1
	sta _ClipY0+1
		
	;	x1=LargeX1;	
	;	y1=LargeY1;
	lda _LargeX1+0
	sta _ClipX1+0
	lda _LargeX1+1
	sta _ClipX1+1

	lda _LargeY1+0
	sta _ClipY1+0
	lda _LargeY1+1
	sta _ClipY1+1

	rts
.)

_ClipSetInvertedStartPoints
.(	
	;	x0=LargeX1;
	;	y0=LargeY1;
	lda _LargeX1+0
	sta _ClipX0+0
	lda _LargeX1+1
	sta _ClipX0+1

	lda _LargeY1+0
	sta _ClipY0+0
	lda _LargeY1+1
	sta _ClipY0+1
		
	;	x1=LargeX0;	
	;	y1=LargeY0;
	lda _LargeX0+0
	sta _ClipX1+0
	lda _LargeX0+1
	sta _ClipX1+1

	lda _LargeY0+0
	sta _ClipY1+0
	lda _LargeY0+1
	sta _ClipY1+1
	
	rts
.)


_ClipDichoTopBottom
.(
	.(	
	; if (LargeY0==CLIP_TOP)
	cpx _LargeY0+0
	bne skip
	lda _LargeY0+1
	bne skip
	jmp _ClipReturnP0
skip
	.)

	.(
	; if (LargeY1==CLIP_TOP)
	cpx _LargeY1+0
	bne skip
	lda _LargeY1+1
	bne skip
	jmp _ClipReturnP1
skip
	.)
			
	sec
	lda _LargeY0+0
	sbc _LargeY1+0
	lda _LargeY0+1
	sbc _LargeY1+1
	bmi label4

label3
	; (LargeY0>=LargeY1)
	jsr _ClipSetInvertedStartPoints
	jmp end_swap
	
label4
	; (LargeY0<LargeY1)
	jsr _ClipSetNormalStartPoints
			
end_swap

#ifdef USE_ACCURATE_CLIPPING
	lda #0
	sta _ClipX0-1
	sta _ClipY0-1
	sta _ClipX1-1
	sta _ClipY1-1
#endif	
	
loop
	jsr _ClipComputeMidPoint	
	
	;	if (yc==CLIP_TOP)	
	cpx _ClipYc+0
	bne not_done 	
	lda _ClipYc+1
	beq done 	
		
not_done

	sec
	txa
	sbc _ClipYc+0
	lda #0
	sbc _ClipYc+1
	bmi replace_first
		
replace_second
	; if (yc<CLIP_TOP)
	jsr _ClipMoveP0	
	jmp loop	
	
replace_first	
	; if (yc>CLIP_TOP)
	jsr _ClipMoveP1
	jmp loop	
	
done
	; Finished !
	jmp _ClipReturnPc
.)			


_ClipDichoLeftRight
.(
	.(	
	; if (LargeX0==CLIP_LEFT/RIGHT)
	cpx _LargeX0+0
	bne skip
	lda _LargeX0+1
	bne skip
	jmp _ClipReturnP0
skip
	.)

	.(
	; if (LargeX1==CLIP_LEFT/RIGHT)
	cpx _LargeX1+0
	bne skip
	lda _LargeX1+1
	bne skip
	jmp _ClipReturnP1
skip
	.)
			
	sec
	lda _LargeX0+0
	sbc _LargeX1+0
	lda _LargeX0+1
	sbc _LargeX1+1
	bmi label4

label3
	; (LargeX0>=LargeX1)
	jsr _ClipSetInvertedStartPoints
	jmp end_swap
	
label4
	; (LargeX0<LargeX1)
	jsr _ClipSetNormalStartPoints
			
end_swap

#ifdef USE_ACCURATE_CLIPPING
	lda #0
	sta _ClipX0-1
	sta _ClipY0-1
	sta _ClipX1-1
	sta _ClipY1-1
#endif	
	
loop
	jsr _ClipComputeMidPoint	
	
	;	if (xc==CLIP_LEFT/RIGHT)	
	cpx _ClipXc+0
	bne not_done 	
	lda _ClipXc+1
	beq done 	
		
not_done

	sec
	txa
	sbc _ClipXc+0
	lda #0
	sbc _ClipXc+1
	bmi replace_first
		
replace_second
	; if (xc<CLIP_LEFT/RIGHT)
	jsr _ClipMoveP0	
	jmp loop	
	
replace_first	
	; if (xc>CLIP_LEFT/RIGHT)
	jsr _ClipMoveP1
	jmp loop	
	
done
	; Finished !
	jmp _ClipReturnPc
.)			




;
; In this code, we assume that the CLIP_ values are fitting
; the resolution of an Oric screen, so they will never be out
; of a 240x200 screen resolution, fit in an unsigned byte.
;
_ClipFindRegion
	;jmp _ClipFindRegion
.(
	; Initialize with 'not clipped'
	lda #0
	
	;
	; Bottom test
	;
	.(
	ldy _LargeY+1
	bmi end_bottom	; If the high byte of Y is negative, it's certainly not clipped
	bne clip_bottom	; If it's not negative, then it needs to be clipped for sure

	ldy _LargeY+0 
	cpy #(CLIP_BOTTOM+1)	; 194
	bcc end_bottom
	
clip_bottom		
	ora #1			; Means (y >= CLIP_BOTTOM)
	
	jmp end_top		; If the end point is clipped on the bottom, it cannot be on the top side as well
	.)
end_bottom

	;
	; Top test
	;
	.(
	ldy _LargeY+1
	bmi clip_top	; If the high byte of Y is negative, it certainly needs to be clipped
	bne end_top     ; If it's not negative, then it's too large to be clipped on top
	
	ldy _LargeY+0
	cpy #CLIP_TOP		; 5
	bcs end_top
	
clip_top
	ora #2			; Means (y < CLIP_TOP)
	.)
end_top

	;
	; Righttest
	;
	.(
	ldy _LargeX+1
	bmi end_right	; If the high byte of X is negative, it's certainly not clipped
	bne clip_right	; If it's not negative, then it needs to be clipped for sure

	ldy _LargeX+0 
	cpy #(CLIP_RIGHT+1)
	bcc end_right
		
clip_right	
	ora #4			; Means (x >= CLIP_RIGHT)

	jmp end_left	; If the end point is clipped on the right, it cannot be on the left side as well
	.)
end_right

	;
	; Left test
	;
	.(
	ldy _LargeX+1
	bmi clip_left	; If the high byte of X is negative, it certainly needs to be clipped
	bne end_left    ; If it's not negative, then it's too large to be clipped on left
	
	ldy _LargeX+0
	cpy #CLIP_LEFT
	bcs end_left
	
clip_left	
	ora #8			; Means (x < CLIP_LEFT)
	.)
end_left	

	; Save the result
	sta _ClipCode
	rts
.)

    	
; Compute the outcode for the first point
_ClipComputeCode0
.(
    lda _LargeX0+0
    sta _LargeX+0
    lda _LargeX0+1
    sta _LargeX+1

    lda _LargeY0+0
    sta _LargeY+0
    lda _LargeY0+1
    sta _LargeY+1
        
    jsr _ClipFindRegion
    
    lda _ClipCode
    sta _ClipCode0
    
	rts
.)

; Compute the outcode for the second point
_ClipComputeCode1
.(
    lda _LargeX1+0
    sta _LargeX+0
    lda _LargeX1+1
    sta _LargeX+1

    lda _LargeY1+0
    sta _LargeY+0
    lda _LargeY1+1
    sta _LargeY+1
        
    jsr _ClipFindRegion
    
    lda _ClipCode
    sta _ClipCode1
    
	rts
.)

_DrawClippedLine
.(
    ; The region outcodes for the the endpoints
    jsr _ClipComputeCode0
    jsr _ClipComputeCode1
      	
    ; In theory, this can never end up in an infinite loop, it'll always come in one of the trivial cases eventually    
clip_loop

	lda _ClipCode0
	ora _ClipCode1
	bne end_trivial_draw	
	.(
		; /accept because both endpoints are in screen or on the border, trivial accept		
		lda _LargeX0
		sta _CurrentPixelX
		lda _LargeY0
		sta _CurrentPixelY
		lda _LargeX1
		sta _OtherPixelX
		lda _LargeY1
		sta _OtherPixelY
				
		jsr _DrawLine
		rts
	.)
end_trivial_draw	

	lda _ClipCode0
	and _ClipCode1
	beq end_invisible_line
	.(
		; The line isn't visible on screen, trivial reject	
		rts
	.)
end_invisible_line
		
	.(
		; if no trivial reject or accept, continue the loop
		.(
		lda _ClipCode0
		bne skip
		lda _ClipCode1
skip			
		.)				

		lsr 
		bcc end_clip_bottom
		; Clip bottom
		ldx #CLIP_BOTTOM
        jsr _ClipDichoTopBottom
		jmp end_clip_switch
end_clip_bottom

		lsr 
		bcc end_clip_top
		; Clip top
		ldx #CLIP_TOP
        jsr _ClipDichoTopBottom
		jmp end_clip_switch
end_clip_top

		lsr 
		bcc end_clip_right
		; Clip right
		ldx #CLIP_RIGHT
        jsr _ClipDichoLeftRight        
		jmp end_clip_switch
end_clip_right

		lsr 
		bcc end_clip_left
		; Clip left
		ldx #CLIP_LEFT
        jsr _ClipDichoLeftRight        
		jmp end_clip_switch
end_clip_left

end_clip_switch

	lda _ClipCode0
	beq clip_second_point
	
clip_first_point
	; First endpoint was clipped
    lda _LargeX+0
    sta _LargeX0+0
    lda _LargeX+1
    sta _LargeX0+1

    lda _LargeY+0
    sta _LargeY0+0
    lda _LargeY+1
    sta _LargeY0+1
	
    jsr _ClipComputeCode0
	
	jmp clip_loop    

clip_second_point		
	; Second endpoint was clipped
    lda _LargeX+0
    sta _LargeX1+0
    lda _LargeX+1
    sta _LargeX1+1

    lda _LargeY+0
    sta _LargeY1+0
    lda _LargeY+1
    sta _LargeY1+1
	
    jsr _ClipComputeCode1
	
	jmp clip_loop    
		
	.)

	; Not supposed to arrive here :p
	rts
.)


_DoubleBuffOn
.(
    lda double_buff
    beq _SwitchDoubleBuff
    rts
.)

_DoubleBuffOff
.(
    lda double_buff
    bne _SwitchDoubleBuff
    rts
.)


_SwitchDoubleBuff
.(

    ; Patch the circle routine
    lda patch_circleclip+1
    cmp #199
    beq clip1
    lda #199
    jmp cont
clip1
    lda #(CLIP_BOTTOM)

cont    
    sta patch_circleclip+1
    lda double_buff
    eor #$ff
    sta double_buff
    jmp _GenerateTables
.)






#undef e	
#undef i
#undef dx
#undef dy


#endif






