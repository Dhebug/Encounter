;SSCM-OM4S5.S	skybridge - skybridge.MEM ON WURLDE.DSK
;1) Lightning and rain (need to create regions so droplets fall below bridge)
;2) Drips from underside of bridge

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
 .byt %10001100			;C01C
LocationID
 .byt 7				;C01D
RecognisedAction
 .byt %00010000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector	;Enter Boat
 .byt 0,0				;C024
InteractionHeaderVector		;This SSC has no meeting place so 0 must be written to high address
 .byt 0,0				;C026
CharacterList			;
 .byt 0,0				;C028
CharacterInfo
 .byt 0,0				;C02A
;**************************
;Collision tables(120) always exist in first page of C000
ct_CeilingLevel
 .dsb 40,128
ct_FloorLevel
 .dsb 40,128
ct_BGCollisions
 .dsb 40,0

ScreenInlay
#include "INLAY-OM4S5.s"	;skybridge - skybridge.MEM ON WURLDE.DSK

#include "SSC_CommonCode.s"

ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "No sooner do you spy the bridge and%"
 .byt "a storm quickly brews. The crack of%"
 .byt "lightning and boom of thunder tells%"
 .byt "you that you have no time to waste.%"
 .byt "The sky is dark now as a torrent of%"
 .byt "water crashes down from the heavens%"
 .byt "and cascades over the narrow bridge]"
ScreenName	;Always 13 characters long
;      *************
 .byt "THE SKYBRIDGE]"



ScreenInit
	jsr InitialiseHero
	jsr InitParticle
Spare	rts

;Parsed
;SideApproachFlag	Hero Appears on Left(0) or Right(1)
InitialiseHero
	;For this screen..
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
	sec
	sbc #9
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
	sec
	sbc #09
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

;Called from DetectFloorAndCollisions in hero.s when the floortable(A) contains
;0,64,128,192 depending on collision(9,10,11,12)
;For M2S5 it is unused
;
;Returned
;Carry Set when move prohibited
CollisionDetection
	;For this screen we need to store 9(2 places) where the hero may board the boat
	sta CollisionFound
	rts

CollisionFound
 .byt 0


ScreenRun
	jsr ParticleDriver
	jmp SequenceLightning
	rts


;When the hero performs a recognised action this routine is called
;ProcAction
;
;
ProcAction
	rts

#include "snow.s"

SequenceLightning
	lda LightningSequence
	bpl ContinueLightningSequence
	lda #255
	jsr game_GetRNDRange
	cmp #7
	bcs NoLightningSequence
InitLightningSequence
	lda #07
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
 .byt 4,4,6,6,7,7,6,6

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
 .byt <$A730+40	;0
 .byt <$A780+40
 .byt <$A7D0+40
 .byt <$A820+40
 .byt <$A872+40	;
 .byt <$A8C2+40
 .byt <$A913+40	;
 .byt <$A963+40
 .byt <$A9B3+40
 .byt <$AA05+40
 .byt <$AA55+40	;10
 .byt <$AAA6+40
 .byt <$AAF6+40
 .byt <$AB46+40
 .byt <$AB96+40
 .byt <$ABE7+40
 .byt <$AC37+40
 .byt <$AC87+40
 .byt <$ACD7+40
 .byt <$AD27+40
 .byt <$AD78+40	;20<
 .byt <$ADC8+40
 .byt <$AE18+40
 .byt <$AE68+40
 .byt <$AEB9+40
 .byt <$AF09+40
 .byt <$AF59+40
 .byt <$AFA9+40
 .byt <$AFF9+40
 .byt <$B049+40
 .byt <$B04A+120
 .byt <$B094+40	;30
 .byt <$B0E4+40

 .byt <$B234-40
 .byt <$B230+40
 .byt <$B27E+40
 .byt <$B2CC+40
 .byt <$B31B+40
 .byt <$B36A+40
 .byt <$B3B9+40
 .byt <$B409+40
 .byt <$B457+40
 .byt <$B4A7+40	;40
 .byt <$B4F7+40
 .byt <$B547+40
 .byt <$B596+40
 .byt <$B5E6+40
 .byt <$B636+40
 .byt <$B686+40
 .byt <$B6D5+40
 .byt <$B725+40
 .byt <$B775+40
 .byt <$B7CF+40	;50
 .byt <$B81F+40
 .byt <$B86F+40
 .byt <$B8C1+40
 .byt <$B911+40
 .byt <$B961+40
 .byt <$B9B1+40
LightingScreenVectorHi
 .byt >$A730+40	;0
 .byt >$A780+40
 .byt >$A7D0+40
 .byt >$A820+40
 .byt >$A872+40	;
 .byt >$A8C2+40
 .byt >$A913+40	;
 .byt >$A963+40
 .byt >$A9B3+40
 .byt >$AA05+40
 .byt >$AA55+40	;10
 .byt >$AAA6+40
 .byt >$AAF6+40
 .byt >$AB46+40
 .byt >$AB96+40
 .byt >$ABE7+40
 .byt >$AC37+40
 .byt >$AC87+40
 .byt >$ACD7+40
 .byt >$AD27+40
 .byt >$AD78+40	;20<
 .byt >$ADC8+40
 .byt >$AE18+40
 .byt >$AE68+40
 .byt >$AEB9+40
 .byt >$AF09+40
 .byt >$AF59+40
 .byt >$AFA9+40
 .byt >$AFF9+40
 .byt >$B049+40
 .byt >$B04A+120
 .byt >$B094+40	;30
 .byt >$B0E4+40

 .byt >$B234-40
 .byt >$B230+40
 .byt >$B27E+40
 .byt >$B2CC+40
 .byt >$B31B+40
 .byt >$B36A+40
 .byt >$B3B9+40
 .byt >$B409+40
 .byt >$B457+40
 .byt >$B4A7+40
 .byt >$B4F7+40
 .byt >$B547+40
 .byt >$B596+40
 .byt >$B5E6+40
 .byt >$B636+40
 .byt >$B686+40
 .byt >$B6D5+40
 .byt >$B725+40
 .byt >$B775+40
 .byt >$B7CF+40
 .byt >$B81F+40
 .byt >$B86F+40
 .byt >$B8C1+40
 .byt >$B911+40
 .byt >$B961+40
 .byt >$B9B1+40
;  .byt <$0+$A000+47*40
;  .byt <$50+$A000+47*40
;  .byt <$a0+$A000+47*40
;  .byt <$f0+$A000+47*40
;  .byt <$140+$A000+47*40
;  .byt <$190+$A000+47*40
;  .byt <$1e0+$A000+47*40
;  .byt <$230+$A000+47*40
;  .byt <$280+$A000+47*40
;  .byt <$2d0+$A000+47*40
;  .byt <$320+$A000+47*40
;  .byt <$370+$A000+47*40
;  .byt <$3c0+$A000+47*40
;  .byt <$410+$A000+47*40
;  .byt <$460+$A000+47*40
;  .byt <$4b0+$A000+47*40
;  .byt <$500+$A000+47*40
;  .byt <$550+$A000+47*40
;  .byt <$5a0+$A000+47*40
;  .byt <$5f0+$A000+47*40
;  .byt <$640+$A000+47*40
;  .byt <$698+$A000+47*40
;  .byt <$6e8+$A000+47*40
;  .byt <$738+$A000+47*40
;  .byt <$788+$A000+47*40
;  .byt <$7d9+$A000+47*40
;  .byt <$829+$A000+47*40
;  .byt <$879+$A000+47*40
;  .byt <$8c9+$A000+47*40
;  .byt <$919+$A000+47*40
;  .byt <$960+$A000+47*40
;  .byt <$9b0+$A000+47*40
;  .byt <$a00+$A000+47*40
;  .byt <$b00+$A000+47*40
;  .byt <$b4e+$A000+47*40
;  .byt <$b9c+$A000+47*40
;  .byt <$beb+$A000+47*40
;  .byt <$c3a+$A000+47*40
;  .byt <$c89+$A000+47*40
;  .byt <$cd9+$A000+47*40
;  .byt <$d27+$A000+47*40
;  .byt <$d77+$A000+47*40
;  .byt <$dc7+$A000+47*40
;  .byt <$e17+$A000+47*40
;  .byt <$e66+$A000+47*40
;  .byt <$eb6+$A000+47*40
;  .byt <$f06+$A000+47*40
;  .byt <$f56+$A000+47*40
;  .byt <$fa5+$A000+47*40
;  .byt <$ff5+$A000+47*40
;  .byt <$1045+$A000+47*40
;  .byt <$1095+$A000+47*40
;  .byt <$10ef+$A000+47*40
;  .byt <$113f+$A000+47*40
;  .byt <$118f+$A000+47*40
;  .byt <$11e1+$A000+47*40
;  .byt <$1231+$A000+47*40
;  .byt <$1281+$A000+47*40

;  .byt >$0+$A000+47*40
;  .byt >$50+$A000+47*40
;  .byt >$a0+$A000+47*40
;  .byt >$f0+$A000+47*40
;  .byt >$140+$A000+47*40
;  .byt >$190+$A000+47*40
;  .byt >$1e0+$A000+47*40
;  .byt >$230+$A000+47*40
;  .byt >$280+$A000+47*40
;  .byt >$2d0+$A000+47*40
;  .byt >$320+$A000+47*40
;  .byt >$370+$A000+47*40
;  .byt >$3c0+$A000+47*40
;  .byt >$410+$A000+47*40
;  .byt >$460+$A000+47*40
;  .byt >$4b0+$A000+47*40
;  .byt >$500+$A000+47*40
;  .byt >$550+$A000+47*40
;  .byt >$5a0+$A000+47*40
;  .byt >$5f0+$A000+47*40
;  .byt >$640+$A000+47*40
;  .byt >$698+$A000+47*40
;  .byt >$6e8+$A000+47*40
;  .byt >$738+$A000+47*40
;  .byt >$788+$A000+47*40
;  .byt >$7d9+$A000+47*40
;  .byt >$829+$A000+47*40
;  .byt >$879+$A000+47*40
;  .byt >$8c9+$A000+47*40
;  .byt >$919+$A000+47*40
;  .byt >$960+$A000+47*40
;  .byt >$9b0+$A000+47*40
;  .byt >$a00+$A000+47*40
;  .byt >$b00+$A000+47*40
;  .byt >$b4e+$A000+47*40
;  .byt >$b9c+$A000+47*40
;  .byt >$beb+$A000+47*40
;  .byt >$c3a+$A000+47*40
;  .byt >$c89+$A000+47*40
;  .byt >$cd9+$A000+47*40
;  .byt >$d27+$A000+47*40
;  .byt >$d77+$A000+47*40
;  .byt >$dc7+$A000+47*40
;  .byt >$e17+$A000+47*40
;  .byt >$e66+$A000+47*40
;  .byt >$eb6+$A000+47*40
;  .byt >$f06+$A000+47*40
;  .byt >$f56+$A000+47*40
;  .byt >$fa5+$A000+47*40
;  .byt >$ff5+$A000+47*40
;  .byt >$1045+$A000+47*40
;  .byt >$1095+$A000+47*40
;  .byt >$10ef+$A000+47*40
;  .byt >$113f+$A000+47*40
;  .byt >$118f+$A000+47*40
;  .byt >$11e1+$A000+47*40
;  .byt >$1231+$A000+47*40
;  .byt >$1281+$A000+47*40

