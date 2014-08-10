; char *strrchr(char *s, char c)

_strrchr
        ldy #0
        lda (sp),y
        sta strrchr1+1  ; low(s)
        iny
        lda (sp),y
        sta strrchr1+2  ; high(s)
        iny
        lda (sp),y
        sta strrchr1+6  ; low(c)
        lda #00
        sta tmp1
        ldx #0
        ldy #0

strrchr1                ; loop through the string
        lda $2211,X
        beq strrchr2
        cmp #$06
        beq strrchr1a

strrchr1b
        inx
        bne strrchr1
        inc strrchr1+2
        iny
        jmp strrchr1

strrchr1a
        stx tmp0        ; found an occurence, store delta pointer to it
        sty tmp0+1
        lda #$01
        sta tmp1        ; flag found=1
        jmp strrchr1b

strrchr2
        lda tmp1
        beq strrchr3    ; found character?

        clc             ; character found, return pointer to it within s
        lda tmp0
        adc strrchr1+1
        tax             ; low order byte
        lda tmp0+1
        adc strrchr1+2  ; high order byte
        rts

strrchr3
        jmp retzero     ; character not found, return NULL
