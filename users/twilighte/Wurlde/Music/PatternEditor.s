;PatternEditor.s


peNavTrackLeft
	lda #00
	sta peHighlightActive
	lda #4
	sta peNavStep
peNavLeftRent
.(
loop1	lda PatternCursorX
	sec
	sbc peNavStep
	and #31
	sta PatternCursorX
	tay
	lsr
	lsr
	tax
	lda TrackProperty,x
	bpl loop1
.)
	sty PatternCursorX
	rts

peNavLeft
	lda #00
	sta peHighlightActive
	lda #1
	sta peNavStep
	jmp peNavLeftRent

peNavTrackRight
	lda #00
	sta peHighlightActive
	lda #4
	sta peNavStep
peNavRightRent
.(
loop1	lda PatternCursorX
	clc
	adc peNavStep
	and #31
	sta PatternCursorX
	tay
	lsr
	lsr
	tax
	lda TrackProperty,x
	bpl loop1
.)
	sty PatternCursorX
	rts

peNavRight
	lda #00
	sta peHighlightActive
	lda #1
	sta peNavStep
	jmp peNavRightRent

peNavUp
	lda #00
	sta peHighlightActive
	lda PatternCursorRow
	sec
	sbc #1
	and #63
	sta PatternCursorRow
	rts
	
peNavDown
	lda #00
	sta peHighlightActive
	lda PatternCursorRow
	clc
	adc #1
	and #63
	sta PatternCursorRow
	rts
	
peNavPU	;Changed to Page Up
	lda #00
	sta peHighlightActive
	lda PatternCursorRow
	sec
	sbc #16
.(
	bcs skip1
	lda #00
skip1	sta PatternCursorRow
.)
	rts
	
	
peNavPD	;Changed to Page Down
	lda #00
	sta peHighlightActive
	lda PatternCursorRow
	clc
	adc #16
	cmp #64
.(
	bcc skip1
	lda #63
skip1	sta PatternCursorRow
.)
	rts

peToggleBlue
	lda peBlueRow
	eor #128
	sta peBlueRow
	rts
	

	

 
	

peOctave
;	sei
;	jmp peOctave
	;Parsed in A is the Note in the form of letters A thru G
	ldx PatternEntryType
	;If entry is Track Rest then abort
.(
	beq Failed
	;If Entry is Command then abort
	cpx #5
	beq Failed
	;If Entry is Rest, VRST or Bar then set default entry
	cpx #2
	bcs DefaultEntry

	;Reduce Keys 48 thru 57 to values 0-9
rent1	sec
	sbc #48
	tay
	
	;Perform comparison between entered octave and current octave
	lda PatternEntryLongNote	;This is independant of list offset
	
	cpy PatternEntryOctave	;This includes list offset
	beq Success
	bcc sub
	
	;Move current octave up to Selected octave
	sty loop1+1
	ldy PatternEntryOctave
loop1	cpy #00	;This includes list offset
	beq Success
	iny
	clc
	adc #12
	cmp #61
	bcc loop1
	rts	;Failed
	
sub	;Move current octave down to selected octave
	sty loop2+1
	ldy PatternEntryOctave
loop2	cpy #00	;This includes list offset
	beq Success
	
	dey
	sec
	sbc #12
	bcs loop2
Failed	rts	;Failed

DefaultEntry
	;We must permit specific Octave selection on rest entry
	;1) Backup selected octave
	pha
	;2) Write intermidiate Note value of C-0
	lda #00
	sta PatternEntrySFX
	sta PatternEntryLongNote
	lda #15
	sta PatternEntryVolume
	jsr peStorePatternLongNote
	;3) Fetch back
	jsr peFetchEntryData
	;4) Restore entered octave
	pla
	;5) Jump back to main
	jmp rent1

Success	sta PatternEntryLongNote
.)
	jmp peStorePatternLongNote


peNote	;The calculation of note is hindered by any Note Offset on the track
	;which directly effects the displayed note. So we must perform some
	;special code to ensure the desired Note is attainable in the current
	;octave otherwise abort.

	;Parsed in A is the Note in the form of letters A thru G
	ldx PatternEntryType
	;If entry is Track Rest then abort
.(
	beq Failed
	;If Entry is Command then abort
	cpx #5
	beq Failed
	;If Entry is Rest, VRST or Bar then set default entry
	cpx #2
	bcs DefaultEntry

rent1	;Convert Typed ABCDEFG(0-6) to Note 0-11(Ignore current Sharp)
	tay
	lda peActualNote-65,y
	sta EnteredNote
		
	;Take the Pattern entry up to B-X(or 60) by observing
	;calculated ShortNote
	ldx PatternEntryLongNote
	ldy PatternEntryNote
	cpy EnteredNote
	beq NoChange
loop1	cpy #11
	bcs BXreached
	iny
	inx
	cpx #61
	bcc loop1
BXreached
	;Then bring Pattern entry down to Typed Note. If Pattern
	;Entry <0 then Fail
loop2	cpy EnteredNote
	beq Success
	dey
	dex
	bpl loop2
	jmp Failed
DefaultEntry
	;We must permit specific Note selection on rest entry
	;1) Backup selected note
	pha
	;2) Write intermidiate Note value of C-0
	lda #00
	sta PatternEntrySFX
	sta PatternEntryLongNote
	lda #15
	sta PatternEntryVolume
	jsr peStorePatternLongNote
	;3) Fetch back
	jsr peFetchEntryData
	;4) Restore entered octave
	pla
	;5) Jump back to main
	jmp rent1
Success	stx PatternEntryLongNote
	jmp peStorePatternLongNote
Failed
NoChange	rts
.)

;The Pattern Entry is composed of 
; Note/Rest/VRest/Bar/Command, Octave, Sharp, Volume and SFX, all within two bytes.
;It is extracted here from the two bytes into..
; PatternEntryType
;   0 Entry Inactive (Pattern Inactive)
;   1 Entry is a Note
;   2 Entry is a Rest
;   3 Entry is a VRest
;   4 Entry is a Bar
;   5 Entry is a Command
;					Store Back with..
; PatternEntryByte0				peStorePatternData
; PatternEntryByte1
;
; PatternEntryNote(Which includes Bar and Rest)	peStorePatternNote
; PatternEntrySharp
; PatternEntryOctave
;
; PatternEntryVolume			peStorePatternLongNote
; PatternEntrySFX
; PatternEntryLongNote
;
;These only apply to Track H if command has been applied
; PatternEntryCommand			peStorePatternCommand
; PatternEntryParam1
; PatternEntryParam2
;
peFetchEntryData
	;Calculate Address of Pattern Entry
	lda PatternCursorX
	lsr
	lsr
	tax
	;Branch if Track inactive
	lda TrackProperty,x
.(
	bpl PatternInactive

	lda PatternCursorRow
	jsr CalcPatternAddress
	
	; Extract bytes 0 & 1
	ldy #00
	lda (source),y
	sta PatternEntryLongNote
	sta PatternEntryByte0
	iny
	lda (source),y
	sta PatternEntrySFX
	sta PatternEntryByte1
	
	
	;Branch if Track H is command
	lda TrackProperty,x
	asl
	bmi PatternCommandEntry

	; Split into Note, SFX and Volume
	lda #00
	sta PatternEntryVolume
	lsr PatternEntryLongNote
	rol PatternEntryVolume
	lsr PatternEntryLongNote
	rol PatternEntryVolume
	lsr PatternEntrySFX
	rol PatternEntryVolume
	lsr PatternEntrySFX
	rol PatternEntryVolume
	
	; Branch if Rest, VRest or Bar
	lda PatternEntryLongNote
	cmp #61
	bcs BarRestVRest
	
	;Add List Note Offset
	adc tl_CurrentOctaveRange,x

	; Extract Note,Octave,Sharp
	ldx #255
	sec
loop1	inx
	sbc #12
	bcs loop1
	adc #12
	stx PatternEntryOctave
	tax
	lda Notes12ToNote,x
	sta PatternEntryNote
	lda Notes12ToSharp,x
	sta PatternEntrySharp
	
	;Set EntryType to 1
	lda #01
	sta PatternEntryType
	rts

PatternInactive
	;Set Entry Type to 0
	lda #0
	sta PatternEntryType
	rts

PatternCommandEntry
	;Extract Command
	lda PatternEntryByte0
	lsr
	lsr
	sta PatternEntryCommand

	; Extract Param2
	lda PatternEntryByte1
	sta PatternEntryParam2
	
	;Set Entry Type to 5
	lda #5
	sta PatternEntryType
	rts

BarRestVRest
	;Reduce 61-63 to 2-4 and store as EntryType
	sbc #59
	sta PatternEntryType
	
skip1	rts
.)

;Relies on (source) pointing to entry
peStorePatternData
	lda PatternEntryByte0
	ldy #00
	sta (source),y
	iny
	lda PatternEntryByte1
	sta (source),y
	rts
	
peStorePatternNote
	;Rebuild Long Note from Note,Sharp and Octave
	lda PatternEntryOctave
	asl
	asl
.(
	sta vector1+1
	asl
vector1	adc #00
.)
	;Add Note
	adc PatternEntryNote
	;Add Sharp
	adc PatternEntrySharp
	;Store as long note
	sta PatternEntryLongNote
peStorePatternLongNote
	;Based on..
	;A0   Volume B3
	;A1   Volume B2
	;A2-7 Note/Rst/VRST/Bar
	;B0   Volume B1
	;B1   Volume B0
	;B2-7 SFX
	lda PatternEntrySFX
	lsr PatternEntryVolume
	rol
	lsr PatternEntryVolume
	rol
	ldy #01
	sta (source),y
	lda PatternEntryLongNote
	lsr PatternEntryVolume
	rol
	lsr PatternEntryVolume
	rol
	dey
	sta (source),y
	rts

peStorePatternCommand
	;Provided with PatternEntryCommand & PatternEntryParam2
	lda PatternEntryCommand
	asl
	asl
peStorePatternCommandBytes
	ldy #00
	sta (source),y
	iny
	lda PatternEntryParam2
	sta (source),y
	rts

	

peIncrement
	;Depends on (PatternCursorX AND 3), PatternEntryType and highlight
	;If used during a highlight operation all notes in the highlighted area
	;will be incremented by volume up to the maximum volume.
	lda peHighlightActive
.(
	beq skip1
	ldx #00
	jmp ProcessExtendedHighlightOptions
skip1	;If EntryType is 0(Inactive)
.)
	;Ignore
	;If EntryType is 1(Note)
	;0 Increment Note by semitone
	;1 Increment Octave (0-4)
	;2 Increment Volume
	;3 Increment SFX
	;If EntryType is 2(Rest) or 4(Bar)
	;Ignore
	;If EntryType is 3(VRest)
	;0 Ignore
	;1 Ignore
	;2 Increment Volume
	;3 Ignore
	;If EntryType is 5(Command)
	;0 Ignore
	;1 Ignore
	;2 Depending on command Increment Param1
	;3 Depending on Command Increment Param2
	
	;Merge the two together to form a 23 Byte index to decide what to do
	lda PatternCursorX
	and #3
.(
	sta vector1+1
	lda PatternEntryType
	asl
	asl
vector1	ora #00
	tax
	lda IncrementWhatVectorHi,x
	beq skip1
	sta vector2+2
	lda IncrementWhatVectorLo,x
	sta vector2+1
	clc
vector2	jmp $dead
skip1	rts
.)

IncrementNote
	lda PatternEntryLongNote
	adc #1
	cmp #61
.(
	bcc skip1
	lda #00
skip1	sta PatternEntryLongNote
.)
	jmp peStorePatternLongNote

	
IncrementOctave
	lda PatternEntryOctave
	adc #1
	cmp #5
.(
	bcc skip1
	lda #00
skip1	sta PatternEntryOctave
.)
	jmp peStorePatternLongNote
	
IncrementVolume
	lda PatternEntryVolume
	adc #1
	cmp #16
.(
	bcc skip1
	lda #15
skip1	sta PatternEntryVolume
.)
	jmp peStorePatternLongNote

	
IncrementSFX
	lda PatternEntrySFX
	adc #1
	cmp #64
.(
	bcc skip1
	lda #63
skip1	sta PatternEntrySFX
.)
	jmp peStorePatternLongNote

IncrementParam1
	;Only permit if in range
	;we use ModifyParamFlag B6 to determine if we can mod but how to add?
	ldx PatternEntryCommand
	lda ModifyParamFlags,x
	and #BIT6
.(
	beq skip1
	lda NextHigherCommandRangeValue,x
	sta PatternEntryCommand
	jmp peStorePatternCommand
skip1	rts
.)

IncrementParam2
	;Depends on Command
	ldx PatternEntryCommand
	lda ModifyParamFlags,x
	and #BIT7
.(
	beq skip2
	inc PatternEntryParam2
	jmp peStorePatternCommand
skip2	rts
.)


IncrementWhatVectorLo
 .byt 0			;Inactive Channel
 .byt 0
 .byt 0
 .byt 0
 .byt <IncrementNote	;Note
 .byt <IncrementOctave
 .byt <IncrementVolume
 .byt <IncrementSFX
 .byt 0			;Rest
 .byt 0
 .byt 0
 .byt 0

 .byt 0			;VRest
 .byt 0
 .byt <IncrementVolume
 .byt 0

 .byt 0			;Bar
 .byt 0
 .byt 0
 .byt 0
 
 .byt 0			;Command
 .byt 0
 .byt <IncrementParam1
 .byt <IncrementParam2

IncrementWhatVectorHi
 .byt 0			;Inactive Channel
 .byt 0
 .byt 0
 .byt 0
 .byt >IncrementNote	;Note
 .byt >IncrementOctave
 .byt >IncrementVolume
 .byt >IncrementSFX
 .byt 0			;Rest
 .byt 0
 .byt 0
 .byt 0

 .byt 0			;VRest
 .byt 0
 .byt >IncrementVolume
 .byt 0

 .byt 0			;Bar
 .byt 0
 .byt 0
 .byt 0
 
 .byt 0			;Command
 .byt 0
 .byt >IncrementParam1
 .byt >IncrementParam2

;A strange rule here (to conserve bytes) is that if b6 set and b7 reset then assume
;param2 is track
ModifyParamFlags
 .dsb 16,BIT6
 .dsb 3,BIT7
 .dsb 16,BIT6
 .dsb 16,BIT6+BIT7
 .dsb 13,0

NextHigherCommandRangeValue
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0
 .byt 16,17,18
 .byt 20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,19
 .byt 36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,35
NextLowerCommandRangeValue
 .byt 15,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14
 .byt 16,17,18
 .byt 34,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33
 .byt 50,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49
	;00-15 Pitchbend		Rate	Track		00-15
	;16    Trigger Out		-	Value(0-63)	01
	;17    Trigger In		-	Value(0-63)	02
	;18    Note Tempo		-	Tempo(0-63)	03
	;19-34 EG Cycle		-	Cycle		04
	;35-50 EG Period		Hi	Lo		05
	;51-60 -                                                    06-60
	;61    Rest					----
	;62    Rest					62
	;63    Bar					----



InsertRowInHighlightedArea
	;Only permit if one row highlighted
	lda peHighlightRowStart
	cmp peHighlightRowEnd
.(
	bne skip1
	ldx #04
	jmp ProcessExtendedHighlightOptions
skip1	rts
.)

DeleteRowInHighlightedArea
	;Only permit if one row highlighted
	lda peHighlightRowStart
	cmp peHighlightRowEnd
.(
	bne skip1
	ldx #05
	jmp ProcessExtendedHighlightOptions
skip1	rts
.)
	
ProcessExtendedHighlightOptions
	lda ExtendedOptionActionLo,x
.(
	sta vector1+1
	lda ExtendedOptionActionHi,x
	sta vector1+2
	lda #00
	sta peTransferType

	ldx peHighlightTrackStart
loop2	ldy peHighlightRowStart
loop1	jsr peFetchHilightedEntry	;into cpyByte0/1
	jsr ExtractNoteVolumeSFX
vector1	jsr $dead
	iny
	cpy peHighlightRowEnd
	beq loop1
	bcc loop1
	inx
	cpx peHighlightTrackEnd
	beq loop2
	bcc loop2
.)
	rts

ExtractNoteVolumeSFX
	lda #00
	sta eoa_Volume
	lda cpyByte0
	lsr
	rol eoa_Volume
	lsr
	rol eoa_Volume
	sta eoa_Note
	lda cpyByte1
	lsr
	rol eoa_Volume
	lsr
	rol eoa_Volume
	sta eoa_SFX
	rts
	

eoa_IncrementVolume
	jsr eoa_VolumeCommonChecks
.(
	bcs skip1
	lda eoa_Volume
	cmp #15
	beq skip1
	inc eoa_Volume
	jsr StoreHilightedEntry
skip1	rts
.)

eoa_VolumeCommonChecks	;set carry if illegal
	;Don't mod if inactive track
	sec
	lda TrackProperty,x
.(
	bpl skip1
	;Don't mod if command channel H
	and #63
	cmp #63
	bcs skip1
	;only mod if note(0-60) or vrst(62)
	lda eoa_Note
	cmp #61
	beq skip1
	cmp #63
skip1	rts
.)
	
eoa_DecrementVolume
	jsr eoa_VolumeCommonChecks
.(
	bcs skip1
	lda eoa_Volume
	beq skip1
	dec eoa_Volume
	jsr StoreHilightedEntry
skip1	rts
.)

eoa_TransposeUp
	jsr eoa_VolumeCommonChecks
.(
	bcs skip1
	lda eoa_Note
	cmp #60
	bcs skip1
	inc eoa_Note
	jsr StoreHilightedEntry
skip1	rts
.)
	
eoa_TransposeDown
	jsr eoa_VolumeCommonChecks
.(
	bcs skip1
	lda eoa_Note
	beq skip1
	dec eoa_Note
	jsr StoreHilightedEntry
skip1	rts
.)

eoa_InsertRow
	;Temporarily change PatternCursorX to X*4 then call peInsertRent for each track.
	lda PatternCursorX
	sta eoa_Temp01
	stx eoa_Temp02
	sty eoa_Temp03
	txa
	asl
	asl
	sta PatternCursorX
	jsr peInsertRent
	lda eoa_Temp01
	sta PatternCursorX
	ldx eoa_Temp02
	ldy eoa_Temp03
	rts

eoa_DeleteRow
	;Temporarily change PatternCursorX to X*4 then call peDeleteRent for each track.
	lda PatternCursorX
	sta eoa_Temp01
	stx eoa_Temp02
	sty eoa_Temp03
	txa
	asl
	asl
	sta PatternCursorX
	jsr peDeleteRent
	lda eoa_Temp01
	sta PatternCursorX
	ldx eoa_Temp02
	ldy eoa_Temp03
	rts

eoa_Delete
	lda #61
	sta eoa_Note
	jmp StoreHilightedEntry

	
StoreHilightedEntry
	;
	lsr eoa_Volume
	rol eoa_SFX
	lsr eoa_Volume
	rol eoa_SFX
	lsr eoa_Volume
	rol eoa_Note
	lsr eoa_Volume
	rol eoa_Note
	;
	lda eoa_Note
	sty eoa_Volume	;Use volume as temp loc for y
	ldy #00
	sta (source),y
	iny
	lda eoa_SFX
	sta (source),y
	ldy eoa_Volume
	rts
	
;Pretty much opposite of increment	
peDecrement
	;Depends on (PatternCursorX AND 3), PatternEntryType and highlight
	;If used during a highlight operation all notes in the highlighted area
	;will be decremented by volume down to 0.
	lda peHighlightActive
.(
	beq skip1
	ldx #01
	jmp ProcessExtendedHighlightOptions
skip1	;Merge the two together to form a 23 Byte index to decide what to do
.)
	lda PatternCursorX
	and #3
.(
	sta vector1+1
	lda PatternEntryType
	asl
	asl
vector1	ora #00
	tax
	lda DecrementWhatVectorHi,x
	beq skip1
	sta vector2+2
	lda DecrementWhatVectorLo,x
	sta vector2+1
	sec
vector2	jsr $dead
skip1	rts
.)

DecrementNote
	lda PatternEntryLongNote
	sbc #1
.(
	bcs skip1
	lda #00
skip1	sta PatternEntryLongNote
.)
	jmp peStorePatternLongNote

	
DecrementOctave
	lda PatternEntryOctave
	sbc #1
.(
	bcs skip1
	lda #00
skip1	sta PatternEntryOctave
.)
	jmp peStorePatternLongNote
	
DecrementVolume
	lda PatternEntryVolume
	sec
	sbc #1
.(
	bcs skip1
	lda #00
skip1	sta PatternEntryVolume
.)
	jmp peStorePatternLongNote
	
DecrementSFX
	lda PatternEntrySFX
	sec
	sbc #1
.(
	bcs skip1
	lda #00
skip1	sta PatternEntrySFX
.)
	jmp peStorePatternLongNote

DecrementParam1
	;Only permit if in range
	;we use ModifyParamFlag B6 to determine if we can mod but how to add?
	ldx PatternEntryCommand
	lda ModifyParamFlags,x
	and #BIT6
.(
	beq skip1
	lda NextLowerCommandRangeValue,x
	sta PatternEntryCommand
	jmp peStorePatternCommand
skip1	rts
.)

DecrementParam2
	;Depends on Command
	ldx PatternEntryCommand
	lda ModifyParamFlags,x
	and #BIT7
.(
	beq skip2
	dec PatternEntryParam2
	jmp peStorePatternCommand
skip2	rts
.)


DecrementWhatVectorLo
 .byt 0			;Inactive Channel
 .byt 0
 .byt 0
 .byt 0
 .byt <DecrementNote	;Note
 .byt <DecrementOctave
 .byt <DecrementVolume
 .byt <DecrementSFX
 .byt 0			;Rest
 .byt 0
 .byt 0
 .byt 0

 .byt 0			;VRest
 .byt 0
 .byt <DecrementVolume
 .byt 0

 .byt 0			;Bar
 .byt 0
 .byt 0
 .byt 0
 
 .byt 0			;Command
 .byt 0
 .byt <DecrementParam1
 .byt <DecrementParam2

DecrementWhatVectorHi
 .byt 0			;Inactive Channel
 .byt 0
 .byt 0
 .byt 0
 .byt >DecrementNote	;Note
 .byt >DecrementOctave
 .byt >DecrementVolume
 .byt >DecrementSFX
 .byt 0			;Rest
 .byt 0
 .byt 0
 .byt 0

 .byt 0			;VRest
 .byt 0
 .byt >DecrementVolume
 .byt 0

 .byt 0			;Bar
 .byt 0
 .byt 0
 .byt 0
 
 .byt 0			;Command
 .byt 0
 .byt >DecrementParam1
 .byt >DecrementParam2
	rts

	
peReset	
	;If highlight active then becomes transpose down
	lda peHighlightActive
.(
	beq skip1
	ldx #06
	jmp ProcessExtendedHighlightOptions
skip1	
.)
	;Are we over Left two characters of Track?
	lda PatternCursorX
	and #3
	
	cmp #2
.(
	bcs OverParameters
	; Is this a Command Track?
	lda #244
	ldx PatternEntryType
	cpx #5
	beq CommandRest
	;Is this a note entry?
	cpx #1
	beq CommandRest
	; Is this a Rest entry?
	lda #62*4
	cpx #2
	beq CommandRest
	; Is this a VRest entry?
	lda #61*4
	cpx #3
	bne skip1
CommandRest
	sta PatternEntryByte0
	lda #00
	sta PatternEntryByte1
	jmp peStorePatternData
OverParameters
	;Is this a command entry?
	ldx PatternEntryType
	cpx #5
	beq ResetCommandParams
	;Is this a note?
	cpx #1
	bne skip1
ResetNoteParams
	tax
	lda #00
	sta PatternEntryVolume-2,x
	jmp peStorePatternLongNote
ResetCommandParams
	tax
	lda #00
	sta PatternEntryParam1-2,x
	jmp peStorePatternCommand
skip1	rts
.)	


peCopyLast
	lda PatternCursorRow
.(
	beq skip1
	dec PatternCursorRow
	jsr peFetchEntryData
	inc PatternCursorRow
	lda PatternCursorX
	lsr
	lsr
	tax
	lda PatternCursorRow
	jsr CalcPatternAddress
	jmp peStorePatternData
skip1	rts
.)
	
peCopyNext
	lda PatternCursorRow
	cmp #63
.(
	bcs skip1
	inc PatternCursorRow
	jsr peFetchEntryData
	dec PatternCursorRow
	lda PatternCursorX
	lsr
	lsr
	tax
	lda PatternCursorRow
	jsr CalcPatternAddress
	jmp peStorePatternData
skip1	rts
.)

;Grab acts in different ways, depending on the entry type
peGrab
	lda PatternEntryByte0
	sta GrabbedPatternEntry0
	lda PatternEntryByte1
	sta GrabbedPatternEntry1
	jmp peDisplayStatus
	
peDrop
	lda GrabbedPatternEntry0
	sta PatternEntryByte0
	lda GrabbedPatternEntry1
peDropRent1
	sta PatternEntryByte1
	jmp peStorePatternData

peContextualDrop
	;Contextual Drop depends on Entry Type
	; 0 Inactive - Abort
	; 1 Note	   - Drop only field value
	; 2 Rest     - Drop Entry
	; 3 VRest    - If over volume then drop volume else Drop Entry
	; 4 Bar      - Drop Entry
	; 5 Command  - Drop Entry
	lda PatternEntryType
	beq DecodeRent1
	cmp #4
	bcs peDrop
	cmp #2
	beq peDrop
	bcc peContextualDropRent1
	;VREST
	lda PatternCursorX
	and #3
	cmp #2
	bne peDrop
	jsr DecodeGrabbedPatternEntry
DropVolume
	;Drop Volume
	lda gdVolume
	sta PatternEntryVolume
	jmp peStorePatternLongNote
peContextualDropRent1
	;Drop Field Value
	jsr DecodeGrabbedPatternEntry
	lda PatternCursorX
	and #3
	cmp #2
	beq DropVolume
	bcc peDrop
DropSFX	lda gdSFX
	sta PatternEntrySFX
	jmp peStorePatternLongNote
	
DecodeGrabbedPatternEntry
	lda #00
	sta gdVolume
	lda PatternCursorX
	lsr
	lsr
	tax
	lda GrabbedPatternEntry0
	lsr
	rol gdVolume
	lsr
	rol gdVolume
	adc tl_CurrentOctaveRange,x
	sta gdLongNote
	lda GrabbedPatternEntry1
	lsr
	rol gdVolume
	lsr
	rol gdVolume
	sta gdSFX
	lda gdLongNote
	ldx #255
	sec
.(
loop1	inx
	sbc #12
	bcs loop1
.)
	adc #12
	sta gdNote
	stx gdOctave
DecodeRent1
	rts
	
gdVolume		.byt 0
gdLongNote          .byt 0
gdSFX               .byt 0
gdNote              .byt 0
gdOctave            .byt 0


peBar	;
	lda PatternEntryType
.(
	beq skip1
	lda #%11111100
	sta PatternEntryByte0
	lda #00
	jmp peDropRent1
skip1	rts
.)

peHighlightDown
	lda peHighlightActive
	beq peInitialiseHighlighting
	jsr peNavDown
	lda #01
	sta peHighlightActive
	lda PatternCursorRow
	sta peHighlightRowEnd
	rts

peCalcCurrentTrack
	lda PatternCursorX
	lsr
	lsr
	rts
	
peInitialiseHighlighting
	;Cannot begin highlighting in Rested Pattern
	lda PatternEntryType
.(
	beq skip1
	;Store Current Track and Row
	jsr peCalcCurrentTrack
	sta peHighlightTrackStart
	sta peHighlightTrackEnd
	lda PatternCursorRow
	sta peHighlightRowStart
	sta peHighlightRowEnd
	lda #01
	sta peHighlightActive
skip1	rts
.)

peDeactivateHighlighting
	lda #00
	sta peHighlightActive
	rts

peHighlightUp
	;Is Highlight active?
	lda peHighlightActive
.(
	beq skip1
	
	;Does move make Pattern Cursor above Highlight start row?
	jsr peNavUp
	lda #01
	sta peHighlightActive
	lda PatternCursorRow
	cmp peHighlightRowStart
	bcc peDeactivateHighlighting
	sta peHighlightRowEnd
skip1	rts
.)
	
peHighlightLeft
	lda peHighlightActive
.(
	beq skip1
	
	;Does move make Pattern Cursor left of Highlight start track?
	jsr peNavTrackLeft
	lda #01
	sta peHighlightActive
	jsr peCalcCurrentTrack
	cmp peHighlightTrackStart
	bcc peDeactivateHighlighting
	sta peHighlightTrackEnd
skip1	rts
.)

peHighlightRight
	lda peHighlightActive
	beq peInitialiseHighlighting
	jsr peNavTrackRight

	;Moving into a rest channel will deactivate highlight
	lda PatternEntryType
.(
	beq skip1
	lda #01
	sta peHighlightActive
	jsr peCalcCurrentTrack
	sta peHighlightTrackEnd
skip1	rts
.)

	
	

peCopy
	lda #00
peCopy2Buffer
	sta peTransferType
	lda peHighlightActive
.(
	beq skip1
	lda #00
	sta CopyByteCount
	sta CopyByteCount+1
	;Display copying..
	ldx #1
	ldy #27
	lda #0+DSM_INVERT
	jsr DisplaySimpleMessage
	;Setup for copying
	jsr SetupCopyBuffer
	
	;Transfer Boundaries to Copy otherwise highlighting will corrupt original
	lda peHighlightTrackStart
	sta peCopyTrackStart
	lda peHighlightTrackEnd
	sta peCopyTrackEnd
	lda peHighlightRowStart
	sta peCopyRowStart
	lda peHighlightRowEnd
	sta peCopyRowEnd
	lda #00
	sta peCopyTracks
	;Copy area
	ldx peHighlightTrackStart

loop2	;skip if on rested track
	lda TrackProperty,x
	bpl skip2
	inc peCopyTracks
	ldy peHighlightRowStart
loop1	jsr peFetchHilightedEntry
	jsr peStore2CopyBuffer
	iny
	cpy peHighlightRowEnd
	beq loop1
	bcc loop1
skip2	inx
	cpx peHighlightTrackEnd
	beq loop2
	bcc loop2

	;Display Copied and clear previous
	ldx #1
	ldy #27
	lda #1+DSM_CLEARPREVIOUS+DSM_INVERT
	jsr DisplaySimpleMessage
	;Dehighlight area
	lda #00
	sta peHighlightActive
	;Set copy buffer to Pattern data
	lda CurrentEditor
	sta CopyEditor
	sec
skip1	rts
.)
peCut	lda #01
	jmp peCopy2Buffer

;Fetch Highlighted Bytes 0 and +1 using X(Track) and Y(Row) without corrupting either
peFetchHilightedEntry
	sty peTempY
	;Fetch Address
	tya
	jsr CalcPatternAddress
	ldy #00
	lda peTransferType
.(
	bne skip1
	lda (source),y
	sta cpyByte0
	iny
	lda (source),y
	sta cpyByte1
	ldy peTempY
	rts
skip1	;Cut
.)
	lda (source),y
	sta cpyByte0
	;If on Track H and is Command then set different Rest value
	cpx #7
.(
	bne skip1
	lda PatternEntryType
	cmp #5
	bne skip1
	lda #10
	jmp skip2
skip1	lda #61*4
skip2	sta (source),y
.)
	iny
	lda (source),y
	sta cpyByte1
	lda #0
	sta (source),y
	ldy peTempY
	rts
	
;Store the Bytes cpyByte0 and cpyByte1 to the CopyBuffer sequentially without corrupting X or Y
peStore2CopyBuffer
	sty peTempY
	ldy #00
	lda cpyByte0
	sta (copy),y
	iny
	lda cpyByte1
	sta (copy),y
	lda #2
	jsr Add_Copy
	lda #2
	jsr Add_CopyCount
	ldy peTempY
	rts
	

pePaste
	lda #00
	jmp peCopy2Pattern
peMerge
	lda #1
peCopy2Pattern
	sta peTransferType
	lda CopyByteCount
.(
	bne skip3
	lda CopyByteCount+1
	beq skip4
skip3	lda CopyEditor
	cmp CurrentEditor
	bne skip1

	;Setup for copying
	jsr SetupCopyBuffer
	lda peCopyTracks
	sta peCopiedTracks

	lda PatternCursorX
	lsr
	lsr
	tax
	lda peCopyTrackStart
	sta pecCurrentTrack

loop1	lda peCopyRowStart
	sta pecCurrentRow
	;Avoid pasting too far right
	cpx #8
	bcs skip4
	;Avoid pasting into rested track
	lda TrackProperty,x
	bpl skip1
	ldy PatternCursorRow
	
loop2	jsr peFetchCopyEntry
	;Avoid pasting beyond row 63(but still track rows)
	cpy #64
	bcs skip2
	jsr peStore2Pattern
skip2	iny
	inc pecCurrentRow
	lda pecCurrentRow
	cmp peCopyRowEnd
	beq loop2
	bcc loop2
	dec peCopiedTracks
	beq skip4
	inc pecCurrentTrack
skip1	inx
	lda pecCurrentTrack
	cmp peCopyTrackEnd
	beq loop1
	bcc loop1
skip4	rts
.)

;
;	;Use Copy boundaries purely to track original format
;	lda PatternCursorRow
;	sta 
;	jsr peCalcCurrentTrack
;	sta 
;	
;	
;	ldx peCopyTrackStart
;
;loop2	;Prevent pasting onto rested track
;	stx peTempX
;	ldx pecCurrentTrack
;	lda TrackProperty,x
;	asl
;	ldx peTempX
;	bcc skip3
;	ldy peCopyRowStart
;loop1	jsr peFetchCopyEntry
;	;Prevent pasting beyond entry 63
;	lda pecCurrentRow
;	cmp #64
;	bcs skip4
;	jsr peStore2Pattern
;skip4	inc pecCurrentRow
;	iny
;	cpy peCopyRowEnd
;	beq loop1
;	bcc loop1
;	lda PatternCursorRow
;	sta pecCurrentRow
;skip3	inc pecCurrentTrack
;	;Prevent pasting into Track8!
;	lda pecCurrentTrack
;	cmp #8
;	bcs skip1
;	
;	inx
;	cpx peCopyTrackEnd
;	beq loop2
;	bcc loop2
;skip1	rts

	
peFetchCopyEntry
	sty peTempY
	ldy #00
	lda (copy),y
	sta cpyByte0
	iny
	lda (copy),y
	sta cpyByte1
	lda #2
	jsr Add_Copy
	ldy peTempY
	rts
	
peStore2Pattern
	sty peTempY
	stx peTempX
	tya
	jsr CalcPatternAddress
	ldy #00
	lda peTransferType
.(
	bne Merge
skip1	lda cpyByte0
	sta (source),y
	lda cpyByte1
	iny
	sta (source),y
	ldx peTempX
	ldy peTempY
	rts
Merge
	;In Merge only paste if the entry is a Rest(61*4)
	lda (source),y
	lsr
	lsr
	cmp #61
	beq skip1
.)
	ldx peTempX
	ldy peTempY
	rts
	
pePlayPattern
	jmp PlayPattern
pePlaySong
	rts
peMuteTrack
	;Calc Current Track
	lda PatternCursorX
	lsr
	lsr
	
	;Use as index to bitpos
	tax
	lda Bitpos,x
	
	;And toggle mute flag
	eor prActiveTracks_NotMuted
	sta prActiveTracks_NotMuted
	
	;Play monitor should automatically pick this up
	rts

peInsert
	;If highlight active then becomes transpose down
	lda peHighlightActive
.(
	beq skip1
	ldx #04
	jmp ProcessExtendedHighlightOptions
skip1	
.)
peInsertRent
	lda PatternCursorRow
	cmp #63
.(
	bcs skip2
	
	;Insert row(Rest) in all active tracks and shift data down
	lda PatternCursorX
	lsr
	lsr
	tax
	lda TrackProperty,x
	bpl skip2
	ldy #62	;Row
loop1	jsr peFetchPatternEntry
	iny
	jsr peStorePatternEntry
	dey
	dey
	bmi skip3
	cpy PatternCursorRow
	beq loop1
	bcs loop1
skip3	ldy PatternCursorRow
	jsr peStorePatternRest
skip2	rts
.)


peDelete
	;If highlight active then becomes transpose down
	lda peHighlightActive
.(
	beq skip1
	ldx #05
	jmp ProcessExtendedHighlightOptions
skip1	
.)
peDeleteRent
	lda PatternCursorRow
	cmp #63
.(
	bcs skip2
	;Delete row in all active tracks and shift data up(Storing rest in entry 63)
	lda PatternCursorX
	lsr
	lsr
	tax
	lda TrackProperty,x
	bpl skip2
	ldy PatternCursorRow
	iny
loop1	jsr peFetchPatternEntry
	dey
	jsr peStorePatternEntry
	iny
	iny
	cpy #64
	bcc loop1
	ldy #63
	jsr peStorePatternRest
skip2	rts
.)

;Parsed
;X Track
;Y Row
;Returns
;cpyByte0	Pattern Entry Byte0
;cpyByte1	Pattern Entry Byte1
peFetchPatternEntry
	tya
	pha
	jsr CalcPatternAddress
.(
	ldy #01
loop1	lda (source),y
	sta cpyByte0,y
	dey
	bpl loop1
.)
	pla
	tay
	rts
	
peStorePatternEntry
	tya
	pha
	jsr CalcPatternAddress
.(
	ldy #01
loop1	lda cpyByte0,y
	sta (source),y
	dey
	bpl loop1
.)
	pla
	tay
	rts
	
peStorePatternRest
	lda #61*4
	sta cpyByte0
	lda #00
	sta cpyByte1
	jmp peStorePatternEntry
	
peMoveEntryDown
	;If highlight active then becomes transpose down
	lda peHighlightActive
.(
	beq skip1
	ldx #03
	jmp ProcessExtendedHighlightOptions
skip1	;Must ensure boundaries are not exceeded
.)
	lda PatternCursorRow
.(
	beq skip1
	cmp #63
	bcs skip1
	inc PatternCursorRow
	jsr peDelete
	dec PatternCursorRow
;	dec PatternCursorRow
	jsr peInsert
;	inc PatternCursorRow
	inc PatternCursorRow
skip1	rts
.)
	

	
	
	
peMoveEntryUp
	;If highlight active then becomes transpose up
	lda peHighlightActive
.(
	beq skip1
	ldx #02
	jmp ProcessExtendedHighlightOptions
skip1	;Just do reverse of MoveDown
.)
	lda PatternCursorRow
.(
	beq skip1
	cmp #63
	bcs skip1
	dec PatternCursorRow
	jsr peDelete
	inc PatternCursorRow
;	inc PatternCursorRow
	jsr peInsert
	dec PatternCursorRow
;	dec PatternCursorRow
skip1	rts
.)
	rts

peToggleCommand
	;Is Track H Command?
	lda TrackProperty+7
	asl
.(
	bpl skip1
	; Fetch Command
	ldx #7
	ldy PatternCursorRow
	jsr peFetchPatternEntry
	lda cpyByte0
	lsr
	lsr
	tax
	lda ModifyParamFlags,x
	and #%11000000
	cmp #%01000000
	; Is Command Track specific? (3 Only)
	bne skip1
	; invert Current Track bitpos in cpyByte1
	lda PatternCursorX
	lsr
	lsr
	tax
	lda cpyByte1
	eor Bitpos,x
	sta cpyByte1
	ldx #7
	ldy PatternCursorRow
	jsr peStorePatternEntry
skip1	rts
.)
peCmdEGWave
	;Is Track H Command?
	lda TrackProperty+7
	asl
.(
	bpl skip1
	
	; Fetch H Entry
	ldx #7
	ldy PatternCursorRow
	jsr peFetchPatternEntry
	
	;A0-3 Command ID(0-11)
	;A4-7 Param1(0-15)
	;B0-7 Param2(0-255)
	
	;Store Command and Default Param1
	lda #31*4
	sta cpyByte0
	lda #00
	sta cpyByte1
	
	ldx #7
	ldy PatternCursorRow
	jsr peStorePatternEntry
skip1	rts
.)
peCmdEGPeriod
	;Is Track H Command?
	lda TrackProperty+7
	asl
.(
	bpl skip1
	
	; Fetch H Entry
	ldx #7
	ldy PatternCursorRow
	jsr peFetchPatternEntry
	
	;A0-3 Command ID(0-11)
	;A4-7 Param1(0-15)
	;B0-7 Param2(0-255)
	
	;Store Command and Default Param1
	lda #35*4
	sta cpyByte0
	lda #0
	sta cpyByte1
	
	ldx #7
	ldy PatternCursorRow
	jsr peStorePatternEntry
skip1	rts
.)

peCmdTriggerOut
	;Is Track H Command?
	lda TrackProperty+7
	asl
.(
	bpl skip1
	
	; Fetch H Entry
	ldx #7
	ldy PatternCursorRow
	jsr peFetchPatternEntry
	
	;A0-3 Command ID(0-11)
	;A4-7 Param1(0-15)
	;B0-7 Param2(0-255)
	
	;Store Command and Default Param1
	lda #16*4
	sta cpyByte0
	lda #0
	sta cpyByte1
	
	ldx #7
	ldy PatternCursorRow
	jsr peStorePatternEntry
skip1	rts
.)
	
	
peCmdTriggerIn
	;Is Track H Command?
	lda TrackProperty+7
	asl
.(
	bpl skip1
	
	; Fetch H Entry
	ldx #7
	ldy PatternCursorRow
	jsr peFetchPatternEntry
	
	;A0-3 Command ID(0-11)
	;A4-7 Param1(0-15)
	;B0-7 Param2(0-255)
	
	;Store Command and Default Param1
	lda #17*4
	sta cpyByte0
	lda #00
	sta cpyByte1
	
	ldx #7
	ldy PatternCursorRow
	jsr peStorePatternEntry
skip1	rts
.)
peCmdSongTempo
	;Is Track H Command?
	lda TrackProperty+7
	asl
.(
	bpl skip1
	
	; Fetch H Entry
	ldx #7
	ldy PatternCursorRow
	jsr peFetchPatternEntry
	
	;Store Command and Default Param1
	lda #18*4

	sta cpyByte0
	lda #10	;Default tempo to 10
	sta cpyByte1
	
	ldx #7
	ldy PatternCursorRow
	jsr peStorePatternEntry
skip1	rts
.)

peCmdBend
	;Is Track H Command?
	lda TrackProperty+7
	asl
.(
	bpl skip1
	
	; Fetch H Entry
	ldx #7
	ldy PatternCursorRow
	jsr peFetchPatternEntry
	
	;A0-3 Command ID(0-11)
	;A4-7 Param1(0-15)
	;B0-7 Param2(0-255)
	
	;Store Command and Default Param1
	lda #0
	sta cpyByte0
	sta cpyByte1
	
	ldx #7
	ldy PatternCursorRow
	jsr peStorePatternEntry
skip1	rts
.)

