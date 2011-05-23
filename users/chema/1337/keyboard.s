
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Twilighte's IRQ routine!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

#define ayc_Register $FF
#define ayc_Write    $FD
#define ayc_Read	 $FE
#define ayc_Inactive $DD


.zero
;irq_A               .byt 0
;irq_X               .byt 0
;irq_Y               .byt 0
TimerCounter        .byt 40        ;Used in music
zpTemp01			.byt 0
zpTemp02			.byt 0
tmprow				.byt 0
counter				.byt 0

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

		; Setup DDRA, DDRB and ACR
        lda #%11111111
        sta via_ddra
		lda #%11110111 ; PB0-2 outputs, PB3 input.
		sta via_ddrb
		lda #%1000000
		sta via_acr

        lda #<irq_routine 
        sta IRQ_ADDRLO
        lda #>irq_routine 
        sta IRQ_ADDRHI

		lda #<9984*2
		sta via_t1ll 
		lda #>9984*2
		sta via_t1lh 
  
        cli 
        rts 
.)


;The IRQ routine will run at 25Hz
irq_routine 
.(
		; Genaral purpose counter (counting fps)
		inc counter

        ;Preserve registers 
      	sta sav_A+1
    	stx sav_X+1
    	sty sav_Y+1

        ;Clear IRQ event 
        lda via_t1cl 

        ;Process keyboard 
        jsr ReadKeyboard 

        ;Restore Registers 
sav_A   lda #00
sav_X 	ldx #00
sav_Y  	ldy #00

        ;End of IRQ 
        rti 
.)


/* Usually it is a good idea to keep 0 all the entries
   possible, as it speeds up things. Z=1 means no key
   pressed and there is no need to look in tables */

#define KEY_UP			1
#define KEY_LEFT		2
#define KEY_DOWN		3
#define KEY_RIGHT		4

#define KEY_LCTRL		0
#define KET_RCTRL		0
#define KEY_LSHIFT		0
#define KEY_RSHIFT		0
#define KEY_FUNCT		0

#define KEY_RETURN		$0d
#define KEY_ESC			$1b
#define KEY_DEL			$7f

//#define COMPLETE_ASCII_TABLE

tab_ascii
#ifdef COMPLETE_ASCII_TABLE
    .asc "7","N","5","V",KET_RCTRL,"1","X","3"
    .asc "J","T","R","F",0,KEY_ESC,"Q","D"
    .asc "M","6","B","4",KEY_LCTRL,"Z","2","C"
    .asc "K","9",59,"-",0,0,92,39
    .asc " ",",",".",KEY_UP,KEY_LSHIFT,KEY_LEFT,KEY_DOWN,KEY_RIGHT
    .asc "U","I","O","P",KEY_FUNCT,KEY_DEL,"]","["
    .asc "Y","H","G","E",0,"A","S","W"
    .asc "8","L","0","/",KEY_RSHIFT,KEY_RETURN,0,"="
#else
    .asc "7","N","5","V",0,"1","X","3"
    .asc "J","T","R","F",0,0,"Q","D"
    .asc "M","6","B","4",0,"Z","2","C"
	.asc "K","9",0,0,0,0,0,0
    .asc " ",0,0,KEY_UP,0,KEY_LEFT,KEY_DOWN,KEY_RIGHT
    .asc "U","I","O","P",0,KEY_DEL,0,0
    .asc "Y","H","G","E",0,"A","S","W"
    .asc "8","L","0",0,0,KEY_RETURN,0,0
#endif


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


oldKey .byt 0
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

KeyBank .dsb 8





