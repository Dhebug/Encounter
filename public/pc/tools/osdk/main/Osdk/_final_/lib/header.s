


	.zero

	*= $50

;
; Most of the documentation/comments in this file are from 'Another Approach to Instruction Set Architecture—VAX'
;
ap		.dsb 2		; Argument pointer - points to the base of the list of arguments or parameters in memory that are passed to the procedure
fp		.dsb 2		; Frame pointer - points to the base of the local variables of the procedure that are kept in memory (the stack frame)
sp		.dsb 2		; Stack pointer - points to the top of the stack

tmp0	.dsb 2
tmp1	.dsb 2
tmp2	.dsb 2
tmp3	.dsb 2
tmp4	.dsb 2
tmp5	.dsb 2
tmp6	.dsb 2
tmp7	.dsb 2

op1		.dsb 2
op2		.dsb 2

tmp		.dsb 2

reg0	.dsb 2
reg1	.dsb 2
reg2	.dsb 2
reg3	.dsb 2
reg4	.dsb 2
reg5	.dsb 2
reg6	.dsb 2
reg7	.dsb 2


	.text

osdk_start
    ;jmp osdk_start		; Comment out to not autostart the system

	;#include "adress.tmp"
	;*=$800

	;
	; Needs to clear the BSS section
	;




	tsx
	lda #<osdk_stack
	sta sp
	lda #>osdk_stack
	sta sp+1
	ldy #0
	stx retstack
	jmp _main
retstack	
	.byt 0

/*
Preserving Registers Across Procedure Invocation of
swap
The VAX has a pair of instructions that preserve registers calls and ret. This
example shows how they work.
The VAX C compiler uses a form of callee convention. Examining the code
above, we see that the values in registers r0, r1, r2, and r3 must be saved so
that they can later be restored. The calls instruction expects a 16-bit mask at
the beginning of the procedure to determine which registers are saved: if bit i
is set in the mask, then register i is saved on the stack by the calls instruction.
In addition, calls saves this mask on the stack to allow the return instruction
(ret) to restore the proper registers. Thus the calls executed by the caller
does the saving, but the callee sets the call mask to indicate what should be
saved.
One of the operands for calls gives the number of parameters being
passed, so that calls can adjust the pointers associated with the stack: the argument
pointer (ap), frame pointer (fp), and stack pointer (sp). Of course,
calls also saves the program counter so that the procedure can return!
Thus, to preserve these four registers for swap, we just add the mask at the
beginning of the procedure, letting the calls instruction in the caller do all the
work:
.word ^m<r0,r1,r2,r3>; set bits in mask for 0,1,2,3
This directive tells the assembler to place a 16-bit constant with the proper bits
set to save registers r0 though r3.
*/	
	
	
; Code is called this way:
;
;	ldx #6    <- ?
;	lda #1    <- Sometimes "4" or "5" <- Number of registers to save?
;	jsr enter 
;
; Y=The routine that calls a subfunction puts in Y the number of parameters*2 in Y. Example is CALLV_C(_drawbox,6)
; X=
; A=Number of registers to save (registers being adresses from 'reg0' to 'reg7'
enter
	sty tmp		; Save the number of bytes reserved for parameters
	stx tmp+1
	
	; Save the registers
	asl			; Number of registers to save x2
	sta op2		; =number of bytes to save
	tax
	beq noregstosave
savereg	
    lda reg0-1,x
	sta (sp),y
	iny
	dex
	bne savereg
	
noregstosave
	sty op2+1	; New stack offset after the registers have been saved
	
	; Save the argument pointer
	lda ap
	sta (sp),y
	iny
	lda ap+1
	sta (sp),y
	iny
	
	; Save the frame pointer
	lda fp
	sta (sp),y
	iny
	lda fp+1
	sta (sp),y
	iny
	
	; Save the number of bytes saved for the registers
	lda op2
	sta (sp),y
	iny
	lda tmp		; Previously saved number of bytes for parameters
	sta (sp),y
	
	; Update the argument pointer
	; AP=SP
	; FP=SP+stack offset
	clc
	lda sp
	sta ap
	adc op2+1
	sta fp	
	lda sp+1
	sta ap+1
	adc #0
	sta fp+1
	
	; SP=FP+X
	lda tmp+1
	adc fp
	sta sp
	lda fp+1
	adc #0
	sta sp+1
	rts

	
/*	
The return instruction undoes the work of calls. When finished, ret sets
the stack pointer from the current frame pointer to pop everything calls
placed on the stack. Along the way, it restores the register values saved by
calls, including those marked by the mask and old values of the fp, ap, and
pc.
To complete the procedure swap, we just add one instruction:
ret ; restore registers and return
*/	
leave
	stx op2			; Save X
	sta op2+1		; Save A
	
	; Restore sp from ap
	lda ap
	sta sp
	lda ap+1
	sta sp+1
	
	ldy #4
	lda (fp),y
	tax
	iny
	lda (fp),y
	tay
	txa
	beq noregstorestore
	
restorereg
	lda (sp),y
	sta reg0-1,x
	iny
	dex
	bne restorereg
	
noregstorestore
	; Restore AP
	ldy #0
	lda (fp),y
	sta ap
	iny
	lda (fp),y
	sta ap+1
	
	; Restore FP
	iny
	lda (fp),y
	sta tmp+0
	tax
	iny
	lda (fp),y
	sta fp+1
	stx fp
	
	ldx op2			; Restore X
	lda op2+1		; Restore A
	rts

jsrvect 
	jmp (0000)

_exit
	ldx retstack
	txs
	rts

reterr
	lda #$ff	; return -1
	tax
	rts

retzero
false
	lda #0		;return 0
	tax
	rts

true
	ldx #1		;return 1
	lda #0
	rts


#define load_acc1	$DE7B
#define load_acc2	$DD51
#define store_acc	$DEAD
#define fadd		$DB25
#define fsub		$DB0E
#define fmul		$DCF0
#define fdiv		$DDE7
#define fneg		$E271
#define fcomp		$DF4C
#define cif			$DF24

cfi     
	jsr $DF8C
    ldx $D3
    lda $D4
    rts

