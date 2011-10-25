;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; IRQ and keyboard routines
;; --------------------------

#include "params.h"

; key read and timer irq 
#define        via_portb               $0300 
#define		   via_ddrb				   $0302	
#define		   via_ddra				   $0303
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

#define			ayc_Register			$FF
#define			ayc_Write				$FD
#define			ayc_Read				$FE
#define			ayc_Inactive			$DD


.zero

zpTemp01			.byt 0
zpTemp02			.byt 0
tmprow				.byt 0
counter				.byt 0
oldKey				.byt 0

; For music and sfx
ay_Pitch_A_High		.byt 0
ay_Pitch_A_Low		.byt 0
Song				.word 0000
Song2				.word 0000
TimerCounter		.byt 00
NoteCounter			.byt 00
Sfx					.byt 00
audio_off			.byt 00


.text 

#define ROM
#ifdef ROM
#define IRQ_ADDRLO $0245
#define IRQ_ADDRHI $0246
#else
#define IRQ_ADDRLO $fffe
#define IRQ_ADDRHI $ffff
#endif

#define KB_SENSE_ALL_FIRST

_init_irq_routine 
.(
        ;Since we are starting from when the standard irq has already been 
        ;setup, we need not worry about ensuring one irq event and/or right 
        ;timer period, only redirecting irq vector to our own irq handler. 
        sei
	
/*
		; Setup DDRA, DDRB and ACR
        lda #%11111111
        sta via_ddra
		lda #%11110111 ; PB0-2 outputs, PB3 input.
		sta via_ddrb
		lda #%1000000
		sta via_acr
*/

#ifdef ROM
		; To be Oric-1 compatible, get the
		; page 2 vector
		lda $fffe
		sta tmp
		lda $ffff
		sta tmp+1
		ldy #1
        lda #<irq_routine 
		sta (tmp),y
		iny
        lda #>irq_routine 
		sta (tmp),y
#else
        lda #<irq_routine 
        sta $fffe
        lda #>irq_routine 
        sta $ffff
#endif

		lda #<9984*2
		sta via_t1ll 
		lda #>9984*2
		sta via_t1lh 
  
        cli 
        rts 
.)

#ifdef BRK2SETTMP0
set_tmp0
.(
	; Get data using the stored
	; ret addr in stack
	tsx
	lda $103,x
	sta zpTemp01+1
	lda $102,x
	sta zpTemp01
	bne skip2
	dec zpTemp01+1
skip2
	dec zpTemp01

	ldy #0
	lda (zpTemp01),y
	sta tmp0
	iny
	lda (zpTemp01),y
	sta tmp0+1

	; Increment the return address to
	; jump over the two byte data
	; (the address was already +1).
	inc $102,x
	bne skip
	inc $103,x
skip

	; Restore registers
	; and return 
	bne ret_isr	; this always jumps
.)
#endif


;The IRQ routine will run at 25Hz or 50Hz...
irq_routine 
.(
        ;Preserve registers 
      	sta sav_A+1
    	stx sav_X+1
    	sty sav_Y+1

#ifdef BRK2SETTMP0
		; Check if it was a brk which caused this interrupt
		pla
		pha
		and #%00010000
		bne set_tmp0
#endif
        ;Clear IRQ event 
        lda via_t1cl 

  		; Genaral purpose counter
		inc counter

        ;Process keyboard 
        jsr ReadKeyboard 

		lda audio_off
		bne Audioisoff

		; Process music, if present
		lda Song+1
		bne ProcessMusic

		; Process sfx if present
		lda Sfx
		bne ProcessSfx


+ret_isr
        ;Restore Registers 
sav_A   lda #00
sav_X 	ldx #00
sav_Y  	ldy #00

        ;End of IRQ 
        rti 
.)

Audioisoff
	lda #0
	sta Song+1
	sta Sfx
	beq ret_isr

ProcessSfx
.(
	ldy Sfx
	lda tab_sfx_hi-1,y
	ldx tab_sfx_lo-1,y
	tay
	jsr AYRegDump
	lda #0
	sta Sfx
	jmp ret_isr
.)

ProcessMusic
.(
	inc TimerCounter
	lda TimerCounter
	and #%111
	bne ret_isr

	ldy NoteCounter
	lda (Song),y
	bmi endplay
	beq restA
	jsr Note2Pitch
	lda ay_Pitch_A_Low
	ldx #0
	jsr SendAYReg
	lda ay_Pitch_A_High
	ldx #1
	jsr SendAYReg
restA
	ldy NoteCounter
	lda (Song2),y
	beq restB
	jsr Note2Pitch
	lda ay_Pitch_A_Low
	ldx #2
	jsr SendAYReg
	lda ay_Pitch_A_High
	ldx #3
	jsr SendAYReg
restB	

	lda NoteCounter
	beq SetVolume
+contm
	inc NoteCounter

retme
	jmp ret_isr

endplay
	jsr StopSound

	lda #0
	sta Song+1
	beq retme
.)

SetVolume
.(
	; Set volume
	lda #$f
	ldx #8
	jsr SendAYReg
	lda #$f
	ldx #9
	jsr SendAYReg
	jmp contm
.)

ReadKey
.(
	ldx #7
loop
	lda KeyBank,x
	bne getbit
contsearch
	dex
	bpl loop
	
	lda #0
	rts

getbit
	ldy #$ff
loop2
	iny
	lsr
	bcc loop2
	txa
	asl
	asl
	asl
	sty tmprow
	; Carry should be clear here
	;clc
	adc tmprow
	tay
	lda tab_ascii,y
	beq contsearch
	rts
.)


ReadKeyNoBounce
.(
	jsr ReadKey
	cmp oldKey
	beq retz
	sta oldKey
	tax	 ; Set Z flag correctly Z=0
	rts
retz
	lda #0
	rts
.)


ReadKeyboard
.(
        ;Write Column Register Number to PortA 
        lda #$0E 
        sta via_porta 

        ;Tell AY this is Register Number 
        lda #$FF 
        sta via_pcr 

		; Clear CB2, as keeping it high hangs on some orics.
		; Pitty, as all this code could be run only once, otherwise
        ldy #$dd 
        sty via_pcr 

        ldx #7 

loop2   ;Clear relevant bank 
        lda #00 
        sta KeyBank,x 

#ifdef KB_SENSE_ALL_FIRST
        ;Write 0 to Column Register 

		sta via_porta 
	    lda #$fd 
	    sta via_pcr 
        lda #$dd
        sta via_pcr

        lda via_portb 
        and #%11111000
        stx zpTemp02
        ora zpTemp02 
        sta via_portb 

        
        ;Wait 10 cycles for circuit to settle on new row 
        ;Use time to load inner loop counter and load Bit 

		; CHEMA: Fabrice Broche uses 4 cycles (lda #8:inx) plus
		; the four cycles of the and absolute. That is 8 cycles.
		; So I guess that I could do the same here (ldy,lda)

        ldy #$80
#ifdef KB_EXTRA_NOPS
		nop 
        nop 
#endif
        lda #8 

        ;Sense Row activity 
        and via_portb 
        beq skip2 
#else
		ldy #$80
#endif
		;Store Column 
        tya 
loop1   
        eor #$FF 

		sta via_porta 
	    lda #$fd 
	    sta via_pcr 
        lda #$dd
        sta via_pcr

        lda via_portb 
        and #%11111000
        stx zpTemp02
        ora zpTemp02 
        sta via_portb 


        ;Use delay(10 cycles) for setting up bit in Keybank and loading Bit 
        tya 
        ora KeyBank,x 
        sta zpTemp01 
        lda #8 

        ;Sense key activity 
        and via_portb 
        beq skip1 

        ;Store key 
        lda zpTemp01 
        sta KeyBank,x 

skip1   ;Proceed to next column 
        tya 
        lsr 
        tay 
        bcc loop1 

skip2   ;Proceed to next row 
        dex 
        bpl loop2 

        rts 
.)  


#define NUM_KEYS 11

process_user_input
.(
	jsr ReadKeyNoBounce
	beq end       	
		
	; Ok a key was pressed, let's check
    ldx #NUM_KEYS-1
loop    
    cmp user_keys,x
    beq found
    dex
    bpl loop
end
	rts

found

    lda key_routl,x
    sta _smc_routine+1
    lda key_routh,x
    sta _smc_routine+2   

	; Some keys shall be read with repetitions
	cpx #4
	bcs call
	ldx #0
	stx oldKey

call
	ldx #0
_smc_routine
	; Call the routine
    jmp $1234   ; SMC     

.)




