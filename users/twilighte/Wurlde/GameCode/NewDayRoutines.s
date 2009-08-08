;New Day routines - Modify settings for new day

;1) Clear out characters food posessions (if not infinite)

NewDayInitialisation
	;Set new Best Offer Random seed for all characters
	
	jsr ClearCharactersOldFood
	
	rts

ClearCharactersOldFood	
	;Clear out any food items characters may have accumulated (except infinite ones)
	ldx #127
	
	; Is Object active?
.(
loop1	lda Objects_C,x
	bmi skip1
	
	; Is Object infinite?
	and #64	;oInfiniteSupply
	bne skip1
	
	; Is object posessed by character?
	lda Objects_C,x
	and #15
	cmp #10	;oCreatureHeld
	bne skip1
	
	; Fetch Objects ID
	lda Objects_B,x
	lsr
	lsr
	lsr
	tay
	
	; Is Object a foodstuff?
	lda ObjectProperty,y
	and #1
	beq skip1
	
	;Clear out food
	lda Objects_C,x
	ora #128
	sta Objects_C,x
	
skip1	;Next
	dex
	bpl loop1
.)
	rts	
	