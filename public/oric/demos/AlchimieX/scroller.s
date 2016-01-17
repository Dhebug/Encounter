
#define ENABLE_MUSIC

#include "script.h"

#define        via_portb                $0300 
#define        via_t1cl                $0304 
#define        via_t1ch                $0305 
#define        via_t1ll                $0306 
#define        via_t1lh                $0307 
#define        via_t2ll                $0308 
#define        via_t2ch                $0309 
#define        via_sr                  $030A 
#define        via_acr                 $030b 
#define        via_pcr                 $030c 
#define        via_ifr                 $030D 
#define        via_ier                 $030E 
#define        via_porta               $030f 


	.zero

_VblCounter					.dsb 1

_SystemFrameCounter
_SystemFrameCounter_low		.dsb 1
_SystemFrameCounter_high	.dsb 1

_MessageScrollerPtr			.dsb 2

_ScrollerCommand			.dsb 1
_ScrollerCommandParam1		.dsb 1
_ScrollerCommandParam2		.dsb 1
_ScrollerCommandParam3		.dsb 1
_ScrollerCommandParam4		.dsb 1

	
	.text
	

_MessageScroller
    .byt SCROLLER_START_CHESSBOARD
	.asc "Good news everyone!       "
	.byt SCROLLER_SHOW_KGLOGO
	.asc "It is 7:56 on this mild norwegian morning, "
    .byt SCROLLER_START_GAMEOFLIFE
	.asc "here at Kindergarden. "
    .byt SCROLLER_SHOW_EVOLUTIONLOGO
	.asc "Since party coding rules, I'm working on a small intro for the Alchimie-X.   "
	.byt SCROLLER_SHOW_LOGO
	.asc "This logo was (hand) converted from H2O's original, the music is from David Whittaker, "
	.asc "the rest was built by Dbug on the party place."
    .byt SCROLLER_SHOW_SPACESHIP
    .asc "Looks like our friends from space are back???   "
    .asc "Greeting to everybody at Kindergarden and Alchimie, and anyone else who deserves it :)"
	.asc "                            "
	.asc "The End :) Let's wrap..."
			
	.asc "                            "
	.byt SCROLLER_END


/*	
;
; Installs a simple 50hz Irq
;
; 304
; 306
; 307
bit $304	// VIA_T1CL ; Turn off interrupt early.  (More on that below

;Based on setting T1 to FFFF and adding to global counter in IRQ for up to 16.5
;Million Clock Cycles.


#define VIA_T1CL 			$0304
#define VIA_T1CH 			$0305

#define VIA_T1LL 			$0306
#define VIA_T1LH 			$0307

_VSync
	lda $300
vsync_wait
	lda $30D
	and #%00010000 ;test du bit cb1 du registre d'indicateur d'IRQ
	beq vsync_wait
	rts

*/
_System_InstallIRQ_SimpleVbl
.(
	sei

	//
	// Switch OFF interrupts, and enable Overlay RAM
	// Because writing in ROM, is basicaly very hard !
	//
	sei
	lda #%11111101
	sta $314
	
	// Set the VIA parameters
	lda #<19966		; 20000
	sta $306
	lda #>19966		; 20000
	sta $307

	lda #0
	sta _VblCounter
	sta _SystemFrameCounter_low
	sta _SystemFrameCounter_high
	
	lda #SCROLLER_NOTHING
	sta _ScrollerCommand
	lda #0
	sta _ScrollerCommandParam1
	sta _ScrollerCommandParam2
		
	;
	; Scroller
	;
	jsr ScrollerDisplayReset
	
 	;
 	; Music player
 	;
#ifdef ENABLE_MUSIC 	
	jsr _Mym_Initialize
#endif	

	// Install interrupt (this works only if overlay ram is disabled)
	lda #<_InterruptCode_SimpleVbl
	sta $FFFE
	lda #>_InterruptCode_SimpleVbl
	sta $FFFF

	cli
	rts	
.)




_VSync
	lda _VblCounter
	beq _VSync
	lda #0
	sta _VblCounter
	rts


_InterruptCode_SimpleVbl
_InterruptCode
	bit $304
	inc _VblCounter
	
	.(
	inc _SystemFrameCounter_low
	bne skip
	inc _SystemFrameCounter_high
skip
	.)
	
	pha
	txa
	pha
	tya
	pha
	
	jsr _ScrollerDisplay
	
#ifdef ENABLE_MUSIC 	
	jsr _Mym_PlayFrame
#endif
	
_InterruptCodeEnd
	pla
	tay
	pla
	tax
	pla

	rti




_ScrollerInit
	lda #SCROLLER_NOTHING
	sta _ScrollerCommand
	
	; Clear the scroller area
	ldx #39
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

	; Small gradient
	lda #7
	sta $a000+40*0
	lda #7
	sta $a000+40*1
	lda #3
	sta $a000+40*2
	lda #3
	sta $a000+40*3
	lda #3
	sta $a000+40*4
	lda #2
	sta $a000+40*5
	lda #2
	sta $a000+40*6
	lda #2
	sta $a000+40*7

	;lda #16+1
	;sta $a000+40*7
				
	; HIRES switch
	lda #30
	sta $bb80
	
	; TEXT switch
	lda #26
	sta $a000+40*8+40+40*75

	;
	; Minigradient test under the logos
	;
	lda #16+6
	sta $a000+40*87
	lda #16+4
	sta $a000+40*86
	lda #16+6
	sta $a000+40*87
	
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
	cmp #32
	bcc SpecialCommand

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
	
SpecialCommand	
	;cmp #SCROLLER_MOVE_MAP
	;beq ScrollerCommandThreeByte
	;cmp #SCROLLER_HIGHLIGHTE 
	;beq ScrollerCommandFiveByte
	; ...default commands are one byte	

ScrollerCommandOneByte
	ldx #1
	jmp ReadParameters

ScrollerCommandThreeByte
	ldx #3
	jmp ReadParameters
		
ScrollerCommandFiveByte
	ldx #5
	jmp ReadParameters

ParamCounter	.byt 0		
	
ReadParameters
	.(
	stx ParamCounter
	ldx #0
	ldy #0
loop	
	lda (_MessageScrollerPtr),y
	sta _ScrollerCommand,x
	inx
	
	jsr ScrollerIncPointer

	dec ParamCounter
	bne loop
	jmp readCharacter
	.)
		
	

ScrollerIncPointer	
	inc _MessageScrollerPtr
	bne skipscrollermove
	inc _MessageScrollerPtr+1
skipscrollermove
	rts
