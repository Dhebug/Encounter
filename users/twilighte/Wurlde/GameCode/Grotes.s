;Grotes.s
;3xBCD values
;00 hundredThousands,Tens of thousands
;01 thousands,hundreds
;02 tens,units

;Parsed
;source	Pointer to 3xBCD of Grotes
;source2	Pointer to 3xBCD of Grotes
;Is their enough Grotes in source2 for the price in source?
;Carry set if yes
;Rather than do a complex comparison we do a subtraction and branch on minus!
EnoughGrotes
	ldy #02
	sed
	sec
.(
loop1	lda (source2),y
	sbc (source),y
	dey
	bpl loop1
skip1	cld
.)
	rts

;Parsed
;source	Pointer to 3xBCD to Add
;source2	Pointer to 3xBCD to receive
AddGrotes
	sed
	clc
	ldy #02
.(
loop1	lda (source2),y
	adc (source),y
	sta (source2),y
	dey
	bpl loop1
.)
	cld
	rts



;Parsed
;source	Pointer to 3xBCD to take
;source2	Pointer to 3xBCD to Give
SubGrotes
	sed
	sec
	ldy #02
.(
loop1	lda (source2),y
	sbc (source),y
	sta (source2),y
	dey
	bpl loop1
.)
	cld
	rts

GiveHeroMoney
	sta tempBCD+2

	lda #<tempBCD
	sta source
	lda #>tempBCD
	sta source+1

	lda #<HeroGrotes
	sta source2
	lda #>HeroGrotes
	sta source2+1

	jmp AddGrotes

GiveCharacterMoney
	sta tempBCD+2

	lda #<tempBCD
	sta source
	lda #>tempBCD
	sta source+1

	lda CurrentCharacter
	asl
	asl
	asl
	adc #5
	adc #<CharacterBlocks
	sta source2
	lda #>CharacterBlocks
	adc #00
	sta source2+1

	jmp AddGrotes
;Parsed
;A Grotes to take
TakeMoneyFromHero
	sta tempBCD+2

	lda #<tempBCD
	sta source
	lda #>tempBCD
	sta source+1

	lda #<HeroGrotes
	sta source2
	lda #>HeroGrotes
	sta source2+1

	jmp SubGrotes

TakeMoneyFromCharacter
	sta tempBCD+2

	lda #<tempBCD
	sta source
	lda #>tempBCD
	sta source+1

	lda CurrentCharacter
	asl
	asl
	asl
	adc #5
	adc #<CharacterBlocks
	sta source2
	lda #>CharacterBlocks
	adc #00
	sta source2+1

	jmp SubGrotes

;Parsed
;A Grotes needed
HasHeroEnoughGrotes
	sta tempBCD+2

	lda #<tempBCD
	sta source
	lda #>tempBCD
	sta source+1

	lda #<HeroGrotes
	sta source2
	lda #>HeroGrotes
	sta source2+1

	jmp EnoughGrotes

HasCharacterEnoughGrotes
	sta tempBCD+2

	lda #<tempBCD
	sta source
	lda #>tempBCD
	sta source+1

	lda CurrentCharacter
	asl
	asl
	asl
	adc #5
	adc #<CharacterBlocks
	sta source2
	lda #>CharacterBlocks
	adc #00
	sta source2+1

	jmp EnoughGrotes

tempBCD
 .byt 0,0,0

;Calculate Selling Price that CurrentCharacter is willing to offer for SelectedObject
CalculateSellingPrice	;Returns bnsOfferPrice
	; Fetch CurrentCharacter's Buying Fraction
	lda CurrentCharacter
	asl
	asl
	asl
	tax
	lda CharacterBlocks+4,x
	lsr
	lsr
	and #3
	tay
	jmp CalculatePrice
	
;Calculate Buying Price that CurrentCharacter is willing to pay for SelectedObject
CalculateBuyingPrice
;	nop
;	jmp CalculateBuyingPrice
	; Fetch CurrentCharacter's Buying Fraction
	lda CurrentCharacter
	asl
	asl
	asl
	tax
	lda CharacterBlocks+4,x
	and #3
	tay

CalculatePrice
;	nop
;	jmp CalculatePrice
	; Fetch Base Price
	ldx SelectedObject
	lda Objects_B,x
	lsr
	lsr
	lsr
	tax
	lda Current_GamePrices,x
	sta bnsBasePrice

	; Calculate Base Price / 2(0.5) (Not as simple as LSR or INXLoop since BCD)
	lda #00
	sta bnsTemp01
	lda bnsBasePrice
	sta bnsTemp02
	
	sed
	clc
.(	
loop1	lda bnsTemp01
	adc #00
	sta bnsTemp01
	lda bnsTemp02
	sec
	sbc #02
	sta bnsTemp02
	bcs loop1
.)	
	lda bnsTemp01
	sta bnsBasePrice050
	
	; Do same again to calculate /4
	lda #00
	sta bnsTemp01
	lda bnsBasePrice
	sta bnsTemp02
	
	sed
	clc
.(	
loop1	lda bnsTemp01
	adc #00
	sta bnsTemp01
	lda bnsTemp02
	sec
	sbc #04
	sta bnsTemp02
	bcs loop1
.)	
	lda bnsTemp01
	sta bnsBasePrice025

	; Now add prices up as required by BuyingFrac
	lda bnsBasePrice
	ldx bnsPriceFrac025Flag,y
.(
	bpl skip1
	adc bnsBasePrice025
skip1	ldx bnsPriceFrac050Flag,y
	bpl skip2
	adc bnsBasePrice050
skip2	sta bnsOfferPrice
.)
	cld
	rts

;1.00 1.25 1.50 1.75
bnsPriceFrac025Flag
 .byt 0,128,0,128
bnsPriceFrac050Flag
 .byt 0,0,128,128
bnsBasePrice	.byt 0
bnsBasePrice050	.byt 0
bnsBasePrice025	.byt 0
bnsOfferPrice	.byt 0
bnsTemp02		.byt 0
bnsTemp01		.byt 0
