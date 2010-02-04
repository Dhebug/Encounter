; History of timings...
; Using (10,160)
;1186
;1136
;993
;949
;874
;840
;820
;801
;785
;....
; Using (120,100)
;845
; Using clipping to 10/190 vertically
;827
;754

#include "params.h"


	.zero
X1			.byt 0
Y1			.byt 0

save_y		.dsb 1

; Circle centre and radius
_CentreY	.word 0
_CentreX	.word 0
_Radius		.word 0

; Variables for circlepoints
sy    		.word 0
sx    		.word 0
p 			.word 0

cxmx		.dsb 2
cxpx		.dsb 2
cxmy		.dsb 2
cxpy		.dsb 2
cymx		.dsb 2
cypx		.dsb 2
cymy		.dsb 2
cypy		.dsb 2


	.text

circleExit
 rts
	 
_circleMidpoint
.(
    ; Check if circle is visible
    ;;  _CentreX + _Radius < lhs of screen fails
    lda _CentreX
    clc
    adc _Radius
	tay
	lda _CentreX+1
	adc _Radius+1
	cpy #(CLIP_LEFT)
	sbc #0
.(
	bvc ret
	eor #$80
ret
.)

	bmi circleExit 

    ;;  x - size > rhs of screen fails 
    lda _CentreX
    sec
    sbc _Radius
	tay
    lda _CentreX+1
    sbc _Radius+1
    cpy #(CLIP_RIGHT-1)
    sbc #0
.(
    bvc ret ; N eor V
    eor #$80
ret
.)

	bpl circleExit 

    ;;  y + size < top of screen fails
    lda _CentreY
    clc
    adc _Radius
	tay
	lda _CentreY+1
    adc _Radius+1
    cpy #(CLIP_TOP)
    sbc #0
.(
    bvc ret ; N eor V
    eor #$80
ret
.)
    
	bmi circleExit 

    ;;  y - size > bot of screen fails
    lda _CentreY
    sec
    sbc _Radius
	tay
    lda _CentreY+1
    sbc _Radius+1
    cpy #(CLIP_BOTTOM-1)
    sbc #0
.(
    bvc ret ; N eor V
    eor #$80
ret
.)
	bpl circleExit 

drawit
     ;x=0;y=radius
    lda #0
    sta sx
    sta sx+1
    lda _Radius
    sta sy
    lda _Radius+1
    sta sy+1   
 
    ; p=1-radius
    lda #1
    sec
    sbc _Radius
    sta p
    lda #0
    sbc _Radius+1
    sta p+1
    
    
    ; Init cx and co
    lda _CentreX
    sta cxmx
    sta cxpx
    lda _CentreX+1
    sta cxmx+1
    sta cxpx+1

    lda _CentreY
    sta cymx
    sta cypx
    lda _CentreY+1
    sta cymx+1
    sta cypx+1

    clc
    lda _CentreX
    adc _Radius
    sta cxpy
    lda _CentreX+1
    adc _Radius+1
    sta cxpy+1
        
    sec
    lda _CentreX
    sbc _Radius
    sta cxmy
    lda _CentreX+1
    sbc _Radius+1
    sta cxmy+1

    clc
    lda _CentreY
    adc _Radius
    sta cypy
    lda _CentreY+1
    adc _Radius+1
    sta cypy+1
        
    sec
    lda _CentreY
    sbc _Radius
    sta cymy
    lda _CentreY+1
    sbc _Radius+1
    sta cymy+1
        
    
draw
   ; circlePoints (xCenter, yCenter, x, y);
    jmp _circlePoints
.)

circleExit2
 rts

 
    ;while (x < y) {
    ;    x++;
    ;    if (p < 0) 
    ;      p += 2 * x + 1;
    ;    else {
    ;      y--;
    ;      p += 2 * (x - y) + 1;
    ;    }
    ;    circlePoints (xCenter, yCenter, x, y);
    ;  }

	;.dsb 256-(*&255) 825 with, 822 without Oo
  
loop
.(
    sec
    lda sx 
    sbc sy
    lda sx+1
    sbc sy+1
	bpl circleExit2

	/*  
	cxmx		.dsb 2
	cymx		.dsb 2
	cxpx		.dsb 2
	cypx		.dsb 2
	*/

	.(
	inc cxpx
	bne skip
	inc cxpx+1
skip	
	.)	
	
	.(
	inc cypx
	bne skip
	inc cypx+1
skip
	.)	

	.(
	lda cxmx
	bne skip
	dec cxmx+1
skip
	dec cxmx
	.)	
	
	.(
	lda cymx
	bne skip
	dec cymx+1
skip
	dec cymx
	.)	
			
    inc sx
    bne noinc
    inc sx+1
noinc

    lda p+1
    bpl positivep
    
    lda sx
    asl
    sta tmp
    lda sx+1
    rol
    sta tmp+1

    inc tmp
    bne noinc2
    inc tmp+1
noinc2    
    lda p
    clc
    adc tmp
    sta p
    lda p+1
    adc tmp+1
    sta p+1
    
    jmp _circlePoints

positivep    
	/*
	cymy		.dsb 2
	cypy		.dsb 2
	cxmy		.dsb 2
	cxpy		.dsb 2
	*/	

	.(
	inc cymy
	bne skip
	inc cymy+1
skip	
	.)	
	
	.(
	inc cxmy
	bne skip
	inc cxmy+1
skip
	.)	

	.(
	lda cypy
	bne skip
	dec cypy+1
skip
	dec cypy
	.)	
	
	.(
	lda cxpy
	bne skip
	dec cxpy+1
skip
	dec cxpy
	.)	
	
    lda sy
    bne nodec
    dec sy+1
nodec
    dec sy

    lda sx
    sec
    sbc sy
    sta tmp
    lda sx+1
    sbc sy+1
    sta tmp+1

    asl tmp
    rol tmp+1

    inc tmp
    bne noinc3
    inc tmp+1
noinc3   

    lda p
    clc
    adc tmp
    sta p
    lda p+1
    adc tmp+1
    sta p+1
   
    ;jmp _circlePoints

.)

_circlePoints
.(
    ; Calculate _CentreY+y
    ldy cypy
    lda cypy+1
    sta Y1
    
    ; Calculate _CentreX+x    
    ldx cxpx
    lda cxpx+1
	ora Y1
	bne skip1

.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty save_y
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
    ora (tmp0),y
    sta (tmp0),y
	ldy save_y
end

.)


skip1
    ; Calculate _CentreY+y (already done)    
    ; Calculate _CentreX-x  
    
    ldx cxmx
    lda cxmx+1
	ora Y1
    sta X1
	ora Y1
	bne skip2
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
    ora (tmp0),y
    sta (tmp0),y
end

.)

skip2
    ; Calculate _CentreY-y
    ldy cymy
    lda cymy+1
    sta Y1
   	ora X1
	bne skip3

    ; Calculate _CentreX-x (already done)
	 
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty save_y
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
    ora (tmp0),y
    sta (tmp0),y
	ldy save_y
end

.)

skip3
    ; Calculate _CentreY-y (already done)
    ; Calculate _CentreX+x
    ldx cxpx
    lda cxpx+1
    sta X1
   	ora Y1
	bne skip4
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
    ora (tmp0),y
    sta (tmp0),y
end

.)

skip4
    ; Calculate _CentreY+x 
    ldy cypx
    lda cypx+1
    sta Y1
    
    ; Calculate _CentreX+y    
    ldx cxpy
    lda cxpy+1
    ORA Y1
	bne skip5
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty save_y
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
    ora (tmp0),y
    sta (tmp0),y
	ldy save_y
end

.)

skip5
    ; Calculate _CentreX+y (already done)
    ; Calculate _CentreX-y
    ldx cxmy
    lda cxmy+1
    sta X1
 	ora Y1
	bne skip6
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty save_y
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
    ora (tmp0),y
    sta (tmp0),y
	ldy save_y
end

.)

skip6
    ; Calculate _CentreX-y (already done)
    ; Calculate _CentreY-x  
    ldy cymx
    lda cymx+1
    sta Y1
 	ora X1
	bne skip7
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty save_y
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
    ora (tmp0),y
    sta (tmp0),y
	ldy save_y
end

.)

skip7
    ; Calculate _CentreY-x (already done)
    ; Calculate _CentreX+y
    ldx cxpy
    lda cxpy+1
	ora Y1
	bne skip8
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
    ora (tmp0),y
    sta (tmp0),y
end

.)

skip8
    jmp loop
.)

