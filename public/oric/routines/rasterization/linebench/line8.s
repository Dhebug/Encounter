; History of timings...
;649
;614 (replacing the update of tmp0)
;607
;588
;583 after alignment
;579

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
save_y          .dsb 1
curBit          .dsb 1

    .text

    .dsb 256-(*&255)

; nop $ea
; inx $e8 11101000
; dex $ca 11001010
; iny $c8 11001000
; dey $88 10001000

#define _NOP    $ea
#define _INX    $e8
#define _DEX    $ca
#define _INY    $c8
#define _DEY    $88
#define _ASL    $0a
#define _LSR    $4a
#define _INC_ZP $e6
#define _DEC_ZP $c6



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

    ; Update screen adress
    .(
    lda tmp0+0                  ; 3
    adc #40                     ; 2
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
    lda #$ca                ; dex
    bne end

cur_smaller                 ; x1<x2
    ; Absolute value
    eor #$ff
    adc #1
    sta dx

    lda #$e8                ; inx
end
.)

    jmp alignIt

    .dsb 256-(*&255)

alignIt
    ; Compute slope and call the specialized code for mostly horizontal or vertical lines
    ldy dy
    beq draw_totaly_horizontal_8
    cpy dx
    bcs draw_mainly_vertical_8

draw_mainly_horizontal_8
    .(
    ; here we have DY in Y, and the OPCODE in A
    sta __auto_stepx        ; Write a (dex / nop / inx) instruction
    cmp #$ca                ; dex?
    bne skipDex
    dey                     ; adjust for carry being set in loop
skipDex
    sty __auto_ady+1

    lda dx
    sta __auto_dx+1

    lda _OtherPixelX
    sta __auto_cpx+1

    ldx _CurrentPixelX      ;Plotting coordinates
    ldy _CurrentPixelY      ;in X and Y

    lda dx
    lsr
    eor #$ff
;    clc

loopX
    sta save_a              ; 3 =  3
loopY
    ; Draw the pixel
__auto_div6
    ldy _TableDiv6,x        ; 4
__auto_bit6
    lda _TableBit6Reverse,x ; 4
    eor (tmp0),y            ; 5*
    sta (tmp0),y            ; 6*= 19

__auto_cpx
    cpx #00                 ; 2         At the endpoint yet?
    beq exitLoop            ; 2/3
__auto_stepx
    inx                     ; 2         Step in x
    lda save_a              ; 3
__auto_ady
    adc #00                 ; 2         +DY
    bcc loopX               ; 2/3=13/14
    ; Time to step in y
__auto_dx
    sbc #00                 ; 2         -DX
    sta save_a              ; 3 =  5

    ; Set the new screen adress
    lda tmp0+0              ; 3
    adc #40                 ; 2
    sta tmp0+0              ; 3
    bcc loopY               ; 2/3=10/11 ~84 taken
    inc tmp0+1              ; 5
    bcs loopY               ; 3 =  8
; average: 12.12

exitLoop
    rts
; Timings:
; x++/y  : 36
; x++/y++: 49.12
; average: 42.56
    .)

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
;    sta __auto_stepx        ;       Write a (dex / nop / inx) instruction
    cmp #_DEX               ;       which direction
    bne doInx
; dex, moving left:
    lda #%00100000
    sta __auto_cpBit+1
    lda #_ASL               ;
    sta __auto_shBit
    lda #%00000001
    sta __auto_ldBit+1
    lda #_DEY
    sta __auto_yLo
    lda #$ff
    sta __auto_cpY+1
    lda #_DEC_ZP
    sta __auto_yHi
    bne endX

doInx
; inx, moving right
    lda #%00000001
    sta __auto_cpBit+1
    lda #_LSR
    sta __auto_shBit
    lda #%00100000
    sta __auto_ldBit+1
    lda #_INY
    sta __auto_yLo
    lda #$00
    sta __auto_cpY+1
    lda #_INC_ZP
    sta __auto_yHi
endX
; setup X
    tya                     ;       y = dY
    tax
    inx                     ;       x = dY+1
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
    eor #$ff                ; -DX/2
    clc                     ; 2
    bcc loopY               ; 3
; a = sum, y = tmp0, x = dY+1, tmp0 = 0

incHiPtr                    ; 9
    inc tmp0+1              ; 5
    clc                     ; 2
    bcc contHiPtr           ; 3

loopY
    sta save_a              ; 3 =  3
    ; Draw the pixel
    lda curBit              ; 3
    eor (tmp0),y            ; 5*
    sta (tmp0),y            ; 6*= 14**

    dex                     ; 2         At the endpoint yet?
    beq exitLoop            ; 2/3= 4/5
loopX
    ; Update screen adress
    tya                     ; 2
    adc #40                 ; 2
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
__auto_cpBit
    cmp #%00100000          ; 2         %00100000/%00000001
    beq nextColumn          ; 2/14.07   ~17% taken
__auto_shBit
    asl                     ; 2         asl/lsr, clears carry
contNextColumn
    sta curBit              ; 3 =~13.71

    ; Draw the pixel
    eor (tmp0),y            ; 5*
    sta (tmp0),y            ; 6*= 11**
    dex                     ; 2         At the endpoint yet?
    bne loopX               ; 2/3= 4/5
exitLoop
    rts

nextColumn
__auto_ldBit
    lda #%00000001          ; 2         %00000001/%00100000
__auto_yLo
    dey                     ; 2
__auto_cpY
    cpy #$ff                ; 2
    clc                     ; 2         TODO: optimize
    bne contNextColumn      ; 2/3       ~99% taken
__auto_yHi
    dec tmp0+1              ; 5
    bcc contNextColumn      ; 3

; x  ,y++: 38.76** (50%)
; x++,y++: 51.47** (50%)
; average: 45.11**


; x  ,y++: 54.12**
; x++,y++: 57.12**
; average: 55.62**
    .)
