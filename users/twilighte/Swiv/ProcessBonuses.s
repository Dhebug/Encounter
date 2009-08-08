;ProcessBonuses.s

ProcessBonus_Health		; - 1
	rts
	jsr CalculatePlayerIndex
	lda #10
	jmp AddPlayersHealth	;y==player A==Health to add
ProcessBonus_Life             ; - 2
	rts
	jsr CalculatePlayerIndex
	lda #1
	jmp AddPlayersLife		;y==player A==Lives to add
ProcessBonus_DoubleCannon     ; - 3
	jsr CalculatePlayerIndex
	lda PlayerA_Weapons,y
	ora #BIT1
	sta PlayerA_Weapons,y
	ldx #7
	jmp PlotWeapon

ProcessBonus_Splay            ; - 4
	jsr CalculatePlayerIndex
	lda PlayerA_Weapons,y
	ora #BIT2
	sta PlayerA_Weapons,y
	ldx #3
	jmp PlotWeapon
ProcessBonus_Sidewinders      ; - 5
	jsr CalculatePlayerIndex
	lda PlayerA_Weapons,y
	ora #BIT3
	sta PlayerA_Weapons,y
	ldx #8
	jsr PlotWeapon
	ldx #11
	jmp PlotWeapon

ProcessBonus_Retros           ; - 6
	jsr CalculatePlayerIndex
	lda PlayerA_Weapons,y
	ora #BIT4
	sta PlayerA_Weapons,y
	ldx #14
	jsr PlotWeapon
	ldx #15
	jmp PlotWeapon

ProcessBonus_SmartBomb        ; - 7
	jsr CalculatePlayerIndex
	lda PlayerA_Weapons,y
	ora #BIT5
	sta PlayerA_Weapons,y
	ldx #0
	jmp PlotWeapon
ProcessBonus_Missile          ; - 8
	jsr CalculatePlayerIndex
	lda PlayerA_Weapons,y
	ora #BIT6
	sta PlayerA_Weapons,y
	ldx #12
	jmp PlotWeapon
ProcessBonus_Laser            ; - 9
	jsr CalculatePlayerIndex
	lda PlayerA_Weapons,y
	ora #BIT7
	sta PlayerA_Weapons,y
	ldx #17
	jsr PlotWeapon
	ldx #18
	jmp PlotWeapon
ProcessBonus_SpeedUp          ; - A
ProcessBonus_Invisibility     ; - B
ProcessBonus_Shield           ; - C
	rts
ProcessBonus_Orb              ; - D
;	nop
;	jmp ProcessBonus_Orb
	jsr CalculatePlayerIndex
	lda PlayerA_Weapons,y
	ora #BIT0
	sta PlayerA_Weapons,y
	ldx #16
	jmp PlotWeapon
ProcessBonus_Blank		; - E
	rts
	
	
CalculatePlayerIndex
	lda Sprite_Attributes,x
	and #3
	sec
	sbc #2
	tay
	lda BluPrintPlayerXOffset,y
	sta BluPrintXOffset
	rts
	
DeleteWeapon
	lda bpWeaponScreenLocLo,x
	clc
	adc BluPrintXOffset
	sta screen
	lda bpWeaponScreenLocHi,x
	adc #00
	sta screen+1
	lda bpWeaponGraphicBackgroundLo,x
.(
	sta graphic+1
	lda bpWeaponGraphicBackgroundHi,x
	sta graphic+2
	lda bpWeaponUltimateByte,x
	tax
loop1	ldy ScreenOffset,x
graphic	lda $dead,x
	sta (screen),y
	dex
	bpl loop1
.)
	rts
	
PlotWeapon
	lda bpWeaponScreenLocLo,x
	clc
	adc BluPrintXOffset
	sta screen
	lda bpWeaponScreenLocHi,x
	adc #00
	sta screen+1
	lda bpWeaponGraphicLo,x
.(
	sta graphic+1
	lda bpWeaponGraphicHi,x
	sta graphic+2
	lda bpWeaponUltimateByte,x
	tax
loop1	ldy ScreenOffset,x
graphic	lda $dead,x
	sta (screen),y
	dex
	bpl loop1
.)
	rts

bpWeaponScreenLocLo
 .byt <$A8EA	;00 SmartBomb         
 .byt <$A8EC        ;01 ForwardShieldLeft 
 .byt <$A8ED        ;02 ForwardShieldRight
 .byt <$A8EF        ;03 Splay             
 .byt <$A9DA        ;04 ForwardCannon1    
 .byt <$A9DC        ;05 CentralShieldLeft 
 .byt <$A9DD        ;06 CentralShieldRight
 .byt <$A9DF        ;07 ForwardCannon2    
 .byt <$ABBA        ;08 SideWinderLeft    
 .byt <$ABBC        ;09 ThrustLeft        
 .byt <$ABBD        ;10 ThrustRight       
 .byt <$ABBF        ;11 SideWinderRight   
 .byt <$AC33        ;12 Missile           
 .byt <$AC36        ;13 Invisibility      
 .byt <$AD4B        ;14 RetroLeft         
 .byt <$AD4E        ;15 RetroRight        
 .byt <$A52D	;16 Orb - Special Case
 .byt <$A9DA	;17 Laser Left
 .byt <$A9DF	;18 Laser Right
bpWeaponScreenLocHi
 .byt >$A8EA	;SmartBomb         
 .byt >$A8EC        ;ForwardShieldLeft 
 .byt >$A8ED        ;ForwardShieldRight
 .byt >$A8EF        ;Splay             
 .byt >$A9DA        ;ForwardCannon1    
 .byt >$A9DC        ;CentralShieldLeft 
 .byt >$A9DD        ;CentralShieldRight
 .byt >$A9DF        ;ForwardCannon2    
 .byt >$ABBA        ;SideWinderLeft    
 .byt >$ABBC        ;ThrustLeft        
 .byt >$ABBD        ;ThrustRight       
 .byt >$ABBF        ;SideWinderRight   
 .byt >$AC33        ;Missile           
 .byt >$AC36        ;Invisibility      
 .byt >$AD4B        ;RetroLeft         
 .byt >$AD4E        ;RetroRight        
 .byt >$A52D	;Orb - Special Case
 .byt >$A9DA	;Laser Left
 .byt >$A9DF	;Laser Right
bpWeaponUltimateByte	;0 Base
 .byt 4	;SmartBomb         
 .byt 1	;ForwardShieldLeft 
 .byt 1	;ForwardShieldRight
 .byt 4	;Splay             
 .byt 5	;ForwardCannon1    
 .byt 1	;CentralShieldLeft 
 .byt 1	;CentralShieldRight
 .byt 5	;ForwardCannon2    
 .byt 2	;SideWinderLeft    
 .byt 0	;ThrustLeft        
 .byt 0	;ThrustRight       
 .byt 2	;SideWinderRight   
 .byt 5	;Missile           
 .byt 5	;Invisibility      
 .byt 5	;RetroLeft         
 .byt 5	;RetroRight        
 .byt 4	;Orb
 .byt 5	;Laser Left
 .byt 5	;Laser Right

bpWeaponGraphicLo
 .byt <gfxBPWeapon_SmartBomb
 .byt <gfxBPWeapon_ForwardShieldLeft
 .byt <gfxBPWeapon_ForwardShieldRight
 .byt <gfxBPWeapon_Splay
 .byt <gfxBPWeapon_ForwardCannon1
 .byt <gfxBPWeapon_CentralShieldLeft
 .byt <gfxBPWeapon_CentralShieldRight
 .byt <gfxBPWeapon_ForwardCannon2
 .byt <gfxBPWeapon_SideWinderLeft
 .byt <gfxBPWeapon_ThrustLeft
 .byt <gfxBPWeapon_ThrustRight
 .byt <gfxBPWeapon_SideWinderRight
 .byt <gfxBPWeapon_Missile
 .byt <gfxBPWeapon_Invisibility
 .byt <gfxBPWeapon_RetroLeft
 .byt <gfxBPWeapon_RetroRight
 .byt <gfxBPWeapon_Orb
 .byt <gfxBPWeapon_Laser
 .byt <gfxBPWeapon_Laser

bpWeaponGraphicHi
 .byt >gfxBPWeapon_SmartBomb
 .byt >gfxBPWeapon_ForwardShieldLeft
 .byt >gfxBPWeapon_ForwardShieldRight
 .byt >gfxBPWeapon_Splay
 .byt >gfxBPWeapon_ForwardCannon1
 .byt >gfxBPWeapon_CentralShieldLeft
 .byt >gfxBPWeapon_CentralShieldRight
 .byt >gfxBPWeapon_ForwardCannon2
 .byt >gfxBPWeapon_SideWinderLeft
 .byt >gfxBPWeapon_ThrustLeft
 .byt >gfxBPWeapon_ThrustRight
 .byt >gfxBPWeapon_SideWinderRight
 .byt >gfxBPWeapon_Missile
 .byt >gfxBPWeapon_Invisibility
 .byt >gfxBPWeapon_RetroLeft
 .byt >gfxBPWeapon_RetroRight
 .byt >gfxBPWeapon_Orb
 .byt >gfxBPWeapon_Laser
 .byt >gfxBPWeapon_Laser

bpWeaponGraphicBackgroundLo
 .byt <gfxBPBackground_SmartBomb
 .byt <gfxBPBackground_ForwardShieldLeft
 .byt <gfxBPBackground_ForwardShieldRight
 .byt <gfxBPBackground_Splay
 .byt <gfxBPBackground_ForwardCannonLeft
 .byt <gfxBPBackground_CentralShieldLeft
 .byt <gfxBPBackground_CentralShieldRight
 .byt <gfxBPBackground_ForwardCannonRight
 .byt <gfxBPBackground_SideWinderLeft
 .byt <gfxBPBackground_ThrustLeft
 .byt <gfxBPBackground_ThrustRight
 .byt <gfxBPBackground_SideWinderRight
 .byt <gfxBPBackground_Missile
 .byt <gfxBPBackground_Invisibility
 .byt <gfxBPBackground_RetroLeft
 .byt <gfxBPBackground_RetroRight
 .byt <gfxBPBackground_Orb
 .byt <gfxBPBackground_LaserLeft
 .byt <gfxBPBackground_LaserRight
bpWeaponGraphicBackgroundHi
 .byt >gfxBPBackground_SmartBomb
 .byt >gfxBPBackground_ForwardShieldLeft
 .byt >gfxBPBackground_ForwardShieldRight
 .byt >gfxBPBackground_Splay
 .byt >gfxBPBackground_ForwardCannonLeft
 .byt >gfxBPBackground_CentralShieldLeft
 .byt >gfxBPBackground_CentralShieldRight
 .byt >gfxBPBackground_ForwardCannonRight
 .byt >gfxBPBackground_SideWinderLeft
 .byt >gfxBPBackground_ThrustLeft
 .byt >gfxBPBackground_ThrustRight
 .byt >gfxBPBackground_SideWinderRight
 .byt >gfxBPBackground_Missile
 .byt >gfxBPBackground_Invisibility
 .byt >gfxBPBackground_RetroLeft
 .byt >gfxBPBackground_RetroRight
 .byt >gfxBPBackground_Orb
 .byt >gfxBPBackground_LaserLeft
 .byt >gfxBPBackground_LaserRight

gfxBPWeapon_SmartBomb
 .byt $F3
 .byt $ED
 .byt $D2
 .byt $ED
 .byt $F3
gfxBPWeapon_ForwardShieldLeft
 .byt $E5
 .byt $C9
gfxBPWeapon_ForwardShieldRight
 .byt $E9
 .byt $E4
gfxBPWeapon_Splay
 .byt $DE
 .byt $FF
 .byt $ED
 .byt $FF
 .byt $F3
gfxBPWeapon_ForwardCannon1
 .byt $FF
 .byt $ED
 .byt $ED
 .byt $FF
 .byt $ED
 .byt $FF
gfxBPWeapon_Laser
 .byt $FF
 .byt $E1
 .byt $E1
 .byt $E1
 .byt $E1
 .byt $FF
gfxBPWeapon_CentralShieldLeft
 .byt $D5
 .byt $EA
gfxBPWeapon_CentralShieldRight
 .byt $EA
 .byt $D5
gfxBPWeapon_ForwardCannon2
 .byt $FF
 .byt $ED
 .byt $ED
 .byt $FF
 .byt $ED
 .byt $FF
gfxBPWeapon_SideWinderLeft
 .byt $FF
 .byt $E5
 .byt $FF
gfxBPWeapon_ThrustLeft
 .byt $5C
gfxBPWeapon_ThrustRight
 .byt $4E
gfxBPWeapon_SideWinderRight
 .byt $FF
 .byt $E9
 .byt $FF
gfxBPWeapon_Missile
 .byt $FF
 .byt $F3
 .byt $F3
 .byt $F3
 .byt $E1
 .byt $FF
gfxBPWeapon_Invisibility
 .byt $FF
 .byt $F5
 .byt $EB
 .byt $F5
 .byt $EB
 .byt $FF
gfxBPWeapon_RetroLeft
 .byt $FF
 .byt $ED
 .byt $FF
 .byt $ED
 .byt $ED
 .byt $FF
gfxBPWeapon_RetroRight
 .byt $FF
 .byt $ED
 .byt $FF
 .byt $ED
 .byt $ED
 .byt $FF
gfxBPWeapon_Orb
 .byt $5E
 .byt $F3
 .byt $E1
 .byt $F3
 .byt $5E

gfxBPBackground_SmartBomb
 .byt $40
 .byt $55
 .byt $40
 .byt $50
 .byt $40
gfxBPBackground_ForwardShieldLeft
 .byt $40
 .byt $46
gfxBPBackground_ForwardShieldRight
 .byt $40
 .byt $58
gfxBPBackground_Splay
 .byt $40
 .byt $55
 .byt $40
 .byt $40
 .byt $40
gfxBPBackground_LaserLeft
gfxBPBackground_ForwardCannonLeft
 .byt $42
 .byt $45
 .byt $48
 .byt $49
 .byt $50
 .byt $51
gfxBPBackground_CentralShieldLeft
 .byt $40
 .byt $40
gfxBPBackground_CentralShieldRight
 .byt $40
 .byt $40
gfxBPBackground_LaserRight
gfxBPBackground_ForwardCannonRight
 .byt $50
 .byt $68
 .byt $44
 .byt $64
 .byt $42
 .byt $62
gfxBPBackground_SideWinderLeft
 .byt $42
 .byt $42
 .byt $44
gfxBPBackground_ThrustLeft
 .byt $40
gfxBPBackground_ThrustRight
 .byt $40
gfxBPBackground_SideWinderRight
 .byt $50
 .byt $50
 .byt $48
gfxBPBackground_Missile
 .byt $41
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
gfxBPBackground_Invisibility
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
gfxBPBackground_RetroLeft
 .byt $48
 .byt $40
 .byt $4A
 .byt $48
 .byt $40
 .byt $4A
gfxBPBackground_RetroRight
 .byt $44
 .byt $40
 .byt $54
 .byt $44
 .byt $40
 .byt $54
gfxBPBackground_Orb
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
