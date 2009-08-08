;SSCM-OM4S1.S	littlepee - scn53.MEM ON WURLDE.DSK
;1) Little folk running around
;2) animated river
;3) distant birds

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
EnteringTextVector
 .byt <EnterText,>EnterText		;C024
InteractionHeaderVector		;C026
 .byt <InteractionHeader,>InteractionHeader
CharacterList			;C028
 .byt <SSCCharacterList,>SSCCharacterList
CharacterInfo			;C02A
 .byt <SSCCharacterInfo,>SSCCharacterInfo
;**************************
;Collision tables(120) always exist in first page of C000
ct_CeilingLevel
 .dsb 40,128
ct_FloorLevel
 .dsb 40,128
ct_BGCollisions
 .dsb 40,0

ScreenInlay
#include "INLAY-OM4S1.s"	;littlepee - scn53.MEM ON WURLDE.DSK

#include "SSC_CommonCode.s"
EnterText
 .byt "Little Pee folk hosts travellers by%"
 .byt "providing]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "The folk here are much smaller than%"
 .byt "regular humans. But with there size%"
 .byt "comes a dexterity for producing the%"
 .byt "most finely detailed cloth, metals%"
 .byt "and porcalain.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "LITTLEPEE]"



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
	rts


;When the hero performs a recognised action this routine is called
;ProcAction
;
;
ProcAction
	rts

InteractionHeader
UltimateInteraction		.byt 0	;Number of interactions-1 (Zero based)
InteractionsTable
 .byt <Interaction0,>Interaction0

Interaction0
 .byt 147,"$]"		;Asking Derb about rumours
 .byt 162," swore he saw a ",181," fly%over here a few moons ago.]"	;Kinda , Pit Dragon

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days
SSCCharacterList	;List of characters(0-31) present at this location (Terminated with 128)
 .byt %101	;Nylot
 .byt 255

;From the index of the found Character we multiply by 4 and use to index this table
;to get Face graphic loc and character description
SSCCharacterInfo
 .byt <NylotFaceGFX,>NylotFaceGFX,<NylotDescription,>NylotDescription


NylotFaceGFX
 .byt $7F,$78,$7F
 .byt $40,$40,$40
 .byt $7F,$62,$4F
 .byt $07,$42,$40
 .byt $7F,$42,$47
 .byt $05,$4D,$60
 .byt $7E,$62,$4B
 .byt $01,$48,$60
 .byt $7F,$47,$47
 .byt $03,$50,$50
 .byt $7E,$57,$53
 .byt $01,$48,$60
 .byt $7D,$67,$4D
 .byt $06,$42,$40
 .byt $7F,$78,$7F
NylotDescription
 .byt "Nylot is a Tribes-%"
 .byt "man and holds a%"
 .byt "wealth of local%"
 .byt "knowledge]"

