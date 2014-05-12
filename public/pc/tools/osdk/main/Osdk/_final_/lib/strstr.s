; char *strstr(char *s1,char *s2)

_strstr
        jsr get_2ptr
        jsr resets2     ; needls is op2
        lda op1         ; haystack is op1
        sta strstr1+8
        sta tmp1
        lda op1+1
        sta strstr1+9
        ldy #0

strstr1                 ; main loop
        lda $2211,x     ; s2
        beq success     ; finished
        sta tmp
        lda $9988,y     ; s1
        beq failure     ; finished

        cmp tmp         ; compare *s1,*s2
        beq strstr2     ; equal?
        jsr resets2     ; nope... reset s2 pointer
        jmp strstr3     ; ...and go on to next *s1

strstr2                 ; inc s2 pointer
        txa
        bne strstr2a
        lda tmp+1
        bne strstr2a

        sty tmp2
        lda strstr1+9
        sta tmp1+1

strstr2a
        lda #1
        sta tmp+1
        inx
        bne strstr3
        lda #1
        sta tmp+1
        inc strstr1+2

strstr3                  ; inc s1 pointer
        iny
        bne strstr4
        inc strstr1+9

strstr4
        jmp strstr1

resets2
        lda op2
        sta strstr1+1
        lda op2+1
        sta strstr1+2
        ldx #0
        lda #0
        sta tmp+1
        rts

failure
        jmp retzero

success
        lda tmp2        ; return sp1+Y
        clc
        adc tmp1
        tax
        lda tmp1+1
        adc #0
        rts

