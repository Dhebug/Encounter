

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


	.zero

_VblCounter					.dsb 1
	
	.text
	
_System_InstallIRQ_SimpleVbl
.(
	sei
	// Set the VIA parameters
	lda #<19966		; 20000
	sta $306
	lda #>19966		; 20000
	sta $307

	lda #0
	sta _VblCounter
	
	; Install interrupt (this works only if overlay ram is accessible)
	lda #<_50Hz_InterruptHandler
	sta $FFFE
	lda #>_50Hz_InterruptHandler
	sta $FFFF

	cli
	rts	
.)


_VSync
	lda _VblCounter
	beq _VSync
	lda #0
	sta _VblCounter
_DoNothing
	rts


_50Hz_InterruptHandler
	bit $304
	inc _VblCounter
		
	pha
	txa
	pha
	tya
	pha
		
_InterruptCallBack_1		; Used by the transition animation that shows the name of the authors
	jsr _DoNothing			; Transformed to "jsr _PrintDescriptionCallback"

_InterruptCallBack_2		; Used by the scrolling code
	jsr _DoNothing			; Transformed to "jsr _ScrollerDisplay" -> 15675 cycles -> 15062

_InterruptCallBack_3		; Used by the music player
	jsr _DoNothing			; Transformed to "jsr _Mym_PlayFrame" -> 12 cycles
	
	jsr MiniScrollLoading   ; -> 338 cycles

	pla
	tay
	pla
	tax
	pla

	rti



LoadingDataBitmap
.(
	.dsb 8*2	
	; 58 pixels bitmap + 8 +8 = 74
#include "loading_data.s"
	.dsb 8*2	
.)

MiniScrollColorCycle
	.byt 1,3,7,6,4,4,5,1
	.byt 1,3,7,6,4,4,5,1

MiniScrollYPos	.byt 1

MiniScrollLoading
.(
	ldy MiniScrollYPos
	dey
	bne no_reset
	ldy #74
no_reset	
	sty MiniScrollYPos

	tya
	and #7
	tax
	lda MiniScrollColorCycle,x
	stx $bb80+40*26+38
	inx
	lda MiniScrollColorCycle,x
	stx $bb80+40*27+38

	ldx #0
loop	
	lda LoadingDataBitmap,y
	sta $9800+126*8,x
	iny
	inx
	cpx #16
	bne loop
	rts
.)
