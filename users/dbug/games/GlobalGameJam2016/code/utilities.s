

	.zero

	
	.text
	
IncTmp0
	clc 
	lda tmp0+0
	adc #1
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1
	rts

Add40Tmp1
.(	
	clc
	lda tmp1
	adc #40
	sta tmp1
	bcc skip_dst
	inc tmp1+1
skip_dst
	rts
.)

