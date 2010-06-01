
;; Tutorial 2. basic combat

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

enemy .byt 00

POS1
	.word 0
	.word 0
	.word -2000


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
	lda #<POS1
	sta tmp0
	lda #>POS1
	sta tmp0+1

    lda #SHIP_ADDER
    jsr IndAddSpaceObject
	stx enemy

	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda #(1|IS_ANGRY)
	sta _target,x

	; Set number of missiles to zero
	lda #%11111000
	and _missiles,x
	sta _missiles,x
	
	
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

	lda _mission
	cmp #THISMISSION+2
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



CheckTarget
.(
	cpx enemy
	bne ret
	inc _mission
ret
	clc
	rts
.)


HelpMessage
.(
	lda _mission
	cmp #THISMISSION+2
	beq doit
retme
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
    .asc "Let's practice simple combat now."
	.byt 13
	.asc "Use the scanner and compass to locate"
	.byt 13
	.asc "the enemy ship. Watch out your"
	.byt 13
	.asc "shields and energy as well as your"
	.byt 13
	.asc "laser temperature, and use Power"
	.byt 13
	.asc "redirection (P) wisely."
	.byt 13
	.byt 13
	.asc "When finished, land back in Lave."
	.byt 0

str_msg
	.asc "Well done! Now land"
	.byt 0
	

str_MissionDebrief
	.asc "Now we will focus on trading. Press"
	.byt 13 
	.asc "2-7 and get used to the different"
	.byt 13
	.asc "screens of your console. As Lave is"
	.byt 13 
	.asc "an agricultural planet we'll buy (6)"
	.byt 13 
	.asc "food. Then select Zaonce (4) and"
	.byt 13
	.asc "check it is an industrial system (3)"
	.byt 13
	.asc "We will sell those goods there."
	.byt 0

str_MissionDebrief2
	.asc "You have not destroyed the enemy ship."
	.byt 13
	.asc "Launch and try again."
	.byt 0


str_Summary
	.byt 2
	.asc "Tutorial 3:"
	.byt 13
	.byt 2 
	.asc "Destroy enemy ship"
	.byt 13
	.byt 0

.)


