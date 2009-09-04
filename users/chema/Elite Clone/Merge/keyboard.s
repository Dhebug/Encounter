
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Twilighte's IRQ routine!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; key read and timer irq 
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
*=$ec
irq_A               .byt 0
irq_X               .byt 0
irq_Y               .byt 0
TimerCounter        .byt 40        ;Slows key read to 25Hz 
zpTemp01			.byt 0
zpTemp02			.byt 0
tmprow				.byt 0
counter				.byt 0
.text 

sav_old_rout .word $0000

_init_irq_routine 
.(
        ;Since we are starting from when the standard irq has already been 
        ;setup, we need not worry about ensuring one irq event and/or right 
        ;timer period, only redirecting irq vector to our own irq handler. 
        sei
        lda $0245
        sta sav_old_rout
        lda $0246
        sta sav_old_rout+1
        lda #<irq_routine 
        sta $0245        ;When we disable rom, we should change this to $fffe 
        lda #>irq_routine 
        sta $0246        ;When we disable rom, we should change this to $ffff 

        ;Turn off music and sfx
    	;lda #128
    	;sta MusicStatus
    	;sta EffectNumber
    	;sta EffectNumber+1
    	;sta EffectNumber+2
        cli 
        rts 
.)


_disable_irq_routine
.(
    sei
    lda sav_old_rout
    sta $0245
    lda sav_old_rout+1
    sta $0246
    cli
    rts

.)


;The IRQ routine will run (Like Oric) at 100Hz. 
irq_routine 
.(
		dec counter

        ;Preserve registers 
      	sta irq_A
    	stx irq_X
    	sty irq_Y

        ;Protect against Decimal mode 
        cld 

        ;Clear IRQ event 
        lda via_t1cl 

    	;Process Music
    	;jsr ProcMusic
    	;Process Effects
    	;jsr ProcEffect

        ;Process timer event 
        dec TimerCounter 
        lda TimerCounter 
        and #7        ;Essentially, every 4th irq, call key read 
        bne skip1 
        ;Process keyboard 
        jsr ReadKeyboard 

skip1        
        ;Process controller (Joysticks) 
;        jsr proc_controller 


        ;Send Sound Bank 
;        jsr send_ay 

        ;Restore Registers 
        lda irq_A
    	ldx irq_X
    	ldy irq_Y

        ;End of IRQ 
        rti 
.)



tab_ascii
    .asc "7","N","5","V",0,"1","X","3"
    .asc "J","T","R","F",0,0,"Q","D"
    .asc "M","6","B","4",0,"Z","2","C"
    .asc "K","9",0,0,0,0,0,0
    .asc " ",0,0,0,0,0,0,0
    .asc "U","I","O","P",0,$7f,0,0
    .asc "Y","H","G","E",0,"A","S","W"
    .asc "8","L","0",0,0,$0d,0,0



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
	sta oldKey
	rts
retz
	lda #0
	rts
.)

;ChemaRead.s 


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


ReadKeyboard
.(
        ;Write Column Register Number to PortA 
        lda #$0E 
        sta via_porta 

        ;Tell AY this is Register Number 
        lda #$FF 
        sta via_pcr 

        ;Setup PB read pulsing CB2 
        ;ldy #%10111100 
        ;sty via_pcr 

        ;sta via_pcr 
        ldy #$dd 
        sty via_pcr 


        ldx #7 

loop2   ;Clear relevant bank 
        lda #00 
        sta KeyBank,x 

        ;Write 0 to Column Register 

		jsr SenseKeyPrep
        
		;Send Column and write Row 
        ;stx via_portb 

        ;Wait 10 cycles for curcuit to settle on new row 
        ;Use time to load inner loop counter and load Bit 
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
		jsr SenseKeyPrep

        ;stx via_portb 

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

        ;Disable Pulse mode in PCR 
        ;lda #$DD 
        ;sta via_pcr

        rts 
.)  

KeyBank .dsb 8





