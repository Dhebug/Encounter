;prProcEvent.s

;A0-7 Pattern
;	0-126 Pattern
;	127   Rest
;A7   -
;B0-5 Channel Combination (0-31) or 63 for Pattern Command(Channel H only)
;B6-7 Command
;	0 No Command
;	1 Mimic Track Left (Shown on Screen as <xtS) S remains as Sound Source
;	  A0-2 Volume Offset(0 To - 7 of mimicked Track) (Shown in x as compounded 64)
;	  A3-5 Pitch Offset(0 to -15 of mimicked Track)  (Shown in x as compounded 64)
;	  A6-7 Time offset(0 to -3 behind mimicked Track)(Shown in t as single digit)
;	2 Mimic Track Right (Shown on screen as >xts)
;	3 Extended Command(Row Wide Command)
;	  A0-2 Command (Always Set on Track A)
;	  	0 New Music (Always set on Track A)
;		   "NEW SONG '1234567890123' TEMPO 00 "
;                                 --------------        --
;                      D-H  Name(13 Characters)
;		   C0-7 Music Frac(0-255)
;	  	1 End of Song
;		   "END OF SONG(SILENCED) LOOP ROW 000"
;                                   --------           ---
;	  	   A3   Silence(1)
;		   C0-6 Jump back(Loop) to Row (If 128 the no loop)
;	  	2 Fade Music (Always set on Track A)
;		   "FADE SONG OUT AT RATE OF 15       "
;                                 ---            --
;	  	   A3   In(0) or Out(1)
;	  	   C0-7 Frac Rate over one pattern(0-255)
;	  	3 Effect Settings
;		   "EFFECT IRQ BASE 200Hz AT TEMPO 31 "
;                                       ---            --
;		   B0-1 IRQ Effect Speed (25Hz(0) 50Hz(1) 100Hz(2) 200Hz(3))
;		   C0-7 Spare (Was 'Effect Frac Tempo(0-255)' but not Used now!)
;	  	4 TimeSlot Behaviour
;		   "TIMESLOT IS SHARED AT RATE OF 255 "
;                                   ------            ---
;	  	   A5    Time Slot Behaviour(Shared Timeslot(0) or Normal(1))
;	  	   C0-7  Time Slot Delay Frac (255 for maximum speed)
;	  	5 Octave Settings
;		   "OCTAVES 0-4 ON TRACKS ABCDEFGH    "
;                               ---           --------
;	  	   A3-5 Range of Octaves 0-4 1-5 2-6 3-7 4-8 5-9
;	  	   C0-7 Channel Spread
;	  	6 Resolution Settings
;                      "RESOLUTIONS - NOISE 4BIT, VOLUME 5BIT"
;                                           -            -
;	  	   A3    Use 5 Bit Noise Resolution(0) or 7 Bit(1)
;	  	   A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)
;	  	7 Spare
;                     -
prProcEvent
	; Reset Resource usage
	ldx #4
	lda #255
.(
loop1	sta prResourceUsageCount,x
	dex
	bpl loop1
.)
	; Reset other bits
	lda #0
	sta prGroupIndex
	sta prPatternIndex
	sta prActiveTracks_Mimicking

	;Examine Command in Track A first
	ldy #01
	
	lda (event),y
	and #%11000000
.(
	cmp #%11000000
	bne skip4
	jmp prProcEventRowCommand
	
skip4	;Row contains individual Tracks(X Track / Y Event Index)
	ldx #00
	
loop1	;We still need to examine each Command field
	lda (event),y
	and #%11000000
	beq PatternOrRestEntry
	
	;Mimic which Track?
	txa
	adc #01
	cmp #%10000000
	bcc skip2
	sbc #2
skip2	and #7
	sta prMimicTrack,x

	; Flag Mimicking Track
	lda Bitpos,x
	ora prActiveTracks_Mimicking
	sta prActiveTracks_Mimicking
	
	; Capture TrackSS (which is still required for mimicking)
	lda (event),y
	and #63
	sta prTrackSS,x
	
	; Capture Variables
	dey
	lda (event),y
	and #%00000111
	sta prMimicVolumeOffset,x
	lda (event),y
	lsr
	lsr
	lsr
	pha
	and #%00000111
	sta prMimicPitchOffset,x
	pla
	lsr
	lsr
	lsr
	sta prMimicTimeOffset,x
	
	;Reset historical pointer
	lda #00
	sta prMimicHistoryPointer,x
	
	;Reset volume history
	txa
	;Track x 12
	asl
	asl
	sta prTemp01
	asl
	adc prTemp01
	stx prTemp01
	tax
	lda #00
	sta prMimicHistoryData,x
	sta prMimicHistoryData+1,x
	sta prMimicHistoryData+2,x
	sta prMimicHistoryData+3,x
	ldx prTemp01

	;Progress to next event entry
	jmp skip1

PatternOrRestEntry
	;Disable any previous Mimic on this track
	lda prActiveTracks_Mimicking
	and BitposMask,x
	sta prActiveTracks_Mimicking
	
	;Capture Patterns SS
	lda (event),y
	and #63
	sta prTrackSS,x
	;Capture Pattern
	dey
	lda (event),y
	and #127
	cmp #127
	beq PatternRest

	; Store Track A Pattern
	sta prTrackPattern,x
	
	; Activate Track
	lda prActiveTracks_Pattern
	ora Bitpos,x
	sta prActiveTracks_Pattern
	
	; Build Sharing Tables
	jsr BuildSharingTables
	jmp skip1

PatternRest
	;Deactivate Track
	lda prActiveTracks_Pattern
	and BitposMask,x
	sta prActiveTracks_Pattern
skip1	iny
	iny
	inx
	cpx #8
	bcs skip3
	jmp loop1
skip3	rts
.)

	
;Process Row wide command (Can only be set in Channel A)
prProcEventRowCommand

	dey
	lda (event),y
	and #7
	tay
	lda EventRowWideCommandLo,y
.(
	sta vector1+1
	lda EventRowWideCommandHi,y
	sta vector1+2
vector1	jsr $dead
.)
	jmp prProcEvent

;0 New Music (Always set on Track A)
;   D-H  Name(13 Characters)
;   C0-7 Note Tempo Frac(0-255)
erwcNewSong
	;New Song is also used to reset Mimic history
	lda prActiveTracks_Mimicking
.(
	beq skip1
	ldy #95
	lda #00
loop1	sta prMimicHistoryData,y
	dey
	bpl loop1
skip1	;Only capture Music Tempo
.)
	ldy #2
	lda (event),y
	sta prNoteDelayFrac
	jmp nl_event
;1 End of Song
;   A3   Silence(1)
;   C0-6 Jump back(Loop) to Row (If 128 the no loop)
erwcEndSong
	;Process Silence?
	ldy #00
	lda (event),y
	and #%00001000
.(
	beq skip1
	;Zero Sound
	lda #00
	sta AY_VolumeA
	sta AY_VolumeB
	sta AY_VolumeC
	jmp prSendAY

skip1	;Loop?
.)
	ldy #2
	lda (event),y
.(
	bmi skip1
	;Calculate Row Address of loop((x16)+BaseAddress)
	ldy #00
	sta event+1
	asl
	asl
	rol event+1
	asl
	rol event+1
	sta event
	lda event+1
	adc #>ListMemory
	sta event+1
	pla
	pla
	jmp prProcEvent
skip1	lda prGlobalProperty
.)
	ora #128
	sta prGlobalProperty
	rts

;2 Fade Music (Always set on Track A)
;   A3   In(0) or Out(1)
;   C0-7 Frac Rate over one pattern(0-255)
erwcFadeSong
	jmp nl_event
;3 Effect Settings
;   B0-1 IRQ Effect Speed (25Hz(0) 50Hz(1) 100Hz(2) 200Hz(3))
;   C0-7 Spare (Was 'Effect Frac Tempo(0-255)' but not Used now!)
erwcEffectSettings
	;Capture IRQ Effect Speed
	ldy #1
	lda (event),y
	and #3
	sta prIRQEffectSpeed
	jmp nl_event

;4 TimeSlot Behaviour
;   A5    Time Slot Behaviour(Shared Timeslot(0) or Normal(1))
;   C0-7  Time Slot Delay Frac (255 for maximum speed)
erwcTimeSlotBehaviour
	;A5    Time Slot Behaviour(Share Timeslot(0) or Not(1))
	ldy #00
	lda (event),y
	and #%00100000
	sta prTemp01
	lda prGlobalProperty
	and #%11011111
	ora prTemp01
	sta prGlobalProperty
	;C0-7  Time Slot Delay Frac (255 for maximum speed)
	ldy #2
	lda (event),y
	sta TimeslotDelayFrac
	jmp nl_event

;5 Octave Settings
;   A3-5 Range of Octaves 0-4 1-5 2-6 3-7 4-8 5-9
;   C0-7 Channel Spread
erwcSongSettings
	;A3-5 Range of Octaves 0-4 1-5 2-6 3-7 4-8 5-9
	ldy #00
	lda (event),y
	lsr
	lsr
	lsr
	and #7
	;x12
	asl
	asl
	sta prTemp01
	asl
	adc prTemp01
	sta prTemp01
	;C0-7 Channel Spread
	ldy #2
	lda (event),y
	sta prTemp02
	;Now Spread
	ldx #7
.(
loop1	lda prTemp02
	and Bitpos,x
	beq skip1
	lda prTemp01
	sta prBaseOctave,x
skip1	dex
	bpl loop1
.)
	jmp nl_event	

;6 Resolution Settings
;   A3    Use 5 Bit Noise Resolution(0) or 7 Bit(1)
;   A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)
erwcResolutionSettings
	;"MUSIC BEHAVIOUR- V:4 N:4 IRQ:100"
	;A3    Use 5 Bit Noise Resolution(0) or 7 Bit(1)
	;A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)
	ldy #00
	lda (event),y
	and #%00011000
	sta prTemp01
	lda prGlobalProperty
	and #%11100111
	ora prTemp01
	sta prGlobalProperty
;7 Spare
erwcSpare	;Continue to next event row
	

nl_event	lda event
	clc
	adc #8
	sta event
	lda event+1
	adc #0
	sta event+1
	rts

BuildSharingTables
	;The problem is that once we have established that a track needs to be shared
	;we will have already moved beyond the first track in the new group.
	;So we store the track at the end of each pass and then we can recall this track
	;and include it in the group tables.
	
	; Fetch the resource for this track
	ldy prTrackSS,x
	; Extrapolate the sound source resource
	lda prSS2ResourceUsage,y
	tay
	; increment the resource usage for this track
	lda prResourceUsageCount,y
	clc
	adc #01
	sta prResourceUsageCount,y
	; If the usage is now 1 then we must double back and include the first track to use resource
	cmp #1
.(
	bne skip1
	lda prLastTrack2UseResource,y
	tay
	; Assign new group to this resource sharing and the first track too
	lda prGroupIndex
	sta SharingGroup,y
	sta SharingGroup,x
	inc prGroupIndex
	; Set Sharing on for this track and the first
	lda Bitpos,y
	ora prActiveTracks_Sharing
	ora Bitpos,x
	sta prActiveTracks_Sharing
	; Set the entry
	lda #00
	sta SharingEntry,y
	lda #01
	sta SharingEntry,x
	; Set Count and Index to SharingEntry too (It will keep being updated to highest)
	ldy SharingGroup,x
	sta SharingCount,y
	sta SharingIndex,y
	rts

skip1	; If the usage is more than 1 then we need only update this track
	bcc skip2
	; We can again use LastTrack2UseResource to get in to the group ID for the resource sharing
	pha
	lda prLastTrack2UseResource,y
	tay
	lda SharingGroup,y
	sta SharingGroup,x
	tay
	; Then use prResourceUsageCount as the direct SharingEntry
	pla
	sta SharingEntry,x
	; And update the SharingCount
	lda SharingCount,y
	adc #00
	sta SharingCount,y
	rts
skip2	; Store the last track to use resource here
	stx prLastTrack2UseResource,y
	rts
.)	
	
