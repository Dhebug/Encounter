



; Alternate charset in hires from $9c00 to $a000
; is a nice 1024 bytes buffer

_MovieFrame		.byt 0

_DisplayColumn	.byt 39

_FrameUnpack	
	lda #<_picture_frames
	sta tmp0
	clc
	lda #>_picture_frames
	adc _MovieFrame
	sta tmp0+1

	ldy #0

	ldx #0
FrameUnpackLoop0
	lda (tmp0),y
	iny 

	pha
	and #3
	sta $9c00,x
	inx 

	pla
	lsr
	lsr
	pha
	and #3
	sta $9c00,x
	inx 

	pla
	lsr
	lsr
	pha
	and #3
	sta $9c00,x
	inx 

	pla
	lsr
	lsr
	sta $9c00,x
	inx 

	bne FrameUnpackLoop0


	ldx #0
FrameUnpackLoop1
	lda (tmp0),y
	iny 

	pha
	and #3
	sta $9d00,x
	inx 

	pla
	lsr
	lsr
	pha
	and #3
	sta $9d00,x
	inx 

	pla
	lsr
	lsr
	pha
	and #3
	sta $9d00,x
	inx 

	pla
	lsr
	lsr
	sta $9d00,x
	inx 

	bne FrameUnpackLoop1


	ldx #0
FrameUnpackLoop2
	lda (tmp0),y
	iny 

	pha
	and #3
	sta $9e00,x
	inx 

	pla
	lsr
	lsr
	pha
	and #3
	sta $9e00,x
	inx 

	pla
	lsr
	lsr
	pha
	and #3
	sta $9e00,x
	inx 

	pla
	lsr
	lsr
	sta $9e00,x
	inx 

	bne FrameUnpackLoop2


	ldx #0
FrameUnpackLoop3
	lda (tmp0),y
	iny 

	pha
	and #3
	sta $9f00,x
	inx 

	pla
	lsr
	lsr
	pha
	and #3
	sta $9f00,x
	inx 

	pla
	lsr
	lsr
	pha
	and #3
	sta $9f00,x
	inx 

	pla
	lsr
	lsr
	sta $9f00,x
	inx 

	bne FrameUnpackLoop3

	rts


_TabColors
	.byt 64
	.byt 64
	.byt 64+2+4
	.byt 64+2+4+8+16

_TabColors1
	.byt 64
	.byt 64+1+2
	.byt 64+1+2+4+8
	.byt 64+1+2+4+8+16+32


_FrameFlip	.byt 0


#define SCREEN_BEGIN_ODD	$a000+40*8+1
#define SCREEN_BEGIN_EVEN	$a000+40*8+40+1


_FrameDisplay	
	lda _FrameFlip
	beq FrameDisplayOdd
	jmp FrameDisplayEven

FrameDisplayOdd
	lda #1
	sta _FrameFlip

	ldy #0
FrameDisplayOddLoopX
	ldx $9c00+40*0,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*0+0,y
	sta SCREEN_BEGIN_ODD+320*0+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*0+80,y
	sta SCREEN_BEGIN_ODD+320*0+160,y

	ldx $9c00+40*1,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*1+0,y
	sta SCREEN_BEGIN_ODD+320*1+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*1+80,y
	sta SCREEN_BEGIN_ODD+320*1+160,y

	ldx $9c00+40*2,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*2+0,y
	sta SCREEN_BEGIN_ODD+320*2+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*2+80,y
	sta SCREEN_BEGIN_ODD+320*2+160,y

	ldx $9c00+40*3,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*3+0,y
	sta SCREEN_BEGIN_ODD+320*3+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*3+80,y
	sta SCREEN_BEGIN_ODD+320*3+160,y

	ldx $9c00+40*4,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*4+0,y
	sta SCREEN_BEGIN_ODD+320*4+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*4+80,y
	sta SCREEN_BEGIN_ODD+320*4+160,y

	ldx $9c00+40*5,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*5+0,y
	sta SCREEN_BEGIN_ODD+320*5+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*5+80,y
	sta SCREEN_BEGIN_ODD+320*5+160,y

	ldx $9c00+40*6,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*6+0,y
	sta SCREEN_BEGIN_ODD+320*6+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*6+80,y
	sta SCREEN_BEGIN_ODD+320*6+160,y

	ldx $9c00+40*7,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*7+0,y
	sta SCREEN_BEGIN_ODD+320*7+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*7+80,y
	sta SCREEN_BEGIN_ODD+320*7+160,y

	ldx $9c00+40*8,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*8+0,y
	sta SCREEN_BEGIN_ODD+320*8+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*8+80,y
	sta SCREEN_BEGIN_ODD+320*8+160,y

	ldx $9c00+40*9,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*9+0,y
	sta SCREEN_BEGIN_ODD+320*9+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*9+80,y
	sta SCREEN_BEGIN_ODD+320*9+160,y


	ldx $9c00+40*10,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*10+0,y
	sta SCREEN_BEGIN_ODD+320*10+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*10+80,y
	sta SCREEN_BEGIN_ODD+320*10+160,y

	ldx $9c00+40*11,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*11+0,y
	sta SCREEN_BEGIN_ODD+320*11+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*11+80,y
	sta SCREEN_BEGIN_ODD+320*11+160,y

	ldx $9c00+40*12,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*12+0,y
	sta SCREEN_BEGIN_ODD+320*12+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*12+80,y
	sta SCREEN_BEGIN_ODD+320*12+160,y

	ldx $9c00+40*13,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*13+0,y
	sta SCREEN_BEGIN_ODD+320*13+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*13+80,y
	sta SCREEN_BEGIN_ODD+320*13+160,y

	ldx $9c00+40*14,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*14+0,y
	sta SCREEN_BEGIN_ODD+320*14+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*14+80,y
	sta SCREEN_BEGIN_ODD+320*14+160,y

	ldx $9c00+40*15,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*15+0,y
	sta SCREEN_BEGIN_ODD+320*15+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*15+80,y
	sta SCREEN_BEGIN_ODD+320*15+160,y

	ldx $9c00+40*16,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*16+0,y
	sta SCREEN_BEGIN_ODD+320*16+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*16+80,y
	sta SCREEN_BEGIN_ODD+320*16+160,y

	ldx $9c00+40*17,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*17+0,y
	sta SCREEN_BEGIN_ODD+320*17+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*17+80,y
	sta SCREEN_BEGIN_ODD+320*17+160,y

	ldx $9c00+40*18,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*18+0,y
	sta SCREEN_BEGIN_ODD+320*18+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*18+80,y
	sta SCREEN_BEGIN_ODD+320*18+160,y

	ldx $9c00+40*19,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*19+0,y
	sta SCREEN_BEGIN_ODD+320*19+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*19+80,y
	sta SCREEN_BEGIN_ODD+320*19+160,y


	ldx $9c00+40*20,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*20+0,y
	sta SCREEN_BEGIN_ODD+320*20+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*20+80,y
	sta SCREEN_BEGIN_ODD+320*20+160,y

	ldx $9c00+40*21,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*21+0,y
	sta SCREEN_BEGIN_ODD+320*21+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*21+80,y
	sta SCREEN_BEGIN_ODD+320*21+160,y

	ldx $9c00+40*22,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*22+0,y
	sta SCREEN_BEGIN_ODD+320*22+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*22+80,y
	sta SCREEN_BEGIN_ODD+320*22+160,y

	ldx $9c00+40*23,y
	lda _TabColors,x
	sta SCREEN_BEGIN_ODD+320*23+0,y
	sta SCREEN_BEGIN_ODD+320*23+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_ODD+320*23+80,y
	sta SCREEN_BEGIN_ODD+320*23+160,y


	iny
	cpy _DisplayColumn
	beq FrameDisplayOddLoopXEnd
	jmp FrameDisplayOddLoopX


FrameDisplayOddLoopXEnd

	lda #<$a000+40*8
	sta tmp0
	lda #>$a000+40*8
	sta tmp0+1

	ldy #0
	ldx #96 
FrameDisplayOddLoopColors
	lda #2
	ldy #0
	sta (tmp0),y
	lda #1
	ldy #40
	sta (tmp0),y

	clc
	lda tmp0
	adc #80
	sta tmp0
	bcc skipoddcolor
	inc tmp0+1
skipoddcolor

	dex
	bne FrameDisplayOddLoopColors


	ldx _DisplayColumn
	cpx #39
	beq FrameDisplayNotFillLastColumns
	jmp FrameDisplayFillLastColumns
FrameDisplayNotFillLastColumns
	rts



FrameDisplayEven
	lda #0
	sta _FrameFlip

	ldy #0
FrameDisplayEvenLoopX
	ldx $9c00+40*0,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*0+0,y
	sta SCREEN_BEGIN_EVEN+320*0+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*0+80,y
	sta SCREEN_BEGIN_EVEN+320*0+160,y

	ldx $9c00+40*1,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*1+0,y
	sta SCREEN_BEGIN_EVEN+320*1+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*1+80,y
	sta SCREEN_BEGIN_EVEN+320*1+160,y

	ldx $9c00+40*2,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*2+0,y
	sta SCREEN_BEGIN_EVEN+320*2+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*2+80,y
	sta SCREEN_BEGIN_EVEN+320*2+160,y

	ldx $9c00+40*3,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*3+0,y
	sta SCREEN_BEGIN_EVEN+320*3+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*3+80,y
	sta SCREEN_BEGIN_EVEN+320*3+160,y

	ldx $9c00+40*4,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*4+0,y
	sta SCREEN_BEGIN_EVEN+320*4+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*4+80,y
	sta SCREEN_BEGIN_EVEN+320*4+160,y

	ldx $9c00+40*5,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*5+0,y
	sta SCREEN_BEGIN_EVEN+320*5+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*5+80,y
	sta SCREEN_BEGIN_EVEN+320*5+160,y

	ldx $9c00+40*6,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*6+0,y
	sta SCREEN_BEGIN_EVEN+320*6+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*6+80,y
	sta SCREEN_BEGIN_EVEN+320*6+160,y

	ldx $9c00+40*7,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*7+0,y
	sta SCREEN_BEGIN_EVEN+320*7+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*7+80,y
	sta SCREEN_BEGIN_EVEN+320*7+160,y

	ldx $9c00+40*8,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*8+0,y
	sta SCREEN_BEGIN_EVEN+320*8+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*8+80,y
	sta SCREEN_BEGIN_EVEN+320*8+160,y

	ldx $9c00+40*9,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*9+0,y
	sta SCREEN_BEGIN_EVEN+320*9+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*9+80,y
	sta SCREEN_BEGIN_EVEN+320*9+160,y


	ldx $9c00+40*10,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*10+0,y
	sta SCREEN_BEGIN_EVEN+320*10+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*10+80,y
	sta SCREEN_BEGIN_EVEN+320*10+160,y

	ldx $9c00+40*11,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*11+0,y
	sta SCREEN_BEGIN_EVEN+320*11+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*11+80,y
	sta SCREEN_BEGIN_EVEN+320*11+160,y

	ldx $9c00+40*12,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*12+0,y
	sta SCREEN_BEGIN_EVEN+320*12+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*12+80,y
	sta SCREEN_BEGIN_EVEN+320*12+160,y

	ldx $9c00+40*13,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*13+0,y
	sta SCREEN_BEGIN_EVEN+320*13+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*13+80,y
	sta SCREEN_BEGIN_EVEN+320*13+160,y

	ldx $9c00+40*14,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*14+0,y
	sta SCREEN_BEGIN_EVEN+320*14+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*14+80,y
	sta SCREEN_BEGIN_EVEN+320*14+160,y

	ldx $9c00+40*15,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*15+0,y
	sta SCREEN_BEGIN_EVEN+320*15+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*15+80,y
	sta SCREEN_BEGIN_EVEN+320*15+160,y

	ldx $9c00+40*16,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*16+0,y
	sta SCREEN_BEGIN_EVEN+320*16+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*16+80,y
	sta SCREEN_BEGIN_EVEN+320*16+160,y

	ldx $9c00+40*17,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*17+0,y
	sta SCREEN_BEGIN_EVEN+320*17+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*17+80,y
	sta SCREEN_BEGIN_EVEN+320*17+160,y

	ldx $9c00+40*18,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*18+0,y
	sta SCREEN_BEGIN_EVEN+320*18+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*18+80,y
	sta SCREEN_BEGIN_EVEN+320*18+160,y

	ldx $9c00+40*19,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*19+0,y
	sta SCREEN_BEGIN_EVEN+320*19+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*19+80,y
	sta SCREEN_BEGIN_EVEN+320*19+160,y


	ldx $9c00+40*20,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*20+0,y
	sta SCREEN_BEGIN_EVEN+320*20+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*20+80,y
	sta SCREEN_BEGIN_EVEN+320*20+160,y

	ldx $9c00+40*21,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*21+0,y
	sta SCREEN_BEGIN_EVEN+320*21+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*21+80,y
	sta SCREEN_BEGIN_EVEN+320*21+160,y

	ldx $9c00+40*22,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*22+0,y
	sta SCREEN_BEGIN_EVEN+320*22+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*22+80,y
	sta SCREEN_BEGIN_EVEN+320*22+160,y

	ldx $9c00+40*23,y
	lda _TabColors,x
	sta SCREEN_BEGIN_EVEN+320*23+0,y
	sta SCREEN_BEGIN_EVEN+320*23+240,y
	lda _TabColors1,x
	sta SCREEN_BEGIN_EVEN+320*23+80,y
	sta SCREEN_BEGIN_EVEN+320*23+160,y


	iny
	cpy _DisplayColumn
	beq FrameDisplayEvenLoopXEnd
	jmp FrameDisplayEvenLoopX

FrameDisplayEvenLoopXEnd
	lda #<$a000+40*8
	sta tmp0
	lda #>$a000+40*8
	sta tmp0+1

	ldy #0
	ldx #96 
FrameDisplayEvenLoopColors
	lda #1
	ldy #0
	sta (tmp0),y
	lda #2
	ldy #40
	sta (tmp0),y

	clc
	lda tmp0
	adc #80
	sta tmp0
	bcc skipevencolor
	inc tmp0+1
skipevencolor

	dex
	bne FrameDisplayEvenLoopColors

	ldx _DisplayColumn
	cpx #39
	bne FrameDisplayFillLastColumns
	rts



FrameDisplayFillLastColumns
	lda #<$a000+40*8+1
	sta tmp0
	lda #>$a000+40*8+1
	sta tmp0+1

	ldy _DisplayColumn
	ldx #192 
FrameDisplayFillLastColumnsLoop
	lda #16			; 63+1+4+16
	sta (tmp0),y

	clc
	lda tmp0
	adc #40
	sta tmp0
	bcc skipfillcolor
	inc tmp0+1
skipfillcolor

	dex
	bne FrameDisplayFillLastColumnsLoop
	rts


_DisplayClearScreen
	ldx #192

	lda #<$a000+40*8
	sta tmp0
	lda #>$a000+40*8
	sta tmp0+1

	ldx #192 
DisplayClearScreenLoopY

	ldy #0
	lda #16			; Black paper
	sta (tmp0),y
	iny
	lda #0			; Black ink
	sta (tmp0),y
	iny
	lda #64
DisplayClearScreenLoopX
	sta (tmp0),y
	iny
	cpy #40
	bne DisplayClearScreenLoopX

	clc
	lda tmp0
	adc #40
	sta tmp0
	bcc skipclearcolor
	inc tmp0+1
skipclearcolor

	dex
	bne DisplayClearScreenLoopY

	rts



;memcpy((unsigned char*)0xa000+40*8,(unsigned char*)0xdc00,40*192);



_DisplayEmptyScreen
	;jmp	_DisplayEmptyScreen
	ldx #192

	lda #<$a000+40*8
	sta tmp0
	lda #>$a000+40*8
	sta tmp0+1

	ldx #192 
DisplayEmptyScreenLoopY

	ldy #2
DisplayEmptyScreenLoopX
	lda #64
	sta (tmp0),y
	iny
	cpy #40
	bne DisplayEmptyScreenLoopX

	clc
	lda tmp0
	adc #40
	sta tmp0
	bcc skipdisplayempty
	inc tmp0+1
skipdisplayempty

	dex
	bne DisplayEmptyScreenLoopY
	rts




_DisplayFighter
	ldx #192

	lda #<$dc00
	sta tmp0
	lda #>$dc00
	sta tmp0+1


	lda #<$a000+40*8
	sta tmp1
	lda #>$a000+40*8
	sta tmp1+1

	ldx #192 
DisplayFighterFlipLoopY

	ldy #2
DisplayFighterFlipLoopX
	lda (tmp0),y
	eor #63
	sta (tmp1),y
	iny
	cpy #40
	bne DisplayFighterFlipLoopX

	clc
	lda tmp0
	adc #40
	sta tmp0
	bcc skipdisplayfighter1
	inc tmp0+1
skipdisplayfighter1

	clc
	lda tmp1
	adc #40
	sta tmp1
	bcc skipdisplayfighter2
	inc tmp1+1
skipdisplayfighter2

	dex
	bne DisplayFighterFlipLoopY


	rts




