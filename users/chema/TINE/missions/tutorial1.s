
;; Tutorial 1. basic firing

.(
// Jump table to mission functions    
// These are kind of event handlers  
// OnPlayerXXX. The idea is patching these with the necessary jumps. If returns C=1 it means
// that text is to be plotted to screen (brief or debrief). 

OnPlayerLaunch
	jmp PlayerLaunch
OnPlayerDock
	jmp PlayerDock
OnPlayerHyper
	clc
	rts
	.byt 00
OnExplodeShip
	jsr CheckTarget
OnDockedShip
	clc
	rts
	.byt 00
OnHyperShip
	clc
	rts
	.byt 00
OnEnteringSystem
	clc
	rts
	.byt 00
OnNewEncounter
	jmp HelpMessage

// OnScoopObject return with carry =1 if it has handled the scooping, so the main program
// avoids doing so.

OnScoopObject		
	clc
	rts 
	.byt 00

// OnGameLoaded, called whenever the game has been loaded from disk, for initializing things...
OnGameLoaded
	clc
	rts
	.byt 00
	
// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word str_Summary
MissionCargo		.byt 0	; Cargo for this mission
AvoidOtherShips		.byt $ff	; If not zero, no other ships are created

// Some internal variables and code 

nTargets .byt  5

POS1
	.word 0
	.word 0
	.word -2000
POS2
	.word -2000
	.word 0
	.word -2000
POS3
	.word 2000
	.word 0
	.word -2000
POS4
	.word -2000
	.word 0
	.word -1000
POS5
	.word 2000
	.word 0
	.word -1000
POS6
	.word 0
	.word 0
	.word 0


PlayerLaunch
.(
	; What needs to be done when player launches?
	; basically either brief mission or load cargo.

	; Check mission state
	lda _mission
	cmp #THISMISSION
	beq firststart
	clc
	rts

firststart
	lda _galaxynum
	cmp #1
	bne nolaunch
	lda _currentplanet
	cmp #7 ;Lave
	bne nolaunch

	; Launch mission, increment state to 1
	inc _mission

	; Create targets
	lda #6
	sta nTargets
	lda #<POS1
	sta tmp0
	lda #>POS1
	sta tmp0+1
loop
    lda #SHIP_SPLINTER
    jsr IndAddSpaceObject

	lda tmp0
	clc
	adc #6
	sta tmp0
	bcc nocarry
	inc tmp0+1
nocarry
	dec nTargets
	bne loop

	lda #6
	sta nTargets

	; Prepare brief message
	lda #<str_MissionBrief
	sta TXTPTRLO
	lda #>str_MissionBrief
	sta TXTPTRHI

	; Return with message to be printed
	sec
	rts
.)

nolaunch
	clc
	rts


PlayerDock
.(
	lda _galaxynum
	cmp #1
	bne nolaunch
	lda _currentplanet
	cmp #7 ;Lave
	bne nolaunch

	lda nTargets
	beq success

	lda #THISMISSION
	sta _mission

	; Prepare debriefing
	lda #<str_MissionDebrief2
	sta TXTPTRLO
	lda #>str_MissionDebrief2
	sta TXTPTRHI
	sec
	rts

success
	; Set next mission
	lda #NEXTMISSION
	sta _mission


	; Prepare debriefing
	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	; Flag that we need to load mission from disk
	dec NeedsDiskLoad

	; Return with message to be printed.
	sec
	rts
.)


HelpMessage
.(
	lda _mission
	cmp #THISMISSION+1
	beq doit
retme
	clc
	rts
doit
	lda nTargets
	beq retme

	lda #<str_msg
	sta tmp0
	lda #>str_msg
	sta tmp0+1
	ldx #0
	jsr IndFlightMessage
	clc
	rts
.)


CheckTarget
.(
	jsr IndGetShipType
	cmp #SHIP_SPLINTER
	bne ret
	dec nTargets
	bne onemore
	lda #<str_all
	ldy #>str_all
	jmp printit
onemore
	lda #<str_hit
	ldy #>str_hit
printit
	sty tmp0+1
	sta tmp0
	ldx #0
	jsr IndFlightMessage
ret
	clc
	rts
.)

str_MissionBrief
    .asc "Let's practice targetting now."
	.byt 13
	.asc "Use the scanner to locate ships"
	.byt 13
	.asc "around you. You can target them"
	.byt 13
	.asc "with your compass using SPACE,"
	.byt 13
	.asc "which is vital in dogfighting."
	.byt 13
	.byt 13
	.asc "Fire with A and destroy all the"
	.byt 13
	.asc "targets. Then land back in Lave."
	.byt 13
	.asc "Watch the laser temperature, and use"
	.byt 13
	.asc "Power redir (P) to cool them quicker."
	.byt 0

str_msg
	.asc "Destroy all targets"
	.byt 0
str_hit
	.asc "Good shot, commander!"
	.byt 0
str_all
	.asc "Well done! Now land"
	.byt 0
	

str_MissionDebrief
	.asc "Well done Commander."
	.byt 13
	.asc "Next tutorial will train you in basic"
	.byt 13
	.asc "combat, so review the ship main"
	.byt 13
	.asc "controls and launch again when ready."
	.byt 0

str_MissionDebrief2
	.asc "You have not destroyed all the targets."
	.byt 13
	.asc "Launch and try again."
	.byt 0


str_Summary
	.byt 2
	.asc "Tutorial 2:"
	.byt 13
	.byt 2 
	.asc "Destroy all targets"
	.byt 13
	.byt 0

.)


