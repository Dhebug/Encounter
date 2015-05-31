

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
vsync_save_a				.dsb 1

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
	lda $FFFE
	sta _auto_restore_irq_low+1
	lda #<_50Hz_InterruptHandler
	sta $FFFE

	lda $FFFF
	sta _auto_restore_irq_high+1
	lda #>_50Hz_InterruptHandler
	sta $FFFF

	cli
	rts	
.)

_System_RestoreIRQ
.(
+_auto_restore_irq_low
	lda #$00
	sta $FFFE
+_auto_restore_irq_high
	lda #$00
	sta $FFFF
	rts
.)


_VSync
	sta vsync_save_a
	lda _VblCounter
	beq _VSync
	lda #0
	sta _VblCounter
_DoNothing
	lda vsync_save_a
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
	
	pla
	tay
	pla
	tax
	pla

	rti


