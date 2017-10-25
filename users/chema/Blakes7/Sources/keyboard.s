

; Example program for reading the Oric's     
; keyboard. All keys are scanned and a       
; virtual matrix of 8 bytes is updated at    
; each IRQ.                                  
;                                            
; Idea: Dbug                                 
; Main code: Twiligthe                       
; Adaptation & final implementation: Chema   
;                                            
; 2010                                        

#include "params.h"

#define        	via_portb               $0300 
#define		via_ddrb		$0302	
#define		via_ddra		$0303
#define        	via_t1cl                $0304 
#define        	via_t1ch                $0305 
#define        	via_t1ll                $0306 
#define        	via_t1lh                $0307 
#define        	via_t2ll                $0308 
#define        	via_t2lh                $0309 
#define        	via_sr                  $030A 
#define        	via_acr                 $030b 
#define        	via_pcr                 $030c 
#define        	via_ifr                 $030D 
#define        	via_ier                 $030E 
#define        	via_porta               $030f 


.zero
zpTemp01			.byt 0
zpTemp02			.byt 0
tmprow				.byt 0

;isr_plays_sound		.byt 0

.text 

;#define ROM

#ifdef ROM
#define IRQ_ADDRLO $0245
#define IRQ_ADDRHI $0246
#else
#define IRQ_ADDRLO $fffe
#define IRQ_ADDRHI $ffff
#endif


_InitISR
.(
	sei
	
	; Now this is done in the auxiliar code loaded at $2000, then discarded

	/*
	; Setup DDRA, DDRB and ACR
	lda #%11111111
	sta via_ddra
	lda #%11110111 ; PB0-2 outputs, PB3 input.
	sta via_ddrb
	lda #%1000000
	sta via_acr
	*/
	
	
	; Since this is a slow process, we set the VIA timer to 
	; issue interrupts at 50Hz, instead of 100 Hz. This is 
	; not necessary -- it depends on your needs
	;lda #<19966
	;sta via_t1ll 
	;lda #>19966
	;sta via_t1lh

	; Patch IRQ vector
	lda #<irq_routine
	ldx #>irq_routine 
	sta IRQ_ADDRLO
	stx IRQ_ADDRHI
		
	cli 
	rts 
.)


irq_routine 
.(
	pha
#ifdef SANITYVERSION	
test_via1
	bit $030D
	bpl test_via2
	lda #$7F
	sta $030D    ; cancel any VIA interrupt
test_via2
	bit $032D        ; on the Oric1/Atmos, this will test via1 again
	bpl test_acia
	lda #$7F
	sta $032D    ; cancel any VIA2 interrupt (VIA1 on the Atmos)
test_acia
	bit $031D    ; on the Oric1/Atmos, this will test via1 again !
	bpl test_fdc
	; reading the ACIA status has already cleared the interrupt, so no need to do anything
	; if it is a VIA interrupt on the Atmos, it has happened between the first via test and now,
	; so we ignore it: it will raise another interrupt that will be cleared during the second interrupt handler test_fdc
	bit $0314           ; $0314 reflects INTRQ state in negative logic
	bmi all_tests_done
test_fdc
.dsb (($0310&3)-((*+3)&3))&3,$ea
	lda $0310    ; read FDC status and clears interrupt request
_chk_310g
all_tests_done
#else
	;Clear IRQ event 
	lda via_t1cl 
#endif	
	; Signal an interrupt has been detected
	; This serves the purpose of timing and 
	; synchronizing with the vertical retrace
	inc irq_detected
	
	stx savx+1
	sty savy+1
	; If the ISR is to play sound, do it
	
	; Process keyboard
	jsr ReadKeyboard
	
#ifdef IJK_SUPPORT	
	; If joystick detected, read it
	lda $100
	beq nojoy
	jsr ReadIJK
nojoy
#endif
	
	; If game is paused nothing is to be done here
	lda InPause
	bne end
	
	; Process Music if playing
	lda MusicPlaying
	beq skip	
	jsr ProcessMusic	
skip	

	; Process input (mouse events)
	jsr ProcessUserInput
	
	; Restore regs and return
end	
savx
	ldx #0
savy
	ldy #0
	pla
	rti 
.)

ReadKeyboard
.(
	sei
	;Write Column Register Number to PortA 
	lda #$0E 
	sta via_porta 
	;Tell AY this is Register Number 
	lda #$FF 
	sta via_pcr 
	; Clear CB2, as keeping it high hangs on some orics.
	; Pity, as all this code could be run only once, otherwise
	ldy #$dd 
	sty via_pcr 

	ldx #7 
loop2   ;Clear relevant bank 
	lda #00 
	sta _KeyBank,x 
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
	lda #8 
	;Sense Row activity 
	and via_portb 
	beq skip2 
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
	;Use delay(10 cycles) for setting up bit in _KeyBank and loading Bit 
	tya
	ora _KeyBank,x 
	sta zpTemp01 
	lda #8 
	;Sense key activity 
	and via_portb 
	beq skip1 
	;Store key 
	lda zpTemp01 
	sta _KeyBank,x 
skip1   ;Proceed to next column 
	tya 
	lsr 
	tay 
	bcc loop1 
skip2   ;Proceed to next row 
	dex 
	bpl loop2 
	cli
	rts 
.)  


; Some more routines, not actualy needed, but quite useful
; for reading a single key (get the first active bit in 
; the virtual matrix) and returning his ASCII value.
; Should serve as an example about how to handle the keymap.

; Reads a key (single press, but repeating) and returns his ASCII value in reg X. 
; Z=1 if no keypress detected.
KeyBankUsed 	.byt 0
KeyBitflag	.byt 0

ReadKey
.(
	ldx #7
loop
	lda _KeyBank,x
	beq skip

	stx KeyBankUsed
	sta KeyBitflag
	
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
	tax
	rts
skip
	dex
	bpl loop

	ldx #0
	rts
.)

; Read a single key, same as before but no repeating.

oldKey 		.byt 0
ReadKeyNoBounce
.(
	jsr ReadKey
	cpx oldKey
	beq retz
	stx oldKey
	cpx #0
	beq retz
	rts
retz
	ldx #0
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;
; Wait for a keypress
;;;;;;;;;;;;;;;;;;;;;;
WaitKey
.(
	;lda #0
	;sta oldKey
loop
	jsr WaitIRQ
	jsr ReadKeyNoBounce
	beq loop
	rts	
.)


#ifdef IJK_SUPPORT	

;;;;;;;;;;;;;;;;;;;;;;;;;
; IJK Joystick routines
;;;;;;;;;;;;;;;;;;;;;;;;;

joy_Left 	.byt 0
;joy_Right 	.byt 0

GenericIJKBits = $bfe0 
;      .byt 0,2,1,3,32,34,33,0,8,10,9,0,40,42,41,0
;      .byt 16,18,17,0,48,50,49,0,0,0,0,0,0,0,0,0

ReadIJK
         ;Ensure Printer Strobe is set to Output
         LDA #%10110111
         STA via_ddrb
         ;Set Strobe Low
         LDA #%00000000
         STA via_portb
         ;Set Top two bits of PortA to Output and rest as Input
         LDA #%11000000
         STA via_ddra
         ;Select Left Joystick
         LDA #%01111111
         STA via_porta
         ;Read back Left Joystick state
         LDA via_porta
         ;Mask out unused bits
         AND #%00011111
         ;Invert Bits
         EOR #%00011111
         ;Index table to conform to Generic Format
         ;TAX
         ;LDA GenericIJKBits,X
         STA joy_Left
/*	 
         ;Select Right Joystick
         LDA #%10111111
         STA via_porta
         ;Read back Right Joystick state and rejig bits
         LDA via_porta
         AND #%00011111
         EOR #%00011111
         TAX
         LDA GenericIJKBits,X
         STA joy_Right
*/	 
         ;Restore VIA PortA state
         LDA #%11111111
         STA via_ddra
         RTS       
#endif
	 