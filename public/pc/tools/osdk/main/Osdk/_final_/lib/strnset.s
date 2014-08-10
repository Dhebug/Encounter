; char *strnset(char *s, char c, int n)

_strnset
        ldy #5          ; get n
        lda (sp),y
        sta tmp
        dey
        lda (sp),y
        tax

        ldy #2
        lda (sp),y
        sta strnset1+6  ; low(c)
        dey
        lda (sp),y
        sta strnset1+2  ; high(s)
        sta strnset1+9 ; high(s)
        sta strnset2+3  ; return value, high byte
        dey
        lda (sp),y
        sta strnset1+1  ; low(s)
        sta strnset1+8 ; high(s)
        sta strnset2+1  ; return value, low byte

strnset0
        dex             ; decrease n
        cpx #$ff
        bne strnset1
        dec tmp
        lda tmp
        cmp #$ff
        beq strnset2    ; n<0?

strnset1
        lda $2211,y
        beq strnset2
        lda #$66
        sta $9988,y
        iny
        bne strnset0

        inc strnset1+2
        inc strnset1+9
        jmp strnset0

strnset2
        ldx #1
        lda #3
        rts

