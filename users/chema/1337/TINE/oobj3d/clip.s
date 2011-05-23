
#include "params.h"

#ifdef FILLEDPOLYS
	;.zero

#define _LargeX0	X1
#define _LargeY0	Y1
#define _LargeX1	X2
#define _LargeY1	Y2

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

	
_Break
	jmp _Break
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
	lda _LargeY1+1
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
		sta _X0
		lda _LargeY0
		sta _Y0
		lda _LargeX1
		sta _X1
		lda _LargeY1
		sta _Y1

		jsr _AddLineASM
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
		
		lda _ClipCode0
		beq clip_second_point
		jmp clip_first_point
end_clip_bottom

		lsr 
		bcc end_clip_top
		; Clip top
		ldx #CLIP_TOP
		jsr _ClipDichoTopBottom
		
		lda _ClipCode0
		beq clip_second_point
		jmp clip_first_point
end_clip_top

		lsr 
		bcc end_clip_right
		; Clip right
		ldx #CLIP_RIGHT
		jsr _ClipDichoLeftRight  
		
		lda _ClipCode0
		beq clip_second_point_poly
		jmp clip_first_point_poly
end_clip_right

		lsr 
		bcc end_clip_left
		; Clip left
		ldx #CLIP_LEFT
		jsr _ClipDichoLeftRight        
		lda _ClipCode0
		beq clip_second_point_poly
		jmp clip_first_point_poly
end_clip_left

		
	; First endpoint was clipped
clip_first_point_poly
	; Draw a vertical line for the clipped part
	lda _LargeX
	sta _X0
	lda _LargeY
	sta _Y0
	lda _LargeX
	sta _X1
	lda _LargeY0
	sta _Y1

	jsr _AddLineASM

clip_first_point
	; Then standard clipping
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

	; Second endpoint was clipped
clip_second_point_poly
	; Draw a vertical line for the clipped part
	lda _LargeX
	sta _X0
	lda _LargeY
	sta _Y0
	lda _LargeX
	sta _X1
	lda _LargeY1
	sta _Y1

	jsr _AddLineASM

clip_second_point		
	; Then standard clipping
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


#endif

