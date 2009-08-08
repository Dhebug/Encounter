;Selector.s
;Selector currently planned for main game memory to covers Inns, Market and Shops

;When displaying drunkards, Health and Mana should oscillate.

;Parsed
;LocationID
SelectorDriver
	;Display Welcome Message for Location
	jsr TextCLS
	lda #00
	sta twh_CursorX
	sta twh_CursorY

	ldx LocationID
	lda LocationWelcomeTextLo,x
	sta text
	lda LocationWelcomeTextHi,x
	sta text+1

	jsr twh_DisplayText

	;Scan CharacterBlock and compile list of Characters that reside at LocationID
	ldx #00
	ldy #00
.(
loop1	; Calculate location of property list for character number in Y
	tya
	; x16
	asl
	asl
	asl
	asl
	php
	sec	;Add 1 so directly looking at +01 of property list
	adc #<CharacterBlocks
	sta vector1+1
	lda #>CharacterBlocks
	plp
	adc #00
	sta vector1+2

	;Fetch Byte
vector1	lda $dead

	;Branch if unused
	bmi skip1

	; Extract LocationID
	lsr
	lsr
	and #15

	; is it this location?
	cmp LocationID
	bne skip1

	; Add Y to compiled list
	tya
	sta CharactersAtLocation,x
	inx

skip1	; Proceed to next Character
	iny
	cpy #32
	bcc loop1
.)
	; Keep record of Last Character index +1
	dex
	stx LastCharacterIndex

	;Check there are characters at this location

;	beq DefaultToSingleCharacter
;	bmi NoCharactersFound

	;Set List variables
	lda #00
	sta CharacterListScreenBase	;Base of Push Scroll
	sta CharacterListScreenIndex	;Index on Screen (0-3)

	jsr DisplayCharacterFormsPage

	lda #127
	sta $A000

	;Wait on 25hz signal
.(
loop1	lda via_ifr
	bpl loop1

	;Reset irq
	lda via_t1cl

	jsr GlowHilite

	; Check key
	jsr ReadKeyboard
	lda KeyRegister

	; If no key pressed then permit any subsequent key through
	cmp #00
	bne skip3
	lda #255
	sta PreviousKey
	jmp loop1

skip3	;Loop if same as previous key
	cmp PreviousKey
	beq loop1

	; When different save as previous key
	sta PreviousKey

	; Was Key Escape?
	and #kcM
	bne EscapePressed

	; Was key Fire?
	lda KeyRegister
	and #kcA
	bne FirePressed

	; Was Key Down?
	lda KeyRegister
	and #kcD
	bne DownPressed

	; Was key Up?
	lda KeyRegister
	and #kcU
	beq loop1

	; Decrement Option
	lda CharacterListScreenIndex
	beq skip1

	; Delete Hilite
	lda #00
	jsr HiliteForm

	dec CharacterListScreenIndex
	jmp loop1
skip1	lda CharacterListScreenBase
	beq loop1
	dec CharacterListScreenBase
	jsr DisplayCharacterFormsPage
	jmp loop1

DownPressed
	; Increment Option
	lda CharacterListScreenIndex
	cmp #3
	bcs skip2

	; Delete Hilite
	lda #00
	jsr HiliteForm

	inc CharacterListScreenIndex
	jmp loop1
skip2	clc
	adc CharacterListScreenBase
	cmp LastCharacterIndex
	bcs skip4
	inc CharacterListScreenBase
skip4	jsr DisplayCharacterFormsPage
	jmp loop1

FirePressed
	jmp CharacterDetailTransition
EscapePressed
	jmp loop1
.)

DisplayCharacterFormsPage
	lda #00
	sta CharacterListScreenIndexCount
.(
loop1	; Calc Character Index for compiled list
	lda CharacterListScreenIndexCount
	sta EntryIndex
	clc
	adc CharacterListScreenBase

	; Locate Character for this index
	tax
	sta NextCharacterIndex
	lda CharactersAtLocation,x
	sta CharacterID

	; Display Character Form
	jsr DisplayCharacterForm

	; Proceed to next index
	inc CharacterListScreenIndexCount

	; Have we reached the end of the screen(0-3)
	lda CharacterListScreenIndexCount
	cmp #4
	bcs skip1

	; Have we reached the end yet?
	cmp LastCharacterIndex
	beq loop1
	bcc loop1

skip1
.)
	; Are there Pages before?
	lda CharacterListScreenBase
.(
	beq skip1

	; Display Up Arrow
	jsr DisplayUpArrow
	jmp skip2

skip1	; Delete Up Arrow
	jsr DeleteUpArrow
skip2
.)
	; Are there Pages After?
	lda NextCharacterIndex
	cmp LastCharacterIndex
.(
	bcs skip1

	; Display Down Arrow
	jsr DisplayDownArrow
	rts

skip1	; Delete Down Arrow
	jsr DeleteDownArrow
.)

CharacterListScreenIndexCount	.byt 0

GlowHilite
	;Update Hilite Colour
	inc HiliteIndex

	;Extract B0-3
	lda HiliteIndex
	and #15

	;Use as index to fetch real ink
	tax
	lda HiliteInk,x

	;Update Hilite Graphic
	jsr HiliteForm

	rts


NextCharacterIndex	.byt 0
LastCharacterIndex	.byt 0
CharacterListScreenBase	.byt 0
CharacterListScreenIndex	.byt 0
CharactersAtLocation
 .dsb 64,0

LocationID	.byt 0

HiliteIndex	.byt 0
HiliteInk
 .byt 4,1,5,2,6,3,3,7
 .byt 7,3,3,6,2,5,1,4

EntryIndex	.byt 0
CharacterID	.byt 0
;Parsed
; CharacterID ID of Character the form represents
; EntryIndex Index of the entry on screen (0-3)
DisplayCharacterForm
	jsr DisplayCharacterTemplate

	; Calculate location of property list for character in Playerfile
	lda CharacterID	;0-31
	; x16
	asl
	asl
	asl
	asl
	php
	clc
	adc #<CharacterBlocks
	sta header
	lda #>CharacterBlocks
	plp
	adc #00
	sta header+1

	; Fetch screen base for form
	ldx EntryIndex
	lda EntryScreenBaseLo,x
	sta screen2
	lda EntryScreenBaseHi,x
	sta screen2+1

	; Calculate location of Health tube
	lda #<325+1+40*12
	ldx #>325+1+40*12
	jsr CalculateFormFieldScreenLoc

	; Fetch Health Value
	ldy #00
	lda (header),y
	and #15

	; Display health
	jsr DisplayCharacterHealth

	; Calculate location of Mana tube
	lda #<344+13+40*12
	ldx #>344+13+40*12
	jsr CalculateFormFieldScreenLoc

	; Fetch Mana Value
	ldy #00
	lda (header),y
	lsr
	lsr
	lsr
	lsr

	;Display Mana
	jsr DisplayCharacterMana

	; Calculate location of Gender field
	lda #<$C7-$58
	ldx #>$C7-$58
	jsr CalculateFormFieldScreenLoc

	; Fetch Gender Flag
	ldy #01
	lda (header),y
	and #01

	;Display Gender
	jsr DisplayCharacterOther

	; Calculate location of Info Field
	lda #<$C9-$58
	ldx #>$C9-$58
	jsr CalculateFormFieldScreenLoc

	; Fetch Info flag
	ldy #01
	lda (header),y
	and #02

	;Display Info
	jsr DisplayCharacterInfo

	; Calculate location of Face Graphic
	lda #<2+40*4
	ldx #>2+40*4
	jsr CalculateFormFieldScreenLoc

	; Fetch FaceID
	ldy #02
	lda (header),y
	and #15

	;Display Face
	jsr DisplayCharacterFace

	; Calculate location of Group Field
	lda #<620
	ldx #>620
	jsr CalculateFormFieldScreenLoc

	; Fetch GroupID
	ldy #02
	lda (header),y
	lsr
	lsr
	lsr
	lsr

	;Display Group Text
	jsr DisplayCharacterGroupText

	; Calculate location of Name field
	lda #<$E4-$58
	ldx #>$E4-$58
	jsr CalculateFormFieldScreenLoc

	; Display Name
	jsr DisplayCharacterName

	; Calculate location of Grotes field
	lda #<$2CF-$58
	ldx #>$2CF-$58
	jsr CalculateFormFieldScreenLoc

	; Display Grotes (held as 3xBCD)
	jsr DisplayCharacterGrotes

	; Run through the 128 objects and display those held by the character
	lda #00
	sta FormObjectIndex

	ldx #127
	stx ObjectListIndex
.(
loop1	ldx ObjectListIndex

	; Fetch Object ID
	lda Objects_B,x
	lsr
	lsr
	lsr
	tay

	; Is it 31(Not used)?
	cmp #31
	beq skip1

	; Is object posessed by a character?
	lda Objects_A,x
	and #7
	cmp #6
	bne skip1

	; Is object posessed by this character?
	lda Objects_A,x
	lsr
	lsr
	lsr
	cmp CharacterID
	bne skip1

	;Is Character hiding this Object?
	lda Objects_B,x
	and #02
	beq skip2
	ldy #31
skip2
	; Index Object Graphic Table by ObjectID
	lda ObjectGraphicLo,y
	sta source
	lda ObjectGraphicHi,y
	sta source+1

	; Calculate Objects Screen Location
	ldy FormObjectIndex
	lda screen2
	adc ObjectScreenOffsetLo,y
	sta screen
	lda screen2+1
	adc ObjectScreenOffsetHi,y
	sta screen+1

	; Display object
	jsr DisplayObject

	;increment Pocket
	inc FormObjectIndex

skip1	; Proceed to next object
	dec ObjectListIndex
	bpl loop1
.)
	rts

FormObjectIndex	.byt 0
ObjectListIndex	.byt 0
ObjectScreenOffsetLo
 .byt <$88-$59
 .byt <$8A-$59
 .byt <$8C-$59
 .byt <$8E-$59
 .byt <$90-$59
 .byt <$240-$59
 .byt <$242-$59
 .byt <$244-$59
 .byt <$246-$59
 .byt <$248-$59
ObjectScreenOffsetHi
 .byt >$88-$59
 .byt >$8A-$59
 .byt >$8C-$59
 .byt >$8E-$59
 .byt >$90-$59
 .byt >$240-$59
 .byt >$242-$59
 .byt >$244-$59
 .byt >$246-$59
 .byt >$248-$59


;Parsed
;A Low screen offset
;X High screen offset
CalculateFormFieldScreenLoc
	clc
	adc screen2
	sta screen
	txa
	adc screen2+1
	sta screen+1
	rts

DisplayCharacterHealth
	sta temp01
	ldx #00
	ldy #00
.(
loop1	lda HealthTubeGraphic,x
	sta (screen),y
	lda screen
	sec
	sbc #40
	sta screen
	lda screen+1
	sbc #00
	sta screen+1
	inx
	dec temp01
	bpl loop1
.)
	rts

HealthTubeGraphic
 .byt %01011110
 .byt $EF
 .byt %01111111
 .byt $EF
 .byt %01111111
 .byt $EF
 .byt %01111111
 .byt $EF
 .byt %01111111
 .byt $EF
 .byt %01111111
 .byt $EF
 .byt %01111111
 .byt $EF
 .byt %01111111
 .byt $EF

DisplayCharacterMana
	sta temp01
	ldx #00
	ldy #00
.(
loop1	lda ManaTubeGraphic,x
	sta (screen),y
	lda screen
	sec
	sbc #40
	sta screen
	lda screen+1
	sbc #00
	sta screen+1
	inx
	dec temp01
	bpl loop1
.)
	rts

ManaTubeGraphic
 .byt %01011110
 .byt $EF
 .byt %01111111
 .byt $EF
 .byt %01101011
 .byt $EF
 .byt %01101101
 .byt $EF
 .byt %01101011
 .byt $EF
 .byt %01101101
 .byt $EF
 .byt %01101011
 .byt $EF
 .byt %01101101
 .byt $EF

DisplayCharacterOther
	tax
	lda CharacterOtherGraphicLo,x
	sta source
	lda CharacterOtherGraphicHi,x
	sta source+1

	ldx #7
.(
loop2	ldy #01
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #2
	jsr add_source
	jsr nl_screen
	dex
	bne loop2
.)
	rts

CharacterOtherGraphicLo
 .byt <GenderFemaleGraphic
 .byt <GenderMaleGraphic
 .byt <InfoGraphicOff
 .byt <InfoGraphicOn
CharacterOtherGraphicHi
 .byt >GenderFemaleGraphic
 .byt >GenderMaleGraphic
 .byt >InfoGraphicOff
 .byt >InfoGraphicOn

GenderFemaleGraphic
 .byt 3,%01010000
 .byt 3,%01111000
 .byt 3,%01010000
 .byt %01000000,%01111000
 .byt %01000001,%01000100
 .byt %01000001,%01000100
 .byt %01000000,%01111000
GenderMaleGraphic
 .byt 3,%01000111
 .byt 3,%01000011
 .byt 3,%01000101
 .byt %01000001,%01110000
 .byt %01000010,%01001000
 .byt %01000010,%01001000
 .byt %01000001,%01110000
InfoGraphicOff
 .byt 3,3
 .byt 3,3
 .byt 3,3
 .byt 3,3
 .byt 3,3
 .byt 3,3
 .byt 3,3
InfoGraphicOn
 .byt 7,%01000110
 .byt 7,%01000110
 .byt 2,2
 .byt 2,%01001100
 .byt 2,%01001100
 .byt 2,%01011000
 .byt 2,%01011000

DisplayCharacterInfo
	lsr
	adc #2
	jmp DisplayCharacterOther

;Parsed
;A FaceID
DisplayCharacterFace
	tax
	lda FaceGraphicLo,x
	sta source
	lda FaceGraphicHi,x
	sta source+1

	ldx #15
.(
loop2	ldy #2
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #3
	jsr add_source
	jsr nl_screen
	dex
	bne loop2
.)
	rts

;Parsed
;A GroupID(0-15)
DisplayCharacterGroupText

	tax
	lda GroupTextVectorLo,x
	sta source
	lda GroupTextVectorHi,x
	sta source+1

	;Display it
	ldx #10
	jmp DisplayHIRESText

GroupTextVectorLo
 .byt <GroupText
 .byt <GroupText+10*1
 .byt <GroupText+10*2
 .byt <GroupText+10*3
 .byt <GroupText+10*4
 .byt <GroupText+10*5
 .byt <GroupText+10*6
 .byt <GroupText+10*7
 .byt <GroupText+10*8
 .byt <GroupText+10*9
 .byt <GroupText+10*10
 .byt <GroupText+10*11
 .byt <GroupText+10*12
 .byt <GroupText+10*13
 .byt <GroupText+10*14
 .byt <GroupText+10*15
GroupTextVectorHi
 .byt >GroupText
 .byt >GroupText+10*1
 .byt >GroupText+10*2
 .byt >GroupText+10*3
 .byt >GroupText+10*4
 .byt >GroupText+10*5
 .byt >GroupText+10*6
 .byt >GroupText+10*7
 .byt >GroupText+10*8
 .byt >GroupText+10*9
 .byt >GroupText+10*10
 .byt >GroupText+10*11
 .byt >GroupText+10*12
 .byt >GroupText+10*13
 .byt >GroupText+10*14
 .byt >GroupText+10*15

GroupText
 .byt "INNKEEPER "
 .byt "WENCH     "
 .byt "BAKER     "
 .byt "COBBLER   "
 .byt "PIRATE    "
 .byt "FISHERMAN "
 .byt "PEASANT   "
 .byt "TRIBESMAN "
 .byt "DEALER    "
 .byt "CHILD     "
 .byt "STEWARD   "
 .byt "FARMER    "
 .byt "TALISMAN  "
 .byt "CLERGYMAN "
 .byt "WITCH     "
 .byt "WIZARD    "

DisplayCharacterName
	lda header
	adc #3
	sta source
	lda header+1
	adc #0
	sta source+1

	;Display it
	ldx #10
	jmp DisplayHIRESText

DisplayHIRESText
	ldy #00
	sty dhtTextIndex
	stx dhttemp01
.(
loop2	ldy dhtTextIndex
	lda (source),y
	jsr DisplayHIRESChar
	inc screen
	bne skip1
	inc screen+1
skip1	inc dhtTextIndex
	dec dhttemp01
	bne loop2
.)
	rts
dhtTextIndex	.byt 0
dhttemp01		.byt 0

DisplayHIRESChar
	tay
	lda CharacterAddressLo-32,y
.(
	sta vector1+1
	lda CharacterAddressHi-32,y
	sta vector1+2
	ldx #5
vector1	lda $dead,x
	ldy ScreenOFS,x
	sta (screen),y
	dex
	bpl vector1
.)
	rts

;Parsed
;(header+13) 3 bytes encoded in BCD to be displayed as 5 digit decimal to HIRES screen
;+00
DisplayCharacterGrotes
	ldy #13
	sty temp01
.(
	;Avoid first digit MSB
	jmp skip1
loop1	ldy temp01
	lda (header),y
	lsr
	lsr
	lsr
	lsr
	jsr dcgDisplayDigit
	lda #1
	jsr add_screen

skip1	ldy temp01
	lda (header),y
	and #15
	jsr dcgDisplayDigit
	lda #1
	jsr add_screen

	inc temp01
	lda temp01
	cmp #16
	bcc loop1
.)
	rts

;Parsed
;A 0-9 Digit
dcgDisplayDigit
	clc
	adc #48
	jmp DisplayHIRESChar




DisplayCharacterTemplate

	; Fetch screen base for form
	ldx EntryIndex
	lda EntryScreenBaseLo,x
	sta screen
	lda EntryScreenBaseHi,x
	sta screen+1

	lda #<CharacterFormTemplate
	sta source
	lda #>CharacterFormTemplate
	sta source+1

	ldx #23
.(
loop2	ldy #39
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	jsr nl_source
	jsr nl_screen
	dex
	bne loop2
.)
	rts



EntryScreenBaseLo
 .byt <$A848+40
 .byt <$A848+40+1080*1
 .byt <$A848+40+1080*2
 .byt <$A848+40+1080*3
EntryScreenBaseHi
 .byt >$A848+40
 .byt >$A848+40+1080*1
 .byt >$A848+40+1080*2
 .byt >$A848+40+1080*3
Rows2Top
 .byt 0
 .byt 28
 .byt 28*2
 .byt 28*3

CharacterFormTemplate	;40x23
 .byt 1,$40,$43,$7F,$7F,$55,$55,$6A,$68,$40,$4A,$40,$4A,$40,$4A,$40,$4A,$40,$55,$55
 .byt $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$50,%01000000
 .byt 1,$40,$40,$40,$40,$06,$40,$40,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$40,$40,$40,$40,$40,$40,$04,%01000000
 .byt 1,$40,$7F,$7F,$7F,$7A,$E1,$4A,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$01,$6A
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$6A,$03,$40,$07,$40,$01,$4A,$E1,$4A,%01000000
 .byt 1,$40,$40,$40,$40,$06,$E1,$40,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$40,$03
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$03,$03,$40,$07,$40,$40,$03,$E1,$04,%01000000
 .byt 1,$43,$7F,$7F,$7F,$7E,$40,$4C,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$01,$54
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$54,$03,$40,$02,$40,$01,$46,$40,$4D,%01010000
 .byt 1,$40,$40,$40,$40,$06,$50,$40,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$40,$03
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$02,$40,$40,$03,$50,$04,%01000000
 .byt 1,$47,$7F,$7F,$7F,$7E,$40,$4A,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$01,$48
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$48,$40,$40,$02,$40,$01,$4A,$40,$4A,%01101000
 .byt 1,$40,$40,$40,$40,$06,$50,$40,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$40,$03
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$02,$40,$40,$03,$50,$04,%01000000
 .byt 1,$47,$7F,$7F,$7F,$7E,$40,$4D,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$01,$54
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$54,$40,$40,$02,$40,$01,$56,$40,$4D,%01010100
 .byt 1,$40,$40,$40,$40,$06,$50,$40,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$03,$50,$04,%01000000
 .byt 1,$4F,$7F,$7F,$7F,$7E,$40,$4A,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$01,$6A
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$40,$4A,%01101000
 .byt 1,$40,$40,$40,$40,$06,$50,$01,$68,$40,$4A,$40,$4A,$40,$4A,$40,$4A,$40,$45,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$40,$40,$03,$50,$04,%01000000
 .byt 1,$4F,$7F,$7F,$7F,$7E,$40,$4D,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$01,$55
 .byt $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$56,$40,$4D,%01010100
 .byt 1,$40,$40,$40,$40,$06,$50,$40,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$40,$40,$03,$50,$04,%01000000
 .byt 1,$47,$7F,$7F,$7F,$7E,$40,$4A,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$01,$6A
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$6A,$60,$60,$60,$60,$60,$6A,$40,$4A,%01101000
 .byt 1,$40,$40,$40,$40,$06,$50,$40,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$40,$06
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$05,$40,$40,$40,$40,$40,$03,$50,$04,%01000000
 .byt 1,$47,$7F,$7F,$7F,$7E,$40,$4C,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$01,$54
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$54,$40,$40,$40,$40,$40,$56,$40,$4D,%01010000
 .byt 1,$40,$40,$40,$40,$06,$50,$40,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$40,$06
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$05,$40,$40,$40,$40,$40,$03,$50,$04,%01000000
 .byt 1,$43,$7F,$7F,$7F,$7E,$40,$4A,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$01,$48
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$48,$40,$40,$40,$40,$40,$4A,$40,$4A,%01100000
 .byt 1,$40,$40,$40,$40,$06,$50,$40,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$40,$06
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$05,$40,$40,$40,$40,$40,$03,$50,$04,%01000000
 .byt 1,$40,$7F,$7F,$7F,$75,$40,$55,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$01,$54
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$54,$41,$41,$41,$41,$41,$55,$40,$55,%01000000
 .byt 1,$40,$40,$40,$40,$40,$40,$40,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$40,$40,$40,$40,$40,$40,$04,%01000000
 .byt 1,$40,$43,$7F,$7E,$6A,$6A,$6A,$68,$40,$4A,$40,$4A,$40,$4A,$40,$4A,$40,$4A,$6A
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$68,%01000000

DisplayUpArrow
	ldx #32
.(
loop1	ldy duaScreenOffset,x
	lda selUpArrowGraphic,x
	sta $A767,y
	dex
	bpl loop1
.)
	rts
DeleteUpArrow
	ldx #32
	lda #64
.(
loop1	ldy duaScreenOffset,x
	sta $A767,y
	dex
	bpl loop1
.)
	rts

;Displayed at $A767
selUpArrowGraphic	;11x3
 .byt 4,$40,$40,$43,$15,$16,$15,$10,$40,$40,$40
 .byt 4,$40,$43,$15,$16,$13,$16,$15,$10,$40,$40
 .byt 4,$11,$15,$16,$13,$17,$13,$16,$15,$11,$10

duaScreenOffset
 .byt 0,1,2,3,4,5,6,7,8,9,10
 .byt 40,41,42,43,44,45,46,47,48,49,50
 .byt 80,81,82,83,84,85,86,87,88,89,90

DisplayDownArrow
	ldx #32
.(
loop1	ldy duaScreenOffset,x
	lda selDownArrowGraphic,x
	sta $B937+40,y
	dex
	bpl loop1
.)
	rts

DeleteDownArrow
	ldx #32
	lda #64
.(
loop1	ldy duaScreenOffset,x
	sta $B937+40,y
	dex
	bpl loop1
.)
	rts

;Displayed at $B937
selDownArrowGraphic
 .byt 4,$11,$15,$16,$13,$17,$13,$16,$15,$11,$10
 .byt 4,$40,$43,$15,$16,$13,$16,$15,$10,$40,$40
 .byt 4,$40,$40,$43,$15,$16,$15,$10,$40,$40,$40

;Parsed
;A Highlight Colour
HiliteForm

	sta temp01

	;Calculate screen location
	ldx CharacterListScreenIndex
	lda EntryScreenBaseLo,x
	sec
	sbc #80
	sta screen2
	lda EntryScreenBaseHi,x
	sbc #00
	sta screen2+1

	;Plot hilite
	ldx #00
	ldy #00
.(
loop1	lda screen2
	clc
	adc FormHiliteOffsetLo,x
	sta screen
	lda screen2+1
	adc FormHiliteOffsetHi,x
	sta screen+1
	lda FormHiliteByte,x
	cmp #4
	bne skip1
	lda temp01
skip1	sta (screen),y
	inx
	cpx #130
	bcc loop1
.)
	rts




FormHiliteByte	;130
 .byt 4,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt 4,%01000111,%01111000
 .byt 4,%01011110
 .byt 4,%01011000
 .byt 4,%01110000
 .byt 4,%01110000
 .byt 4,%01100000
 .byt 4,%01100000
 .byt 4,%01100000
 .byt 4,%01110000
 .byt 4,%01110000
 .byt 4,%01011000
 .byt 4,%01011110
 .byt 4,%01000111,%01111000
 .byt 4,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt %01000111,%01111000
 .byt 4,%01011110
 .byt 4,%01000110
 .byt 4,%01000011
 .byt 4,%01000001
 .byt 4,%01000001
 .byt 4,%01000001
 .byt 4,%01000001
 .byt 4,%01000011
 .byt 4,%01000011
 .byt 4,%01000110
 .byt 4,%01011110
 .byt %01000111,%01111000

FormHiliteOffsetLo
 .byt 0,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
 .byt 20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38
 .byt 40,41,42
 .byt 40*3,1+40*3
 .byt 40*5,1+40*5
 .byt <40*7,<1+40*7
 .byt <40*9,<1+40*9
 .byt <40*11,<1+40*11
 .byt <40*13,<1+40*13
 .byt <40*15,<1+40*15
 .byt <40*17,<1+40*17
 .byt <40*19,<1+40*19
 .byt <40*21,<1+40*21
 .byt <40*23,<1+40*23
 .byt <40*25,<1+40*25,<2+40*25
 .byt <40*26,<2+40*26,<3+40*26,<4+40*26,<5+40*26
 .byt <6+40*26,<7+40*26,<8+40*26,<9+40*26,<10+40*26
 .byt <11+40*26,<12+40*26,<13+40*26,<14+40*26,<15+40*26
 .byt <16+40*26,<17+40*26,<18+40*26,<19+40*26,<20+40*26
 .byt <21+40*26,<22+40*26,<23+40*26,<24+40*26,<25+40*26
 .byt <26+40*26,<27+40*26,<28+40*26,<29+40*26,<30+40*26
 .byt <31+40*26,<32+40*26,<33+40*26,<34+40*26,<35+40*26
 .byt <36+40*26,<37+40*26,<38+40*26

 .byt <38+40*1,<39+40*1
 .byt <38+40*3,<39+40*3
 .byt <38+40*5,<39+40*5
 .byt <38+40*7,<39+40*7
 .byt <38+40*9,<39+40*9
 .byt <38+40*11,<39+40*11
 .byt <38+40*13,<39+40*13
 .byt <38+40*15,<39+40*15
 .byt <38+40*17,<39+40*17
 .byt <38+40*19,<39+40*19
 .byt <38+40*21,<39+40*21
 .byt <38+40*23,<39+40*23
 .byt <38+40*25,<39+40*25


FormHiliteOffsetHi
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0
 .byt 0,0,0
 .byt 0,0
 .byt 0,0
 .byt >40*7,>1+40*7
 .byt >40*9,>1+40*9
 .byt >40*11,>1+40*11
 .byt >40*13,>1+40*13
 .byt >40*15,>1+40*15
 .byt >40*17,>1+40*17
 .byt >40*19,>1+40*19
 .byt >40*21,>1+40*21
 .byt >40*23,>1+40*23
 .byt >40*25,>1+40*25,>2+40*25
 .byt >40*26,>2+40*26,>3+40*26,>4+40*26,>5+40*26
 .byt >6+40*26,>7+40*26,>8+40*26,>9+40*26,>10+40*26
 .byt >11+40*26,>12+40*26,>13+40*26,>14+40*26,>15+40*26
 .byt >16+40*26,>17+40*26,>18+40*26,>19+40*26,>20+40*26
 .byt >21+40*26,>22+40*26,>23+40*26,>24+40*26,>25+40*26
 .byt >26+40*26,>27+40*26,>28+40*26,>29+40*26,>30+40*26
 .byt >31+40*26,>32+40*26,>33+40*26,>34+40*26,>35+40*26
 .byt >36+40*26,>37+40*26,>38+40*26

 .byt >38+40*1,>39+40*1
 .byt >38+40*3,>39+40*3
 .byt >38+40*5,>39+40*5
 .byt >38+40*7,>39+40*7
 .byt >38+40*9,>39+40*9
 .byt >38+40*11,>39+40*11
 .byt >38+40*13,>39+40*13
 .byt >38+40*15,>39+40*15
 .byt >38+40*17,>39+40*17
 .byt >38+40*19,>39+40*19
 .byt >38+40*21,>39+40*21
 .byt >38+40*23,>39+40*23
 .byt >38+40*25,>39+40*25


CharacterDetailTransition
	; Remove Hilite
	lda #00
	jsr HiliteForm

	;Remove both Arrows
	jsr DeleteDownArrow
	jsr DeleteUpArrow

	; Don't bother scrolling if character selected is already at top
	lda CharacterListScreenIndex
.(
	beq skip1

	;Copy Form and next row down to Screen Buffer
	ldx CharacterListScreenIndex
	lda EntryScreenBaseLo,x
	sta source
	sta screen2
	lda EntryScreenBaseHi,x
	sta source+1
	sta screen2+1
	lda #<ScreenBuffer
	sta screen
	lda #>ScreenBuffer
	sta screen+1
	jsr ZoomForm

	; Calc number of pixel rows to scroll to top
	ldx CharacterListScreenIndex
	lda Rows2Top,x
	lsr
	sta temp01

loop1	lda screen2
	sec
	sbc #80
	sta screen2
	sta screen
	lda screen2+1
	sbc #00
	sta screen2+1
	sta screen+1

	lda #<ScreenBuffer
	sta source
	lda #>ScreenBuffer
	sta source+1

	jsr ZoomForm

	dec temp01
	bne loop1

	;Infinitum
skip1	nop
	jmp skip1
.)

ZoomForm	ldx #25
.(
loop2	ldy #39
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	jsr nl_source
	jsr nl_screen
	dex
	bne loop2
.)
	rts


ScreenBuffer
 .dsb 40*25,64
