
#define _picture_font_2 $9900

	.dsb 256-(*&255)
	
// - Entry #43 '..\build\files\Font_16x16.hir'
//   Loads at address 40960 starts on track 41 sector 1 and is 6 sectors long (1442 compressed bytes: 57% of 2528 bytes).
_FontBuffer	.dsb 2528

	.dsb 256-(*&255)

_ScrollBuffer	.dsb 40*20


_ScrollerMessage
	.byt "WELCOME TO THE DEFENCE FORCE SLIDE SHOW"


_ScrollerGenerate
.(
	lda _ScrollerMessage,x

	rts
.)

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



	.zero


_MessageScrollerPtr			.dsb 2

	
	.text
	

_MessageScroller
	.asc "Good news everyone!       "
	.asc "It is 7:56 on this mild norwegian morning, "
	.asc "here at Kindergarden. "
	.asc "Since party coding rules, I'm working on a small intro for the Alchimie-X.   "
	.asc "This logo was (hand) converted from H2O's original, the music is from David Whittaker, "
	.asc "the rest was built by Dbug on the party place."
    .asc "Looks like our friends from space are back???   "
    .asc "Greeting to everybody at Kindergarden and Alchimie, and anyone else who deserves it :)"
	.asc "                            "
	.asc "The End :) Let's wrap..."
			
	.asc "                            "
	.byt 0



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
	sta tmp7
	lda #0
	sta tmp7+1

	asl tmp7
	rol tmp7+1

	asl tmp7
	rol tmp7+1

	asl tmp7
	rol tmp7+1

	; Add the font pointer
	clc
	lda #<_picture_font_2-32*8
	adc tmp7
	sta tmp7
	lda #>_picture_font_2-32*8
	adc tmp7+1
	sta tmp7+1

	; Copy the character data to the scroller buffer
	ldy #0
loopcopychar
	lda (tmp7),y
	ora #64
	sta ScrollerCharBuffer,y
	iny
	cpy #8
	bne loopcopychar

ScrollerEndNewCharacter


;Break jmp Break

	lda #<$a000
	sta tmp6
	lda #>$a000
	sta tmp6+1


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
	lda (tmp6),y
	rol
	cmp #192
	and #%00111111
	ora #%01000000
	sta (tmp6),y

	dey
	bne ScrollerDisplayLoopMessageX

	clc
	lda tmp6
	adc #40
	sta tmp6
	bcc skipkipppp
	inc tmp6+1
skipkipppp

	inx
	cpx #8
	bne ScrollerDisplayLoopMessageY

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
