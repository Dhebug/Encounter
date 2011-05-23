
;; Mission 4. Protect Zantor


.(
// Jump table to mission functions    
// These are kind of event handlers  
// OnPlayerXXX. The idea is patching these with the necessary jumps. If returns C=1 it means
// that text is to be plotted to screen (brief or debrief). 

OnPlayerLaunch
	jmp MissionStart
OnPlayerDock
	jmp MissionSuccess
OnPlayerHyper
	jmp HyperJump
OnExplodeShip
	jmp ShipKilled
OnDockedShip
	jmp ShipDocked
OnHyperShip
	clc
	rts
	.byt 00
OnEnteringSystem
	jmp MissionLaunch
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

ShipToProtect	.byt 00
Succeeded		.byt 00
Failed			.byt 00


HyperJump
.(
	lda AvoidOtherShips
	beq checklaunch

	; It was already launched!
	jmp MissionSuccess

checklaunch
	jmp MissionStart

.)

MissionStart
.(
	lda _mission
	cmp #THISMISSION
	bne nolaunch

	lda _galaxynum
	cmp #2 
	bne nolaunch

	jsr IndRnd
	cmp #$50
	bcs nolaunch

	inc AvoidOtherShips
	rts
.)

MissionLaunch
.(
/*
	lda _mission
	cmp #THISMISSION
	bne nolaunch

	jsr IndRnd
	cmp #$50
	bcs nolaunch
*/
	lda AvoidOtherShips
	beq nolaunch

	; launch mission
	inc _mission

	jsr CreateMissionShips

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

MissionSuccess
.(
	lda _mission
	cmp #THISMISSION+1
	bne nolaunch

	dec AvoidOtherShips

	lda Succeeded
	beq failure

	lda Failed
	bne failure

	lda #NEXTMISSION
	sta _mission

	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	dec NeedsDiskLoad

	sec
	rts

failure
	lda #<str_MissionFailure
	sta TXTPTRLO
	lda #>str_MissionFailure
	sta TXTPTRHI

	lda #NEXTMISSIONFAIL
	sta _mission
	sec
	rts
.)

POS1
	.word 0
	.word 0
	.word -2000
POS2
	.word 4500
	.word 0
	.word -8000
POS3
	.word -4500
	.word 0
	.word -8000
POS4
	.word -4500
	.word -4500
	.word -7000

CreateMissionShips
.(
	; Create ship fleeing...
    lda #<POS1
    sta tmp0
    lda #>POS1   
    sta tmp0+1
    lda #SHIP_COBRA1
    jsr IndAddSpaceObject
	stx ShipToProtect
	lda #(FLG_FLY_TO_PLANET|FLG_INNOCENT)
	sta _flags,x
	lda #(IS_AICONTROLED|FLG_DEFENCELESS|FLG_BOLD)
	sta _ai_state,x
	lda #2
	sta _target,x

	; Create bad guys
    lda #<POS2
    sta tmp0
    lda #>POS2   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda ShipToProtect
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to zero
	lda #%11111000
	and _missiles,x
	sta _missiles,x

    lda #<POS3
    sta tmp0
    lda #>POS3   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda ShipToProtect
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to zero
	lda #%11111000
	and _missiles,x
	sta _missiles,x

    lda #<POS4
    sta tmp0
    lda #>POS4   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_PIRATE)
	sta _ai_state,x
	lda ShipToProtect
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to zero
	lda #%11111000
	and _missiles,x
	sta _missiles,x
	clc
	rts

.)

ShipDocked
.(
	lda _mission
	cmp #THISMISSION+1
	beq cont
nothing
	clc
	rts
cont
	cpx ShipToProtect
	bne nothing
	dec Succeeded	
	lda #<str_hedocked
	sta tmp0
	lda #>str_hedocked
	sta tmp0+1
	ldx #0
	jsr IndFlightMessage

	clc
	rts
.)


ShipKilled
.(
	lda _mission
	cmp #THISMISSION+1
	beq cont
nothing
	clc
	rts
cont
	cpx ShipToProtect
	bne nothing

	dec Failed

	lda #<str_hekilled
	sta tmp0
	lda #>str_hekilled
	sta tmp0+1
	ldx #0
	jsr IndFlightMessage

	clc
	rts
.)

str_MissionBrief
	.asc "   MAYDAY -- MAYDAY "
	.byt 13
	.byt 13
	.asc "My name is Zantor Maynard."
	.byt 13
	.asc "My Cobra-I ship is damaged and"
	.byt 13
	.asc "I am pursued by pirate Mambas."
	.byt 13
	.byt 13
	.asc "Please help me!."
	.byt 13
	.byt 0

str_MissionDebrief
	.asc "You have saved my life and I shall"
	.byt 13
	.asc "remember."
	.byt 0

str_MissionFailure
	.asc "Sadly you did not succeed. It was"
	.byt 13
	.asc "clearly too much for your skills."
	.byt 0
str_hedocked
	.asc "Zantor docked safely!"
	.byt 0
	.asc "Mission successful"
	.byt 0
str_hekilled
	.asc "Zantor has been killed!"
	.byt 0
	.asc "Mission failed"
	.byt 0
str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Save Zantor from pirates"
	.byt 13
	.byt 2
	.asc "so he can land safely."
	.byt 0

.)



