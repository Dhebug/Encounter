
;; Mission 9. Carry plans to Rianxe (154), avoiding getting killed by Thargoid


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
    clc
	rts
	.byt 00
OnNewEncounter
	jmp ThargoidEncounter


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


CheckSuccess
.(
	lda _galaxynum
	cmp #4 
	bne notarrived

	lda _currentplanet
	cmp #154
	bne notarrived

	lda #NEXTMISSION
	sta _mission

	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	dec NeedsDiskLoad
	sec
	rts
notarrived
	clc
	rts
.)

POS1
	.word -4000
	.word -4000
	.word -9000
POS2
	.word 4000
	.word -4000
	.word -9000
POS3
	.word 4000
	.word 4000
	.word -9000
POS4
	.word -4000
	.word 4000
	.word -9000

pos_tablo 
	.byt <POS1,<POS2,<POS3,<POS4
pos_tabhi 
	.byt >POS1,>POS2,>POS3,>POS4


ThargoidEncounter
.(
	jsr IndRnd
	cmp #200
	bcs doit
	rts
doit
	jsr IndRnd
	and #%11
	tay
	lda pos_tabhi,y
	tax
	lda pos_tablo,y

    sta tmp0
	stx tmp0+1

    lda #(SHIP_THARGOID)
    jsr IndAddSpaceObject
	cpx #0
	beq end

	lda #$81
	sta _target,x

	lda #(HAS_ECM)
	jsr IndSetShipEquip

	lda #(IS_AICONTROLED|FLG_PIRATE)
	sta _ai_state,x

	; Should add missiles (tharglets) here. Maybe depending on environment stats.

	lda _missiles,x
	and #%11111000
	sta _missiles,x

	stx savx+1
	jsr IndRnd
	and #%1
	clc
	adc #1
savx
	ldx #0 ;SMC
	ora _missiles,x
	sta _missiles,x

end
	clc
	rts
.)



str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Go to Naval Intel centre at"
	.byt 13
	.byt 2 
	.asc "Rianxe and ask for Admiral Curruthers."
	.byt 0



str_MissionDebrief
	.asc "My name is Admiral Curruthers." 
	.byt 13
	.asc "I want to thank you for your"
	.byt 13
	.asc "invaluable help. The technical data"
	.byt 13
	.asc "you have brought will allow us to"
	.byt 13
	.asc "reinforce the defences of the" 
	.byt 13
	.asc "Galactic Co-operative of Worlds"
	.byt 13
	.asc "against further Thargoid attacks."
	.byt 11
	.asc "My first priority now will be"
	.byt 13
	.asc "seeking the traitor who leaked this"
	.byt 13
	.asc "information to the beetles."
	.byt 13
	.asc "And I assure you that I will order"
	.byt 13
	.asc "the inmediate arrest, dead or alive,"
	.byt 13
	.asc "of Torjan Mino. He won't escape the"
	.byt 13
	.asc "Naval Security forces."
	.byt 13
	.asc "I will let you know as soon as I have"
	.byt 13
	.asc "news about this matter. Stay in this"
	.byt 13
	.asc "galaxy. You saved millions of lives."
	.byt 0
.)

