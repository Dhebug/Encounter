;OSS_CoreCommands.s


;The core commands parsed registers
;Carry Set
;X Sprite Index
;Y Script Index of first data byte
;A -
ScrollSouth00
;	nop
;	jmp ScrollSouth00
	lda Sprite_Y,x
	adc (zpscript),y
	sta Sprite_Y,x
	jmp DisplaySprite22
MoveEast01
	inc Sprite_X,x
	rts
MoveSouth02
	lda Sprite_Y,x
	adc (zpscript),y
ossrent1	sta Sprite_Y,x
	sec
	rts
;MOVE_WEST			3
MoveWest03
	dec Sprite_X,x
	rts

;MOVE_NORTH		4
MoveNorth04
	lda Sprite_Y,x
	sbc (zpscript),y
	jmp ossrent1
;MOVE_FORWARD		5
MoveForward05
	ldy Sprite_CurrentDir,x
	lda Sprite_X,x
	adc DirectionStepX,y
	sta Sprite_X,x
	lda Sprite_Y,x
	sec
	adc DirectionStepY,y
	jmp ossrent1

;MOVE_TOWARDS_HERO		6
MoveTowardsHero06
	jmp MoveTowardsHero
	
;MOVE(x,y)			.byt 7,x,y
MoveXY07
	lda (zpscript),y
	sta Sprite_X,x
	iny
	lda (zpscript),y
	sta Sprite_Y,x
	rts
;SET_DIRECTIONFRAME(n,f)	.byt 8,n,f
SetDirectionFrame08
	stx ScriptTempX
	txa
	asl
	asl
	asl
	ora (zpscript),y
	tax
	iny
	lda (zpscript),y
	sta Sprite_DirectionsTable,x
	ldx ScriptTempX
	sec
	rts
;SET_EXPLOSION(s)		.byt 9,s
SetExplosion09
	lda (zpscript),y
	sta Sprite_ExplosionScript,x
	rts
;SET_COUNTER(v)		.byt 10,v
SetCounter10
	lda (zpscript),y
	sta Sprite_Counter,x
	rts
;SET_CONDITION(c)		.byt 11,c
SetCondition11
	lda (zpscript),y
	sta Sprite_ConditionID,x
	rts
;SET_TARGET(p)		.byt 12,p
SetTarget12
	lda (zpscript),y
	sta Sprite_HeroTarget,x
	rts
;SET_FRAME(n)		.byt 13,n
SetFrame13
	lda (zpscript),y
	sta Sprite_ID,x
	rts
;DECREMENT_FRAME		14
DecrementFrame14
	dec Sprite_ID,x
	rts
;INCREMENT_FRAME		15
IncrementFrame15
	inc Sprite_ID,x
	rts
;TURN_CLOCKWISE		16
TurnClockwise16
	lda Sprite_CurrentDir,x
	adc #0
ssrent2	and #7
	sta Sprite_CurrentDir,x
	jmp UpdateFrame4Direction
;TURN_ANTICLOCKWISE		17
TurnAnticlockwise16
	lda Sprite_CurrentDir,x
	sbc #1
	jmp ssrent2
;TURN_TOWARDS_HERO		18
TurnTowardHero18
;	nop
;	jmp TurnTowardHero18
	jsr EstablishDirectionForHero
	cmp Sprite_CurrentDir,x
.(
	beq skip2
	bcs skip1
	dec Sprite_CurrentDir,x
	jmp UpdateFrame4Direction
skip1	inc Sprite_CurrentDir,x
	jmp UpdateFrame4Direction
skip2	rts
.)

;SPAWN_SCRIPT(s,g)		.byt 19,s,g
SpawnScript19
	lda (zpscript),y
	pha
	iny
	lda (zpscript),y
	sta SpawnGroupFlag
	lda Sprite_X,x
	ldy #00
	jmp SpawnScript
	
SetWidth32
	lda (zpscript),y
	sta Sprite_Width,x
	rts
	
;DISPLAY_SPRITE		22
DisplaySprite22
	jsr Sprite_CheckBoundary
	bcs Terminate23_2
	jsr Sprite_CheckCollisions
	jsr Sprite_PlotSprite
	clc
	rts
	
;TERMINATE			23
Terminate23
;	nop
;	jmp Terminate23
	lda Sprite_Bonuses,x
;Still seem to have problem with bonuses
;	beq Terminate23_2
;	jmp Switch2Bonus
Terminate23_2
	jmp RemoveSpriteFromList
;WAIT(p)			.byt 24,p
Wait24
	lda (zpscript),y
	sta Sprite_PausePeriod,x
	clc
	rts
	
SpawnProjectile25
	;Protect against spawning a projectile when sprite beyond viewable area
	lda Sprite_X,x
	cmp #2
.(
	bcs skip8
	cmp #20
	bcs skip9
	lda Sprite_Y,x
	cmp #12
	bcc skip9
	cmp #146
	bcc skip8
skip9	sec
	rts
skip8	;Fetch Type
	;0 Eastbound White Cell
	;1 Southeastbound White Cell
	;2 Southbound White Cell
	;3 Southwestbound White Cell
	;4 Westbound White Cell
	;5 Northwestbound White Cell
	;6 Northbound White Cell
	;7 Northeastbound White Cell
	;8 Bound by current Facing direction White Cell
	;9 Eastbound Missile
	;A Westbound Missile
	;B Homing Missile
	lda (zpscript),y
	pha
	iny
	lda (zpscript),y
	sta spHitpoints 
	pla
	
	ldy UltimateProjectile
	bmi skip7
	cpy #32
	bcs skip4
skip7	inc UltimateProjectile
	ldy UltimateProjectile
	cmp #8
	bne skip1
	lda Sprite_CurrentDir,x
	clc
skip1	bcs skip2
	sta Projectile_Behaviour,y
	lda #00
	sta Projectile_GraphicID,y
	jmp skip3
skip2	cmp #9
	bne skip5
	lda #0
	sta Projectile_Behaviour,y
	lda #10
	sta Projectile_GraphicID,y
	jmp skip3
skip5	cmp #10
	bne skip6
	lda #4
	sta Projectile_Behaviour,y
	lda #12
	sta Projectile_GraphicID,y
	jmp skip3
skip6	lda #128
	sta Projectile_Behaviour,y
	lda #14
	sta Projectile_GraphicID,y
skip3	;Position Projectile in the centre of the sprite
	lda Sprite_Width,x
	lsr
	clc
	adc Sprite_X,x
	sta Projectile_X,y
	lda Sprite_Height,x
	lsr
	clc
	adc Sprite_Y,x
	sta Projectile_Y,y
	lda #128
	sta Projectile_Ownership,y
	lda spHitpoints
	sta Projectile_HitPoints,y
skip4	sec
.)
	rts
	
SetHitIndex26
	lda (zpscript),y
	sta Sprite_HitIndex,x
	rts

CallSpecial27
	jmp CallSpecial2


;BRANCH(index)		.byt 21,index
Branch21
	lda Sprite_ConditionID,x
	beq DoBranch
	cmp #2
	beq BranchWhenNotFacingEast
	bcc BranchWhenNotFacingHero
	cmp #4
	beq BranchWhen2Players
BranchWhenCounterNonZero
	lda Sprite_Counter,x
	beq NoBranch
	dec Sprite_Counter,x
	jmp DoBranch
BranchWhenNotFacingEast
	lda Sprite_CurrentDir,x
	beq NoBranch
	jmp DoBranch
BranchWhen2Players
	lda PlayerA_Status
	beq NoBranch
	lda PlayerB_Status
	beq NoBranch
	jmp DoBranch
BranchWhenNotFacingHero
	jsr EstablishDirectionForHero
	cmp Sprite_CurrentDir,x
	beq NoBranch
DoBranch	lda (zpscript),y
	sta Sprite_ScriptIndex,x
NoBranch	sec
	rts
	
SetAttributes28
	;Attributes
	lda (zpscript),y
	sta Sprite_Attributes,x
	rts

SetHitpoints29
	lda (zpscript),y
	sta Sprite_HitPoints,x
	iny
	lda (zpscript),y
	sta Sprite_Health,x
	rts

SetBonuses30
	lda (zpscript),y
	sta Sprite_Bonuses,x
	rts

CallSpecial2
	lda (zpscript),y
	sta zpVector
	iny
	lda (zpscript),y
	sta zpVector+1
	jmp (zpVector)

Switch2Bonus
;	nop
;	jmp Switch2Bonus
	;Turn terminated sprite into Bonus
	lda #3
	sta Sprite_Width,x
	lda #9
	sta Sprite_Height,x
	lda Sprite_Bonuses,x
	and #15
	clc
	adc #BONUSES_STARTFRAME
	sta Sprite_ID,x
	lda #00
	sta Sprite_ExplosionScript,x
	sta Sprite_ScriptIndex,x
	sta Sprite_PausePeriod,x
	sta Sprite_ConditionID,x
	sta Sprite_ScorePoints,x
	sta Sprite_Counter,x
	lda #SCRIPT_BONUS
	sta Sprite_ScriptID,x
	lda #128	;Use 128 to indicate Bonus
	sta Sprite_GroupID,x
	lda #00
	sta Sprite_Attributes,x
	lda #26
	sta Sprite_UltimateByte,x
	lda #5
	sta Sprite_CollisionBytes,x
	lda #99
	sta Sprite_HitPoints,x
	;We still need to process into the Bonus script but zpscript still points to old
	lda SpriteScriptAddressLo+40
	sta zpscript
	lda SpriteScriptAddressHi+40
	sta zpscript+1
	sec
	rts
		
MoveTowardsHero
	ldy Sprite_HeroTarget,x
	lda Sprite_X,y
	cmp Sprite_X,x
.(
	beq skip1
	bcs skip2
	inc Sprite_X,x
	jmp skip1
skip2	dec Sprite_X,x
skip1	lda Sprite_Y,y
.)
	cmp Sprite_Y,x
.(
	beq skip1
	bcs skip2
	inc Sprite_Y,x
	sec
skip1	rts
skip2	dec Sprite_Y,x
.)
	rts

SpawnScriptPlusX20	;x,s,g
	lda (zpscript),y
	clc
	adc Sprite_X,x
	sta ssTemp01
	iny
	lda (zpscript),y
	pha
	iny
	lda (zpscript),y
	sta SpawnGroupFlag
	lda ssTemp01
	ldy #00
	jmp SpawnScript
	
JumpToScript31
	lda (zpscript),y
	sta Sprite_ScriptID,x
	tay
	lda #00
	sta Sprite_ScriptIndex,x
	;Set the Main Script Loop Script address pointers
	lda SpriteScriptAddressLo,y
	sta zpscript
	lda SpriteScriptAddressHi,y
	sta zpscript+1
	sec
	rts

;X Sprite Index
;Y YPOS to Spawn Script Sprite to
;A XPOS to Spawn Script Sprite to
;S ScriptID
SpawnScript
.(
	sty vector1+1
	inc UltimateSprite
	ldy UltimateSprite
	sta Sprite_X,y
vector1	lda #00
.)
	sta Sprite_Y,y
	pla
	sta Sprite_ScriptID,y
	stx SpawnTempX
	tax
	lda LevelFrameHitpoints,x
	sta Sprite_HitPoints,y
	lda LevelFrameHealth,x
	sta Sprite_Health,y
	txa	
	;Fetch First entry in Script (for Sprite ID)
	jsr FetchDefaultScriptFrame
	sta Sprite_ID,y
	tax
;	lda LevelFrameAttributes,x
;	sta Sprite_Attributes,y
	lda LevelFrameWidth,x
	sta Sprite_Width,y
	lda LevelFrameHeight,x
	sta Sprite_Height,y
	lda LevelFrameUltimateByte,x
	sta Sprite_UltimateByte,y
	lda LevelFrameCollisionBytes,x
	sta Sprite_CollisionBytes,y
	jsr FetchUniqueSequenceID
	asl
	asl
	ora #3
	sta Sprite_UniqueID,y
	ldx SpawnTempX
	bit SpawnGroupFlag	;Set in Script spawn command
.(
	bpl skip1
	lda Sprite_GroupID,x
skip1	sta Sprite_GroupID,y
.)
	lda #00
	sta Sprite_ScriptIndex,y
	sta Sprite_HeroTarget,y
	sta Sprite_PausePeriod,y
	sta Sprite_CurrentDir,y
	sta Sprite_ConditionID,y
	sta Sprite_Counter,y
	lda #DEFAULT_EXPLOSIONSCRIPT
	sta Sprite_ExplosionScript,y
	sec
	rts


UpdateFrame4Direction
	txa
	asl
	asl
	asl
	ora Sprite_CurrentDir,x
	tay
	lda Sprite_DirectionsTable,y
	sta Sprite_ID,x
	sec
	rts

;X Index
;Y DONOT CORRUPT
;A Direction
;5 6 7
; \|/
;4-o-0
; /|\
;3 2 1
EstablishDirectionForHero
	;Locate Target in respect to Sprite
	sty ScriptTempY
	;Fetch Target(Hero) Index
	ldy Sprite_HeroTarget,x
	;Fetch Targets Sprite Index
	lda PlayerA_SpriteIndex,y
	tay
	;Compare Targets position to Sprite
	lda Sprite_X,x
	cmp Sprite_X,y
	beq NoLookWestEast
	bcc CheckEast
CheckWest	lda Sprite_Y,x
	cmp Sprite_Y,y
	beq LookWest
	bcc LookSouthWest
LookNorthWest
	lda #5
	ldy ScriptTempY
	rts
NoLookWestEast
	lda Sprite_Y,x
	cmp Sprite_Y,y
	bcc LookSouth
LookNorth	lda #6
	ldy ScriptTempY
	rts
CheckEast	lda Sprite_Y,x
	cmp Sprite_Y,y
	beq LookEast
	bcc LookSouthEast
LookNorthEast
	lda #7
	ldy ScriptTempY
	rts
LookEast	lda #0
	ldy ScriptTempY
	rts
LookSouthEast
	lda #1
	ldy ScriptTempY
	rts
LookSouth	lda #2
	ldy ScriptTempY
	rts
LookSouthWest
	lda #3
	ldy ScriptTempY
	rts
LookWest	lda #4
	ldy ScriptTempY
	rts

;Depends on Step size?
Sprite_CheckBoundary
	;Check top border
	lda Sprite_Y,x
	cmp #200	;200 is just an approximate for <0
.(
	bcs skip1
	;Check bottom border
	adc Sprite_Height,x
	cmp #158
	bcs skip1
	;Check left border
	lda Sprite_X,x
	cmp #24
	bcs skip1
	;Check right border
	adc Sprite_Width,x
	cmp #24
skip1	rts
.)

;Plot sprite area in collision map
Sprite_CheckCollisions	;Routine must init dying script for craft
	;If Explosion frames, just continue without detecting collisions
	;Bit1 Don't detect Collisions(Explosion)
	lda Sprite_Attributes,x
	and #BIT4
.(
	bne skip4
	;Calculate the cmap location beforehand so that we can alternatively store the player footprint
	ldy Sprite_Y,x	;Locate within map
	lda Sprite_X,x
	clc
	adc CollisionMap_YLOCLo,y
	sta cmap
	lda CollisionMap_YLOCHi,y
	adc #00
	sta cmap+1
	
	;Display Sprite footprint in Collision Map
	lda Sprite_Attributes,x
	;Is Sprite Player?
	;Bits0-1
	; 0 Sprite is single (Never players)
	; 1 Sprite is part of bigger group(Never players)
	; 2 Player A
	; 3 Player B
	and #3
	cmp #2

	bcc skip1
	
     	;At this point detect collision bytes
	ldy #03
loop1	lda (cmap),y
	bne skip3
	dey
	bpl loop1
	jmp skip2
skip3	;Found collision - now locate Sprite index
	ldy UltimateSprite
loop2	cmp Sprite_UniqueID,y
	beq skip5
	dey
	bpl loop2
	jmp skip2
skip5	;Found sprite - is it bonus?
	lda Sprite_GroupID,y
	bpl skip2
	;Process Bonus(Sprite_Bonuses,y and Sprite_Attributes,y(BIT5)) for player(Sprite_Attributes,x(2-3))
	jsr ProcessBonusForPlayer	;Preserves X, Removes Bonus and credits players arsenal and score
	
skip2	;For Players Craft ensure we only store 2 cells instead of the calculated 8 cells
	;and also offset them by 1 (All this will reduce the accuracy of incoming projectiles)
	lda Sprite_UniqueID,x
	ldy #01
	sta (cmap),y
	iny
	sta (cmap),y
skip4	rts

	
skip1	ldy Sprite_Width,x	;Fetch width
.)
	lda ScreenBufferOffsetTableLo-1,y
.(
	sta offset+1
	lda ScreenBufferOffsetTableHi-1,y
	sta offset+2

	;The unique ID should already be in the collision map format
	ldy Sprite_UniqueID,x
	
	lda Sprite_CollisionBytes,x
	stx Sprite_TempX
	tax
	
	
	
	tya
offset	ldy $dead,x
	sta (cmap),y
	dex
	bpl offset
.)
	ldx Sprite_TempX
	rts
	


RemoveSpriteFromList
	cpx UltimateSprite
.(
	bne skip1
	jmp skip2
skip1	ldy UltimateSprite
	lda Sprite_HeroTarget,y
	sta Sprite_HeroTarget,x
	lda Sprite_ExplosionScript,y
	sta Sprite_ExplosionScript,x
	lda Sprite_ScriptID,y
	sta Sprite_ScriptID,x
	lda Sprite_ScriptIndex,y
	sta Sprite_ScriptIndex,x
	lda Sprite_PausePeriod,y
	sta Sprite_PausePeriod,x
	lda Sprite_CurrentDir,y
	sta Sprite_CurrentDir,x
	lda Sprite_X,y
	sta Sprite_X,x
	lda Sprite_Y,y
	sta Sprite_Y,x
	lda Sprite_ID,y
	sta Sprite_ID,x
	lda Sprite_DirectionsTable,y
	sta Sprite_DirectionsTable,x
	lda Sprite_ConditionID,y
	sta Sprite_ConditionID,x
	lda Sprite_Counter,y
	sta Sprite_Counter,x
	lda Sprite_GroupID,y
	sta Sprite_GroupID,x
	lda Sprite_Attributes,y
	sta Sprite_Attributes,x
	lda Sprite_Width,y
	sta Sprite_Width,x
	lda Sprite_Height,y
	sta Sprite_Height,x
	lda Sprite_UltimateByte,y
	sta Sprite_UltimateByte,x
	lda Sprite_UniqueID,y
	sta Sprite_UniqueID,x
	lda Sprite_CollisionBytes,y
	sta Sprite_CollisionBytes,x
	lda Sprite_HitPoints,y
	sta Sprite_HitPoints,x
	lda Sprite_Health,y
	sta Sprite_Health,x
	lda Sprite_ScorePoints,y
	sta Sprite_ScorePoints,x
	lda Sprite_HitIndex,y
	sta Sprite_HitIndex,x
	lda Sprite_Bonuses,y
	sta Sprite_Bonuses,x
	;Transfer Direction Frame ID's
	;Calc source
	tya
	asl
	asl
	asl
	tay
	;Calc Destination
	txa
	asl
	asl
	asl
	stx rsflTempX
	tax
	;Now copy 8 bytes
	lda Sprite_DirectionsTable,y
	sta Sprite_DirectionsTable,x
	lda Sprite_DirectionsTable+1,y
	sta Sprite_DirectionsTable+1,x
	lda Sprite_DirectionsTable+2,y
	sta Sprite_DirectionsTable+2,x
	lda Sprite_DirectionsTable+3,y
	sta Sprite_DirectionsTable+3,x
	lda Sprite_DirectionsTable+4,y
	sta Sprite_DirectionsTable+4,x
	lda Sprite_DirectionsTable+5,y
	sta Sprite_DirectionsTable+5,x
	lda Sprite_DirectionsTable+6,y
	sta Sprite_DirectionsTable+6,x
	lda Sprite_DirectionsTable+7,y
	sta Sprite_DirectionsTable+7,x
	ldx rsflTempX
skip2     dec UltimateSprite
.)
          clc
          rts

;Choose next bonus frame using Bit 5 of Sprite_Attributes to alternate between two nibbles of Sprite_Bonuses
csNextBonus
	lda Sprite_Attributes,x
	eor #BIT5
	sta Sprite_Attributes,x
	and #BIT5
.(
	beq SelectLoNibble
SelectHiNibble
	lda Sprite_Bonuses,x
	lsr
	lsr
	lsr
	lsr
rent1	clc
	adc #BONUSES_STARTFRAME
	sta Sprite_ID,x
	sec
	rts
SelectLoNibble
	lda Sprite_Bonuses,x
	and #15
	jmp rent1
.)

;Process Bonus(Sprite_Bonuses,y and Sprite_Attributes,y(BIT5)) for player(Sprite_Attributes,x(2-3))
;Preserves X, Removes Bonus and credits players arsenal and score
ProcessBonusForPlayer
;	nop
;	jmp ProcessBonusForPlayer
	;Preserve X
	stx pbfpTempX
	sty pbfpTempY

	;credits players arsenal
	lda Sprite_Attributes,y
	and #BIT5
	cmp #BIT5
	lda Sprite_Bonuses,y
.(
	bcc skip1
	lsr
	lsr
	lsr
	lsr
skip1	and #15
	sta pbfpTempA
	beq skip2
	tay
	lda ProcessBonusCodeVectorLo-1,y
	sta vector1+1
	lda ProcessBonusCodeVectorHi-1,y
	sta vector1+2
vector1	jsr $dead
skip2	;Credit Players Score
	ldx pbfpTempX
	lda Sprite_Attributes,x
	and #3
	sec
	sbc #2
	tax
	ldy pbfpTempA
	lda Score4Bonus,y
	jsr Add2Score
	;Remove Bonus
	ldx pbfpTempY
	jsr RemoveSpriteFromList

	ldx pbfpTempX
.)
	ldy pbfpTempY
          rts

	
