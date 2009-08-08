;SSCM-OM2S6 - Shore with All-Fruit Tree
;First screen in game.

;At start the ground is full of black birds nesting next to the shore and feeding on the
;grass. The hero lies on the sand inert. When the player hits any movement key the hero
;will stir and rise to stand. As he does so the birds will take to flight and fly off
;into the distance and left.
;There is the slight possibility the hero has just enough time to capture a bird.

;Yet to do..
;1)>Waves animation, the water lapping at the heroes inert body and continueing after he has risen
;   or reentered the screen.
;2)>Black Birds on the sand dune.

;All-Fruit Tree
;Synopsis When the hero uses the action key infront of the tree he shakes the trunk which
;	  in turn shakes the branches and knocks fruit from it which fall to the ground.
;1) Using the Action key over trunk initiates Tree shaking and triggers Fruit Falling event
;2) Using Item Key over falling fruit triggers fruit to be pocketed

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
 .byt %10000100			;C01C
LocationID
 .byt 7				;C01D
RecognisedAction
 .byt %00000011			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector		;Nothing here
 .byt 0,0				;C024
InteractionHeaderVector	;This SSC has no meeting place so 0 must be written to high address
 .byt 0,0				;C026
CharacterList			;
 .byt 0,0				;C028
CharacterInfo
 .byt 0,0				;C02A
;**************************
;Collision tables(120) always exist in first page of C000
ct_CeilingLevel
 .dsb 40,128
ct_FloorLevel
 .dsb 40,128
ct_BGCollisions
 .dsb 40,0

ScreenInlay
#include "INLAY-OM2S6.S"	;Shore - scn71.mem in wurlde.dsk

#include "SSC_CommonCode.s"
ScreenProse
;      ***********************************
 .byt "Tired out and worn, Lucien rises on%"
 .byt "a strange foreign shore.His boat is%"
 .byt "all but destroyed on distant rocks.%"
 .byt "His posessions are all gone, only%"
 .byt "the clothes on his back remain..%"
 .byt "The hunger gradually returns as he%"
 .byt "slumps towards a great fruit tree.]"
  
ScreenName	;Always 13 characters long
 .byt "THE SEA SHORE]"

FruitFallFlag	.byt 0
ShakingTreeFlag	.byt 0

ScreenMask
#include "M02S06_TreeMask.s"

ssc_SYLocl
 .byt <$a730
 .byt <$a730+80*1
 .byt <$a730+80*2
 .byt <$a730+80*3
 .byt <$a730+80*4
 .byt <$a730+80*5
 .byt <$a730+80*6
 .byt <$a730+80*7
 .byt <$a730+80*8
 .byt <$a730+80*9
 .byt <$a730+80*10
 .byt <$a730+80*11
 .byt <$a730+80*12
 .byt <$a730+80*13
 .byt <$a730+80*14
 .byt <$a730+80*15
 .byt <$a730+80*16
 .byt <$a730+80*17
 .byt <$a730+80*18
 .byt <$a730+80*19
 .byt <$a730+80*20
 .byt <$a730+80*21
 .byt <$a730+80*22
 .byt <$a730+80*23
 .byt <$a730+80*24
 .byt <$a730+80*25
 .byt <$a730+80*26
 .byt <$a730+80*27
 .byt <$a730+80*28
 .byt <$a730+80*29
 .byt <$a730+80*30
 .byt <$a730+80*31
 .byt <$a730+80*32
 .byt <$a730+80*33
 .byt <$a730+80*34
 .byt <$a730+80*35
 .byt <$a730+80*36
 .byt <$a730+80*37
 .byt <$a730+80*38
 .byt <$a730+80*39
 .byt <$a730+80*40
 .byt <$a730+80*41
 .byt <$a730+80*42
 .byt <$a730+80*43
 .byt <$a730+80*44
 .byt <$a730+80*45
 .byt <$a730+80*46
 .byt <$a730+80*47
 .byt <$a730+80*48
 .byt <$a730+80*49
 .byt <$a730+80*50
 .byt <$a730+80*51
 .byt <$a730+80*52
 .byt <$a730+80*53
 .byt <$a730+80*54
 .byt <$a730+80*55
 .byt <$a730+80*56
 .byt <$a730+80*57
 .byt <$a730+80*58
 .byt <$a730+80*59
ssc_SYLoch
 .byt >$a730
 .byt >$a730+80*1
 .byt >$a730+80*2
 .byt >$a730+80*3
 .byt >$a730+80*4
 .byt >$a730+80*5
 .byt >$a730+80*6
 .byt >$a730+80*7
 .byt >$a730+80*8
 .byt >$a730+80*9
 .byt >$a730+80*10
 .byt >$a730+80*11
 .byt >$a730+80*12
 .byt >$a730+80*13
 .byt >$a730+80*14
 .byt >$a730+80*15
 .byt >$a730+80*16
 .byt >$a730+80*17
 .byt >$a730+80*18
 .byt >$a730+80*19
 .byt >$a730+80*20
 .byt >$a730+80*21
 .byt >$a730+80*22
 .byt >$a730+80*23
 .byt >$a730+80*24
 .byt >$a730+80*25
 .byt >$a730+80*26
 .byt >$a730+80*27
 .byt >$a730+80*28
 .byt >$a730+80*29
 .byt >$a730+80*30
 .byt >$a730+80*31
 .byt >$a730+80*32
 .byt >$a730+80*33
 .byt >$a730+80*34
 .byt >$a730+80*35
 .byt >$a730+80*36
 .byt >$a730+80*37
 .byt >$a730+80*38
 .byt >$a730+80*39
 .byt >$a730+80*40
 .byt >$a730+80*41
 .byt >$a730+80*42
 .byt >$a730+80*43
 .byt >$a730+80*44
 .byt >$a730+80*45
 .byt >$a730+80*46
 .byt >$a730+80*47
 .byt >$a730+80*48
 .byt >$a730+80*49
 .byt >$a730+80*50
 .byt >$a730+80*51
 .byt >$a730+80*52
 .byt >$a730+80*53
 .byt >$a730+80*54
 .byt >$a730+80*55
 .byt >$a730+80*56
 .byt >$a730+80*57
 .byt >$a730+80*58
 .byt >$a730+80*59

;Both Floor and ceiling tiles always exist only in SSC Overlay
FloorTable
 .dsb 40,0
CeilingTable
 .dsb 40,0

;Fruit Tables
FruitActive
 .dsb 8,0
FruitX
 .dsb 8,0
FruitY
 .dsb 8,0
FruitF
 .dsb 8,0


;Coloured Fruit Graphics (2x4) x 8
FruitBitmapLo
 .byt <FruitGraphic00		;0
 .byt <FruitGraphic01           ;1
 .byt <FruitGraphic02           ;2
 .byt <FruitGraphic03           ;3
 .byt <FruitGraphic04           ;4
 .byt <FruitGraphic05           ;5
 .byt <FruitGraphic06           ;6
 .byt <FruitGraphic07           ;7
 .byt <FruitGraphicSplattered   ;8
FruitBitmapHi
 .byt >FruitGraphic00
 .byt >FruitGraphic01
 .byt >FruitGraphic02
 .byt >FruitGraphic03
 .byt >FruitGraphic04
 .byt >FruitGraphic05
 .byt >FruitGraphic06
 .byt >FruitGraphic07
 .byt >FruitGraphicSplattered

FruitGraphic00	;Red Apple
 .byt 64,64
 .byt 1,%01011000
 .byt 1,%01011000
FruitGraphic01	;Red Apple
 .byt 64,64
 .byt 1,%01011000
 .byt 5,%01011000
FruitGraphic02	;Green Pear
 .byt 64,64
 .byt 2,%01111000
 .byt 2,%01011000
FruitGraphic03	;Yellow Pear
 .byt 64,64
 .byt 3,%01111000
 .byt 3,%01011000
FruitGraphic04	;Blue Damson
 .byt 64,64
 .byt 4,%01000011
 .byt 4,%01000011
FruitGraphic05	;Magenta Plum
 .byt 64,64
 .byt 5,%01000110
 .byt 5,%01000110
FruitGraphic06	;Cyan grape
 .byt 64,64
 .byt 6,%01001100
 .byt 6,%01011000
FruitGraphic07	;White Nut
 .byt 64,64
 .byt 7,%01011000
 .byt 7,%01000100
FruitGraphicSplattered
 .byt 64,64
 .byt 7,%01000000
 .byt 7,%01101010


ScreenInit
	jsr InitialiseHero
Spare    	rts

;Parsed
;SideApproachFlag	Hero Appears on Left(0) or Right(1)
InitialiseHero
	;For this screen there is no exit right but the game may have just started.
	lda SideApproachFlag
.(
	bne InitHeroRight4GameStart
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

InitHeroRight4GameStart
.)
	lda #105
	sta HeroSprite
	;Game start (For Map01) parameters
	ldx #27
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
	;Set initial Action (This must change later when we want the hero lieing down)
	lda #hcStandLeft
	sta HeroAction
	jsr ControlStartSequence
	rts

CyclicByte	.byt 0

ScreenRun
	inc CyclicByte
	lda ShakeTreeTrigger
.(
	beq skip1
	dec ShakeTreeTrigger
	jsr ShakeTree
	;Check on ShakeTreeTrigger again to determine when to trigger FruitFall
	lda ShakeTreeTrigger
	bne skip1
	;Initialise Falling Fruit
	jsr LocateInactiveFruit
	bcc skip1
	jsr InitialiseFruit
skip1	;Process any active Fruit
	jsr FallFruit
	rts

.)


;Fruit are always displayed on even lines and like hero mask against the background on odd
;lines. However unlike the hero some fruit may fall behind or infront of the trunk so
;special code is needed to mask correctly.
;Two different tree masks are used, one permitting the fruit infront of the trunk and the
;other hiding the fruit behind the trunk. Both masks also hide the fruit from showing above
;the canopy on either side.
;An extra screen buffer is used that has the same dimensions as both masks.
;
FallFruit
	;Clear Buffer (11x34==374)
;	ldx #125
;	lda #64
;.(
;loop1	sta FruitScreenBuffer,x
;	sta FruitScreenBuffer+125,x
;	sta FruitScreenBuffer+249,x
;	dex
;	bpl loop1
;.)
	;Now process each piece of fruit
	ldx #07
.(
loop1	;Check if Fruit active
	lda FruitActive,x
	beq skip1
	;Plot Fruit to Screen Buffer
	jsr PlotFruit
	;Move Fruit
	inc FruitY,x
	;Check Ground
	lda FruitY,x
	cmp #57
	bcc skip1
	;Keep Fruit away from bottom border
	dec FruitY,x
	;Check if Fruit Smashed
	lda FruitF,x
	cmp #8
	bne skip2
	;Fruit smashed - delete entry
	lda #00
	sta FruitActive,x
	;Delete Fruit

	jmp skip1
skip2	;Smash Fruit
	lda #8
	sta FruitF,x
skip1	;Progress
	dex
	bpl loop1
.)
	rts

DSOffset2xH
 .byt 0,1
 .byt 80,81
 .byt 160,161
;For now display fruit directly to screen on hero rows
PlotFruit
	;
	ldy FruitY,x	;0-33
	lda ssc_SYLocl,y
	clc
	adc FruitX,x
	sta screen
	lda ssc_SYLoch,y
	adc #00
	sta screen+1
	;
.(
	ldy FruitF,x
	lda FruitBitmapLo,y
	sta vector1+1
	lda FruitBitmapHi,y
	sta vector1+2
	;
	stx temp01
	ldx #05
vector1	lda $dead,x
	ldy DSOffset2xH,x
	sta (screen),y
	dex
	bpl vector1
.)
	ldx temp01
	rts
DeleteFruit
	;
	ldy FruitY,x	;0-33
	lda ssc_SYLocl,y
	clc
	adc FruitX,x
	sta screen
	lda ssc_SYLoch,y
	adc #00
	sta screen+1
	;
	lda #64
.(
	ldx #05
loop1	ldy DSOffset2xH,x
	sta (screen),y
	dex
	bpl loop1
.)
	rts

LocateInactiveFruit
	sec
	ldx #07
.(
loop1	lda FruitActive,x
	beq skip2
	dex
	bpl loop1
	clc
skip2	rts
.)

InitialiseFruit
	lda CyclicByte
	and #15
	cmp #9
.(
	bcc skip1
	sbc #6
skip1	clc
.)
	adc #3	;Offset by left gap
	sta FruitX,x
	;Rather than using mask, we can simply make starting Y at canopy height
	tay
	lda YPOSForCanopyShape-3,y
	sta FruitY,x
	lda CyclicByte
	lsr
	lsr
	lsr
	and #7
	sta FruitF,x
	lda #1
	sta FruitActive,x
	rts
YPOSForCanopyShape	;10
 .byt 39,35,30,28,26,28,25,29,30,35

ShakeTree
	;ShakeTreeTrigger counter bit 0 indicates alt frame
	and #02
	;Fetch Tree Frame Address
	lsr
	tax
	lda TreeShakeFrameLo,x
	sta source
	lda TreeShakeFrameHi,x
	sta source+1
	;Fetch Screen Address
	lda #<$AEDB+80
	sta screen
	lda #>$AEDB+80
	sta screen+1
	;Plot Tree frame
	ldx #27
.(
loop2	ldy #10
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #11
	jsr ssc_AddSource
	jsr ssc_nl_screen
	jsr ssc_nl_screen
	dex
	bne loop2
.)
	rts

TreeShakeFrameLo
 .byt <SSCM_OM2S6_TreeShake_Frame0
 .byt <SSCM_OM2S6_TreeShake_Frame1
TreeShakeFrameHi
 .byt >SSCM_OM2S6_TreeShake_Frame0
 .byt >SSCM_OM2S6_TreeShake_Frame1


;Called from DetectFloorAndCollisions in hero.s when the floortable(A) contains
;0,64,128,192 depending on collision.
;For M2S6 this is the tree trunk
;
;Returned
;Carry Set when move prohibited
CollisionDetection
	sta CollisionFound
	rts

CollisionFound
 .byt 0

ShakeTreeTrigger
 .byt 0

;When the hero performs a recognised action this routine is called
;ProcAction will examine keybit and if Inventory key and FruitFall active, will detect fruit
;           to hero pos and pocket(AddPocket, SFX) ones that match.
;ProcAction will examine keybit and if Action Key and FruitFall active, will detect fruit
;           to Hero pos and eat(Health, SFX) ones that match.
;ProcAction will examine keybit and if Action key and FruitFall off, will detect Trunk to
;           Hero pos and on match will trigger shake tree event(SFX) and FruitFall event(SFX).
ProcAction
	;Are Fruit falling?
	ldx #07
.(
loop1	lda FruitActive,x
	bne FruitFalling
	dex
	bpl loop1
.)
	;Don't rely on Collision type, rely on BGCollisions table
	jsr EstablishCollision
.(
	bcc skip1
	;However only shake tree if Action Key
	lda KeyRegister
	cmp #kcA
	bne skip1
	;Shake Tree!
	lda #20	;Game cycles to alternate tree shake frames
	sta ShakeTreeTrigger
skip1	clc
.)
	rts

EstablishCollision
	;
	ldy HeroAction
	lda game_HAPVector
	sta source
	lda game_HAPVector+1
	sta source+1
	lda (source),y
	sec
	and #%00001000
.(
	beq skip2
	clc
skip2	lda HeroX
.)
	adc #1
	tay
	lda ct_BGCollisions,y
	cmp #5
	rts

FruitFalling
	;Is Fruit below height of hero?
	ldx #07
.(
loop1	lda FruitActive,x
	beq skip1
	;Active Fruit
	lda FruitY,x
	cmp HeroY
	bcc skip1
	;Check Fruit X against hero x
	lda HeroX
	cmp FruitX,x
	beq Yes
	;Also check FruitX against HeroX+1
	clc
	adc #01
	cmp FruitX,x
	beq Yes
skip1	dex
	bpl loop1
	;No
	clc
	rts
Yes	;Fetch key
.)
	lda KeyRegister
	;Was it Item Control(Shift)
	cmp #kcI
.(
	bne skip1
	;Delete Fruit from table
	lda #00
	sta FruitActive,x
	;Delete fruit from screen
	jsr DeleteFruit
	;Add Fruit to inventory - Infinite resource, so locate free object and assign Fruit to Hero
	ldx #127
loop1	lda Objects_C,x
	; Any unused items have Object_C Bit 7 set
	bmi skip3
	dex
	bpl loop1
	;No free objects
	clc
	rts
skip3	;Build new object
	lda #00
	sta Objects_A,x
;	lda #0
	sta Objects_B,x
	lda #11
	sta Objects_C,x
	sec
	jsr game_DisplayPockets 
skip1	clc
.)
	rts



HeroFrame
 .byt 0
CSS_Frac
 .byt 0

ControlStartSequence
	;wait for irq
.(
loop1	lda via_ifr
	bpl loop1

	;Reset irq
	lda via_t1cl

	;SlowDown further (25Hz way too fast)
	lda CSS_Frac
	clc
	adc #64
	sta CSS_Frac
	bcc loop1


	;Animate Hero
	ldx HeroFrame

	jsr PlotStartFrame

	;Increment Frame
	inc HeroFrame
	lda HeroFrame
	cmp #13

	bcc loop1
.)
	rts




;X == Frame
PlotStartFrame
	;Fetch frame graphic address
	lda GSFAddressLo,x
	sta source
	lda GSFAddressHi,x
	sta source+1
	;Store Screen Address
	lda #<HIRESInlayLocation+27+40*98
	sta screen
	lda #>HIRESInlayLocation+27+40*98
	sta screen+1

	ldx #17
.(
loop2	ldy #3
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #4
	jsr ssc_AddSource
	jsr ssc_nl_screen
	dex
	bne loop2
.)
	rts


GSFAddressLo
 .byt <GameStartFrame00
 .byt <GameStartFrame00
 .byt <GameStartFrame01
 .byt <GameStartFrame02
 .byt <GameStartFrame01
 .byt <GameStartFrame02
 .byt <GameStartFrame01
 .byt <GameStartFrame02
 .byt <GameStartFrame03
 .byt <GameStartFrame04
 .byt <GameStartFrame05
 .byt <GameStartFrame04
 .byt <GameStartFrame05
GSFAddressHi
 .byt >GameStartFrame00
 .byt >GameStartFrame00
 .byt >GameStartFrame01
 .byt >GameStartFrame02
 .byt >GameStartFrame01
 .byt >GameStartFrame02
 .byt >GameStartFrame01
 .byt >GameStartFrame02
 .byt >GameStartFrame03
 .byt >GameStartFrame04
 .byt >GameStartFrame05
 .byt >GameStartFrame04
 .byt >GameStartFrame05

;Game Start only frames (As hero rises from being washed ashore unconcious) (4x20)x6
GameStartFrame00
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 06,%01000110,%01110101,%01010000
 .byt 01,%01000110,%01001000,%01000100
GameStartFrame01
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 03,%01000110,%01000000,%01000000
 .byt 01,%01000110,%01000000,%01000000
 .byt 02,%01000000,%01110111,%01000000
 .byt 06,%01000001,%01001010,%01101000
 .byt 01,%01000011,7,%01000100
GameStartFrame02
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 03,%01000000,%01110000,%01000000
 .byt 01,%01000000,%01110000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 02,%01000000,%01011010,%01000000
 .byt 06,%01000000,%01100101,%01010000
 .byt 01,%01000011,7,%01001100
GameStartFrame03
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 03,%01000011,%01000000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 01,%01000011,%01000000,%01000000
 .byt 02,%01000000,%01100000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 02,%01000000,%01110000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 02,%01000001,%01011000,%01000000
 .byt 01,%01000100,%01000000,%01000000
 .byt 06,%01000000,%01111110,%01000000
GameStartFrame04
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 64,64,64,64
 .byt 03,%01000011,%01000000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 01,%01000001,%01100000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 02,%01000000,%01110000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 02,%01000000,%01110000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 02,%01000000,%01100000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 01,%01000000,%01100000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 06,%01000000,%01011110,%01000000
GameStartFrame05
 .byt 03,%01000000,%01011000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 01,%01000000,%01011000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 02,%01000000,%01001100,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 02,%01000000,%01000100,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 01,%01000000,%01001100,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 06,%01000000,%01001100,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 06,%01000000,%01011000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 01,%01000000,%01110000,%01000000
 .byt 64,%01000000,%01000000,%01000000
 .byt 07,%01000000,%01001100,%01000000



 .bss
#include "C:\OSDK\Projects\Wurlde\PlayerFile\PlayerFile.s"
