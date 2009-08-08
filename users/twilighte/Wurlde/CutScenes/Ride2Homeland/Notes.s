;Ride to Homeland
;A combination of delayed 1,2,3 and 6 bit parralax scrolls over 39x59 screen rows

;Clouds
;Mountains
;Hills
;Terrain
;Path	Fence
;	Fence

ParralaxScroll
	ldx #49
loop1	lda ScrollFrac,x
	adc FractionalParralaxStep,x
	sta ScrollFrac,x
	bcc
	lda ScrollVectorLo,x	;1,2,3,6 bit scroll routine vector
	sta vector1+1
	lda ScrollVectorHi,x
	sta vector1+2
vector1	jsr $dead
	lda DataColumnFillVectorLo,x	;Populate column with data vector
	sta vector2+1
	lda DataColumnFillVectorHi,x
	sta vector2+2
vector2	jsr $dead
	dex
	bpl loop1
	rts
	
ScrollVectorLo	;Top Down
 .byt <BitCount1Scroll
 .byt <
ScrollVectorHi
DataColumnFillVectorLo
DataColumnFillVectorHi
	