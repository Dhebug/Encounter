;prPatternDVSProcess - 
prPatternProcessBuzzer
	and #127
	bne prPatternProcessPulsar
	;Fetch, convert and store Pitch
	pla
	clc
	adc prBaseOctave,x
	sta prTrackNote,x
	jsr ConvertToPitch
	sta prTrackPitchLo,x
	lda #DVS_BUZZER
	sta dvsActive
	tya
	jmp prPatternProcDVSRent2
prPatternProcessPulsar
	lda #DVS_PULSAR
	sta dvsActive
	;Fetch, convert and store Pitch
	pla
	clc
	adc prBaseOctave,x
	sta prTrackNote,x
	jsr ConvertToPitch
	sta prTrackPitchLo,x
	tya
	sta prTrackPitchHi,x
	;Fetch and store Value(Held in Volume)
	lda prTrackVolume,x
	sta dvsPulsarValue
	;Enable SFX on track
	lda Bitpos,x
	ora prActiveTracks_SFX
	sta prActiveTracks_SFX
	; Reset SFX Pointer
	lda #00
	sta prSFXIndex,x
	;Redirect IRQ Jump
	lda #<prPlayPulsar
	sta prIRQDVSVector+1
	lda #>prPlayPulsar
	sta prIRQDVSVector+2
	rts

prProcessDVS
	;Fetch DVS Index(0-1)
	lda prSS2Register4DVS,y
	sta dvsRegister
	lda prSS2PitchResourceIndex,y
	bmi prPatternProcessBuzzer
	bne prPatternProcessSID

prPatternProcessDigidrum
	;Branch on Bank(Held in Volume)
	pla
	lda prTrackVolume,x
	and #1
	bne prPatternProcessDigidrumHighBank
prPatternProcessDigidrumLowBank
	;Fetch Address offset(Effect and 15)
	lda prTrackSFX,x
	and #15
	;Add to Digidrum memory high
	clc
	adc #>DigidrumMemory
	sta DigiLoAddress+2
	;Reset Lo Address
	lda #00
	sta DigiLoAddress+1
	;Redirect IRQ Jump
	lda #<prPlayDIGILO
	sta prIRQDVSVector+1
	lda #>prPlayDIGILO
	sta prIRQDVSVector+2
	lda #DVS_DIGIDRUMLO
	sta dvsActive
	;Set T1 Period to Digidrum frequency(4Khz Max) and Enable T1 IRQ
prPatternProcDVSRent1
	lda DigiDrumT1PeriodLo
	sta VIA_T1LL
	lda DigiDrumT1PeriodHi
	sta VIA_T1LH
	;Digidrum already turned on by writing address
	rts
prPatternProcessDigidrumHighBank
	;Fetch Address offset(Effect and 15)
	lda prTrackSFX,x
	and #15
	;Add to Digidrum memory high
	clc
	adc #>DigidrumMemory
	sta DigiHiAddress+2
	;Reset Lo Address
	lda #00
	sta DigiHiAddress+1
	;Redirect IRQ Jump
	lda #<prPlayDIGIHI
	sta prIRQDVSVector+1
	lda #>prPlayDIGIHI
	sta prIRQDVSVector+2
	lda #DVS_DIGIDRUMHI
	sta dvsActive
	;Enable T1 IRQ
	jmp prPatternProcDVSRent1
prPatternProcessSID
	lda #DVS_SID
	sta dvsActive
	;Fetch and store Pitch
	pla
	clc
	adc AY_PitchALo-23,y
	sta prTrackPitchLo,x
	lda AY_PitchAHi-23,y
	adc #00
prPatternProcDVSRent2
	sta prTrackPitchHi,x
	;Fetch and store Value1(Held in Volume)
	lda prTrackVolume,x
	sta SID_Value1+1
	;Fetch and store Value2(Held in Effect)
	lda prTrackSFX,x
	sta SID_Value2+1
	;Redirect IRQ Jump
	lda #<prPlaySID
	sta prIRQDVSVector+1
	lda #>prPlaySID
	sta prIRQDVSVector+2
	;Turn on SID
	lda #1
	sta SID_Vector1+1
	rts
