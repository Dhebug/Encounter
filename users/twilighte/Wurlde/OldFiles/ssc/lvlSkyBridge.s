;lvlSkyBridge.s
;Level Specific Effects..
;1)
;Screen Specific activities
;2) Intermittant snow showers			Sort of
;3)
;4)

;Each Screen must be provided with its own set of routines to determine the Land Contour.
;Through these it will be possible to cover all the requirements of Wurlde whilst also
;keeping simple schemes like skybridge a very small footprint.
DetermineContourMap
	ldx HeroY
DetermineContourMap2
	ldy #00
	lda #<ContourFloorList
	sta ContourFloor
	lda #>ContourFloorList
	sta ContourFloor+1
	lda #<ContourCeilingList
	sta ContourCeiling
	lda #>ContourCeilingList
	sta ContourCeiling+1
	rts

ContourFloorList
 .byt 58,58
 .byt 38,38
 .byt 37,37,36,35,34,33,32,32,32,31,30,30,29,29,29,29
 .dsb 18,28
 .byt 59,59
ContourCeilingList
 .dsb 40,4

LevelExit
LevelUnpack
	jsr InitSnow
;Was gonna use this to set background black and light up background
;	lda #00
;	jsr SetScreenLightningColour
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
	jsr SnowDriver
	jmp SequenceLightning
.)

#include "Snow.s"

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


SequenceLightning
	lda LightningSequence
	bpl ContinueLightningSequence
	lda rndRandom
	cmp #7
	bcs NoLightningSequence
InitLightningSequence
	lda #03
	sta LightningSequence
ContinueLightningSequence
	ldy LightningSequence
	lda LightningColour,y
	jsr SetScreenLightningColour
	dec LightningSequence
NoLightningSequence
	rts


LightningSequence	.byt 128
LightningColour
 .byt 4,6,7,6

SetScreenLightningColour
	ldx #57
.(
loop1	ldy LightingScreenVectorLo,x
	sty vector1+1
	ldy LightingScreenVectorHi,x
	sty vector1+2
vector1	sta $dead
	dex
	bpl loop1
.)
	rts

LightingScreenVectorLo
 .byt <$0+$A000+47*40
 .byt <$50+$A000+47*40
 .byt <$a0+$A000+47*40
 .byt <$f0+$A000+47*40
 .byt <$140+$A000+47*40
 .byt <$190+$A000+47*40
 .byt <$1e0+$A000+47*40
 .byt <$230+$A000+47*40
 .byt <$280+$A000+47*40
 .byt <$2d0+$A000+47*40
 .byt <$320+$A000+47*40
 .byt <$370+$A000+47*40
 .byt <$3c0+$A000+47*40
 .byt <$410+$A000+47*40
 .byt <$460+$A000+47*40
 .byt <$4b0+$A000+47*40
 .byt <$500+$A000+47*40
 .byt <$550+$A000+47*40
 .byt <$5a0+$A000+47*40
 .byt <$5f0+$A000+47*40
 .byt <$640+$A000+47*40
 .byt <$698+$A000+47*40
 .byt <$6e8+$A000+47*40
 .byt <$738+$A000+47*40
 .byt <$788+$A000+47*40
 .byt <$7d9+$A000+47*40
 .byt <$829+$A000+47*40
 .byt <$879+$A000+47*40
 .byt <$8c9+$A000+47*40
 .byt <$919+$A000+47*40
 .byt <$960+$A000+47*40
 .byt <$9b0+$A000+47*40
 .byt <$a00+$A000+47*40
 .byt <$b00+$A000+47*40
 .byt <$b4e+$A000+47*40
 .byt <$b9c+$A000+47*40
 .byt <$beb+$A000+47*40
 .byt <$c3a+$A000+47*40
 .byt <$c89+$A000+47*40
 .byt <$cd9+$A000+47*40
 .byt <$d27+$A000+47*40
 .byt <$d77+$A000+47*40
 .byt <$dc7+$A000+47*40
 .byt <$e17+$A000+47*40
 .byt <$e66+$A000+47*40
 .byt <$eb6+$A000+47*40
 .byt <$f06+$A000+47*40
 .byt <$f56+$A000+47*40
 .byt <$fa5+$A000+47*40
 .byt <$ff5+$A000+47*40
 .byt <$1045+$A000+47*40
 .byt <$1095+$A000+47*40
 .byt <$10ef+$A000+47*40
 .byt <$113f+$A000+47*40
 .byt <$118f+$A000+47*40
 .byt <$11e1+$A000+47*40
 .byt <$1231+$A000+47*40
 .byt <$1281+$A000+47*40
LightingScreenVectorHi
 .byt >$0+$A000+47*40
 .byt >$50+$A000+47*40
 .byt >$a0+$A000+47*40
 .byt >$f0+$A000+47*40
 .byt >$140+$A000+47*40
 .byt >$190+$A000+47*40
 .byt >$1e0+$A000+47*40
 .byt >$230+$A000+47*40
 .byt >$280+$A000+47*40
 .byt >$2d0+$A000+47*40
 .byt >$320+$A000+47*40
 .byt >$370+$A000+47*40
 .byt >$3c0+$A000+47*40
 .byt >$410+$A000+47*40
 .byt >$460+$A000+47*40
 .byt >$4b0+$A000+47*40
 .byt >$500+$A000+47*40
 .byt >$550+$A000+47*40
 .byt >$5a0+$A000+47*40
 .byt >$5f0+$A000+47*40
 .byt >$640+$A000+47*40
 .byt >$698+$A000+47*40
 .byt >$6e8+$A000+47*40
 .byt >$738+$A000+47*40
 .byt >$788+$A000+47*40
 .byt >$7d9+$A000+47*40
 .byt >$829+$A000+47*40
 .byt >$879+$A000+47*40
 .byt >$8c9+$A000+47*40
 .byt >$919+$A000+47*40
 .byt >$960+$A000+47*40
 .byt >$9b0+$A000+47*40
 .byt >$a00+$A000+47*40
 .byt >$b00+$A000+47*40
 .byt >$b4e+$A000+47*40
 .byt >$b9c+$A000+47*40
 .byt >$beb+$A000+47*40
 .byt >$c3a+$A000+47*40
 .byt >$c89+$A000+47*40
 .byt >$cd9+$A000+47*40
 .byt >$d27+$A000+47*40
 .byt >$d77+$A000+47*40
 .byt >$dc7+$A000+47*40
 .byt >$e17+$A000+47*40
 .byt >$e66+$A000+47*40
 .byt >$eb6+$A000+47*40
 .byt >$f06+$A000+47*40
 .byt >$f56+$A000+47*40
 .byt >$fa5+$A000+47*40
 .byt >$ff5+$A000+47*40
 .byt >$1045+$A000+47*40
 .byt >$1095+$A000+47*40
 .byt >$10ef+$A000+47*40
 .byt >$113f+$A000+47*40
 .byt >$118f+$A000+47*40
 .byt >$11e1+$A000+47*40
 .byt >$1231+$A000+47*40
 .byt >$1281+$A000+47*40

LevelProse
 .byt "The Sky Bridge...                  "
 .byt "It seems like the weather has taken"
 .byt "a step for the worst. I am getting "
 .byt "drenched here and the wind is      "
 .byt "picking up. It is also ill advised "
 .byt "to stand in the open with lightning"
 .byt "so close..                         "
LevelScreen
#include "skybridg.s"
