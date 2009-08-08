;SSCM-OM2S5.s - Field with reflective water
;This is the next (and in some ways the most awaited screen since it will prove the SSC concept).
;This screen displays the following...
;1) a reflective surface reflecting all sprites on land and in air (The fish) but with distortion
;   to provide a more realistic feel to the water.
;   The distortion here is from a random source that picks a random routine to LSR, ASL or keep each byte.
;   Because of the random element the reflection is constantly different which is similar to real life.
;2) Jumping Fish, Fish swim below the surface(not seen) but will occasionally jump into the air in an arc shape.
;   Each one creates bubbles on the surface of the water before breaking through and jumping to hero height.
;   Because the fish flies in an arc shaped flight path the Hero has the chance to catch it with the item key
;   on the downward path.
;3)>Birds flying(aimlessly) in the distance. This screen may appear alot darker than previous and the addition
;   of birds will break the monotony of the backdrop of trees.
;4)>Twinkling Stars

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
 .byt %00000010			;C01E
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
#include "INLAY-OM2S5.s"	;Field - scn51.mem in wurlde.dsk

#include "SSC_CommonCode.s"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "These fish swim in shallow waters,%"
 .byt "and create bubbles when they come,%"
 .byt "They rise beyond their quarters,%"
 .byt "and taste as good as they come!]"
ScreenName	;Always 13 characters long
 .byt "THE LONG ROAD]"


FishGraphics
#include "M02S05_FishySprites.s"


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
	ldx #34	;Recommended value (34(xpos)+3(herowidth)==37(38-39 holds exit in floortable)
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

CyclicByte	.byt 0

ScreenRun
	jsr MoveFish
	jsr ReflectionCode
	rts

ReflectionCode
	;1) Reflect all objects (Hero and Fish) in water
	lda #<$ae3a+$758+80*7
	sta source
	lda #>$ae3a+$758+80*7
	sta source+1
	lda #<$b182+$758
	sta screen
	lda #>$b182+$758
	sta screen+1
	ldx #06
.(
loop2	ldy DistortionType
	lda DistortionVectorLo,y
	sta vector1+1
	lda DistortionVectorHi,y
	sta vector1+2

	ldy #37


loop1	lda (source),y
	;Avoid distorting attribute changes
	cmp #64
	bcc skip2
vector1	jsr $dead
skip2	sta (screen),y
skip1	dey
	bpl loop1

	lda source
	sec
	sbc #80
	sta source
	lda source+1
	sbc #00
	sta source+1

	jsr ssc_nl_screen

	lda #7
	jsr game_GetRNDRange
	and #03
	sta DistortionType

	dex
	bne loop2
	;2) Distort water
.)
	rts
DistortionType	.byt 0
DistortionVectorLo
 .byt <DistortLeft
 .byt <DistortNone
 .byt <DistortRight
 .byt <DistortNone
DistortionVectorHi
 .byt >DistortLeft
 .byt >DistortNone
 .byt >DistortRight
 .byt >DistortNone

DistortLeft
	and #%00111111
	lsr
	ora #%01000000
	rts
DistortNone
	rts
DistortRight
	and #%00111111
	asl
	ora #%01000000
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
;ProcAction When the item key is pressed and the flying fish is at the same xpos as the hero and within the hero
;	  height then the fish is pocketed (Should not need to delete fish as hero will overwrite same locs)
;
ProcAction
	;Check FishActiveFlag to ensure we don't keep adding the same fish multiple times
	lda FishActiveFlag
.(
	beq skip2
	;Check HeroX against FishX
	lda HeroX
	cmp FishX
	beq skip1
	clc
	adc #01
	cmp FishX
	bne skip2
skip1	;Check (FishY/2) > HeroY
	lda FishY
	lsr
	cmp HeroY
	bcc skip2
	;Check HeroY+HeroHeight > FishY
	lda HeroY
	clc
	adc SpriteHeight
	cmp FishY
	bcs skip2
	;Delete Fish
	lda #00
	sta FishActiveFlag
	;Bok fish are an infinite resource, so locate free object and assign bok fish and hero to it
	ldx #127
loop1	lda Objects_C,x
	; Any unused items have Object_C Bit 7 set
	bmi skip3
	dex
	bpl loop1
	;No free objects
	jmp skip2
skip3	;Build new object
	lda #00
	sta Objects_A,x
	lda #8*5
	sta Objects_B,x
	lda #11
	sta Objects_C,x
	sec
	jsr game_DisplayPockets 
skip2	clc
.)
	rts

;Fish Code
FishActiveFlag	.byt 0
FishStepIndex	.byt 0
SplitLineFlag	.byt 0
FishWidth		.byt 0
FishHeight	.byt 0
FishX		.byt 0
FishY		.byt 0
FishXStep		.byt 0
FishYStep		.byt 0
FishDelayFrac	.byt 0
FishSlowDownFrac	.byt 0

RowsTable
 .byt 40,80
ScreenYLOCL	;Full 119 rows
 .byt <$a758
 .byt <$a758+40*1
 .byt <$a758+40*2
 .byt <$a758+40*3
 .byt <$a758+40*4
 .byt <$a758+40*5
 .byt <$a758+40*6
 .byt <$a758+40*7
 .byt <$a758+40*8
 .byt <$a758+40*9
 .byt <$a758+40*10
 .byt <$a758+40*11
 .byt <$a758+40*12
 .byt <$a758+40*13
 .byt <$a758+40*14
 .byt <$a758+40*15
 .byt <$a758+40*16
 .byt <$a758+40*17
 .byt <$a758+40*18
 .byt <$a758+40*19
 .byt <$a758+40*20
 .byt <$a758+40*21
 .byt <$a758+40*22
 .byt <$a758+40*23
 .byt <$a758+40*24
 .byt <$a758+40*25
 .byt <$a758+40*26
 .byt <$a758+40*27
 .byt <$a758+40*28
 .byt <$a758+40*29
 .byt <$a758+40*30
 .byt <$a758+40*31
 .byt <$a758+40*32
 .byt <$a758+40*33
 .byt <$a758+40*34
 .byt <$a758+40*35
 .byt <$a758+40*36
 .byt <$a758+40*37
 .byt <$a758+40*38
 .byt <$a758+40*39
 .byt <$a758+40*40
 .byt <$a758+40*41
 .byt <$a758+40*42
 .byt <$a758+40*43
 .byt <$a758+40*44
 .byt <$a758+40*45
 .byt <$a758+40*46
 .byt <$a758+40*47
 .byt <$a758+40*48
 .byt <$a758+40*49
 .byt <$a758+40*50
 .byt <$a758+40*51
 .byt <$a758+40*52
 .byt <$a758+40*53
 .byt <$a758+40*54
 .byt <$a758+40*55
 .byt <$a758+40*56
 .byt <$a758+40*57
 .byt <$a758+40*58
 .byt <$a758+40*59
 .byt <$a758+40*60
 .byt <$a758+40*61
 .byt <$a758+40*62
 .byt <$a758+40*63
 .byt <$a758+40*64
 .byt <$a758+40*65
 .byt <$a758+40*66
 .byt <$a758+40*67
 .byt <$a758+40*68
 .byt <$a758+40*69
 .byt <$a758+40*70
 .byt <$a758+40*71
 .byt <$a758+40*72
 .byt <$a758+40*73
 .byt <$a758+40*74
 .byt <$a758+40*75
 .byt <$a758+40*76
 .byt <$a758+40*77
 .byt <$a758+40*78
 .byt <$a758+40*79
 .byt <$a758+40*80
 .byt <$a758+40*81
 .byt <$a758+40*82
 .byt <$a758+40*83
 .byt <$a758+40*84
 .byt <$a758+40*85
 .byt <$a758+40*86
 .byt <$a758+40*87
 .byt <$a758+40*88
 .byt <$a758+40*89
 .byt <$a758+40*90
 .byt <$a758+40*91
 .byt <$a758+40*92
 .byt <$a758+40*93
 .byt <$a758+40*94
 .byt <$a758+40*95
 .byt <$a758+40*96
 .byt <$a758+40*97
 .byt <$a758+40*98
 .byt <$a758+40*99
 .byt <$a758+40*100
 .byt <$a758+40*101
 .byt <$a758+40*102
 .byt <$a758+40*103
 .byt <$a758+40*104
 .byt <$a758+40*105
 .byt <$a758+40*106
 .byt <$a758+40*107
 .byt <$a758+40*108
 .byt <$a758+40*109
 .byt <$a758+40*110
 .byt <$a758+40*111
 .byt <$a758+40*112
 .byt <$a758+40*113
 .byt <$a758+40*114
 .byt <$a758+40*115
 .byt <$a758+40*116
 .byt <$a758+40*117
 .byt <$a758+40*118

ScreenYLOCH
 .byt >$a758
 .byt >$a758+40*1
 .byt >$a758+40*2
 .byt >$a758+40*3
 .byt >$a758+40*4
 .byt >$a758+40*5
 .byt >$a758+40*6
 .byt >$a758+40*7
 .byt >$a758+40*8
 .byt >$a758+40*9
 .byt >$a758+40*10
 .byt >$a758+40*11
 .byt >$a758+40*12
 .byt >$a758+40*13
 .byt >$a758+40*14
 .byt >$a758+40*15
 .byt >$a758+40*16
 .byt >$a758+40*17
 .byt >$a758+40*18
 .byt >$a758+40*19
 .byt >$a758+40*20
 .byt >$a758+40*21
 .byt >$a758+40*22
 .byt >$a758+40*23
 .byt >$a758+40*24
 .byt >$a758+40*25
 .byt >$a758+40*26
 .byt >$a758+40*27
 .byt >$a758+40*28
 .byt >$a758+40*29
 .byt >$a758+40*30
 .byt >$a758+40*31
 .byt >$a758+40*32
 .byt >$a758+40*33
 .byt >$a758+40*34
 .byt >$a758+40*35
 .byt >$a758+40*36
 .byt >$a758+40*37
 .byt >$a758+40*38
 .byt >$a758+40*39
 .byt >$a758+40*40
 .byt >$a758+40*41
 .byt >$a758+40*42
 .byt >$a758+40*43
 .byt >$a758+40*44
 .byt >$a758+40*45
 .byt >$a758+40*46
 .byt >$a758+40*47
 .byt >$a758+40*48
 .byt >$a758+40*49
 .byt >$a758+40*50
 .byt >$a758+40*51
 .byt >$a758+40*52
 .byt >$a758+40*53
 .byt >$a758+40*54
 .byt >$a758+40*55
 .byt >$a758+40*56
 .byt >$a758+40*57
 .byt >$a758+40*58
 .byt >$a758+40*59
 .byt >$a758+40*60
 .byt >$a758+40*61
 .byt >$a758+40*62
 .byt >$a758+40*63
 .byt >$a758+40*64
 .byt >$a758+40*65
 .byt >$a758+40*66
 .byt >$a758+40*67
 .byt >$a758+40*68
 .byt >$a758+40*69
 .byt >$a758+40*70
 .byt >$a758+40*71
 .byt >$a758+40*72
 .byt >$a758+40*73
 .byt >$a758+40*74
 .byt >$a758+40*75
 .byt >$a758+40*76
 .byt >$a758+40*77
 .byt >$a758+40*78
 .byt >$a758+40*79
 .byt >$a758+40*80
 .byt >$a758+40*81
 .byt >$a758+40*82
 .byt >$a758+40*83
 .byt >$a758+40*84
 .byt >$a758+40*85
 .byt >$a758+40*86
 .byt >$a758+40*87
 .byt >$a758+40*88
 .byt >$a758+40*89
 .byt >$a758+40*90
 .byt >$a758+40*91
 .byt >$a758+40*92
 .byt >$a758+40*93
 .byt >$a758+40*94
 .byt >$a758+40*95
 .byt >$a758+40*96
 .byt >$a758+40*97
 .byt >$a758+40*98
 .byt >$a758+40*99
 .byt >$a758+40*100
 .byt >$a758+40*101
 .byt >$a758+40*102
 .byt >$a758+40*103
 .byt >$a758+40*104
 .byt >$a758+40*105
 .byt >$a758+40*106
 .byt >$a758+40*107
 .byt >$a758+40*108
 .byt >$a758+40*109
 .byt >$a758+40*110
 .byt >$a758+40*111
 .byt >$a758+40*112
 .byt >$a758+40*113
 .byt >$a758+40*114
 .byt >$a758+40*115
 .byt >$a758+40*116
 .byt >$a758+40*117
 .byt >$a758+40*118



;MoveFish involves deleting the current stepindex frame, incrementing the stepindex, and plotting the new stepindex frame
MoveFish	lda FishActiveFlag
.(
	beq skip2
	;Delay Fish sequence
	lda FishSlowDownFrac
	clc
	adc #128
	sta FishSlowDownFrac
	bcc skip1
	;Check if fish sequence has finished
	ldx FishStepIndex
	ldy FishPath_RightArc,x
	bmi skip2
	;Fetch address of header and bitmap of fish
	jsr FetchFishAddress
	;Delete Fish
	jsr DeleteFishFrame
	;Update the fish step
	jsr ManageNextStep
	bcs skip1
	;Plot Fish
	jsr FetchFishAddress
	jsr PlotFishFrame
	;Done
skip1	rts

skip2	;Manage delay between fish activity
	lda #39
	jsr game_GetRNDRange
	clc
	adc FishDelayFrac
	sta FishDelayFrac
	bcc WaitSomeMore
	;Setup next fish sequence
	lda #01
	sta FishActiveFlag
	lda #00
	sta FishStepIndex
	lda #28
	jsr game_GetRNDRange
	clc
	adc #02
	sta FishX
	lda #113
	sta FishY
WaitSomeMore
	rts
.)

FetchFishAddress
	;Load pointers
	ldx FishStepIndex
	ldy FishPath_RightArc,x
	;B6 Double height (Use odd lines)
	tya
	asl
	asl
	rol
	and #%00000001
	sta SplitLineFlag	;0/1
	tya
	and #63
	tay
	;Fetch Header and bitmap locations of fish frame
	lda FishFrameAddressTableLo,y
	sta header
	clc
	adc #4
	sta source
	lda FishFrameAddressTableHi,y
	sta header+1
	adc #00
	sta source+1
	;Fetch Fish width and height
	ldy #00
	lda (header),y
	sta FishWidth
	iny
	lda (header),y
	sta FishHeight
	;Fetch Fish steps
	iny
	lda (header),y
	sta FishXStep
	iny
	lda (header),y
	sta FishYStep
	rts


;Update stepindex, move fish based on 2's compliment FishXStep and FishYStep
ManageNextStep
	;Update StepIndex
	inc FishStepIndex
	ldx FishStepIndex
	ldy FishPath_RightArc,x
	;B7 End of sequence
	bmi EndOfFishyStuff
	;Update X Pos
	lda FishX
	sec
	adc FishXStep
	sta FishX
	;Update Y Pos
	lda FishY
	sec
	adc FishYStep
	sta FishY
	;Done
	clc
	rts

EndOfFishyStuff
	sec
	rts

;FishFrame held in source
;Width and height in FishWidth and FishHeight
;X and Y based on FishX and FishY (If SplitLineFlag then exclude b0)
;Row stepping based on SplitLineFlag

DeleteFishFrame
	jsr CalculateScreenLoc
	ldx FishHeight
.(
loop2	ldy FishWidth
	dey
	lda #64
loop1	sta (screen),y
	dey
	bpl loop1

	ldy SplitLineFlag
	lda RowsTable,y
	jsr ssc_AddScreen

	dex
	bne loop2
.)
	rts

PlotFishFrame
	jsr CalculateScreenLoc
	ldx FishHeight
.(
loop2	ldy FishWidth
	dey
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1

	ldy SplitLineFlag
	lda RowsTable,y
	jsr ssc_AddScreen

	lda FishWidth
	jsr ssc_AddSource

	dex
	bne loop2
.)
	rts


CalculateScreenLoc
	lda FishY
	ldx SplitLineFlag
.(
	beq skip1
	ora #%00000001
skip1	tay
.)
	;Use same 119 byte tables
	lda ScreenYLOCL,y
	clc
	adc FishX
	sta screen
	lda ScreenYLOCH,y
	adc #00
	sta screen+1

	rts

 .bss
#include "C:\OSDK\Projects\Wurlde\PlayerFile\PlayerFile.s"
