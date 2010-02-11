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

; TODOs:
; + chunking (-35)
; - two separate branches instead of patching?
; + countdown minor
;   x mainly_horizontal (won't work)
;   + mainly_vertical (-9)
; o optimizing for space (-2 tables and one alignment page)
; - optimize horizontal
; - optimize vertical
; + correct branch taken percentages

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
#define _INC_ABS    $ee
#define _DEC_ABS    $ce
#define _STA_ZP     $85
#define _CPY_IMM    $c0


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
    bcc skip                    ; 2/3       84.4% taken
    inc tmp0+1                  ; 5
    clc                         ; 2
skip                            ;   = 9.94
    .)
    dex                         ; 2
    bne loop                    ; 2/3=4/5
    rts
; average: 27.94
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
    bcc cur_smaller
    beq end

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

    bcs end

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
    beq draw_totaly_vertical_8
    ldx #_DEX
    bcs cur_bigger

cur_smaller                 ; x1<x2
    ; Absolute value
    eor #$ff
    adc #1
    sta dx

    ldx #_INX
cur_bigger                  ; x1>x2
    sta dx
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
    ; here we have DY in Y, and the OPCODE in X
    stx _outer_patch    ; Write a (dex / inx) instruction

    ldx _OtherPixelX
    stx __auto_cpx+1

    ldx _CurrentPixelX

    ;
    ; Draw loop
    ;
outer_loop
    ldy _TableDiv6,x            ; 4
    lda _TableBit6Reverse,x     ; 4
    and #$7f                    ; 2
    eor (tmp0),y                ; 5
    sta (tmp0),y                ; 6 = 19

_outer_patch
    inx                         ; 2

__auto_cpx
    cpx #00                     ; 2     At the endpoint yet?
    bne outer_loop              ; 2
    rts
.)

;**********************************************************
draw_mainly_horizontal_8
.(
; A = DX, Y = DY, X = opcode
;    lda dx
    lsr
    cmp dy
    bcc contMainly
    jmp draw_very_horizontal_8

contMainly
    sty __auto_dy+1

; all this stress to be able to use dex, beq :)
    cpx #_INX
    beq doInx

    lda #_DEY
    sta __auto_stepx
    lda #$ff
    sta __auto_cpy+1
    ldy #_DEC_ABS

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
    ldy #_INC_ABS

    lda #X_SIZE-1
;    sec
    sbc _OtherPixelX
    ldx #>_TableBit6        ;
endPatch
    sty __auto_yHi0
    sty __auto_yHi1
    sta __auto_bit6+1
    sta __auto_bit6_0+1
    stx __auto_bit6+2
    stx __auto_bit6_0+2

    ldx _CurrentPixelX
    lda _TableDiv6,x
    clc
    adc tmp0
    tay
    lda tmp0+1
    adc #0
    sta __auto_ptr0+2
    sta __auto_ptr1+2

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
    and #$7f                 ;          remove signal bit
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
__auto_ptr0
    eor $a000,y             ; 4
__auto_ptr1
    sta $a000,y             ; 5 = 17.06

    dex                     ; 2         Step in x
    beq exitLoop            ; 2/3       At the endpoint yet?
    lda save_a              ; 3
__auto_dy
    adc #00                 ; 2         +DY
    bcc loopX               ; 2/3=11/12 ~28.0% taken (not 50% due do to special code for very horizontal lines)
    ; Time to step in y
__auto_dx
    sbc #00                 ; 2         -DX
    sta save_a              ; 3 =  5

; update the screen address:
    tya                     ; 2
    adc #ROW_SIZE           ; 2
    tay                     ; 2
    bcc loopY               ; 2/3= 8/9  ~84.4% taken
    inc __auto_ptr0+2       ; 6
    inc __auto_ptr1+2       ; 6
    clc                     ; 2
    bcc loopY               ; 3 = 17
; average: 11.83

exitLoop
    rts

nextColumn
    and #$7f                ; 2         remove signal bit
__auto_stepx
    iny                     ; 2
__auto_cpy
    cpy #$00                ; 2
    clc                     ; 2
    bne contColumn          ; 2/3=10/11 99% taken
__auto_yHi0
    inc __auto_ptr0+2       ; 6
__auto_yHi1
    inc __auto_ptr1+2       ; 6
    bcc contColumn          ; 3

; Timings:
; x++/y  : 32.06 (28.0%) <- corrected!
; x++/y++: 44.89 (72.0%) <- corrected!
; average: 41.30
.)

;    .dsb 256-(*&255)
;**********************************************************
draw_very_horizontal_8
.(
; dX > 2*dY, here we use "chunking"
; here we have DY in Y, and the OPCODE (inx, dex) in A
    sty __auto_dy0+1
    sty __auto_dy1+1
    sty __auto_dy2+1
    cpx #_INX
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
    sta save_a              ; save_a = _CurrentPixelX % 6
    lda _CurrentPixelX
    sec
    sbc save_a
; patch the code:
    plp
    beq doInx
; negative x-direction
    tax

    lda #_DEY
    sta __auto_stepx
    sta __auto_stepx2
    lda #_CPY_IMM
    sta __auto_cpy
    sta __auto_cpy2
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
    sta save_a
    lda #BYTE_PIXEL-1
    sbc tmp0
    tax

    lda #_INY
    sta __auto_stepx
    sta __auto_stepx2
    lda #_STA_ZP
    sta __auto_cpy
    sta __auto_cpy2
    lda #<save_a            ; 2
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
; a = sum, x = _CurrentPixelX % 6, y = ptr-offset

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
    bne contColumn          ; 2/3=31/32 99% taken
__auto_yHi
    inc tmp0+1              ; 5         dec/inc
    clc                     ; 2
    bcc contColumn          ; 3 = 10
;----------------------------------------------------------
loopY
    dec dy                  ; 5         all but one vertical segments drawn?
    beq exitLoop            ; 2/3= 7/8   yes, exit loop
    dex                     ; 2
    bmi nextColumn          ; 2/38.04   ~16.7% taken (this will continue below)
__auto_dy0
    adc #00                 ; 2 = 11.67 +DY, no check necessary here!
loopX
    dex                     ; 2
    bmi nextColumn          ; 2/35.04   ~16.7% taken
contColumn                  ;   =  9.51
__auto_dy1
    adc #00                 ; 2         +DY
    bcc loopX               ; 2/3= 4/5  ~76.4% taken
    ; Time to step in y
__auto_dx
    sbc #00                 ; 2         -DX
    sta save_a              ; 3 =  5

; plot the last bits of current segment:
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
; x++/y  : 14.51 (76.4%)
; x++/y++: 62.07 (23.6%)
; average: 25.73
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
    bcc loopXEnd            ; 2/3= 4/5  ~38.2% taken

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
    bne contColumnEnd       ; 2/3=31/32 99% taken
__auto_yHi2
    inc tmp0+1              ; 5         dec/inc
    clc                     ; 2
    bcc contColumnEnd       ; 3 = 10

    .dsb 256-(*&255)

Pot2PTbl
    .byte   %00000001, %00000011, %00000111, %00001111
    .byte   %00011111, %00111111
Pot2NTbl
    .byte   %00100000, %00110000
    .byte   %00111000, %00111100, %00111110, %00111111
.)

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
    cpx #_DEX               ;           which direction?
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
    lda #_DEC_ABS
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
    lda #_INC_ABS
endPatch
    stx __auto_cpY+1
    sta __auto_yHi0
    sta __auto_yHi1
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
    lda tmp0+1
    adc #0
    sta __auto_ptr0+2
    sta __auto_ptr1+2
;    bcc skipTmp0
;    inc tmp0+1
;skipTmp0
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
    inc __auto_ptr0+2       ; 6
    inc __auto_ptr1+2       ; 6
    clc                     ; 2
    bcc contHiPtr           ; 3
;----------------------------------------------------------
loopY
    sta save_a              ; 3
    lda curBit              ; 3 =  6
loopX
    ; Draw the pixel
__auto_ptr0
    eor $a000,y             ; 4
__auto_ptr1
    sta $a000,y             ; 5 =  9
; update the screen address:
    tya                     ; 2
    adc #ROW_SIZE           ; 2
    tay                     ; 2
    bcs incHiPtr            ; 2/20      ~15.6% taken
contHiPtr                   ;   = 11.00 average
    lda save_a              ; 3
__auto_dx1
    adc #00                 ; 2         +DX
    bcc loopY               ; 2/3= 7/8  ~41.4% taken
    ; Time to step in x
__auto_dy
    sbc #00                 ; 2         -DY
    sta save_a              ; 3 =  5

    lda curBit              ; 3
__auto_cpBit                ;           TODO: optimize
    cmp #%00100000          ; 2         %00100000/%00000001
    beq nextColumn          ; 2/14.05   ~16.7% taken
__auto_shBit
    asl                     ; 2         asl/lsr, clears carry
contNextColumn
    sta curBit              ; 3 =~13.68
; step in x:
    dex                     ; 2         At the endpoint yet?
    bne loopX               ; 2/3= 4/5

; x  ,y++: 34.00 (41.4%) <- corrected!
; x++,y++: 50.68 (58.6%) <- corrected!
; average: 43.77

; draw the last vertical line segment:
    ldx __auto_ptr0+2       ; 4
    stx tmp0+1              ; 3
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
    bcc loopYEnd            ; 2/3= 6/7  ~20.7% taken
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
__auto_yHi0
    dec __auto_ptr0+2       ; 6         dec/inc
__auto_yHi1
    dec __auto_ptr1+2       ; 6         dec/inc
    bcc contNextColumn      ; 3

incHiPtrEnd                 ; 9
    inc tmp0+1              ; 5
    clc                     ; 2
    bcc contHiPtrEnd        ; 3
;----------------------------------------------------------
.)

; *** total timings: ***
; draw_very_horizontal_8   (29.5%): 25.73
; draw_mainly_horizontal_8 (20.5%): 41.30
; draw_mainly_vertical_8   (50.0%): 43.77
;----------------------------------------
; total average           (100.0%): 37.94