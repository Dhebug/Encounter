;Characters Routines
coObject		.byt 0
;Discover if object is held by character
;A Object to find
;X If Object is held by character then return CharacterBlock index in X
;  Otherwise set X to 128
;CurrentCharacter references the character to search for(Not Hero)
IsCurrentCharacterHoldingObject
	sta coObject
	ldx #127
.(	
loop1	; Is Object used?
	lda Objects_C,x
	bmi skip1
	
	; Is Object held by a creature?
	and #15
	cmp #LS_HELDBYCREATURE
	bne skip1
	
	; Is Object held by the current creature?
	lda Objects_A,x
	and #31
	cmp CurrentCharacter
	bne skip1
	
	; Is Object the Parsed one?
	lda Objects_B,x
	lsr
	lsr
	lsr
	cmp coObject
	beq skip2	;Character Has Object
	
skip1	dex
	bpl loop1
skip2	rts
.)

	