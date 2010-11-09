;EyeOpener.s - Routines to open/close room by revealing it from centre

;05)eye opens shaft (from bgb to screen)
EyeOpenRoom
	ldy #75
	sty TopCloseY
	;lda #74
	dey
	sty BottomCloseY
	
.(	
loop1	;If Room is 32(Terminal screen) then display terminal asap
 	lda EthansLocation
	cmp #IN_CORRIDOR
	beq skip2
	lda RoomID
	cmp #32
	bcs skip1
skip2	jsr SlowDown2
	
skip1	ldy TopCloseY
	jsr CopyBGBRow2Screen
	
	ldy BottomCloseY
	jsr CopyBGBRow2Screen
	
	inc BottomCloseY
	
	dec TopCloseY
	bpl loop1
.)	
	rts
	
CopyBGBRow2Screen
	tya
	sty R2Svector1+1
	jsr CalcBGBufferRowAddress
	sta source
	sty source+1
R2Svector1
	ldy #00


	lda #00
	jsr RecalcScreen
	
	ldy #39
.(
loop1	lda (source),y
	sta (screen),y
	dey
	bne loop1
.)
	lda #7
	ldy GameScreenColouring
.(
	beq skip3
	;If in shaft always 3/6
	ldy #0
	lda EthansLocation
	cmp #IN_CORRIDOR
	beq skip1
	lda RoomID
	cmp #ROOM_CONTROL
	beq skip1
	and #7
	tay
skip1	lsr R2Svector1+1
	bcc skip2
	lda OddColour,y
	jmp skip3
skip2	lda EvenColour,y
skip3	ldy #00
.)
	sta (screen),y
	rts

EyeCloseRoom
	;Use droid delay to control eye closing rate
	lda #00
	sta TopCloseY
	lda #149
	sta BottomCloseY
.(	
loop1	jsr SlowDown2
	
	ldy TopCloseY
	jsr ClearScreenRow
	
	ldy BottomCloseY
	jsr ClearScreenRow
	
	inc TopCloseY
	dec BottomCloseY
	
	lda TopCloseY
	cmp #75
	bcc loop1
.)	
	rts

SlowDown2	lda #00
.(
loop1	jsr AddScreen
	adc #1
	bne loop1
.)
	rts

ClearScreenRow
	lda #00
	jsr RecalcScreen
	
	ldy #39
	lda #$40
.(
loop1	sta (screen),y
	dey
	bne loop1
.)
	rts
	
