;CommonRoutines.s
DisplayTopRow
	ldx #31
.(
loop1	lda TopRowText,x
	sta $BB80,x
	dex
	bpl loop1
.)

;Parsed
;Y - Editors Cursor Row
SetupEditorScreen
	lda #<$BB80+40*2
	sta screen
	lda #>$BB80+40*2
	sta screen+1
	;28-menu(1)-legend(1)-status(1)
	lda #25
	sta RowCounter
	; Look at cursor row - (window height / 2)
	tya
	sec
	sbc #12
	sta RowIndex
	rts


DisplayAlt4DD_SectorsFree
	lda #<fnStatusBar_SectorsFree
	sta screen
	lda #>fnStatusBar_SectorsFree
	sta screen+1
	ldy #00
	lda fnSectorsFreeLo
	sta Temp01
 	lda fnSectorsFreeHi
 	sta Temp02
	;Calc 1000's
	ldx #47
	sec
.(
loop1	inx
	lda Temp01
	sbc #<1000
	sta Temp01
	lda Temp02
	sbc #>1000
	sta Temp02
	bcs loop1
.)
	lda Temp01
	adc #<1000
	sta Temp01
	lda Temp02
	adc #>1000
	sta Temp02
	txa
	sta (screen),y
	iny
	;Calc 100's
	ldx #47
	sec
.(
loop1	inx
	lda Temp01
	sbc #<100
	sta Temp01
	lda Temp02
	sbc #>100
	sta Temp02
	bcs loop1
.)
	lda Temp01
	adc #<100
	pha
	txa
	sta (screen),y
	iny
	pla
	jmp AltPlotInversed2DD
	
	
	
	


DisplayAlt3DD_withListhlinverse
	ldx #47
	sec
.(
loop1	inx
	sbc #100
	bcs loop1
.)
	adc #100
	pha
	txa
	ora eeHighlightInverse
	sta (screen),y
	iny
	pla
DisplayAlt2DD_withListhlinverse
	ldx #47
	sec
.(
loop1	inx
	sbc #10
	bcs loop1
.)
	adc #58
	pha
	txa
	ora eeHighlightInverse
	sta (screen),y
	iny
	pla
	ora eeHighlightInverse
	sta (screen),y
	iny
	rts
	

AltPlotInversed3DD
	ldx #47+128
	sec
.(
loop1	inx
	sbc #100
	bcs loop1
.)
	adc #100
	pha
	txa
	sta (screen),y
	iny
	pla
AltPlotInversed2DD
	ldx #47+128
	sec
.(
loop1	inx
	sbc #10
	bcs loop1
.)
	adc #10
	pha
	txa
	sta (screen),y
	iny
	pla
AltPlotInversed1DD
	clc
	adc #48+128
	sta (screen),y
	iny
	rts

AltPlotInversed2DH
	pha
	lsr
	lsr
	lsr
	lsr
	jsr AltPlotInversed1DH
	pla
AltPlotInversed1DH
	and #15
	cmp #10
.(
	bcc skip1
	adc #6
skip1	adc #48+128
.)
	sta (screen),y
	iny
	rts
	
	


Plot3dd
	ldx #SINGLEDIGITS_CHARACTERBASE-1
	sec
.(
loop1	inx
	sbc #100
	bcs loop1
.)
	adc #100
	pha
	txa
	ora eeHighlightInverse
	sta (screen),y
	iny
	pla
Plot2dd
	ldx #SINGLEDIGITS_CHARACTERBASE-1
	sec
.(
loop1	inx
	sbc #10
	bcs loop1
.)
	adc #SINGLEDIGITS_CHARACTERBASE+10
	pha
	txa
	ora eeHighlightInverse
	sta (screen),y
	iny
	pla
	ora eeHighlightInverse
	sta (screen),y
	iny
	rts

;Move screen+0/+1 to next row(+40)
nl_screen
	lda screen
	clc
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts

;Parsed
;X Track
;A Row
CalcPatternAddress
	; Multiply row by 2
	asl
.(
	sta vector1+1

	; Add Pattern address for this channel
	lda CurrentPattern,x	;0-127)
	;x128
	lsr
	;A == High C==Low
	pha
	;Move Carry into B7 (0 or 128)
	lda #00
	ror
	;Add Row Offset
vector1	adc #00
.)
	sta source
	pla
	;Add Base address of Patterns
	adc #>PatternMemory
	sta source+1
	rts
	
;Parsed
;X Track (0-7)
;A Row (0-127)
;Memory organisation is
;0-1 2-3 4-5 6-7 8-9 A-B C-D E-F
;0-1 2-3 4-5 6-7 8-9 A-B C-D E-F
CalcListAddress
	;Row x 16
	jsr CalcRowX16
	;Track x 2
	txa
	asl
	;+source
	adc source
	sta source
	;+Base Address
	lda source+1
	adc #>ListMemory
	sta source+1
	rts
CalcListRowAddress
	;Row x 16
	jsr CalcRowX16
	;+Base Address
	lda source+1
	adc #>ListMemory
	sta source+1
	rts
CalcRowX16
	sta source
	lda #00
	sta source+1
	asl source
	rol source+1
	asl source
	rol source+1
	asl source
	rol source+1
	asl source
	rol source+1
	rts

eeFetchRowData
	tya
	pha
	jsr CalcListRowAddress
	ldy #15
.(
loop1	lda (source),y
	sta eeRowData,y
	dey
	bpl loop1
.)
	pla
	tay
	rts


IsRowWideListCommand
	lda #00
.(
	sta vector1+2
	lda ListCursorRow
	asl
	rol vector1+2
	asl
	rol vector1+2
	asl
	rol vector1+2
	asl
	rol vector1+2
	adc #1
	sta vector1+1
	lda vector1+2
	adc #6
	sta vector1+2
vector1	lda $dead
.)
	cmp #%11000000
	rts
	
	
eeStoreRowData
	tya
	tax
	jsr CalcListRowAddress
	ldy #15
.(
loop1	lda eeRowData,y
	sta (source),y
	dey
	bpl loop1
.)
	txa
	tay
	rts
	
;X SFXNumber
;A RowIndex
CalcSFXAddress
.(
	sta vector1+1
	;source x 64
	lda #00
	sta source
	txa
	lsr
	ror source
	lsr
	ror source
	adc #>SFXMemory
	sta source+1
	lda source
vector1	ora #00
.)
	sta source
	rts 
	
Add_Copy
	clc
	adc copy
	sta copy
	lda copy+1
	adc #00
	sta copy+1
	rts
SetupCopyBuffer
	lda #<CopyBuffer
	sta copy
	lda #>CopyBuffer
	sta copy+1
	rts

Add_CopyCount
	clc
	adc CopyByteCount
	sta CopyByteCount
	lda CopyByteCount+1
	adc #00
	sta CopyByteCount+1
	rts
	
seFetchEntryTypeIndex
	ldx #27
.(
loop1	dex
	cmp SFXRangeThreshold,x
	bcc loop1
.)	
	; Index now in X - Reduce range to 0-X and store
	sbc SFXRangeThreshold,x
	rts

;Parsed
;Y == Row
CalcYLOC
	lda YLOCL,y	;#<$bb80+40*7
	sta screen
	lda YLOCH,y	;#>$BB80+40*7
	sta screen+1
	rts

;Parsed
;A == SFXNumber
CalcSFXNameAddress
	asl
	asl
	asl
	rol source+1
	sta source
	lda source+1
	and #1
	ora #>SFXNames
	sta source+1
	rts
	

CLS
ClearScreen
	lda #<$BB80
	sta screen
	lda #>$BB80
	sta screen+1
	ldx #28
.(
loop2	ldy #39
	lda #9
loop1	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	dex
	bne loop2
.)
	rts

;*** Jump Routines
JumpHelp
	;Flag system that help is being used so that playmonitor knows
	lda #01
	sta HelpViewFlag
	jsr HelpPlot
	lda #00
	sta HelpViewFlag
	ldx CurrentEditor
	lda JumpVectorLo,x
.(
	sta vector1+1
	lda JumpVectorHi,x
	sta vector1+2
vector1	jmp $dead
.)	



;From List,Pattern or SFX Editors
;JumpMenu
;	lda CurrentEditor
;	cmp #3
;.(
;	bne skip1
;	;We must check the current SFX is valid before proceding
;	jsr ValidateCurrentSFX
;	bcs skip2
;skip1	jsr DisplayTopRow
;	lda #0
;	sta CurrentEditor
;skip2	rts
;.)

;From Menu,Pattern or SFX Editors
JumpList
	jsr TrackList
	lda CurrentEditor
	cmp #3
.(
	bne skip1
	;We must check the current SFX is valid before proceding
	jsr ValidateCurrentSFX
	bcs skip2
skip1	jsr CLS
	jsr SynchroniseMusicPointers
	jsr DisplayTopRow
	
	jsr eeDisplayLegend
	jsr ListPlot
	jsr eeDisplayStatus
	
	lda #1
	sta CurrentEditor
skip2	rts
.)

;From Menu,List or SFX Editors
JumpPattern
	lda CurrentEditor
	cmp #3
.(
	bne skip1
	;We must check the current SFX is valid before proceding
	jsr ValidateCurrentSFX
	bcs skip2
	jsr CLS
skip1	jsr SynchroniseMusicPointers
	lda CurrentEditor
	cmp #1
	bne skip3
	
skip3	;Prohibit jump to patterns if list row is RWC
	jsr IsRowWideCommand
	bcs skip5
	;Prohibit jump to Patterns if List row is all rests! (Otherwise trackchg will crash)
	ldx #0
loop1	lda TrackProperty,x
	bmi skip4
	inx
	cpx #8
	bcc loop1
skip5	rts
skip4	;Ensure Pattern cursor is currently on active track
	lda PatternCursorX
	lsr
	lsr
	tay
	lda TrackProperty,y
	bmi skip6
	;If not reset to first
	txa
	asl
	asl
	sta PatternCursorX
skip6	jsr DisplayTopRow
	
	jsr TrackCurrentSongDetails
	jsr peDisplayLegend
	jsr PatternPlot
	jsr peDisplayStatus

	lda #2
	sta CurrentEditor
	
skip2	rts
.)

;From Menu,List or Pattern Editors
;Must Track List to Pattern to SFX number before allowed to enter SFX
JumpSFX
	jsr CLS
	jsr SynchroniseMusicPointers
	jsr TrackCurrentSongDetails
	jsr DisplayTopRow
	
	jsr seUpdateLegend
	jsr seDisplayLegend
	jsr SFXPlot
	jsr seDisplayStatus

	lda #3
	sta CurrentEditor
	rts

JumpFile
	lda CurrentEditor
	cmp #3
.(
	bne skip1
	;We must check the current SFX is valid before proceding
	jsr ValidateCurrentSFX
	bcs skip2
skip1	jsr CLS
	jsr DisplayTopRow
	jsr fnUpdateStatusBar
	jsr fnRefreshDirectory
	lda #4
	sta CurrentEditor
skip2	rts
.)

JumpSelectMonitorView
	;Change between
	;Volumes
	;Pitch&Volume
	;CPU Load
	;Blank
	lda MonitorMode
	clc
	adc #1
	and #3
	sta MonitorMode
	jmp InitMonitor
	
;Cycle the available songs in List
;JumpSelectSong
;	jsr leSongNext
	
;UpdateMenuSong
;	lda #<MainMenuRowText_SongCount
;	sta screen
;	lda #>MainMenuRowText_SongCount
;	sta screen+1
;	ldy #00
;	sty eeHighlightInverse
;	;Always show song as base1
;	lda CurrentSong
;.(
;	bmi skip1
;	clc
;	adc #01
;	jsr DisplayAlt2DD_withListhlinverse
;	;Redisplay Current Song Name if CurrentSong different
;	lda CurrentSong
;	cmp OldSong
;	beq skip2
;	sta OldSong
;	ldx #12
;loop1	lda eeRowData+3,x
;	sta eeLegend_SongName,x
;	dex
;	bpl loop1
;	;Redisplay Legend
;	jsr eeDisplayLegend
;skip2	;Redisplay Menu
;	jmp DisplayTopRow
;skip1
;.)
;	lda #"-"
;	sta (screen),y
;	iny
;	sta (screen),y
;	rts
	
;Synchronise Music Pointers and update Pattern Legend
;SFXNumber is taken from current entry in Pattern Editor
;CurrentPattern(8) and TrackProperty(8) is taken from current valid row in List Editor
SynchroniseMusicPointers
	; Fetch List Row
	ldy ListCursorRow
	jsr eeFetchRowData
	; Don't change pattern settings if row wide command here
	lda eeRowData+1
	cmp #%11000000
.(
	bcs skip3
	; Set up Pattern tables
	ldx #00
loop1	txa
	asl
	tay
	lda eeRowData+1,y
	cmp #%01000000
	bcs MimickingTrack
	lda eeRowData,y
	and #127
	cmp #127
	bne skip1
RestingTrack
MimickingTrack
	lda #0
	sta TrackProperty,x
	lda #127
	sta CurrentPattern,x
	jmp skip2
skip1	sta CurrentPattern,x
	;Now set up Track Property
	lda eeRowData+1,y
	and #63
	cmp #63
	bne skip4
	;Command Channel H
	lda #64+128
	sta TrackProperty,x
	jmp skip2
skip4	and #31
	sta rent1+1
	;SS beyond 6 are always displayed as Values rather than notes
	cmp #6
	lda #0
	ror
	lsr
	lsr
	ora #128
rent1	ora #00
	sta TrackProperty,x
skip2	inx
	cpx #8
	bcc loop1

skip3	;Update Pattern Legend with the latest information
.)
	lda #<peLegend+1
	sta screen
	lda #>peLegend+1
	sta screen+1
	ldx #7
.(
loop1	txa
	sta vector1+1
	asl
	asl
vector1	adc #00
	tay
	lda TrackProperty,x
	bmi skip2
	;Display Rest
	lda #"R"
	sta peLegend+1,y
	lda #"E"
	sta peLegend+2,y
	lda #"S"
	sta peLegend+3,y
	lda #"T"
	sta peLegend+4,y
	jmp skip1
skip2	;Display Pattern
	lda CurrentPattern,x
	stx Temp01
	jsr AltPlotInversed3DD
	ldx Temp01
	;Display SS (Physical source)
	sty Temp01
	lda TrackProperty,x
	asl
	bmi skip4
	lsr
	and #31
	tay
	lda SS2PhysicalCharacter,y
	jmp skip3
skip4	lda #"m"
skip3	ldy Temp01
	sta (screen),y
skip1	dex
	bpl loop1
.)	
	;Update SFX Number with current entry in Pattern
	jsr peFetchEntryData
	lda PatternEntryType
	cmp #1
.(
	bne skip1	;NonNoteEntry
	lda PatternEntrySFX
	sta SFXNumber
skip1	rts
.)
	

	
	
SS2PhysicalCharacter
 .byt "ABCABCEEEEEEENNN"
 .byt "NNNNABCABCZABC--"
	
	

;A Rules
; B0 Permit Punctuations
; B1 Permit Spaces
; B2 Permit Numbers
; B7 Inverse mode - Characters appear inverted and cursor appears non-inverted
;X Number of characters to allow input of 
;Y Combined with Screen sets the leftmost character to begin input from
;Returns
;Text is returned in ipInputBuffer and the end of input can be read from ipCursorX-1
GenericInput
	sta ipRules
	and #128
	sta ipInverseMode
	stx ipMaxLength
	sty ipScreenIndex
	lda #00
	sta ipCursorX
	;Clear out input Buffer
ipRent1
.(
loop2	jsr ipPlotCursor
loop1	;Clear out input buffer (Do not permit repeat)
	lda HardKeyRegister
	bne loop1
loop4	lda HardKeyRegister
	beq loop4
	
	sta ipNewCharacter
	jsr ipDeleteCursor
	
	; Check for return
	lda ipNewCharacter
	cmp #13
	beq ipEnd
	
	; Check for DEL
	cmp #127
	beq ipBackspace
	
	; Check for Abort
	cmp #27
	beq ipAbort
	
	; Check for valid Characters
	ldx #46
loop3	cmp ipValidCharacter,x
	beq skip1
	dex
	bpl loop3
	jmp loop2
skip1	ldy CharacterType,x
	lda CharacterTypeVectorLo,y
	sta vector1+1
	lda CharacterTypeVectorHi,y
	sta vector1+2
vector1	jsr $dead
	jmp loop2
.)
ipEnd
	clc
	rts
ipBackspace
	ldx ipCursorX
.(
	beq skip1
	dec ipCursorX
	dex
	lda #9
	sta ipInputBuffer,x
	jsr ipDisplayInputBuffer
skip1	jmp ipRent1
.)
ipAbort
	lda #00
	sta ipCursorX
	sec
	rts

ipProcSpace
	lda ipRules
	and #%00000010
.(
	beq skip1
	jmp ipProcLetter
skip1	rts
.)
ipProcPunctuation
	lda ipRules
	and #%00000001
.(
	beq skip1
	jmp ipProcLetter
skip1	rts
.)
ipProcNumeric
	lda ipRules
	and #%00000100
.(
	beq skip1
	jmp ipProcLetter
skip1	rts
.)
ipProcLetter
	lda ipCursorX
	cmp ipMaxLength
.(
	bcs skip1
	ldx ipCursorX
	lda ipNewCharacter
	sta ipInputBuffer,x
	inc ipCursorX
	jsr ipDisplayInputBuffer
skip1	rts
.)

ipPlotCursor
	lda ipScreenIndex
	clc
	adc ipCursorX
	tay
	lda ipInverseMode
	eor #128
	ora #9
	sta (screen),y
	rts
	
ipDeleteCursor
	lda ipScreenIndex
	clc
	adc ipCursorX
	tay
	lda #9
	ora ipInverseMode
	sta (screen),y
	rts

ipDisplayInputBuffer
	ldy ipScreenIndex
	ldx #00
.(
loop1	lda ipInputBuffer,x
	ora ipInverseMode
	sta (screen),y
	iny
	inx
	cpx ipCursorX
	bcc loop1
.)
	rts
	
	
	

	
	


