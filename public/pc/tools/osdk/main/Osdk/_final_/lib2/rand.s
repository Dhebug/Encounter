_rand
_random
        ldx #$ff
        jsr $E355
        ldx $D2
        lda $D1
        rts

_srandom
        ldy #0
        lda (sp),y
        sta $FC
        sta $FE
        iny
        lda (sp),y
        sta $FB
        sta $FD
        lda #$80
        sta $FA
        rts
