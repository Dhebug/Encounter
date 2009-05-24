;
; lprintf(str,...)
;
_lprintf
	lda $023A
	pha
	lda $0239
	pha
	lda $023F
	sta $0239
	lda $0240
	sta $023A
	jsr _printf
	pla
	sta $0239
	pla
	sta $023A
	rts