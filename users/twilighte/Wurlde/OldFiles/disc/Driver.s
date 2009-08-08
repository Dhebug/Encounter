;Driver.s
#define	HIRES		$ec33
#define	pcr_Disabled	$DD
#define	pcr_Register	$FF
#define	pcr_Value	$FD

#define	via_portb	$0300
#define via_t1cl	$0304
#define	via_pcr		$030C
#define	via_porta	$030F

#define	hcLeftTurnRight		0
#define	hcRightTurnLeft         1
#define	hcRunLeft               2
#define	hcRunRight              3
#define	hcStandLeft             4
#define	hcStandRight            5
#define	hcJumpUpFacingLeft      6
#define	hcJumpUpFacingRight     7
#define	hcSwingFacingLeft       8
#define	hcSwingFacingRight      9
#define	hcClamberFacingLeft     10
#define	hcClamberFacingRight    11
#define	hcStandingJumpLeft      12
#define	hcStandingJumpRight     13
#define	hcRunningJumpLeft       14
#define	hcRunningJumpRight      15
#define	hcFallLeft              16
#define	hcFallRight             17
#define	hcPickupLeft		18
#define	hcPickupRight		19
#define hcDropLeft		20
#define	hcDropRight		21

#define ccFloorExtra	60
#define ccLeftExit	60
#define ccRightExit	61
#define ccLeftBorder	62
#define	ccRightBorder	63
#define	ccInpenetrableWall	64
#define	ccFloorExit	65
#define ccFloorPain	66

#define hap_Repeat	128
#define hap_Grounded    64
#define hap_AddCheck    32
#define	hap_ContKey	16
#define	hap_FRight	8
#define hap_Still	4

#define kcL 		1
#define kcR		2
#define kcU		4
#define kcUL		5
#define kcUR            6
#define kcD             8
#define kcDL            9
#define kcDR            10
#define kcF             16
#define kcFL            17
#define kcFR            18
#define kcFU            20
#define kcFD            24
#define kcE		32
#define kcS		64
#define kcX		128

#define lsDisableHeroControl	1
#define lsProhibitJump		2

;Used for Devils Head and Hand Actions
#define gf_Pointing	0
#define	gf_Tapping	4
#define	gf_Normal	128

#define gh_Normal	0
#define	gh_Glowing	1

#define eve_Star	0
#define eve_Flag	1
#define eve_Flow	2
#define eve_Lift	3
#define eve_Flicker	4
#define eve_Sluece	5
#define eve_Wave	6
#define eve_Seagulls	7
#define eve_Moor	8
#define eve_ShipFlag	9
#define eve_EOL		128

 .zero
*=$00
#include "zeropage.s"


 .text
*=$500

Driver

	; Testing disk routines
	jsr test_disk

	jsr InitGame
	sei
	jsr SetupText
	jsr DisplayScreenProse
	ldx ScreenID
	lda LevelSettingTable,x
	sta LevelSettings

	and #1
.(
	bne skip1
	jsr PlotHero
skip1	jsr UpdateInventoryPointer
.)
.(
loop1
	lda LevelSettings
	and #1
	bne skip1
	jsr ReadKeyboard
	jsr HeroControl
skip1
	jsr LongDelay
	jsr UpdateTextBox
	jsr ManageTime
	jsr UpdateGremlin
	jsr AnimateMapPosition
	jsr getrand
	jsr ProcessScreenEvents
	jsr PlotScreenItems
	jmp loop1
.)

SunMoonIndex	.byt 12
SunMoonFrac	.byt 0

ManageTime
	;Delay Sunmoon interval
	lda SunMoonFrac
	clc
	adc #1
	sta SunMoonFrac
.(
	bcc skip1
	;Manage SunMoon
	dec SunMoonIndex
	bpl skip2
	lda #12
	sta SunMoonIndex
skip2	lda SunMoonIndex
	jsr UpdateSunMoon
	;Use this to also reduce health by one
	dec HeroHealth
	jsr UpdateHealthBar
skip1	rts
.)


LongDelay
	ldy #48
	ldx #00
.(
loop1
;	nop
;	nop
;	nop
	dex
	bne loop1
	dey
	bpl loop1
.)
	rts

#include "hero.s"
#include "Data.s"
#include "HeroSprites.s"
#include "InfoPan.s"
#include "BotDevil.s"
#include "ReadKeyboard.s"
;#include "ManageHeroAction.s"
#include "CeilingFloorCapture.s"
#include "TextWindowHandler.s"
#include "CollisionDetection.s"
#include "InventoryObjects.s"
#include "InfoPanelHandler.s"
#include "LevelManagement.s"
#include "Map01Code.s"
StartofLevelData
;#include "lvlBoulders.s"
;#include "lvlHallow1.s"
;#include "lvlBridge2.s"
;#include "lvlHarbour1.s"
;#include "lvlHarbour2.s"
;#include "lvljettyend.s"
;#include "lvlWizHouse.s"
;#include "lvlMoat2.s"
;#include "lvlMillHouse.s"
;#include "lvlTown1.s"
;#include "lvlSkyBridge.s"
;#include "lvlNewYear.s"
;#include "lvltestcomplex.s"
;#include "lvlField.s"
;#include "lvlBrokenSky.s"
;#include "lvlLiftCage.s"
;#include "lvlWindmill.s"
EndOfLevelData
InitGame

	jsr _switch_ovl
	jsr HIRES
	;jsr _switch_ovl
	jsr PlotHIRES
	jsr LoadLevel
	jmp InitialiseHeroOnLeft

InitialiseHeroOnLeft
;	jsr CaptureHeights
	jsr CaptureBGB
	lda #98
	sta HeroSprite
	;Game start (For Map01) parameters
	ldx #1
	stx HeroX
	;Set hero y to land contour

	jsr LevelFollowLandContour

	lda #3
	sta SpriteWidth
	lda #9
	sta SpriteHeight
	lda #hcStandRight
	sta HeroAction
	rts
InitialiseHeroOnRight
;	jsr CaptureHeights
	jsr CaptureBGB
	lda #105
	sta HeroSprite
	;Game start (For Map01) parameters
	lda #36
	sta HeroX
	;Set hero y to land contour
	jsr LevelFollowLandContour

	lda #3
	sta SpriteWidth
	lda #9
	sta SpriteHeight
	lda #hcStandLeft
	sta HeroAction
	rts


PlotHIRES
	lda #<$a000
	sta screen
	lda #>$a000
	sta screen+1
	lda #<InfoPan
	sta source
	lda #>InfoPan
	sta source+1
	ldx #46
	jsr ZoomHIRESSection
	lda #<$b9f0
	sta screen
	lda #>$b9f0
	sta screen+1
	lda #<BotDevil
	sta source
	lda #>BotDevil
	sta source+1
	ldx #34
	jmp ZoomHIRESSection


ZoomHIRESSection
	clc
.(
loop2	ldy #39
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda source
	adc #40
	sta source
	lda source+1
	adc #00
	sta source+1
	lda screen
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	dex
	bne loop2
.)
	rts

getrand
         lda rndRandom+1
         sta rndTemp
         lda rndRandom
         asl
         rol rndTemp
         asl
         rol rndTemp

         clc
         adc rndRandom
         pha
         lda rndTemp
         adc rndRandom+1
         sta rndRandom+1
         pla
         adc #$11
         sta rndRandom
         lda rndRandom+1
         adc #$36
         sta rndRandom+1
         rts

;A == Maximum (eg. 0-39)
GetRNDRange
	sta rndTemp+1
	jsr getrand
	cmp rndTemp+1
.(
	bcc skip1
	and rndTemp+1
skip1	rts
.)



;;;;; TESTING DISK ROUTINES
test_disk
.(
	lda #0
dbug
	beq dbug

	jsr _switch_ovl



	lda #0
	jsr load_ssc


	lda #1
	jsr load_ssc

	rts

.)

freespace
.dsb $9d00-*

#include "Disk\disk.s"
