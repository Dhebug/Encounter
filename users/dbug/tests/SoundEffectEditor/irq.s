
#include "params.h"

    .zero

_IrqCounter					.dsb 1
_VblCounter					.dsb 1

    .text

; 1 second       = 1000 ms
; 1 frame @50hz  = 20ms
; 1 frame @100hz = 10ms

; 19966 = 50hz  = 1 irq per frame
; 10000 = 100hz = 2 irq per frame  (0x2710 is the original ROM value)
;  5000 = 200hz = 4 irq per frame
;  2500 = 400hz = 8 irq per frame

_IrqSpeedMask 	.byt 1

_Sei
  sei
  rts
  
_Cli
  cli
  rts


_System_InstallIRQ_SimpleVbl
.(
	sei

	;  Set the VIA parameters in $306-$307 to get a 50hz IRQ
	lda $306
	sta VIA_Restore_Low+1
	lda $307
	sta VIA_Restore_High+1

	jsr _Set50hzIrq

	; Install the IRQ handler in $245-246
	lda $245
	sta IRQ_Restore_Low+1
	lda $246
	sta IRQ_Restore_High+1

	lda #<InterruptHandler
	sta $245
	lda #>InterruptHandler
	sta $246

	lda #0
	sta _VblCounter

	cli
	rts	
.)


_Set50hzIrq
	lda #1
	ldx #<19966/1
	ldy #>19966/1
	jmp _SetIrqSpeed

_Set100hzIrq
	lda #2
	ldx #<19966/2
	ldy #>19966/2
	jmp _SetIrqSpeed

_Set200hzIrq
	lda #4
	ldx #<19966/4
	ldy #>19966/4
	jmp _SetIrqSpeed

_Set400hzIrq
	lda #8
	ldx #<19966/8
	ldy #>19966/8
	jmp _SetIrqSpeed

_SetIrqSpeed
.(
	php
	sei
	sta _IrqSpeedMask
	sta _IrqCounter
	stx $306
	sty $307
	plp
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
	sta $245
+IRQ_Restore_High
	lda #$12
	sta $246

	cli
	rts	
.)



InterruptHandler 
.(
	bit $304

	pha
	txa
	pha
	tya
	pha

	; Call the Frequent IRQ handler
	jsr IrqTasksHighSpeed

	dec _IrqCounter
	bne skip_50hz_task

	lda _IrqSpeedMask
	sta _IrqCounter

	; Call the 50hz IRQ handler
	inc _VblCounter
    jsr IrqTasks50hz

skip_50hz_task
	
	; Restore regs and return
	pla
	tay
	pla
	tax
	pla 
	rti 
.)



; Waits for the next IRQ
_VSync
_WaitIRQ
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

; Stop the program while blinking the bottom right corner with psychedelic colors
_Panic
	lda #16+1
	sta $BFDF
	lda #16+2
	sta $BFDF
	jmp _Panic
	rts


_Temporize
	ldy #1
temporize_outer
	ldx #0
temporize_inner
	dex
	bne temporize_inner

	dey
	bne temporize_outer

	rts
