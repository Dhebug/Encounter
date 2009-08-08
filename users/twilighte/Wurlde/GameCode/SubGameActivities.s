;SubGameActivities.s

;Called from DisplayText in TextWindowHandler.s after "[" triggered the subgame
ActivateSubGame
	;Has Subgame already been completed?
	ldx ssc_LocationID
	lda SubGameProperty,x
	and #%00000010
.(
	beq skip1
	
	; Is subgame repeatable?
	lda SubGameProperty,x
	and #%00000001
	beq JumpToAlternateText

skip1	; Activate subgame associated to this location
	lda SubGameProperty,x
	ora #%00000100
	sta SubGameProperty,x

	; Process SubgameInit routine here
	lda SubgameInitHi,x
	beq skip2	;No Initialisation
	sta vector1+2
	lda SubgameInitLo,x
	sta vector1+1
vector1	jsr $dead	
skip2	rts
.)

JumpToAlternateText
	;inc dtSourceTextIndex until (text) is after "]"
	ldy dtSourceTextIndex
.(
loop1	iny
	lda (text),y
	cmp #"]"
	bne loop1
.)
	;Incase subgame intro text uses all 7 rows (259!) add index to text and reset index
	tya
	clc
	adc text
	sta text
	lda #00
	sta dtSourceTextIndex
	adc text+1
	sta text+1
	rts

	
;Called from main game loop in GameDriver.s - Process subgame at runtime
ProcessSubGameActivities
	;Is a game active?
	ldx ssc_LocationID
	lda SubGameProperty,x
	and #%00000100
.(
	beq skip1
	lda SubGameRuntimeLo,x
	sta vector1+1
	lda SubGameRuntimeHi,x
	beq skip1
	sta vector1+2
vector1	jsr $dead
skip1	rts
.)	

InitTemplesGreatHornSearch
	;Temporarily Remove Temple from Fishy Plaice
	lda Temple_Child+1
	ora #128
	sta Temple_Child+1
	;Set subgame start location to current locationid
	lda ssc_LocationID
	sta SubGameStartLocation
	rts

;This code also includes processing after the subgame has completed
RunningTemplesGreatHornSearch
	;Temples Great Horn Search - Has it completed?
	lda SubGameResult
	;Result of 1 is when temple is swimming out of view
	cmp #2
.(
	bne skip1
	
	; Turn off game and reset result
	lda #00
	sta SubGameResult
	
	; Locate Horn - Assign to Temple
	ldy #127
loop1	lda Objects_B,y
	lsr
	lsr
	lsr
	cmp #30
	beq skip2
	dey
	bpl loop1
	;Couldn't find it - This should never happen!
	jmp skip1

skip2	;Activate Temples Horn
	lda Objects_C,y
	and #127
	sta Objects_C,y
	
	; Put Temple back in Fishy Plaice
	lda Temple_Child+1
	and #127
	sta Temple_Child+1
	
	; Set SubGame completed status and deactivate subgame
	lda SubGameProperty,x
	and #%00000001
	ora #%00000010
	sta SubGameProperty,x
	
	;Thats all
skip1	rts
.)


InitPergasPipe
	;Place the pipe at Bogmire in Ritemoor
	rts

