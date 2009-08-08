;MimicTracks

;	1 Mimic Track Left (Shown on Screen as <xtS) S remains as Sound Source
;	  A0-2 Volume Offset(0 To - 7 of mimicked Track) (Shown in x as compounded 64)
;	  A3-5 Pitch Offset(0 to -15 of mimicked Track)  (Shown in x as compounded 64)
;	  A6-7 Time offset(0 to -3 behind mimicked Track)(Shown in t as single digit)
;	2 Mimic Track Right (Shown on screen as >xts)
;Mimic copies the adjacent tracks Volume and pitch to the current track and may modify it a little.
;The complexity is only for the time offset which is based on sampling a history table of up to 16 records
;of the adjacent tracks modified elements.
;Since we are still setting up tracks volume and pitch, Timeslot rules are still observed.
;X Current Track
prProcMimicTrack
	ldx prMimicTrack,y
	;If Volume Resolution is 6bit then convert to 4
	lda prGlobalProperty
	and #BIT4
.(
	beq skip1
	lda prTrackVolume,x
	lsr
	lsr
	jmp skip2
skip1	lda prTrackVolume,x
skip2	;Offset Volume
.)
	sec
	sbc prMimicVolumeOffset,y
.(
	bcs skip1
	lda #00
skip1	sta prMimicVolume
.)
	; Offset Pitch
	lda prTrackPitchLo,x
	clc
	adc prMimicPitchOffset,y
	sta prMimicPitchLo
	lda prTrackPitchHi,x
	adc #00
	and #15
	sta prMimicPitchHi

	; Update Mimics History Pointer
	;The history pointer is 8(Track) cyclic Counters counting 0-15
	lda prMimicHistoryPointer,y
	clc
	adc #01
	and #15
	sta prMimicHistoryPointer,y
	
	; Calculate history table and current index
	;Multiply Track(0-7) in Y by 32 to get the starting point(base) of the two history blocks
	tya
	asl
	asl
	asl
	asl
	asl
	sta prTemp01
	; Add History pointer
	;This will point to the entry in the first History Block
	ora prMimicHistoryPointer,y
	tax
	; Store Sample
	;Store the Volume and PitchLo to the First block
	lda prMimicVolume
	asl
	asl
	asl
	asl
	ora prMimicPitchHi
	sta prMimicHistoryData,x
	;Store the PitchHi to the second block by adding 16
	lda prMimicPitchLo
	sta prMimicHistoryData+16,x
	
	; Now calculate where to capture history
	;History is the same pointer minus the time-offset but within the block boundary
	;Fetch history pointer again(0-15)
	lda prMimicHistoryPointer,y
	;subtract by the time-offset(0-15)
	sec
	sbc prMimicTimeOffset,y
	;Ensure within Block boundary
	and #15
	;Then add the Base address of the Blocks
	ora prTemp01
	tax
	
	; Capture Sample(From 256 Table)
	;Track x 32
	;Block1(+00)
	; B0-3 Pitch Lo
	; B4-7 Volume
	;Block2(+16)
	; B0-7 Pitch Hi
	;If Higher Res Volume, only shift twice
	lda prGlobalProperty
	and #BIT4
.(
	beq skip1
	lda prMimicHistoryData,x
	and #%11110000
	jmp skip2
skip1	lda prMimicHistoryData,x
	lsr
	lsr
skip2	lsr
.)
	lsr
	sta prTrackVolume,y
	
	lda prMimicHistoryData,x
	and #15
	sta prTrackPitchHi,y
	
	lda prMimicHistoryData+16,x
	sta prTrackPitchLo,y
	rts

;Must permit up to 7 concurrent mimics, even permitted mimicking a mimic track!
;History is up to 3 intervals behind current.
; pitch sample 0 -0
; pitch sample 1 -1
; pitch sample 2 -2
; pitch sample 3 -3
;
;so history for each element(3) should be 4 bytes long. And up to 7 separate histories means 84 Bytes
;but simplification of history per track means 96 Bytes.

                                           