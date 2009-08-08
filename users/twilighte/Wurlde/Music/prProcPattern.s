;prProcPattern.s


;prProcPattern which can progress to prProcList
prProcPattern
	;
	lda #00
	sta prNextEntryIsBarFlag
	
	ldx #0
.(	
loop1	;Is Track muted?
	lda Bitpos,x
	and prActiveTracks_NotMuted
	and prActiveTracks_Pattern
	bne skip6
	jmp skip2
skip6	; Calc Pattern Address(64x2xPattern)
	lda prTrackPattern,x
	lsr
	pha
	lda #00
	ror
	sta pattern
	pla
	adc #>PatternMemory
	sta pattern+1
	ldy prPatternIndex	;0-127 step2
	
	; Branch if Channel H and Command
	cpx #7
	bcc skip3
	lda prGlobalProperty
	asl
	bpl skip3
	jsr ProcessCommandTrackH
	jmp skip2
	
skip3	; Is this a Rest, VRest or Bar?
	lda (pattern),y
	lsr
	lsr
	cmp #61
	bcs skip1

	; Extract Note Data
	lda #00
	sta prTrackVolume,x
	lda (pattern),y
	lsr
	rol prTrackVolume,x
	lsr
	rol prTrackVolume,x
	sta prTrackNote,x
	pha
	iny
	lda (pattern),y
	lsr
	rol prTrackVolume,x
	lsr
	rol prTrackVolume,x

	sta prTrackSFX,x
	
	;On storing a new SFX, reset Skip condition to unconditional
	lda #128
	sta prTrackSFXSkipCondition,x
	
	;If Track is EG then Volume is Wave Code
	lda prTrackSS,x
	cmp #6
	bcc skip5
	cmp #13
	bcs skip4
	;Transfer Volume to Wave
	lda prTrackVolume,x
	ora #128
	sta AY_Cycle
	;Reset Volume to 15
	lda #15
	sta prTrackVolume,x
	jmp skip4
	
skip5	;Shift volume if higher res
	lda prGlobalProperty
	and #BIT4
	beq skip4
	asl prTrackVolume,x
	asl prTrackVolume,x
skip4	pla
	clc
skip1	jsr prProcPatternEntry

	;Check if next note is a BAR
	ldy prPatternIndex
	iny
	iny
	lda (pattern),y
	and #%11111100
	cmp #%11111100
	bne skip2
	inc prNextEntryIsBarFlag
	
skip2	inx
	cpx #8
	bcs skip10
	jmp loop1
skip10
.)
	;Once a Complete Pattern Row has been processed proceed to the next Row
	inc prPatternIndex
	inc prPatternIndex
.(	
	;Check for natural Bar(at entry 64)
	bmi skip2

	;Check for forced Bar(set in a pattern)
	lda prNextEntryIsBarFlag
	beq skip1
skip2	jmp prProcList
skip1	rts
.)

;Carry is set if the Entry is a Bar, Rest or VRest
prProcPatternEntry
	;Branch on LnNote Type
.(
	bcs prProcRest
	;It should never reach this point since Bars are picked up in parent
prProcNote
	pha
	;On next note 
	lda prActiveTracks_Pitchbend
	and BitposMask,x
	sta prActiveTracks_Pitchbend
	
	;Capture current pitch (incase Track7 invokes a pitchbend)
	lda prTrackPitchLo,x
	sta prPitchbendLo,x
	lda prTrackPitchHi,x
	sta prPitchbendHi,x

	; Branch on Pitch held Entry
	lda prActiveTracks_Pitch
	and Bitpos,x
	bne prPitchHeldEntry
	pla
	; Add Base Octave
	adc prBaseOctave,x
	sta prTrackNote,x
	; Convert LnNote into Pitch (Placed in A(Lo) and Y(Hi))
	jsr ConvertToPitch
rent1	sta prTrackPitchLo,x
	tya
	sta prTrackPitchHi,x

	; Reset SFX Pointer
	lda #00
	sta prSFXIndex,x
	
	;Enable SFX in Track
	lda Bitpos,x
	ora prActiveTracks_SFX
	sta prActiveTracks_SFX
	rts
prPitchHeldEntry
	pla
	ldy #00
	jmp rent1

prProcRest
.)
	; This may be a Rest or a VRest
	cmp #62
.(
	bne prProcRest
prProcVRest
skip1	;Fetch Volume
	lda #00
	sta prTrackVolume,x
;	iny
	lda (pattern),y
	lsr
	rol prTrackVolume,x
	lsr
	rol prTrackVolume,x
	dey
	lda (pattern),y
	lsr
	rol prTrackVolume,x
	lsr
	rol prTrackVolume,x
	
	;If higher res then shift volume
	lda prGlobalProperty
	and #BIT4
	beq prProcRest
	asl prTrackVolume,x
	asl prTrackVolume,x
	
prProcRest
.)
	rts

