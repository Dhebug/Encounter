;DroidEngine.s
DroidEngine
	ldx UltimateDroid
.(
	bmi skip2

loop1	lda DroidsSnoozing
	beq skip3
	jsr PlotDroid
	lda TimedDelay
	bne next
	lda #00
	sta DroidsSnoozing

skip3	lda DroidDelayCount,x
	beq skip1
	dec DroidDelayCount,x
	jmp next

skip1	lda DroidDelayRefer,x
	sta DroidDelayCount,x
	ldy DroidAction,x
	bmi ProcessNextScriptInstruction
	lda DroidActionVectorLo,y
	sta vector1+1
	lda DroidActionVectorHi,y
	sta vector1+2
vector1	jsr $dead
	jmp next

ProcessNextScriptInstruction
	ldy DroidScriptID,x
	lda DroidScriptBaseAddressLo,y
	sta dscript
	lda DroidScriptBaseAddressHi,y
	sta dscript+1
loop2	ldy DroidScriptIndex,x

;test99	cpx #3
;	bne test98
;	cpy #4
;	beq test99
;test98
	lda (dscript),y
	tay
	lda DroidScriptInstructionCodeAddressLo,y
	sta vector2+1
	lda DroidScriptInstructionCodeAddressHi,y
	sta vector2+2
	lda DroidScriptIndex,x
	clc
	adc DroidScriptInstructionBytes,y
	ldy DroidScriptIndex,x
	sta DroidScriptIndex,x
	;C==Set
	sec
	iny
vector2	jsr $dead

	bcs loop2

next	dex
	bpl loop1

skip2	rts
.)

; SETSPEED,Speed then proceed to next instruction
Droid_SetSpeed
	lda (dscript),y
	sta DroidDelayCount,x
	sta DroidDelayRefer,x
	rts

;Set the number of steps to move the droid in the current direction. If the droid reaches the end of the rail
;it will move on to the next instruction. If 0 then move to the end of the rail
; MOVE,Step
Droid_Move
	lda #ACTION_MOVING
	sta DroidAction,x
	lda (dscript),y
	sta DroidParameter,x
;	lda #SFX_ROBOTMOTORS
;	jsr KickSFX
	clc
	rts

;Turns the droid to lookback position and waits 2 game cycles
; LOOKBACK
Droid_LookBack
	lda #ACTION_LOOKBACK
	sta DroidAction,x
	lda #00
	sta DroidParameter,x
	clc
Droid_OnSense
	rts

;Senses ethan by sight and branches to index if seen
; ONSENSE,Index
;	;Check if Ethan is on same level as Droid
;	lda EthanY
;	cmp DroidY,x
;.(
;	bcs Remain	;different level
;	clc
;	adc #25
;	cmp DroidY,x
;	bcc Remain	;different level
;	;Check that ethan is not jumping
;	lda EthanFrame
;	cmp #17	;will need to increase when we expand Ethan running frames
;	bcs Remain	;ethan jumping
;	;Check Droid is facing Ethan
;	lda DroidDirection,x
;	beq FacingLeft
;	lda DroidX,x
;	cmp EthanX
;	bcs Remain	;Not facing Ethan
;	jmp branch
;FacingLeft
;	lda DroidX,x
;	cmp EthanX
;	bcc Remain	;Not facing Ethan
;branch	;Fetch and store new index
;	lda (dscript),y
;	sta DroidScriptIndex,x
;Remain	sec
;.)
;	rts

	
;Returns droid to facing current course after lookback. If currently on course then skip to next instruction
; RETURNTOCOURSE
Droid_ReturnToCourse
	lda #ACTION_RETURNTOCOURSE
	sta DroidAction,x
	lda #00
	sta DroidParameter,x
	clc
	rts

;branches to index if the droid is at the end of the rail
; ONENDOFRAIL,Index
Droid_OnEndOfRail
	lda DroidX,x
	cmp DroidsRailEnd,x
.(
	beq skip2
	cmp DroidsRailStart,x
	bne skip1
skip2	lda (dscript),y
	sta DroidScriptIndex,x
skip1	sec
.)
	rts

;Turns Droid in opposite direction. However if in lookback position continue to turn to looking in opposite
;direction.
; TURN
Droid_Turn
	lda #ACTION_TURN
	sta DroidAction,x
	lda #00
	sta DroidParameter,x
	lda #SFX_ROBOTTURN
	jsr KickSFX
	clc
	rts

;Droid shoots for set period. If spark found to go beyond wall then only wait for duration of spark
;Also write spark to top 3 bits of collision map
; SPARK
Droid_Spark
	;Check bounds based on direction
	ldy DroidDirection,x
.(
	bne CheckRightWall
CheckLeftWall
	ldy DroidX,x
	cpy #6
	bcc ActionWait
	jmp SparkIt
CheckRightWall
	ldy DroidX,x
	cpy #33
	bcs ActionWait
SparkIt	lda #ACTION_SPARK
.)
	sta DroidAction,x
	lda #SFX_ROBOTPLASMA
	jsr KickSFX
	
	;Sets spark count
	lda #7
	sta DroidParameter,x
	
	;Now write Spark to collision map
	;Calc Xpos of spark
	lda DroidX,x
	ldy DroidDirection,x
	clc
	;Use 2's compliment table to get x offset
	adc TwosSparkOffset,y
	pha
	;Then calc ypos
	lda DroidY,x
	sec
	sbc #1
	tay
	;And use to get address
	pla
	jsr FetchCollisionMapLocation
	
	;Write only top 3 bits of collision map
	ldy #03
.(
loop1	lda (screen),y
	and #%00011111
	ora #COL_SPARK
	sta (screen),y
	dey
	bpl loop1
.)
;	clc
	rts

ActionWait
	lda #ACTION_WAIT
	sta DroidAction,x
	lda #7
	sta DroidParameter,x
	clc
	rts

TwosSparkOffset
 .byt 252	;Left
 .byt 3	;right
DroidsSnoozing
 .byt 0
;Jumps to index
; JUMP,Index
Droid_Jump
	lda (dscript),y
	sta DroidScriptIndex,x
	rts

;Waits for period
; WAIT,Period
Droid_Wait
	lda #ACTION_WAIT
	sta DroidAction,x
	lda (dscript),y
	sta DroidParameter,x
	clc
	rts

Droid_Face
	lda #DROIDRIGHT
	ldy DroidDirection,x
	bne FaceRight
FaceLeft	lda #DROIDLEFT
FaceRight	sta DroidFrameID,x
	jsr PlotDroid
	
	
;Process Actions

Action_Moving		;Param==Steps(128 to move to end of rail)
	jsr DeleteDroid
	ldy DroidDirection,x
.(
	bne MoveRight
	lda #DROIDLEFT
	sta DroidFrameID,x
	lda DroidX,x
	sec
	sbc #1
	cmp DroidsRailStart,x
	beq EndThisAction
	bcc EndThisAction
rent1	sta DroidX,x
	lda DroidParameter,x
	bmi skip1
	dec DroidParameter,x
	beq EndThisAction
	jmp skip1
MoveRight	lda #DROIDRIGHT
	sta DroidFrameID,x
	lda DroidX,x
	clc
	adc #1
	cmp DroidsRailEnd,x
	bcc rent1
EndThisAction
	lda #128
	sta DroidAction,x
skip1	jmp PlotDroid	
.)


Action_LookBack		;Param==FrameOffset(Starts 0)
	lda DroidDirection,x
.(
	bne LookBackFacingRight
LookBackFacingLeft
	ldy DroidParameter,x
	lda DroidFrameForLookBackRight,y
	sta DroidFrameID,x
	jmp skip1
LookBackFacingRight
	ldy DroidParameter,x
	lda DroidFrameForLookBackLeft,y
	sta DroidFrameID,x
skip1	jsr PlotDroid
	inc DroidParameter,x
	lda DroidParameter,x
	cmp #3
	bcc skip2
	lda #128
	sta DroidAction,x
	;Lookback means facing the other direction (so that sense will look back too)
	lda DroidDirection,x
	eor #1
	sta DroidDirection,x
skip2	rts	
.)
	
DroidFrameForLookBackRight
 .byt 1,2,3
DroidFrameForLookBackLeft
 .byt 3,2,1

Action_ReturnToCourse	;Param==FrameOffset(Starts 0)
	lda DroidDirection,x
.(
	beq ReturnFacingRight
ReturnFacingLeft
	ldy DroidParameter,x
	lda DroidFrameForReturningLeft,y
	sta DroidFrameID,x
	jmp skip1
ReturnFacingRight
	ldy DroidParameter,x
	lda DroidFrameForReturningRight,y
	sta DroidFrameID,x
skip1	jsr PlotDroid
	inc DroidParameter,x
	lda DroidParameter,x
	cmp #3
	bcc skip2
	lda #128
	sta DroidAction,x
	;Returning to course means returning from lookback so look forward and face opposite direction
	lda DroidDirection,x
	eor #1
	sta DroidDirection,x
skip2	rts	
.)

DroidFrameForReturningLeft
 .byt 2,1,0
DroidFrameForReturningRight
 .byt 2,3,4

Action_Turn		;Param==FrameOffset(Starts 0)
	lda DroidDirection,x
.(
	beq TurnRight
TurnLeft	ldy DroidParameter,x
	lda DroidFrameForTurningLeft,y
	sta DroidFrameID,x
	jmp skip1
TurnRight	ldy DroidParameter,x
	lda DroidFrameForTurningRight,y
	sta DroidFrameID,x
skip1	jsr PlotDroid
	inc DroidParameter,x
	lda DroidParameter,x
	cmp #4
	bcc skip2
	lda #128
	sta DroidAction,x
	lda DroidDirection,x
	eor #1
	sta DroidDirection,x
skip2	rts	
.)

DroidFrameForTurningLeft
 .byt 3,2,1,0
DroidFrameForTurningRight
 .byt 1,2,3,4


Action_Spark		;Param==Spark Index(Initially 7)
	;Already established that spark is valid here
	ldy DroidDirection,x
	lda DroidX,x
	clc
	adc TwosSparkOffset,y
	sta Object_X
	lda DroidY,x
	sec
	sbc #1
	sta Object_Y
	ldy DroidParameter,x
	lda DroidSparkFrame,y
	sta Object_V
	stx ScriptTempX
	jsr DisplayGraphicObject
	ldx ScriptTempX
	dec DroidParameter,x
.(
	bpl skip1
	lda #128
	sta DroidAction,x
	
	;ok so the last frame is never displayed
	stx ScriptTempX
	jsr RestoreObjectsBackground
	
	;Remove spark from collision map
	ldx ScriptTempX
	lda DroidX,x
	ldy DroidDirection,x
	clc
	adc TwosSparkOffset,y
	pha
	lda DroidY,x
	sec
	sbc #1
	tay
	pla
	jsr FetchCollisionMapLocation
	ldy #03
loop1	lda (screen),y
	and #%00011111
	sta (screen),y
	dey
	bpl loop1
skip1	rts
.)

	
DroidSparkFrame
 .byt 13,14,15,16
 .byt 13,14,15,16

Action_Wait		;Param==Wait Period
	dec DroidParameter,x
.(
	bne skip1
	lda #128
	sta DroidAction,x
skip1	jmp PlotDroid
.)		

DeleteDroid
	stx ScriptTempX
	;Restore Droid BG
	lda DroidX,x
	ldy DroidY,x
	jsr RecalcScreen
	
	;Locate droid BG area
	lda DroidY,x
	jsr CalcBGBufferRowAddress
	adc DroidX,x
	sta source
	tya
	adc #00
	sta source+1
	
	ldx #13
.(
loop2	ldy #2
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #40
	jsr AddSource
	jsr nl_screen
	dex
	bne loop2
.)
	;Delete Droid from Collision Map
	ldx ScriptTempX
	lda DroidY,x
	adc #5
	tay
	lda DroidX,x
	adc #1
	jsr FetchCollisionMapLocation2
	ldy #00
	lda (screen),y
	and #%00011111
	sta (screen),y
	
	sec
	rts

	
PlotDroid	stx ScriptTempX

	lda DroidX,x
	ldy DroidY,x
	jsr RecalcScreen
	
	;Locate Droid Bitmap
	ldy DroidFrameID,x
	lda DroidBitmapAddressLo,y
	sta bitmap
	lda DroidBitmapAddressHi,y
	sta bitmap+1
	
	;Locate Droid Mask
	lda DroidMaskAddressLo,y
	sta mask
	lda DroidMaskAddressHi,y
	sta mask+1
	ldx #13
.(
loop2	ldy #2
loop1
	lda (screen),y
	bmi CheckMask
	and (mask),y
	ora (bitmap),y
	jmp skip1
CheckMask	;If the Background(screen) is inversed then invert and mask
	eor #63
	and (mask),y
	ora (bitmap),y
skip1	sta (screen),y
next	dey
	bpl loop1
	lda #3
	jsr AddSource
	jsr nl_screen
	lda mask
	adc #3
	sta mask
	
	bcc skip2
	inc mask+1
	clc
skip2
;	lda mask+1
;	adc #00
;	sta mask+1
	lda bitmap
	adc #3
	sta bitmap
	
	bcc skip3
	inc bitmap+1
	clc
skip3
;	lda bitmap+1
;	adc #00
;	sta bitmap+1
	dex
	bne loop2
.)
	ldx ScriptTempX
	
	lda DroidsSnoozing
.(
	bne skip1
	;Write Droid to Collision Map
	ldx ScriptTempX
	lda DroidY,x
	adc #5
	tay
	lda DroidX,x
	adc #1
	jsr FetchCollisionMapLocation2
	ldy #00
	lda (screen),y
	and #%00011111
	ora DroidCollisionFootprint,x
	sta (screen),y

skip1	clc
.)
	rts

DroidCollisionFootprint
 .byt COL_DROID0
 .byt COL_DROID1
 .byt COL_DROID2
 .byt COL_DROID3
 .byt COL_DROID4

;***********************
UltimateDroid
 .byt 255
DroidDelayCount
 .dsb 5,0
DroidDelayRefer
 .dsb 5,0
DroidAction
 .dsb 5,0
DroidScriptID
 .dsb 5,0
DroidScriptIndex
 .dsb 5,0
DroidParameter
 .dsb 5,0
DroidY
 .dsb 5,0
DroidDirection	;0==Left / 1==Right
 .dsb 5,0
DroidX
 .dsb 5,0
DroidsRailEnd
 .dsb 5,0
DroidsRailStart
 .dsb 5,0
DroidFrameID
 .dsb 5,0

DroidActionVectorLo
 .byt <Action_Moving
 .byt <Action_LookBack
 .byt <Action_ReturnToCourse
 .byt <Action_Turn
 .byt <Action_Spark
 .byt <Action_Wait
DroidActionVectorHi
 .byt >Action_Moving
 .byt >Action_LookBack
 .byt >Action_ReturnToCourse
 .byt >Action_Turn
 .byt >Action_Spark
 .byt >Action_Wait
DroidScriptBaseAddressLo
 .byt <DroidScript00
 .byt <DroidScript01
 .byt <DroidScript02
 .byt <DroidScript03
DroidScriptBaseAddressHi
 .byt >DroidScript00
 .byt >DroidScript01
 .byt >DroidScript02
 .byt >DroidScript03
DroidScriptInstructionCodeAddressLo
 .byt <Droid_SetSpeed
 .byt <Droid_Move
 .byt <Droid_LookBack
 .byt <Droid_OnSense
 .byt <Droid_ReturnToCourse
 .byt <Droid_OnEndOfRail
 .byt <Droid_Turn
 .byt <Droid_Spark
 .byt <Droid_Jump
; .byt <Droid_Wait
; .byt <Droid_Face
DroidScriptInstructionCodeAddressHi
 .byt >Droid_SetSpeed
 .byt >Droid_Move
 .byt >Droid_LookBack
 .byt >Droid_OnSense
 .byt >Droid_ReturnToCourse
 .byt >Droid_OnEndOfRail
 .byt >Droid_Turn
 .byt >Droid_Spark
 .byt >Droid_Jump
; .byt >Droid_Wait
; .byt >Droid_Face
DroidScriptInstructionBytes
 .byt 2	;Droid_SetSpeed,Speed Frac
 .byt 2	;Droid_Move,Step
 .byt 1	;Droid_LookBack
 .byt 2	;Droid_OnSense,Index
 .byt 1	;Droid_ReturnToCourse
 .byt 1	;Droid_OnEndOfRail
 .byt 1	;Droid_Turn
 .byt 1	;Droid_Spark
 .byt 2	;Droid_Jump,Index
 .byt 2	;Droid_Wait,Period
 .byt 1	;Droid_Face

