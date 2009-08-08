;MenuEditor.s
;0123456789012345678901234567890123456789
;

mnuReturn
	ldx MenuCursorX
	lda MenuVectorJumpLo,x
.(
	sta vector1+1
	lda MenuVectorJumpHi,x
	sta vector1+2
vector1	jmp $dead
.)	
	
mnuLeft	;0-8
	lda MenuCursorX
	sec
	sbc #1
.(
	bcs skip1
	lda #8
skip1	sta MenuCursorX
.)
	rts

mnuRight
	lda MenuCursorX
	clc
	adc #1
	cmp #9
.(
	bcc skip1
	lda #0
skip1	sta MenuCursorX
.)
	rts

mnuEscape
	;Confirm exit from Editor on status row(flashing)
	;"LEAVING SO SOON Y/N?"
	jsr FetchRandom255
	and #3
	tax
	lda RandomExitMessageLo,x
.(
	sta vector1+1
	lda RandomExitMessageHi,x
	sta vector1+2
	ldx #00
vector1	lda $dead,x
	ora #128
	sta $BB80+40*27,x
	inx
	cpx #40
	bcc vector1
skip1	lda HardKeyRegister
	bne skip1
loop2	lda HardKeyRegister
	beq loop2
	cmp #"Y"
	bne skip2
	sei
	;Restore Stack
	ldx OriginalStackPointer
	txs
	;Restore IRQ
	lda #<20000
	sta VIA_T1LL
	lda #>20000
	sta VIA_T1LH
	lda #$88
	sta $245
	lda #$04
	sta $246
	cli
	jmp $F88F
skip2	ldx #39
	lda #128
loop1	sta $bb80+40*27,x
	dex
	bpl loop1
	rts
.)
	