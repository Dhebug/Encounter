;char *strupr(char *s)

_strupr
        ldy #1
        lda (sp),y
        sta strupr1+2
        sta strupr1a+2
        sta strupr2+3
        dey
        lda (sp),y
        sta strupr1+1
        sta strupr1a+1
        sta strupr2+1

strupr1
        lda $2211,y
        beq strupr2     ; end of string

        tax             ; code adapted from _tolower
	lda ctype,x
        and #$02        ;_L
        beq strupr1b    ;skip if not upper-case
        sec
	txa		;original char
        sbc #$20        ;force upper case

strupr1a
        sta $2211,y     ;store back into string

strupr1b
        iny
        bne strupr1     ; next character
        inc strupr1+2   ; next page
        inc strupr1a+2  ; next page
        jmp strupr1

strupr2
        ldx #1          ; self modifying
        lda #3          ; ditto
        rts

