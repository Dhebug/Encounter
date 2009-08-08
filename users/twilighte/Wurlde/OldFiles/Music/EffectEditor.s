;seSFXEditor

seCalcCurrentSFXRowAddress
	ldx SFXNumber
	lda SFXCursorRow
	jmp CalcSFXAddress


seNavUp
	jsr seDeactivateHighlighting
	lda SFXCursorRow
	sec
	sbc #1
	jmp seNavCommon
seNavDown
	jsr seDeactivateHighlighting
	lda SFXCursorRow
	clc
	adc #1
seNavCommon
	and #127
	sta SFXCursorRow
	rts

seHome
	jsr seDeactivateHighlighting
	lda #00
	jmp seNavCommon
seEnd
	jsr seDeactivateHighlighting
	lda #127
	jmp seNavCommon
seLastEntry
	ldy SFXCursorRow
.(
	beq skip1
	dey
	lda (source),y
	iny
	sta (source),y
skip1	rts
.)
	
seNextEntry
	ldy SFXCursorRow
.(
	cpy #127
	bcs skip1
	iny
	lda (source),y
	dey
	sta (source),y
skip1	rts
.)

seInsertGap
	lda SFXCursorRow
	cmp #127
.(
	bcs seGapReturn
	ldx SFXNumber
	lda #00
	jsr CalcSFXAddress
	;Insert row(Rest) in all active tracks and shift data down
	ldy #126	;Row
loop1	lda (source),y
	iny
	sta (source),y
	dey
	dey
	bmi skip1
	cpy SFXCursorRow
	beq loop1
	bcs loop1
skip1	ldy SFXCursorRow
.)
seGapCommon
	lda #186
	sta (source),y
seGapReturn
	rts

seDeleteGap
	lda SFXCursorRow
	cmp #127
	bcs seGapReturn
	ldx SFXNumber
	lda #00
	jsr CalcSFXAddress
	;Delete row in all active tracks and shift data up(Storing rest in entry 63)
	ldy SFXCursorRow
	iny
.(
loop1	lda (source),y
	dey
	sta (source),y
	iny
	iny
	bpl loop1
.)
	ldy #63
	jmp seGapCommon


seDecSFX
	;We must check the current SFX is valid before proceding
	jsr ValidateCurrentSFX
	bcs seSkip1
	lda SFXNumber
	beq seSkip1
	dec SFXNumber
seRent2	jsr seUpdateLegend
	jsr seDisplayLegend
seSkip1	rts

seIncSFX
	;We must check the current SFX is valid before proceding
	jsr ValidateCurrentSFX
	bcs seSkip1
	lda SFXNumber
.(
	cmp #63
	bcs skip1
	inc SFXNumber
	jmp seRent2
skip1	rts
.)

;If the group of the selected command is already selected then progress to next range in group
;This reduces number of keys and amount of code and simplifies operation.
seCommand
;	nop
;	jmp seCommand
	stx seTemp01
	; Fetch existing entry
	ldy #00
	lda (source),y
	
	; Fetch existing entry type
	jsr seFetchEntryTypeIndex
	
	; A contains real range and X index
	ldy GroupPerKeyIndex,x

	; Is entry of same group as we are selecting?
	cpy seTemp01
.(
	bne skip1	;No Its Different
	
	; Is the next range within the same group?
	tya
	cmp GroupPerKeyIndex+1,x
	bne skip1
	
	; The next range is of the same group so just inc range 
	lda SFXRangeThreshold+1,x
	ldy #00
	sta (source),y
	rts

skip1	; The next range is of a different group so reset to the first range in the group
.)
	ldy seTemp01
	lda FirstRangeInGroup-14,y
	ldy #00
	sta (source),y
	rts

GroupPerKeyIndex
 .byt 14,14,15,15,16,16,17,17,18,18,19,20,21,22,22,23,24,24,25,26,27,28,28,28,28,28,29
FirstRangeInGroup
 .byt 0,50,100,130,162,178,180,182,184,186,187,192,202,222,247,252

seIncrement
	jsr FetchEntryRange	;into seRangeLo and seRangeHi and A==Current Value
	cmp seRangeHi
.(
	bcs skip1
	adc #1
	sta (source),y
	rts
skip1	lda seRangeLo
.)
	sta (source),y
	rts

seDecrement
	jsr FetchEntryRange	;into seRangeLo and seRangeHi and A==Current Value
	cmp seRangeLo
.(
	beq skip1
	sec
	sbc #1
	sta (source),y
	rts
skip1	lda seRangeHi
.)
	sta (source),y
	rts
seDeleteVal
	jsr FetchEntryRange	;into seRangeLo and seRangeHi and A==Current Value
	lda seRangeLo
	sta (source),y
	rts

seToggleVal
	jsr FetchEntryRange	;into seRangeLo and seRangeHi and A==Current Value
	cmp seRangeHi
.(
	beq skip1
	lda seRangeHi
	sta (source),y
	rts
skip1	lda seRangeLo
.)
	sta (source),y
	rts

FetchEntryRange	;into seRangeLo and seRangeHi and A==Current Value
;	nop
;	jmp FetchEntryRange
	ldy #00
	lda (source),y
	jsr seFetchEntryTypeIndex
	ldy SFXRangeThreshold,x
	sty seRangeLo
	ldy SFXRangeThreshold+1,x
	dey
	sty seRangeHi
	ldy #00
	lda (source),y
	rts
	
	
seHiliteDown
	lda seHighlightActive
	beq seInitialiseHighlighting
	;Do not allow highlighting for more than 64 rows (1024/16)
	lda seHighlightRowEnd
	sec
	sbc seHighlightRowStart
	cmp #63
.(
	bcs skip1
	jsr seNavDown
	jsr seActivateHighlight
	lda SFXCursorRow
	sta seHighlightRowEnd
skip1	rts
.)

seHighlightUp
	;Is Highlight active?
	lda seHighlightActive
.(
	beq skip1
	
	;Does move make Pattern Cursor above Highlight start row?
	jsr seNavUp
	jsr seActivateHighlight
	lda SFXCursorRow
	cmp seHighlightRowStart
	bcc seDeactivateHighlighting
	sta seHighlightRowEnd
skip1	rts
.)

seInitialiseHighlighting
	;Store Current Row
	lda SFXCursorRow
	sta seHighlightRowStart
seRent1	sta seHighlightRowEnd
seActivateHighlight
	lda #01
seHighlightRent1
	sta seHighlightActive
	rts


seDeactivateHighlighting
	lda #00
	jmp seHighlightRent1

seHighlightAll
	lda #00
	sta seHighlightRowStart
	lda #127
	jmp seRent1
seCopy
	lda seHighlightActive
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
	lda seHighlightRowStart
	sta seCopyRowStart
	lda seHighlightRowEnd
	sta seCopyRowEnd
	;Copy area
	ldy seHighlightRowStart
loop1	jsr seFetchStoreHilightedEntry
	iny
	cpy seHighlightRowEnd
	beq loop1
	bcc loop1

	;Display Copied and clear previous
	ldx #1
	ldy #27
	lda #1+DSM_CLEARPREVIOUS+DSM_INVERT
	jsr DisplaySimpleMessage
	;Dehighlight area
	lda #00
	sta seHighlightActive
	;Set copy buffer to Pattern data
	lda CurrentEditor
	sta CopyEditor
	sec
skip1	rts
.)

;Fetch from SFX Row Y and store in copybuffer(copy) and inc copy (don't corrupt Y)
seFetchStoreHilightedEntry
	ldx SFXNumber
	tya
	pha
	jsr CalcSFXAddress
	ldy #00
	lda (source),y
	sta (copy),y
	lda #1
	jsr Add_Copy
	lda #1
	jsr Add_CopyCount
	pla
	tay
	rts
	
	

sePaste
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

	lda SFXCursorRow
	sta pecCurrentRow

	ldy seCopyRowStart

loop1	lda pecCurrentRow
	jsr seTransferCopyBufferRow
	inc pecCurrentRow
	;Prevent pasting beyond entry 127
	lda pecCurrentRow
	bmi skip1
	iny
	cpy seCopyRowEnd
	beq loop1
	bcc loop1
skip1	rts
.)

seTransferCopyBufferRow
	sty seTemp01
	ldx SFXNumber
	jsr CalcSFXAddress
	ldy #00
	lda (copy),y
	sta (source),y
	lda #1
	jsr Add_Copy
	lda #1
	jsr Add_CopyCount
	ldy seTemp01
	rts

seGrab
seDrop
	rts
sePlay
	;On Play we must first scan SFX and check no infinite loops exist
	;Infinite loops are ones where a delay does not exist within a loop.
	jsr ValidateCurrentSFX
	
	
	rts

seNameSFX
	;Locate SFX Name location in legend on screen
	ldy #1
	jsr CalcYLOC
	ldy #31
	ldx #8
	lda #1+2+4+128
	jsr GenericInput
.(
	bcs skip1
	lda SFXNumber
	jsr CalcSFXNameAddress
	;Clear current name
	ldy #07
	tya
loop1	sta (source),y
	dey
	bpl loop1
	iny
loop2	lda ipInputBuffer,y
	sta (source),y
	iny
	cpy ipCursorX
	bcc loop2
	;Update Legend to reflect new name
	jsr seUpdateLegend
	jsr seDisplayLegend
skip1	rts
.)

	

ValidateCurrentSFX
	;Set Defaults for Simulation
	lda #15
	sta veVolume
	sta veCount
	lda #128
	sta veSkipCondition
	
	ldx SFXNumber
	lda #00
	jsr CalcSFXAddress
	ldy #00
.(
loop1	lda (source),y
	;Locate Type
	ldx #22
loop2	dex
	cmp prSFXCodeThreshhold,x
	bcc loop2
	; Reduce to Zero based
	sbc prSFXCodeThreshhold,x
	pha
		
	lda veSFXTypeVectorLo,x
	sta vector1+1
	lda veSFXTypeVectorHi,x
	sta vector1+2
	clc
	pla
	
vector1	jsr $dead
	inc veInfiniteCount
	beq skip1
	bcs loop1
	ldx #7+64+128
	jmp skip2
skip1	;Display Warning
	ldx #6+128
	sec
skip2	php
	ldy #27
	txa
	ldx #1
	jsr DisplaySimpleMessage
	plp
.)
	rts

veNoChange	;prProc_SFXNegativeNote
veContinue
	iny
	sec
veEndSFX	;prProc_SFXEndSFX
	rts
	
vePlusVol	;prProc_SFXPositiveVolume
	adc veVolume
	cmp #16
.(
	bcc skip1
	lda #15
skip1	sta veVolume
.)
	jmp veContinue
veMinusVol	;prProc_SFXNegativeVolume
.(
	sta vector1+1
	lda veVolume
vector1	sbc #00
	bcs skip1
	lda #00
skip1	sta veVolume
.)
	jmp veContinue
veSkipCond	;prProc_SFXSetSkipCondition
	sta veSkipCondition
	jmp veContinue
veRNDDelay	;prProc_SFXRandomDelay
veSetDelay	;prProc_SFXDelay
	lda #00
	sta veInfiniteCount
	jmp veContinue
veSetCount	;prProc_SFXSetCounter
	sta veCount
	jmp veContinue
veSFXLoop	;prProc_SFXLoop
	;May depend on veSkipCondition
	ldx veSkipCondition
.(
	bmi JustLoop
	beq skip1
	;Check Counter
	ldx veCount
	beq JustLoop
	jmp veContinue
skip1	;Check volume
	ldx veVolume
	bne veContinue
JustLoop	sta vector1+1
	tya
	sec
vector1	sbc #00
	tay
	;Update Counter
	lda veCount
	beq skip2
	dec veCount
skip2	sec
.)
	rts

veRNDVol	;prProc_SFXRandomVolume
	lda #7
	sta veVolume
	jmp veContinue