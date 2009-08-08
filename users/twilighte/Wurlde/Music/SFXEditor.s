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
	and #63
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
	;source does hold address but of row so must refetch
	ldx SFXNumber
	lda #00
	jsr CalcSFXAddress

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
	cpy #63
	bcs skip1
	ldy #01
	lda (source),y
	dey
	sta (source),y
skip1	rts
.)

seInsertGap
	lda SFXCursorRow
	cmp #63
.(
	bcs seGapReturn
	ldx SFXNumber
	lda #00
	jsr CalcSFXAddress
	;Insert row(Rest) in all active tracks and shift data down
	ldy #62	;Row
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
	lda #221
	sta (source),y
seGapReturn
	;Ensure that any loops that crossed this entry have their value updated

	
	rts

seDeleteGap
	lda SFXCursorRow
	cmp #63
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
	cpy #64
	bcc loop1
.)
	ldy #63
	lda #221
	sta (source),y
	;If entry 1 or 0 contains Loop then delete it
	ldy #01
.(
loop1	lda (source),y
	jsr seFetchEntryTypeIndex
	cpx #21
	beq skip1
	dey
	bpl loop1
	rts
skip1	lda #221
.)
	sta (source),y
	rts


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
	lda FirstRangeInGroup-19,y
	;Is this the loop command?
	cmp #222
.(
	bne skip1
	;Are we on entry zero? (Prevent)
	ldy SFXCursorRow
	beq skip2
skip1	ldy #00
	sta (source),y
skip2	rts
.)


seIncrement
	jsr FetchEntryRange	;into seRangeLo and seRangeHi and A==Current Value
	cpx #20
	beq seIncrementLoop
	cmp seRangeHi
.(
	bcs skip1
	adc #1
	jmp skip2
skip1	lda seRangeLo

skip2
.)
	sta (source),y
	rts
seIncrementLoop
	;Move loop pointer down rows (decrementing offset)
	sec
	sbc #1
	cmp seRangeLo
.(
	bcc skip1
	sta (source),y
skip1	rts
.)	

seDecrement
	jsr FetchEntryRange	;into seRangeLo and seRangeHi and A==Current Value
	cpx #20
	beq seDecrementLoop
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
seDecrementLoop
	;Move loop pointer up rows (incrementing offset)
	clc
	adc #1
	cmp seRangeHi
.(
	bcs skip1
	sta seTemp01
	;reduce value to 0-X
	sec
	sbc seRangeLo
	sta seTemp02
	;Then subtract from current row
	lda SFXCursorRow
	sec
	sbc seTemp02
	;Branch if it takes row before first
	beq skip1
	lda seTemp01
	sta (source),y
skip1	rts
.)	
	
seDeleteVal
	lda seHighlightActive
	bne DeleteHighlightedRange
	jsr FetchEntryRange	;into seRangeLo and seRangeHi and A==Current Value
	lda seRangeLo
	sta (source),y
	rts
DeleteHighlightedRange
	ldx SFXNumber
	lda #00
	jsr CalcSFXAddress
	ldy seHighlightRowStart
	lda #221
.(
loop1	sta (source),y
	iny
	cpy seHighlightRowEnd
	beq loop1
	bcc loop1
.)
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
	lda #63
	jmp seRent1
seCut	lda #128
	jmp seCopyRent
seCopy
	lda #00
seCopyRent
	sta seCopyType
	
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
	lda seCopyType
.(
	beq skip1
	;Cut area
	lda #221
	sta (source),y
skip1	lda #1
.)
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
	;Prevent pasting beyond entry 63
	lda pecCurrentRow
	cmp #64
	bcs skip1
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
	;Grab byte
	lda SFXCursorRow
	sta seGrabbedRow
	ldy #00
	lda (source),y
	sta seGrabbedEntry
	jmp seDisplayStatus

seDrop
	ldy #00
	lda seGrabbedEntry
	sta (source),y
	rts

sePlay
	;On Play we must first scan SFX and check no infinite loops exist
	;Infinite loops are ones where a delay does not exist within a loop.
	jsr ValidateCurrentSFX
.(
	bcs skip2
	;Check if Current pattern entry is note otherwise default C-3 15
	jsr peFetchEntryData
	lda PatternCursorX
	lsr
	lsr
	tax
	lda PatternEntryLongNote
	clc
	adc tl_CurrentOctaveRange,x
	
	ldy PatternEntryVolume
	ldx PatternEntryType
	cpx #1
	beq skip1
	lda #12*3
	ldy #15

skip1	;Play Effect
	sei
	sty prTrackVolume
	sta prTrackNote
	jsr ConvertToPitch
	sta prTrackPitchLo
	sty prTrackPitchHi
	lda #00
	sta prActiveTracks_Sharing
	sta prActiveTracks_Mimicking
	sta prTrackSFXDelay
;	sta prBaseOctave
	sta prSFXIndex
	lda #1
	sta prActiveTracks_SFX
	sta prGlobalProperty
	;On storing a new SFX, reset Skip condition to unconditional
	lda #128
	sta prTrackSFXSkipCondition
	lda SFXNumber
	sta prTrackSFX
	cli
skip2	rts
.)

seNameSFX
	;Vanish cursor from entry by displaying effect again
	jsr SFXPlot
	;Locate SFX Name location in legend on screen
	ldy #1
	jsr CalcYLOC
	ldy #8
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

	
;Validate SFX runs through current SFX observing all the rules. If it hasn't reached End
;before a timeout of 256 it will declare an infinite loop

;Problem - A valid loop of the effect without an end causes "infinite loop" to be reported.
;The new procedure introduces an 'overall counter'(255>>0) to timeout and finish the Effect.
;We still use Infinite Counter but it is specifically reset to 15 whenever DELAY is used and
;will trigger 'Infinite loop' if it reaches 0. This means no single sequence of commands
;can exceed 15 steps(Otherwise infinity is reported).
ValidateCurrentSFX
	;Set Defaults for Simulation
	lda #15
	sta veVolume
	lda #00
	sta veCount
	lda #15
	sta veInfiniteCount
	lda #255
	sta veOverallCount
	lda #128
	sta veSkipCondition
	
	ldx SFXNumber
	lda #00
	jsr CalcSFXAddress
	ldy #00
.(
loop1	lda (source),y
	;Locate Type
	ldx #24
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
	;We use 2 counters to detect infinite looping
	;The first counts down from 15 to 0 (but is reset to 15 by DELAY)
	;(This prevents a sequence of more than 15 commands without delay)
	lda veInfiniteCount
	beq skip1
	dec veInfiniteCount
	;We then use a second that counts down from 255 to 0 and will Finish
	;the validation (successful) if reached. An END will also Finish it.
	lda veOverallCount
	beq Success
	dec veOverallCount
	bcs loop1
	;End Reached
Success	ldx #7+64+128
	clc
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
	cmp #2
.(
	bne skip1
	lda #128
skip1	sta veSkipCondition
.)
	jmp veContinue
veSetCount	;prProc_SFXSetCounter
	sta veCount
	jmp veContinue
veRNDDelay	;prProc_SFXRandomDelay
veSetDelay	;prProc_SFXDelay
	lda #15
	sta veInfiniteCount
	jmp veContinue
veSFXLoop
	;May depend on veSkipCondition
	ldx veSkipCondition
.(
	bmi JustLoop
	beq skip1
	;Check Counter
	ldx veCount
	bne JustLoop
	jmp veContinue
skip1	;Check volume
	pha
	lda prGlobalProperty
	and #BIT4
	cmp #BIT4
	pla
	bcc skip3
	
	ldx veVolume
	beq veContinue
	cpx #63
	bcs veContinue
	jmp JustLoop
	
skip3	ldx veVolume
	beq veContinue
	cpx #15
	beq veContinue
JustLoop	sta vector1+1
	tya
	clc
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