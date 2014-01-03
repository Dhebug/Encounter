
#define SCROLLER_BUFFER_WIDTH   91

	.dsb 256-(*&255)

ScrollerBuffer1 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer2		.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer3 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer4 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer5 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer6 	.dsb SCROLLER_BUFFER_WIDTH*16


	.dsb 256-(*&255)
	
;// Entry #43 '..\build\files\Font12x16_ArtDeco.hir'
;// - Loads at address 40960 starts on the second side on track 0 sector 13 and is 4 sectors long (980 compressed bytes: 32% of 3040 bytes).
_FontBuffer	.dsb 3040

	.dsb 256-(*&255)

_FontAddrLow		.dsb 128
_FontAddrHigh		.dsb 128	
_FontCharacterWidth .dsb 128

_MessageScroller
	;.asc "AiMlToiiilllmN123abcdefg"
    .asc "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    .asc "abcdefghijklmnopqrstuvwxyz"
    .asc "123456789,;:.?!"
	.asc "Welcome to the Defence-Force's SlideShow! "
	.asc "This is still some heavy work in progress, with bugs and performance issues, "
	.asc "but as far as I know this is the first attempt ever made on the Oric at loading things "
	.asc "while playing musics and animations in the background."
	.asc "                            "
	.asc "The End :) Let's wrap..."
			
	.asc "                            "
	.byt 0

_NarrowCharacterList
	.asc "iI,;.:!'"
	.byt 0


	.zero


_MessageScrollerPtr			.dsb 2
scroll_ptr_0				.dsb 2
scroll_ptr_1 				.dsb 2
scroll_tmp_0				.dsb 2
scroll_tmp_1				.dsb 2
	
	.text
	


ByteMaskRight		.dsb 1
ByteMaskLeft		.dsb 1
column				.byt 0 
columnCopy			.byt 20

ScrollerCharacterColumn	.byt 0
ScrollerCurChar		.byt 0
ScrollCurCharWidth  .byt 0

ScrollerCharBuffer	.byt 0,0,0,0,0,0,0,0	; Buffer with character to scroll

ScrollTableLeft  .dsb 256
ScrollTableRight .dsb 256






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

;bllll jmp bllll

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

;bllll2 jmp bllll2

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

	;lda #10
	;sta $bb80+40*26
	;sta $bb80+40*27

	jsr GenerateScrollTable	

	ldy #44
	sty column

	jsr ScrollerDisplayReset	

	rts




	.dsb 256-(*&255)

ScrollerJumpTable
	.word _ScrollerPhase1
	.word _ScrollerPhase2
	.word _ScrollerPhase3
	.word _ScrollerPhase4
	.word _ScrollerPhase5
	.word _ScrollerPhase6

_ScrollerDisplay
	;jmp _ScrollerDisplay
	jsr __auto_jump
	;jsr CopyBuffersToFont
	rts

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
	; Get character and write into the buffer
	ldy #0
	sty ScrollerCharacterColumn

	lda (_MessageScrollerPtr),y
	beq ScrollerDisplayReset
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
	jsr CopyBuffersToFont_6
	rts


_ScrollerPhase2
    jsr CopyAndShift
	inc __auto_jump+1
	inc __auto_jump+1
	jsr CopyBuffersToFont_5
	rts

_ScrollerPhase3
    jsr CopyAndShift
	inc __auto_jump+1
	inc __auto_jump+1
	jsr CopyBuffersToFont_4
	rts

_ScrollerPhase4
    jsr CopyAndShift
	inc __auto_jump+1
	inc __auto_jump+1
	jsr CopyBuffersToFont_3
	rts

_ScrollerPhase5
    jsr CopyAndShift
	inc __auto_jump+1
	inc __auto_jump+1
	jsr CopyBuffersToFont_2
	rts


_ScrollerPhase6
    jsr CopyAndShift
    ; Reset to the start of the table
	lda #<ScrollerJumpTable
	sta __auto_jump+1

	jsr CopyBuffersToFont_1
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


;Break jmp Break

StupidRotatingMask .byt 0

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


tempWhatever  .byt 0

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


#define TARGET_SCROLL $a000+40*160

#ifdef SOURCE_SCROLL
#undef SOURCE_SCROLL
#endif
#define SOURCE_SCROLL ScrollerBuffer1
CopyBuffersToFont_1
.(
	lda #<SOURCE_SCROLL
	sta scroll_ptr_0+0
	lda #>SOURCE_SCROLL
	sta scroll_ptr_0+1

    ; Copy to charset
    jsr CopyToCharset

	rts
.)


#ifdef SOURCE_SCROLL
#undef SOURCE_SCROLL
#endif
#define SOURCE_SCROLL ScrollerBuffer2
CopyBuffersToFont_2
.(
	lda #<SOURCE_SCROLL
	sta scroll_ptr_0+0
	lda #>SOURCE_SCROLL
	sta scroll_ptr_0+1


    ; Copy to charset
    jsr CopyToCharset

	rts
.)



#ifdef SOURCE_SCROLL
#undef SOURCE_SCROLL
#endif
#define SOURCE_SCROLL ScrollerBuffer3
CopyBuffersToFont_3
.(
	lda #<SOURCE_SCROLL
	sta scroll_ptr_0+0
	lda #>SOURCE_SCROLL
	sta scroll_ptr_0+1

    ; Copy to charset
    jsr CopyToCharset

	rts
.)




#ifdef SOURCE_SCROLL
#undef SOURCE_SCROLL
#endif
#define SOURCE_SCROLL ScrollerBuffer4
CopyBuffersToFont_4
.(
	lda #<SOURCE_SCROLL
	sta scroll_ptr_0+0
	lda #>SOURCE_SCROLL
	sta scroll_ptr_0+1


    ; Copy to charset
    jsr CopyToCharset

	rts
.)




#ifdef SOURCE_SCROLL
#undef SOURCE_SCROLL
#endif
#define SOURCE_SCROLL ScrollerBuffer5
CopyBuffersToFont_5
.(
	lda #<SOURCE_SCROLL
	sta scroll_ptr_0+0
	lda #>SOURCE_SCROLL
	sta scroll_ptr_0+1

    ; Copy to charset
    jsr CopyToCharset

	rts
.)




#ifdef SOURCE_SCROLL
#undef SOURCE_SCROLL
#endif
#define SOURCE_SCROLL ScrollerBuffer6
CopyBuffersToFont_6
.(
	lda #<SOURCE_SCROLL
	sta scroll_ptr_0+0
	lda #>SOURCE_SCROLL
	sta scroll_ptr_0+1

    ; Copy to charset
    jsr CopyToCharset

	rts
.)


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

CopyToCharset
.(
	;lda #<TARGET_SCROLL+40*0
	;sta scroll_ptr_0+0
	;lda #>TARGET_SCROLL+40*0
	;sta scroll_ptr_0+1

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


