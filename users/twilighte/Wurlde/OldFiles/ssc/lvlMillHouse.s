;lvlMillHouse.s
;Level Specific Effects..
;1) Twinkling stars
;Screen Specific activities
;2) Bees (Refer Euphoric_047 pic)			Done

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
 .byt "The old Mill House...              "
 .byt "The old mill house steeped in grain"
 .byt "                                   "
 .byt "                                   "
 .byt "                                   "
 .byt "                                   "
 .byt "Cherish the innocence...           "
LevelScreen
#include "MillHous.s"
