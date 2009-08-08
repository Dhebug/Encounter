;MenuPlot.s

MainMenuPlot
	ldx #31
.(
loop1	lda MainMenuRowText,x
	sta $bb80,x
	dex
	bpl loop1
.)
	rts
	
PlotMenuCursor
	ldx MenuCursorX
	ldy MenuOptionScreenOffset,x
	lda MenuOptionScreenCharacters,x
	tax
.(
loop1	lda $BB80,y
	ora #128
	sta $BB80,y
	iny
	dex
	bne loop1
.)
	rts
	
MenuOptionScreenOffset
 .byt 1,6,11,19,23,24,25,27,31
MenuOptionScreenCharacters
 .byt 4,4,7,3,1,1,1,3,8

