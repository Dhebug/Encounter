;prProcessPatternCommand.s

;Command Track H
;A0-1 -
;A2-7 Command ID
;	00-15 Pitchbend		Rate	Track		00-15
;	16    Trigger Out		-	Value(0-63)	01
;	17    Trigger In		-	Value(0-63)	02
;	18    Note Tempo		-	Tempo(0-63)	03
;	19-34 EG Cycle		Cycle	Track(EG Flag)	04
;	35-50 EG Period		Hi	Lo		05
;	51-60 -                                                    06-60
;	61    Rest					----
;	62    Rest					62
;	63    Bar					----
;B0-7 Parameter2 B0-7(0-255)
ProcessCommandTrackH
	; Capture Param2
	iny
	lda (pattern),y
	sta prTemp01
	; Detect bar in next entry
	iny
	lda (pattern),y
	cmp #63*4
.(
	bcc skip1
	sta prNextEntryIsBarFlag

skip1	; Capture Param1
.)
	dey
	dey
	lda (pattern),y
	lsr
	lsr
	ldy #10	;Range of Pattern Commands
.(
loop1	dey
	cmp prPatternCommandThreshhold,y
	bcc loop1
.)
	sbc prPatternCommandThreshhold,y
	;A is range and Y is ID
	sta prTemp02
	cpy #7
.(
	beq CommandRest
	lda prPatternCommandVectorLo,y
	sta vector1+1
	lda prPatternCommandVectorHi,y
	sta vector1+2
	;Backup X
	stx prPatternCommandX
vector1	jsr $dead
	ldx prPatternCommandX
CommandRest
.)
	rts

prpc_EGCycle  	;4 EG Cycle
	;For EG Cycle prTemp02 is the Wave and prTemp01 is the EG flag for each track
	lda prTemp02
	ora #128
	sta AY_Cycle
	ldx #6
.(	
loop1	lda Bitpos,x
	;Protect against Pitchbending a rested track
	and prActiveTracks_Pattern
	beq skip2
	
	;Fetch SS for this Track
	ldy prTrackSS,x
	;Only permit changes to SS below 6 (otherwise we'd get into sharing complexity)
	cpy #6
	bcs skip2
	lda prSS2ChannelIndex,y
	tay
	
	;Work out EG Flag for calculated Channel and push into Carry Flag
	lda prTemp01
	and Bitpos,x
	cmp #1
	;Now load the AY volume register and (by default) switch EG off
	lda AY_VolumeA,y
	and #15
	;Then turn eg flag on only if carry set
	bcc skip1
	ora #16
skip1	sta AY_VolumeA,y
	
skip2	;Progress to next Track
	dex
	bpl loop1
.)
	rts
	
prpc_EGPeriod  	;5 EG Period
	;prTemp02 goes into PeriodHi whilst prTemp01 into Lo
	lda prTemp01
	sta AY_PeriodLo
	lda prTemp02
	sta AY_PeriodHi
	
prpc_Spare  	;9 Bar
prpc_TriggerOut
prpc_TriggerIn
	;Since we are in the editor environment it is not neccesary to process either trigger
	;command
	rts
prpc_NoteTempo
	;Use Parameter1 for Note Tempo (Show as c2-?)
	lda prTemp01
	sta prNoteDelayRefer
	rts
prpc_PitchBend
	;prTemp01 8 Bit Param - Track/s
	;prTemp02 4 Bit Param - Rate
	
	;Pitchbend now works as follows (V2)
	;1) Split Rate(0-15) into Delay(B0-1) and Step(B2-3)
	ldx prTemp02
	lda pbDelayTable,x
	sta prTemp02	;Delay
	lda pbStepTable,x
	sta prTemp03	;Step

	;2) For each Track in Param2(prTemp01)..
	ldx #6
.(	
loop2	lda prTemp01
	and Bitpos,x
	;Protect against Pitchbending a rested track
	and prActiveTracks_Pattern
	beq skip1

	; 2.1) transfer current track pitch to PitchbendDestination
	ldy prTrackPitchLo,x
	lda prPitchbendLo,x
	sty prPitchbendLo,x
	pha
	ldy prTrackPitchHi,x
	lda prPitchbendHi,x
	sty prPitchbendHi,x
	
	; 2.2) transfer prPitchbendStartLo/Hi to Track Pitch
	sta prTrackPitchHi,x
	pla
	sta prTrackPitchLo,x
	
	; 2.3) Decide on direction
	ldy #1	;Default to increment
	lda prTrackPitchHi,x
	cmp prPitchbendHi,x
	bcc increment
	bne decrement
	lda prTrackPitchLo,x 
	cmp prPitchbendLo,x
	beq skip1	;Matched - Abort
	bcc increment
decrement	ldy #255
increment	sty prPitchbendDirection,x
	;Store Pitchbend Delay
	lda prTemp02
	sta prPitchbendDelay,x
	sta prPitchbendDelayCount,x
	;Store Pitchbend Step
	lda prTemp03
	sta prPitchbendStep,x
	;Activate Pitchbend on Track
	lda Bitpos,x
	ora prActiveTracks_Pitchbend
	sta prActiveTracks_Pitchbend
	;Proceed to next Track
skip1	dex
	bpl loop2
.)
	rts
                      	
	
prProcPitchbend
	ldx #7
.(
loop1	lda Bitpos,x
	and prActiveTracks_Pitchbend
	beq skip1
	; Delay this pitchbend
	dec prPitchbendDelayCount,x
	bpl skip1
	lda prPitchbendDelay,x
	sta prPitchbendDelayCount,x
	; Decide which direction to go
	lda prTrackPitchLo,x
	ldy prPitchbendDirection,x
	bpl increment
decrement	sec
	sbc prPitchbendStep,x
	tay
	lda prTrackPitchHi,x
	sbc #00
	;Now perform comparison
	cmp prPitchbendHi,x
	bcc Reached
	sta prTrackPitchHi,x
	beq skip4
	tya
	jmp skip3
skip4	tya
	cmp prPitchbendLo,x
	beq Matched	;Matched - Abort
	bcc Reached
skip3	sta prTrackPitchLo,x
	jmp skip1
Reached	;With reached set tracks pitch to destination pitch
	lda prPitchbendLo,x
	sta prTrackPitchLo,x
	lda prPitchbendHi,x
	sta prTrackPitchHi,x
Matched	;Disable Pitchbend
	lda BitposMask,x
	and prActiveTracks_Pitchbend
	sta prActiveTracks_Pitchbend
	jmp skip1
increment	clc
	adc prPitchbendStep,x
	tay
	lda prTrackPitchHi,x
	adc #00
	;Now perform comparison
	sta prTrackPitchHi,x
	cmp prPitchbendHi,x
	beq skip2
	bcs Reached
	tya
	jmp skip5
skip2	tya
	cmp prPitchbendLo,x
	bcs Reached
skip5	sta prTrackPitchLo,x
skip1	dex
	bpl loop1
.) 
	rts
