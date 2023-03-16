
#include "params.h"

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

    .text

 Update the sound generator
SoundUpdate    
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
	sty	via_porta
	txa

	pha
	lda	via_pcr
	ora	#$EE		; $EE	238	11101110
	sta	via_pcr

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	via_pcr

	tax
	pla
	sta	via_porta
	txa
	ora	#$EC		; $EC	236	11101100
	sta	via_pcr

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	via_pcr

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

// To play these sounds, just copy the 14 bytes to _PsgVirtualRegisters and then set _PsgNeedUpdate to 2
_ExplodeData     .byt $00,$00,$00,$00,$00,$00,$1F,$07,$10,$10,$10,$00,$18,$00
_ShootData       .byt $00,$00,$00,$00,$00,$00,$0F,$07,$10,$10,$10,$00,$08,$00
_PingData        .byt $18,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$00,$0F,$00
_ZapData         .byt $00,$00,$00,$00,$00,$00,$00,$3E,$0F,$00,$00,$00,$00,$00
_KeyClickHData   .byt $1F,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$1F,$00,$00
_KeyClickLData   .byt $2F,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$1F,$00,$00

