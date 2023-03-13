

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

_VblCounter					.dsb 1
;irq_save_a				.dsb 1
;irq_save_x				.dsb 1
;irq_save_y				.dsb 1

	.text 


oldKey 			.byt 0
irq_detected	.byt 0 	; Signal if an interrupt occured


_KeyBank .dsb 8   ; The virtual Key Matrix


; Usually it is a good idea to keep 0 all the unused
; entries, as it speeds up things. Z=1 means no key
; pressed and there is no need to look in tables later on. 
tab_ascii
    .asc "7","N","5","V",KET_RCTRL,"1","X","3"
    .asc "J","T","R","F",0,KEY_ESC,"Q","D"
    .asc "M","6","B","4",KEY_LCTRL,"Z","2","C"
    .asc "K","9",38,"-",0,0,42,39
    .asc " ",",",".",KEY_UP,KEY_LSHIFT,KEY_LEFT,KEY_DOWN,KEY_RIGHT
    .asc "U","I","O","P",KEY_FUNCT,KEY_DEL,")","("
    .asc "Y","H","G","E",0,"A","S","W"
    .asc "8","L","0","/",KEY_RSHIFT,KEY_RETURN,0,"+"


_System_InstallIRQ_SimpleVbl
	//jmp _System_InstallIRQ_SimpleVbl
.(
	sei

	lda $306
	sta VIA_Restore_Low+1
	lda $307
	sta VIA_Restore_High+1

	lda $FFFE
	sta IRQ_Restore_Low+1
	lda $FFFF
	sta IRQ_Restore_High+1

	;  Set the VIA parameters to get a 50hz IRQ
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



_System_RestoreIRQ_SimpleVbl
	//jmp _System_RestoreIRQ_SimpleVbl
.(
	sei

	;  Restore the VIA
+VIA_Restore_Low	
	lda #$12
	sta $306
+VIA_Restore_High
	lda #$12
	sta $307
	
	; Restore the IRQ handler
+IRQ_Restore_Low	
	lda #$12
	sta $FFFE
+IRQ_Restore_High
	lda #$23
	sta $FFFF

	cli
	rts	
.)



_50Hz_InterruptHandler 
.(
	bit $304
	inc _VblCounter

	pha
	txa
	pha
	tya
	pha

	; Just to show the IRQ is running... blinks a cursor at 50hz at the bottom right of the screen
	//lda $bfdf
	//eor #128
	//sta $bfdf

	; Signal an interrupt has been detected
	; This serves the purpose of timing and 
	; synchronizing with the vertical retrace
	inc irq_detected
	
	; Process keyboard
	jsr ReadKeyboard
			
  dec Milliseconds
  bne skip_count_down

  lda #50
  sta Milliseconds

  jsr CountSecondDown

skip_count_down  

	; Restore regs and return
	pla
	tay
	pla
	tax
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

ReadKey
.(
	ldx #7
loop
	lda _KeyBank,x
	and #%11101111    ; The column 4 of the matrix contains all the CTRL, SHIFT and FUNC keys
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
	lda tab_ascii,x  ; Get the code associated to the key

	tax
	rts

skip
	dex
	bpl loop

	ldx #0
	rts
.)


; Read a single key, same as before but no repeating.

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
_WaitKey
.(
	;lda #0
	;sta oldKey
loop
	jsr WaitIRQ
	jsr ReadKeyNoBounce
	beq loop
	rts	
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Waits for a signaled IRQ
; event to occur
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WaitIRQ
.(
	lda #0
	sta irq_detected
loop
	lda irq_detected
	beq loop
	rts
.)
