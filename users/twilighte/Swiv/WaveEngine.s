;WaveEngine.s
;Initiates Sprite Scripts as they appear in map.

ControlWave	
	ldx UltimateSprite
.(
loop1	;Countdown Distance between each crafts start
	lda Sprite_DistanceDelay,x
	beq skip2	;Distance Delay elapsed - initialise craft in wave
	bmi skip3	;Craft now in wave - continue to move thru it
	dec Sprite_DistanceDelay,x
	rts
skip2	;Initialise craft in wave
	dec Sprite_DistanceDelay,x
	ldy Sprite_WaveID,x
	lda Wave_AddressLo,y
	sta wave
	lda Wave_AddressHi,y
	sta wave+1
	;Read header
	ldy #01
	lda (wave),y
	sta Sprite_X,x
	iny
	lda (wave),y
	sta Sprite_Y,x
	;Skip reserved header byte
	ldy #4
	sty Sprite_WaveIndex,x
	;No need to setup wave again - jump straight to plotting
	jmp skip5
skip3	;Move the sprite through the wave steps
	ldy Sprite_WaveID,x
	lda Wave_AddressLo,y
	sta wave
	lda Wave_AddressHi,y
	sta wave+1
	ldy Sprite_WaveIndex,x
	inc Sprite_WaveIndex,x
	lda (wave),y
	;Extract Step Size
	and #3
	sta Temp_StepSize
	
	jsr ControlSprite_XMovement
	jsr ControlSprite_YMovement
	jsr ControlSprite_Fire

skip5	stx TempX
	lda Sprite_ID,x
	pha
	ldy Sprite_Y,x
	lda Sprite_X,x
	tax
	pla
	jsr PlotSprite
	ldx TempX

	;Check Bit 7
	ldy Sprite_WaveIndex,x
	lda (wave),y
	bpl skip4
	
	;Loop on last wave byte until exited
	dec Sprite_WaveIndex,x
	
skip4	dex
	bpl loop1
.)
	rts
	
	
	
ControlSprite_XMovement
	;Control X Movement activity
	lda (wave),y
	;Extract X Type
	lsr
	lsr
	sta Temp_WaveByteRemaining
	and #3
.(
	beq XStill
	;Calc XStep
	cmp #2
	bcc XLeft
	bne XHome
XRight	lda Sprite_X,x
	adc Temp_StepSize
	jmp skip1
XHome	lda Sprite_X,x
	cmp HeroX
	bcc XRight
	beq XStill
XLeft	lda Sprite_X,x
	sbc Temp_StepSize
skip1	;Check boundaries (0-114)
	cmp #114
	bcs OutOfBounds
	sta Sprite_X,x
XStill	rts
.)

ControlSprite_YMovement
	lda Temp_WaveByteRemaining
	lsr
	lsr
	and #3
.(
	beq YStill
	;Calc YStep
	cmp #2
	bcc YLeft
	bne YHome
YRight	lda Temp_StepSize
	asl
	adc Sprite_Y,x
	jmp skip1
YHome	lda Sprite_Y,x
	cmp HeroY
	bcc YRight
	beq YStill
YLeft	lda Temp_StepSize
	asl
	sbc Sprite_Y,x
skip1	;Check boundaries (0-147)
	cmp #147
	bcs OutOfBounds
	sta Sprite_Y,x
YStill	rts
.)
	
ControlSprite_Fire
	rts

OutOfBounds
	ldy UltimateSprite
.(
	bmi skip1
	;Copy UltimateSprite to Current index and dec UltimateSprite count
	lda Sprite_DistanceDelay,y
	sta Sprite_DistanceDelay,x
	lda Sprite_WaveID,y
	sta Sprite_WaveID,x
	lda Sprite_WaveIndex,y
	sta Sprite_WaveIndex,x
	lda Sprite_X,y
	sta Sprite_X,x
	lda Sprite_Y,y
	sta Sprite_Y,x
	lda Sprite_ID,y
	sta Sprite_ID,x
	
	dec UltimateSprite
skip1	rts
.)
	
	


	
;B0-1 Step Size
;B2-3 Still,Left(1,2,3,4),Right(1,2,3,4),Home
;B4-5 Still,Up(2,4,6(Square),8),Down(2(Synchronised with bg),4,6(Square),8),Home
;B6   Fire weapon
;B7   Exit on current Steps	