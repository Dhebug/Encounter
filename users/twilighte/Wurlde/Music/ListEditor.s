;ListEditor.s


 
eeNavTrackLeft
	lda #00
	sta eeHighlightActive
	lda ListCursorX
	sec
	sbc #2
.(
	bcc skip1
	sta ListCursorX
skip1	rts
.)
eeNavTrackRight
	lda #00
	sta eeHighlightActive
	lda ListCursorX
	clc
	adc #2
	cmp #16
.(
	bcs skip1
	sta ListCursorX
skip1	rts
.)

eeNavLeft
	lda #00
	sta eeHighlightActive
	; Is this a row wide command?
	jsr IsRowWideCommand
	bcs MoveRWCCursor
	lda ListCursorX
	sec
	sbc #1
	and #15
	sta ListCursorX
	rts

MoveRWCCursor
	lda RWCListCursorX
	eor #1
	sta RWCListCursorX
	rts

eeNavRight
	lda #00
	sta eeHighlightActive
	; Is this a row wide command?
	jsr IsRowWideCommand
	bcs MoveRWCCursor
	lda ListCursorX
	clc
	adc #1
	and #15
	sta ListCursorX
	rts
eeNavUp
	lda #00
	sta eeHighlightActive
	lda ListCursorRow
	sec
	sbc #1
	and #127
	sta ListCursorRow
	rts
eeNavDown
	lda #00
	sta eeHighlightActive
	lda ListCursorRow
	clc
	adc #1
	and #127
	sta ListCursorRow
	rts

eeToggleBlue
	lda eeBlueRow
	eor #128
	sta eeBlueRow
	rts
	

eeFetchEntryData
	lda ListCursorX
	lsr
	tax
	lda ListCursorRow
	jsr CalcListAddress
	ldy #00
	lda (source),y
	sta eeListByte0
	iny
	lda (source),y
	sta eeListByte1
	rts
eeStoreEntryData
	lda ListCursorX
	lsr
	tax
	lda ListCursorRow
	jsr CalcListAddress
	ldy #00
	lda eeListByte0
	sta (source),y
	iny
	lda eeListByte1
	sta (source),y
	rts
	
eeNavPU
	lda #00
	sta eeHighlightActive
	lda ListCursorRow
	sec
	sbc #10
.(
	bcs skip1
	lda #00
skip1	sta ListCursorRow
.)
	rts
eeNavPD
	lda #00
	sta eeHighlightActive
	lda ListCursorRow
	clc
	adc #10
.(
	bpl skip1
	lda #127
skip1	sta ListCursorRow
.)
	rts
	
eeIncrement
	lda #1
	jmp eeRent5
eeDecrement
	lda #255
eeRent5	sta eeTemp01
	;Is the line a row wide command?
	jsr IsRowWideListCommand
.(
	bcs skip2
	
	lda ListCursorX
	and #1

	beq skip1	;IncrementPattern
	;Increment SS
	lda eeListByte1
	and #%11000000
	sta vector1+1
	lda eeListByte1
	and #63
	clc
	adc eeTemp01
	bpl skip4
	lda #19
	jmp vector1
skip4	;Prevent incrementing beyond 19
	cmp #20
	bcc vector1
	lda #00
vector1	ora #00
	sta eeListByte1
	jmp eeStoreEntryData
skip1	;Increment Pattern
	lda eeListByte0
	clc
	adc eeTemp01
	cmp #127
	bcc skip3
	; Is Mimic?
	ldx eeListByte1
	cpx #%01000000
	bcs skip3
	lda #00
skip3	sta eeListByte0
	jmp eeStoreEntryData
skip2	;Row Wide Command
	jmp ModifyRWC
.)		


;0 New Music (Always set on Track A)				Defaults
;   D-H  Name(13 Characters)					Spaces(32)
;   C0-7 Music Delay(0-20 Typically)				10
;1 End of Song
;   A3   Silence(1)						1
;   C0-6 Jump back(Loop) to Row (If 0 the no loop)		0
;2 Fade Music (Always set on Track A)
;   A3   In(0) or Out(1)					1
;   C0-7 Frac Rate over one pattern(0-255)			10
;3 SFX Settings
;   B0-1 IRQ SFX Rate (25Hz(0) 50Hz(1) 100Hz(2) 200Hz(3))		1
;   C0-1 IRQ Digidrum Rate (500Hz(0) 1KHz(1) 2KHz(2) 3KHz(3))	2
;4 Sharing Behaviour
;   A5    Time Slot Behaviour(Shared Timeslot(0) or Normal(1))	1
;   C0-7  Time Slot Delay					0
;5 Octave Settings
;   D0-5 Range of Notes C-0 to D#5				2
;   C0-7 Channel Spread					0
;6 Resolution Settings
;   A3    Use 5 Bit Noise Resolution(0) or 7 Bit(1)		0
;   A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)		0
;7 Spare
;  -
;B0-3 Parameter0
;   Name 0
;   A3   1
;   B0-1 2
;   A5   3
;   A3-5 4
;B4-7 Parameter1
;   C0-7 5
;   A4   6
ListCommandInfo
 .byt 5*16
 .byt 1+5*16
 .byt 1+5*16
 .byt 2+5*16
 .byt 3+5*16
 .byt 4+5*16
 .byt 1+6*16
 .byt 1+5*16	;This is the spare one
 

;Modify Row Wide command
;A Decrement(255) or Increment(1) or Toggle/Change(0)
;RWCListCursorX
ModifyRWC
	;Capture this rows data into eeRowData(16)
	ldy ListCursorRow
	jsr eeFetchRowData
	;Fetch command ID
	lda eeRowData
	and #7
	tax
	sta eeTemp02
	;Fetch Info Byte
	lda ListCommandInfo,x
	;Extract Nibble appropriate to Parameter
	ldy RWCListCursorX
.(
	beq skip1
	lsr
	lsr
	lsr
	lsr
skip1	and #15
	;Branch if Song Name Field
	beq ModifyName
	; Fetch Data
	tax
	ldy rwcByteOffset-1,x
	lda eeRowData,y
	; Store Mask
	and rwcByteMask-1,x
	sta vector1+1
	; Was Toggle expected?
	lda eeTemp01
	beq skip3
	; Get data again
	lda eeRowData,y
	; Extract bits
	and rwcByteBits-1,x
	; Was Decrement expected?
	ldy eeTemp01
	bmi skip2
	; Add Bit
	clc
	adc rwcLSBBit-1,x
rent1	; Mask again to remove any overflow
	and rwcByteBits-1,x
;	; Protect Octave Range exceeding 8
;	jsr LimitOctaveRange
	; Combine back with original mask
vector1	ora #00
	;Fetch offset again
	ldy rwcByteOffset-1,x
skip3	; Store data byte
	sta eeRowData,y
	
	; Protect against Looping to same row
	; Is mod to END SONG RWC?
	lda eeTemp02
	cmp #1
	bne skip4
	; Is Mod to Loop Field?
	lda RWCListCursorX
	beq skip4
	; Is Loop position 0?
	lda eeRowData+2
	and #127
	beq skip4
	; Is Loop position same as current row?
	cmp ListCursorRow
	bne skip4
	; Was key Reset/Toggle?
	ldy eeTemp01
	beq skip4
	; Was key dec?
	bmi skip6
	; Key was inc - add 1
	adc #00
	jmp skip5
skip6	; Key was dec - sub 1
	sbc #1
skip5	sta eeRowData+2

skip4	; Store Row into memory
	ldy ListCursorRow
	jmp eeStoreRowData
skip2	sec
	sbc rwcLSBBit-1,x
	jmp rent1
ModifyName
.)
	;Refresh list to remove wide cursor
	jsr ListPlot
	;Prompt for new name
	lda #<$bb80+80+40*12
	sta screen
	lda #>$bb80+80+40*12
	sta screen+1
	lda #1+2+4
	ldx #13
	ldy #12
	jsr GenericInput
.(
	bcs skip1
	;Fetch row data again (listplot would have corrupted it)
	ldy ListCursorRow
	jsr eeFetchRowData
	;Copy inputted name to row Data
	ldx #00
loop1	lda ipInputBuffer,x
	sta eeRowData+3,x
	inx
	cpx ipCursorX
	bcc loop1
loop2	;Clear to eol
	cpx #13
	bcs skip2
	lda #9
	sta eeRowData+3,x
	inx
	jmp loop2
skip2	;Store row data to List memory
	ldy ListCursorRow
	jmp eeStoreRowData
skip1	rts
.)
	
;LimitOctaveRange
;	;Is Octave RWC?
;	cpx #4
;.(
;	bne skip1
;	; Is Octave Range field?
;	ldy RWCListCursorX
;	bne skip1
;	; Is Range beyond 4-8(?
;	cmp #8*5
;	bcc skip1
;	; Reset to 0-4
;	lda #00
;skip1	rts
;.)


rwcByteOffset
 .byt 0,1,0,3,2,0
rwcByteMask
 .byt %11110111
 .byt %11111100
 .byt %11011111
 .byt %11000000
 .byt %00000000
 .byt %11101111
rwcByteBits
 .byt %00001000
 .byt %00000011
 .byt %00100000
 .byt %00111111
 .byt %11111111
 .byt %00010000
rwcLSBBit
 .byt %00001000
 .byt %00000001
 .byt %00100000
 .byt %00000001
 .byt %00000001
 .byt %00010000

eeReset
	;Is the line a row wide command?
	jsr IsRowWideListCommand
.(
	bcs skip2
	
	lda ListCursorX
	and #1
	tax
	lda eeListByte0,x
	and eeByteMask,x
	sta eeListByte0,x
	jmp eeStoreEntryData
skip2	lda #00
	sta eeTemp01
	jmp ModifyRWC
.)
eeByteMask
 .byt 127
 .byt 128+64

eeCopyLast
	lda ListCursorRow
.(
	beq skip1
	tay
	dey
	jsr eeFetchRowData
	ldy ListCursorRow
	jsr eeStoreRowData
skip1	rts
.)

eeCopyNext
	lda ListCursorRow
	cmp #127
.(
	beq skip1
	tay
	iny
	jsr eeFetchRowData
	ldy ListCursorRow
	jsr eeStoreRowData
skip1	rts
.)
	
eeToggle
	;Is the line a row wide command?
	jsr IsRowWideListCommand
.(
	bcc skip1
	lda #00
	sta eeTemp01
	jmp ModifyRWC
skip1	rts
.)

eeRest
	jsr IsRowWideCommand
.(
	bcc skip1
	;Reset Row to Tracks
	jsr ResetRow2Tracks
skip1	lda #127
.)
	sta eeListByte0
eeRent1	lda #00
	sta eeListByte1
	jmp eeStoreEntryData

eePattern
	jsr IsRowWideCommand
.(
	bcc skip1
	;Reset Row to Tracks
	jsr ResetRow2Tracks
skip1	lda #00
.)
eeRent3	sta eeListByte0
	jmp eeRent1

ResetRow2Tracks
	ldy #15
.(
loop1	lda DefaultTrackRow,y
	sta eeRowData,y
	dey
	bpl loop1
.)
	ldy ListCursorRow
	jmp eeStoreRowData
	
eeComMimicLeft
	lda #%01000000
eeRent2	sta eeListByte1
	lda #127
	sta eeListByte0
	jmp eeStoreEntryData

eeComMimicRight
	lda #%10000000
	jmp eeRent2

;0 New Music (Always set on Track A)				Defaults
;   D-H  Name(13 Characters)					Spaces(32)
;   C0-7 Music Delay(0-20 Typically)				10
eeComNewSong
	jsr eeSetupCom
	;Set default name
	ldx #12
	lda #32
.(
loop1	sta eeRowData+3,x
	dex
	bpl loop1
.)
	;Set default tempo
	lda #10
	sta eeRowData+2
	
	lda #00
	jsr eeRent4
	jmp TrackList
	
eeSetupCom
	ldy ListCursorRow 
	jsr eeFetchRowData
	lda #%11000000
	sta eeRowData+1
	jmp eeRent6
	
;1 End of Song
;   A3   Silence(1)						1
;   C0-6 Jump back(Loop) to Row (If 0 the no loop)		0
eeComEndSong
	jsr eeSetupCom
	lda #0
	sta eeRowData+2
	lda #1+BIT3
eeRent4	sta eeRowData
eeRent6	ldy ListCursorRow
	jmp eeStoreRowData
	
;2 Fade Music (Always set on Track A)
;   A3   In(0) or Out(1)					1
;   C0-7 Frac Rate over one pattern(0-255)			10
eeComFadeMusic
	jsr eeSetupCom
	lda #10
	sta eeRowData+2
	lda #2+BIT3
	jmp eeRent4
	
;3 SFX Settings
;   B0-1 IRQ SFX Rate (25Hz(0) 50Hz(1) 100Hz(2) 200Hz(3))		1
;   C0-1 IRQ Digidrum Rate (500Hz(0) 1KHz(1) 2KHz(2) 3KHz(3))	2
eeComIRQRates
	jsr eeSetupCom
	lda #%11000001
	sta eeRowData+1
	lda #2
	sta eeRowData+2
	lda #3
	jmp eeRent4

;4 Sharing Behaviour
;   A5    Time Slot Behaviour(Shared Timeslot(0) or Normal(1))	1
;   C0-7  Time Slot Delay					0
eeComSharing	 ;TimeSlot Behaviour
	jsr eeSetupCom
	lda #0
	sta eeRowData+2
	lda #4+BIT5
	jmp eeRent4

;5 Octave Settings
;   A3-5 Range of Octaves 0-4 1-5 2-6 3-7 4-8 5-9			2
;   C0-7 Channel Spread					0
eeComOctaveRange	 ;Octave Settings   
	jsr eeSetupCom
	lda #0
	sta eeRowData+2
	lda #5+BIT4
	jmp eeRent4

;6 Resolution Settings
;   A3    Use 5 Bit Noise Resolution(0) or 7 Bit(1)		0
;   A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)		0
eeComResolutions	 ;System Behaviour  
	jsr eeSetupCom
	lda #6
	jmp eeRent4

eeHilightDown
	lda eeHighlightActive
	beq eeInitialiseHighlighting
	;Do not allow highlighting for more than 64 rows (1024/16)
	lda eeHighlightRowEnd
	sec
	sbc eeHighlightRowStart
	cmp #63
.(
	bcs skip1
	jsr eeNavDown
	lda #01
	sta eeHighlightActive
	lda ListCursorRow
	sta eeHighlightRowEnd
skip1	rts
.)

eeHilightUp
	;Is Highlight active?
	lda eeHighlightActive
.(
	beq skip1
	
	;Does move make Pattern Cursor above Highlight start row?
	jsr eeNavUp
	lda #01
	sta eeHighlightActive
	lda ListCursorRow
	cmp eeHighlightRowStart
	bcc eeDeactivateHighlighting
	sta eeHighlightRowEnd
skip1	rts
.)

eeInitialiseHighlighting
	;Store Current Row
	lda ListCursorRow
	sta eeHighlightRowStart
	sta eeHighlightRowEnd
	lda #01
	sta eeHighlightActive
	rts


eeDeactivateHighlighting
	lda #00
	sta eeHighlightActive
	rts

eeCopy
	lda #00
eeCopy2Buffer
	sta eeTransferType
	lda eeHighlightActive
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
	lda eeHighlightRowStart
	sta eeCopyRowStart
	lda eeHighlightRowEnd
	sta eeCopyRowEnd
	
	;Copy area
	ldy eeHighlightRowStart
loop1	jsr eeFetchStoreHilightedEntry
	iny
	cpy eeHighlightRowEnd
	beq loop1
	bcc loop1

	;Display Copied and clear previous
	ldx #1
	ldy #27
	lda #1+DSM_CLEARPREVIOUS+DSM_INVERT
	jsr DisplaySimpleMessage
	;Dehighlight area
	lda #00
	sta eeHighlightActive
	;Set copy buffer to Pattern data
	lda CurrentEditor
	sta CopyEditor
	sec
skip1	rts
.)
eeCut	lda #01
	jmp eeCopy2Buffer

eeFetchStoreHilightedEntry
	sty eeTempY
	tya
	jsr CalcListRowAddress
	ldy #15
.(
loop1	lda (source),y
	sta (copy),y
	lda eeTransferType
	beq skip3
	lda eeRestedRow,y
	sta (source),y
skip3	dey
	bpl loop1
	;Update copy address
	lda #16
	jsr Add_Copy
	lda #16
	jsr Add_CopyCount
	ldy eeTempY
.)
	rts
	
eePaste
	lda CopyByteCount	
.(
	bne skip2
	lda CopyByteCount+1
	beq skip1
skip2	lda CopyEditor
	cmp CurrentEditor
	bne skip1
	
	;Setup for copying
	jsr SetupCopyBuffer

	lda ListCursorRow
	sta pecCurrentRow

	ldy eeCopyRowStart

loop1	lda pecCurrentRow
	jsr eeTransferCopyBufferRow
	inc pecCurrentRow
	;Prevent pasting beyond entry 127
	lda pecCurrentRow
	bmi skip1
	iny
	cpy eeCopyRowEnd
	beq loop1
	bcc loop1
skip1	rts
.)

eeTransferCopyBufferRow
	sty eeTempY
	jsr CalcListRowAddress
	ldy #15
.(
loop1	lda (copy),y
	sta (source),y
	dey
	bpl loop1
	;Update copy address
	lda #16
	jsr Add_Copy
	ldy eeTempY
.)
	rts

eeGrab
	;Is RWC?
	jsr IsRowWideCommand
.(
	bcs skip1
	;Capture Track
	lda ListCursorX
	and #%1110
	tay
	lda eeRowData,y
	sta eeGrabbedEntry
	lda eeRowData+1,y
	sta eeGrabbedEntry+1
	lda #1
	sta eeGrabbedEntryType
	jmp eeDisplayStatus
skip1	ldy #15
loop1	lda eeRowData,y
	sta eeGrabbedEntry,y
	dey
	bpl loop1
.)
	lda ListCursorRow
	sta eeGrabbedRow
	lda #2
	sta eeGrabbedEntryType
	jmp eeDisplayStatus
	

eeDrop	lda eeGrabbedEntryType
.(
	beq skip1
	cmp #1
	bne skip2
	jsr IsRowWideCommand
	bcs skip1
	lda ListCursorX
	and #%1110
	tay
	lda eeGrabbedEntry
	sta eeRowData,y
	lda eeGrabbedEntry+1
	sta eeRowData+1,y
	ldy ListCursorRow
	jmp eeStoreRowData
skip1	rts
skip2	ldy #15
loop1	lda eeGrabbedEntry,y
	sta eeRowData,y
	dey
	bpl loop1
.)
	ldy ListCursorRow
	jmp eeStoreRowData

eeInsertGap
	;Inserting a gap involves shifting data from the end of the Lists to the
	;current entry then writing rests to the current entry
	lda ListCursorRow
	cmp #127
.(
	bcs skip1
	ldy #126
loop1	jsr eeFetchRowData
	iny
	jsr eeStoreRowData
	dey
	dey
	bmi skip2
	cpy ListCursorRow
	bcs loop1
skip2	lda ListCursorRow
	jsr CalcListRowAddress
	jmp eeWipeRow
skip1	rts
.)
	
eeDeleteGap
	;Deleting a gap involves shifting data from the current List row to the
	;end of the Lists then writing rests to the last row
	lda ListCursorRow
	cmp #127
.(
	bcs skip1
	tay
	iny
loop1	jsr eeFetchRowData
	dey
	jsr eeStoreRowData
	iny
	iny
	bpl loop1
	lda #127
	jsr CalcListRowAddress
	jmp eeWipeRow
skip1	rts
.)


eeWipeRow
	ldy #15
.(
loop1	lda eeRestedRow,y
	sta (source),y
	dey
	bpl loop1
.)
	rts

eeRestedRow
 .byt 127,0
 .byt 127,0
 .byt 127,0
 .byt 127,0
 .byt 127,0
 .byt 127,0
 .byt 127,0
 .byt 127,0
eeRowData
 .dsb 16,0

eeCommandH
	ldy ListCursorRow
	jsr eeFetchRowData
	;Ensure we don't bugger data if RWC
	lda eeRowData+1
	cmp #%11000000
.(
	bcs skip2
	lda #00
	ldx eeRowData+15
	cpx #63
	beq skip1
	;Only Assign free Pattern to Track if it was a rest before
	lda eeRowData+14
	cmp #127
	bne skip3

	jsr LocateFreePattern
	bcs skip3
	;4)Drop into Tracks Pattern Field
	pha
	ldy ListCursorRow
	jsr eeFetchRowData
	pla
	sta eeRowData+14
	pha
	lda #63
	sta eeRowData+15
	ldy ListCursorRow
	jsr eeStoreRowData
	pla
	jmp DeletePattern
skip3	lda #63
skip1	sta eeRowData+15
	lda #127
	sta eeRowData+14
skip4	ldy ListCursorRow
	jsr eeStoreRowData
skip2	rts
.)

leSongPrevious
	jsr TrackList
	lda tlUltimateSong
.(
	bpl skip3
	rts
skip3	dec CurrentSong
	bpl skip1
skip2	lda tlUltimateSong
	sta CurrentSong
	jmp LoadSongIndex
skip1	lda CurrentSong
	cmp tlUltimateSong
	beq LoadSongIndex
	bcs skip2
.)
LoadSongIndex
	;Now load index pointer
	tax
	lda SongStartIndex,x
	sta ListCursorRow
	;Now update Song shown in Menu
	rts
	
leSongNext
	jsr TrackList
	lda tlUltimateSong
.(
	bpl skip1
	rts
skip1	inc CurrentSong
.)
	lda CurrentSong
	cmp tlUltimateSong
	beq LoadSongIndex
	bcc LoadSongIndex
	lda #00
	sta CurrentSong
	jmp LoadSongIndex
	
eeAutoAssignPatterns
	;This is a little more complex than originally envisaged.
	;1)Ensure this row is Track Row
	ldy ListCursorRow
	jsr eeFetchRowData
	lda eeRowData+1
	and #%11000000
	cmp #%11000000
.(
	bcs skip1
	jsr LocateFreePattern
	bcs skip1
	;4)Drop into Tracks Pattern Field
	pha
	ldy ListCursorRow
	jsr eeFetchRowData
	lda ListCursorX
	and #14
	tax
	pla
	sta eeRowData,x
	pha
	;5)Ensure Tracks command is not mimic
	lda eeRowData+1,x
	and #63
	sta eeRowData+1,x
	ldy ListCursorRow
	jsr eeStoreRowData
	;Now delete Pattern
	pla
	jmp DeletePattern
skip1	rts
.)

DeletePattern
	lsr
	pha
	;Move Carry into B7 (0 or 128)
	lda #00
	ror
	sta source
	pla
	;Add Base address of Patterns
	adc #>PatternMemory
	sta source+1
	ldy #127
	lda #61*4
.(
loop1	sta (source),y
	dey
	bpl loop1
.)
	rts
LocateFreePattern
	;2)Track all List rows and flag Pattern Usage to bit table
	ldy #15
	lda #00
.(
loop1	sta PatternUsageBitTable,y
	dey
	bpl loop1
.)
	ldy #00
.(
loop1	jsr eeFetchRowData
	lda eeRowData+1
	and #%11000000
	cmp #%11000000
	bcs skip1
	;Scan each Track
	ldx #0
loop2	lda eeRowData,x
	and #127
	cmp #127
	bcs skip2
	;Flag Bit Table
	
	sty Temp01
	and #7
	tay
	lda Bitpos,y
	pha
	lda eeRowData,x
	lsr
	lsr
	lsr
	tay
	pla
	ora PatternUsageBitTable,y
	sta PatternUsageBitTable,y
	ldy Temp01
	
skip2	inx
	inx
	cpx #16
	bcc loop2
skip1	iny
	bpl loop1
.)	

	;3)Locate first Unused Pattern
	ldy #00
.(
loop2	lda PatternUsageBitTable,y
	cmp #255
	bcc skip2
	iny
	cpy #16
	bcc loop2
	jmp skip1	;Abort
skip2	;Locate Pattern in Bit Table Byte
	tya
	asl
	asl
	asl
	sta Temp01
	lda PatternUsageBitTable,y
	sty Temp02
	ldy #00
loop3	pha
	and Bitpos,y
	beq skip3
	pla
	iny
	cpy #8
	bcc loop3
	;Abort - This should never happen because we've already established
	;        that there is a bit not set here
skip1	rts
skip3     ;Place Free Pattern ID in A
.)
	pla
	tya
	clc
	adc Temp01
	clc
	rts

	
	
	