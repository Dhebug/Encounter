; History of timings...
;1186
;1136
;993
;949
;874
;840
;820


#include "params.h"

#define cypy tmp0
#define cymy cypy+1
#define cypx cypy+2
#define cymx cypy+3
#define cxpy cypy+4
#define cxmy cypy+5
#define cxpx cypy+6
#define cxmx cypy+7


/*
.zero
cypy .byt 0
cymy .byt 0
cypx .byt 0
cymx .byt 0
cxpy .byt 0
cxmy .byt 0
cxpx .byt 0
cxmx .byt 0
*/


.zero

X1			.byt 0
Y1			.byt 0

; Circle centre and radius
_CentreY	.word 0
_CentreX	.word 0
_Radius		.word 0

; Variables for circlepoints
sy    .word 0
sx    .word 0


xpr	.word 0
xmr .word 0
ypr .word 0
ymr .word 0
p .word 0


.text
 
_circleMidpoint
.(

    ; Check if circle is visible
    ;;  _CentreX + _Radius < lhs of screen fails
    lda _CentreX
    clc
    adc _Radius
    sta xpr
    lda _CentreX+1
    adc _Radius+1
    sta xpr+1
.(
    lda xpr 
    cmp #(CLIP_LEFT)
    lda xpr+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
	bmi circleExit 

    ;;  x - size > rhs of screen fails 
    lda _CentreX
    sec
    sbc _Radius
    sta xmr
    lda _CentreX+1
    sbc _Radius+1
    sta xmr+1
.(
    lda xmr 
    cmp #(CLIP_RIGHT-1)
    lda xmr+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
	bpl circleExit 

    ;;  y + size < top of screen fails
    lda _CentreY
    clc
    adc _Radius
    sta ypr
    lda _CentreY+1
    adc _Radius+1
    sta ypr+1
.(
    lda ypr 
    cmp #(CLIP_TOP)
    lda ypr+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
    
	bmi circleExit 

    ;;  y - size > bot of screen fails
    lda _CentreY
    sec
    sbc _Radius
    sta ymr
    lda _CentreY+1
    sbc _Radius+1
    sta ymr+1
.(
    lda ymr 
    cmp #(CLIP_BOTTOM-1)
    lda ymr+1
    sbc #0
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
    
draw
   ; circlePoints (xCenter, yCenter, x, y);
    jmp _circlePoints
.)

circleExit
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
	bpl circleExit

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
    
    lda _CentreY
    clc
    adc sy
	tay
    lda _CentreY+1
    adc sy+1
    sta Y1
    
    ; Calculate _CentreX+x
    
    lda _CentreX
    clc
    adc sx
	tax
    lda _CentreX+1
    adc sx+1
    sta X1
	ora Y1
	bne skip1
    ;jsr plotpoint   ; _CentreX+x,_CentreY+y

.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

plot 
    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty _savy+1
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4

    ora (tmp0),y
    sta (tmp0),y
_savy
	ldy #0 ;SMC	
end

.)


skip1

   ; Calculate _CentreX-x
    
    lda _CentreX
    sec
    sbc sx
	tax
    lda _CentreX+1
    sbc sx+1
    sta X1
	ora Y1
	bne skip2
    
 ;   jsr plotpoint ; _CentreX-x,_CentreY+y
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

plot 
    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty _savy+1
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4

    ora (tmp0),y
    sta (tmp0),y
_savy
	ldy #0 ;SMC	
end

.)

skip2
   ; Calculate _CentreY-y
    
    lda _CentreY
    sec
    sbc sy
	tay
    lda _CentreY+1
    sbc sy+1
    sta Y1
   	ora X1
	bne skip3
 
;    jsr plotpoint ; _CentreX-x,_CentreY-y
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

plot 
    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty _savy+1
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4

    ora (tmp0),y
    sta (tmp0),y
_savy
	ldy #0 ;SMC	
end

.)

skip3
  ; Calculate _CentreX+x
    
    lda _CentreX
    clc
    adc sx
	tax
    lda _CentreX+1
    adc sx+1
    sta X1
   	ora Y1
	bne skip4
 
;    jsr plotpoint ; _CentreX+x,_CentreY-y
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

plot 
    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty _savy+1
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4

    ora (tmp0),y
    sta (tmp0),y
_savy
	ldy #0 ;SMC	
end

.)

skip4

    ; Calculate _CentreY+x
    
    lda _CentreY
    clc
    adc sx
	tay
    lda _CentreY+1
    adc sx+1
    sta Y1
    
   ; Calculate _CentreX+y
    
    lda _CentreX
    clc
    adc sy
	tax
    lda _CentreX+1
    adc sy+1
    sta X1
 	ora Y1
	bne skip5
   
;    jsr plotpoint  ; _CentreX+y,_CentreY+x
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

plot 
    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty _savy+1
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4

    ora (tmp0),y
    sta (tmp0),y
_savy
	ldy #0 ;SMC	
end

.)

skip5
    ; Calculate _CentreX-y
    lda _CentreX
    sec
    sbc sy
	tax
    lda _CentreX+1
    sbc sy+1
    sta X1
 	ora Y1
	bne skip6
   
;    jsr plotpoint  ; _CentreX-y,_CentreY+x
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

plot 
    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty _savy+1
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4

    ora (tmp0),y
    sta (tmp0),y
_savy
	ldy #0 ;SMC	
end

.)

skip6

    ; Calculate _CentreY-x
    
    lda _CentreY
    sec
    sbc sx
	tay
    lda _CentreY+1
    sbc sx+1
    sta Y1
 	ora X1
	bne skip7
   
;    jsr plotpoint   ; _CentreX-y,_CentreY-x
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

plot 
    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty _savy+1
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4

    ora (tmp0),y
    sta (tmp0),y
_savy
	ldy #0 ;SMC	
end

.)

skip7
   ; Calculate _CentreX+y
    
    lda _CentreX
    clc
    adc sy
	tax
    lda _CentreX+1
    adc sy+1
    sta X1
	ora Y1
	bne skip8
    
;    jmp plotpoint    ; _CentreX+y,_CentreY-x
.(
	cpx #(CLIP_RIGHT)
	bcs end
	cpx #(CLIP_LEFT)
	bcc end
    cpy #(CLIP_BOTTOM)
	bcs end
    cpy #(CLIP_TOP)
	bcc end

plot 
    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

	sty _savy+1
  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4

    ora (tmp0),y
    sta (tmp0),y
_savy
	ldy #0 ;SMC	
end

.)

skip8
    jmp loop
.)









