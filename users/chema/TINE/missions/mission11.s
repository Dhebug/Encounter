
;; Mission 11. Encounter with Torjan Mino in Gelesoma (79), galaxy 7


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
	jmp MissionSuccess
OnPlayerHyper
	jmp MissionSuccess
OnExplodeShip
	jmp ShipKilled
OnDockedShip
	clc
	rts
	.byt 00
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

TorjanShip		.byt 00


MissionLaunch
.(
	lda _mission
	cmp #THISMISSION
	bne nolaunch

	lda _galaxynum
	cmp #7 
	bne nolaunch

	lda _currentplanet
	cmp #79
	bne nolaunch

	inc AvoidOtherShips

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
	cmp #THISMISSION
	beq nolaunch

	dec AvoidOtherShips

	lda _mission
	cmp #THISMISSION+1
	beq failure

	lda #NEXTMISSION
	sta _mission

	; Pay the player (100000=$186a0)
	lda #$a0
	clc
	adc _cash
	sta _cash
	lda #$86
	adc _cash+1
	sta _cash+1
	lda #$1
	adc _cash+2
	sta _cash+2
	bcc nomore
	inc _cash+3
nomore	

	; And add score
	lda #<$500
	clc
	adc _score
	sta _score
	lda #>$500
	adc _score+1
	sta _score+1


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

CreateMissionShips
.(
	; Create Torjan's ship
    lda #<POS1
    sta tmp0
    lda #>POS1   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	stx TorjanShip

	lda #(IS_AICONTROLED|FLG_PIRATE)
	sta _ai_state,x
	ora #IS_ANGRY
	lda #1
	sta _target,x

    lda #<POS2
    sta tmp0
    lda #>POS2   
    sta tmp0+1
	lda #SHIP_KRAIT
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda #1
	ora #IS_ANGRY
	sta _target,x

    lda #<POS3
    sta tmp0
    lda #>POS3   
    sta tmp0+1
	lda #SHIP_KRAIT
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda #1
	ora #IS_ANGRY
	sta _target,x

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
	cpx TorjanShip
	bne nothing
	lda #<str_hekilled
	sta tmp0
	lda #>str_hekilled
	sta tmp0+1
	ldx #0
	jsr IndFlightMessage

	inc _mission
	clc
	rts
.)

str_MissionBrief
	.asc "Look who is here..."
	.byt 13
	.asc "My name is Torjan Mino."
	.byt 13
	.asc "You have interfered my bussiness"
	.byt 13
	.asc "for the last time."
	.byt 13
	.byt 13
	.asc "Prepare to meet thy doom."
	.byt 13
	.byt 0

str_MissionDebrief
	.asc "You have elliminated Torjan Mino."
	.byt 13
	.asc "There was a warrant on his head"
	.byt 13
	.asc "of 10000 Credits!"
	.byt 13
	.byt 13
	.asc "Well done!"
	.byt 0

str_MissionFailure
	.asc "You saved your life, but Torjan"
	.byt 13
	.asc "Mino escaped."
	.byt 0
str_hekilled
	.asc "You killed Torjan Mino!"
	.byt 0
	.asc "Mission successfull."
	.byt 0
str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Eliminate Torjan Mino"
	.byt 13
	.byt 0

.)






