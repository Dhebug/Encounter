;SSCM-OM3S1.S	Log Cabin - sscmom3s1.mem ON Samson.DSK
;1) 
;2) 

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
 .byt 4				;C01D
RecognisedAction
 .byt %00010000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector		;
 .byt <EnteringCabinText,>EnteringCabinText	;C024
InteractionHeaderVector	;
 .byt <InteractionHeader,>InteractionHeader	;C026
CharacterList		;
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
#include "INLAY-OM3S1.s"	;

#include "SSC_CommonCode.s"
;Enter Text
EnteringCabinText
 .byt "The door creaks open and the musty%"
 .byt "smell says this place has not been%"
 .byt "used for many seasons.In one corner%"
 .byt "is an old wood stove and another is%"
 .byt "a small single bed. A Large Spider%"
 .byt "sits on the bed almost grinning at%"
 .byt "you (if that was possible).]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "The old log cabin seems a welcoming%"
 .byt "sign of habitation in this desolate%"
 .byt "place.Aside it is stacked much wood%"
 .byt "and the lantern looks hardly used.%"
 .byt "The cabin stands on log stilts and%"
 .byt "seems solid and in good repair. The%"
 .byt "door has no key hole.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "LOG CABIN]"



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
	rts

;When the hero performs a recognised action this routine is called
;ProcAction
;
;
ProcAction
	clc
	rts


InteractionHeader
 .byt 0	;
 .byt <Interaction0,>Interaction0

Interaction0
 .byt "$]"
 .byt "Oh i dunno!]"

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days
SSCCharacterList	;List of characters(0-31) present at the Market and times they are present (0-7)
 .byt %111+8*25	;Spider
 .byt 255

SSCCharacterInfo
 .byt <SpiderFaceGFX,>SpiderFaceGFX,<SpiderDescription,>SpiderDescription

SpiderFaceGFX
 .byt $7F,$7B,$7F
 .byt $01,$44,$40
 .byt $7F,$7B,$7F
 .byt $01,$44,$40
 .byt $7F,$7B,$7F
 .byt $01,$44,$40
 .byt $7F,$7B,$7F
 .byt $01,$44,$40
 .byt $7E,$7B,$6F
 .byt $01,$44,$40
 .byt $7D,$5B,$57
 .byt $05,$40,$40
 .byt $7A,$60,$6B
 .byt $07,$4A,$40
 .byt $76,$60,$6D
SpiderDescription
;>>>>>>******************
 .byt "I am a spider.%"
 .byt "Squash me and i'll%"
 .byt "turn you into a%"
 .byt "fly swat!]"

