;SSCM-OM0S3.S	HALLOWED DOORWAY - HALLOW1.MEM ON WURLDE.DSK
;1) Gravedigger on horizon
;2) Stars glistening
;3) Circling Crows
;4) Mushrooms to collect

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
 .byt 3				;C01D
RecognisedAction
 .byt %00010000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector	;Enter Boat
 .byt <EnterTextHollow,>EnterTextHollow	;C024
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
#include "INLAY-OM0S3.s"	;

#include "SSC_CommonCode.s"
EnterTextHollow
 .byt "The old door creaks open and a%"
 .byt "sudden gush of stale deadness%"
 .byt "rushes out almost knocking you%"
 .byt "backwards. beyond the threshhold%"
 .byt "lies a set of stairs that decend%"
 .byt "into the bowels of Wurlde.]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "As you approach, a writhing swarm%"
 .byt "of biting bugs seep out from the%"
 .byt "iron gate and rise high in the%"
 .byt "sunless sky. The hallowed doorways%"
 .byt "warning to all who venture too%"
 .byt "close and even the fools who dare%"
 .byt "plunder beyond the threshhold.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "HALLOWED DOOR]"



ScreenInit
	jsr InitialiseHero
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
	jsr ProcSwarm
	rts


;When the hero performs a recognised action this routine is called
;ProcAction
;
;
ProcAction
	;Action key pressed (board boat) - check CollisionFound
	lda CollisionFound
;.(
;	beq skip1
;	;Hero over right place and action pressed so trigger board boat sequence
;	;by disabling hero control..
;	lda ssc_ScreenRules
;	ora #%00000001
;	sta ssc_ScreenRules
;	;Freezing Boat Rock
;	lda #00
;	sta RockFlag
;	;Triggering Board Animation
;	lda #01
;	sta BoardingFlag
;	lda #00
;	sta BoardingIndex
;skip1	clc
;.)
	rts

#include "swarm.s"


