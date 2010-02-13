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
;451 refactored to make x-direction always positive (37.16)

; TODOs:
; + chunking (-35)
; - two separate branches instead of patching?
; + countdown minor
;   x mainly_horizontal (won't work)
;   + mainly_vertical (-9)
; o optimizing for space (-2 tables and one alignment page)
; - optimize horizontal (merge with very_horizontal)
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


;#define OPP         ORA
#define OPP         EOR

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
#define _ADC_IMM    $69
#define _SBC_IMM    $e9
#define _BCC        $90
#define _BCS        $b0
#define _CLC        $18
#define _SEC        $38


    .text

;    .dsb 256-(*&255)

;**********************************************************
draw_totaly_horizontal_8
.(
; here we have DY in Y, and the OPCODE in X
    ldx _OtherPixelX
    inx
    stx _patch_cpx+1
    ldx _CurrentPixelX
;
; draw loop
;
outer_loop
    ldy _TableDiv6,x            ; 4
    lda _TableBit6Reverse,x     ; 4
    OPP (tmp0),y                ; 5
    sta (tmp0),y                ; 6 = 19

    inx                         ; 2
_patch_cpx
    cpx #00                     ; 2     At the endpoint yet?
    bne outer_loop              ; 2
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
    beq draw_totaly_horizontal_8
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
    beq doIny

; dey -> moving down:
    ldx _OtherPixelX
    bcc endPatch

doIny
; inx -> moving up:
    clc
    ldx _CurrentPixelX
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
    sta save_a              ; save_a = _CurrentPixelX % 6
    lda _CurrentPixelX
    sec
    sbc save_a
    sta save_a
    lda #BYTE_PIXEL-1
    sbc save_a
    tax
    lda Pot2PTbl,x
    sta chunk

; patch the code:
    plp
    beq doIny
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
_patch_pot1
    lda Pot2PTbl,x          ; 4
    eor chunk               ; 3
    OPP (tmp0),y            ; 5
    sta (tmp0),y            ; 6
_patch_pot2
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
_patch_pot3
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
    bne contHiPtr           ; 3
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
contHiPtr                   ;   = 11.00 average
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

; x  ,y++: 34.00 (41.4%)
; x++,y++: 48.68 (58.6%)
; average: 42.60

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
; draw_mainly_vertical_8   (50.0%): 42.60 (was 43.77)
;----------------------------------------
; total average           (100.0%): 37.16 (was 37.94)