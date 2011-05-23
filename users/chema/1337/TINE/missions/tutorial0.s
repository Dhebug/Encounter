
;; Tutorial 0. Flying

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
	jmp InitMission
	
// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word str_Summary1
MissionCargo		.byt 0	; Cargo for this mission
AvoidOtherShips		.byt $ff	; If not zero, no other ships are created

// Some internal variables and code 


tab_sumlo
	.byt <str_Summary,<str_Summary1
tab_sumhi
	.byt >str_Summary,>str_Summary1

InitMission
.(
	lda _mission
	and #%1
	tax
	lda tab_sumlo,x
	sta MissionSummary
	lda tab_sumhi,x
	sta MissionSummary+1
	rts
.)


PlayerLaunch
.(
	; What needs to be done when player launches?
	; basically either brief mission or load cargo.

	; Check mission state
	lda _mission
	cmp #THISMISSION+1
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

	; Change summary which prints on status page
	lda #<str_Summary
	sta MissionSummary
	lda #>str_Summary
	sta MissionSummary+1


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
	cmp #THISMISSION+2
	beq doit
	clc
	rts
doit
	lda #<str_msg
	sta tmp0
	lda #>str_msg
	sta tmp0+1
	ldx #0
	jsr IndFlightMessage
	clc
	rts
.)

str_MissionBrief
	.asc "This is the main cockpit. At the top"
	.byt 13
	.asc "you can see the Missile indicators"
	.byt 13
	.asc "The ID of your target (SPACE to"
	.byt 13
	.asc "change), ECM detection, and Mass"
	.byt 13
	.asc "pressence indicators."
	.byt 11	
	.byt 13
	.asc "The bottom pannels are as follows:"
	.byt 13
	.byt 13
	.byt 13
	.asc "Shields               Compass  Power"
	.byt 13
	.asc "Speed        Scanner           redir"
    .byt 13
	.asc "Laser temp            Energy banks"
	.byt 11	
    .asc "First of all let's practice flying."
	.byt 13
	.byt 13
	.asc "Roll: Q,W Yaw: N,M Pitch: X,S"
	.byt 13
	.asc "Accelerate O, deccelerate L"
	.byt 13
	.asc "Change front/rear views with V"
	.byt 13
	.byt 13
	.asc "Use the compass to find the planet"
	.byt 13
	.asc "  Filled = in front of you"
	.byt 13
	.asc "  Hollow = at your back."
	.byt 13
	.asc "When done, land in Lave again."
	.byt 0

str_msg
	.asc "To land, fly to the planet"
	.byt 0
	
	

str_MissionDebrief
	.asc "Well done Commander."
	.byt 13
	.asc "Next tutorial will train you in basic"
	.byt 13
	.asc "targetting and firing."
	.byt 13
	.asc "Launch again (1) when ready."
	.byt 0

str_Summary1
	.byt 2
	.asc "Tutorial 1:"
	.byt 13
	.byt 2 
	.asc "Launch (press 1) to start"
	.byt 13
	.byt 0

str_Summary
	.byt 2
	.asc "Tutorial 1:"
	.byt 13
	.byt 2 
	.asc "Land in Lave for next tutorial"
	.byt 13
	.byt 0

.)


