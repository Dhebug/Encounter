
;; Mission 10. Follow Constrictor trail!


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
    jmp LaunchMission
OnPlayerHyper
    clc
	rts
	.byt 00
OnExplodeShip
    jmp CheckSuccess
OnDockedShip
    clc
	rts
	.byt 00
OnHyperShip
	clc
	rts
	.byt 00
OnEnteringSystem
    jmp CheckConstrictor
OnNewEncounter
	jmp SuccessMsg

// OnScoopObject return with carry =1 if it has handled the scooping, so the main program
// avoids doing so.

OnScoopObject		
	clc
	rts
	.byt 00

// OnGameLoaded, called whenever the game has been loaded from disk, for initializing things...
OnGameLoaded
	jmp SetMissionText
	
// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word str_Summary
MissionCargo		.byt 0	; Cargo for this mission
AvoidOtherShips		.byt 0	; If not zero, no other ships are created

// Local variables
idConstrictor		.byt 0

CheckSuccess
.(
	lda _mission
	cmp #THISMISSION+2
	bne no
	cpx idConstrictor
	bne no
yes
	inc _mission	
+no
	clc
	rts
.)

POS1
	.word -4000
	.word 4000
	.word -4000


CheckConstrictor
.(

	lda _galaxynum
	cmp #5
	bne no

	lda _currentplanet
	cmp #111
	bne no

	lda #<POS1
	ldx #>POS1

    sta tmp0
	stx tmp0+1

    lda #(SHIP_CONSTRICTOR)
    jsr IndAddSpaceObject
	cpx #0
	beq end

	lda #$81
	sta _target,x

	lda #(HAS_ECM)
	jsr IndSetShipEquip

	lda #(IS_AICONTROLED|FLG_PIRATE|FLG_BOLD)
	sta _ai_state,x

	lda #FLG_HARD
	sta _flags,x

	; Should add missiles here
	lda #%10
	ora _missiles,x
	sta _missiles,x

	inc _mission
	stx idConstrictor
end
	clc
	rts
.)

str_rumlo4	.byt <str_Summary0,<str_Summary1,<str_Summary2
str_rumhi4	.byt >str_Summary0,>str_Summary1,>str_Summary2
str_rumlo5	.byt <str_Summary9,<str_Summary4,<str_Summary5,<str_Summary6,<str_Summary7,<str_Summary8
str_rumhi5	.byt >str_Summary9,>str_Summary4,>str_Summary5,>str_Summary6,>str_Summary7,>str_Summary8
pnum4		.byt 114,13,29
pnum5		.byt 29,18,186,222,183,111

SetMissionText
.(
	lda _galaxynum
	cmp #4
	bne gal5
.(
  	ldx #2
	lda _currentplanet
loop
	cmp pnum4,x
	beq found
	dex
	bpl loop
	clc
	rts
found
	lda str_rumlo4,x
	sta MissionSummary
	lda str_rumhi4,x
	sta MissionSummary+1
	clc
	rts
.)
gal5
.(
   	ldx #5
	lda _currentplanet
loop
	cmp pnum5,x
	beq found
	dex
	bpl loop
	; Not found
	jmp hint
found
	lda str_rumlo5,x
	sta MissionSummary
	lda str_rumhi5,x
	sta MissionSummary+1
	clc
	rts
.)

.)

hint
.(
    jsr IndRnd
    cmp #20
    bcs dontdoit
doit
	lda #<str_Summary3
	sta MissionSummary
	lda #>str_Summary3
	sta MissionSummary+1
dontdoit
	clc
	rts
.)


LaunchMission
.(
	lda _mission
	; If state is zero, see if launch
	; If state is one just set the text for status screen
	; If state is three then sucess!
	cmp #THISMISSION
	beq dolaunch
	cmp #THISMISSION+3
	beq SuccessMsg	
	bcs nothing
	jmp SetMissionText
nothing
	clc
	rts
dolaunch
	; Launch randomly if not at Aingeon and in galaxy 4
	; Galaxy must be 4
	lda _galaxynum
	cmp #4
	bne nothing

	lda _currentplanet
	cmp #114
	beq nothing

	jsr IndRnd
	cmp #50
	bcs nothing

	; Launch
	inc _mission

	; Prepare brief message
	lda #<str_MissionBrief
	sta TXTPTRLO
	lda #>str_MissionBrief
	sta TXTPTRHI
	sec
	rts
.)

SuccessMsg
.(
	lda _mission
	cmp #THISMISSION+3
	beq doit
	clc
	rts
doit
	lda #NEXTMISSION
	sta _mission

	lda _score
	clc
	adc #$10
	sta _score
	bcc nocarry
	inc _score+1
nocarry

	lda _equip+1
	ora #EQ_EXTRAFUEL
	sta _equip+1

  	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	dec NeedsDiskLoad
	sec
	rts
.)



str_MissionBrief 
	.asc "Greetings Commander, I am Admiral
	.byt 13
	.asc "Curruthers again. We found the"
	.byt 13
	.asc "traitor. He was the intel liaison"
	.byt 13
#ifdef 0
	.asc "with Zantor's group. We have"
	.byt 13
	.asc "examined the computer logs and"
	.byt 13
	.asc "security data, and have enough"
	.byt 13
	.asc "evidence against him. But he fled"
	.byt 13
#else
	.asc "with Zantor's group, but he fled"
	.byt 13
#endif
	.asc "away before we could capture him."
	.byt 11
	.asc "He stole a prorotype for a new"
	.byt 13
	.asc "ship, the Constrictor, from our"
	.byt 13
	.asc "ship yard in Aingeon. Seek and"
	.byt 13
	.asc "destroy this ship. You are cautioned"
	.byt 13
	.asc "that only Military Lasers will get"
	.byt 13
	.asc "through its experimental shields."
	.byt 13
	.asc "Good luck."
	.byt 0

str_MissionDebrief 
	.asc "There will always be a place for you"
	.byt 13
	.asc "in Her Majesty's Space Navy."
	.byt 13
	.byt 13
;	.asc "And maybe sooner than you think..."
;	.byt 13
	.asc "Accept this fuel optimizer unit"
	.byt 13
	.asc "as a present."
	.byt 0


str_Summary0
	.byt 2
	.asc "The Constrictor was last seen at"
	.byt 13
	.byt 2
	.asc "Mavelege, commander."
	.byt 0

str_Summary1
	.byt 2
	.asc "A strange looking ship left here a"
	.byt 13
	.byt 2
	.asc "while back. Looked bound for Veteerza."
	.byt 0

str_Summary2
	.byt 2
	.asc "Yep, an unusual new ship just"
	.byt 13
	.byt 2
	.asc "jumped to galaxy 5."
	.byt 0


str_Summary3
	.byt 2
	.asc "I hear a weird looking ship was"
	.byt 13
	.byt 2
	.asc "seen at Intedi."
	.byt 0

str_Summary4
	.byt 2
	.asc "This strange ship dehyped here and"
	.byt 13
	.byt 2
	.asc "jumped again. I heard it went to"
	.byt 13
	.byt 2
	.asc "Rainte."
	.byt 0

str_Summary5
	.byt 2
	.asc "Rogue ship went for me at Veedri."
	.byt 13
	.byt 2
	.asc "My lasers didn't even scratch"
	.byt 13
	.byt 2
	.asc "its hull..."
	.byt 0

str_Summary6
	.byt 2
	.asc "Oh dear me yes. A frightful rogue"
	.byt 13
	.byt 2
	.asc "shot lots of those beastly pirates"
	.byt 13
	.byt 2
	.asc "and went to Rabeer."
	.byt 0

str_Summary7
	.byt 2
	.asc "You can tackle the vicious scoundrel"
	.byt 13
	.byt 2
	.asc "if you like. He's at Beatza."
	.byt 0

str_Summary8
	.byt 2
	.asc "There's a real deadly pirate"
	.byt 13
	.byt 2
	.asc "out there!"
	.byt 0

str_Summary9
	.byt 2
	.asc "The ship entered this galaxy here."
	.byt 0


str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Go to Naval yard at Aingeon and"
	.byt 13
	.byt 2 
	.asc "pursue the Constrictor."
	.byt 0
.)


