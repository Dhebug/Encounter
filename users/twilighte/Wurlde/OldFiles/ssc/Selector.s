;Selector.s
;Selector currently planned for main game memory to covers Inns, Market and Shops

;When displaying drunkards, Health and Mana should oscillate.

SelectorDriver
	;Test it for now
	ldx #03
	stx EntryIndex
	lda #00
	sta CharacterID
.(
loop1	jsr DisplayCharacterForm
	dec EntryIndex
	bpl loop1
.)
	;Infinite loop
infinitum	nop
	jmp infinitum

EntryIndex	.byt 0
CharacterID	.byt 0
;Parsed
; CharacterID ID of Character the form represents
; EntryIndex Index of the entry on screen (0-3)
DisplayCharacterForm
	jsr DisplayCharacterTemplate

	; Fetch property list for character
	ldx CharacterID
	lda GameCharacterPropertyListLo,x
	sta source
	lda GameCharacterPropertyListHi,x
	sta source+1

	; Convert Grotes BCD to text
	jsr ConvertCharactersBCD2TEXT

	; Fetch screen base for form
	ldx EntryIndex
	lda EntryScreenBaseLo,x
	sta screen2
	lda EntryScreenBaseHi,x
	sta screen2+1

	ldy #00
	sty CharacterFormField
.(
loop1	; Calc screen location of field
	ldy CharacterFormField
	lda CharacterFormFieldScreenOffsetLo,y
	clc
	adc screen2
	sta screen
	lda CharacterFormFieldScreenOffsetHi,y
	clc
	adc screen2+1
	sta screen+1

	; Fetch the code vector that will display this information
	lda CharacterFormFieldDisplayVectorLo,y
	sta vector1+1
	lda CharacterFormFieldDisplayVectorHi,y
	sta vector1+2

	; Fetch Field Value
	lda (source),y

	; Display Field Value
vector1	jsr $dead

	; Proceed to next Field
	inc CharacterFormField
	ldy CharacterFormField
	cpy #40
	bcc loop1
.)
	; Fetch Face Graphic location
	ldy #43
	lda (source),y
	tax
	iny
	lda (source),y
	sta source+1
	stx source

	; Set Face Screen Location
	lda screen
	clc
	adc #<$FA-$59
	sta screen
.(
	bcc skip1
	inc screen+1
skip1
.)
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



;A contains Health 0(Low) to 15(High)
;screen2 points to bottom entry
DisplayCharacterMana   ;+01
DisplayCharacterHealth ;+00
	sta temp01
	ldx #00
	ldy #00
.(
loop1	lda TubeByteGraphic,x
	sta (screen),y
	lda #40
	jsr ssc_SubScreen
	inx
	dec temp01
	bpl loop1
.)
	rts

TubeByteGraphic
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

;Parsed
;A 0-63(Item) +64(Hidden so show ?) or 128(No Item)
DisplayCharacterItem   ;+02
	; Decide what to show
	cmp #128
.(
	bcs NoShow
	cmp #64
	bcs ShowQuestionMark

	; Capture Item graphic address
	tax
	lda ItemGraphicLo,x
	sta source
	lda ItemGraphicHi,x
	sta source+1

	; Display item
	jmp DisplayItem
NoShow	rts
ShowQuestionMark
.)
	lda #20
	jmp DisplayCharacterItem


DisplayCharacterInfo   ;+13
	clc
	adc #3
;Parsed
;A Female(0) Male(1) Unknown(2)
;Graphic always 2x7
DisplayCharacterGender ;+12
	tax
	lda CharacterGenderGraphicLo,x
	sta source
	lda CharacterGenderGraphicHi,x
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
 .byt <GenderUnknownGraphic
 .byt <InfoGraphicOff
 .byt <InfoGraphicOn
CharacterOtherGraphicHi
 .byt >GenderFemaleGraphic
 .byt >GenderMaleGraphic
 .byt >GenderUnknownGraphic
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
GenderUnknownGraphic
 .byt 3,%01011100
 .byt 3,%01110110
 .byt 3,%01001100
 .byt 3,%01011000
 .byt 3,3
 .byt 1,%01011000
 .byt 1,%01011000
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


DisplayCharactersAlpha ;+20
	;convert to hires character address
	tay
	lda CharacterAddressLo-32,y
	sta source
	lda CharacterAddressHi-32,y
	sta source+1

	;Display HIRES Character
	ldx #05
.(
loop1	ldy SourceOFS,x
	lda (source),y
	ldy ScreenOFS,x
	sta (screen),y
	dex
	bpl loop1
.)
	rts


ConvertCharactersBCD2TEXT
	rts

EntryScreenBaseLo
 .byt <$A7F8
 .byt <$AC58
 .byt <$AC58+$460
 .byt <$AC58+$460*2
EntryScreenBaseHi
 .byt >$A7F8
 .byt >$AC58
 .byt >$AC58+$460
 .byt >$AC58+$460*2

CharacterFormField	.byt 0

CharacterFormFieldScreenOffsetLo
 .byt <325
 .byt <344

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

 .byt <$C7-$59
 .byt <$C9-$59

 .byt <$2CF-$59
 .byt <$2D0-$59
 .byt <$2D1-$59
 .byt <$2D2-$59
 .byt <$2D3-$59
 .byt <$2D4-$59

 .byt <$E4-$59
 .byt <$E5-$59
 .byt <$E6-$59
 .byt <$E7-$59
 .byt <$E8-$59
 .byt <$E9-$59
 .byt <$EA-$59
 .byt <$EB-$59
 .byt <$EC-$59
 .byt <$ED-$59

 .byt <$2C4-$59
 .byt <$2C5-$59
 .byt <$2C6-$59
 .byt <$2C7-$59
 .byt <$2C8-$59
 .byt <$2C9-$59
 .byt <$2CA-$59
 .byt <$2CB-$59
 .byt <$2CC-$59
 .byt <$2CD-$59
CharacterFormFieldScreenOffsetHi
 .byt >325
 .byt >344

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

 .byt >$C7-$59
 .byt >$C9-$59

 .byt >$2CF-$59
 .byt >$2D0-$59
 .byt >$2D1-$59
 .byt >$2D2-$59
 .byt >$2D3-$59
 .byt >$2D4-$59

 .byt >$E4-$59
 .byt >$E5-$59
 .byt >$E6-$59
 .byt >$E7-$59
 .byt >$E8-$59
 .byt >$E9-$59
 .byt >$EA-$59
 .byt >$EB-$59
 .byt >$EC-$59
 .byt >$ED-$59

 .byt >$2C4-$59
 .byt >$2C5-$59
 .byt >$2C6-$59
 .byt >$2C7-$59
 .byt >$2C8-$59
 .byt >$2C9-$59
 .byt >$2CA-$59
 .byt >$2CB-$59
 .byt >$2CC-$59
 .byt >$2CD-$59

CharacterFormFieldDisplayVectorLo
 .byt <DisplayCharacterHealth	;+00
 .byt <DisplayCharacterMana   ;+01

 .byt <DisplayCharacterItem   ;+02
 .byt <DisplayCharacterItem   ;+03
 .byt <DisplayCharacterItem   ;+04
 .byt <DisplayCharacterItem   ;+05
 .byt <DisplayCharacterItem   ;+06
 .byt <DisplayCharacterItem   ;+07
 .byt <DisplayCharacterItem   ;+08
 .byt <DisplayCharacterItem   ;+09
 .byt <DisplayCharacterItem   ;+10
 .byt <DisplayCharacterItem   ;+11

 .byt <DisplayCharacterGender ;+12
 .byt <DisplayCharacterInfo   ;+13

 .byt <DisplayCharactersAlpha ;+14
 .byt <DisplayCharactersAlpha ;+15
 .byt <DisplayCharactersAlpha ;+16
 .byt <DisplayCharactersAlpha ;+17
 .byt <DisplayCharactersAlpha ;+18
 .byt <DisplayCharactersAlpha ;+19

 .byt <DisplayCharactersAlpha ;+20
 .byt <DisplayCharactersAlpha ;+21
 .byt <DisplayCharactersAlpha ;+22
 .byt <DisplayCharactersAlpha ;+23
 .byt <DisplayCharactersAlpha ;+24
 .byt <DisplayCharactersAlpha ;+25
 .byt <DisplayCharactersAlpha ;+26
 .byt <DisplayCharactersAlpha ;+27
 .byt <DisplayCharactersAlpha ;+28
 .byt <DisplayCharactersAlpha ;+29

 .byt <DisplayCharactersAlpha ;+30
 .byt <DisplayCharactersAlpha ;+31
 .byt <DisplayCharactersAlpha ;+32
 .byt <DisplayCharactersAlpha ;+33
 .byt <DisplayCharactersAlpha ;+34
 .byt <DisplayCharactersAlpha ;+35
 .byt <DisplayCharactersAlpha ;+36
 .byt <DisplayCharactersAlpha ;+37
 .byt <DisplayCharactersAlpha ;+38
 .byt <DisplayCharactersAlpha ;+39
CharacterFormFieldDisplayVectorHi
 .byt >DisplayCharacterHealth	;+00
 .byt >DisplayCharacterMana   ;+01

 .byt >DisplayCharacterItem   ;+02
 .byt >DisplayCharacterItem   ;+03
 .byt >DisplayCharacterItem   ;+04
 .byt >DisplayCharacterItem   ;+05
 .byt >DisplayCharacterItem   ;+06
 .byt >DisplayCharacterItem   ;+07
 .byt >DisplayCharacterItem   ;+08
 .byt >DisplayCharacterItem   ;+09
 .byt >DisplayCharacterItem   ;+10
 .byt >DisplayCharacterItem   ;+11

 .byt >DisplayCharacterGender ;+12
 .byt >DisplayCharacterInfo   ;+13

 .byt >DisplayCharactersAlpha ;+14
 .byt >DisplayCharactersAlpha ;+15
 .byt >DisplayCharactersAlpha ;+16
 .byt >DisplayCharactersAlpha ;+17
 .byt >DisplayCharactersAlpha ;+18
 .byt >DisplayCharactersAlpha ;+19

 .byt >DisplayCharactersAlpha ;+20
 .byt >DisplayCharactersAlpha ;+21
 .byt >DisplayCharactersAlpha ;+22
 .byt >DisplayCharactersAlpha ;+23
 .byt >DisplayCharactersAlpha ;+24
 .byt >DisplayCharactersAlpha ;+25
 .byt >DisplayCharactersAlpha ;+26
 .byt >DisplayCharactersAlpha ;+27
 .byt >DisplayCharactersAlpha ;+28
 .byt >DisplayCharactersAlpha ;+29

 .byt >DisplayCharactersAlpha ;+30
 .byt >DisplayCharactersAlpha ;+31
 .byt >DisplayCharactersAlpha ;+32
 .byt >DisplayCharactersAlpha ;+33
 .byt >DisplayCharactersAlpha ;+34
 .byt >DisplayCharactersAlpha ;+35
 .byt >DisplayCharactersAlpha ;+36
 .byt >DisplayCharactersAlpha ;+37
 .byt >DisplayCharactersAlpha ;+38
 .byt >DisplayCharactersAlpha ;+39

CharacterFormTemplate	;40x23
 .byt 1,$40,$43,$7F,$7F,$55,$55,$6A,$68,$40,$4A,$40,$4A,$40,$4A,$40,$4A,$40,$55,$55
 .byt $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$50,%01000000
 .byt 1,$40,$40,$40,$40,$06,$40,$40,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$40,$40,$40,$40,$40,$40,$04,%01000000
 .byt 1,$40,$7F,$7F,$7F,$7A,$E1,$4A,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$01,$6A
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$6A,$03,$40,$07,$40,$01,$4A,$E1,$4A,%01000000
 .byt 1,$40,$40,$40,$40,$06,$E1,$40,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$40,$05
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$03,$03,$40,$07,$40,$40,$03,$E1,$04,%01000000
 .byt 1,$43,$7F,$7F,$7F,$7E,$40,$4C,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$01,$54
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$54,$03,$40,$02,$40,$01,$46,$40,$4D,%01010000
 .byt 1,$40,$40,$40,$40,$06,$50,$40,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$40,$05
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$02,$40,$40,$03,$50,$04,%01000000
 .byt 1,$47,$7F,$7F,$7F,$7E,$40,$4A,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$01,$48
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$48,$40,$40,$02,$40,$01,$4A,$40,$4A,%01101000
 .byt 1,$40,$40,$40,$40,$06,$50,$40,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$40,$05
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$02,$40,$40,$03,$50,$04,%01000000
 .byt 1,$47,$7F,$7F,$7F,$7E,$40,$4D,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$01,$54
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$54,$40,$40,$02,$40,$01,$56,$40,$4D,%01010100
 .byt 1,$40,$40,$40,$40,$07,$EF,$40,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$03,$50,$04,%01000000
 .byt 1,$4F,$7F,$7F,$7F,$7E,$40,$4A,$06,$40,$06,$40,$06,$40,$06,$40,$06,$40,$01,$6A
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$40,$4A,%01101000
 .byt 1,$40,$40,$40,$40,$07,$EF,$01,$68,$40,$4A,$40,$4A,$40,$4A,$40,$4A,$40,$45,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$40,$40,$03,$50,$04,%01000000
 .byt 1,$4F,$7F,$7F,$7F,$7E,$40,$4D,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$01,$55
 .byt $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$56,$40,$4D,%01010100
 .byt 1,$40,$40,$40,$40,$07,$EF,$40,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$40,$40,$07,$EF,$04,%01000000
 .byt 1,$47,$7F,$7F,$7F,$7E,$40,$4A,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$01,$6A
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$6A,$60,$60,$60,$60,$60,$6A,$40,$4A,%01101000
 .byt 1,$40,$40,$40,$40,$07,$EF,$40,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$40,$06
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$03,$40,$40,$40,$40,$40,$07,$EF,$04,%01000000
 .byt 1,$47,$7F,$7F,$7F,$7E,$40,$4C,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$01,$54
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$54,$40,$40,$40,$40,$40,$56,$40,$4D,%01010000
 .byt 1,$40,$40,$40,$40,$07,$EF,$40,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$40,$06
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$03,$40,$40,$40,$40,$40,$07,$EF,$04,%01000000
 .byt 1,$43,$7F,$7F,$7F,$7E,$40,$4A,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$01,$48
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$48,$40,$40,$40,$40,$40,$6A,$40,$4A,%01100000
 .byt 1,$40,$40,$40,$40,$07,$EF,$40,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$40,$06
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$03,$40,$40,$40,$40,$40,$07,$EF,$04,%01000000
 .byt 1,$40,$7F,$7F,$7F,$75,$40,$55,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$01,$54
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$54,$41,$41,$41,$41,$41,$55,$40,$55,%01000000
 .byt 1,$40,$40,$40,$40,$40,$40,$40,$06,$40,$06,$40,$06,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$01,$40,$40,$40,$40,$40,$40,$40,$40,$04,%01000000
 .byt 1,$40,$43,$7F,$7E,$6A,$6A,$6A,$68,$40,$4A,$40,$4A,$40,$4A,$40,$4A,$40,$4A,$6A
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$68,%01000000

