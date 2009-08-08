;Projectiles_Engine.s
;Controls and displays all projectiles in Swiv

;Projectiles follow a much simpler path, making scripts a bit of an overkill.
;They can observe the following paths
;000 E Bound
;001 SE Bound
;002 S Bound
;003 SW Bound
;004 W Bound
;005 NW Bound
;006 N Bound
;007 NE Bound
;128-135 Turn and move forwards toward Target
;129 Move toward target

;Deal with Codes 8 onwards
;Whilst each Projectile can potentially set the exact Graphic to represent it -
;the format of the graphics is always 8 direction frames starting with East followed
;by 4 sprites which may be set in conjunction with the behaviour.
;Behaviour 128-135 relies on the direction frames.
;
SpecialProjectileBehaviour
;	cpy #136
;	bcs MoveTowardsTarget
;TurnTowardsTarget
	jmp ProjRent2
	
	
	
	
	

RemoveProjectile
	cpx UltimateProjectile
.(
	beq skip1
	ldy UltimateProjectile
	lda Projectile_X,y
	sta Projectile_X,x
	lda Projectile_Y,y
	sta Projectile_Y,x
	lda Projectile_Behaviour,y
	sta Projectile_Behaviour,x
	lda Projectile_GraphicID,y
	sta Projectile_GraphicID,x
	lda Projectile_Ownership,y
	sta Projectile_Ownership,x
	lda Projectile_HitPoints,y
	sta Projectile_HitPoints,x
skip1	dec UltimateProjectile
.)
	jmp ProjRent1
ProjExit2	rts
	

ProjectileDriver
	ldx UltimateProjectile
	bmi ProjExit2

Projloop1	ldy Projectile_Behaviour,x
	bmi SpecialProjectileBehaviour
	
	;Move projectile
	lda Projectile_X,x
	clc
	adc ProjectileXStep,y
	sta Projectile_X,x
	lda Projectile_Y,x
	clc
	adc ProjectileYStep,y
	sta Projectile_Y,x
	
	;Check Boundaries
	cmp #152
	bcs RemoveProjectile
	tay
	lda Projectile_X,x
	cmp #23
	bcs RemoveProjectile
	
	;Check Collisions
	adc CollisionMap_YLOCLo,y
	sta projvec1+1
	lda CollisionMap_YLOCHi,y
	adc #00
	sta projvec1+2
projvec1	lda $dead
	bne FoundCollision
	
ProjRent2	;Calculate Graphic location
	lda Projectile_GraphicID,x	;0-11
	sta ProjectileBitmap
	
	;Calculate ScreenBuffer Locations
	lda Projectile_X,x
	adc ScreenBufferRowAddressLo,y
	sta screen
	lda ScreenBufferRowAddressHi,y
	adc #00
	sta screen+1

	;Plot Projectile
	ldy #00
	lda (ProjectileBitmap),y
	sta (screen),y
	ldy #24*1
	lda (ProjectileBitmap),y
	sta (screen),y
	ldy #24*2
	lda (ProjectileBitmap),y
	sta (screen),y
ProjRent1	dex
	bpl Projloop1
ProjExit	rts
	
FoundCollision
;	nop
;	jmp FoundCollision
	;Collision Byte in A
	;B0-1 Sprite Type
      	;	0 Reserved for No Collision
      	;	1 Player A Craft
      	;	2 Player B Craft
      	;	3 Sprite (Data is UniqueID 0-63)
	;B2-7 Data for Type
	tay
	and #3
	cmp #2
	bcc PlayerA_Collision
	bne Enemy_Collision
	jmp PlayerB_Collision

Enemy_Collision
	; 0 Shot by PlayerA
	; 1 Shot by PlayerB
	; 128 Shot by Enemy
	lda Projectile_Ownership,x
	bpl PlayerHitsEnemy
	;Restore things before re-entering loop
	ldy Projectile_Y,x
	clc
	jmp ProjRent2	;Projectile was shot by Enemy and hit enemy

PlayerHitsEnemy
	;Now locate exact Enemy sprite through its unique ID in Y
	tya
	ldy UltimateSprite
.(
loop1	cmp Sprite_UniqueID,y
	beq ProjSkip1
	dey
	bpl loop1
.)
	;This should never occur unless there is corruption in the collision map
ProjRent3	jmp ProjRent2
ProjSkip1	;Y contains Sprite Index of Enemy just hit
;	nop
;	jmp ProjSkip1
	lda Sprite_HitPoints,y
.(
	bmi skip1
	sbc Projectile_HitPoints,x
	sta Sprite_HitPoints,y
	bcc KillEnemy
	;Show we successfully hit enemy through a Whiteout for one gamecycle
	lda Sprite_Attributes,y
	ora #BIT2
	sta Sprite_Attributes,y
skip1	;Set the Script Index to the Hit index if non zero
	lda Sprite_HitIndex,y
	beq skip2
	sta Sprite_ScriptIndex,y
skip2	;Because we hit the enemy we must destroy this projectile
	jmp RemoveProjectile
.)

KillEnemy
;	nop
;	jmp KillEnemy
	
	;Add Enemies ScorePoints(Sprite_ScorePoints,y) to hero(Projectile_Ownership,x)
	lda Projectile_Ownership,x
	tax
	lda Sprite_ScorePoints,y
	sty ProjectileTempY
	jsr Add2Score
	;Set Enemy to Explosion Frame
	ldy ProjectileTempY
	jsr BlowUpSprite
	;Destroy Projectile
	jmp RemoveProjectile

PlayerA_Collision
	; 0 Shot by PlayerA
	; 1 Shot by PlayerB
	; 128 Shot by Enemy
	lda Projectile_Ownership,x
	bpl ProjRent3	;Projectile was shot by Player and hit Player
EnemyHitsPlayerA
	;Decrease Player A's Health
	lda PlayerHealth
	sec
	sbc Projectile_HitPoints,x
	sta PlayerHealth
	bcc KillPlayerA
	;Show new Health level for Player A
	tay
	lda HealthByte0,y
	sta $B272
	lda HealthByte1,y
	sta $B273
	lda HealthByte2,y
	sta $B274
	lda HealthByte3,y
	sta $B275
	;Whiteout PlayerA for one frame
	ldy PlayerA_SpriteIndex
	lda Sprite_Attributes,y
	ora #BIT2
	sta Sprite_Attributes,y
	;Destroy Projectile
	jmp RemoveProjectile

PlayerB_Collision
	; 0 Shot by PlayerA
	; 1 Shot by PlayerB
	; 128 Shot by Enemy
	lda Projectile_Ownership,x
	bpl ProjRent3	;Projectile was shot by Player and hit Player
EnemyHitsPlayerB
	;Decrease Player B's Health
	lda PlayerHealth+1
	sec
	sbc Projectile_HitPoints,x
	sta PlayerHealth+1
	bcc KillPlayerB
	;Show new Health level for Player A
	tay
	lda HealthByte0,y
	sta $B290
	lda HealthByte1,y
	sta $B291
	lda HealthByte2,y
	sta $B292
	lda HealthByte3,y
	sta $B293
	;Whiteout PlayerA for one frame
	ldy PlayerB_SpriteIndex
	lda Sprite_Attributes,y
	ora #BIT2
	sta Sprite_Attributes,y
	;Destroy Projectile
	jmp RemoveProjectile

KillPlayerA
	;Set PlayerA to Explode - Explosion script will continue players story
	ldy PlayerA_SpriteIndex
	jsr BlowUpSprite
	;Destroy Projectile
	jmp RemoveProjectile
	
KillPlayerB
	;Set PlayerB to Explode - Explosion script will continue players story
	ldy PlayerB_SpriteIndex
	jsr BlowUpSprite
	;Destroy Projectile
	jmp RemoveProjectile

BlowUpSprite
	lda Sprite_ExplosionScript,y
	sta Sprite_ScriptID,y
	lda #00
	sta Sprite_ScriptIndex,y
	sta Sprite_PausePeriod,y
	sta Sprite_ConditionID,y
	sta Sprite_Counter,y
	lda #BIT4
	sta Sprite_Attributes,y
	;Adjust sprite position to show Explosion in centre
	
	;Sprite X = Sprite X + (Original Sprite Width / 2)-1
	lda Sprite_Width,y
	lsr
	sec
	sbc #1
	clc
	adc Sprite_X,y
	sta Sprite_X,y
	lda #2
	sta Sprite_Width,y
	
	;Sprite Y = Sprite Y + (Original Sprite Height / 2)-1
	lda Sprite_Height,y
	lsr
	sec
	sbc #1
	clc
	adc Sprite_Y,y
	sta Sprite_Y,y
	
	lda #11
	sta Sprite_Height,y
	lda #21
	sta Sprite_UltimateByte,y
	rts

	

;Projectiles are always 6(1)x6 and arranged in a column width of 24 on a page boundary.
PageAllign
 .dsb 256-(*&255)
ProjectileGFX
;      00  01  02  03  04  05  06  07  08  09  10  11  12  13  14  15
;      WC  SQ  EE  SE  SS  SW  WW  NW  NN  NE  ME  ME  MW  MW  XX  XX  --  --  --  --  --
 .byt $F3,$4E,$58,$48,$54,$48,$4C,$58,$48,$4C,$48,$48,$44,$44,$CC,$52,$E1,$F3,$4C,$E0,$C1,$40,$40,$40
 .byt $E1,$4A,$4C,$5C,$5C,$5C,$58,$5C,$5C,$5C,$F8,$47,$C7,$78,$F3,$4C,$E1,$4C,$E1,$E0,$C1,$40,$40,$40
 .byt $F3,$4E,$58,$4C,$48,$58,$4C,$48,$54,$48,$48,$48,$44,$44,$CC,$52,$E1,$F3,$4C,$E0,$C1,$40,$40,$40
;Projectile may be PlayerA,PlayerB, Enemy4A  or Enemy4B
Projectile_X
 .dsb 32,0
Projectile_Y
 .dsb 32,0
;0 East Bound
;1 South East Bound
;2 South Bound
;3 South West Bound
;4 West Bound
;5 North West Bound
;6 North Bound
;7 North East Bound
;+128 Special Behaviour
;+64 Homing Missile
;+32 glide towards Target
Projectile_Behaviour
 .dsb 32,0
;00 White Cell (Enemy)
;01 Square Cell (Player)
;02 Bullet East (Player)
;03 Bullet Southeast (Player)
;04 Bullet South (Player)
;05 Bullet Southwest (Player)
;06 Bullet West (Player)
;07 Bullet Northwest (Player)
;08 Bullet North (Player)
;09 Bullet Northeast (Player)
;10 Missile East #0 (Enemy)
;11 Missile East #1 (Enemy)
;12 Missile West #0 (Enemy)
;13 Missile West #1 (Enemy)
;14 Homing Missile #0 (Enemy)
;15 Homing Missile #1 (Enemy)
;16 
Projectile_GraphicID
 .dsb 32,0
; 0 Shot by PlayerA
; 1 Shot by PlayerB
; 128 Shot by Enemy to kill PlayerA
Projectile_Ownership
 .dsb 32,0
Projectile_HitPoints
 .dsb 32,0

ProjectileXStep
 .byt 1,1,0,255,255,255,0,1
ProjectileYStep
 .byt 0,6,6,6,0,250,250,250

FireFrequencyCounter
 .dsb 2,0
FireFrequency
 .byt 32,32
 
