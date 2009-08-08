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
	
eeHome
	
	lda #00
	sta eeHighlightActive
	sta ListCursorRow
	rts
eeEnd
	lda #00
	sta eeHighlightActive
	lda #127
	sta ListCursorRow
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
	and #63
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

;0 New Music (Always set on Track A)
;   D-H  Name(13 Characters)
;   C0-7 Music Frac(0-255)
;1 End of Song
;   A3   Silence(1)
;   C0-6 Jump back(Loop) to Row (If 128 the no loop)
;2 Fade Music (Always set on Track A)
;   A3   In(0) or Out(1)
;   C0-7 Frac Rate over one pattern(0-255)
;3 Effect Settings
;   B0-1 IRQ Effect Speed (25Hz(0) 50Hz(1) 100Hz(2) 200Hz(3))
;   C0-7 Effect Frac Tempo(0-255)
;4 TimeSlot Behaviour
;   A5    Time Slot Behaviour(Shared Timeslot(0) or Normal(1))
;   C0-7  Time Slot Delay Frac (255 for maximum speed)
;5 Octave Settings
;   A3-5 Range of Octaves 0-4 1-5 2-6 3-7 4-8 5-9
;   C0-7 Channel Spread
;6 Resolution Settings
;   A3    Use 5 Bit Noise Resolution(0) or 7 Bit(1)
;   A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)
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
	; Combine back with original mask
vector1	ora #00
	;Fetch offset again
	ldy rwcByteOffset-1,x
skip3	; Store data byte
	sta eeRowData,y
	; Store Row into memory
	ldy ListCursorRow
	jmp eeStoreRowData
skip2	sec
	sbc rwcLSBBit-1,x
	jmp rent1
ModifyName
.)
	;Prompt for new name
	lda #<$bb80+80+40*12
	sta screen
	lda #>$bb80+80+40*12
	sta screen
	lda #1+2+4
	ldx #13
	ldy #11
	jsr GenericInput
.(
	bcs skip1
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


rwcByteOffset
 .byt 0,1,0,0,2,0
rwcByteMask
 .byt %11110111
 .byt %11111100
 .byt %11011111
 .byt %11000111
 .byt %00000000
 .byt %11101111
rwcByteBits
 .byt %00001000
 .byt %00000011
 .byt %00100000
 .byt %00111000
 .byt %11111111
 .byt %00010000
rwcLSBBit
 .byt %00001000
 .byt %00000001
 .byt %00100000
 .byt %00001000
 .byt %00000001
 .byt %00010000

	
;Combined eeDecrement above with eeIncrement to save some space

;eeDecrement
;	;Is the line a row wide command?
;	jsr IsRowWideListCommand
;.(
;	bcs skip2
;	
;	lda ListCursorX
;	and #1
;
;	beq skip1	;Decrement Pattern
;	;Decrement SS
;	lda eeListByte1
;	and #%11000000
;	sta vector1+1
;	lda eeListByte1
;	and #63
;	sec
;	sbc #1
;	and #63
;vector1	ora #00
;	sta eeListByte1
;	jmp eeStoreEntryData
;skip1	;Decrement Pattern
;	lda eeListByte0
;	sec
;	sbc #1
;	bcs skip3
;	; Is Mimic?
;	ldx eeListByte1
;	cpx #%01000000
;	bcs skip3
;	lda #126
;skip3	sta eeListByte0
;	jmp eeStoreEntryData
;skip2	jmp ModifyRWC
;.)		
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
	jmp ModifyRWC
.)
eeByteMask
 .byt 127
 .byt 128+64

eeCopyLast
	lda ListCursorRow
.(
	beq skip1
	dec ListCursorRow
	jsr eeFetchEntryData
	inc ListCursorRow
	jmp eeStoreEntryData
skip1	rts
.)

eeCopyNext
	lda ListCursorRow
	cmp #127
.(
	beq skip1
	inc ListCursorRow
	jsr eeFetchEntryData
	dec ListCursorRow
	jmp eeStoreEntryData
skip1	rts
.)
	
eeToggle
	rts
eeRest
	lda #127
	sta eeListByte0
eeRent1	lda #00
	sta eeListByte1
	jmp eeStoreEntryData

eePattern
	lda #00
eeRent3	sta eeListByte0
	jmp eeRent1
	
eeComMimicLeft
	lda #%01000000
eeRent2	sta eeListByte1
	lda #127
	sta eeListByte0
	jmp eeStoreEntryData

eeComMimicRight
	lda #%10000000
	jmp eeRent2


eeComNewSong
	jsr eeSetupCom
	lda #00
	jmp eeRent4
	
eeSetupCom
	ldy ListCursorRow 
	jsr eeFetchRowData
	; Fill last 14 bytes with 9
	lda #9
	ldx #13
.(
loop1	sta eeRowData+2,x
	dex
	bpl loop1
.)
	lda #%11000000
	sta eeRowData+1
	rts
	
eeComEndSong
	jsr eeSetupCom
	lda #1
eeRent4	sta eeRowData
	ldy ListCursorRow
	jmp eeStoreRowData
	
eeComFadeMusic
	jsr eeSetupCom
	lda #2
	jmp eeRent4
	
eeComLoopMusic
	jsr eeSetupCom
	lda #3
	jmp eeRent4

eeComSongBehaviour	 ;TimeSlot Behaviour
	jsr eeSetupCom
	lda #4
	jmp eeRent4

eeComNoteSettings	 ;Octave Settings   
	jsr eeSetupCom
	lda #5
	jmp eeRent4

eeComNoteBehaviour	 ;System Behaviour  
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
	;PrList pasting beyond entry 127
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
	;Grabbing an List row grabs just the row number
	lda ListCursorRow
	sta eeGrabbedRow
	;Displays the row number in status bar
	jmp eeDisplayStatus
eeDrop	ldy eeGrabbedRow
.(
	bmi skip1
	jsr eeFetchRowData
	ldy ListCursorRow
	jsr eeStoreRowData
skip1	rts
.)

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
	lda #00
	ldx eeRowData+15
	cpx #63
.(
	beq skip1
	lda #63
skip1	sta eeRowData+15
.)
	lda #00
	sta eeRowData+14
	jsr eeStoreRowData
	rts

