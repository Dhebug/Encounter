; Draw an inversed colr box to highlight selected box
; _cx=screen x position
; _cy=screen y position
_inverseloader
.(
	;ldx _cx
	;ldy _cy
	;jsr _SetScreenAddress
	jsr _SetScreenAddress2
	jsr _Add40
	;jsr _Add40
	
	; Draw loop
	.(
	ldx #17
loop
	ldy #0
	lda (tmp1),y
	eor #%111111
	eor #128
	sta (tmp1),y
	iny
	lda (tmp1),y
	eor #%111111
	eor #128
	sta (tmp1),y
	iny
	lda (tmp1),y
	eor #%111111
	eor #128
	sta (tmp1),y

	jsr _Add40
			
	dex
	bne loop
	.)
		
	rts
.)