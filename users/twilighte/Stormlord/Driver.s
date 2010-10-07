;Driver
#define	HIRES		$EC33
#define	MAP_END		128

#define	MAP_LEVEL1	0
#define	MAP_LEVEL2          1
#define	MAP_LEVEL3          2

#define	SYS_IRQVECTOR	$0229	;0245 for Atmos

#define	VIA_PORTB		$0300
#define	VIA_PORTAH	$0301
#define	VIA_DDRB		$0302
#define	VIA_DDRA		$0303
#define	VIA_T1CL		$0304
#define	VIA_T1CH            $0305
#define	VIA_T1LL            $0306
#define	VIA_T1LH            $0307
#define	VIA_T2LL            $0308
#define	VIA_T2CH            $0309
#define	VIA_PCR             $030C
#define	VIA_IFR		$030D
#define	VIA_IER		$030E
#define	VIA_PORTA           $030F

#define	VIA2_PORTB	$0320

#define	GAME_NORMAL	0
#define	GAME_BONUS	1
#define	GAME_ENDOFBONUS	128
#define	GAME_OUTOFTIME	129
#define	GAME_NOMORELIVES	130

#define	GFX_FAIRYINPOT	0      
#define	GFX_STONEBLOCK1     1 
#define	GFX_DOOR            2 
#define	GFX_FAIRY           3 
#define	GFX_TRAMPOLINE      4 
#define	GFX_CHAIN           5 
#define	GFX_LARGEBRICK      6 
#define	GFX_FLORA1          7 
#define	GFX_BLUEVASE        8 
#define	GFX_SPHERELAUNCHER  9 
#define	GFX_KEY             10
#define	GFX_SPHERE          11
#define	GFX_COLUMNTOP       12
#define	GFX_COLUMN          13
#define	GFX_SMALLBRICKS     14

;#define	SCREENSCORE	
#define	CB_EXIT		3
#define	CB_BACKGROUND	0

#define	NPCA_BALLRISING	0
#define	NPCA_BALLBOUNCE	1
#define	NPCA_BALLPAUSE	2
#define	NPCA_GRUBPEEP	3
#define	NPCA_GRUBMOVE	4
#define	NPCA_RAINDROP	5
#define	NPCA_EGGWASP	6
#define	NPCA_DRAGONLEFT	7
#define	NPCA_DRAGONRIGHT	8
#define	NPCA_BEE		9
#define	NPCA_EXPLODE	10
#define	NPCA_SPIDER	11
#define	NPCA_TRIFFID	12
#define	NPCA_FAIRY	13
#define	NPCA_THROWNTEAR	14
#define	NPCA_FLOORTEAR	15
#define	NPCA_MELTTEAR	16

#define	NPCF_BALL0	0
#define	NPCF_BALL1	1
#define	NPCF_BALL2	2
#define	NPCF_BALL3	3
#define	NPCF_GRUBMOVELEFT0	4
#define	NPCF_GRUBMOVELEFT1	5
#define	NPCF_GRUBMOVERIGHT0	6
#define	NPCF_GRUBMOVERIGHT0	7
#define	NPCF_GRUBPEEPLEFT	8
#define	NPCF_GRUBPEEPRIGHT	9
#define	NPCF_RAINDROP	10
#define	NPCF_DRAGONLEFT	11
#define	NPCF_DRAGONRIGHT	12
#define	NPCF_BEE		13
#define	NPCF_EXPLOSION	19
#define	NPCF_AFTEREXPLODE	25
#define	NPCF_EGG		25
#define	NPCF_HATCH	26
#define	NPCF_SWARMINGWASP	27
#define	NPCF_SPIDER0	32
#define	NPCF_SPIDER1	33
#define	NPCF_FAIRY0	34
#define	NPCF_FAIRY1	35

#define	BONUSFAIRYSPEED	2

;CollisionValue..
;B0-3
#define	BCKC_BG		0	; 00 Background
#define	BCKC_WALL		1	; 01 Wall/Surface/Solid
#define	BCKC_DEATH	2	; 02 Death(Flames)
#define	BCKC_ICELEDGE	3	; 03 Ice Ledge
#define	BCKC_TEARS	4	; 04-15 Tear(NPC ID)
#define	BCKC_OBJECTKEY	4	; 04 Object 1 Key
#define	BCKC_OBJECTHONEY	5	; 05 Object 2 Honey
#define	BCKC_OBJECTUMBRELLA	6	; 06 Object 3 Umbrella
#define	BCKC_OBJECTBOOTS	7	; 07 Object 4 Boots
#define	BCKC_FAIRY	8	; 08 Fairy
#define	BCKC_DOOR		9	; 09 Door
#define	BCKC_TRAMPOLENE	10	; 10 Trampolene
#define	BCKC_TRIFFID	11	; 11 Triffid

#define	STARFIELD_WEST	1
#define	STARFIELD_EAST	248

#define	GFXF_ORB		28
#define	GFXF_SWORDRIGHT	29
#define	GFXF_SWORDLEFT	30
#define	GFXF_HEART	31

#define	FIREPERIOD4SWORD	4

#define	OBJECT_KEY	4
#define	OBJECT_HONEY	5
#define	OBJECT_UMBRELLA	6
#define	OBJECT_BOOTS	7

#define	TR_GAMEOVER	0
#define	TR_TIMEOUT	1


;SFX's
#define	SFX_LEVELCOMPLETE             15
#define	SFX_KILLED                    0
#define	SFX_EXPLOSION		13
#define	SFX_GAMEOVER                  14

;#define	SFX_PASSFAIRY                 

#define	SFX_LAUNCHER                  4
#define	SFX_RAINDROP		6
;#define	SFX_FAIRYTEAR                 ;Raindrop
;#define	SFX_GRUB			
#define	SFX_SPIDER		11
#define	SFX_BEES			12
#define	SFX_COLLECTKEY     		5
#define	SFX_COLLECTFAIRY              7
#define	SFX_COLLECTUMBRELLA           16
#define	SFX_COLLECTHONEY		17
#define	SFX_COLLECTSHOES              18
;#define	SFX_COLLECTTEAR               
#define	SFX_OPENDOOR                  9
#define	SFX_USETRAMPOLENE             8
#define	SFX_FIREHEART               	3
#define	SFX_FIREORB                 	1
#define	SFX_FIRESWORD                 2
#define	SFX_FOOTSTEP		10
#define	SFX_STARFIELD		19

#define	OVERLAY_TITLE		0
#define	OVERLAY_REDEFINE		1
#define	OVERLAY_OPTIONS		2
#define	OVERLAY_STUFF		3
#define	OVERLAY_HISCOREENTRY	4
#define	OVERLAY_TIMEOUT		5
#define	OVERLAY_GAMEOVER		6
#define	OVERLAY_LEVELINTRO1		7
#define	OVERLAY_GAMECOMPLETE	10

#define	FRONTEND_TITLE		0
#define	FRONTEND_OPTIONS		1
#define	FRONTEND_STUFF		2

#define	CTRL_LEFT			1
#define	CTRL_RIGHT		2
#define	CTRL_UP			16
#define	CTRL_DOWN			8
#define	CTRL_FIRE			32
#define	CTRL_FIRE2		64

 .zero
*=$00

#include "ZeroPage.s"

 .text
*=$500

Driver	jmp Driver2
;$503 - Tables to $5FF
#include "Tables5035FF.s"
;$600 - pmeLoopOrEnd
PageAlligned2_600
#include "Wave_PageAllignedStuff.s"
#include "Tables6DB6FF.s"
PageAlligned2_700
BackgroundBuffer	;10E0
 .dsb 40*108,0
;The collision map is based on 6x6 cells
;00 Background
;01 Wall/Surface/Solid
;02 Death
;03 Exit (Left/Right)
;04 Object 1 Key
;05 Object 2 Honey
;06 Object 3 Umbrella
;07 Object 4 Boots
;08-15
;16 Fairy
;17 Door
;18 Trampolene
;+32 Left(0) or Right(1) Block (Only needed for collisions over 2)

Object_X
 .dsb 8,0
Object_Y
 .dsb 8,0
Object_MapLo
 .dsb 8,0
Object_MapHi
 .dsb 8,0

;Above tables pad the following to become page alligned 
CollisionMap
StarfieldX
 .dsb 100,0
StarfieldY
 .dsb 100,0
StarfieldStep
 .dsb 100,0
;(40x18)-(300 already defined above)
 .dsb 420,0	;40*18,0


Driver2	lda #30
	sta $BFDF
	jsr ClearLowerScreen
	lda #128
	sta GameFlag
	jsr SetupIRQ
	;Restore BB80 area(Cassette load corrupts it)
	ldx #39
.(
loop1	lda BB80Restoration,x
	sta $A000+40*176,x
	dex
	bpl loop1
.)
	lda #00
	sta usm_SunMoonYPos
	sta usm_RowIndex
	
.(
loop1	lda KeyRegister
	bne loop1
loop2	lda KeyRegister
	beq loop2
.)
	jsr ClearScreen
GameStartLoop
	sei
	lda #00
	sta ayw_Volume
	sta ayw_Volume+1
	sta ayw_Volume+2
	jsr InitMusic
	lda #<10000
	sta VIA_T1CL
	sta VIA_T1LL
	lda #>10000
	sta VIA_T1CH
	sta VIA_T1LH
	cli

	lda #00
	sta GameFlag
	lda #10
	sta CounterReference

	jsr FrontEnd

	lda #1
	sta GameFlag
	sei
	jsr InitMusic
	lda #<40000
	sta VIA_T1CL
	sta VIA_T1LL
	lda #>40000
	sta VIA_T1CH
	sta VIA_T1LH
	;Stop any EG activity
	lda #00
	sta ayw_Volume
	sta ayw_Volume+1
	sta ayw_Volume+2
	cli
	
	;Reset and display Score
	lda #00
	sta HeroScore
	sta HeroScore+1
	sta HeroScore+2
	jsr DisplayScore
	
	;Set lives dependant on difficulty
	ldx Option_Difficulty
	lda InitialLives,x
;	lda #3
	sta HeroLives
	jsr DisplayLives

	;Set Game start (Level1) start Position
	lda #0
	sta LevelID
NextLevelLoop
	jsr SetupLevel
	ldx LevelID
	jsr UnpackData
	
	jsr DrawMap	;And pop bgbuff
	;Clear and redisplay Object Pocket
	lda #128
	sta HeroHolding
	jsr DisplayHeldObject

	;Sunmoon speed is based on level aswell as difficulty
	;Difficulty == 0-2
	;level == 0-2
	jsr SetTimeLimit

	;Reset Fairies collected
	lda #00
	sta HeroCapturedFairies
	jsr DisplayCapturedFairies

	;Reset Hero frame(death was causing death frame) and redisplay
	lda #8
	sta HeroFrame
	jsr PlotHero
	
	;Display Level Name
	jsr DisplayLevelName
	
	lda #GAME_NORMAL
	sta GameAction
	

GameLoop	jsr SpeedDampener
;	jsr TestWriteBinaryKeys
	jsr NPCControl
	jsr HeroControl
	lda GameAction
.(
	bmi skip3
	jsr FireEngine
	jsr PlotHero
	jsr ManageBeePosition
	lda KeyRegister
	cmp #CTRL_FIRE2
	beq skip2

	lda GameAction
	bpl GameLoop
skip3	cmp #GAME_ENDOFBONUS
	beq EndOfBonusScreen
	cmp #GAME_NOMORELIVES
	beq skip1
	;Shouldn't be anything other than out of time here
	
	;Display Out of Time
	ldx #OVERLAY_TIMEOUT
	jsr DisplayOverlay
	
skip1	;Delay a few seconds
	jsr CommonTextDelay
	
	;Check highscore
	jsr CheckHiscore

skip5	;Return to title
	jmp GameStartLoop

skip2	;Esc pressed
	jsr EscMenu
;	lda KeyRegister
;	and #31
;	beq skip6
;	inc LevelID
;	jmp skip7
;skip6	lda KeyRegister
;	cmp #CTRL_FIRE2
;	;Result is in Carry..
;	;Clr - Restart Level
;	;Set - Return to Title
	bcs skip5

	;Restore Score
	ldx #2

loop1	lda HeroLevelScore,x
	sta HeroScore,x
	dex
	bpl loop1

	;Display Score
	jsr DisplayScore
	
	;Decrement 1 life
	dec HeroLives

	beq skip4
	
	jsr DisplayLives
skip7	jmp NextLevelLoop
skip4	jsr ClearScreen
	;Display Game Over mid screen
	ldx #OVERLAY_GAMEOVER
	jsr DisplayOverlay
	jmp skip1
.)

EndOfBonusScreen
	;Record the score (ESC resets level and score too)
	ldx #2
.(
loop1	lda HeroScore,x
	sta HeroLevelScore,x
	dex
	bpl loop1
.)	
	;then proceed to next level or finish game
	inc LevelID
	lda LevelID
	cmp #3
	bcs GameCompleted
	
	lda #SFX_LEVELCOMPLETE
	jsr KickSFX

;	;Restore sunmoon speed
;	ldx Option_Difficulty
;	lda GameSpeed,x
;	sta CounterReference
;	jsr UpdateSunMoon_Cont

	;Restore midday
	lda #00
	sta usm_SunMoonYPos
	
	;Loop
	jmp NextLevelLoop

GameCompleted
	ldx #OVERLAY_GAMECOMPLETE
	jsr DisplayOverlay
	;Kick some SFX
	lda #SFX_STARFIELD
	jsr KickSFX
	;Wait a while
	lda #150
	jsr CommonTextDelay2
	;Check hiscore
	jsr CheckHiscore
	;then return to title
	jmp GameStartLoop
	
	

DisplayLevelName
	lda LevelID
	adc #OVERLAY_LEVELINTRO1
	tax
	jsr DisplayOverlay
	jsr CommonTextDelay
	jmp DrawMap

CommonTextDelay
	lda #50
CommonTextDelay2
	sta ProgrammableCountdown
.(
loop1	lda ProgrammableCountdown
	bne loop1
.)
	rts

ManageBeePosition
	;Move Bees?
	lda BeeTravellingFlag
.(
	beq skip1
	
	;Fetch the current Bee position
	lda BeeOriginX
	ldy BeeOriginY
	
	;Have we reached the destination?
	cmp BeesDestinationX
	bne skip2
	cpy BeesDestinationY
	beq ReachedDestination
	
skip2	;Progress X
	cmp BeesDestinationX
	bcc IncBeeX
DecBeeX	dec BeeOriginX
	jmp skip3
IncBeeX	inc BeeOriginX

skip3	;Progress Y
	cpy BeesDestinationY
	bcc IncBeeY
DecBeeY	dec BeeOriginY
	rts
IncBeeY	inc BeeOriginY
	rts
	
ReachedDestination
	lda #00
	sta BeeTravellingFlag
skip1	rts
.)

SpeedDampener
	lda ProgrammableCountdown
	bne SpeedDampener
	lda #2
	sta ProgrammableCountdown
	rts

SetupLevel
	;Unpack Level Map here
	
	ldx LevelID
	
	lda LevelStart_MapX,x
	sta MapX
	
	lda LevelStart_HeroX,x
	sta HeroX
	
	lda #30
	sta HeroY
	
	lda LevelStart_Fairies2Collect,x
	sta HeroRequiredFairies
	jsr DisplayRequiredFairies
	
	lda #00
	sta usm_SunMoonYPos
	jsr DisplayLives
	
	lda #25
	sta SecondCounter
	rts


;TestWriteBinaryKeys
;	ldx #6
;.(
;loop1	lda KeyRegister
;	ldy #16
;	and Bitpos,x
;	beq skip1
;	iny
;skip1	tya
;	sta $BF68,x
;	dex
;	bpl loop1
;.)
;	rts	

#include "LevelSpecificData.s"
#include "Frontend.s"
#include "GenericCode.s"
#include "NPC_Engine.s"
#include "GenericTables.s"
#include "GenericVariables.s"
#include "CommonRoutines.s"
#include "Tiles.s"
#include "GraphicBlocks.s"
#include "GraphicSprites.s"	;gfx in shared/euph1007/disks/ssm73_*/npcs.mem
Stormlord_Map
#include "Stormlord_Map.s"
Stormlord_Map_End
#include "MapCode.s"
#include "HeroCode.s"
#include "IRQRoutine.s"
#include "HeroFire.s"
#include "Unpack.s"
#include "sfx.s"
#include "sfx_scripts.s"
#include "PackedLevel1.s"
#include "PackedLevel2.s"
#include "PackedLevel3.s"
#include "Wave_Player.s"
#include "CompiledMusic.s"
#include "JoystickDrivers.s"
#include "SafeZones.s"
#include "SetTimeLimit.s"
BB80Restoration
 .byt $06,$40,$40,$58,$50,$4B,$40,$C9,$43,$40,$49,$4E,$60,$40,$40,$40,$40,$4E,$60,$40,$40,$40,$42,$4E,$60,$40,$40,$40,$40,$6E,$64,$40,$58,$02,$76,$06,$76,$43,$40,$40
ClearLowerScreen
	ldx #00
	txa
.(
loop1	sta $BD88,x
	sta $BE88,x
	sta $BEDF,x
	inx
	bne loop1
.)
	rts


Himem
 .byt 0

TopOfMemory
 .dsb $A000-*
HiresScreen
#include "TwilighteLogo.s"
ScorePanelArea	;b770
#include "ScorePanel.s"
;BD88-BF3F - Fill remainder of screen with 0
;RestOfHires
;.dsb $BF40-*
;;BF40-BF67 - Spare 40 bytes
;BB80Restoration
; .byt $06,$40,$40,$58,$50,$4B,$40,$C9,$43,$40,$49,$4E,$60,$40,$40,$40,$40,$4E,$60,$40,$40,$40,$42,$4E,$60,$40,$40,$40,$40,$6E,$64,$40,$58,$02,$76,$06,$76,$43,$40,$40
;;BF68-BFDE - Text Area
;TextArea
; .dsb 119,0
;;BFDF - HIRES Switch
;HIRESSwitch
; .byt 30	;28
;;BFE0-BFFF - Spare 32 bytes
;HimemSpare
; .dsb 32,0


