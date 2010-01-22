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
	; Initialize variables
	lda #0
	sta thargoid_counter
	sta police_counter
	sta asteroid_counter
	sta worm_counter
	sta missile_counter

	sta _ecm_counter
	sta message_delay

    ;jsr _InitTestCode

	; Create initial encounters
	; Encounters are not created if too close to planet, so 
	; set_planet_distance should be called afterwards...
	lda #$ff
	sta _planet_dist

	ldx #3
	stx count ; Hope it is not used here
loopen
	jsr random_encounter
	dec count
	bpl loopen

	jmp set_planet_distance

	;rts
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
    adc #$5      ; result number between $5 and $35
    sta _PosZ+1
	lsr
    tax
    lda _cpl_system+SEED+1
    ;and #1
	;beq noinvert
	bcc noinvert
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
		lda NUMOBJS
		cmp #10;12
		bcc cont1
		rts
cont1

;	if ((ship_count[SHIP_CORIOLIS] != 0) || (ship_count[SHIP_DODEC] != 0))
;		return;

		; If near the planet, then return
		lda _planet_dist
		cmp #PDIST_DOCK
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

		lda _rnd_seed+3
		and #3
		bne notrader
	; Change this so more traders on secure systems
	;	and #7
	;	cmp _cpl_system+GOVTYPE
	;	bcs notrader
		jmp create_trader
notrader

;	check_for_asteroids();
		jsr check_for_asteroids

;	check_for_cops();	
;	if (ship_count[SHIP_VIPER] != 0)
;		return;

		jsr check_for_cops
/*
		lda police_counter
		beq nocops
		rts
nocops
*/

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
		ldx _rnd_seed+3
		bpl nocloack
		ora #SHIP_NORADAR
nocloack
		jsr create_other_ship
		cpx #0
		beq end	; Could not create ship

		lda #(HAS_ECM)	; Cloaking?
		jsr SetShipEquip

		lda #(IS_AICONTROLED)
		sta _ai_state,x
		jsr set_boldness

		jmp set_speed_and_target
	
end
		rts
.)





create_thargoid
.(
		; No more than MAXTHARG Thargoids, please
		lda thargoid_counter
		cmp #(MAXTHARG)			
		bcs end
		lda #SHIP_THARGOID
		jsr create_other_ship
		cpx #0
		beq end	; Could not create ship

		lda #1
		ora #IS_ANGRY ; set angry flag
		sta _target,x

		
		lda #(HAS_ECM)
		jsr SetShipEquip

		lda #(IS_AICONTROLED|FLG_PIRATE)
		sta _ai_state,x
		jsr set_boldness

		; Should add missiles (tharglets) here. Maybe depending on environment stats.
		;lda _missiles,x
		;ora #%10
		stx savx+1
		jsr _gen_rnd_number
		and #%11
savx	ldx #0 ;SMC
		sta _missiles,x

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
		
		lda _ai_state,x
		ora #FLG_TRADER
		sta _ai_state,x

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
		jsr _gen_rnd_number
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

		inc asteroid_counter

		lda _ai_state,x
		and #%01111111 ;~(IS_AICONTROLED)  
		sta _ai_state,x

		; Make it rotate
		lda #3
		sta _rotz,x
	
		;Set speed and random orientation
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

	jsr _gen_rnd_number
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

	jsr _gen_rnd_number
	;lda _rnd_seed+2
	cmp #90
	bcc doit
	rts
doit
	;lda _rnd_seed
	and #7
	sta tmp
	lda _cpl_system+GOVTYPE
	cmp tmp
	bcs nopirates ; govtype >= rnd &7  then no pirates

pirates
	; Generate pirates 
	jmp generate_pirate

nopirates
	lda _rnd_seed
	bmi shuttle
	; Gererate Bounty Hunter
	jmp generate_bounty

shuttle
	; Generate some junk	
	jmp generate_shuttle
.)


generate_pirate
.(
	jsr gen_ship_type
	clc
	adc #SHIP_BOA
	jsr generate_pirate_bounty		
	cpx #0
	bne cont
	rts
cont
	; Flag as pirate
	lda _ai_state,x
	ora #FLG_PIRATE
	sta _ai_state,x

	; Assign target
	stx savx+1
	ldx NUMOBJS
	dex
loop
	cpx savx+1
	beq next
	lda _ai_state,x
	and #%01111111
	sta tmp+1
	lda _rnd_seed+1
	ora _rnd_seed+2
	;ora _rnd_seed+3
	and tmp+1
	bne chosen
next
	dex
	bne loop
	; Nothing chosen, track the player
	ldx #1
chosen
	txa
savx 
	ldx #0 ; SMC
	ora #IS_AICONTROLED
	sta _target,x

	jmp set_boldness
.)

generate_bounty
.(
	jsr gen_ship_type
	lsr
	clc
	adc #SHIP_MORAY
	jsr generate_pirate_bounty		
	cpx #0
	bne cont
	rts

cont
	; Flag as Bounty
	lda _ai_state,x
	ora #FLG_BOUNTYHUNTER
	sta _ai_state,x

	jmp set_boldness
.)


generate_pirate_bounty
.(
	sta shiptype+1
	; Set cloacking device
	tax
	lda _galaxynum
	cmp #1
	beq nocloack
	lda _rnd_seed+3
	and #%1111
	bne nocloack
	txa
	ora #SHIP_NORADAR	; Not visible
	tax
nocloack
	txa
	jsr create_other_ship
	cpx #0
	beq end

	; See if it is to be flagged as slow
shiptype
	lda #0 ; SMC
	cmp #SHIP_ANACONDA
	beq slowme
	cmp #SHIP_WORM
	bne noslow
slowme
	lda _ai_state,x
	ora #FLG_SLOW
	sta _ai_state,x
noslow
	jmp gen_ship_equipment	
end
	rts
.)


gen_ship_type
.(
	jsr _gen_rnd_number
	and #%1111			; a=0..15	
	tax
	lda _score
	bne l1
	dex
	lda _score+1
	cmp #80
	bcc l1
	dex
	dex
l1						; a=0..15 - 0..3
	lda _galaxynum
	cmp #1
	bne l2
	dex
	dex
l2						; a=0..15 - 0..3 - 0..2
	txa
	bpl correct
	lda #0
correct
	cmp #11
	bcc correct2
	lda #10
correct2
	rts
.)

eq_tmp .byt 0

gen_ship_equipment
.(
	lda #0
	sta eq_tmp

	; Must preserve reg X!!!
	stx savx+1

	; What is to be added here? Maybe ECM
	lda _score+1
	bne nocheckscore
    lda _score
    cmp _rnd_seed+2
	bcc noecm
nocheckscore
	lda _rnd_seed+3
	;bpl noecm
	and #%11
	bne noecm
	lda #(HAS_ECM)	; Cloaking?
	sta eq_tmp
noecm
	; And escape pod
	lda _rnd_seed+1
	bpl nopod
	lda eq_tmp
	ora #(HAS_ESCAPEPOD)
	sta eq_tmp
nopod

	; Equip with selected items
	lda eq_tmp
    jsr SetShipEquip
savx
	ldx #0 ; SMC
	rts
.)

generate_shuttle
.(
    lda _rnd_seed+3
	and #%1
	clc
	adc #SHIP_SHUTTLE   ; Ship to launch
	sta tmp
	
    lda _rnd_seed
    bmi from_planet
to_planet
	lda tmp
	jsr create_other_ship
	lda #2
	sta _target,x
	lda _flags,x
	ora #FLG_FLY_TO_PLANET|FLG_INNOCENT
	sta _flags,x
	bne finish ; allways branches
from_planet
	ldx #2	; Planet
	jsr SetCurOb
	lda tmp
    jsr LaunchShipFromOther
    cpx #0
    beq end	; Couldn't create object

	lda _flags,x
	ora #FLG_FLY_TO_HYPER|FLG_INNOCENT
	sta _flags,x	

finish
	lda #IS_AICONTROLED|FLG_DEFENCELESS|FLG_SLOW
    sta _ai_state,x
end
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
	eor #%1111; $17
	sta _PosX+1

	lda _PosY+1
	eor #%1111;$17
	sta _PosY+1

	lda _PosZ+1
	eor #%1111;$17
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

	; Set number of missiles
	stx savx+1
	jsr _gen_rnd_number
	ora #%11111000
savx
	ldx #0 ;SMC
	and _missiles,x
	sta _missiles,x

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


