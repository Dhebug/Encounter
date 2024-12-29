
#include "params.h"

    .zero

_IrqCounter					.dsb 1    ; Decremented at 200hz and when reaching zero triggers the 50hz callback
_VblCounter					.dsb 1    ; Incremented every 1/50 th of a second

    .text

; 1 second       = 1000 ms
; 1 frame @50hz  = 20ms
; 1 frame @100hz = 10ms

; 19966 = 50hz  = 1 irq per frame
; 10000 = 100hz = 2 irq per frame  (0x2710 is the original ROM value)
;  5000 = 200hz = 4 irq per frame
;  2500 = 400hz = 8 irq per frame

_System_InstallIRQ_SimpleVbl
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

    ;  Set the VIA parameters to get a 200hz IRQ
    lda #<19966/4		; 4991
    sta $306
    lda #>19966/4		; 4991
    sta $307

    ; Install interrupt (this works only if overlay ram is accessible)
    lda #<InterruptHandler
    sta $FFFE
    lda #>InterruptHandler
    sta $FFFF

    lda #4
    sta _IrqCounter
    
    lda #0
    sta _VblCounter

    cli
    rts	
.)



_System_RestoreIRQ_SimpleVbl
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

    lda #4
    sta _IrqCounter

    ; Call the 50hz IRQ handler
    inc _VblCounter
    jsr IrqTasks50hz

    ; Call the loader "RGB flash" disk access indicator
    jsr _LoaderApiLoadingAnimation

skip_50hz_task
	
    ; Restore regs and return
    pla
    tay
    pla
    tax
    pla 
    rti 
.)



; param0+0/param0+1=number of frames to wait
_WaitFramesAsm
.(
    ; Do we have a zero number of frames???
    lda _param0+0
    bne loop
    lda _param0+1
    bne loop
    rts

loop
    jsr _WaitIRQ    ; Uses A register
    dec _param0+0
    bne loop
    dec _param0+1
    bpl loop
    rts
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


; Stop the program while blinking the bottom right corner with psychedelic colors
_Panic
	lda #16+1
	sta $BFDF
	lda #16+2
	sta $BFDF
	jmp _Panic
_DoNothing    
	rts

