

ProcessRoomLift
	lda LiftStatus
	cmp #LIFT_GOINGDOWN
	beq ProcessLiftGoingDown
ProcessLiftGoingUp
	ldx CurrentLift
	lda LiftPlatform_Group,x
	sta TempGroup
	
	;Move Ethan Up
	jsr DeleteEthan
	lda EthanY
	sec
	sbc #6
	sta EthanY
	jsr PlotEthan
	
	;Move up all lifts in group by 6 pixels
	ldx UltimateLiftPlatform
	stx pl_tempx
.(	
loop1	ldx pl_tempx
	lda LiftPlatform_Group,x
	cmp TempGroup
	bne skip1
	
	;Delete this lift
	lda LiftPlatform_X,x
	sta Object_X
	lda LiftPlatform_Y,x
	sta Object_Y
	lda #SHAFTGFX
	sta Object_V
	jsr DisplayGraphicObject
	
	;Delete lift from collision map
	ldx Object_X
	ldy Object_Y
	jsr DeleteLiftInCollisionMap
	
	;Move it up 6 pixels
	ldx pl_tempx
	lda LiftPlatform_Y,x
	sec
	sbc #6
	sta LiftPlatform_Y,x
	
	;Plot this lift
	sta Object_Y
	lda #LIFTGFX
	sta Object_V
	jsr DisplayGraphicObject
	
	;Plot lift in collision map
	ldx Object_X
	ldy Object_Y
	jsr PlotLiftInCollisionMap
	
	;Adjust how much we can move this lift after
	ldx pl_tempx
	dec LiftPlatform_CanMoveThisMuchUp,x
	inc LiftPlatform_CanMoveThisMuchDown,x

	;Proceed to next Lift
skip1	dec pl_tempx	
	bpl loop1
	
	dec Lifts_TotalStepsCount
	bne skip2
	
	;End Lift
	lda #00
	sta LiftStatus
	
	;Set the new level Ethan is now at (We'll currently just dec, but if we decide on bigger steps
	;this will need reworking
	dec EthansCurrentLevel

skip2	rts
.)
ProcessLiftGoingDown
	ldx CurrentLift
	lda LiftPlatform_Group,x
	sta TempGroup
	
	;Move Ethan Down
	jsr DeleteEthan
	lda EthanY
	clc
	adc #6
	sta EthanY
	
	;Move up all lifts in group by 6 pixels
	ldx UltimateLiftPlatform
	stx pl_tempx
.(	
loop1	ldx pl_tempx
	lda LiftPlatform_Group,x
	cmp TempGroup
	bne skip1
	
	;Delete this lift
	lda LiftPlatform_X,x
	sta Object_X
	lda LiftPlatform_Y,x
	sta Object_Y
	lda #SHAFTGFX
	sta Object_V
	jsr DisplayGraphicObject
	
	;Delete lift from collision map
	ldx Object_X
	ldy Object_Y
	jsr DeleteLiftInCollisionMap
	
	;Move it down 6 pixels
	ldx pl_tempx
	lda LiftPlatform_Y,x
	clc
	adc #6
	sta LiftPlatform_Y,x
	
	;Plot this lift
	sta Object_Y
	lda #LIFTGFX
	sta Object_V
	jsr DisplayGraphicObject

	;Plot lift in collision map
	ldx Object_X
	ldy Object_Y
	jsr PlotLiftInCollisionMap
	
	;Adjust how much we can move this lift after
	ldx pl_tempx
	inc LiftPlatform_CanMoveThisMuchUp,x
	dec LiftPlatform_CanMoveThisMuchDown,x
	
	;Proceed to next Lift
skip1	dec pl_tempx	
	bpl loop1
	
	dec Lifts_TotalStepsCount
	bne skip2
	
	;End Lift
	lda #00
	sta LiftStatus
;	lda #SFX_ROOMLIFTEND
;	jsr KickSFX
	;
	inc EthansCurrentLevel
	
skip2	jmp PlotEthan
.)

PlotLiftInCollisionMap
	txa
	jsr FetchCollisionMapLocation
	ldy #00
	lda #COL_PLATFORM
	sta (screen),y
	iny
	lda pl_tempx
	adc #COL_LIFTPLATFORM0
	sta (screen),y
	iny
	sta (screen),y
	iny
	lda #COL_PLATFORM
	sta (screen),y
	rts

DeleteLiftInCollisionMap
	txa
	jsr FetchCollisionMapLocation
	ldy #03
	tya
.(
loop1	lda (screen),y
	and #%11100000
	sta (screen),y
	dey
	bpl loop1
.)
	rts
