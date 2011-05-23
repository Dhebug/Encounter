
#include "main.h"
#include "tine.h"
#include "cockpit.h"


#define SHUTTLE_CHANCE      $fc
#define VIPER_CHANCE        $ef
#define ANACONDA_CHANCE     $c7
#define BREAK_CHANCE        $f9
#define ESCAPE_POD_CHANCE   $e5
#define FIRING_DISTANCE     $e000
#define ECM_CHANCE          $10
#define HERMIT_CHANCE       $fc

#define CHECK_VALID_TYPES

;; Function table for ships that are
;; hyperspacing, docking, exploding or disappearing...
;; Flags IS_whatever in tine.h

dis_tab_lo .byt <(ExplodeObject), <(DisappearObject), <(HyperObject), <(DockObject)
dis_tab_hi .byt >(ExplodeObject), >(DisappearObject), >(HyperObject), >(DockObject)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tactics function
;; Implements the control loop
;; Calls AIMain for objects when necessary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_Tactics
.(

    ldx #0  ; Player is affected by flags and can be affected by tactics (autopilot).
    jsr SetCurOb

    jsr GetNextOb
    cpx #0
    beq end

loop
    sta POINT        ;Object pointer
    sty POINT+1

    lda #( IS_HYPERSPACING | IS_DOCKING | IS_EXPLODING | IS_DISAPPEARING )
    and _flags,x
    beq noflags

    tay
    lda _ttl,x
    beq do_special
    dec _ttl,x
    jmp noflags

do_special
	; Get pointer to routine
	
	tya
	ldy #$ff
loopi
	iny
	lsr
	bcc loopi

    ; Call routine for each flag kind...

    lda dis_tab_lo,y
    sta _smc_jump+1
    lda dis_tab_hi,y
    sta _smc_jump+2
_smc_jump
    jsr $1234   ; SMC

    jmp nomove


noflags    
    lda _ai_state,x
    and #IS_AICONTROLED
    beq noai
    
    ldy #ObjID
    lda (POINT),y
    and #%01111111
    cmp #SHIP_MISSILE
    beq doai

    ;if (i^g_mcount)&7==0  

    txa
    eor frame_number
    and #7
    bne noai    
doai
    jsr AIMain
noai

nomove
    jsr GetNextOb
    cpx #0
    bne loop
end
    rts


.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AIMain function
; Implements the genera AI for objects
; which have the flag AI_CONTROLLED set
; in _ai_state flag.
; Corresponds to tactics() in tactics.c in
; Elite AGB
; Parameters Reg X contains ship ID
; for which we are running the AI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


AIMain
.(
	; Save some variables for later access

    stx AIShipID
    lda _target,x
    sta AIIsAngry
    and #%01111111
    sta AITarget
    jsr GetShipType
    sta AIShipType

	; Are we dealing with a missile?

    cmp #SHIP_MISSILE
    ;bne nomissile
	beq missile
	jmp nomissile
missile
    
    ; It is a missile. If the target is 0 then there is no target
    ; so should do nothing or explode? OR should this never happen? 

    lda _ecm_counter
    beq noecm

    ; make missile explode
    ;ldx AIShipID
    lda _flags,x
    and #%11110000  ; Remove older flags...
    ora #IS_EXPLODING
    sta _flags,x
	lda #0
	sta _ttl,x
    rts
noecm

    ; Get vector to target

    lda AITarget
    bne cont1
    rts
cont1
    tax
 
    jsr substract_positions

    ;if ( (abs(x)< 256) && (abs(y) < 256) && abs(z) < 256) {
    ldy #4
loop
    lda _VectX,y
    sta op1
    lda _VectX+1,y
    sta op1+1
    jsr abs
    
    lda op1+1
    bne nohit
; The original is <256, so this is all
    lda op1
    cmp #100
    bcs nohit
    dey
    dey
    bpl loop
 
    ; Missile hit!!!
 
    
    ; Missile explodes

    ldx AIShipID
    lda _flags,x
    and #%11110000  ; Remove older flags...
    ora #IS_EXPLODING
    sta _flags,x
    lda #0
    sta _ttl,x
    lda #0
    sta _speed,x
    sta _accel,x

    ; Make ship angry at who fired the missile

    lda _missiles,x
    tax
	stx savy+1	; Save it for later
    lda AITarget
    jsr make_angry 
 
    ;Perform damage

    ldx AITarget
    lda _speed,x
    lsr
    sta _speed,x
    lda #0
    sta _accel,x
    lda #MISSILE_DAMAGE
savy
	ldy #0	;SMC
	sec ; A missile
    jmp damage_ship ; This is JSR/RTS

nohit
	; See if ecm is already active
	lda _ecm_counter
	bne noacecm

	; See chance
	jsr _gen_rnd_number
	cmp #ECM_CHANCE
	bcs noacecm; if >= ECM_CHANCE, then don't

	; Check it is not the player
	ldx AITarget
	cpx #1 ; player
	beq noacecm

	; See if ECM equipped
	jsr GetShipEquip
	and #(HAS_ECM)
	beq noacecm
	; Target has ECM system, will he activate it?
	jmp SetECMOn

noacecm
    jmp approach

nomissile
 
   ;; It was NOT a missile, but another kind of ship

    ; Update energy
	ldy AIShipType
	lda ShipEnergy-1,y
	cmp _energy,x
	beq maxen
	inc _energy,x
maxen

    ; If it is a THARGON and there are no THARGOIDS
    ; halve speed and set ai_state=0 and rts
	lda AIShipType
	cmp #SHIP_THARGLET
	bne nothargon
	lda thargoid_counter
	bne nothargon
	lsr _speed,x
	lda #0
	sta _ai_state,x
	rts
nothargon
	; If it is a Hermit (?) and rand>200 launch a Sidewinder+rand&3 angry
	; at us and with ECM and leave Hermit inactive
    
    ; Get a random number

    jsr _gen_rnd_number
	ldx AIShipID	; Get back X with ship ID, as it was destroyed by gen_rnd_number

	; If it is police and legal_status>=64 make it angry at us. Why not simplify this and check the same
	; for Bounty Hunters and police? See below...

	; If it is slow and rand > 50 rts

	lda _ai_state,x
	and #FLG_SLOW 
	beq notslow
	lda _rnd_seed+1
	cmp #50*2
	;bcc notslow ; This is UNSIGNED comparision!
	bmi notslow
	rts
notslow
    ; If FLG_TRADER and r1>100 rts
	lda _ai_state,x
	and #FLG_TRADER
	beq notrader
	lda _rnd_seed+1
	cmp #100
	bcc approach	; if <100 continue and no rts
	rts
notrader

    ; If FLG_BOUNTYHUNTER and our legal status >=40 set angry flag and target us (=1)
	lda _ai_state,x
	and #(FLG_BOUNTYHUNTER|FLG_POLICE)
	beq nobounty

	; If already targetting someone and angry, keep it
	;lda AITarget
	lda _target,x
	and #IS_ANGRY
	bne approach

	ldy _legal_status
	; Add value for carrying contraband
	lda _shipshold+3	; Slaves
	ora _shipshold+6	; Narcotics
	ora _shipshold+10	; Firearms
	beq nocontraband
	lda _rnd_seed+3
	and #%111111
	tay
nocontraband
	cpy #40
	bcc approach ; if <40 continue and don't target us
	lda #(1|IS_ANGRY)
	sta _target,x
	lda #1
	sta AITarget
nobounty

    ; If FLG_PIRATE and planet nearby or police and r1>100 , 
	; remove angry status and target hyperspace point 
	; If FLG_BOLD keep on trying!
	lda _ai_state,x
	and #(FLG_BOLD)
	bne approach

	lda _ai_state,x
	and #(FLG_PIRATE)
	beq approach
	lda _planet_dist
	cmp #PDIST_DOCK
	bcc flee
	lda police_counter
	beq approach
	stx savx+1
	jsr _gen_rnd_number
	cmp #100
	bcs approach
savx
	ldx #0	;SMC
flee
	lda #0
	sta _target,x
	lda _flags,x
	ora #FLG_FLY_TO_HYPER
	sta _flags,x
	;rts
	jmp fly_to_zero

approach

    ; If a moving ship has a target, make her go
    ; for it!
    
    lda AITarget
    beq notarget
    tax
    jmp fly_to_ship    
notarget
	lda _flags,x
	and #FLG_FLY_TO_HYPER 
	beq end
	; Wants to go hyper
	jmp fly_to_zero
end
    rts

.)


; Hack to make a ship travel to position 0,0,0
fly_to_zero
.(
	lda #0
	ldy #5
loop
	sta _VectX,y
	dey
	bpl loop
	jsr substract_positions2
	jmp fly_to_ship2
.)


;; fly_to_ship
;; Makes current object fly towards a given ship
;; passed in reg X
fly_to_ship
.(

    ; Get the vector towards the target
    jsr substract_positions
    
+fly_to_ship2
	; Need to save some data for later on... 
    jsr getnorm
    lda op1
    sta A1
    lda op1+1
    sta A1+1
    
    ldy #5
loop
    lda _VectX,y
    sta oX,y
    dey
    bpl loop
    

    ; Calculate attack angle
    jsr get_attack_angle


    ; if it is a missile, just fly towards it
    lda AIShipType
    cmp #SHIP_MISSILE
    ;beq approach
    bne cont
    jmp approach
cont
    ; Randomly roll a bit to throw away anyone tracking me
    lda _rnd_seed
    cmp #BREAK_CHANCE
    bcc noroll
    ora #$68    ; doesn't $68 seem too high?
    ldx AIShipID
    sta _rotx,x    
noroll

    ; If we are not angry we don't want to shoot.
    lda AIIsAngry
    and #IS_ANGRY
    bne areangry
    jmp toofar
areangry    

	lda AIShipType
	cmp #SHIP_HERMIT
	bne nothermit

	ldx AIShipID
	lda #0
	sta _target,x

	; Not many ships around
	lda NUMOBJS
	cmp #10
	bcs nothermit

	; Launch Sidewinder+rand&3

	lda hermit_counter
	bne nothermit

	inc hermit_counter

	ldx AIShipID
	jsr SetCurOb
	lda _rnd_seed+2
	and #%11
	clc
	adc #SHIP_SIDEWINDER

    jsr LaunchShipFromOther
    cpx #0
    beq nothermit	; Couldn't create object

	lda #(HAS_ECM)	
	jsr SetShipEquip

    lda #(IS_AICONTROLED|FLG_BOLD)
    sta _ai_state,x
        
    ; Get objective
    lda AITarget  
	ora #IS_ANGRY
    sta _target,x 
	rts

nothermit
/*	Actually this creates too many ships in the same place :(
    ; if it is an Anaconda it may launch worms.
	; As _gen_rnd_number has already
    ; been called, just use _rnd_seed (+1,+2,+3)

	lda AIShipType
	cmp #SHIP_ANACONDA
	bne notanaconda
	lda _rnd_seed
	cmp #200
	bcc notanaconda

	; No more than 2 worms
	lda worm_counter
	cmp #3
	bcs notanaconda

	; Not many ships around
	lda NUMOBJS
	cmp #10
	bcs notanaconda

	; Launch WORM
	ldx AIShipID
	jsr SetCurOb
	lda #SHIP_WORM
    jsr LaunchShipFromOther
    cpx #0
    beq notanaconda	; Couldn't create object
    lda #(IS_AICONTROLED|FLG_BOLD) ;|FLG_SLOW)
    sta _ai_state,x
        
    ; Get objective
    lda AITarget  
	ora #IS_ANGRY
    sta _target,x 
	inc worm_counter
	rts

notanaconda
*/

	; If BOLD he might want to launch a missile
	ldx AIShipID
	lda _ai_state,x
	and #FLG_BOLD
	beq nobold
	lda _rnd_seed+1
	cmp #10 ;64
	bcc nocriten	; Launch a missile if possible
nobold

    ; Check ship's energy. If it is max/2
    ; check if also less than max/8
    ; if it is
    ; launch escape pod, if possible and rts
    ; if only less than max/2 launch missile and rts

    ldx AIShipType
    lda ShipEnergy-1,x
    lsr
    ldx AIShipID
    cmp _energy,x
    bcs continue
	jmp nolowen  
continue
    lsr
    lsr
    cmp _energy,x
    bcc nocriten
    ; Launch escape pod if fitted 
	jsr GetShipEquip
	and #(HAS_ESCAPEPOD)
	beq nocriten

	; fitted, launch it and leave ship without management
	lda _speed,x
	lsr
	sta _speed,x
	lda #$fd ; -3
	sta _accel,x
	lda #0
	sta _ai_state,x

	lda #SHIP_ESCAPE
	jsr LaunchShipFromOther
	cpx #0
	bne noerror
	;;;; Could not create Escape POD!!
	rts
noerror
	lda #2	; Planet
	sta _target,x
	lda #(FLG_FLY_TO_PLANET|FLG_INNOCENT)
	sta _flags,x
	lda #(IS_AICONTROLED|FLG_DEFENCELESS)
	sta _ai_state,x
	lda #5
	sta _speed,x
	rts
nocriten

    ; Can we launch a missile?
	; If ECM active, dont'
	lda _ecm_counter
	bne nolowen
	
	; Do we have missiles left?
    lda _missiles,x
    and #%00000111
    beq nolowen

    ; Launch missile

	; If it is a Thargoid, launch a Targlet (FLG_BOLD set)
	lda AIShipType
	cmp #SHIP_THARGOID
	bne domissile
	jsr SetCurOb
    lda #SHIP_THARGLET   ; Ship to launch
    jsr LaunchShipFromOther
    cpx #0
    beq nolowen	; Couldn't create object
    lda #(IS_AICONTROLED|FLG_BOLD|FLG_SLOW);
    sta _ai_state,x
        
    ; Get objective
    lda AITarget  
	ora #IS_ANGRY
    sta _target,x 

	/*
    ; Push it a bit
    jsr SetCurOb
    lda #20
    jsr MoveForwards
    lda #20
    jsr MoveSide*/

    ldx AIShipID 
	dec _missiles,x
	rts	
domissile
	; No more than MAX_MISSILES missiles
	lda missile_counter
	cmp #(MAX_MISSILES+1)
	bcs nolowen

    jsr SetCurOb
    jsr LaunchMissile   
    beq nolowen ; Could not fire missile
    ldx AIShipID
    dec _missiles,x
	rts
nolowen

    ; If we arrive here energy is still high or we didn't
    ; want to or couldn't launch missile or escape pod
    ; Try to shoot at target
    
    ; Check distance... as A=abs(x)|abs(y)|abs(z)..
    ; Now precalculated in A1

    ; Check if greater (or equal) than $2000 (maximum firing -and visibile- distance)
    
	
	; we can do this with an and over $e000 (the inverse of $1fff), and check for zero.
    ;lda A1+1
    ;and #>FIRING_DISTANCE
    ;bne toofar  

	; Seems the $2000 is too much... try with someting smaller.
	;lda A1
    ;cmp #00
    lda A1+1
    sbc #$15       ;Greater than $2000?
    bcs toofar     

    ; Check if laser is fitted... check FLAG_DEFENCELESS?
    ; if none goto toofar
	
	ldx AIShipID
	lda _ai_state,x
	and #FLG_DEFENCELESS
	bne toofar
    
    ; We can shoot, so let's do it
    
    ; Check the attack angle (our_ang0)
    ; According to Elite-AGB if greater than $2000 fire, if greater than $2300 fire and hit.
    ; Scaling down approprately $2000 is 0.888 times the max value ($2400). The 88 percent of
    ; our max value ($1000) is $e38. $2300 is equivalent to $f8e.
+debugme
    lda our_ang0
    sta op1
    lda our_ang0+1
    sta op1+1
 
    lda #<3200		;$e38-550; $f1c8 ;$e38
    sta op2
    lda #>3200		;$e38-550; ;$e38
    sta op2+1
    jsr cmp16
    bmi toofar

 
    ; We fire! 
    ldx _numlasers
    cpx #3
    beq toofar  ; Too many lasers at the same time!

    lda AIShipID
    sta _laser_source,x

    lda AITarget
    sta _laser_target,x
    inc _numlasers
 
	jsr SndShoot

    ; Make ship angry at who shoots

    ldx AIShipID
    lda AITarget
    jsr make_angry

   
    ; Do we hit or miss?
    lda #<3250		;$f8e-500	;-500);f07d ;$f8e
    sta op2
    lda #>3250			;$f8e-500	;-500);f07d ;$f8e
    sta op2+1
    jsr cmp16
    bmi toofar


    ; We hit!
	ldx AIShipID
    dec _accel,x

    lda _missiles,x
	; bits 7-3 = Lasers, 0-2 # missiles
    lsr
    lsr
	lsr
	;lsr	; do laser damage/2 (according to elite agb)
    ldx AITarget

	ldy AIShipID
	clc ; Not a missile
    jmp damage_ship ; This is jsr/rts
    
     
toofar    
    ; Target far away,
    ; or not angry,
    ; or angle of attack too great,
    ; or fired and missed
    ; or no laser fitted
    ; fly about "randomly"

    ; First see if we are on a collision course
    
    ; if z>$500 no problem

    lda oZ+1
    bpl notneg0
    sec
    lda #0
    sbc oZ+1
notneg0
    cmp #5
    bcs approach 

    ; it is less than $500, so check X and Y
    ; if (abs(x)|abs(y)) & $fe00 then not on collision
    ; it is enough to check the high bytes...

    lda oX+1
    bpl notneg1
    sec
    lda #0
    sbc oX+1
notneg1    
    sta tmp    

    lda oY+1
    bpl notneg2
    sec
    lda #0
    sbc oY+1
notneg2
    ora tmp    
    and #$fe	; Change from fe to fc to avoid occasional collisions. But combat suffers...
    bne approach

    ; What if our target is a planet? Then if want to dock, dock

	ldx AIShipID
	lda _flags,x
	and #FLG_FLY_TO_PLANET
	beq nodock

	; Dock to planet
	lda #IS_DOCKING
	ora _flags,x
	sta _flags,x
	rts
	
nodock
	; If we wants to go hyper, go hyper
	lda _flags,x
	and #FLG_FLY_TO_HYPER 
	beq nohyper

	; Check if conditions are met (no other hypers, no interdictors...)
	lda ship_to_hyper
	bne nohyper

	; Go Hyper
	lda #IS_HYPERSPACING
	ora _flags,x
	sta _flags,x

	lda #3
	sta _ttl,x
	stx ship_to_hyper

	rts
nohyper    
	; On collision course, invert everything

	ldx #4
loopinv
    lda #0
    sec
    sbc _VectX,x
    sta _VectX,x
    lda #0
    sbc _VectX+1,x
    sta _VectX+1,x
	dex
	dex
	bpl loopinv

    lda #0
    sec
    sbc our_ang0
    sta our_ang0
    lda #0
    sbc our_ang0+1
    sta our_ang0+1

 
    
approach
    ;jmp fly_to_vector_final
	jmp fly_to_vector

.)


substract_positions
.(
    jsr GetObj
    jsr GetShipPos
    ldy #5
loop
    lda _PosX,y
    sta _VectX,y
    dey
    bpl loop

+substract_positions2
    jsr GetCurOb
    jsr GetShipPos

    ; Substract both positions
    ; and store in _VectX,Y,Z
    lda _VectX
    sec
    sbc _PosX
    sta _VectX
    lda _VectX+1
    sbc _PosX+1
    sta _VectX+1

    lda _VectY
    sec
    sbc _PosY
    sta _VectY
    lda _VectY+1
    sbc _PosY+1
    sta _VectY+1

    lda _VectZ
    sec
    sbc _PosZ
    sta _VectZ
    lda _VectZ+1
    sbc _PosZ+1
    sta _VectZ+1

    rts
.)



FireLaser
.(
	lda LaserTemperature
	cmp #9
	beq nohit

    jsr SndShoot

	inc LaserTemperature
	jsr update_temperature_panel

	;Patch main loop code so it draws laser
	lda #$20	; jsr opcode
	sta _patch_laser_fired
	lda #<_DrawLaser
	sta _patch_laser_fired+1
	lda #>_DrawLaser
	sta _patch_laser_fired+2


    ; Check to see if we hit
    jsr FindTarget
    ldx _ID
    beq nohit

 	lda _p_laserdamage
	;lsr	; do laser damage/2 (according to elite agb)

	ldy #1	; Player does damage
	clc	; It is not a missile
    jsr damage_ship
    
    ; Make him angry at us
    ldx #1  ; Player
    lda _ID
    jsr make_angry

nohit
    rts
.)


FindTarget
.(
    lda #$0
    sta _ID


    ; Iterate through visible object list 
    ; Initialize list for iterating ?
    ldy #$80
    sty COB
    jsr GetNextVis
    bmi end
loop
	;cpy #0
	beq next	; Object has just been deleted, but CalcVis has not been called.
    sta POINT
    sty POINT+1
	
    ldy #ObjID
    lda (POINT),y
    ; Remove flags to get Object's type
    and #%01111111
    beq next ; Suns and planets...
  
    asl
    tax
    lda ShipSize-2,x
    sta op2
    lda ShipSize-1,x
    sta op2+1
 
    ldy #ObjCenPos
    lda (POINT),y
    tax
    
    lda HCX,x
    sta op1+1
    lda CX,x
    sta op1
    jsr abs

    lda op1+1
    bne next
    lda op1
    sta uno+1

    lda HCY,x
    sta op1+1
    lda CY,x
    sta op1
    jsr abs    

    lda op1+1
    bne next
    lda op1
    sta dos+1


    lda #0
    sta op1
    sta op1+1

uno
    lda #0
    jsr do_square_nosign
dos
    lda #0
    jsr do_square_nosign
    bcs next ; Overflow occured.
   
    jsr cmp16
    bcs next

    ; Should save ID to get the last one, after iterating...
    jsr GetCurOb
    stx _ID
    
next
    jsr GetNextVis
    bpl loop

end
    rts
.)

_ID .byt $0


;; LaunchMissile
;; Current ship
;; launches a missile
LaunchMissile
.(
    stx savx+1
    lda #SHIP_MISSILE   ; Ship to launch
    jsr LaunchShipFromOther
    cpx #0
    beq failure

	inc missile_counter

    lda #4;11
    sta _accel,x
    ;lda #3
    ;sta _rotz,x
    lda #40
    sta _speed,x       

    ; Set ai_controlled
    lda _ai_state,x
    ora #IS_AICONTROLED 
    sta _ai_state,x
        
    ; Get objective
    lda AITarget  
	ora #$80
    sta _target,x 

	; If we are the objective, set inflight message
	cmp #$81
	bne notus
	stx savx2+1
	ldx #STR_INCOMING_MISSILE
	jsr flight_message 

	; If not in front view, alert player
	lda _current_screen
	cmp #SCR_FRONT
	beq savx2
    ldx #2
	jsr alarm
savx2
	ldx #0	; SMC
notus
    ; Set who is launching at _missiles field
savx
    lda #0  ;SMC
    sta _missiles,x

    ; Make it disappear soon
    lda #(IS_EXPLODING) ;IS_DISAPPEARING )
    ora _flags,x
    sta _flags,x

    lda #255    
    sta _ttl,x

    ; Push it a bit
    jsr SetCurOb
    lda #20;100
    jsr MoveForwards
    lda #20;50
    jsr MoveSide;Down
    lda #1 ; So we dont return with zero
failure
    rts

.)



HyperObject
#ifdef HAVE_MISSIONS
.(
	stx savx+1
	jsr OnHyperShip
	bcc nothing
	jsr print_mission_message
nothing
	lda #0
	sta ship_to_hyper
savx
	ldx #0 ;SMC
	jmp RemoveObject
.)
#endif
DockObject
#ifdef HAVE_MISSIONS
.(
	stx nothing+1
	jsr OnDockedShip
	bcc nothing
	jsr print_mission_message
nothing
	ldx #0 ;SMC
	jmp RemoveObject
.)
#endif
DisappearObject
.(
    jmp RemoveObject
.)




ExplodeObject
.(
    stx _ID
    jsr SndExplosion
	lda #A_FWRED
	jsr set_ink

    jsr _gen_rnd_number
    ldx _ID

    ; Generate some debris
	lda #7
    sta tmp3
loop
    jsr SetCurOb

    lda #(SHIP_DEBRIS|SHIP_NORADAR)
    jsr CreatePart
    
    ldx _ID
    dec tmp3
    bne loop

    ; Now some loot, if exploding
    ; object is a ship
    jsr GetShipType
    and #%01111111 

	; What if it is an asteroid????
	cmp #SHIP_ASTEROID
	bne noasteroid
	lda #SHIP_BOULDER
	jsr ReleaseRandom
	jmp nomore
noasteroid

	cmp #SHIP_BOULDER
	bne noboulder
	lda #SHIP_SPLINTER
	jsr ReleaseRandom
	jmp nomore
noboulder

	; if it is space junk nothing more...
    cmp #SHIP_VIPER
    bcc nomore  

	lda #SHIP_ALLOY
	jsr ReleaseRandom
	lda #SHIP_CARGO
	jsr ReleaseRandom

nomore

	ldx _ID
	cpx #1	; Is it the player's ship?
	bne noplayer
	dec game_over
noplayer
	jsr SetCurOb	; Without this destroying player's ship does NOT work!!!

#ifdef HAVE_MISSIONS
.(
	ldx _ID
	stx nothing+1
	jsr OnExplodeShip
	bcc nothing
	jsr print_mission_message
nothing
	ldx #0 ;SMC
.)
#endif
    jmp RemoveObject
.)


; Release random loot
; Pass a=type, _ID=parent's id 

ReleaseRandom
.(
	cpx #1
	beq ReleaseRandomPlayer
    sta type+1	
	jsr _gen_rnd_number
	ldx _ID
	lda type+1	; Get back type
	cmp #SHIP_CARGO
	beq cargo
	lda _rnd_seed+1
	and #%11
	jmp relloop
cargo	
    jsr GetShipType
    and #%01111111   
	tax
	lda ShipCargo-1,x
	beq nomore
    lda _rnd_seed+1
	and #%1
relloop
	beq nomore
    sta tmp3
	ldx _ID
loop2
    jsr SetCurOb
type
    lda #0	;SMC
    jsr CreatePart
    
    ldx _ID
    dec tmp3
	dec tmp3
	bpl loop2
    ;bne loop2

nomore
	rts
.)


ReleaseRandomPlayer
.(
	sta type+1
	cmp #SHIP_CARGO
	beq cargo
	lda #%10
	jmp relloop
cargo	
    lda #%11
relloop
	beq nomore
    sta tmp3
	ldx _ID
loop2
    jsr SetCurOb
type
    lda #0	;SMC
    jsr CreatePart
    
    ldx _ID
    dec tmp3
    bne loop2
nomore
	rts
.)


CreatePart
.(
    sta savA+1
    jsr LaunchShipFromOther
    cpx #0
    bne nofailure
    rts
nofailure
    lda #$ff ;d ; -3
    sta _accel,x
    lda #20
    sta _speed,x
    lda #3
    sta _rotz,x


    ; Make it disappear soon
    lda #IS_DISAPPEARING
    ora _flags,x
    sta _flags,x
	lda #255
	sta _ttl,x
savA
    lda #0  ;SMC
    and #%01111111  ; Remove flag
    cmp #SHIP_DEBRIS
    bne nodeb

    lda _rnd_seed
    and #%00000111
    ora #%00000100
	sta _ttl,x
nodeb
    jsr SetCurOb

    jsr _gen_rnd_number
    ldy _rnd_seed+2
    lda _rnd_seed+1
    ldx _rnd_seed
    jsr SetMat
   
    lda #5
    jmp MoveForwards ; This is JSR/RTS

.)



;; Remove the object in reg X

RemoveObject
.(

    ; Update targets for all the active ships, so 
    ; they no more have this ID as target
    ; Then remove object

    stx _ID

    ldx #0  ; Player is affected by flags and can be affected by tactics (autopilot).
    jsr SetCurOb

    jsr GetNextOb
    cpx #0
    beq end
    ;bcs end

loop
    lda _target,x
    and #%01111111  ; Remove angry flag
     
    cmp _ID
    bne next

    lda #0
    sta _target,x

next
    jsr GetNextOb
    cpx #0
    bne loop
    ;bcc loop
end

	; Was the player locked on this?
	lda _missile_armed
	cmp _ID
	bne no_target_lost
	
	jsr unarm
	ldx #STR_TARGET_LOST
	jsr flight_message 
no_target_lost

	lda compass_index
	cmp _ID
	bne no_compass_lost
	jsr reinit_compass
no_compass_lost

    ldx _ID
    jsr GetShipType
    and #%01111111 

	; What if it is an asteroid????
	cmp #SHIP_ASTEROID
	bne noasteroid
	dec asteroid_counter
noasteroid

	; If a missile, decrement counter
	cmp #SHIP_MISSILE
	bne nomissile
	dec missile_counter
nomissile

	; If it is a thargoid, the same thing
	cmp #SHIP_THARGOID
	bne nothargoid
	dec thargoid_counter
nothargoid

	; If a worm, idem
	cmp #SHIP_WORM
	bne noworm
	dec worm_counter
noworm

	; If police idem
    cmp #SHIP_VIPER
	bne nopolice
	dec police_counter
nopolice

nomore
    jmp DelObj
    ;rts
.)

_collision_list .dsb 4
_num_collisions .byt 0

;; Iterate through visible objects to check for collisions
_CheckHits
.(

    lda #0
    sta _num_collisions

   ; Iterate through visible object list 
    ; Initialize list for iterating ?
    ldy #$80
    sty COB
    jsr GetNextVis
    bmi end
loop
    stx theobject
    sta POINT
    sty POINT+1    

    jsr hit_check
    beq no_hit

    ; HIT
	; Can we scoop?
	lda _equip
	and #EQ_SCOOPS
	beq noscoop
	; Is the object below us?
	lda HCY,x	
	bmi noscoop ; Y coordinates are INVERTED!!!! BEWARE
	; Do we have space?
	lda _holdspace
	beq noscoop

	; Look at ship's type
	ldx theobject
	jsr GetShipType
	and #%01111111
	cmp #SHIP_CARGO
	bne nocannister
	jsr _gen_rnd_number
	and #$0f
	jsr scoop_item
	jmp no_hit
nocannister
	; Not a cannister, scoop, depending on type
	tax
	lda ShipCargo-1,x
	ldx #4
loopd
	lsr
	dex
	bne loopd
	cmp #0
	beq noscoop
	clc
	adc #1
	jsr scoop_item
	jmp no_hit

noscoop
    lda theobject
    ldx _num_collisions
	; Some defensive programming...
	cpx #4
	beq no_hit
    sta _collision_list,x
    inc _num_collisions
    
no_hit
    
    jsr GetNextVis
    bpl loop

end
    lda _num_collisions
    beq none
    jmp handle_collisions   ; This is jsr/rts

none
    rts

.)

theobject .byt 0


scoop_item
.(
	pha
#ifdef HAVE_MISSIONS
	ldx theobject
	jsr OnScoopObject
	bcc nomiss
	pla
	jmp finish
nomiss
#endif

	lda _equip+1
	and #EQ_FUELPROCESSOR
	beq noprocessor

	pla
	pha
	cmp #$0c ; minerals
	bne noprocessor

#ifdef REALRANDOM
	jsr randgen
#else
	jsr _gen_rnd_number
#endif
	cmp #60
	bcs noprocessor

	lda _equip+1
	and #EQ_EXTRAFUEL
	beq normal
	lda #75
	.byt $2c
normal
    lda #70
	sta tmp
	lda _fuel
	cmp tmp
	bcs noprocessor
	
	; Got Quirium... create fuel
	lda tmp
	sta _fuel
	ldx #17
	jsr flight_message_loot
	pla
	jmp finish

noprocessor
	pla

	tax
	stx saveme+1
	jsr flight_message_loot

saveme
	ldx #0 ; SMC
	inc _shipshold,x
	dec _holdspace
finish
	ldx theobject
	jmp RemoveObject ; This is jsr/rts
.)

;; Check if an object is too near collision or scoop
;; X is obj ID, POINT does have the pointer to object record pre-loaded
hit_check
.(
 
    ;; Check if too near
    
    ldy #ObjCenPos
    lda (POINT),y
    tax

    lda HCZ,x
    bne no_hit

    lda CZ,x
    cmp #110 ; Minimum distance
    bcs no_hit

hit
    ;; Check if it is just debris
    ldy #ObjID
    lda (POINT),y
    ; Remove flags to get Object's type
    and #%01111111
  
    beq yes_hit 
    cmp #SHIP_DEBRIS+1
    bcc no_hit  ; Not with debris nor missiles

yes_hit
    lda #1
    rts

no_hit
    lda #0
    rts
.)


;;; damage_ship
; Perform damage of ships and explodes them, if necessary
; Params Reg X is ship ID, Reg A is damage amount.
; Reg Y who is making the damage
; Carry set indicates that it is a missile, and we need to 
; change a bit what we do in damage_player
damage_ship
.(
	ror tmp	; Save carry flag
	; If damaging the player, behave differently
	cpx #1
	beq damage_player

	; Making damage to another ship
	sta tmp
    lda _flags,x
	and #IS_EXPLODING
	beq dodam	
	lda _ttl,x
	bne dodam
	; Can't do damage here, has already been killed
elrts
	rts
dodam
	; If innocent, alert the cops
	lda _flags,x 
	and #(FLG_INNOCENT)
	beq noinnocent
	jsr alert_cops
noinnocent
	lda _flags,x 
	and #(FLG_HARD)
	beq nohard
	lda tmp
	cmp #MILITARY_LASER
	bcs cando
	rts
cando
	lsr
nohard
	; We perform damage
    lda _energy,x
    sec
    sbc tmp
    sta _energy,x
    bcs nokill
killit

	; Target destroyed
    lda _flags,x
    and #%11110000  ; Remove older flags...
    ora #IS_EXPLODING
    sta _flags,x
    lda #0
    sta _ttl,x
	cpy #1
	bne nokill
	; The player killed this...
	; Reg X already contains the ship's ID
	jsr increment_kills
nokill
    ; Make a nice sound
    jmp SndHit	; this is jsr/rts
	;rts
.)



alert_cops
.(
	; Need to save X and Y
	stx savx+1 
	sty savy+1
	ldx police_counter
	beq end
loop
	lda police_ids-1,x
	tay
	lda _target,y
	and #%01111111
	bne next
	lda savy+1	; Get back Y
	ora #IS_ANGRY
	sta _target,y
next
	dex
	bne loop
end
savx
	ldx #00	; SMC
savy
	ldy #00	; SMC
	rts
.)



;;; damage_player
; Perform damage of player
; Params Reg A is damage amount. Reg X equals 1
; Reg Y is the ship making damage
damage_player
.(
	sta tmp+1

	; Alert the cops?
	lda _legal_status
	cmp #50
	bcs nohelp
	lda _ai_state,y
	and #FLG_PIRATE
	beq nohelp
	jsr alert_cops
nohelp
	; See if it is in front or behind us

	lda tmp
	bpl notmissile
	; It was a missile and Y stores the
	; id of the ship which launched it, so
	; need to get that information back
	ldy AIShipID
notmissile
	tya
	tax
	jsr GetObj
	sta kk+1
	sty kk+2
    ldy #ObjCenPos
kk
    ldx $1234,y
	lda HCZ,x
	; We got it, at last

	eor invert	; Invert sign if invert=$ff, leave if invert=$00
	sta tmp		; Needed sign for later

	bmi deplete_rear
	lda _front_shield
	jmp cont4
deplete_rear
	lda _rear_shield
cont4
	sec
	sbc tmp+1
	sta tmp+1
	bpl notneg
	lda #0
notneg
	ldx tmp
	bmi deplete_rear2
	sta _front_shield
	jmp cont
deplete_rear2
	sta _rear_shield
cont
	lda tmp+1
	bpl nokill

	; Shield gone. Deplete energy
	;asl		; double damage
	clc
	adc _energy+1
    sta _energy+1
    bcs losesmthing

    ; Player killed - uh oh
	jsr ViewPlayerShip

    ; Disable keyboard...
    lda #0
    sta player_in_control

	; Inform player
	ldx #STR_GAME_OVER
	jmp flight_message 
losesmthing
	; If reached here, energy was depleted... check
	; if we are to lose equipment
;	lda #0
;dbug beq dbug
	jsr _gen_rnd_number
	cpx #(22+1)
	bcs nokill	; Don't lose anything
	cpx #(16+1)
	bcs loseequip
	; Lose an item?
	lda _shipshold,x
	beq nokill ; We don't have it
	; Does it take cargo space
	sta tmp
	lda Units,x
	bne nospace
	lda tmp
	clc
	adc _holdspace
	sta _holdspace
nospace
	; Lose it	
	lda #0
	sta _shipshold,x
	; Print message
	jsr flight_message_itemlost
	jmp nokill
loseequip
	; Lose equipment
	jsr lose_equip
nokill
    ; Player not killed
    ; Just update screen indicators and such...
	jsr update_shields_panel
    ; Make a nice sound
    jsr SndHitNoShields
	lda #A_FWMAGENTA; A_FWYELLOW
	jsr set_ink

	; If not in front view, alert player
	lda _current_screen
	cmp #SCR_FRONT
	beq end
    ldx #0
	jmp alarm
end	
	rts
.)


;; lose_equip
;; A subroutine just for clarity.
;; Makes the player lose some of its equipment
;; depending on the value of reg X

lose_equip
.(
	// rand -= 17;
    // rand = 0 means ECM,
    //        1       FUEL SCOOPS
    //        6       GALACTIC_HYPER
	; Valid numbers (bit values in _equip)
	; are:
	; 2	Escape Pod
	; 3 Scoops
	; 4 ECM
	; 5 Bomb
	; 7 Galactic Hyper

	txa	; a is 17..22
	sec
	sbc #15
	; Now a is =2..7
	cmp #6
	beq end
	; now just 2,3,4,5, or 7
	; prepare bitflag
	tax
	stx savx+1
	lda #1
loop
	asl
	dex
	bne loop
	; Do we have it equipped?
	and _equip
	beq end	; No, return
	; Clear it
	eor #$ff
	and _equip
	sta _equip
	; Let the player know
savx
	ldx #0	;SMC
	jmp flight_message_eqlost	
end
	rts
.)

;; make_angry
;; Makes a ship angry at another.
;; but first checks if this is possible
;; and the reaction is logical.
;; Params reg A is the ship ID
;;         reg X is the bad guy
make_angry
.(

   ; Check for pressence of FLAG_DEFENCELESS
   ; and behave also depending on type of ship (FLAG)
   ; police allways get angry, pirates and bounty may
   ; and others may with a smaller probability...
   ; and depending on their ammo.

    cmp #2  ; Don't make player angry
    bcc cannot

    tay

	; If it is not ai-controleld, leave it
	lda _ai_state,y
	bpl cannot

	; If the ship is defenceless, he cannot be angry
	;lda _flags,y
	and #FLG_DEFENCELESS 
	bne cannot

    ; If he is already angry, he might not change his mind
	lda _flags,y
	and #FLG_BOLD
	bne cannot

	stx savx+1
	jsr _gen_rnd_number
    and _target,y
    bmi cannot  ; IS_ANGRY is the 7th bit
savx
    ;txa
	lda #0 ;SMC
    ora #IS_ANGRY
    sta _target,y

	; Remove older flags
	lda _flags,y
	and #%11001111
	sta _flags,y

cannot
    rts

.)



.byt count
handle_collisions
.(

    sta count
loop
    ldy count
    lda _collision_list-1,y
    tax
    lda _energy,x   ; Get enemy's energy/2
    lsr
    sta enemy_energy+1
    lda _energy+1   ; Get player's energy/2
    lsr
	ldy #1
	clc ; Not a missile
    jsr damage_ship ; Damage enemy

   ; Make him angry at us
    ldx #1  ; Player
    ldy count
    lda _collision_list-1,y
    jsr make_angry

enemy_energy
    lda #0  ; SMC
    jsr damage_player   ; Damage player
    dec count
    bne loop
    
	jmp SndCrash
    ;rts
.)




_Lasers
.(
    ldx _numlasers
    beq end
    
loop
    ldy _numlasers

	lda _laser_source-1,y
	tax
	lda _vertexXLO,x
	ora _vertexXHI,x
	ora _vertexYLO,x
	ora _vertexYHI,x
	pha
	lda _laser_target-1,y
	;cmp #1
	;bne plkilled
	;lda player_in_control ;escape_pod_launched 
	cmp VOB	; Is this the view object?
	beq set_random_border
	;lda #1
plkilled
	tax
	pla
	ora _vertexXLO,x
	ora _vertexXHI,x
	ora _vertexYLO,x
	ora _vertexYHI,x
	beq nextl

cont
    lda _laser_source-1,y
    tax
    lda _vertexXLO,x
    sta X1        
    lda _vertexXHI,x
    sta X1+1        
    lda _vertexYLO,x
    sta Y1        
    lda _vertexYHI,x
    sta Y1+1        

    lda _laser_target-1,y
    tax
    lda _vertexXLO,x
    sta X2   
    lda _vertexXHI,x
    sta X2+1        
    lda _vertexYLO,x
    sta Y2        
    lda _vertexYHI,x
    sta Y2+1        

    
    jsr _DrawClippedLine
nextl
    dec _numlasers
    bne loop
end
    rts

set_random_border
	pla ;Get rid of saved A
	lda _rnd_seed
	ora #%1
	ldx _rnd_seed+2
	inx
	sta _vertexYHI+1
	stx _vertexXHI+1
	jmp cont

.)



; Increment player's killpoints
; Params reg X is destroyed ship's ID
increment_kills
.(
	stx saveid+1
	jsr GetShipType
	; Remove cloacking bit
	and #%01111111

#ifdef CHECK_VALID_TYPES
    cmp #33
	bcc valid
;	ldy #0
;dbug beq dbug
	ldx saveid+1
	rts
valid
#endif
	cmp #2
	beq nobounty	; Nothing for debris (?)
	sta savetype+1
	asl
	tax
	lda ShipKillValue-2,x
	clc
	adc _score_rem
	sta _score_rem
	lda ShipKillValue-1,x
	adc _score
	sta _score
	bcc all
	inc _score+1
	inc righton
all

saveid
	ldy #0	;SMC
	lda _flags,y
	and #FLG_INNOCENT
	beq bounty

	; Man, he was innocent, should pay consequences for that
	lda _ai_state,y
	and #FLG_DEFENCELESS
	bne nodefense
	; He was asking for it
	lda #1
	bne addfine ; This is a jmp
nodefense
	; You coward!
	lda #($40*2)
loopfine
	lsr 
	bit _legal_status
	bne loopfine
addfine
	clc
	adc _legal_status
	bcs noadd
	sta _legal_status
noadd
	rts
bounty
	; Now the bounty, if any
;	txa
;	asl
;	tax
savetype
	ldx #0 ; SMC

	lda ShipBountyLo-1,x
	sta op2
	ora ShipBountyHi-1,x
	beq nobounty
	lda ShipBountyHi-1,x
	sta op2+1

	lda op2
	clc
	adc bounty_am
	sta bounty_am
	lda op2+1
	adc bounty_am+1
	sta bounty_am+1

	jmp inc_cash

	;jsr flight_message_bounty 
nobounty
	rts
.)


SetECMOn
.(
	; Set cockpit signal to ecm detected
	
	; Set ecm counter
	lda #5
	sta _ecm_counter

	jmp update_ecm_panel

	;rts
.)





