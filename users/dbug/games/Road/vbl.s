

#define VIA_1				$30f
#define VIA_2				$30c

_PsgVirtualRegisters
_PsgfreqA 		.byt 0,0    ;  0 1    Chanel A Frequency
_PsgfreqB		.byt 0,0    ;  2 3    Chanel B Frequency
_PsgfreqC		.byt 0,0    ;  4 5    Chanel C Frequency
_PsgfreqNoise	.byt 0      ;  6      Chanel sound generator
_Psgmixer		.byt 0      ;  7      Mixer/Selector
_PsgvolumeA		.byt 0      ;  8      Volume A
_PsgvolumeB		.byt 0      ;  9      Volume B
_PsgvolumeC		.byt 0      ; 10      Volume C
_PsgfreqShape	.byt 0,0    ; 11 12   Wave period
_PsgenvShape	.byt 0      ; 13      Wave form

_PsgNeedUpdate  .byt 1



_Breakpoint
	jmp _Breakpoint
_DoNothing
	rts

_VSync
.(
	//rts
	pha
loop_wait
	lda _VblCounter
	beq loop_wait
	lda #0
	sta _VblCounter
	pla
	rts
.)

_VSyncHardware
	lda $300
vsync_wait
	lda $30D
	and #%00010000 ;test du bit cb1 du registre d'indicateur d'IRQ
	beq vsync_wait
	rts


_Temporize
	ldy #1
temporize_outer
	ldx #0
temporize_inner
	dex
	bne temporize_inner

	dey
	bne temporize_outer

	rts



_System_Initialize
	;jmp _System_Initialize
.(
	//
	// Switch OFF interrupts, and enable Overlay RAM
	// Because writing in ROM, is basicaly very hard !
	//
	sei
	lda #%11111101
	sta $314

	//
	// Init params
	//
	lda #0
	sta _SystemFrameCounter_low
	sta _SystemFrameCounter_high

	// Set the VIA parameters
	lda #<20000
	sta $306
	lda #>20000
	sta $307

	// Install interrupt
	lda #<_InterruptCode_SimpleVbl
	sta $FFFE
	lda #>_InterruptCode_SimpleVbl
	sta $FFFF

	cli

	rts
.)



; A simple IRQ that increment a VBL counter: Should be called at 50hz frequency
_InterruptCode_SimpleVbl
.(
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
	
	; Update the sound generator
	.(
	lda _PsgNeedUpdate
	beq skip_update

	and #1
	sta _PsgNeedUpdate

	lda _Psgmixer
	ora #%11000000
	sta _Psgmixer

	ldy #0
register_loop
	ldx	_PsgVirtualRegisters,y

	; y=register number
	; x=value to write
	jsr _PsgPlayRegister

	iny
	cpy #14
	bne register_loop
skip_update	
	.)

	; Read the keyboard
	jsr _KeyboardRead


+__auto_callback
	jsr _DoNothing

	pla
	tay
	pla
	tax
	pla

	rti
.)





	
_KeyboardFlush
.(
loop
	jsr _KeyboardRead
	lda _gKey
	bne loop
	rts
.)	

_KeyboardWait
.(
	jsr _KeyboardFlush
loop	
	jsr _KeyboardRead
	lda _gKey
	beq loop
	rts
.)
	
_KeyboardRead
	lda #00
	sta _gKey

read_left
	ldx #$df
	jsr KeyboardSetUp
	beq read_right
	lda _gKey	
	ora #1
	sta _gKey
	
read_right
	ldx #$7f
	jsr KeyboardSetUp
	beq read_up
	lda _gKey	
	ora #2
	sta _gKey
	
read_up
	ldx #$f7
	jsr KeyboardSetUp
	beq read_down
	lda _gKey	
	ora #4
	sta _gKey
	
read_down
	ldx #$bf
	jsr KeyboardSetUp
	beq read_fire
	lda _gKey	
	ora #8
	sta _gKey
	
read_fire
	ldx #$fe
	jsr KeyboardSetUp
	beq read_end
	lda _gKey	
	ora #16
	sta _gKey
	
read_end
	rts


KeyboardSetUp
	;x=column a=row
	lda #04
	sta $300
	lda #$0e
	sta $30f
	lda #$ff
	sta $30c
	ldy #$dd
	sty $30c
	stx $30f
	lda #$fd
	sta $30c
	sty $30c
	lda $300
	and #08
	rts







; y=register number
; x=value to write
_PsgPlayRegister
.(
	sty	VIA_1
	txa

	pha
	lda	VIA_2
	ora	#$EE		; $EE	238	11101110
	sta	VIA_2

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	VIA_2

	tax
	pla
	sta	VIA_1
	txa
	ora	#$EC		; $EC	236	11101100
	sta	VIA_2

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	VIA_2

	rts
.)


_PsgStopSound
.(
	lda #0
	sta _PsgvolumeA
	sta _PsgvolumeB
	sta _PsgvolumeC
	lda #1
	sta _PsgNeedUpdate
	rts
.)


ExplodeData
	.byt 0,0,0,0,0,0,15
	.byt 7,16,16,16,0,24

_PsgExplode
.(
	ldx #0
loop
	lda ExplodeData,x
	sta _PsgVirtualRegisters,x
	inx
	cpx #14
	bne loop

	lda #2
	sta _PsgNeedUpdate


	rts
.)