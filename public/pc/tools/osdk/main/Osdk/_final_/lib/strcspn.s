; int strcspn(char *s1, char *s2)

_strcspn
        ldy #3          ; s2
        lda (sp),y
        sta tmp1+1
        dey
        lda (sp),y
        sta tmp1
        dey             ; s1
        lda (sp),y
        sta strcspn1+2
        dey
        lda (sp),y
        sta strcspn1+1

        ldx #0
        stx tmp2

strcspn1
        lda $2211,x
        beq strcspn3
        sta tmp

        ldy #0          ; inner loop, init
        lda tmp1
        sta strcspn2+1
        lda tmp1+1
        sta strcspn2+2

strcspn2                ; inner loop, loop
        lda $2211,y
        beq strcspn1a
        cmp tmp

        beq strcspn3
        iny
        bne strcspn2
        inc strcspn2+2
        jmp strcspn2

strcspn1a
        inx             ; back to the outer loop
        bne strcspn1
        inc strcspn1+2
        inc tmp2
        jmp strcspn2

strcspn3
        lda tmp2
        rts
