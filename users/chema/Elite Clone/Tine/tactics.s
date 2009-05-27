
#include "tine.h"

;; Function table for ships that are
;; hyperspacing, docking, exploding or disappearing...
;; Flags IS_whatever in tine.h

dis_tab_lo .byt <(ExplodeObject), <(DisappearObject), <(HyperObject), <(DockObject)
dis_tab_hi .byt >(ExplodeObject), >(DisappearObject), >(HyperObject), >(DockObject)



;; Tactics function
;; Implements AI
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
    ; Make ship disappear for now
    ;jsr DelObj
    ;tay
    lda dis_tab_lo-1,y
    sta jump+1
    lda dis_tab_hi-1,y
    sta jump+2
jump
    jsr $1234   ; SMC

    jmp nomove


noflags    
    ; If a moving ship has a target, make her go
    ; for it!
    
    lda _target,x
    and #%01111111  ; Remove angry flag
    beq nomove
    tax
    jsr fly_to_ship    

nomove
    jsr GetNextOb
    cpx #0
    bne loop
end
    rts


.)


FireLaser
.(
    jsr _DrawLaser

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

;    ldy #0
;dbug    beq dbug
  
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
  ;  stx sav_x+1 ; Save X for later...
    jsr abs

    lda op1+1
    bne next
    lda op1
    sta uno+1

;sav_x
;    ldx #0  ; SMC    
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
    
    ; HIT!
    ; Should save ID to get the last one, after iterating...
    ; For now just print something...
     
    jsr GetCurOb
    stx _ID
    
next
    jsr GetNextVis
    bpl loop

end

    ldx _ID
    beq nohit
    lda #10 ; Current laser strength. SHOULD CHANGE   
    jsr damage_ship

nohit
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

    lda #11
    sta _accel,x
    lda #3
    sta _rotz,x
    ;lda #30
    ;sta _speed,x       

    ; Make it disappear soon
    lda #( IS_DISAPPEARING )
    ora _flags,x
    sta _flags,x

    lda #255    
    sta _ttl,x

    ; Push it a bit
    jsr SetCurOb
    lda #10
    jmp MoveForwards

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
    jsr GetObj
    sta tmp
    sty tmp+1

    ldy #ObjID
    lda (tmp),y
    and #%01111111   

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
    lda #$ff ;d ; -3
    sta _accel,x
    lda #5
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
    ora #%00001000
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
    rts 

noexplode

   jsr _printHit     
    ; Make a nice sound
    rts

.)


;;; damage_ship
; Perform damage of player
; Params: Reg A is damage amount.

damage_player
.(
    ldx #1
    jsr damage_ship
    lda _flags,x
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
    lda #1
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
    lda #$9c     ; -100
    jsr MoveForwards
 

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


    jsr _prcolls

    rts
.)
