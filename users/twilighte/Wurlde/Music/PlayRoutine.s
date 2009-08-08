;
	

ProcMusic
	; Is Music Active?
	lda prGlobalProperty
.(
	bpl Skip1
	
	; Process Note Delay
	dec prNoteDelayCount
	bpl Skip1
	lda prNoteDelayRefer
	sta prNoteDelayCount
	
	; Process Patterns for each active Track
;	ldx #7
;Loop1	lda Bitpos,x
;	and prActiveTracks_Pattern
;	beq Skip2
	jsr prProcPattern
;Skip2	dex
;	bpl Loop1
Skip1	rts
.)
	
ProcSFX
	lda #128
	sta tmTrackingSFX
	ldx #7
.(
loop1	lda Bitpos,x
	and prActiveTracks_SFX
	beq skip1
	jsr prProcSFX
skip1	dex
	bpl loop1
.)
	jsr prProcPitchbend
	jmp TrackTheMusic
	
prSendAY
	;Reset CB2 incase Digidrum has it high
	lda #PCR_SETINACTIVE
	sta VIA_PCR
	;If wave has top bit set then mask it and reset reference(to force write)
	lda AY_Cycle
.(
	bpl skip1
	sta AYRegisterReference+13
	and #15
	sta AY_Cycle
skip1	;Send up to 14 Registers depending on changes
.)
	ldy #$DD
	ldx #13
.(
loop1	; Setup Register
	lda RegisterNumber,x
	sta VIA_PORTA
	lda #PCR_SETREGISTER
	sta VIA_PCR
	sty VIA_PCR
	
	; Has the value changed last time we looked?
	lda AYRegisterBase,x
	cmp AYRegisterReference,x
	beq skip1
	sta AYRegisterReference,x
	
	;Write the register value
	sta VIA_PORTA
	lda #PCR_WRITEVALUE
	sta VIA_PCR
	sty VIA_PCR
	
	;Progress to next register
skip1	dex
	bpl loop1
.)
	
;Convert the Note in A to PitchLo(A) and PitchHi(Y)
;Does not corrupt X
ConvertToPitch
	;Convert Long Note to Octave and Short Note
	ldy #255
	sec
.(
loop1	iny
	sbc #12
	bcs loop1
.)
	adc #12
	
	; A==Short Note Y==Octave
	sty prTemp01
	
	; Fetch Base Pitch for this Short Note
	tay
	lda BasePitchLo,y
	sta prTemp02
	lda BasePitchHi,y
	
	; Fetch back the octave
	ldy prTemp01

	; Don't Shift if Octave 0
.(
	beq skip1
	
	; Shift Base Pitch to Octave
loop1	lsr
	ror prTemp02
	
	dey
	bne loop1

skip1	; Put Hi in Y
.)
	tay
	
	; Put Lo in A
	lda prTemp02
	
	rts

FetchRandom255
         lda rndRandom+1
         sta rndTemp
         lda rndRandom
         asl
         rol rndTemp
         asl
         rol rndTemp

         clc
         adc rndRandom
         adc VIA_T2CL
         pha
         lda rndTemp
         adc rndRandom+1
         sta rndRandom+1
         pla
         adc #$11
         sta rndRandom
         lda rndRandom+1
         adc #$36
         sta rndRandom+1
         rts

	
TransferTrack2Resource
	;Process Timeslot delay
	dec prTimeslotDelayCount
.(
	bpl skip1
	lda prTimeslotDelayRefer
	sta prTimeslotDelayCount
	;Update sharing group indexes
	ldx prGroupIndex
loop1	dex
	bmi skip1
	dec SharingIndex,x
	bpl loop1
	lda SharingCount,x
	sta SharingIndex,x
	jmp loop1
skip1	;Process Track Transfer in Timeslot
	ldy #7
.)
.(
loop1	lda Bitpos,y
	and prActiveTracks_Mimicking
	beq skip1
	pha
	jsr prProcMimicTrack
	pla
	jmp skip4
skip1	;This is a bit strange here because for playing SFX outside of music Patterns won't be active
	;but for sharing/rest they need to remain active even when note not playing
	lda Bitpos,y
	and prActiveTracks_SFX
	bne skip4
	lda Bitpos,y
	and prActiveTracks_Pattern	;SFX
	beq skip3	;Track not active - skip to next
skip4	and prActiveTracks_Sharing
	beq skip2	;Not sharing - so send direct to AY
	ldx SharingGroup,y
	lda SharingEntry,y
	cmp SharingIndex,x
	bne skip3	;Track inactive for Timeslot
skip2	;Transfer Track Pitch to Resource
	jsr TrackPitch2Resource
	;Process Track Volume Resolution
	jsr TrackVolume2Resource
skip3	dey
	bpl loop1
.)
	rts

TrackVolume2Resource
	lda prTrackVolume,y
TrackVolume2ResourceSetVol
	sta prTemp01
	;Branch if single bit Volume (Status/EGFlag)
	ldx prTrackSS,y	;Real Volume only on 0-2
	;Abort if 63(Command Track H)
	cpx #63
.(
	bcs skip7
	lda prSS2StatusFlag,x
	bne skip1	;1Bit Volume - Special conditions apply
	lda prTemp01
	sta AbsoluteVolume,x
skip7	rts
skip1	; Put EG Flag in Carry
;	lda prSS2StatusFlag,x
	lsr
	; Branch if EGFlag
	bcs skip3
	; Translate Volume to 1 Bit
	lda prTemp01
	;Combined 'Translate to single bit' & 'Invert'
	bne skip2
	sec
skip2	; Process Bit in Status Register
	lda prSS2StatusBits,x
	eor #%11111111
	and AY_Status
	bcc skip4
	ora prSS2StatusBits,x
skip4	sta AY_Status
	rts
skip3	lda prTemp01
	beq skip6
	lda #16
skip6	sta prTemp01
	; Fetch EG Flags to alter
	lda prSS2StatusBits,x
	sta prTemp02
	ldx #2
loop1	lsr prTemp02
	bcc skip5
	lda AY_VolumeA,x
	and #%00001111
	ora prTemp01
	sta AY_VolumeA,x
skip5	dex
	bpl loop1
.)
	rts	
	
TrackPitch2Resource
	;Set Filter Mask from Filter(0-4)
	ldx prTrackSS,y
	cpx #20
.(
	bcs skip2
	lda prSS2PitchResourceIndex,x
	bmi skip1 ;Noise - may require Res conversion
	tax
	lda prTrackPitchLo,y
	sta AYRegisterBase,x
	lda prTrackPitchHi,y
	sta AYRegisterBase+3,x
	rts
skip1	lda prTrackPitchLo,y
	sta AbsoluteNoise
skip2	rts
.)



ProcResolutions
	;Cycle 4 step here
	lda Dither4StepCount
	clc
	adc #32
	sta Dither4StepCount
.(
	bcc skip1
	ldx #2
loop1	lda AbsoluteVolume,x
	beq skip2
	and #3
	tay
	lda DitherPattern,y
	sta DitherVolumePattern,x
skip2	dex
	bpl loop1
	lda AbsoluteNoise
	and #3
	tay
	lda DitherPattern,y
	sta DitherNoisePattern
skip1	;Process Volume Dither
.)
	;Process higher resolution Volume
	ldx #2
.(
loop1	ldy AbsoluteVolume,x
	beq skip1
	lda prGlobalProperty
	and #BIT4
	beq skip1
	tya
	lsr
	lsr
	cmp #15
	bcs skip2
	lsr DitherVolumePattern,x
	adc #00
skip2	tay
skip1	sty prTemp01
	lda AY_VolumeA,x
	and #%00010000
	ora prTemp01
	sta AY_VolumeA,x
	dex
	bpl loop1
.)
ProcNoiseResolution
	ldy AbsoluteNoise
	lda prGlobalProperty
	and #BIT3
.(
	beq skip1
	;Process Higher resolution Noise
	tya
	lsr
	lsr
	cmp #31
	bcs skip2
	lsr DitherNoisePattern
	adc #00
skip2	tay
skip1	sty AY_Noise
.)
	rts
	