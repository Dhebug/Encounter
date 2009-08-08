;PlayRoutine.s

;PlayPattern
;A Pattern
;PlayPattern
;
;PlayPatternRow
;
;PlayPatternNote
;
;PlayListRow
;PlayListSong

;PlayNote
;Parsed
;A Note (0-63)
;X Volume
;Y SFX
;PlayNote
;	;Set interrupt so we don't start prematurely
;	sei
;	
;	; Store Parsed SFX
;	sty prTrackSFX
;	
;	; Store Parsed Note
;	sta prTrackNote
;	; Calculate and store Pitch
;	jsr ConvertToPitch
;	sta prTrackPitchLo
;	sty prTrackPitchHi
;	
;	; Store Parsed Volume
;	stx prTrackVolume
;	
;	;Turn off other track SFX
;	lda #00
;	sta prActiveTracks_Pattern
;	sta prActiveTracks_SFX
;	
;	; Sort Track Delay frac
;	sta prTrackSFXDelay
;	
;	; Disable Song
;	lda #BIT0
;	sta prGlobalProperty
;	
;	; Silence other channels (in case they were playing)
;	lda #00
;	sta AY_VolumeA
;	sta AY_VolumeB
;	sta AY_VolumeC
;	
;	jsr prSendAY
;	
;	;Enable just the first track	for playing our note
;	lda #1
;	sta prActiveTracks_SFX
;	lda #00
;	sta prActiveTracks_Sharing
;	
;	; Re-enable IRQ and play
;	cli
;	rts
JumpPause
	lda prGlobalProperty
	eor #128
	sta prGlobalProperty
	rts
JumpAllStop
	;Also Stop Effects
	lda #00
	sta prActiveTracks_SFX
	sta prActiveTracks_Pattern
	sta prActiveTracks_Sharing
	sta prActiveTracks_Mimicking
	sta prActiveTracks_Pitchbend
	sta AbsoluteVolume
	sta AbsoluteVolume+1
	sta AbsoluteVolume+2
JumpStop
	lda prGlobalProperty
	and #127
	sta prGlobalProperty
	;And reset Volume
ResetAYRegisters
	;Default AY registers
	lda #%01111000
	sta AY_Status
	lda #0
	sta AY_VolumeA
	sta AY_VolumeB
	sta AY_VolumeC
	rts

PlayPattern
	jsr JumpAllStop
	sei
	;Ensure Music is not playing
	lda prGlobalProperty
	and #$7F
	sta prGlobalProperty
	;Track from song start to current List row to accumulate settings
	jsr TrackCurrentSongDetails
	;Now write these settings to play routines runtime variables
	ldx #7
.(
loop1	lda tl_CurrentOctaveRange,x
	sta prBaseOctave,x
	lda #00
	sta prTrackVolume,x
	dex
	bpl loop1
.)
	lda tl_CurrentTempo
	sta prNoteDelayRefer
	sta prNoteDelayCount
	
	ldx tl_CurrentSFXRate
	lda IRQSpeedValue,x
	sta prSFXFrequency
	
	;tl_CurrentDIGRate not implemented yet in play routine
	
	lda prGlobalProperty
	and #%11000111
	ora tl_CurrentShareBehaviour
	ora tl_CurrentResolutions
	sta prGlobalProperty

	lda tl_CurrentShareTicks
	sta prTimeslotDelayRefer
	sta prTimeslotDelayCount

	;set LIST to current list row
	lda ListCursorRow
	ldx #00
	jsr CalcListAddress
	
	;Transfer source to list
	lda source
	sta list
	lda source+1
	sta list+1
	
	;Reset Single Pattern Flag(Incase we are called during a play)
	lda #0
	sta SinglePatternPlayFlag

	;Initial call to generate other list stuff
	jsr prProcList
	
	;Seems proclist still doesn't reset this
	lda #0
	sta prPatternIndex
	
	jsr prProcPattern
	
	;Now set Single Pattern Flag
	lda #1
	sta SinglePatternPlayFlag
	
	;Start music again
	lda prGlobalProperty
	ora #128
	sta prGlobalProperty
	cli
	rts

		
	

TrackCurrentSongDetails
	;we track from song start to current list row and accumulate RWC changes.
	;This ensure playing the isolated pattern sounds the same as playing the song.

	;We'll need to track the following
	;0 NEW SONG - Track Tempo held in (C0-7)
	;1 END SONG - Ignore
	;2 FADE	  - Ignore
	;3 IRQ RATE - Track SFX Rate(B0-1) and Digidrum Rate(C0-1)
	;4 SHARING  - Track Behaviour(A5) and Ticks(C0-7)
	;5 OCTAVES  - Track Octave Range for each track(A3-5)
	;6 RESOLUTI - Track Resolutions Volume(A4) and Noise(A3)
	
	;Set defaults
	lda #10
	sta tl_CurrentTempo
	lda #%00100000
	sta tl_CurrentShareBehaviour
	lda #0
	sta tl_CurrentResolutions
	sta tl_CurrentSFXRate
	sta tl_CurrentShareTicks
	ldx #7
.(
loop1	sta tl_CurrentOctaveRange,x
	dex
	bpl loop1
.)
	lda #2
	sta tl_CurrentDIGRate

	;Fetch Current Song start row
	ldx CurrentSong
	ldy SongStartIndex,x
.(	
loop1	;Fetch row data
	jsr eeFetchRowData
	
	;Ensure RWC
	lda eeRowData+1
	cmp #%11000000
	bcc skip5
	
	lda eeRowData
	and #7
	bne skip1
	
	;Track Tempo
	lda eeRowData+2
	sta tl_CurrentTempo
	jmp skip5
	
skip1	cmp #3
	bne skip2
	
	;Track SFX Rate
	lda eeRowData+1
	and #3
	sta tl_CurrentSFXRate
	;Track Digidrum Rate
	lda eeRowData+2
	and #3
	sta tl_CurrentDIGRate
	jmp skip5
	
skip2	cmp #4
	bne skip3
	
	;Track Behaviour(A5)
	lda eeRowData
	and #BIT5
	sta tl_CurrentShareBehaviour
	;Track Ticks(C0-7)
	lda eeRowData+2
	sta tl_CurrentShareTicks
	jmp skip5
	
skip3	cmp #5
	bne skip4
	
	;Track Octave Range(A3-5) for each track(C0-7)
	ldx #7
	
loop2	lda Bitpos,x
	and eeRowData+2
	beq skip6
	lda eeRowData+3
	and #63
	sta tl_CurrentOctaveRange,x
;	sta tl_CurrentOctaveRange_Unit,x
skip6	dex
	bpl loop2
	jmp skip5
	
skip4	cmp #6
	bne skip5
	
	;Track Resolutions Volume(A4) and Noise(A3)
	lda eeRowData
	and #BIT4+BIT3
	sta tl_CurrentResolutions
	
skip5	iny
	cpy ListCursorRow
	bcs skip7
	jmp loop1
skip7	rts
.)

tl_Temp01			.byt 0
tl_CurrentTempo		.byt 0
tl_CurrentSFXRate		.byt 0
tl_CurrentDIGRate		.byt 0
tl_CurrentShareBehaviour	.byt 0
tl_CurrentShareTicks	.byt 0
tl_CurrentResolutions	.byt 0
tl_CurrentOctaveRange
 .dsb 8,0
tl_CurrentOctaveRange_Unit
 .dsb 8,0


PlayFromRow
	jsr JumpAllStop
	jsr TrackCurrentSongDetails
	lda ListCursorRow
	ldx #00
	jsr CalcListAddress
	
	;Transfer source to list
	lda source
	sta list
	lda source+1
	sta list+1

	;Set interrupt so we don't start prematurely
	sei
	
	;Set Basics
	lda #BIT5+BIT7
	sta prGlobalProperty
	
	;Set Track Properties to those picked up in TrackCurrentSongDetails
	lda tl_CurrentTempo
	sta prNoteDelayRefer
	sta prNoteDelayCount

	ldy tl_CurrentSFXRate
	lda IRQSpeedValue,y
	sta prSFXFrequency

	ldy tl_CurrentDIGRate	;Music IRQ
	lda IRQSpeedValue,y
	sta prMusicFrequency

	lda #BIT7			;B7
	ora tl_CurrentShareBehaviour	;B5
	ora tl_CurrentResolutions
	sta prGlobalProperty

	lda tl_CurrentShareTicks
	sta prTimeslotDelayRefer
	sta prTimeslotDelayCount
	

	ldx #7
.(
loop1	lda tl_CurrentOctaveRange,x
	sta prBaseOctave,x	;or tl_CurrentOctaveRange_Unit
	dex
	bpl loop1
.)
	lda #00
	sta prActiveTracks_SFX
	sta prActiveTracks_Sharing
	sta prActiveTracks_Pattern

	; Process Lists up to first Pattern row
	jsr prProcList
	
	; Now setup Patterns
	jsr prProcPattern
	
	; Re-enable IRQ and play
	cli
	rts
	
	
JumpPlay
	jsr JumpAllStop	
	;Rebuild SongStartIndex table
	jsr TrackList
	
	;Ensure song is valid(we may be playing imm after load)
	lda tlUltimateSong
.(
	bpl skip1
	lda #00
	jmp skip3
skip1	;

	lda CurrentSong
	cmp tlUltimateSong
	beq skip2
	bcc skip2
	lda #00
	sta CurrentSong

skip2	;
	tax
	lda SongStartIndex,x

skip3
.)
	;A==List row to begin(Song start)
	ldx #00
	jsr CalcListAddress
	
	;Transfer source to list
	lda source
	sta list
	lda source+1
	sta list+1


	;Set interrupt so we don't start prematurely
	sei
	
	;Set Basics
	lda #BIT5+BIT7
	sta prGlobalProperty
	
	;Reset AY vars
	jsr ResetAYRegisters
	
	;These register values are used throughout most of this routine
	ldx #255
	lda #00

	;Set Track Properties to default
	sta prActiveTracks_SFX
	sta prActiveTracks_Sharing
	sta prActiveTracks_Pattern

	; Sort Sharing(By default timeslot has no delay)
	
	; Set default note tempo to 25
;	sta prVector2+1
	ldy #10
	sty prNoteDelayRefer
	sty prNoteDelayCount
	
	ldy #0
	sty prTimeslotDelayRefer
	sty prTimeslotDelayCount
	
	; Process Lists up to first Pattern row
	jsr prProcList
	
	; Now setup Patterns
	jsr prProcPattern
	
	; Re-enable IRQ and play
	cli
	rts
	
	
