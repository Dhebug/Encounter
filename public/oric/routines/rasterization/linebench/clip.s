; History of linebench timings...
; without, trivial, worst case, 7331 clipping
; 451, 466, 636,  -  (initial version)
; 451, 459, 624, 424
; 451; 459, 614, 422
; 451; 459, 609, 418

#include "params.h"

    .zero

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

#define OFS_PT0 0
#define OFS_PT1 (_LargeX1-_LargeX0)

    .text

_Break
    jmp _Break
    rts


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
    ldy _LargeY0+1,x    ;
    bmi clip_top        ;       if Y-Hi <= -1, clip top
    bne clip_bottom     ;       else, if Y-Hi != 0, clip bottom

; initialize with 'not clipped'
    lda #0

    ldy _LargeY0+0,x
#if CLIP_TOP <> 0
    cpy #CLIP_TOP       ;       = 5
    bcc clip_top
#endif
    cpy #(CLIP_BOTTOM+1);       = 194
    bcc end_top_bottom
clip_bottom
    lda #1              ;       means (y > CLIP_BOTTOM)
    bne end_top_bottom

clip_top
    lda #2              ;       means (y < CLIP_TOP)
end_top_bottom

; xHi >= $01 -> clip_right
; xHi == $00 -> check xLo
; xHi <= $ff -> clip_left

; left/right test
    ldy _LargeX0+1,x
    bmi clip_left       ;       if X-Hi <=- 1, clip left
    bne clip_right      ;       else, if X-Hi != 0, clip bottom

    ldy _LargeX0+0,x
#if CLIP_LEFT <> 0
    cpy #CLIP_LEFT
    bcc clip_left
#endif
    cpy #(CLIP_RIGHT+1)
    bcc end_left_right
clip_right
    ora #4              ;       means (x > CLIP_RIGHT)
    bne end_left_right  ; 3

clip_left
    ora #8              ;       means (x < CLIP_LEFT)
end_left_right
    sta _ClipCode0,x
    rts
.)


_ClipComputeMidPoint
.(
    ;   xc=(x0+x1)>>1;
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
; divide by 2:
    cmp #$80
    ror
    sta _ClipXc+1
    ror _ClipXc+0
#ifdef USE_ACCURATE_CLIPPING
    ror _ClipXc-1
#endif

    ;   yc=(y0+y1)>>1;
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
; divide by 2:
    cmp #$80
    ror
    sta _ClipYc+1
    ror _ClipYc+0
#ifdef USE_ACCURATE_CLIPPING
    ror _ClipYc-1
#endif
    rts
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
    rts
skip
    .)

    .(
    ; if (LargeY1==CLIP_TOP/BOTTOM)
    cpy _LargeY1+0
    bne skip
    lda _LargeY1+1
    bne skip
    rts
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
    jsr _ClipComputeMidPoint ; (ClipXY0+ClipXY1)/2

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
    jsr _ClipMoveP0
    jmp loop

replace_first
    ; if (yc>CLIP_TOP/BOTTOM)
    jsr _ClipMoveP1
    jmp loop

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
    rts
skip
    .)

    .(
    ; if (LargeX1==CLIP_LEFT/RIGHT)
    cpy _LargeX1+0
    bne skip
    lda _LargeX1+1
    bne skip
    rts
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
    jsr _ClipComputeMidPoint

    ;   if (xc==CLIP_LEFT/RIGHT)
    sec
    tya
    sbc _ClipXc+0
    beq done_lo
    lda #0
    sbc _ClipXc+1
not_done_hi
    bmi replace_first

replace_second
    ; if (xc<CLIP_LEFT/RIGHT)
    jsr _ClipMoveP0
    jmp loop

replace_first
    ; if (xc>CLIP_LEFT/RIGHT)
    jsr _ClipMoveP1
    jmp loop

done_lo
    lda #0
    sbc _ClipXc+1
    bne not_done_hi
    jmp _ClipReturnPc
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

_DrawClippedLine
.(
; The region outcodes for the the endpoints
; Compute the outcode for the first point
    ldx #OFS_PT0        ; XY0
    jsr _ClipFindRegion
; Compute the outcode for the second point
    ldx #OFS_PT1        ; XY1
clip_loop
    jsr _ClipFindRegion

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
    jmp _DrawLine8

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

