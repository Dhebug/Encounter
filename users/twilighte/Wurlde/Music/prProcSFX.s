;prProcSFX.s

;The other Timeslot rule which we did NOT invoke was whether an SFX should process a tracks
;volume and pitch outside of a timeslot. This could easily be done.

;ProcSFX
; ProcSFX has a dual purpose. In its simplest form it merely modifies Tracks volume and Pitch.
; In more advanced form it can modify any AY register independantly of any active Resource Sharing
prProcSFX
	;
	lda prGlobalProperty
	and #BIT5
.(
	beq skip1
	lda Bitpos,x
	and prActiveTracks_Sharing
	beq skip1
	ldy SharingGroup,x
	lda SharingIndex,y
	cmp SharingEntry,x

	bne skip2	;OutsideTimeslot
skip1	;Branch if delay has not expired
	lda prTrackSFXDelay,x
	beq skip3
	dec prTrackSFXDelay,x
	jmp skip2
skip3	;Calc SFX Address (SFX x 64)
	lda #00
	sta SFX
	lda prTrackSFX,x
	;Whilst we momentarily have SFX for track, check if matches current Editor
	;SFX and flag it so that we can track it
	cmp SFXNumber
	bne skip4
	sta tmTrackingSFX
	;And also store current SFX index
	ldy prSFXIndex,x
	sty tmTrackingSFXIndex
skip4	lsr
	ror SFX
	lsr
	ror SFX
	adc #>SFXMemory
	sta SFX+1
	;Fetch SFX Index
loop1	ldy prSFXIndex,x
	lda (SFX),y
	;Locate Type
	ldy #25
loop2	dey
	cmp prSFXCodeThreshhold,y
	bcc loop2
	; Reduce to Zero based
	sbc prSFXCodeThreshhold,y
	sta prTemp01
	
	lda prSFXTypeVectorLo,y
	sta vector1+1
	lda prSFXTypeVectorHi,y
	sta vector1+2
	;Set Registers as follows before calling SFX Command
	;X Track Index
	;A Value Range
	lda prTemp01
	sec
	
vector1	jsr $dead
	inc prSFXIndex,x
	bcs loop1
skip2	rts
.)

	

prStatusOn
	lda prAYStatusChannelBits,y
	eor #$FF
	and AY_Status
	sta AY_Status
	
	;Set carry to force loop in parent
	rts
prStatusOff
	lda AY_Status
	ora prAYStatusChannelBits,y
	sta AY_Status
	rts
	
prTurnEGFlagOn
	tya
	and #1
.(
	beq skip1
	lda AY_VolumeA
	ora #16
	sta AY_VolumeA
skip1	tya
	and #2
	beq skip2
	lda AY_VolumeB
	ora #16
	sta AY_VolumeB
skip2	tya
	and #4
	beq skip3
	lda AY_VolumeC
	ora #16
	sta AY_VolumeC
skip3
.)
	rts

prTurnEGFlagOff
	tya
	and #1
.(
	beq skip1
	lda AY_VolumeA
	and #15
	sta AY_VolumeA
skip1	tya
	and #2
	beq skip2
	lda AY_VolumeB
	and #15
	sta AY_VolumeB
skip2	tya
	and #4
	beq skip3
	lda AY_VolumeC
	and #15
	sta AY_VolumeC
skip3
.)
	rts
	
	
;Process prTrackVolume, prTrackPitchLo, prTrackPitchHi, prTrackNote with value held in prTemp01
;All commands are absolute ;) and Carry is Clear before entering
prProc_SFXPositivePitch
	adc prTrackPitchLo,x
	;Force 1 because value is 0-X
	sta prTrackPitchLo,x
.(
	bcc skip1
	inc prTrackPitchHi,x
skip1	sec
.)
	rts
	
prProc_SFXNegativePitch
	lda prTrackPitchLo,x
	clc
	sbc prTemp01
	sta prTrackPitchLo,x
.(
	bcs skip1
	dec prTrackPitchHi,x
skip1	sec
.)
	rts

;Note overrides/overwrites Pitch
prProc_SFXPositiveNote
	adc prTrackNote,x
ProcSFXNote
	and #127
	sta prTrackNote,x
	jsr ConvertToPitch
	sta prTrackPitchLo,x
	tya
	sta prTrackPitchHi,x
	sec
	rts
	
prProc_SFXNegativeNote
	lda prTrackNote,x
	clc
	sbc prTemp01
	jmp ProcSFXNote

prProc_SFXPositiveVolume
	;Volume depends on Resolution(15 or 63)
	ldy #15
	lda prGlobalProperty
	and #BIT4	;0/16
.(
	beq skip2
	ldy #63
skip2	sty vector1+1
	lda prTemp01
	adc prTrackVolume,x
vector1	cmp #00

	bcc skip1
	lda vector1+1
skip1	sta prTrackVolume,x
.)
	sec
	rts
	
prProc_SFXNegativeVolume
	lda prTrackVolume,x
	clc
	sbc prTemp01
.(
	; Keep to bounds
	bcs skip1
	lda #0
skip1	sta prTrackVolume,x
.)
	sec
	rts

;SFX change to noise happens beyond scope of Timeslots
prProc_SFXPositiveNoise
	adc AY_Noise
	and #31
	sta AY_Noise
	sec
	rts

prProc_SFXNegativeNoise
	lda AY_Noise
	clc
	sbc prTemp01
	and #31
	sta AY_Noise
	sec
	rts

	
prProc_SFXPositiveEGPeriod
	adc AY_PeriodLo
	sta AY_PeriodLo
.(
	bcc skip1
	inc AY_PeriodHi
skip1	sec
	rts
.)

prProc_SFXNegativeEGPeriod
	lda AY_PeriodLo
	clc
	sbc prTemp01
	sta AY_PeriodLo
.(
	bcc skip1
	inc AY_PeriodHi
skip1	sec
	rts
.)

	
;These commands depend on SS
prProc_SFXSwitchEG
	ldy prTrackSS,x
	lda prSS2ChannelBits,y
	tay
	lda prTemp01
.(
	beq skip1
	jmp prTurnEGFlagOn
skip1	jmp prTurnEGFlagOff
.)

	
prProc_SFXSwitchTone
	ldy prTrackSS,x
	lda prSS2ChannelIndex,y
	tay
	lda prTemp01
.(
	bne skip1
	jmp prStatusOff
skip1	jmp prStatusOn
.)

prProc_SFXSwitchNoise
	ldy prTrackSS,x
	lda prSS2ChannelIndex,y
	ora #8
	tay
	lda prTemp01
.(
	beq skip1
	jmp prStatusOff
skip1	jmp prStatusOn
.)
	
prProc_SFXSetSkipCondition
	lda prTemp01
	;0 	Conditional Volume
	;1        Conditional Counter
	;2 >>128	Unconditional
	cmp #2
.(
	bcc skip1
	lda #128
skip1	sta prTrackSFXSkipCondition,x
.)
          sec
	rts


prProc_SFXEndSFX
	;Stop current SFX
	lda prActiveTracks_SFX
	and BitposMask,x
	sta prActiveTracks_SFX
	;CLC set before in parent so no forced loop
	clc
	rts

prProc_SFXFilter
	;Mask prTrackPitchLo/Hi based on Filter in A(0==Off, 1-4)
	tay
	lda prTrackPitchLo,x
	and FilterMaskLo,y
	sta prTrackPitchLo,x
	lda #00
	sta prTrackPitchHi,x
	rts

prProc_SFXDelay
	sta prTrackSFXDelay,x
	clc
	rts
prProc_SFXSetCounter
	sta prTrackSFXCounter,x
	rts

prProc_SFXLoop
	lda prTrackSFXSkipCondition,x
.(
	bmi skip1	;Just Loop
	bne skip2	;Check Counter
	;Check Volume
	ldy #15
	lda prGlobalProperty
	and #BIT4
	beq skip4
	ldy #63
skip4	sty vector1+1
	lda prTrackVolume,x
	beq skip3
vector1	cmp #00
	bne skip1
skip3	rts
skip2	lda prTrackSFXCounter,x
	beq skip3
skip1	;Loop to Rows(Bytes) back
.)
	lda prSFXIndex,x
	sec
	sbc prTemp01
	; 1)Subtract one more because parent routine will increment to next entry
	; 2)Subtract one more so minimum loop is to row above
	sbc #02
	sta prSFXIndex,x
	;Update counter
	lda prTrackSFXCounter,x
.(
	beq skip1
	dec prTrackSFXCounter,x
skip1	sec
.)
	rts

prProc_SFXRandomDelay
	jsr FetchRandom255
	and #127
	sta prTrackSFXDelay,x
	; Carry kept Clear so no forced loop
	clc
	rts
	
prProc_SFXRandomNoise
	jsr FetchRandom255
	and #31
	sta AY_Noise
	sec	;Force loop
	rts
prProc_SFXRandomVolume
	jsr FetchRandom255
	and #15
	sta prTrackVolume,x
	sec
	rts

prProc_SFXRandomNote
	jsr FetchRandom255
	jsr ProcSFXNote
	sec
	rts

prProc_SFXRandomPitch
	jsr FetchRandom255
	sta prTrackPitchLo,x
	jsr FetchRandom255
	and #15
	sta prTrackPitchHi,x
	sec
	rts

prProc_SFXWave
	tay	;0-3
	lda prWaveCode,y
	sta AY_Cycle
	rts
