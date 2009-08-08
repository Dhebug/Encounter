;Synopsis - Market Square
;1) Stars in sky
;2) Flickering castle lights


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
 .byt 2				;C01D
RecognisedAction
 .byt %00010000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector
 .byt <EnterTextMarket,>EnterTextMarket	;C024
InteractionHeaderVector	;This SSC has no meeting place so 0 must be written to high address
 .byt <InteractionHeader,>InteractionHeader	;C026
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
#include "inlay-om1s3.s"	;Butterflies - moat2.mem in wurlde.dsk

#include "SSC_CommonCode.s"
EnterTextMarket
 .byt "You enter the busy market. Stalls%"
 .byt "heavily laiden with goods from all%"
 .byt "over Wurlde lie in the central%"
 .byt "courtyard. At each stall stands a%"
 .byt "tradesman ready to buy or sell.%"
 .byt "Select Option or Character.]"
ScreenProse	;Up to 35x7 characters
;      ***********************************
 .byt "The Market is still a bustling%"
 .byt "and busy place in these hard times.%"
 .byt "However it is only open during day-%"
 .byt "light hours. The best bargains are%"
 .byt "had late in the day. The Market%"
 .byt "sells everything from Fish to%"
 .byt "Artifacts.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "MARKET SQUARE]"


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

ScreenRun
	jsr LevelRun
	rts

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
	;Erase screen inlay
	jsr game_EraseInlay

	;Enter Bakery
	jsr game_Selector

	;Restore Screen
	jsr game_ScreenCopy

	;Return
	clc
	rts


LevelRun
	rts

InteractionHeader
 .byt 1	;
 .byt <Interaction0,>Interaction0
 .byt <Interaction1,>Interaction1

Interaction0
 .byt 173,"$]"	;Asking Rumours from Triffith
;      ***********************************
 .byt "Business has dropped alot over the%"
 .byt "last season. I am forbidden to make%"
 .byt "swords and only permitted to forge%"
 .byt "weapons if they are to hunt animals%"
 .byt "with.I have recently started making%"
 .byt "bird cages but doubt even that will%"
 .byt "last long.]"
Interaction1
 .byt "$]"
 .byt "Oh i dunno!]"

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days

SSCCharacterList	;List of characters(0-31) present at the Market and times they are present (0-7)
 .byt %111+8*4	;Jumbee			Cobbler
 .byt %111+8*11	;Milo			Carpenter
 .byt %000+8*23	;Merideth(Random Day)	Antiquary
 .byt %000+8*29	;Triffith(Random Day)	Ironsmith
 .byt %000+8*30	;Callum(Random Day)		Grocer
 .byt %001+8*28	;Rotfilsh(Mornings)		Fishmonger
 .byt 255

SSCCharacterInfo
 .byt <JumbeeFaceGFX,>JumbeeFaceGFX,<JumbeeDescription,>JumbeeDescription
 .byt <MiloFaceGFX,>MiloFaceGFX,<MiloDescription,>MiloDescription
 .byt <MeridethFaceGFX,>MeridethFaceGFX,<MeridethDescription,>MeridethDescription
 .byt <TriffithFaceGFX,>TriffithFaceGFX,<TriffithDescription,>TriffithDescription
 .byt <CallumFaceGFX,>CallumFaceGFX,<CallumDescription,>CallumDescription
 .byt <RotFilshFaceGFX,>RotFilshFaceGFX,<RotFilshDescription,>RotFilshDescription

JumbeeFaceGFX
 .byt $7F,$78,$7F
 .byt $40,$40,$40
 .byt $7F,$60,$4F
 .byt $05,$47,$40
 .byt $7E,$5D,$73
 .byt $03,$48,$60
 .byt $7E,$52,$53
 .byt $05,$5A,$70
 .byt $7F,$5A,$77
 .byt $01,$47,$40
 .byt $7F,$68,$6F
 .byt $01,$4F,$60
 .byt $7F,$70,$5F
 .byt $05,$47,$40
 .byt $7F,$78,$7F
JumbeeDescription
 .byt "Jumbee mends shoes%"
 .byt "and posesses quite%"
 .byt "a large collection%"
 .byt "of foot garments]"


MiloFaceGFX
 .byt $7F,$70,$4F
 .byt $05,$40,$40
 .byt $7F,$60,$47
 .byt $05,$47,$60
 .byt $7F,$5F,$73
 .byt $05,$52,$50
 .byt $7F,$5A,$73
 .byt $05,$57,$50
 .byt $7F,$57,$53
 .byt $05,$58,$70
 .byt $7F,$5F,$73
 .byt $05,$48,$60
 .byt $7F,$6F,$6B
 .byt $05,$47,$40
 .byt $7F,$78,$7F
MiloDescription
;>>>>>>******************
 .byt "Milo is Sassubrees%"
 .byt "carpenter.]"

MeridethFaceGFX	;14 of 32 in charfaces.hrs on wurlde.dsk 
 .byt $7E,$7F,$7B
 .byt $07,$7F,$78
 .byt $7F,$40,$43
 .byt $05,$7F,$78
 .byt $7E,$7D,$7B
 .byt $03,$48,$60
 .byt $7E,$52,$53
 .byt $05,$7A,$78
 .byt $7F,$52,$57
 .byt $05,$47,$40
 .byt $7F,$58,$77
 .byt $05,$4F,$60
 .byt $7F,$60,$4F
 .byt $05,$47,$40
 .byt $7F,$70,$5F
MeridethDescription
 .byt "The Talisman holds%"
 .byt "the key to fortune%"
 .byt "through rune stone%"
 .byt "and Old law]"

TriffithFaceGFX	;32 of 32 in charfaces.hrs on wurlde.dsk
 .byt $7F,$40,$47
 .byt $40,$40,$40
 .byt $7E,$40,$43
 .byt $05,$4F,$60
 .byt $7E,$5D,$73
 .byt $05,$42,$40
 .byt $7E,$5A,$73
 .byt $05,$5A,$70
 .byt $7E,$57,$53
 .byt $05,$58,$70
 .byt $7E,$5F,$73
 .byt $05,$48,$60
 .byt $7F,$6F,$6F
 .byt $05,$47,$40
 .byt $7F,$78,$7F
TriffithDescription
 .byt "I travel near and%"
 .byt "far to trade only%"
 .byt "the finest items%"
 .byt "at best prices.]"

CallumFaceGFX	;31 of 32 in charfaces.hrs on wurlde.dsk
 .byt $7F,$70,$5F
 .byt $05,$40,$40
 .byt $7F,$41,$67
 .byt $05,$47,$60
 .byt $7E,$5F,$73
 .byt $05,$52,$50
 .byt $7E,$5A,$73
 .byt $05,$57,$50
 .byt $7F,$58,$77
 .byt $05,$5F,$70
 .byt $7F,$58,$77
 .byt $05,$4F,$60
 .byt $7F,$50,$57
 .byt $05,$40,$40
 .byt $7F,$7F,$7F
CallumDescription
 .byt "Duncel Callum is%"
 .byt "one of only a few%"
 .byt "dealers remaining%"
 .byt "selling weaponry.]"

RotFilshFaceGFX	;
 .byt $7F,$70,$5F
 .byt $05,$40,$40
 .byt $7F,$42,$47
 .byt $05,$46,$40
 .byt $7E,$5D,$73
 .byt $07,$48,$60
 .byt $7C,$62,$49
 .byt $05,$7A,$78
 .byt $7C,$5A,$71
 .byt $05,$67,$48
 .byt $7D,$58,$75
 .byt $05,$5F,$70
 .byt $7F,$68,$6F
 .byt $05,$4F,$60
 .byt $7F,$70,$5F



RotFilshDescription
 .byt "Rotfilsh is the%"
 .byt "local fishmonger.]"
