;GameDriver.s


GameDriver
;	jmp tstPlotAllHeroFrames
	jsr SetupManualIRQ
;	jsr SelectorDriver
	jsr SetupGAMEPointers
	jsr SetupPage2
	;Setup game for first time
	lda #00
	sta SubGameResult
	sta SubGameStartLocation
	jsr UpdateHeroGrotes
	jsr UpdateHealthBar
;	jsr UpdateManaBar	This generates some screen corruption!
	lda #01
	jsr LoadSSC
	;Store Stack Pointer
	tsx
	stx GameStackPointer
	;Build list of objects that reside on the ground in this screen
SSCLoop	jsr RescanScreenItems
	;Update item text
	jsr DisplayHeroItemText
	;Don't plot hero if B0 set in ScreenRules
	lda ssc_ScreenRules

	and #1
.(
	bne skip1
	jsr PlotHero
skip1	jsr UpdateInventoryPointer
.)

.(
loop1
	;Don't Control hero if B0 set in ScreenRules
	lda ssc_ScreenRules
	and #%00000001
	bne skip1
	jsr ReadKeyboard
	jsr HeroControl
skip1	;Observe rule b7 to sync with irq (25Hz)
	lda ssc_ScreenRules
	and #%10000000
	beq skip3
	;Wait for 25Hz IRQ
loop2	lda via_ifr
	bpl loop2
	;Reset irq
	lda via_t1cl
	jmp skip2
skip3	jsr LongDelay
skip2	jsr ManageTime
	jsr UpdateGremlin
	jsr AnimateMapPosition
	jsr getrand
	jsr ssc_ScreenRun
	jsr AnimateScreenObjects
	jsr ProcessSubGameActivities
	;At any point in game a cut-scene may be invoked
loop3	ldx game_CutSceneFlag
	bmi loop1

	;The value held here specifies the File index (0-79) / (Cut-scenes always reside in C000)
	lda #$C0
	;X File Number   A Load Address High
	jsr dsk_LoadFile
	
	;If the filenum is a known map(3-39) then initialise it
	ldx game_CutSceneFlag
	cpx #3
	bcc skip4
	cpx #40
	bcs skip4
	;Display Screen Prose, Place name, Devil exits, Map Position
	jsr InitialiseSettings
	;We now copy and extract SSC inlay in main game code.
	jsr ScreenCopy
	

skip4	;All cut-scenes always execute at $C000
	lda #128
	sta game_CutSceneFlag
	jsr ssc_ScreenInit
	;And will always return the next file Number in game_CutSceneFlag or 128 to return to game
	
	jmp loop3
.)

;For successful cut-scene sequence
	;ssc set cutsceneflag to 40
	;above loads cs1 and calls c000
	;cs1 finishes and sets cutsceneflag to 41 cs2(Castle)
	;above loads cs2 and calls c000
	;cs2 finishes and sets cutsceneflag to 42 cs3(Escape)
	;above loads cs3 and calls c000
	;cs3 finishes and sets m&s to 1&0 and cutsceneflag to 10
	;above loads sscom1s0 and inits
;For unsuccessful cut-scene sequence(cut-scene was sub game that terminated hero)
	;ssc set cutsceneflag to 40
	;above loads cs1 and calls c000
	;cs1 finishes and sets cutsceneflag to 41 cs2(Castle)
	;above loads cs2 and calls c000
	;cs2 finishes and sets cutsceneflag to 42 cs3(Escape)
	;above loads cs3 and calls c000
	;cs3 finishes and sets cutsceneflag to gameover filenum
	;above loads cs3 and calls c000
	
SetupPage2
	;200-23A Screen ylocl Table
	;23B-275 Screen yloch Table
	;276-2B0 BackgroundBuffer ylocl Table
	;2B1-2EB BackgroundBuffer yloch Table
	;2EC-2FF -
	lda #<HIRESInlayLocation+40
	sta source
	lda #>HIRESInlayLocation+40
	sta source+1
	
	lda #<BackgroundBuffer
	sta source2
	lda #>BackgroundBuffer
	sta source2+1
	
	ldy #60
	ldx #00
	clc
.(
loop1	lda source
	sta game_sylocl,x
	adc #80
	sta source
	lda source+1
	sta game_syloch,x
	adc #00
	sta source+1
	
	lda source2
	sta game_bgbylocl,x
	adc #40
	sta source2
	lda source2+1
	sta game_bgbyloch,x
	adc #00
	sta source2+1
	
	inx
	dey
	bne loop1
.)
	rts

SetupManualIRQ
	lda #<40000
	sta via_t1ll
	lda #>40000
	sta via_t1lh
	lda #%01111111
	sta via_ier
	lda #%11000000
	sta via_ier
	rts

SetupGAMEPointers
	;Sets up Jump vectors in page 4 for use by SSC module
	lda #<AddItem
	sta $407
	lda #>AddItem
	sta $408

	lda #<IncreaseHealth
	sta $40a
	lda #>IncreaseHealth
	sta $40b

	lda #<DecreaseHealth
	sta $40D
	lda #>DecreaseHealth
	sta $40E

	lda #<DisplayHeroItemText
	sta $410
	lda #>DisplayHeroItemText
	sta $411

	lda #<GetRNDRange
	sta $413
	lda #>GetRNDRange
	sta $414

	lda #<PlotHero
	sta $416
	lda #>PlotHero
	sta $417

	lda #<PlotPlace
	sta $419
	lda #>PlotPlace
	sta $41A

	lda #<SelectorDriver
	sta $41C
	lda #>SelectorDriver
	sta $41D

	lda #<ScreenCopy
	sta $41F
	lda #>ScreenCopy
	sta $420

	lda #<EraseInlay
	sta $422
	lda #>EraseInlay
	sta $423

	lda #<BackgroundBuffer
	sta $424
	lda #>BackgroundBuffer
	sta $425
	
	lda #<DeleteHero
	sta $42B
	lda #>DeleteHero
	sta $42C
	
	lda #<DisplayText
	sta $42F
	lda #>DisplayText
	sta $430
	
	lda #<DisplayPockets 
	sta $434
	lda #>DisplayPockets 
	sta $435
	
	lda #<ReadKeyboard
	sta $437
	lda #>ReadKeyboard
	sta $438
	
	rts
	
	


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
;#include "PlotFrames.s"	;tst routine to display all hero frames on inlay
#include "General.s"
#include "ScreenCopy.s"	;Copies SSC inlay to screen and extracts embedded stuff
#include "hero.s"
#include "CharacterRoutines.s"
#include "NewDayRoutines.s"
#include "SubGameActivities.s"
#include "Data.s"
#include "HeroSprites.s"
#include "ReadKeyboard.s"
;#include "CeilingFloorCapture.s"
#include "TextWindowHandler.s"
#include "CollisionDetection.s"
#include "InventoryObjects.s"
#include "InfoPanelHandler.s"
#include "Grotes.s"
#include "text.s"
#include "ManageCharacterMovements.s"
#include "Selector.s"

