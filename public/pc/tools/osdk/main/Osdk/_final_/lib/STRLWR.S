;char *strlwr(char *s)

_strlwr
        ldy #1
        lda (sp),y
        sta strlwr1+2
        sta strlwr1a+2
        sta strlwr2+3
        dey
        lda (sp),y
        sta strlwr1+1
        sta strlwr1a+1
        sta strlwr2+1

strlwr1
        lda $2211,y
        beq strlwr2     ; end of string

        tax             ; code adapted from _tolower
	lda ctype,x
	and #$01	;_U
        beq strlwr1b    ;skip if not upper-case
	clc
	txa		;original char
	adc #$20	;force lower case

strlwr1a
        sta $2211,y     ;store back into string

strlwr1b
        iny
        bne strlwr1     ; next character
        inc strlwr1+2   ; next page
        inc strlwr1a+2  ; next page
        jmp strlwr1

strlwr2
        ldx #1          ; self modifying
        lda #3          ; ditto
        rts

