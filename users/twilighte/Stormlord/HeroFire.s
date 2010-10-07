;HeroFire.s

;If Fire released within timer then shoot quick burst arcing orbs otherwise shoot sword.
;orbs have killing power of 1 but many may be shot at a time(8).
;Swords have killing power of 10 but take more time to fire.

;Both sword and orb end life on contact with obstruction in collision map

;The course and graphic of the projectile is all that is required in setting it up
ProjectileType_XStep
 .byt 1	;Orb
 .byt 1	;Sword
 .byt 0	;Heart
ProjectileType_YStep
 .byt 252	;Orb
 .byt 0	;Sword
 .byt 254	;Heart
ProjectileType_GFXID
 .byt 28	;Orb  
 .byt 29  ;Sword
 .byt 31  ;Heart


SpawnOrb
;	nop
;	jmp SpawnOrb
	lda #SFX_FIREORB
	jsr KickSFX
	;Don't allow hero to fire if too near boundaries
	jsr PerformProjectileCommonChecks
.(
	bcs skip2
	lda HeroFrame
	cmp #8
	bcs ProjectileLeft
ProjectileRight
	lda HeroX
	adc #2
	sta prj_X,x
	lda #1
	sta prj_XStep,x
	jmp skip1
ProjectileLeft
	lda HeroX
	sbc #1
	sta prj_X,x
	lda #255
	sta prj_XStep,x

skip1	lda HeroY
	adc #12
	sta prj_Y,x
	lda #252
	sta prj_YStep,x
	lda #GFXF_ORB
	sta prj_GFXID,x
skip2	rts
.)


SpawnSword
	;Don't allow hero to fire if too near boundaries
	jsr PerformProjectileCommonChecks
.(
	bcs skip2
	lda HeroFrame
	cmp #8
	bcs ProjectileLeft
ProjectileRight
	lda HeroX
	adc #2
	sta prj_X,x
	lda #1
	sta prj_XStep,x
	lda #GFXF_SWORDRIGHT
	sta prj_GFXID,x
	jmp skip1
ProjectileLeft
	lda HeroX
	sbc #2
	sta prj_X,x
	lda #255
	sta prj_XStep,x
	lda #GFXF_SWORDLEFT
	sta prj_GFXID,x

skip1	lda HeroY
	adc #12
	sta prj_Y,x
	lda #0
	sta prj_YStep,x
skip2	rts
.)

SpawnHeart
	;Don't allow hero to fire if too near boundaries
	jsr PerformProjectileCommonChecks
.(
	bcs skip2
	lda HeroX
	adc #1
	sta prj_X,x
	lda #0
	sta prj_XStep,x
	lda HeroY
	sec
	sbc #5
	sta prj_Y,x
	lda #250
	sta prj_YStep,x
	lda #GFXF_HEART
	sta prj_GFXID,x
skip2	rts
.)


PerformProjectileCommonChecks
	lda HeroX
	cmp #3
.(
	bcc skip1
	cmp #34
	bcs skip2
	
	jsr FetchNewProjectileIndex
skip2	rts
skip1	sec
.)
	rts

FetchNewProjectileIndex
	lda UltimateProjectile
.(
	bmi skip2
	cmp #7
	bcs skip1
skip2	inc UltimateProjectile
	ldx UltimateProjectile
skip1	rts
.)

FireEngine
	ldx UltimateProjectile
.(
	bmi skip1
	
loop1	;Delete Projectile from screen
	jsr DeleteProjectile
	
	;If Orb gradually increase fall
	lda prj_GFXID,x
	cmp #28
	bne skip2
	inc prj_YStep,x
	
skip2	;Move projectile
	lda prj_Y,x
	clc
	adc prj_YStep,x
	ora #1	;and #$FE
	sta prj_Y,x
	tay
	lda prj_X,x
	clc
	adc prj_XStep,x
	sta prj_X,x
	
	;Check boundaries
	cmp #1
	bcc DestroyProjectile
	cmp #38
	bcs DestroyProjectile
	cpy #30
	bcc DestroyProjectile
	cpy #124
	bcs DestroyProjectile
	
	;Check collisions
	jsr CheckFireCollision
	bcc skip3
	jsr HitNPC
	
skip3	;Plot Projectile
	jsr PlotProjectile

	dex
	bpl loop1
skip1	rts
.)

DestroyProjectile
	;Avoid having to set everything if already the same index
	cpx UltimateProjectile
.(
	beq skip1
	;Copy last projectile to current
	ldy UltimateProjectile
	lda prj_X,y
	sta prj_X,x
	lda prj_Y,y
	sta prj_Y,x
	lda prj_XStep,y
	sta prj_XStep,x
	lda prj_YStep,y
	sta prj_YStep,x
	lda prj_GFXID,y
	sta prj_GFXID,x
	;Then remove last one
skip1	dec UltimateProjectile
.)
	rts
	
HitNPC	;NPC Index held in Y
.(
	stx vector1+1
	;Check that NPC is not already being destroyed
	ldx NPC_Activity,y
	cpx #NPCA_EXPLODE
	beq vector1

	;Cannot destroy raindrops, Bees or Fairies
	cpx #NPCA_BEE
	beq vector1
	cpx #NPCA_RAINDROP
	beq vector1
	cpx #NPCA_FAIRY
	beq MakeFairyShedATear
	
	ldx NPC_Activity,y
	lda NPC_ExplosionsNeeded,x
	sta NPC_Count,y
	lda NPC_SpriteFrame4Activity,x
	sta NPC_SpriteFrame,y
	lda #NPCA_EXPLODE
	sta NPC_Activity,y
	lda #NPCF_EXPLOSION
	sta NPC_Progress,y
	lda NPC_ScreenX,y
	sta NPC_ScreenXOrigin,y
	lda NPC_ScreenY,y
	sta NPC_ScreenYOrigin,y

	;Wipe B4-7 of collision map(720) - Next frame will restore living NPC's
	ldx #240
loop1	lda CollisionMap-1,x
	and #15
	sta CollisionMap-1,x
	lda CollisionMap+239,x
	and #15
	sta CollisionMap+239,x
	lda CollisionMap+479,x
	and #15
	sta CollisionMap+479,x
	dex
	bne loop1

	;Add score
	lda #$50
	jsr AddScore
	jsr DisplayScore
	
	;Kick Explosion SFX
	lda #SFX_EXPLOSION
	jsr KickSFX
	
vector1	ldx #00
	rts

MakeFairyShedATear
	;Kill the Kiss
	sty vector2+1
	ldx vector1+1
	jsr DestroyProjectile
vector2	ldx #00

	;Spawn a Tear
	jsr FetchNewNPCIndex
	bcs skip1
	lda NPC_ScreenX,x
	sta NPC_ScreenX,y
	lda NPC_ScreenY,x
	sta NPC_ScreenY,y
	;Starting at offset 7 in sine table means we'll move up 6,4,2 before down. and abs min fairy is 42
	lda #0
	sta NPC_Progress,y
	lda #7
	sta NPC_Special,y	;Used in controlling arc of tear and after - for period of remaining on ground
	lda #NPCA_THROWNTEAR
	sta NPC_Activity,y
skip1	jmp vector1
.)

NPC_ExplosionsNeeded
 .byt 1	;NPCA_BALLRISING	0
 .byt 1	;NPCA_BALLBOUNCE	1
 .byt 1	;NPCA_BALLPAUSE	2
 .byt 2	;NPCA_GRUBPEEP	3
 .byt 2	;NPCA_GRUBMOVE	4
 .byt 1	;NPCA_RAINDROP	5
 .byt 2	;NPCA_EGGWASP	6
 .byt 2	;NPCA_DRAGONLEFT	7
 .byt 2	;NPCA_DRAGONRIGHT	8
 .byt 1	;NPCA_BEE		9
 .byt 1	;NPCA_EXPLODE	10
 .byt 1	;NPCA_SPIDER	11

	

CheckFireCollision
	lda prj_X,x
	ldy prj_Y,x
	clc
	adc CollisionMapYLOCL-30,y
.(
	sta vector1+1
	lda CollisionMapYLOCH-30,y
	adc #00
	sta vector1+2
vector1	lda $dead
	and #$F0
	beq skip1
	; 00 Background
	; 01-0C NPC Index
	cmp #$D0
	bcs skip2
	;Place NPC Index in Y
	lsr
	lsr
	lsr
	lsr
	tay
	dey

	sec
skip1	rts
skip2	clc
	rts
.)

DeleteProjectile
	lda prj_GFXID,x
	sta SpriteFrame
	lda prj_X,x
	ldy prj_Y,x
	jsr RecalcScreen
	lda prj_X,x
	ldy prj_Y,x
	stx rsbg_RestorationOfX+1
	jmp RestoreSpriteBG2

PlotProjectile
	lda prj_GFXID,x
	sta SpriteFrame
	lda prj_X,x
	ldy prj_Y,x
	jsr RecalcScreen
	jmp PlotSpriteWithMask
