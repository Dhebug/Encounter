
	.text

_main
	jmp _main
	jsr CopyZeroPageRoutine	
	jsr ZeroPageRoutine
	rts
	
StartZeroPageRoutine 
	*=$50
 
ZeroPageRoutine 
	nop
source 
	lda $A000 
    sta $030F 
	inc source+1 
	bne skip1 
	inc source+2    
skip1  
	rts
EndZeroPageRoutine

	*=StartZeroPageRoutine+EndZeroPageRoutine-ZeroPageRoutine
	
CopyZeroPageRoutine	
	ldx #0
loop	
	lda StartZeroPageRoutine,x
	sta ZeroPageRoutine,x
	inx
	cpx #EndZeroPageRoutine-ZeroPageRoutine
	bne loop
	rts

		