; char *strcat(char *s1, char *s2)
_strcat
        ldy #3          ; copy s2
        lda (sp),y
        sta strcat2+2
        dey             ; Y=#2
        lda (sp),y
        sta strcat2+1

        dey             ; Y=#1
        lda (sp),y      ; copy s1
        sta strcat1+2
        sta strcat3+1   ; copy return value, high
        dey             ; Y=#0
	lda (sp),y
        sta strcat1+1
        sta strcat3+3   ; copy return value, low

strcat1                 ; look for terminating null in s1
        lda $2211,Y     ; self-modifying
        beq strcat1a    ; terminating null found?
        iny
        bne strcat1
        inc strcat1+2   ; next page (whoa, that's a long string!)
        jmp strcat1

strcat1a
        lda strcat1+2   ; set self-mod in strcat2+[5,4] to end of s1
        sta strcat2+5
        lda strcat1+1
        sta strcat2+4
        clc
        tya
        adc strcat2+4
        sta strcat2+4
        lda strcat2+5
        adc #$00
        sta strcat2+5
        ldx #$00

strcat2
	lda $2211,x
	sta $5544,x
        beq strcat3     ; found terminating null?
	inx
        bne strcat2
        inc strcat2+2
        inc strcat2+5
        jmp strcat2

strcat3
        lda #$01        ; self-mod
        ldx #$03        ; likewise
        rts


