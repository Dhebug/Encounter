;Synopsis - Pirates Arms

;1) Distant light house rotating beam
;2) Stars in sky
;3) Flickering church light


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
 .byt 1				;C01D
RecognisedAction
 .byt %00010000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector
 .byt <EnterTextPiratesArms,>EnterTextPiratesArms	;C024
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
#include "inlay-om1s2.s"	;Butterflies - moat2.mem in wurlde.dsk

#include "SSC_CommonCode.s"
EnterTextPiratesArms
 .byt "The musty smell of pipe tobacco%"
 .byt "and other strange aromas hit your%"
 .byt "nostrils as you enter the Pirates%"
 .byt "Arms Inn. Food, Beer, Lodging and%"
 .byt "new friends can all be found here.%"
 .byt "The perfect rest for a weary journ-%"
 .byt "eyman. Select Option or Character.]"
ScreenProse	;Up to 35x7 characters
;      ***********************************
 .byt "Sassubree is home to many%"
 .byt "interesting places.The Pirates Arms%"
 .byt "is one of the best drinking houses%"
 .byt "to meet new faces. The town stocks%"
 .byt "are also here. Mind you don't drink%"
 .byt "too much otherwise you may wake up%"
 .byt "to find yourself in them.]"
ScreenName	;Always 13 characters long
;      *************
 .byt " PIRATES ARMS]"




;**************************************
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
;On collision detected, the hero xpos dictates the entrance.
;Possible entrances are..
;Xr Location
;1 Pirates Arms
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

;************************* Interactions ***********************
InteractionHeader
UltimateInteraction		.byt 11	;Number of interactions-1 (Zero based)
InteractionsTable
 .byt <Interaction0,>Interaction0
 .byt <Interaction1,>Interaction1
 .byt <Interaction2,>Interaction2
 .byt <Interaction3,>Interaction3
 .byt <Interaction4,>Interaction4
 .byt <Interaction5,>Interaction5
 .byt <Interaction6,>Interaction6
 .byt <Interaction7,>Interaction7
 .byt <Interaction8,>Interaction8
 .byt <Interaction9,>Interaction9
 .byt <Interaction10,>Interaction10
 .byt <Interaction11,>Interaction11

;Message text will always appear in bottom text window so 35 characters per line.
;required stuff,"]",Message Text,"]"
;For required stuff..
;0-31 	Only if the hero posesses the specified object will the character deliver this message
;"$"	Rumour Flag (If omitted then always treated as Interaction)
;128-143	Only the Character of specified Group will deliver this message
;144-175	Only specified Character or Characters will deliver this message
;176-207	Only if the hero is asking about the specified keyword will the character deliver this message
;208-223	Only when the character is at the specified Health level will he deliver this message
;224-239  Only at the specified level of drunkedness(0-15) will the character deliver this message
;240-255	Only if the hero posesses the specified Grotes(100-1600) will the character deliver this message

;One rumour per character unless other stuff needed to posess
;The response may then contain embedded codes that correspond to those in the main memory EmbeddedText.
;These may either be ways to optimise text size or for keyword specifying.

Interaction0
 .byt 182,"$]"		;Rumours (with keyword Samson Isle)
 .byt "A few moons ago i was sure someone%"
 .byt "said they saw a ",181," flying%"
 .byt "towards ",182,".]"
Interaction1
 .byt 156,"$]"		;Rumour from Retnig
 .byt "I have not seen you here before and%"
 .byt "yet you speak our same tongue, %"
 .byt "though your accent is very strange.%"
 .byt "I hear many rumours but prefer to%"
 .byt "share them in private. If you show%"
 .byt "me your rumours,i'll show you mine!]"
Interaction2
 .byt "$]"		;Rumour to anyone
 .byt "I hear we are due some rain soon.]"
Interaction3
 .byt 146,187,"]"		;Asking Lief about Hayden
;      ***********************************
 .byt "Many,many summers ago children from%"
 .byt "all abouts used to play in the mill%"
 .byt "and barns,building great structures%"
 .byt "from the bales.One day a spark fell%"
 .byt "and lit the tinder, burning all the%"
 .byt "children alive. No child survived..%"
 .byt "But Hay Dens day remembers them.]"
Interaction4
 .byt 156,181,"]"		;Asking Retnig about Pit Dragon
 .byt "The Pit Dragon used to be summoned%"
 .byt "with a ",189,". This was lost a%"
 .byt "few winters back and is now thought%"
 .byt "to lie at the bottom of the silvery%"
 .byt "sea.Though some still claim to hear%"
 .byt "it somewhere along the quayside.]"
Interaction5
 .byt 181,"]"		;Asking anyone about the Pit Dragon
 .byt "Pit Dragons are sacred beasts and%"
 .byt "anyone who enslaves them should be%"
 .byt "banished to the ",188,".]"
Interaction6	;When keggs is asked about "Hayden" at kissing widow
 .byt 187,154,"]"
 .byt "Many seasons ago i laboured on land%"
 .byt "as a farmer. Back then my wife used%"
 .byt "to smoke an ",190," which was%"
 .byt "the source of most arguments.%"
 .byt "On one such occasion, i threw that%"
 .byt "pipe out the window not realising a%"
 .byt "spark would light the ",191,".]"
Interaction7	;When Keggs is asked about "STRAW BEYOND" at kissing widow
 .byt 191,154,"]"
 .byt "I didn't know children were playing%"
 .byt "in the shed. They should have known%"
 .byt "better! Both me and ",192," raced to%"
 .byt "try and save them, but my wife was%"
 .byt "caught in the blaze. I escaped but%"
 .byt "only just in time as the whole barn%"
 .byt "collapsed in on itself crushing all]"
Interaction8	;When Keggs is asked about "Perga" at kissing widow
;      ***********************************
 .byt 192,154,"]"
 .byt "I found her the following day lying%"
 .byt "in the wreckage and carried her to%"
 .byt "the sea shore where she now rests.%"
 .byt "When i finally returned to clear up%"
 .byt "the wreckage heavy rain had churned%"
 .byt "the old ruin into a sodden heap and%"
 .byt "to this day a wretched ",193,".]"
;
Interaction9	;When keggs is asked about "BOGMIRE" at kissing widow
 .byt 193,154,"]["	;This triggers Pergas Grave subgame and temp removes Keggs from pub
 .byt "A treachorous place that is best to%"
 .byt "avoid. I tried to find the old pipe%"
 .byt "since i had vowed to Perga that she%"
 .byt "would lay to rest with it.But every%"
 .byt "attempt was in vein as i sank to my%"
 .byt "waist in the blackest tar,and a few%"
 .byt "steps further would have taken me!]"
;When keggs is asked about Bogmire the second time (after pergas grave subgame has been completed)
 .byt "I don't know how you did it but you%"
 .byt "gave my wife the one thing i had%"
 .byt "vowed she would have before i died.]"
;When Lucien finds the pipe he goes to the seashore, locates the unmarked grave
;and drops the pipe their. A ghostly apparition will be seen.. This triggers Perga to pay keggs a visit.
;      ***********************************
Interaction10	;When keggs is asked about samson isle (and subgame Pergas pipe is completed) at kissing widow
 .byt 182,154,240,"]"
 .byt "I had a dream last night,or perhaps%"
 .byt "even a vision. Perga came to me and%"
 .byt "told me your good deed.She urged me%"
 .byt "to give my life to you and if i do%"
 .byt "this she will forgive me. I posess%"
 .byt "a boat that can take us both to the%"
 .byt "island.We will need ",194," though]"
Interaction11	;When keggs is asked about "supplies" at kissing widow
;      ***********************************
 .byt 194,154,"]"
 .byt "I can provide the boat and will buy%"
 .byt "the rigging needed to make the boat%"
 .byt "seaworthy. However i will need from%"
 .byt "you fresh water,two loaves of Bread%"
 .byt "four of Barton's best fish stew and%"
 .byt "six rations of Fruit. Put the cargo%"
 .byt "on the jetty near my boat then wait]"

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days

SSCCharacterList	;List of characters(0-31) present at the Pirates Arms and times they are present (0-7)
 .byt %111+8*1	;Drummond
 .byt %111+8*2	;Lief
 .byt %100+8*9	;Rangard
 .byt %110+8*12	;Retnig
 .byt %110+8*17	;Tallard
 .byt %100+8*10	;Keggs(Evenings)
 .byt 255

;From the index of the found Character we multiply by 4 and use to index this table
;to get Face graphic loc and character description
SSCCharacterInfo
 .byt <DrummondFaceGFX,>DrummondFaceGFX,<DrummondDescription,>DrummondDescription
 .byt <LiefFaceGFX,>LiefFaceGFX,<LiefDescription,>LiefDescription
 .byt <RangardFaceGFX,>RangardFaceGFX,<RangardDescription,>RangardDescription
 .byt <RetnigFaceGFX,>RetnigFaceGFX,<RetnigDescription,>RetnigDescription
 .byt <TallardFaceGFX,>TallardFaceGFX,<TallardDescription,>TallardDescription
 .byt <KeggsFaceGFX,>KeggsFaceGFX,<KeggsDescription,>KeggsDescription


DrummondFaceGFX	;2 of 32
 .byt $7F,$78,$7F
 .byt $05,$45,$40
 .byt $7F,$62,$4F
 .byt $05,$50,$50
 .byt $7F,$40,$47
 .byt $01,$4D,$60
 .byt $7E,$62,$4B
 .byt $05,$48,$60
 .byt $7F,$42,$47
 .byt $01,$52,$50
 .byt $7F,$40,$47
 .byt $05,$4D,$60
 .byt $7F,$60,$4F
 .byt $01,$42,$40
 .byt $7F,$78,$7F
DrummondDescription
 .byt "Reknowned for his%"
 .byt "strong morals and%"
 .byt "strict tea total%"
 .byt "attitude]"

LiefFaceGFX	;8 of 32
 .byt $7F,$78,$7F
 .byt $05,$40,$40
 .byt $7F,$40,$47
 .byt $05,$43,$40
 .byt $7E,$47,$43
 .byt $05,$4D,$60
 .byt $7E,$42,$43
 .byt $05,$4D,$60
 .byt $7E,$4D,$6B
 .byt $05,$4F,$60
 .byt $7E,$65,$4B
 .byt $05,$47,$40
 .byt $7E,$68,$6F
 .byt $40,$40,$40
 .byt $7F,$7F,$7F
LiefDescription
 .byt "A barmaid as well%"
 .byt "as the wife of%"
 .byt "Drummond. Known to%"
 .byt "follow witchcraft]"

RangardFaceGFX	;7 of 32
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

RetnigFaceGFX	;He has the face of Ratboy (may need to change)
 .byt $7F,$78,$7F
 .byt $05,$47,$40
 .byt $7F,$5F,$73
 .byt $05,$7F,$78
 .byt $7E,$7F,$5B
 .byt $05,$5D,$70
 .byt $7E,$72,$5B
 .byt $03,$48,$60
 .byt $7E,$62,$4B
 .byt $05,$77,$58
 .byt $7F,$5A,$77
 .byt $05,$5D,$70
 .byt $7F,$68,$6F
 .byt $05,$47,$40
 .byt $7F,$78,$7F
RetnigDescription
;>>>>>>******************
 .byt "Retnig is known%"
 .byt "to enjoy the%"
 .byt "company of men%"
 .byt "rather than women]"
TallardFaceGFX
 .byt $7F,$6A,$6F
 .byt $05,$45,$40
 .byt $7E,$60,$4B
 .byt $05,$57,$50
 .byt $7F,$40,$47
 .byt $03,$5D,$70
 .byt $7E,$42,$43
 .byt $05,$48,$60
 .byt $7E,$62,$4B
 .byt $01,$77,$58
 .byt $7F,$42,$47
 .byt $04,$40,$40
 .byt $7F,$67,$4F
 .byt $04,$40,$40
 .byt $7F,$78,$7F
TallardDescription
 .byt "Steward of this%"
 .byt "area and known to%"
 .byt "have a unsettled%"
 .byt "grudge on Kobla]"

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
;>>>>>>******************
 .byt "Whilst his face is%"
 .byt "wisened,his body's%"
 .byt "bent and frail and%"
 .byt "he sits alone.]"
; .byt "Salt of the earth%"
; .byt "Fisherman who has%"
; .byt "earnt the love of%"
; .byt "many a maiden]"
