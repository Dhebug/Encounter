;SSC-OM2S4 BOGMIRE.MEM on Wurlde.dsk
;Synopsis
;This screen displays the following...
;1) Popping Bubbles on the bog surface
;2)>Rising and falling stepping stones in the bog. Dependant on where the hero is (xpos) other stepping stones
;   will rise out the bog permitting the hero to decide which direction to take his next step to.
;3) Rising and falling objects to collect. Some red herrings that will guide the hero to his death,
;   some valuable artifacts, some health potions.
;3)>If the hero jumps or steps or falls into the bog, he will quickly sink and his health will deteriorate.
;   However he may still jump or step to the safety of a stone if he is quick enough.
;3) Birds flying(aimlessly) in the distance. This screen may appear alot darker than previous and the addition
;   of birds will break the monotony of the backdrop of trees.
;4) Twinkling Stars

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
 .byt %00000000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector		;Nothing here
 .byt 0,0				;C024
InteractionHeaderVector	;This SSC has no meeting place so 0 must be written to high address
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
#include "INLAY-OM2S4.s"	;Mire - bogmire.mem in wurlde.dsk

#include "SSC_CommonCode.s"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "An Acrid seeping sulpher rises from%"
 .byt "the quagmire like pus oozing from a%"
 .byt "verruca, weeping a piebald mucus on%"
 .byt "the sodden ground. The rancid earth%"
 .byt "evicts a malodour that eats at your%"
 .byt "very soul.A granite plinth rises as%"
 .byt "you approach this godforsaken land.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "THE QUAGMIRE ]"



ScreenInit
	jsr InitialiseHero
	jsr InitialiseStones
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
	and #63
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

ScreenRun
	jsr ProcessSteppingStones
	rts




;Called from DetectFloorAndCollisions in hero.s when the floortable(A) contains
;0,64,128,192 depending on collision(9,10,11,12)
;For M2S5 it is unused
;
;Returned
;Set Carry when move prohibited
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


#include "SteppingStones.s"

