
;; Mission 5. Runaway to Resori (189)


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
	jmp MissionStart
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
	jmp CreateMissionShips
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
	jmp InitMission
	
// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word str_Summary1
MissionCargo		.byt 0	; Cargo for this mission
AvoidOtherShips		.byt 0	; If not zero, no other ships are created

// Some internal variables and code 

tab_sumlo
	.byt <str_Summary1,<str_Summary
tab_sumhi
	.byt >str_Summary1,>str_Summary

InitMission
.(
	lda _mission
	and #%11
	lsr
	tax
	lda tab_sumlo,x
	sta MissionSummary
	lda tab_sumhi,x
	sta MissionSummary+1
	clc
	rts
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
	inc _mission
.)
nolaunch
	clc
	rts

MissionSuccess
.(
	lda _mission
	cmp #THISMISSION+2
	bne ll

	inc _mission
	lda #<str_Summary
	sta MissionSummary
	lda #>str_Summary
	sta MissionSummary+1

	lda #<str_MissionBrief2
	sta TXTPTRLO
	lda #>str_MissionBrief2
	sta TXTPTRHI
	sec
	rts
ll
	cmp #THISMISSION+3
	bne nolaunch

	lda _galaxynum
	cmp #2 
	bne nolaunch
	lda _currentplanet
	cmp #189
	bne nolaunch

	lda #NEXTMISSION
	sta _mission

	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	dec NeedsDiskLoad

	sec
	rts

.)



POS1
	.word 0
	.word -4500
	.word 0
POS2
	.word 4500
	.word 0
	.word 0

CreateMissionShips
.(
	lda _mission
	cmp #THISMISSION+1
	bne nolaunch

	inc _mission
	dec AvoidOtherShips

	; Create ships
    lda #<POS1
    sta tmp0
    lda #>POS1   
    sta tmp0+1

	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda #1
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to one
	lda #%11111000
	and _missiles,x
	ora #%01
	sta _missiles,x

    lda #<POS2
    sta tmp0
    lda #>POS2   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda #1
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to one
	lda #%11111000
	and _missiles,x
	ora #%01
	sta _missiles,x

 	lda #<str_MissionBrief
	sta TXTPTRLO
	lda #>str_MissionBrief
	sta TXTPTRHI

	sec
	rts

.)


str_MissionBrief
	.asc "Send us the data Dr. Zantor"
	.byt 13
	.asc "transmitted to you, or prepare"
	.byt 13
	.asc "to die!"
	.byt 0

str_MissionBrief2
	.asc "Hi again Commander, Untha Banhath"
	.byt 13
	.asc "here. What have you been involved"
	.byt 13
	.asc "in? Somebody shady has been"
	.byt 13
	.asc "asking questions about you."
	.byt 13
	.asc "You are in danger, friend. This"
	.byt 13
	.asc "is serious. I will try to find"
	.byt 13
	.asc "out who is behind this. Meet me"
	.byt 13
	.asc "at Resori as soon as possible."
	.byt 0

str_MissionDebrief
	.asc "I have a name for you: Torjan"
	.byt 13
	.asc "Mino, someone dangerous. He is"
	.byt 13
	.asc "behind the murder of a certain"
	.byt 13
	.asc "Dr. Zantor Maynard at his home."
	.byt 13
	.asc "You should leave this galaxy as"
	.byt 13
	.asc "soon as possible and ask for" 
	.byt 13
	.asc "Garmond Hasler at Riave."
	.byt 0

str_Summary1
	.byt 0

str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.byt "Go to Resori to find out"
	.byt 13
	.byt 2
	.byt "what is going on"
	.byt 0

.)



