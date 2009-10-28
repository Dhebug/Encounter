; Test code for TINE

#include "ships.h"
#include "params.h"
#include "tine.h"
#include "main.h"


#define OBS  osdk_end


invert .byt 00

_init_tine
.(

    lda #<OBS        ;Object records
    ldy #>OBS
    jsr Init3D

    jsr INITSTAR
    jmp _GenerateTables ;; /* For Wireframe*/

.)


LoadDefaultCommander
.(
	ldx #(_default_commander_end - _default_commander)
loop
	lda _default_commander,x
	sta _name,x
	dex
	bne loop

	ldx #7
	stx _dest_num

	rts
.)


init_intro
.(
	jsr _EmptyObj3D
	; Create our ship
    lda #0
    sta _PosX
    sta _PosX+1
    sta _PosY
    sta _PosY+1
    sta _PosZ
    sta _PosZ+1
    lda #<_PosX
    sta tmp0
    lda #>_PosX   
    sta tmp0+1
 	lda #SHIP_DEBRIS ;)
    jsr AddSpaceObject

	; Create the ship to watch	
	lda #<1300
	sta _PosZ
	lda #>1300
	sta _PosZ+1
	jsr _gen_rnd_number
	and #%1111
	clc
	adc #15
	;lda #SHIP_COBRA3
	jsr AddSpaceObject

	; initialize front view
	jsr _DoubleBuffOff
	jsr clr_hires
	jsr load_frame
	jmp _DoubleBuffOn
.)

animate
.(
    ldx #0
    jsr CalcView
    jsr SortVis   
    jsr clr_hires2
    jsr DrawAllVis   ;Draw objects
	jsr print_inflight_message
    jsr dump_buf

	ldx #1
	jsr SetCurOb
    sec
    jsr Pitch
    clc
    jsr Yaw
    clc
    jsr Roll
	clc
    jsr Roll

	lda frame_number
	beq nonearer

	dec frame_number
	ldx #0
	jsr SetCurOb
	lda #8*2
	jmp MoveForwards
nonearer
	rts
.)

end_intro
.(
	lda #0
	sta message_delay
	jsr _DoubleBuffOff
    jsr save_frame
	jmp _EmptyObj3D
.)

_init_screen
.(
	ldx #2
	jsr flight_message
	jsr init_intro

	lda #15
	sta frame_number
loop
	jsr animate
	; Check keyboard press
	jsr ReadKeyNoBounce
	cmp #"Y"
	bne noY
	;jsr LoadSavedCommander
	jmp end
noY
	cmp #"N"
	bne loop
	jsr LoadDefaultCommander
end
	jsr NewPlayerShip
	jmp end_intro

.)


_init_screen2
.(
	ldx #3
	jsr flight_message

	jsr init_intro

	lda #15
	sta frame_number
loop
	jsr animate
	; Check keyboard press
	jsr ReadKeyNoBounce
	cmp #" "  
	bne loop

	jmp end_intro
.)



init_front_view
.(
	jsr clr_hires
	jsr load_frame
	jsr update_all_controls
	;jsr _DrawFrameBorder   
	jsr _DoubleBuffOn
	;jmp _FirstFrame	; Let the program flow...
.)

_FirstFrame
.(
         lda #$ff
         sta _planet_dist

         jsr clr_hires2

         LDX VOB          ;Calculate view
         jsr SetRadar
         jsr set_compass
         JSR CalcView
         JSR SortVis      ;Sort objects
         JSR DrawAllVis   ;Draw objects
        
         jsr DrawRadar

         jmp dump_buf
.)


frame_number .byt 0
player_in_control .byt $0
attr_changed .byt 0

invertZ
.(
	ldx VOB
	jsr GetObj
	clc
	adc #ObjMat
    bcc cont
    iny
cont
	sta tmp0
	sty tmp0+1

	ldy #6
	ldx #3
loop
	sec
	lda #0
	sbc (tmp0),y
	sta (tmp0),y
	iny
	dex
	bne loop

	rts
.)


_TineLoop
.(
    lda _docked
    beq loop
    jsr ProcessKeyboard
    jmp _TineLoop

loop
	lda #0
	ldx NUMOBJS
loopcl
	sta _vertexXLO-1,x
	sta _vertexXHI-1,x
	sta _vertexYLO-1,x
	sta _vertexYHI-1,x
	dex
	bne loopcl


	lda attr_changed
	beq nochange
	lda #A_FWWHITE
	jsr set_ink
	lda #0
	sta attr_changed
nochange
    jsr _Tactics
    
    lda _planet_dist
    cmp #06
    bcs nodock    

	; Docking ship... must call docking sequence
	lda _current_screen
	cmp #SCR_FRONT
	bne l1
    jsr _DoubleBuffOff
    jsr save_frame
l1
    dec _docked
    jsr info
    jmp _TineLoop
    
nodock
    ldx VOB
    jsr SetCurOb
    jsr move_stars
    jsr ProcessKeyboard

	lda invert
	beq noinvert
	jsr invertZ
noinvert

    ldx VOB
    jsr SetRadar

    jsr CalcView
    jsr SortVis   


    lda _current_screen
    cmp #SCR_FRONT
    bne nodraw
	

    jsr clr_hires2
    jsr DrawAllVis   ;Draw objects

    jsr EraseRadar   ; Erase radar
    jsr DrawRadar

	lda invert
	beq noinvert2
	jsr invertZ
noinvert2
    jsr PlotStars
	jsr _DrawCrosshair

    jsr _Lasers
    lda _laser_fired
    beq nofire
    inc _laser_fired ; Set back to 0
    jsr _DrawLaser
nofire

	lda message_delay
	beq nomessage
	dec message_delay
	jsr print_inflight_message
nomessage

#define DBGVALUES
#ifdef DBGVALUES
	jsr print_dbgval
#endif

    jsr dump_buf
    jsr update_compass
nodraw

	lda player_in_control
	beq cont
    jsr _CheckHits  ; Should be called after DrawAllVis!!!!

    jsr damp   
	lda #0
	sta yawing
	sta pitching
	sta rolling

	lda _current_screen
	cmp #SCR_FRONT
	bne cont
    jsr dorolls
cont
    jsr _MoveShips
	

	; Perform timely checks
	
    ;lda #1
    ;eor frame_number
	lda frame_number
	and #7
	bne cont2

	; Check distance to planet
    ldx VOB
    jsr SetCurOb
	ldx #2	;Planet
	jsr substract_positions
	jsr getnorm	; Calc distance as A=abs(x)|abs(y)|abs(z)
	lda op1+1	; Get high byte
	sta _planet_dist


	; Start with energy and shields

	lda _energy+1
	bmi no_energy
	cmp _p_maxenergy
	bcs noinc_energy
	inc _energy+1
	bne done_energy ; branches allways
noinc_energy
	lda _front_shield
	cmp #22
	beq done_front
	inc _front_shield
done_front
	lda _rear_shield
	cmp #22
	beq done_rear
	inc _rear_shield
done_rear
	jsr update_shields_panel
done_energy
	jmp locking
no_energy
	; We should be dead here :)

	lda message_delay
	ora player_in_control
	bne locking
	rts	

locking	
	; Locking computer
	lda _missile_armed
	bpl notarget	; Nothing to do if already locked or unarmed
    jsr FindTarget
    lda _ID
	beq notarget
	sta _missile_armed
	; Print Target Locked message
	ldx #STR_TARGET_LOCKED
	jsr flight_message 
	jsr update_missile_panel
notarget
	ldx LaserTemperature
	beq notemp
	dex
	stx LaserTemperature
	jsr update_temperature_panel
notemp

	; ...

cont2
	; Check for new encounters
	lda frame_number
	;and #%1111111
	bne cont3
	jsr random_encounter
cont3
	; Increment the counter of frames
    inc frame_number

	; Update everything that needs to be
	jsr update_speed_panel
nofr	 
    jmp loop

.)

#ifdef DBGVALUES
dbg1 .word $0000
dbg2 .word $0000
dbg3 .word $0000


// DEBUGGING

print_dbgval
.(

    lda _current_screen
    cmp #SCR_FRONT
	beq doit
    jmp end
doit
	dec print2dbuffer

	; Debug our energy value
	lda _energy+1
	sta dbg1
	lda #0
	sta dbg1+1

	; Debug a_y
	;lda a_y
	;sta dbg2
	;lda #0
	;sta dbg2+1

	; Debug ship pos
	ldx #1
	jsr GetShipPos
	ldx #5
loop
	lda _PosX,x
	sta dbg1,x
	dex
	bpl loop

	lda counter 
	sta op2
	lda #0
	sta op2+1
	ldx #0
	ldy #0
	jsr gotoXY
	ldx #5
	jsr print_num_tab	

	lda #0
	sta counter

    lda dbg1
    sta op2
    lda dbg1+1
    sta op2+1
	ldx #47
	ldy #0
	jsr gotoXY
	ldx #5
	jsr print_num_tab	

    lda dbg2
    sta op2
    lda dbg2+1
    sta op2+1
	ldx #47+48
	ldy #0
	jsr gotoXY
	ldx #5
	jsr print_num_tab	

    lda dbg3
    sta op2
    lda dbg3+1
    sta op2+1
	ldx #47+48+48
	ldy #0
	jsr gotoXY
	ldx #5
	jsr print_num_tab	


    lda _speed+1
    sta op2
    lda #0
    sta op2+1
	ldx #47+48+48+48
	ldy #0
	jsr gotoXY
	ldx #5
	jsr print_num_tab	

	inc print2dbuffer

end
	rts
.)
#endif

;; Now the keyboard map table
#define MAX_KEY 17
user_keys
    .byt     "2", "3", "4", "5", "6", "7", "R", "H", "J", "1"
    .byt     "S",      "X",       "N",     "M",      "A", "T", "F", "U"

key_routh
    .byt >(info), >(sysinfo), >(short_chart), >(gal_chart), >(market), >(equip), >(splanet), >(galhyper), >(jumphyper), >(frontview)    
    .byt >(keydn), >(keyup), >(keyl), >(keyr), >(sele), >(target), >(fireM), >(unarm) 
key_routl
    .byt <(info), <(sysinfo), <(short_chart), <(gal_chart), <(market), <(equip), <(splanet), <(galhyper), <(jumphyper), <(frontview)     
    .byt <(keydn), <(keyup), <(keyl), <(keyr), <(sele), <(target), <(fireM), <(unarm)  


/* M= byte 3 val 1
   N= byte 1 val 2
   X= byte 1 val 64
   S= byte 7 val 64
   A= byte 7 val 32
   Q= byte 2 val 64
   W= byte 7 val 128
   O= byte 6 val 4
   L= byte 8 val 2
   B= byte 3 val 4 */

#define NUM_SIM_KEYS 8
tab_ship_control_byte
	.byt 2,0,0,6,6,1,6,5,7;,2
tab_ship_control_val
	.byt 1,2,64,64,32,64,128,4,2;,4

tab_ship_control_routh
    .byt >yawr,>yawl,>pitchup,>pitchdn,>fireL,>rolll,>rollr,>accel,>deccel;,>fireM
tab_ship_control_routl
    .byt <yawr,<yawl,<pitchup,<pitchdn,<fireL,<rolll,<rollr,<accel,<deccel;,<fireM


ShipControl
.(	
    lda _current_screen
    cmp #SCR_FRONT
    bne noship
    ldx #NUM_SIM_KEYS
	bne loop	; allways branches
noship
	ldx #3
loop
	lda tab_ship_control_byte,x
	tay
	lda tab_ship_control_val,x
	and KeyBank,y
	beq skip
	stx savx+1
	lda tab_ship_control_routl,x
	sta rout+1
	lda tab_ship_control_routh,x
	sta rout+2
rout
	jsr $1234
savx
	ldx #0
skip
	dex
	bpl loop
	rts
.)


ProcessKeyboard
.(
        lda player_in_control
        beq end         

		jsr ShipControl

		lda _current_screen
		cmp #SCR_CHART
		beq cross
		cmp #SCR_GALAXY
		bne cont1
cross
		jsr MoveCross
cont1
        jsr ReadKeyNoBounce
		beq end       	


        ; Ok a key was pressed, let's check
        ldx #MAX_KEY
loop    
        cmp user_keys,x
        bne next

        lda key_routl,x
        sta routine+1
        lda key_routh,x
        sta routine+2   

cont
        cpx #7  
        bcs skip
                
        ; No market or equip if not docked
        lda _docked
        bne isdock
        cpx #4
        beq end
        cpx #5 
        beq end      
isdock
        lda double_buff
        beq skip
        stx savx+1
        jsr _DoubleBuffOff
        jsr save_frame
savx
        ldx #0 ; SMC
         
skip
 
routine
        jsr $1234   ; SMC                
		jmp end
next
        dex
        bpl loop
end

		lda _current_screen
		cmp #SCR_FRONT
		bne ret

		lda #0
		ldx #7
loopb
		sta KeyBank,x
		dex
		bpl loopb
ret
        rts
.)   



a_y .byt 0
a_p .byt 0
a_r .byt 0

yawing .byt 0
pitching .byt 0
rolling .byt 0

#define MAXR 6 ;9		;6	;3  ;4
#define MINR $fa ;$f7	;$fa; $fd    ;fc

yawr
.(     
		 lda a_y
		 bpl doinc
		 lda #0
		 sta a_y
		 beq end
doinc
         inc a_y
         lda #MAXR
         cmp a_y
         bpl end
         sta a_y
end
		 lda #1
		 sta yawing
         rts
.)
yawl     
.(
  		 lda a_y
		 bmi doinc
		 beq doinc
		 lda #0
		 sta a_y
		 beq end
doinc
         dec a_y
         lda #MINR
         cmp a_y
         bmi end
         sta a_y
end
		 lda #1
		 sta yawing
         rts
.)
pitchdn
.(  
  		 lda a_p
		 bmi doinc
		 beq doinc
		 lda #0
		 sta a_p
 		 beq end
doinc
         dec a_p
         lda #MINR
         cmp a_p
         bmi end
         sta a_p
end
		 lda #1
		 sta pitching
         rts

.)
pitchup  
.(
    	 lda a_p
		 bpl doinc
		 lda #0
		 sta a_p
		 beq end
doinc
         inc a_p
         lda #MAXR
         cmp a_p
         bpl end
         sta a_p
end
		 lda #1
		 sta pitching
         rts
.)
rolll
.(   
    	 lda a_r
		 bmi doinc
		 beq doinc
		 lda #0
		 sta a_r
		 beq end
doinc
         dec a_r
         lda #MINR
         cmp a_r
         bmi end
         sta a_r
end
		 lda #1
		 sta rolling
         rts
.)
rollr
.(   
      	 lda a_r
		 bpl doinc
		 lda #0
		 sta a_r
		 beq end
doinc
         inc a_r
         lda #MAXR
         cmp a_r
         bpl end
         sta a_r
end
		 lda #1
		 sta rolling
         rts
.)


accel
       ; Accelerate
        lda #1
       .byt $2C
deccel   
        lda #$ff
        sta _accel+1
        rts

target
		lda _missiles_left
		beq no_arm
		lda _missile_armed
		bne no_arm
		; Arm missile and start target procedure
		dec _missile_armed	; This sets it to $ff
		jsr update_missile_panel
no_arm
		rts

unarm
		; This could simply set it to 0
		; and save memory and CPU, but as it also may
		; produce some sfx and panel changes, it may be worth a check
		lda _missile_armed
		beq no_unarm
		lda #UNARMED		; Set it to 0
		sta _missile_armed
		jsr update_missile_panel
no_unarm
		rts

fireM   
		; Shoud this be defered to LaunchMissile??
		lda _missiles_left
		beq nolock
		lda _missile_armed
		beq nolock
		bmi nolock
        
		; Missile is locked, fire it
        sta AITarget
        ldx #1
        jsr SetCurOb
        jsr LaunchMissile
		beq nolock
		dec _missiles_left
		jsr update_missile_panel
nolock
        rts

fireL   jmp FireLaser
        

;H
galhyper

		lda invert
		eor #$ff
		sta invert
		rts

        lda #SCR_FRONT
        cmp _current_screen
        bne nothing
		
		; Test if we have the Galactic Hyperspace equipped

        jsr _enter_next_galaxy
        jmp endjump
;J
jumphyper
        lda #SCR_FRONT
        cmp _current_screen
        bne nothing

		; Compare current_planet with dest_planet too see if it is a "bad jump"
		; and simply ignore
        lda _dest_num
        cmp _currentplanet
        bne good
        rts
good
		; Compare distance and check it is not a "hyperspace range?"

		; Should start sequence, but not perform the jump right now... 

endjump
        jsr _jump
        jsr EraseRadar
        jsr clear_compass
        jsr CreateEnvironment
        jsr _FirstFrame
        rts

;1
frontview
        lda #SCR_FRONT
        cmp _current_screen
        beq nothing
        sta _current_screen

        lda _docked
        beq notdocked 
        ; Exit to space...
		jsr InitPlayerShip
		jsr CreateEnvironment
        ; We update the _docked variable AFTER CreateEnvironment, so it can be used
        ; to decide if we are exitting hyper or leaving planet.
        inc _docked     ; docked is either ff or 0, this gets it back to 0,
notdocked
		jmp init_front_view	; This is jsr/rts
nothing
        rts
;2
info    
    lda #SCR_INFO
    sta _current_screen
    jmp _displayinfo
;3
sysinfo    
    lda #SCR_SYSTEM
    sta _current_screen
    jmp _printsystem

;4
short_chart
    lda #SCR_CHART
    sta _current_screen
    jmp _plot_chart
;5
gal_chart
    lda #SCR_GALAXY
    sta _current_screen
    jmp _plot_galaxy

;6
market
    lda #SCR_MARKET
    sta _current_screen
    jmp _displaymarket

;7
equip
    lda #SCR_EQUIP
    sta _current_screen
    jmp _displayequip

;R
splanet
    lda _current_screen
    cmp #SCR_GALAXY
    beq doit
    cmp #SCR_CHART
    beq doit
    rts
doit
    ; ask for planet and search it
    jsr prepare_area    
    lda #(A_FWGREEN+A_FWYELLOW*16+128)
    jsr put_code
    lda #<str_searchplanet
    ldx #>str_searchplanet
    jsr print
    lda #A_FWWHITE
    jsr put_code
    jsr gets
    jmp _search_planet    ; This is jsr/rts


;;;; END OF TABLE

check_scr
.(
    lda _current_screen
    ;cmp #SCR_GALAXY
    ;beq retnz
    ;cmp #SCR_CHART
    ;beq retnz
    cmp #SCR_MARKET
    beq retz
    cmp #SCR_EQUIP
    beq retz
    sec
    rts
retz
    clc
    rts

.)

keydn
.(
    jsr check_scr
    bcc do
    rts
do
    jmp _dec_sel

.)


keyup
.(
    jsr check_scr
    bcc do
    rts
do
    jmp _inc_sel

.)


keyl
.(
    lda _current_screen
    cmp #SCR_EQUIP
    beq ret
    jsr check_scr
    bcc do
ret
    rts
do
    jmp _sell

.)


keyr
.(
    lda _current_screen
    cmp #SCR_EQUIP
    beq ret
    jsr check_scr
    bcc do
ret
    rts
do  
    jmp _buy

.)

sele
.(
    lda _current_screen
    cmp #SCR_GALAXY
    beq doit2
    cmp #SCR_CHART
    beq doit2
    cmp #SCR_EQUIP
    bne ret
    ; Jump to acquire equipment
	jmp buy_equip
ret
    rts
doit2
    jmp _find_planet
.)


dorolls
.(
.(
        ; Transform a_whatever in rot_whatever
        lda a_y
        bpl notneg
        lda #0
        sec
        sbc a_y
        ora #%10000000
notneg
        sta _roty+1
.)

.(
        ; Transform a_whatever in rot_whatever
        lda a_p
        bpl notneg
        lda #0
        sec
        sbc a_p
        ora #%10000000
notneg
        sta _rotx+1
.)

.(
        ; Transform a_whatever in rot_whatever
        lda a_r
        bpl notneg
        lda #0
        sec
        sbc a_r
        ora #%10000000
notneg
        sta _rotz+1
.)

    rts
.)




MoveCross
.(
	lda pitching
	beq next1
	lda a_p
	beq next1
	jsr _move_cross_v
	lda #0
	sta a_p
next1
	lda yawing
	beq next2
	lda a_y
	beq next2
	jsr _move_cross_h
	lda #0
	sta a_y
next2
	rts
.)



damp
.(
    ; Dampen rotations

.(
		lda yawing
		bne end
        lda a_y
        bmi neg
        beq end
        dec a_y
        bpl end
neg
        inc a_y
end
.)

.(
  		lda rolling
		bne end
        lda a_r
        bmi neg
        beq end
        dec a_r
        bpl end
neg
        inc a_r
end
.)

.(
  		lda pitching
		bne end
        lda a_p
        bmi neg
        beq end
        dec a_p
        bpl end
neg
        inc a_p
end
.)
        rts
.)



VOB      .byt 00           ;View object

;Pattern table
#define SOLID 0
#define DITHER1  1
#define DITHER2  2
#define ZIGS      3
#define ZAGS      4
#define ZIGZAG    5
#define CROSSSM   6
#define BRICK     7
#define SQUARES   8
#define INVSQ     9
#define HOLES     10
#define HSTRIPES  11
#define VSTRIPES  12



ONEDOT
    .byt DEBRIS       ;Debris object
    .byt 1            ;Number of points
    .byt 1            ;Number of faces
	.byt 0,0,0		 ;Normal (unused)

; Point list
    .byt 0
    .byt 0
    .byt 0

; Face list
    .byt 1      ;Number of vertices
    .byt 0      ;Fill pattern
    .byt 0      ;Vertices



ONEPLANET
   .byt PLANET       ;Sun or planet Object
   .byt 1            ;Number of points
   .byt 1            ;Number of faces
   .byt 0,0,0		 ;Normal (unused)
; Point list
   
    .byt 0
    .byt 0
    .byt 0

; Face list
    .byt 1            ;Number of vertices
    .byt SOLID ;5        ;Fill pattern
    .byt 0      ;Vertices

ONEMOON
    .byt MOON         ;Moon Object
    .byt 1            ;Number of points
    .byt 1            ;Number of faces
	.byt 0,0,0		 ;Normal (unused)

; Point list
    .byt 0
    .byt 0
    .byt 0

; Face list
    .byt 1            ;Number of vertices
    .byt 5        ;Fill pattern
    .byt 0      ;Vertices
