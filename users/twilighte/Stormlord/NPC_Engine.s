;NPC_Engine.s

;NPC's are...
; The launched Ball
;  Behaviour - The ball is pumped out of the ground launcher. It rises every 2 steps then is catapulted
;              vertically up where it well finally reach a height and decend. It will fall back into the
;              Launcher only to be pumped out again
;  Contact   - Kills hero on contact
;  Quantity  - 1
;  Initialise- Initialised by MapCode
; The flying dragons
;  Behaviour - These fly in from left or right at byte level
;  Contact   - Kills hero on contact
;  Quantity  - Up to 5
;  Initialise- Initialised in Realtime
; Acid Water drops
;  Behaviour - These fall from the clouds to the ground and disperse
;  Contact   - Kills hero on contact (unless he carries the umbrella)
;  Quantity  - Up to 5
;  Initialise- Initialised by MapCode
; Triffid
;  Behaviour - These lye on the ground and will animate if affected by hero
;  Contact   - Kills hero if he falls on them.
;  Quantity  - 1
;  Initialise- Initialised by MapCode
; Grubs
;  Behaviour - These rise from the ledges (only) then scurry to lower levels
;  Contact   - Kills hero on contact
;  Quantity  - Up to 5
;  Initialise- Initialised in Realtime
; Bees
;  Behaviour - These(5?) swarm around blue vase but will be attracted to Honeypot
;  Contact   - Kills hero on contact
;  Quantity  - 5
;  Initialise- Initialised in Realtime
; Egg Wasps
;  Behaviour - These fall from the sky as eggs which break on impact into wasp that oscillates vertically
;  Contact   - Kills hero on contact
;  Quantity  - Up to 5
;  Initialise- Initialised in Realtime
; Fairy (Bonus sections only)
;  Behaviour - X using sine table byte steps, reinitiating on bounds, Y using sine table in x2 pixel steps
;  Contact   - Hero fires hearts which fire vertically upwards and on hitting fairy it throws tear to ground
;	     which remains on floor for 2 seconds that disappears.
;  Quantity  - Up to 5
;  Initialise- Initialised in Realtime
; Spider (New)

;
;Level 1
;0	Ball
;14	Grubs
;28	Grubs
;42	Triffid,Ball
;56	Ball,Triffidx2,Bees(Depends on honeypot)
;70	Bees
;84	Triffid,Eggs
;98	Triffid,Ball,Eggs
;112	Ball
;126	Ballx2,Rain drops
;140	Ballx2,Rain drops
;154	Dragons
;168	Bees(swarm around key)
;182	Bees(around key or honeypot),Triffidx2
;196	Triffid,Ball
;210	-
;224	Bonus Level
;248	-

NPCControl
	lda ssnpc_Type
.(
	bmi skip2
	jsr SpawnRealtimeNPC
skip2	;Control NPC setup in the Map Code
	ldx NPCUltimateIndex
	bmi skip1
loop1	ldy NPC_Activity,x
	lda NPCActivityVectorLo,y
	sta vector1+1
	lda NPCActivityVectorHi,y
	sta vector1+2
	stx npcc_TempX
vector1	jsr $dead
	ldx npcc_TempX
	dex
	bpl loop1
skip1	rts
.)

;Plot Sprite with Mask
;screen
;SpriteFrame
;Preserve X
PlotSpriteWithMask
	stx pswm_TempX
	ldy SpriteFrame
	lda gfxSpriteBMPLo,y
	sta graphic
	lda gfxSpriteBMPHi,y
	sta graphic+1
	lda gfxSpriteMSKLo,y
	sta mask
	lda gfxSpriteMSKHi,y
	sta mask+1
	lda gfxSpriteWidth,y
	sta pswm_TempW
	ldx gfxSpriteHeight,y
.(
loop2	ldy pswm_TempW
	dey
loop1	lda (screen),y
	bpl ProcNormal
ProcInverse
	eor #63
	and (mask),y
	ora (graphic),y
	eor #63+128
	jmp ProcContinue
ProcNormal
	and (mask),y
	ora (graphic),y
ProcContinue
	sta (screen),y
	dey
	bpl loop1
	
	lda graphic
	clc
	adc pswm_TempW
	sta graphic
	lda graphic+1
	adc #00
	sta graphic+1
	
	lda screen
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	
	lda mask
	adc pswm_TempW
	sta mask
	lda mask+1
	adc #00
	sta mask+1
	
	dex
	bne loop2
.)
	ldx pswm_TempX
	rts

RestoreSpriteBG
	stx rsbg_RestorationOfX+1
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
RestoreSpriteBG2
	sec
	sbc #1
	jsr RecalcBGBuff
	
	ldy SpriteFrame
	lda gfxSpriteWidth,y
	sta pswm_TempW
	ldx gfxSpriteHeight,y
.(	
loop2	ldy pswm_TempW
	dey
loop1	lda (bgbuff),y
	sta (screen),y
	dey
	bpl loop1
	
	jsr nlBgbuff
	jsr nlScreen
	dex
	bne loop2
.)
rsbg_RestorationOfX
	ldx #00
	rts


;On each new screen flip or level load the possible screen NPC's are set to Init
;NPC Activities
;00 Ball Rising
;    rising 2 pixels using frames less mask
;01 Ball Bounce
;    Rising and falling using 2's compliment with mask
;02 Ball Delay
;    Delay before ball rises again

;02 Dragon Initiate
;    Init based on hero not being at sides
;    Direction based on side of screen hero is
;    Height is random
;03 Dragon Flight Left
;04 Dragon Flight Right
;05 Dragon Death
;06 Acid Drop Initiate
;    Decent step between 2 and 4(creating parralax)
;    X pos random along length of cloud
;07 Acid Drop flight
;08 Acid drop land and dissipate
;09 Triffid Animate
;10 TriffidMonitoring
;11 Grub Initiate
;12 Grub Rise and look
;13 Grub scurry Left
;14 Grub scurry right
;15 Grub Fall
;16 Grub Death
;17 Bees flight
;    moving in random direction but centred around object
;18 Egg Wasps Initiate
;    From top of screen
;    Decent rate always the same
;19 Egg Decent
;20 Egg Hatch
;21 Wasp Attack
;    Wasp homes on hero with oversteer
;22 Wasp Death
NPCActivityVectorLo
 .byt <BallRising	;0
 .byt <BallBounce   ;1
 .byt <BallPause    ;2
 .byt <GrubPeep     ;3
 .byt <GrubMove     ;4
 .byt <RainDrop     ;5
 .byt <EggWasp	;6
 .byt <DragonLeft   ;7
 .byt <DragonRight  ;8
 .byt <BeeBuzz	;9
 .byt <Destroy	;10
 .byt <Spider	;11
 .byt <Triffid	;12
 .byt <ChannelFairy	;13
 .byt <ThrownTear	;14
 
NPCActivityVectorHi
 .byt >BallRising
 .byt >BallBounce
 .byt >BallPause
 .byt >GrubPeep
 .byt >GrubMove
 .byt >RainDrop
 .byt >EggWasp	;6
 .byt >DragonLeft   ;7
 .byt >DragonRight  ;8
 .byt >BeeBuzz	;9
 .byt >Destroy	;10
 .byt >Spider	;11
 .byt >Triffid	;12
 .byt >ChannelFairy	;13
 .byt >ThrownTear	;14

BallRising
	;Display this frame(3x9)
	lda NPC_Progress,x
	clc
	adc #NPCF_BALL0
	sta SpriteFrame
	
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	
	jsr PlotSpriteWithMask
	
	;Write to Collision Map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jsr PlotNPCInCollisionMap
	
	;Progress NPC
	lda NPC_Progress,x
	adc #1
	cmp #3
	bcs CatapultBall
	sta NPC_Progress,x
	rts

CatapultBall
	lda #NPCA_BALLBOUNCE
	sta NPC_Activity,x
	lda #249
	sta NPC_Progress,x
	
	rts

;A == X(0-39)
;Y == Y(0-137)
RecalcScreen
	;(Yx40)+X+$A000
	sta TempRX
	lda #00
	sta screen+1
	tya
	
	;Yx8
	asl
	rol screen+1
	asl
	rol screen+1
	asl
	rol screen+1
	sta TempLo
	ldy screen+1
	
	;Yx32
	asl
	rol screen+1
	asl
	rol screen+1
	
	;Yx8 + Yx32
	adc TempLo
	sta screen
	tya
	adc screen+1
	tay
	
	;+X
	lda screen
	adc TempRX
	sta screen
	
	;+$A000
	tya
	adc #$A0
	sta screen+1
	rts

;A == X
;Y == Y
RecalcBGBuff
	;(Yx40)+X+(>BackgroundBuffer)
	sta TempRX
	lda #00
	sta bgbuff+1
	tya
	sec
	sbc #30
	
	;Yx8
	asl
	rol bgbuff+1
	asl
	rol bgbuff+1
	asl
	rol bgbuff+1
	sta TempLo
	ldy bgbuff+1
	
	;Yx32
	asl
	rol bgbuff+1
	asl
	rol bgbuff+1
	
	;Yx8 + Yx32
	adc TempLo
	sta bgbuff
	tya
	adc bgbuff+1
	tay
	
	;+X
	lda bgbuff
	adc TempRX
	sta bgbuff
	
	;+(>BackgroundBuffer)
	tya
	adc #>BackgroundBuffer
	sta bgbuff+1
	rts

BallBounce
	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_BALL3
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Remove from Collision map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap
	
	;Progress Ball
	lda NPC_ScreenY,x
	clc
	adc NPC_Progress,x
	and #$FE	;Allign to 2 steps
	cmp #106
	bcs BackInLauncher
	sta NPC_ScreenY,x
	inc NPC_Progress,x
	
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen

	;Plot Sprite
	jsr PlotSpriteWithMask
	
	;Write to Collision Map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jmp PlotNPCInCollisionMap

BackInLauncher
	;Process to Pause phase
	lda #NPCA_BALLPAUSE
	sta NPC_Activity,x
	lda #00
	sta NPC_Progress,x
	rts

BallPause
	;
	lda NPC_Progress,x
.(
	bne skip1
	;First time - Delete Ball
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_BALL3
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Remove from Collision map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap
	
skip1	;Progress Ball Pause
.)
	lda NPC_Progress,x
	adc #1
	cmp #10
	bcs BackToRise
	sta NPC_Progress,x
	rts
	
BackToRise
	;Process to Pause phase
	lda #NPCA_BALLRISING
	sta NPC_Activity,x
	lda #00
	sta NPC_Progress,x
	lda NPC_ScreenXOrigin,x
	sta NPC_ScreenX,x
	lda NPC_ScreenYOrigin,x
	sta NPC_ScreenY,x
	lda #SFX_LAUNCHER
	jsr KickSFX
	rts

GrubPeep
	;Peep Left/Right 4 times before proceeding to GrubMove
	dec NPC_Progress,x
	bmi OnToGrubMove
	lda NPC_Direction,x
	beq GrubPeepLeft
GrubPeepRight
	lda #NPCF_GRUBPEEPRIGHT
	sta SpriteFrame
	jmp GrubPeepRent1
GrubPeepLeft
	lda #NPCF_GRUBPEEPLEFT
	sta SpriteFrame
GrubPeepRent1
	dec NPC_Special,x
.(
	bne skip1
	lda #4
	sta NPC_Special,x
	lda NPC_Direction,x
	eor #2
	sta NPC_Direction,x
	
skip1	ldy NPC_ScreenY,x
.)
	lda NPC_ScreenX,x
	jsr RecalcScreen
	jsr PlotSpriteWithMask
	
	;Write to Collision Map
	lda NPC_ScreenX,x
	adc #2
	ldy NPC_ScreenY,x
	jmp PlotNPCInCollisionMap

OnToGrubMove
	lda #NPCA_GRUBMOVE
	sta NPC_Activity,x
	lda #00
	sta NPC_Progress,x
;	jsr GetRandomNumber
;	sta NPC_Special,x	;This indicates its life span
	rts
GrubMove
	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_GRUBMOVELEFT0
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Remove from Collision map
	lda NPC_ScreenX,x
	adc #2
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap
	
	;Check lifespan
;	dec NPC_Special,x
;.(
;	bne skip1
;	;Setup New Grub
;	jsr SetupNewGrub
;	;Destroy Grub
;	txa
;	tay
;	jsr HitNPC2
;skip1	;Progress Grub
;.)
	lda NPC_ScreenY,x
	adc #6
	tay
	lda NPC_ScreenX,x
	adc #2
	jsr FetchCollisionCell
	beq FallingGrub

	lda NPC_Direction,x
	bne GrubMoveRight
GrubMoveLeft
	;Check left collision
	lda NPC_ScreenX,x
	sec
	sbc #1
	ldy NPC_ScreenY,x
	jsr FetchCollisionCell
	bne InvertGrubDirection
	dec NPC_ScreenX,x
	jmp GrubContinue
GrubMoveRight
	;Check Right collision
	lda NPC_ScreenX,x
	clc
	adc #5
	ldy NPC_ScreenY,x
	jsr FetchCollisionCell
	bne InvertGrubDirection
	inc NPC_ScreenX,x
	jmp GrubContinue
FallingGrub
	lda NPC_ScreenY,x
	adc #5
	and #$FE	;Force Allignment
	sta NPC_ScreenY,x
	jmp GrubContinue
InvertGrubDirection
	lda NPC_Direction,x
	eor #2
	sta NPC_Direction,x
GrubContinue
	;Set frame based on direction(0 or 2)
	lda NPC_Progress,x
	eor #1
	sta NPC_Progress,x
	ora NPC_Direction,x
	clc
	adc #NPCF_GRUBMOVELEFT0
	sta SpriteFrame
	
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen

	;Plot Sprite
	jsr PlotSpriteWithMask
	
	;Write to Collision Map
	lda NPC_ScreenX,x
	clc
	adc #2
	ldy NPC_ScreenY,x
	jmp PlotNPCInCollisionMap


RainDrop
	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_RAINDROP
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Remove from Collision map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap
	
		
	;Progress Droplet
	lda NPC_ScreenY,x
	adc NPC_Progress,x
	and #$FE	;Row Allign
	;Check no rogue ones reach beyond boundary
	cmp #120
	bcs RestartRainDrop
	sta NPC_ScreenY,x
	;And check when they hit an object
	tay
	lda NPC_ScreenX,x
	adc #1
	jsr CheckForBackgroundInCollisionMap
	bcs RestartRainDrop

	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen

	;Plot Sprite
	jsr PlotSpriteWithMask
	
	;Write to Collision Map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jmp PlotNPCInCollisionMap

RestartRainDrop
	txa
	and #3
	clc
	adc NPC_ScreenXOrigin,x
	sta NPC_ScreenX,x
	lda NPC_ScreenYOrigin,x
	sta NPC_ScreenY,x
	lda VIA_T2LL
	and #7
	ora #2
	sta NPC_Progress,x
	lda #SFX_RAINDROP
	jsr KickSFX
	rts

Spider	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_SPIDER0
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Remove from Collision map
	lda NPC_ScreenX,x
	clc
	adc #1
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap
		
	;Progress Spider
	lda NPC_ScreenY,x
	adc NPC_Direction,x
	and #$FE
	cmp #32
.(
	bcc ChangeDirection
	cmp #120
	bcs ChangeDirection
	sta NPC_ScreenY,x
	
	tay
	lda NPC_ScreenX,x
	clc
	adc #1
	jsr CheckForBackgroundInCollisionMap
	bcc skip1
ChangeDirection
	;Kick Spider SFX
	lda #SFX_SPIDER
	jsr KickSFX
	;Change direction
	lda NPC_Direction,x
	;Direction is either 2(00000010) or 254(11111110) so eor with 252(11111100)
	eor #252
	sta NPC_Direction,x
	
skip1
.)

	;Fetch BGBuff address
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	sec
	sbc #1
	jsr RecalcBGBuff

	;Is Spider descending?
	lda NPC_Direction,x
.(
	bmi skip2
	;Spider Descending - plot thread
	ldy #01
	lda #%01001000
	sta (bgbuff),y
	lda #%01000100
	ldy #41
	sta (bgbuff),y
	jmp skip1
skip2	;Spider ascending - Delete Thread
	ldy #01
	lda #%01000000
	sta (bgbuff),y
	lda #%01000000
	ldy #41
	sta (bgbuff),y

skip1	;Select frame
.)
	lda NPC_ScreenY,x
	lsr
	lsr
	lsr
	lda #32
	adc #00
	sta SpriteFrame
	
	;Plot Sprite
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	jsr PlotSpriteWithMask
	
	;Write to Collision Map
	lda NPC_ScreenX,x
	clc
	adc #1
	ldy NPC_ScreenY,x
	jmp PlotNPCInCollisionMap

Triffid	;The triffid doesn't do anything until the hero treds or falls on it
	;and then it animates between frames
	rts
		
;The humble bee must revolve around the object until such time as the honey pot appears
;whereby the object origin will gradually move to the honeypot
BeeBuzz
;	nop
;	jmp BeeBuzz
	;Delete Old Frame(Observing shifted position)
	ldy NPC_ScreenX,x
	lda XLOC,y
	ldy NPC_ScreenY,x
	jsr RecalcScreen
	lda #NPCF_BEE
	sta SpriteFrame
	stx rsbg_RestorationOfX+1
	ldy NPC_ScreenX,x
	lda XLOC,y
	ldy NPC_ScreenY,x
	jsr RestoreSpriteBG2
	
	;Remove from Collision map
	ldy NPC_ScreenX,x
	lda XLOC,y
	clc
	adc #1
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap

	;Progress Bee
	;Bees must buzz around a set point so that when the honeypot arrives the single point can be moved
	;instead of each individual bee
	;So they should use a 2's compliment signed sine table then have a random index for both x and y to create
	;a movement pattern similar to the wave demo for wurlde.

	inc NPC_Progress,x
	inc NPC_Progress,x
	ldy NPC_Progress,x		;Bee Sine Index
	lda BeeOriginY		;The common position that will change if honeypot dropped near
	clc
	adc SignedSineTable,y	;256x(-7 to +7) Imperfect sine
	ora #1
	sta NPC_ScreenY,x
	;For X use same index eored with 128
	tya
	clc
	adc #128
	tay
	lda BeeOriginX
	clc
	adc SignedSineTable,y
	sta NPC_ScreenX,x
	
	;Use X to find correct Bee frame
	tay
	lda BitIndex,y
	;Which returns a number 0 to 5
	clc
	adc #NPCF_BEE
	sta SpriteFrame
	
	;X is pixel based so fetch byte offset
	ldy NPC_ScreenX,x
	lda XLOC,y
	ldy NPC_ScreenY,x
	jsr RecalcScreen
	
	;Plot Sprite
	jsr PlotSpriteWithMask
	
	;Write to Collision Map
	ldy NPC_ScreenX,x
	lda XLOC,y
	clc
	adc #1
	ldy NPC_ScreenY,x

;A==X Pos
;Y==Y Pos
;X==NPC Index
PlotNPCInCollisionMap
	;Fetch top left Location and size of NPC in collision map
	jsr FetchCollisionLocAndSizeOfNPC
	
.(	
loop2	ldy CollisionWidth
	dey
loop1	lda (cmap),y
	and #15
	ora NPCCollisionID,x
	sta (cmap),y
	dey
	bpl loop1
	lda cmap
	clc
	adc #40
	sta cmap
	bcc skip1
	inc cmap+1
skip1	dec CollisionHeightCount
	bne loop2
.)
	rts	
	
	
FetchCollisionLocAndSizeOfNPC
	clc
	adc CollisionMapYLOCL-30,y
	sta cmap
	lda CollisionMapYLOCH-30,y
	adc #00
	sta cmap+1
	
	;Calculate size of NPC
	ldy NPC_Activity,x
	lda Action2CollisionHeight,y
	sta CollisionHeightCount
	lda Action2CollisionWidth,y
	sta CollisionWidth
	rts

;	ldy #00
;	lda (cmap),y
;	and #15
;	ora NPCCollisionID,x
;	sta (cmap),y
;	rts

;Collision cell represents 6x6 pixels on screen	
Action2CollisionWidth
 .byt 2	;BALLRISING	0
 .byt 2	;BALLBOUNCE	1
 .byt 1	;BALLPAUSE	2
 .byt 1	;GRUBPEEP		3
 .byt 3	;GRUBMOVE		4
 .byt 1	;RAINDROP		5
 .byt 2	;EGGWASP		6
 .byt 4	;DRAGONLEFT	7
 .byt 4	;DRAGONRIGHT	8
 .byt 1	;BEE		9
 .byt 2	;EXPLODE		10
 .byt 2	;SPIDER		11
 .byt 3	;TRIFFID		12
 .byt 3	;FAIRY		13
 .byt 1	;THROWNTEAR	14
 .byt 1	;FLOORTEAR	15
 .byt 1	;MELTTEAR		16
Action2CollisionHeight
 .byt 1	;BALLRISING	0
 .byt 2	;BALLBOUNCE	1
 .byt 1	;BALLPAUSE	2
 .byt 1	;GRUBPEEP		3
 .byt 1	;GRUBMOVE		4
 .byt 1	;RAINDROP		5
 .byt 2	;EGGWASP		6
 .byt 1	;DRAGONLEFT	7
 .byt 1	;DRAGONRIGHT	8
 .byt 1	;BEE		9
 .byt 2	;EXPLODE		10
 .byt 2	;SPIDER		11
 .byt 2	;TRIFFID		12
 .byt 3	;FAIRY		13
 .byt 1	;THROWNTEAR	14
 .byt 1	;FLOORTEAR	15
 .byt 1	;MELTTEAR		16

RemoveNPCFromCollisionMap
	;Fetch top left Location and size of NPC in collision map
	jsr FetchCollisionLocAndSizeOfNPC
	
.(	
loop2	ldy CollisionWidth
	dey
loop1	lda (cmap),y
	and #15
	sta (cmap),y
	dey
	bpl loop1
	lda cmap
	clc
	adc #40
	sta cmap
	bcc skip1
	inc cmap+1
skip1	dec CollisionHeightCount
	bne loop2
.)
	rts	

CheckForBackgroundInCollisionMap
	;Fetch top left Location and size of NPC in collision map
	jsr FetchCollisionLocAndSizeOfNPC
	
.(	
loop2	ldy CollisionWidth
	dey
loop1	lda (cmap),y
	and #15
	cmp #1
	bcs skip2
	dey
	bpl loop1
	lda cmap
	clc
	adc #40
	sta cmap
	bcc skip1
	inc cmap+1
skip1	dec CollisionHeightCount
	bne loop2
	clc
skip2	rts	
.)

;	clc
;	adc CollisionMapYLOCL-30,y
;	sta cmap
;	lda CollisionMapYLOCH-30,y
;	adc #00
;	sta cmap+1
;	ldy #00
;	lda (cmap),y
;	and #15
;	cmp #1
;	rts

;B4-7 Sprite Collisions
; 00 Background
; 01-0C NPC Index
NPCCollisionID
 .byt 16*1
 .byt 16*2
 .byt 16*3
 .byt 16*4
 .byt 16*5
 .byt 16*6
 .byt 16*7
 .byt 16*8
 .byt 16*9
 .byt 16*10
 .byt 16*11
 .byt 16*12

	
	

Destroy
;	nop
;	jmp Destroy
	;The explosion action cycles once through the 6 explosion frames repeating the frame
	;X number of times right as specified in NPC_Count
	;The position for the leftmost explosion is always held in Origin
	;ie. Dragon is 4 bytes wide so NPC_Count would be 2
	lda #00
	sta TempCount
.(	
loop1	;Multiply current count by 2
	lda TempCount
	asl
	;And add to screen X origin
	adc NPC_ScreenXOrigin,x
	sta NPC_ScreenX,x
	
	;Set the y position to Origin
	lda NPC_ScreenYOrigin,x
	sta NPC_ScreenY,x
	
	;Set the frame to NPC_Progress
	lda NPC_Progress,x
	sta SpriteFrame
	
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	
	jsr PlotSpriteWithMask
	
	inc TempCount
	lda TempCount
	cmp NPC_Count,x
	bcc loop1
.)	
	;Progress NPC
	lda NPC_Progress,x
	clc
	adc #1
	cmp #NPCF_AFTEREXPLODE
	bcs RemoveExplosion
	sta NPC_Progress,x
	rts
	
RemoveExplosion
	;Remove NPC and restore bg over screen area
	lda NPC_Count,x
	sta TempCount
.(	
loop1	lda NPC_ScreenXOrigin,x
	ldy NPC_ScreenYOrigin,x
	jsr RecalcScreen
	lda NPC_ScreenXOrigin,x
	ldy NPC_ScreenYOrigin,x
	stx rsbg_RestorationOfX+1
	jsr RestoreSpriteBG2
	inc NPC_ScreenXOrigin,x
	inc NPC_ScreenXOrigin,x
	dec TempCount
	bne loop1
.)
	;Another problem is that if the width and/or height of the original NPC is slightly larger than
	;explosion then we end up with artifacts on screen so keep
	;record of original NPC Frame and restore BG
	lda NPC_SpriteFrame,x
	sta SpriteFrame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	stx rsbg_RestorationOfX+1
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RestoreSpriteBG2
	
	jmp DestroyDragon

FetchCollisionCell
	clc
	adc CollisionMapYLOCL-30,y
.(
	sta vector1+1
	lda CollisionMapYLOCH-30,y
	adc #00
	sta vector1+2
vector1	lda $dead
.)
	rts
	

;DragonInitiate
;DragonFlightLeft
;DragonFlightRight
;DragonDeath
;AcidDropInitiate
;AcidDropFlight
;AcidDropLandAndDissipate
;TriffidAnimate
;TriffidMonitoring
;GrubInitiate
;GrubRiseAndLook
;GrubScurryLeft
;GrubScurryRight
;GrubFall
;GrubDeath
;BeesFlight
;EggWaspsInitiate
;EggDescent
;EggHatch
;WaspAttack
;WaspDeath

SpawnRealtimeNPC
	beq SpawnDragon
	cmp #1
	beq SpawnEggWasps
	jmp SpawnFairy
	
SpawnDragon
	;Dragons appear on left or right of screen and swoop down then up 
	dec DelayBetweenRRNPC
.(
	bne skip1
	lda #20
	sta DelayBetweenRRNPC
	;Avoid spawning dragon if hero close to side
	lda HeroX
	cmp #6
	bcc skip1
	cmp #35
	bcs skip1
	;Spawn Dragon
	jsr FetchNewNPCIndex
	bcs skip1
	;Randomise Y position (40-103)
	jsr GetRandomNumber
	and #31
	clc
	adc #50
	sta NPC_ScreenY,y
	lda #2	;Initially swoop down
	sta NPC_Direction,y
	;The direction of the dragons depends on the direction the hero is facing
	lda HeroFrame
	cmp #8
	bcs ApproachFromLeft
ApproachFromRight
	;Moving left
	lda #NPCA_DRAGONLEFT
	sta NPC_Activity,y
	lda #39-5
	sta NPC_ScreenX,y
	rts
ApproachFromLeft
	;Moving right
	lda #NPCA_DRAGONRIGHT
	sta NPC_Activity,y
	lda #1
	sta NPC_ScreenX,y
skip1	rts
.)


SpawnEggWasps
	;Egg wasps float down from above, crack then turn into wasps that home in on hero
	;with potential over-run
	dec DelayBetweenRRNPC
.(
	bne skip1
	lda #20
	sta DelayBetweenRRNPC
	;Spawn Egg
	jsr FetchNewNPCIndex
	bcs skip1
	;Set progress to falling Egg
	lda #00
	sta NPC_Progress,y
	lda #NPCA_EGGWASP
	sta NPC_Activity,y
	;Randomise X
	jsr GetRandomNumber
	and #15
	clc
	adc #18
	sta NPC_ScreenX,y
	;Set Y to 30
	lda #31
	sta NPC_ScreenY,y
skip1	rts
.)

EggWasp	;6
	lda NPC_Progress,x
	;00 Descending Egg
	;01 Breaking Egg
	;80 Swarming Wasp
.(
	bpl skip1
	jmp SwarmingWasp
skip1	bne HatchingEgg
.)
	;Descending Egg
	
	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_EGG
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Remove from Collision map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap
	
	;Progress Egg
	inc NPC_ScreenY,x
	inc NPC_ScreenY,x
	inc NPC_ScreenY,x
	inc NPC_ScreenY,x
	
	;Check Collision below
	lda NPC_ScreenY,x
	cmp #120
	bcs ProceedToHatching
	adc #12
	tay
	lda NPC_ScreenX,x
	adc #1
	jsr CheckForBackgroundInCollisionMap
	bcs ProceedToHatching

	;Plot Sprite
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	jsr PlotSpriteWithMask
	
	;Write to Collision Map
	lda NPC_ScreenX,x
;	adc #1
	ldy NPC_ScreenY,x
	jmp PlotNPCInCollisionMap
	
ProceedToHatching
	lda #1
	sta NPC_Progress,x
	lda #5
	sta NPC_Count,x
	rts
	
;	bmi SwarmingWasp
HatchingEgg
	lda #NPCF_HATCH
	sta SpriteFrame
	
	;Plot Sprite
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	jsr PlotSpriteWithMask

	;Progress Hatch
	dec NPC_Count,x
	beq ProceedToSwarmingWasp
	rts

SpawnFairy
	;Fairies appear on left or right of screen and oscillate left/right across top of screen
	dec DelayBetweenRRNPC
.(
	bne skip1
	lda #20
	sta DelayBetweenRRNPC

	;Only allow 3 Fairies
	lda NPCUltimateIndex
	bmi skip2
	cmp #2
	bcs skip1

skip2	;Spawn Fairy
	jsr FetchNewNPCIndex
	bcs skip1

	;Randomise Y position (40-103)
	jsr GetRandomNumber
	sta NPC_Special,y
	and #31
	clc
	adc #42
	and #$FE
	sta NPC_ScreenYOrigin,y
	sta NPC_ScreenY,y
	
	;Count is used to slowdown fairies
	lda #BONUSFAIRYSPEED
	sta NPC_Count,y
	
	;Randomise X position
	jsr GetRandomNumber
	and #15
	clc
	adc #12
	sta NPC_ScreenXOrigin,y
	sta NPC_ScreenX,y
	
	lda #NPCA_FAIRY
	sta NPC_Activity,y
skip1	rts
.)
	
ProceedToSwarmingWasp
	lda #128
	sta NPC_Progress,x	;This becomes index of sine table
	lda #00
	sta NPC_Special,x
	;Delete existing hatch since different size to Wasp
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_EGG
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Then plot wasp frame
	lda #NPCF_SWARMINGWASP
	sta SpriteFrame
	
	;Plot Sprite
	lda NPC_ScreenY,x
	sta NPC_ScreenYOrigin,x
	tay
	lda NPC_ScreenX,x
	sta NPC_ScreenXOrigin,x
	jsr RecalcScreen
	jsr PlotSpriteWithMask
	
	rts
	
SwarmingWasp
;	nop
;	jmp SwarmingWasp
	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_SWARMINGWASP
	sta SpriteFrame
	jsr RestoreSpriteBG

	;Remove from Collision map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap

	inc NPC_Special,x
	inc NPC_Special,x
	ldy NPC_Special,x		;Wasp Sine Index
	lda NPC_ScreenYOrigin,x		;The common position that will change if honeypot dropped near
	clc
	adc SignedSineTable,y	;256x(-7 to +7) Imperfect sine
	ora #1
	sta NPC_ScreenY,x

	;Write to Collision Map
	lda NPC_ScreenX,x
;	adc #1
	ldy NPC_ScreenY,x
	jsr PlotNPCInCollisionMap

	;Plot Sprite
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	jsr PlotSpriteWithMask

	rts

ChannelFairy	;hehe, typo
	;Slow down fairies
	dec NPC_Count,x
.(
	beq skip1
	rts
	
skip1	lda #BONUSFAIRYSPEED
.)
	sta NPC_Count,x
	
	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	
	lda #NPCF_FAIRY0
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Remove from Collision map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap
	
	;Animate Fairy wings
	inc NPC_Special,x
	lda NPC_Special,x
	lsr
	lda #NPCF_FAIRY0
	adc #00
	sta SpriteFrame

	;Progress Fairy
;	inc NPC_Progress,x
	inc NPC_Progress,x
	ldy NPC_Progress,x
	lda NPC_ScreenXOrigin,x
	clc
	adc SignedSineTable,y
	;boundary checks
	cmp #3
.(
	bcc skip1
	cmp #35
	bcs skip1
	sta NPC_ScreenX,x
	
	tya
	adc #128
	tay
	
	lda NPC_ScreenYOrigin,x
	clc
	adc SignedSineTable,y
	and #$FE	;This alligns Fairy to correct colour pair
	;boundary checks
	cmp #32
	bcc skip1
	sta NPC_ScreenY,x
	
skip1	;Plot Sprite
.)
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	jsr PlotSpriteWithMask

	;Write to Collision Map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jmp PlotNPCInCollisionMap

;The Tear has 3 phases of life.
;Phase 1
; Tear is thrown from Fairy up and then down in an arc towards the ground
; During this time it is NOT written to the collision map
; When it hits the ground the next phase starts
;Phase 2
; The tear remains on the ground for 2 seconds
; During this time it is written to the collision map and may be picked up by Stormlord whereupon it is destroyed
; Once 2 seconds has expired the next phase begins
;Phase 3
; The tears is removed from the collision map and melts into the ground.
; After it has melted the tear is destroyed

ThrownTear
;	nop
;	jmp ThrownTear
	lda NPC_Progress,x
.(
	bne skip4

	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_RAINDROP	;3x8
	sta SpriteFrame
	jsr RestoreSpriteBG
	
;	;Remove from Collision map
;	lda NPC_ScreenX,x
;	ldy NPC_ScreenY,x
;	jsr RemoveNPCFromCollisionMap
	
	;We'll use the start of the sine table here to ensure a calculated rise and fall remains
	;within the screen bounds (we know min height of Fairies is 42).
	
	;Progress Y
	ldy NPC_Special,x	(7-
	lda NPC_ScreenY,x
	clc
	adc SignedSineTable,y
	
	;Ensure Y does not rise above arena
	cmp #30
	bcc skip5
	sta NPC_ScreenY,x
	
skip5	;Progress Special (Index in sine table) until 5
	lda SignedSineTable,y
	cmp #5
	beq skip1
	inc NPC_ScreenX,x
	inc NPC_Special,x

skip1	;Ensure X does not reach beyond right of screen
	lda NPC_ScreenX,x
	cmp #36
	bcc skip2
	lda #36
	sta NPC_ScreenX,x

skip2	;Check Y does not exceed floor

	lda NPC_ScreenY,x
	cmp #118
	bcc skip3
	;Switch2TearPhase2
	;This is special since we must continue NPC but write non-npc to colmap
	;for moment just ensure it remains at 118
	lda #118
	sta NPC_ScreenY,x
	lda #1
	sta NPC_Progress,x
	;We'll use Special to time tears on ground
	lda #25
	sta NPC_Special,x

skip3	;Plot Sprite

	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	jsr PlotSpriteWithMask
	
	rts
	
skip4	;Tears on ground for about 2 seconds
	lda #NPCF_RAINDROP	;3x8
	sta SpriteFrame
	
	;Write tear to row 16, col X collision map
	ldy NPC_ScreenX,x
	txa
	clc
	adc #4
	sta CollisionMap+40*14,y
	
	;We need to trigger Raindrop SFX but only once
	lda NPC_Special,x
	cmp #25
	bne skip6
	lda #SFX_RAINDROP
	jsr KickSFX
	
skip6	;Progress tear timeout
	dec NPC_Special,x
	bne skip3
.)
	jmp RemoveTear

DragonLeft   ;7
	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_DRAGONLEFT
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Remove from Collision map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap
	
	;Progress Dragon
	inc NPC_ScreenY,x
	inc NPC_ScreenY,x
	dec NPC_ScreenX,x
	
	;Check Collision below
	lda NPC_ScreenX,x
	cmp #2
	bcc DestroyDragon
	lda NPC_ScreenY,x
	cmp #126
	bcs DestroyDragon
	
	;Plot Sprite
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	jsr PlotSpriteWithMask
	
	;Write to Collision Map
	lda NPC_ScreenX,x
;	adc #1
	ldy NPC_ScreenY,x
	jmp PlotNPCInCollisionMap
	
DestroyDragon
	jmp DestroyNPC
	
	
DragonRight  ;8
	;Delete Old Frame
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	lda #NPCF_DRAGONRIGHT
	sta SpriteFrame
	jsr RestoreSpriteBG
	
	;Remove from Collision map
	lda NPC_ScreenX,x
	ldy NPC_ScreenY,x
	jsr RemoveNPCFromCollisionMap
	
	;Progress Dragon
	inc NPC_ScreenY,x
	inc NPC_ScreenY,x
	inc NPC_ScreenX,x
	
	;Check Collision below
	lda NPC_ScreenX,x
	cmp #34
	bcs DestroyDragon
	lda NPC_ScreenY,x
	cmp #126
	bcs DestroyDragon
	
	;Plot Sprite
	ldy NPC_ScreenY,x
	lda NPC_ScreenX,x
	jsr RecalcScreen
	jsr PlotSpriteWithMask
	
	;Write to Collision Map
	lda NPC_ScreenX,x
;	adc #1
	ldy NPC_ScreenY,x
	jmp PlotNPCInCollisionMap

DelayBetweenRRNPC	.byt 0

;RemoveSpiderThread
;	;NPC in Y but old activity in X
;	cpx #NPCA_SPIDER
;.(
;	bne skip1
;	;Run from NPC_ScreenYOrigin to NPC_ScreenY
;	sty vector1+1
;	tya
;	tax
;	
;loop1	;Fetch BGBuff address
;	ldy NPC_ScreenYOrigin,x
;	lda NPC_ScreenXOrigin,x
;	sec
;	sbc #1
;	jsr RecalcBGBuff
;	
;	;also show on screen
;	ldy NPC_ScreenYOrigin,x
;	lda NPC_ScreenXOrigin,x
;	jsr RecalcScreen
;	
;	
;	ldy #01
;	lda #%01000000
;	sta (screen),y
;	sta (bgbuff),y
;	lda #%01000000
;	ldy #41
;	sta (screen),y
;	sta (bgbuff),y
;	
;	inc NPC_ScreenYOrigin,x
;	inc NPC_ScreenYOrigin,x
;	
;	lda NPC_ScreenYOrigin,x
;	cmp NPC_ScreenY,x
;	bcc loop1
;vector1	ldy #00
;skip1	rts
;.)
;