#define ENABLE_MUSIC
//#define DEBUG

#include "script.h"

#define        via_portb               $0300 
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


#define SCROLLER_MAX_X	40-7-1

#define	SCROLLER_START_ADDR $a000+SCROLLER_OFFSET


#define BOING_MIN_ADDR $a000+40*15*8 
//#define BOING_MIN_ADDR $a000+40*40*8
#define BOING_START_ADDR $a000+40*16*8

	.zero

_VblCounter					.dsb 1

_SystemFrameCounter
_SystemFrameCounter_low		.dsb 1
_SystemFrameCounter_high	.dsb 1

_ScrollerAddrBase
_ScrollerAddrBase_low		.dsb 1
_ScrollerAddrBase_high		.dsb 1

_MessageScrollerPtr			.dsb 2

_ScrollerCommand			.dsb 1
_ScrollerCommandParam1		.dsb 1
_ScrollerCommandParam2		.dsb 1
_ScrollerCommandParam3		.dsb 1
_ScrollerCommandParam4		.dsb 1

_ScrollerScreenDir		.dsb 1
_BoingPhase		.dsb 1

	.text

_BottomDesc
	.asc "Le salon de la (re)creation numerique", 0

_BottomDates
	.asc "    du 13 au 15 Novembre 2015        ", 0

_BottomPlace
	.asc "      a Tain l'Hermitage             ", 0

_BottomWWW
	.asc "     www.triplea.fr/alchimie         ", 0

_MessageScroller
    .byt SCROLLER_SHOW_LOGOVIP
	.asc "30 YEARS OF AMIGA! HAPPY BIRTHDAY!      "
	.byt SCROLLER_SCREEN_UP
	;; 	.byt SCROLLER_START_JSUN 
	.asc "Alchimie 0xb invitro "
	.byt SCROLLER_SCREEN_UP
	.asc "based on tunnel effect "
	.byt SCROLLER_SCREEN_UP
#ifndef DEBUG
	.asc "and other works by _Dbug_ (Defence Force)...   /   "
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomDesc
#endif
	.asc "And for the first time fully built "
	.byt SCROLLER_SCREEN_UP
	.asc "using the Linux-native ORIC SDK.   /  "
#ifndef DEBUG
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomDates
	.asc "Logo converted from the VIP original     "
#endif
	.byt SCROLLER_SHOW_LOGOA0XB
//	.byt SCROLLER_SCREEN_UP
	//.byt SCROLLER_START_BOING
	.asc "/ code: mmu_man/TripleA  "
//	.byt SCROLLER_SCREEN_UP
#ifndef DEBUG
	.asc "/ gfx: Cicile/TripleA  "
	.asc "/ music: Fabounio/TripleA  "
//	.asc "/ music: David Whittaker.    "
	;; 	.byt SCROLLER_SHOW_LOGOUA3
#endif
	//.byt SCROLLER_START_BOING
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomPlace
	.asc "L'Alchimie ca poutre !!!!      "
	.byt SCROLLER_SCREEN_UP
#ifndef DEBUG
	.asc "<demoparty> <conferences> <oldschool> <robotique> <retrogames>   "
#endif
	.asc "...     "
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomWWW
	.asc "Greetingz:   "
#ifndef DEBUG
	.asc "GGRO   "
	.asc "_Dbug_ / Defence Force   "
	.asc "Jylam   "
	.asc "PoPsY TeAm   "
	.asc "X-MEN   "
	.asc "LNX   "
	.asc "Sector One   "
	.asc "MJJ Prod   "
	.asc "Nectarine   "
	.asc "WoodTower   "
	.asc "NoExtra   "
	.asc "Vital-motion!   "
	.asc "the undead sceners   "
	.asc "dreamdealers   "
	.asc "TRBL   "
	.asc "DvO   "
	.asc "Calodox   "
	.asc "tmp   "
	.asc "punkfloyd   "
	.asc "Map   "
	.asc "Froggy Corp.   "
	.asc "Farbrausch   "
	.asc "Adinpsz   "
	.asc "PuR3LaM3Rs   "
	.asc "Evolution4   "
	.asc "TripleA   "
#endif
	.asc "            "
	.asc "The End :)  It's over now      "
	.asc "                            "
	.asc "The End :)  It's over now      "
	.asc "                            "
	.byt SCROLLER_DONE
	.asc " "
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
	sta _ScrollerScreenDir
	sta _BoingPhase

	lda #SCROLLER_NOTHING
	sta _ScrollerCommand
	lda #0
	sta _ScrollerCommandParam1
	sta _ScrollerCommandParam2
		
	lda #<SCROLLER_START_ADDR
	sta _ScrollerAddrBase_low
	lda #>SCROLLER_START_ADDR
	sta _ScrollerAddrBase_high

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
	sei

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
	ldx #SCROLLER_MAX_X
	lda #64
ScrollerInitEraseLoop
	sta SCROLLER_START_ADDR+40*0,x
	sta SCROLLER_START_ADDR+40*1,x
	sta SCROLLER_START_ADDR+40*2,x
	sta SCROLLER_START_ADDR+40*3,x
	sta SCROLLER_START_ADDR+40*4,x
	sta SCROLLER_START_ADDR+40*5,x
	sta SCROLLER_START_ADDR+40*6,x
	sta SCROLLER_START_ADDR+40*7,x
	dex 
	bne ScrollerInitEraseLoop

	; Small gradient
	;; lda #7
	;; sta SCROLLER_START_ADDR+40*0
	;; lda #7
	;; sta SCROLLER_START_ADDR+40*1
	;; lda #3
	;; sta SCROLLER_START_ADDR+40*2
	;; lda #3
	;; sta SCROLLER_START_ADDR+40*3
	;; lda #3
	;; sta SCROLLER_START_ADDR+40*4
	;; lda #2
	;; sta SCROLLER_START_ADDR+40*5
	;; lda #2
	;; sta SCROLLER_START_ADDR+40*6
	;; lda #2
	;; sta SCROLLER_START_ADDR+40*7
	lda #$87
	sta SCROLLER_START_ADDR+40*0
	sta SCROLLER_START_ADDR+40*1
	sta SCROLLER_START_ADDR+40*2
	sta SCROLLER_START_ADDR+40*3
	sta SCROLLER_START_ADDR+40*4
	sta SCROLLER_START_ADDR+40*5
	sta SCROLLER_START_ADDR+40*6
	sta SCROLLER_START_ADDR+40*7

	;lda #16+1
	;sta SCROLLER_START_ADDR+40*7
				
	; HIRES switch
	lda #30
	sta $bb80
	
	; TEXT switch
	lda #26
	sta $a000+40*8+40+40*75

	;
	; Minigradient test under the logos
	;
	;; lda #16+6
	;; sta $a000+40*87
	;; lda #16+4
	;; sta $a000+40*86
	;; lda #16+6
	;; sta $a000+40*87
	
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
	lda #<_AmigaTopazUnicodeRus_8_bits -32*8
	adc tmp7
	sta tmp7
	lda #>_AmigaTopazUnicodeRus_8_bits -32*8
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

	;; check if we move the screen up or down
	lda _ScrollerScreenDir
	beq ScrollerScreenNotMoved
	bmi ScrollerScreenMovedUp
;	jmp ScrollerScreenMovedDown
	
ScrollerScreenNotMoved

	jsr _BoingBall

ScrollerEndNewCharacter


;Break jmp Break





	lda _ScrollerAddrBase_low
	sta tmp6
	lda _ScrollerAddrBase_high
	sta tmp6+1


	ldx #0
ScrollerDisplayLoopMessageY
	; Get pixel from character
	clc
	lda ScrollerCharBuffer,x
	rol
	cmp #192
	and #%00111111
	ora #%11000000
	sta ScrollerCharBuffer,x

	; And then scroll the whole scanline
	ldy #SCROLLER_MAX_X
ScrollerDisplayLoopMessageX
	lda (tmp6),y
	rol
	cmp #192
	and #%00111111
	ora #%11000000
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
	;cmp #24
	;bpl ScrollerCommandFiveByte
	cmp #16
	bpl ScrollerCommandThreeByte

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

	
;; ScrollerScreenMovedDown
;; 	;; moved down
;; 	clc
;; 	lda _ScrollerAddrBase_low
;; 	sta tmp6
;; 	adc #40
;; 	sta tmp7
;; 	sta _ScrollerAddrBase_low
;; 	lda _ScrollerAddrBase_high
;; 	sta tmp6+1
;; 	sta tmp7+1
;; 	bcc skipmoveddown
;; 	inc tmp7+1
;; 	inc _ScrollerAddrBase_high
;; skipmoveddown
;; 	dec _ScrollerScreenDir
;; 	jmp ScrollerScreenNotMoved

ScrollerScreenMovedUp

	sec
	lda _ScrollerAddrBase_low
	sta tmp6
	sbc #40
	sta tmp7
	sta _ScrollerAddrBase_low
	lda _ScrollerAddrBase_high
	sta tmp6+1
	sta tmp7+1
	bcs skipmovedup
	dec tmp7+1
	dec _ScrollerAddrBase_high
skipmovedup
	inc _ScrollerScreenDir


	ldx #9
ScrollerScreenMovedUpL1
	ldy #39
ScrollerScreenMovedUpL2
	lda (tmp6),y
	sta (tmp7),y
	dey
	bpl ScrollerScreenMovedUpL2
	clc
	lda #40
	adc tmp6
	sta tmp6
	lda #0
	adc tmp6+1
	sta tmp6+1
	clc			;useless?
	lda #40
	adc tmp7
	sta tmp7
	lda #0
	adc tmp7+1
	sta tmp7+1
	dex
	bne ScrollerScreenMovedUpL1

	jmp ScrollerScreenNotMoved	


_BoingBall
 	lda _ScrollerAddrBase_high
 	cmp #>BOING_MIN_ADDR
 	bmi _DoBoingBall
 	rts
 _DoBoingBall

	lda #<BOING_START_ADDR
	sta tmp7
	lda #>BOING_START_ADDR
	sta tmp7+1
	lda #<Boing0
	sta tmp6
	lda #>Boing0
	sta tmp6+1

	lda _BoingPhase
	inc _BoingPhase
	;; disable
	//lda #0
	and #$3
	tax
	beq _BoingP0		
_BoingPL
	clc
	lda #< Boing1-Boing0
	adc tmp6
	sta tmp6
	lda #> Boing1-Boing0
	adc tmp6+1
	sta tmp6+1
	dex
	bne _BoingPL
_BoingP0


	ldx #40
_BoingL1
	ldy #BOING_BYTE_WIDTH-1
_BoingL2
	lda (tmp6),y
	sta (tmp7),y
	dey
	bne _BoingL2

	clc
	lda tmp6
	adc #BOING_BYTE_WIDTH
	sta tmp6
	bcc _BoingC1
	lda #0
	adc tmp6+1
	sta tmp6+1
_BoingC1
	clc
	lda tmp7
	adc #40
	sta tmp7
	bcc _BoingC2
	lda #0
	adc tmp7+1
	sta tmp7+1
_BoingC2
	
	dex
	bne _BoingL1
	
	rts
