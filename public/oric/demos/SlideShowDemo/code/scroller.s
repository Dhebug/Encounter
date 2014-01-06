
#define SCROLLER_BUFFER_WIDTH   91

#define SCROLLER_EFFECT_GARBAGE		1


	.zero

_MessageScrollerPtr			.dsb 2
scroll_ptr_0				.dsb 2
scroll_ptr_1 				.dsb 2
scroll_tmp_0				.dsb 2
scroll_tmp_1				.dsb 2

	.text


DitheringLeft
	.byt %001110
	.byt %010101
	.byt %101011
	.byt %010101
	.byt %001110
	.byt %010001
	.byt %101111
	.byt %010101
	.byt %001010
	.byt %010101
	.byt %101111
	.byt %010001
	.byt %001110
	.byt %010101
	.byt %101011
	.byt %010101

DitheringRight
	.byt %011100
	.byt %101010
	.byt %110101
	.byt %101010
	.byt %011100
	.byt %100010
	.byt %111101
	.byt %101010
	.byt %010100
	.byt %101010
	.byt %111101
	.byt %100010
	.byt %011100
	.byt %101010
	.byt %110101
	.byt %101010

_MessageScroller
	.asc ":p"


	.asc "The End :) Let's wrap...    "
			
	.asc "                            "
	.byt 0

_NarrowCharacterList
	.asc "iIl,;.:!'"
	.byt 0


ByteMaskRight		.byt 0
ByteMaskLeft		.byt 0
column				.byt 0 
columnCopy			.byt 20
tempWhatever        .byt 0

ScrollerCharacterColumn	.byt 0
ScrollerCurChar			.byt 0
ScrollCurCharWidth  	.byt 0
StupidRotatingMask 		.byt 0




; xx111111
;
; xx011111
; xx100000

GenerateScrollTable
.(
	ldx #0
loop	
	txa
	and #%00111111
	lsr
	ora #64
	sta ScrollTableLeft,x

	txa
	and #%00000001
	lsr
	bcc skip
	ora #%00100000
skip	
	ora #64

	sta ScrollTableRight,x
	inx
	cpx #0
	bne loop


	; Then the font character address table, first make all unknown characters
	; point to the space character.
	ldx #0
loop_init_car	
	lda #<_FontBuffer
	sta _FontAddrLow,x
	lda #>_FontBuffer
	sta _FontAddrHigh,x

	lda #2
	sta _FontCharacterWidth,x
	inx 
	cpx #128
	bne loop_init_car

	.(
	ldx #0
loop_init_width
	lda _NarrowCharacterList,x
	beq end_loop
	tay
	lda #1
	sta _FontCharacterWidth,y
	inx
	bne loop_init_width
end_loop
	.)

	; Then the font character address table, first make all unknown characters
	; point to the space character.
	lda #<_FontBuffer
	sta tmp0+0
	lda #>_FontBuffer
	sta tmp0+1

	ldx #32
loop_set_car
	clc	
	lda tmp0+0
	sta _FontAddrLow,x
	adc #32
	sta tmp0+0
	lda tmp0+1
	sta _FontAddrHigh,x
	adc #0
	sta tmp0+1
	inx 
	cpx #128
	bne loop_set_car

	rts
.)


_ScrollerInit
	; Write the characters in the bottom text area
	ldy #32
	ldx #0
loop_fill_text	
	tya
	sta $bb80+40*26,x
	iny
	tya
	sta $bb80+40*27,x
	iny
	inx
	cpx #40
	bne loop_fill_text


	jsr GenerateScrollTable	

	ldy #44
	sty column

	jsr ScrollerDisplayReset	

	;
	; Install the IRQ
	;
	sei
	lda #<_ScrollerDisplay
	sta _InterruptCallBack_2+1
	lda #>_ScrollerDisplay
	sta _InterruptCallBack_2+2
	cli
	rts



ScrollBufferAddrLow 	
	.byt <ScrollerBuffer1
	.byt <ScrollerBuffer2
	.byt <ScrollerBuffer3
	.byt <ScrollerBuffer4
	.byt <ScrollerBuffer5
	.byt <ScrollerBuffer6
	; Garbage
	.byt <_ScrollerDisplay

ScrollBufferAddrHigh
	.byt >ScrollerBuffer1
	.byt >ScrollerBuffer2
	.byt >ScrollerBuffer3
	.byt >ScrollerBuffer4
	.byt >ScrollerBuffer5
	.byt >ScrollerBuffer6
	; Garbage
	.byt >_ScrollerDisplay

ScrollBufferCounter	.byt 1

_ScrollerDisplay
	jsr __auto_jump

	.(
	ldx ScrollBufferCounter
	dex
	bne skip
	ldx #6
skip
	stx ScrollBufferCounter
	.)	

	.(
	lda _FlagGarbageEnabled
	beq skip
	lda _SystemFrameCounter_low
	and #1
	beq skip
	ldx #7
skip	
	.)

	lda ScrollBufferAddrLow-1,x
	sta scroll_ptr_0+0
	lda ScrollBufferAddrHigh-1,x
	sta scroll_ptr_0+1
    jmp CopyToCharset

__auto_jump	
	jmp (ScrollerJumpTable)



_ScrollerPhase1
    ;jmp _ScrollerPhase1

	ldx column
	inx
	cpx #45
	bcc skip_reset
	ldx #0
skip_reset	
	stx column
	clc
	txa
	adc #45
	sta columnCopy


	lda ScrollerCharacterColumn
	cmp ScrollCurCharWidth
	bne WriteCharData

InsertNewChar
	;jmp InsertNewChar
	; Get character and write into the buffer
	ldy #0
	sty ScrollerCharacterColumn

	lda (_MessageScrollerPtr),y
	cmp #32
	bcs NoSpecialEffect
	beq ScrollerDisplayReset
	bne ScrollerSpecialCode
NoSpecialEffect	
	sta ScrollerCurChar
	tay
	lda _FontCharacterWidth,y
	sta ScrollCurCharWidth

	jsr ScrollerIncPointer

WriteCharData
	ldx ScrollerCurChar
	jsr InsertCharacter 

	inc __auto_jump+1
	inc __auto_jump+1
	rts

_FlagGarbageEnabled		.byt 0

ScrollerSpecialCode
	cmp #SCROLLER_EFFECT_GARBAGE
	beq ScrollerEffectGarbage
	jsr ScrollerIncPointer
	jmp InsertNewChar

ScrollerEffectGarbage
	;inc $bb80+40*25+1
	lda _FlagGarbageEnabled
	eor #255
	sta _FlagGarbageEnabled
	jsr ScrollerIncPointer
	jmp InsertNewChar


_ScrollerPhase2
_ScrollerPhase3
_ScrollerPhase4
_ScrollerPhase5
    jsr CopyAndShift
	inc __auto_jump+1
	inc __auto_jump+1
	rts

_ScrollerPhase6
    jsr CopyAndShift
    ; Reset to the start of the table
	lda #<ScrollerJumpTable
	sta __auto_jump+1
	rts


ScrollerDisplayReset
	lda #<_MessageScroller
	sta _MessageScrollerPtr+0
	lda #>_MessageScroller
	sta _MessageScrollerPtr+1
	rts
	

	

ScrollerIncPointer	
	inc _MessageScrollerPtr
	bne skipscrollermove
	inc _MessageScrollerPtr+1
skipscrollermove
	rts



InsertCharacter
	lda _FontAddrLow,x
	sta __auto_font+1
	lda _FontAddrHigh,x
	sta __auto_font+2

	lda #<ScrollerBuffer1
	sta scroll_tmp_0+0
	sta scroll_tmp_1+0
	lda #>ScrollerBuffer1
	sta scroll_tmp_0+1
	sta scroll_tmp_1+1

	ldx ScrollerCharacterColumn
loop_insert_character	
__auto_font
	lda $1234,x
	ora #64
	ldy column
	sta (scroll_tmp_1),y
	ldy columnCopy
	sta (scroll_tmp_1),y

	clc
	lda scroll_tmp_1+0
	adc #SCROLLER_BUFFER_WIDTH
	sta scroll_tmp_1+0 
	lda scroll_tmp_1+1
	adc #0
	sta scroll_tmp_1+1 

	inx
	inx
	cpx #32
	bcc loop_insert_character

	inc ScrollerCharacterColumn

	lda #0
	sta StupidRotatingMask

	rts


CopyAndShift
	lda StupidRotatingMask
	lsr
	ora #%11100000
	sta StupidRotatingMask

	ldx #0
loop_shift_character	
	ldy column
	lda (scroll_tmp_0),y

	tay
	lda ScrollTableRight,y
	sta ByteMaskRight
	lda ScrollTableLeft,y
	sta ByteMaskLeft	
	ldy column
	lda (scroll_tmp_1),y
	and #%11100000
	ora ByteMaskLeft
	sta (scroll_tmp_1),y

	ldy columnCopy
	sta tempWhatever
	lda (scroll_tmp_1),y
	and StupidRotatingMask
	ora tempWhatever
	sta (scroll_tmp_1),y


	ldy column
	iny

	lda (scroll_tmp_0),y
	tay
	lda ScrollTableLeft,y
	ora ByteMaskRight	
	ldy column
	iny
	sta (scroll_tmp_1),y

	ldy columnCopy
	iny
	sta (scroll_tmp_1),y

	clc
	lda scroll_tmp_0+0
	adc #SCROLLER_BUFFER_WIDTH
	sta scroll_tmp_0+0 
	lda scroll_tmp_0+1
	adc #0
	sta scroll_tmp_0+1 

	clc
	lda scroll_tmp_1+0
	adc #SCROLLER_BUFFER_WIDTH
	sta scroll_tmp_1+0 
	lda scroll_tmp_1+1
	adc #0
	sta scroll_tmp_1+1 

	inx
	cpx #16
	bne loop_shift_character

	rts


CopyToCharset
.(
	ldx #0
loop
	ldy column
	iny
	iny

	lda (scroll_ptr_0),y
	and DitheringLeft,x
	sta $9800+32*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+34*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+36*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+38*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+40*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+42*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+44*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+46*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+48*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+50*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+52*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+54*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+56*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+58*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+60*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+62*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+64*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+66*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+68*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+70*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+72*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+74*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+76*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+78*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+80*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+82*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+84*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+86*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+88*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+90*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+92*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+94*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+96*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+98*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+100*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+102*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+104*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+106*8,x

	iny
	lda (scroll_ptr_0),y
	sta $9800+108*8,x

	iny
	lda (scroll_ptr_0),y
	and DitheringRight,x	
	sta $9800+110*8,x

	clc
	lda scroll_ptr_0+0
	adc #SCROLLER_BUFFER_WIDTH
	sta scroll_ptr_0+0
	lda scroll_ptr_0+1
	adc #0
	sta scroll_ptr_0+1

	inx
	cpx #16
	beq end
    jmp loop
end

	rts
.)


