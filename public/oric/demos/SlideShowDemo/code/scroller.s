
#define _picture_font_2 $9d00

	.dsb 256-(*&255)
	
// - Entry #43 '..\build\files\Font_16x16.hir'
//   Loads at address 40960 starts on track 41 sector 1 and is 6 sectors long (1442 compressed bytes: 57% of 2528 bytes).
_FontBuffer	.dsb 2528

	.dsb 256-(*&255)

_ScrollBuffer	.dsb 40*20


_MessageScroller
	.asc "Welcome to the Defence-Force's SlideShow! "
	.asc "This is still some heavy work in progress, with bugs and performance issues, "
	.asc "but as far as I know this is the first attempt ever made on the Oric at loading things "
	.asc "while playing musics and animations in the background."
	.asc "                            "
	.asc "The End :) Let's wrap..."
			
	.asc "                            "
	.byt 0



	.zero


_MessageScrollerPtr			.dsb 2
scroll_ptr_0				.dsb 2
scroll_ptr_1 				.dsb 2
	
	.text
	



_ScrollerInit
	; Clear the scroller area
	ldx #39
	lda #64
ScrollerInitEraseLoop
	sta _ScrollBuffer+40*0,x
	sta _ScrollBuffer+40*1,x
	sta _ScrollBuffer+40*2,x
	sta _ScrollBuffer+40*3,x
	sta _ScrollBuffer+40*4,x
	sta _ScrollBuffer+40*5,x
	sta _ScrollBuffer+40*6,x
	sta _ScrollBuffer+40*7,x
	dex 
	bne ScrollerInitEraseLoop


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

	
	rts









ScrollerCounter		.byt 0

ScrollerCharBuffer	.byt 0,0,0,0,0,0,0,0	; Buffer with character to scroll


_ScrollerDisplay
;Break jmp Break

	lda ScrollerCounter
	beq ScrollerNewCharacter

	dec ScrollerCounter
	jmp ScrollerEndNewCharacter

ScrollerNewCharacter
	lda #6
	sta ScrollerCounter

readCharacter	
	; Get character and write into the buffer
	ldy #0
	lda (_MessageScrollerPtr),y
	beq ScrollerDisplayReset

	jsr ScrollerIncPointer
	
	; Multiply by 8 the ASCII code to point in the font
	sta scroll_ptr_1
	lda #0
	sta scroll_ptr_1+1

	asl scroll_ptr_1
	rol scroll_ptr_1+1

	asl scroll_ptr_1
	rol scroll_ptr_1+1

	asl scroll_ptr_1
	rol scroll_ptr_1+1

	; Add the font pointer
	clc
	lda #<_picture_font_2-32*8
	adc scroll_ptr_1
	sta scroll_ptr_1
	lda #>_picture_font_2-32*8
	adc scroll_ptr_1+1
	sta scroll_ptr_1+1

	; Copy the character data to the scroller buffer
	ldy #0
loopcopychar
	lda (scroll_ptr_1),y
	ora #64
	sta ScrollerCharBuffer,y
	iny
	cpy #8
	bne loopcopychar

ScrollerEndNewCharacter


;Break jmp Break

	lda #<_ScrollBuffer
	sta scroll_ptr_0
	lda #>_ScrollBuffer
	sta scroll_ptr_0+1


	ldx #0
ScrollerDisplayLoopMessageY
	; Get pixel from character
	clc
	lda ScrollerCharBuffer,x
	rol
	cmp #192
	and #$3F
	ora #64
	sta ScrollerCharBuffer,x

	; And then scroll the whole scanline
	ldy #39
ScrollerDisplayLoopMessageX
	lda (scroll_ptr_0),y
	rol
	cmp #192
	and #%00111111
	ora #%01000000
	sta (scroll_ptr_0),y

	dey
	bne ScrollerDisplayLoopMessageX

	clc
	lda scroll_ptr_0
	adc #40
	sta scroll_ptr_0
	bcc skipkipppp
	inc scroll_ptr_0+1
skipkipppp

	inx
	cpx #8
	bne ScrollerDisplayLoopMessageY

	jsr BlitBufferToChars
	rts

ScrollerDisplayReset
	lda #<_MessageScroller
	sta _MessageScrollerPtr
	lda #>_MessageScroller
	sta _MessageScrollerPtr+1
	rts
	

	

ScrollerIncPointer	
	inc _MessageScrollerPtr
	bne skipscrollermove
	inc _MessageScrollerPtr+1
skipscrollermove
	rts


BlitBufferToChars	
    ;
	; Then blit the buffer to the text screen
    ;
    lda #<$9900
    sta scroll_ptr_0+0
    lda #>$9900
    sta scroll_ptr_0+1

    ldx #0
 loop_blit 
    ldy #0
	lda _ScrollBuffer+40*0,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*0,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*1,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*1,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*2,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*2,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*3,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*3,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*4,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*4,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*5,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*5,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*6,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*6,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*7,x
	sta (scroll_ptr_0),y
	iny
	lda _ScrollBuffer+40*7,x
	sta (scroll_ptr_0),y
	iny

	clc
    lda scroll_ptr_0+0
    adc #16
    sta scroll_ptr_0+0
    lda scroll_ptr_0+1
    adc #0
    sta scroll_ptr_0+1


	inx 
	cpx #40
	bne loop_blit

	rts




; Using the 24x20 font, each letter is 3 bytes large (in practice the largest is 20 pixels wide)
; Say a buffer 128 bytes large
; 128/3 bytes=42 characters large
; "WELCOME TO THE DEFENCE FORCE SLIDE SHOW" <- That's about 40 characters :S
; 128*20=2560
; 2560*6=15360
;



/*
 Fonts infos: http://cgi.algonet.se/htbin/cgiwrap?user=guld1&script=fonts.pl

Some scroll computation.

Say we have a 32x24 font

Displaying this message: "WELCOME TO DEFENCE FORCE ULTIMATE SLIDE DISK MUSIC SHOW, HOPE YOU WILL ENJOY IT!!!" (83 characters)
would use:
83*32=2656 pixels
2656/240=about 11 screens wide,
2656/50 =about 53 seconds scrolling time (at one pixel per frame - which is super slow)

2656/32 =83 bytes wide
83*24=1992 bytes for one scroll buffer
1992*6=11952 bytes for six preshifted buffers


32/6=5.3
5*6=30
6*6=36

Miriam's choices:
- millitary_15
- spaz_20 (19x20 plus spacing)
- classic_21_nice

Me:
- outline_24


*/

// From achimiex



