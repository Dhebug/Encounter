; char *strncat(char *s1, char *s2, int n)

_strncat
        ldy #5
        lda (sp),y      ; high(n)
        sta tmp2+1
        dey
        lda (sp),y
        sta tmp2        ; low(n)

        dey             ; copy s2
        lda (sp),y
        sta strncat2+2
        dey             ; Y=#2
        lda (sp),y
        sta strncat2+1

        dey             ; Y=#1
        lda (sp),y      ; copy s1
        sta strncat1+2
        sta strncat3+1  ; copy return value, high
        dey             ; Y=#0
        lda (sp),y
        sta strncat1+1
        sta strncat3+3  ; copy return value, low

strncat1                ; look for terminating null in s1
        lda $2211,Y     ; self-modifying
        beq strncat1a   ; terminating null found?
        iny
        bne strncat1
        inc strncat1+2  ; next page (whoa, that's a long string!)
        jmp strncat1

strncat1a
        lda strncat1+2  ; set self-mod in strncat2+[5,4] to end of s1
        sta strncat2+5
        lda strncat1+1
        sta strncat2+4
        clc
        tya
        adc strncat2+4
        sta strncat2+4
        lda strncat2+5
        adc #$00
        sta strncat2+5
        ldx #$00
        ldy tmp2

strncat2
        lda $2211,x
        sta $5544,x
        beq strncat3    ; found terminating null?

        dey             ; decrease n
        cpy #$ff
        bne strncat2a
        dec tmp2+1
        lda tmp2+1
        cmp #$ff
        beq strncat2b   ; n<0?

strncat2a
        inx             ; increase pointers
        bne strncat2
        inc strncat2+2
        inc strncat2+5
        jmp strncat2

strncat2b
        txa             ; add terminating null, low order byte of pointer
        clc
        adc strncat2+4
        sta tmp2
        lda #0          ; terminating null, high order byte
        adc strncat2+5
        sta tmp2+1
        lda #0          ; write terminating null
        tay
        sta (tmp2),y

strncat3
        lda #$01        ; self-mod
        ldx #$03        ; likewise
        rts



