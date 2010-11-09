;SimpleSimon.s - Simple Simon Engine

;The computer is activated on Ethan standing infront of the console and the player moving the joystick up.

;The Computer starts by playing 3 successive notes.
;Each note is random but duplicates must not exist. The range is 32 notes falling on the 32 chequerboard
;squares. Notes are displayed momentarily as crosses on the chequerboard.

;The player must then (by way of the controller) move a cursor(square) to each note that
;was played (highlighted with a cross starting at the first note and finished at the last)
;pressing fire to select each one.

;The player must select the notes that were played from lowest to highest.

;On success the chequerboard will animate and either one snooze or one lift reset will be awarded.
;The length of the sequence will be increased by one note(up to 16) and the
;computer will kick Ethan off the system.
;The awarded bonus will be displayed in the score panel. The system will also credit the player 500 points
;to his score.

;If at any point the player is unsuccessful the computer will kick Ethan off the system.

;Problem  How do we play a number of random notes, but remember their ascending order?
; Answer  We use a 32 byte table (which may use the start of the collision map) which is initialised
;	with 128's.
;On playing
;	We play random notes (0-31) and store the sequence index in the table indexed by the note.
;On checking
;	We locate the note selected in the table and check the table index matches the sequence index.

SimonEngine
	;First off display ethan searching and wipe/reset game start variables and tables...
	
	;Make Ethan stand searching
	lda #ETHAN_STANDING
	sta EthanFrame

	jsr DeleteEthan
	lda #ETHAN_SEARCHING
	sta EthanFrame
	
	;Tie ethan to the current level
	jsr TieEthan2Platform
	
	jsr PlotEthan

	;Initialise NoteTable
	ldx #32
	lda #128
.(
loop1	sta svNoteTable-1,x
	dex
	bne loop1
.)	
	;Play the note sequence
	stx svNoteSequenceIndex
	stx svCursorX
	stx svCursorY
.(	
loop1	;Create random note ensuring..
	;- it doesn't match any note already played
	jsr GetRandomNumber
	and #31
	
	sta svTempNote
	;Check it doesn't match existing notes in sequence
	;Which infact can use rule2
	ldx #00
loop2	lda svNoteTable,x
	bmi skip1
	cmp svTempNote
	beq loop1
	inx
	bpl loop2
	
skip1	;Store note in table
	ldx svNoteSequenceIndex
	lda svTempNote
	sta svNoteTable,x
	sta svTempNote
	
	;Display Note
	jsr smDisplayNote
	
	;Sound Note
	lda svTempNote
	jsr smNote2Pitch
	lda #SFX_SCSCALE
	jsr KickSFX
	
	;Wait a while (depends on difficulty)
	lda #7
	sec
	sbc GameDifficulty	;0-2(Hard)
	asl
	asl
	asl
	jsr SlowDown
	
	;Remove note
	jsr smDeleteNote
	
	;Proceed to next note in sequence
	inc svNoteSequenceIndex
	lda svNoteSequenceIndex
	cmp svUltimateCount
	bcc loop1
.)
          ;Now bubble sort svNoteTable
.(
loop2	ldx #00
loop1	lda svNoteTable+1,x
          bmi EndOfList
          cmp svNoteTable,x
          bcs skip1
          ldy svNoteTable,x
          sta svNoteTable,x
          sty svNoteTable+1,x
          bcc loop2	;effectively jmp since carry will always be clear
skip1	inx
          bcs loop1	;effectively jmp since carry will always be set

EndOfList	;Now display cursor and allow Ethan to nav
.)
	ldx #ROOMTEXT_SIMONENTER
	jsr DisplayRoomText

	lda #00
	sta svNoteSequenceIndex
.(
loop4	;Display Cursor
	ldx svCursorX
	ldy svCursorY
	lda #OBJ_SIMONBLACKCURSOR
	jsr smCalculateObjectElements
	jsr DisplayGraphicObject
	
loop1	jsr WaitOnKey_NoRepeat
	
	;Delete cursor
	pha
	ldx svCursorX
	ldy svCursorY
	lda #OBJ_SIMONBLACKCELL
	jsr smCalculateObjectElements
	jsr DisplayGraphicObject
	pla

	;Valid keys are LRUDF
	ldx #4
loop3	cmp svValidKey,x
	beq skip1
	dex
	bpl loop3
	jmp loop4
	
skip1	;Branch on key
	lda svKeyVectorLo,x
	sta vector1+1
	lda svKeyVectorHi,x
	sta vector1+2
vector1	jsr $dead
	
	;Loop
	bcc loop4
	
	;Award 1000 for each additional simon step
	lda #$10
	jsr AddHundredsScore

	jmp AnimateSimon
.)
	
svValidKey
 .byt CONTROLLER_LEFT
 .byt CONTROLLER_RIGHT
 .byt CONTROLLER_UP
 .byt CONTROLLER_DOWN
 .byt CONTROLLER_FIRE1

svKeyVectorLo
 .byt <smCursorLeft
 .byt <smCursorRight
 .byt <smCursorUp
 .byt <smCursorDown
 .byt <smCursorSelect
svKeyVectorHi
 .byt >smCursorLeft
 .byt >smCursorRight
 .byt >smCursorUp
 .byt >smCursorDown
 .byt >smCursorSelect




smCursorLeft
	lda svCursorX
.(
	beq skip1
	dec svCursorX
skip1	clc
.)
	rts

smCursorRight
	lda svCursorX
	cmp #7
.(
	bcs skip1
	inc svCursorX
skip1	clc
.)
	rts

smCursorUp
	lda svCursorY
.(
	beq skip1
	dec svCursorY
skip1	clc
.)
	rts

smCursorDown
	lda svCursorY
	cmp #3
.(
	bcs skip1
	inc svCursorY
skip1	clc
.)
	rts


;X==Xpos 0-7
;Y==Ypos 0-3
;A==Base Object (+1 for on)
;Work out chequerboard X,Y and Object V
smCalculateObjectElements
	;Calculate object first
.(
	sta vector1+1
	txa
	and #1
	sta vector2+1
	tya
	and #1
vector2	eor #00
	clc
vector1	adc #00
	sta Object_V
	
	;XPos=(Xx2)+12
	txa
	asl
	adc #12
	sta Object_X
	
	;YPos=(Yx12)+68
	tya
	asl
	asl
	sta vector3+1
	asl
vector3	adc #00
.)
	adc #68
	sta Object_Y
	rts
	
smCursorSelect
;	nop
;	jmp smCursorSelect
	;Display Cross
	ldx svCursorX
	ldy svCursorY
	lda #OBJ_SIMONBLACKCROSS
	jsr smCalculateObjectElements
	jsr DisplayGraphicObject
	
	;Sound note
	lda svCursorY
	asl
	asl
	asl
	ora svCursorX
	sta svTempNote
	jsr smNote2Pitch
	lda #SFX_SCSCALE
	jsr KickSFX

	;Wait a moment
	lda #5
	jsr SlowDown
	;Delete Cross
	ldx svCursorX
	ldy svCursorY
	lda #OBJ_SIMONBLACKCELL
	jsr smCalculateObjectElements
	jsr DisplayGraphicObject

	;Locate note in sequence
	ldx svNoteSequenceIndex
	lda svTempNote
	cmp svNoteTable,x
	bne WrongNoteSelected
	
	inc svNoteSequenceIndex
	lda svNoteTable+1,x
	bmi SequenceCorrect
	clc
	rts

WrongNoteSelected
	ldx #ROOMTEXT_SIMONFAILED
	jsr DisplayRoomText

	jsr ResetHiPitch

	;Sound negative
	lda #SFX_LOWBEEP
	jsr KickSFX
KickEthanOffComputer
	sec
	rts
	
ResetHiPitch
	;Zero BC pitch hi's
	lda #00
	sta ay_PitchHi+1
	sta ay_PitchHi+2
	rts

;On successfully getting the sequence right the chequerboard will animate and either one snooze or one
;lift reset will be awarded. The length of the sequence will be increased by one note(up to 16) and the
;computer will kick Ethan off the system.
;The awarded bonus will be displayed in the score panel. The system will also credit the player 500 points
;to his score.
SequenceCorrect
	ldx #ROOMTEXT_SIMONSUCCESS
	jsr DisplayRoomText

	;Award bonus
	jsr GetRandomNumber
	and #1
.(
	beq CreditSnooze
CreditLReset
	lda LiftResets
	cmp #99
	bcs skip1
	inc LiftResets
	jsr Display_LiftResets
	jmp skip1
CreditSnooze
	lda RobotSnoozes	;0-99
	cmp #99
	bcs skip1
	inc RobotSnoozes
	jsr Display_RobotSnoozes
skip1	;Increase length of sequence
.)
	lda svUltimateCount
	cmp #15
.(
	bcs skip1
	inc svUltimateCount
	
skip1	jsr ResetHiPitch
.)
	;Sound positive
	lda #SFX_HIGHBEEP
	jsr KickSFX

	jmp KickEthanOffComputer
	
smNote2Pitch
	;Perform note 2 pitch conversion of x note (B0-2) and y octave(B3-4)
	pha
	and #7
	tay
	lda BasePitchLo,y
	sta svTemp01
	lda BasePitchHi,y
	tay
	pla
	lsr
	lsr
	lsr
.(
	beq skip1
	tax
loop1	tya
	lsr
	tay
	ror svTemp01
	dex
	bne loop1
skip1	lda svTemp01
.)
	;Now store
	sta ay_PitchLo+1
	clc
	adc #1
	sta ay_PitchLo+2
	tya
	sta ay_PitchHi+1
	adc #00
	sta ay_PitchHi+2
	rts

smDisplayNote
	pha
	;extract row (/8)
	lsr
	lsr
	lsr
	
	;convert 0-3 to chequerboard ypos
	tay
	
	;Fetch note
	pla
	
	;extract column (and 7)
	and #7
	tax
	lda #OBJ_SIMONBLACKCROSS
	jsr smCalculateObjectElements	
	jmp DisplayGraphicObject
	
smDeleteNote
	;Fetch note
	lda svTempNote

	;extract row (/8)
	lsr
	lsr
	lsr
	
	;convert 0-3 to chequerboard ypos
	tay
	
	;Fetch note
	lda svTempNote
	
	;extract column (and 7)
	and #7
	tax
	lda #OBJ_SIMONBLACKCELL
	jsr smCalculateObjectElements	
	jmp DisplayGraphicObject

;Run when logging off simon with successful sequence
;Invert chequerboard 8 times
;Cells are either $40 or $C0 so EOR row with $80
AnimateSimon
	lda #8
	sta CycleCount
.(
loop4	lda #<$A000+12+68*40
	sta screen
	lda #>$A000+12+68*40
	sta screen+1
	
	ldx #48
loop2	ldy #15
loop1	lda (screen),y
	eor #$80
	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	dex
	bne loop2
	
	;Use unused Droid Delay to control speed of each frame
	lda #5
	jsr SlowDown

	dec CycleCount
	bne loop4
.)
	;Silence sfx
	jmp SilenceSFX
