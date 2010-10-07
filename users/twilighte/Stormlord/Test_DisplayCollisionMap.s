;Test_DisplayCollisionMap.s

TestTemp1	.byt 0
TestTemp2	.byt 0

Test_DisplayCollisionMap
	lda #<CollisionMap
	sta cmap
	lda #>CollisionMap
	sta cmap+1
	
	lda #<$A000+30*40
	sta screen
	lda #>$A000+30*40
	sta screen+1
	
	lda #18
	sta TestTemp2

.(	
loop3	ldy #39
	
loop2	lda (cmap),y
	beq skip1
	
	;Display Collision byte as 6x6cell
	sty TestTemp1
	and #31
	tax
	lda CellGraphicAddressLo,x
	sta vector1+1
	lda CellGraphicAddressHi,x
	sta vector1+2
	clc
	ldx #5
vector1	lda $dead,x
	sta (screen),y
	tya
	adc #40
	tay
	dex
	bpl vector1
	ldy TestTemp1
	
skip1	dey
	bpl loop2
	
	;Next row
	lda cmap
	adc #40
	sta cmap
	lda cmap+1
	adc #00
	sta cmap+1
	
	lda screen
	adc #<40*6
	sta screen
	lda screen+1
	adc #>40*6
	sta screen+1
	
	dec TestTemp2
	bne loop3
.)
	rts


CellGraphicAddressLo
 .byt 0		;00 Background
 .byt <cg_1	;01 Wall/Surface/Solid
 .byt <cg_2	;02 Death
 .byt <cg_3	;03 Exit (Left/Right)
 .byt <cg_4	;04 Object 1 Key
 .byt <cg_5	;05 Object 2 Honey
 .byt <cg_6	;06 Object 3 Umbrella
 .byt <cg_7	;07 Object 4 Boots
 .dsb 8,<cg_u	;08-15
 .byt <cg_16	;16 Fairy
 .byt <cg_17	;17 Door
 .byt <cg_18	;18 Trampolene
CellGraphicAddressHi
 .byt 0		;00 Background
 .byt >cg_1	;01 Wall/Surface/Solid
 .byt >cg_2	;02 Death
 .byt >cg_3	;03 Exit (Left/Right)
 .byt >cg_4	;04 Object 1 Key
 .byt >cg_5	;05 Object 2 Honey
 .byt >cg_6	;06 Object 3 Umbrella
 .byt >cg_7	;07 Object 4 Boots
 .dsb 8,>cg_u	;08-15
 .byt >cg_16	;16 Fairy
 .byt >cg_17	;17 Door
 .byt >cg_18	;18 Trampolene

cg_1
 .byt %01111111
 .byt %01110111
 .byt %01110111
 .byt %01110111
 .byt %01110111
 .byt %01111111
cg_2
 .byt %01111111
 .byt %01100111
 .byt %01111011
 .byt %01110111
 .byt %01100011
 .byt %01111111
cg_3
 .byt %01111111
 .byt %01111111
 .byt %01111111
 .byt %01111111
 .byt %01111111
 .byt %01111111
cg_4
 .byt %01111111
 .byt %01111111
 .byt %01111111
 .byt %01111111
 .byt %01111111
 .byt %01111111
cg_5
 .byt %01111111
 .byt %01100011
 .byt %01101111
 .byt %01100011
 .byt %01100111
 .byt %01111111
cg_6
 .byt %01111111
 .byt %01110001
 .byt %01100011
 .byt %01101101
 .byt %01110011
 .byt %01111111
cg_7
 .byt %01111111
 .byt %01100011
 .byt %01111011
 .byt %01110111
 .byt %01110111
 .byt %01111111
cg_16
 .byt %01111111
 .byt %01011001
 .byt %01010011
 .byt %01010101
 .byt %01011011
 .byt %01111111
cg_17
 .byt %01111111
 .byt %01010001
 .byt %01011101
 .byt %01011101
 .byt %01011101
 .byt %01111111
cg_18
 .byt %01111111
 .byt %01011011
 .byt %01010101
 .byt %01011011
 .byt %01010101
 .byt %01011011
cg_u
 .byt %01111111
 .byt %01101101
 .byt %01101101
 .byt %01101101
 .byt %01110011
 .byt %01111111
