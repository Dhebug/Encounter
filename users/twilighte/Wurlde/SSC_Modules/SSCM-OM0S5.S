;SSCM-OM0S5.S	WIZARDS HOUSE - WIZHOUSE.MEM ON WURLDE.DSK
;1) Smoke rising from house chimney
;2) Occasional hex charms shining
;3) Vegetable plants swaying in light wind
;4) Statues moving as hero passes them and loses or gains weapons
;5) Stars glistening


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
 .byt 10				;C01D
RecognisedAction
 .byt %00010000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector	;Enter Wizards house
 .byt <EnterTextWizardsHouse,>EnterTextWizardsHouse	;C024
InteractionHeaderVector		;
 .byt <InteractionHeader,>InteractionHeader	;C026
CharacterList			;
 .byt <SSCCharacterList,>SSCCharacterList	;C028
CharacterInfo
 .byt <SSCCharacterInfo,>SSCCharacterInfo	;C02A
;**************************
;Collision tables(120) always exist in first page of C000
ct_CeilingLevel
 .dsb 40,128
ct_FloorLevel
 .dsb 40,128
ct_BGCollisions
 .dsb 40,0

ScreenInlay
#include "INLAY-OM0S5.s"	;

#include "SSC_CommonCode.s"
EnterTextWizardsHouse
 .byt "You approach the old oak door and%"
 .byt "if by some unseen servant it gently%"
 .byt "opens revealing a peaceful darkness%"
 .byt "within. As you step over the brink%"
 .byt "your eyes are dazzled with a large%"
 .byt "assortment of Paraphanalia that%"
 .byt "phases in and out of reality.]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "Two Painted statues stand on guard%"
 .byt "and between them with thatched roof%"
 .byt "and picket fence, old oak door and%"
 .byt "green vined walls stands a very old%"
 .byt "home. Rune signs daub the sills and%"
 .byt "hexes guard the terrace. Some great%"
 .byt "Sorcerer made his mark here.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "WIZARDS HOUSE]"



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
	jsr ProcSmoke
	jsr ProcDBird
	rts


;When the hero performs a recognised action this routine is called
;ProcAction
;
;
ProcAction
	;Erase screen inlay
	jsr game_EraseInlay

	;Enter Bakery
	jsr game_Selector

	;Restore Screen
	jsr game_ScreenCopy

	;Return
	clc
	rts


InteractionHeader
 .byt 0
 .byt <Interaction0,>Interaction0

Interaction0
 .byt "$]"
 .byt "Sorry mate, i know nout!]"

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days

SSCCharacterList
 .byt %110+8*21	;Jiro
 .byt %111+8*26	;Erth
 .byt 128

SSCCharacterInfo
 .byt <JiroFaceGFX,>JiroFaceGFX,<JiroDescription,>JiroDescription
 .byt <ErthFaceGFX,>ErthFaceGFX,<ErthDescription,>ErthDescription

JiroFaceGFX
 .byt $7F,$78,$7F
 .byt $40,$40,$40
 .byt $7F,$40,$47
 .byt $05,$43,$40
 .byt $7E,$47,$43
 .byt $07,$44,$60
 .byt $7E,$42,$43
 .byt $05,$4D,$60
 .byt $7E,$6D,$6F
 .byt $01,$4F,$60
 .byt $7F,$65,$4F
 .byt $05,$47,$40
 .byt $7F,$70,$5F
 .byt $40,$40,$40
 .byt $7F,$7F,$7F

JiroDescription
;>>>>>>******************
 .byt "Found at birth in%"
 .byt "the reed banks,%"
 .byt "Jiro now studies%"
 .byt "Magic with Erth]"

ErthFaceGFX
 .byt $7F,$78,$5F
 .byt $07,$47,$40
 .byt $7F,$6F,$6F
 .byt $05,$5F,$70
 .byt $7F,$40,$47
 .byt $03,$48,$60
 .byt $7E,$52,$53
 .byt $05,$5A,$70
 .byt $7F,$40,$47
 .byt $07,$4D,$60
 .byt $7F,$62,$4F
 .byt $07,$47,$40
 .byt $7F,$70,$5F
 .byt $07,$47,$40
 .byt $7F,$70,$5F
ErthDescription
;>>>>>>******************
 .byt "Erth is.]"

SmokeWidth	.byt 10
SmokeLeft		.byt 22*6
SmokeHeight	.byt 20
SmokeBottom	.byt 20

#include "Smoke.s"

dbird_count		.byt 7	;3 to 15
dbird_MaximumY		.byt 24
dbird_LeftStartX		.byt 6
dbird_RightStartX		.byt 239
dbird_HeightRange		.byt 20
dbird_StartY		.byt 4
dbird_DefaultLeftBG		.byt 127
dbird_DefaultRightBG	.byt 127


#include "DistantBirds.s"
