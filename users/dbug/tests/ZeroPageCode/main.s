
	.text

_main
	jmp _main
	jsr CopyZeroPageRoutine	
	jsr ZeroPageRoutine
	jsr SwapBuffer
	jsr SwapBuffer
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


SwapBuffer  .dsb 256

SwapZeroPage
	jmp SwapZeroPage
.(	
	ldy #0
loop
	lda $00,y
	tax
	lda SwapBuffer,y
	sta $00,y
	txa
	sta SwapBuffer,y
	iny
	bne loop
	rts
.)

		