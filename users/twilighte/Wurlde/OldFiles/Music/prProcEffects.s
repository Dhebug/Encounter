;prProcEffects.s

;The other Timeslot rule which we did NOT invoke was whether an effect should process a tracks
;volume and pitch outside of a timeslot. This could easily be done.

;ProcEffect
; ProcEffect has a dual purpose. In its simplest form it merely modifies Tracks volume and Pitch.
; In more advanced form it can modify any AY register independantly of any active Resource Sharing
prProcEffect
	ldy SharingGroup,x
	lda SharingIndex,y
	cmp SharingEntry,x
.(
	bne skip2	;OutsideTimeslot

	; Process Delay
	lda prTrackEffectDelay,x
	beq skip1
	dec prTrackEffectDelay,x
	lda prTrackEffectCounter,x
	beq skip2
	dec prTrackEffectCounter,x
skip2	rts
	
skip1	lda prTrackEffect,x
.)
	lsr
	pha
	lda #00
	ror
	sta effect
	pla
	adc #$4E
	sta effect+1
.(
loop1	ldy prEffectIndex,x
	lda (effect),y
	;Locate Type
	ldy #22
loop2	dey
	cmp prEffectCodeThreshhold,y
	bcc loop2
	; Reduce to Zero based
	sbc prEffectCodeThreshhold,y
	sta prTemp01
	
	lda prEffectTypeVectorLo,y
	sta vector1+1
	lda prEffectTypeVectorHi,y
	sta vector1+2
	clc
	
vector1	jsr $dead
	bcs loop1
.)
	rts

	

prStatusOn
	lda prAYStatusChannelBits,y
	eor #$FF
	and AY_Status
	sta AY_Status
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
skip3	rts
.)
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
skip3	rts
.)
	
	
;Process prTrackVolume, prTrackPitchLo, prTrackPitchHi, prTrackNote with value held in prTemp01
;All commands are absolute ;) and Carry is Clear before entering
prProc_EffectPositivePitch
	lda prTrackPitchLo,x
	adc prTemp01
	sta prTrackPitchLo,x
.(
	bcc skip1
	inc prTrackPitchHi,x
skip1	rts
.)	
	
prProc_EffectNegativePitch
	lda prTrackPitchLo,x
	sec
	sbc prTemp01
	sta prTrackPitchLo,x
.(
	bcs skip1
	dec prTrackPitchHi,x
skip1	rts
.)	

;Note overrides/overwrites Pitch
prProc_EffectPositiveNote
	lda prTrackNote,x
	adc prTemp01
ProcEffectNote
	and #127
	jsr ConvertToPitch
	sta prTrackPitchLo,x
	tya
	sta prTrackPitchHi,x
	rts
	
prProc_EffectNegativeNote
	lda prTrackNote,x
	sec
	sbc prTemp01
	and #127
	jsr ConvertToPitch
	sta prTrackPitchLo,x
	tya
	sta prTrackPitchHi,x
	rts

prProc_EffectPositiveVolume
	lda prTrackVolume,x
	adc prTemp01
.(
	bcc skip1
	lda #15
skip1	sta prTrackVolume,x
.)
	rts
	
prProc_EffectNegativeVolume
	lda prTrackVolume,x
	sec
	sbc prTemp01
.(
	; Keep to bounds
	bcs skip1
	lda #0
skip1	sta prTrackVolume,x
.)
	rts

;Effect change to noise happens beyond scope of Timeslots
prProc_EffectSetNoise
	lda prTemp01
	sta AY_Noise
	rts
	
prProc_EffectSetEGPeriod
	lda prTemp01
	sta AY_PeriodLo
	lda #00
	sta AY_PeriodHi
	rts
	
;These commands depend on SS
prProc_EffectSwitchEG
	ldy prTrackSS,x
	lda prSS2Channel,y
	tay
	lda prTemp01
.(
	beq skip1
	jmp prTurnEGFlagOn
skip1	jmp prTurnEGFlagOff
.)

	
prProc_EffectSwitchTone
	ldy prTrackSS,x
	lda prSS2Channel,y
	tay
	lda prTemp01
.(
	beq skip1
	jmp prStatusOff
skip1	jmp prStatusOn
.)

prProc_EffectSwitchNoise
	ldy prTrackSS,x
	lda prSS2Channel,y
	ora #8
	tay
	lda prTemp01
.(
	beq skip1
	jmp prStatusOff
skip1	jmp prStatusOn
.)
	
prProc_EffectSetSkipCondition
	lda prTemp01
	sta prTrackEffectSkipCondition,x
	rts


prProc_EffectEndEffect
	;Stop current Effect
	lda prActiveTracks_Effect
	and BitposMask,x
	sta prActiveTracks_Effect
	rts

prProc_EffectFilter
	lda prTemp01
	sta prTrackEffectFilter,x
	rts

prProc_EffectDelay
	lda prTemp01
	sta prTrackEffectDelay,x
	rts
prProc_EffectSetCounter
	lda prTemp01
	sta prTrackEffectCounter,x

prProc_EffectLoop
	lda prTrackEffectSkipCondition,x
.(
	bmi skip1	;Just Loop
	bne skip2	;Check Counter
	;Check Volume
	lda prTrackVolume,x
	beq skip1
skip3	rts
skip2	lda prTrackEffectCounter,x
	bne skip3
skip1	;Loop to Rows(Bytes) back
.)
	lda prEffectIndex,x
	sec
	sbc prTemp01
	sta prEffectIndex,x
	;Update counter
	lda prTrackEffectCounter,x
.(
	beq skip1
	dec prTrackEffectCounter,x
skip1	rts
.)

prProc_EffectRandomDelay
	jsr FetchRandom255
	and #127
	sta prTrackEffectDelay,x
	rts
	
prProc_EffectRandomNoise
	jsr FetchRandom255
	and #31
	sta AY_Noise
	rts
prProc_EffectRandomVolume
	jsr FetchRandom255
	and #15
	sta prTrackVolume,x
	rts

prProc_EffectRandomNote
	jsr FetchRandom255
	jmp ProcEffectNote

prProc_EffectRandomPitch
	jsr FetchRandom255
	sta prTrackPitchLo,x
	jsr FetchRandom255
	and #15
	sta prTrackPitchHi,x
	rts

prProc_EffectWave
	ldy prTemp01	;0-3
	lda prWaveCode,y
	sta AY_Cycle
	rts
