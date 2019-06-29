// scrolling inside the font buffer itself
#define ENABLE_MUSIC
//#define DEBUG
//#define DEBUG_FONT

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

; paper+ink+dblheight on left, looks better symetrical
; code requires 32 max width (due to 8bit wrapping)
#define SCROLLER_MAX_X	40-8

//#define	SCROLLER_START_ADDR $a000+SCROLLER_OFFSET
// 0x9C00+33*8
#define	SCROLLER_START_ADDR 39936+33*8


#define BOING_MIN_ADDR $a000+40*15*8 
//#define BOING_MIN_ADDR $a000+40*40*8
#define BOING_START_ADDR $a000+40*16*8

	.zero

_VblCounter					.dsb 1

_SavedIRQ					.dsb 2

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
	.asc "     du 1 au 3 Novembre 2019         ", 0

_BottomPlace
	.asc "        a Tain l'Hermitage           ", 0

_BottomWWW
	.asc "         triplea.fr/alchimie         ", 0

_BottomRDV
	.asc "    Rendez-vous a l'Alchimie 13!     ", 0

_MessageScroller
    .byt SCROLLER_SHOW_SCROLL
//	.asc " !'#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_ abcdefghijklmnopqrstuvwxyz{|}  "
//	.asc "     A little invitro...  "
#ifndef DEBUG
	.asc "                        "
	.asc "   Happy 20th Birthday VIP!!!      "
	//.byt SCROLLER_SCREEN_UP
	//;; 	.byt SCROLLER_START_JSUN 
;	.asc "                        "
#endif

#ifndef DEBUG
//;	.asc "                        "
//	.asc "   It is always a pleasure to join"
	.asc " Traditions...   traditions...  "
	.asc "                                "
	.asc " Once again we gather around to code... "
	.asc "       discuss...        and have fun at"
	.asc " the Very Important Party!    "
	.asc "                                "
	.asc " We love you!           "
	.asc "                        "
	//.byt SCROLLER_SCROLL_SCROLL
	.asc " | We would like to invite you to...  "
#endif
	.byt SCROLLER_SHOW_LOGOA13

;	.asc "                        "
	.asc "   Alchimie Treize !           "
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomDesc
	//.byt SCROLLER_SCREEN_UP

	.asc "   Le salon de la (re)creation numerique !           "
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomDates
	.asc "    du 10 au 12 Novembre 2017        "
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomPlace
	.asc "      a Tain l'Hermitage             "
#ifndef DEBUG
	.asc "       triplea.fr/alchimie           "
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomWWW
	.asc "(demoparty)   (conferences)   (oldschool)   (robotique)   (retrogames)   "
/*
	.asc "   Pas de DemoParty cette annee,  "
	.asc "   mais une AmigaBouffe grand format !       "
	.asc "    du 20 au 21 octobre 2018        "
	.asc "      a Clerieux           "
	.asc "       triplea.fr/microalchimie         "
*/
#endif
	//.byt SCROLLER_SCROLL_SCROLL
#ifndef DEBUG
	.asc "                        "
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomDesc
	.asc " | This invitro was inspired by code "
	//.byt SCROLLER_SCREEN_UP
	.asc "and other works by _Dbug_ (Defence Force)... "
#endif
//	.asc " | This time we did a 3-screenful HIRES scrolling "
	//.byt SCROLLER_SCREEN_UP
//	.asc " plus a scrolltext on the bottom text lines using the font RAM."
#ifndef DEBUG
//	.asc " | VIP logo converted from the VIP original."
#endif
//	.byt SCROLLER_SCREEN_UP
	//.byt SCROLLER_START_BOING
	.asc " | code: mmu_man/TripleA"
//	.byt SCROLLER_SCREEN_UP
#ifndef DEBUG
	.asc " | gfx: Cicile/TripleA"
	.asc " | music: Fabounio/TripleA"
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomDates
//	.asc " | music: David Whittaker.  "
	//;; 	.byt SCROLLER_SHOW_LOGOUA3
#endif
	//.byt SCROLLER_START_BOING
	.asc "               "
//	.asc "L'Alchimie ca poutre !!!! "
//	.asc "La Micro Alchimie ca poutre !!!! "
	//.byt SCROLLER_SCREEN_UP
	.asc "               "
	.asc "               "
	.asc "Greetingz:"
#ifndef DEBUG
	.asc "   GGRO"
	.asc " | _Dbug_ / Defence Force"
	.asc " | PoPsY TeAm"
	.asc " | X-Men"
	.asc " | MPS"
	.asc " | MJJ Prod"
	.asc " | Laboratoire D"
	.asc " | G2L2 Corp"
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomPlace
	.asc " | SWYNG"
	.asc " | PAULA POWERED"
	.asc " | Logon System"
	.asc " | Sector One"
	.asc " | New Order"
	.asc " | Dark Force"
	.asc " | Cerebral Vortex"
	.asc " | Cocoon"
	.asc " | Replicants"
	.asc " | Map"
	.asc " | Woootz"
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomWWW
	.asc " | Cosmosaure"
	.asc " | SFX"
	.asc " | Atari Legend"
	.asc " | Eclipse"
	.asc " | Froggy Corp."
	.asc " | Team Unicorn"
	.asc " | SQNY"
	.asc " | Paradize"
	.asc " | Calodox"
	.asc " | ELITE"
	.asc " | WoodTower"

	.asc " | Apollo Team (Vampire POWAH!)"
	.asc " | Silicium & MO5.com"
	.asc " | and all the friends of TripleA"
#endif
	.asc "            "
	.byt SCROLLER_SHOW_BELETT
	.asc "            "
	.byt SCROLLER_BOTTOM_TEXT
	.word _BottomRDV
	.asc " Monsieur Belett' et son equipe vous remercient"
	.asc " et vous donnent rendez-vous a l'Alchimie 13. "
	.asc "            "
	.asc "            "
	.asc "The End :)  IT'S OVER NOW      "
	.asc "                            "
	.asc " SEE YOU ALL AT ALCHIMIE 13 !   "
	.asc "                            "
	.asc "The End :)  IT'S OVER NOW      "
	.asc "                            "
	.asc " SEE YOU ALL AT ALCHIMIE 13 !   "
	.asc "                            "
	.asc " Non mais serieux, rentrez chez vous !!   "
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

	lda $FFFE
	sta _SavedIRQ
	lda $FFFF
	sta _SavedIRQ+1
	// Install interrupt (this works only if overlay ram is disabled)
	lda #<_InterruptCode_SimpleVbl
	sta $FFFE
	lda #>_InterruptCode_SimpleVbl
	sta $FFFF

	cli
	rts	
.)


/*
_System_UninstallIRQ_SimpleVbl
.(
	sei

	// Install interrupt (this works only if overlay ram is disabled)
	lda _SavedIRQ
	sta $FFFE
	lda _SavedIRQ+1
	sta $FFFF

	cli
	rts	
.)
*/

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
	ldx #SCROLLER_MAX_X+1
	lda #64
ScrollerInitEraseLoop
	; TODO: simplify?
	sta SCROLLER_START_ADDR+(SCROLLER_MAX_X)*0,x
	sta SCROLLER_START_ADDR+(SCROLLER_MAX_X)*1,x
	sta SCROLLER_START_ADDR+(SCROLLER_MAX_X)*2,x
	sta SCROLLER_START_ADDR+(SCROLLER_MAX_X)*3,x
	sta SCROLLER_START_ADDR+(SCROLLER_MAX_X)*4,x
	sta SCROLLER_START_ADDR+(SCROLLER_MAX_X)*5,x
	sta SCROLLER_START_ADDR+(SCROLLER_MAX_X)*6,x
	sta SCROLLER_START_ADDR+(SCROLLER_MAX_X)*7,x
	dex 
	bne ScrollerInitEraseLoop

	; Color attributes won't work in the font buffer,
	; set them up in the text lines directly
	; FIXME TODO
	;lda #16+1
	;sta SCROLLER_START_ADDR+40*7
				
	; HIRES switch
;	lda #30
;	sta $bb80
	
	; TEXT switch
	;lda #26
	;sta $a000+40*8+40+40*75

	ldx #40-3
	lda #32 // space
ScrollerInitTextEraseLoop
	sta $bf90+2,x
	sta $bf90+40+2,x
	dex 
	bne ScrollerInitTextEraseLoop

	; paper: white
;	lda #23
;	sta $bf90+0;
#ifdef SCROLLER_DOUBLE_HEIGHT
;	sta $bf90+40+0;
#endif

	; ink: blue
;	lda #4
;	sta $bf90+1;
#ifdef SCROLLER_DOUBLE_HEIGHT
;	sta $bf90+40+1;
#endif

/*	; space to let paper+ink go through
	lda #35
	sta $bf90+2;
	sta $bf90+3;
	sta $bf90+4;
#ifdef SCROLLER_DOUBLE_HEIGHT
	sta $bf90+40+2;
	sta $bf90+40+3;
	sta $bf90+40+4;
#endif
*/

#ifdef SCROLLER_DOUBLE_HEIGHT
	lda #11	; dbl height non blinking alt charset
	sta $bf90+2;
	sta $bf90+40+2;
#endif

	; set up text lines to point to contiguous characters in the font
	ldx #SCROLLER_MAX_X-1
	ldy #33+SCROLLER_MAX_X-1 ; '!' and up
ScrollerInitTextLoop
	tya
	sta $bf90+4,x
#ifdef SCROLLER_DOUBLE_HEIGHT
	sta $bf90+40+4,x
#endif
	dey 
	dex 
	bne ScrollerInitTextLoop


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


; unrolled here as subroutine to avoid branch overflow
sub8y
	; y-=8 (unrolled)
	dey
	dey
	dey
	dey
	dey
	dey
	dey
	dey
	rts

_ScrollerDisplay
;Break jmp Break
;	rts

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
#ifndef DEBUG_FONT
;	lda #<_AmigaTopazUnicodeRus_8_bits -32*8
;	lda #<_Minecrafter_3_6_6_bits -32*8
	lda _scrollerFont//+32*8
#else
	lda #<$9C00 -32*8
#endif
	adc tmp7
	sta tmp7
#ifndef DEBUG_FONT
;	lda #>_AmigaTopazUnicodeRus_8_bits -32*8
;	lda #>_Minecrafter_3_6_6_bits -32*8
	lda _scrollerFont+1//+32*8
#else
	lda #>$9C00 -32*8
#endif
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
;	lda _ScrollerScreenDir
;	beq ScrollerScreenNotMoved
;	bmi ScrollerScreenMovedUp
;	jmp ScrollerScreenMovedDown
	
ScrollerScreenNotMoved

	;jsr _BoingBall

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
	;ora #64
	rol
	cmp #192
	and #%00111111
	ora #%11000000
	sta ScrollerCharBuffer,x

	; And then scroll the whole scanline
	ldy #(SCROLLER_MAX_X)*8-8 ; (= 256 which overflows)
ScrollerDisplayLoopMessageX
	lda (tmp6),y
	;ora #64
	rol
	cmp #192
	and #%00111111
	ora #%11000000
	sta (tmp6),y

	; reset N flag
	;cmp #0
	; y-=8 (unrolled)
	jsr sub8y

	bne ScrollerDisplayLoopMessageX

	clc
	lda tmp6
	adc #1 ; go to next line on the same first character in the font
	sta tmp6
	bcc skipkipppp
	inc tmp6+1
skipkipppp

	inx
	cpx #8
	bne ScrollerDisplayLoopMessageY
foo
	;jmp foo

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


; reg5 = 
; reg6 = 
; reg7 = 
_A12_DoLeftScroll

	ldy #0
	lda (sp),y
	sta reg7
	iny
	lda (sp),y
	sta reg7+1


	lda #<$a000
	sta reg5
	lda #>$a000
	sta reg5+1


	ldx #0

A12_ScrollerDisplayLoopMessageY
	txa
	pha

	; = *A12_bp
	ldy #0
	lda (reg7),y
	;tax
	sta reg6

	lda reg5
	sta A12_lda_inner1+1
	sta A12_sta_inner1+1
	lda reg5+1
	sta A12_lda_inner1+2
	sta A12_sta_inner1+2

	ldy #40


A12_ScrollerDisplayLoopMessageX

	;txa
	;pha

	dey
;	lda (reg5),y
A12_lda_inner1
	lda $ffff,y
	;sta reg6
	tax
	;pla
	lda reg6

;	sta (reg5),y
A12_sta_inner1
	sta $ffff,y

	stx reg6

	cpy #2
	bne A12_ScrollerDisplayLoopMessageX

	; handle paper & ink
	dey
	txa
	and #%01111111
	cmp #8
	bpl A12_sk1
	txa
	sta (reg5),y
	jmp A12_skdone
A12_sk1
	cmp #16
	bmi A12_skdone
	cmp #24
	bpl A12_skdone
	dey
	txa
	sta (reg5),y
	;jmp A12_skdone

A12_skdone

	; reg5 += 40
	clc
	lda reg5
	adc #40 ; go to next line
	sta reg5
	bcc A12_skip1
	inc reg5+1
A12_skip1

	; A12_bp += 40
	clc
	lda reg7 ;_A12_bp
	adc #40 ; go to next line
	sta reg7 ;_A12_bp
	bcc A12_skip2
	inc reg7+1 ;_A12_bp+1
A12_skip2

	pla
	tax

	inx
	cpx #200
	bne A12_ScrollerDisplayLoopMessageY

	rts

