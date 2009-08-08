;Selector - Complete Creature Interaction interface (CII)
#define	fhgJump	128

;Selector Control
;Lcursor Select Character Left
;Rcursor Select Character Right
;Ucursor Move up Options
;Dcursor Move Down Options
;Action  Select Option
;Escape  Leave
SelectorDriver
	; Display Enter Text (held in SSC)
	lda ssc_EnteringTextVectorLo
	sta text
	lda ssc_EnteringTextVectorHi
	sta text+1
	ldx #8+128
	ldy #0
	jsr DisplayText

	jsr DisplayFormItemCursor

	jsr ManageCharacterMovements
	
	; Accumulate Location Specifics
	jsr AccumulateLocationInfo

	; Display all Character faces and Frames
	jsr DisplayCharacterFaces

	; Setup Default Options
	lda #00
	sta OptionSet
	sta SelectedOption
	sta SelectedCharacter

	;Display Form Template
	jsr DrawFormTemplate

	; Refresh the selected character
	jsr DisplayCharacterForm


	; Inverse Selected line
	jsr InverseSelectedLine
.(
loop2	; Wait on Key
	jsr WaitOnKey

	; Locate recognised key
	lda KeyRegister
	ldx #05
loop1	cmp SelectorKeys,x
	beq skip1
	dex
	bpl loop1
	jmp loop2

skip1	; Branch to key routine
	lda SelectorKeysVectorLo,x
	sta vector1+1
	lda SelectorKeysVectorHi,x
	sta vector1+2
vector1	jsr $dead
	jmp loop2
.)

AccumulateLocationInfo
	ldx #00
	ldy #00
	sty UltimateCharacterIndex

	;Add Hero
	lda #32
	sta LocalCharacters,y

.(
loop1	;Fetch location of Character Block
	jsr CalcCharacterBlockLoc

	; Is Character Used?
	ldy #01
	lda (source2),y
	bmi skip1

	; Is Character at this location?
	lsr
	lsr
	and #15
	cmp ssc_LocationID
	bne skip1

	; Compile in list
	inc UltimateCharacterIndex
	ldy UltimateCharacterIndex
	txa
	sta LocalCharacters,y

skip1	; Proceed to next
	inx
	cpx #32
	bcc loop1
.)
	rts

UltimateCharacterIndex	.byt 0
LocalCharacters
 .dsb 32,0

CalcCharacterBlockLoc
	txa
	asl
	asl
	asl
	adc #<CharacterBlocks
	sta source2
	lda #>CharacterBlocks
	adc #00
	sta source2+1
	rts

;Display only as many frames as faces
DisplayCharacterFaces
	;Display Red Ink Column (alt lines) for Frames
	jsr DisplayRedInkColumn

	ldx #00
	stx CharacterIndex
.(
loop1	jsr DisplayCharacterFrame
	jsr DisplayCharacterFace

	; Proceed to next frame position
	inc CharacterIndex
	lda CharacterIndex
	cmp UltimateCharacterIndex
	beq loop1
	bcc loop1
.)
	rts

CharacterIndex	.byt 0

DisplayRedInkColumn
	lda #<$A870
	sta screen
	lda #>$A870
	sta screen+1
	ldx #12
	ldy #00
.(
loop1	lda #01
	sta (screen),y
	jsr nl_screen
	jsr nl_screen
	dex
	bne loop1
.)
	rts

; Draw standard Frame and modify if hero
DisplayCharacterFrame
	lda #<FaceTemplateGraphic
	sta source
	lda #>FaceTemplateGraphic
	sta source+1
	ldx CharacterIndex
	lda FaceFrameScreenLocLo,x
	sta screen
	lda FaceFrameScreenLocHi,x
	sta screen+1
	lda #12
	sta FrameRowCount
.(
loop2	ldy #4
loop1	lda (source),y

	;Modify for hero
	cmp #1
	bne skip1
	ldx CharacterIndex
	bne skip1
	lda #3


skip1	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	jsr nl_screen
	lda #5
	jsr add_source
	dec FrameRowCount
	bne loop2
.)
	rts

FrameRowCount	.byt 0
FaceTemplateGraphic	;Every alt row 5x12
 .byt 1,%01111111,%01111111,%01111111,%01110000
 .byt %01000011,%01111111,%01111111,%01111111,%01111100
 .byt %01000111,%01111111,%01111111,%01111111,%01111110
 .byt %01000111,%01111111,%01111111,%01111111,%01111110
 .byt %01000111,%01111111,%01111111,%01111111,%01111110
 .byt %01000111,%01111111,%01111111,%01111111,%01111110
 .byt %01000111,%01111111,%01111111,%01111111,%01111110
 .byt %01000111,%01111111,%01111111,%01111111,%01111110
 .byt %01000111,%01111111,%01111111,%01111111,%01111110
 .byt %01000111,%01111111,%01111111,%01111111,%01111110
 .byt %01000011,%01111111,%01111111,%01111111,%01111100
 .byt 1,%01111111,%01111111,%01111111,%01110000
FaceFrameScreenLocLo
 .byt <$A871
 .byt <$A871+5*1
 .byt <$A871+5*2
 .byt <$A871+5*3
 .byt <$A871+5*4
 .byt <$A871+5*5
 .byt <$A871+5*6
FaceFrameScreenLocHi
 .byt >$A871
 .byt >$A871+5*1
 .byt >$A871+5*2
 .byt >$A871+5*3
 .byt >$A871+5*4
 .byt >$A871+5*5
 .byt >$A871+5*6

DisplayCharacterFace
	ldx CharacterIndex
	lda LocalCharacters,x
	cmp #32
.(
	bcc skip1

skip4	;Fetch hero face loc
	lda #<HeroLucien
	sta source
	lda #>HeroLucien
	sta source+1
	jmp skip2

skip1	jsr LocateCharacterInfoTableInSSC
skip2	;
.)
	ldx CharacterIndex
	lda FaceFrameScreenLocLo,x
	clc
	adc #161
	sta screen
	lda FaceFrameScreenLocHi,x
	adc #00
	sta screen+1
	ldx #15
	ldy #03
	jmp CopySource2Screen

LocateCharacterInfoTableInSSC
	;Fetch location of character list in SSC module
	lda ssc_CharacterListVectorLo
	sta source
	lda ssc_CharacterListVectorHi
	sta source+1
	;Locate character in SSCCharacterList
	ldy #255
.(
loop1	iny
	lda (source),y
	cmp #255
	beq skip1
	;Extract top 5 bits
	lsr
	lsr
	lsr
	cmp LocalCharacters,x
	bne loop1

	;From the index of the found Character multiply by 4
	tya
	asl
	asl
	tay

	;Fetch location of character info table
	lda ssc_CharacterInfoVectorLo
	sta source
	lda ssc_CharacterInfoVectorHi
	sta source+1

	;Fetch the Face graphic loc in SSC module
	lda (source),y
	tax
	iny
	lda (source),y
	stx source
	sta source+1
	rts
skip1	;Default face to hero
	lda #<HeroLucien
	sta source
	lda #>HeroLucien
	sta source+1
	rts

.)
DrawTopLineBorder
	lda #127
	ldx #39
.(
loop1	sta $A000+40*79,x
	dex
	bne loop1
.)
	rts

DisplayCharacterForm
	;Draw top line border
	jsr DrawTopLineBorder

	;Display Frame Highlight
	jsr DrawFrameHighlight

	; Display Form contents
	ldy SelectedCharacter	;0-6
	lda LocalCharacters,y
	sta CurrentCharacter	;0-32

	;Fetch location of Character Block
	tax
	jsr CalcCharacterBlockLoc

	jsr DisplayCharacterName
	jsr DisplayCharacterGroup
	jsr DisplayCharacterDescription
	clc
	jsr DisplayCharacterItems
	jsr DisplayCharacterHealth
	jsr DisplayCharacterMana
	jsr DisplayCharacterGender
	jsr DisplayCharacterAllegiance
	lda #00
	sta OptionSet
	jsr DisplayCharacterOptions
	jsr DisplayCharacterGrotes
	rts

DrawFormTemplate
	lda #<FormTemplateGraphic
	sta source
	lda #>FormTemplateGraphic
	sta source+1
	lda #<$AC58
	sta screen
	lda #>$AC58
	sta screen+1
	ldx #85
	ldy #40
	jmp CopySource2Screen

InverseSelectedLine
	; Locate Option text screen location
	ldy SelectedOption
	lda FormOptionsScreenYLOCL,y
	sec
	sbc #40
	sta screen
	lda FormOptionsScreenYLOCH,y
	sbc #00
	sta screen+1

	;Inverse complete 16x5
	ldx #7
.(
loop2	ldy #15
loop1	lda (screen),y
	eor #128
	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	dex
	bne loop2
.)
	rts

FormOptionsScreenYLOCL
 .byt <$AD5E
 .byt <$AD5E+240*1
 .byt <$AD5E+240*2
 .byt <$AD5E+240*3
 .byt <$AD5E+240*4
 .byt <$AD5E+240*5
 .byt <$AD5E+240*6
 .byt <$AD5E+240*7
 .byt <$AD5E+240*8
 .byt <$AD5E+240*9
 .byt <$AD5E+240*10
 .byt <$AD5E+240*11
FormOptionsScreenYLOCH
 .byt >$AD5E
 .byt >$AD5E+240*1
 .byt >$AD5E+240*2
 .byt >$AD5E+240*3
 .byt >$AD5E+240*4
 .byt >$AD5E+240*5
 .byt >$AD5E+240*6
 .byt >$AD5E+240*7
 .byt >$AD5E+240*8
 .byt >$AD5E+240*9
 .byt >$AD5E+240*10
 .byt >$AD5E+240*11




SelectedCharacter	.byt 0	;0-15
SelectedOption	.byt 0	;0-11
SelectorKeys
 .byt 1,2,4,8,16,64
SelectorKeysVectorLo
 .byt <sk_Left
 .byt <sk_Right
 .byt <sk_Up
 .byt <sk_Down
 .byt <sk_Action
 .byt <sk_Escape
SelectorKeysVectorHi
 .byt >sk_Left
 .byt >sk_Right
 .byt >sk_Up
 .byt >sk_Down
 .byt >sk_Action
 .byt >sk_Escape

;Select character left
sk_Left	; Is there another character left?
	lda SelectedCharacter
.(
	beq skip1

	; Inverse Selected line(Off)
	jsr InverseSelectedLine

	;Delete Frame Highlight
	jsr DeleteFrameHighlight

	;Decrement character
	dec SelectedCharacter

	; Reset Option selected
	lda #00
	sta SelectedOption
	sta OptionSet

	; Refresh the selected character
	jsr DisplayCharacterForm

	; Inverse Selected line(On)
	jsr InverseSelectedLine

skip1	rts
.)

sk_Right	; Is there another character Right?
	lda SelectedCharacter
.(
	cmp UltimateCharacterIndex
	bcs skip1

	; Inverse Selected line(Off)
	jsr InverseSelectedLine

	;Delete Frame Highlight
	jsr DeleteFrameHighlight

	;Decrement character
	inc SelectedCharacter

	; Reset Option selected
	lda #00
	sta SelectedOption
	sta OptionSet

	; Refresh the selected character
	jsr DisplayCharacterForm

	; Inverse Selected line(On)
	jsr InverseSelectedLine

skip1	rts
.)

sk_Up
	lda SelectedOption
.(
	beq skip1

	; Inverse Selected line(Off)
	jsr InverseSelectedLine


	; Decrement selected option
	dec SelectedOption

	; Inverse Selected line(On)
	jsr InverseSelectedLine

skip1	rts
.)

sk_Down
	;If LastOption is FF then prohibit down
	lda LastOption
.(
	bmi skip1

	lda SelectedOption
	cmp LastOption
	bcs skip1

	; Inverse Selected line(Off)
	jsr InverseSelectedLine

	; Increment selected option
	inc SelectedOption

	; Inverse Selected line(On)
	jsr InverseSelectedLine

skip1	rts
.)

;Execute option selected
;Based on OptionSet & SelectedOption
sk_Action
	;Remember last KeywordsLearntIndex
	lda KeywordsLearntIndex
	sta LastKeywordsLearntIndex
	
	;If last option is FF (no options) then prohibit Action key
	lda LastOption
.(
	bpl skip1
	rts

skip1	;Combine OptionSet(0-3) with SelectedOption(0-11)
.)
	lda OptionSet

	;Mult12
	asl
	asl
.(
	sta vector1+1
	asl
vector1	adc #00
.)
	; Are we talking OptionSet0?
.(
	bne skip1

	; Fetch from OptionList instead with SelectedOption
	ldy SelectedOption
	adc OptionList,y
	jmp skip2


skip1	;Add SelectedOption
	adc SelectedOption

skip2	; Use to Index OptionActionCodeLo/Hi
.)
	tax
	lda OptionActionCodeLo,x
.(
	sta vector1+1
	lda OptionActionCodeHi,x
	sta vector1+2
vector1	jsr $dead
.)
	;were we enquiring about a keyword?
	lda OptionSet
	cmp #1
.(
	bne skip1
	
	;Have we learnt more keywords now?
	lda LastKeywordsLearntIndex
	cmp KeywordsLearntIndex
	beq skip1
	
	; Inverse Selected line(Off)
	jsr InverseSelectedLine
	
	;Redisplay character options in order to display new keywords
	jsr DisplayCharacterOptions

	; Inverse Selected line(On)
	jsr InverseSelectedLine
	
skip1	rts
.)
	
LastKeywordsLearntIndex	.byt 0
OptionActionCodeLo
 .byt <oacCombine	;OptionSet0 - Character Interaction
 .byt <oacEnquire
 .byt <oacRumours
 .byt <oacExamine
 .byt <oacLodging
 .byt <oacBuyItem
 .byt <oacSellItem
 .byt <oacCompliment
 .byt <oacInsult
 .byt <oacLend
 .byt <oacSpare
 .byt <oacBuyAle

 .byt <oacKeyword		;OptionSet1 - Keywords
 .byt <oacKeyword
 .byt <oacKeyword
 .byt <oacKeyword
 .byt <oacKeyword
 .byt <oacKeyword
 .byt <oacKeyword
 .byt <oacKeyword
 .byt <oacKeyword
 .byt <oacKeyword
 .byt <oacKeyword
 .byt <oacKeyword

 .byt <oacAccept		;OptionSet2 - Haggling
 .byt <oacHaggle
 .byt <oacCompliment
 .byt <oacBuyAle
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare

 .byt <oacYes		;OptionSet3 - Yes/No Prompt
 .byt <oacNo
 .byt <oacCancel
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare
 .byt <oacSpare

OptionActionCodeHi
 .byt >oacCombine	;OptionSet0 - Character Interaction
 .byt >oacEnquire
 .byt >oacRumours
 .byt >oacExamine
 .byt >oacLodging
 .byt >oacBuyItem
 .byt >oacSellItem
 .byt >oacCompliment
 .byt >oacInsult
 .byt >oacLend
 .byt >oacSpare
 .byt >oacBuyAle

 .byt >oacKeyword		;OptionSet1 - Keywords
 .byt >oacKeyword
 .byt >oacKeyword
 .byt >oacKeyword
 .byt >oacKeyword
 .byt >oacKeyword
 .byt >oacKeyword
 .byt >oacKeyword
 .byt >oacKeyword
 .byt >oacKeyword
 .byt >oacKeyword
 .byt >oacKeyword

 .byt >oacAccept		;OptionSet2 - Haggling
 .byt >oacHaggle
 .byt >oacCompliment
 .byt >oacBuyAle
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare

 .byt >oacYes		;OptionSet3 - Yes/No Prompt
 .byt >oacNo
 .byt >oacCancel
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare
 .byt >oacSpare

;Attempt to Combine Posessed Items
oacCombine	;OptionSet0 - Character Interaction

;Ask Question about 'Keyword' to character - Check CharacterInteraction blocks
oacEnquire	;OptionSet0 - Character Interaction
	; Inverse Selected line(Off)
	jsr InverseSelectedLine

	lda #01
	sta OptionSet
	lda #00
	sta SelectedOption

	jsr DisplayCharacterOptions

	; Inverse Selected line(On)
	jsr InverseSelectedLine

	lda #00
	sta SelectedOption

	ldx #1
	jmp DisplayPrompt

DisplayPrompt
	lda OptionPromptLo,x
	sta text
	lda OptionPromptHi,x
	sta text+1
	ldx #8+128
	ldy #0
	jmp DisplayText


;Ask about rumours to character - Response Depends on character
;Rumour text derives from SSC.
oacRumours	;OptionSet0 - Character Interaction
	;Fetch Interaction Header address
	lda ssc_InteractionHeaderVectorLo
	sta source
	lda ssc_InteractionHeaderVectorHi
	sta source+1

	;Fetch number of interactions
	ldy #00
	lda (source),y
;	sta UltimateInteractions
	tax

	sty RumourFoundFlag
	sty ThisCharacter
	lda CurrentCharacter
	clc
	adc #144
	sta oacrCharID

	;Cycle once to count number of rumours appropriate to this character

	ldy #01
.(
loop1	;Fetch vector address of interaction
	lda (source),y
	sta source2
	iny
	lda (source),y
	sta source2+1
	sty oacrtempy

	;Scan up to "]" for characterID (144-175)
	ldy #00
loop2	lda (source2),y	;Fetch interaction header
	cmp oacrCharID	;Is it CharacterID?
	bne skip2
	dec ThisCharacter	;Sets flag to minus
	jmp skip3
skip2	cmp #"$"		;Is this interaction a rumour?
	bne skip3
	bit ThisCharacter	;was the character found?
	bpl skip3
	;Found rumour for character
	inc RumourFoundFlag
skip3	iny		;Proceed to next byte in interactions header
	cmp #"]"
	bne loop2

	lda RumourFoundFlag	;Branch if rumour found
	bne skip1

	lda #00		;Reset Character found flag
	sta ThisCharacter
	ldy oacrtempy	;Restore Y and proceed to next interaction header
	iny
	dex
	bpl loop1
	;No rumours found for character so select one of 4 default messages
	lda #3
	jsr GetRNDRange
	tay
	lda RumourDenialTextLo,y
	sta text
	lda RumourDenialTextHi,y
	sta text+1
	jmp skip4

skip1	;Rumour found
;	iny
	tya
	clc
	adc source2
	sta text
	lda source2+1
	adc #00
	sta text+1
skip4	ldx #8+128
.)
	ldy #0
	jsr DisplayText

	;If one keyword then redisplay options to display Enquire (incase enquire.. did not exist before)
	lda KeywordsLearntIndex
.(
	bne skip1
	jsr InverseSelectedLine
	jsr DisplayCharacterOptions
	jsr InverseSelectedLine
skip1	rts
.)

oacrtempy		.byt 0
RumourFoundFlag     .byt 0
oacrCharID	.byt 0
ThisCharacter	.byt 0

;Examine own or characters items
; * Items shown may depend on characters intoxication level
; * A description of each item should be shown in window above
oacExamine	;OptionSet0 - Character Interaction
	;Display Prompt
	ldx #5
	jsr DisplayPrompt

	; Inverse Selected line(Off) to take focus to Item cursor
	jsr InverseSelectedLine

	;Tell Selector we're examining
	lda #1
	sta TradingType
	
	;Launch Item Selector
	jsr ItemSelector

	; Inverse Selected line(Off) to take focus to Item cursor
	jsr InverseSelectedLine

	; "Select Option or Character.."
	ldx #0
	jmp DisplayPrompt


;Seek lodging from Innkeeper or Staff
oacLodging	;OptionSet0 - Character Interaction
	rts
;Now we have just an option to buy (which then includes Lodging and Ale)
oacBuyItem
	; Does hero have spare pockets?
	jsr CountHeroPocketsUsed
	cmp #10
.(
	bcc skip4
	
	ldx #10
	jmp DisplayPrompt
	
skip4	; Display Prompt
	ldx #6	;"Select item you wish to buy.."
	jsr DisplayPrompt
	
	;Tell ItemSelector we're buying
	lda #00
	sta TradingType

	; Inverse Selected line(Off) to take focus to Item cursor
	jsr InverseSelectedLine

	;Launch Item Selector
	jsr ItemSelector

	; Inverse Selected line(Off) to take focus to Item cursor
	jsr InverseSelectedLine

	; Branch if itemselector was aborted
	lda fiscKey
	cmp #kcM
	beq skip7
	
	; Fetch Object index (128 for no item selected)
	ldx SelectedObject
	bpl skip6
skip7	rts	
skip6	; Cannot buy if item hidden
	lda Objects_B,x
	and #2
	beq skip5

	ldx #11
	jmp DisplayPrompt

skip5	; Fetch objects price (What the character is selling it for)
	lda CurrentSellingPrice
	sta TempPrice
	
	; For now just buy it
	jsr HasHeroEnoughGrotes

	bcs Enough
	
	ldx #8
	jmp DisplayPrompt
	
Enough	lda TempPrice
	jsr TakeMoneyFromHero
	
	;
	lda TempPrice
	jsr GiveCharacterMoney
	
	; Lodging is a special case - Don't add to heroes inventory or take from characters,
	; but save game and restore health
	
	; Is object in infinite supply?
	ldy SelectedObject
	lda Objects_C,y
	and #64
	beq skip2
	; For infinite items we'll need to create a new object
	; since we cannot transfer item to hero
	ldx #127
loop1	lda Objects_C,x
	; Any unused items have Object_C Bit 7 set
	bmi skip3
	dex
	bpl loop1
	;No free objects
	jmp skip1
skip3	;Transfer source object details to target object and assign to hero
	lda Objects_A,y
	sta Objects_A,x
	lda Objects_B,y
	sta Objects_B,x
	lda Objects_C,y
	;remove infinite flag and mask out ownership
	and #%10110000
	;then give hero ownership
	ora #LS_HELDBYHERO
	sta Objects_C,x
	jmp rent1

	
skip2	; Assign item to hero 
	ldx SelectedObject
	lda Objects_C,x
	and #%11110000
	ora #LS_HELDBYHERO
	sta Objects_C,x

rent1	; Redisplay Heroes money
	jsr UpdateAllScreenGrotes
	
	; Redisplay Heroes items in infopanel
	sec
	jsr DisplayPockets
	
	; Redisplay Characters items
	clc
	jsr DisplayPockets

	; "Select Option or Character.."
	ldx #0
	jsr DisplayPrompt

	; Finally refresh the Options list (bought item may be first so need to show sell item)
	jsr DisplayCharacterOptions
	jsr InverseSelectedLine
	
	jsr DeleteInventoryPointer
	
skip1	rts
.)	
	
	; Display Slumber stuff
	ldx #9
	jsr DisplayPrompt

	;Save Playerfile

	;Restore Hero Health
	lda #15
	sta HeroHealth

	rts

SelectedObject	.byt 0
TempPrice		.byt 0


;Attempt to Sell item to character - Response depends on character
oacSellItem	;OptionSet0 - Character Interaction
	; Does Character have spare pockets?
	lda CurrentCharacter
	jsr CountCharacterPocketsUsed
	cmp #10
.(
	bcc skip4
	
	ldx #10
	jmp DisplayPrompt
	
skip4	; Display Prompt
;	ldx #7	;"Select item you wish to sell.."
;	jsr DisplayPrompt
	
	;Tell ItemSelector we're selling
	lda #128
	sta TradingType

	; Inverse Selected line(Off) to take focus to Item cursor
	jsr InverseSelectedLine

	;Launch Item Selector
	jsr ItemSelector

	; Inverse Selected line(Off) to take focus to Item cursor
	jsr InverseSelectedLine

	; Branch if itemselector was aborted
	lda fiscKey
	cmp #kcM
	bne skip3
skip6	rts
	
skip3	; Fetch Object index (128 for no item selected)
	sec
	jsr LocateObjectForSelectedItem
	bmi skip6
	
	; Cannot sell if item hidden
	lda Objects_B,x
	and #2
	beq skip5

	ldx #12
	jmp DisplayPrompt

skip5	; Calculate the objects price (Multiply by time of day or game progression)
	lda CurrentBuyingPrice
	sta TempPrice 
	; For now just buy it
	jsr HasCharacterEnoughGrotes

	bcs Enough
	
	lda CurrentCharacter
	adc #144
	sta OptionPrompt13
	ldx #13
	jmp DisplayPrompt
	
Enough	lda TempPrice
	jsr TakeMoneyFromCharacter
	
	lda TempPrice
	jsr GiveHeroMoney
	
	; Need to add code here for..
	; "If object already owned by character and 'infinite supply' then Remove object"
	; Fetch Item
	sec
	jsr LocateObjectForSelectedItem
	lda Objects_B,x
	lsr
	lsr
	lsr
	jsr IsCurrentCharacterHoldingObject	;x==index else x=128
	cpx #128
	bcs skip2
	
	;Is object infinite?
	lda Objects_C,x
	and #%01000000
	beq skip2
	
	;Remove Item
	sec
	jsr LocateObjectForSelectedItem
	lda #128
	sta Objects_C,x
	jmp rent1
	
skip2	;Transfer object details to character
	sec
	jsr LocateObjectForSelectedItem
;	ldx SelectedObject
	lda Objects_C,x
	and #%10110000
	ora #LS_HELDBYCREATURE
	sta Objects_C,x
	;Now transfer ownership
	lda Objects_A,x	;A0-4  CreatureID(0-31)
	and #%11100000
	ora CurrentCharacter
	sta Objects_A,x
	;Remove Infinite flag
	
rent1	; Redisplay Heroes money
	jsr UpdateAllScreenGrotes
	
;	; Redisplay Characters money
;	jsr DisplayCharacterGrotes
	
	; Redisplay Heroes items in infopanel
	sec
	jsr DisplayPockets
	
	; Redisplay Characters items
	clc
	jsr DisplayPockets

	; "Select Option or Character.."
	ldx #0
	jsr DisplayPrompt
	
	; Finally refresh the Options list (Sold item may be last)
	jsr DisplayCharacterOptions
	jsr InverseSelectedLine

skip1	rts
.)

;Compliment character
oacCompliment	;OptionSet0 - Character Interaction & OptionSet2 - Haggling
	rts
;Insult Character
oacInsult		;OptionSet0 - Character Interaction
	rts
;Lend character item in heroes posession
oacLend             ;OptionSet0 - Character Interaction
	rts
;Recall item held by Character
oacRecall		;OptionSet0 - Character Interaction
	rts

FetchCurrentCharacterBlockIndex
	lda CurrentCharacter
	asl
	asl
	asl
	tay
	rts


;Can be used to..
; Character Action
; Hero      Buy Ale for self
; character Buy character ale
oacBuyAle  	;OptionSet0 - Character Interaction
	rts
;	;Have we hero selected?
;	lda CurrentCharacter
;	cmp #32
;.(
;	bcc HandleCharacter
;HandleHero
;	;Buy Ale for self
;	lda price_Ale
;	jsr HasHeroEnoughGrotes
;	bcs Enough
;NotEnoughrent
;	jmp NotEnough
;
;Enough	;Subtract from heroes money
;	lda price_Ale
;	jsr TakeMoneyFromHero
;
;	; Redisplay Heroes money
;	jsr UpdateAllScreenGrotes
;
;	jmp DrinkingHero
;
;HandleCharacter
;;	nop
;;	jmp HandleCharacter
;	; Fetch Characters IQ
;	jsr FetchCurrentCharacterBlockIndex
;	lda CharacterBlocks+4,y
;	and #15
;	; Is character willing to drink alone?
;	cmp #WiseDrinkingThreshhold
;	bcs WiseDrinker
;
;	;Buy character Ale
;	lda price_Ale
;	jsr HasHeroEnoughGrotes
;	bcc NotEnoughrent
;
;	;Subtract from heroes money
;	lda price_Ale
;	jsr TakeMoneyFromHero
;
;	; Redisplay Heroes money
;	jsr UpdateAllScreenGrotes
;
;	;Increment Characters ToxicLevel
;	jsr FetchCurrentCharacterBlockIndex
;	lda CharacterBlocks+3,y
;	and #%00001111
;	cmp #15
;	bcs skip3
;	adc #1
;	sta temp01
;	lda CharacterBlocks+3,y
;	and #%11110000
;	ora temp01
;	sta CharacterBlocks+3,y
;
;skip3	;"You buy ? an Ale"
;	ldy SelectedCharacter
;	lda LocalCharacters,y
;	clc
;	adc #144
;	sta EmbeddedText254+8
;	lda #8+128
;	ldx #0
;	ldy #158
;	jsr DisplayBlockField
;
;
;	;Check characters new toxicity level
;	jsr FetchCurrentCharacterBlockIndex
;	lda CharacterBlocks+3,y
;	lsr
;	lsr
;	lsr
;	lsr
;	cmp temp01
;	bcs skip1	;StillSober
;
;	;Set character to drunk
;	lda CharacterBlocks+2,y
;	ora #%00000100
;	sta CharacterBlocks+2,y
;
;	;"? is drunk"
;	lda CurrentCharacter
;	clc
;	adc #144
;	sta EmbeddedText253
;	lda #8+128
;	ldx #0
;	ldy #157
;	jsr DisplayBlockField
;
;	;Reveal characters next hidden object
;	jsr RevealCharactersNextHiddenObject
;	bcc skip1	;NoneHidden
;
;	; Show object
;	lda Objects_B,x
;	and #%11111011
;	sta Objects_B,x
;
;	; Redisplay Characters objects
;	jsr DisplayCharacterItems
;
;skip1	rts
;
;
;WiseDrinker
; 	;"? Refuses to drink alone."
; 	;"Are you willing to buy a round for"
;	;"both you and your guest?"
;	lda CurrentCharacter
;	clc
;	adc #144	;48
;	sta EmbeddedText252
;	lda #8+128
;	ldx #0
;	ldy #156
;	jsr DisplayBlockField
;	;for now, rts
;	rts
;
;
;NotEnough	;Hero does not have enough grotes to buy ale
;	lda #8+128
;	ldx #0
;	ldy #159
;	jmp DisplayBlockField
;.)


DrinkingHero
	lda #8+128
	ldx #0
	ldy #155	;EmbeddedText251
	jsr DisplayBlockField

	; Increment Hero's toxic level
	inc HeroToxicLevel

	; Is hero drunk?
	lda HeroToxicLevel
	cmp HeroToxicLimit
.(
	bcc skip1

	; "You are Drunk!"
	lda #8+128
	ldx #0
	ldy #154
	jsr DisplayBlockField

	; Corrupt options
	lda #1
	sta DrunkOptionsFlag

	; Is hero too drunk?
	lda HeroToxicLevel
	cmp #DrunkArrestThreshhold
	bcc skip1

	; Arrest Hero
	lda #8+128
	ldx #1
	ldy #154
	jsr DisplayBlockField

skip1	rts
.)
DrunkOptionsFlag	.byt 0

RevealCharactersNextHiddenObject
	ldx #00
.(
loop1	; Is object held by a creature?
	lda Objects_C,x
	and #15
	cmp #LS_HELDBYCREATURE
	bne skip2

	; Is object held by this creature?
	lda Objects_A,x
	and #31
	cmp CurrentCharacter
	bne skip2

	; Is object hidden?
	sec
	lda Objects_B,x
	and #%00000100
	bne skip1

skip2	; Otherwise progress to next object
	inx
	bpl loop1
	clc
skip1	rts
.)

UpdateAllScreenGrotes
	jsr UpdateHeroGrotes
	ldx CurrentCharacter
	jsr CalcCharacterBlockLoc
	jmp DisplayCharacterGrotes





;Question regards selected keyword to CurrentCharacter
oacKeyword 	;OptionSet1 - Keywords
	;Selected option is keywordslearnt index
	ldx SelectedOption
	lda KeywordsLearnt,x
	sta AskAboutThisKeyword

	lda #00
	sta keywordfoundflag

	;Fetch Interactions Header
	lda ssc_InteractionHeaderVectorLo
	sta source
	lda ssc_InteractionHeaderVectorHi
	sta source+1

	;Fetch Interaction Count
	ldy #00
	lda (source),y
	tax
.(
loop2	;Scan all interactions for one that meets criteria
	iny
	lda (source),y
	sta source2
	iny
	lda (source),y
	sta source2+1

	stx oackTempX
	sty oackTempY

	ldy #00
loop1	lda (source2),y
	;Breakdown element type
	jsr FetchEmbeddedElementID
	cpx #2
	beq ClauseSuccessful
	pha
	lda EmbeddedElementClauseCodeLo,x
	sta vector1+1
	lda EmbeddedElementClauseCodeHi,x
	sta vector1+2
	pla
	sty oackTempY2
vector1	jsr $dead
	ldy oackTempY2
	bcc ClauseFailed
	iny
	jmp loop1

ClauseFailed
	ldx oackTempX
	ldy oackTempY

	;Progress to next interaction
	dex
	bpl loop2

	;Display "Sorry i know nothing about that"
	lda #<ExtraText0
	sta text
	lda #>ExtraText0
	sta text+1
	ldx #8+128
	ldy #0
	jmp DisplayText


ClauseSuccessful
	;However if the keyword we are asking about was not found in the interaction then the clause failed
	lda keywordfoundflag
	beq ClauseFailed
.)
	;Display text after "]" in source2
	iny
	tya
	clc
	adc source2
	sta text
	lda source2+1
	adc #00
	sta text+1
	ldx #8+128
	ldy #0
	jmp DisplayText




FetchEmbeddedElementID
	ldx #9
.(
loop1	dex
	cmp EmbeddedElementThreshhold,x
	bcc loop1
.)
	sbc EmbeddedElementThreshhold,x
	rts
EmbeddedElementThreshhold
 .byt 0,"$","]",128,144,176,208,224,240
EmbeddedElementClauseCodeLo
 .byt <ClauseCode4ObjectPosessed
 .byt <ClauseCode4Rumour
 .byt <ClauseCode4EndOfPassage
 .byt <ClauseCode4OfGroup
 .byt <ClauseCode4IsCharacter
 .byt <ClauseCode4AskingAboutKeyword
 .byt <ClauseCode4CharacterHealthIs
 .byt <ClauseCode4CharacterToxicityIs
 .byt <ClauseCode4SubgameComplete
EmbeddedElementClauseCodeHi
 .byt >ClauseCode4ObjectPosessed
 .byt >ClauseCode4Rumour
 .byt >ClauseCode4EndOfPassage
 .byt >ClauseCode4OfGroup
 .byt >ClauseCode4IsCharacter
 .byt >ClauseCode4AskingAboutKeyword
 .byt >ClauseCode4CharacterHealthIs
 .byt >ClauseCode4CharacterToxicityIs
 .byt >ClauseCode4SubgameComplete

;0-31 	Only if the hero posesses the specified object will the character deliver this message
;"$"	Rumour Flag (If omitted then always treated as Interaction)
;128-143	Only the Character of specified Group will deliver this message
;144-175	Only specified Character or Characters will deliver this message
;176-207	Only if the hero posesses the specified keyword will the character deliver this message
;208-223	Only when the character is at the specified Health level will he deliver this message
;224-239  Only at the specified level of drunkedness(0-15) will the character deliver this message
;240-255	Only if the hero posesses the specified Grotes(100-1600) will the character deliver this message

ClauseCode4Rumour		;If found clause failed!
ClauseCode4EndOfPassage	;This routine is never reached
	clc
	rts

;Can corrupt X and Y and A(Although A contains zero based element)
ClauseCode4ObjectPosessed
	;Is Object held by hero?
	sta clausetemp01

	;Locate object
	ldx #00
.(
loop1	lda Objects_B,x
	lsr
	lsr
	lsr
	cmp clausetemp01
	beq skip1
	inx
	bpl loop1
rent1	clc
	rts

skip1	;Is object held by hero?
	lda Objects_C,x
	and #15
	cmp #LS_HELDBYHERO
	bne rent1
.)
	rts

ClauseCode4OfGroup
	;Is Character of the Group in A?
	sta clausetemp01
	lda CurrentCharacter
	asl
	asl
	asl
	tax
	lda CharacterBlocks+2,x
	lsr
	lsr
	lsr
	lsr
	cmp clausetemp01
.(
	beq skip1
	clc
skip1	rts
.)

ClauseCode4IsCharacter
	cmp CurrentCharacter
.(
	beq skip1
	clc
skip1	rts
.)

ClauseCode4AskingAboutKeyword
	;Bring keyword code back up to embedded range (+80)
	clc
	adc #$50
	;If the keyword found in the interaction matches the keyword being asked about then set
	;keywordfoundflag otherwise check if hero knows this keyword.
	cmp AskAboutThisKeyword
.(
	beq skip1
	clc
	rts
skip1	inc keywordfoundflag
	rts
.)
	
;.(
;	bne skip3
;	inc keywordfoundflag
;skip3
;	ldx KeywordsLearntIndex
;
;	bmi skip1
;loop1	cmp KeywordsLearnt,x
;	beq skip2
;	dex
;	bpl loop1
;skip1	clc
;skip2	rts
;.)

ClauseCode4CharacterHealthIs
	sta clausetemp01
	lda CurrentCharacter
	asl
	asl
	asl
	tax
	lda CharacterBlocks,x
	and #15
	cmp clausetemp01
.(
	beq skip1
	clc
skip1	rts
.)

ClauseCode4CharacterToxicityIs
	sta clausetemp01
	lda CurrentCharacter
	asl
	asl
	asl
	tax
	lda CharacterBlocks+3,x
	and #15
	cmp clausetemp01
.(
	beq skip1
	clc
skip1	rts
.)

ClauseCode4SubgameComplete
	tax
	lda SubGameProperty,x
	and #%00000010
	lsr
	lsr
	rts

AskAboutThisKeyword	.byt 0
keywordfoundflag	.byt 0
clausetemp01	.byt 0
oackTempY		.byt 0
oackTempY2	.byt 0
oackTempX		.byt 0

;Accept CurrentPrice for item
oacAccept		;OptionSet2 - Haggling

;Haggle character for better price - Depends on character and group
oacHaggle         	;OptionSet2 - Haggling

;Confirm Yes
oacYes		;OptionSet3 - Yes/No Prompt

;Confirm No
oacNo

;Cancel
oacCancel

;Similar to Buy Ale for character except..
; For hero      Will buy ale enough for all occupants and self
;		Eg. 6 thirsty looking friends suddenly appear
; For character Will buy ale for character and self
oacBuyRound
oacSpare
	rts

;The item selector is used to examine, buy or sell items to and from a character.
;it may also be used to examine your own items.
;TradingType
;  0   Hero Buying
;  1   Hero Examining
;  128 Hero Selling
ItemSelector
.(
loop3	jsr DisplaySelectedFormItemDescription
	jsr DisplaySelectedFormItemPrices
loop2	jsr DisplayFormItemCursor
	jsr WaitOnKey
	jsr DeleteFormItemCursor

;B0 left
;B1 right
;B2 up
;B3 down
;B4 left-ctrl
;B6 Escape
	lda #00
	sta CyclePocketRepeating

	lda KeyRegister
	sta fiscKey
	ldx #03
loop1	cmp FormItemSelectorKey,x
	beq skip1
	dex
	bpl loop1
	jmp loop2

skip1	lda FormItemSelectorKeyVectorLo,x
	sta vector1+1
	lda FormItemSelectorKeyVectorHi,x
	sta vector1+2
vector1	jsr $dead
	jmp loop3
.)



;Display both buying and selling prices contextually together with prompt in bottom window
;>>>>>>***********************************
;EmbeddedText249
; .byt 144," is selling the ",0,"%"
; .byt "for 00 Grotes and is willing to buy%"
; .byt "any you have for 00 Grotes.%"
; .byt "Press Action key to buy, Inventory%"
; .byt "key to Sell, Navigate to another%"
; .byt "item or press ESC to quit.]"
DisplaySelectedFormItemPrices
	ldy #150	;Set Y to Message for examining
	lda TradingType	;0 if Buying, 128 if Selling
.(
	bmi skip1	;Hero Selling
	bne rent1	;Hero Examining
	; Hero is buying - Character is selling
	lda CurrentCharacter	;0-31
	; Insert Character name tag into text
	clc
	adc #144
	sta EmbeddedText249_CharacterName
	
	; Insert Item name tag into text
	ldx SelectedObject		;
	;However if the selected item is 128 then no selected item and branch
	bmi DisplayDefaultEmptyMessage
	lda Objects_B,x
	lsr
	lsr
	lsr
	sta EmbeddedText249_ItemName
	
	; Insert Selling Price
	jsr CalculateSellingPrice	;Returns bnsOfferPrice
	; Display BCD High Selling Price
	lda bnsOfferPrice
	sta CurrentSellingPrice
	lsr
	lsr
	lsr
	lsr
	ora #48
	sta EmbeddedText249_SellPrice
	; Display BCD Low Selling Price
	lda bnsOfferPrice
	and #15
	ora #48
	sta EmbeddedText249_SellPrice+1
	
	; Now display text
	ldy #153
rent1	ldx #0
	lda #8+128
	jsr DisplayBlockField
	
	sec
	jmp DisplayPockets
	
DisplayDefaultEmptyMessage
	ldy #152
	jmp rent1

skip1	;Hero is selling - Character is buying
	lda CurrentCharacter	;0-31
	; Insert Character name tag into text
	clc
	adc #144
	sta EmbeddedText247_CharacterName
	
	; Insert Item name tag into text
	sec
	jsr LocateObjectForSelectedItem
	;However if the selected item is 128 then no selected item and branch
	bmi DisplayDefaultEmptyMessage
	lda Objects_B,x
	lsr
	lsr
	lsr
	sta EmbeddedText247_ItemName
	
	; Insert Selling Price
	jsr CalculateBuyingPrice	;Returns bnsOfferPrice
	; Display BCD High Selling Price
	lda bnsOfferPrice
	sta CurrentBuyingPrice
	lsr
	lsr
	lsr
	lsr
	ora #48
	sta EmbeddedText247_BuyPrice
	; Display BCD Low Selling Price
	lda bnsOfferPrice
	and #15
	ora #48
	sta EmbeddedText247_BuyPrice+1
	
	; Now display text
	ldy #151
	jmp rent1
.)
TradingType	.byt 0
CurrentBuyingPrice	.byt 0
CurrentSellingPrice	.byt 0
FormItemSelectorKey
 .byt kcL
 .byt kcR
 .byt kcA		;Buy or Sell
 .byt kcM		;Abort
FormItemSelectorKeyVectorLo
 .byt <fiscLeft
 .byt <fiscRight
 .byt <fiscAction
 .byt <fiscEscape
FormItemSelectorKeyVectorHi
 .byt >fiscLeft
 .byt >fiscRight
 .byt >fiscAction
 .byt >fiscEscape
fiscKey
 .byt 0	;Last key pressed before exiting Selector (So we can capture ESC or Action)

fiscLeft
	lda TradingType
.(
	bmi skip3
	; Fetch selected pocket(0-9)
	lda FormSelectedPocket

	; Is it 0?
	bne skip1

	; Reset to 9
	lda #9
	jmp skip2

skip1	sec
	sbc #01
skip2	sta FormSelectedPocket
	rts
skip3	jmp CyclePocketLeft
.)


fiscRight
;	nop
;	jmp fiscRight
	lda TradingType
.(
	bmi skip3
	; Fetch selected pocket(0-9)
	lda FormSelectedPocket

	; Is it 9?
	cmp #9
	bne skip1

	; Reset to 0
	lda #0
	jmp skip2

skip1	clc
	adc #01
skip2	sta FormSelectedPocket
	rts
skip3	jmp CyclePocketRight
.)

fiscAction
	pla
	pla
	sec
	rts
fiscEscape
	;Retract JSR to here and RTS
	pla
	pla
	jsr DeleteFormItemCursor
	clc
	rts


DisplaySelectedFormItemDescription
	;Priority is first to get the selected object - Is selected character the hero?
	lda TradingType
	cmp #128
	;Carry 0(Character) or 1(Hero)
	jsr LocateObjectForSelectedItem
	;Store it
	stx SelectedObject

	clc
	; If the hero then can only show Shortname in infopanel
	lda TradingType
.(
	bmi skip2
	beq skip3
	;Examining - is hero selected?
	lda CurrentCharacter
	cmp #32
;	bcc skip3
;	;Ensure selected pockets are the same
;	lda FormSelectedPocket
;	sta HeroSelectedPocket
	
skip3	; Is an item in this pocket?
	jsr LocateObjectForSelectedItem
	bmi NothingHere

	; Store Objects index so we may pick it up later to directly locate item
	stx SelectedObject
	
	; Is this item hidden?
	lda Objects_B,x
	lsr
	lsr
	bcc ShownObject

	; Direct text displayed to "Hidden item"
	ldy #23
	jmp skip1
NothingHere
	lda #128
	sta SelectedObject
	ldy #24
skip1	ldx #1

	lda #5+128
	jmp DisplayBlockField

ShownObject
	; Fetch ObjectID
	lsr

	; Locate and display description of item
	tay
	ldx #1
	lda #5+128
	jmp DisplayBlockField
skip2	jmp DisplayHeroItemText
.)

DisplayFormItemCursor
	; If the hero is selling need to highlight infopanel cursor otherwise form cursor
	lda TradingType
.(
	bmi DisplayInfoPanelCursor
	; Fetch both cursor screen locations
	ldx FormSelectedPocket
	lda FormItemTopCursorScreenLo,x
	sta vector1+1
	lda FormItemTopCursorScreenHi,x
	sta vector1+2
	lda FormItemLowCursorScreenLo,x
	sta vector2+1
	lda FormItemLowCursorScreenHi,x
	sta vector2+2

	; Display Cursors
	ldx #03

loop1	ldy FormCursorOffset,x
	lda FormCursorTopGraphic,x
vector1	sta $dead,y
	lda FormCursorLowGraphic,x
vector2	sta $dead,y
	dex
	bpl loop1
	rts
DisplayInfoPanelCursor
.)
	jmp UpdateInventoryPointer


FormCursorOffset
 .byt 0,1,80,81
FormItemTopCursorScreenLo
 .byt <$B33B
 .byt <$B33B+2*1
 .byt <$B33B+2*2
 .byt <$B33B+2*3
 .byt <$B33B+2*4
FormItemLowCursorScreenLo
 .byt <$B5BB
 .byt <$B5BB+2*1
 .byt <$B5BB+2*2
 .byt <$B5BB+2*3
 .byt <$B5BB+2*4

 .byt <$B83B
 .byt <$B83B+2*1
 .byt <$B83B+2*2
 .byt <$B83B+2*3
 .byt <$B83B+2*4
FormItemTopCursorScreenHi
 .byt >$B33B
 .byt >$B33B+2*1
 .byt >$B33B+2*2
 .byt >$B33B+2*3
 .byt >$B33B+2*4
FormItemLowCursorScreenHi
 .byt >$B5BB
 .byt >$B5BB+2*1
 .byt >$B5BB+2*2
 .byt >$B5BB+2*3
 .byt >$B5BB+2*4

 .byt >$B83B
 .byt >$B83B+2*1
 .byt >$B83B+2*2
 .byt >$B83B+2*3
 .byt >$B83B+2*4


FormCursorTopGraphic
 .byt $40,$F3
FormCursorLowGraphic	;Can save 2 bytes by overlapping
 .byt $05,$4C
 .byt $40,$F3

DeleteFormItemCursor
	; If the hero is selling need to highlight infopanel cursor otherwise form cursor
	lda TradingType
.(
	bmi DeleteInfoPanelItemCursor
	; Fetch both cursor screen locations
	ldx FormSelectedPocket
	lda FormItemTopCursorScreenLo,x
	sta vector1+1
	lda FormItemTopCursorScreenHi,x
	sta vector1+2
	lda FormItemLowCursorScreenLo,x
	sta vector2+1
	lda FormItemLowCursorScreenHi,x
	sta vector2+2

	; Delete Cursors
	ldx #03
	lda #64
loop1	ldy FormCursorOffset,x
vector1	sta $dead,y
vector2	sta $dead,y
	dex
	bpl loop1
	rts
DeleteInfoPanelItemCursor
.)
	jmp DeleteInventoryPointer
	

;Jump back a menu or to game
;If in optionset0 (character interaction) return to game
;If in optionset1 (Keywords) recede to optionset0
;If in optionset2 (Haggle) recede to optionset0
;If in optionset3 (Yes/No) recede to optionset0
sk_Escape
	lda OptionSet
.(
	beq skip1	;Eventually returns to game

	; Inverse Selected line(Off)
	jsr InverseSelectedLine

	lda #00
	sta OptionSet

	; Refresh the selected character
	jsr DisplayCharacterForm

	; Inverse Selected line(On)
	jsr InverseSelectedLine

	rts
skip1	;Return to game
	pla
	pla
	jmp DisplayScreenProse
.)



DisplayCharacterName
	; Calc location of name
	lda CurrentCharacter
	cmp #32
.(
	bcs skip1	;Hero name

	adc #48
	tay
	ldx #0+128
	lda #3
	;A WindowID
	;Y Block ID
	;X Field Number(0-1)
	clc
	jmp DisplayBlockField


skip1	lda #<fdGeneralMessage03
	sta text
	lda #>fdGeneralMessage03
	sta text+1
.)
	; Display Text
	ldx #3
	ldy #00
	jmp DisplayText


DisplayCharacterGroup
	; Is Character the Hero?
	lda CurrentCharacter
	cmp #32
.(
	beq skip1

	; Fetch Group ID
	ldy #2
	lda (source2),y
	lsr
	lsr
	lsr
	lsr

	clc
	adc #32
	tay
	ldx #128
	lda #4
	;A WindowID
	;Y Block ID
	;X Field Number(0-1)
	clc
	jmp DisplayBlockField


skip1	; Fetch Lucien group
.)
	lda #<fdGeneralMessage02
	sta text
	lda #>fdGeneralMessage02
	sta text+1

	; Display Text
	ldx #4
	ldy #00
	jmp DisplayText

DisplayCharacterDescription
	; Is this character the hero?
	lda CurrentCharacter
	cmp #32
.(
	bcs skip1

          ; Fetch from SSC
          lda ssc_CharacterListVectorLo
          sta source
          lda ssc_CharacterListVectorHi
          sta source+1
          ldy #00
loop1     lda (source),y
	cmp #255
	beq skip1
	lsr
	lsr
	lsr
          cmp CurrentCharacter
          beq skip2
          iny
          jmp loop1	;Can't find it
skip2	tya
	asl
	asl
	adc #2
	tay
          lda ssc_CharacterInfoVectorLo
          sta source
          lda ssc_CharacterInfoVectorHi
          sta source+1
          lda (source),y
          sta text
          iny
          lda (source),y
          sta text+1
          jmp skip3
skip1	lda #<fdGeneralMessage01
	sta text
	lda #>fdGeneralMessage01
	sta text+1
skip3	; Display Text
.)
	ldx #5+128
	ldy #00
	jmp DisplayText

CurrentCharacter	.byt 0

;This either displays in form or in Hero info panel if carry set
DisplayCharacterItems
	clc
	jmp DisplayPockets

InfoPanelItemsFlag	.byt 0

ObjectItemIndexCount	.byt 0
ObjectScreenIndex		.byt 0

DisplayCharacterHealth
	; Fetch screen address (Bottom most row)
	lda #<$B6B7
	sta screen
	lda #>$B6B7
	sta screen+1

	; Is Character the hero?
	lda CurrentCharacter
	cmp #32
.(
	bne skip2

	; Fetch Hero Health
	lda HeroHealth
	jmp skip3

skip2	; Fetch Health value
	ldy #00
	lda (source2),y
	and #15

	;Branch if no health(Dead)
	beq skip1

skip3	; Plot upwards taking bytes from table
	sta temp01
	ldy #00
	ldx #00
loop1	lda HealthBarGraphic,x
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
	bne loop1

loop2	cpx #16
	bcs skip1

	; Erase rest of tube
	lda TubeEmptyGraphic,x
	sta (screen),y

	lda screen
	sec
	sbc #40
	sta screen
	lda screen+1
	sbc #00
	sta screen+1
	inx
	jmp loop2

skip1	rts
.)
HealthBarGraphic
 .byt $5E
 .byt $FF
 .byt $EF
 .byt $FF
 .byt $EF
 .byt $FF
 .byt $EF
 .byt $FF
 .byt $EF
 .byt $FF
 .byt $EF
 .byt $FF
 .byt $EF
 .byt $FF
 .byt $EF
 .byt $FF

DisplayCharacterMana
	; Fetch screen address (Bottom most row)
	lda #<$B6BC
	sta screen
	lda #>$B6BC
	sta screen+1

	; Is Character the hero?
	lda CurrentCharacter
	cmp #32
.(
	bne skip2

	; Fetch Hero Mana
	lda HeroMana
	jmp skip3

skip2	; Fetch Mana value
	ldy #00
	lda (source2),y
	lsr
	lsr
	lsr
	lsr

skip3	;Branch if no Mana
	beq skip1

	; Plot upwards taking bytes from table
	sta temp01
	ldy #00
	ldx #00
loop1	lda ManaBarGraphic,x
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
	bne loop1

loop2	cpx #16
	bcs skip1

	; Erase rest of tube
	lda TubeEmptyGraphic,x
	sta (screen),y

	lda screen
	sec
	sbc #40
	sta screen
	lda screen+1
	sbc #00
	sta screen+1
	inx
	jmp loop2

skip1	rts
.)

ManaBarGraphic
 .byt $5E
 .byt $EB
 .byt $EF
 .byt $E5
 .byt $EF
 .byt $ED
 .byt $EF
 .byt $EB
 .byt $EF
 .byt $E5
 .byt $EF
 .byt $ED
 .byt $EF
 .byt $EB
 .byt $EF
 .byt $E5
TubeEmptyGraphic
 .byt $40
 .byt $40
 .byt $50
 .byt $40
 .byt $50
 .byt $40
 .byt $50
 .byt $40
 .byt $50
 .byt $40
 .byt $50
 .byt $40
 .byt $50
 .byt $40
 .byt $50
 .byt $40


DisplayCharacterGender
	; Is Character Hero?
	lda CurrentCharacter
	cmp #32
.(
	bne skip1
	lda #1
	jmp skip2

skip1	;Fetch Gender Flag for character
	ldy #01
	lda (source2),y
	and #1

skip2	; Use to fetch Gender Graphic
.)
	tax
	lda GenderGraphicLo,x
	sta source
	lda GenderGraphicHi,x
	sta source+1

	; Set Screen Location
	lda #<$B3C1+40
	sta screen
	lda #>$B3C1+40
	sta screen+1

	ldx #7
	ldy #2
	jmp CopySource2Screen

GenderGraphicLo
 .byt <GenderFemaleGraphic
 .byt <GenderMaleGraphic
GenderGraphicHi
 .byt >GenderFemaleGraphic
 .byt >GenderMaleGraphic

GenderFemaleGraphic
 .byt %01000001,%01110000
 .byt %01000011,%01011000
 .byt %01000011,%01011000
 .byt %01000001,%01110000
 .byt %01000000,%01100000
 .byt %01000001,%01110000
 .byt %01000000,%01100000
GenderMaleGraphic
 .byt %01000000,%01011100
 .byt %01000000,%01001100
 .byt %01000000,%01010100
 .byt %01000111,%01000000
 .byt %01001101,%01100000
 .byt %01001101,%01100000
 .byt %01000111,%01000000

DisplayCharacterAllegiance
	; Is Character Hero?
	lda CurrentCharacter
	cmp #32
.(
	bne skip2
	lda #0
	jmp skip1

skip2	;Fetch Allegiance Flag for character
	ldy #01
	lda (source2),y
	and #%01000000
	beq skip1
	lda #01
skip1
.)
	; Use to fetch Allegiance(Friend or Foe) Graphic
	tax
	lda AllegianceGraphicLo,x
	sta source
	lda AllegianceGraphicHi,x
	sta source+1

	; Set Screen Location
	lda #<$B5A1+40
	sta screen
	lda #>$B5A1+40
	sta screen+1

	ldx #7
	ldy #2
	jmp CopySource2Screen

AllegianceGraphicLo
 .byt <FriendGraphic
 .byt <FoeGraphic
AllegianceGraphicHi
 .byt >FriendGraphic
 .byt >FoeGraphic

FriendGraphic
 .byt %01000011,%01011000
 .byt %01000111,%01111100
 .byt %01000111,%01111100
 .byt %01000011,%01111000
 .byt %01000011,%01111000
 .byt %01000001,%01110000
 .byt %01000000,%01100000
FoeGraphic
 .byt %01000110,%01001100
 .byt %01001111,%01001110
 .byt %01001110,%01011110
 .byt %01000111,%01001100
 .byt %01000111,%01001100
 .byt %01000011,%01101000
 .byt %01000001,%01000000

;Grotes (6 Digits) are still alligned to standard form text
UpdateHeroGrotes
	lda #2
	sta temp01
	jmp dcgrent1
DisplayCharacterGrotes
	lda #7
	sta temp01
	; Is character the Hero?
	lda CurrentCharacter
	cmp #32

	bne dcgskip1

dcgrent1	;Set source2 to point at HeroGrotes-5
	lda #<HeroGrotes-5
	sta source2
	lda #>HeroGrotes-5
	sta source2+1

dcgskip1	;Convert BCD encoded bytes to 6 digit decimal
	ldx #00
	ldy #5
.(
loop1	lda (source2),y
	lsr
	lsr
	lsr
	lsr
	clc
	adc #48
	sta BCDDigits,x
	inx
	lda (source2),y
	and #15
	clc
	adc #48
	sta BCDDigits,x
	inx

	iny
	cpy #8
	bcc loop1
.)
	;Display to screen
	lda #<BCDDigits
	sta text
	lda #>BCDDigits
	sta text+1
	ldx temp01
	ldy #0+128

	jmp DisplayText

BCDDigits
 .byt "      ]"

;Compile list of options then dump them to the screen
DisplayCharacterOptions
	ldx OptionSet
	lda BuildOptionsVectorLo,x
	sta vector1+1
	lda BuildOptionsVectorHi,x
	sta vector1+2
vector1	jsr $dead
;DisplayOptions takes directly from OptionListTextVectorLo/Hi indexed by LastOption
DisplayOptions
	;If no options available, then just clear options
	lda LastOption
.(
	bmi skip2
	ldy #00
	;If the lastoption is 0 then avoid loop
	cpy LastOption
	beq skip1
loop1	lda OptionListTextVectorLo,y
	sta text
	lda OptionListTextVectorHi,y
	sta text+1

	;If on last option (Equal to LastOption) then erase rest of window
	;X WindowID (+128 to clear to end of window)
	ldx #6
	;Y Row in window (+128 for non embedded single word like Grotes or Form Group)
	jsr DisplayText

	iny
	cpy LastOption
	bcc loop1
skip1	;Process last option separately so we can clear remaining rows
	lda OptionListTextVectorLo,y
	sta text
	lda OptionListTextVectorHi,y
	sta text+1
rent1	;X WindowID (+128 to clear to end of window)
	ldx #6+128
	;Y Row in window (+128 for non embedded single word like Grotes or Form Group)
	jmp DisplayText
skip2	;Special case when no options to display
	lda #<EmbeddedText224
	sta text
	lda #>EmbeddedText224
	sta text+1
	ldy #00
	jmp rent1
.)

OptionSet		.byt 0
OptionList
 .dsb 12,0
LastOption	.byt 0
BuildOptionsVectorLo
 .byt <BuildOptionSet00	; 0) Character interaction options or Hero Options
 .byt <BuildOptionSet01       ; 1) Learnt Keyword list
 .byt <BuildOptionSet02       ; 2) Price haggling options
 .byt <BuildOptionSet03       ; 3) Yes/No/Cancel
BuildOptionsVectorHi
 .byt >BuildOptionSet00	; 0) Character interaction options or Hero Options
 .byt >BuildOptionSet01       ; 1) Learnt Keyword list
 .byt >BuildOptionSet02       ; 2) Price haggling options
 .byt >BuildOptionSet03       ; 3) Yes/No/Cancel


;Character interaction options
;Builds OptionList to relate SelectedOption to Option identity
BuildOptionSet00
	ldx #00
;	jsr AddOption0	;"Combine Items"
	jsr AddOption1      ;"Ask about        "
	jsr AddOption2      ;"Ask about Rumours"
	jsr AddOption3      ;"Examine Items"
	jsr AddOption5      ;"Buy Item"
	jsr AddOption6      ;"Sell Item"
	jsr AddOption7      ;"Compliment"
	jsr AddOption8      ;"Insult"
	jsr AddOption9      ;"Loan Item"
	jsr AddOption10     ;"Withdraw Item"
	;Populate Option Text Vectors
	dex
	stx LastOption
	rts


;Learnt keyword list options
;This Option set holds a 1/1 relationship between OptionSelected and Option identity(keywordindex)
BuildOptionSet01
	ldx KeywordsLearntIndex
	stx LastOption
.(
loop1	ldy KeywordsLearnt,x
	lda EmbeddedTextAddressLo,y
	sta OptionListTextVectorLo,x
	lda EmbeddedTextAddressHi,y
	sta OptionListTextVectorHi,x
	dex
	bpl loop1
.)
	rts

CurrentPrice	;Held as 3 bcd
 .byt 0,0,0
AcceptText
 .byt "Accept * Grotes",255
OptionListTextVectorLo
 .dsb 12,0
OptionListTextVectorHi
 .dsb 12,0

;Price haggling options
;This Option set holds a 1/1 relationship between OptionSelected and Option identity
BuildOptionSet02
	;Compile first option from text with CurrentPrice
	;For the moment point directly to Accept text

	lda #<AcceptText
	sta OptionListTextVectorLo
	lda #>AcceptText
	sta OptionListTextVectorHi

	;Add Haggle option
	lda #<OptionListText12
	sta OptionListTextVectorLo+1
	lda #>OptionListText12
	sta OptionListTextVectorHi+1

	;Add Compliment option
	lda #<OptionListText07
	sta OptionListTextVectorLo+2
	lda #>OptionListText07
	sta OptionListTextVectorHi+2

	;Add Buy Ale option
	lda #<OptionListText11
	sta OptionListTextVectorLo+3
	lda #>OptionListText11
	sta OptionListTextVectorHi+3

	lda #3
	sta LastOption
	rts

;Yes/No Options
;This Option set holds a 1/1 relationship between OptionSelected and Option identity
BuildOptionSet03
	ldx #13
.(
loop1	lda OptionListTextLo,x
	sta OptionListTextVectorLo-13,x
	lda OptionListTextHi,x
	sta OptionListTextVectorHi-13,x

	inx
	cpx #16
	bcc loop1
.)
	lda #2
	sta LastOption
	rts


AddOptionVector
	lda OptionListTextLo,y
	sta OptionListTextVectorLo,x
	lda OptionListTextHi,y
	sta OptionListTextVectorHi,x
	tya
	sta OptionList,x
	rts



;Add if hero and he has 2 or more items
AddOption0      ;"Combine Items"
	; Is Character Hero?
	lda CurrentCharacter
.(
	cmp #32
	bne skip1

	; Does Hero have 2 or more items?
	jsr CountCharacterItems
	cmp #2
	bcc skip1

	; Add Option 0
	ldy #00
	jsr AddOptionVector
	inx

skip1	rts
.)


;Add if not hero but hero has one or more incomplete keywords
AddOption1      ;"Ask about        "
	; Is Character not hero?
	lda CurrentCharacter
.(
	cmp #32
	beq skip1

	; Does hero have one or more keywords?
	ldy KeywordsLearntIndex
	bmi skip1

	ldy #01
	jsr AddOptionVector
	inx

skip1	rts
.)

;Add if not hero
AddOption2      ;"Ask about Rumours"
	lda CurrentCharacter
.(
	cmp #32
	beq skip1

	ldy #02
	jsr AddOptionVector
	inx

skip1	rts
.)

;Add if character has items
AddOption3      ;"Examine Items"
	lda CurrentCharacter
	jsr CountCharacterItems
	cmp #00
.(
	beq skip1

	ldy #03
	jsr AddOptionVector
	inx

skip1	rts
.)

;Add if not hero and character has items
AddOption5      ;"Buy Item"
	lda CurrentCharacter
.(
	cmp #32
	beq skip1

	jsr CountCharacterItems
	cmp #00
	beq skip1

	ldy #05
	jsr AddOptionVector
	inx

skip1	rts
.)

;Add if not hero and Hero has items
AddOption6      ;"Sell Item"
	lda CurrentCharacter
.(
	cmp #32
	beq skip1

	lda #32
	jsr CountCharacterItems
	cmp #00
	beq skip1

	ldy #06
	jsr AddOptionVector
	inx

skip1	rts
.)

;Add if not hero
AddOption7      ;"Compliment"
	lda CurrentCharacter
.(
	cmp #32
	beq skip1

	ldy #07
	jsr AddOptionVector
	inx

skip1	rts
.)

;Add if not hero
AddOption8      ;"Insult"
	lda CurrentCharacter
.(
	cmp #32
	beq skip1

	ldy #08
	jsr AddOptionVector
	inx

skip1	rts
.)

;Add if not hero but hero has items, and also if character has spare pockets
AddOption9      ;"Lend Item"
	lda CurrentCharacter
.(
	cmp #32
	beq skip1

	lda #128
	jsr CountCharacterItems
	cmp #00
	beq skip1

	ldy #09
	jsr AddOptionVector
	inx

skip1	rts
.)

;Add if not hero, hero has spare pockets, character has lent item
AddOption10     ;"Recall Item"
	; Is current character not hero?
	lda CurrentCharacter
.(
	cmp #32
	beq skip1

	; has Hero got spare pockets?
	lda #32
	jsr CountCharacterItems
	cmp #10
	bcs skip1

	; character has lent item?
	ldy #00
loop1	lda Objects_C,y
	and #15
	cmp #LS_HELDBYCREATURE
	bne skip3
	lda Objects_A,y
	and #31
	cmp CurrentCharacter
	bne skip3
	lda Objects_B,y
	and #1
	bne skip2	;HoldingItem4Hero
skip3	iny
	bpl loop1
	jmp skip1
skip2
	ldy #10
	jsr AddOptionVector
	inx

skip1	rts
.)

;Parsed
;A Character to scan
CountCharacterItems
	sta cciCharacter	;Character 0-31 or Hero 32
	ldy #00
	sty cciCount
.(
loop1	lda cciCharacter
	cmp #32
	beq HeroCheck
CharacterCheck
	lda Objects_C,y
	and #15
	cmp #LS_HELDBYCREATURE
	bne skip1
	lda Objects_A,y
	and #31
	cmp cciCharacter
	bne skip1
	jmp skip2
HeroCheck	lda Objects_C,y
	and #15
	cmp #LS_HELDBYHERO
	bne skip1
skip2	inc cciCount
skip1	iny
	bpl loop1
.)
	lda cciCount
	rts

cciCharacter	.byt 0
cciCount		.byt 0


;Parsed
DrawFrameHighlight
	ldx SelectedCharacter
	lda FaceFrameScreenLocLo,x
	sec
	sbc #81
	sta screen
	lda FaceFrameScreenLocHi,x
	sbc #00
	sta screen+1
	ldx #0
	ldy #0
.(
loop1	lda FaceHighlightGraphic,x
	bmi skip1
	sta (screen),y
	lda #01
skip1	and #127
	jsr add_screen
	inx
	cpx #91
	bcc loop1
.)
	rts

DeleteFrameHighlight
	ldx SelectedCharacter
	lda FaceFrameScreenLocLo,x
	sec
	sbc #81
	sta screen
	lda FaceFrameScreenLocHi,x
	sbc #00
	sta screen+1
	ldx #0
	ldy #0
.(
loop1	lda FaceHighlightGraphic,x
	bmi skip1
	lda #64
	sta (screen),y
	lda #01
skip1	and #127
	jsr add_screen
	inx
	cpx #91
	bcc loop1
.)
	rts


;The face highlight graphic does not require inverse so top bit indicates
;bytes forward to jump otherwise each byte is plotted one after the other.
FaceHighlightGraphic	;Offset and Graphic (Including ink changes)
 .byt 2,%01000111,%01111111,%01111111,%01111111,%01111110,fhgJump+34	;7
 .byt 2,%01011110,fhgJump+3,%01000111,%01100000,fhgJump+73            ;6
 .byt 2,%01111000,fhgJump+3,%01000001,%01110000,fhgJump+73            ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+73                    ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+73                    ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+73                    ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+73                    ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+73                    ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+73                    ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+73                    ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+73                    ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+73                    ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+73                    ;6
 .byt 2,%01110000,fhgJump+3,2,%01110000,fhgJump+74                    ;6
 .byt %01110000,%01000000,%01000000,%01000000,%01000000,%01111111     ;6

FormTemplateGraphic	;Full Res 40x (AC58-B977)
#include "cstem.s"

