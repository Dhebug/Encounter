;lvltestcomplex.s


;Level Specific Effects..
;1) Twinkling stars
;Screen Specific activities
;2) Flickering church candlelight                       ?
;3) Distant Lighthouse curculating light
;4) Chimney Smoke

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
        rts

DetermineContourMap
	ldx HeroY
DetermineContourMap2
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
 .byt "This tunnel complex has been       "
 .byt "plundered by some dark force.      "
 .byt "Immense strength must have been    "
 .byt "exumed to collapse the dwarven     "
 .byt "stronghold. A mystery that may     "
 .byt "never be recounted.                "
 .byt "                                   "
LevelScreen

#include "excomplx.s"
