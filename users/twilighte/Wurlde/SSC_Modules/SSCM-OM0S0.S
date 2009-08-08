;SSCM-OM0S0.S	TIRN CHURCH - SCN03.MEM ON WURLDE.DSK
;1) Castle lights flickering
;2) distant village lights intermittantly switching

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
 .byt %10001000			;C01C
LocationID
 .byt 12				;C01D
RecognisedAction
 .byt %00010000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector	;Enter Boat
 .byt <EnterTextTirnChurch,>EnterTextTirnChurch	;C024
InteractionHeaderVector		;This SSC has no meeting place so 0 must be written to high address
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
#include "INLAY-OM0S0.s"	;

#include "SSC_CommonCode.s"
EnterTextTirnChurch
 .byt "As you approach the church its tall%"
 .byt "spire seems to heighten the closer%"
 .byt "you approach. Its shallow windows%"
 .byt "and wide open door beckon you like%"
 .byt "some strange devil about to swallow%"
 .byt "you whole.Beyond the threshhold the%"
 .byt "the church is dark and dank.]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "Old Tirn church was reputed to be%"
 .byt "the very first building in Wurlde.%"
 .byt "It lies on the intersection of two%"
 .byt "laylines. Old man willow though has%"
 .byt "stood since waves lashed at its%"
 .byt "roots.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "TURN CHURCH]"



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
	ldx #7
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
	;switch distant village lights AE21,AE70,AEC1   ADDE,AE2F
	jsr SwitchDistantVillageLights
	;flicker distant castle lights B308  B269,B26D
	jsr FlickerFortLights
	rts

;******************** Distant Village Lights **********
SwitchDistantVillageLights
	;Use delay of random length to switch on off each light.
	dec VillageLightPeriod
.(
	bpl skip1
	lda #255
	jsr game_GetRNDRange
	sta VillageLightPeriod
	dec VillageLightIndex	;0-4
	bpl skip2
	lda #04
	sta VillageLightIndex
skip2	ldx VillageLightIndex	;0-4
	;Now switch light
	lda VillageLightLo,x
	sta screen
	lda VillageLightHi,x
	sta screen+1
	ldy #00
	lda (screen),y
	eor #7
	sta (screen),y
skip1	rts
.)

VillageLightPeriod	.byt 32
VillageLightIndex	.byt 4
VillageLightLo
 .byt <$AE21
 .byt <$AE70
 .byt <$AEC1
 .byt <$ADDE
 .byt <$AE2F
VillageLightHi
 .byt >$AE21
 .byt >$AE70
 .byt >$AEC1
 .byt >$ADDE
 .byt >$AE2F

;******************** Fort Lights *********************
FlickerFortLights
	lda #3
	jsr game_GetRNDRange
	tay
	lda FortLightInk,y
	sta temp01

	ldx #02
.(
loop1	ldy FortLightSLOCL,x
	sty screen
	ldy FortLightSLOCH,x
	sty screen+1
	ldy #00
	lda temp01
	sta (screen),y
	dex
	bpl loop1
.)
	rts

FortLightSLOCL
 .byt <$B308
 .byt <$B269
 .byt <$B26D
FortLightSLOCH
 .byt >$B308
 .byt >$B269
 .byt >$B26D
FortLightInk
 .byt 6,3,2,7


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
;      ***********************************
 .byt "$]"
 .byt "We rarely get visitors here. Hence%"
 .byt "we rarely get rumours. Last i heard%"
 .byt "was some children getting burnt in%"
 .byt "a haystack many many moons ago.]"

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 0 Mornings
;Bit 1 Afternoons
;Bit 2 Evenings
;If all bits are clear then the character will appear on random days


SSCCharacterList
 .byt %111+8*13	;Yltendoq
 .byt %111+8*19	;Abbot
 .byt 255

SSCCharacterInfo
 .byt <YltendoqFaceGFX,>YltendoqFaceGFX,<YltendoqDescription,>YltendoqDescription
 .byt <AbbotFaceGFX,>AbbotFaceGFX,<AbbotDescription,>AbbotDescription

YltendoqFaceGFX
 .byt $7F,$70,$5F
 .byt $05,$4F,$60
 .byt $7F,$5F,$77
 .byt $05,$7F,$78
 .byt $7E,$7D,$7B
 .byt $03,$48,$60
 .byt $7C,$62,$49
 .byt $05,$5A,$70
 .byt $7F,$52,$57
 .byt $05,$47,$40
 .byt $7F,$40,$47
 .byt $01,$40,$40
 .byt $7F,$67,$4F
 .byt $01,$40,$40
 .byt $7F,$78,$7F

YltendoqDescription
 .byt "Practising Spheric%"
 .byt "and also some dark%"
 .byt "magic for good%"
 .byt "measure]"

AbbotFaceGFX
 .byt $7F,$78,$7F
 .byt $05,$47,$40
 .byt $7F,$6F,$6F
 .byt $05,$5F,$50
 .byt $7F,$5F,$77
 .byt $05,$42,$40
 .byt $7E,$52,$53
 .byt $05,$5A,$70
 .byt $7C,$57,$51
 .byt $05,$58,$70
 .byt $7F,$5F,$77
 .byt $05,$48,$60
 .byt $7F,$6F,$6F
 .byt $05,$47,$40
 .byt $7F,$78,$7F
AbbotDescription
 .byt "To be announced]"
