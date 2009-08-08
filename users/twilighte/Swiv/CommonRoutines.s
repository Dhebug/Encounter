;CommonRoutines.s

AddScreen
	clc
	adc screen
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts	

AddSource	
	clc
	adc source
	sta source
	lda source+1
	adc #00
	sta source+1
	rts	

