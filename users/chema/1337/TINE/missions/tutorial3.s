
;; Tutorial 3. basic trade

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
	clc
	rts
	.byt 00
OnDockedShip
	clc
	rts
	.byt 00
OnHyperShip
	clc
	rts
	.byt 00
OnEnteringSystem
	jmp PlayerJumped
OnNewEncounter
	clc
	rts
	.byt 00

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
AvoidOtherShips		.byt 0	; If not zero, no other ships are created

// Some internal variables and code 

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

PlayerJumped
.(
	lda _galaxynum
	cmp #1
	bne nolaunch
	lda _currentplanet
	cmp #129 ;Zaonce
	bne nolaunch

	; Prepare brief message
	lda #<str_MissionBrief2
	sta TXTPTRLO
	lda #>str_MissionBrief2
	sta TXTPTRHI

	; Return with message to be printed
	sec
	rts
.)

PlayerDock
.(
	lda _galaxynum
	cmp #1
	bne nolaunch
	lda _currentplanet
	cmp #129 ;Zaonce
	bne nolaunch

	lda _mission
	cmp #THISMISSION+1
	bne nolaunch

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



str_MissionBrief
    .asc "Be sure you have Zaonce as your"
	.byt 13
	.asc "target system (2) or do so now (4)."
	.byt 13
	.asc "Fly away from Lave until the mass"
	.byt 13
	.asc "indicator (upper right) turns green."
	.byt 13
	.asc "Then you can hyper jump (J)."
	.byt 13
	.byt 13
	.asc "Avoid combat or smuggling until you"
	.byt 13
	.asc "are ready for it."
	.byt 0

str_MissionBrief2
    .asc "Quickly locate the planet in your"
	.byt 13
	.asc "compass and fly towards it at full"
	.byt 13
	.asc "speed (O). Watch your scanner and"
	.byt 13
	.asc "identify any potential dangers."
	.byt 13
	.byt 13
	.asc "Watch the mass indcator and how it"
	.byt 13
	.asc "changes when you enter the planet's"
	.byt 13
	.asc "area or when about to dock."
	.byt 0


str_MissionDebrief
	.asc "Sell the food in the market (6)"
	.byt 13
	.asc "and check your earnings, but"
	.byt 13 
	.asc "remember the hyperjump needs fuel."
	.byt 13 
	.asc "Check your current fuel in the"
	.byt 13 
	.asc "status screen (2) and refill tanks"
	.byt 13
	.asc "at the equip ship screen (7)."
	.byt 13
	.asc "The tutorial is over. Good luck."
	.byt 0

str_Summary
	.byt 2
	.asc "Tutorial 4:"
	.byt 13
	.byt 2 
	.asc "Carry food to Zaonce"
	.byt 13
	.byt 0

.)


