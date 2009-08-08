
;Plot Pattern - Plot 8 channels and 24 rows

;Editor Patterns are stored as 3 Byte x 64 Entires x 8 Channels where each 3 byte entry is
;0-7 Bar(0) Note(1-95) Rest(128)
;0-7 Volume(0-63)
;0-7 Effect(0-63)
;or if a channel is a command channel it is
;0-7 Channel Apply(Each bit set will be a channel affected)
;0-7 Command
;0-7 Command Data

;Editor Pattern Note data is shown as 4 characters
;COVX
;Where
;C is Note and Sharp
;O is octave
;V is volume
;X is Effect
;And for Rest
;RRV-
;Where
;RR is RST
;V can be volume rest
;- is not used
;And for Bar
;BBV-
;BB is BAR
;V can set volume at a bar
;- is not used
;And for Command channel(Channel H only)
;GC0T
;Where
;G  is the graphic that indicates this entry as a command
;C  is the command Number(0-31)
;0  is the command data (Decimal 00-63)
;T  is used for some commands(Byte usually Track Spread)
;And the command Channel allocation is shown to the right of each channel
;0123456789012345678901234567890123456789
;N00-A 01-A 02-E 01-N 03-B 10-C 09-C 08-T
;MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX


;Parsed
;PatternCursorRow	Current row that pattern cursor is on
;CurrentPattern	Table of 8 bytes showing current pattern activity on each channel
;CurrentCommandFlag	Current Command on H status
PatternPlot
	lda #00
	sta PatternRowCommandChannelActivity
	; Fetch Pattern Screen Address
	ldy PatternCursorRow
	jsr SetupEditorScreen
.(	
loop2	; Branch if within pattern
	cmp #64
	bcc skip1
	
	; Plot blank row
	ldy #39
loop1	lda BlankPatternRow,y
	sta (screen),y
	dey
	bpl loop1

rent1	; Look to next row
	jsr nl_screen
	inc RowIndex
	lda RowIndex
	dec RowCounter
	bne loop2
	
	; Pattern Plot ends here!
	rts

skip1	; Plot pattern row - Loop on Track
	ldx #7

loop3	;Branch if track is inactive
	lda TrackProperty,x
	bpl skip4
	
	lda RowIndex
	jsr CalcPatternAddress

	; Fetch Pattern Entry bytes
	ldy #00
	lda (source),y
	;Look and branch if BAR found
	cmp #63*4
	bcs skip2
	
	iny
	sta PatternEntryByte0
	lda (source),y
	sta PatternEntryByte1
	
	; Calc Y for screen offset
	stx ppTempX
	txa
	;Multiply channel (0-7) by 5
	asl
	asl
	sec
	adc ppTempX
	tay
	
	jsr PatternPlotEntry
	ldx ppTempX
	jmp skip3

skip4	; Display Blank Track Entry (Inactive)
	stx ppTempX
	txa
	;Multiply channel (0-7) by 5
	asl
	asl
	sec
	adc ppTempX
	tay
	lda #8	;HYPHEN_CHARACTER
	sta (screen),y
	iny
	sta (screen),y
	iny
	sta (screen),y
	iny
	sta (screen),y
	iny
	jsr DisplayTrackCommandFlag
	
skip3	;
	dex
	bpl loop3
	
	; Show Pattern Index (only when on channel 0)
	ldy #00
	lda RowIndex
	cmp PatternCursorRow
	beq skip5
skip6	clc
	adc #SIXTYFOUR_CHARACTERBASE
	sta (screen),y
	; Progress to next row
	jmp rent1
skip5	bit peBlueRow
	bpl skip6
	lda #16+4
	sta $BB80+40*14
	jmp rent1
skip2	;Plot BAR row and clear to end of page
.)
	ldy #39
.(
loop1	lda PatternBARRow,y
	sta (screen),y
	dey
	bpl loop1
.)
.(
rent1	; Look to next row
	jsr nl_screen
	dec RowCounter
	beq skip2
	
	; Now clear to end of page
	ldy #39
loop1	lda BlankPatternRow,y
	sta (screen),y
	dey
	bpl loop1
	
	jmp rent1
skip2	rts
.)




;Parsed
;PatternEntryByte0
;PatternEntryByte1
;TrackProperty - Current Properties of each track
;         B0-4 SS for Track
;	B5   Display Numeric rather than Note
;	B6   Command Track
;	B7   Active
;CurrentPattern
;(screen),y
;X & ppTempX	Current Track
PatternPlotEntry
	;Check Highlighting and flag 128 if so
	lda peHighlightActive
.(
	beq skip1
	;Fetch Current Row
	lda RowIndex
	cmp peHighlightRowStart
	bcc skip1
	cmp peHighlightRowEnd
	beq skip3
	bcs skip1
skip3	cpx peHighlightTrackStart
	bcc skip1
	cpx peHighlightTrackEnd
	beq skip4
	bcs skip1
skip4	lda #128
	jmp skip2
skip1	lda #00
skip2	sta peHighlightInverse
.)
	;Branch if Track H is the Command Track
	lda TrackProperty,x
	asl
.(
	bpl skip10
	jmp DisplayPatternCommand
skip10
	; Extract all fields - Byte0 becomes Note and Byte1 becomes Effect!
	ldx #00
	stx ppTempVolume
	lsr PatternEntryByte0
	rol ppTempVolume
	lsr PatternEntryByte0
	rol ppTempVolume
	lsr PatternEntryByte1
	rol ppTempVolume
	lsr PatternEntryByte1
	rol ppTempVolume
	
	; Branch if Track Entry needs to be displayed as Numeric
	asl
	bmi skip11

	; Branch on Note type
	lda PatternEntryByte0
	cmp #61
	bcc skip9
rent3	cmp #62
	bcs skip1
	jmp DisplayRest
skip1	bne skip2
	jmp DisplayVRest
skip2	jmp DisplayBar

skip11	; Still observe Rest,VRest and Bar for Value held
	lda PatternEntryByte0
	cmp #61
	bcs rent3
	;Display Byte0 directly in format 00-60 (2 digit decimal)
	ldx #SINGLEDIGITS_CHARACTERBASE-1
	sec
loop1	inx
	sbc #10
	bcs loop1
	adc #SINGLEDIGITS_CHARACTERBASE+10
	pha
	txa
	ora peHighlightInverse
	sta (screen),y
	clc
	pla
	iny
	jmp skip5	
	
skip9	ldx ppTempX
	lda tl_CurrentOctaveRange,x
	clc
	adc PatternEntryByte0
	tax
	lda NoteSharpCharacter,x
	ora peHighlightInverse
	sta (screen),y
	iny
	lda OctaveCharacter,x
skip5	ora peHighlightInverse
	sta (screen),y
	iny
	
	jsr ReformatVolume
skip12	clc
	adc #SIXTYFOUR_CHARACTERBASE
	ora peHighlightInverse
	sta (screen),y
	iny
	lda PatternEntryByte1
	adc #SIXTYFOUR_CHARACTERBASE
	jmp ppRent2
.)
DisplayPatternCommand
	;Pattern Command now follows existing note format in order
	;that both Rest and Bar conform to same format. However
	;the Command parameter is held in the note range so..
	;B0-1 -
	;B2-7 Command ID and Parameter1(Range)
	;B0   -
	;B1-7 Parameter2
	
	lda #00
	sta PatternRowCommandChannelActivity
	;Is Command?
	lda PatternEntryByte0
	lsr
	lsr
	cmp #61
	bne dcSkip1
	;Command Rest ----
	lda #HYPHEN_CHARACTER
	ora peHighlightInverse
	sta (screen),y
	iny
	sta (screen),y
	iny
	sta (screen),y
	iny
	sta (screen),y
	rts
dcSkip1	cmp #63
	bne dcSkip2
	;Command Bar ====
	lda #BAR_CHARACTER
	ora peHighlightInverse
	sta (screen),y
	iny
	sta (screen),y
	lda #HYPHEN_CHARACTER
	iny
	sta (screen),y
	iny
	sta (screen),y
	rts

dcSkip2	;Command is displayed depending on its range
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
	lda #COMMAND_CHARACTER
	ora peHighlightInverse
	sta (screen),y
	iny
	;C  is the command Number(0-60/62)
	lda PatternEntryByte0
	lsr
	lsr
	;Display as ID..
	;0	Pitchbend
	;1   	Trigger Out
	;2    	Trigger In
	;3    	Note Tempo
	;4    	EG Cycle
	;5 	EG Period
	;6 	-          
	;    	Rest
	;7    	Rest
	;    	Bar
	ldx #10	;Range of Pattern Commands
.(
loop1	dex
	cmp prPatternCommandThreshhold,x
	bcc loop1
.)
	txa
	clc
	adc #SIXTYFOUR_CHARACTERBASE
	ora peHighlightInverse
	sta (screen),y
	iny
	;
	;0  is the command param (Decimal 00-15)
	;		  v
	;00-15 Pitchbend	c0p-
	;16    Trigger Out	c0-q
	;17    Trigger In	c0-q
	;18    Note Tempo	c0-q
	;19    EG Cycle	c0-q
	;20-35 EG Period	c0pq
	;36-60 -            ----
	;61    Rest	----
	;62    -		----
	;63    Bar	====
	lda PatternEntryByte0
	lsr
	lsr
	tax
	lda cpDigit0,x
	and #127	;Top bit flags next parameter
	ora peHighlightInverse
	sta (screen),y
	;		   v
	;00-15 Pitchbend	c0p-
	;16    Trigger Out	c0-q
	;17    Trigger In	c0-q
	;18    Note Tempo	c0-q
	;19-34 EG Cycle	c0-q
	;35-50 EG Period	c0pq
	;51-60 -            ----
	;61    Rest	----
	;62    -		----
	;63    Bar	====
	;Only display command flag if command id 0-15 or 19-34
	lda ModifyParamFlags,x
	and #%11000000
	cmp #%01000000
.(
	bne skip1
	lda PatternEntryByte1
	sta PatternRowCommandChannelActivity
skip1	iny
.)
	lda cpDigit0,x
	asl
	lda #HYPHEN_CHARACTER
.(
	bcc skip1
	lda PatternEntryByte1
	and #63
	clc
	adc #SIXTYFOUR_CHARACTERBASE
skip1	ora peHighlightInverse
.)
	sta (screen),y
	rts
DisplayBar
	lda #BAR_CHARACTER
	ora peHighlightInverse
	sta (screen),y
	iny
ppRent1	sta (screen),y
	iny
	; Display remainder of track as Hyphens(2)
	lda #HYPHEN_CHARACTER
	ora peHighlightInverse
	sta (screen),y
	iny
	jmp ppRent2
DisplayRest
	lda #HYPHEN_CHARACTER
	ora peHighlightInverse
	sta (screen),y
	iny
	jmp ppRent1
DisplayVRest
	lda #HYPHEN_CHARACTER
	ora peHighlightInverse
	sta (screen),y
	iny
	sta (screen),y
	iny
	;Shift left if hires
	lda tl_CurrentResolutions
	and #BIT4
	cmp #BIT4
	lda ppTempVolume	
.(
	bcc skip12
	asl
	asl
	cmp #60
	bcc skip12
	clc
	lda #63
skip12	adc #SIXTYFOUR_CHARACTERBASE	;Carry Set before!
.)
	ora peHighlightInverse
	sta (screen),y
	iny
	lda #HYPHEN_CHARACTER
ppRent2	ora peHighlightInverse
	sta (screen),y
	iny
	;Now display Track Command Flag


DisplayTrackCommandFlag
	ldx ppTempX
	cpx #7
.(
	beq skip2
	;Fetch Command Flag
	lda PatternRowCommandChannelActivity
	and Bitpos,x
	beq skip3
	lda #CHANNELCOMMANDFLAG_CHARACTER
;	ora peHighlightInverse
	sta (screen),y
	rts
skip3	lda #127	;8
;	ora peHighlightInverse
	sta (screen),y
skip2	rts
.)


;32-95	0-63 Numerics
;96-107	0-11 Notes
;108-117	0-9  Single Digits
;118-118	Hyphen
;119-120	Bar Graphic
;121-122	Rest Graphic
;123-123	Channel Command Flag
;124-124  Command Graphic
;125-127  3 Spare Characters
NoteSharpCharacter
 .byt 96,97,98,99,100,101,102,103,104,105,106,107	;0
 .byt 96,97,98,99,100,101,102,103,104,105,106,107	;1
 .byt 96,97,98,99,100,101,102,103,104,105,106,107	;2
 .byt 96,97,98,99,100,101,102,103,104,105,106,107	;3
 .byt 96,97,98,99,100,101,102,103,104,105,106,107	;4

 .byt 96,97,98,99,100,101,102,103,104,105,106,107	;5
 .byt 96,97,98,99,100,101,102,103,104,105,106,107	;6
 .byt 96,97,98,99,100,101,102,103,104,105,106,107	;7
 .byt 96,97,98,99,100,101,102,103,104,105,106,107	;8
 .byt 96,97,98,99,100,101,102,103,104,105,106,107	;9
OctaveCharacter
 .dsb 12,108	;0
 .dsb 12,109	;1
 .dsb 12,110	;2
 .dsb 12,111	;3
 .dsb 12,112	;4
 .dsb 12,113	;5
 .dsb 12,114	;6
 .dsb 12,115	;7
 .dsb 12,116	;8
 .dsb 12,117	;9


;Display Cursor based on PatternCursorX (Always middle row)
peDisplayCursor
	ldx PatternCursorX
	ldy PatternCursorIndex2ScreenIndex,x
	lda $bb80+80+40*12,y
	ora #128
	sta $bb80+80+40*12,y
	;Take this opportunity to update status bar textual stuff for command
	jsr peFetchEntryData
	lda PatternEntryType
;	beq ???
	cmp #5
.(
	bne skip1
	jmp LookupPatternCommand
skip1	;
.)
;	cmp #

	
;   0 Entry Inactive (Pattern Inactive)
;   1 Entry is a Note
;   2 Entry is a Rest
;   3 Entry is a VRest
;   4 Entry is a Bar
;   5 Entry is a Command

;PatternContextual	;16x8
; .byt "A-RESTED TRACK  "
; .byt "A-NOTE          "
; .byt "A-OCTAVE        "
; .byt "A-VOLUME        "
; .byt "A-SFX ",34,"        ",34
; .byt "A-REST          "
; .byt "A-VRST          "
; .byt "A-BAR           "

	lda PatternCursorX
	and #3
	cmp #3
.(
	bne skip1
	jsr peFetchEntryData
	jmp LookupSFX
skip1	jmp LookupNone
.)

peDisplayLegend
	ldy #39
.(
loop1	lda peLegend,y
	ora #128
	sta $bb80+40,y
	dey
	bpl loop1
.)
	rts


peDisplayStatus
	;Calc Track
	lda PatternCursorX
	lsr
	lsr
	tax
	;Extract nvs from grabbed pattern bytes
	lda #00
	sta PatternEntryVolume
	lda GrabbedPatternEntry0
	lsr 
	rol PatternEntryVolume
	lsr 
	rol PatternEntryVolume
	;Add the current base octave(track dependant)
	adc tl_CurrentOctaveRange,x
	sta PatternEntryLongNote
	lda GrabbedPatternEntry1
	lsr 
	rol PatternEntryVolume
	lsr 
	rol PatternEntryVolume
	sta PatternEntrySFX

	;Display Grabbed Note Entry
	ldx PatternEntryLongNote
	lda NoteSharpCharacter,x
	sta PatternGrabbedStatus_Entry
	lda OctaveCharacter,x
	sta PatternGrabbedStatus_Entry+1
	lda PatternEntryVolume
	adc #SIXTYFOUR_CHARACTERBASE
	sta PatternGrabbedStatus_Entry+2
	lda PatternEntrySFX
	adc #SIXTYFOUR_CHARACTERBASE
	sta PatternGrabbedStatus_Entry+3
	
	;Display status
	ldx #39
.(
loop1	lda PatternGrabbedStatus,x
	ora #128
	sta $bb80+40*27,x
	dex
	bpl loop1
.)
	rts


;Volume format depends on SS and global HighResVolume settings
ReformatVolume
	;If SS <3 then observe hires
	ldx ppTempX
	lda TrackProperty,x
	and #31
	cmp #3
.(
	bcs skip2
	;Shift left if hires
	lda tl_CurrentResolutions
	and #BIT4
	cmp #BIT4
skip3	lda ppTempVolume
	bcc skip1
	asl
	asl
	cmp #60
	bcc skip1
	lda #63
skip1	rts
skip2	;If SS is Tone(3-5) then always 0-1
	cmp #6
	bcc skip4
	;If SS is EG(6-12) then always 0-15
	cmp #13
	bcc skip3
	;If SS is Noise(13-19) then always 0-1
skip4	lda ppTempVolume
	beq skip1
.)
	lda #1
	rts
