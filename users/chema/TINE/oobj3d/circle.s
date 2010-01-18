#include "params.h"

#define cypy tmp0
#define cymy cypy+1
#define cypx cypy+2
#define cymx cypy+3
#define cxpy cypy+4
#define cxmy cypy+5
#define cxpx cypy+6
#define cxmx cypy+7

/*.zero
clipme	.byt 0
*/

#define clipme plotpoint+1

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

.text


; Circle centre and radius
cy   .word 0
cx   .word 0
rad  .word 0

#ifdef FILLEDPOLYS

_circlePoints
.(

    ; Calculate cy+y
    
    lda cy
    clc
    adc sy
    sta op1
    lda cy+1
    adc sy+1
    sta op1+1
    
    jsr clipbt
    sta cypy


    ; Calculate cy-y
    
    lda cy
    sec
    sbc sy
    sta op1
    lda cy+1
    sbc sy+1
    sta op1+1
    
    jsr clipbt
    sta cymy

    ; Calculate cy+x
    
    lda cy
    clc
    adc sx
    sta op1
    lda cy+1
    adc sx+1
    sta op1+1
    
    jsr clipbt
    sta cypx

    ; Calculate cy-x
    
    lda cy
    sec
    sbc sx
    sta op1
    lda cy+1
    sbc sx+1
    sta op1+1
    
    jsr clipbt
    sta cymx



    ; Calculate cx+y
    
    lda cx
    clc
    adc sy
    sta op1
    lda cx+1
    adc sy+1
    sta op1+1
    
    jsr cliplr
    sta cxpy


    ; Calculate cx-y
    
    lda cx
    sec
    sbc sy
    sta op1
    lda cx+1
    sbc sy+1
    sta op1+1
    
    jsr cliplr
    sta cxmy

    ; Calculate cx+x
    
    lda cx
    clc
    adc sx
    sta op1
    lda cx+1
    adc sx+1
    sta op1+1
    
    jsr cliplr
    sta cxpx

    ; Calculate cx-x
    
    lda cx
    sec
    sbc sx
    sta op1
    lda cx+1
    sbc sx+1
    sta op1+1
    
    jsr cliplr
    sta cxmx

    ; Now fill the MaxMin array

;MaxX[cy+y]=(cx+x>CLIP_RIGHT?CLIP_RIGHT:cx+x); 
;MinX[cy+y]=(cx-x<CLIP_LEFT?CLIP_LEFT:cx-x); 
;MaxX[cy-y]=(cx+x>CLIP_RIGHT?CLIP_RIGHT:cx+x); 
;MinX[cy-y]=(cx-x<CLIP_LEFT?CLIP_LEFT:cx-x); 
;MaxX[cy+x]=(cx+y>CLIP_RIGHT?CLIP_RIGHT:cx+y); 
;MinX[cy+x]=(cx-y<CLIP_LEFT?CLIP_LEFT:cx-y); 
;MaxX[cy-x]=(cx+y>CLIP_RIGHT?CLIP_RIGHT:cx+y); 
;MinX[cy-x]=(cx-y<CLIP_LEFT?CLIP_LEFT:cx-y);

    ldx cypy
    lda cxpx
    sta _MaxX,x
    lda cxmx
    sta _MinX,x

    ldx cymy
    lda cxpx
    sta _MaxX,x
    lda cxmx
    sta _MinX,x

    ldx cypx
    lda cxpy
    sta _MaxX,x
    lda cxmy
    sta _MinX,x

    ldx cymx
    lda cxpy
    sta _MaxX,x
    lda cxmy
    sta _MinX,x


    rts


.)


clipbt
.(
    ; Compare with CLIP_BOTTOM and CLIP_TOP
    lda #(CLIP_BOTTOM)
    sta op2
    lda #0
    sta op2+1
    
    jsr cmp16

    bmi cont1
    lda #(CLIP_BOTTOM)
    rts    

cont1
    lda #(CLIP_TOP)
    sta op2
    jsr cmp16
    bpl cont2
    lda #(CLIP_TOP)
    rts
cont2
    lda op1
    rts
.)

cliplr
.(
    ; Compare with CLIP_LEFT and CLIP_RIGHT
    lda #(CLIP_RIGHT)
    sta op2
    lda #0
    sta op2+1
    
    jsr cmp16

    bmi cont1
    lda #(CLIP_RIGHT)
    rts    

cont1
    lda #(CLIP_LEFT)
    sta op2
    jsr cmp16
    bpl cont2
    lda #(CLIP_LEFT)
    rts
    
cont2
    lda op1
    rts
.)



; Variables for circlepoints
sy    .word 0
sx    .word 0


_circleMidpoint
.(
    ; Check if circle is visible
    ;;  cx + rad < lhs of screen fails
    lda #CLIP_LEFT
    sta op2
    lda #0
    sta op2+1
    lda cx
    clc
    adc rad
    sta op1
    lda cx+1
    adc rad+1
    sta op1+1
    jsr cmp16
    bpl next1
    rts
next1
    ;;  x - size > rhs of screen fails 
    lda #CLIP_RIGHT-1
    sta op2
    lda #0
    sta op2+1
    lda cx
    sec
    sbc rad
    sta op1
    lda cx+1
    sbc rad+1
    sta op1+1
    jsr cmp16
    bmi next2
    rts
next2
    ;;  y + size < top of screen fails
    lda #CLIP_TOP
    sta op2
    lda #0
    sta op2+1
    lda cy
    clc
    adc rad
    sta op1
    lda cy+1
    adc rad+1
    sta op1+1
    jsr cmp16
    bpl next3
    rts
next3
    ;;  y - size > bot of screen fails
    lda #CLIP_BOTTOM-1
    sta op2
    lda #0
    sta op2+1
    lda cy
    sec
    sbc rad
    sta op1
    lda cy+1
    sbc rad+1
    sta op1+1
    jsr cmp16
    bmi next4
    rts
next4

    ;x=0;y=radius
    lda #0
    sta sx
    sta sx+1
    lda rad
    sta sy
    lda rad+1
    sta sy+1   
 
    ; p=1-radius
    lda #1
    sec
    sbc rad
    sta p
    lda #0
    sbc rad+1
    sta p+1
    
    ; PolyY0=yCenter-radius    
    lda cy
    sec
    sbc rad
    sta op1
    lda cy+1
    sbc rad+1
    sta op1+1
    jsr clipbt
    sta _PolyY0

    ; PolyY1=yCenter+radius+1

    lda cy
    sec
    adc rad
    sta op1
    lda cy+1
    adc rad+1
    sta op1+1
    jsr clipbt
    sta _PolyY1

    ; If outside, then end

    lda _PolyY0
    cmp _PolyY1
    bcc draw
    lda #0
    sta _PolyY0
    sta _PolyY1
    rts
draw
   ; circlePoints (xCenter, yCenter, x, y);
    jsr _circlePoints


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

loop
    lda sx
    sta op1
    lda sx+1
    sta op1+1
    lda sy
    sta op2
    lda sy+1
    sta op2+1
    jsr cmp16
    bpl end
    

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
    
    jsr _circlePoints
    jmp loop

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
   
    jsr _circlePoints
    jmp loop

end

    jsr _FillTablesASM
    rts


p .word 0

.)


#else
_circlePoints
.(

    ; Now fill the MaxMin array

	/*
;MaxX[cy+y]=(cx+x>CLIP_RIGHT?CLIP_RIGHT:cx+x); 
;MinX[cy+y]=(cx-x<CLIP_LEFT?CLIP_LEFT:cx-x); 
;MaxX[cy-y]=(cx+x>CLIP_RIGHT?CLIP_RIGHT:cx+x); 
;MinX[cy-y]=(cx-x<CLIP_LEFT?CLIP_LEFT:cx-x); 
;MaxX[cy+x]=(cx+y>CLIP_RIGHT?CLIP_RIGHT:cx+y); 
;MinX[cy+x]=(cx-y<CLIP_LEFT?CLIP_LEFT:cx-y); 
;MaxX[cy-x]=(cx+y>CLIP_RIGHT?CLIP_RIGHT:cx+y); 
;MinX[cy-x]=(cx-y<CLIP_LEFT?CLIP_LEFT:cx-y);
*/
    ; Calculate cy+y
    
    lda cy
    clc
    adc sy
    sta Y1
    lda cy+1
    adc sy+1
    sta Y1+1
    
    ; Calculate cx+x
    
    lda cx
;    clc
    adc sx
    sta X1
    lda cx+1
    adc sx+1
    sta X1+1

    jsr plotpoint   ; cx+x,cy+y

   ; Calculate cx-x
    
    lda cx
    sec
    sbc sx
    sta X1
    lda cx+1
    sbc sx+1
    sta X1+1
    
    jsr plotpoint ; cx-x,cy+y

   ; Calculate cy-y
    
    lda cy
;    sec
    sbc sy
    sta Y1
    lda cy+1
    sbc sy+1
    sta Y1+1
    
    jsr plotpoint ; cx-x,cy-y

  ; Calculate cx+x
    
    lda cx
    clc
    adc sx
    sta X1
    lda cx+1
    adc sx+1
    sta X1+1
    
    jsr plotpoint ; cx+x,cy-y


    ; Calculate cy+x
    
    lda cy
 ;   clc
    adc sx
    sta Y1
    lda cy+1
    adc sx+1
    sta Y1+1
    
   ; Calculate cx+y
    
    lda cx
 ;   clc
    adc sy
    sta X1
    lda cx+1
    adc sy+1
    sta X1+1
    
    jsr plotpoint  ; cx+y,cy+x

    ; Calculate cx-y
    
    lda cx
    sec
    sbc sy
    sta X1
    lda cx+1
    sbc sy+1
    sta X1+1
    
    jsr plotpoint  ; cx-y,cy+x


    ; Calculate cy-x
    
    lda cy
 ;   sec
    sbc sx
    sta Y1
    lda cy+1
    sbc sx+1
    sta Y1+1
    
    jsr plotpoint   ; cx-y,cy-x

   ; Calculate cx+y
    
    lda cx
    clc
    adc sy
    sta X1
    lda cx+1
    adc sy+1
    sta X1+1
    
    jmp plotpoint    ; cx+y,cy-x
 	;rts
.)

plotpoint
.(
	lda #0	;SMC
	bne plot
.(
    lda X1
    cmp #(CLIP_RIGHT)
    lda X1+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
	bpl end
.(
    lda X1
    cmp #(CLIP_LEFT)
    lda X1+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
	bmi end
.(
    lda Y1
+patch_circleclip
    cmp #(CLIP_BOTTOM)
    lda Y1+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
	bpl end
.(
    lda Y1
    cmp #(CLIP_TOP)
    lda Y1+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
	bmi end



plot 
    ldx X1
    ldy Y1

    ;jsr pixel_address

    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
  

    ora (tmp0),y
    sta (tmp0),y

end
    rts

.)


; Variables for circlepoints
sy    .word 0
sx    .word 0


xpr	.word 0
xmr .word 0
ypr .word 0
ymr .word 0


_circleMidpoint
.(

    ; Check if circle is visible
    ;;  cx + rad < lhs of screen fails
    lda cx
    clc
    adc rad
    sta xpr
    lda cx+1
    adc rad+1
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
	bpl next1
    rts
next1
    ;;  x - size > rhs of screen fails 
    lda cx
    sec
    sbc rad
    sta xmr
    lda cx+1
    sbc rad+1
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
	bmi next2
    rts
next2
    ;;  y + size < top of screen fails
    lda cy
    clc
    adc rad
    sta ypr
    lda cy+1
    adc rad+1
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
    
	bpl next3
    rts
next3
    ;;  y - size > bot of screen fails
    lda cy
    sec
    sbc rad
    sta ymr
    lda cy+1
    sbc rad+1
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
	bmi next4
    rts
next4

	; Check if clipping is needed
	lda #1
	sta clipme
	
	;cx+r<CLIP_RIGHT
.(
    lda xpr 
    cmp #(CLIP_RIGHT-1)
    lda xpr+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
	bmi nextb1
    lda #0
	sta clipme
	beq drawit
nextb1

	;cx-r>CLIP_LEFT
.(
    lda xmr 
    cmp #(CLIP_LEFT)
    lda xmr+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
	bpl nextb2
    lda #0
	sta clipme
	beq drawit
nextb2

	
	;cy+r<CLIP_BOTTOM
.(
    lda ypr 
    cmp #(CLIP_BOTTOM-1)
    lda ypr+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
	bmi nextb3
    lda #0
	sta clipme
	beq drawit
nextb3

	;cy-r>CLIP_TOP
.(
    lda ymr 
    cmp #(CLIP_TOP)
    lda ymr+1
    sbc #0
    bvc ret ; N eor V
    eor #$80
ret
.)
	bpl drawit
    lda #0
	sta clipme

drawit
     ;x=0;y=radius
    lda #0
    sta sx
    sta sx+1
    lda rad
    sta sy
    lda rad+1
    sta sy+1   
 
    ; p=1-radius
    lda #1
    sec
    sbc rad
    sta p
    lda #0
    sbc rad+1
    sta p+1
    
draw
   ; circlePoints (xCenter, yCenter, x, y);
    jsr _circlePoints


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

loop
/*    lda sx
    sta op1
    lda sx+1
    sta op1+1
    lda sy
    sta op2
    lda sy+1
    sta op2+1
    jsr cmp16
    bpl end
  */  

  .(
    lda sx 
    cmp sy
    lda sx+1
    sbc sy+1
    bvc ret ; N eor V
    eor #$80
ret
  .)
	bpl end

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
    
    jsr _circlePoints
    jmp loop

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
   
    jsr _circlePoints
    jmp loop

end

    rts


p .word 0

.)






#endif //FILLEDPOLYS





