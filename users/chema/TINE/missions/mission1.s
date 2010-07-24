
;; Mission 1. Transportation of concealed illegal cargo from Xexedi (250) to Teen (209)


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

#define CARGO_AMOUNT 15

#define NEXTMISSION_LEGAL 28

tab_sumlo
	.byt <str_Summary1,<str_Summary
tab_sumhi
	.byt >str_Summary1,>str_Summary
tab_cargo
	.byt 0,CARGO_AMOUNT,0,0

InitMission
.(
	lda _mission
	and #%11
	tax
	ldy tab_cargo,x
	sty MissionCargo
	lsr
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
	cmp #THISMISSION+2
	bne firststart

	; If it is 2, then mission has been launched.
	; check if at origin
	lda _galaxynum
	cmp #1
	bne nolaunch
	lda _currentplanet
	cmp #250 ;Xexedi
	bne nolaunch

	; We are at origin, therefor load cargo
	; if enough space, else hit a problem

	lda _holdspace
	cmp #CARGO_AMOUNT
	bcs doit
	; No cargo left!
	lda #<str_MissionProblem
	sta TXTPTRLO
	lda #>str_MissionProblem
	sta TXTPTRHI

	sec
	rts

doit
	lda #CARGO_AMOUNT
	;ldx #3
	clc
	adc _shipshold	;,x
	sta _shipshold	;,x
	lda _holdspace
	sec
	sbc #CARGO_AMOUNT
	sta _holdspace

	; Loaded, set MissionCargo to 0 and increment state to 3
	lda #0
	sta MissionCargo

	inc _mission

	; Issue the alert message from the police
	lda #<str_CargoRevealed
	sta TXTPTRLO
	lda #>str_CargoRevealed
	sta TXTPTRHI
end
	sec
	rts


firststart
	;It was not at state 2... maybe not launched yet? (that is state 0)
	cmp #THISMISSION
	beq launch	

	; No, it wasnot, so either state 1 or 3. Nothing to be done
	; so just return
nolaunch
	clc
	rts

launch
	; Ok, we are about to launch mission here.
	; Check preconditions

	lda _score+1
	bne prec
	lda _score
	cmp #$16
	bcc nolaunch
prec
	; Launch mission, increment state to 1
	inc _mission

	; Prepare brief message
	lda #<str_MissionBrief
	sta TXTPTRLO
	lda #>str_MissionBrief
	sta TXTPTRHI

	; Setup MissionCargo variable
	lda #CARGO_AMOUNT
	sta MissionCargo

	; Return with message to be printed
	sec
	rts
.)


PlayerDock
.(
	; What needs to be done when player docks?
	; If mission is at state 1
	lda _mission
	cmp #THISMISSION+1
	bne finished

	; Check if we have arrived at origin, then issue
	; second brief, clarifiying what cargo needs to be
	; transported and where.
	lda _galaxynum
	cmp #1
	bne notlaunched
	lda _currentplanet
	cmp #250 ;Xexedi
	bne notlaunched

	; Increment mission state to 2
	inc _mission

	; Second briefing
	lda #<str_MissionBrief2
	sta TXTPTRLO
	lda #>str_MissionBrief2
	sta TXTPTRHI

	; Change summary which prints on status page
	lda #<str_Summary
	sta MissionSummary
	lda #>str_Summary
	sta MissionSummary+1

	; Return with a message to be printed
	sec
	rts


finished
	; Check if state is 3, then we need to see if
	; we have successfuly transported the goods to
	; destination.

	cmp #THISMISSION+3
	beq checksuccess

	; Not even launched
	; Just return
notlaunched
	clc
	rts
	
checksuccess
	lda _galaxynum
	cmp #1
	bne notlaunched
	lda _currentplanet
	cmp #209 ;Teen
	bne legalway

	; Remove cargo
	; Do we have it?
	;ldx #3
	lda _shipshold ;,x
	cmp #CARGO_AMOUNT 
	bcs okcargo

	; Uh, oh... we don't have the cargo
	lda #NEXTMISSIONFAIL
	sta _mission
	lda #<str_MissionFailed
	sta TXTPTRLO
	lda #>str_MissionFailed
	sta TXTPTRHI
	sec
	rts

okcargo
	; Remove cargo from ship
	sec
	sbc #CARGO_AMOUNT
	sta _shipshold   ;,x
	clc
	lda #CARGO_AMOUNT
	adc _holdspace
	sta _holdspace

	; Pay the player
	lda #<5000
	clc
	adc _cash
	sta _cash
	lda #>5000
	adc _cash+1
	sta _cash+1
	bcc nomore
	inc _cash+2
	bne nomore
	inc _cash+3
nomore	

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

legalway
	; Check if player acted the legal way
	;lda _galaxynum
	;cmp #1
	;bne notlaunched
	;lda _currentplanet
	cmp #109 ;Usatqura
	bne notlaunched

	; Remove cargo
	; Do we have it?
	;ldx #3
	lda _shipshold ;,x
	cmp #CARGO_AMOUNT 
	bcs okcargo2

	clc
	rts

okcargo2
	; Remove cargo from ship
	sec
	sbc #CARGO_AMOUNT
	sta _shipshold   ;,x
	clc
	lda #CARGO_AMOUNT
	adc _holdspace
	sta _holdspace

	; Pay the player
	lda #<3000
	clc
	adc _cash
	sta _cash
	lda #>3000
	adc _cash+1
	sta _cash+1
	bcc nomore2
	inc _cash+2
	bne nomore2
	inc _cash+3

nomore2
	; Clear legal status
	lda #0
	sta _legal_status
	
	; Set next mission
	lda #NEXTMISSION_LEGAL
	sta _mission

	; Prepare debriefing
	lda #<str_MissionDebrief2
	sta TXTPTRLO
	lda #>str_MissionDebrief2
	sta TXTPTRHI

	; Flag that we need to load mission from disk
	dec NeedsDiskLoad

	; Return with message to be printed.
	sec
	rts
	
.)


str_MissionBrief
	.asc "Greetings Commander."
	.byt 13
	.asc "This is Milto Zaxx again and I have a"
	.byt 13
	.asc "another bussiness of your interest."
	.byt 13
	.asc "Come to Xexedi for a transport."
	.byt 0

str_MissionBrief2
	.asc "Welcome to Xexedi, Commander."
	.byt 13
	.asc "Transport 15 tons of food to Teen."
	.byt 13
	.asc "Be sure to have such space free before"
	.byt 13
	.asc "leaving. You will be paid 500 Cr."
	.byt 0

str_MissionDebrief
	.asc "Good job. I have sent the credits."
	.byt 13
	.asc "I see you like risky bussiness."
	.byt 13
	.asc "I will contact you again soon..."
	.byt 0

str_MissionProblem
	.asc "You didn't have enough space for" 
	.byt 13
	.asc "our cargo!"
	.byt 13
	.byt 13
	.asc "Get back to Xexedi inmediately!"
	.byt 0

str_MissionFailed
	.asc "What did you do with my cargo?"
	.byt 13
	.asc "I'll make sure nobody else hires you!"
	.byt 0


str_CargoRevealed
	.asc "ATTENTION Message from GalCop Police."
	.byt 13
	.asc "We have heard that a smuggler called"
	.byt 13
	.asc "Milto Zaxx has concealed illegal"
	.byt 13
	.asc "cargo as food in one ship leaving"
	.byt 13
	.asc "this system. If you suspect you are"
	.byt 13
	.asc "transporting this, come inmediately"
	.byt 13
	.asc "to Usatqura for interrogation."
	.byt 0

str_MissionDebrief2
	.asc "Thanks commander."
	.byt 13
	.asc "For your help to the GalCop police,"
	.byt 13
	.asc "your legal status has been cleared"
	.byt 13
	.asc "and a reward of 300 Cr has been sent."
	.byt 0


str_Summary1
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Go to Xexedi for a transport."
	.byt 13
	.byt 0

str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Transport food to Teen."
	.byt 13
	.byt 0

.)


