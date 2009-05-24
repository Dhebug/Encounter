;
; toupper(c)
;
_toupper
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$02	;_L
	beq toupper1	;skip if not lower-case
	sec
	txa		;original char
	sbc #$20	;force upper case
	tax
toupper1
	lda #0
	rts

;
; tolower(c)
;
_tolower
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$01	;_U
	beq tolower1	;skip if not upper-case
	clc
	txa		;original char
	adc #$20	;force lower case
	tax
tolower1
	lda #0
	rts

;
; toascii(c)
;
_toascii
	ldy #0
	lda (sp),y	;low byte of c
	and #$7f
	tax
	lda #0
	rts
	
