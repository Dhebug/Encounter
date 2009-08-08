; Wurlde text is handled from one routine. This routine handles a long stream of text
; and will automatically format it for displaying in the various text field windows.
; The following areas are supported..
; X
; 0) Hero Item Description Positions (8x1)
; 1) Hero Location window (13x1)
; 2) Hero Grotes (6x1)
; 3) Character Form Name (8x1)
; 4) Character Form Group (9x1)
; 5) Character Form Description (18x4)
; 6) Character Form Options (16x12)
; 7) Character Form Grotes (6x1)
; 8) Text window (35x7)
; Y YPosition in window to start plotting(Row Number)
; source - contains the text to be displayed terminating with 255 or 254.

;Depending on the area in X the text will either be displayed as VWC or FWC.

;Sentence is..
; expanded to pure text with Embedded codes replaced with words (keywords marked +128)
; Reformatted with Full stops at end, accumulate VWC and insert CR each window width
; Dump each text line to Display buffer and then copy each pixel row to Screen

DisplaySentence
	stx dsLocationID
	sty dsYPosition

	jsr dsExpand2PureText

	jsr dsFormatPureText

	jsr dsPrepareScreen

	jsr dsPlotSentence

	rts




; Dump each text line to Display buffer and then copy each pixel row to Screen
dsDisplayFormattedText
	;Erase dsDisplayBuffer (40 x 6) with 0
	ldx #16
	lda #00
.(
loop1	sta dsDisplayBuffer-16,x
	inx
	bne loop1
.)
	;
	ldx #00
	stx dsFormattedTextIndex
	stx dsScreenBufferPixelX
.(
loop1	;
	ldx dsFormattedTextIndex
	ldy dsFormattedTextBuffer,x	;13 or 32-122 (or +128) or 254

	bpl skip1
	;Found keyword
	and #127
skip1	cpy #13
	beq
	cpy #254
	bcs

	lda TextVectorLo,y
	sta vector1+1
	lda TextVectorHi,y
	sta vector1+2

	;Fetch text width to locate
	ldx dsScreenBufferPixelX
	ldy BufferXLOC,x
	;These tables also have B6 set
	lda LeftShiftTableAddressLo,y
	sta vector2+1
	lda LeftShiftTableAddressHi,y
	sta vector2+2
	lda RightShiftTableAddressLo,y
	sta vector3+1
	lda RightShiftTableAddressHi,y
	sta vector3+2

	;
	ldy #06
vector1	ldx $dead,y
vector2	lda $dead,x
	sta LeftBuffer-1,y
vector3	lda $dead,x
	sta RightBuffer-1,y
	dey
	bne vector1

	;Take row to start displaying text from
	lda dsYPosition
	;multiply by 6

	;Now ora the buffers directly to screen
	ldy


	;
	ldx dsFormattedTextIndex
	lda dsScreenBufferPixelX
	clc
	adc FormattedTextWidths,x
	sta dsScreenBufferPixelX



	inc dsFormattedTextIndex

	jmp loop1




	lda dsWindowWidth,x




























	; Fetch window dimensions
	lda WindowWidthTable,x
	sta WindowWidth
	lda WindowHeightTable,x
	sta WindowHeight

	; Fetch VWC flag
	lda CharacterWidthType,x
	sta VWCFlag

	; Transfer source to buffer inserting keywords
	jsr Convert2PureText

	; Insert carriage returns
	jsr TrackCarriageReturns

	; Branch if need to deal with text lines crossover
	lda dsTempX
	cmp #8
.(
	bne skip1
	lda dsTempY
	cmp #4
	bcs skip2
skip1	;

	; Calculate start Character screen location
	lda WindowScreenLocLo,x
	adc Mult40x6Lo,y
	sta screen
	lda WindowScreenLocHi,x
	adc Mult40x6Hi,y
	sta screen+1


Convert2PureText
	ldy #00
	sty sourceindex
	sty ultimatebufferindex
.(
loop1	ldy sourceindex
	lda (source),y
	bmi insertkeyword
	ldy ultimatebufferindex
	sta buffer,y
	inc ultimatebufferindex
	inc sourceindex
	cmp #00
	bne loop1
	rts
insertkeyword
	;Insert spaces to start and end
	ldy ultimatebufferindex
	lda #32
	sta buffer,y
	inc ultimatebufferindex

	inc sourceindex
	and #127
	tax
	lda KeywordTextVectorLo,x
	sta source2
	lda KeywordTextVectorHi,x
	sta source2+1
	ldy #00
loop2	lda (source2),y
	beq endofkeyword
	ldx ultimatebufferindex
	sta buffer,x
	inc ultimatebufferindex
	iny
	jmp loop2
endofkeyword
	;Insert spaces to start and end
	ldy ultimatebufferindex
	lda #32
	sta buffer,y
	inc ultimatebufferindex
	jmp loop1
.)

TrackCarriageReturns
	ldy #00
	sty sourceindex

	ldy sourceindex
.(
loop1	lda buffer,y
	beq skip2

	cmp #32
	bne skip1
	; Track last Space
	sty LastSpaceIndex

skip1	iny

	;Count columns
	inc ColumnCount
	lda ColumnCount
	cpy WindowWidth
	beq loop1
	bcc loop1
	;Use last space as where to put carriage return
	ldy LastSpaceIndex
	lda #13
	sta buffer,y
	iny
	sty sourceindex
	lda #00
	sta ColumnCount
	jmp loop1
skip2	rts
.)


;99D0 99E0 99F0 9A00 9A10 9A20 9A30 etc.

;X 	x-pos (0-237) (assumed to be left margin)
;Y 	y-pos (0-219)
;source 	formatted text
;cwidths	Character widths table for text in source
DrawSentence
	stx dsXPos
	stx dsLeftMargin
	sty dsYPos
	lda #00
	sta dsTextIndex
.(
loop1	; Fetch character index
	ldy dsTextIndex

	; Fetch character
	lda (source),y

	; Branch if end
	beq EndOfText

	; Branch if carriage return
	cmp #13
	beq CarriageReturn

	ldx dsXPos
	jsr GenerateVWCharacter

	jsr DrawColumnBuffers

	ldy dsTextIndex
	lda dsXPos
	clc
	adc cwidths,y
	sta dsXPos

	jmp loop1
CarriageReturn
	; Reset X
	lda dsLeftMargin

	; Progress row
	inc dsYPos

	; Progress index
	inc dsTextIndex

	jmp loop1
EndOfText
	rts
.)

;X x-pos (0-237)
;Y y-pos (0-219)
DrawColumnBuffers
	;Branch on Crossover or residence in Physical 3 row Text area
	cpy #195
	bcs CheckTEXTResidency

DrawHIRESResidence
	lda ScreenColumn,x
	clc
	adc ScreenYLOCL,y
	sta screen
	lda ScreenYLOCH,y
	sta screen+1
	ldx #11
loop1	ldy ScreenOffset,x
	lda LeftColumnBuffer,x
	ora (screen),y
	sta (screen),y
	dex
	bpl loop1
	rts

CheckTEXTResidency
	;Detect Crossover rows
	cpy #200
	bcs DrawTEXTResidence
DrawTEXTCrossover
	stx dcbXPos
	sty dcbYPos

	; Fetch HIRES screen address
	lda ScreenColumn,x
	clc
	adc ScreenYLOCL,y
	sta screen
	lda ScreenYLOCH,y
	sta screen+1

	; How many HIRES rows?
	sty dsHIRESRows
	lda #200
	sec
	sbc dsHIRESRows
	;200-195 == 5 (0 Based), 200-196 == 4 (0 Based)
	sta dsHIRESRows
	tax

loop1	ldy ScreenOffset1x6,x
	lda LeftColumnBuffer,x
	ora (screen),y
	sta (screen),y
	lda RightColumnBuffer,x
	iny
	ora (screen),y
	sta (screen),y
	dex
	bpl loop1

	; How many text byte rows?
	lda #5
	sbc dsHIRESRows
	sta dsTEXTByteRows

	; Calculate Offset in character set CharBase + ((X-2)x16)
	ldx dcbXPos
	ldy ScreenColumn,x
	lda VirtualHIRESColumnAddressLo-2,y
	sta screen
	clc
	adc #16
	sta screen2
	lda VirtualHIRESColumnAddressHi-2,y
	sta screen+1
	adc #00
	sta screen2+1

	ldy dsTextByteRows

	ldx #05
loop2	lda LeftColumnBuffer,x
	sta (screen),y
	lda RightColumnBuffer,x
	sta (screen2),y
	dex
	dey
	bpl loop2

	rts

DrawTEXTResidence
	?

;X x-pos (0-237)
;A Character (32-127)
GenerateVWCharacter
	; Fetch desired Bit position(0-5) of character
	ldy ScreenBitpos,x

	; Fetch character definition address
	tax
	lda CharacterSetLo-32,x
.(
	sta vector+1
	lda CharacterSetHi-32,x
	sta vector+2

	; Fetch Left and Right Shift Table sets
	lda LeftShiftedTableVectorLo,y
	sta source
	lda LeftShiftedTableVectorLo,y
	sta source+1
	lda RightShiftedTableVectorLo,y
	sta source2
	lda RightShiftedTableVectorLo,y
	sta source2+1


	ldx #05
loop1
vector1	ldy $dead,x
	lda (source),y	;LeftShiftedByte
	sta LeftColumnBuffer,x
	lda (source),y	;RightShiftedByte
	sta RightColumnBuffer,x
	dex
	bpl loop1
.)
	rts

LeftColumnBuffer
 .dsb 6,0
RightColumnBuffer
 .dsb 6,0


