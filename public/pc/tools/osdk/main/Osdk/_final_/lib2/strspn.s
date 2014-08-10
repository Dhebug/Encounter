; int strspn(char *s1, char *s2)

_strspn
        ldy #3          ; s2
        lda (sp),y
        sta tmp1+1
        dey
        lda (sp),y
        sta tmp1
        dey             ; s1
        lda (sp),y
        sta strspn1+2
        dey
        lda (sp),y
        sta strspn1+1

        ldx #0
        stx tmp2

strspn1
        lda $2211,x
        beq strspn3
        sta tmp

        ldy #0          ; inner loop, init
        lda tmp1
        sta strspn2+1
        lda tmp1+1
        sta strspn2+2

strspn2                ; inner loop, loop
        lda $2211,y
        beq strspn3
        cmp tmp

        beq strspn1a
        iny
        bne strspn2
        inc strspn2+2
        jmp strspn2

strspn1a
        inx             ; back to the outer loop
        bne strspn1
        inc strspn1+2
        inc tmp2
        jmp strspn2

strspn3
        lda tmp2
        rts
