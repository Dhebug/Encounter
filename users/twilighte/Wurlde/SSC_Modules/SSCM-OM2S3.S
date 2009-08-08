;SSCM-OM2S3.S - Windmill
;Synopsis
;This screen displays the following...
;1) Moving vanes of Windmill.
;2) There is just enough time for the hero to run past the vanes heading west. Hurt hero on vane contact
;3) There needs to be something to permit the hero to pass the vanes heading east
;3)>Birds flying(aimlessly) in the distance(behind veins).
;4)>Twinkling Stars
;5)>

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
 .byt <EnterTextWindmill,>EnterTextWindmill	;C024
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
#include "INLAY-OM2S3.s"	;Windmill - scn23.mem in wurlde.dsk

#include "SSC_CommonCode.s"
EnterTextWindmill
 .byt "Great cogs creak and yaw as a giant%"
 .byt "mechanism churns round and round,%"
 .byt "teeth grinding the corn into flour.%"
 .byt "heaving restlessly with reckless%"
 .byt "abandonment the miller eyes you,%"
 .byt "nods and continues to manage the%"
 .byt "machine.]"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "The mighty wooden vanes take to the%"
 .byt "breeze turning a great spindle that%"
 .byt "bites at the stones within. Such is%"
 .byt "the nature of these peaceful beasts%"
 .byt "but who works this machine, serving%"
 .byt "its need? And how do i pass without%"
 .byt "feeling its blades?]"
ScreenName	;Always 13 characters long
;      *************
 .byt "THE WINDMILL ]"


ScreenInit
	jsr InitialiseHero
	rts

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
	jsr VaneManage
Spare	rts

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

;Monitor Y for clipping patch
;For Vane each minus represents an increment in YPOS
VaneAngle	;0-35
 .byt 0,9,18,27
VaneFrameLo
 .byt <vane00
 .byt <vane10
 .byt <vane20
 .byt <vane30
 .byt <vane40
 .byt <vane50
 .byt <vane60
 .byt <vane70
 .byt <vane80
 .byt <vane90

 .byt <vane100
 .byt <vane110
 .byt <vane120
 .byt <vane130
 .byt <vane140
 .byt <vane150
 .byt <vane160
 .byt <vane170

 .byt <vane00
 .byt <vane10
 .byt <vane20
 .byt <vane30
 .byt <vane40
 .byt <vane50
 .byt <vane60
 .byt <vane70
 .byt <vane80
 .byt <vane90

 .byt <vane100
 .byt <vane110
 .byt <vane120
 .byt <vane130
 .byt <vane140
 .byt <vane150
 .byt <vane160
 .byt <vane170
VaneFrameHi
 .byt >vane00
 .byt >vane10
 .byt >vane20
 .byt >vane30
 .byt >vane40
 .byt >vane50
 .byt >vane60
 .byt >vane70
 .byt >vane80
 .byt >vane90

 .byt >vane100
 .byt >vane110
 .byt >vane120
 .byt >vane130
 .byt >vane140
 .byt >vane150
 .byt >vane160
 .byt >vane170

 .byt >vane00
 .byt >vane10
 .byt >vane20
 .byt >vane30
 .byt >vane40
 .byt >vane50
 .byt >vane60
 .byt >vane70
 .byt >vane80
 .byt >vane90

 .byt >vane100
 .byt >vane110
 .byt >vane120
 .byt >vane130
 .byt >vane140
 .byt >vane150
 .byt >vane160
 .byt >vane170

VaneScreenLocationLo
 .byt <$A028+18+40*67	;00
 .byt <$A028+18+40*67	;10
 .byt <$A028+18+40*67	;20
 .byt <$A028+18+40*67	;30
 .byt <$A028+17+40*67	;40
 .byt <$A028+17+40*67	;50
 .byt <$A028+17+40*65	;60
 .byt <$A028+17+40*65	;70
 .byt <$A028+17+40*61	;80

 .byt <$A028+4+40*59	;90
 .byt <$A028+5+40*43	;100
 .byt <$A028+5+40*27	;110
 .byt <$A028+7+40*15	;120
 .byt <$A028+7+40*3	;130
 .byt <$9C40+9+40*20	;140
 .byt <$9C40+12+40*12	;150
 .byt <$9C40+14+40*4	;160
 .byt <$9C40+17+40*2	;170

 .byt <$9C40+18		;180(00)
 .byt <$9C40+21+40*2	;190(10)
 .byt <$9C40+24+40*4	;200(20)
 .byt <$9C40+26+40*12	;210(30)
 .byt <$9C40+27+40*20	;220(40)
 .byt <$A028+29+40*3	;230(50)
 .byt <$A028+31+40*15	;240(60)
 .byt <$A028+32+40*27	;250(70)
 .byt <$A028+33+40*43	;260(80)

 .byt <$A028+20+40*59	;270
 .byt <$A028+21+40*61	;280
 .byt <$A028+20+40*65	;290
 .byt <$A028+21+40*65   ;300
 .byt <$A028+19+40*67   ;310
 .byt <$A028+19+40*67   ;320
 .byt <$A028+19+40*67   ;330
 .byt <$A028+19+40*67   ;340
 .byt <$A028+19+40*65   ;350

VaneScreenLocationHi
 .byt >$A028+18+40*67	;00
 .byt >$A028+18+40*67	;10
 .byt >$A028+18+40*67	;20
 .byt >$A028+18+40*67	;30
 .byt >$A028+17+40*67	;40
 .byt >$A028+17+40*67	;50
 .byt >$A028+17+40*65	;60
 .byt >$A028+17+40*65	;70
 .byt >$A028+17+40*61	;80

 .byt >$A028+4+40*59	;90
 .byt >$A028+5+40*43	;100
 .byt >$A028+5+40*27	;110
 .byt >$A028+7+40*15	;120
 .byt >$A028+7+40*3	;130
 .byt >$9C40+9+40*20	;140
 .byt >$9C40+12+40*12	;150
 .byt >$9C40+14+40*4	;160
 .byt >$9C40+17+40*2	;170

 .byt >$9C40+18		;180(00)
 .byt >$9C40+21+40*2	;190(10)
 .byt >$9C40+24+40*4	;200(20)
 .byt >$9C40+26+40*12	;210(30)
 .byt >$9C40+27+40*20	;220(40)
 .byt >$A028+29+40*3	;230(50)
 .byt >$A028+31+40*15	;240(60)
 .byt >$A028+32+40*27	;250(70)
 .byt >$A028+33+40*43	;260(80)

 .byt >$A028+20+40*59	;270
 .byt >$A028+21+40*61	;280
 .byt >$A028+20+40*65	;290
 .byt >$A028+21+40*65   ;300
 .byt >$A028+19+40*67   ;310
 .byt >$A028+19+40*67   ;320
 .byt >$A028+19+40*67   ;330
 .byt >$A028+19+40*67   ;340
 .byt >$A028+19+40*65   ;350

VaneYPOSStart
 .byt 67-46	;00
 .byt 67-46	;10
 .byt 67-46	;20
 .byt 67-46	;30
 .byt 67-46	;40
 .byt 67-46	;50
 .byt 65-46	;60
 .byt 65-46	;70
 .byt 61-46	;80

 .byt 59-46	;90
 .byt 253	;100(43-46)
 .byt 237	;110(27-46)
 .byt 225	;120(15-46)
 .byt 213	;130(3-46)
 .byt 250-46	;140
 .byt 242-46	;150
 .byt 234-46	;160
 .byt 232-46	;170

 .byt 230-46	;180
 .byt 232-46	;190
 .byt 234-46	;200
 .byt 242-46	;210
 .byt 250-46	;220
 .byt 213	;230(3-46)
 .byt 225	;240(15-46)
 .byt 237	;250(27-46)
 .byt 253	;260(43-46)

 .byt 59-46	;270
 .byt 61-46	;280
 .byt 65-46	;290
 .byt 65-46	;300
 .byt 67-46	;310
 .byt 67-46	;320
 .byt 67-46	;330
 .byt 67-46	;340
 .byt 65-46	;350
VaneDelay	.byt 0


VaneManage
	lda VaneDelay
	clc
	adc #64
	sta VaneDelay
.(
	bcs skip1
	rts
skip1
	ldx #03
.)
.(
loop1	ldy VaneAngle,x
	;Delete old Vane
	dey
	bpl skip1
	ldy #35
skip1	lda VaneFrameLo,y
	sta source
	lda VaneFrameHi,y
	sta source+1
	lda VaneScreenLocationLo,y
	sta screen
	lda VaneScreenLocationHi,y
	sta screen+1
	lda VaneYPOSStart,y
	sta VaneScanLineYPOS
	jsr DeleteVane

	ldy VaneAngle,x
	;Plot Vane
	lda VaneFrameLo,y
	sta source
	lda VaneFrameHi,y
	sta source+1
	lda VaneScreenLocationLo,y
	sta screen
	lda VaneScreenLocationHi,y
	sta screen+1
	lda VaneYPOSStart,y
	sta VaneScanLineYPOS
	jsr PlotVane

	ldy VaneAngle,x
	iny
	cpy #36
	bcc skip2
	ldy #00
skip2	tya
	sta VaneAngle,x
	dex
	bpl loop1
.)
	;Animate BG ground Collision table - reflecting windmill vane collision areas
	ldx BGVaneIndex
	lda BGCollisionFrameLo,x
	sta source
	lda BGCollisionFrameHi,x
	sta source+1
	ldy #39
.(
loop1	lda (source),y
	sta ct_BGCollisions,y
	
	;For testing purposes - Display as bg+64 to screen
;	ora #64
;	sta $b900,y
	
	dey
	bpl loop1
.)
	;Update Vane Index
	txa
	clc
	adc #1
	cmp #9
.(
	bcc skip1
	lda #00
skip1	sta BGVaneIndex
.)	
	;Detect Hero collision (Airbourne or not) - Calculate index and get BGCollision for foot
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
.(
	bne skip1
	lda #1
	jsr game_DecreaseHealth
skip1	rts
.)

BGVaneIndex	.byt 0
BGCollisionFrameLo
 .byt <BGCollisionTableFrame0
 .byt <BGCollisionTableFrame1
 .byt <BGCollisionTableFrame2
 .byt <BGCollisionTableFrame3
 .byt <BGCollisionTableFrame4
 .byt <BGCollisionTableFrame5
 .byt <BGCollisionTableFrame6
 .byt <BGCollisionTableFrame7
 .byt <BGCollisionTableFrame8
BGCollisionFrameHi
 .byt >BGCollisionTableFrame0
 .byt >BGCollisionTableFrame1
 .byt >BGCollisionTableFrame2
 .byt >BGCollisionTableFrame3
 .byt >BGCollisionTableFrame4
 .byt >BGCollisionTableFrame5
 .byt >BGCollisionTableFrame6
 .byt >BGCollisionTableFrame7
 .byt >BGCollisionTableFrame8

BGCollisionTableFrame0	;Vane vertical and horizontal
 .byt 1,1,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,2,2
BGCollisionTableFrame1
 .byt 1,1,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,2,2
BGCollisionTableFrame2
 .byt 1,1,0,0
 .byt 0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,2,2
BGCollisionTableFrame3
 .byt 1,1,0,0
 .byt 0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,2,2
BGCollisionTableFrame4	;Safe zone
 .byt 1,1,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,2,2
BGCollisionTableFrame5	;Safe zone
 .byt 1,1,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,2,2
BGCollisionTableFrame6
 .byt 1,1,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,0
 .byt 0,0,0,2,2
BGCollisionTableFrame7
 .byt 1,1,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,2,2
BGCollisionTableFrame8
 .byt 1,1,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,2,2

PlotVane
	stx VaneTempX
	ldy #00
.(
loop1   lda (source),y
        bmi skip1
	;Clip using YPOS
	ldx VaneScanLineYPOS	;0-118 is valid
	bmi skip3
	sta (screen),y
skip3   iny
        jmp loop1
skip1   and #127
        beq skip2

	clc
        adc screen
        sta screen
        lda screen+1
        adc #00
        sta screen+1

	iny
	tya
        adc source
        sta source
        lda #00
        tay
        adc source+1
        sta source+1

        inc VaneScanLineYPOS
        inc VaneScanLineYPOS
        jmp loop1
skip2   ldx VaneTempX
	rts
.)

DeleteVane
	ldy #00
.(
loop1   lda (source),y
        bmi skip1
	;Clip using YPOS
	lda VaneScanLineYPOS	;0-118 is valid
	bmi skip3
	lda #64
        sta (screen),y
skip3   iny
        jmp loop1
skip1   and #127
        beq skip2
        clc
        adc screen
        sta screen
        lda screen+1
        adc #00
        sta screen+1
	iny
	tya
        adc source
        sta source
        lda #00
        tay
        adc source+1
        sta source+1
        inc VaneScanLineYPOS
        inc VaneScanLineYPOS
        jmp loop1
skip2   rts
.)

VaneScanLineYPOS	.byt 0
VaneTempX		.byt 0
#include "VaneBitmaps.s"


InteractionHeader
 .byt 0		;
 .byt <Interaction0,>Interaction0

Interaction0
;      ***********************************
 .byt "$]"
 .byt "Sorry, i have little time to rumour%"
 .byt "monger whilst the corn is grinding.]"

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 2 Evenings
;Bit 1 Afternoons
;Bit 0 Mornings
;If all bits are clear then the character will appear on random days
SSCCharacterList
 .byt %011+8*31	;Jiles
 .byt %011+8*15	;Lintu
 .byt 255

SSCCharacterInfo
 .byt <JilesFaceGFX,>JilesFaceGFX,<JilesDescription,>JilesDescription
 .byt <LintuFaceGFX,>LintuFaceGFX,<LintuDescription,>LintuDescription

JilesFaceGFX	;Face not done yet
 .byt $7F,$78,$7F
 .byt $05,$45,$40
 .byt $7F,$6A,$6F
 .byt $05,$55,$50
 .byt $7F,$5F,$77
 .byt $05,$72,$58
 .byt $7E,$68,$6B
 .byt $05,$77,$58
 .byt $7E,$5A,$73
 .byt $05,$57,$50
 .byt $7F,$58,$77
 .byt $05,$5F,$70
 .byt $7F,$68,$6F
 .byt $05,$4F,$60
 .byt $7F,$77,$5F
JilesDescription
;>>>>>>******************
 .byt "Jiles prefers to%"
 .byt "ignore the plight%"
 .byt "of Wurlde working%"
 .byt "harder instead.]"

LintuFaceGFX	;27 of 32 in charfaces.hrs on wurlde.dsk
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

LintuDescription
;>>>>>>******************
 .byt "Lintu works with%"
 .byt "farmer Jiles.]"
