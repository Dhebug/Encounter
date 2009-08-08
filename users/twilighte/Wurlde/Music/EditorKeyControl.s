;EditorKeyControl.s
;


EditorControl
.(
loop3	;Perform PreProcess Routine (Like Display Cursor)
	ldx CurrentEditor
	lda PreProcessVectorLo,x
	sta vector4+1
	lda PreProcessVectorHi,x
	beq skip2
	sta vector4+2
vector4	jsr $dead

	; Wait for Hard KeyPress
skip2	jsr Wait4Key

	; Fetch Editor Key Tables
	ldx CurrentEditor
	lda EditorHardKeyTableLo,x
	sta source
	lda EditorHardKeyTableHi,x
	sta source+1
	lda EditorSoftKeyTableLo,x
	sta source2
	lda EditorSoftKeyTableHi,x
	sta source2+1
	
	; Is Soft&Hard Key Recognised?
	ldy EditorsUltimateKey,x
loop1	lda HardKeyRegister
	cmp (source),y
	bne skip3
	lda SoftKeyRegister
	cmp (source2),y
	beq skip1
skip3	dey
	bpl loop1
	jmp skip2

skip1	sty Temp01
	; Fetch Key Routine vector
	lda EditorKeyVectorLoTableLo,x
	sta source
	lda EditorKeyVectorLoTableHi,x
	sta source+1
	lda (source),y
	sta vector1+1
	
	lda EditorKeyVectorHiTableLo,x
	sta source
	lda EditorKeyVectorHiTableHi,x
	sta source+1
	lda (source),y
	sta vector1+2
	
	;Reserve Y (Used to index command in SFX and possibly note in Pattern sometime)
	sty vector5+1
	
	;Perform IntermediateProcess (Like fetching cursor byte entries in editor)
	lda IntProcessVectorLo,x
	sta vector3+1
	lda IntProcessVectorHi,x
	beq skip5
	sta vector3+2
vector3	jsr $dead
	
	; SFX Editor Should stop music/sfx if a key over row 12(in key data) is pressed
	ldx CurrentEditor
	cpx #3
	bne skip5
	lda Temp01
	cmp #12
	bcc skip5
	;Disable Music
	lda #00
	sta prGlobalProperty
	;Disable SFX
	sta prActiveTracks_SFX
	
	; Call Key routine
skip5	lda HardKeyRegister
vector5	ldx #00
	clc
vector1	jsr $dead

	; After Processing a key, reset KeyRegisters
	lda #00
	sta HardKeyRegister
	sta SoftKeyRegister

	; Perform PostProcess (Like display editor)
	ldx CurrentEditor
	lda ProProcessVectorLo,x
	sta vector2+1
	lda ProProcessVectorHi,x
	beq skip4
	sta vector2+2
vector2	jsr $dead

skip4	; Loop
	jmp loop3
.)



;Key
;Control+Key
;Shift+Key
;Function+Key

Wait4Key
	;Update PlayMonitor
	jsr PlayMonitor

	lda HardKeyRegister
	beq Wait4Key
	rts

