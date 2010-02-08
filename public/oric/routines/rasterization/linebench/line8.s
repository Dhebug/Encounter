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


; TODOs:
; + chunking
; - two separate branches instead of patching?
; - countdown minor
;   - mainly horizontal
;   - mainly vertical

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
    eor (tmp0),y                ; 5
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
    sta __auto_cpx+1

    ldx _CurrentPixelX

    ;
    ; Draw loop
    ;
outer_loop
    ldy _TableDiv6,x
    lda _TableBit6Reverse,x     ; 4
    eor (tmp0),y                ; 5
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
    eor (tmp0),y            ; 5*
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
    eor (tmp0),y            ; 5
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
    eor (tmp0),y            ; 5
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
    eor (tmp0),y            ; 5
    sta (tmp0),y            ; 6 = 18
    rts

nextColumnEnd                  ;
    tax                     ; 2
    lda chunk               ; 3
    eor (tmp0),y            ; 5
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
    eor (tmp0),y            ; 5
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
    eor (tmp0),y            ; 5
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



