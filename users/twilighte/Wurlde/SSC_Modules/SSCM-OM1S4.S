;Synopsis - Kissing Widow
;1)xTwinkling of Stars in sky (A784,A799,A7F3,A7A6)
;2)xFlag on tower (3(Incs pole)x8(With borders) @ A745)
;3) Seagulls
;4)xChurch light flicker(attributes placed between inns thatched roof AAF8/AB48)
;5) Sluece gate on condition
;6) Sluece water
;7) Kissing Widow Entrance and occupants
;8)xThe Great Horn sub-game

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
 .byt 0				;C01D
RecognisedAction
 .byt %00011000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector
 .byt <EnterTextKissingWidow,>EnterTextKissingWidow	;C024
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
#include "inlay-om1s4.s"	;Butterflies - moat2.mem in wurlde.dsk

#include "SSC_CommonCode.s"
EnterTextKissingWidow
 .byt "the door creaks loudly as you enter%"
 .byt "the establishment and all goes very%"
 .byt "quiet as all occupants turn to look%"
 .byt "at you.After a time the drinkers%"
 .byt "return to their beers and you%"
 .byt "venture to the bar.%"
 .byt "Select Option or Character.]"

ScreenProse	;Up to 35x7 characters
;      ***********************************
 .byt "Sassubree is not only a market town%"
 .byt "but also a Sea port to the distant%"
 .byt "isles. The Kissing Widow Tavern is%"
 .byt "the best place to meet many of the%"
 .byt "seafarers that brave the waters for%"
 .byt "fortune or fish and the best place%"
 .byt "to seek transport across the seas.]"

ScreenName	;Always 13 characters long
;      *************
 .byt "KISSING WIDOW]"


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

#include "sg_TemplesGreatHornSearch.s"
#include "Waterline.s"

ScreenRun
	ldx SubGameStartLocation
	lda SubGameProperty,x
	and #%00000100
.(
	beq skip1
	jsr SubGame_Run
skip1	jsr ProcWaterline
	jsr ProcFlickerChurchLight
	jsr TwinkleStars
	jsr AnimateTowerFlag
.)
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
	lda KeyRegister
	cmp #kcI+kcU
.(
	beq skip1
	;Erase screen inlay
	jsr game_EraseInlay

	;Enter Bakery
	jsr game_Selector

	;Restore Screen
	jsr game_ScreenCopy

	;Return
	clc
	rts

skip1	;Is Temple in Water?
.)
	ldx SubGameStartLocation
	lda SubGameProperty,x
	and #%00000100
.(
	beq skip1
	jsr SubGame_Interact
skip1	rts
.)

;******************** Fort Lights *********************
ProcFlickerChurchLight
	lda #3
	jsr game_GetRNDRange
	tay
	lda FortLightInk,y
	sta $AAF8
	sta $AB48
	rts
FortLightInk
 .byt 6,3,2,7
 
;******************** Tower Flag **********************
TowerFlagIndex	.byt 0

AnimateTowerFlag
	lda TowerFlagIndex
	clc
	adc #01
	cmp #6
.(
	bcc skip1
	lda #0
skip1	sta TowerFlagIndex
.)
	tax
	lda TowerFlagFrameLo,x
.(
	sta loop1+1
	lda TowerFlagFrameHi,x
	sta loop1+2
	ldx #20
loop1	lda $dead,x
	ldy TowerFlagSOFS,x
	sta $A745+40,y
	dex
	bpl loop1
.)
	rts
TowerFlagSOFS
 .byt 0,1,2
 .byt 40,41,42
 .byt 80,81,82
 .byt 120,121,122
 .byt 160,161,162
 .byt 200,201,202
 .byt 240,241,242
TowerFlagFrameLo
 .byt <TowerFlagFrame00
 .byt <TowerFlagFrame01
 .byt <TowerFlagFrame02
 .byt <TowerFlagFrame03
 .byt <TowerFlagFrame04
 .byt <TowerFlagFrame05
TowerFlagFrameHi
 .byt >TowerFlagFrame00
 .byt >TowerFlagFrame01
 .byt >TowerFlagFrame02
 .byt >TowerFlagFrame03
 .byt >TowerFlagFrame04
 .byt >TowerFlagFrame05

TowerFlagFrame00
 .byt %01110000,%01000011,%01000000
 .byt %01000011,%01001111,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000011,%01111111,%01100000
 .byt %01110011,%01111100,%01100000
 .byt %01000000,%01110000,%01000000
 .byt %01110000,%01000000,%01000000
TowerFlagFrame01
 .byt %01110000,%01000001,%01100000
 .byt %01000001,%01100111,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000011,%01111111,%01100000
 .byt %01110011,%01111110,%01000000
 .byt %01000010,%01011000,%01000000
 .byt %01110000,%01000000,%01000000
TowerFlagFrame02
 .byt %01110000,%01000000,%01100000
 .byt %01000000,%01110011,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000011,%01111111,%01100000
 .byt %01110011,%01111110,%01000000
 .byt %01000001,%01001100,%01000000
 .byt %01110000,%01000000,%01000000
TowerFlagFrame03
 .byt %01110000,%01000000,%01000000
 .byt %01000010,%01011001,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000011,%01111111,%01100000
 .byt %01110011,%01111111,%01000000
 .byt %01000001,%01100110,%01000000
 .byt %01110000,%01000000,%01000000
TowerFlagFrame04
 .byt %01110010,%01000000,%01100000
 .byt %01000011,%01001101,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000011,%01111111,%01100000
 .byt %01110011,%01111111,%01000000
 .byt %01000000,%01110010,%01000000
 .byt %01110000,%01000000,%01000000
TowerFlagFrame05
 .byt %01110000,%01000000,%01000000
 .byt %01000011,%01100110,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000011,%01111111,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000000,%01011001,%01000000
 .byt %01110000,%01000000,%01000000

;**************** Stars in Sky *********************
TwinkleStars
.(
        	ldx #03
loop1   	lda #3
	jsr game_GetRNDRange
        	tay
        	lda TwinkleColour,y
        	ldy StarLocationsOffset,x
        	sta $A700,y
        	dex
        	bpl loop1
.)
	rts

StarLocationsOffset
 .byt $84
 .byt $99
 .byt $F3
 .byt $A6
TwinkleColour
 .byt 6,3,2,7

;0-31 	Only if the hero posesses the specified object will the character deliver this message
;"$"	Rumour Flag (If omitted then always treated as Interaction)
;"["	Sub Game activation Flag (Triggers the sub-game associated to the current Location)
;128-143	Only the Character of specified Group will deliver this message
;144-175	Only specified Character or Characters will deliver this message
;176-207	Only if the hero is asking about the specified keyword will the character deliver this message
;208-223	Only when the character is at the specified Health level will he deliver this message
;224-239  Only at the specified level of drunkedness(0-15) will the character deliver this message
;240-255	Only if the specified subgame is completed will the character deliver this message

;Kissing Widow Interactions
InteractionHeader
UltimateInteraction		.byt 0	;Number of interactions-1 (Zero based)
InteractionsTable
 .byt <Interaction0,>Interaction0

Interaction0
 .byt 182,"$]"		;Rumours (with keyword Samson Isle)
 .byt "A few moons ago i was sure someone%"
 .byt "said they saw a ",181," flying%"
 .byt "towards ",182,".]"


;The minimum would be..
;1 x Waterstone
;2 x Bread
;4 x Fish Stew
;6 x Fruit
;Then for Samson Isle Lucien must take
;1 x Great Horn
;And 9 other items Lucien may choose which should include some potions and a weapon

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days

SSCCharacterList	;List of characters(0-31) present at the Market and times they are present (0-7)
 .byt %111+8*5	;Barton
 .byt %111+8*6	;Keesha
 .byt %110+8*7	;Kobla(Nights)
 .byt %110+8*8	;Ribald(Nights)
 .byt %110+8*12	;Retnig
 .byt %111+8*14	;Mardon
 .byt 255
SSCCharacterInfo
 .byt <BartonFaceGFX,>BartonFaceGFX,<BartonDescription,>BartonDescription
 .byt <KeeshaFaceGFX,>KeeshaFaceGFX,<KeeshaDescription,>KeeshaDescription
 .byt <KoblaFaceGFX,>KoblaFaceGFX,<KoblaDescription,>KoblaDescription
 .byt <RibaldFaceGFX,>RibaldFaceGFX,<RibaldDescription,>RibaldDescription
 .byt <RetnigFaceGFX,>RetnigFaceGFX,<RetnigDescription,>RetnigDescription
 .byt <MardonFaceGFX,>MardonFaceGFX,<MardonDescription,>MardonDescription

BartonFaceGFX
 .byt $7F,$70,$5F
 .byt $05,$4F,$60
 .byt $7F,$5F,$77
 .byt $05,$5F,$70
 .byt $7E,$7D,$7B
 .byt $03,$48,$60
 .byt $7C,$7A,$79
 .byt $05,$5A,$78
 .byt $7E,$7A,$6B
 .byt $05,$77,$58
 .byt $7E,$60,$4F
 .byt $07,$47,$40
 .byt $7F,$4F,$67
 .byt $05,$47,$40
 .byt $7F,$58,$77
BartonDescription
 .byt "One of the oldest%"
 .byt "Innkeepers and his%"
 .byt "Fish stew is%"
 .byt "Wurlde reknowned]"

KeeshaFaceGFX
 .byt $7F,$6A,$6F
 .byt $06,$55,$50
 .byt $7F,$4A,$6B
 .byt $06,$55,$50
 .byt $7E,$68,$6B
 .byt $05,$57,$50
 .byt $7E,$5A,$73
 .byt $05,$42,$40
 .byt $7C,$5A,$71
 .byt $05,$57,$50
 .byt $7F,$58,$77
 .byt $05,$4F,$60
 .byt $7F,$6D,$6F
 .byt $05,$47,$40
 .byt $7F,$78,$7F
KeeshaDescription
 .byt "Reputed to be in%"
 .byt "love with Barton%"
 .byt "but half his age]"

KoblaFaceGFX
 .byt $7F,$78,$7F
 .byt $03,$45,$40
 .byt $7F,$4A,$67
 .byt $03,$55,$50
 .byt $7E,$5C,$6B
 .byt $03,$68,$44
 .byt $7E,$43,$73
 .byt $03,$40,$60
 .byt $7E,$42,$43
 .byt $01,$57,$54
 .byt $7F,$40,$47
 .byt $03,$47,$40
 .byt $7F,$62,$4F
 .byt $40,$40,$40
 .byt $7F,$7D,$7F
KoblaDescription
;>>>>>>******************
 .byt "Always seated with%"
 .byt "the wall behind,he%"
 .byt "monitors everyone%"
 .byt "with contempt.]"

RibaldFaceGFX
 .byt $7F,$78,$7F
 .byt $07,$47,$40
 .byt $7F,$60,$4F
 .byt $07,$5F,$70
 .byt $7F,$5D,$77
 .byt $05,$45,$40
 .byt $7E,$48,$63
 .byt $03,$42,$40
 .byt $7F,$5A,$77
 .byt $01,$47,$40
 .byt $7F,$60,$4F
 .byt $05,$44,$40
 .byt $7F,$68,$4F
 .byt $03,$40,$40
 .byt $7F,$70,$5F
RibaldDescription
;>>>>>>******************
 .byt "With beer in hand%"
 .byt "and billowing pipe%"
 .byt "this salty seaman%"
 .byt "knows no fear.]"
; .byt "Known to be Koblas%"
; .byt "ship mate, Ribald%"
; .byt "is rarely caught%"
; .byt "sober]"

MardonFaceGFX
 .byt $7F,$40,$47
 .byt $05,$47,$40
 .byt $7C,$5F,$71
 .byt $05,$77,$58
 .byt $7C,$42,$49
 .byt $03,$48,$40
 .byt $7C,$62,$49
 .byt $05,$77,$58
 .byt $7C,$77,$59
 .byt $05,$58,$70
 .byt $7D,$4F,$65
 .byt $05,$48,$60
 .byt $7C,$6F,$65
 .byt $05,$47,$40
 .byt $7D,$58,$7D
MardonDescription
 .byt "Sly and secretive,%"
 .byt "Mardon will twist%"
 .byt "the truth to meet%"
 .byt "his requirements]"

RetnigFaceGFX
 .byt $7F,$70,$5F
 .byt $05,$40,$40
 .byt $7F,$42,$47
 .byt $05,$46,$40
 .byt $7E,$5D,$73
 .byt $07,$48,$60
 .byt $7C,$62,$49
 .byt $05,$7A,$78
 .byt $7C,$5A,$71
 .byt $05,$77,$58
 .byt $7C,$58,$71
 .byt $05,$5F,$70
 .byt $7F,$68,$6F
 .byt $05,$4F,$60
 .byt $7F,$70,$5F

RetnigDescription
 .byt "Retnig is known%"
 .byt "to enjoy the%"
 .byt "company of men%"
 .byt "rather than women]"

 .bss
#include "..\playerfile\playerfile.s"
