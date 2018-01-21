

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
_KeyboardState				.dsb 1
_KeyboardStateMemorized     .dsb 1

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

	jsr _ReadKeyboard
	lda _KeyboardStateMemorized
	ora _KeyboardState
	sta _KeyboardStateMemorized
	
	pla
	tay
	pla
	tax
	pla

	rti







;	en $ff y'a la valeur de la touche pressée
;	les valeurs en sortie ...
;	key_left=1,
;	key_left_up=5,
;	key_left_down=9,
;	key_right_up=6,
;	key_right_down=10,
;	key_right=2,
;	key_up=4,
;	key_down=8,
;	key_fire= 16

_WaitNoKeyPressed
	lda _KeyboardState
	bne _WaitNoKeyPressed
	lda #0
	sta _KeyboardStateMemorized
	rts

_ReadKeyboard
	lda #00
	sta _KeyboardState

	ldx #$df     ;left
	jsr setup_key
	beq rk_01
	lda _KeyboardState
	ora #1
	sta _KeyboardState
rk_01
	ldx #$7f	;right
	jsr setup_key
	beq rk_02
	lda _KeyboardState
	ora #2
	sta _KeyboardState
rk_02
	ldx #$f7	;up
	jsr setup_key
	beq rk_03
	lda _KeyboardState
	ora #4
	sta _KeyboardState
rk_03
	ldx #$bf	;down
	jsr setup_key
	beq rk_04
	lda _KeyboardState
	ora #8
	sta _KeyboardState
rk_04
	ldx #$fe	;fire
	jsr setup_key
	beq rk_05
	lda _KeyboardState
	ora #16
	sta _KeyboardState
rk_05
	lda _KeyboardState
	rts

setup_key
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
