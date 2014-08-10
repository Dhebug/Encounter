	
; unsigned 32 bit multiply with 64 bit product
; tmp0/1 x tmp2/3 -> tmp4/5/6/6/7
mul32u
.(
	lda #$00
	sta tmp4+4   ;Clear upper half of
	sta tmp4+5   ;product
	sta tmp4+6
	sta tmp4+7
	ldx #32      ;Set binary count to 32
SHIFT_R
	lsr tmp0+3   ;Shift multiplyer right
	ror tmp0+2
	ror tmp0+1
	ror tmp0
	bcc ROTATE_R ;Go rotate right if c = 0
	lda tmp4+4   ;Get upper half of product
	clc          ; and add multiplicand to
	adc tmp2    ; it
	sta tmp4+4
	lda tmp4+5
	adc tmp2+1
	sta tmp4+5
	lda tmp4+6
	adc tmp2+2
	sta tmp4+6
	lda tmp4+7
	adc tmp2+3
ROTATE_R
	ror          ;Rotate partial product
	sta tmp4+7   ; right
	ror tmp4+6
	ror tmp4+5
	ror tmp4+4
	ror tmp4+3
	ror tmp4+2
	ror tmp4+1
	ror tmp4+0
	dex          ;Decrement bit count and
	bne SHIFT_R  ; loop until 32 bits are
	;clc          ; done
	;lda MULXP1   ;Add dps and put sum in MULXP2
	;adc MULXP2
	;sta MULXP2
	rts	
.)           


/*
int rand(void)
{
    return( ((_holdrand = _holdrand * 214013L + 2531011L) >> 16) & 0x7fff );
}
*/

_randseedLow .byt 0,0
_randseedTop .byt 0,0

_rand32
	;jmp _pcrand
.(
	; Left side, old seed
	lda _randseedLow+0
	sta tmp0+0
	lda _randseedLow+1
	sta tmp0+1
	lda _randseedLow+2
	sta tmp0+2
	lda _randseedLow+3
	sta tmp0+3
	
	; Righ side, 214013 -> $00 03 43 FD
	lda #$FD
	sta tmp2+0
	lda #$43
	sta tmp2+1
	lda #$03
	sta tmp2+2
	lda #$00
	sta tmp2+3
	
	; Multiply
	; Result in tmp4/5/6/6/7
	jsr mul32u
	
	; Add 2531011 -> $00 26 9E C3
	clc
	lda tmp4+0	
	adc #$C3
	sta _randseedLow+0
	lda tmp4+1
	adc #$9E
	sta _randseedLow+1
	lda tmp4+2	
	adc #$26
	sta _randseedLow+2
	lda tmp4+3	
	adc #$00
	sta _randseedLow+3
	
	rts
.)
     

      