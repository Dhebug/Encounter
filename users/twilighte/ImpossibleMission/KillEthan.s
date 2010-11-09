;KillEthan.s

DeathByElectricution
	lda #SFX_ELECTRICUTION
	jsr KickSFX
	;Alternate Ethan being electricuted (whiteout) and normal (Normal) of last frame and direction
	lda #10
	sta Temp01
.(
loop1	jsr WhiteOutEthan
	jsr ElectricutionDelay
	jsr PlotEthan
	jsr ElectricutionDelay
	dec Temp01
	bne loop1
.)
	;Display 
	ldx #ROOMTEXT_YOUDIED
	jsr DisplayRoomText

	jmp KillEthan


ElectricutionDelay
	;Play SFX
	
	lda #2
SlowDown	sta DroidDelay
	;Wait on IRQ
.(
loop1	lda DroidDelay
	bne loop1
.)
	rts


DeathByHeight
	lda #SFX_DEATHBYHEIGHT
	jsr KickSFX
	;Ensure X does not overlap screen bounds
	lda EthanX
	cmp #34
.(
	bcc skip1
	sbc #3
skip1	sta Object_X
.)
	lda #134
	sta Object_Y
	lda #SPEECHAARGH
	sta Object_V
	jsr DisplayGraphicObject
	
	;Wait until sfx ends
.(
loop1	lda sfx_Status+1
	bne loop1
.)	
	;Record Death in Room Text window
	ldx #ROOMTEXT_YOUDIED
	jsr DisplayRoomText

KillEthan
	;Subtract 10 Minutes from time
	lda #1
	sta GamePaused
	lda #10
	sta keMinuteCounter
.(
loop1	jsr DecrementMinutes
	dec keMinuteCounter
	bne loop1
.)
	
	lda #0
	sta GamePaused
	sta DroidsSnoozing
	
	;Restore Lift positions
	jsr RestoreLiftPositions
	
	;Redraw Room
	jsr PlotRoom
	
	;Reposition Hero where he entered room
	lda EthansStartX
	sta EthanX
	lda EthansStartY
	sta EthanY
	lda EthanStartFacingID
	sta EthanFacingID
	ldy EthanStartLevel
	sty EthansCurrentLevel
	lda #ACTION_STANDING
	sta EthanCurrentAction
	ldx #ETHAN_STANDING
	stx EthanFrame

	;Seems the above is still not so reliable so hook hero to platform
	jsr TieEthan2Platform

	jsr FlushInputBuffer
	
	lda #00
	sta LiftStatus
	sta SearchingStatus
		
	jmp IgnoreNewPosition

RestoreLiftPositions
	ldx RoomID
	lda RoomAddressLo,x
	sta room
	lda RoomAddressHi,x
	sta room+1
	
	ldy #00
.(
loop1	lda (room),y
	tax
	cmp #END
	beq skip3
	cmp #LIFTPLATFORMS
	bne skip2
	;+0 LIFTPLATFORMS
	;+1 GroupID
	;+2 Original Position
	;+3 Current Position
	iny
	iny
	lda (room),y
	iny
	sta (room),y
	iny
	jmp skip1
skip2	tya
	clc
	adc CommandBytes,x
	tay
skip1	jmp loop1
skip3	rts
.)
