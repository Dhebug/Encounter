;DisplaySimpleMessage.s
;X Xpos
;Y Ypos
;A MessageID(0-63)
;  Clear to Previous End(+64)
;  InverseFlag(+128)
DisplaySimpleMessage
	pha
	txa
	clc
	adc YLOCL,y
	sta screen
	lda YLOCH,y
	adc #00
	sta screen+1
	
	lda #<Message0
	sta source
	lda #>Message0
	sta source+1
	
	pla
	pha
	and #128
	sta dsmInverseFlag
	pla
	pha
	and #64
.(
	beq skip1
	ldy dsmPreviousEnd
	lda #9
	ora dsmInverseFlag
loop1	sta (screen),y
	dey
	bpl loop1
skip1	pla
.)
	and #63
.(
	beq skip1
	tax
	ldy #00

loop1	lda (source),y
	inc source
	bne skip2
	inc source+1
skip2	cmp #128
	bcc loop1
	dex
	bne loop1
skip1	ldy #00
loop2	lda (source),y
	pha
	and #127
	ora dsmInverseFlag
	sta (screen),y
	iny
	pla
	bpl loop2
skip3	dey
	sty dsmPreviousEnd
	rts
.)	
		
Message0
 .byt "COPYING.","."+128
Message1
 .byt "COPIED","!"+128
Message2
 .byt "LOADING.","."+128
Message3
 .byt "SAVING.","."+128
Message4
 .byt "ENTER NEW KEY COMBINATION NO","W"+128
Message5
 .byt "THIS KEY COMBINATION IS ALREADY USE","D"+128
Message6
 .byt "INFINITE LOOP FOUND!","!"+128
Message7
 .byt "THE SFX IS VALI","D"+128
