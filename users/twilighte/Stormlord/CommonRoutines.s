;CommonRoutines.s

AddGraphic
	clc
	adc graphic
	sta graphic
	lda graphic+1
	adc #00
	sta graphic+1
	rts

nlScreen	lda screen
	clc
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts

nlBgbuff	lda bgbuff
	clc
	adc #40
	sta bgbuff
	lda bgbuff+1
	adc #00
	sta bgbuff+1
	rts

;Sunmoon is 4x64(256)
;But window is 4x15
;Display rolling Sun Moon graphic (in steps of 2 rows at a time to keep colour sync)
UpdateSunMoon
	lda usm_SunMoonYPos
	clc
	adc #2
	and #63
	sta usm_SunMoonYPos
	sta usm_RowIndex

	;If bonus level (MapX==237) then end level on ypos==32
	lda MapX
	cmp #237
.(
	bne skip1
	lda usm_SunMoonYPos
	cmp #32
	bcs EndOfBonusLevel
	jmp skip2

skip1	;If Normal level then game over on ypos==00
	
	lda usm_SunMoonYPos
	beq TimeOut
	
skip2
.)
UpdateSunMoon_Cont
	lda #<$A1ED+150*40

	sta usm_screen
	lda #>$A1ED+150*40
	sta usm_screen+1

	ldx #15
.(
loop2	lda usm_RowIndex
	asl
	asl
	adc #<ScorePanelSunMoon
	sta usm_graphic
	lda #>ScorePanelSunMoon
	adc #00
	sta usm_graphic+1

	ldy #3
loop1	lda (usm_graphic),y
	sta (usm_screen),y
	dey
	bpl loop1

	lda usm_RowIndex
	adc #1
	and #63
	sta usm_RowIndex
	lda usm_screen
	adc #40
	sta usm_screen
	lda usm_screen+1
	adc #00
	sta usm_screen+1
	
	dex
	bne loop2
.)
	rts

EndOfBonusLevel
	;We're in IRQ here so we must flag main loop
	lda #GAME_ENDOFBONUS
	sta GameAction
	jmp UpdateSunMoon_Cont
TimeOut
	;We're in IRQ here so we must flag main loop
	lda #GAME_OUTOFTIME
	sta GameAction
	jmp UpdateSunMoon_Cont
	



;A Score to add
;Score is held as 6 digit bcd(3 byte MSB to LSB) but display only handles 5 digit
AddScore
	sed
	clc
	ldx #2
.(
loop1	adc HeroScore,x
	sta HeroScore,x
	lda #00
	dex
	bpl loop1
.)
	cld
	rts
	
DisplayScore
	ldx #02
.(
loop1	lda HeroScore,x
	and #15
	ldy LowScoreDigitOffset,x
	jsr DisplayScoreDecimalDigit
	cpx #00
	beq skip1
	lda HeroScore,x
	lsr
	lsr
	lsr
	lsr
	ldy HighScoreDigitOffset,x
	jsr DisplayScoreDecimalDigit
skip1	dex
	bpl loop1
.)
	rts

;A Digit Value 00-09
;X
;Y Screen Offset to digit
DisplayScoreDecimalDigit
.(
	stx vector1+1
	tax
	lda DecimalGraphicRow0,x
	eor #128+63
	sta $A000+18+165*40,y
	lda DecimalGraphicRow1,x
	sta $A000+18+166*40,y
	lda DecimalGraphicRow2,x
	eor #128+63
	sta $A000+18+167*40,y
	lda DecimalGraphicRow3,x
	sta $A000+18+168*40,y
	lda DecimalGraphicRow4,x
	eor #128+63
	sta $A000+18+169*40,y
	lda DecimalGraphicRow5,x
	sta $A000+18+170*40,y
	lda DecimalGraphicRow6,x
	eor #128+63
	sta $A000+18+171*40,y
	lda DecimalGraphicRow7,x
	sta $A000+18+172*40,y
	lda DecimalGraphicRow8,x
	eor #128+63
	sta $A000+18+173*40,y
	lda DecimalGraphicRow9,x
	sta $A000+18+174*40,y
vector1	ldx #00
.)
	rts
	
DisplayHighscore
	;Convert Highscore BCD to 5 digit 4 bit sequence
	ldx #2
	ldy #4
.(
loop1	lda HighScore,x
	and #15
	sta HighScoreDigits,y
	lda HighScore,x
	lsr
	lsr
	lsr
	lsr
	dey
	bmi skip1
	sta HighScoreDigits,y
	dey
	dex
	bpl loop1
skip1	;First digit is Difficulty
.)

	;Now display the sequence
	ldy #4
.(
loop1	ldx HighScoreDigits,y
	lda DecimalGraphicRow0,x
;	eor #128+63
	sta $A000+20+108*40,y
	lda DecimalGraphicRow1,x
	sta $A000+20+109*40,y
	lda DecimalGraphicRow2,x
;	eor #128+63
	sta $A000+20+110*40,y
	lda DecimalGraphicRow3,x
	sta $A000+20+111*40,y
	lda DecimalGraphicRow4,x
;	eor #128+63
	sta $A000+20+112*40,y
	lda DecimalGraphicRow5,x
	sta $A000+20+113*40,y
	lda DecimalGraphicRow6,x
;	eor #128+63
	sta $A000+20+114*40,y
	lda DecimalGraphicRow7,x
	sta $A000+20+115*40,y
	lda DecimalGraphicRow8,x
;	eor #128+63
	sta $A000+20+116*40,y
	lda DecimalGraphicRow9,x
	sta $A000+20+117*40,y
	dey
	bpl loop1
.)
	rts

HighScoreDigits
 .dsb 5,0
;First Score Digit is at +$26A
;Lives are at +$377
;Captured at +$392
;Required at +$394
DecimalGraphicRow0
 .byt $5C,$58,$5C,$5C,$70,$7E,$5C,$7E,$5C,$5C
DecimalGraphicRow1
 .byt $76,$58,$76,$76,$70,$76,$76,$46,$76,$76
DecimalGraphicRow2
 .byt $76,$58,$46,$46,$76,$70,$70,$46,$76,$76
DecimalGraphicRow3
 .byt $76,$58,$4C,$46,$76,$70,$70,$4C,$76,$76
DecimalGraphicRow4
 .byt $76,$58,$4C,$5C,$7E,$7C,$7C,$4C,$5C,$5E
DecimalGraphicRow5
 .byt $76,$58,$58,$46,$46,$46,$76,$58,$76,$46
DecimalGraphicRow6
 .byt $76,$58,$58,$46,$46,$46,$76,$58,$76,$46
DecimalGraphicRow7
 .byt $76,$58,$70,$46,$46,$76,$76,$70,$76,$46
DecimalGraphicRow8
 .byt $76,$58,$76,$76,$46,$76,$76,$70,$76,$46
DecimalGraphicRow9
 .byt $5C,$58,$7E,$5C,$46,$5C,$5C,$70,$5C,$46

DisplayLives
	ldx HeroLives
	lda DecimalGraphicRow0,x
	eor #128+63
	sta $A000+7+172*40
	lda DecimalGraphicRow1,x
	sta $A000+7+173*40
	lda DecimalGraphicRow2,x
	eor #128+63
	sta $A000+7+174*40
	lda DecimalGraphicRow3,x
	sta $A000+7+175*40
	lda DecimalGraphicRow4,x
	eor #128+63
	sta $A000+7+176*40
	lda DecimalGraphicRow5,x
	sta $A000+7+177*40
	lda DecimalGraphicRow6,x
	eor #128+63
	sta $A000+7+178*40
	lda DecimalGraphicRow7,x
	sta $A000+7+179*40
	lda DecimalGraphicRow8,x
	eor #128+63
	sta $A000+7+180*40
	lda DecimalGraphicRow9,x
	sta $A000+7+181*40
	rts

DisplayCapturedFairies
	ldx HeroCapturedFairies
	lda DecimalGraphicRow0,x
	sta $A000+34+172*40
	lda DecimalGraphicRow1,x
	sta $A000+34+173*40
	lda DecimalGraphicRow2,x
	sta $A000+34+174*40
	lda DecimalGraphicRow3,x
	sta $A000+34+175*40
	lda DecimalGraphicRow4,x
	sta $A000+34+176*40
	lda DecimalGraphicRow5,x
	sta $A000+34+177*40
	lda DecimalGraphicRow6,x
	sta $A000+34+178*40
	lda DecimalGraphicRow7,x
	sta $A000+34+179*40
	lda DecimalGraphicRow8,x
	sta $A000+34+180*40
	lda DecimalGraphicRow9,x
	sta $A000+34+181*40
	rts

DisplayRequiredFairies
	ldx HeroRequiredFairies
	lda DecimalGraphicRow0,x
	sta $A000+36+172*40
	lda DecimalGraphicRow1,x
	sta $A000+36+173*40
	lda DecimalGraphicRow2,x
	sta $A000+36+174*40
	lda DecimalGraphicRow3,x
	sta $A000+36+175*40
	lda DecimalGraphicRow4,x
	sta $A000+36+176*40
	lda DecimalGraphicRow5,x
	sta $A000+36+177*40
	lda DecimalGraphicRow6,x
	sta $A000+36+178*40
	lda DecimalGraphicRow7,x
	sta $A000+36+179*40
	lda DecimalGraphicRow8,x
	sta $A000+36+180*40
	lda DecimalGraphicRow9,x
	sta $A000+36+181*40
	rts

DisplayHeldObject
	lda #00
	ldy HeroHolding
.(
	bmi skip1
	lda ObjectsMapCode-4,y
skip1	sta MomentaryBlock
.)
	lda #23
	sta dm_CursorX
	lda #22
	sta dm_CursorY
	jsr PlotBlock2Screen
	lda MomentaryBlock
.(
	beq skip1
	inc MomentaryBlock
skip1	lda #25
.)
	sta dm_CursorX
	jmp PlotBlock2Screen
	
EraseDisplayedObject
	lda #00
	sta MomentaryBlock
	lda #23
	sta dm_CursorX
	lda #22
	sta dm_CursorY
	jsr PlotBlock2Screen
	lda #25
	sta dm_CursorX
	jmp PlotBlock2Screen
	



;40
;Fetch unique MapID based on Level and MapX
;FetchUniqueMapID
;	;MapX/14
;	lda MapX
;	ldy #00
;	sec
;.(
;loop1	iny
;	sbc #14
;	bcs loop1
;.)
;	tya
;	and #15
;	
;	;Fetch
;.(
;	sta vector1+1
;	lda LevelID
;	asl
;	asl
;	asl
;	asl
;vector1	ora #00
;.)
;	tay
;	rts

GetRandomNumber
         lda rndRandom+1
         sta rndTemp
         lda rndRandom
         asl
         rol rndTemp
         asl
         rol rndTemp
         clc
         adc rndRandom
         adc VIA_T1CL
         pha
         lda rndTemp
         adc rndRandom+1
         sta rndRandom+1
         pla
         adc #$11
         sta rndRandom
         lda rndRandom+1
         adc #$36
         sta rndRandom+1
         rts

ClearScreen
	;Clear Screen down to top of score panel and plot colours
	lda #<$A000
	sta screen
	lda #>$A000
	sta screen+1
	ldx #150
.(
loop2	ldy #39
	lda #$40
loop1	sta (screen),y
	dey
	bne loop1
	lda #7
	ldy Option_Screen
	bne skip2
	txa
	lsr
	lda #6
	bcc skip2
	lda #3
skip2	ldy #00
	sta (screen),y
	jsr nlScreen
	dex
	bne loop2
.)
	;Also clear BGBUFF
	lda #<BackgroundBuffer
	sta bgbuff
	lda #>BackgroundBuffer
	sta bgbuff+1
	ldx #108
.(
loop2	ldy #39
	lda #64
loop1	sta (bgbuff),y
	dey
	bne loop1
	jsr nlBgbuff
	dex
	bne loop2
.)
	;Clear top of screen
	
	rts
