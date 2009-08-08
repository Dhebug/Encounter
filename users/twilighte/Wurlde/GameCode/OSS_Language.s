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

;The Sprite List is up to 32 entries long but limited by UltimateSprite. Ground based objects have Bit7
;of Sprite_ScriptID set. The sprite list is passed twice. Once to pick up background sprites and again
;to pick up air based.
;3 Types of sprites can exist in Swiv -
ossScript_Driver
	;Pick up and process Background Sprites
	ldx UltimateSprite
.(
loop2	ldy Sprite_ScriptID,x
	bpl skip1
	lda Sprite_ScriptLo-128,y
	sta script
	lda Sprite_ScriptHi-128,y
	sta script+1
script	ldy Sprite_ScriptIndex,x
	stx ScriptTempX
	ldx $dead,y
	lda ScriptCommandAddressLo,x
	sta vector+1
	lda ScriptRangeValue,x
	ldx ScriptTempX
	sec
vector	jsr $??ad
	inc Sprite_ScriptIndex,x
	bcs script
skip1	dex
	bpl loop2
.)
	;Pick up and process air based sprites
	ldx UltimateSprite
.(
loop2	ldy Sprite_ScriptID,x
	bmi skip1
	lda Sprite_ScriptLo,y
	sta script
	lda Sprite_ScriptHi,y
	sta script+1
script	ldy Sprite_ScriptIndex,x
	stx ScriptTempX
	ldx $dead,y
	lda ScriptCommandAddressLo,x
	sta vector+1
;	lda ScriptCommandAddressHi,x
;	sta vector+1
	lda ScriptRangeValue,x
	ldx ScriptTempX
	sec
vector	jsr $??ad
	inc Sprite_ScriptIndex,x
	bcs script
skip1	dex
	bpl loop2
.)
	rts

*=$??00

ScriptCommand1and7	;Move East (uses 2's compliment format numbers as the range values)
	clc
	adc Sprite_X,x
	sta Sprite_X,x
	sec
	rts
ScriptCommand4and10	;Move South (uses 2's compliment format numbers as the range values)
	clc
	adc Sprite_Y,x
	sta Sprite_Y,x
	sec
	rts
ScriptCommand13	;Use this frame for E
	lda Sprite_Frame,x
	sta Sprite_DirFrameE,y
	sec
	rts
ScriptCommand14	;Use this frame for SE
	lda Sprite_Frame,x
	sta Sprite_DirFrameSE,x
	sec
	rts
ScriptCommand15	;Use this frame for S
	lda Sprite_Frame,x
	sta Sprite_DirFrameS,x
	sec
	rts
ScriptCommand16	;Use this frame for SW
	lda Sprite_Frame,x
	sta Sprite_DirFrameSW,x
	sec
	rts
ScriptCommand17	;Use this frame for W
	lda Sprite_Frame,x
	sta Sprite_DirFrameW,x
	sec
	rts
ScriptCommand18	;Use this frame for NW
	lda Sprite_Frame,x
	sta Sprite_DirFrameNW,x
	sec
	rts
ScriptCommand19	;Use this frame for N
	lda Sprite_Frame,x
	sta Sprite_DirFrameN,x
	sec
	rts
ScriptCommand20	;Use this frame for NE
	lda Sprite_Frame,x
	sta Sprite_DirFrameNE,x
	sec
	rts
ScriptCommand21	;Turn clockwise (Relies on codes 13-20 being known)
	lda Sprite_CurrentDir,x
	adc #00
	cmp #12
.(
	bcc skip1
	lda #00
skip1	sta Sprite_CurrentDir,x
.)
	sec
	rts
	
ScriptCommand22	;Turn until in direction of hero (Relies on codes 13-20 being known)
	jsr Sprite_CalcDesiredDirectionToFace
	cmp Sprite_CurrentDir,x
	bcc ScriptCommand21
	bne ScriptCommand246
	rts
ScriptCommand48and64 ;jump back or forward on condition (range value holds 2's compliment)
	sta Sprite_TempA
	lda Sprite_ConditionID,x
	beq LoopUnconditionally
	jsr IsConditionMet
	bcc skip1
LoopUnconditionally
	lda Sprite_ScriptIndex,x
	adc Sprite_TempA
	sta Sprite_ScriptIndex,x
skip1	sec
	rts
ScriptCommand80	;Set Counter(1-64)
	sta Sprite_Counter,x
	sec
	rts
ScriptCommand144	;Set FrameID(0-95)
	sta Sprite_FrameID,x
ScriptCommand240	;Set loop condition (condition in range value)
	sta Sprite_ConditionID,x
	sec
	rts
ScriptCommand246	;Turn anticlockwise (Relies on codes 13-20 being known)
	lda Sprite_CurrentDir,x
	sbc #01
.(
	bcs skip1
	lda #11
skip1	sta Sprite_CurrentDir,x
.)
	sec
ScriptCommand247	;Spare
	rts
ScriptCommand23	;Fire trajectile(Trajectile ScriptID specified as 0-15)
	;Spawn new sprite that will be trajectile
	tay
	lda Level_TrajectileScriptID,y
	ldy UltimateSprite
	sta Sprite_ScriptID,y
	lda #00
	sta Sprite_ScriptIndex,y
	;Transfer current sprites coordinates
	lda Sprite_X,x
	sta Sprite_X,y
	lda Sprite_Y,x
	sta Sprite_Y,y
	inc UltimateSprite
	sec
	rts
ScriptCommand247	;Move forward (Relies on codes 13-20 being known)
	;The step provided must be converted to a '2's compliment' relative to the current dir!
	sta Sprite_TempA
	ldy Sprite_CurrentDir,x	;0-11 E-NE
	lda XStep,y
.(
	bmi skip1
	adc Sprite_TempA
	jmp skip2
skip1	sec
	sbc Sprite_TempA
skip2	clc
.)
	adc Sprite_X,x
	sta Sprite_X,x

	lda YStep,y
.(
	bmi skip1
	adc Sprite_TempA
	jmp skip2
skip1	sec
	sbc Sprite_TempA
skip2	clc
.)
	adc Sprite_Y,x
	sta Sprite_Y,x
	sec
	rts
	

	
	

ScriptCommand0	;End (keep displaying last frame)
	lda #1
ScriptCommand39	;Display current frame and Pause(1-9)
	sta Sprite_PausePeriod,x
	jsr Sprite_CheckBoundary
	bcs ScriptCommand255
	jsr Sprite_CheckCollisions	;Routine must init dying script for craft
	bcs ?end or continue?
	jsr Sprite_PlotSprite
	clc
	rts
	
ScriptCommand255	;End (Don't plot anymore)
	;Remove Sprite from list
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

;All sprites are plotted on the screenbuffer
Sprite_PlotSprite
	;Calc Bitmap (potentially Shifted)
	ldy Sprite_X,x
	lda ShiftedPosition,y
	tay
	sty Sprite_TempY
	lda SpriteShiftedBitmapLoTableVectorLo,y
	sta bitmaplo
	lda SpriteShiftedBitmapHiTableVectorLo,y
	sta bitmaplo+1
	lda SpriteShiftedBitmapLoTableVectorHi,y
	sta bitmaphi
	lda SpriteShiftedBitmapHiTableVectorHi,y
	sta bitmaphi+1
	ldy Sprite_ID,x
	lda (bitmaplo),y
.(
	sta bitmap+1
	lda (bitmaphi),y
	sta bitmap+2

	;Calc Mask (potentially Shifted)
	ldy Sprite_TempY
	lda SpriteShiftedMaskLoTableVectorLo,y
	sta masklo
	lda SpriteShiftedMaskHiTableVectorLo,y
	sta masklo+1
	lda SpriteShiftedMaskLoTableVectorHi,y
	sta maskhi
	lda SpriteShiftedMaskHiTableVectorHi,y
	sta maskhi+1
	ldy Sprite_ID,x
	lda (masklo),y
	sta mask+1
	lda (maskhi),y
	sta mask+2

	;Calc Screen
	ldy Sprite_X,x	;0-137
	lda Sprite_XLOC,y
	ldy Sprite_Y,x	;0-124
	clc
	adc ScreenBufferRowAddressLo,y
	sta screen
	lda ScreenBufferRowAddressHi,y
	sta screen+1
	
	;Calc SB Offset table Address
	ldy Sprite_Width,x
	lda ScreenBufferOffsetTableLo,y
	sta offset+1
	lda ScreenBufferOffsetTableHi,y
	sta offset+2

	;Plot Sprite
	lda Sprite_UltimateByte,x
	stx Sprite_TempX
	tax
	
offset	ldy $DEAD,x
	lda (screen),y
	bpl VMask
	eor #63
mask	and $dead,x
bitmap	ora $dead,x
	bpl skip1
	eor #63
skip1	sta (screen),y
	dex
	bpl VOffset
.)
	;Check borders


	

	
	
RestoreSpriteBG	;Using OldX/Y


CollisionDetectionLevel2
	ldx ?
loop1	lda screen
	adc yoffset,x
	sta CollisionAddressLoList,x
	lda screen+1
	adc #00
	sta CollisionAddressHiList,x
	lda $dead,x	;sprite frame
	sta CollisionBitmapValueList,x
	dex
	bpl loop1
	
	