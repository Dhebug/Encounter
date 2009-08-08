;ReadKeyboard.s


ReadKeyboard
	;Special once call to read kbd
	lda #00
	sta KeyRegister
	lda #$0e
	sta via_porta
	lda #pcr_Register
	sta via_pcr
	ldy #pcr_Disabled
	sty via_pcr
	ldx #06
.(
loop1	lda key_column,x
	sta via_porta
	lda #pcr_Value
	sta via_pcr
	lda key_row,x
	sta via_portb
	sty via_pcr
	nop
	nop
	nop
	nop
	lda via_portb
	and #8
	beq skip1
	lda KeyRegister
	ora Bitcode,x
	sta KeyRegister
skip1	dex
	bpl loop1
.)
	rts

;****************
;Keyboard tables
Bitcode
 .byt 1,2,4,8,16,32,64
;B0 left
;B1 right
;B2 up
;B3 down
;B4 left-ctrl
;B5 Shift
;B6 Escape

key_column
 .byt $df,$7f,$f7,$bf,$ef,$ef,$df
key_row
 .byt 4,4,4,4,2,4,1
PreviousKey	.byt 0

WaitOnKey
	;Empty Keyboard buffer
	jsr ReadKeyboard
	lda KeyRegister
	bne WaitOnKey
.(
loop1	;Wait on key
	jsr ReadKeyboard
	lda KeyRegister
	beq loop1
.)
	rts

