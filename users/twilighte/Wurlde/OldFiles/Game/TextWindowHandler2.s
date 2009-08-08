;The Text handler drives all text display in Wurlde and resides in game memory.
;Text may contain embedded codes for Groups, common words and keywords and
;are expanded and rendered to the screen window area clearing to end of row
;and (optionally) to remaining rows of window.

;X WindowID (+128 to clear to end of window)
;Y Row in window (+128 for non embedded single word like Grotes or Form Group)
;text Source location of text

DisplayText
	;Store X & Y
	stx dtRegisterX
	sty dtRegisterY
	sta dtRegisterA

	;Capture parsed fields
	txa
	and #127
	sta dtWindowID
	txa
	and #128
	sta dtClear2EndOfWindow
	tya
	and #127
	sta dtRowInWindow
	tya
	and #128
	sta dtSingleWordFlag

	;Locate Window (and row within) on screen
	ldx dtWindowID
	lda dtRowInWindow
	asl
.(
	sta vector1+1
	asl
vector1	adc #00
	adc dtWindowOriginY,x
	sta dtCharacterY

	;Set up for big loop
	lda #00
	sta SourceTextIndex
	lda dtWindowOriginX,x
	sta dtCharacterX

loop2	;Now process text
	ldy SourceTextIndex
	lda (text),y

	;Branch on contents
	bmi EmbeddedText
	cmp #"%"
	beq CarriageReturn
	cmp #"]"
	beq EndOfPassage
	cmp #32
	bcs RenderCharacter

EmbeddedText
	;Capture embedded text (All embedded(common) text held in game memory)
	;0-31	Objects
	;128-143	Group
	;144-175	Character Name
	;176-207	Keyword
	;208-223	Placename
	;224-255  General
	;Reduce to 0-159
	cmp #32
	bcc skip2
	sbc #96

skip2	;Use to index embedded text address
	tax
	lda EmbeddedTextAddressLo,x
	sta source
	lda EmbeddedTextAddressHi,x
	sta source+1

	;Detect new Keyword
	txa
	ldx #00

	cmp #176
	bcc skip1
	cmp #208
	bcs skip1

	;Is this keyword known?
	ldy KeywordsLearntIndex
	bmi skip1

loop3	cmp KeywordsLearnt,y
	beq skip1
	dey
	bpl loop3

	;Flag as keyword
	ldx #128
skip1	stx InverseFlag

	;Display Embedded text
	ldy #00
	sty EmbeddedTextIndex

loop1	ldy EmbeddedTextIndex
	lda (source),y
	cmp #"]"
	beq skip4

	ora InverseFlag

	ldx dtCharacterX
	ldy dtCharacterY
	jsr DisplayCharacter

	inc dtCharacterX
	inc EmbeddedTextIndex

	jmp skip4

RenderCharacter
	;Render single character
	ldx dtCharacterX
	ldy dtCharacterY
	jsr DisplayCharacter

	inc dtCharacterX

skip4	;
	inc SourceTextIndex
	jmp loop2

CarriageReturn
	jsr PerformCarriageReturn
	jmp skip4

EndOfPassage
.)
	;Branch on single word
	lda dtSingleWordFlag
.(
	bmi skip1

	;Perform carriage return
loop1	jsr PerformCarriageReturn

	;
	lda dtClear2EndOfWindow
	bpl skip1

	;
	lda dtCharacterY
	ldx dtWindowID
	cmp dtWindowBottomMargin,x
	bcc loop1
skip1	rts
.)

PerformCarriageReturn
	jsr Clear2EndOfRow

	;
	ldx dtWindowID
	lda dtWindowOriginX,x
	sta dtCharacterX

	;
	lda dtCharacterY
	clc
	adc #6
	sta dtCharacterY
	rts

Clear2EndOfRow
	lda dtCharacterX
	ldx dtWindowID
	cmp dtWindowRightMargin,x
.(
	beq skip1

	;Render Space
	lda #" "
	ldx dtCharacterX
	ldy dtCharacterY
	jsr DisplayCharacter

	inc dtCharacterX
	jmp Clear2EndOfRow

skip1	rts
.)


;A Character (32-127) to plot (+128(keyword) to highlight)
;X X position (0-39)
;Y Y position (0-210)
PlotCharacter
	sta pcCharacter
	lda #00
	sta InverseCharacterFlag
	lda pcCharacter
	cmp #128
.(
	bcc skip1

	; Set Inverse flag
	lda #63
	sta InverseCharacterFlag

skip1	; Now we know about keyword(inverse) remove top bit
	lda pcCharacter
	and #127

	; Remember parsed parameters
	sta pcCharacter
	stx pcXpos
.)
	sty pcYpos

	; does character lye completely in HIRES?
	cpy #195
	bcc PlotHIRESCharacter

	; does character lye in crossover between HIRES and TEXT?
	cpy #200
	bcc PlotCrossoverCharacter

	; Character lies in TEXT
	jmp PlotTEXTCharacter

PlotHIRESCharacter
	ldx #05
PlotPartHIRESCharacter
	;Fetch Character Bitmap Address
	tay
	lda CharacterAddressLo,y
.(
	sta vector1+1
	lda CharacterAddressHi,y
	sta vector1+2

	;Calculate Screen address
	ldy pcYpos
	lda pcXpos
	clc
	adc HIRESylocl,y
	sta screen
	lda HIRESyloch,y
	adc #00
	sta screen+1

	;Plot HIRES character
vector1	lda $dead,x
	ldy Offset40x1,x
	eor InverseCharacterFlag
	sta (screen),y
	dex
	bpl vector1
.)
	rts
InverseCharacterFlag	.byt 0
PlotCrossoverCharacter
	;Calculate how many rows of character are in HIRES
	lda #200
	sec
	sbc pcYpos
	sta pcCharacterStartRow
	tax
	dex

	;Restore Character in A
	lda pcCharacter

	;Plot HIRES part
	jsr PlotPartHIRESCharacter

	ldy #200
	ldx pcXpos
	lda pcCharacterStartRow
	jmp PlotPartTEXTCharacter


PlotTEXTCharacter
	lda #0
PlotPartTEXTCharacter
	sta pcCharacterStartRow
	;Reduce Xpos by 3
	dex
	dex
	dex

	;Reduce Ypos by 200
	tya
	sec
	sbc #200

	;Add Column address of TEXT virtual hires
	clc
	adc vhColumnAddressLo,x
	sta screen
	lda vhColumnAddressHi,x
	sta screen+1

	;Fetch Character Address
	ldx pcCharacter

	lda CharacterAddressLo,x
.(
	sta vector1+1
	lda CharacterAddressHi,x
	sta vector1+2

	;Straight write
	ldy #00
	ldx pcCharacterStartRow
vector1	lda $dead,x
	eor InverseCharacterFlag
	sta (screen),y
	inx
	iny
	cpy #6
	bcc vector1
.)
	rts


