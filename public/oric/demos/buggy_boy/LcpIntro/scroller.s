
	.zero

SkipCounter					.dsb 1
_ScrollerPosition			.dsb 1
_ScrollerCounter			.dsb 1

_Scroller_JumpPos			.dsb 1
_Scroller_CurrentJumpPos	.dsb 1
_Scroller_Y					.dsb 1
_Scroller_XDecount			.dsb 1
_Scroller_XXDecount			.dsb 1


	.text

_Scroller_JumpTable
    .byt  $0c,$0c,$0d,$0d,$0e,$0e,$0f,$0f,$10,$10,$11,$11,$12,$12
    .byt  $13,$13,$14,$14,$14,$15,$15,$15,$15,$16,$16,$16,$16,$16,$17,$17
    .byt  $17,$17,$17,$17,$17,$17,$16,$16,$16,$16,$16,$15,$15,$15,$15,$14
    .byt  $14,$14,$13,$13,$12,$12,$11,$11,$10,$10,$0f,$0f,$0e,$0e,$0d,$0d
    .byt  $0c,$0c,$0b,$0b,$0a,$0a,$09,$09,$08,$08,$07,$07,$06,$06,$05,$05
    .byt  $04,$04,$03,$03,$03,$02,$02,$02,$02,$01,$01,$01,$01,$01,$00,$00
    .byt  $00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$02,$02,$02,$02,$03
    .byt  $03,$03,$04,$04,$05,$05,$06,$06,$07,$07,$08,$08,$09,$09,$0a,$0a
    .byt  $0b,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$15,$16,$16,$16
    .byt  $17,$17,$17,$17,$16,$16,$16,$15,$15,$14,$13,$12,$11,$10,$0f,$0e
    .byt  $0d,$0c,$0b,$0a,$09,$08,$07,$06,$05,$04,$03,$02,$02,$01,$01,$01
    .byt  $00,$00,$00,$00,$01,$01,$01,$02,$02,$03,$04,$05,$06,$07,$08,$09
    .byt  $0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$15,$16,$16,$16
    .byt  $17,$17,$17,$17,$16,$16,$16,$15,$15,$14,$13,$12,$11,$10,$0f,$0e
    .byt  $0d,$0c,$0b,$0a,$09,$08,$07,$06,$05,$04,$03,$02,$02,$01,$01,$01
    .byt  $00,$00,$00,$00,$01,$01,$01,$02,$02,$03,$04,$05,$06,$07,$08,$09
    .byt  $0a,$0b


_MessageScroller
	/*
	.asc "Hello, this is Dbug's first DYCP scroller on the Oric. "
	.asc "Thanks to Mermaid for the movement table and explanations. "
	.asc "                            "
	*/
	.asc "YEEEEAHHHHH, EVERYTHING WORKS !!!  "
	.asc "Doing a 64k single file demo is a lot harder than expected !!!  "
	.asc "It seems that finaly I finished the demo before the deadline :)  "
	.asc "Thanks for everybody's support !  "
	.asc "                                            "
	.byt 0


_MessageScrollerPtr	.word _MessageScroller

	.dsb 256-(*&255)


_Scroller_OffsetTable		.byt 40*0,40*1,40*2,40*3,40*4,40*5,40*6


_ScrollerTerminate
.(
	//jsr _System_InstallDoNothing_CallBack
	rts
.)



_Scroller_InitHires
.(
	jsr _ScrollerInit

	//
	// Install the Scroller VBL callback in the main interrupt handler
	//
	jsr _VSync
	sei
	lda #<_Scroller_DisplayHires
	sta _System_VblCallBack+0
	lda #>_Scroller_DisplayHires
	sta _System_VblCallBack+1
	cli
	rts
.)

_Scroller_DisplayHires
.(
	jsr _ScrollerDisplay
	jsr _ScrollerBlitToScreen
	rts
.)


/*

	$B400+8*35 = $B520-$A000 = 5400 / 40 = 135  
$B400+8*36 = $B520-$A000 = 5408 / 40 = 135,2  
$B400+8*37 = $B520-$A000 = 1520 / 40 = 
$B400+8*38 = $B520-$A000 = 1520 / 40 = 
$B400+8*39 = $B520-$A000 = 1520 / 40 = 
	$B400+8*40 = $B520-$A000 = 1520 / 40 = 
=> 41
 
	$B800+8*32 = $B920-$A000 = 6400 / 40 = 160,4
$B800+8*33 = $B920-$A000 = 6408 / 40 = 160,4
$B800+8*34 = $B920-$A000 = 6416 / 40 = 160,4
$B800+8*35 = $B920-$A000 = 6424 / 40 = 160,6
$B800+8*36 = $B920-$A000 = 6432 / 40 = 160,8
	$B800+8*37 = $B920-$A000 = 6440 / 40 = 161
=> 38



*/


_Scroller_InitDycp
.(
	jsr _ScrollerInit

	// Now, we need to predisplay characters
	
	.(
	ldx #4

	inx

	ldy #41
	sty tmp0+0

	ldy #38+128
	sty tmp0+1

loop
	lda tmp0+1
	sta $bb80+40*0+17,x
	sta $bb80+40*1+17,x
	sta $bb80+40*8+17,x
	sta $bb80+40*9+17,x
	sta $bb80+40*16+17,x
	sta $bb80+40*17+17,x

	inc tmp0+0
	inc tmp0+1

	lda tmp0+1
	sta $bb80+40*2+17,x
	sta $bb80+40*3+17,x
	sta $bb80+40*10+17,x
	sta $bb80+40*11+17,x
	sta $bb80+40*18+17,x
	sta $bb80+40*19+17,x

	inc tmp0+0
	inc tmp0+1

	lda tmp0+1
	sta $bb80+40*4+17,x
	sta $bb80+40*5+17,x
	sta $bb80+40*12+17,x
	sta $bb80+40*13+17,x
	sta $bb80+40*20+17,x
	sta $bb80+40*21+17,x

	inc tmp0+0
	inc tmp0+1

	lda tmp0+1
	sta $bb80+40*6+17,x
	sta $bb80+40*7+17,x
	sta $bb80+40*14+17,x
	sta $bb80+40*15+17,x
	sta $bb80+40*22+17,x
	sta $bb80+40*23+17,x

	inc tmp0+0
	inc tmp0+1

	inc tmp0+0
	inc tmp0+1

	lda #36
	sta $bb80+40*0+17,x
	sta $bb80+40*6+17,x
	sta $bb80+40*12+17,x
	sta $bb80+40*18+17,x
	sta $bb80+40*24+17,x

	inx
	cpx #20
	bcs end
	jmp loop
end
	.)
	

	
	.(
	ldx #4

	inx

	ldy #41
	sty tmp0+0

	ldy #38
	sty tmp0+1

loop
	lda tmp0+0
	sta $bb80+40*0,x
	sta $bb80+40*4,x
	sta $bb80+40*8,x
	sta $bb80+40*12,x
	sta $bb80+40*16,x
	sta $bb80+40*20,x

	inc tmp0+0
	inc tmp0+1

	lda tmp0+0
	sta $bb80+40*1,x
	sta $bb80+40*5,x
	sta $bb80+40*9,x
	sta $bb80+40*13,x
	sta $bb80+40*17,x
	sta $bb80+40*21,x

	inc tmp0+0
	inc tmp0+1

	lda tmp0+0
	sta $bb80+40*2,x
	sta $bb80+40*6,x
	sta $bb80+40*10,x
	sta $bb80+40*14,x
	sta $bb80+40*18,x
	sta $bb80+40*22,x

	inc tmp0+0
	inc tmp0+1

	lda tmp0+0
	sta $bb80+40*3,x
	sta $bb80+40*7,x
	sta $bb80+40*11,x
	sta $bb80+40*15,x
	sta $bb80+40*19,x
	sta $bb80+40*23,x

	inc tmp0+0
	inc tmp0+1

	inc tmp0+0
	inc tmp0+1

	inx
	cpx #20
	bcs end
	jmp loop
end
	.)
	
	lda #0
	sta _SystemEffectTrigger

	rts
.)

_Scroller_DisplayDycp
.(
	jsr _ScrollerDisplay
	jsr _ScrollerDrawDYCP
	rts
.)



_ScrollerInit
	.(
	ldx #2*8*6
	lda #64
loop_erase
	sta _Scroller_TwoChars_Buffer-1,x
	dex 
	bne loop_erase

	// Erase
	lda #<_Scroll_Circular_Buffer
	sta loop_inner+1
	lda #>_Scroll_Circular_Buffer
	sta loop_inner+2

	lda #64
	ldy #8
loop_outer
	ldx #0
loop_inner
	sta $1234,x
	dex
	bne loop_inner
	inc loop_inner+2
	dey
	bne loop_outer

	lda #39
	sta _ScrollerPosition
	lda #0
	sta _ScrollerCounter
	sta _Scroller_JumpPos

	rts
.)





ScrollerDisplayReset
	lda #<_MessageScroller
	sta _MessageScrollerPtr
	lda #>_MessageScroller
	sta _MessageScrollerPtr+1

	lda #1
	sta _SystemEffectTrigger

	rts

_ScrollerDisplay
.(
	//
	// Check if we need to insert a new character
	//
	inc _ScrollerCounter
	ldx _ScrollerCounter
	cpx #6
	beq insert_new_character
	jmp end_new_character

insert_new_character
	//jmp insert_new_character

	lda #0
	sta _ScrollerCounter

	// message
	lda _MessageScrollerPtr
	sta tmp6
	lda _MessageScrollerPtr+1
	sta tmp6+1

	inc _MessageScrollerPtr
	bne skip_scrollermove
	inc _MessageScrollerPtr+1
skip_scrollermove

	// Get character and write into the buffer
	ldy #0
	lda (tmp6),y
	beq ScrollerDisplayReset

	//
	// Preshift the character everywhere in the life...
	//
	// *8
	sta tmp7
	lda #0
	sta tmp7+1

	asl tmp7
	rol tmp7+1

	asl tmp7
	rol tmp7+1

	asl tmp7
	rol tmp7+1

	clc
	lda #<_picture_font_2-32*8
	adc tmp7
	sta tmp7
	lda #>_picture_font_2-32*8
	adc tmp7+1
	sta tmp7+1

	ldx #0
	ldy #0
loop_copychar
	lda _Scroller_TwoChars_Buffer_0+1,x
	ora #64
	sta _Scroller_TwoChars_Buffer_0+0,x

	lda (tmp7),y
	ora #64

	sta _Scroller_TwoChars_Buffer_0+1,x
	inx
	inx

	iny
	cpy #8
	bne loop_copychar


	.(
	ldx #0
loop_propagate
	clc
	lda _Scroller_TwoChars_Buffer_0+1,x
	rol
	cmp #192
	and #%00111111
	ora #%01000000
	sta _Scroller_TwoChars_Buffer_1+1,x

	lda _Scroller_TwoChars_Buffer_0+0,x
	rol
	cmp #192
	and #%00111111
	ora #%01000000
	sta _Scroller_TwoChars_Buffer_1+0,x

	inx
	inx

	cpx #2*8*5
	bne loop_propagate
	.)
	

	.(	
	ldx _ScrollerPosition
	inx
	cpx #40
	bne skip
	ldx #0
skip
	stx _ScrollerPosition
	.)


	.(
zon
	//jmp zon

	ldy #0
	ldx _ScrollerPosition
loop
	lda _Scroller_TwoChars_Buffer_0+0,y
	sta _Scroll_Circular_Buffer+256*0,x

	lda _Scroller_TwoChars_Buffer_0+2,y
	sta _Scroll_Circular_Buffer+256*1,x

	lda _Scroller_TwoChars_Buffer_0+4,y
	sta _Scroll_Circular_Buffer+256*2,x

	lda _Scroller_TwoChars_Buffer_0+6,y
	sta _Scroll_Circular_Buffer+256*3,x

	lda _Scroller_TwoChars_Buffer_0+8,y
	sta _Scroll_Circular_Buffer+256*4,x

	lda _Scroller_TwoChars_Buffer_0+10,y
	sta _Scroll_Circular_Buffer+256*5,x

	lda _Scroller_TwoChars_Buffer_0+12,y
	sta _Scroll_Circular_Buffer+256*6,x

	lda _Scroller_TwoChars_Buffer_0+14,y
	sta _Scroll_Circular_Buffer+256*7,x

	txa
	clc
	adc #40
	tax

	tya
	clc
	adc #16
	tay

	cpy #16*6

	bne loop

	.)

end_new_character

	//
	// Insert the new character on the right
	//
	rts
.)




// 40*8=320
_ScrollerBlitToScreen
.(
	.(
	ldx _ScrollerCounter
	lda _Scroller_OffsetTable,x
	sta __mod_min+1
	inx
	ldy _Scroller_OffsetTable,x
	//iny
	sty __mod_max+1
	sec
	adc _ScrollerPosition
	tax

	ldy #0
loop
__mod_max
	cpx #$12
	bcc skip
__mod_min
	ldx #$12
skip

	lda _Scroll_Circular_Buffer_0,x
	sta $a000+40*(0+0),y

	lda _Scroll_Circular_Buffer_1,x
	sta $a000+40*(0+1),y

	lda _Scroll_Circular_Buffer_2,x
	sta $a000+40*(0+2),y

	lda _Scroll_Circular_Buffer_3,x
	sta $a000+40*(0+3),y

	lda _Scroll_Circular_Buffer_4,x
	sta $a000+40*(0+4),y

	lda _Scroll_Circular_Buffer_5,x
	sta $a000+40*(0+5),y

	lda _Scroll_Circular_Buffer_6,x
	sta $a000+40*(0+6),y

	lda _Scroll_Circular_Buffer_7,x
	sta $a000+40*(0+7),y

	inx
	iny

	cpy #40
	bne loop
	.)
	rts
.)


#define SCROLLER_BASE_CHARSET		$b400+41*8
#define SCROLLER_BASE_CHARSET_ALT	$b800+38*8



_ScrollerDrawDYCP
.(
	lda #<SCROLLER_BASE_CHARSET
	sta tmp0+0
	lda #>SCROLLER_BASE_CHARSET
	sta tmp0+1

	lda _Scroller_JumpPos
	sta _Scroller_CurrentJumpPos
	inc _Scroller_JumpPos
	inc _Scroller_JumpPos


	.(
	ldx _ScrollerCounter
	lda _Scroller_OffsetTable,x
	inx
	ldy _Scroller_OffsetTable,x
	sty __mod_max+1
	sec
	adc _ScrollerPosition
	tax

	lda #20
	sta __mod_end+1

	ldy #0
	sty SkipCounter

	ldy #2
	sty _Scroller_XXDecount

	ldy #4
	sty _Scroller_XDecount
loop
	//
	// Be sure that min/max pointers are valid
	//
__mod_max
	cpx #$12
	bcc skipy
	txa
	sec
	sbc #40
	tax
skipy

	// Load the new offset
	ldy _Scroller_CurrentJumpPos
	inc _Scroller_CurrentJumpPos
	lda _Scroller_JumpTable,y
	sta _Scroller_Y


	//
	// Erase top part of charset
	//
	
	.(
	ldy _Scroller_Y
	beq skip
	lda #0
	tay
loop_clear
	sta (tmp0),y
	iny
	cpy _Scroller_Y
	bne loop_clear
skip
	.)

	//
	// Update midle part
	//
	lda _Scroll_Circular_Buffer_0,x
	sta (tmp0),y
	iny

	lda _Scroll_Circular_Buffer_1,x
	sta (tmp0),y
	iny

	lda _Scroll_Circular_Buffer_2,x
	sta (tmp0),y
	iny

	lda _Scroll_Circular_Buffer_3,x
	sta (tmp0),y
	iny

	lda _Scroll_Circular_Buffer_4,x
	sta (tmp0),y
	iny

	lda _Scroll_Circular_Buffer_5,x
	sta (tmp0),y
	iny

	lda _Scroll_Circular_Buffer_6,x
	sta (tmp0),y
	iny

	lda _Scroll_Circular_Buffer_7,x
	sta (tmp0),y
	iny


	//
	// Erase bottom part of charset
	//
	.(
	cpy #8*4
	bcs skip
	lda #0
loop_clear
	sta (tmp0),y
	iny
	cpy #8*4
	bcc loop_clear
skip
	.)
	

	lda tmp0+0
	clc
	adc #8*5
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1

	inx

	ldy _Scroller_XDecount
	iny
	sty _Scroller_XDecount
__mod_end
	cpy #20
	bcs loop_end
	jmp loop

loop_end
	dec _Scroller_XXDecount
	beq loop_end_end

	// Skip the two middle columns
	inx
	inx

	lda #35	//36
	sta __mod_end+1

	lda #<SCROLLER_BASE_CHARSET_ALT
	sta tmp0+0
	lda #>SCROLLER_BASE_CHARSET_ALT
	sta tmp0+1
	jmp loop


loop_end_end

	.)

	rts
.)
