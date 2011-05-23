#include "main.h"


#define _hires		$ec33
;#define _text		$ec21
;#define _ping		$fa9f
;#define _shoot		$fab5
;#define _zap		$fae1
;#define _explode	$facb
;#define _kbdclick1	$fb14
;#define _kbdclick2	$fb2a

;#define _cls		$ccce
;#define _lores0		$d9ed
;#define _lores1		$d9ea


.zero
;*=	$50

;ap		.dsb 2
;fp		.dsb 2
sp		.dsb 2
tmp0	.dsb 2
tmp1	.dsb 2
tmp2	.dsb 2
tmp3	.dsb 2
tmp4	.dsb 2
tmp5	.dsb 2
tmp6	.dsb 2
tmp7	.dsb 2
op1		.dsb 2
op2		.dsb 2
tmp		.dsb 2
;reg0	.dsb 2
;reg1	.dsb 2
;reg2	.dsb 2
;reg3	.dsb 2
;reg4	.dsb 2
;reg5	.dsb 2
;reg6	.dsb 2
;reg7	.dsb 2

#define        via_t1cl                $0304 


.text

; Main procedure.

_main
.(

  	jsr InitSound
	lda #<osdk_stack
	sta sp
	lda #>osdk_stack
	sta sp+1

    jsr _switch_ovl ; Activate overlay ram
    jsr _init_disk
	jsr LoadOverlay

	;jsr _init_irq_routine
	jsr _init_tine
	jsr _init_print
	
restart
	jsr SndStop

	inc silence_sfx
	jsr InitMusic

	//jsr _init_screen
	jsr _init_screen2

	dec silence_sfx

	jsr _init_irq_routine 

	jsr SndStop

	; Load mission code
	jsr load_mission


	ldx #00
	stx escape_pod_launched
	stx game_over
	stx _numlasers
	stx _ecm_counter
	stx righton

	ldx #$ff
	stx player_in_control
	stx _docked
	stx _planet_dist


	jsr InitPlayerPos
	jsr InitPlayerShip

	jsr _DoubleBuffOff

	; Loop for initialization of random numbers
	ldy via_t1cl 
looprnd
	jsr _gen_rnd_number
	dey 
	bne looprnd


	lda #SCR_INFO
	sta _current_screen
	jsr _displayinfo


	jsr _TineLoop

	jsr _DoubleBuffOff
    jsr save_frame

	jsr SndStop	
	jmp restart
	;rts
.)

base0 .word $5a4a
base1 .word $0248
base2 .word $b753
galcount .byt 0


InitPlayerPos
.(
	; Update galaxy and planet based on player's position
	; Setup seed for galaxy 1
	ldx #5
loop
	lda base0,x
	sta _base0,x
	dex
	bpl loop

	; Init seed
	jsr _init_rand

	; Go to current galaxy
	ldx _galaxynum
	dex
	beq donegal
	stx galcount
	ldx #1
	stx _galaxynum
loop2
	jsr _enter_next_galaxy
	dec galcount
	bne loop2
donegal

	; And now go to current planet
	lda _currentplanet
	sta _dest_num
	jsr _infoplanet
	jsr _makesystem
	jmp _jump
	;rts
.)


#define OVERLAY_INIT 100

;Number of sectors to read Just the original tables, models, music and dictionary now 

#define NUM_SECT_OVL 34+8+11-1+4	//11+10	 
//#define NUM_SECT_OVL 34+8+11-1	//11+10	 

LoadOverlay
.(
	php
	sei
    ; Sector to read    
    lda #OVERLAY_INIT
    ldy #0
    sta (sp),y
    tya
    iny
    sta (sp),y

    ; Address of buffer
    iny
    lda #<$c000
    sta (sp),y
    lda #>$c000
    iny
    sta (sp),y

	; Load everything into overlay, except grammar that goes to page 2
    lda #NUM_SECT_OVL-1
    sta tmp
loop
    jsr _sect_read
    jsr inc_disk_params

    dec tmp
    bne loop

	; Load grammar file in page 2
	ldy #2
	lda #0
	sta (sp),y
	iny
	lda #$02
	sta (sp),y
	jsr _sect_read

	plp
	rts
.)
    
    
; Routine to increment disk reading/writting parameters
inc_disk_params
.(
    ; Increment address in 256 bytes
    ldy #3
    lda (sp),y
    clc
    adc #1
    sta (sp),y

    ; Increment sector to read
    ldy #0
    lda (sp),y
    clc
    adc #1
    sta (sp),y
//#ifdef 0
	pha
//#endif
	iny
	lda (sp),y
	adc #0
	sta (sp),y
//#ifdef 0
    ;Sedoric bug workaround 
	pla
	cmp #225 ;$f3
	bne nosedbug
	dey
	lda #226; $f4
	sta (sp),y	
	iny
nosedbug
//#endif

    rts
.)











