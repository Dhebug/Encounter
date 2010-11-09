;DetectEthanDroidCollision.s
;Scan the screen ethan occupies and if different to copy then collision detected

DetectEthanDroidCollision
	lda #<EthansScreenImage
	sta copy
	lda #>EthansScreenImage
	sta copy+1

	;Restore BG from BGBuffer
	lda EthanX
	ldy EthanY
	jsr RecalcScreen
	
	ldy EthanFrame
	ldx EthanMSKPixelHeight,y
.(
loop2	ldy #2
loop1	lda (screen),y
	cmp (copy),y
	bne CollisionDetected
	dey
	bpl loop1
	jsr nl_screen
	lda copy
	adc #3
	sta copy
	bcc skip1
	inc copy+1
skip1	dex
	bne loop2
.)
;	lda #16
;	sta $BF68
	rts	
	
CollisionDetected
	jmp DeathByElectricution
