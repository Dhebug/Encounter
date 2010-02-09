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

; TODOs:
; + chunking (-35)
; - two separate branches instead of patching?
; + countdown minor
;   x mainly_horizontal (won't work)
;   + mainly_vertical (-9)

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

;    .dsb 256-(*&255)

;**********************************************************
draw_totaly_vertical_8
.(
    ldx _CurrentPixelX
    ldy _TableDiv6,x
    lda _TableBit6Reverse,x     ; 4
    and #$7f
    sta _mask_patch+1
    ldx dy
    inx
    clc                         ; 2
loop
_mask_patch
    lda #0                      ; 2
    eor (tmp0),y                ; 5*
    sta (tmp0),y                ; 6*= 13**

; update the screen address:
    .(
    tya                         ; 2
    adc #ROW_SIZE               ; 2
    tay                         ; 2
    bcc skip                    ; 2/3= 8/9
    inc tmp0+1                  ; 5
    clc                         ; 2 =  7
skip                            ;
    .)
    dex                         ; 2
    bne loop                    ; 2/3=4/5
    rts
.)


;**********************************************************
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

;**********************************************************
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
    and #$7f
    eor (tmp0),y                ; 5
    sta (tmp0),y                ; 6

_outer_patch
    inx

__auto_cpx
    cpx #00                     ; At the endpoint yet?
    bne outer_loop
    rts
.)

;**********************************************************
draw_mainly_horizontal_8
.(
    tax
    lda dx
    lsr
    cmp dy
    bcc contMainly
    jmp draw_very_horizontal_8
contMainly

; here we have DY in Y, and the OPCODE (inx, dex) in A
    sty __auto_dy+1

; all this stress to be able to use dex, beq :)
    cpx #_INX
    beq doInx

    lda #_DEY
    sta __auto_stepx
    lda #$ff
    sta __auto_cpy+1
    ldy #_DEC_ZP

    lda #<_TableBit6Reverse-1   ; == 0
;    clc
    adc _OtherPixelX
    ldx #>_TableBit6Reverse ;
    bne endPatch

doInx
    lda #_INY
    sta __auto_stepx
    lda #$00
    sta __auto_cpy+1
    ldy #_INC_ZP

    lda #X_SIZE-1
;    sec
    sbc _OtherPixelX
    ldx #>_TableBit6        ;
endPatch
    sty __auto_yHi
    sta __auto_bit6+1
    sta __auto_bit6_0+1
    stx __auto_bit6+2
    stx __auto_bit6_0+2

    ldx _CurrentPixelX
    lda _TableDiv6,x
    clc
    adc tmp0
    tay
    bcc skipInc
    inc tmp0+1
skipInc
    lda #0
    sta tmp0

    lda dx
  tax
    inx                     ; 2         +1 since we count to 0
    sta __auto_dx+1
    lsr
    eor #$ff
    clc

    sta save_a              ; 3 =  3
__auto_bit6_0
    lda _TableBit6Reverse-1,x;4
    and #$7f
    bcc contColumn

; a = sum, x = dX+1
;----------------------------------------------------------
loopX
    sta save_a              ; 3 =  3
loopY
__auto_bit6
    lda _TableBit6Reverse-1,x;4
    bmi nextColumn          ; 2/14      16.7% taken
contColumn
    eor (tmp0),y            ; 5
    sta (tmp0),y            ; 6 = 19

    dex                     ; 2         Step in x
    beq exitLoop            ; 2/3       At the endpoint yet?
    lda save_a              ; 3
__auto_dy
    adc #00                 ; 2         +DY
    bcc loopX               ; 2/3=11/12 ~33.3% taken (not 50% due do to special code for very horizontal lines)
    ; Time to step in y
__auto_dx
    sbc #00                 ; 2         -DX
    sta save_a              ; 3 =  5

; update the screen address:
    tya                     ; 2
    adc #ROW_SIZE           ; 2
    tay                     ; 2
    bcc loopY               ; 2/3= 8/9  ~84.4% taken
    inc tmp0+1              ; 5
    clc                     ; 2
    bcc loopY               ; 3 = 10
; average: 10.40

exitLoop
    rts

nextColumn
    and #$7f                ; 2         remove signal bit
__auto_stepx
    iny                     ; 2
__auto_cpy
    cpy #$00                ; 2
    clc                     ; 2
    bne contColumn          ; 2/3=10/11
__auto_yHi
    inc tmp0+1              ; 5
    bcc contColumn          ; 3

; Timings:
; x++/y  : 34.00 (33.3%)
; x++/y++: 45.40 (66.7%)
; average: 41.61
.)

    .dsb 256-(*&255)
;**********************************************************
draw_very_horizontal_8
.(
; dX > 2*dY, here we use "chunking"
; here we have DY in Y, and the OPCODE (inx, dex) in A
    sty __auto_dy+1
    sty __auto_dy2+1
    cpx #_INX
    php
; setup pointer and Y:
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
; patch the code:
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
    bcc loopX
; a = sum, x = dX+1, y = ptr-offset

;----------------------------------------------------------
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
;----------------------------------------------------------
loopY
    dec dy                  ; 5         all but one vertical segments drawn?
    beq exitLoop            ; 2/3= 7/8  yes, exit loop
loopX
    dex                     ; 2
    bmi nextColumn          ; 2/37.03   ~16.7% taken
contColumn                  ;   =  9.85
__auto_dy
    adc #00                 ; 2         +DY
    bcc loopX               ; 2/3= 4/5  ~75% taken
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
;----------------------------------------------------------
exitLoop
; draw the last horizontal line segment:
    adc lastSum             ; 3
loopXEnd
    dex                     ; 2
    bmi nextColumnEnd       ; 2/37.03   ~16.7% taken
contColumnEnd               ;   =  9.85
__auto_dy2
    adc #00                 ; 2         +DY
    bcc loopXEnd            ; 2/3= 4/5  ~50% taken

; plot last chunk:
__auto_pot3
    lda Pot2PTbl,x          ; 4
    eor chunk               ; 3
    eor (tmp0),y            ; 5
    sta (tmp0),y            ; 6 = 18
    rts
;----------------------------------------------------------
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
;**********************************************************
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
    ldx dx                  ;           X = dx
    stx __auto_dx1+1
    stx __auto_dx2+1
; setup current bit:
    ldy _CurrentPixelX
    lda _TableBit6Reverse,y ; 4
    and #$7f
    sta curBit
; setup pointer and Y:
; TODO: self-modyfing code for the ptrs?
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
    sta lastSum
    eor #$ff                ;           -DY/2
    clc                     ; 2
    bcc loopY               ; 3
; a = sum, y = tmp0, x = dX, tmp0 = 0
;----------------------------------------------------------
incHiPtr                    ;
    inc tmp0+1              ; 5
    clc                     ; 2
    bcc contHiPtr           ; 3
;----------------------------------------------------------
loopY
    sta save_a              ; 3
    lda curBit              ; 3 =  6
loopX
    ; Draw the pixel
    eor (tmp0),y            ; 5
    sta (tmp0),y            ; 6 = 11
; update the screen address:
    tya                     ; 2
    adc #ROW_SIZE           ; 2
    tay                     ; 2
    bcs incHiPtr            ; 2/13      ~15.6% taken
contHiPtr                   ;   =  9.72 average
    lda save_a              ; 3
__auto_dx1
    adc #00                 ; 2         +DX
    bcc loopY               ; 2/3= 7/8  ~50% taken
    ; Time to step in x
__auto_dy
    sbc #00                 ; 2         -DY
    sta save_a              ; 3 =  5

    lda curBit              ; 3
__auto_cpBit                ;           TODO: optimize
    cmp #%00100000          ; 2         %00100000/%00000001
    beq nextColumn          ; 2/14.07   ~16.7% taken
__auto_shBit
    asl                     ; 2         asl/lsr, clears carry
contNextColumn
    sta curBit              ; 3 =~13.68
; step in x:
    dex                     ; 2         At the endpoint yet?
    bne loopX               ; 2/3= 4/5

; x  ,y++: 34.72 (50%)
; x++,y++: 51.40 (50%)
; average: 43.06

; draw the last vertical line segment:
    lda save_a              ; 3
    adc lastSum             ; 3
loopYEnd
    tax                     ; 2 =  2
    ; Draw the pixel
    lda curBit              ; 3
    eor (tmp0),y            ; 5
    sta (tmp0),y            ; 6 = 14
; update the screen address:
    tya                     ; 2
    adc #ROW_SIZE           ; 2
    tay                     ; 2
    bcs incHiPtrEnd         ; 2/13      ~15.6% taken
contHiPtrEnd                ;   =  9.72 average
    txa                     ; 2
__auto_dx2
    adc #00                 ; 2         +DX
    bcc loopYEnd            ; 2/3= 6/7  ~25% taken
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

incHiPtrEnd                 ; 9
    inc tmp0+1              ; 5
    clc                     ; 2
    bcc contHiPtrEnd        ; 3
;----------------------------------------------------------
.)

; *** total timings: ***
; draw_very_horizontal_8   (29.6%): 27.20
; draw_mainly_horizontal_8 (20.4%): 41.61 <- corrected!
; draw_mainly_vertical_8   (50.0%): 43.06
;----------------------------------------
; total average           (100.0%): 38.07