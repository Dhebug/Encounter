
#include "tine.h"

#define SHUTTLE_CHANCE      $fc
#define VIPER_CHANCE        $ef
#define ANACONDA_CHANCE     $c7
#define BREAK_CHANCE        $f9
#define ESCAPE_POD_CHANCE   $e5
#define FIRING_DISTANCE     $e000
#define ECM_CHANCE          $10
#define HERMIT_CHANCE       $fc


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
    STA POINT        ;Object pointer
    STY POINT+1

    lda #( IS_HYPERSPACING | IS_DOCKING | IS_EXPLODING | IS_DISAPPEARING )
    and _flags,x
    beq noflags

    tay
    lda _ttl,x
    beq do_special
    dec _ttl,x
    jmp noflags
do_special
    ; Call routine for each flag kind...
    lda dis_tab_lo-1,y
    sta jump+1
    lda dis_tab_hi-1,y
    sta jump+2
jump
    jsr $1234   ; SMC

    jmp nomove


noflags    
    lda _ai_state,x
    and #IS_AICONTROLLED
    beq noai
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
; Parameters: Reg X contains ship ID
; for which we are running the AI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AIShipID    .byt 00 ; Current ship's ID
AIShipType  .byt 00 ; Current ship's type
AITarget    .byt 00 ; Current ship's target
AIIsAngry   .byt 00 ; Angry status (with target)

AIMain
.(
    stx AIShipID
    lda _target,x
    sta AIIsAngry
    and #%01111111
    sta AITarget
    jsr GetShipType
    sta AIShipType
    cmp #SHIP_MISSILE
    bne nomissile

    ; lda _ecm_counter
    ; beq noecm
    ; ;Incrementamos kills y eliminamos el misil
    ; rts
;noecm
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
    lda op1
    cmp #70
    bcs nohit
    dey
    dey
    bpl loop
 
    ; Missile hit!!!
 
    
    ; Missile explodes
    ;jsr GetCurOb
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

    ; Perform damage
    lda AITarget
    tax
    lda _speed,x
    lsr
    sta _speed,x
    lda #0
    sta _accel,x
    lda #$40
    jmp damage_ship
        
nohit
    ;; Mirar a ver si se activa ECM (si no es el jugador)
    ;; Si no lo activa entonces seguimos la persecución (?)
    jmp approach

nomissile
    ;; It was NOT a missile, but another kind of ship
    ; Update energy

    ; If it is a THARGON and there are no THARGOIDS
    ; halve speed and set ai_state=0 and rts
    
    ; Get a random number
    jsr _gen_rnd_number

    ; If FLAG_TRADER and r1>100 rts

    ; If FLAG_BOUNTYHUNTER and our legal status >=40 set angry flag and target us (=1)

    ; If FLAG_PIRATE and planet nearby or police and r1>100 , remove angry status and target hyperspace point 


approach
    ; If a moving ship has a target, make her go
    ; for it!
    
    lda AITarget
    beq end
    tax
    jsr fly_to_ship    

end
    rts

.)


;; Some variables to decouple firing and drawing the lasers
_numlasers .byt 00
_laser_source .dsb 4
_laser_target .dsb 4

A1  .word 0
oX   .word 0
oY   .word 0
oZ   .word 0

;; fly_to_ship
;; Makes current object fly towards a given ship
;; passed in reg X
fly_to_ship
.(

    ; Get the vector towards the target
    jsr substract_positions
    
    ; Need to save some data for later on... :(
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

    ; if it is an Anaconda and there are less than 3 worms
    ; launch one randomly. As _gen_rnd_number has already
    ; been called, just use _rnd_seed (+1,+2,+3)

    ; Randomly roll a bit to throw away anyone tracking me
    lda _rnd_seed
    cmp #BREAK_CHANCE
    bcc noroll
    ora #$68    ; doesn't $68 seem too high?
    ldx AIShipID
    sta _rotx,x    
noroll
    
    ; Check ship's energy. If it is max/2
    ; check if also less than max/8
    ; if it is
    ; launch escape pod, if possible and rts
    ; if only less than max/2 launch missile and rts

    ; If we are not angry we don't want to shoot.
    lda AIIsAngry
    and #IS_ANGRY
    beq toofar

    ; If we arrive here energy is still high or we didn't
    ; want to or couldn't launch missile or escape pod
    ; Try to shoot at target
    
    ; Check distance... as A=abs(x)|abs(y)|abs(z)..
    ;jsr getnorm ; Does precisely this with x,y,z being VectX,Y,Z (see tinefuncs.s)
    ; Now precalculated in A1

    ; Check if greater (or equal) than $2000 (maximum firing -and visibile- distance)
    ; we can do this with an and over $e000 (the inverse of $1fff), and check for zero.
    ; BEWARE! Bug. VectX,Y,Z are now normalized!
    lda A1+1
    and #>FIRING_DISTANCE
    bne toofar  

    ; Check if laser is fitted... check FLAG_DEFENCELESS?
    ; if none goyo toofar
    
    ; We can shoot, so let's do it
    
    ; Check the attack angle (our_ang0)
    ; According to Elite-AGB if greater than $2000 fire, if greater than $2300 fire and hit.
    ; Scaling down approprately $2000 is 0.888 times the max value ($2400). The 88 percent of
    ; our max value ($1000) is $e38. $2300 is equivalent to $f8e.

    lda our_ang0
    sta op1
    lda our_ang0+1
    sta op1+1
 
    lda #<$e38; $f1c8 ;$e38
    sta op2
    lda #>$e38; ;$e38
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
 

    ; Make ship angry at who shoots
    ldx AIShipID
    lda AITarget
    jsr make_angry

   
    ; Do we hit or miss?
    lda #<$f8e;f07d ;$f8e
    sta op2
    lda #>$f8e;f07d ;$f8e
    sta op2+1
    jsr cmp16
    bmi toofar

    ; We hit!

    ldx AIShipID
    dec _accel,x

    ldx AITarget
    lda #3 ; Current laser strength. SHOULD CHANGE   
    jmp damage_ship ; This is jsr/rts
    
     
toofar    
    ; Target far away,
    ; or not angry,
    ; or angle of attack too great,
    ; or fired and missed
    ; or no laser fitted
    ; fly about "randomly"

    ; First see if we are on a collision course
    
    ; if z>$300 no problem
;    lda #0
;dbug beq dbug  
    
    lda oZ+1
    bpl notneg0
    sec
    lda #0
    sbc oZ+1
notneg0
    cmp #3
    bcs approach 

    ; it is less than $300, so check X and Y
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
    and #$fe
    bne approach
    
    ; On collision course, invert everything

    lda #0
    sec
    sbc _VectX
    sta _VectX
    lda #0
    sbc _VectX+1
    sta _VectX+1

    lda #0
    sec
    sbc _VectY
    sta _VectY
    lda #0
    sbc _VectY+1
    sta _VectY+1

    lda #0
    sec
    sbc _VectZ
    sta _VectZ
    lda #0
    sbc _VectZ+1
    sta _VectZ+1

    lda #0
    sec
    sbc our_ang0
    sta our_ang0
    lda #0
    sbc our_ang0+1
    sta our_ang0+1

 
    
approach
    jmp fly_to_vector_final

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

    jsr _DrawLaser

    ; Check to see if we hit
    jsr FindTarget
    ldx _ID
    beq nohit
    lda #10 ; Current laser strength. SHOULD CHANGE   
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
    lda #SHIP_MISSILE   ; Ship to launch
    jsr LaunchShipFromOther
    cpx #0
    beq failure

    lda #11
    sta _accel,x
    lda #3
    sta _rotz,x
    ;lda #30
    ;sta _speed,x       
    ; Set ai_controlled
    lda _ai_state,x
    ora #IS_AICONTROLLED 
    sta _ai_state,x
        
    ; Get objective
    lda #2
    sta _target,x

    ; Make it disappear soon
    lda #( IS_DISAPPEARING )
    ora _flags,x
    sta _flags,x

    lda #255    
    sta _ttl,x

    ; Push it a bit
    jsr SetCurOb
    lda #100
    jsr MoveForwards
    lda #50
    jsr MoveSide;Down

failure
    rts

.)







HyperObject
DockObject
DisappearObject
.(
    
    stx _ID
    jmp RemoveObject
.)




ExplodeObject
.(
    stx _ID
    jsr _explode
    jsr _gen_rnd_number
    ldx _ID

    ; Generate some debris

    lda _rnd_seed+1
    and #%00001111
    ora #%00001000
    sta tmp3
loop
    jsr SetCurOb

    lda #(SHIP_DEBRIS|SHIP_NORADAR) ; #SHIP_ALLOY
    jsr CreatePart
    
    ldx _ID
    dec tmp3
    bne loop

    ; Now some plates, if exploding
    ; object is a ship
    ;jsr GetObj
    ;sta tmp
    ;sty tmp+1

    ;ldy #ObjID
    ;lda (tmp),y
    and #%01111111   
    jsr GetShipType
    cmp #SHIP_VIPER
    bcc nomore  ; if it is space junk nothing more...

    lda _rnd_seed+2
    and #%00000011
    clc
    adc #1
    ;ora #%00000001
    sta tmp3
loop2
    jsr SetCurOb
    lda #SHIP_ALLOY
    jsr CreatePart
    
    ldx _ID
    dec tmp3
    bpl loop2

nomore

 
    ;lda #IS_DISAPPEARING
    ;ora _flags,x
    ;sta _flags,x

    ;rts
    jmp RemoveObject

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

savA
    lda #0  ;SMC
    and #%01111111  ; Remove flag
    cmp #SHIP_DEBRIS
    bne nodeb
 
    lda _rnd_seed
    and #%00000111
    ;ora #%00001000
    ora #%00000100
    jmp setttl
nodeb
    lda #255    
setttl
    sta _ttl,x
    
    jsr SetCurOb

    jsr _gen_rnd_number
    ldy _rnd_seed+2
    lda _rnd_seed+1
    ldx _rnd_seed
    jsr SetMat
   
    lda #5
    jmp MoveForwards

    ;rts

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
end


    ldx _ID
    jsr DelObj

    rts



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
    stx sav_x+1
    sta POINT
    sty POINT+1    

    jsr hit_check
    beq no_hit

    ; HIT
sav_x
    lda #0
    ldx _num_collisions
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


;; Check if an object is too near: collision or scoop
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
    ;; Check if it is just debris:
    ldy #ObjID
    lda (POINT),y
    ; Remove flags to get Object's type
    and #%01111111

    ;; What to do if it is a planet?
    ;; Collisions this way are reported too late (when the planet circle is wrongly drawn!)

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
; Params: Reg X is ship ID, Reg A is damage amount.
damage_ship
.(

    sta tmp
    lda _energy,x
    sec
    sbc tmp
    sta _energy,x
    bcs noexplode 
    
    lda _flags,x
    and #%11110000  ; Remove older flags...
    ora #IS_EXPLODING
    sta _flags,x
    lda #0
    sta _ttl,x
    jmp end 

noexplode
    ; Preserve reg X
    stx end+1
    ;jsr _printHit     
    ; Make a nice sound
    jsr _shoot

end
    ldx #0  ; SMC
    cpx #1
    bne noplayer
    jmp damage_player
noplayer
     
    rts

.)

;; make_angry
;; Makes a ship angry at another.
;; but first checks if this is possible
;; and the reaction is logical.
;; Params: reg A is the ship ID
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

    ; If he is already angry, he might not change his mind
    lda _target,y
    bmi cannot  ; IS_ANGRY is the 7th bit
    
    txa
    ora #IS_ANGRY
    sta _target,y

cannot
    rts

.)


;;; damage_player
; Perform damage of player
; Params: Reg A is damage amount. Reg X equals 1

damage_player
.(
    ;ldx #1
    ;jsr damage_ship
    lda _flags+1
    and #%IS_EXPLODING
    beq nokill    
   
;    lda #0
;dbug
;    beq dbug

    ; Player killed - uh oh

   ; Make it still
    lda #0
    sta _speed+1    

    ; Delay explosion a bit
    lda #0
    sta _ttl+1
    
    jsr SetCurOb
    lda #SHIP_COBRA3
    jsr LaunchShipFromOther

    ;lda #0
    ;sta _speed,x


    ; Set it as view object
    stx VOB

    ; Push it a bit
    jsr SetCurOb
    lda #$9c     ; -100
    jsr MoveForwards
    ;lda #$9c     ; -100
    ;jsr MoveForwards
 

    ; Disable keyboard...
    ;lda #0
    ;sta _player_in_control

nokill
    ; Player not killed
    ; Just update screen indicators and such...
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
    lda _energy,x
    sta enemy_energy+1
    lda _energy+1   ; Get player's energy
    jsr damage_ship ; Damage enemy

enemy_energy
    lda #0  ; SMC
    jsr damage_player   ; Damage player

    dec count
    bne loop


    ;jsr _prcolls

    rts
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
    sta X1        
    lda _vertexXHI,x
    bmi neg1
    lda #0
    beq post1
neg1
    lda #$ff
post1
    sta X1+1        
    lda _vertexYLO,x
    sta Y1        
    lda _vertexYHI,x
    bmi neg2
    lda #0
    beq post2
neg2
    lda #$ff
post2
    sta Y1+1        

    lda _laser_target-1,y
    tax
    lda _vertexXLO,x
    sta X2   
    lda _vertexXHI,x
    bmi neg3
    lda #0
    beq post3
neg3
    lda #$ff
post3
    sta X2+1        
    lda _vertexYLO,x
    sta Y2        
    lda _vertexYHI,x
    bmi neg4
    lda #0
    beq post4
neg4
    lda #$ff
post4
    sta Y2+1        

    jsr _DrawClippedLine

    dec _numlasers
    bne loop
end
    rts
.)



