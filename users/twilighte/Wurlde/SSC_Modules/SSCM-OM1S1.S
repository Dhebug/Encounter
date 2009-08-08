;Synopsis
;1) Rising and falling Barrels on lift
;2) Water effect in river beneath bridge
;3)xStars in sky
;4)xFlag on right building


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
 .byt <EnterTextBakery,>EnterTextBakery	;C024
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
#include "inlay-om1s1.s"	;Butterflies - moat2.mem in wurlde.dsk

#include "SSC_CommonCode.s"

EnterTextBakery
;      ***********************************
 .byt "As you enter, a large rat scurries%"
 .byt "straight passed you into a nearby%"
 .byt "shadow. The Bakery is large and%"
 .byt "open and the smell of fresh bread%"
 .byt "almost takes your breath away.%"
 .byt "The noise and heat are unbearable%"
 .byt "here. Select Option or Character.]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "Sassubree used to be the stronghold%"
 .byt "of the eastern side of Wurlde. Its%"
 .byt "turbulent history only showing in%"
 .byt "some of the architecture.The bakery%"
 .byt "stands to the left and is still the%"
 .byt "best place to get bread.]"
ScreenName	;Always 13 characters long
;      *************
 .byt " OLDE BAKERY]"


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
	rts

;Called from DetectFloorAndCollisions in hero.s when the floortable(A) contains
;0,64,128,192 depending on collision(9,10,11,12)
;For M2S5 it is unused
;
;Returned
;Carry Set when move prohibited
;SCN12 - Ground window A5, Door A6
CollisionDetection
	sta CollisionFound
	clc
	rts

CollisionFound
 .byt 128


;When the hero performs a recognised action this routine is called
;ProcAction
;
;Recognised action is UP but filter only when infront of Bakery
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
	ldx #7
loop1	lda $dead,x
	ldy FortFlagSOFS,x
	sta HIRESInlayLocation+$5C4,y
	dex
	bpl loop1
.)
	rts

FortFlagSOFS
 .byt 0,1
 .byt 40,41
 .byt 80,81
 .byt 120,121
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
 .byt %01010100,%01100000
 .byt %01010111,%01110000
 .byt %01010111,%01110000
 .byt %01010010,%01010000
FortFlagFrame01
 .byt %01010101,%01000000
 .byt %01010111,%01100000
 .byt %01010111,%01100000
 .byt %01010010,%01100000
FortFlagFrame02
 .byt %01010110,%01000000
 .byt %01010111,%01100000
 .byt %01010111,%01100000
 .byt %01010101,%01000000
FortFlagFrame03
 .byt %01010101,%01000000
 .byt %01010111,%01100000
 .byt %01010111,%01100000
 .byt %01010010,%01100000
FortFlagFrame04
 .byt %01010100,%01000000
 .byt %01010111,%01100000
 .byt %01010111,%01100000
 .byt %01010001,%01000000
FortFlagFrame05
 .byt %01010100,%01010000
 .byt %01010111,%01110000
 .byt %01010111,%01100000
 .byt %01010001,%01000000
FortFlagFrame06
 .byt %01010001,%01001000
 .byt %01010111,%01111000
 .byt %01010110,%01110000
 .byt %01010100,%01000000
FortFlagFrame07
 .byt %01010010,%01000000
 .byt %01010111,%01100000
 .byt %01010111,%01110000
 .byt %01010100,%01010000


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


InteractionHeader
UltimateInteraction		.byt 6	;Number of interactions-1 (Zero based)
InteractionsTable
 .byt <Interaction0,>Interaction0
 .byt <Interaction1,>Interaction1
 .byt <Interaction2,>Interaction2
 .byt <Interaction3,>Interaction3
 .byt <Interaction4,>Interaction4
 .byt <Interaction5,>Interaction5

;Message text will always appear in bottom text window so 35 characters per line.
;required stuff,"]",Message Text,"]"
;For required stuff..
;0-31 	Only if the hero posesses the specified object will the character deliver this message
;"$"	Rumour Flag (If omitted then always treated as Interaction)
;128-143	Only the Character of specified Group will deliver this message
;144-175	Only specified Character or Characters will deliver this message
;176-207	Only if the hero posesses the specified keyword will the character deliver this message
;208-223	Only when the character is at the specified Health level will he deliver this message
;224-239  Only at the specified level of drunkedness(0-15) will the character deliver this message
;240-255	Only if the hero posesses the specified Grotes(100-1600) will the character deliver this message

;One rumour per character unless other stuff needed to posess
;The response may then contain embedded codes that correspond to those in the main memory EmbeddedText.
;These may either be ways to optimise text size or for keyword specifying.

Interaction0
 .byt 147,"$]"		;Asking Derb about rumours
 .byt 162," swore he saw a ",181," fly%over here a few moons ago.]"	;Kinda , Pit Dragon
Interaction1
 .byt 162,147,"$]"		;Asking either about rumours
;      ***********************************
 .byt "We make the finest bread here.]"
Interaction2
 .byt 162,181,"]"		;Asking Kinda about the Pit Dragon
 .byt "Yeah, it seemed to be heading for%",182,"]"			;Samson Isle
Interaction3
 .byt 147,181,"]"		;Asking Derb about the Pit Dragon
;      ***********************************
 .byt 181,"s were a sacred race of%"	;Pit Dragon
 .byt "flying creatures. They used to be%"
 .byt "called upon to scorch the wheat%"
 .byt "fields after harvest and light the%"
 .byt "great fire on ",187,"s day.%"	;Hayden
 .byt "But now they have not been seen for%"
 .byt "many winters.]"
Interaction4
 .byt 162,147,182,"]"	;Asking either about Samson Isle
 .byt "Sorry, i know little about the%island itself.]"
Interaction5
 .byt 162,147,187,"]"	;Asking either about Hayden
 .byt 187,"s day is when we burn the%"	;Hayden
 .byt "Great Fire boat on the quayside%"
 .byt "in Sassubree in honour of ",187,".]"	;Hayden
;The hero must find the fireboat and use it to get to samson isle, disgracing Sassubreeans.
Interaction6
 .byt 162,188,"]"		;Asking Kinda about the Underwurlde
;      ***********************************
 .byt "How do you know of such a place?..%"
 .byt "My brothers and sisters were taken%"
 .byt "there when i was smaller. I have%"
 .byt "not heard from them since..%"
 .byt " %"
 .byt "I do not like to be reminded of it.]"

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days

SSCCharacterList	;List of characters(0-31) present at this location (Terminated with 128)
 .byt %011+8*3	;Derb
 .byt %010+8*18	;Kinda
 .byt 255

;From the index of the found Character we multiply by 4 and use to index this table
;to get Face graphic loc and character description
SSCCharacterInfo
 .byt <DerbFaceGFX,>DerbFaceGFX,<DerbDescription,>DerbDescription
 .byt <KindaFaceGFX,>KindaFaceGFX,<KindaDescription,>KindaDescription


DerbFaceGFX
 .byt $7F,$60,$4F
 .byt $07,$5F,$70
 .byt $7F,$40,$47
 .byt $07,$5F,$70
 .byt $7E,$40,$43
 .byt $05,$7D,$78
 .byt $7C,$62,$49
 .byt $02,$48,$60
 .byt $7E,$7D,$7B
 .byt $05,$5D,$70
 .byt $7F,$58,$77
 .byt $05,$5F,$70
 .byt $7F,$6D,$6F
 .byt $05,$47,$40
 .byt $7F,$78,$7F
DerbDescription
;>>>>>>******************
 .byt "Derb the baker%"
 .byt "makes some of the%"
 .byt "finest Breads in%"
 .byt "all of Wurlde.]"

KindaFaceGFX
 .byt $7F,$60,$4F
 .byt $05,$42,$40
 .byt $7E,$43,$43
 .byt $05,$4F,$60
 .byt $7E,$42,$43
 .byt $05,$68,$60
 .byt $7E,$7A,$73
 .byt $05,$7A,$78
 .byt $7E,$77,$5B
 .byt $05,$5A,$70
 .byt $7F,$5F,$77
 .byt $05,$58,$70
 .byt $7F,$5F,$77
 .byt $05,$4F,$60
 .byt $7F,$70,$5F
KindaDescription
 .byt "Kinda helps Derb%"
 .byt "in the bakery and%"
 .byt "Rangard early in%"
 .byt "the morning]"
