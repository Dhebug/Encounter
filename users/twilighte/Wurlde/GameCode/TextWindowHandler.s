;TextWindowHandler.s
;All routines connected to Bottom Virtual HIRES text window (Below Gremlin)

;The text window consists visially of 7 rows of 35 columns however in memory
;Due to the border graphics reducing the number of characters per row(35) it has
;been possible to create a pseudo HIRES in the bottom 3 text lines..

;Row 0 is in HIRES
;Row 1 is in HIRES
;Row 2 is in HIRES
;Row 3 is in HIRES
;Row 4 is in half in HIRES(Top 2 rows) and Half in TEXT(Bottom 4 rows)
;Row 5 is in TEXT (6)
;Row 6 is in TEXT (6)

; 0         1         2         3
; 0123456789012345678901234567890123456789

;  |  <>@BDFHJLNPRTVXZ\^`bdfhjlnprtvxz|~ |
;  | ;=?ACEGIKMOQSUWY[]_acegikmoqsuwy{} |
;  \------------------------------------/

;The top left text character cell is 58(Colon) at HIRES character set address $99D0..
;99D0 99E0 99F0 9A00 9A10 9A20 9A30 etc.

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
	sta dtSourceTextIndex
	lda dtWindowOriginX,x
	sta dtCharacterX

loop2	;Now process text
	ldy dtSourceTextIndex
	lda (text),y

	;Branch on contents
	bmi EmbeddedText
	cmp #"["
	bne skip6
TriggerSubGameActivation
	;Don't display this character but activate sub-game associated to this LocationID
	jsr ActivateSubGame
	jmp skip4
skip6	cmp #"%"
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
	cmp #176-96
	bcc skip1
	cmp #208-96
	bcs skip1

	;Is this keyword known?
	ldy KeywordsLearntIndex
	bmi skip5
	ldx #00

loop3	cmp KeywordsLearnt,y
	beq skip1
	dey
	bpl loop3

skip5     ;remember keyword
	inc KeywordsLearntIndex
	ldy KeywordsLearntIndex
	sta KeywordsLearnt,y
	;Flag as keyword
	ldx #128
skip1	stx dtInverseFlag

	;Display Embedded text
	ldy #00
	sty dtEmbeddedTextIndex

loop1	ldy dtEmbeddedTextIndex
	lda (source),y
	cmp #"]"
	beq skip4

	ora dtInverseFlag

	ldx dtCharacterX
	ldy dtCharacterY
	jsr PlotCharacter

	inc dtCharacterX
	inc dtEmbeddedTextIndex

	jmp loop1

RenderCharacter
	;Render single character
	ldx dtCharacterX
	ldy dtCharacterY
	jsr PlotCharacter

	inc dtCharacterX

skip4	;
	inc dtSourceTextIndex
	jmp loop2

CarriageReturn
	jsr PerformCarriageReturn
	jmp skip4

EndOfPassage
.)
	;Branch on single word
	lda dtSingleWordFlag
.(
	bmi skip2

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
skip1	ldx dtRegisterX
	ldy dtRegisterY
	lda dtRegisterA
	rts
skip2	jsr Clear2EndOfRow
	ldx dtRegisterX
	ldy dtRegisterY
	lda dtRegisterA
	rts
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
	jsr PlotCharacter

	inc dtCharacterX
	jmp Clear2EndOfRow

skip1	rts
.)


;A Character (32-127) to plot (+128(keyword) to highlight(Bold))
;X X position (0-39)
;Y Y position (0-210)
PlotCharacter
	sta pcCharacter
	lda #00
	sta pcInverseFlag
	lda pcCharacter
	cmp #128
.(
	bcc skip1

	; Set Inverse flag
	lda #128
	sta pcInverseFlag

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
	lda CharacterAddressLo-32,y
.(
	sta vector1+1
	lda CharacterAddressHi-32,y
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
	sta (screen),y
	bit pcInverseFlag
	bpl skip1
	and #63
	lsr
	ora (screen),y
	sta (screen),y
skip1	dex
	bpl vector1
.)
	rts

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

	lda CharacterAddressLo-32,x
.(
	sta vector1+1
	lda CharacterAddressHi-32,x
	sta vector1+2

	;Straight write
	ldy #00
	ldx pcCharacterStartRow
vector1	lda $dead,x
	sta (screen),y
	bit pcInverseFlag
	bpl skip1
	and #63
	lsr
	ora (screen),y
	sta (screen),y
skip1	inx
	iny
	cpy #6
	bcc vector1
.)
	rts


dtRegisterX	.byt 0
dtRegisterY	.byt 0
dtRegisterA	.byt 0
dtWindowID	.byt 0
dtClear2EndOfWindow	.byt 0
dtRowInWindow	.byt 0
dtSingleWordFlag	.byt 0
dtCharacterX	.byt 0
dtCharacterY	.byt 0
dtEmbeddedTextIndex	.byt 0
dtInverseFlag	.byt 0
dtSourceTextIndex	.byt 0

pcCharacter	.byt 0
pcInverseFlag	.byt 0
pcXpos		.byt 0
pcYpos		.byt 0
pcCharacterStartRow	.byt 0

dtWindowOriginX
 .byt 4	; 0) Hero Item Description Positions 4,0 (9x1)
 .byt 14	; 1) Hero Location window 14,0 (13x1)
 .byt 28	; 2) Hero Grotes 28,0 (6x1)
 .byt 3	; 3) Character Form Name (8x1)
 .byt 12	; 4) Character Form Group (9x1)
 .byt 3	; 5) Character Form Description (18x4)
 .byt 22	; 6) Character Form Options (16x12)
 .byt 15	; 7) Character Form Grotes (6x1)
 .byt 3	; 8) Text window (35x7)
dtWindowOriginY
 .byt 36	; 0) Hero Item Description Positions 2,0 (8x1)
 .byt 39	; 1) Hero Location window 11,0 (?x1)
 .byt 36	; 2) Hero Grotes ?
 .byt 85	; 3) Character Form Name (8x1)
 .byt 85	; 4) Character Form Group (9x1)
 .byt 97	; 5) Character Form Description (18x4)
 .byt 85	; 6) Character Form Options (16x12)
 .byt 150	; 7) Character Form Grotes (6x1)
 .byt 174	; 8) Text window (35x7)
dtWindowBottomMargin	;Full Resolution bottom margin
 .byt 36	; 0) Hero Item Description Positions 2,0 (8x1)
 .byt 39	; 1) Hero Location window 11,0 (?x1)
 .byt 0	; 2) Hero Grotes ?
 .byt 0	; 3) Character Form Name (8x1)
 .byt 0	; 4) Character Form Group (9x1)
 .byt 121	; 5) Character Form Description (18x4)
 .byt 157	; 6) Character Form Options (16x12)
 .byt 156	; 7) Character Form Grotes (6x1)
 .byt 216	; 8) Text window (35x7)
dtWindowRightMargin
 .byt 13	; 0) Hero Item Description Positions 2,0 (8x1)
 .byt 27  ; 1) Hero Location window 11,0 (?x1)
 .byt 34  ; 2) Hero Grotes
 .byt 11  ; 3) Character Form Name (8x1)
 .byt 21  ; 4) Character Form Group (9x1)
 .byt 21  ; 5) Character Form Description (18x4)
 .byt 38  ; 6) Character Form Options (16x12)
 .byt 21  ; 7) Character Form Grotes (6x1)
 .byt 38  ; 8) Text window (35x7)

Offset40x1
 .byt 0,40,80,120,160,200

vhColumnAddressLo
 .byt <$9800+8*58
 .byt <$9800+8*60
 .byt <$9800+8*62
 .byt <$9800+8*64
 .byt <$9800+8*66
 .byt <$9800+8*68
 .byt <$9800+8*70
 .byt <$9800+8*72
 .byt <$9800+8*74
 .byt <$9800+8*76
 .byt <$9800+8*78
 .byt <$9800+8*80
 .byt <$9800+8*82
 .byt <$9800+8*84
 .byt <$9800+8*86
 .byt <$9800+8*88
 .byt <$9800+8*90
 .byt <$9800+8*92
 .byt <$9800+8*94
 .byt <$9800+8*96
 .byt <$9800+8*98
 .byt <$9800+8*100
 .byt <$9800+8*102
 .byt <$9800+8*104
 .byt <$9800+8*106
 .byt <$9800+8*108
 .byt <$9800+8*110
 .byt <$9800+8*112
 .byt <$9800+8*114
 .byt <$9800+8*116
 .byt <$9800+8*118
 .byt <$9800+8*120
 .byt <$9800+8*122
 .byt <$9800+8*124
 .byt <$9800+8*126
vhColumnAddressHi
 .byt >$9800+8*58
 .byt >$9800+8*60
 .byt >$9800+8*62
 .byt >$9800+8*64
 .byt >$9800+8*66
 .byt >$9800+8*68
 .byt >$9800+8*70
 .byt >$9800+8*72
 .byt >$9800+8*74
 .byt >$9800+8*76
 .byt >$9800+8*78
 .byt >$9800+8*80
 .byt >$9800+8*82
 .byt >$9800+8*84
 .byt >$9800+8*86
 .byt >$9800+8*88
 .byt >$9800+8*90
 .byt >$9800+8*92
 .byt >$9800+8*94
 .byt >$9800+8*96
 .byt >$9800+8*98
 .byt >$9800+8*100
 .byt >$9800+8*102
 .byt >$9800+8*104
 .byt >$9800+8*106
 .byt >$9800+8*108
 .byt >$9800+8*110
 .byt >$9800+8*112
 .byt >$9800+8*114
 .byt >$9800+8*116
 .byt >$9800+8*118
 .byt >$9800+8*120
 .byt >$9800+8*122
 .byt >$9800+8*124
 .byt >$9800+8*126

;This routine is similar to DisplayText except it allows the Block field number to be passed
;If the field is not found, nothing is displayed
;Parsed
;A WindowID (+128 to clear to end of window)
;X Field in Text(0 or 1) (+128 for non embedded single word like Grotes or Form Group)
;Y TextID (0-159)
;No Registers Corrupted
DisplayBlockField
	;Backup fields carried over
.(
	sta vector1+1
	stx vector2+1

	;Locate text
	lda EmbeddedTextAddressLo,y
	sta text
	lda EmbeddedTextAddressHi,y
	sta text+1

	;Locate field in (text)
	txa
	and #127
	beq skip1
	tax
	ldy #01
loop1	lda (text),y
	iny
	cmp #"]"
	bne loop1
	tya
	clc
	adc text
	sta text
	bcc skip1
	inc text+1

skip1	;Load registers
vector1	ldx #00
vector2	lda #00
.)
	and #128
	tay
	jmp DisplayText

