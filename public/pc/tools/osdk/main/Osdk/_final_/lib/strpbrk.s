; char *strpbrk(char *s1, char *s2)

_strpbrk
        jsr _strcspn
        stx tmp
        sta tmp+1

        ldy #0
        lda (sp),y
        clc
        adc tmp
        sta tmp
        tax

        iny
        lda (sp),y
        adc tmp+1
        sta tmp+1

        dey
        lda (tmp),y
        bne strpbrk1    ; *tmp=='\0'?
        ldx #0          ; return NULL
        rts

strpbrk1
        lda tmp+1
        rts
