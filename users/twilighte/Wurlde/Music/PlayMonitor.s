;PlayMonitor.s

InitMonitor
	rts

PlayMonitor
	ldx #7
.(	
loop1	;Is Track Active?
	lda Bitpos,x
	and prActiveTracks_NotMuted
	bne skip3
	;For a muted track display code 91
	lda #91
	jmp skip4
skip3	and prActiveTracks_Mimicking
	bne skip2
	lda Bitpos,x
	and prActiveTracks_Pattern
	beq skip1
	
skip2	;Calculate 3 Bit volume level of current track
	jsr TranslateVolumeTo3Bit
	
skip1	;Calc Level character
	and #7
	clc
	adc #100
	
skip4	;store on screen
	sta $bb80+32,x
	
	dex
	bpl loop1
.)	
	rts

;Display Load as %
;MonitorCPULoad
;	;Calculate TotalCycles
;	lda VIA_T1LL
;	sec
;	sbc irqCycles
;	sta TotalCycles
;	lda VIA_T1LH
;	sbc irqCycles+1
;	sta TotalCycles+1
;	;Convert Total Cycles to Percentage CPU
;	ldx #255
;	sec
;loop1	inx
;	lda TotalCycles
;	sbc #<655
;	sta TotalCycles
;	lda TotalCycles+1
;	sbc #>655
;	sta TotalCycles+1
;	bcs loop1
;	;Results in X == 0-99 - Convert to Decimal
;	ldx #47
;	sec
;loop3	inx
;	sbc #10
;	bcs loop3
;	adc #58
;	;X==Tens A==Units
;	stx $bb80+36
;	sta $bb80+37
;	rts
;Display Volume for each Track

	

	
TranslateVolumeTo3Bit
	;Is Volume 1 Bit?
	ldy prTrackSS,x
	lda prSS2StatusFlag,y
.(
	bne skip4
	
	;Is Volume 4 or 6 Bit?
	lda prGlobalProperty
	and #BIT4
	beq skip3
	
	;Convert 6bit volume to 3 bit
	lda prTrackVolume,x
	lsr
	lsr
	lsr
	rts

skip3	;Convert 4bit volume to 3 bit
	lda prTrackVolume,x
	lsr
	rts
	
skip4	;Convert 1bit volume to 3 bit
	lda #0
	ldy prTrackVolume,x
	beq skip2
	lda #7

skip2	rts
.)

TrackTheMusic
	lda HelpViewFlag
	bne TrackOff
	lda CurrentEditor
	cmp #1
	beq TrackTheList
	cmp #2
	beq TrackThePattern
	cmp #3
	beq TrackTheSFX
TrackOff	jmp tmCommonCursorDelete
TrackTheList
	jsr tmCommonCursorDelete
	; Calculate current page bounds(List Row)
	lda ListCursorRow
	sec
	sbc #12
	sta tmPageBoundTop
.(
	bcs skip1
	lda #00
skip1	sta tmPageBoundTopLimited
.)
	clc
	adc #25
.(
	bcc skip1
	lda #127
skip1	sta tmPageBoundBottomLimited
.)
	; Convert zp list to Playing list row
	lda list+1
	sec
	sbc #>ListMemory	;Subtract base address
	sta tmTemp01
	lda list
	lsr tmTemp01	;/16
	ror
	lsr tmTemp01
	ror
	lsr tmTemp01
	ror
	lsr tmTemp01
	ror
	;pr List always looks at next row?
	sec
	sbc #1
	; Check current pr playing row against these bounds
	cmp tmPageBoundTopLimited
.(
	bcc skip1
	cmp tmPageBoundBottomLimited
	bcs skip1
	; Calculate y position of pr playing row
	sec
	sbc tmPageBoundTop
	; Should be Y!
	sta tmCommonCursorY
	jmp tmCommonCursorPlot
skip1	rts
.)
TrackThePattern
	jsr tmCommonCursorDelete
	; Calculate current page bounds(List Row)
	lda PatternCursorRow
	sec
	sbc #12
	sta tmPageBoundTop
.(
	bcs skip1
	lda #00
skip1	sta tmPageBoundTopLimited
.)
	clc
	adc #25
.(
	bcc skip1
	lda #127
skip1	sta tmPageBoundBottomLimited
.)
	; Convert zp list to Playing list row
	lda prPatternIndex
.(
	bmi skip1
	lsr
	sec
	sbc #1
	; Check current pr playing row against these bounds
	cmp tmPageBoundTopLimited
	bcc skip1
	cmp tmPageBoundBottomLimited
	bcs skip1
	; Calculate y position of pr playing row
	sec
	sbc tmPageBoundTop
	; Should be Y!
	sta tmCommonCursorY
	jmp tmCommonCursorPlot
skip1	rts
.)
TrackTheSFX
	jsr tmCommonCursorDelete
	; Check we are in Active SFX
	lda tmTrackingSFX
.(
	bmi skip3
	; Calculate current page bounds(List Row)
	lda SFXCursorRow
	sec
	sbc #12
	sta tmPageBoundTop
	bcs skip2
	lda #00
skip2	sta tmPageBoundTopLimited

	clc
	adc #25
	bcc skip1
	lda #127
skip1	sta tmPageBoundBottomLimited
	; 
	lda tmTrackingSFXIndex
	sec
	sbc #1
	; Check current pr playing row against these bounds
	cmp tmPageBoundTopLimited
	bcc skip3
	cmp tmPageBoundBottomLimited
	bcs skip3
	; Calculate y position of pr playing row
	sec
	sbc tmPageBoundTop
	; Should be Y!
	sta tmCommonCursorY
	jmp tmCommonCursorPlot
skip3	rts
.)

tmCommonCursorDelete
	ldy tmCommonCursorY
	;Perform extra check just to be sure
	cpy #25
.(
	bcs skip1
	lda YLOCL+2,y
	sta tmScreen
	lda YLOCH+2,y
	sta tmScreen+1
	ldy #00
	lda (tmScreen),y
	and #127
	sta (tmScreen),y
skip1	rts
.)
tmCommonCursorPlot
	ldy tmCommonCursorY
	;Perform extra check just to be sure
	cpy #25
.(
	bcs skip1
	lda YLOCL+2,y
	sta tmScreen
	lda YLOCH+2,y
	sta tmScreen+1
	ldy #00
	lda (tmScreen),y
	ora #128
	sta (tmScreen),y
skip1	rts
.)
