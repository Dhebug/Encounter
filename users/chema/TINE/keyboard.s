
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


.zero
irq_A               .byt 0
irq_X               .byt 0
irq_Y               .byt 0
TimerCounter        .byt 40        ;Used in music
zpTemp01			.byt 0
zpTemp02			.byt 0
tmprow				.byt 0
counter				.byt 0

.text 

#ifdef ROM
#define IRQ_ADDRLO $0245
#define IRQ_ADDRHI $0246
#else
#define IRQ_ADDRLO $fffe
#define IRQ_ADDRHI $ffff
#endif


_init_irq_routine 
.(
        ;Since we are starting from when the standard irq has already been 
        ;setup, we need not worry about ensuring one irq event and/or right 
        ;timer period, only redirecting irq vector to our own irq handler. 
        sei
		lda #<9984*4
		sta via_t1ll 
		lda #>9984*4
		sta via_t1lh 
        lda #<irq_routine 
        sta IRQ_ADDRLO
        lda #>irq_routine 
        sta IRQ_ADDRHI
        cli 
        rts 
.)


;The IRQ routine will run at 25Hz
irq_routine 
.(
		; Genaral purpose counter (counting fps)
		inc counter

        ;Preserve registers 
      	sta irq_A
    	stx irq_X
    	sty irq_Y

        ;Clear IRQ event 
        lda via_t1cl 

        ;Process keyboard 
        jsr ReadKeyboard 

        ;Restore Registers 
        lda irq_A
    	ldx irq_X
    	ldy irq_Y

        ;End of IRQ 
        rti 
.)


/* Usually it is a good idea to keep 0 all the entries
   possible, as it speeds up things. Z=1 means no key
   pressed and there is no need to look in tables */

#define ARROW_UP	1
#define ARROW_LEFT	2
#define ARROW_DOWN	3
#define ARROW_RIGHT 4

#define LCTRL		0
#define LSHIFT		0
#define RSHIFT		0
#define FUNCT		0

#define KEY_RETURN		$0d
#define KEY_ESC			$1b
#define KEY_DEL			$7f

tab_ascii
    .asc "7","N","5","V",0,"1","X","3"
    .asc "J","T","R","F",0,KEY_ESC,"Q","D"
    .asc "M","6","B","4",LCTRL,"Z","2","C"
    .asc "K","9",0,0,0,0,0,0
    .asc " ",0,0,ARROW_UP,LSHIFT,ARROW_LEFT,ARROW_DOWN,ARROW_RIGHT
    .asc "U","I","O","P",FUNCT,KEY_DEL,0,0
    .asc "Y","H","G","E",0,"A","S","W"
    .asc "8","L","0",0,0,KEY_RETURN,0,0



ReadKey
.(
	ldx #7
loop
	lda KeyBank,x
	beq skip

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
	clc
	adc tmprow
	tax
	lda tab_ascii,x
	;pha
	;jsr ClearBank
	;pla
	rts
skip
	dex
	bpl loop

	lda #0
	rts
.)


oldKey .byt 0
ReadKeyNoBounce
.(
	jsr ReadKey
	cmp oldKey
	beq retz
	tax
	sta oldKey
	rts
retz
	lda #0
	rts
.)

;ChemaRead.s 

/*
SenseKeyPrep
.(
       sta via_porta 
	   lda #$fd 
	   sta via_pcr 
       sty via_pcr 

       lda via_portb 
       and #%11111000
       stx zpTemp02
       ora zpTemp02 
       sta via_portb 

	   rts
.)
*/

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

        ;Write 0 to Column Register 

		;jsr SenseKeyPrep
		sta via_porta 
	    lda #$fd 
	    sta via_pcr 
        sty via_pcr 

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
		nop 
        nop 
        nop 
        lda #8 

        ;Sense Row activity 
        and via_portb 
        beq skip2 

loop1   ;Store Column 
        tya 
        eor #$FF 

		;jsr SenseKeyPrep
		sta via_porta 
	    lda #$fd 
	    sta via_pcr 
        sty via_pcr 

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





