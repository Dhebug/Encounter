;PanelRoutines.s - Common Score Panel Routines

;X PlayerA(0) or B(1)
;A Score to Add
Add2Score	;Fetch location on screen of score
	ldy PlayerScorePanelLocLo,x
	sty screen
	ldy PlayerScorePanelLocHi,x
	sty screen+1

	;Add to score
	sed
	clc
	adc PlayerScoreDigits01,x
	sta PlayerScoreDigits01,x	;LSB
	sta PlayerScore2Display01
	bcc OnlyDisplayDigit01
	lda PlayerScoreDigits23,x
	adc #00
	sta PlayerScoreDigits23,x
	sta PlayerScore2Display23
	bcc OnlyDisplayDigits0123
	lda PlayerScoreDigits45,x
	adc #00
	sta PlayerScoreDigits45,x
	sta PlayerScore2Display45
	bcc OnlyDisplayDigits012345
	lda PlayerScoreDigits67,x
	adc #00
	sta PlayerScoreDigits67,x	;MSB
	sta PlayerScore2Display67
	
	;Now display digits
	jsr DisplayDigit6
OnlyDisplayDigits012345
	jsr DisplayDigits45
OnlyDisplayDigits0123
	jsr DisplayDigits23
OnlyDisplayDigit01
	jmp DisplayDigits01
	
DisplayDigit6
	cld
	lda PlayerScore2Display67
	;Extract Digit 6 only (0-9)
	and #15
	tax
	lda DigitScreenGraphicBitmap234_0,x	;bitpos 234
	ora #1
	ldy #4
	sta (screen),y
	lda DigitScreenGraphicBitmap234_1,x
	ora #1
	ldy #44
	sta (screen),y
	lda DigitScreenGraphicBitmap234_2,x
	ora #1
	ldy #84
	sta (screen),y
	lda DigitScreenGraphicBitmap234_3,x
	ora #1
	ldy #124
	sta (screen),y
	lda DigitScreenGraphicBitmap234_4,x
	ora #1
	ldy #164
	sta (screen),y
	rts

DisplayDigits45
	cld
	lda PlayerScore2Display45
	and #15
	sta LSBDigitIndex	;The right one
	lda PlayerScore2Display45
	lsr
	lsr
	lsr
	lsr
	tax	;The left one (overlaps a byte)
	
	;Display Right digit and two pixels of left
	ldy LSBDigitIndex
	lda DigitScreenGraphicBitmap012_0,y
	ora DigitScreenGraphicBitmap45_0,x
	ldy #3
	sta (screen),y
	;Display remaining one pixel in previous byte
	lda DigitScreenGraphicBitmap0_0,x
	dey
	sta (screen),y
	
	ldy LSBDigitIndex
	lda DigitScreenGraphicBitmap012_1,y
	ora DigitScreenGraphicBitmap45_1,x
	ldy #43
	sta (screen),y
	lda DigitScreenGraphicBitmap0_1,x
	dey
	sta (screen),y
	
	ldy LSBDigitIndex
	lda DigitScreenGraphicBitmap012_2,y
	ora DigitScreenGraphicBitmap45_2,x
	ldy #83
	sta (screen),y
	lda DigitScreenGraphicBitmap0_2,x
	dey
	sta (screen),y

	ldy LSBDigitIndex
	lda DigitScreenGraphicBitmap012_3,y
	ora DigitScreenGraphicBitmap45_3,x
	ldy #123
	sta (screen),y
	lda DigitScreenGraphicBitmap0_3,x
	dey
	sta (screen),y

	ldy LSBDigitIndex
	lda DigitScreenGraphicBitmap012_4,y
	ora DigitScreenGraphicBitmap45_4,x
	ldy #163
	sta (screen),y
	lda DigitScreenGraphicBitmap0_4,x
	dey
	sta (screen),y
	rts
	
DisplayDigits23
	cld
	lda PlayerScore2Display23
	and #15
	sta LSBDigitIndex	;The right one
	lda PlayerScore2Display45
	lsr
	lsr
	lsr
	lsr
	tax	;The left one
	
	;Display right digit combined with one pixel of next digit
	ldy LSBDigitIndex
	lda DigitScreenGraphicBitmap234_0,y
	ldy #2
	ora (screen),y
	sta (screen),y
	;Display left digit in previous byte
	lda DigitScreenGraphicBitmap012_0,x
	dey
	sta (screen),y
	
	ldy LSBDigitIndex
	lda DigitScreenGraphicBitmap234_1,y
	ldy #42
	ora (screen),y
	sta (screen),y
	lda DigitScreenGraphicBitmap012_1,x
	dey
	sta (screen),y
	
	ldy LSBDigitIndex
	lda DigitScreenGraphicBitmap234_2,y
	ldy #82
	ora (screen),y
	sta (screen),y
	lda DigitScreenGraphicBitmap012_2,x
	dey
	sta (screen),y

	ldy LSBDigitIndex
	lda DigitScreenGraphicBitmap234_3,y
	ldy #122
	ora (screen),y
	sta (screen),y
	lda DigitScreenGraphicBitmap012_3,x
	dey
	sta (screen),y

	ldy LSBDigitIndex
	lda DigitScreenGraphicBitmap234_4,y
	ldy #162
	ora (screen),y
	sta (screen),y
	lda DigitScreenGraphicBitmap012_4,x
	dey
	sta (screen),y

	rts

DisplayDigits01
	cld
	lda PlayerScore2Display23
	and #15
	tax	;The right one
	lda PlayerScore2Display45
	lsr
	lsr
	lsr
	lsr
	sta MSBDigitIndex	;The left one
	
	
	lda DigitScreenGraphicBitmap45_0,x
	ldy #1
	ora (screen),y
	sta (screen),y
	lda DigitScreenGraphicBitmap0_0,x
	ldy MSBDigitIndex
	ora DigitScreenGraphicBitmap234_0,y
	ldy #0
	sta (screen),y

	lda DigitScreenGraphicBitmap45_1,x
	ldy #41
	ora (screen),y
	sta (screen),y
	lda DigitScreenGraphicBitmap0_1,x
	ldy MSBDigitIndex
	ora DigitScreenGraphicBitmap234_1,y
	ldy #40
	sta (screen),y

	lda DigitScreenGraphicBitmap45_2,x
	ldy #81
	ora (screen),y
	sta (screen),y
	lda DigitScreenGraphicBitmap0_2,x
	ldy MSBDigitIndex
	ora DigitScreenGraphicBitmap234_2,y
	ldy #80
	sta (screen),y

	lda DigitScreenGraphicBitmap45_3,x
	ldy #121
	ora (screen),y
	sta (screen),y
	lda DigitScreenGraphicBitmap0_3,x
	ldy MSBDigitIndex
	ora DigitScreenGraphicBitmap234_3,y
	ldy #120
	sta (screen),y

	lda DigitScreenGraphicBitmap45_4,x
	ldy #161
	ora (screen),y
	sta (screen),y
	lda DigitScreenGraphicBitmap0_4,x
	ldy MSBDigitIndex
	ora DigitScreenGraphicBitmap234_4,y
	ldy #160
	sta (screen),y
	rts


AddPlayersHealth	;y==player A==Health to add
	clc
	adc PlayerHealth,y
	cmp #24
.(
	bcc skip1
	lda #23
skip1	sta PlayerHealth,y
	cpy #1
	bcs skip2
	tay
	lda HealthByte0,y
	sta $B272
	lda HealthByte1,y
	sta $B273
	lda HealthByte2,y
	sta $B274
	lda HealthByte3,y
	sta $B275
	rts
skip2	tay
.)
	lda HealthByte0,y
	sta $B290
	lda HealthByte1,y
	sta $B291
	lda HealthByte2,y
	sta $B292
	lda HealthByte3,y
	sta $B293
	rts
SubPlayersHealth
AddPlayersLife
SubPlayersLife
	rts


