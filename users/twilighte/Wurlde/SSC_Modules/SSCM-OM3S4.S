;SSCM-OM3S4.S	Right Monastery - sscmom3s4.mem ON samson.DSK
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
 .byt 5				;C01D
RecognisedAction
 .byt %00010000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector		;
 .byt <EnteringMonasteryText,>EnteringMonasteryText	;C024
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
#include "INLAY-OM3S4.s"	;

#include "SSC_CommonCode.s"
;Enter Text
EnteringMonasteryText
;      ***********************************
 .byt "The door creaks open and releases a%"
 .byt "quick stale breeze. This dank place%"
 .byt "seems dull and forboding. The great%"
 .byt "walls are adorned with strange and%"
 .byt "lude pictures of human sacrificial%"
 .byt "ceremonies. Terror fills your heart%"
 .byt "as you notice monks approaching..]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "The Monastery seems a large place.%"
 .byt "It no doubt holds an abundance of%"
 .byt "friendly monks willing to share and%"
 .byt "part with the sword you seek so%"
 .byt "dearly.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "THE MONASTERY]"



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
 .byt %111+8*20	;Prest
 .byt %111+8*27	;Munk
 .byt 255

SSCCharacterInfo
 .byt <PrestFaceGFX,>PrestFaceGFX,<PrestDescription,>PrestDescription
 .byt <MunkFaceGFX,>MunkFaceGFX,<MunkDescription,>MunkDescription

PrestFaceGFX
 .byt $7F,$70,$5F
 .byt $01,$4A,$40
 .byt $7F,$54,$67
 .byt $01,$62,$48
 .byt $7E,$5D,$73
 .byt $03,$48,$60
 .byt $7E,$5D,$73
 .byt $05,$5A,$60
 .byt $7E,$5A,$73
 .byt $05,$57,$50
 .byt $7F,$50,$57
 .byt $05,$5F,$70
 .byt $7F,$68,$6F
 .byt $05,$4F,$60
 .byt $7F,$70,$5F
PrestDescription
;>>>>>>******************
 .byt "Prest is a younger%"
 .byt "member of the monk%"
 .byt "order and is known%"
 .byt "to dabble in magic]"
MunkFaceGFX
 .byt $7F,$60,$4F
 .byt $05,$4F,$60
 .byt $7F,$5B,$77
 .byt $05,$5F,$70
 .byt $7F,$52,$57
 .byt $03,$48,$60
 .byt $7F,$4A,$67
 .byt $05,$5A,$70
 .byt $7F,$50,$57
 .byt $05,$40,$40
 .byt $7F,$67,$4F
 .byt $05,$40,$40
 .byt $7F,$60,$4F
 .byt $05,$40,$40
 .byt $7F,$68,$6F
MunkDescription
;>>>>>>******************
 .byt "Munk has been with%"
 .byt "the order for most%"
 .byt "of his life and is%"
 .byt "a fungologist.]"