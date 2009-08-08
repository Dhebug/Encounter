;3DStarfield.s
;Resolution 0-233
;Alt res 0-116
;Offset res 0-58

XFracCount
 .dsb 64,0
XFracValue
 .dsb 64,0
StarXOffset
 .dsb 64,0
YFracCount
 .dsb 64,0
YFracValue
 .dsb 64,0
StarYOffset
 .dsb 64,0
StarXPolar
 .dsb 64,0
StarYPolar
 .dsb 64,0
OldStarX
 .dsb 64,0
OldStarY
 .dsb 64,0
RandomPolarX
 .byt $7D,$7D,$FD,$FD
RandomPolarY
 .byt $7D,$FD,$7D,$FD

*
GenerateNewStar
	lda #00
	sta XFracCount,x
	sta YFracCount,x
	sta StarXOffset,x
	sta StarYOffset,x

	jsr getrand
	sta XFracValue,x

	jsr getrand
	sta YFracValue,x

	jsr getrand
	and #03
	tay
	lda RandomPolarX,y
	sta StarXPolar,x
	lda RandomPolarY,y
	sta StarYPolar,x

	jmp rent1

ProcStarfield
	ldx #63
.(
loop1	lda XFracCount,x
	adc XFracValue,x
	sta XFracCount,x
	lda StarXOffset,x
	adc #01
	sta StarXOffset,x	;0-58
	cmp #59
	bcs GenerateNewStar

	lda YFracCount,x
	adc YFracValue,x
	sta YFracCount,x
	lda StarYOffset,x
	adc #01
	sta StarYOffset,x	;0-49
	cmp #50
	bcs GenerateNewStar


rent1	lda #122
	ldy StarXPolar,x	;Contains mnemonic for "ADC abs,x"(7D) or "SBC abs,x"(FD)
	sty vector1
	sec
vector1	sbc StarXOffset,x
	sta NewStarX

	lda #50
	ldy StarYPolar,x
	sty vector2
	sec
vector2	sbc StarYOffset,x
	sta NewStarY

	;Increase velocity
	inc XFracValue,x
	inc YFracValue,x

	stx temp01

	;Delete Star
	ldy OldStarY,x
	lda OldStarX,x
	tax
	lda YLOCL,y
	sta screen
	lda YLOCH,y
	sta screen+1
	ldy XLOC,x
	lda (screen),y
	and MASK,x
	sta (screen),y

	;Plot Star
	ldy NewStarY
	ldx NewStarX
	lda YLOCL,y
	sta screen
	lda YLOCH,y
	sta screen+1
	ldy XLOC,x
	lda (screen),y
	ora BITMAP,x
	sta (screen),y

	ldx temp01

	;Transfer New to Old
	lda NewStarX
	sta OldStarX,x
	lda NewStarY
	sta OldStarY,x

	;Update index
	dex
	bpl loop1
.)
	rts
