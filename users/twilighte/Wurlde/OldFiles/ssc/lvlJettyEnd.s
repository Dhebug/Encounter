;lvlJettyEnd.s
;Level Specific Effects..
;1) Twinkling stars                                     Done
;2) Distant waves glistening
;3) Seagulls
;4) Moored Boats swaying mast silhouette		Done
;5) Distant ship mast top flag 				Done
;6) distant ship flags
;7) distant birds
LevelSettings	.byt %00000000

;B0 Exit West Normal
;B1 Exit East Normal
;B2 Exit North Normal (Into screen) or Exit Up Normal
;B3 Exit South Normal (Out of screen) or Exit Down Normal
;B4 Exit West Danger
;B5 Exit East Danger
;B6 Exit North Danger (Into screen) or Exit Up Danger
;B7 Exit South Danger (Out of screen) or Exit Down Danger
;LevelExits
; .byt ExitWestNormal


DetermineContourMap
	ldx HeroY
DetermineContourMap2
	ldy #00
	lda #<FloorTable
	sta ContourFloor
	lda #>FloorTable
	sta ContourFloor+1
	lda #<CeilingTable
	sta ContourCeiling
	lda #>CeilingTable
	sta ContourCeiling+1
	rts

LevelExit
LevelUnpack
        rts
LevelRun
        ;Twinkle stars
.(
        ldx #05
loop1   lda StarLocationsLo,x
        sta screen
        lda StarLocationsHi,x
        sta screen+1
        txa
        tay
        lda rndRandom
loop2   lsr
        dey
        bpl loop2
        and #3
        tay
        lda TwinkleColour,y
        ldy #00
        sta (screen),y
        dex
        bpl loop1

        ;flying insects(biting?)
.)
	;Animate Moored Boat (Delay!)
	lda MooringDelay
	adc #96
	sta MooringDelay
.(
	bcs skip1
	jmp next1
skip1	;Plot next frame to BGBuffer(BackgroundBuffer+6+65*32) and Screen(AA2E)
	lda MooringFrame	;0-7
	adc #00
	and #7
	sta MooringFrame
	tax
	lda MooringFrameAddressLo,x
	sta source
	lda MooringFrameAddressHi,x
	sta source+1
	lda #<BackgroundBuffer+5+32*40
	sta bgbuff
	lda #>BackgroundBuffer+5+32*40
	sta bgbuff+1
	lda #<$A730+$A2E
	sta screen
	lda #>$A730+$A2E
	sta screen+1
	ldx #11
loop2	ldy #04
loop1	lda (source),y
	sta (screen),y
	sta (bgbuff),y
	dey
	bpl loop1
	lda source
	clc
	adc #05
	sta source
	lda source+1
	adc #00
	sta source+1
	lda screen
	adc #80
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	lda bgbuff
	adc #40
	sta bgbuff
	lda bgbuff+1
	adc #00
	sta bgbuff+1
	dex
	bne loop2
	jsr PlotHero
next1
.)
	lda FlagTopFrame
	clc
	adc #1
	and #7
	sta FlagTopFrame
	tax
	lda ShipTopFlagAddressLo,x
	sta source
	lda ShipTopFlagAddressHi,x
	sta source+1
	lda #<$A811
	sta screen
	lda #>$A811
	sta screen+1
	ldx #6
.(
loop2	ldy #2
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda screen
	clc
	adc #80
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	lda source
	adc #3
	sta source
	lda source+1
	adc #00
	sta source+1
	dex
	bne loop2
.)
	jsr GenerateWaves
	rts
FlagTopFrame	.byt 0
WaveFrameIndex	.byt 0
ShipTopFlagAddressLo
 .byt <ShipTopFlagFrame0
 .byt <ShipTopFlagFrame1
 .byt <ShipTopFlagFrame2
 .byt <ShipTopFlagFrame3
 .byt <ShipTopFlagFrame4
 .byt <ShipTopFlagFrame5
 .byt <ShipTopFlagFrame6
 .byt <ShipTopFlagFrame7
ShipTopFlagAddressHi
 .byt >ShipTopFlagFrame0
 .byt >ShipTopFlagFrame1
 .byt >ShipTopFlagFrame2
 .byt >ShipTopFlagFrame3
 .byt >ShipTopFlagFrame4
 .byt >ShipTopFlagFrame5
 .byt >ShipTopFlagFrame6
 .byt >ShipTopFlagFrame7



MooringDelay	.byt 0
MooringFrame	.byt 0
MooringFrameAddressLo
 .byt <MooredMastFrame0
 .byt <MooredMastFrame1
 .byt <MooredMastFrame2
 .byt <MooredMastFrame3
 .byt <MooredMastFrame4
 .byt <MooredMastFrame3
 .byt <MooredMastFrame2
 .byt <MooredMastFrame1
MooringFrameAddressHi
 .byt >MooredMastFrame0
 .byt >MooredMastFrame1
 .byt >MooredMastFrame2
 .byt >MooredMastFrame3
 .byt >MooredMastFrame4
 .byt >MooredMastFrame3
 .byt >MooredMastFrame2
 .byt >MooredMastFrame1
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
LevelProse
 .byt "A Bridge to guide me..             "
 .byt "In a dark dank hollow              "
 .byt "the musty aroma is rank            "
 .byt "and lies their a lost hallow       "
 .byt "beyond salvation ence beheld.      "
 .byt "                                   "
 .byt "But is all is it seems?            "
;the example i sent requires that the mast of the moored boat be animated (moving side to side like a pendulum)
MooredMastFrame0	;(5x11)x5 frames == 275 Bytes
 .byt %01111111,%01111111,%01111111,%01111111,%01111111
 .byt %01111111,%01111111,%01111111,%01110011,%01111111
 .byt %01111111,%01111111,%01111111,%01010011,%01111111
 .byt %01111111,%01111111,%01111101,%01100101,%01111111
 .byt %01111111,%01111111,%01110111,%01100110,%01111111
 .byt %01111111,%01111111,%01011111,%01100111,%01011111
 .byt %01111111,%01111101,%01111111,%01001111,%01101111
 .byt %01111111,%01110111,%01111111,%01001111,%01110111
 .byt %01111111,%01010111,%01111111,%01001111,%01111011
 .byt %01111101,%01110111,%01111110,%01011111,%01111101
 .byt %01110111,%01110111,%01111110,%01011111,%01111110
MooredMastFrame1
 .byt %01111111,%01111111,%01111111,%01111111,%01111111
 .byt %01111111,%01111111,%01111111,%01001111,%01111111
 .byt %01111111,%01111111,%01111101,%01001011,%01111111
 .byt %01111111,%01111111,%01111010,%01011101,%01111111
 .byt %01111111,%01111111,%01101110,%01011110,%01111111
 .byt %01111111,%01111111,%01011110,%01011111,%01011111
 .byt %01111111,%01111101,%01111110,%01011111,%01101111
 .byt %01111111,%01110011,%01111110,%01011111,%01110111
 .byt %01111111,%01100111,%01111100,%01111111,%01111011
 .byt %01111111,%01010111,%01111100,%01111111,%01111101
 .byt %01111101,%01110111,%01111100,%01111111,%01111110
MooredMastFrame2
 .byt %01111111,%01111111,%01111001,%01111111,%01111111
 .byt %01111111,%01111111,%01101001,%01011111,%01111111
 .byt %01111111,%01111111,%01011001,%01101111,%01111111
 .byt %01111111,%01111110,%01111001,%01110111,%01111111
 .byt %01111111,%01111011,%01111001,%01111011,%01111111
 .byt %01111111,%01110111,%01111001,%01111101,%01111111
 .byt %01111111,%01101111,%01111001,%01111110,%01111111
 .byt %01111111,%01010111,%01111001,%01111111,%01011111
 .byt %01111101,%01110111,%01111001,%01111111,%01101111
 .byt %01111011,%01110111,%01111001,%01111111,%01110111
 .byt %01110111,%01110111,%01111001,%01111111,%01111011
MooredMastFrame3
 .byt %01111111,%01111111,%01111111,%01111111,%01111111
 .byt %01111111,%01111100,%01111111,%01111111,%01111111
 .byt %01111111,%01110100,%01101111,%01111111,%01111111
 .byt %01111111,%01101110,%01010111,%01111111,%01111111
 .byt %01111111,%01011110,%01011101,%01111111,%01111111
 .byt %01111110,%01111110,%01011110,%01111111,%01111111
 .byt %01111101,%01111110,%01011111,%01101111,%01111111
 .byt %01111011,%01110110,%01011111,%01110111,%01111111
 .byt %01110111,%01110111,%01001111,%01111101,%01111111
 .byt %01101111,%01110111,%01001111,%01111110,%01111111
 .byt %01011111,%01110111,%01001111,%01111111,%01101111
MooredMastFrame4
 .byt %01111111,%01111111,%01111111,%01111111,%01111111
 .byt %01111111,%01110011,%01111111,%01111111,%01111111
 .byt %01111111,%01110010,%01111111,%01111111,%01111111
 .byt %01111111,%01101001,%01101111,%01111111,%01111111
 .byt %01111111,%01011001,%01111011,%01111111,%01111111
 .byt %01111110,%01111001,%01111110,%01111111,%01111111
 .byt %01111101,%01111100,%01111111,%01101111,%01111111
 .byt %01111011,%01110100,%01111111,%01111011,%01111111
 .byt %01110111,%01110100,%01111111,%01111110,%01111111
 .byt %01101111,%01110110,%01011111,%01111111,%01101111
 .byt %01011111,%01110110,%01011111,%01111111,%01111011
ShipTopFlagFrame0	;(3x6)x8 == 144 Bytes
 .byt %01111111,%01111111,%01111011
 .byt %01111111,%01111111,%01000011
 .byt %01111111,%01111100,%01111011
 .byt %01110101,%01001100,%01111011
 .byt %01101111,%01110011,%01111001
 .byt %01111011,%01111110,%01100011
ShipTopFlagFrame1
 .byt %01111111,%01111111,%01111011
 .byt %01111111,%01111111,%01000011
 .byt %01110101,%01111100,%01011011
 .byt %01101110,%01011001,%01111011
 .byt %01111011,%01100111,%01111001
 .byt %01111111,%01111110,%01100011
ShipTopFlagFrame2
 .byt %01111111,%01111111,%01111011
 .byt %01110101,%01111110,%01000011
 .byt %01101110,%01010000,%01111011
 .byt %01101111,%01000111,%01111011
 .byt %01111111,%01111111,%01111001
 .byt %01111111,%01111110,%01100011
ShipTopFlagFrame3
 .byt %01111111,%01111111,%01111011
 .byt %01110101,%01111110,%01000011
 .byt %01101100,%01111000,%01111011
 .byt %01111110,%01010011,%01111011
 .byt %01111111,%01101111,%01111001
 .byt %01111111,%01111110,%01100011
ShipTopFlagFrame4
 .byt %01111111,%01111111,%01111011
 .byt %01111010,%01111111,%01000011
 .byt %01111111,%01001100,%01111011
 .byt %01111111,%01001001,%01111011
 .byt %01111111,%01100011,%01111001
 .byt %01111111,%01111110,%01100011
ShipTopFlagFrame5
 .byt %01111111,%01111111,%01111011
 .byt %01111110,%01111100,%01000011
 .byt %01111110,%01011001,%01111011
 .byt %01111111,%01001011,%01111011
 .byt %01111111,%01100011,%01111001
 .byt %01111111,%01110110,%01100011
ShipTopFlagFrame6
 .byt %01111111,%01111101,%01111011
 .byt %01111111,%01110010,%01000011
 .byt %01111111,%01100011,%01111011
 .byt %01111100,%01001111,%01111011
 .byt %01111111,%01111111,%01111001
 .byt %01111111,%01111110,%01100011
ShipTopFlagFrame7
 .byt %01111111,%01111111,%01111011
 .byt %01111111,%01111100,%01000011
 .byt %01111111,%01001011,%01111011
 .byt %01111110,%01010111,%01111011
 .byt %01110101,%01111111,%01111001
 .byt %01111111,%01111110,%01100011
LevelScreen
#include "jettyend.s"
#include "WaveEngine.s"
