;HeroControl.s - Run from Driver.s - Drives X and Y movement but oss_language does actual moves

;Currently key control is emulator stuff, and will probably crash real oric
PlayerA_HeroControl_EuphoricKeyboard
	;Fetch Input
	lda #00
	sta ControllerA_Register
	lda #$0E
	sta VIA_PORTA
	lda #$FF
	sta VIA_PCR
	lda #$FD
	sta VIA_PCR
	ldy #5
.(
loop1	lda PlayerA_KeyboardColumn,y
	sta VIA_PORTA
	lda PlayerA_KeyboardRow,y
	sta VIA_PORTB
	lda VIA_PORTB
	and #8
	beq skip1
	lda ControllerA_Register
	ora Bitpos,y
	sta ControllerA_Register
skip1	dey
	bpl loop1
.)
	ldx #00
	jmp CommonHeroControl

PlayerB_HeroControl_EuphoricKeyboard
	;Fetch Input
	lda #00
	sta ControllerB_Register
	lda #$0E
	sta VIA_PORTA
	lda #$FF
	sta VIA_PCR
	lda #$FD
	sta VIA_PCR
	ldy #5
.(
loop1	lda PlayerB_KeyboardColumn,y
	sta VIA_PORTA
	lda PlayerB_KeyboardRow,y
	sta VIA_PORTB
	lda VIA_PORTB
	and #8
	beq skip1
	lda ControllerB_Register
	ora Bitpos,y
	sta ControllerB_Register
skip1	dey
	bpl loop1
.)
	ldx #01
	jmp CommonHeroControl

	
;Entered from ControllerDriver
;X Player A(0) or B(1)
;Control Heroes movements through Player?_XMovement and Player?_YMovement
;Initialise Projectiles on Fire1 or 2
CommonHeroControl
	lda #00
	sta PlayerA_XMovement,x
	sta PlayerA_YMovement,x
	;Now process input
	lda ControllerA_Register,x
	and #CTRL_LEFT
.(
	beq skip1
	lda #1
	sta PlayerA_XMovement,x
	jmp skip2
skip1	lda ControllerA_Register,x
	and #CTRL_RIGHT
	beq skip2
	lda #128
	sta PlayerA_XMovement,x
skip2	lda ControllerA_Register,x
	and #CTRL_UP
	beq skip3
	lda #1
	sta PlayerA_YMovement,x
	jmp skip4
skip3	lda ControllerA_Register,x
	and #CTRL_DOWN
	beq skip4
	lda #128
	sta PlayerA_YMovement,x
skip4	lda ControllerA_Register,x
	and #CTRL_FIRE1
	beq skip5
	jsr CraftFire1
skip5	lda ControllerA_Register,x
	and #CTRL_FIRE2
	beq skip6
	jsr CraftFire2
skip6
.)
	rts
	
;;This is at the start when player has not started playing the game
;PlayerPressFireToStart
;	;Blink "Press Fire" by alternating black/colour ink at game cycle speed
;	lda PressFireBlinkingFlag,y
;	eor #1
;	sta PressFireBlinkingFlag,y
;	tax
;	cpy #1
;.(
;	beq skip1
;	;Display for PlayerA
;	lda BlinkingColourRow0,x
;	sta $B5E0
;	lda BlinkingColourRow1,x
;	sta $B5E0+40*1
;	lda BlinkingColourRow2,x
;	sta $B5E0+40*2
;	lda BlinkingColourRow3,x
;	sta $B5E0+40*3
;	lda BlinkingColourRow4,x
;	sta $B5E0+40*4
;	lda BlinkingColourRow5,x
;	sta $B5E0+40*5
;	jmp skip2
;skip1	lda BlinkingColourRow0,x
;	sta $B5FE
;	lda BlinkingColourRow1,x
;	sta $B5FE+40*1
;	lda BlinkingColourRow2,x
;	sta $B5FE+40*2
;	lda BlinkingColourRow3,x
;	sta $B5FE+40*3
;	lda BlinkingColourRow4,x
;	sta $B5FE+40*4
;	lda BlinkingColourRow5,x
;	sta $B5FE+40*5
;skip2
;.)
;	;Detect Fire1
;	lda ControllerA_Register,y
;	and #CTRL_FIRE1
;	beq skip1
;	

CraftFire1	;Main Cannon + Smartbomb(Hold)
	;Each player can have up to the following weaponry
	; Forward Cannon(2)	Shoots N (One or two parallel shots depending on strength)
	; Splay(2)	Shoots NW and NE
	; Sidewinders(2)	Shoots W and E
	; Retro-fire(2)	Shoots S on both wings
	;In addition the player can also get a smart bomb and a shield
	
	;This means each player gets a maximum artilliary of 8 projectiles which are shot
	;every 8th game cycle
	;If both players are active then each weapon can display up to 4 shells following same path
	
	lda FireFrequencyCounterA,x
.(	
	bne skip4
	;Reset counter to frequency of fire permitted
	lda #8	;We'll just use 8 for now
	sta FireFrequencyCounterA,x
	;On Fire check what weapons we have
	;B0 
	;B1 Forward Cannon(2) - If not set use (1)
	;B2 Splay
	;B3 Sidewinders
	;B4 Retro-fire
	;B5 smart bomb
	;B6 shield
	;B7 ?
	lda #1
	jsr InitProjectile_ForwardCannon
	lda PlayerA_Weapons,x
	and #BIT1
	beq skip1
	jsr InitProjectile_ForwardCannon
	lda Sprite_X,x
skip1	lda PlayerA_Weapons,x
	and #BIT2
	beq skip2
	jsr InitProjectile_Splay
skip2	lda PlayerA_Weapons,x
	and #BIT3
	beq skip3
	jsr InitProjectile_Sidewinders
skip3	lda PlayerA_Weapons,x
	and #BIT4
	beq skip4
	jsr InitProjectile_RetroFire
skip4	rts
.)
	
;A X offset of projectile from hero
InitProjectile_ForwardCannon
	pha
	jsr SpawnProjectile
	pla
.(
	bcs skip1
	adc Sprite_X,x
	sta Projectile_X,y
	lda Sprite_Y,x
	sbc #5
	sta Projectile_Y,y
	lda #PROJECTILE_NORTHBOUND
	sta Projectile_Behaviour,y
	lda #GFX_PROJECTILE_NORTHBOUND
	sta Projectile_GraphicID,y
	lda #1
	sta Projectile_HitPoints,y
skip1	ldx CraftTempX
.)
	rts
	

InitProjectile_Splay
	;Spawn Diagonal NW Projectile
	jsr SpawnProjectile
.(
	bcs skip1
	lda Sprite_X,x
	sta Projectile_X,y
	lda Sprite_Y,x
	sbc #5
	sta Projectile_Y,y
	lda #PROJECTILE_NORTHWESTBOUND
	sta Projectile_Behaviour,y
	lda #GFX_PROJECTILE_NORTHWESTBOUND
	sta Projectile_GraphicID,y
	lda #1
	sta Projectile_HitPoints,y
	ldx CraftTempX
	;Spawn Diagonal NE Projectile
	jsr SpawnProjectile
	bcs skip1
	lda Sprite_X,x
	adc #3
	sta Projectile_X,y
	lda Sprite_Y,x
	sbc #5
	sta Projectile_Y,y
	lda #PROJECTILE_NORTHEASTBOUND
	sta Projectile_Behaviour,y
	lda #GFX_PROJECTILE_NORTHEASTBOUND
	sta Projectile_GraphicID,y
	lda #1
	sta Projectile_HitPoints,y
skip1	ldx CraftTempX
.)
	rts
InitProjectile_Sidewinders
	;Spawn Sidewinder W Projectile
	jsr SpawnProjectile
.(
	bcs skip1
	lda Sprite_X,x
	sta Projectile_X,y
	lda Sprite_Y,x
	adc #6
	sta Projectile_Y,y
	lda #PROJECTILE_WESTBOUND
	sta Projectile_Behaviour,y
	lda #GFX_PROJECTILE_WESTBOUND
	sta Projectile_GraphicID,y
	lda #1
	sta Projectile_HitPoints,y
	ldx CraftTempX
	;Spawn Sidewinder E Projectile
	jsr SpawnProjectile
	bcs skip1
	lda Sprite_X,x
	adc #4
	sta Projectile_X,y
	lda Sprite_Y,x
	adc #6
	sta Projectile_Y,y
	lda #PROJECTILE_EASTBOUND
	sta Projectile_Behaviour,y
	lda #GFX_PROJECTILE_EASTBOUND
	sta Projectile_GraphicID,y
	lda #1
	sta Projectile_HitPoints,y
skip1	ldx CraftTempX
.)
	rts

InitProjectile_RetroFire
	;Spawn Vertical Back S Projectiles
	jsr SpawnProjectile
.(
	bcs skip1
	lda Sprite_X,x
	adc #1
	sta Projectile_X,y
	lda Sprite_Y,x
	adc #2
	sta Projectile_Y,y
	lda #PROJECTILE_SOUTHBOUND
	sta Projectile_Behaviour,y
	lda #GFX_PROJECTILE_SOUTHBOUND
	sta Projectile_GraphicID,y
	lda #1
	sta Projectile_HitPoints,y
	ldx CraftTempX
	;Spawn Vertical Back S Projectiles
	jsr SpawnProjectile
	bcs skip1
	lda Sprite_X,x
	adc #2
	sta Projectile_X,y
	lda Sprite_Y,x
	adc #2
	sta Projectile_Y,y
	lda #PROJECTILE_SOUTHBOUND
	sta Projectile_Behaviour,y
	lda #GFX_PROJECTILE_SOUTHBOUND
	sta Projectile_GraphicID,y
	lda #1
	sta Projectile_HitPoints,y
skip1	ldx CraftTempX
.)
	rts

SpawnProjectile
	lda UltimateProjectile
	clc
	;Skip if none on screen
.(
	bmi skip2
	;Don't spawn if not enough sprites
	cmp #31
	bcs skip1
skip2	;Spawn new projectile
	inc UltimateProjectile
	ldy UltimateProjectile
	txa
	sta Projectile_Ownership,y
	stx CraftTempX
	lda PlayerA_SpriteIndex,x
	tax
skip1	rts
.)	


	
CraftFire2	;Sidearms(Cyclic) + ?(Hold)
	rts
	
	
	
	
	

