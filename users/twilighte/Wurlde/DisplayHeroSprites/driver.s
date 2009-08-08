;Display Hero Sprites
;Display hero sprite in hires with width, height and XByte in Text and allow select

 .zero
*=$00
screen          .dsb 2
sprite		.dsb 2
header		.dsb 2
Frame           .dsb 1
Digit0		.dsb 1
Digit1		.dsb 1
Digit2		.dsb 1
FrameWidth	.dsb 1
FrameHeight	.dsb 1
FrameXByte	.dsb 1
temp01		.dsb 1

 .text

*=$500

Driver  jsr $EC33
        lda #00
        sta Frame
        jmp Viewer

#include "C:\osdk\projects\wurlde\gamecode\herosprites.s"

Viewer  jsr DisplayGrid
	jsr DisplaySprite
	jsr DisplayHeader

	jsr UserSelection
	jmp Viewer

DisplayGrid
	;Display HIRES Grid as template to Sprite (Wiping previous sprite)
	;This consists of similar format to SPRITED but also with Sprite Origin Mark
	lda #<$a000
	sta screen
	lda #>$a000
	sta screen+1
	;Plot Red rows
	ldx #20
.(
loop2	ldy #39
	lda #127
loop1	sta (screen),y
	dey
	bne loop1
	lda #1
	sta (screen),y
	jsr nl_screen
	ldy #39
	lda #64
loop3	sta (screen),y
	dey
	bpl loop3
	jsr nl_screen
	dex
	bne loop2
.)
	rts

nl_screen
	lda screen
	clc
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts
nl_sprite
	lda sprite
	clc
	adc FrameWidth
	sta sprite
	lda sprite+1
	adc #00
	sta sprite+1
	rts

Plot3dd
	;Plot 3 digit Decimal (A holds value, Screen+Y)
	ldx #47
	sec
.(
loop1	inx
	sbc #100
	bcs loop1
.)
	adc #100
	stx Digit0
	ldx #47
	sec
.(
loop1	inx
	sbc #10
	bcs loop1
.)
	stx Digit1
	adc #58
	sta Digit2
	lda Digit0
	sta (screen),y
	iny
	lda Digit1
	sta (screen),y
	iny
	lda Digit2
	sta (screen),y
	iny
	rts

Plot2dh
	;Plot 2 Digit Hex
	pha
	lsr
	lsr
	lsr
	lsr
	jsr Plot1dh
	pla
Plot1dh	and #15
	cmp #10
.(
	bcc skip1
	adc #6
skip1	adc #48
.)
	sta (screen),y
	iny
	rts

DisplaySprite
	lda #<$a000+18+80*5
	sta screen
	lda #>$a000+18+80*5
	sta screen+1
	jsr FetchHeaderAndData
	ldx FrameHeight
.(
loop3	;Plot Mask
	ldy FrameWidth
	dey
loop1	lda (sprite),y
;	and (screen),y
	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	jsr nl_sprite
	;Plot Bitmap
	ldy FrameWidth
	dey
loop2	lda (sprite),y
	sta (screen),y
	dey
	bpl loop2
	jsr nl_screen
	jsr nl_sprite
	dex
	bne loop3
.)
	rts


FetchHeaderAndData
	ldx Frame
	lda SpriteFrameVectorLo,x
	sta header
	clc
	adc #4
	sta sprite
	lda SpriteFrameVectorHi,x
	sta header+1
	adc #00
	sta sprite+1
	;Extract Width,Height and XByte from header
	ldy #00
	lda (header),y
	sta FrameWidth
	iny
	lda (header),y
	sta FrameHeight
	iny
	lda (header),y
	sta FrameXByte
	rts

DisplayHeader
	;Display Text Legend
	ldy #39
.(
loop1	lda TextLegend,y
	sta $bf68,y
	lda TextLegend2,y
	sta $bf68+40,y
	dey
	bpl loop1
.)
	;Display Sprite Number in decimal and hex
	lda #<$bf6f
	sta screen
	lda #>$BF6F
	sta screen+1
	ldy #00
	lda Frame
	jsr Plot3dd
	ldy #5
	lda Frame
	jsr Plot2dh
	;Display Width and Height info in decimal
	jsr FetchHeaderAndData
	lda FrameWidth
	ldy #09
	jsr Plot3dd
	lda FrameHeight
	ldy #13
	jsr Plot3dd
	;Display XByte in split Binary
	lda FrameXByte
	sta temp01
	ldy #24
.(
loop1	;Split
	cpy #28
	bne skip1
	iny
skip1	asl temp01
	;Calc Numeric
	lda #"0"
	adc #00
	;Store
	sta (screen),y
	iny
	cpy #33
	bcc loop1
.)
	;Display XByte (Ground Collision)
	ldx FrameHeight
	lda #<$a028+18+80*5
	clc
	adc FrameHeightRowsLo,x
	sta screen
	lda #>$a028+18+80*5
	adc FrameHeightRowsHi,x
	sta screen+1
	;Subtract 1 (To allow to plot colour)
	lda screen
.(
	bne skip1
	dec screen+1
skip1	dec screen
.)
	;Plot Ground Collision Colour
	ldy #00
	lda #2
	sta (screen),y
	;Plot Ground Collision Bitmap
	lda FrameXByte
	sta temp01
	iny
.(
loop1	asl temp01
	bcc skip1
	lda #127
	sta (screen),y
skip1	iny
	cpy #5
	bcc loop1
.)
	;Plot Hero/BG Collision Colour
	lda #<$a028+17+80*3
	sta screen
	lda #>$a028+17+80*3
	sta screen+1

	lda #6
	ldy #0
	sta (screen),y
	;Plot Hero/BG Collision Bitmap
	iny
.(
loop1	asl temp01
	bcc skip1
	lda #127
	sta (screen),y
skip1	iny
	cpy #5
	bcc loop1
.)

	rts
FrameHeightRowsLo
 .byt <0
 .byt <80*1
 .byt <80*2
 .byt <80*3
 .byt <80*4
 .byt <80*5
 .byt <80*6
 .byt <80*7
 .byt <80*8
 .byt <80*9
 .byt <80*10
 .byt <80*11
 .byt <80*12
 .byt <80*13
 .byt <80*14
 .byt <80*15
 .byt <80*16
 .byt <80*17
 .byt <80*18
 .byt <80*19
FrameHeightRowsHi
 .byt >0
 .byt >80*1
 .byt >80*2
 .byt >80*3
 .byt >80*4
 .byt >80*5
 .byt >80*6
 .byt >80*7
 .byt >80*8
 .byt >80*9
 .byt >80*10
 .byt >80*11
 .byt >80*12
 .byt >80*13
 .byt >80*14
 .byt >80*15
 .byt >80*16
 .byt >80*17
 .byt >80*18
 .byt >80*19
TextLegend
 .byt "Sprite:   /#   (   x   ) XByt:",2,"0000",6,"0000"
TextLegend2
 .byt "                               GNDC HROC"

UserSelection
	;Wait on key
loop1	jsr $EB78
	bpl loop1
	;branch on -(Dec Sprite) =(Inc Sprite)
	and #127
	cmp #"-"
	beq DecrementFrame
	cmp #"="
	beq IncrementFrame
	jmp UserSelection

DecrementFrame
	lda Frame
.(
	beq skip1
	dec Frame
skip1	rts
.)

IncrementFrame
	lda Frame
	cmp #105
.(
	bcs skip1
	inc Frame
skip1	rts
.)
