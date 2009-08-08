;SSCM-OM2S0.S Escarpment - SCN50.MEM on WURLDE.DSK
;1) Crows nesting on cliff
;2) Crows flying in distance.
;3) Jetty boat gently rocking
;4) When hero hits action key infront of boat it triggers the hero to climb into the
;   boat and sit down. The boat will then drift off left behind Cliff.

;If hero approaches from the west (from cut scene or with oars) then DriftOn and
;Landing sequences will auto ensue followed by hero standing on jetty.


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
 .byt 7				;C01D
RecognisedAction
 .byt %00010000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector	;Enter Boat
 .byt <EnterTextBoat,>EnterTextBoat	;C024
InteractionHeaderVector		;This SSC has no meeting place so 0 must be written to high address
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
#include "INLAY-OM2S0.s"	;Escarpment - scn50.mem in wurlde.dsk

#include "SSC_CommonCode.s"
EnterTextBoat
 .byt "The boat seems in good repair, the%"
 .byt "construction is simple yet sturdy.%"
 .byt "As you step into its hollow, it%"
 .byt "gently sways in the water. As you%"
 .byt "bed down in the craft,the rope that%"
 .byt "tied you off loosens and the boat%"
 .byt "begins to drift down stream..]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "And so the journey abruptly halts,%"
 .byt "as before you high cliffs stand.%"
 .byt "But before you recount your faults%"
 .byt "remember not all paths lie on land.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "ESCARPMENT]"



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
	ldx #20
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


BoatBehaviour	.byt 0
bb_Frac		.byt 0
bb_Index		.byt 0

ScreenRun
	;Boat can either rock or drift off left
	lda RockBoatFlag
.(
	beq skip1
	jsr AnimateRockingBoat
	rts
skip1	lda DriftingFrac
	clc
	adc DriftingStep
	sta DriftingFrac
	;Increase velocity of drift (up to frac of 186)
	inc DriftingStep
	bcc skip2
	jsr ProcDriftSequence
	dec DriftSequenceCount
	bne skip2
	;When drifting completes, Trigger loading of Cut-Scene 1
	lda #40	;Cut Scene 1 File number
	sta game_CutSceneFlag
	;Clear Inlay
	jsr game_EraseInlay
skip2	rts
.)

ProcDriftSequence
	jsr ScrollBitmap1BitLeft
	jsr MaskBoat2Screen
	rts

;When the hero performs a recognised action this routine is called
;ProcAction
;
;
ProcAction
	;Action key pressed (board boat) - check CollisionFound
	lda CollisionFound
.(
	beq skip1
	;Hero over right place and action pressed so trigger board boat sequence
	;by disabling hero control..
	lda ssc_ScreenRules
	ora #%00000001
	sta ssc_ScreenRules
	;Freezing Boat Rock
	lda #00
	sta RockBoatFlag
	jsr game_DeleteHero
	;Triggering Board Animation
	lda #01
	sta BoardingFlag
skip1	clc
.)
	rts

BoardingFlag	.byt 0
RockBoatFlag	.byt 1
DriftSequenceCount	.byt 11*6	;Number of frames or moves of drifting sequence
DriftingFrac	.byt 0
DriftingStep	.byt 64
RockingDelayFrac	.byt 0
RockingFrame	.byt 0
;Display Rocking Boat animation in background

AnimateRockingBoat
	lda #32
	jsr game_GetRNDRange
	sec
	adc RockingDelayFrac
	sta RockingDelayFrac
.(
	bcc skip2
	lda RockingFrame
	clc
	adc #01
	cmp #6
	bcc skip1
	lda #00
skip1	sta RockingFrame
	tax
	lda RockingBoatFrameAddressLo,x
	sta source
	lda RockingBoatFrameAddressHi,x
	sta source+1

	lda #<HIRESInlayLocation+9+105*40
	sta screen
	lda #>HIRESInlayLocation+9+105*40
	sta screen+1

	ldx #4
loop2	ldy #8
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #9
	jsr ssc_AddSource
	jsr ssc_nl_screen
	jsr ssc_nl_screen
	dex
	bne loop2
skip2	rts
.)

RockingBoatFrameAddressLo
 .byt <RockingBoat_Frame00
 .byt <RockingBoat_Frame00
 .byt <RockingBoat_Frame01
 .byt <RockingBoat_Frame02
 .byt <RockingBoat_Frame02
 .byt <RockingBoat_Frame01
RockingBoatFrameAddressHi
 .byt >RockingBoat_Frame00
 .byt >RockingBoat_Frame00
 .byt >RockingBoat_Frame01
 .byt >RockingBoat_Frame02
 .byt >RockingBoat_Frame02
 .byt >RockingBoat_Frame01

RockingBoat_Frame00	;9x4(Alt)
 .byt $40,$40,$58,$40,$40,$41,$70,$40,$43
 .byt $40,$7E,$59,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $40,$5E,$58,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $40,$44,$7D,$7D,$7D,$7F,$6F,$77,$7F
RockingBoat_Frame01	;9x4(Alt)
 .byt $40,$40,$58,$40,$40,$43,$60,$40,$46
 .byt $41,$7E,$59,$7F,$7F,$7F,$7F,$7F,$7E
 .byt $40,$7E,$58,$7F,$7F,$7F,$7F,$7F,$7E
 .byt $40,$4C,$7D,$7D,$7D,$7F,$6F,$77,$7F
RockingBoat_Frame02	;9x4(Alt)
 .byt $40,$40,$58,$40,$40,$47,$40,$40,$4C
 .byt $43,$7E,$59,$7F,$7F,$7F,$7F,$7F,$7C
 .byt $41,$7E,$58,$7F,$7F,$7F,$7F,$7F,$7C
 .byt $40,$5C,$7D,$7D,$7D,$7F,$6F,$77,$7F


BoatBoardingFrameAddressLo
 .byt <BoatBoarding_Frame00
 .byt <BoatBoarding_Frame01
 .byt <BoatBoarding_Frame02
 .byt <BoatBoarding_Frame03
 .byt <BoatBoarding_Frame04
 .byt <BoatBoarding_Frame05
BoatBoardingFrameAddressHi
 .byt <BoatBoarding_Frame00
 .byt <BoatBoarding_Frame01
 .byt <BoatBoarding_Frame02
 .byt <BoatBoarding_Frame03
 .byt <BoatBoarding_Frame04
 .byt <BoatBoarding_Frame05

;Shoring frames same as boarding but in reverse
BoatShoringFrameAddressLo
 .byt <BoatBoarding_Frame05
 .byt <BoatBoarding_Frame04
 .byt <BoatBoarding_Frame03
 .byt <BoatBoarding_Frame02
 .byt <BoatBoarding_Frame01
 .byt <BoatBoarding_Frame00
BoatShoringFrameAddressHi
 .byt <BoatBoarding_Frame05
 .byt <BoatBoarding_Frame04
 .byt <BoatBoarding_Frame03
 .byt <BoatBoarding_Frame02
 .byt <BoatBoarding_Frame01
 .byt <BoatBoarding_Frame00

BoatBoarding_Frame00	;3x23(Full Res)
 .byt $60,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $03,$70,$40
 .byt $40,$40,$40
 .byt $01,$70,$40
 .byt $40,$40,$40
 .byt $02,$58,$40
 .byt $40,$40,$40
 .byt $02,$58,$40
 .byt $40,$40,$40
 .byt $01,$70,$40
 .byt $40,$40,$40
 .byt $06,$58,$40
 .byt $40,$40,$40
 .byt $06,$58,$40
 .byt $78,$40,$40
 .byt $06,$4C,$40
 .byt $7F,$61,$7F
 .byt $01,$44,$40
 .byt $40,$40,$40
 .byt $07,$46,$40
BoatBoarding_Frame01
 .byt $60,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $03,$70,$40
 .byt $40,$40,$40
 .byt $01,$70,$40
 .byt $40,$40,$40
 .byt $02,$58,$40
 .byt $40,$40,$40
 .byt $02,$58,$40
 .byt $40,$40,$40
 .byt $01,$70,$40
 .byt $40,$40,$40
 .byt $06,$70,$40
 .byt $78,$40,$40
 .byt $06,$58,$40
 .byt $7F,$61,$7F
 .byt $01,$44,$40
 .byt $40,$40,$40
 .byt $07,$46,$40
BoatBoarding_Frame02
 .byt $60,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $03,$58,$40
 .byt $40,$40,$40
 .byt $01,$58,$40
 .byt $40,$40,$40
 .byt $02,$58,$40
 .byt $40,$40,$40
 .byt $02,$58,$40
 .byt $40,$40,$40
 .byt $01,$70,$40
 .byt $40,$40,$40
 .byt $06,$70,$40
 .byt $78,$40,$40
 .byt $01,$48,$40
 .byt $7F,$61,$7F
 .byt $07,$46,$40
 .byt $40,$40,$40
 .byt $07,$40,$40
BoatBoarding_Frame03
 .byt $60,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $03,$58,$40
 .byt $40,$40,$40
 .byt $01,$58,$40
 .byt $40,$40,$40
 .byt $02,$4C,$40
 .byt $40,$40,$40
 .byt $02,$4C,$40
 .byt $40,$40,$40
 .byt $01,$70,$40
 .byt $40,$40,$40
 .byt $06,$58,$40
 .byt $78,$40,$40
 .byt $06,$40,$40
 .byt $7F,$7F,$7F
 .byt $07,$40,$40
 .byt $40,$40,$40
 .byt $07,$40,$40
BoatBoarding_Frame04
 .byt $60,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $03,$4C,$40
 .byt $40,$40,$40
 .byt $01,$4C,$40
 .byt $40,$40,$40
 .byt $02,$46,$40
 .byt $40,$40,$40
 .byt $02,$42,$40
 .byt $40,$40,$40
 .byt $06,$75,$40
 .byt $78,$40,$40
 .byt $06,$40,$40
 .byt $7F,$7F,$7F
 .byt $07,$40,$40
 .byt $40,$40,$40
 .byt $07,$40,$40
BoatBoarding_Frame05
 .byt $60,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $03,$4C,$40
 .byt $40,$40,$40
 .byt $01,$4C,$40
 .byt $40,$40,$40
 .byt $02,$46,$40
 .byt $40,$40,$40
 .byt $02,$46,$40
 .byt $78,$58,$40
 .byt $06,$40,$40
 .byt $7F,$7F,$7F
 .byt $07,$40,$40
 .byt $40,$40,$40
 .byt $07,$40,$40

;Rather than frames (11x14 == 154 bytes per frame, x 33 Frames == 5082)
;Use common mask and 1pixel scroll left bitmap boat behind
;Graphic masks and bitmaps also held in escarp2.mem on wurlde.dsk
ScrollBitmap1BitLeft
	; Scroll 14 rows
	lda #<BoatBitmap
	sta source
	lda #>BoatBitmap
	sta source+1
	ldx #14
.(
loop2	clc
	ldy #10

loop1	lda (source),y
	rol
	and #127
	cmp #64
	ora #64
	sta (source),y
	dey
	bpl loop1
	
	lda #11
	jsr ssc_AddSource
	dex
	bne loop2
.)
	rts
	
#define	BoatScreen	$B687

MaskBoat2Screen
	lda #<BoatBitmap
	sta source
	lda #>BoatBitmap
	sta source+1
	
	lda #<BackgroundMask
	sta bgmask
	lda #>BackgroundMask
	sta bgmask+1
	
	lda #<BoatScreen
	sta screen
	lda #>BoatScreen
	sta screen+1
	
	lda #<BackgroundBitmaps
	sta source2
	lda #>BackgroundBitmaps
	sta source2+1
	
	ldx #14
.(
loop2	ldy #10

loop1	lda (source),y	;Fetch Boat Bitmap
	and (bgmask),y	;Mask behind Flower and Jetty
	ora (source2),y	;Combine with Flower and Jetty Bitmaps
	sta (screen),y	;Store to screen
	
	dey
	bpl loop1
	
	lda #11
	jsr ssc_AddSource
	
	lda #11
	jsr ssc_AddBGMask
	
	lda #40
	jsr ssc_AddScreen
	
	lda source2
	clc
	adc #11
	sta source2
	bcc skip1
	inc source2+1
skip1	
	dex
	bne loop2
.)
	rts
BackgroundMask	;11x14
 .byt $5F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $5F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $4F,$7F,$7F,$7F,$43,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $47,$7F,$7F,$7F,$43,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $47,$7F,$7F,$7F,$43,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $47,$77,$7F,$7F,$63,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $47,$63,$7F,$7F,$43,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $47,$63,$7F,$7F,$43,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $47,$41,$7F,$7F,$43,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $44,$40,$5F,$7F,$43,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $40,$40,$4F,$7F,$43,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $44,$40,$5F,$7F,$43,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $46,$40,$7F,$7E,$40,$40,$40,$40,$40,$40,$40
 .byt $47,$41,$7F,$7E,$40,$40,$40,$40,$40,$40,$40
BoatBitmap	;11x14
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$58,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$58,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$4C,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$4C,$40,$40
 .byt $40,$40,$41,$70,$40,$40,$40,$78,$40,$40,$43
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$70,$40,$40
 .byt $40,$40,$40,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$5F,$7F,$7F,$7F,$7F,$7F,$7F,$7E
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$47,$7F,$7F,$7F,$7F,$7F,$7F,$78
BackgroundBitmaps
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $70,$40,$40,$40,$58,$40,$40,$40,$40,$40,$40
 .byt $70,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $50,$40,$40,$40,$48,$40,$40,$40,$40,$40,$40
 .byt $50,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $50,$40,$40,$40,$58,$40,$40,$40,$40,$40,$40
 .byt $50,$5C,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $50,$40,$40,$40,$58,$40,$40,$40,$40,$40,$40
 .byt $43,$49,$60,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $50,$40,$40,$40,$58,$40,$40,$40,$40,$40,$40
 .byt $40,$6A,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $50,$40,$40,$40,$7D,$7D,$7F,$6F,$77,$7F,$7F
