
#define FULLINK		(64+1+2+4+8+16+32)



_TableEraseLeftPosX		.dsb 200
_TableEraseRightPosX	.dsb 200

_TableLeftPosX			.dsb 200
_TableLeftColor			.dsb 200
_TableLeftMask			.dsb 200
						
_TableRightPosX			.dsb 200
_TableRightMask			.dsb 200

_MinX					.dsb 256	; 200
_MaxX					.dsb 200	; 200

;_CNT	.byt 0

_TableDraw
	;jmp _TableDraw

	;lda #$1E
	;sta tmp2

	lda #<$a001
	sta tmp1
	lda #>$a001
	sta tmp1+1

	ldx #0
LoopTableDrawY
	; Erase
	ldy _TableEraseRightPosX,x
	beq skip_erase
	lda #FULLINK
	ldy _TableEraseLeftPosX,x
	dey
	sta (tmp1),y
	iny
	sta (tmp1),y
	ldy _TableEraseRightPosX,x
	sta (tmp1),y
	iny
	sta (tmp1),y
skip_erase


	; Draw
	ldy _TableRightPosX,x
	beq skip_display
	lda _TableRightMask,x
	sta (tmp1),y
	iny
	lda #0				; BLACK INK
	sta (tmp1),y

	ldy _TableLeftPosX,x
	lda _TableLeftColor,x
	dey
	sta (tmp1),y
	iny
	lda _TableLeftMask,x
	sta (tmp1),y
skip_display


	; Copy old values
	lda _TableLeftPosX,x
	sta _TableEraseLeftPosX,x
	lda _TableRightPosX,x
	sta _TableEraseRightPosX,x

	lda #0
	sta _TableRightPosX,x



	inx

	; Increment
	clc
	lda tmp1
	adc #40
	sta tmp1
	bcc LoopTableDrawY
	inc tmp1+1

;BRKK
;	jmp BRKK

	cpx #199			;dec tmp2
	bne LoopTableDrawY

	rts


_TableFill
	ldx #0
LoopTableFillErase
	; Copy old values
	lda _TableLeftPosX,x
	sta _TableEraseLeftPosX,x
	lda _TableRightPosX,x
	sta _TableEraseRightPosX,x

	lda #0
	sta _TableRightPosX,x

	inx
	cpx #200
	bne LoopTableFillErase

	rts






_tx0	.word 0
_bx0	.word 0
_ix0	.word 0

_tx1	.word 0
_bx1	.word 0
_ix1	.word 0

_iy0	.byt 0
_iy1	.byt 0




_LeftPattern
    .byt 64+1+2+4+8+16+32
    .byt 64+1+2+4+8+16
    .byt 64+1+2+4+8
    .byt 64+1+2+4
    .byt 64+1+2
    .byt 64+1

_RightPattern
    .byt 64+63-(1+2+4+8+16+32)
    .byt 64+63-(1+2+4+8+16)
    .byt 64+63-(1+2+4+8)
    .byt 64+63-(1+2+4)
    .byt 64+63-(1+2)
    .byt 64+63-(1)



_TableInitColors
	ldx #0
LoopTableInitColors
	lda #1					; RED
	sta _TableLeftColor,x
	inx

	lda #2					; GREEN
	sta _TableLeftColor,x
	inx

	lda #4					; BLUE
	sta _TableLeftColor,x
	inx

	cpx #200
	bne LoopTableInitColors
	rts



