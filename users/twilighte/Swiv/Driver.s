;Swiv Driver.s

#include "CommonDefines.s"
#include "OSS_LanguageDefines.s"

 .zero
*=$00
#include "zeropage.s"

 .text
*=$500
;0500-9FFF Game Code(39680)
;A000-BFDF HIRES
;BFE0-BFFF Spare
;C000-FDFF Level Data(15,872)
;FE00-FFF7 Disc Code
;FFF8-FFFF System vectors

Driver	sei
	jsr FrontEnd
	jsr SetupGame
	;Player Status
	;0    Dead
	;1    Alive
	;128  Just Died
	;129- Dying
	lda #1
	sta PlayerB_Status
	lda #1
	sta PlayerA_Status

;On entering Big Loop one or both players will begin playing (Depending on Player Settings)
;If either player is not playing then they will be set to Dead in Player?Status
.(
BigLoop	;On each game cycle count down the FireFrequency Counter if it is more than Zero
	;We put this here so that we get a much more reactive firing mechanism and can
	;control (through pickups) the regularity of firing.
	lda FireFrequencyCounterA
	beq skip4
	dec FireFrequencyCounterA
skip4	lda FireFrequencyCounterB
	beq skip5
	dec FireFrequencyCounterB
skip5	;During play if a player dies we must branch to process the death (dec lives,check both dead, etc)
	;At no point will both players be dead(but may be dying)
	lda PlayerA_Status	;0(Dead)
	beq skip2
	jsr PlayerA_HeroControl_EuphoricKeyboard
skip2	lda PlayerB_Status	;0(Dead)
	beq skip3
	jsr PlayerB_HeroControl_EuphoricKeyboard
skip3	jsr CyclicCopyBGBuffer	;Cyclic Copy BGBuffer to ScreenBuffer
	jsr UpdateBackground	;Populate 2 Rows of BGBuffer
	jsr UpdateBGBPointers	;Update bgb Pointers
skip1	jsr ossScript_Driver	;Manage all sprites
	jsr ProjectileDriver	;Manage all projectiles
	jsr ZoomScreen		;Copy ScreenBuffer to Display
	jmp BigLoop
.)

SetupGame
	;Setup ZEROPAGE pointers
	lda #00
	sta FireFrequencyCounterA
	sta FireFrequencyCounterB
	sta bgbRowStart
	lda #127
	sta CurrentMapRow
 	lda #88
	sta GraphicBlockRowOffset
	lda #136
	sta bgbPlotRow
	lda #0
	sta PlayerA_Shield
	sta PlayerB_Shield
	sta UniqueID_SequenceNumber
	lda #1
	sta UltimateSprite
	lda #BIT1	;+BIT2+BIT3+BIT4
	sta PlayerA_Weapons
	sta PlayerB_Weapons

	lda #3
	sta PlayerLives
	sta PlayerLives+1
	lda #23
	sta PlayerHealth
	sta PlayerHealth+1
	
	lda #255
	sta UltimateProjectile
	lda #>ProjectileGFX
	sta ProjectileMask+1
	sta ProjectileBitmap+1
	
	
	;Set up PlayerA sprite(initially 00)
	lda #32
	sta Sprite_ScriptID
	lda #00
	sta Sprite_ScriptIndex
	sta Sprite_PausePeriod
	sta Sprite_CurrentDir
	sta Sprite_ConditionID
	sta Sprite_Counter
;	sta PlayerA_SpriteIndex
	lda #8
	sta Sprite_X
	;118 should allign the Players craft to the collision map so that only two cells need to
	;be written giving the advantage to the player and increasing the accuracy of any
	;collision. X/Y Movement is always a multiple of 6 pixels(Default 6 pixels)
	lda #118
	sta Sprite_Y
	lda #65
	sta Sprite_ID
	;Bit3 Show Sprites Shadow (Bonuses,projectiles and ground based sprite don't have shadows)
	;Bits0-1
	; 0 Sprite is single (Never players)
	; 1 Sprite is part of bigger group(Never players)
	; 2 Player A (If Bit5 clear then craft else Projectile)
	; 3 Player B (If Bit5 clear then craft else Projectile)
	lda #2+BIT3
	sta Sprite_Attributes
	;B0-1 Sprite Type
      	;	0 Reserved for No Collision
      	;	1 Player A Craft
      	;	2 Player B Craft
      	;	3 Sprite (Data is UniqueID 0-63)
	;B2-7 Data for Type
	jsr FetchUniqueSequenceID	;A == 0-63
	asl
	asl
	ora #1
	sta Sprite_UniqueID

	lda #00
	sta PlayerA_SpriteIndex
	lda #4
	sta Sprite_Width
	lda #11
	sta Sprite_Height
	lda #43
	sta Sprite_UltimateByte
	
	;Setup PlayerB sprite(initially 01)
	lda #32
	sta Sprite_ScriptID+1
	lda #00
	sta Sprite_ScriptIndex+1
	sta Sprite_PausePeriod+1
	sta Sprite_CurrentDir+1
	sta Sprite_ConditionID+1
	sta Sprite_Counter+1
	lda #12
	sta Sprite_X+1
	lda #118
	sta Sprite_Y+1
	lda #81
	sta Sprite_ID+1
	;Bit3 Show Sprites Shadow (Bonuses,projectiles and ground based sprite don't have shadows)
	;Bits0-1
	; 0 Sprite is single (Never players)
	; 1 Sprite is part of bigger group(Never players)
	; 2 Player A (If Bit5 clear then craft else Projectile)
	; 3 Player B (If Bit5 clear then craft else Projectile)
	lda #3+BIT3
	sta Sprite_Attributes+1
	;B0-1 Sprite Type
      	;	0 Reserved for No Collision
      	;	1 Player A Craft
      	;	2 Player B Craft
      	;	3 Sprite (Data is UniqueID 0-63)
	;B2-7 Data for Type
	jsr FetchUniqueSequenceID	;A == 0-63
	asl
	asl
	ora #2
	sta Sprite_UniqueID+1

;	lda #01
;	sta PlayerB_SpriteIndex
	lda #4
	sta Sprite_Width+1
	lda #11
	sta Sprite_Height+1
	lda #43
	sta Sprite_UltimateByte+1

	rts
#include "OSS_CoreCommands.s
#include "Frontend.s"
Level_Start
#include "Level_1.s"
Level_End
#include "Tables.s"
#include "CommonRoutines.s"
#include "GraphicEngine.s"
#include "OSS_Language.s"
#include "HeroControl.s"
#include "Projectiles_Engine.s"
#include "gfxSprite_Hero.s"
#include "gfsHero_Sprites.s"
#include "gfxExplosion.s"
#include "gfxBonuses.s"
#include "Air_Sprites/gfxGenericBullet_BitmapFrameN.s"
#include "Air_Sprites/gfxGenericBullet_BitmapFrameNE.s"
#include "Air_Sprites/gfxGenericBullet_BitmapFrameE.s"
#include "Air_Sprites/gfxGenericBullet_BitmapFrameSE.s"
#include "Air_Sprites/gfxGenericBullet_BitmapFrameS.s"
#include "Air_Sprites/gfxGenericBullet_BitmapFrameSW.s"
#include "Air_Sprites/gfxGenericBullet_BitmapFrameW.s"
#include "Air_Sprites/gfxGenericBullet_BitmapFrameNW.s"
#include "Air_Sprites/gfxGenericBullet_MaskFrameN.s"
#include "Air_Sprites/gfxGenericBullet_MaskFrameNE.s"
#include "Air_Sprites/gfxGenericBullet_MaskFrameE.s"
#include "Air_Sprites/gfxGenericBullet_MaskFrameSE.s"
#include "Air_Sprites/gfxGenericBullet_MaskFrameS.s"
#include "Air_Sprites/gfxGenericBullet_MaskFrameSW.s"
#include "Air_Sprites/gfxGenericBullet_MaskFrameW.s"
#include "Air_Sprites/gfxGenericBullet_MaskFrameNW.s"

#include "ProcessBonuses.s"
#include "PanelRoutines.s"

#include "Scripts/Script_Explode.s"
#include "Scripts/Script_Bonus.s"

Himem
 .dsb $A000-*

;#include "otype_hires.s"
#include "otype.s"

 .dsb $BFDF-*
HIRESSwitch
 .byt 28

