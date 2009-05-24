;
; clock_t clock(void)	; return the system clock
;
_clock
	php
	sei
	ldx $0276
	lda $0277
	cli			; JEDE
	plp
	rts
	