;OSS_Language - Oric Sprite Script Language

;0	End (keep displaying last frame)
;1-3	Move East(1,2,3)
;4-6	Move South
;7-9	Move West
;10-12	Move North
;
;13	Use this frame for E
;14	Use this frame for SE
;15	Use this frame for S
;16	Use this frame for SW
;17	Use this frame for W
;18	Use this frame for NW
;19	Use this frame for N
;20	Use this frame for NE
;	
;21	Turn clockwise (Relies on codes 13-20 being known)
;22	Turn until in direction of hero (Relies on codes 13-20 being known)
;23-38	Fire trajectile(Trajectile specified as 0-15)
;
;39-47	Display current frame and Pause(1-9)
;48-63	jump back on condition(1-16)
;64-79	jump forward on Condition(1-16)
;80-143	Set Counter(1-64)
;144-239	Set FrameID(0-95)
;240	Set loop condition to counter timeout
;241	Set loop condition to not facing hero (Relies on codes 13-20 being known)
;242	Set loop condition to not facing east (Relies on codes 13-20 being known)
;243	Set loop condition to facing hero (Relies on codes 13-20 being known)
;244	Set loop condition to facing east (Relies on codes 13-20 being known)
;245	Remove loop conditions
;246	Turn anticlockwise (Relies on codes 13-20 being known)
;247-249	Move forward (Relies on codes 13-20 being known)
;250-253	-
;255	End (Don't plot anymore)

;We use a two pass process so that the ground sprites always appear in the background of the aircraft
ossScript_Driver
	;Process Ground based Sprites
	ldx UltimateSprite

	bpl ossgloop1
	rts
	
ossgloop1	;Detect Ground based sprites from list
	lda Sprite_Attributes,x
	;Bit7 Ground based Sprite
	bpl ossgskip2

	;The pauseperiod is both used as a script command(0-127) and as an on-delay(+128)
	lda Sprite_PausePeriod,x
	and #127
	beq ossgskip1
	dec Sprite_PausePeriod,x
	bmi ossgskip2
	stx ScriptTempX
	jsr Sprite_PlotSprite
	ldx ScriptTempX
	jmp ossgskip2

ossgskip1	jsr DeleteGroundSpriteInCollisionMap
	ldy Sprite_ScriptID,x
	lda SpriteScriptAddressLo,y
	sta zpscript
	lda SpriteScriptAddressHi,y
	sta zpscript+1
	sec
ossgloop2	ldy Sprite_ScriptIndex,x
	lda (zpscript),y
	stx ScriptTempX
	tax
	lda ScriptCommandAddressLo,x
	sta ossgvector+1
	lda ScriptCommandAddressHi,x
	sta ossgvector+2
	tya
	adc ScriptCommandStep,x
	ldx ScriptTempX
	sta Sprite_ScriptIndex,x
	sec
	iny
	;Carry Set
	;X Sprite Index
	;Y Script Index
	;A -
ossgvector
	jsr $DEAD
	bcs ossgloop2
ossgskip2	dex
	bpl ossgloop1






;We can later redirect to different controllers using HCAVector/HCBVector
	;Process Air based Sprites
	ldx UltimateSprite

ossaloop1	;Detect Ground based sprites from list
	lda Sprite_Attributes,x
	;Bit7 Ground based Sprite
	bmi ossaskip2

	;The pauseperiod is both used as a script command(0-127) and as an on-delay(+128)
	lda Sprite_PausePeriod,x
	and #127
	beq ossaskip1
	dec Sprite_PausePeriod,x
	bmi ossaskip2
	stx ScriptTempX
	jsr Sprite_PlotSprite
	ldx ScriptTempX
	jmp ossaskip2

ossaskip1	jsr DeleteAirSpriteInCollisionMap
	;Bit of nasty business here..
	;If player A dies for good whilst player B is still playing, then PlayerB_SpriteIndex will
	;be at the mercy of sprite management allocating sprite index 0.
	
	;So we must use a common routine for deleting a sprite from the list and ensure
	;that the player sprite index variable is updated if changed
	lda Sprite_Attributes,x
	;Bits0-1
	; 0 Sprite is single (Never players)
	; 1 Sprite is part of bigger group(Never players)
	; 2 Player A (If Bit5 clear then craft else Projectile)
	; 3 Player B (If Bit5 clear then craft else Projectile)
	and #32+3
	cmp #2
	bne ossaskip3
	
	stx PlayerA_SpriteIndex
	jsr PlayerA_ProcessMovements
ossaskip3	lda Sprite_Attributes,x
	and #32+3
	cmp #3
	bne ossaskip4
	stx PlayerB_SpriteIndex	;Used later when we need to rotate in direction of hero
	jsr PlayerB_ProcessMovements
ossaskip4	ldy Sprite_ScriptID,x
	lda SpriteScriptAddressLo,y
	sta zpscript
	lda SpriteScriptAddressHi,y
	sta zpscript+1
	sec
ossaloop2	ldy Sprite_ScriptIndex,x
	lda (zpscript),y
	stx ScriptTempX
	tax
	lda ScriptCommandAddressLo,x
	sta ossavector+1
	lda ScriptCommandAddressHi,x
	sta ossavector+2
	tya
	adc ScriptCommandStep,x
	ldx ScriptTempX
	sta Sprite_ScriptIndex,x
	iny
	sec
	;Carry Set
	;X Sprite Index
	;Y Script Index of first data byte
	;A -
ossavector
	jsr $DEAD
	bcs ossaloop2
ossaskip2	dex
	bpl ossaloop1

	rts
	
	
FastPlotNoMask
	;Bit2 Whiteout Flag(1)
	lda Sprite_Attributes,x
	and #BIT2
.(
	beq skip1
	jmp DisplayWhiteoutSprite
skip1	;Calc Bitmap (no shifting)
.)
	ldy Sprite_ID,x
	lda SpriteBitmapFrameAddressLo,y
.(
	sta bitmap1+1
	lda SpriteBitmapFrameAddressHi,y
	sta bitmap1+2

	;Calc Screen
	lda Sprite_X,x	;0-137
	ldy Sprite_Y,x	;0-124
	clc
	adc ScreenBufferRowAddressLo,y
	sta screen
	lda ScreenBufferRowAddressHi,y
	adc #00
	sta screen+1
	
	;Calc SB Offset table Address
	ldy Sprite_Width,x
	lda ScreenBufferOffsetTableLo-1,y
	sta offset+1
	lda ScreenBufferOffsetTableHi-1,y
	sta offset+2

	stx Sprite_TempX

	;Plot Sprite
	lda Sprite_UltimateByte,x
	tax
	
offset	ldy $DEAD,x
bitmap1	lda $dead,x
	sta (screen),y
	dex
	bpl offset
.)
	ldx Sprite_TempX
	rts

	

;All sprites are plotted on the screenbuffer
Sprite_PlotSprite
	;If a static ground based sprite then no mask is neccesary so jump to faster plot routine
	;Establish sprite is ground based
	;Bit6 Square Sprite (In order to directly plot to screenbuffer without mask)
	lda Sprite_Attributes,x
	and #BIT6
	bne FastPlotNoMask
	;Bit3 Show Sprites Shadow (Bonuses,projectiles and ground based sprite don't have shadows)
	lda Sprite_Attributes,x
	and #BIT3
.(
	beq skip1
	;Plot shadow (mask) first so that sprite may overlap it - for moment tho just simple ofs shadow
	jsr DisplaySpritesShadow

skip1	;Branch if whiteout required
.)
	;Bit2 Whiteout Flag(1)
	lda Sprite_Attributes,x
	and #BIT2
	bne DisplayWhiteoutSprite
	
	;Calc Bitmap
	ldy Sprite_ID,x
	lda SpriteBitmapFrameAddressLo,y
.(
	sta bitmap1+1
	sta bitmap2+1
	lda SpriteBitmapFrameAddressHi,y
	sta bitmap1+2
	sta bitmap2+2
	
	lda SpriteMaskFrameAddressLo,y
	sta mask1+1
	sta mask2+1
	lda SpriteMaskFrameAddressHi,y
	sta mask1+2
	sta mask2+2

	;Calc Screen
	lda Sprite_X,x	;0-137
	ldy Sprite_Y,x	;0-124
	clc
	adc ScreenBufferRowAddressLo,y
	sta screen
	lda ScreenBufferRowAddressHi,y
	adc #00
	sta screen+1
	
	;Calc SB Offset table Address
	ldy Sprite_Width,x
	lda ScreenBufferOffsetTableLo-1,y
	sta offset+1
	lda ScreenBufferOffsetTableHi-1,y
	sta offset+2
	
	stx Sprite_TempX

	;Plot Sprite
	lda Sprite_UltimateByte,x
	tax
	
offset	ldy $DEAD,x
	lda (screen),y
	bmi ProcInversedByte
mask1	and $dead,x
bitmap1	ora $dead,x
	sta (screen),y
	dex
	bpl offset
	ldx Sprite_TempX
	rts
ProcInversedByte
	eor #63
mask2	and $dead,x
bitmap2	ora $dead,x
	eor #63+128
	sta (screen),y
	dex
	bpl offset
.)
	ldx Sprite_TempX
	rts

DisplayWhiteoutSprite
	;Turn off whiteout for next game cycle
	lda Sprite_Attributes,x
	and #%11111011
	sta Sprite_Attributes,x

	;Calc Bitmap
	ldy Sprite_ID,x
.(
	;We don't care about bitmap for whiteout
	lda SpriteMaskFrameAddressLo,y
	sta mask1+1
	lda SpriteMaskFrameAddressHi,y
	sta mask1+2

	;Calc Screen
	lda Sprite_X,x	;0-137
	ldy Sprite_Y,x	;0-124
	clc
	adc ScreenBufferRowAddressLo,y
	sta screen
	lda ScreenBufferRowAddressHi,y
	adc #00
	sta screen+1
	
	;Calc SB Offset table Address
	ldy Sprite_Width,x
	lda ScreenBufferOffsetTableLo-1,y
	sta offset+1
	lda ScreenBufferOffsetTableHi-1,y
	sta offset+2
	
	stx Sprite_TempX

	;Plot Sprite
	lda Sprite_UltimateByte,x
	tax
	
offset	ldy $DEAD,x
	;Calculate bitmap from inverted mask
mask1	lda $dead,x
	eor #63
	sta bitmap1+1
	sta bitmap2+1
	lda (screen),y
	bmi ProcInversedByte
;mask1	and $dead,x
bitmap1	ora #00
	sta (screen),y
	dex
	bpl offset
	ldx Sprite_TempX
;skip99	nop
;	jmp skip99
	rts
ProcInversedByte
	eor #63
;mask2	and $dead,x
bitmap2	ora #00
	eor #63+128
	sta (screen),y
	dex
	bpl offset
.)
	ldx Sprite_TempX
;skip99	nop
;	jmp skip99
	rts

	
DisplaySpritesShadow
	;Calc Mask (potentially Shifted)
	ldy Sprite_ID,x
	lda SpriteMaskFrameAddressLo,y
.(
	sta mask1+1
	sta mask2+1
	lda SpriteMaskFrameAddressHi,y
	sta mask1+2
	sta mask2+2

	lda Sprite_Y,x	;0-124
	sec
	sbc #12
	bcc AbortShadow
	tay

	;Calc Screen - Place shadow x-12,y-12
	lda Sprite_X,x	;0-137
	sec
	sbc #2
	bcc AbortShadow

	clc
	adc ScreenBufferRowAddressLo,y
	sta screen
	lda ScreenBufferRowAddressHi,y
	adc #00
	sta screen+1
	
	;Calc SB Offset table Address
	ldy Sprite_Width,x
	lda ScreenBufferOffsetTableLo-1,y
	sta offset+1
	lda ScreenBufferOffsetTableHi-1,y
	sta offset+2

	stx Sprite_TempX

	;Plot Sprite
	lda Sprite_UltimateByte,x
	tax
	
offset	ldy $DEAD,x
	lda (screen),y
	bmi ProcInversedByte
mask1	and $dead,x
	sta (screen),y
	dex
	bpl offset
	ldx Sprite_TempX
AbortShadow
	rts
	
;One additional rule just for Inverse could be if the bg byte is FF then reset to 00
ProcInversedByte
	eor #63
mask2	and $dead,x
	eor #63+128
	sta (screen),y
	dex
	bpl offset
.)
	ldx Sprite_TempX
	rts

;Fill upper 4 bits in area with 0
DeleteAirSpriteInCollisionMap
	;Branch if Explosion
	;Bit4 Don't detect Collisions(Explosion)
	lda Sprite_Attributes,x
	and #BIT4
.(
	bne skip1
	;  
	ldy Sprite_Y,x	;Locate within map
	lda Sprite_X,x
	clc
	adc CollisionMap_YLOCLo,y
	sta cmap
	lda CollisionMap_YLOCHi,y
	adc #00
	sta cmap+1
	ldy Sprite_Width,x	;Fetch width
	lda ScreenBufferOffsetTableLo-1,y
	sta offset+1
	lda ScreenBufferOffsetTableHi-1,y
	sta offset+2

	lda Sprite_CollisionBytes,x
	stx Sprite_TempX
	tax
	lda #00
			
offset	ldy $dead,x	;Scan area
	sta (cmap),y
	dex
	bpl offset
	
	; No collision found
	ldx Sprite_TempX
skip1	rts
.)

;Fill lower 4 bits in area with 0
DeleteGroundSpriteInCollisionMap
	;Branch if Explosion
	lda Sprite_Attributes,x
	and #BIT4
.(
	bne skip1
	;  
	ldy Sprite_Y,x	;Locate within map
	lda Sprite_X,x
	clc
	adc CollisionMap_YLOCLo,y
	sta cmap
	lda CollisionMap_YLOCHi,y
	adc #00
	sta cmap+1
	ldy Sprite_Width,x	;Fetch width
	lda ScreenBufferOffsetTableLo-1,y
	sta offset+1
	lda ScreenBufferOffsetTableHi-1,y
	sta offset+2

	lda Sprite_CollisionBytes,x
	stx Sprite_TempX
	tax
	lda #00
			
offset	ldy $dead,x	;Scan area
	sta (cmap),y
	dex
	bpl offset
	
	; No collision found
	ldx Sprite_TempX
skip1	rts
.)

PlayerA_ProcessMovements
	;We don't detect keyboard here, just move player A craft depending on the previously set
	;movement flags
	;HeroXMovement
	;0 No movement
	;1 Move Left
	;128 Move Right
	lda #65
	sta Sprite_ID,x
	
	lda PlayerA_XMovement
.(
	bmi PlayerA_MoveRight
	beq skip1
	lda Sprite_X,x
	cmp #2
	bcc skip1
	dec Sprite_X,x
	lda #66
	sta Sprite_ID,x
	jmp skip1
PlayerA_MoveRight
	lda Sprite_X,x
	cmp #19
	bcs skip1
	inc Sprite_X,x
	lda #67
	sta Sprite_ID,x
skip1	;0 No movement
	;1 Move Up
	;128 Move Down
	lda PlayerA_YMovement
	bmi PlayerA_MoveDown
	beq skip2
	lda Sprite_Y,x
	cmp #50
	bcc skip2
	sbc #6
	sta Sprite_Y,x
	lda #64
	sta Sprite_ID,x
	jmp skip2
PlayerA_MoveDown
	lda Sprite_Y,x
	cmp #142
	bcs skip2
	adc #6
	sta Sprite_Y,x
skip2	rts
.)

PlayerB_ProcessMovements
	;We don't detect keyboard here, just move player A craft depending on the previously set
	;movement flags
	lda #81
	sta Sprite_ID,x
	;HeroXMovement
	;0 No movement
	;1 Move Left
	;128 Move Right
	lda PlayerB_XMovement
.(
	bmi PlayerB_MoveRight
	beq skip1
	lda Sprite_X,x
	cmp #2
	bcc skip1
	dec Sprite_X,x
	lda #82
	sta Sprite_ID,x
	jmp skip1
PlayerB_MoveRight
	lda Sprite_X,x
	cmp #19
	bcs skip1
	inc Sprite_X,x
	lda #83
	sta Sprite_ID,x
skip1	;0 No movement
	;1 Move Up
	;128 Move Down
	lda PlayerB_YMovement
	bmi PlayerB_MoveDown
	beq skip2
	lda Sprite_Y,x
	cmp #50
	bcc skip2
	sbc #6
	sta Sprite_Y,x
	lda #80
	sta Sprite_ID,x
	jmp skip2
PlayerB_MoveDown
	lda Sprite_Y,x
	cmp #142
	bcs skip2
	adc #6
	sta Sprite_Y,x
skip2	rts
.)
