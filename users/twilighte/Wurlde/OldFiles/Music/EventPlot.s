;EventPlot.s

;7MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std

EventPlot
	ldy EventCursorRow
	jsr SetupEditorScreen
.(	
loop2	; Branch if within Events
	cmp #128
	bcc skip1
	
	; Plot blank row
	ldy #39
	lda #8
loop1	sta (screen),y
	dey
	bpl loop1

rent1	; Look to next row
	jsr nl_screen
	inc RowIndex
	lda RowIndex
	dec RowCounter
	bne loop2
	
	; Events Plot ends here!
	rts

skip1	; Check for Row Wide Command
	ldy RowIndex
	jsr eeFetchRowData
	lda eeRowData+1
	cmp #BIT6 + BIT7
	bcc skip2
	jsr DisplayRowWideCommand
	jmp skip3
	

skip2	; Plot Event Pattern row - Loop on Track
	ldx #7

loop3
	lda RowIndex
	jsr CalcEventAddress

	; Fetch Event Entry bytes
	ldy #00
	lda (source),y
	iny
	sta EventEntryByte0
	lda (source),y
	sta EventEntryByte1
	
	; Calc Y for screen offset
	stx ppTempX
	txa
	;Multiply channel (0-7) by 5
	asl
	asl
	sec
	adc ppTempX
	tay
	
	jsr EventPlotEntry
	ldx ppTempX

	dex
	bpl loop3
	
skip3	; Show Event Index (only when on channel 0)
	ldy #00
	lda RowIndex
	and #63
	clc
	adc #SIXTYFOUR_CHARACTERBASE
	sta (screen),y
	
	; Progress to next row
	jmp rent1
.)
;PPPS
;PPP Pattern (A0-6) Shown as single 00-63 plus a single digit to achieve 000-127 in Decimal across 2 chars
;	0-126 Pattern PPSO
;	127   Rest    ----
;S   Composite "Sound Source + Physical Channel" (B0-5) or C for Command Channel H
;	B0-2 Sound Source
;	B3-5 Physical Channel
;
;0 No Command
;1 Mimic Track Left (Volume Offset(A0-2), Pitch Offset(A3-5), Time offset(A6-7))
;  Shown as MVPTS
;2 Mimic Track Right (Volume Offset(A0-2), Pitch Offset(A3-5), Time offset(A6-7))
;  Shown as MVPTS
;3 Global Command (Command(A0-2), Param(A3-7)) which includes End and New Music
;  Shown across complete row and depends on command


EventPlotEntry
	lda eeHighlightActive
.(
	beq skip1
	lda RowIndex
	cmp eeHighlightRowStart
	bcc skip1
	cmp eeHighlightRowEnd
	beq skip2
	bcs skip1
skip2	lda #128
	jmp skip3
skip1	lda #00
skip3	sta eeHighlightInverse
.)	
	;First check command
	lda EventEntryByte1
	and #%11000000
.(
	bne DisplayCommand
	
	lda EventEntryByte0
	and #127
	cmp #127

	beq EventDisplayRest
	
	; Display Pattern as 3 single digit decimal
	jsr Plot3dd
	
	; Display Channel Mix
	lda EventEntryByte1
	and #63
	cmp #63
	bcc skip1
	lda #COMMAND_CHARACTER
	jmp skip2
skip1	adc #SIXTYFOUR_CHARACTERBASE
skip2	ora eeHighlightInverse
	sta (screen),y
	iny
	
rent1	ldx ppTempX
	cpx #7
	beq skip3
	lda #8
	ora eeHighlightInverse
	sta (screen),y
skip3	rts

EventDisplayRest
	lda #REST_CHARACTER1
	ora eeHighlightInverse
	sta (screen),y
	iny
	lda #REST_CHARACTER2
	ora eeHighlightInverse
	sta (screen),y
	iny
	lda #HYPHEN_CHARACTER
	ora eeHighlightInverse
	sta (screen),y
	iny
	lda #HYPHEN_CHARACTER
	ora eeHighlightInverse
	sta (screen),y
	iny
	jmp rent1

DisplayCommand

	cmp #64*2

	bcc MimicTrackLeft
	beq MimicTrackRight
;	rtsjmp DisplayRowWideCommand
MimicTrackLeft
	lda #MIMICLEFT_CHARACTER
	jmp skip4
MimicTrackRight
	lda #MIMICRIGHT_CHARACTER
skip4	ora eeHighlightInverse
	sta (screen),y

	iny
	
	; Display Volume
	lda EventEntryByte0
	and #63
	clc
	adc #SIXTYFOUR_CHARACTERBASE
	ora eeHighlightInverse
	sta (screen),y
	iny
	
	;Display Time
	lda EventEntryByte0
	asl
	rol
	asl
	rol
	and #3
	clc
	adc #SINGLEDIGITS_CHARACTERBASE
	ora eeHighlightInverse
	sta (screen),y
	iny
	
	lda EventEntryByte1
	and #63
	adc #SIXTYFOUR_CHARACTERBASE
	ora eeHighlightInverse
	sta (screen),y
	iny
	jmp rent1
.)
;For Command rows use alt cursor with fields dependant on command
eeDisplayCursor
	; Is this a row wide command?
	jsr IsRowWideCommand
.(
	bcc skip1
	; Fetch Command ID(A0-2)
	lda eeRowData
	and #7
	tax
	lda rwcCursorFieldPosTableLo,x
	sta vector1+1
	lda rwcCursorFieldPosTableHi,x
	sta vector1+2
	lda rwcCursorFieldLenTableLo,x
	sta vector2+1
	lda rwcCursorFieldLenTableHi,x
	sta vector2+2
	ldx RWCEventCursorX	;0 or 1
vector1	ldy $dead,x
vector2	lda $dead,x
	jmp skip2
skip1	ldx EventCursorX
	ldy EventCursorIndex2ScreenIndex,x
	lda EventCursorIndex2ScreenLength,x
skip2	tax
.)

.(
loop1	lda $bb80+80+40*12,y
	ora #128
	sta $bb80+80+40*12,y
	iny
	dex
	bne loop1
.)
	;Also take this opportunity to update status bar with entry specific stuff
	jsr IsRowWideCommand
.(
	bcs skip2
	;Is entry Event Mimic?
	jsr eeFetchEntryData
	lda eeEventByte1
	and #%11000000
	beq skip1
	cmp #%11000000
	beq skip1
	jmp LookupEventMimic
skip1	;Is Entry SS?
	lda eeEventByte0
	cmp #127
	beq skip2
	jmp LookupEventSS
skip2	jmp LookupNone
.)


IsRowWideCommand
	ldy EventCursorRow 
	jsr eeFetchRowData
	lda eeRowData+1
	cmp #BIT6+BIT7
	rts

eeDisplayLegend
	ldy #39
.(
loop1	lda eeLegend,y
	ora #128
	sta $BB80+40,y
	dey
	bpl loop1
.)
	rts

eeDisplayStatus
	;Display status
	ldx #39
.(
loop1	lda GenericGrabbedRowStatus,x
	ora #128
	sta $bb80+40*27,x
	dex
	bpl loop1
.)
	;Now display grabbed row
	lda eeGrabbedRow
	ldx #<$BB80+37+40*27
	stx screen
	ldx #>$BB80+37+40*27
	stx screen+1
	ldy #00
	jsr AltPlotInversed3DD 
	rts

 

DisplayRowWideCommand
	; Process Global Command - based on Text templates
	lda eeRowData
	and #7
	tax
	lda RowWideEventCommandTextTemplateLo,x
	sta source2
	lda RowWideEventCommandTextTemplateHi,x
	sta source2+1
	;Always plot 9 to start
	lda #9
	ldy #01
	sta (screen),y
	lda #00
	sta rwTemplateIndex
	iny
	sty rwScreenIndex
.(	
loop1	ldy rwTemplateIndex
	lda (source2),y
	beq rwEnd
	cmp #32
	bcc rwEmbeddedCode
	ldy rwScreenIndex
	ora eeHighlightInverse
	sta (screen),y
	inc rwScreenIndex
rwRent1	inc rwTemplateIndex
	jmp loop1
rwEmbeddedCode
	tax
	lda rwTemplateEmbeddedFieldDisplayLo-1,x
	sta vector1+1
	lda rwTemplateEmbeddedFieldDisplayHi-1,x
	sta vector1+2
	ldy rwScreenIndex
	lda eeRowData
vector1	jsr $dead
	sty rwScreenIndex
	jmp rwRent1
rwEnd	ldy rwScreenIndex
	;Clear To End Of Row
.)
ClearToEndOfRow
	lda #9
.(
loop1	sta (screen),y
	iny
	cpy #40
	bcc loop1
.)
	rts

rwReferenceText
 .byt " NORMAL"," "+128	;0
 .byt "SILENCE","D"+128       ;8
 .byt "OU","T"+128            ;16
 .byt "IN"," "+128            ;19
 .byt " 2","5"+128            ;22
 .byt " 5","0"+128            ;25
 .byt "10","0"+128            ;28
 .byt "20","0"+128            ;31
 .byt "SHARE","D"+128         ;34
 .byt "NORMA","L"+128         ;40
 .byt "0-","4"+128            ;46
 .byt "1-","5"+128            ;49
 .byt "2-","6"+128            ;52
 .byt "3-","7"+128            ;55
 .byt "4-","8"+128            ;58
 .byt "5-","9"+128            ;61
 .byt "6-","A"+128            ;64
 .byt "7-","B"+128            ;67
INOUTMessageIndex
 .byt 16,19
HertzMessageIndex
 .byt 22,25,28,31
SharedMessageIndex
 .byt 34,40
OctaveMessageIndex
 .byt 46,49,52,55,58,61,64,67

rwField9	;Display 6 when A3 is Set or 4 when not
	ldx #"4"
	and #BIT3
.(
	beq skip1
	ldx #"6"
skip1	txa
.)
rwRent6	ora eeHighlightInverse
	sta (screen),y
	iny
	rts
	
rwField10	;Display 7 when A4 is Set or 5 when not
	ldx #"5"
	and #BIT4
.(
	beq skip1
	ldx #"7"
skip1	txa
.)
	jmp rwRent6
 
rwField1	;1 13 chars from D-H            
	ldx #00
.(
loop1	lda eeRowData+3,x
	ora eeHighlightInverse
	sta (screen),y
	iny
	inx
	cpx #13
	bcc loop1
.)
	rts

rwField8	;Display C0-7 as Tracks A-H
	ldx #7
.(
loop1	lda eeRowData+2
	and Bitpos,x
	beq skip1
	lda TrackLetter,x
	ora eeHighlightInverse
	sta (screen),y
	iny
skip1	dex
	bpl loop1
.)
	rts

rwField2	;Display C0-7 as 3DD
	lda eeRowData+2
	jmp DisplayAlt3DD_witheventhlinverse
 
rwField7	;7 0-4,1-5,2-6,3-7,4-8,5-9(A3-5)
	lsr
	lsr
	lsr
	tax
	lda OctaveMessageIndex,x
	tax
	jmp rwDisplayReferenceText

rwField6	;6 SHARED(A5=1) or NORMAL(0)
	and #BIT5
.(
	beq skip1
	lda #1
skip1	tax
.)
	lda SharedMessageIndex,x
	tax
	jmp rwDisplayReferenceText
rwField5	;5 _25,_50,100,200(B0-1)
	lda eeRowData+1
	and #3
	tax
	lda HertzMessageIndex,x
	tax
	jmp rwDisplayReferenceText
rwField4	;4 IN_(A3=1) or OUT(0)
	and #BIT3
.(
	beq skip1
	lda #1
skip1	tax
.)
	lda INOUTMessageIndex,x
	tax
	jmp rwDisplayReferenceText
	
;Field Code always entered with Acc having Byte0(A0-7)
rwField3	;3 SILENCED(A3=1) or _NORMAL_(0)
	and #BIT3
	tax	
rwDisplayReferenceText
.(
loop1	lda rwReferenceText,x
	pha
	and #127
	ora eeHighlightInverse
	sta (screen),y
	iny
	inx
	pla
	bpl loop1
.)
rwExit	rts


