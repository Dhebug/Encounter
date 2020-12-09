;
; exit()
; ------
; exit from user program
;
_exit
	ldx retstack
	txs
	rts

reterr
	lda #$ff	; return -1
	tax
	rts

retzero
false
	lda #0		;return 0
	tax
	rts

true
	ldx #1		;return 1
	lda #0
	rts
