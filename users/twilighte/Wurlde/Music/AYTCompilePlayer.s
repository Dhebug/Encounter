;AYTCompilePlayer
;This program compiles the Player code based on the features and top frequency byte

 .zero
list
pattern
sfx
PATl	.dsb 2
PATh      .dsb 2
XATl      .dsb 2
XATh      .dsb 2
SATl      .dsb 2
SATh      .dsb 2

 .text

SetupPlayer
	;Set Up vectors
	lda #>CompiledMusicData
	sta zero+1
	lda #<CompiledMusicData
	sta zero
	ldy #00
	clc
	ldx #00
.(	
loop1	lda zero
	adc (zero),y
	sta PATl,x
	lda zero+1
	iny
	adc (zero),y
	sta PATl+1,x
	iny
	inx
	inx
	cpx #12
	bcc loop1
.)

	
	
	
	
	
	
;	 +00 Pattern Lo Address Offset Table Lo
;	 +01 Pattern Lo Address Offset Table Hi
;	 +02 Pattern Hi Address Offset Table Lo
;	 +03 Pattern Hi Address Offset Table Hi


IRQDriver
prPlayMusic
	;Backup Registers
	sta irqBackupA
	stx irqBackupX
	sty irqBackupY
	
	;Reset IRQ
	bit VIA_T1CL
	
	;run at 200hz
	inc IRQCounter	;0-255

	; Process Music(Pattern and List)
	;0 200Hz
	;1 100Hz
	;2 67Hz
	;3 50Hz
	;4 40Hz
	;5 33Hz
	;6 29Hz
	;7 25Hz
	dec prMusicFrequency
	bpl
	lda #
	sta prMusicFrequency
	
	lda prMusicFrequency
.(
	beq skip1
	and IRQCounter
	cmp prMusicFrequency
	bne skip2
skip1	jsr ProcMusic
skip2
.)
	; Process SFX(Updates Track Elements)
	lda prSFXFrequency
.(
	beq skip1
	and IRQCounter
	cmp prSFXFrequency
	bne skip2
skip1	jsr ProcSFX
skip2
.)
	; Process Tracks to Resources(Processes Timeslots)
	lda prTransferFrequency
.(
	beq skip1
	and IRQCounter
	cmp prTransferFrequency
	bne skip2
skip1	jsr TransferTrack2Resource
skip2
.)
	; Process Resolutions(Volume and Noise)
	lda prResolutionFrequency
.(
	beq skip1
	and IRQCounter
	cmp prResolutionFrequency
	bne skip2
skip1	jsr ProcResolutions
	; Send to Sound Chip
	jsr prSendAY
skip2
.)
	; Process Auxilliaries(Keyboard,Counters)
	lda IRQCounter
	;Always at 25Hz
	and #7
	cmp #7
.(
	bne skip1
	jsr ScanKeyboard
	jsr ProcessKeyboard
	jsr ControlCounter
skip1
.)
	ldx irqBackupX
	ldy irqBackupY
	lda irqBackupA
	rti

	
prProcPattern
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
	ldy prTrackPattern,x
	lda (PATl),y
	sta pattern
	lda (PATh),y
	sta pattern+1
	ldy prPatternIndex,x
	
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

	; Branch on DVS
	ldy prTrackSS,x
	cpy #20
	bcc skip1
	jmp prProcessDVS
skip1	; Branch on Pitch held Entry
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
	; If Track is DVS turn off DVS (by redirecting jmp to RTI)
	lda prTrackSS,x
	cmp #20
	bcs prProcRest
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

