;SSCM-OM2S2.S Mill - SCN14.MEM on WURLDE.DSK
;Synopsis
;1) Stars at night
;2) Crows(black) flying in a circular motion in distance.
;3) Insects (worms, snails) on ground below.
;4) Bugs or nats flying in swarm/s low in the air.
;5) The weathercock could control the wind

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
EnteringTextVector		;Nothing here
 .byt <EnterTextMill,>EnterTextMill	;C024
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
#include "inlay-om2s2.s"	;Mill - scn14.mem in wurlde.dsk

#include "SSC_CommonCode.s"
EnterTextMill
 .byt "The old mill door creaks opens and%"
 .byt "you step inside. The interior is%"
 .byt "laid out in circular platforms,each%"
 .byt "level holding sacks of flour apart%"
 .byt "from ground which is strewn great%"
 .byt "bales of hay. In one corner an old%"
 .byt "man eyes you cautiously.]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "The lowly millhouse stands on the%"
 .byt "high ground of Ritemoor, with fresh%"
 .byt "pastures encircled with old fences.%"
 .byt "The mill houses this seasons flour%"
 .byt "crop. The weathercock stands proud%"
 .byt "upon its thatched roof.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "MILL HOUSE]"


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
	clc
	rts

InteractionHeader
 .byt 2		;
 .byt <Interaction0,>Interaction0
 .byt <Interaction1,>Interaction1
 .byt <Interaction2,>Interaction2

Interaction0	;Chitchat with old Tom (Lucien posesses the Old Briar)
 .byt 20,166,"$]"
 .byt "Is that the old Briar pipe from Bog%"
 .byt "Mire? My old father used to tell me%"
 .byt "he used to puff on it down the Inn%"
 .byt "and it always kept him cold sober!%"
 .byt "I don't drink that much these days%"
 .byt "so can't vouch for it meself.%"
Interaction1	;Chitchat with Old Tom
 .byt "$]"
 .byt "The old windmill is really in great%"
 .byt "need of repair.It has stood turning%"
 .byt "kernels to flour for nigh on twenty%"
 .byt "seasons but won't last another. Me%"
 .byt "and Jiles would start if it was not%"
 .byt "for lack of grease.]"

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days
SSCCharacterList
 .byt %011+8*22	;Old Tom(Days)
 .byt 128

SSCCharacterInfo
 .byt <OldTomFaceGFX,>OldTomFaceGFX,<OldTomDescription,>OldTomDescription

OldTomFaceGFX
 .byt $7F,$78,$7F
 .byt $40,$47,$40
 .byt $7F,$5F,$77
 .byt $40,$7F,$58
 .byt $7E,$7D,$7B
 .byt $07,$48,$60
 .byt $7E,$72,$5B
 .byt $40,$57,$50
 .byt $7F,$50,$57
 .byt $40,$40,$40
 .byt $7F,$46,$47
 .byt $40,$58,$40
 .byt $7F,$58,$4F
 .byt $40,$40,$40
 .byt $7F,$78,$7F
OldTomDescription
;>>>>>>******************
 .byt "Old Tom rests his%"
 .byt "feet after a long%"
 .byt "day resting his%"
 .byt "feet.]"

