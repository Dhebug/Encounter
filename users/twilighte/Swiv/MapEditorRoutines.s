;Map Editor MC routines

#define	MapLocationLo	$BFE0
#define	MapLocationHi	$BFE1
#define	BlockID		$BFE2
#define	MapX		$BFE3
#define	SHOWCODE_FLAG	$BFE4

;0500 BASIC EDITOR
;5000 MAP(#600)
;5800 Editor Routines + Block GFX(64x4x24) (1800)
;7500 -
;A000 ...

 .zero
*=$00

screen		.dsb 2
screen2		.dsb 2
map		.dsb 2
source		.dsb 2
tempx		.dsb 1
tempy		.dsb 1
pcx		.dsb 1
pcy		.dsb 1


 .text
*=$5800

Driver	jmp PlotMap
	jmp DisplayMapBlockGraphic

;Plot 5x5 Map in HIRES
PlotMap	;update colours
	lda #<$A001
	sta screen
	lda #>$A001
	sta screen+1
	ldx #60
.(
loop1	ldy #00
	lda #3
	sta (screen),y
	ldy #40
	lda #6
	sta (screen),y
	lda screen
	clc
	adc #80
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	dex
	bne loop1
.)
	;Plot map
	lda #<$A002
	sta screen
	lda #>$A002
	sta screen+1
	lda MapLocationLo
	sta map
	lda MapLocationHi
	sta map+1
	
	ldx #5
.(
loop2	ldy #4
loop1	lda (map),y
	lsr
	lsr
	sta BlockID
	lda SHOWCODE_FLAG
	beq skip1
	lda (map),y
	and #3
	;If normal then don't show code
	beq skip1
	;otherwise
	ora #128
	sta BlockID
skip1	sty MapX
	jsr DisplayMapBlockGraphic
	dey
	bpl loop1
	lda map
	clc
	adc #6
	sta map
	lda map+1
	adc #00
	sta map+1
	
	lda screen
	adc #<960
	sta screen
	lda screen+1
	adc #>960
	sta screen+1
	
	dex
	bne loop2
.)
	rts


		
DisplayMapBlockGraphic
	stx tempx
	lda MapX
	asl
	asl
	adc screen
	sta screen2
	lda screen+1
	adc #00
	sta screen2+1
	sty tempy
	ldx BlockID
.(
	bpl skip1
	;129-131
	lda SpecialBlockAddressLo-129,x
	sta source
	lda SpecialBlockAddressHi-129,x
	jmp skip2
	
skip1	lda GraphicBlockAddressLo,x
	sta source
	lda GraphicBlockAddressHi,x
skip2	sta source+1
.)
	
	ldx #24
.(
loop2	ldy #3
loop1	lda (source),y
	sta (screen2),y
	dey
	bpl loop1
	
	lda source
	clc
	adc #4
	sta source
	lda source+1
	adc #00
	sta source+1
	
	lda screen2
	adc #40
	sta screen2
	lda screen2+1
	adc #00
	sta screen2+1
	
	dex
	bne loop2
.)
	ldx tempx
	ldy tempy
	
	rts
#include "Level1_BGMapTiles.s"


SpecialBlockAddressLo
 .byt <Back_Graphic
 .byt <Wave_Graphic
 .byt <EOL_Graphic
SpecialBlockAddressHi
 .byt >Back_Graphic
 .byt >Wave_Graphic
 .byt >EOL_Graphic

Back_Graphic
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$5E,$4F,$55
 .byt $40,$53,$50,$40
 .byt $55,$5E,$57,$55
 .byt $40,$53,$53,$40
 .byt $55,$5E,$4E,$55
 .byt $40,$40,$40,$40
 .byt $51,$73,$73,$79
 .byt $42,$4A,$58,$48
 .byt $52,$4B,$70,$49
 .byt $42,$4A,$5A,$48
 .byt $51,$73,$71,$71
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
Wave_Graphic
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$4E,$55,$5E
 .byt $51,$51,$51,$50
 .byt $55,$5F,$4A,$5D
 .byt $5F,$51,$4A,$50
 .byt $55,$51,$44,$5E
 .byt $40,$40,$40,$40
 .byt $5F,$5E,$5F,$4F
 .byt $44,$53,$44,$50
 .byt $55,$5E,$55,$57
 .byt $44,$53,$44,$51
 .byt $55,$55,$5F,$4E
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
EOL_Graphic
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $57,$67,$73,$71
 .byt $44,$71,$44,$40
 .byt $55,$65,$54,$79
 .byt $44,$71,$44,$58
 .byt $57,$67,$73,$71
 .byt $40,$40,$40,$40
 .byt $56,$73,$4B,$6D
 .byt $44,$6A,$69,$48
 .byt $56,$73,$49,$4D
 .byt $42,$62,$69,$48
 .byt $56,$62,$69,$4D
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
 .byt $40,$40,$40,$40
 .byt $55,$55,$55,$55
