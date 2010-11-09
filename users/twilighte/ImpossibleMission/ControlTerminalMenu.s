;ControlTerminalMenu - Control security terminal menu
;Each Security terminal presents 3 options
; Reset Lifting Platforms in this room
; Temporarily disable robots in this room
; Log off

ControlTerminalMenu
	lda #128
	sta ConfirmationOption
	;Display Security Terminal Cursor
.(
loop1	jsr stDisplayCursor
	
	;Wait on key
	jsr WaitOnKey_NoRepeat

	;Delete cursor
	pha
	jsr stDeleteCursor
	pla
	
	;Sense Up
	cmp #CONTROLLER_UP
	bne skip1
	
	;Prevent moving up too far
	lda stOption
	beq loop1
	
	;Move option up
	dec stOption
	
	jmp loop1
	
skip1	cmp #CONTROLLER_DOWN
	bne skip2
	
	lda stOption
	cmp #2
	bcs loop1
	
	inc stOption
	
	jmp loop1
	
skip2	cmp #CONTROLLER_FIRE1
	bne loop1
.)
	;Execute option
	lda stOption
	sta ConfirmationOption
	beq CheckResetLiftingPlatforms
	cmp #1
	beq CheckTemporarilyDisableRobots
	rts
	
CheckTemporarilyDisableRobots
	lda RobotSnoozes
	beq MomentarilyDeny
	dec RobotSnoozes
	lda #1
	sta DroidsSnoozing
	lda TimedDelay
	clc
	adc #30
	sta TimedDelay
	jsr Display_RobotSnoozes
	jmp MomentarilyAccept

CheckResetLiftingPlatforms
	lda LiftResets
	beq MomentarilyDeny
	dec LiftResets
	inc ResetLiftOnReturn
	jsr Display_LiftResets
MomentarilyAccept
	jsr DisplayConfirmationFrames
	lda #<SecurityTerminalAcceptanceText
	sta line
	lda #>SecurityTerminalAcceptanceText
MomentarilyRent
	sta line+1
	ldx ConfirmationOption
	ldy ConfirmationTextYPOS,x
	ldx #10
	lda #00
	jsr DisplayTextLine
	lda #40
	jsr SlowDown
	;Just clear menu area then redisplay menu rather than restoring menu text rows
	jsr DisplaySecurityTerminalMenu
	jmp ControlTerminalMenu
MomentarilyDeny
	jsr DisplayConfirmationFrames
	lda #<SecurityTerminalDeniedText
	sta line
	lda #>SecurityTerminalDeniedText
	jmp MomentarilyRent
	
DisplayConfirmationFrames
	lda #<SecurityTerminalResponseFrameText
	sta line
	lda #>SecurityTerminalResponseFrameText
	sta line+1
	ldx ConfirmationOption
	ldy ConfirmationFrame1YPOS,x
	ldx #10
	lda #00
	jsr DisplayTextLine
	ldx ConfirmationOption
	ldy ConfirmationFrame2YPOS,x
	ldx #10
	lda #00
	jmp DisplayTextLine
	
ConfirmationFrame1YPOS
 .byt 52-7,73-7
ConfirmationTextYPOS
 .byt 59-7,80-7
ConfirmationFrame2YPOS
 .byt 66-7,87-7


stDisplayCursor
	lda #<SecurityTerminalCursorText
	sta line
	lda #>SecurityTerminalCursorText
	sta line+1
stDisplayCursorRent
	ldx stOption
	ldy stYPOS,x
	ldx #6
	lda #00
	jmp DisplayTextLine
	
stDeleteCursor
	lda #<SecurityTerminalCursorDelText
	sta line
	lda #>SecurityTerminalCursorDelText
	sta line+1
	jmp stDisplayCursorRent

stYPOS
 .byt 45,66,108


RedisplayLifts
	ldx UltimateLiftPlatform
.(
	bmi skip1
loop1	;Display on screen
	lda LiftPlatform_X,x
	sta Object_X
	lda LiftPlatform_Y,x
	sta Object_Y
	lda #LIFTGFX
	sta Object_V
	stx Temp01
	jsr DisplayGraphicObject
	ldx Temp01
	dex
	bpl loop1
skip1	rts	
.)	
