
_MessageScroller
	.asc "And here we are again, Solskogen, 2011 edition !!! "
	.asc "As usual, late minute production, not really finished, full of bugs, but I hope you will like it anyway.    "
	.asc "So what do we have here? Well, I guess you recognized the PopTart/Nyan Cat music, reproduced in all it's original "
	.asc "4khz/4bit sample glory. Honestly I'm not sure it actually sounds worse than the original version. "
	.asc "I wanted to add some double rainbow, pink unicorns, caramel dance and other internet meme shit, but I ran out of  "
	.asc "1) memory 2) time 3) patience 4) all of the above. "
	.asc "  "
	.asc "Greetings to all the usual suspects, you know I love you all, but specially to my GF who had the patience of me  "
	.asc "writing this shit during two days after I was back from a two week work trip in Montreal. The girl understand priorities!!! "
	.asc "  "
	.asc "Let's wrap :) "
	.asc "                            "
	.byt 0


_InterruptInstall
	sei
	lda #$20		; jsr
	sta $400
	lda #<_InterruptCode
	sta $401
	lda #>_InterruptCode
	sta $402
	lda #$60
	sta $403		; rts
	cli	
	rts

FlipCounter1	.byt 0
FlipCounter2	.byt 0

_VblCounter		.byt 0


_VSync
	lda _VblCounter
	beq _VSync
	lda #0
	sta _VblCounter
	rts



_InterruptCode
	inc FlipCounter1
	lda FlipCounter1
	and #2
	beq _InterruptCodeEnd

	lda #0
	sta FlipCounter1
	inc _VblCounter

	jsr _ScrollerDisplay

	inc FlipCounter2
	lda FlipCounter2
	and #2
	beq _InterruptCodeEnd

	lda #0
	sta FlipCounter2

	jsr _TeletypeUpdate

_InterruptCodeEnd
	rts


_MessageScrollerPtr	.word _MessageScroller


_ScrollerInit
	; paper
	lda #16+1
	sta $a000+40*0

	lda #16+1
	sta $a000+40*7

	lda #16+4
	sta $a000+40*1
	sta $a000+40*6


	lda #16+4
	sta $a000+40*2
	sta $a000+40*5

	lda #16+4
	sta $a000+40*3
	sta $a000+40*4

	ldx #38
	lda #64
ScrollerInitEraseLoop
	sta $a000+40*0,x
	sta $a000+40*1,x
	sta $a000+40*2,x
	sta $a000+40*3,x
	sta $a000+40*4,x
	sta $a000+40*5,x
	sta $a000+40*6,x
	sta $a000+40*7,x
	dex 
	bne ScrollerInitEraseLoop
	rts









ScrollerCounter		.byt 0

ScrollerCharBuffer	.byt 0,1,2,3,4,5,6,7	; Buffer with character to scroll

_ScrollerDisplay
;Break jmp Break

	lda ScrollerCounter
	beq ScrollerNewCharacter

	dec ScrollerCounter
	jmp ScrollerEndNewCharacter

ScrollerNewCharacter
	lda #6
	sta ScrollerCounter

	; message
	lda _MessageScrollerPtr
	sta tmp6
	lda _MessageScrollerPtr+1
	sta tmp6+1

	inc _MessageScrollerPtr
	bne skipscrollermove
	inc _MessageScrollerPtr+1
skipscrollermove

	; Get character and write into the buffer
	ldy #0
	lda (tmp6),y
	beq ScrollerDisplayReset 

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
	ldy #38
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


TeletypeMessage
	;     0123456789012345678901234567890123456789
	.asc " Defence Force is proud",2,"(ashamed)",7,"to",0
	.asc " present a new Oric intro for the",0
	.asc 3,"Solskogen 2011",7,"demo party.",0
	.asc " ",0
	.asc 4,"Starring:",0
	.asc "  MICKAEL 'DBUG' POINTIER",0
	.asc "  ORIC 'Nyan' ATMOS.",0
	.asc " ",0
	.asc 4,"Produced using:",0
	.asc "  Ripped internet crap",0
	.asc "  Annoying music",0
	.asc "  Non finished graphics",0
	.asc "  Recycled code from 3 demos",0
	.asc "  The Oric Software Development Kit",0
	.asc "  A hacked and buggy sample converter",0
	.asc " ",0
	.asc 4,"Known bugs:",0
	.asc "  The sample loops badly",0
	.asc "  The oric colors flicker horribly",0
	.asc "  There are no stars in the bottom half",0
	.asc "  This text uses the SYSTEM font",0
	.asc " ",0
	.asc " I hope you enjoyed it anyway, it's all",0
	.asc " I managed to write in two days",0
	.asc 3,"VOTE FOR ME !!!",0
	.asc " ",0
	.asc 4,"DEFENCE FORCE website:",0
	;     0123456789012345678901234567890123456789
	.asc "    http:",47,47,"www.defence-force.org       ",0
	.asc " ",0

	.asc " ",0
	.asc " ",0
	.asc " ",0
	.asc 1



TeletypeMessagePtr	.word TeletypeMessage
TeletypeXPos		.byt 0

_TeletypeUpdate
	; Red paper
	lda #17
	sta $bf68+40*0
	sta $bf68+40*1
	sta $bf68+40*2

	; Insert new char
	lda TeletypeMessagePtr
	sta tmp6
	lda TeletypeMessagePtr+1
	sta tmp6+1

	ldy #0

	lda (tmp6),y
	cmp #1
	bne TeletypeNoEndOfText

	; Reinitialise to begin of message
	; and reload character
	lda #<TeletypeMessage
	sta TeletypeMessagePtr
	sta tmp6
	lda #>TeletypeMessage
	sta TeletypeMessagePtr+1
	sta tmp6+1
	jmp	TeletypeScrollUp

TeletypeNoEndOfText

	inc TeletypeMessagePtr
	bne skipteletypemove
	inc TeletypeMessagePtr+1
skipteletypemove

	cmp #0
	beq TeletypeScrollUp

	ldx TeletypeXPos
	sta $bf68+40*2+1,x
	inc TeletypeXPos

	rts


TeletypeScrollUp
	ldx #39
TeletypeScrollUpLoopX
	lda $bf68+40*1,x
	sta $bf68+40*0,x
	lda $bf68+40*2,x
	sta $bf68+40*1,x
	lda #32
	sta $bf68+40*2,x
	dex
	bne TeletypeScrollUpLoopX

	ldx #0
	stx TeletypeXPos
	rts



