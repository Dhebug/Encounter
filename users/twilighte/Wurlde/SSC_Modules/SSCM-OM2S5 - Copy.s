;SSCM-OM2S5.s - Field with reflective water
;This is the next (and in some ways the most apprehended screen since it will prove the SSC concept).
;This screen displays the following...
;1) a reflective surface reflecting all sprites on land and in air (The fish) but with distortion
;   to provide a more realistic feel to the water.
;2) Jumping Fish, Fish swim below the surface(not seen) but will occasionally jump into the air in an arc shape.
;   Each one creates bubbles on the surface of the water before breaking through and jumping to hero height.
;   The period of bubbles will allow the hero to run into place and catch the fish as it rises out the water.
;3) Birds flying(aimlessly) in the distance. This screen may appear alot darker than previous and the addition
;   of birds will break the monotony of the backdrop of trees.

;Field - Reflective Water and Fish
#include "..\gamecode\SSCModuleHeader.s"
 .zero
#include "..\gamecode\ZeroPage.s"

 .text
*=$C000

;**************************
ScreenSpecificCodeBlock
        jmp ScreenInit
        jmp ScreenRun
        jmp CollisionDetection
ScreenProseVector
 .byt <ScreenProse,>ScreenProse
ScreenNameVector
 .byt <ScreenName,>ScreenName
ScreenRules
 .byt %00000000
Spare
 .dsb 2,0
;**************************
ScreenInlay
#include "M02S05.s"	;Field1 - scn51.mem in wurlde.dsk

ScreenProse
 .byt "River Banit..                      "
 .byt "                                   "
 .byt "                                   "
 .byt "                                   "
 .byt "                                   "
 .byt "                                   "
 .byt "                                  "," "+128
ScreenName
 .byt "RIVER BANI","T"+128

ScreenInit
	;Copy Inlay to Screen
	lda #<GameScreen
	sta source
	lda #>GameScreen
	sta source+1
	lda #<$A000+46*40
	sta screen
	lda #>$A000+46*40
	sta screen+1
	ldx #119
.(
loop2	ldy #39
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda source
	clc
	adc #40
	sta source
	lda source+1
	adc #00
	sta source+1
	lda screen
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	dex
	bne loop2
.)
        rts
ScreenRun
	;Reflect Hero in reverse(even lines), reduced height and oscillating!
	lda MoveIndex
	clc
	adc #01
	and #3
	sta MoveIndex
	tax
	lda MoveIndexAddressLo,x
.(
	sta vector1+1
	lda MoveIndexAddressHi,x
	sta vector1+2
vector1	jsr $dead
	rts
.)
MoveIndex	.byt 0
movedelay	.byt 0

;Load X with Hero Y before calling
CollisionDetection
	lda #<LevelFloorTable
	sta ContourFloor
	lda #>LevelFloorTable
	sta ContourFloor+1
	lda #<LevelCeilingTable
	sta ContourCeiling
	lda #>LevelCeilingTable
	sta ContourCeiling+1
	rts
LevelCeilingTable
 .dsb 40,22
LevelFloorTable
 .dsb 40,54

MoveIndexAddressLo
 .byt <move1
 .byt <move3
 .byt <move2
 .byt <move4
MoveIndexAddressHi
 .byt >move1
 .byt >move3
 .byt >move2
 .byt >move4


move1	ldx #38
.(
loop1	lda $aff1+46*40,x
	cmp #64
	bcc skip1
	asl
	and #63
	ora #64
	sta $b181+46*40,x
skip1	lda $afa1+46*40,x
	cmp #64
	bcc skip2
	and #63
	lsr
	ora #64
	sta $b1a9+46*40,x
skip2	lda $af51+46*40,x
	cmp #64
	bcc skip3
	asl
	and #63
	ora #64
	sta $b1d1+46*40,x
skip3	lda $af01+46*40,x
	cmp #64
	bcc skip4
	and #63
	lsr
	ora #64
	sta $b1f9+46*40,x
skip4	lda $aeb1+46*40,x
	cmp #64
	bcc skip5
	asl
	and #63
	ora #64
	sta $b221+46*40,x
skip5	lda $ae61+46*40,x
	cmp #64
	bcc skip6
	and #63
	lsr
	ora #64
	sta $b249+46*40,x
skip6	lda $ae11+46*40,x
	cmp #64
	bcc skip7
	asl
	and #63
	ora #64
	sta $b271+46*40,x
skip7
;lda $adc1+46*40,x
;	cmp #64
;	bcc skip8
;	sta $b299+46*40,x
skip8	dex
	bne loop1
.)
	;Now oscillate reflection
 ;	ldx #
 ;	sta $b181+46*40,x
 ;	sta $b1a9+46*40,x
 ;	sta $b1d1+46*40,x
 ;	sta $b1f9+46*40,x
 ;	sta $b221+46*40,x
 ;	sta $b249+46*40,x
 ;	sta $b271+46*40,x
 ;	sta $b299+46*40,x

	rts

move2	ldx #38
.(
loop1	lda $aff1+46*40,x
	cmp #64
	bcc skip1
	and #63
	lsr
	ora #64
	sta $b181+46*40,x
skip1	lda $afa1+46*40,x
	cmp #64
	bcc skip2
	asl
	and #63
	ora #64
	sta $b1a9+46*40,x
skip2	lda $af51+46*40,x
	cmp #64
	bcc skip3
	and #63
	lsr
	ora #64
	sta $b1d1+46*40,x
skip3	lda $af01+46*40,x
	cmp #64
	bcc skip4
	asl
	and #63
	ora #64
	sta $b1f9+46*40,x
skip4	lda $aeb1+46*40,x
	cmp #64
	bcc skip5
	and #63
	lsr
	ora #64
	sta $b221+46*40,x
skip5	lda $ae61+46*40,x
	cmp #64
	bcc skip6
	asl
	and #63
	ora #64
	sta $b249+46*40,x
skip6	lda $ae11+46*40,x
	cmp #64
	bcc skip7
	and #63
	lsr
	ora #64
	sta $b271+46*40,x
skip7
;lda $adc1+46*40,x
;	cmp #64
;	bcc skip8
;	sta $b299+46*40,x
skip8	dex
	bne loop1
.)
	rts

move3
move4	ldx #38
.(
loop1	lda $aff1+46*40,x
	cmp #64
	bcc skip1
	sta $b181+46*40,x
skip1	lda $afa1+46*40,x
	cmp #64
	bcc skip2
	sta $b1a9+46*40,x
skip2	lda $af51+46*40,x
	cmp #64
	bcc skip3
	sta $b1d1+46*40,x
skip3	lda $af01+46*40,x
	cmp #64
	bcc skip4
	sta $b1f9+46*40,x
skip4	lda $aeb1+46*40,x
	cmp #64
	bcc skip5
	sta $b221+46*40,x
skip5	lda $ae61+46*40,x
	cmp #64
	bcc skip6
	sta $b249+46*40,x
skip6	lda $ae11+46*40,x
	cmp #64
	bcc skip7
	sta $b271+46*40,x
skip7
;lda $adc1+46*40,x
;	cmp #64
;	bcc skip8
;	sta $b299+46*40,x
skip8	dex
	bne loop1
	rts
.)
StarLocationsLo
 .byt <$29+$a758
 .byt <$7E+$a758
 .byt <$38+$a758
 .byt <$3B+$a758
 .byt <$12A+$a758
 .byt <$47+$a758
StarLocationsHi
 .byt >$29+$a758
 .byt >$7E+$a758
 .byt >$38+$a758
 .byt >$3B+$a758
 .byt >$12A+$a758
 .byt >$47+$a758
TwinkleColour
 .byt 6,3,2,7
