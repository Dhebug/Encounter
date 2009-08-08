;Synopsis
;1) Ships sails and flags swaying (or even the ship!)
;2) Boat moored on condition
;3) Stars in sky
;4) Seagulls
;5) Sea Water effect
;8) The Great Horn sub-game


#include "..\gamecode\WurldeDefines.s"

#include "..\gamecode\SSCModuleHeader.s"
 .zero
*=$00
#include "..\gamecode\ZeroPage.s"

 .text
*=$C000

;**************************
ScreenSpecificCodeBlock
        jmp ScreenInit		;C000	;Run immediately after SSC(This file) is loaded
        jmp ScreenRun		;C003	;Run during a game cycle
        jmp CollisionDetection	;C006	;Run during game cycle and parsed Collision Type in A
        jmp ProcAction		;C009	;Called when Recognised Key Pressed
        jmp Spare			;C00C
        jmp Spare			;C00F
        jmp Spare			;C012
        jmp Spare			;C015
ScreenProseVector
 .byt <ScreenProse,>ScreenProse	;C018
ScreenNameVector
 .byt <ScreenName,>ScreenName		;C01A
ScreenRules
 .byt %10000100			;C01C
LocationID
 .byt 128				;C01D
RecognisedAction
 .byt %00000000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector
 .byt <EnterTextBoat,>EnterTextBoat	;C024
InteractionHeaderVector	;This SSC has no meeting place so 0 must be written to high address
 .byt 0,0				;C026
;**************************
;Collision tables(120) always exist in first page of C000
ct_CeilingLevel
 .dsb 40,128
ct_FloorLevel
 .dsb 40,128
ct_BGCollisions
 .dsb 40,0

ScreenInlay
#include "inlay-om1s6.s"	;Butterflies - moat2.mem in wurlde.dsk

#include "SSC_CommonCode.s"
EnterTextBoat
 .byt "You have found the moored 'Plinker'%"
 .byt "boat. It seems a sturdy little%"
 .byt "vessel for its size. The sails and%"
 .byt "oars are missing and until you%"
 .byt "posess either this vessel is better%"
 .byt "kept where it is.]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "The distant Kobla Rose moors beyond%"
 .byt "in deeper waters, but you still spy%"
 .byt "its crew wrestling to maintain it.%"
 .byt "The end of the jetty marks the end%"
 .byt "of this path.]"
ScreenName	;Always 13 characters long
;      *************
 .byt " HARBOUR END ]"


ScreenInit
	jsr InitialiseHero
Spare	rts

;Parsed
;SideApproachFlag	Hero Appears on Left(0) or Right(1)
InitialiseHero
	;For this screen there is no exit right but the game may have just started.
	lda SideApproachFlag
.(
	bne InitHero4Right
	;Set initial hero sprite frame
	lda #98
	sta HeroSprite
	;Set Hero X to left
	ldx #3
	stx HeroX
	;Set hero y to land contour
	lda ct_FloorLevel,x
	and #63
	sec
	sbc #10
	sta HeroY
	;Set other stuff
	lda #3
	sta SpriteWidth
	lda #9
	sta SpriteHeight
	;Set initial action to stand right
	lda #hcStandRight
	sta HeroAction
	rts

InitHero4Right
.)
	lda #105
	sta HeroSprite
	;Game start (For Map02) parameters
	ldx #34
	stx HeroX
	;Set hero y to land contour
	lda ct_FloorLevel,x
	and #63
	sec
	sbc #10
	sta HeroY
	;Set a few defaults
	lda #3
	sta SpriteWidth
	lda #9
	sta SpriteHeight
	;Set initial Action
	lda #hcStandLeft
	sta HeroAction
	rts

#include "sg_TemplesGreatHornSearch.s"
#include "Waterline.s"

ScreenRun
	jsr TwinkleStars
	jsr RockBoat
	jsr AnimateFlag
	jsr GenerateWaves
	;Is the Great Horn sub-game active?
	ldx SubGameStartLocation
	lda SubGameProperty,x
	and #%00000100
.(
	beq skip1
	jsr SubGame_Run
skip1	rts
.)

;Called from DetectFloorAndCollisions in hero.s when the floortable(A) contains
;0,64,128,192 depending on collision(9,10,11,12)
;For M2S5 it is unused
;
;Returned
;Carry Set when move prohibited
CollisionDetection
	sta CollisionFound
	rts

CollisionFound
 .byt 0


;When the hero performs a recognised action this routine is called
;ProcAction
;
;
ProcAction
	clc
	rts


TwinkleStars
        ;Twinkle stars
        ldx #05
.(
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
.)
        rts

RockBoat
	;Animate Moored Boat (Delay!)
	lda MooringDelay
	adc #64
	sta MooringDelay
.(
	bcs skip1
	rts
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
	lda game_BackgroundBuffer
	adc #<5+32*40
	sta bgbuff
	lda game_BackgroundBuffer+1
	adc #>5+32*40
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
.)
	jsr game_PlotHero
	rts



AnimateFlag
	lda FlagDelay
	clc
	adc #64
	sta FlagDelay
.(
	bcc skip1
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
skip1	rts
.)

FlagDelay		.byt 0
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

LevelWaveHorizonWidth	.byt 39
LevelWaveHorizonLeft	.byt 1
LevelWaveHorizonHeight	.byt 15
LevelWaveHorizonDown	.byt 28

#include "WaveEngine.s"
 .bss
#include "..\playerfile\playerfile.s"
