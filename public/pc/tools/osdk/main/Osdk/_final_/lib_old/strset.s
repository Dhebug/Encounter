; char *strset(char *s, char c)

_strset
        ldy #2
        lda (sp),y
        sta strset1+6   ; low(c)
        dey
        lda (sp),y
        sta strset1+2   ; high(s)
        sta strset1+9   ; high(s)
        sta strset2+3   ; return value, high byte
        dey
        lda (sp),y
        sta strset1+1   ; low(s)
        sta strset1+8   ; high(s)
        sta strset2+1   ; return value, low byte

strset1
        lda $2211,y
        beq strset2
        lda #$66
        sta $9988,y
        iny
        bne strset1

        inc strset1+2
        inc strset1+9
        jmp strset1

strset2
        ldx #1
        lda #3
        rts

