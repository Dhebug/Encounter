;;;;; Functions to create objects and initialize universe.



OCEN     .word 0000            ;X-coord
         .word 0000            ;Y-coord
         .word 1300            ;Z-coord

OCEN2    .word -1000            ;X-coord
         .word 1000            ;Y-coord
         .word 1300            ;Z-coord


; Creates the environment, based on the data from cpl_system, so
; should be called after _jump on galaxy.s

CreateEnvironment
.(
    ; Make sure Obj3D is empty
    jsr _EmptyObj3D
    ; Create the radar object (number 0)
    jsr CreateRadar
    ; Add our ship, which is  object number 1 at initial position (fixed)
    ; This is different depending on whether we are launched from planet,
    ; or exit hyperspace. This depends on the _docked variable

    lda _docked
    beq hyper

    ; Create at planet's position
    jsr planetpos
    ; With Z a bit closer
    lda _PosZ+1
    sec
    sbc #7
    sta _PosZ+1
    jmp createship

hyper   
    lda #0
    sta _PosX
    sta _PosX+1
    sta _PosY
    sta _PosY+1
    lda #<(-16384+6000)
    sta _PosZ
    lda #>(-16384+6000)
    sta _PosZ+1

createship    
    lda #<_PosX
    sta tmp0
    lda #>_PosX   
    sta tmp0+1
    lda _ship_type
    jsr AddSpaceObject
	
	; Set our ship as view object
    stx VOB          

    lda _docked
    beq norot
    
    ; Rotate it 180 deg
    jsr SetCurOb
    lda #0
    tay           ; z and y angles 0 deg of rotation
    ldx #50;     ; rotate 180 deg
    jsr SetMat

norot
    ;ldy _ship_type
    ;lda ShipMaxSpeed-1,y
    ;lsr
    ;sta _speed+1
 
   	; And initialize all the stuff (equipment...)
	jsr InitPlayerShip

    jsr planetpos
    lda #<ONEPLANET
    ldy #>ONEPLANET
    jsr addmoonplanet
    
    ; Now create some moons (between 0 and 3)      
    lda _cpl_system+SEED+1
    and #%00000011
    beq moonsdone
    sta tmp1
    
    lda _PosX+1
    sta savpX+1
    lda _PosY+1
    sta savpY+1
    lda _PosZ+1
    sta savpZ+1


loop
    lda _cpl_system+SEED
    sta tmp
    jsr moonpos
    lda _PosX+1
    sec
    sbc tmp
    sta _PosX+1

    lda _cpl_system+SEED+2
    sta tmp
    jsr moonpos
    lda _PosY+1
    sec
    sbc tmp
    sta _PosY+1

    lda _cpl_system+SEED+3
    sta tmp
    jsr moonpos
    lda _PosZ+1
    sec
    sbc tmp
    sta _PosZ+1

    lda #<ONEMOON
    ldy #>ONEMOON
    jsr addmoonplanet


savpX 
    lda #0
    sta _PosX+1
savpY 
    lda #0
    sta _PosY+1
savpZ 
    lda #0
    sta _PosZ+1


    dec tmp1
    bne loop

moonsdone
    ; Create ships and others... for now, just testing
    ;jsr _InitTestCode
    rts


.)


planetpos
.(

    ; Now create the position of the planet (adapted from Elite TNK, but with small variations)
    lda #0
    sta _PosZ
    sta _PosX
    sta _PosY
    lda _cpl_system+SEED+1   
    and #%00110000
    clc
    adc #%00010000      ; result number between $10 and $40
    sta _PosZ+1
    lsr
    tax
    lda _cpl_system+SEED+1
    and #1
    beq noinvert
    txa
    eor #%11110000
    tax
noinvert
    stx _PosX+1
    stx _PosY+1
    rts
.)

addmoonplanet
.(

    ldx #<_PosX
    stx tmp0
    ldx #>_PosX   
    stx tmp0+1

    ldx #$80   ; Non-moving object
    jsr AddSpaceObjectDirect
    lda #255
    sta _energy,x    
    rts
.)

moonpos
.(
    lda tmp
    ldx tmp1
loop
    lsr
    lsr
    dex
    bne loop
    php
    and #%00000011
    clc
    adc #%00000001              ; Result between $1 and $4
    ;asl
    ;asl                     
    ;tax
    ;lda tmp
    plp
    ;and #1
    ;beq noinvert2
    bcc noinvert2
    ;txa
    eor #$ff
    ;tax
noinvert2    
    ;stx tmp
    sta tmp
    rts
.)


;;;;;;;;;;;;;;; TEST CODE
#ifdef 0
_InitTestCode 
.(
		rts	
         ; Add some ships

         lda #<OCEN
         sta tmp0
         lda #>OCEN
         sta tmp0+1   
         lda #SHIP_ADDER
		 ;lda #SHIP_ANACONDA
		 ;lda #SHIP_COUGAR
         jsr AddSpaceObject   
         stx savid+1   
         lda _ai_state,x
         ;ora #(IS_AICONTROLED | FLG_BOUNTYHUNTER)   
		 ;ora #(IS_AICONTROLED | FLG_POLICE)   
		 ora #(IS_AICONTROLED)   
         sta _ai_state,x

		 ;lda #2 ; Planet
		 ;sta _target,x
         ;lda _flags,x
		 ;ora #FLG_FLY_TO_PLANET
		 ;sta _flags,x
		
		 lda #(HAS_ESCAPEPOD)
		 jsr SetShipEquip

         lda #<OCEN2
         sta tmp0
         lda #>OCEN2
         sta tmp0+1   
         lda #SHIP_ASP
		 ;lda #SHIP_ANACONDA
		 ;lda #SHIP_COUGAR
         jsr AddSpaceObject   

        ; This one will pursue the other :)
savid   lda #0  ;SMC

        ; make it angry
        ora #IS_ANGRY
        sta _target,x        
        lda _ai_state,x
        ora #IS_AICONTROLED   
        sta _ai_state,x

  		 lda #(HAS_ESCAPEPOD)
		 jsr SetShipEquip


        ;ldx VOB
        ;sta _target,x

        rts
.)

#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Create random encounters
; Extracted and adapted from Elite TNK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;void random_encounter (void)

random_encounter
.(
		; If already too many objects, return
;		lda NUMOBJ
;		cmp #8
;		bcc cont1
;		rts
;cont1

;	if ((ship_count[SHIP_CORIOLIS] != 0) || (ship_count[SHIP_DODEC] != 0))
;		return;

		; If near the planet, then return
		lda _planet_dist
		cmp #10
		bcs cont
		rts
cont

;	if (rand255() == 136)
;	{
;		if (((int)(universe[0].location.z) & 0x3e) != 0)
;			create_thargoid ();
;		else
;			create_cougar();			
;
;		return;
;	}		

		; Create new random
		jsr _gen_rnd_number
		cmp #136
		bne nothargoid
		; Create thargoid or cougar and return
		; Thargoid is created if far from planet
		lda _planet_dist
		cmp #80
		bcs thargoid
		jmp create_cougar
thargoid
		jmp create_thargoid
nothargoid

;	if ((rand255() & 7) == 0)
;	{
;		create_trader();
;		return;
;	}

		lda _rnd_seed
		and #7
		bne notrader
		jmp create_trader
notrader

;	check_for_asteroids();
		jsr check_for_asteroids

;	check_for_cops();	
;	if (ship_count[SHIP_VIPER] != 0)
;		return;

		jsr check_for_cops
		lda police_counter
		beq nocops
		rts
nocops

;	if (in_battle)
;		return;

;	if ((cmdr.mission == 5) && (rand255() >= 200))
;		create_thargoid ();
		
;	check_for_others();	
		jmp check_for_others 

.)

create_cougar
.(
		lda #SHIP_COUGAR
		jsr create_other_ship
		cpx #0
		beq end	; Could not create ship

		lda #(IS_AICONTROLED)
		sta _ai_state,x
		jsr set_boldness

		lda #(HAS_ECM)	; Cloaking?
		jsr SetShipEquip

		jmp set_speed_and_target
	
end
		rts
.)





create_thargoid
.(
		; No more than 4 Thargoids, please
		lda thargoid_counter
		cmp #5			
		bcs end
		lda #SHIP_THARGOID
		jsr create_other_ship
		cpx #0
		beq end	; Could not create ship

		lda #1
		ora #IS_ANGRY ; set angry flag
		sta _target,x

		lda #(IS_AICONTROLED)
		sta _ai_state,x
		jsr set_boldness

		; Should add missiles (tharglets) here. Maybe depending on environment stats.
		lda _missiles,x
		ora #%10
		sta _missiles,x

		lda #(HAS_ECM)
		jsr SetShipEquip

		; note that there are thargoids on system
		inc thargoid_counter
end
		rts
.)


create_trader
.(
	
	; 	type = SHIP_COBRA3 + (rand255() & 3);
		jsr _gen_rnd_number
		and #3
		clc
		adc #SHIP_BOA
		jsr create_other_ship
		cpx #0
		beq end	; Could not create ship
		
;	if (newship != -1)
;	{
;		universe[newship].rotmat[2].z = -FRAC_ONE;
;		universe[newship].rotz = rand255() & 7;
;		
;		rnd = rand255();
;		universe[newship].velocity = (rnd & 31) | 16;
;		universe[newship].bravery = rnd / 2;
;
;		if (rnd & 1)
;			universe[newship].flags |= FLG_HAS_ECM;
;
;//		if (rnd & 2)
;//			universe[newship].flags |= FLG_ANGRY; 
;	}

		; Equip
		lda _rnd_seed+2
		lsr
		bcc noecm

		lda #HAS_ECM
		;and #%1111	; Limit possible equipment

		; Equip is random, but this includes advanced equipment
		; Maybe it is a good idea to limit, for instance, anti-radar.
		jsr SetShipEquip
noecm
		lda #FLG_INNOCENT
		sta _flags,x
		jmp set_speed_and_target
end
		rts
.)


set_speed_and_target
.(
		; Set destination and speed
		lda _rnd_seed+2
		bmi noptarget
		lda #2
		sta _target,x
		lda _flags,x
		ora #FLG_FLY_TO_PLANET
		sta _flags,x
		bne set_speed	; allways branches
noptarget
		lsr
		bcc set_speed
		; Set Hyper as target
		lda _flags,x
		ora #FLG_FLY_TO_HYPER
		sta _flags,x
+set_speed
		lda _rnd_seed+2
		and #%111
		ora #%100
		asl
		sta _speed,x
+set_orient
		; change its orientation
		jsr SetCurOb
		lda _rnd_seed
		ldx _rnd_seed+1
		ldy _rnd_seed+3
		jmp SetMat
		;BEWARE X is no more the object's id
.)


check_for_asteroids
.(
	;if ((rand255() >= 35) || (ship_count[SHIP_ASTEROID] >= 3))
	;	return;

		lda asteroid_counter
		cmp #3
		bcs end
		lda _rnd_seed+3
		cmp #35
		bcs end

	;if (rand255() > 253)
	;	type = SHIP_HERMIT;
	;else
	;	type = SHIP_ASTEROID;

;		lda _rnd_seed
;		cmp #254
;		bcs hermit
		lda #SHIP_ASTEROID
;		.byt $2c
;hermit
;		lda #SHIP_HERMIT

		jsr create_other_ship
		cpx #0
		beq end

		lda _ai_state,x
		and #%01111111 ;~(IS_AICONTROLED)  
		sta _ai_state,x

		inc asteroid_counter

		jmp set_speed
end
		rts

.)



check_for_cops
.(
	lda police_counter
	cmp #(MAXCOPS)
	beq end

	; Check 
	; if rnd and 7 >= _cpl_system+GOVTYPE
	; then rts

	; Send cops from planet
	; They should automatically target you if needed

	lda _rnd_seed+1
	and #7
	cmp _cpl_system+GOVTYPE
	bcs end

	ldx #2	; Planet
	jsr SetCurOb
    lda #SHIP_VIPER   ; Ship to launch
    jsr LaunchShipFromOther
    cpx #0
    beq end	; Couldn't create object

	; Note it down on cop list
	lda police_counter
	tay
	txa
	sta police_ids,y
	inc police_counter


	lda #IS_AICONTROLED|FLG_POLICE
    sta _ai_state,x
	jsr set_boldness
	lda #20
	sta _speed,x

	lda _rnd_seed+2
	bmi notarp
	lda #1
	sta _target,x

notarp
	lda #FLG_INNOCENT
	sta _flags,x
	jmp set_orient
end
	rts

.)

check_for_others
.(
	; Here goes everything else
	; Pirates, Bounties, shuttles...
	; Should be based on game internals and some randomizing

	lda #0
dbug beq dbug

	jsr _gen_rnd_number
	lda _rnd_seed+2
	cmp #190;90
	bcc doit
	rts
doit
	lda _cpl_system+GOVTYPE
	beq pirates
	sta tmp
	lda _rnd_seed
	and #7
	cmp tmp
	bcs nopirates

pirates
	; Generate pirates 
	jmp generate_pirate

nopirates
	and #%11
	bne shuttle
	; Gererate Bounty Hunter
	jmp generate_bounty

shuttle
	; Generate some junk	
	jmp generate_shuttle
.)


generate_pirate
.(
	lda #0
dbug beq dbug
	rts
.)
generate_bounty
.(
	lda #0
dbug beq dbug
	rts
.)

generate_shuttle
.(
	lda #0
dbug beq dbug
	rts
.)


; Create a ship of type passed in reg A
; Returns X with the new ship ID. Zero in X if error.
create_other_ship
.(
	pha
	; Get player's position
	ldx #1
	jsr GetShipPos

	; Generate new ship a bit far away
	lda _PosX+1
	eor #$17
	sta _PosX+1

	lda _PosY+1
	eor #$17
	sta _PosY+1

	lda _PosZ+1
	eor #$17
	sta _PosZ+1

	lda _rnd_seed+1
	bmi noinvertX
	sec
	lda #0
	sbc _PosX
	sta _PosX
	lda #0
	sbc _PosX+1
	sta _PosX+1
noinvertX

	lda _rnd_seed+2
	bmi noinvertY
	sec
	lda #0
	sbc _PosY
	sta _PosY
	lda #0
	sbc _PosY+1
	sta _PosY+1
noinvertY

	lda _rnd_seed+2
	bmi noinvertZ
	sec
	lda #0
	sbc _PosZ
	sta _PosZ
	lda #0
	sbc _PosZ+1
	sta _PosZ+1
noinvertZ


    lda #<_PosX
    sta tmp0
    lda #>_PosX+1   
    sta tmp0+1
    pla
    jsr AddSpaceObject

    lda #(IS_AICONTROLED)   
    sta _ai_state,x
	rts	
.)

set_boldness
.(
	lda _score+1
	cmp #02
	bcc end

	; We are really dangerous, so make enemies bold
	lda _ai_state,x
	ora #FLG_BOLD
	sta _ai_state,x
end
	rts
.)


