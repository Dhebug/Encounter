
#include "params.h"

    .zero

_VblCounter					.dsb 1

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

    jsr IrqTasks
	
	; Restore regs and return
	pla
	tay
	pla
	tax
	pla 
	rti 
.)



; Waits for the next IRQ
_WaitIRQ
.(
	lda _VblCounter
loop
	cmp _VblCounter
	beq loop
	rts
.)

