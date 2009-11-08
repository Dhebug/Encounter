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


.text

; Main procedure.

_main
.(

  	jsr SndPing


	lda #<osdk_stack
	sta sp
	lda #>osdk_stack
	sta sp+1

    jsr _switch_ovl ; Activate overlay ram
    jsr _init_disk
	jsr LoadOverlay

	jsr _init_irq_routine 
	jsr _init_tine
	jsr _init_print
	
restart
	jsr _init_screen
	jsr _init_screen2

	ldx #$ff
	stx player_in_control
	stx _docked
	stx _planet_dist

	; Update galaxy and planet

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
	jsr _jump
	jsr InitPlayerShip

	jsr _DoubleBuffOff


	lda #SCR_INFO
	sta _current_screen
	jsr _displayinfo


	jsr _TineLoop

	jsr _DoubleBuffOff
    jsr save_frame

	jmp restart
	;rts
.)

base0 .word $5a4a
base1 .word $0248
base2 .word $b753
galcount .byt 0


#define OVERLAY_INIT 100

;Number of sectors to read: Just the original tables and the models now 

#define NUM_SECT_OVL 15+4+17	 

LoadOverlay
.(
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

    lda #NUM_SECT_OVL
    sta tmp
loop
    jsr _sect_read
    jsr inc_disk_params

    dec tmp
    bne loop
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
    iny
    lda (sp),y
    adc #0
    sta (sp),y

    rts

.)











