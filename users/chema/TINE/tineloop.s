; main loop and other high-level functions

#include "ships.h"
#include "params.h"
#include "tine.h"
#include "main.h"

invert .byt 00
frame_time .byt 00


// select where the space for object records starts...
#define OBS ($fffa-MAXOBJS*ObjSize)
#echo Object records start at
#print OBS
#echo

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
	ldx #(_default_commander_end - _default_commander)-1
loop
	lda _default_commander,x
	sta _name,x
	dex
	bpl loop

	ldx #7
	stx _dest_num

	rts
.)

init_view_ship
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
	lda #<4100
	sta _PosZ
	lda #>4100
	sta _PosZ+1
	jsr _gen_rnd_number
	and #%1111
	clc
	adc #15
	sta shiptype+1
	jsr AddSpaceObject
	lda #$60
	sta screen
	lda #$a0
	sta screen+1
shiptype
	ldx #0 ; SMC
	jmp name_ship
.)

init_intro
.(
	jsr _DoubleBuffOff
	jsr clr_hires
	jsr load_frame
	jsr set_ink2
	jsr _DoubleBuffOn
	jmp init_view_ship
.)

animate
.(
    ldx #0
	stx frame_time
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

	inc frame_number

	lda frame_number
	cmp #30
	bcs nonearer
	ldx #0
	jsr SetCurOb
	lda #32
	jmp MoveForwards
nonearer
	cmp #(30+150)
	bcc keep
	cmp #(30+150+30)
	bcc further
	lda #0
	sta frame_number
	jmp init_view_ship
further
	ldx #0
	jsr SetCurOb
	lda #$e0
	jmp MoveForwards

keep
	rts
.)

end_intro
.(
	lda #0
	sta message_delay
	jsr _DoubleBuffOff
	; KLUDGE
	lda #0
    sta RADOBJ+1
    jsr save_frame
	jmp _EmptyObj3D
.)

/*
_init_screen
.(
	ldx #2
	jsr flight_message
	jsr init_intro

	lda #0
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
	;jsr SndPic
	jsr NewPlayerShip
	jsr InitPlayerShip
	jmp end_intro

.)

*/

_init_screen2
.(

  	jsr LoadDefaultCommander
	jsr NewPlayerShip
	;jsr InitPlayerShip

	ldx #3
	jsr flight_message

	jsr init_intro

	lda #0
	sta frame_number
loop
	jsr animate
	; Check keyboard press
	jsr ReadKeyNoBounce
	cmp #" "  
	bne loop
	;jsr SndPic
	jmp end_intro
.)



init_front_view
.(
	lda #0
	sta yawing
	sta pitching
	sta rolling

	jsr patch_invert_code

	jsr clr_hires
	jsr load_frame

	jsr set_ink2

+_patch_launch_msg
	lda #0			;SMC
	bne nomsg

	ldx #6*8
	ldy #40
	jsr gotoXY
	ldx #>str_launch
	lda #<str_launch
	jsr print
	jsr wait
nomsg
	lda #1
	sta _patch_launch_msg+1

	jsr _DoubleBuffOn

	;jmp _FirstFrame	; Let the program flow...
.)
_FirstFrame
.(
	jsr update_all_controls

    lda #PDIST_MASSLOCK
    sta _planet_dist

	lda #0
	sta frame_time
	sta counter

    jsr clr_hires2

	lda invert
	beq noinvert
	jsr invertZ
noinvert

    ldx VOB          ;Calculate view
    jsr SetRadar
    jsr CalcView
    jsr SortVis      ;Sort objects
    jsr DrawAllVis   ;Draw objects
    jsr DrawRadar
    jsr set_compass
	jsr set_planet_distance

	lda invert
	beq noinvert2
	jsr invertZ
noinvert2

	jsr PatchLaserDraw
    jmp dump_buf
.)


frame_number .byt 0
player_in_control .byt $0
escape_pod_launched .byt 0
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


set_planet_distance
.(
	; Check distance to planet
    ldx VOB
    jsr SetCurOb
	ldx #2	;Planet
	jsr substract_positions
	jsr getnorm	; Calc distance as A=abs(x)|abs(y)|abs(z)
	lda op1+1	; Get high byte
	sta _planet_dist
	rts
.)


wait
.(
	lda #0
	sta counter
loop
	lda counter
	cmp #25
	bcc loop
	rts
.)

dock
.(
	; Docking ship... must call docking sequence
	lda _current_screen
	cmp #SCR_FRONT
	beq l1
	jsr frontview
l1
    jsr _DoubleBuffOff
    jsr save_frame
    dec _docked

	ldx #6*8;12
	ldy #40
	jsr gotoXY
	ldx #>str_land
	lda #<str_land
	jsr print
	; This prints the wrong name... the destination hypersystem
;	jsr gs_planet_name
	jsr wait
	jsr wait
    jsr info
    jmp _TineLoop
.)

_TineLoop
.(
    lda _docked
    beq loop
    jsr ProcessKeyboard
    jmp _TineLoop

loop
	; Clear vertices where lasers start/end in each object
	ldx NUMOBJS 
	lda #0
loopcl
	sta _vertexXLO-1,x
	sta _vertexXHI-1,x
	sta _vertexYLO-1,x
	sta _vertexYHI-1,x
	dex
+fixed_objects
	cpx #3	; SMC
	bne loopcl

	; If we have changed ink color, put it back to white
+_patch_set_ink
	nop
	nop
	nop

	; Call ship tactics
    jsr _Tactics
 
	; If distance with planet is short, then dock player
    lda _planet_dist
    cmp #06
    bcc dock    

    ; Process user's controls
    jsr ProcessKeyboard

	; Trick to invert object's Z in case of rear view
+_patch_invertZa
	jsr invertZ

	; Set the radar
    ldx VOB
    jsr SetCurOb
    jsr SetRadar

	; Calculate visible ships
    jsr CalcView
    jsr SortVis   

	; If not in front view, don't draw
    lda _current_screen
    cmp #SCR_FRONT
    bne nodraw

	; Prepare counter for frame time and get last value
	lda counter
	sta frame_time
	ldx #0
	stx counter

	; If too high, skip frame
	cmp #MAXFRAMETIME2
	bcs nodraw

	; Move the stars, only if we are drawing, as they are fake
    jsr move_stars

;****** START OF DRAWING SECTION ******

	; Clear the off-screen buffer
	jsr clr_hires2

	; Draw all objects
    jsr DrawAllVis   

	; Plot the starfield, the crosshair and any lasers (ours and from others)
    jsr PlotStars
	jsr _DrawCrosshair
	jsr _Lasers
	
+_patch_laser_fired
	nop
	nop
	nop

	; Print any HUD message
	lda message_delay
	beq nomessage
	dec message_delay
	jsr print_inflight_message
nomessage

#ifdef DBGVALUES
	jsr print_dbgval
#endif

	; Print either front or rear view message on top
	; This should be in a subroutine to keep code structured,
	; but...
	dec print2dbuffer
	ldx #(15*6)
	ldy #0
	jsr gotoXY

+_patch_invert_msg	
    lda #<str_frontview
    ldx #>str_frontview

    jsr print
	inc print2dbuffer

	; Everything drawn, now dump the buffer
    jsr dump_buf

;****** END OF DRAWING SECTION ******

; Here we update radar and compass. This is outside the drawing section
; because we are not double buffering, but if we are not drawing we should not 
; update these also

	lda frame_number
	lsr
	bcc nodraw

    ; Erase & Draw radar
    jsr EraseRadar   
    jsr DrawRadar

	; Update compass
	lda _planet_dist
	cmp #PDIST_TOOFAR2
	bcs nocompass
    jsr update_compass
	jmp endcompass
nocompass
	jsr clear_compass
endcompass


; If not drawing (screens different than front/rear views, or frame skipping)
; jump here.

nodraw
	; Trick to invert object's Z in case of rear view
+_patch_invertZb
	jsr invertZ

	; If player is in control, check collisions
	lda player_in_control
	beq cont
    jsr _CheckHits  ; Should be called after DrawAllVis!!!!

	; Dampen rotations
    jsr damp   
	lda #0
	sta yawing
	sta pitching
	sta rolling

	; If in front view, perform rolls
	lda _current_screen
	cmp #SCR_FRONT
	bne cont
    jsr dorolls
cont

	; Move other ships
    jsr _MoveShips

	; Perform timely checks
	; Seldom checks. Every 32 frames
	
	lda frame_number
	and #%11111
	bne qchecks
	lda message_delay
	bne noenmsg

	; "Energy Low" message
	lda _energy+1
	cmp #30
	bcs noenmsg
	ldx #STR_ENERGY_LOW
	jsr flight_message
noenmsg

	lda bounty_am
	ora bounty_am+1
	beq nomsgbounty
	jsr flight_message_bounty 
	lda #0
	sta bounty_am
	sta bounty_am+1
nomsgbounty

qchecks
	; More often checks. Every 8 frames, basically
	lda frame_number
	and #%111
	beq checkthings
	jmp cont2

checkthings
	; Check escape pod
	lda escape_pod_launched
	beq next

	lda player_in_control
	ora message_delay
	bne next

	dec player_in_control
	inc escape_pod_launched
	jmp dock
next

	; Calculate planet distance
	jsr set_planet_distance

	; Setup planet distance light indicator
	jsr planet_light
	
	; Start with energy and shields: recharge
	lda _energy+1
	bmi no_energy
	beq no_energy

	cmp _p_maxenergy
	bcs noinc_energy
	inc _energy+1
	;bne done_energy ; branches allways
noinc_energy
	; If redirecting power to lasers, don't recharge
	lda _ptla
	bne done_energy

	lda _front_shield
	cmp #22
	beq done_front
	inc _front_shield
	cmp #21
	beq done_front
	; If redirecting power to shields, double recharge
	lda _ptsh
	beq done_front
	inc _front_shield
done_front
	lda _rear_shield
	cmp #22
	beq done_rear
	inc _rear_shield
	cmp #21
	beq done_rear
	; If redirecting power to shields, double recharge
	lda _ptsh
	beq done_rear
	inc _rear_shield
done_rear
	jsr update_shields_panel
done_energy
	jmp locking
no_energy

	; We should be dead here 

	; Check message has been displayed for some time
	; and that we are not in control of the ship
	lda message_delay
	ora player_in_control
	bne locking

	; Return from main loop here. 
	rts	


locking	
	; Locking computer
	lda player_in_control
	beq notarget
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

	; Cooling lasers. If redirecting power to shields, don't cool
	lda _ptsh
	bne notemp
	ldx LaserTemperature
	beq notemp
	dex
	beq nodoubl
	; If redirecting power to laser cooling, double cooling
	lda _ptla
	beq nodoubl
	dex
nodoubl
	stx LaserTemperature
donelaser
	jsr update_temperature_panel
notemp
	lda _ecm_counter
	beq noecm
	dec _ecm_counter
	bne noecm
	jsr update_ecm_panel
noecm

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

	; Update everything that needs be
	jsr update_speed_panel
	jsr update_energy_panel
nofr
    jmp loop

.)

str_rearview
.asc "Rear  View"
.byt 0

str_frontview
.asc "Front View"
.byt 0


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

#ifdef 0
	; Debug our energy value
	;lda _energy+1
	;sta dbg1
	;lda #0
	;sta dbg1+1

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
#endif
	lda frame_time
	sta op2
	lda #0
	sta op2+1
	ldx #0
	ldy #0
	jsr gotoXY
	ldx #5
	jsr print_num_tab	
#ifdef 0
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
#endif
	inc print2dbuffer

end
	rts
.)
#endif

;; Now the keyboard map table
#define MAX_KEY 23+5
user_keys
    .byt     "2", "3", "4", "5", "6", "7", "0", "R", "H", "J", "1"
    .byt     "S",      "X",       "N",     "M",      "A", "T", "F", "U", "E", "P", "B", "V", $1b
	.byt	 1,2,3,4,13	 
key_routh
    .byt >(info), >(sysinfo), >(short_chart), >(gal_chart), >(market), >(equip), >(loadsave), >(splanet), >(galhyper), >(jumphyper), >(frontview)    
    .byt >(keydn), >(keyup), >(keyl), >(keyr), >(sele), >(target), >(fireM), >(unarm), >(ecm_on), >(power_redir), >(energy_bomb), >(rearview), >(launch_pod)
	.byt >(keydn), >(keyl), >(keyup), >(keyr), >(sele)
key_routl
    .byt <(info), <(sysinfo), <(short_chart), <(gal_chart), <(market), <(equip), <(loadsave), <(splanet), <(galhyper), <(jumphyper), <(frontview)     
    .byt <(keydn), <(keyup), <(keyl), <(keyr), <(sele), <(target), <(fireM), <(unarm), <(ecm_on), <(power_redir), <(energy_bomb), <(rearview), <(launch_pod)
	.byt <(keydn), <(keyl), <(keyup), <(keyr), <(sele)


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
	sta _smc_rout+1
	lda tab_ship_control_routh,x
	sta _smc_rout+2
_smc_rout
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
        beq found
        dex
        bpl loop
		bmi end

found
        lda key_routl,x
        sta _smc_routine+1
        lda key_routh,x
        sta _smc_routine+2   

cont
        cpx #8  
        bcs skip
                
        ; No market or equip or save if not docked
        lda _docked
        bne isdock
        cpx #4
        beq end
        cpx #5 
        beq end 
		cpx #6
		beq end
		; No planet search either
		;cpx #7
		;beq end
		
isdock
        lda double_buff
        beq skip
        stx savx+1
        jsr _DoubleBuffOff
        jsr save_frame
savx
        ldx #0 ; SMC
         
skip
 
_smc_routine
		; Call the routine
        jsr $1234   ; SMC                

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


; KEEP CONSECUTIVE
a_y .byt 0
a_p .byt 0
a_r .byt 0

; KEEP CONSECUTIVE
yawing .byt 0
pitching .byt 0
rolling .byt 0

#define MAXR 8 
#define MINR $f8 


ParamInc
.(     
	lda a_y,x
	bpl doinc
	lda #0
	sta a_y,x
	beq end
doinc
    inc a_y,x
    lda #MAXR
    cmp a_y,x
    bpl end
    sta a_y,x
end
	lda #1
	sta yawing,x
    rts
.)

ParamDec
.(     
	lda a_y,x
	bmi doinc
	beq doinc
	lda #0
	sta a_y,x
	beq end
doinc
    dec a_y,x
    lda #MINR
    cmp a_y,x
    bmi end
    sta a_y,x
end
	lda #1
	sta yawing,x
    rts
.)

yawr
.( 
	ldx #0
	jmp ParamInc
.)
yawl     
.(
	ldx #0
	jmp ParamDec
.)
pitchdn
.(
   	ldx #1
	jmp ParamDec
.)
pitchup  
.(
  	ldx #1
	jmp ParamInc
.)
rolll
.(  
    ldx #2
	jmp ParamDec
.)
rollr
.(
  	ldx #2
	jmp ParamInc
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
.(
		lda _missiles_left
		beq no_arm
		lda _missile_armed
		bne no_arm
		; Arm missile and start target procedure
		;jsr SndBell1
		jsr SndPoc
		ldx #STR_TARGET_ARMED
		jsr flight_message
		dec _missile_armed	; This sets it to $ff
		jsr update_missile_panel
no_arm
		rts
.)
unarm
.(
		; This could simply set it to 0
		; and save memory and CPU, but as it also may
		; produce some sfx and panel changes, it may be worth a check
		lda _missile_armed
		beq no_unarm
		jsr SndPocLow
		ldx #STR_TARGET_UNARMED
		jsr flight_message
		lda #UNARMED		; Set it to 0
		sta _missile_armed
		jsr update_missile_panel
no_unarm
		rts
.)
fireM   
.(
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
		jsr SndMissile
		beq nolock
		dec _missiles_left
		jmp update_missile_panel
nolock
        rts
.)
fireL   
.(
		lda invert
		beq dofire
		rts
dofire
		jmp FireLaser
.)        

energy_bomb
.(
		; Player launches energy bomb
		; Check if equipped
		lda _equip
		and #%100000
		bne equipped 
dorts
		rts		

equipped
		; It needs energy
		lda _energy+1
		cmp #21+5 ; Some securiy margin
		bcc dorts
		sec
		sbc #20
		sta _energy+1
		; Remove equip
		lda _equip
		and #%11011111
		sta _equip

		; Activate bomb

		ldx #2  ; 0 and 1 are radar and player
		jsr SetCurOb

	    jsr GetNextOb
		cpx #0
		beq end
loop
	    sta POINT        ;Object pointer
	    sty POINT+1
	
	    ; Get ship ID byte...
	    ldy #ObjID
	    lda (POINT),y

		and #%01111111
		beq next ; a planet, as sun or a moon
		
		cmp #SHIP_CONSTRICTOR
		beq next
		cmp #SHIP_COUGAR
		beq next

		; Ok, not protected, so make it explode, if it is not
		; already exploding, hyperspacing or docking
		lda _flags,x
		and #(IS_EXPLODING|IS_HYPERSPACING|IS_DOCKING)
		bne next
	
	    lda _flags,x
	    and #%11110000  ; Remove older flags...
	    ora #IS_EXPLODING
	    sta _flags,x
	    lda #0
	    sta _ttl,x
next
	    jsr GetNextOb
	    cpx #0
	    bne loop
end
		rts
.)



ecm_on
.(
		; player sets ECM on.
		; Check if he has ECM equipped
		lda _equip
		and #%10000
		beq noecm
		; It needs energy
		lda _energy+1
		cmp #6+2 ; Some security margin
		bcc noecm
		sec
		sbc #5
		sta _energy+1
		jmp SetECMOn
noecm
		rts
.)
; P
power_redir
.(
		jsr SndPic
		lda _ptla
		beq step2
		lda #0
		sta _ptla
		lda #1
		sta _ptsh
		jmp update_redirection
step2
		lda _ptsh
		beq step3
		lda #0
		sta _ptsh
		jmp update_redirection
step3
		lda #0
		sta _ptsh
		lda #1
		sta _ptla
		jmp update_redirection
.)
;V
rearview
.(
        lda #SCR_FRONT
        cmp _current_screen
        beq lookrear
		rts
lookrear
		lda invert
		eor #$ff
		sta invert

		jsr patch_invert_code
		jsr update_compass
		jmp INITSTAR
.)

;H
galhyper
.(
        lda #SCR_FRONT
        cmp _current_screen
        bne global_end
		lda invert
		bne global_end
		
		; Test if we have the Galactic Hyperspace equipped
		lda _equip
		and #%10000000
		beq global_end

 		; If too close to planet cannot jump
		lda _planet_dist
		cmp #PDIST_MASSLOCK
		bcs canjump
		ldx #STR_MASS_LOCKED
		jmp flight_message
canjump
		; Should start sequence, but not perform the jump right now... 
		jsr init_hyper_seq
		bcc dojump
		ldx #STR_PATH_LOCKED
		jmp flight_message

dojump
		; Remove Galactic Hyperspace
		lda _equip
		and #%01111111
		sta _equip
		jmp do_galjump
+global_end
		rts
.)

;J
jumphyper
.(
		lda #SCR_FRONT
        cmp _current_screen
        bne global_end

		lda invert
		bne global_end

		; Compare current_planet with dest_planet too see if it is a "bad jump"
		; and simply ignore
        lda _dest_num
        cmp _currentplanet
        bne good
        rts
good
		; Compare distance and check it is not a "hyperspace range?"
		; 16-bit unsigned comparison... inlined
		lda _fuel ; op1-op2
	    cmp _dest_dist
		lda #0
		sbc _dest_dist+1
.(
	    bvc ret ; N eor V
	    eor #$80
ret
.)
		bcs endjump
		; Cannot jump
		ldx #STR_HYPRANGE
		jmp flight_message

endjump
		; If too close to planet cannot jump
		lda _planet_dist
		cmp #PDIST_MASSLOCK
		bcs canjump
		ldx #STR_MASS_LOCKED
		jmp flight_message
canjump
		; Should start sequence, but not perform the jump right now... 
		jsr init_hyper_seq
		bcc dojump
		ldx #STR_PATH_LOCKED
		jmp flight_message

dojump
		jmp do_jump
.)		
;1
frontview
.(
        lda #SCR_FRONT
        cmp _current_screen
        beq nothing
        sta _current_screen

        lda _docked
        beq notdocked 
		lda #0
		sta invert

        ; Exit to space...
		jsr CreateEnvironment
        ; We update the _docked variable AFTER CreateEnvironment, so it can be used
        ; to decide if we are exitting hyper or leaving planet.
        inc _docked     ; docked is either ff or 0, this gets it back to 0,
		lda #0
		sta _patch_launch_msg+1

#ifdef RAMSAVE
		ldx #(__commander_data_end-__commander_data_start)-1
loop
		lda __commander_data_start,x
		sta _default_commander,x
		dex
		bpl loop
#endif

notdocked
		jmp init_front_view	; This is jsr/rts
nothing
        rts
.)
;2
info
.(    
	jsr SndPic
    lda #SCR_INFO
    sta _current_screen
    jmp _displayinfo
.)
;3
sysinfo
.(    
	jsr SndPic
    lda #SCR_SYSTEM
    sta _current_screen
    jmp _printsystem
.)
;4
short_chart
.(
	jsr SndPic
    lda #SCR_CHART
    sta _current_screen
    jmp _plot_chart
.)
;5
gal_chart
.(
	jsr SndPic
    lda #SCR_GALAXY
    sta _current_screen
    jmp _plot_galaxy
.)
;6
market
.(
	jsr SndPic
    lda #SCR_MARKET
    sta _current_screen
    jmp _displaymarket
.)
;7
equip
.(
	jsr SndPic
    lda #SCR_EQUIP
    sta _current_screen
    jmp _displayequip
.)
;0
loadsave
.(
	jsr SndPic
	lda #SCR_LOADSAVE
	sta _current_screen
	jmp _displayloadsave
.)
;R
splanet
.(
	jsr SndPic
    lda _current_screen
    cmp #SCR_GALAXY
    beq doit
;    cmp #SCR_CHART
;    beq doit
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
.)

launch_pod
.(
    lda #SCR_FRONT
    cmp _current_screen
    beq doit1
ret
	rts
doit1

	; Look front
	lda invert
	beq nothing2
	eor #$ff
	sta invert
	jsr update_compass
	jsr INITSTAR
nothing2	
	lda _equip
	and #%100 ; Escape Pod
	beq ret

    inc player_in_control
	dec escape_pod_launched

	; Clear legal status
	lda #0
	sta _legal_status

	; Empty player's cargo
	ldx #16
	lda #0
loop
	sta _shipshold,x
	dex
	bpl loop

	lda #20
	sta _holdspace

	; Empty equipment
	lda #01
	sta _equip
	lda #00
	sta _equip+1
/*	
	lda _equip
	and #%10 ; Large cargo bay
	beq nocargo
	lda _holdspace
	clc
	adc #10
	sta _holdspace
nocargo
*/
	; clears hyperspace destination
	lda _currentplanet
    sta _dest_num
    jsr _infoplanet
    jsr _makesystem

	; Launch us
	ldx #1
    jsr SetCurOb
    lda #DEBRIS	; Anything would do...
    jsr LaunchShipFromOther
    ; Set it as view object
    stx VOB
	lda #0
	sta _speed,x

    ; Push it a bit
    jsr SetCurOb
	lda #10
	jsr MoveSide

	; Inform player
	ldx #STR_PODLAUNCHED
	jmp flight_message 
.)

;;;; END OF TABLE



do_jump
.(
		; Remove fuel
		lda _fuel
		sec
		sbc _dest_dist
		sta _fuel
		lda _fuel+1
		sbc _dest_dist+1
		sta _fuel+1
		
		; Perform the jumping
+tailjump
        jsr _jump
		; Clear legal status a bit
		lda _legal_status
		lsr
		sta _legal_status
		; Erase radar and compass and create environment
        jsr EraseRadar
        jsr clear_compass
        jsr CreateEnvironment
		; Draw first frame
        jmp _FirstFrame
        ;rts
.)

do_galjump
.(
	jsr _enter_next_galaxy
	lda #0
	sta _legal_status
	jmp tailjump
.)

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
    cmp #SCR_LOADSAVE
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
	cmp #SCR_LOADSAVE
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
	cmp #SCR_LOADSAVE
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
    beq bequip
	cmp #SCR_LOADSAVE
	bne ret
	; Jump to load/save
	jmp do_loadsave
bequip
    ; Jump to acquire equipment
	jmp buy_equip
ret
    rts
doit2
    jmp _find_planet
.)


#ifdef TABBEDROLLS
tab_rolls_fast .byt 0,1,1,1,2,2,3,4,6
tab_rolls_slow .byt 0,1,1,1,1,2,2,2,3

tab_rolls .byt 0,1,1,1,2,2,3,4,6
dorolls
.(
.(
        ; Transform a_whatever in rot_whatever
        lda a_y
        bpl notneg
        lda #0
        sec
        sbc a_y
		tax
		lda tab_rolls,x
        ora #%10000000
		bmi store
notneg
		tax
		lda tab_rolls,x

store
        sta _roty+1
.)

.(
        ; Transform a_whatever in rot_whatever
        lda a_p
        bpl notneg
        lda #0
        sec
        sbc a_p
		tax
		lda tab_rolls,x
        ora #%10000000
		bmi store
notneg
		tax
		lda tab_rolls,x
store
        sta _rotx+1
.)

.(
        ; Transform a_whatever in rot_whatever
        lda a_r
        bpl notneg
        lda #0
        sec
        sbc a_r
		tax
		lda tab_rolls,x
        ora #%10000000
		bmi store
notneg
		tax
		lda tab_rolls,x
store
        sta _rotz+1
.)

    rts
.)

#else
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
		bmi store
notneg
store
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
		bmi store
notneg
store
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
		bmi store
notneg
store
        sta _rotz+1
.)

    rts
.)



#endif



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
	ldx #2
loop
	lda yawing,x
	bne end
    lda a_y,x
    bmi neg
    beq end
    dec a_y,x
    bpl end
neg
    inc a_y,x
end
	dex
	bpl loop
	rts
.)



init_hyper_seq
.(

	; Check if path is locked (collision danger)
    jsr FindTarget
    lda _ID
	beq pathfree

	; path is locked!
	;return with C=1
	sec
	rts

pathfree

    lda #20
	sta co
loop
	ldx #1
	jsr SetCurOb
	lda #50
	jsr MoveForwards

	ldx #1
    jsr CalcView
    jsr SortVis   
    ;jsr clr_hires2
    jsr DrawAllVis   ;Draw objects

	lda #20
    sta g_theta
	jsr move_stars    
    jsr PlotStars
	;jsr _DrawCrosshair

	jsr dump_buf

	dec co
	bne loop

	; Return with C=0 to continue jump
	clc	
	rts

co .byt $00
.)


ViewPlayerShip
.(
	; Look front
	lda invert
	beq nothing2
	eor #$ff
	sta invert
	jsr update_compass
	jsr INITSTAR
nothing2

   ; Make it still
    lda #0
    sta _speed+1 
    sta _rotx+1
    sta _roty+1
    sta _rotz+1   
    sta _accel+1
    sta a_y
    sta a_p
    sta a_r
	lda #$ff
	sta _energy+1
    lda _flags+1
    and #%11110000  ; Remove older flags...
    ora #IS_EXPLODING
    sta _flags+1

    ; Delay explosion a bit
    lda #3
    sta _ttl+1
    
	ldx #1
    jsr SetCurOb
    lda #DEBRIS	; Anything would do...
    jsr LaunchShipFromOther

    ; Set it as view object
    stx VOB

	; make it rotate and move
	;lda #4
	;sta _rotz,x
	;lda #2
	;sta _speed,x
	
    ; Push it a bit
    jsr SetCurOb
    lda #$9c     ; -100
    jmp MoveForwards
	;rts
.)




patch_invert_code
.(
	lda invert
	beq setnops
	; Some code patches
	lda #$20	; jsr opcode
	sta _patch_invertZa
	sta _patch_invertZb
	lda	#<invertZ
	sta	_patch_invertZa+1
	sta	_patch_invertZb+1
	lda	#>invertZ
	sta	_patch_invertZa+2
	sta	_patch_invertZb+2

	lda #<str_rearview
	ldx #>str_rearview
	jmp end
setnops
	lda #$ea	; nop opcode
	ldx #2
loop
	sta _patch_invertZa,x
	sta _patch_invertZb,x
	dex
	bpl loop

	lda #<str_frontview
	ldx #>str_frontview
end
	; Patch front/rear view message
	sta _patch_invert_msg+1
	stx _patch_invert_msg+3
	rts
.)

PatchLaserDraw
.(
  	; Pacth main loop code
	lda #$ea	; nop opcode
	sta _patch_laser_fired
	sta _patch_laser_fired+1
	sta _patch_laser_fired+2
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
    .byt DEBRIS	;Debris object
    .byt 1		;Number of points
    .byt 1		;Number of faces
	.byt 0,0,0  ;Normal (unused)
; Point list
    .byt 0
    .byt 0
    .byt 0
; Face list
    .byt 1		;Number of vertices
    .byt 0      ;Fill pattern
    .byt 0      ;Vertices


ONEPLANET
    .byt PLANET	;Sun or planet Object
    .byt 1      ;Number of points
    .byt 1      ;Number of faces
    .byt 0,0,0	;Normal (unused)
; Point list
    .byt 0
    .byt 0
    .byt 0
; Face list
    .byt 1      ;Number of vertices
    .byt SOLID	;Fill pattern
    .byt 0      ;Vertices

ONEMOON
    .byt MOON   ;Moon Object
    .byt 1      ;Number of points
    .byt 1      ;Number of faces
	.byt 0,0,0	;Normal (unused)
; Point list
    .byt 0
    .byt 0
    .byt 0
; Face list
    .byt 1		;Number of vertices
    .byt SOLID  ;Fill pattern
    .byt 0      ;Vertices




