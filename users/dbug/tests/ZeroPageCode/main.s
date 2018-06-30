
	.text

_main
	jsr CopyZeroPageRoutine	
	jmp ZeroPageRoutine
	
StartZeroPageRoutine 
	*=$50
 
ZeroPageRoutine 
.(
	nop
loop	
	ldx #16+1
	stx $BB80
	ldx #16+4
	stx $BB80
	jmp loop
.)	
EndZeroPageRoutine

	*=StartZeroPageRoutine+EndZeroPageRoutine-ZeroPageRoutine
	
CopyZeroPageRoutine	
.(
	ldx #0
loop	
	lda StartZeroPageRoutine,x
	sta ZeroPageRoutine,x
	inx
	cpx #EndZeroPageRoutine-ZeroPageRoutine
	bne loop
	rts
.)

