

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

Add240Tmp1
.(	
	clc
	lda tmp1
	adc #240
	sta tmp1
	bcc skip_dst
	inc tmp1+1
skip_dst
	rts
.)



Add240Tmp2
.(	
	clc
	lda tmp2
	adc #240
	sta tmp2
	bcc skip_dst
	inc tmp2+1
skip_dst
	rts
.)



Add40Tmp2
.(	
	clc
	lda tmp2
	adc #40
	sta tmp2
	bcc skip_dst
	inc tmp2+1
skip_dst
	rts
.)

