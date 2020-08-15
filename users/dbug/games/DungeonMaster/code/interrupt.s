;
; Basic IRQ handler
;

//#include "params.h"

/*
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
*/

	.zero

_VblCounter					.dsb 1
;irq_save_a				.dsb 1
;irq_save_x				.dsb 1
;irq_save_y				.dsb 1

	.text 

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

	; Small animation at the bottom right to show that the IRQ is alive
	lda $bfdf
	eor #128
	;sta $bfdf

	; Process sound
	jsr ProcessSound
	
	; Process keyboard
	jsr ReadKeyboard
			
	; Restore regs and return
	pla
	tay
	pla
	tax
	pla
	rti 
.)


_WaitVbl
.(
	lda _VblCounter
loop
	cmp _VblCounter
	beq loop
	rts
.)



_Breakpoint
	jmp _Breakpoint
_DoNothing
	rts