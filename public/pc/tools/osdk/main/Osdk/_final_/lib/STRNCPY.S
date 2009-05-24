;char *strncpy(char *s1, char *s2, int n)
_strncpy
        jsr get_2ptr    ; get s1 and s2

        ldy #5
        lda (sp),y      ; get n
        sta tmp         ; tmp=hi(n)
        dey
        lda (sp),y
        tax             ; x=lo(n)

        ldy op1
        sty strncpyend+3
	lda op1+1
        sta strncpyend+1
	ldy #0

strncpyloop
        dex             ; decrease n
        cpx #$ff
        bne strncpy1
        dec tmp
        lda tmp
        cmp #$ff
        beq strncpyend  ; n<0?

strncpy1
        lda (op2),Y     ; copy characters
	sta (op1),Y
        beq strncpyend
	iny
        bne strncpyloop
	inc op1+1
	inc op2+1
        jmp strncpyloop

strncpyend
        lda #$01        ; return s1
        ldx #$03
	rts


