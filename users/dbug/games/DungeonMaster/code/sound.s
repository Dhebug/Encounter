;
; Basic sound replay code
;

#define VIA_1				$30f
#define VIA_2				$30c

	.text

_PsgVirtualRegisters
_PsgfreqA 		.byt 0,0    ;  0 1    Chanel A Frequency
_PsgfreqB		.byt 0,0    ;  2 3    Chanel B Frequency
_PsgfreqC		.byt 0,0    ;  4 5    Chanel C Frequency
_PsgfreqNoise	.byt 0      ;  6      Chanel sound generator
_Psgmixer		.byt 0      ;  7      Mixer/Selector
_PsgvolumeA		.byt 0      ;  8      Volume A
_PsgvolumeB		.byt 0      ;  9      Volume B
_PsgvolumeC		.byt 0      ; 10      Volume C
_PsgfreqShape	.byt 0,0    ; 11 12   Wave period
_PsgenvShape	.byt 0      ; 13      Wave form

_PsgNeedUpdate  .byt 1



ProcessSound
.(
	lda _PsgNeedUpdate
	beq skip_update

	and #1
	sta _PsgNeedUpdate

	lda _Psgmixer
	ora #%11000000
	sta _Psgmixer

	ldy #0
register_loop
	ldx	_PsgVirtualRegisters,y

	; y=register number
	; x=value to write
	jsr _PsgPlayRegister

	iny
	cpy #14
	bne register_loop
skip_update	

	rts
.)


; y=register number
; x=value to write
_PsgPlayRegister
.(
	sty	VIA_1
	txa

	pha
	lda	VIA_2
	ora	#$EE		; $EE	238	11101110
	sta	VIA_2

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	VIA_2

	tax
	pla
	sta	VIA_1
	txa
	ora	#$EC		; $EC	236	11101100
	sta	VIA_2

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	VIA_2

	rts
.)


_PsgStopSound
.(
	lda #0
	sta _PsgvolumeA
	sta _PsgvolumeB
	sta _PsgvolumeC
	lda #1
	sta _PsgNeedUpdate
	rts
.)


ExplodeData
	.byt 0,0,0,0,0,0,15
	.byt 7,16,16,16,0,24


_PsgExplode
.(
	ldx #0
loop
	lda ExplodeData,x
	sta _PsgVirtualRegisters,x
	inx
	cpx #14
	bne loop

	lda #2
	sta _PsgNeedUpdate


	rts
.)


