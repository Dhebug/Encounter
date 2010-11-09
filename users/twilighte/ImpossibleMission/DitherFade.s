;Fade Dither screen

FadeDitherGameScreen
	lda #255
	sta DitherStepSize
.(
loop3	lda #<$A000
	sta screen
	lda #>$a000
	sta screen+1
	
	ldy #00
loop1	lda (screen),y
	cmp #8
	bcc skip1
	lda #64
	sta (screen),y
	
skip1	lda DitherStepSize
	jsr AddScreen
	
	cmp #$B7
	bcc loop1
	bne skip2
	ldx screen
	cpx #$70
	bcc loop1
	
skip2	;Then decrease step size until 0
	dec DitherStepSize
	bne loop3
.)	
	rts
	