; char *strchr(char *s, char c)

_strchr
        ldy #0
        lda (sp),y
        sta strchr1+1   ; low(s)
        iny
        lda (sp),y
        sta strchr1+2   ; high(s)
        iny
        lda (sp),y
        sta strchr1+6   ; low(c)
        ldx #0

strchr1
        lda $2211,X
        beq strchr2
        cmp #$06
        beq strchr3
        inx
        bne strchr1
        inc strchr1+2
        jmp strchr1

strchr2
        jmp retzero     ; character not found, return NULL

strchr3
        clc             ; character found, return pointer to it within s
        txa
        adc strchr1+1
        tax
        lda strchr1+2
        adc #0
        rts

