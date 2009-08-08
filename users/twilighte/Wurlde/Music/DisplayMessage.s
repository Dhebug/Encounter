;DisplayMessage.s - Using multiple embedded message pointers

;If this works, it is really cool (if i do say myself)
;A==		Message to Display
;(screen),y	Where to Display
DisplayMessage
	ldx #00
	stx Iterance
	sty msgScreenIndex
.(
loop1	jsr locateMessage
loop2 	ldx Iterance
	lda (msgAddr,x)
	bpl skip1
	inc Iterance
	inc Iterance
	ldx Iterance
	jmp loop1
skip1	beq EndOfText
	;Display Character
rent1	ldy msgScreenIndex
	sta (screen),y
	inc msgScreenIndex
	jsr IncMsgAddr
	jmp loop2
EndOfText	;Once at end of text recede iterance
	dec Iterance
	dec Iterance
	lda #32
	ldx Iterance
	bpl rent1
.)
	rts

IncMsgAddr
	inc msgAddr,x
.(
	bne skip1
	inc msgAddr+1,x
skip1	rts
.)

locateMessage
	;locate message storing address in (source,x)
	ldy #<KeyDescriptionTexts
	sty msgAddr,x
	ldy #>KeyDescriptionTexts
	sty msgAddr+1,x
	;Message number provided is +128
	and #127
	tay
.(
	beq FoundIt
	
loop1	lda (msgAddr,x)
	jsr IncMsgAddr
	cmp #00
	bne loop1
	dey
	bne loop1	
FoundIt	rts
.)


