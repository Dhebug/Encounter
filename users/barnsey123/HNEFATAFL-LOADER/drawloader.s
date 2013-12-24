; Add 40 to "tmp1"
_Add40
.(
	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip	
	rts
.) 


; x=column
; y=row
_SetScreenAddress
.(
	lda #<$a002
	sta tmp1+0
	lda #>$a002
	sta tmp1+1
		
	; +col*3
	jsr _AddCol
	
	; +row*720
	jsr _AddRow
	rts
.)

; X=number of columns
; Out: update "tmp1"
_AddCol
.(
	cpx #0
loop
	beq end
	clc
	lda tmp1+0
	adc #3
	sta tmp1+0
	lda tmp1+1
	adc #0
	sta tmp1+1
	dex
	jmp loop
end
	rts
.)


; Y=number of rows
; Out: update "tmp1"
_AddRow
.(
	cpy #0
loop
	beq end
	clc
	lda tmp1+0
	adc #<720
	sta tmp1+0
	lda tmp1+1
	adc #>720
	sta tmp1+1
	dey
	jmp loop
end	
	rts
.)

_SetScreenAddress2
.(
	ldx _cx
	ldy _cy
	jsr _SetScreenAddress
	rts
.)

_inverse2
.(
	;ldx _cx
	;ldy _cy
	;jsr _SetScreenAddress
	jsr _SetScreenAddress2
	jsr _Add40
	; Draw loop
	.(
	ldx #18
loop
	ldy #0
	lda (tmp1),y
	eor #%111111
	eor #128
	eor #63
	sta (tmp1),y
	iny
	lda (tmp1),y
	eor #%111111
	eor #128
	eor #63
	sta (tmp1),y
	iny
	lda (tmp1),y
	eor #%111111
	eor #128
	eor #63
	sta (tmp1),y

	jsr _Add40
			
	dex
	bne loop
	.)
		
	rts
.)
