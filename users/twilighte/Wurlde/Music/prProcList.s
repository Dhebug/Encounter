;prProcList.s

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
;	  	3 IRQ Rates
;		   "SFX RATE 200HZ, DIGI RATE 2KHZ"
;                                       ---            --
;		   B0-1 SFX Rate (25Hz(0) 50Hz(1) 100Hz(2) 200Hz(3))
;		   C0-1 Digidrum Rate (500Hz,1Khz,2Khz,3Khz)
;	  	4 Sharing Behaviour
;		   "TIMESLOT IS SHARED AT RATE OF 255 "
;                                   ------            ---
;	  	   A5    Sharing Behaviour(PROCSFX(0) or WAITSFX(1))
;	  	   C0-7  Sharing Ticks (000 for maximum speed)
;	  	5 Note Offset Settings
;		   "OCTAVES 0-4 ON TRACKS ABCDEFGH    "
;                               ---           --------
;	  	   C0-7 Channel Spread
;	  	   D0-5 Note Offset C-0(C-0-C-4) to B-5(B-5 to B-9)
;	  	6 Resolution Settings
;                      "RESOLUTIONS - NOISE 4BIT, VOLUME 5BIT"
;                                           -            -
;	  	   A3    Use 5 Bit Noise Resolution(0) or 7 Bit(1)
;	  	   A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)
;	  	7 Spare
;                     -
prProcList
	; Initially Reset CommandH
	lda prGlobalProperty
	and #%10111111
	sta prGlobalProperty

	; If calling PLAY PATTERN from Pattern Editor then we'll need to stop here
	lda SinglePatternPlayFlag
.(
	beq skip1
	lda prGlobalProperty
	and #$7F
	sta prGlobalProperty
	;Switch off single pattern flag
	lda #00
	sta SinglePatternPlayFlag
	;Also switch off AY stuff
	jmp ResetAYRegisters
	
skip1	; Reset Resource usage
.)
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
	sta prActiveTracks_Sharing
	sta prActiveTracks_Pattern
prProcList2
	;Examine Command in Track A first
	ldy #01
	
	lda (list),y
	and #%11000000
.(
	cmp #%11000000
	bne skip4
	jmp prProcListRowCommand
	
skip4	;Row contains individual Tracks(X Track / Y List Index)
	ldx #00
	
loop1	;We still need to examine each Command field
	lda (list),y
	and #%11000000
	beq PatternOrRestEntry
	
	;Mimic which Track? (01(Left) or 10(Right))
	clc
	bmi skip5
	;Use Left track
	txa
	sbc #0
	jmp skip2
skip5	;Use right track
	txa
	adc #1
skip2	and #7
	sta prMimicTrack,x

	; Flag Mimicking Track
	lda Bitpos,x
	ora prActiveTracks_Mimicking
	sta prActiveTracks_Mimicking
	
	; Capture TrackSS (which is still required for mimicking)
	lda (list),y
	and #63
	sta prTrackSS,x
	
	; Capture Variables
	dey
	
	;Convert 0-7 to 0,4,8,12
	lda (list),y
	and #%00000111
	asl
	sta prMimicVolumeOffset,x
	
	;Convert 0-7 To 0,4,8,12,16,20,24,28
	lda (list),y
	and #%00111000
	lsr
	sta prMimicPitchOffset,x

	;convert 0,1,2,3 To 0,7,11,15
	lda (list),y
	and #%11000000
	lsr
	lsr
	lsr
	lsr
	beq skip8
	ora #3
skip8	sta prMimicTimeOffset,x
	
	;Reset historical pointer
	lda #00
	sta prMimicHistoryPointer,x
	
	;Reset volume history
	txa
	;Track x 32
	asl
	asl
	asl
	asl
	asl
	stx prTemp01
	sty prTemp02
	tax
	;Clear 32 bytes starting at x
	ldy #31
	lda #00
loop2	sta prMimicHistoryData,x
	inx
	dey
	bpl loop2
	;Restore Registers
	ldx prTemp01
	ldy prTemp02
	;Progress to next List entry
	jmp skip6

PatternOrRestEntry
	;Disable any previous Mimic on this track
	lda prActiveTracks_Mimicking
	and BitposMask,x
	sta prActiveTracks_Mimicking
	
	;Capture Patterns SS
	lda (list),y
	and #63
	sta prTrackSS,x
	;Detect CommandH
	cpx #7
	bne skip7
	cmp #63
	bne skip7
	lda prGlobalProperty
	ora #%01000000
	sta prGlobalProperty

skip7	;Set prActiveTracks_Pitch based on SS in A
	cmp #6
	lda prActiveTracks_Pitch
	and BitposMask,x
	bcc skip9
	ora Bitpos,x
skip9	sta prActiveTracks_Pitch

	;Capture Pattern
	dey
	lda (list),y
	and #127
	cmp #127
	beq PatternRest

	; Store Track A Pattern
	sta prTrackPattern,x
	
	; Activate Track
	lda prActiveTracks_Pattern
	ora Bitpos,x
	sta prActiveTracks_Pattern
	
skip6	; Build Sharing Tables
	jsr BuildSharingTables
	jmp skip1

PatternRest
	;Deactivate Track
	lda prActiveTracks_Pattern
	and BitposMask,x
	sta prActiveTracks_Pattern
skip1	iny
	iny
	iny	;move to second byte of next track entry
	inx
	cpx #8
	bcs skip3
	jmp loop1
skip3	jmp nl_List
.)

	
;Process Row wide command (Can only be set in Channel A)???
prProcListRowCommand

	dey
	lda (list),y
	and #7
	tay
	lda ListRowWideCommandLo,y
.(
	sta vector1+1
	lda ListRowWideCommandHi,y
	sta vector1+2
vector1	jsr $dead
.)
	jmp prProcList2

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
	lda (list),y
	sta prNoteDelayRefer
	sta prNoteDelayCount
	jmp nl_List
;1 End of Song
;   A3   Silence(1)
;   C0-6 Jump back(Loop) to Row (If 128 the no loop)
erwcEndSong
	;Process Silence?
	ldy #00
	lda (list),y
	and #%00001000
.(
	beq skip1
	;Zero Sound
	lda #00
	sta AY_VolumeA
	sta AY_VolumeB
	sta AY_VolumeC
	jsr prSendAY

skip1	;Loop?
.)
	ldy #2
	lda (list),y
.(
	and #127
	beq skip1
	;Calculate Row Address of loop((x16)+BaseAddress)
	ldy #00
	sty list+1
	asl
	asl
	rol list+1
	asl
	rol list+1
	asl
	rol list+1
	sta list
	lda list+1
	adc #>ListMemory
	sta list+1
	pla
	pla
	jmp prProcList
skip1	lda prGlobalProperty
.)
	and #127
	sta prGlobalProperty
	pla
	pla
	rts

;2 Fade Music (Always set on Track A)
;   A3   In(0) or Out(1)
;   C0-7 Frac Rate over one pattern(0-255)
erwcFadeSong
	jmp nl_List
;3 SFX Settings
;   B0-1 SFX IRQ   (25Hz(0) 50Hz(1) 100Hz(2) 200Hz(3))
;   C0-1 MUSIC IRQ (25Hz(0) 50Hz(1) 100Hz(2) 200Hz(3))
erwcSFXSettings
	;Capture IRQ SFX Speed
	ldy #1
	lda (list),y
	and #3
	tay
	lda IRQSpeedValue,y
	sta prSFXFrequency
	ldy #2
	lda (list),y
	and #3
	tay
	lda IRQSpeedValue,y
	sta prMusicFrequency
	jmp nl_List

;4 Sharing Behaviour
;   A5    Sharing Behaviour(PROCSFX(0) or WAITSFX(1))
;   C0-7  Time Slot Delay Frac (255 for maximum speed)
erwcTimeSlotBehaviour
	;A5    Time Slot Behaviour(Share Timeslot(0) or Not(1))
	ldy #00
	lda (list),y
	and #%00100000
	sta prTemp01
	lda prGlobalProperty
	and #%11011111
	ora prTemp01
	sta prGlobalProperty
	;C0-7  Time Slot Delay Frac (255 for maximum speed)
	ldy #2
	lda (list),y
	sta prTimeslotDelayRefer
	jmp nl_List

;5 Note Offset Settings
;   D0-5 Range of Notes
;   C0-7 Channel Spread
erwcSongSettings
	;   D0-5 Range of Notes
	ldy #03
	lda (list),y
	and #63
	sta prTemp01
	;C0-7 Channel Spread
	ldy #2
	lda (list),y
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
	jmp nl_List	

;6 Resolution Settings
;   A3    Use 5 Bit Noise Resolution(0) or 7 Bit(1)
;   A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)
erwcResolutionSettings
	;"MUSIC BEHAVIOUR- V:4 N:4 IRQ:100"
	;A3    Use 5 Bit Noise Resolution(0) or 7 Bit(1)
	;A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)
	ldy #00
	lda (list),y
	and #%00011000
	sta prTemp01
	lda prGlobalProperty
	and #%11100111
	ora prTemp01
	sta prGlobalProperty
;7 Spare
erwcSpare	;Continue to next List row
	

nl_List	lda list
	clc
	adc #16
	sta list
	lda list+1
	adc #0
	sta list+1
nl_list_rts
	rts

BuildSharingTables
	;If Command H then abort - Otherwise SS will be found to be 63
	lda prGlobalProperty
	asl
	bmi nl_list_rts

	;Backup Y (Is used to index the list track)
	sty bstTemp01
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
	ldy bstTemp01
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
	ldy bstTemp01
	; Set Sharing on for this track only
	lda Bitpos,x
	ora prActiveTracks_Sharing
	sta prActiveTracks_Sharing
	rts
skip2	; Store the last track to use resource here
	stx prLastTrack2UseResource,y
	ldy bstTemp01
	rts
.)	
	
