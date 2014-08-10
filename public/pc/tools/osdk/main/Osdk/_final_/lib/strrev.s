; char *sttrev(char *s)

_strrev
        ldy #1
        lda (sp),y
        sta strrev1+2
        sta strrev3a+6
        sta strrev3a+13
        sta strrev4+3
        dey
        lda (sp),y
        sta strrev1+1
        sta strrev3a+5
        sta strrev3a+12
        sta strrev4+1

strrev1
        lda $2211,y     ; find end of string
        beq strrev2
        iny
        bne strrev1
        inc strrev1+2
        jmp strrev1

strrev2
        lda strrev1+2   ; store end pointer
        sta strrev3a+2
        sta strrev3a+9
        lda strrev1+1
        sta strrev3a+1
        sta strrev3a+8

        ldx #0

strrev3
        dey             ; decrease end pointer
        bpl strrev3a
        dec strrev3a+2  ; decrease end pointer page
        dec strrev3a+9  ; decrease end pointer page

strrev3a
        lda $2211,y     ; ep
        pha
        lda $6655,x     ; sp
        sta $9988,y     ; == $2211
        pla
        sta $ddcc,x     ; == $6655

        inx
        bne strrev3b
        inc strrev3a+6
        inc strrev3a+13

strrev3b
        sty tmp
        cpx tmp
        bcc strrev3

strrev4
        ldx #1
        lda #3
        rts
