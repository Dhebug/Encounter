
;; Mission 6. Meeting Hasler at Riave.


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
	jmp MeetHasler2
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
	jmp MeetHasler1
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


MeetHasler1
.(
	lda _mission
	cmp #THISMISSION+1
	bne nolaunch

	lda _galaxynum
	cmp #3 
	bne nolaunch

	lda _currentplanet
	; 0 is Riave
	bne nolaunch

	inc _mission

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

MeetHasler2
.(
 	lda _mission
	cmp #THISMISSION+2
	bne nolaunch

	lda _galaxynum
	cmp #3 
	bne nolaunch

	lda _currentplanet
	; 0 is Riave
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




str_MissionBrief
	.asc "So you are asking for Hasler..."
	.byt 13
	.asc "Untha has told us about the"
	.byt 13
	.asc "matter. Land and I'll arrange"
	.byt 13
	.asc "a meeting."
	.byt 0


str_MissionDebrief
	.asc "Trojan is scum. He makes"
	.byt 13
	.asc "bussiness with the Thargoids."
	.byt 13
	.asc "He wants you terminated."
	.byt 13
	.asc "I will find out more, but quid"
	.byt 13
	.asc "pro quo; do something for me." 
	.byt 13
	.asc "I need you to pick up a lost"
	.byt 13
	.asc "cannister at Rebees. I will"
	.byt 13
	.asc "give you more instructions when"
	.byt 13
	.asc "you arrive there.
	.byt 0

str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.byt "Go to Riave (gal. 3) to meet"
	.byt 13
	.byt 2
	.byt "Garmond Hasler"
	.byt 0

.)



