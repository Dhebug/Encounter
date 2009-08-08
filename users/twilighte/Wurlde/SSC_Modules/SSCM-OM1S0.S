;Synopsis
;Sasubree Castle - Entrance to the Fort (Through portcullis)
;1)xFlags atop castle
;2)xStars in sky
;3)xSpear or flag representing fort guard or guards moving along top of castle
;4) Animation of rising portcullis if hero enters Fort.
;5) Moat water refraction.
;6)xFort window light flickers aa01(4),aa51(4),a9e1(1),a926(1),aa24(8),aa74(8)
;7) Conditional Boat(for return to Ritemoor)
;8) Rocking boat like in Ritemoor


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
 .byt 0				;C01D
RecognisedAction
 .byt %00000000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector
 .byt <EnterTextFort,>EnterTextFort	;C024
InteractionHeaderVector		;C026
 .byt <InteractionHeader,>InteractionHeader
CharacterList			;C028
 .byt <SSCCharacterList,>SSCCharacterList
CharacterInfo			;C02A
 .byt <SSCCharacterInfo,>SSCCharacterInfo
;**************************
;Collision tables(120) always exist in first memory page
ct_CeilingLevel			;C02A
 .dsb 40,128
ct_FloorLevel			;C052
 .dsb 40,128
ct_BGCollisions			;C07A
 .dsb 40,0

;Characters, Rumours, location text

ScreenInlay
#include "inlay-om1s0.s"	;Sassubree Fort - ?.mem in wurlde.dsk

#include "SSC_CommonCode.s"

EnterTextFort
;>>>>>>***********************************
 .byt "Stepping across the void you cannot%"
 .byt "help feel that some unseen eyes are%"
 .byt "watching you from the shadows. Each%"
 .byt "step seems to chill you to the bone%"
 .byt "as the Portcullis silently rises as%"
 .byt "if heaved by some hidden Goblin.%"
 .byt "The interior is just as forboding..]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "Sassubree Castle stands beside the%"
 .byt "great river Banit. Steward Tallard%"
 .byt "used to reside here but since many%"
 .byt "moons dark forces have trodden its%"
 .byt "halls vanquishing all but the most%"
 .byt "brave. Such are these dark times..]"
; .byt "and still stoke the fires within.]" Cathedral high spires

ScreenName	;Always 13 characters long
;      *************
 .byt "BANIT CASTLE]"


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
	jsr AnimateFortFlags
	jsr TwinkleStars
	jsr FlickerFortLights
	jsr GuardManage
	rts

;Called from DetectFloorAndCollisions in hero.s when ct_BGCollisions(A) contains
;any value over 4  or 0
;
;Returned
;Carry Set when move prohibited
CollisionDetection
	sta CollisionFound
	clc
	rts

CollisionFound
 .byt 128


;When the hero performs a recognised action this routine is called
;ProcAction
;
;When the hero presses up
ProcAction
	; Is collision found $A5?
	lda CollisionFound
	cmp #$A5
.(
	bne skip1
	; Is Fort gate open?
	nop
skip1	clc
.)
	rts



;********************* Animate Fort Flags ******************
FortFlagIndex	.byt 0

AnimateFortFlags
	lda FortFlagIndex
	clc
	adc #01
	and #07
	sta FortFlagIndex
	tax
	lda FortFlagFrameLo,x
.(
	sta loop1+1
	lda FortFlagFrameHi,x
	sta loop1+2
	ldx #11
loop1	lda $dead,x
	ldy FortFlagSOFS,x
	sta $A010+40*81,y
	sta $A018+40*81,y
	dex
	bpl loop1
.)
	rts

FortFlagSOFS
 .byt 0,1
 .byt 40,41
 .byt 80,81
 .byt 120,121
 .byt 160,161
 .byt 200,201
FortFlagFrameLo
 .byt <FortFlagFrame00
 .byt <FortFlagFrame01
 .byt <FortFlagFrame02
 .byt <FortFlagFrame03
 .byt <FortFlagFrame04
 .byt <FortFlagFrame05
 .byt <FortFlagFrame06
 .byt <FortFlagFrame07
FortFlagFrameHi
 .byt >FortFlagFrame00
 .byt >FortFlagFrame01
 .byt >FortFlagFrame02
 .byt >FortFlagFrame03
 .byt >FortFlagFrame04
 .byt >FortFlagFrame05
 .byt >FortFlagFrame06
 .byt >FortFlagFrame07

FortFlagFrame00
 .byt %01010010,%01000000
 .byt %01011111,%01000000
 .byt %01011111,%01000000
 .byt %01011111,%01000000
 .byt %01001001,%01000000
 .byt %01000000,%01000000
FortFlagFrame01
 .byt %01010100,%01000000
 .byt %01011110,%01000000
 .byt %01011110,%01000000
 .byt %01011110,%01000000
 .byt %01001010,%01000000
 .byt %01000000,%01000000
FortFlagFrame02
 .byt %01011000,%01000000
 .byt %01011110,%01000000
 .byt %01011110,%01000000
 .byt %01011110,%01000000
 .byt %01010100,%01000000
 .byt %01000000,%01000000
FortFlagFrame03
 .byt %01010100,%01000000
 .byt %01011110,%01000000
 .byt %01011110,%01000000
 .byt %01011110,%01000000
 .byt %01001010,%01000000
 .byt %01000000,%01000000
FortFlagFrame04
 .byt %01010000,%01000000
 .byt %01011110,%01000000
 .byt %01011110,%01000000
 .byt %01011110,%01000000
 .byt %01000100,%01000000
 .byt %01000000,%01000000
FortFlagFrame05
 .byt %01010001,%01000000
 .byt %01011111,%01000000
 .byt %01011111,%01000000
 .byt %01011110,%01000000
 .byt %01000100,%01000000
 .byt %01000000,%01000000
FortFlagFrame06
 .byt %01000100,%01100000
 .byt %01011111,%01100000
 .byt %01011111,%01100000
 .byt %01011011,%01000000
 .byt %01010000,%01000000
 .byt %01000000,%01000000
FortFlagFrame07
 .byt %01001000,%01000000
 .byt %01011110,%01000000
 .byt %01011111,%01000000
 .byt %01011111,%01000000
 .byt %01010001,%01000000
 .byt %01000000,%01000000


;**************** End of Fort Flag Code ******************

;**************** Stars in Sky *********************
TwinkleStars
.(
        	ldx #05
loop1   	lda StarLocationsLo,x
        	sta screen
        	lda StarLocationsHi,x
        	sta screen+1
        	txa
        	tay
	lda #3
	jsr game_GetRNDRange
        	tay
        	lda TwinkleColour,y
        	ldy #00
        	sta (screen),y
	iny
	lda #%01001000
        	sta (screen),y
        	dex
        	bpl loop1
.)
	rts

StarLocationsLo
 .byt <HIRESInlayLocation+5+40*1
 .byt <HIRESInlayLocation+6+40*3
 .byt <HIRESInlayLocation+10+40*14
 .byt <HIRESInlayLocation+20+40*10
 .byt <HIRESInlayLocation+15+40*2
 .byt <HIRESInlayLocation+38+40*7
StarLocationsHi
 .byt >HIRESInlayLocation+5+40*1
 .byt >HIRESInlayLocation+6+40*3
 .byt >HIRESInlayLocation+10+40*14
 .byt >HIRESInlayLocation+20+40*10
 .byt >HIRESInlayLocation+15+40*2
 .byt >HIRESInlayLocation+38+40*7
TwinkleColour
 .byt 6,3,2,7

;******************** Fort Lights *********************
FlickerFortLights
	lda #3
	jsr game_GetRNDRange
	tay
	lda FortLightInk,y
	sta temp01

	ldx #05
.(
loop1	ldy FortLightSLOCL,x
	sty screen
	ldy FortLightSLOCH,x
	sty screen+1
	ldy #00
	lda temp01
	sta (screen),y
	iny
	lda FortLightBit,x
	sta (screen),y
	dex
	bpl loop1
.)
	rts

FortLightSLOCL
 .byt <HIRESInlayLocation+$a01
 .byt <HIRESInlayLocation+$a51
 .byt <HIRESInlayLocation+$91E
 .byt <HIRESInlayLocation+$926
 .byt <HIRESInlayLocation+$a24
 .byt <HIRESInlayLocation+$a74
FortLightSLOCH
 .byt >HIRESInlayLocation+$a01
 .byt >HIRESInlayLocation+$a51
 .byt >HIRESInlayLocation+$91E
 .byt >HIRESInlayLocation+$926
 .byt >HIRESInlayLocation+$a24
 .byt >HIRESInlayLocation+$a74
FortLightBit
 .byt %01000100
 .byt %01000100
 .byt %01000001
 .byt %01000001
 .byt %01001000
 .byt %01001000
FortLightInk
 .byt 6,3,2,7


InteractionHeader
UltimateInteraction		.byt 0	;Number of interactions-1 (Zero based)
InteractionsTable
 .byt <Interaction0,>Interaction0
; .byt <Interaction1,>Interaction1
; .byt <Interaction2,>Interaction2

Interaction0
 .byt "$]"
 .byt "Oh i dunno!]"

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days

SSCCharacterList	;List of characters(0-31) present at the Market and times they are present (0-7)
 .byt %111+8*24	;Witch
 .byt 255
SSCCharacterInfo
 .byt <WitchFaceGFX,>WitchFaceGFX,<WitchDescription,>WitchDescription

WitchFaceGFX
 .byt $7D,$50,$57
 .byt $05,$45,$40
 .byt $7D,$47,$45
 .byt $05,$4F,$60
 .byt $7A,$5D,$73
 .byt $06,$48,$60
 .byt $7A,$52,$53
 .byt $05,$5A,$70
 .byt $7E,$52,$53
 .byt $05,$4D,$60
 .byt $7E,$68,$6B
 .byt $05,$47,$40
 .byt $7F,$70,$5F
 .byt $40,$40,$40
 .byt $7F,$7F,$7F
WitchDescription
 .byt "To be announced]"
 
#include "GuardsAtopCastle.s"
