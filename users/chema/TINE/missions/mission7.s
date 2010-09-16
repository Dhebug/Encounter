
;; Mission 7. Lost Cannister at Rebees (8)


.(
// Jump table to mission functions    
// These are kind of event handlers  
// OnPlayerXXX. The idea is patching these with the necessary jumps. If returns C=1 it means
// that text is to be plotted to screen (brief or debrief). 

OnPlayerLaunch
	clc
	rts
	.byt 00
OnPlayerDock
    jmp CheckSuccess
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
	jmp LaunchMission
OnNewEncounter
	clc
	rts
	.byt 00


// OnScoopObject return with carry =1 if it has handled the scooping, so the main program
// avoids doing so.

OnScoopObject		
	jmp CheckScoop

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

IdItem				.byt 0

LaunchMission
.(
	lda _mission
	cmp #THISMISSION+1
	bne nolaunch

	lda _galaxynum
	cmp #3 
	bne nolaunch

	lda _currentplanet
	cmp #8
	bne nolaunch

	inc _mission

	jsr CreateItemForScoop

	lda #<str_MissionBrief
	sta TXTPTRLO
	lda #>str_MissionBrief
	sta TXTPTRHI
	sec
	rts

.)
nolaunch
	clc
	rts

CheckSuccess
.(
 	lda _mission
	cmp #THISMISSION+2
	beq fail

	cmp #THISMISSION+3
	bne nolaunch

	lda _galaxynum
	cmp #3 
	bne nolaunch

	lda _currentplanet
	; 0 is Riave
	;bne fail
	beq done
	clc
	rts
done
	lda #NEXTMISSION
	sta _mission

	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	dec NeedsDiskLoad
	sec
	rts

fail
	lda #NEXTMISSIONFAIL
	sta _mission

	lda #<str_MissionDebriefFail
	sta TXTPTRLO
	lda #>str_MissionDebriefFail
	sta TXTPTRHI

	sec
	rts

.)



POS1
	.word -4000
	.word -4000
	.word -4000
POS2
	.word -4000
	.word -4000
	.word -4600
POS3
	.word 4000
	.word -4000
	.word -4000
POS4
	.word -4000
	.word 5000
	.word -6000


CreateItemForScoop
.(
    lda #<POS2
    sta tmp0
    lda #>POS2   
    sta tmp0+1
    lda #(SHIP_CARGO|$80)
    jsr IndAddSpaceObject
	stx IdItem

    lda #<POS1
    sta tmp0
    lda #>POS1   
    sta tmp0+1
    lda #SHIP_ASTEROID
    jsr IndAddSpaceObject

    lda #<POS3
    sta tmp0
    lda #>POS3   
    sta tmp0+1
    lda #SHIP_ASTEROID
    jsr IndAddSpaceObject

    lda #<POS4
    sta tmp0
    lda #>POS4   
    sta tmp0+1
    lda #(SHIP_COUGAR|$80)
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_PIRATE)
	sta _ai_state,x
	lda #$81
	sta _target,x

	rts
.)


CheckScoop
.(
	lda _mission
	cmp #THISMISSION+2
	bne itsnot

	lda _galaxynum
	cmp #3 
	bne itsnot

	lda _currentplanet
	cmp #8
	bne itsnot


	cpx IdItem
	bne itsnot
	inc _mission
	lda #<str_gotit
	sta tmp0
	lda #>str_gotit
	sta tmp0+1
	ldx #0
	jsr IndFlightMessage
	sec
	rts
itsnot
	clc
	rts
.)


str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Get cannister at Rebees. Bring it to"
	.byt 13
	.byt 2 
	.asc "Riave."
	.byt 0


str_gotit
	.asc "Stolen Hi-Tech"
	.byt 0

str_MissionBrief
	.asc "The cannister is hidden behind one"
	.byt 13
	.asc "asteroid. It has a cloacking"
	.byt 13
	.asc "device, so won't appear in your"
	.byt 13
	.asc "radar. Pick it up and bring it"
	.byt 13
	.asc "back to Riave."
	.byt 0

str_MissionDebriefFail
	.asc "You have not followed my"
	.byt 13
	.asc "instructions. Our deal is"
	.byt 13
	.asc "over. Good luck."
	.byt 0


str_MissionDebrief
	.asc "Zantor worked in a project for"
	.byt 13
	.asc "the GalCop Navy. Torjan is said"
	.byt 13
	.asc "to sell secrets. I am sure he"
	.byt 13
	.asc "got something from Zantor's"
	.byt 13
	.asc "research. Zantor is not a traitor,"
	.byt 13
	.asc "so there must be another link."
	.byt 13
	.byt 13
	.asc "I'll try to find out more and"
	.byt 13
	.asc "let you know soon. Stay around."
	.byt 0
.)



#ifdef 0	
	.byt 13
	.asc "You should go to MaynardCo's lab"
	.byt 13
	.asc "at Edorqu (gal 4), and ask there."	; 10
	.byt 0
#endif
