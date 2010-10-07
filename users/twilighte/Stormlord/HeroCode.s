;HeroCode.s
;X 128	Resign Level
;F 64	Shoot
;L 32	Left
;R 16	Right
;U 8	Jump
;D 4

HeroNPCCollisionDetected
	lsr
	lsr
	lsr
	lsr
	tax
	
	;Is Bonus level Fairy Collision?
	lda MapX
	cmp #237
	beq HeroControlContinue
	
	dex
	
	;Is NPC EggWasp?
	lda NPC_Activity,x
	cmp #NPCA_EGGWASP
.(
	bne skip1
	
	;Is NPC still in Egg or Hatch phase?
	;It seems these NPC's are just too difficult to get passed
	lda NPC_Progress,x
	bpl HeroControlContinue
	jmp DeathSequence
	
skip1	;Is NPC raindrop?
	cmp #NPCA_RAINDROP
	bne skip2
	
	;Is Hero holding the Umbrella?
	lda HeroHolding
	cmp #OBJECT_UMBRELLA
	beq HeroControlContinue
	
skip2	jmp DeathSequence
.)

HeroControl
	;Check Hero collision with NPC's here
	;The hero is 4x24 so to give player the benefit of the doubt we'll only detect NPC's
	;in centre two bytes. For height we'll also only read on centre 2 bytes.
	lda HeroY
	clc
	adc #6
	tay
	lda HeroX
	adc #1
	adc CollisionMapYLOCL-30,y
	sta cmap
	lda CollisionMapYLOCH-30,y
	adc #00
	sta cmap+1
	ldx #3
.(
loop1	ldy HeroOffsetsInCollisionMap,x
	lda (cmap),y
	and #$F0
	beq skip1
	cmp #$D0
	bcc HeroNPCCollisionDetected
skip1	dex
	bpl loop1
.)
HeroControlContinue
	lda JumpPhase
	bne DealWithJumpMoves
	;Ground check
	jsr CheckBelowInCollisionMap
.(
	bcs skip1
	
	;Falling..
	jsr DeleteHero
	;When falling Synchronise y position to 1 6th then fall every 6 pixels
	lda #4
	sta InternalFallCount
loop1	dec InternalFallCount
	beq skip2
	lda HeroY
	clc
	adc #2
	ora #1	;Allign to blue head, red arms
	sta HeroY
	cmp #$70
	bcc skip4
	jmp DeathSequence
skip4	jsr CheckBelowInCollisionMap
	bcc loop1
skip2
	jsr PlotHero
	;If Falling then avoid jumping again
	jmp skip3

skip1	lda KeyRegister
	and #CTRL_UP
	beq skip3
	;Don't allow jump whilst jumping
	lda JumpPhase
	bne skip3
	jsr JumpUp

skip3	lda KeyRegister
.)
	and #CTRL_LEFT
.(
	beq skip1
	jsr MoveLeft
skip1	lda KeyRegister
.)
	and #CTRL_RIGHT
.(
	beq skip1
	jsr MoveRight
skip1	lda KeyRegister
.)
	and #CTRL_FIRE
.(
	beq skip1
	jmp HeroFire
skip1	lda FirePressedPeriod
	beq skip2
	cmp #16
	bcs skip4
	;Don't spawn Orb if on fairy screen
	lda MapX
	cmp #237
	beq skip4
	jsr SpawnOrb
skip4	lda #00
	sta FirePressedPeriod
skip2	rts
.)

DealWithJumpMoves
	;First control Heroes Y pos
	jsr DeleteHero
	lda HeroY
	clc
	adc JumpStep
	ora #1
.(
	sta vector1+1
	tay
	ldx HeroX
	jsr CheckHorizontalsInCollisionMap
	bcs StopJump
vector1	lda #00
	
	;Prevent jumping beyond top of screen
	cmp #30
	bcc StopJump
	sta HeroY
	inc JumpStep
	bmi Rising
	
	;Falling
	jsr CheckBelowInCollisionMap
	bcc skip3
	
	;Synchronise hero to platform just landed on
loop9	dec HeroY
	jsr CheckBelowInCollisionMap
	bcs loop9
	
StopJump	lda #00
	sta JumpPhase
;	jmp skip1
skip3
Rising
	;Whilst airbourne permit fire, left and right
	lda KeyRegister
	and #CTRL_LEFT
	beq skip2
	jsr MoveLeft
skip2	lda KeyRegister
	and #CTRL_RIGHT
	beq skip1
	jsr MoveRight
;	jmp PlotHero
skip1
.)
	lda KeyRegister
	and #CTRL_FIRE
.(
	beq skip1
	jsr HeroFire
skip1	lda FirePressedPeriod
	beq skip2
	cmp #16
	bcs skip4
	;Don't spawn Orb if on fairy screen
	lda MapX
	cmp #237
	beq skip4
	jsr SpawnOrb
skip4	lda #00
	sta FirePressedPeriod
skip2	rts
.)

	
JumpStep	.byt 0	
JumpPhase .byt 0

MoveLeft
	lda HeroX
	cmp #2
.(
	bcc skip3
	
	jsr CheckLeftInCollisionMap
	bcs skip1
	
	lda ObjectSwapped
	beq skip5
	;If the object was swapped and the hero was facing right(8) then reset ObjectSwapped
	lda SwappedDirection
	beq skip5
	lda #00
	sta ObjectSwapped
skip5	lda HeroFrame
	and #7
	clc
	adc #1
	cmp #6
	bcc skip2
	lda #00
skip2	ora #8
	sta HeroFrame
	php
	tax
	lda HeroGraphicStep,x
	beq NoByteMovement
	jsr DeleteHero
NoByteMovement
	ldx HeroFrame
	plp
	lda HeroX
	adc HeroGraphicStep,x
	sta HeroX
	;Trigger Footstep SFX
	jsr CheckFootDown
	jsr PlotHero
skip1	rts
skip3	jmp ExitLeft
.)

MoveRight
	lda HeroX
	cmp #35
.(
	bcs skip4
	
	jsr CheckRightInCollisionMap
	bcs skip1
	
	lda ObjectSwapped
	beq skip5
	;If the object was swapped and the hero was facing left(0) then reset ObjectSwapped
	lda SwappedDirection
	bne skip5
	lda #00
	sta ObjectSwapped
skip5	lda HeroFrame
	clc
	adc #1
	cmp #6
	bcc skip2
	lda #00
skip2	sta HeroFrame
	tax
	lda HeroX
	adc HeroGraphicStep,x
	cmp HeroX
	beq skip3
	pha
	jsr DeleteHero
	pla
skip3	sta HeroX
	;Trigger Footstep SFX
	jsr CheckFootDown
	jsr PlotHero
skip1	rts
skip4	jmp ExitRight
.)
	
CheckFootDown
	jsr CheckBelowInCollisionMap
.(
	bcc skip1

	lda JumpPhase
	bne skip1
	lda HeroFrame
	and #7
	beq FootDown
	cmp #3
	bne skip1
FootDown	lda #SFX_FOOTSTEP
	jsr KickSFX
skip1	rts
.)	

;We use a 2's compliment number to perform the jump height curve
;Setting it to 240 then incrementing in steps of 2
JumpUp
	;Initialise jump with range which depends if hero posesses the boots
	;04 Object 1 Key
	;05 Object 2 Honey
	;06 Object 3 Umbrella
	;07 Object 4 Boots
	ldy #247	;Default jump height
	lda HeroHolding
	cmp #7
.(
	bne skip1
	ldy #244
skip1	sty JumpStep
.)
	lda #1
	sta JumpPhase
	rts

HeroFire	;Hero Fire is based on the length of time FIRE is held down
	;Short Press - Fire orb
	;Long Press  - Fire Sword
	lda FirePressedPeriod
	cmp #FIREPERIOD4SWORD
.(
	bcs skip2
	inc FirePressedPeriod
skip1	rts
skip2	;Is Hero on bonus Fairy bit?
	lda MapX
	cmp #237
	bne skip3
	jsr SpawnHeart
	jmp skip4
skip3	jsr SpawnSword
skip4	lda #00
	sta FirePressedPeriod
	rts
.)
	
	
CheckBelowInCollisionMap
	lda #128
	sta LastSafeX
	ldx HeroX
	lda HeroY
	clc
	adc #24
	tay
	jsr CheckHorizontalsInCollisionMap
	lda LastSafeX
.(
	bmi skip1
	sta ReEntryPointX
	lda MapX
	sta ReEntryPointMapX
	lda HeroY
	sta ReEntryPointY
skip1	rts
.)	
LastSafeX		.byt 128
ReEntryPointX	.byt 20
ReEntryPointMapX	.byt 0
ReEntryPointY	.byt 0
	
;CheckAboveInCollisionMap
;	ldx HeroX
;	lda HeroY
;	sec
;	sbc #6
;	tay

CheckHorizontalsInCollisionMap
	cpy #30
.(
	bcc skip3
	txa
	clc
	adc CollisionMapYLOCL-30,y
	sta cmap
	lda CollisionMapYLOCH-30,y
	adc #00
	sta cmap+1
	sec
	ldy #02
loop1	lda (cmap),y
	and #15
	bne skip1
	dey
	bne loop1
skip1	cmp #1
	bcc skip2
	jsr ProcessCollision
	;Also check if on temporary ledge or Triffid
	
skip3	sec
skip2	rts
.)


CheckRightInCollisionMap
	lda HeroX
	clc
	adc #3
	jmp CheckVerticalsInCollisionMap
CheckLeftInCollisionMap
	lda HeroX
	clc
CheckVerticalsInCollisionMap
	ldy HeroY
	adc CollisionMapYLOCL-30,y
	sta cmap
	lda CollisionMapYLOCH-30,y
	adc #00
	sta cmap+1
	sec
	ldy #00
	lda (cmap),y
.(
	and #15
	bne skip1
	
	ldy #40
	lda (cmap),y
	and #15
	bne skip1
	
	ldy #80
	lda (cmap),y
	and #15
	bne skip1
	
	ldy #120
	lda (cmap),y
	and #15
skip1	cmp #1
	bcc skip2
	jsr ProcessCollision
	sec
skip2	rts
.)

;B0-3 Static Collisions
; 00 Background
; 01 Wall/Surface/Solid
; 02 Death(Flames)
; 03 Temporary Ledge(Blue)
; 04 Object 1 Key
; 05 Object 2 Honey
; 06 Object 3 Umbrella
; 07 Object 4 Boots
; 08 Fairy
; 09 Door
; 10 Trampolene
; 11-15 -
;B4-7 Sprite Collisions
; 00 Background
; 01-0C NPC Index
; 0D Hero Orb
; 0E Hero Sword
; 0F -
ProcessCollision	;Collision in A
	;Is Hero at left border?
	ldx HeroX
	cpx #2
.(
	bcs skip1
	jmp ExitLeft

skip1	;Is Hero at Right Border
	cpx #35
	bcc skip2
	jmp ExitRight

skip2	;Are we on Bonus level?
	ldy MapX
	cpy #237
	bne skip11
	;Was collision with Tear?
	cmp #BCKC_TEARS
	bcs skip10
	
skip11	;Was collision with Death?
	cmp #BCKC_DEATH
	bne skip3

	jmp DeathSequence

skip3	;Was collision with Temporary Ledge?
	cmp #BCKC_ICELEDGE
	bne skip8
	jmp ActivateLedgeDestruction
	
skip8	;Was collision with solid?
	bcs skip9
	;If solid then mark this position as re-entry point after death
	lda HeroX
	sta LastSafeX
	jmp skip4
skip9	;Was collision with Object?
	cmp #BCKC_FAIRY
	bcs skip5
	jmp SwapObject

skip5	;Was collision with Fairy?
	bne skip6
	jmp FreeFairy
	
skip6	;Was collision with Door?
	cmp #BCKC_DOOR
	bne skip7
	jmp CheckDoor
	
skip7	;Was collision with trampolene?
	cmp #BCKC_TRAMPOLENE
	bne skip4
	jmp HitTrampolene
	
skip4	rts

skip10	;Found tear
.)
	;Calculate NPC Index
	sec
	sbc #4
	tax
	
RemoveTear
	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_RAINDROP	;3x8
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Remove from collision map
	ldy NPC_ScreenX,x
	lda #0
	sta CollisionMap+40*14,y

	;Destroy NPC
	jsr DestroyNPC

	;Award Life, score and sfx
	lda HeroLives
	cmp #9
.(
	bcs skip1
	inc HeroLives
	jsr DisplayLives
skip1
.)
;	lda #
;	jsr KickSFX
	
	lda #$75
	jsr AddScore
	jmp DisplayScore


ExitLeft
	lda MapX
.(
	beq skip1
	sec
	sbc #14
	sta MapX
	
;	bne skip998
;skip999	nop
;	jmp skip999
;skip998

;	jsr ClearCollisionMap
;	sec
	jsr DrawMap
;	jsr CheckRepositionBees
;	jsr GenerateCollisionMap
	;Reposition Hero to opposite side of screen
	lda #29
	sta HeroX
	lda #00
	sta JumpPhase
	lda #255
	sta UltimateProjectile
	jmp PlotHero
skip1	rts
.)	
	
	
ExitRight
	lda MapX
	cmp #238
.(
	bcs skip1
	adc #14
	sta MapX
;	jsr ClearCollisionMap
;	sec
	jsr DrawMap
;	jsr CheckRepositionBees
;	jsr GenerateCollisionMap
	;Reposition Hero to opposite side of screen
	lda #7
	sta HeroX
	lda #00
	sta JumpPhase
	lda #255
	sta UltimateProjectile
	jmp PlotHero
skip1	rts
.)

CheckRepositionBees
	;Was the honeypot found?
	lda HoneypotPresent
.(
	beq skip1
	;Are their bees on this screen?
	lda MapX
	cmp #70
	beq skip2
	cmp #168
	bne skip1
skip2	;Transfer Object_X and Object_Y to beeorigins
	ldx HoneypotSOS
	lda Object_X,x
	asl
	sta vector1+1
	asl
vector1	adc #00
	sta BeeOriginX
	lda Object_Y,x
	clc
	adc #24
	sta BeeOriginY
skip1	rts
.)	

ActivateLedgeDestruction
	rts
	
	

SwapObject
	;Match object with Recorded one for this screen
	ldx ObjectIndex
.(
loop1	cmp Object_CollisionValue,x
	beq skip1
	dex
	bpl loop1
	;Report Error
;	lda #17
;	sta $BF68
	rts
skip1
.)
	;Fetch map location for this object
	lda Object_MapLo,x
	sta map
	lda Object_MapHi,x
	sta map+1
	stx ReservedSOBIndex

	;Record object on screen (4-7)
	lda Object_CollisionValue,x
	sta ThisOneIsToHold

	;Does Hero already hold an object?
	ldy HeroHolding
.(
	bmi skip2
	
	;We need to make sure this swapping only occurs once!!
	lda ObjectSwapped
	beq skip5
	rts
	
skip5	;Object not swapped before, so mark as swapped and store Current hero dir
	inc ObjectSwapped
	lda HeroFrame
	and #8
	sta SwappedDirection

	;Place held item in map
	lda ObjectsMapCode-4,y
;	tax
	ldy #00
	sta (map),y
	iny
	clc
	adc #1
	sta (map),y
	
	ldy HeroHolding
	lda ObjectSFX-4,y
	jsr KickSFX
	
	;Is object placed on map the honeypot?
	lda HeroHolding
	cmp #BCKC_OBJECTHONEY
	bne skip4
	;Does this screen contain bees?
	lda BeesPresentHere
	beq skip4
	;Now move the bees to this honeypot
	jsr InitiateBeesJourney

skip4	;Swap object
	ldx HeroHolding
	;This is a collision value so we need to change back to a blockid
	ldy ObjectsMapCode-4,x
	sty Object2Plot
	iny
	sty Object2Plot+1
	
	;Object must also be swapped in Object_ tables
	lda ObjectsMapCode-4,x
	ldy ReservedSOBIndex
	sta Object_BlockID,y
	txa
	sta Object_CollisionValue,y

	jmp skip3

skip2	;Hero was not holding an object
	lda #00
	sta Object2Plot
	sta Object2Plot+1
	
	;remove object from map
	lda #00
	tay
	sta (map),y
	iny
	sta (map),y

	jsr skip3
	
	;Object tables must be updated and shrunk
	ldx ReservedSOBIndex
	jmp RemoveObjectFromList

skip3
	ldx ThisOneIsToHold
	lda ObjectSFX-4,x
	jsr KickSFX
	
	;Remove or swap Object from screen 2x1
	ldx #01

loop1	stx TempX
	ldy ReservedSOBIndex
	lda Object_Y,y
	clc
	adc ObjectDeletionYOffset,x
	sta dm_CursorY
	lda Object_X,y
	clc
	adc ObjectDeletionXOffset,x
	sta dm_CursorX
	lda Object2Plot,x
	sta MomentaryBlock
	jsr PlotBlock2Screen
	jsr PlotBlock2BGBuff
	jsr PlotBlock2CMAP
	ldx TempX
	dex
	bpl loop1
	
skip1	;Place Map item in pocket
.)
	lda ThisOneIsToHold
	sta HeroHolding
	
	;Update score
	lda #$05
	jsr AddScore
	jsr DisplayScore
	
	;Update Held Object Display in Score panel
	jmp DisplayHeldObject

InitiateBeesJourney
	;Calculate bees destination x/y
	lda Object_X,x
	jsr Mult6
	sta BeesDestinationX
	lda Object_Y,x
	jsr Mult6
	clc
	adc #24
	sta BeesDestinationY
	lda #1
	sta BeeTravellingFlag
	rts
	
CheckDoor	;Does Hero have a key?
	lda HeroHolding
	cmp #4
.(
	bne skip2
	
	;Locate Door
	lda #9
	ldx ObjectIndex
loop1	cmp Object_CollisionValue,x
	beq skip1
	dex
	bpl loop1
	;Report Error
;	lda #18
;	sta $BF68
	rts

skip1	lda #SFX_OPENDOOR
	jsr KickSFX
	;Remove door from map(2x2)
	stx Purging_ObjectIndex
	lda Object_MapLo,x
	sta map
	lda Object_MapHi,x
	sta map+1
	lda #00
	tay
	sta (map),y
	iny
	sta (map),y
	inc map+1
	sta (map),y
	dey
	sta (map),y
	
	;Remove Held key
	lda #255
	sta HeroHolding
	
	;Wipe key from score panel
	jsr EraseDisplayedObject
;	lda #<$A000+24+154*40
;	sta screen
;	lda #>$A000+24+154*40
;	sta screen+1
;	jsr EraseBlock
;	lda #<$A000+26+154*40
;	sta screen
;	lda #>$A000+26+154*40
;	sta screen+1
;	jsr EraseBlock

	;Refresh screen, bgbuff and collision map
	jsr Remove2x2Blocks

	;Add score
	lda #$50
	jsr AddScore
	jsr DisplayScore
	
	;Refresh Hero
	jsr PlotHero
skip2	rts
.)

FreeFairy
	;Locate Fairy
	lda #8
	ldx ObjectIndex
.(
loop1	cmp Object_CollisionValue,x
	beq skip1
	dex
	bpl loop1
	;Report Error
;	lda #19
;	sta $BF68
	rts

skip1	;Remove Fairy from map(2x2)
.)
	lda #SFX_COLLECTFAIRY
	jsr KickSFX

	stx Purging_ObjectIndex
	lda Object_MapLo,x
	sta map
	lda Object_MapHi,x
	sta map+1
	lda #00
	tay
	sta (map),y
	iny
	sta (map),y
	inc map+1
	sta (map),y
	dey
	sta (map),y
	
	;Add Fairy to acquired
	inc HeroCapturedFairies
	
	;Display in score panel
	jsr DisplayCapturedFairies
	
	;We should branch here if all the fairies have been freed
	lda HeroCapturedFairies
	cmp HeroRequiredFairies
.(
	bcc skip1
	
	;For bonus level, act like trampolene with MapX destination 237 in Trampolene tables
	jsr EraseDisplayedObject
	jmp HitTrampolene

skip1	;Refresh screen, bgbuff and collision map
.)
	jsr Remove2x2Blocks

	;Add score
	lda #$75
	jsr AddScore
	jsr DisplayScore
	
	;Refresh Hero
	jmp PlotHero
	
Remove2x2Blocks
	;Remove Fairy from screen 2x2
	ldx #03
.(
loop1	stx TempX
	ldy Purging_ObjectIndex
	lda Object_Y,y
	clc
	adc ObjectDeletionYOffset,x
	sta dm_CursorY
	lda Object_X,y
	clc
	adc ObjectDeletionXOffset,x
	sta dm_CursorX
	lda #00
	sta MomentaryBlock
	jsr PlotBlock2Screen
	jsr PlotBlock2BGBuff
	jsr PlotBlock2CMAP
	ldx TempX
	dex
	bpl loop1
.)	
	;Remove Fairy from Object List
	ldx Purging_ObjectIndex
	jmp RemoveObjectFromList



;Remove object x from Object_ tables and shrink
RemoveObjectFromList
	;Is x same as Count-1?
	cpx ObjectIndex
	
	;If it is then just shrink
.(
	beq skip1
	
	;Transfer Object_ tables from x
	ldy ObjectIndex
	lda Object_X,y
	sta Object_X,x
	lda Object_Y,y
	sta Object_Y,x
	lda Object_MapLo,y
	sta Object_MapLo,x
	lda Object_MapHi,y
	sta Object_MapHi,x
	lda Object_BlockID,y
	sta Object_BlockID,x
	lda Object_CollisionValue,y
	sta Object_CollisionValue,x
	
skip1	;Shrink List
.)
	dec ObjectIndex
	rts


	
ObjectDeletionXOffset
 .byt 0,2,0,2
ObjectDeletionYOffset
 .byt 0,0,2,2
TempX		.byt 0
Purging_ObjectIndex	.byt 0

HitTrampolene
	lda #SFX_USETRAMPOLENE
	jsr KickSFX
	;If the trampolene is being called because the hero has all the fairies
	;we'll need to do things a bit different
	lda HeroCapturedFairies
	cmp HeroRequiredFairies
.(
	bne skip6
	;In this scenario the destination is always 237
	;Set trampolene id to 19 and write to tables
	ldx #19
	lda #237
	sta TrampolenesEndMapX,x
	lda #20
	sta TrampolenesEndHeroX,x
	jmp skip5
skip6	;Find out destination of trampolene (5 on level 0)
	ldx #0
loop1	lda TrampolenesLevelID,x
	bmi skip4
	cmp LevelID
	bne skip1
	lda TrampolenesStartMapX,x
	cmp MapX
	beq skip2
skip1	inx
	jmp loop1
skip4	rts
skip2	;If the Fairy was collected from the place this trampolene took the hero we should
	;disable the trampolene here, though we don't currently
	
	lda HeroFrame
	ldy TrampolenesEndMapX,x
	
skip5	;Decide on direction the hero should face
	cpy MapX
	and #7
	bcs skip3
	ora #8
skip3	sta HeroFrame
.)	
	stx ThisTrampolenesID
	
	;Raise hero to top of screen
.(
loop1	jsr DeleteHero
	
	lda HeroY
	sec
	sbc #6
	ora #1
	sta HeroY
	
	cmp #36
	bcc HeroAtTop
	
	jsr PlotHero
	
	;Delay
	jsr SpeedDampener
	
	jmp loop1
.)

HeroAtTop	;Clear screen
	jsr ClearScreen
	
	;Set hero to bottom of screen
	lda #103
	sta HeroY
	
	;Now entering parralax starfield phase - Calculate difference in mapX's
	ldx ThisTrampolenesID
	lda TrampolenesEndMapX,x
	cmp MapX
.(
	bcc skip2
	sbc MapX
	ldy #STARFIELD_EAST
	jmp skip1
skip2	ldy #STARFIELD_WEST
	lda MapX
	sbc TrampolenesEndMapX,x
skip1	asl
	sta StarfieldDistance
.)
	sty StarfieldDirection

	;Move Hero to centre stage
	lda #20
	sta HeroX
	
	;Setup Parralax scrolling
	ldx #99
.(	
loop1	;Randomise X
	jsr GetRandomNumber
	
	;Ensure X is no wider than 232
	cmp #232
	bcc skip1
	sbc #232

skip1	;Add 8 to avoid ink column
	clc
	adc #8
	sta StarfieldX,x
	
	;Randomise Y
	jsr GetRandomNumber
	
	;Ensure Y is no taller than 108
	and #127
	cmp #108
	bcc skip2
	sbc #108
	
skip2	;Add 30 to bring into screen bounds
	clc
	adc #30
	sta StarfieldY,x
	
	;Randomise step(Defines number of layers)
	;Step is 2's compliment to allow same parralax routine for both left and right scrolls
	;So for moving right steps should be from 1 to 8 and for Left from 248-255
	jsr GetRandomNumber
	and #7
	clc
	adc StarfieldDirection	;Add either 1(Right) or 248(Left)
	sta StarfieldStep,x
	
	dex
	bpl loop1
.)
	;Kick starfield sfx
	lda #SFX_STARFIELD
	jsr KickSFX

	;Process starfield
.(
loop2	ldx #99
	
loop1	;Delete pixel
	ldy StarfieldX,x
	lda BitMap,y
	eor #63+64
	sta sfTemp01
	lda XLOC,y
	ldy StarfieldY,x
	jsr RecalcScreen
	ldy #00
	lda (screen),y
	and sfTemp01
	sta (screen),y
	
	;Move star
	lda StarfieldStep,x
	bmi MovingStarfieldLeft
MovingStarfieldRight
	adc StarfieldX,x
	cmp #240
	bcc skip1
	lda #8
	jmp skip1
MovingStarfieldLeft
	adc StarfieldX,x
	cmp #8
	bcs skip1
	lda #239
skip1	sta StarfieldX,x

	;Plot star
	tay	;ldy StarfieldX,x
	lda BitMap,y
	sta sfTemp01
	lda XLOC,y
	ldy StarfieldY,x
	jsr RecalcScreen
	ldy #00
	lda (screen),y
	ora sfTemp01
	sta (screen),y
	
	dex
	bpl loop1
	
	
	;Delete hero only if descending
	lda StarfieldDistance
	cmp #10
	bcs skip4
	jsr DeleteHero
	
	lda HeroY
	cmp #103
	bcs skip2
	adc #6
	sta HeroY
	jmp skip2
skip4	lda HeroY
	cmp #36
	bcc skip2
	jsr DeleteHero

	lda HeroY
	sbc #6
	sta HeroY

skip2	jsr PlotHero

	
	;Count down 
	dec StarfieldDistance
	beq skip3
	jmp loop2
skip3
.)
	;Clear Screen
	jsr ClearScreen

	;Move to destination of Trampolene
	ldx ThisTrampolenesID
	lda TrampolenesEndMapX,x
	sta MapX
	
	;Position Hero correctly
	lda TrampolenesEndHeroX,x
	sta HeroX
	lda #34
	sta HeroY

	;If new MapX is 237 then bonus level, so set speed of sunmoon to high and reset sunmoon ypos
	lda MapX
	cmp #237
.(
	bne skip1
	jsr SetTimeLimit
;	lda #00
;	sta usm_SunMoonYPos
;	ldx Option_Difficulty
;	lda BonusSpeed,x
;	sta CounterReference
	lda #$67
	sta HeroY

skip1	;Refresh screen, bgbuff and collision map
.)
	jsr DrawMap
	
	;Refresh Hero
	jmp PlotHero

DeathSequence
	;Descend hero to ground
	jsr CheckBelowInCollisionMap
.(
	bcs skip1
	
	;Falling..
	jsr DeleteHero
	;When falling Synchronise y position to 1 6th then fall every 6 pixels
	lda #4
	sta InternalFallCount
loop1	dec InternalFallCount
	beq skip2
	lda HeroY
	clc
	adc #2
	ora #1	;Allign to blue head, red arms
	sta HeroY
	cmp #$70
	bcs skip1
skip4	jsr CheckBelowInCollisionMap
	bcc loop1
skip2
	jsr PlotHero
	
	jsr SpeedDampener
	jmp DeathSequence

skip1	;Animate with frame 06 then 07
.)
	lda #6
	sta HeroFrame
	jsr PlotHero
	lda #10
	sta ProgrammableCountdown
	jsr SpeedDampener
	lda #7
	sta HeroFrame
	jsr PlotHero
	
	;Wait a while longer
	lda #10
	sta ProgrammableCountdown
	jsr SpeedDampener
	
	;Delete Hero
	jsr DeleteHero
	
	;Clear screen
	jsr ClearScreen

	;decrement lives
	dec HeroLives
	beq GameOver
	
	;Display lives
	jsr DisplayLives
	
	;Return to last trampolene or level start x/y
	jsr RestoreHero2SafeZone
	lda #00
	sta HeroFrame
	sta JumpPhase
	
	;Refresh screen, bgbuff and collision map
	jsr DrawMap
	
	;Also clear single line just below play area since this often contains crap
	ldx #39
	lda #64
.(
loop1	sta $A000+40*138,x
	dex
	bpl loop1
.)	
	;Refresh Hero
	jmp PlotHero

GameOver
	;Display Game Over mid screen
	ldx #OVERLAY_GAMEOVER
	jsr DisplayOverlay
	lda #GAME_NOMORELIVES
	sta GameAction
	rts

PlotHero
	lda HeroX
	ldy HeroY
	jsr RecalcScreen
	
	lda HeroX
	ldy HeroY
	sec
	sbc #1
	jsr RecalcBGBuff

	ldx HeroFrame
	lda HeroBMPGraphicAddressLo,x
	sta graphic
	lda HeroBMPGraphicAddressHi,x
	sta graphic+1

	lda HeroMSKGraphicAddressLo,x
	sta mask
	lda HeroMSKGraphicAddressHi,x
	sta mask+1

	ldx #24
.(	
loop2	ldy #3
loop1	lda (bgbuff),y
	bpl skip1
	eor #63
	and (mask),y
	ora (graphic),y
	eor #63+128
	jmp skip2
skip1	and (mask),y
	ora (graphic),y
skip2	sta (screen),y
	dey
	bpl loop1
	
	lda graphic
	clc
	adc #4
	sta graphic
	lda graphic+1
	adc #00
	sta graphic+1
	
	jsr nlScreen
	
	lda mask
	adc #4
	sta mask
	lda mask+1
	adc #00
	sta mask+1
	
	lda bgbuff
	adc #40
	sta bgbuff
	lda bgbuff+1
	adc #00
	sta bgbuff+1
	
	dex
	bne loop2
.)
	rts

;Remove hero from screen by restoring his current loc with the bgbuff
DeleteHero
	lda HeroX
	ldy HeroY
	jsr RecalcScreen

	;Reduce Y to play area range
	lda HeroX
	ldy HeroY
	sec
	sbc #1
	jsr RecalcBGBuff

	ldx #24
.(	
loop2	ldy #3
loop1	lda (bgbuff),y
	sta (screen),y
	dey
	bpl loop1
	jsr nlBgbuff
	jsr nlScreen
	dex
	bne loop2
.)
	rts

CheatCode2
 .byt "MAYBE THE CHEAT IS HERE SOMEWHERE.."
