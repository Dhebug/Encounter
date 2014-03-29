

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

	
	.text
	
_OldIrq	.dsb 2


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

	// Install interrupt (this works only if overlay ram is disabled)
	lda $FFFE
	sta _OldIrq+0
	lda $FFFF
	sta _OldIrq+1

	lda #<_InterruptCode_SimpleVbl
	sta $FFFE
	lda #>_InterruptCode_SimpleVbl
	sta $FFFF

	jsr _Player_Initialize

	cli
	rts	
.)

_System_RemoveIRQ
.(
	sei
	lda _OldIrq+0
	sta $FFFE
	lda _OldIrq+1
	sta $FFFF

	jsr _Player_Silence

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
		
	pha
	txa
	pha
	tya
	pha
		
	jsr _Player_PlayFrame

	pla
	tay
	pla
	tax
	pla

	rti


