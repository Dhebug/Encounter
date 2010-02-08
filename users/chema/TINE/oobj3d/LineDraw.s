#include "params.h"

#ifndef FILLEDPOLYS


.zero

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


save_a          .dsb 1
curBit          .dsb 1
chunk           .dsb 1
lastSum         .dsb 1


#define BYTE_PIXEL  6
#define X_SIZE      240
#define ROW_SIZE    X_SIZE/BYTE_PIXEL

#define _NOP        $ea
#define _INX        $e8
#define _DEX        $ca
#define _INY        $c8
#define _DEY        $88
#define _ASL        $0a
#define _LSR        $4a
#define _INC_ZP     $e6
#define _DEC_ZP     $c6



.text

;; To include double-buffer (on and off)
double_buff .byt $ff


#define X_SIZE      240
#define Y_SIZE      200
#define ROW_SIZE    X_SIZE/6

    .dsb 256-(*&255)

_HiresAddrLow           .dsb Y_SIZE

    .dsb 256-(*&255)

_HiresAddrHigh          .dsb Y_SIZE

    .dsb 256-(*&255)

    .byt 0
_TableDiv6              .dsb X_SIZE

    .dsb 256-(*&255)

    .byt 0
_TableMod6              .dsb X_SIZE

    .dsb 256-(*&255)

    .byt 0
_TableDiv6Rev           .dsb X_SIZE

    .dsb 256-(*&255)

    .byt 0
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

    .byt 0
_TableBit6
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32

    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32

    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32

    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32
    .byt 1,2,4,8,16,32


/////////////////////////////////////


    .dsb 256-(*&255)

draw_totaly_vertical_8
.(
    ldx _CurrentPixelX
    ldy _TableDiv6,x
    lda _TableBit6Reverse,x     ; 4
    sta _mask_patch+1

    ldx dy
    inx

    clc                         ; 2
loop
_mask_patch
    lda #0                      ; 2
    ora (tmp0),y                ; 5
    sta (tmp0),y                ; 6 => total = 13 cycles

; update the screen address:
    .(
    lda tmp0+0                  ; 3
    adc #ROW_SIZE               ; 2
    sta tmp0+0                  ; 3
    bcc skip                    ; 2 (+1 if taken)
    inc tmp0+1                  ; 5
    clc                         ; 2
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
_DrawLine
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

cur_bigger                  ; y1>y2
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

cur_smaller                 ; y1<y2
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
    lda _HiresAddrLow,y         ; 4
    sta tmp0+0                  ; 3
    lda _HiresAddrHigh,y        ; 4
    sta tmp0+1                  ; 3 => Total 14 cycles

    ; Test X value
.(
    sec
    lda _CurrentPixelX
    sbc _OtherPixelX
    sta dx
    beq draw_totaly_vertical_8
    bcc cur_smaller

cur_bigger                  ; x1>x2
    lda #_DEX
    bne end

cur_smaller                 ; x1<x2
    ; Absolute value
    eor #$ff
    adc #1
    sta dx

    lda #_INX
end
.)

    jmp alignIt

    .dsb 256-(*&255)

alignIt
    ; Compute slope and call the specialized code for mostly horizontal or vertical lines
    ldy dy
    beq draw_totaly_horizontal_8
    cpy dx
    bcc draw_mainly_horizontal_8
    jmp draw_mainly_vertical_8

draw_totaly_horizontal_8
.(
    ; here we have DY in Y, and the OPCODE in A
    sta _outer_patch    ; Write a (dex / nop / inx) instruction

    ldx _OtherPixelX
    stx __auto_cpx+1

    ldx _CurrentPixelX

    ;
    ; Draw loop
    ;
outer_loop
    ldy _TableDiv6,x
    lda _TableBit6Reverse,x     ; 4
    ora (tmp0),y                ; 5
    sta (tmp0),y                ; 6

_outer_patch
    inx

__auto_cpx
    cpx #00                 ; At the endpoint yet?
    bne outer_loop
    rts
.)

draw_mainly_horizontal_8
.(
    tax
    lda dx
    lsr
    cmp dy
    bcs draw_very_horizontal_8

; here we have DY in Y, and the OPCODE (inx, dex) in A
    sty __auto_dy+1

; all this stress to be able to use dex, beq :)
    cpx #_INX
    beq doInx

    lda #<_TableDiv6-1          ; == 0
;    clc                        ; _DEX < _INX
    adc _OtherPixelX
    sta __auto_div6+1
    lda #<_TableBit6Reverse-1   ; == 0
;    clc
    adc _OtherPixelX

    ldx #>_TableDiv6
    ldy #>_TableBit6Reverse ;
    bne endPatch

doInx
    lda #X_SIZE-1
;    sec
    sbc _OtherPixelX
    sta __auto_div6+1
    lda #X_SIZE-1
;    sec
    sbc _OtherPixelX

    ldx #>_TableDiv6Rev
    ldy #>_TableBit6        ;
endPatch
    sta __auto_bit6+1
    stx __auto_div6+2
    sty __auto_bit6+2

    lda dx
    tax
    inx                     ; 2         +1 since we count to 0
    sta __auto_dx+1
    lsr
    eor #$ff
    clc
; a = sum, x = dX+1

loopX
    sta save_a              ; 3 =  3
loopY
    ; Draw the pixel
__auto_div6
    ldy _TableDiv6-1,x      ; 4
__auto_bit6
    lda _TableBit6Reverse-1,x;4
    ora (tmp0),y            ; 5*
    sta (tmp0),y            ; 6*= 19

    dex                     ; 2         Step in x
    beq exitLoop            ; 2/3       At the endpoint yet?
    lda save_a              ; 3
__auto_dy
    adc #00                 ; 2         +DY
    bcc loopX               ; 2/3=11/12 ~50% taken
    ; Time to step in y
__auto_dx
    sbc #00                 ; 2         -DX
    sta save_a              ; 3 =  5

; update the screen address:
    lda tmp0+0              ; 3
    adc #ROW_SIZE           ; 2
    sta tmp0+0              ; 3
    bcc loopY               ; 2/3=10/11 ~84% taken
    inc tmp0+1              ; 5
    clc                     ; 2
    bcc loopY               ; 3 = 10
; average: 12.44

exitLoop
    rts
; Timings:
; x++/y  : 34
; x++/y++: 47.44
; average: 40.72
.)

draw_very_horizontal_8
.(
; dX > 2*dY, here we use "chunking"
; here we have DY in Y, and the OPCODE (inx, dex) in A
    sty __auto_dy+1
    sty __auto_dy2+1
    cpx #_INX
    php

    ldx _CurrentPixelX
    lda _TableDiv6,x
    clc
    adc tmp0
    tay
    bcc skipHi
    inc tmp0+1
skipHi
    lda #0
    sta tmp0

    plp
    beq doInx
; negative x-direction
    lda _TableMod6,x
    tax

    lda #_DEY
    sta __auto_stepx
    sta __auto_stepx2
    lda #$ff
    sta __auto_cpy+1
    sta __auto_cpy2+1
    lda #_DEC_ZP
    sta __auto_yHi
    sta __auto_yHi2
    lda Pot2NTbl,x
    sta chunk
    lda #<Pot2NTbl
    bne endPatch

doInx
; positive x-direction
    lda #BYTE_PIXEL-1
;    sec
    sbc _TableMod6,x
    tax

    lda #_INY
    sta __auto_stepx
    sta __auto_stepx2
    lda #$00
    sta __auto_cpy+1
    sta __auto_cpy2+1
    lda #_INC_ZP
    sta __auto_yHi
    sta __auto_yHi2
    lda Pot2PTbl,x
    sta chunk
    lda #<Pot2PTbl
endPatch
    sta __auto_pot1+1
    sta __auto_pot2+1
    sta __auto_pot3+1

    lda dx
    sta __auto_dx+1
; calculate initial bresenham sum
    lsr
    sta lastSum             ; 3         this is used for the last line segment
    eor #$ff                ;           = -dx/2
    clc
    jmp loopX
; a = sum, x = dX+1, y = ptr-offset

    .dsb 256-(*&255)

nextColumn                  ;
    tax                     ; 2
    lda chunk               ; 3
    ora (tmp0),y            ; 5
    sta (tmp0),y            ; 6
    lda #%00111111          ; 2
    sta chunk               ; 3
    txa                     ; 2
    ldx #BYTE_PIXEL-1       ; 2
__auto_stepx
    iny                     ; 2         next column
__auto_cpy
    cpy #00                 ; 2
    clc                     ; 2
    bne contColumn          ; 2/3=33/34 99% taken
__auto_yHi
    inc tmp0+1              ; 5         dec/inc
    bcc contColumn          ; 3 =  8

loopY
    dec dy                  ; 5         all but one vertical segments drawn?
    beq exitLoop            ; 2/3= 7/8  yes, exit loop
loopX
    dex                     ; 2
    bmi nextColumn          ; 2/37.03   ~16.7% taken
contColumn                  ;   =  9.85
__auto_dy
    adc #00                 ; 2         +DY
    bcc loopX               ; 2/3= 4/5  ~50% taken
    ; Time to step in y
__auto_dx
    sbc #00                 ; 2         -DX
    sta save_a              ; 3 =  5

; plot the last bits of current row:
__auto_pot1
    lda Pot2PTbl,x          ; 4
    eor chunk               ; 3
    ora (tmp0),y            ; 5
    sta (tmp0),y            ; 6
__auto_pot2
    lda Pot2PTbl,x          ; 4
    sta chunk               ; 3 = 25

; update the screen address:
    tya                     ; 2
    adc #ROW_SIZE           ; 2
    tay                     ; 2
    lda save_a              ; 3
    bcc loopY               ; 2/3=11/12 ~84.4% taken
    inc tmp0+1              ; 5
    clc                     ; 2
    bcc loopY               ; 3 = 10
; average: 13.40

; Timings:
; x++/y  : 14.85 (75%)
; x++/y++: 64.25 (25%)
; average: 27.20

exitLoop
; draw the last horizontal line segment:
    adc lastSum             ; 3
loopXEnd
    dex                     ; 2
    bmi nextColumnEnd       ; 2/37.03   ~16.7% taken
contColumnEnd               ;   =  9.85
__auto_dy2
    adc #00                 ; 2         +DY
    bcc loopXEnd            ; 2/3=11/12 ~50% taken

; plot last chunk:
__auto_pot3
    lda Pot2PTbl,x          ; 4
    eor chunk               ; 3
    ora (tmp0),y            ; 5
    sta (tmp0),y            ; 6 = 18
    rts

nextColumnEnd                  ;
    tax                     ; 2
    lda chunk               ; 3
    ora (tmp0),y            ; 5
    sta (tmp0),y            ; 6
    lda #%00111111          ; 2
    sta chunk               ; 3
    txa                     ; 2
    ldx #BYTE_PIXEL-1       ; 2
__auto_stepx2
    iny                     ; 2         next column
__auto_cpy2
    cpy #00                 ; 2
    clc                     ; 2
    bne contColumnEnd       ; 2/3=33/34 99% taken
__auto_yHi2
    inc tmp0+1              ; 5         dec/inc
    bcc contColumnEnd       ; 3 =  8

Pot2PTbl
    .byte   %00000001, %00000011, %00000111, %00001111
    .byte   %00011111, %00111111
Pot2NTbl
    .byte   %00100000, %00110000
    .byte   %00111000, %00111100, %00111110, %00111111
.)


    .dsb 256-(*&255)
;
; This code is used when the things are moving faster
; vertically than horizontally
;
; dy>dx
;
draw_mainly_vertical_8
; here we have DY in Y, and the OPCODE in A
.(
; setup bresenham values:
    sty __auto_dy+1
    ldx dx
    stx __auto_dx+1

; setup direction:
    cmp #_DEX               ;           which direction?
    bne doInx
; dex -> moving left:
    lda #%00100000
    sta __auto_cpBit+1
    lda #_ASL               ;
    sta __auto_shBit
    lda #%00000001
    sta __auto_ldBit+1
    lda #_DEY
    sta __auto_yLo
    ldx #$ff
    lda #_DEC_ZP
    bne endPatch

doInx
; inx -> moving right:
    lda #%00000001
    sta __auto_cpBit+1
    lda #_LSR
    sta __auto_shBit
    lda #%00100000
    sta __auto_ldBit+1
    lda #_INY
    sta __auto_yLo
    ldx #$00
    lda #_INC_ZP
endPatch
    stx __auto_cpY+1
    sta __auto_yHi
; setup X
    tya                     ;           y = dY
    tax
    inx                     ;           x = dY+1
; setup current bit:
    ldy _CurrentPixelX
    lda _TableBit6Reverse,y ; 4
    sta curBit
; setup pointer and Y:
; TODO: self-modyfing code?
    lda _TableDiv6,y
    clc
    adc tmp0
    tay
    lda #0
    sta tmp0
    bcc skipTmp0
    inc tmp0+1
skipTmp0
; calculate initial bresenham sum:
    lda dy
    lsr
    eor #$ff                ;           -DY/2
    clc                     ; 2
    bcc loopY               ; 3
; a = sum, y = tmp0, x = dY+1, tmp0 = 0

incHiPtr                    ; 9
    inc tmp0+1              ; 5
    clc                     ; 2
    bcc contHiPtr           ; 3
;----------------------------------------------------------
loopY
    sta save_a              ; 3 =  3
    ; Draw the pixel
    lda curBit              ; 3
    ora (tmp0),y            ; 5
    sta (tmp0),y            ; 6 = 14

    dex                     ; 2         At the endpoint yet?
    beq exitLoop            ; 2/3= 4/5
loopX
; update the screen address:
    tya                     ; 2
    adc #ROW_SIZE           ; 2
    tay                     ; 2
    bcs incHiPtr            ; 2/13      ~16% taken
contHiPtr                   ;   =  9.76 average

    lda save_a              ; 3
__auto_dx
    adc #00                 ; 2         +DX
    bcc loopY               ; 2/3= 7/8  ~50% taken

    ; Time to step in x
__auto_dy
    sbc #00                 ; 2         -DY
    sta save_a              ; 3 =  5

    lda curBit              ; 3
__auto_cpBit                ;           TODO: optimize
    cmp #%00100000          ; 2         %00100000/%00000001
    beq nextColumn          ; 2/14.07   ~17% taken
__auto_shBit
    asl                     ; 2         asl/lsr, clears carry
contNextColumn
    sta curBit              ; 3 =~13.71

    ; Draw the pixel
    ora (tmp0),y            ; 5
    sta (tmp0),y            ; 6 = 11
    dex                     ; 2         At the endpoint yet?
    bne loopX               ; 2/3= 4/5
exitLoop
    rts
;----------------------------------------------------------
nextColumn
__auto_ldBit
    lda #%00000001          ; 2         %00000001/%00100000
__auto_yLo
    dey                     ; 2         dey/iny
__auto_cpY
    cpy #$ff                ; 2         $ff/$00
    clc                     ; 2         TODO: optimize
    bne contNextColumn      ; 2/3       ~99% taken
__auto_yHi
    dec tmp0+1              ; 5         dec/inc
    bcc contNextColumn      ; 3

; x  ,y++: 38.76 (50%)
; x++,y++: 51.47 (50%)
; average: 45.11
.)

; *** total timings: ***
; draw_very_horizontal_8   (29.6%): 27.20
; draw_mainly_horizontal_8 (20.4%): 40.72
; draw_mainly_vertical_8   (50.0%): 45.11
;----------------------------------------
; total average           (100.0%): 38.91



////////////////////////////////////////


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
	adc #ROW_SIZE
	sta tmp0+0
	lda tmp0+1
	sta _HiresAddrHigh,x
	adc #0
	sta tmp0+1

	inx
	cpx #Y_SIZE
	bne loop
.)


   ; Generate multiple of 6 data table
.(
    lda #0      ; cur div
    tay         ; cur mod
    tax
loop
    sta _TableDiv6,x
    pha
    tya
    sta _TableMod6,x
    pla

    iny
    cpy #6
    bne skip_mod
    ldy #0
    adc #0      ; carry = 1!
skip_mod

    inx
    cpx #X_SIZE
    bne loop
.)
.(
    lda #0      ; cur div
    tay         ; cur mod
    ldx #X_SIZE
loop
    dex
    sta _TableDiv6Rev,x

    iny
    cpy #6
    bne skip_mod
    ldy #0
    adc #0      ; carry = 1!
skip_mod

    cpx #0
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
		jmp _DrawLine
		;rts
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
    lda patch_circleclip1+1
    cmp #199
    beq clip1
    lda #199
    jmp cont
clip1
    lda #(CLIP_BOTTOM)

cont    
    sta patch_circleclip1+1
    sta patch_circleclip2+1
    sta patch_circleclip3+1
    sta patch_circleclip4+1
    sta patch_circleclip5+1
/*    sta patch_circleclip6+1
    sta patch_circleclip7+1
    sta patch_circleclip8+1
    sta patch_circleclip9+1*/
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






