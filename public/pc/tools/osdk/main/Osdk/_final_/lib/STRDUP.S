; char *strdup (char *s)

_strdup
        jsr _strlen     ; call strlen(s)

        inx             ; we'll allocate strlen(s)+1 bytes
        bne strdup1
        tay
        iny
        tya

strdup1
        sta tmp+1
        stx tmp
        lda tmp
        ldx tmp+1
        jsr _mallocmc   ; call malloc to get the value

        pha
        stx tmp
        ora tmp
        bne strdup2

        jmp retzero     ; oops, no memory could be allocated... return NULL

strdup2
        lda tmp         ; set the target string for strcpy()
        sta op1
        pla
        sta op1+1

        ldy #0          ; set the source string
        lda (sp),y
        sta op2
        iny
        lda (sp),y
        sta op2+1

        jmp _strcpymc

