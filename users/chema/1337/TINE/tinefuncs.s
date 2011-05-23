;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Some TINE functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include "ships.h"
#include "tine.h"
#include "oobj3d\params.h"


;; Main functions

;; Some extensions of obj3d
;; some can be called from C


;; Gets the pixel address and scan.
;; Params X reg X, Y reg Y
;; Returns
;; tmp0 address of line
;; reg Y scan in line (tmp0),y is the pointer to the actual scan
;; reg A scan code with the pixel to ora or eor in screen...

#ifndef FILLEDPOLYS
pixel_address_real
.(
    lda double_buff
    beq pixel_address

	lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

    ; Put back to onscreen coordinates
    lda #<($a000-buffer)
    clc
    adc tmp0
    sta tmp0
    lda #>($a000-buffer)
    adc tmp0+1
    sta tmp0+1

  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
    
    rts


.)

pixel_address
.(
    lda _HiresAddrLow,y			; 4
	sta tmp0+0					; 3
	lda _HiresAddrHigh,y		; 4
	sta tmp0+1					; 3 => Total 14 cycles

  	ldy _TableDiv6,x
	lda _TableBit6Reverse,x		; 4
    
    rts

.)
#else
pixel_address_real
pixel_address
.(
  
    lda	_ScreenPtrLow,y
    sta tmp0
    lda _ScreenPtrHigh,y
    sta tmp0+1
    

    lda _Mod6Left,x	
    and #%00111111
    sec
    ror
    ora _Mod6Right,x
    eor #$ff
    ldy _Div6,x	
    rts
.)
#endif


;; LaunchShipFromOther
;; Launches a ship from current ship
;; Reg A contains the new ship type
;; Returns the new ship ID in reg X

LaunchShipFromOther
.(
 
    pha
    jsr GetCurOb
    sta loop+1
    sty loop+2
    stx savx+1    

    jsr _GetShipPos
    lda #<_PosX
    sta tmp0
    lda #>_PosY
    sta tmp0+1    

    pla
    jsr AddSpaceObject
    cpx #0
    beq failure

     ; Copy orientation matrix

    ldy #ObjMat
loop
    lda $1234,y ; SMC
    sta (POINT),y
    iny
    cpy #(ObjMat+18)
    bne loop

    ; Match speeds
savx
    ldy #0  ; SMC
    lda _speed,y
    sta _speed,x    

failure    

    rts

.)



;; Adds an space object to the world
;; The pointer to the center is passed in tmp0 
;; and the ship type in A
;; Returns X=ship entry (ID), POINT contains pointer to object data
AddSpaceObject
.(
    ; Load ship Model
    ;txa
    sta saveme+1
    and #%01111111
    tax
    stx saveModelIndex+1


    ; See if we have enough space...
    lda NUMOBJS
    cmp #(MAXSHIPS)
    bne roomok
noroom  
    ldx #0
    rts
roomok

    lda ShipModelHi-1,x
    tay
    lda ShipModelLo-1,x
   
    ; Add object to oobj3d
saveme  
    ldx #0 ; SMC

+AddSpaceObjectDirect 
    jsr AddObj
  
    ; Now the position

    ;lda tmp0+1
    ;ora tmp0
    ;beq nopos       ; If pointer  is zero, not a valid address

    sta POINT        ;Object pointer
    sty POINT+1
    ldy #5           ;Set center
l1  lda (tmp0),y
    sta (POINT),y
    dey
    bpl l1

saveModelIndex
    ldy #0  ; SMC, get model index

    ; Set all fields

    ; Initial energy... default for ship
    lda ShipEnergy-1,y
    sta _energy,x
    
    ; Number of missiles and strength of lasers
    lda ShipAmmo-1,y
    ;and #%11111000
    sta _missiles,x

    ; Set rest of fields to default
    lda #0
    sta _rotx,x
    sta _roty,x
    sta _rotz,x
    sta _speed,x
    sta _accel,x    
    sta _target,x
    sta _flags,x
    sta _ttl,x
    sta _ai_state,x

;nopos
    rts
.)

_SetCurrentObject
.(
    ldy #0
    lda (sp),y
    ;sta _curr_ship
    ;tax
    ;lda _ids,x
    tax
    jmp SetCurOb
.)



_GetFrontVector
.(
    jsr GetFrontVec
    stx _VX
    sty _VY
    sta _VZ
    rts

.)


_GetDownVector
.(
    jsr GetDownVec
    stx _VX
    sty _VY
    sta _VZ
    rts
 .)


_GetSideVector
.(
    jsr GetSideVec
    stx _VX
    sty _VY
    sta _VZ
    rts
 .)


_GetShipPos
.(
    jsr GetCurOb
    jmp GetShipPos

.)


; Gets the position of ship
; given in reg X
; Stores it in _PosX,Y and Z
; all 16 bit signed.
GetShipPos
.(
    jsr GetObj

    sta POINT        ;Object pointer
    sty POINT+1

    ldy #0
    lda (POINT),y
    sta _PosX
    iny
    lda (POINT),y
    sta _PosX+1
    iny


    lda (POINT),y
    sta _PosY
    iny
    lda (POINT),y
    sta _PosY+1
    iny

    lda (POINT),y
    sta _PosZ
    iny
    lda (POINT),y
    sta _PosZ+1

    rts
.)


; Gets the type of ship
; given in reg X
; and returns it in reg A
GetShipType
.(
    jsr GetObj
   ; Check ship ID byte...
    sta POINT        ;Object pointer
    sty POINT+1
    ldy #ObjID
    lda (POINT),y
    rts

.)



; Gets the user byte (equipment)
; given in reg X
; and returns it in reg A
GetShipEquip
.(
    jsr GetObj
   ; Check ship ID byte...
    sta POINT        ;Object pointer
    sty POINT+1
    ldy #ObjUser
    lda (POINT),y
    rts
.)


; Sets the user byte (equipment)
; of the ship given in reg X
; as the value given in reg a
SetShipEquip
.(
	pha
	jsr GetObj
	; Check ship ID byte...
    sta POINT        ;Object pointer
    sty POINT+1
    ldy #ObjUser
	pla
    sta (POINT),y
    rts
.)



; Basic stats for a new ship for the player
NewPlayerShip
.(
  	; Initializations for first-time usage
	ldx _ship_type
	lda ShipAmmo-1,x
	and #%111
	sta _p_maxmissiles
	sec
	sbc #1
	sta _missiles_left
+PreInit
    ;lda ShipMaxSpeed-1,x
	lda #23
    sta _p_maxspeed
	;lda ShipEnergy-1,x
	lda #72
	sta _p_maxenergy

	ldx #8
loop
	lda tab_rolls_slow,x
	sta tab_rolls,x
	dex
	bpl loop

	rts

.)

;; Get the initial stats for player's ship
InitPlayerShip
.(

	jsr PreInit

	; Depending on ship's equipment...

/*	lda _equip
	and #%10 ; Large cargo bay
	beq nocargo
	lda _holdspace
	clc
	adc #10
	sta _holdspace
nocargo

*/
	lda _equip
	ror
	bcc	nopulse
	;Pulse laser
	ldx #PULSE_LASER
nopulse
	lda _equip+1
	ror
	bcc nobeam
	ldx #BEAM_LASER
nobeam
	ror
	bcc nomil
	ldx #MILITARY_LASER
nomil

afterlaser
	stx _p_laserdamage

	ror 
	bcc nospeed
	tax
	lda _p_maxspeed
	clc
	adc #5
	sta _p_maxspeed
	txa
nospeed

	ror
	bcc noman

	ldx #8
loop
	lda tab_rolls_fast,x
	sta tab_rolls,x
	dex
	bpl loop
noman

	lda _equip
	and #%01000000	; Extra energy
	beq noenergy
	clc
	lda _p_maxenergy
	adc #24
	sta _p_maxenergy
noenergy

	; Shields
	lda #22
	sta _front_shield
	sta _rear_shield

	; Energy, speed,...
	lda _p_maxenergy
	sta _energy+1
	lda _p_maxspeed
	lsr
	sta _speed+1

	; Missile armed
	lda #0
	sta _missile_armed
	sta _ptla
	sta _ptsh

	rts
.)



;; For moving ships

_MoveShips
.(
    lda game_over
	beq normal
	ldx #0
	beq p1
normal
    jsr MovePlayer ; Start moving player
       
    ; Now iterate through object list moving the rest

	; Avoid fixed objects
	ldx fixed_objects
	dex
p1
	stx CUROBJ
    jsr GetNextOb
    ; Check if we got back to object 0 (radar)
    cpx #0  
    beq end 
loop
    sta POINT        ;Object pointer
    sty POINT+1

    ; Get ship ID byte...
    ldy #ObjID
    lda (POINT),y
    
    jsr MoveCurrent

nomove
    jsr GetNextOb
    ;bcc loop
    ; Carry shoubd be clear, unless error
    ; Check if we got back to object 0
    cpx #0
    bne loop

end
    rts

.)

;; Routines to perform movement of ships. They are
;; separated in two, one for the player and other
;; for the rest of ships, as different things should be performed
;; and we avoid filling them with comparisons...

;; These globals are used by stars...

g_alpha .byt 0  ; Total rotation in X (Pitch)
g_beta  .byt 0  ; Total rotation in Y (Yaw)
g_delta .byt 0  ; Total rotation in Z (Roll)
g_theta .byt 0  ; Total speed?

#define mancount tmp

MovePlayer
.(
	; Patch ACCROTX, etc.
	lda #<ROTXY2
	sta patch_rot1+1
	sta patch_rot2+1

	lda #>ROTXY2
	sta patch_rot1+2
	sta patch_rot2+2

    ldx #1
    jsr SetCurOb

    lda _rotx+1
    cmp #$80
    php
    and #$7f
    beq nadax
    sta mancount
    lda #0
    sta _rotx+1
    
    lda #0
    plp
    php
    ror
    ora mancount
    sta g_alpha

loopx
    plp
    php
    jsr Pitch
    dec mancount
    bne loopx
nadax
    plp

    lda _roty+1
    cmp #$80
    php
    and #$7f
    beq naday
    sta mancount
    lda #0
    sta _roty+1

    lda #0
    plp
    php
    ror
    ora mancount
    sta g_beta

loopy
    plp
    php
    jsr Yaw
    dec mancount
    bne loopy
naday


	; Patch ACCROTX, etc.
	lda #<ROTXY
	sta patch_rot1+1
	sta patch_rot2+1

	lda #>ROTXY
	sta patch_rot1+2
	sta patch_rot2+2


    plp

    lda _rotz+1
    cmp #$80
    php
    and #$7f
    beq nadaz
    sta mancount
    lda #0
    sta _rotz+1

    lda #0
    plp
    php
    ror
    ora mancount
    sta g_delta

loopz
    plp
    php
    jsr Roll
    dec mancount
    bne loopz
nadaz
    plp

    lda _accel+1
    clc
    adc _speed+1
    bpl noneg
    lda #0
    beq nomax
noneg    
    cmp _p_maxspeed
    bcc nomax
    lda _p_maxspeed  
nomax
    sta _speed+1
    sta g_theta
	beq end
 
    ; Move forwards actually moves 4 times the amount in A
    ; Original Elite moves 3/2 (96*4/256) times this amount.
    ; Let's see if halving down this is enough...
	lsr
	lsr
    jsr MoveForwards    

    lda #0
    sta _accel+1

end
/*
	; Patch ACCROTX, etc.
	lda #<ROTXY
	sta patch_rot1+1
	sta patch_rot2+1

	lda #>ROTXY
	sta patch_rot1+2
	sta patch_rot2+2
*/
+globalrts
    rts

.)


maxspeed .byt 0

; Needs reg A loaded with field ID of obj3D record
MoveCurrent
.(
    and #%01111111
    tax
	beq globalrts ; This is a planet or a moon... 

	lda ShipMaxSpeed-1,x
    sta maxspeed

    ldx CUROBJ
    lda _rotx,x
	tay
	and #%01111111
    beq nadax
    cpy #$80
    jsr Pitch
nadax
    ldx CUROBJ
    lda _roty,x
	tay
	and #%01111111
    beq naday
    cpy #$80
    jsr Yaw
naday
    ldx CUROBJ
    lda _rotz,x
	tay
	and #%01111111
    beq nadaz
    cpy #$80
    jsr Roll
nadaz

forwards
    ldx CUROBJ
    lda _accel,x
    beq move
    clc
    adc _speed,x
    bpl noneg
    lda #0
    beq nomax ; allways branch
noneg    
    cmp maxspeed
    bcc nomax
    lda maxspeed  
nomax
    sta _speed,x
move
    lda _speed,x
	; Move forwards actually moves 4 times the amount in A
    ; Original Elite moves 3/2 (96*4/256) times this amount.
    ; Let's see if halving down this is enough...
    
	; Speed should allways be possitive
	;cmp #$80
    ;ror
    ;cmp #$80
    ;ror
	lsr
	lsr
    jsr MoveForwards    
end
    rts
.)



get_attack_angle
.(

  ; norm_big();
  ; GetFrontVector();
  ; our_ang0=dot_product();

    jsr _norm_big
    jsr _GetFrontVector
    jsr dot_product
    lda op1+1
    ldx op1
    sta our_ang0+1
    stx our_ang0
    rts
.)



;; fly_to_vector
;; function that implements
;; the AI to make a ship follow a given vector
;; The thing is calculating dot products for the
;; three direction vectors of the ship and the objective
;; vector and trying to make down and lateral values 0
;; it fills the rotx, roty and rotz components for the ship
;; data, as well as the acceleration, so MoveShip will perform
;; rotations and advances as necessary.
;;
;; Convention for rotation values is that bit 7 set means negative
;; BUT lower 7 bits are NOT 2-complemented.

#define ROTATE_AMOUNT  3; 5


;; First some variables needed for all this...

;    int our_ang0;
;    int our_ang1;
;    int our_ang2;
;    int ang_lim;

; The three results for the dot product
our_ang0 .word 00
our_ang1 .word 00
our_ang2 .word 00

;; The angle limit to decide a ship should rotate
;; It is compared with the high byte of angle
ang_lim .byt 00



fly_to_vector
.(
  ; If very behind us, make sure we rotate...
  ; if (our_ang0 < -0xa38)//-0x1700/2)
  ;      ang_lim=0;
  ; else
  ;      ang_lim=3;
    ; already in op1
    ;sta op1+1
    ;stx op1
    lda #<(-$a38)
    sta op2
    lda #>(-$a38)
    sta op2+1
    jsr cmp16
    bpl limnorm  
    lda #0
    .byt $2c ;beq store ; allways jump
limnorm
    lda #1      ; Force 0 for aggresive following... maybe when ANGRY?
store
    sta ang_lim
 
  ; // NES addition 
  ;if (our_ang0 < -0xdc7){//-0x1000) {
  ;  rotx[curr_ship] |= 2;
  ;  if (our_ang0 < 0) 
  ;    rotx[curr_ship] |= 0x80;
  ;  rotz[curr_ship] = 0;
  ;  return;
  ;}

    ;jmp nonessadd
    lda our_ang0
    sta op1
    lda our_ang0+1
    sta op1+1
    lda #<(-$dc7)
    sta op2
    lda #>(-$dc7)
    sta op2+1
    jsr cmp16
    bpl nonessadd
 
    ldx CUROBJ;_curr_ship
    lda _rotx,x
    ora #7
    sta _rotx,x
    lda our_ang0+1
    bpl noneg
    lda _rotx,x
    ora #$80
    sta _rotx,x
noneg
    lda #0
    sta _roty,x
    rts
nonessadd   

    ;; Now start with checks for angles.
    ;; We want to make ang1 and ang2 0 and
    ;; ang0 the max possible (64*64=4096 i.e. $1000)


 ; GetDownVector();
  ; our_ang1=dot_product();
    jsr _GetDownVector
    jsr dot_product
    lda op1+1
    ldx op1
    stx our_ang1
    sta our_ang1+1

  ;rotz[curr_ship]=0;
  ;if (abs(our_ang1)/255>=ang_lim) {
  ;    rotz[curr_ship]=ROTATE_AMOUNT;
  ;}
  ;if(our_ang1 >=0)
  ;      rotz[curr_ship] |= 0x80;

    lda #0
    ldx CUROBJ;_curr_ship
    sta _roty,x 

    lda our_ang1
    sta op1
    lda our_ang1+1
    sta op1+1
    jsr abs

    ldx CUROBJ ;_curr_ship
    lda op1+1
    bne rotatez
    lda op1 
    cmp ang_lim
    bcc nothingtodo
;    lda #4
rotatez
    lda #ROTATE_AMOUNT
    ;lsr
    sta _roty,x
nothingtodo
    lda our_ang1+1
    bpl neg ;    bmi neg ; BEWARE rotz seems to be interpreted differently so sign should be inverted!
    lda _roty,x
    ora #$80
    sta _roty,x    
neg
    
  
  ;  GetSideVector();
  ;  our_ang2=dot_product();

    jsr _GetSideVector
    jsr dot_product
    lda op1+1
    ldx op1
    stx our_ang2
    sta our_ang2+1

  ;  rotx[curr_ship]=0;
  ;  if( abs(our_ang2)/255 >=ang_lim){
  ;      rotx[curr_ship]=ROTATE_AMOUNT;
  ;  }

  ;  if(our_ang2>=0)
  ;      rotx[curr_ship]|=0x80;

    lda #0
    ldx CUROBJ;_curr_ship
    sta _rotx,x 
 
    ; already in op1
    ;lda our_ang2
    ;sta op1
    ;lda our_ang2+1
    ;sta op1+1
    jsr abs

    ldx CUROBJ;_curr_ship
    lda op1+1
    bne rotatex
    lda op1 
    cmp ang_lim
    bcc nothingtodo2
    lda #4 
rotatex
    ;lda #ROTATE_AMOUNT
    lsr
    sta _rotx,x
nothingtodo2
    lda our_ang2+1
    bmi neg2
    lda _rotx,x
    ora #$80
    sta _rotx,x    
neg2

    ; Now the acceleration
    ; This was my own addition, trying to avoid a ship
    ; stopping, but should not be necessary...

  ; if ((rotx[curr_ship] & 0x7f | roty[curr_ship] & 0x7f | rotz[curr_ship] & 0x7f)==0)
  ;      accel[curr_ship]=2;
  ; else

#ifdef 0
    lda _rotx,x
    ora _roty,x
    ora _rotz,x
    and #$7f
    bne cont
    lda #2
    sta _accel,x
    rts
cont
#endif
  
  ; // Check if dot product of front vector and destination
  ; // is near the max. Max result is 64*64=4096 (0x1000).
  ; // The original elite-agb used this max*0.63 and max*0.5
  ; // for the bottom thresholds... so we can use 0x9c0 and 0x500..
  ; //    

  ; // i.e. negative or small...
  ; // for tactics this should be 1600 

    ; This means that if the angle of front vector is negative or small
    ; we are in the wrong direction, so better stop... The elite-agb sources
    ; state that for tactics this should be higher, but will add it later
  ;  {
  ;      if (our_ang0<0x9c0){ //0x9ff){//0x1600 ) { // this is 60%the max vector
  ;          our_ang0 = abs(our_ang0);
  ;          if (our_ang0 >= 0x500){//0x100){//0x1200) { // This is half the max vector
  ;              accel[curr_ship] = -1;
  ;          }
  ;      } else {
  ;      accel[curr_ship] = 2;
  ;       }
  ;  };
  ;}
    lda our_ang0
    sta op1
    lda our_ang0+1
    sta op1+1
    lda #<$9c0
    sta op2
    lda #>$9c0
    sta op2+1
    jsr cmp16
    bpl notsmall
    
    jsr abs
   
    ;; Storing this is really necessary? Maybe for later functions...
    ;lda op1
    ;sta our_ang0
    ;lda op1+1
    ;sta our_ang0+1

    lda #<$500
    sta op2
    lda #>$500
    sta op2+1
    jsr cmp16
    bmi notdec

    ldx CUROBJ;_curr_ship
    lda #$ff
    sta _accel,x
    
notdec
    ;; That is all
    rts
notsmall
    ldx CUROBJ;_curr_ship
    lda #2
    sta _accel,x
    
    ;; And that is all folks
    ;lda #0
    ;sta _rotz,x
    rts

.)







;; Normalize a vector


;void norm()
;{
;    int x,y,z;
;    int RQ,Q;
;    
;
;    x=VectX/256;
;    y=VectY/256;
;    z=VectZ/256;
;    
;    RQ=(x*x)+(y*y)+(z*z);
;    Q=SqRoot(RQ);
; 
;    if (Q){
;    VectX=(VectX)/Q*64;
;    VectY=(VectY)/Q*64;
;    VectZ=(VectZ)/Q*64;
;    }
;
;}


;; Removes the sign and adds it back
;; for a 16-bit number stored in op1,op1+1
;; used in the above division...

unsgn
.(
    lda op1+1
    sta resgn+1
    bpl end
    jmp abs
end 
    rts
.)

resgn
.(
    lda #00 ; SMC
    bpl end
    sec
    lda #0
    sbc op1
    sta op1
    lda #0
    sbc op1+1
    sta op1+1
end
    rts
.)

;; Square of the contents of reg A. Accumulate over op1
do_square
.(
    beq end
    bpl cont
    eor #$ff
    ; Can't just add 1 as this is the HIGH byte
    ; so we may get an error of 1 unit. Who cares...
+do_square_nosign
    beq end ; Just in case... -1 ($ff) becomes $00 !
cont
    tay
    MULTAY(tmp)
    sta tmp+1
    clc
    lda tmp
    adc op1
    sta op1
    lda tmp+1
    adc op1+1
    sta op1+1

end
    rts
.)

;; Calculates the high byte of
;; the result of op2, op2+1 (a 16-bit signed number)
;; divided by Q and mutiplied by 64
;; op2/Q*64.
;; That is not the order in which it is done, or
;; floating arithmetic should be needed 
;; (results of the division are between 0 and 1)

divQ
.(
    lda #0  ; SMC
    sta op2
    lda #0
    sta op2+1

    jsr unsgn
    jsr divu	;DIVXY
    ; X low resultado, A hi resultado
            
    ; Multiplicar por 64 y quedarse con el byte alto
    ; En _VectX y poner el signo correcto en _VectX+1
    ; O sea coger el byte rotar a la dcha 2 veces y ponerlo
    ; Como byte alto. Luego arreglar el signo.
    stx tmp

    lsr
    ror tmp
    lsr
    ror tmp

    lda tmp
    sta op1+1
    lda #0
    sta op1    
    jsr resgn

    lda op1+1
    rts
.)

;; Normalize the vector, so it gets a total
;; length of 64 (more or less). It uses only
;; the higher bytes, so we must be sure of this
;; or call _norm_big.

norm
.(
    lda #0
    sta op1
    sta op1+1

    lda _VectX+1
    jsr do_square    
    lda _VectY+1
    jsr do_square
    lda _VectZ+1
    jsr do_square

    jsr SqRoot  ; Resultado en op2, listo para usarse.
    lda op2
    beq end

    sta divQ+1

    ;; OJO ESTO HAY QUE TRATARLO CON SIGNO!!!    

    lda _VectX
    sta op1
    lda _VectX+1 
    sta op1+1
    jsr divQ    
    sta _VectX+1
    lda #0
    sta _VectX

    lda _VectY
    sta op1
    lda _VectY+1 
    sta op1+1
    jsr divQ    
    sta _VectY+1
    lda #0
    sta _VectY

    lda _VectZ
    sta op1
    lda _VectZ+1 
    sta op1+1
    jsr divQ    
    sta _VectZ+1
    lda #0
    sta _VectZ
end
    rts

.)




;; Calculates the value of abs(VectX)|abs(Vecty)|abs(VectZ)
;; Stores result in op1 (16-bit)
getnorm
.(

    lda _VectX
    sta op1
    lda _VectX+1
    sta op1+1
    jsr abs
    
    lda op1
    sta tmp
    lda op1+1
    sta tmp+1

    lda _VectY
    sta op1
    lda _VectY+1
    sta op1+1
    jsr abs
    
    lda op1
    ora tmp
    sta tmp
    lda op1+1
    ora tmp+1
    sta tmp+1

    lda _VectZ
    sta op1
    lda _VectZ+1
    sta op1+1
    jsr abs
    
    lda op1
    ora tmp
    sta tmp
    lda op1+1
    ora tmp+1
    sta tmp+1

    lda tmp
    sta op1
    lda tmp+1
    sta op1+1

    rts

.)

;; Normalize the vector to length 64, but
;; being sure it is large enough as to use higher
;; bytes...

_norm_big
.(
    jsr getnorm ; Result in op1
 
   ; This makes no sense, just some deffensive programming
    lda op1
    ora op1+1
    bne nozero
    inc op1
nozero

    lda #>$2000
    sta op2+1
    lda #<$2000  
    sta op2
    ;jsr cmp16
    lda op1 ; op1-op2
    cmp op2
    lda op1+1
    sbc op2+1

    bcs finloop    
    
    lda #>$4000
    sta op2+1
    ; Low byte is already 00

loopw
    asl _VectX
    rol _VectX+1
    asl _VectY
    rol _VectY+1
    asl _VectZ
    rol _VectZ+1
    asl op1
    rol op1+1
    
    ;jsr cmp16
    lda op1 ; op1-op2
    cmp op2
    lda op1+1
    sbc op2+1


    bcc loopw

finloop

    lda _VectX+1
    cmp #$80
    ror _VectX+1
    ror _VectX    

    lda _VectY+1
    cmp #$80
    ror _VectY+1
    ror _VectY   

    lda _VectZ+1
    cmp #$80
    ror _VectZ+1
    ror _VectZ    

    jsr norm

    lda _VectX+1
    sta _VectX
    sec
    bpl n1
    clc
n1
    lda #0
    sbc #0
    sta _VectX+1

    lda _VectY+1
    sta _VectY
    sec
    bpl n2
    clc
n2
    lda #0
    sbc #0
    sta _VectY+1

    lda _VectZ+1
    sta _VectZ
    sec
    bpl n3
    clc
n3
    lda #0
    sbc #0
    sta _VectZ+1

end
    rts


.)


;; Calculates the dot product between vectors specified in
;; <VX,VY,VZ> and <VectX,VectY,VectZ>, BUT considering both
;; of coordinates of 8-bit maximum, despite the fact that
;; VectX etc. are 16-bit, so they should be normalized first...
;; the operation is VX*VectX+VY*VectY+VZ*VectZ

;; This helper calculates Vx*Vectx, being x=X,Y or Z and considering
;; them as being 8-bit. The component number is passed in reg X (0,1 or 2 for 
;; X, Y or Z). Result is _added_ to op1,op1+1.
#define savsign tmp
dotpcomp
.(  
    ; First unsign each component
    lda #0
    sta savsign

    lda _VX,x
    beq end ; zero result
    bpl nothing
    eor savsign
    sta savsign
    sec
    lda #0
    sbc _VX,x
nothing
    tay ; Save a for multiplication

    txa
    asl ; Vectx are 16-bit
    tax
    lda _VectX,x ; Get only lower byte (assumed high=0)
    beq end ; zero result
    bpl nothing2
    eor savsign
    sta savsign
    sec
    lda #0
    sbc _VectX,x
nothing2        
    MULTAY(op2)
    sta op2+1

    ;; Resign result
    lda savsign
    bpl nothing3
    sec
    lda #0
    sbc op2
    sta op2
    lda #0
    sbc op2+1
    sta op2+1

nothing3
    ;; Add result to op1
    lda op1
    clc
    adc op2
    sta op1
    lda op1+1
    adc op2+1
    sta op1+1
end
    rts


.)

dot_product
.(
    ; Prepare result. Initialize at 0
    lda #0
    sta op1
    sta op1+1   
    ldx #0
    jsr dotpcomp
    ldx #1
    jsr dotpcomp
    ldx #2
    jmp dotpcomp ; This is jsr/rts

.)








