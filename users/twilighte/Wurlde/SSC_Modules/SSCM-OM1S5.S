;Synopsis - Fishy Plaice
;1) Dim light in distant castle light house
;2) Seagulls
;3) Fishmongers stalls
;4) Sea Water effect
;5) Stars in sky
;6) Moored boats on conditions
;7) Rising and falling Waterline
;8) The Great Horn sub-game


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
 .byt 14				;C01D
RecognisedAction
 .byt %00011000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector
 .byt <EnterTextAlcove,>EnterTextAlcove	;C024
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
#include "inlay-om1s5.s"	;Butterflies - moat2.mem in wurlde.dsk

#include "SSC_CommonCode.s"
EnterTextAlcove
;      ***********************************
 .byt "At first light, in an alcove beyond%"
 .byt "the arch lyes crates of the days%"
 .byt "catch (Kept out of the weather and%"
 .byt "waiting to be hauled to market).%"
 .byt "The Fisherman stand aside a great%"
 .byt "trough sorting Glant from haul.%"
 .byt "There work is hard and relentless.]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "Waves crash against the stone jetty%"
 .byt "and salty air parch Luciens lips.%"
 .byt "Early in the morning these crates%"
 .byt "are brimming full of fish fresh%"
 .byt "from the new days catch. Catch a%"
 .byt "local fisherman here and you may%"
 .byt "get a better deal than the Market.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "FISHY PLAICE]"

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

ScreenRun
	jsr GenerateWaves
	; Is Temple in the water?
	ldx LocationID
	lda SubGameProperty,x
	and #%00000100
.(
	beq skip1
	jsr SubGame_Run

skip1	jsr ProcWaterline
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
;ProcAction - However because both Up and ItemUp trigger this
;             event we need to branch on KeyRegister.
;             Note - We can rely on KeyRegister because it is not
;                    Interrupt driven but called each game cycle.
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
	ldx LocationID
	lda SubGameProperty,x
	and #%00000100
.(
	beq skip1
	jsr SubGame_Interact
skip1	rts
.)

LevelWaveHorizonWidth	.byt 14
LevelWaveHorizonLeft	.byt 26
LevelWaveHorizonHeight	.byt 11
LevelWaveHorizonDown	.byt 33

#include "WaveEngine.s"
#include "Waterline.s"

InteractionHeader
UltimateInteraction		.byt 5	;Number of interactions-1 (Zero based)
InteractionsTable
 .byt <Interaction0,>Interaction0
 .byt <Interaction1,>Interaction1
 .byt <Interaction2,>Interaction2
 .byt <Interaction3,>Interaction3
 .byt <Interaction4,>Interaction4
 .byt <Interaction5,>Interaction5

;0-31 	Only if the hero posesses the specified object will the character deliver this message
;"$"	Rumour Flag (If omitted then always treated as Interaction)
;"["	Sub Game activation Flag (Triggers the sub-game associated to the current Location)
;128-143	Only the Character of specified Group will deliver this message
;144-175	Only specified Character or Characters will deliver this message
;176-207	Only if the hero is asking about the specified keyword will the character deliver this message
;208-223	Only when the character is at the specified Health level will he deliver this message
;224-239  Only at the specified level of drunkedness(0-15) will the character deliver this message
;240-255	Only if the hero posesses the specified Grotes(100-1600) will the character deliver this message

;One rumour per character unless other stuff needed to posess
;The response may then contain embedded codes that correspond to those in the main memory EmbeddedText.
;These may either be ways to optimise text size or for keyword specifying.
;Need flag to indicate when to stop displaying a message if a subgame has completed.

Interaction0
;      ***********************************
 .byt 182,"$]"		;Rumours (with keyword Samson Isle)
 .byt "We fished over their some days ago%"
 .byt "but the swell kept our distance.%"
 .byt "Such storms would take a seadragon%"
 .byt "to reach Samson Isle.]"
Interaction1
 .byt 162,"$]"		;Rumour from Retnig
 .byt "Sometimes we find shiny things in%"
 .byt "out nets. These things we sell to%"
 .byt "Triffith and Callum in the market.%"
 .byt "Some days these things earn us more%"
 .byt "grotes than the days catch!]"
Interaction2
 .byt "$]"
 .byt "I've never known a night like it!%"
 .byt "Seems the more we lay our nets the%"
 .byt "less we catch and the greater the%"
 .byt "storm.]"
;Need to add flag to change from hero posessing keyword to hero asking about keyword
Interaction3		;When asking Rangard about Hayden (Specifically at fishy plaice)
 .byt 153,162,187,"]"
 .byt "Speaking in a low voice but totally
 .byt "ignoring you, Rangard replies 'You
 .byt "would be wise not to mention Hay...%"
 .byt "ahem.. that word here.']"
Interaction4		;When asking Keggs about Hayden (Specifically at fishy plaice)
 .byt 154,187,"]"
;      ***********************************
 .byt "Taking you to one side and speaking%"
 .byt "in a low voice, Keggs says 'I would%"
 .byt "usually hurt anyone who so mentions%"
 .byt "it but i think now now it is better%"
 .byt "to know the truth than to be told a%"
 .byt "lie.So meet me later in the Pirates%"
 .byt "arms and we'll talk more'.]"
Interaction5
 .byt 160,189,"]["		;Asking Temple about the great horn (Triggers subgame)
;      ***********************************
 .byt "Ummm.. yes other people have talked%"
 .byt "about it and have even heard it but%"
 .byt "not me.I like swimming though so if%"
 .byt "you run to the spot where you think%"
 .byt "it is and crouch down i'll swim to%"
 .byt "you and look around that spot.]"
;If the subgame (which the above triggers) has already been played and is not repeatable then
;text following the last ] is displayed.
 .byt "We already found the horn, don't%"
 .byt "you remember?]"
;[ Triggers 'Temples great horn search' which acts upon all 3 screens of the Harbour (OM1S4 to S6)

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days


SSCCharacterList	;List of characters(0-31) present at the Market and times they are present (0-7)
 .byt %001+8*9	;Rangard(Mornings)
 .byt %001+8*10	;Keggs(Mornings)
 .byt %001+8*18	;Kinda (Mornings)
 .byt %011+8*16	;Temple (Daytime)
 .byt 255
SSCCharacterInfo
 .byt <RangardFaceGFX,>RangardFaceGFX,<RangardDescription,>RangardDescription
 .byt <KeggsFaceGFX,>KeggsFaceGFX,<KeggsDescription,>KeggsDescription
 .byt <KindaFaceGFX,>KindaFaceGFX,<KindaDescription,>KindaDescription
 .byt <TempleFaceGFX,>TempleFaceGFX,<TempleDescription,>TempleDescription


RangardFaceGFX
 .byt $7F,$70,$5F
 .byt $04,$4C,$40
 .byt $7F,$40,$47
 .byt $04,$50,$60
 .byt $7E,$40,$43
 .byt $05,$4D,$60
 .byt $7E,$62,$4B
 .byt $07,$48,$60
 .byt $7F,$42,$47
 .byt $01,$52,$50
 .byt $7F,$47,$47
 .byt $05,$40,$40
 .byt $7F,$60,$4F
 .byt $05,$47,$40
 .byt $7F,$68,$6F
RangardDescription
 .byt "Stern and strong,%"
 .byt "Rangard will not%"
 .byt "suffer fools%"
 .byt "gladly]"

KeggsFaceGFX
 .byt $7F,$78,$7F
 .byt $05,$47,$40
 .byt $7F,$5F,$77
 .byt $05,$7F,$78
 .byt $7E,$7D,$7B
 .byt $02,$48,$60
 .byt $7C,$62,$49
 .byt $05,$5A,$70
 .byt $7E,$62,$4B
 .byt $07,$4D,$60
 .byt $7F,$42,$47
 .byt $07,$50,$50
 .byt $7F,$67,$4F
 .byt $05,$4F,$60
 .byt $7F,$70,$5F
KeggsDescription
 .byt "Salt of the earth%"
 .byt "Fisherman who has%"
 .byt "earnt the love of%"
 .byt "many a maiden]"

KindaFaceGFX
 .byt $7F,$78,$7F
 .byt $05,$47,$40
 .byt $7F,$6B,$6F
 .byt $05,$5F,$70
 .byt $7F,$52,$57
 .byt $05,$5A,$70
 .byt $7F,$57,$57
 .byt $05,$58,$70
 .byt $7F,$5F,$77
 .byt $05,$5F,$70
 .byt $7F,$68,$6F
 .byt $05,$4F,$60
 .byt $7F,$77,$5F
 .byt $05,$40,$40
 .byt $7F,$7F,$7F


KindaDescription
 .byt "Kinda helps Derb%"
 .byt "in the bakery and%"
 .byt "Rangard early in%"
 .byt "the morning]"

TempleFaceGFX	;29 of 32 in charfaces.hrs on wurlde.dsk 
 .byt $7F,$78,$7F
 .byt $04,$45,$40
 .byt $7F,$60,$4F
 .byt $04,$4A,$60
 .byt $7F,$40,$47
 .byt $05,$5F,$70
 .byt $7F,$52,$57
 .byt $05,$5A,$70
 .byt $7F,$5D,$77
 .byt $05,$5A,$70
 .byt $7F,$6D,$6F
 .byt $05,$4F,$60
 .byt $7F,$68,$6F
 .byt $05,$47,$40
 .byt $7F,$68,$6F

TempleDescription
;>>>>>>******************
 .byt "Temple is Barton's%"
 .byt "son and is usually%"
 .byt "playing with Kinda%"
 .byt "or swimming nearby]"

 .bss
#include "..\playerfile\playerfile.s"
