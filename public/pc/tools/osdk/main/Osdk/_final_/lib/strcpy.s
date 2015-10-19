
; char *strcpy(char *s1,char *s2)

_strcpy
	jsr get_2ptr

_strcpymc
	ldx op1
    stx strcpyend+3
	lda op1+1
    sta strcpyend+1
	sta tmp
	ldy #0
strcpyloop
	lda (op2),Y
	sta (op1),Y
	beq strcpyend
	iny
	bne strcpyloop
	inc op1+1
	inc op2+1
	jmp strcpyloop
strcpyend
    lda #$01
    ldx #$03
	rts

