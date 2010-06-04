#include "params.h"

#ifndef FILLEDPOLYS

.zero

dx				.dsb 1
dy				.dsb 1
_CurrentPixelX	.dsb 1
_CurrentPixelY	.dsb 1
_OtherPixelX	.dsb 1
_OtherPixelY	.dsb 1

; 5 bytes for point 0
_LargeX0        .dsb 2
_LargeY0        .dsb 2
_ClipCode0      .dsb 1
; 5 bytes for point 1
_LargeX1        .dsb 2
_LargeY1        .dsb 2
_ClipCode1      .dsb 1

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
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80

    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80

    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80

    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80


/////////////////////////////////////
; History of linebench timings...
;649
;614 (replacing the update of tmp0)
;607
;588
;583 after alignment
;579
;534 redid mainly_vertical
;529 removed page penalty
;517 final optimization at mainly_horizontal
;501 chunking, initial version
;482 optimized chunking (avg: 38.91 cylces)
;473 final optimization for mainly_vertical (37.89 -> 38.34 corrected)
;468 a weird stunt on mainly_horizontal (38.07)
;467 minor very_horizontal optimization (37.88 -> 38.56 corrected)
;463 self modifying pointer in mainly_horizontal (38.35)
;459 self modifying pointer in mainly_vertical (37.99)
;459 a little tweak to very_horizontal (37.94)
;451 refactored to make x-direction always positive (37.07)

; TODOs:
; + chunking (-35)
; - two separate branches instead of patching?
; + countdown minor
;   x mainly_horizontal (won't work)
;   + mainly_vertical (-9)
; o optimizing for space (-2 tables and one alignment page)
; + optimize horizontal (merge with very_horizontal)
; o optimize vertical
; + correct branch taken percentages
; + always draw left to right and patch y-direction (-8)
; + switch between XOR and OR

    .zero

;   *= tmp1

;e              .dsb 2  ; Error decision factor (slope) 2 bytes in zero page
;i              .dsb 1  ; Number of pixels to draw (iteration counter) 1 byte in zp
;dx             .dsb 1  ; Width
;dy             .dsb 1  ; Height
;_CurrentPixelX .dsb 1
;_CurrentPixelY .dsb 1
;_OtherPixelX   .dsb 1
;_OtherPixelY   .dsb 1

save_a          .dsb 1
curBit          .dsb 1
chunk           .dsb 1
lastSum         .dsb 1


#define OPP         ORA
;#define OPP         EOR

#define BYTE_PIXEL  6
#define X_SIZE      240
#define ROW_SIZE    X_SIZE/BYTE_PIXEL

#define _INY        $c8
#define _DEY        $88
#define _INC_ZP     $e6
#define _DEC_ZP     $c6
#define _INC_ABS    $ee
#define _DEC_ABS    $ce
#define _ADC_IMM    $69
#define _SBC_IMM    $e9
#define _BCC        $90
#define _BCS        $b0
#define _CLC        $18
#define _SEC        $38


    .text

;    .dsb 256-(*&255)

;**********************************************************
;
; Expects the following variables to be set when called:
; _CurrentPixelX
; _CurrentPixelY
; _OtherPixelX
; _OtherPixelY
;
_DrawLine
;
; compute deltas and signs
;
.(
; test X value
    sec
    lda _CurrentPixelX
    sbc _OtherPixelX
    bcc cur_smaller
    beq end

    ldy _CurrentPixelX
    ldx _OtherPixelX
    sty _OtherPixelX
    stx _CurrentPixelX

    ldy _CurrentPixelY
    ldx _OtherPixelY
    sty _OtherPixelY
    stx _CurrentPixelY

    bcs end

cur_smaller                 ; y1<y2
; absolute value
    eor #$ff
    adc #1
end
    sta dx
.)
;
; initialise screen pointer
;
    ldy _CurrentPixelY
    lda _HiresAddrLow,y         ; 4
    sta tmp0+0                  ; 3
    lda _HiresAddrHigh,y        ; 4
    sta tmp0+1                  ; 3 => Total 14 cycles
.(
; test Y value
    sec
    lda _CurrentPixelY
    sbc _OtherPixelY
;    beq horizontal
    ldx #_DEY
    bcs cur_bigger

cur_smaller                 ; x1<x2
; absolute value
    eor #$ff
    adc #1

    ldx #_INY
cur_bigger                  ; x1>x2
    sta dy
.)
    tay
    jmp alignIt

;horizontal
;    jmp draw_totally_horizontal_8

    .dsb 256-(*&255)

alignIt
; Compute slope and call the specialized code for mostly horizontal or vertical lines
    cmp dx
    bcc draw_mainly_horizontal_8
    lda dx
    beq draw_totaly_vertical_8
    jmp draw_mainly_vertical_8

;**********************************************************
draw_totaly_vertical_8
.(
    cpx #_INY
    bne doDey
; iny -> moving up:
    clc
    ldx _CurrentPixelX
    bcc endPatch

; dey -> moving down:
doDey                           ;       _DEY < _INY -> C==0!
    ldy _OtherPixelY
    lda _HiresAddrLow,y         ; 4
    sta tmp0+0                  ; 3
    lda _HiresAddrHigh,y        ; 4
    sta tmp0+1                  ; 3 => Total 14 cycles
    ldx _OtherPixelX

endPatch
    ldy _TableDiv6,x
    lda _TableBit6Reverse,x     ; 4
    sta _mask_patch+1
    ldx dy
    inx

loop
_mask_patch
    lda #0                      ; 2
    OPP (tmp0),y                ; 5*
    sta (tmp0),y                ; 6*= 13**

; update the screen address:
    tya                         ; 2
    adc #ROW_SIZE               ; 2
    tay                         ; 2
    bcc skip                    ; 2/3       84.4% taken
    inc tmp0+1                  ; 5
    clc                         ; 2
skip                            ;   = 9.94
    dex                         ; 2
    bne loop                    ; 2/3=4/5
    rts
; average: 27.94
.)

;**********************************************************
draw_mainly_horizontal_8
.(
; A = DX, Y = DY, X = opcode
    lda dx
    lsr
    cmp dy
    bcc contMainly
    jmp draw_very_horizontal_8

contMainly

; all this stress to be able to use dex, beq :)
    cpx #_INY
    beq doIny

; dey -> moving down:
    dey
    sty _patch_dy+1

    lda #<(loopX-_patch_loop-2)
    sta _patch_loop+1

    lda #_SBC_IMM
    sta _patch_adc
    lda #ROW_SIZE-1
    sta _patch_adc+1
    lda #_DEC_ABS
    ldx #_BCS
    ldy #_SEC
    bne endPatch

doIny
    sty _patch_dy+1

    lda #<(loopX-_patch_loop-1)
    sta _patch_loop+1

    lda #_ADC_IMM
    sta _patch_adc
    lda #ROW_SIZE
    sta _patch_adc+1
    lda #_INC_ABS
    ldx #_BCC
    ldy #_CLC
endPatch
    sta _patch_inc1
    sta _patch_inc2
    stx _patch_bcc
    sty _patch_clc1
    sty _patch_clc2

    lda #X_SIZE-1
    sec
    sbc _OtherPixelX
    sta _patch_bit1+1
    sta _patch_bit2+1

    ldx _CurrentPixelX
    lda _TableDiv6,x
    clc
    adc tmp0
    tay
    lda tmp0+1
    adc #0
    sta _patch_ptr0+2
    sta _patch_ptr1+2

    lda dx
    tax
    inx                     ; 2         +1 since we count to 0
    sta _patch_dx+1
    lsr
    eor #$ff
_patch_clc1
    clc

    sta save_a              ; 3 =  3
_patch_bit1
    lda _TableBit6-1,x;4
    and #$7f                 ;          remove signal bit
    bne contColumn

; a = sum, x = dX+1
;----------------------------------------------------------
loopX
    sec                     ; 1         50% executed (y--)
    sta save_a              ; 3 =  4
loopY
_patch_bit2
    lda _TableBit6-1,x      ; 4
    bmi nextColumn          ; 2/10.05   16.7% taken
contColumn
_patch_ptr0
    OPP $a000,y             ; 4
_patch_ptr1
    sta $a000,y             ; 5 = 16.34

    dex                     ; 2         Step in x
    beq exitLoop            ; 2/3       At the endpoint yet?
    lda save_a              ; 3
_patch_dy
    adc #00                 ; 2         +DY
_patch_loop
    bcc loopX               ; 2/3=11/12 ~28.0% taken (not 50% due do to special code for very horizontal lines)
    ; Time to step in y
_patch_dx
    sbc #00                 ; 2         -DX
    sta save_a              ; 3 =  5

; update the screen address:
    tya                     ; 2
_patch_adc
    adc #ROW_SIZE           ; 2
    tay                     ; 2
_patch_bcc
    bcc loopY               ; 2/3= 8/9  ~84.4% taken
_patch_inc1
    inc _patch_ptr0+2       ; 6
_patch_inc2
    inc _patch_ptr1+2       ; 6
_patch_clc2
    clc                     ; 2
    bne loopY               ; 3 = 17
; average: 11.50

exitLoop
    rts

nextColumn
    and #$7f                ; 2         remove signal bit
    iny                     ; 2
    bne contColumn          ; 2/3= 6/7  99% taken
    inc _patch_ptr0+2       ; 6
    inc _patch_ptr1+2       ; 6
    bne contColumn          ; 3 = 15

; Timings:
; x++/y  : 32.34 (28.0%)
; x++/y++: 43.84 (72.0%)
; average: 40.62
.)

;    .dsb 256-(*&255)
;**********************************************************
draw_very_horizontal_8
.(
; dX > 2*dY, here we use "chunking"
; here we have DY in Y, and the OPCODE (inx, dex) in X
    sty _patch_dy0+1
    sty _patch_dy1+1
    sty _patch_dy2+1
    cpx #_INY
    php
; setup pointer and Y:
    ldx _CurrentPixelX
    lda _TableDiv6,x
    clc
    adc tmp0
    tay
    lda #0
    sta tmp0
    bcc skipHi
    inc tmp0+1
skipHi
    lda _TableDiv6,x
    asl
    adc _TableDiv6,x
    asl
;    clc
    adc #BYTE_PIXEL;-1
;    sec
    sbc _CurrentPixelX
    tax
    lda Pot2PTbl,x
    sta chunk

; patch the code:
    plp
    beq doIny
; no y-direction?
    lda dy
    beq draw_totally_horizontal_8
; negative y-direction
    dec _patch_dy0+1

    lda #_SBC_IMM
    sta _patch_adc
    lda #ROW_SIZE-1
    sta _patch_adc+1
    lda #_BCS
    sta _patch_bcc
    lda #_DEC_ZP
    sta _patch_inc
    lda #_SEC
    bne endPatch

doIny
; positive y-direction
    lda #_ADC_IMM
    sta _patch_adc
    lda #ROW_SIZE
    sta _patch_adc+1
    lda #_BCC
    sta _patch_bcc
    lda #_INC_ZP
    sta _patch_inc
    lda #_CLC
endPatch
    sta _patch_clc

    lda dx
    sta _patch_dx+1
; calculate initial bresenham sum
    lsr
    sta lastSum             ; 3         this is used for the last line segment
    eor #$ff                ;           = -dx/2
    clc
    bcc loopX
; a = sum, x = _CurrentPixelX % 6, y = ptr-offset

;----------------------------------------------------------
nextColumnC                 ;
    clc                     ; 2 =  2
nextColumn                  ;
    tax                     ; 2
    lda chunk               ; 3
    OPP (tmp0),y            ; 5
    sta (tmp0),y            ; 6
    lda #%00111111          ; 2
    sta chunk               ; 3
    txa                     ; 2
    ldx #BYTE_PIXEL-1       ; 2
    iny                     ; 2         next column
    bne contColumn          ; 2/3=29/30 99% taken
    inc tmp0+1              ; 5         dec/inc
    bne contColumn          ; 3 =  8
; average: 30.03
;----------------------------------------------------------
draw_totally_horizontal_8
    lda #1
    sta _patch_dy2+1
    lda dx
    eor #$ff                ;           = -dx
    clc
    bcc loopXEnd
;----------------------------------------------------------
loopY
    lda save_a              ; 3
    dec dy                  ; 5         all but one vertical segments drawn?
    beq exitLoop            ; 2/3=10/11  yes, exit loop
    dex                     ; 2
    bmi nextColumnC         ; 2/38.03   ~16.7% taken (this will continue below)
_patch_dy0
    adc #00                 ; 2 = 12.01 +DY, no check necessary here!
loopX
    dex                     ; 2
    bmi nextColumn          ; 2/33.03   ~16.7% taken
contColumn                  ;   =  9.17
_patch_dy1
    adc #00                 ; 2         +DY
    bcc loopX               ; 2/3= 4/5  ~76.4% taken
    ; Time to step in y
_patch_dx
    sbc #00                 ; 2         -DX
    sta save_a              ; 3 =  5

; plot the last bits of current segment:
    lda Pot2PTbl,x          ; 4
    eor chunk               ; 3
    OPP (tmp0),y            ; 5
    sta (tmp0),y            ; 6
    lda Pot2PTbl,x          ; 4
    sta chunk               ; 3 = 25

; update the screen address:
    tya                     ; 2
_patch_adc
    adc #ROW_SIZE           ; 2
    tay                     ; 2
_patch_bcc
    bcc loopY               ; 2/3= 8/9  ~84.4% taken
_patch_inc
    inc tmp0+1              ; 5
_patch_clc
    clc                     ; 2
    bne loopY               ; 3 = 10
; average: 10.40

; Timings:
; x++/y  : 14.17 (76.4%)
; x++/y++: 62.41 (23.6%)
; average: 25.55
;----------------------------------------------------------
exitLoop
; draw the last horizontal line segment:
    clc
    adc lastSum             ; 3
loopXEnd
    dex                     ; 2
    bmi nextColumnEnd       ; 2/37.03   ~16.7% taken
contColumnEnd               ;   =  9.85
_patch_dy2
    adc #00                 ; 2         +DY
    bcc loopXEnd            ; 2/3= 4/5  ~38.2% taken

; plot last chunk:
    lda Pot2PTbl,x          ; 4
    eor chunk               ; 3
    OPP (tmp0),y            ; 5
    sta (tmp0),y            ; 6 = 18
    rts
;----------------------------------------------------------
nextColumnEnd                  ;
    tax                     ; 2
    lda chunk               ; 3
    OPP (tmp0),y            ; 5
    sta (tmp0),y            ; 6
    lda #%00111111          ; 2
    sta chunk               ; 3
    txa                     ; 2
    ldx #BYTE_PIXEL-1       ; 2
    iny                     ; 2         next column
    bne contColumnEnd       ; 2/3=29/30 99% taken
    inc tmp0+1              ; 5         dec/inc
    bne contColumnEnd       ; 3 =  8

Pot2PTbl
    .byte   %00000001, %00000011, %00000111, %00001111
    .byte   %00011111, %00111111
.)

    .dsb 256-(*&255)

;**********************************************************
;
; This code is used when the things are moving faster
; vertically than horizontally
;
; dy>dx
;
draw_mainly_vertical_8
; A = DX, Y = DY, X = opcode
.(
; setup bresenham values:
    sty _patch_dy+1

; setup direction:
    cpx #_DEY               ;           which direction?
    bne doIny
; dey -> moving down:
    lda #_SBC_IMM
    sta _patch_adc1
    sta _patch_adc2
    lda #ROW_SIZE-1
    sta _patch_adc1+1
    sta _patch_adc2+1
    lda #_BCC
    sta _patch_bcs1
    sta _patch_bcs2
    lda #_DEC_ZP
    sta _patch_inc2
    ldy #_SEC
    ldx dx
    dex
    lda #_DEC_ABS
    bne endPatch

doIny
; inx -> moving up:
    lda #_ADC_IMM
    sta _patch_adc1
    sta _patch_adc2
    lda #ROW_SIZE
    sta _patch_adc1+1
    sta _patch_adc2+1
    lda #_BCS
    sta _patch_bcs1
    sta _patch_bcs2
    lda #_INC_ZP
    sta _patch_inc2
    ldy #_CLC
    ldx dx
    lda #_INC_ABS
endPatch
    sta _patch_inc0
    sta _patch_inc1
    stx _patch_dx1+1
    stx _patch_dx2+1
    sty _patch_clc1
    sty _patch_clc2

; setup X
    ldx dx                  ;           X = dx
; setup current bit:
    ldy _CurrentPixelX
    lda _TableBit6Reverse,y ; 4
    sta curBit
; setup pointer and Y:
    lda _TableDiv6,y
    clc
    adc tmp0
    tay
    lda #0
    sta tmp0
    lda tmp0+1
    adc #0
    sta _patch_ptr0+2
    sta _patch_ptr1+2
; calculate initial bresenham sum:
    lda dy
    lsr
    sta lastSum
    eor #$ff                ;           -DY/2
    clc                     ; 2
    bcc loopY               ; 3
; a = sum, y = tmp0, x = dX, tmp0 = 0
;----------------------------------------------------------
incHiPtr                    ;
_patch_inc0
    inc _patch_ptr0+2       ; 6
_patch_inc1
    inc _patch_ptr1+2       ; 6
_patch_clc1
    clc                     ; 2
    bne contHiPtr           ; 3 = 17
;----------------------------------------------------------
loopY
    sta save_a              ; 3
    lda curBit              ; 3 =  6
loopX
    ; Draw the pixel
_patch_ptr0
    OPP $a000,y             ; 4
_patch_ptr1
    sta $a000,y             ; 5 =  9
; update the screen address:
    tya                     ; 2
_patch_adc1
    adc #ROW_SIZE           ; 2
    tay                     ; 2
_patch_bcs1
    bcs incHiPtr            ; 2/20      ~15.6% taken
contHiPtr                   ;   = 10.81 average
    lda save_a              ; 3
_patch_dx1
    adc #00                 ; 2         +DX
    bcc loopY               ; 2/3= 7/8  ~41.4% taken
    ; Time to step in x
_patch_dy
    sbc #00                 ; 2         -DY
    sta save_a              ; 3 =  5

    lda curBit              ; 3
    lsr                     ; 2
    beq nextColumn          ; 2/12.05   ~16.7% taken
contNextColumn
    sta curBit              ; 3 =~11.68
; step in x:
    dex                     ; 2         At the endpoint yet?
    bne loopX               ; 2/3= 4/5

; x  ,y++: 33.81 (41.4%)
; x++,y++: 48.49 (58.6%)
; average: 42.41

; draw the last vertical line segment:
    ldx _patch_ptr0+2       ; 4
    stx tmp0+1              ; 3
    lda save_a              ; 3
    adc lastSum             ; 3
loopYEnd
    tax                     ; 2 =  2
    ; Draw the pixel
    lda curBit              ; 3
    OPP (tmp0),y            ; 5
    sta (tmp0),y            ; 6 = 14
; update the screen address:
    tya                     ; 2
_patch_adc2
    adc #ROW_SIZE           ; 2
    tay                     ; 2
_patch_bcs2
    bcs incHiPtrEnd         ; 2/13      ~15.6% taken
contHiPtrEnd                ;   =  9.72 average
    txa                     ; 2
_patch_dx2
    adc #00                 ; 2         +DX
    bcc loopYEnd            ; 2/3= 6/7  ~20.7% taken
    rts                     ; 6
;----------------------------------------------------------
nextColumn
    clc                     ; 2
    lda #%00100000          ; 2
    iny                     ; 2
    bne contNextColumn      ; 2/3= 8/9  ~99% taken
    inc _patch_ptr0+2       ; 6
    inc _patch_ptr1+2       ; 6
    bcc contNextColumn      ; 3 = 15

incHiPtrEnd                 ; 9
_patch_inc2
    inc tmp0+1              ; 5
_patch_clc2
    clc                     ; 2
    bne contHiPtrEnd        ; 3
;----------------------------------------------------------
.)

; *** total timings: ***
; draw_very_horizontal_8   (29.5%): 25.55 (was 25.73)
; draw_mainly_horizontal_8 (20.5%): 40.62 (was 41.30)
; draw_mainly_vertical_8   (50.0%): 42.41 (was 43.77)
;----------------------------------------
; total average           (100.0%): 37.07 (was 37.94)
////////////////////////////////////////



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clipping code
;;;;;;;;;;;;;;;;;;;;;;;

#define OFS_PT0 0
#define OFS_PT1 (_LargeX1-_LargeX0)

;
; In this code, we assume that the CLIP_ values are fitting
; the resolution of an Oric screen, so they will never be out
; of a 240x200 screen resolution, fit in an unsigned byte.
;
_ClipFindRegion
.(
; yHi >= $01 -> clip_bottom
; yHi == $00 -> check yLo
; yHi <= $ff -> clip_top

; top/bottom test
    ldy _LargeY0+1,x    ; 4
    bmi clip_top        ; 2/3       if Y-Hi <= -1, clip top
    bne clip_bottom     ; 2/3       else, if Y-Hi != 0, clip bottom

; initialize with 'not clipped'
    lda #0              ; 2

    ldy _LargeY0+0,x    ; 4
#if CLIP_TOP <> 0
    cpy #CLIP_TOP       ; 2         == 0
    bcc clip_top        ; 2/3
#endif
    cpy #(CLIP_BOTTOM+1); 2
    bcc end_top_bottom  ; 2/3
clip_bottom
    lda #1              ; 2         means (y > CLIP_BOTTOM)
    bne end_top_bottom  ; 3

clip_top
    lda #2              ; 2         means (y < CLIP_TOP)
end_top_bottom          ;   = 23    (A==0)

; xHi >= $01 -> clip_right
; xHi == $00 -> check xLo
; xHi <= $ff -> clip_left

; left/right test
    ldy _LargeX0+1,x    ; 4
    bmi clip_left       ; 2/3       if X-Hi <=- 1, clip left
    bne clip_right      ; 2/3       else, if X-Hi != 0, clip bottom

    ldy _LargeX0+0,x    ; 4
#if CLIP_LEFT <> 0
    cpy #CLIP_LEFT      ; 2
    bcc clip_left       ; 2/3
#endif
    cpy #(CLIP_RIGHT+1) ; 2
    bcc end_left_right  ; 2/3
clip_right
    ora #4              ; 2         means (x > CLIP_RIGHT)
    bne end_left_right  ; 3

clip_left
    ora #8              ; 2         means (x < CLIP_LEFT)
end_left_right          ;   = 21    (A==0)
    sta _ClipCode0,x    ; 4
    rts                 ; 6 = 10
.)


_ClipComputeMidPoint
.(
    ;   xc=(x0+x1)>>1;
    clc
#ifdef USE_ACCURATE_CLIPPING
    lda _ClipX0-1       ; 3
    adc _ClipX1-1       ; 3
    sta _ClipXc-1       ; 3
#endif
    lda _ClipX0+0       ; 3
    adc _ClipX1+0       ; 3
    sta _ClipXc+0       ; 3

    lda _ClipX0+1       ; 3
    adc _ClipX1+1       ; 3
; divide by 2:
    cmp #$80            ; 2
    ror                 ; 2
    sta _ClipXc+1       ; 3
    ror _ClipXc+0       ; 5
#ifdef USE_ACCURATE_CLIPPING
    ror _ClipXc-1       ; 5 = 41
#endif

    ;   yc=(y0+y1)>>1;
    clc
#ifdef USE_ACCURATE_CLIPPING
    lda _ClipY0-1       ; 3
    adc _ClipY1-1       ; 3
    sta _ClipYc-1       ; 3
#endif
    lda _ClipY0+0       ; 3
    adc _ClipY1+0       ; 3
    sta _ClipYc+0       ; 3

    lda _ClipY0+1       ; 3
    adc _ClipY1+1       ; 3
; divide by 2:
    cmp #$80            ; 2
    ror                 ; 2
    sta _ClipYc+1       ; 3
    ror _ClipYc+0       ; 5
#ifdef USE_ACCURATE_CLIPPING
    ror _ClipYc-1       ; 5 = 41
#endif
    rts                 ; 6 =  6
; total: 88
.)


_ClipSetNormalStartPoints
.(
    ;   x0=LargeX0;
    ;   y0=LargeY0;
    lda _LargeX0+0
    sta _ClipX0+0
    lda _LargeX0+1
    sta _ClipX0+1

    lda _LargeY0+0
    sta _ClipY0+0
    lda _LargeY0+1
    sta _ClipY0+1

    ;   x1=LargeX1;
    ;   y1=LargeY1;
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
    ;   x0=LargeX1;
    ;   y0=LargeY1;
    lda _LargeX1+0
    sta _ClipX0+0
    lda _LargeX1+1
    sta _ClipX0+1

    lda _LargeY1+0
    sta _ClipY0+0
    lda _LargeY1+1
    sta _ClipY0+1

    ;   x1=LargeX0;
    ;   y1=LargeY0;
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


_ClipMoveP1
.(
    ; x1=xc;
    lda _ClipXc+0       ; 3
    sta _ClipX1+0       ; 3
    lda _ClipXc+1       ; 3
    sta _ClipX1+1       ; 3
#ifdef USE_ACCURATE_CLIPPING
    lda _ClipXc-1       ; 3
    sta _ClipX1-1       ; 3
#endif

    ; y1=yc;
    lda _ClipYc+0       ; 3
    sta _ClipY1+0       ; 3
    lda _ClipYc+1       ; 3
    sta _ClipY1+1       ; 3
#ifdef USE_ACCURATE_CLIPPING
    lda _ClipYc-1       ; 3
    sta _ClipY1-1       ; 3
#endif
    rts                 ; 6
; total: 42
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
; total: 42
    rts
.)


_ClipDichoTopBottom
.(
    .(
    ; if (LargeY0==CLIP_TOP/BOTTOM)
    cpy _LargeY0+0
    bne skip
    lda _LargeY0+1
    bne skip
    cpx #OFS_PT0
    bne copy
    rts

copy:
; special case: XY0 == XY1
    jmp _ClipReturnP0
skip
    .)

    .(
    ; if (LargeY1==CLIP_TOP/BOTTOM)
    cpy _LargeY1+0
    bne skip
    lda _LargeY1+1
    bne skip
    cpx #OFS_PT1
    bne copy
    rts

copy:
; special case: XY0 == XY1
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
    jsr _ClipComputeMidPoint; 94        (ClipXY0+ClipXY1)/2

    ;   if (yc==CLIP_TOP/BOTTOM)
    sec
    tya
    sbc _ClipYc+0
    beq done_lo
    lda #0
    sbc _ClipYc+1
not_done_hi
    bmi replace_first

replace_second
    ; if (yc<CLIP_TOP/BOTTOM)
    jsr _ClipMoveP0         ;48
    jmp loop                ; 3

replace_first
    ; if (yc>CLIP_TOP/BOTTOM)
    jsr _ClipMoveP1         ;48
    jmp loop                ; 3

done_lo
    lda #0
    sbc _ClipYc+1
    bne not_done_hi
    jmp _ClipReturnPc
.)


_ClipDichoLeftRight
.(
    .(
    ; if (LargeX0==CLIP_LEFT/RIGHT)
    cpy _LargeX0+0
    bne skip
    lda _LargeX0+1
    bne skip
    cpx #OFS_PT0
    bne copy
    rts

copy:
; special case: XY0 == XY1
    jmp _ClipReturnP0
skip
    .)

    .(
    ; if (LargeX1==CLIP_LEFT/RIGHT)
    cpy _LargeX1+0
    bne skip
    lda _LargeX1+1
    bne skip
    cpx #OFS_PT1
    bne copy
    rts

copy:
; special case: XY0 == XY1
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

; loop until clip point reached:
loop
    jsr _ClipComputeMidPoint    ;94

    ;   if (xc==CLIP_LEFT/RIGHT)
    sec                         ; 2
    tya                         ; 2
    sbc _ClipXc+0               ; 3
    beq done_lo                 ; 2/3= 9/10
    lda #0                      ; 2
    sbc _ClipXc+1               ; 3
not_done_hi
    bmi replace_first           ; 2/3= 7/8

replace_second
    ; if (xc<CLIP_LEFT/RIGHT)
    jsr _ClipMoveP0             ;48
    jmp loop                    ; 3

replace_first
    ; if (xc>CLIP_LEFT/RIGHT)
    jsr _ClipMoveP1             ;48
    jmp loop                    ; 3
; loop total: 161.5

done_lo
    lda #0                      ; 2
    sbc _ClipXc+1               ; 3
    bne not_done_hi             ; 2/3
    jmp _ClipReturnPc           ; 3
.)

_ClipReturnPc
.(
    ; LargeX0/1=ClipXc;
    lda _ClipXc+0
    sta _LargeX0+0,x
    lda _ClipXc+1
    sta _LargeX0+1,x

    ; LargeY/1=ClipYc;
    lda _ClipYc+0
    sta _LargeY0+0,x
    lda _ClipYc+1
    sta _LargeY0+1,x

    rts
.)

_ClipReturnP0
.(
    ; LargeX=LargeX0;
    lda _LargeX0+0
    sta _LargeX1+0
    lda _LargeX0+1
    sta _LargeX1+1

    ; LargeY=LargeY0;
    lda _LargeY0+0
    sta _LargeY1+0
    lda _LargeY0+1
    sta _LargeY1+1

    rts
.)

_ClipReturnP1
.(
    ; LargeX=LargeX1;
    lda _LargeX1+0
    sta _LargeX0+0
    lda _LargeX1+1
    sta _LargeX0+1

    ; LargeY=LargeY1;
    lda _LargeY1+0
    sta _LargeY0+0
    lda _LargeY1+1
    sta _LargeY0+1

    rts
.)


_DrawClippedLine
.(
; The region outcodes for the the endpoints
; Compute the outcode for the first point
    ldx #OFS_PT0            ; 2     XY0
    jsr _ClipFindRegion     ;60     A==0
; Compute the outcode for the second point
    ldx #OFS_PT1            ; 2     XY1
clip_loop
    jsr _ClipFindRegion     ;60     A==0

; In theory, this can never end up in an infinite loop,
; it'll always come in one of the trivial cases eventually

    lda _ClipCode0
    ora _ClipCode1
    bne end_trivial_draw

; /accept because both endpoints are in screen or on the border,
; trivial accept
    lda _LargeX0
    sta _CurrentPixelX
    lda _LargeY0
    sta _CurrentPixelY
    lda _LargeX1
    sta _OtherPixelX
    lda _LargeY1
    sta _OtherPixelY
    jmp _DrawLine

end_trivial_draw

    lda _ClipCode0
    and _ClipCode1
    beq end_invisible_line
; The line isn't visible on screen, trivial reject
    rts

end_invisible_line
    .(
; if no trivial reject or accept, continue the loop
    ldx #OFS_PT0
    lda _ClipCode0
    bne skip
    ldx #OFS_PT1
    lda _ClipCode1
skip

    lsr
    bcc end_clip_bottom
; Clip bottom
    ldy #CLIP_BOTTOM
    jsr _ClipDichoTopBottom
    jmp clip_loop
end_clip_bottom

    lsr
    bcc end_clip_top
; Clip top
    ldy #CLIP_TOP
    jsr _ClipDichoTopBottom
    jmp clip_loop
end_clip_top

    lsr
    bcc end_clip_right
; Clip right
    ldy #CLIP_RIGHT
    jsr _ClipDichoLeftRight
    jmp clip_loop
end_clip_right

    lsr
    bcc clip_loop
; Clip left
    ldy #CLIP_LEFT
    jsr _ClipDichoLeftRight
    jmp clip_loop
    .)
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Double buffer stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;

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
.)
    rts



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
    lda double_buff
    eor #$ff
    sta double_buff
	beq cont

    lda #(CLIP_BOTTOM)
    sta patch_circleclip1+1
    sta patch_circleclip2+1
    sta patch_circleclip3+1
    sta patch_circleclip4+1
    sta patch_circleclip5+1

    lda #(CLIP_TOP)
    sta patch_circleclipT1+1
    sta patch_circleclipT2+1
    sta patch_circleclipT3+1
    sta patch_circleclipT4+1
    sta patch_circleclipT5+1
cont
    jmp _GenerateTables
.)



#endif






