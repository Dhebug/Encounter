; Test code for TINE

#include "ships.h"
#include "params.h"
#include "tine.h"
#include "main.h"


#define OBS  osdk_end


OCEN     .word 0000            ;X-coord
         .word 0000            ;Y-coord
         .word 1300            ;Z-coord

OCEN2    .word -1000            ;X-coord
         .word 1000            ;Y-coord
         .word 1300            ;Z-coord

OCEN0   .word 0;1000
        .word 0;1000
        .word 0;2500


OCENE   .word 0
        .word 0
        .word 12200

OCENF   .word 1000
        .word 300
        .word 10000



_init_tine
.(

    lda #<OBS        ;Object records
    ldy #>OBS
    jsr Init3D

    jsr INITSTAR

#ifdef FILLEDPOLYS
    jsr _ComputeDivMod
    jmp _InitTables   ;; /* For filled polys */
#else
     jmp _GenerateTables ;; /* For Wireframe*/
#endif

.)


_InitTestCode 

         ;jsr load_frame

         jsr CreateRadar

    
         ; Add our ship

         lda #<OCEN0
         sta tmp0
         lda #>OCEN0   
         sta tmp0+1
         lda #SHIP_COBRA3
         JSR AddSpaceObject
         STX VOB          ;View object

         ; Add some ships

         lda #<OCEN
         sta tmp0
         lda #>OCEN
         sta tmp0+1   
         lda #SHIP_ADDER
         jsr AddSpaceObject   
         stx savid+1   
         lda _ai_state,x
         ora #IS_AICONTROLLED   
         sta _ai_state,x
         lda #1
         sta _speed,x
        

         lda #<OCEN2
         sta tmp0
         lda #>OCEN2
         sta tmp0+1   
         lda #SHIP_ASP
         jsr AddSpaceObject   

        ; This one will pursue the other :)
savid   lda #0  ;SMC

        ; make it angry
        ora #IS_ANGRY
        sta _target,x        
        lda _ai_state,x
        ora #IS_AICONTROLLED   
        sta _ai_state,x
        

         ;ldx VOB
        ;sta _target,x

         lda #<OCENE
         sta tmp0
         lda #>OCENE
         sta tmp0+1   

         LDA #<ONEPLANET
         LDY #>ONEPLANET
         LDX #$80   ; Non-moving object
         JSR AddSpaceObjectDirect
         lda #255
         sta _energy,x


         lda #<OCENF
         sta tmp0
         lda #>OCENF
         sta tmp0+1   

         LDA #<ONEMOON
         LDY #>ONEMOON
         LDX #$80   ; Non-moving object
         JSR AddSpaceObjectDirect
         lda #255
         sta _energy,x

;         clc              ; Wireframe mode
;         JSR SetParms
         rts



_FirstFrame
#ifndef FILLEDPOLYS
         jsr clr_hires2
#endif
         LDX VOB          ;Calculate view
         jsr SetRadar
         JSR CalcView
         JSR SortVis      ;Sort objects
         JSR DrawAllVis   ;Draw objects
        
         jsr DrawRadar


#ifdef FILLEDPOLYS
         jsr _ClearAndSwapFlag
#else
         jsr dump_buf
#endif
         rts



#define DBUG  lda #0\
        dbug  beq dbug



frame_number .byt 0
player_in_control .byt $ff

#define COUNTER $276



_TineLoop
.(
    lda _docked
    beq loop
    jsr ProcessKeyboard
    jmp _TineLoop

loop
	lda #0
	sta COUNTER
	sta COUNTER+1

    jsr _Tactics

    ldx VOB
    jsr SetCurOb
    jsr move_stars
    jsr ProcessKeyboard
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
    jsr PlotStars
    jsr _Lasers
    lda _laser_fired
    beq nofire
    inc _laser_fired ; Set back to 0
    jsr _DrawLaser
nofire
	jsr _DrawCrosshair
    jsr dump_buf

nodraw

    jsr _CheckHits  ; Should be called after DrawAllVis!!!!

#ifndef OLDROLLS
        jsr damp    
        jsr dorolls
#endif


    jsr _MoveShips
    ldx VOB
    jsr SetCurOb

    inc frame_number

    lda _current_screen
    cmp #SCR_FRONT
    bne nofr

	lda #$ff
	sec
    sbc COUNTER
	sta op2
	lda #$ff
	sbc COUNTER+1
	sta op2+1
	ldx #0
	ldy #0
	jsr gotoXY
	ldx #5
	jsr print_num_tab	
nofr	 
    jmp loop

.)




;; Now the keyboard map table
#define MAX_KEY 19
user_keys
    .byt     "2", "3", "4", "5", "6", "7", "R", "H", "J", "1"
    .byt     "O",     "L",       "B",     "Q",      "W",        "S",      "X",       "N",     "M",      "A"

key_routh
    .byt >(info), >(sysinfo), >(short_chart), >(gal_chart), >(market), >(equip), >(splanet), >(galhyper), >(jumphyper), >(frontview)    
    .byt >(accel), >(deccel), >(fireM), >(rolll), >(rollr), >(pitchdn), >(pitchup), >(yawl), >(yawr), >(fireL) 
key_routl
    .byt <(info), <(sysinfo), <(short_chart), <(gal_chart), <(market), <(equip), <(splanet), <(galhyper), <(jumphyper), <(frontview)     
    .byt <(accel), <(deccel), <(fireM), <(rolll), <(rollr), <(pitchdn), <(pitchup), <(yawl), <(yawr), <(fireL)  

alt_key_routh
    .byt >(keydn), >(keyup), >(keyl), >(keyr), >(sele) 
alt_key_routl
    .byt <(keydn), <(keyup), <(keyl), <(keyr), <(sele)  


ProcessKeyboard
.(
        lda player_in_control
        beq end         

        jsr $023B ; Get key
       	bpl return
        ; Ok a key was pressed, let's check
        ldx #MAX_KEY
loop    
        cmp user_keys,x
        bne next

        cpx #(MAX_KEY-4)
        bcc norm_key
        lda _current_screen
        cmp #SCR_FRONT
        beq norm_key

        ; Alternate direction functions
        lda alt_key_routl-(MAX_KEY-4),x
        sta routine+1
        lda alt_key_routh-(MAX_KEY-4),x
        sta routine+2   
        jmp cont    

norm_key
        lda key_routl,x
        sta routine+1
        lda key_routh,x
        sta routine+2   

cont
        cpx #8  
        bcs skip
                
        lda double_buff
        beq skip
        stx savx+1
        jsr save_frame
        jsr _DoubleBuffOff
savx
        ldx #0 ; SMC
         
skip
 
routine
        jmp $1234   ; SMC                
next
        dex
        bpl loop
return
        lda #0
        sta _accel+1

end
        rts
.)   


#ifdef OLDROLLS
yawr     
         lda #1
         .byt $2C
yawl     
         lda #$81
         sta _roty+1
         rts 

pitchdn  
         lda #$81
         .byt $2C
pitchup  
         lda #1
         sta _rotx+1
         rts 

rolll    
         lda #$81
         .byt $2C
rollr   
         lda #1
         sta _rotz+1
         rts

#else

a_y .byt 0
a_p .byt 0
a_r .byt 0

#define MAXR 3  ;4
#define MINR $fd    ;fc

yawr
.(     
         inc a_y
         inc a_y
         lda #MAXR
         cmp a_y
         bpl end
         sta a_y
end
         rts
.)
yawl     
.(
         dec a_y
         dec a_y
         lda #MINR
         cmp a_y
         bmi end
         sta a_y
end
         rts
.)
pitchdn
.(  
         dec a_p
         dec a_p
         lda #MINR
         cmp a_p
         bmi end
         sta a_p
end
         rts

.)
pitchup  
.(
         inc a_p
         inc a_p
         lda #MAXR
         cmp a_p
         bpl end
         sta a_p
end
         rts
.)
rolll
.(    
         dec a_r
         dec a_r
         lda #MINR
         cmp a_r
         bmi end
         sta a_r
end
         rts
.)
rollr
.(   
         inc a_r
         inc a_r
         lda #MAXR
         cmp a_r
         bpl end
         sta a_r
end
         rts
.)

#endif
accel   ; Accelerate
        lda #1
        .byt $2C
deccel   
        lda #$ff
        ;clc
        ;adc _accel+1
        sta _accel+1
        rts

;movf     LDA #$07+100
;         .byt $2C
;movb     LDA #$f9
;         jmp MoveForwards
;movr     LDA #$07
;         .byt $2C
;movl     LDA #$f9
;         jmp MoveSide
;movd     lda #$07
;         .byt $2c
;movu     lda #$f9
;         jmp MoveDown

fireM   
        jmp LaunchMissile
fireL   jmp FireLaser
        

;setdbg  
;        jsr save_frame
;        jmp _nospace_loop

;H
galhyper
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
		; Compare distance and check it is not a "hyperspace range?"

		; Should start sequence, but not perform the jump right now... 

endjump
        jsr _jump
        jsr EraseRadar
        jsr _EmptyObj3D
        jsr _InitTestCode
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
        inc _docked
        jsr _EmptyObj3D
        jsr _InitTestCode

        jsr clr_hires
        jsr load_frame
        jsr _DoubleBuffOn
        jsr _FirstFrame
        rts
        

notdocked
        jsr clr_hires
        jsr load_frame
        jsr _DoubleBuffOn
        jsr _FirstFrame

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
    ; ask for planet and searchit
    rts


;;;; END OF TABLE

check_scr
.(
    lda _current_screen
    cmp #SCR_GALAXY
    beq retnz
    cmp #SCR_CHART
    beq retnz
    cmp #SCR_MARKET
    beq retz
    cmp #SCR_EQUIP
    beq retz
    sec
    rts
retnz
    lda #$ff
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
    beq sel
    lda #(254)
    jmp _move_cross_v
sel
    jmp _dec_sel

.)


keyup
.(
    jsr check_scr
    bcc do
    rts
do
    beq sel
    lda #(2)
    jmp _move_cross_v
sel
    jmp _inc_sel

.)


keyl
.(
    jsr check_scr
    bcc do
    rts
do
    beq sel
    
    lda #(254)
    jmp _move_cross_h
sel
    jmp _sell

.)


keyr
.(
    jsr check_scr
    bcc do
    rts
do  
    beq sel
    lda #(2)
    jmp _move_cross_h
sel
    jmp _buy

.)

sele
.(
    lda _current_screen
    cmp #SCR_GALAXY
    beq doit2
    cmp #SCR_CHART
    beq doit2
    rts
doit2
    jmp _find_planet
.)



;        case 'R':
;            printf("Search planet? ");
;            gets(n);
;            search_planet(n);
;            break;

      


#ifndef OLDROLLS
dorolls
.(
.(
        ; Transform a_whatever in rot_whatever
        lda a_y
        bpl notneg
        lda #0
        sec
        sbc a_y
        cmp #4
        bcc nomax
        lda #4
nomax
        ora #%10000000
        bmi end
notneg
        cmp #4
        bcc nomax2
        lda #4
nomax2
end
        sta _roty+1
.)

.(
        ; Transform a_whatever in rot_whatever
        lda a_p
        bpl notneg
        lda #0
        sec
        sbc a_p
        cmp #4
        bcc nomax
        lda #4
nomax
        ora #%10000000
        bmi end
notneg
        cmp #4
        bcc nomax2
        lda #4
nomax2

end
        sta _rotx+1
.)

.(
        ; Transform a_whatever in rot_whatever
        lda a_r
        bpl notneg
        lda #0
        sec
        sbc a_r
        cmp #4
        bcc nomax
        lda #4
nomax
        ora #%10000000
        bmi end
notneg
        cmp #4
        bcc nomax2
        lda #4
nomax2

end
        sta _rotz+1
.)

    rts
.)

damp
.(
    ; Dampen rotations

.(
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
#endif

  

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
         .byt DEBRIS         ;Moon Object
         .byt 1            ;Number of points
         .byt 1            ;Number of faces

; Point list
   
    .byt 0
    .byt 0
    .byt 0

; Face list
         .byt 1            ;Number of vertices
         .byt 0        ;Fill pattern
         .byt 0      ;Vertices



ONEPLANET
         .byt PLANET       ;Sun or planet Object
         .byt 1            ;Number of points
         .byt 1            ;Number of faces

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

; Point list
   
    .byt 0
    .byt 0
    .byt 0

; Face list
         .byt 1            ;Number of vertices
         .byt 5        ;Fill pattern
         .byt 0      ;Vertices



#define WIDTH 37
#define LEFT 1

dump_buf
.(
    ldx #WIDTH
loop
	lda buffer+LEFT+40*6,x
	sta $a000+LEFT+40*6,x
	lda buffer+LEFT+40*7,x
	sta $a000+LEFT+40*7,x
	lda buffer+LEFT+40*8,x
	sta $a000+LEFT+40*8,x
	lda buffer+LEFT+40*9,x
	sta $a000+LEFT+40*9,x
	lda buffer+LEFT+40*10,x
	sta $a000+LEFT+40*10,x
	lda buffer+LEFT+40*11,x
	sta $a000+LEFT+40*11,x
	lda buffer+LEFT+40*12,x
	sta $a000+LEFT+40*12,x
	lda buffer+LEFT+40*13,x
	sta $a000+LEFT+40*13,x
	lda buffer+LEFT+40*14,x
	sta $a000+LEFT+40*14,x
	lda buffer+LEFT+40*15,x
	sta $a000+LEFT+40*15,x
	sta $a000+LEFT+40*16,x
	lda buffer+LEFT+40*17,x
	sta $a000+LEFT+40*17,x
	lda buffer+LEFT+40*18,x
	sta $a000+LEFT+40*18,x
	lda buffer+LEFT+40*19,x
	sta $a000+LEFT+40*19,x
	lda buffer+LEFT+40*20,x
	sta $a000+LEFT+40*20,x
	lda buffer+LEFT+40*21,x
	sta $a000+LEFT+40*21,x
	lda buffer+LEFT+40*22,x
	sta $a000+LEFT+40*22,x
	lda buffer+LEFT+40*23,x
	sta $a000+LEFT+40*23,x
	lda buffer+LEFT+40*24,x
	sta $a000+LEFT+40*24,x
	lda buffer+LEFT+40*25,x
	sta $a000+LEFT+40*25,x
	lda buffer+LEFT+40*26,x
	sta $a000+LEFT+40*26,x
	lda buffer+LEFT+40*27,x
	sta $a000+LEFT+40*27,x
	lda buffer+LEFT+40*28,x
	sta $a000+LEFT+40*28,x
	lda buffer+LEFT+40*29,x
	sta $a000+LEFT+40*29,x
	lda buffer+LEFT+40*30,x
	sta $a000+LEFT+40*30,x
	lda buffer+LEFT+40*31,x
	sta $a000+LEFT+40*31,x
	lda buffer+LEFT+40*32,x
	sta $a000+LEFT+40*32,x
	lda buffer+LEFT+40*33,x
	sta $a000+LEFT+40*33,x
	lda buffer+LEFT+40*34,x
	sta $a000+LEFT+40*34,x
	lda buffer+LEFT+40*35,x
	sta $a000+LEFT+40*35,x
	lda buffer+LEFT+40*36,x
	sta $a000+LEFT+40*36,x
	lda buffer+LEFT+40*37,x
	sta $a000+LEFT+40*37,x
	lda buffer+LEFT+40*38,x
	sta $a000+LEFT+40*38,x
	lda buffer+LEFT+40*39,x
	sta $a000+LEFT+40*39,x
	lda buffer+LEFT+40*40,x
	sta $a000+LEFT+40*40,x
	lda buffer+LEFT+40*41,x
	sta $a000+LEFT+40*41,x
	lda buffer+LEFT+40*42,x
	sta $a000+LEFT+40*42,x
	lda buffer+LEFT+40*43,x
	sta $a000+LEFT+40*43,x
	lda buffer+LEFT+40*44,x
	sta $a000+LEFT+40*44,x
	lda buffer+LEFT+40*45,x
	sta $a000+LEFT+40*45,x
	lda buffer+LEFT+40*46,x
	sta $a000+LEFT+40*46,x
	lda buffer+LEFT+40*47,x
	sta $a000+LEFT+40*47,x
	lda buffer+LEFT+40*48,x
	sta $a000+LEFT+40*48,x
	lda buffer+LEFT+40*49,x
	sta $a000+LEFT+40*49,x
	lda buffer+LEFT+40*50,x
	sta $a000+LEFT+40*50,x
	lda buffer+LEFT+40*51,x
	sta $a000+LEFT+40*51,x
	lda buffer+LEFT+40*52,x
	sta $a000+LEFT+40*52,x
	lda buffer+LEFT+40*53,x
	sta $a000+LEFT+40*53,x
	lda buffer+LEFT+40*54,x
	sta $a000+LEFT+40*54,x
	lda buffer+LEFT+40*55,x
	sta $a000+LEFT+40*55,x
	lda buffer+LEFT+40*56,x
	sta $a000+LEFT+40*56,x
	lda buffer+LEFT+40*57,x
	sta $a000+LEFT+40*57,x
	lda buffer+LEFT+40*58,x
	sta $a000+LEFT+40*58,x
	lda buffer+LEFT+40*59,x
	sta $a000+LEFT+40*59,x
	lda buffer+LEFT+40*60,x
	sta $a000+LEFT+40*60,x
	lda buffer+LEFT+40*61,x
	sta $a000+LEFT+40*61,x
	lda buffer+LEFT+40*62,x
	sta $a000+LEFT+40*62,x
	lda buffer+LEFT+40*63,x
	sta $a000+LEFT+40*63,x
	lda buffer+LEFT+40*64,x
	sta $a000+LEFT+40*64,x
	lda buffer+LEFT+40*65,x
	sta $a000+LEFT+40*65,x
	lda buffer+LEFT+40*66,x
	sta $a000+LEFT+40*66,x
	lda buffer+LEFT+40*67,x
	sta $a000+LEFT+40*67,x
	lda buffer+LEFT+40*68,x
	sta $a000+LEFT+40*68,x
	lda buffer+LEFT+40*69,x
	sta $a000+LEFT+40*69,x
	lda buffer+LEFT+40*70,x
	sta $a000+LEFT+40*70,x
	lda buffer+LEFT+40*71,x
	sta $a000+LEFT+40*71,x
	lda buffer+LEFT+40*72,x
	sta $a000+LEFT+40*72,x
	lda buffer+LEFT+40*73,x
	sta $a000+LEFT+40*73,x
	lda buffer+LEFT+40*74,x
	sta $a000+LEFT+40*74,x
	lda buffer+LEFT+40*75,x
	sta $a000+LEFT+40*75,x
	lda buffer+LEFT+40*76,x
	sta $a000+LEFT+40*76,x
	lda buffer+LEFT+40*77,x
	sta $a000+LEFT+40*77,x
	lda buffer+LEFT+40*78,x
	sta $a000+LEFT+40*78,x
	lda buffer+LEFT+40*79,x
	sta $a000+LEFT+40*79,x
	lda buffer+LEFT+40*80,x
	sta $a000+LEFT+40*80,x
	lda buffer+LEFT+40*81,x
	sta $a000+LEFT+40*81,x
	lda buffer+LEFT+40*82,x
	sta $a000+LEFT+40*82,x
	lda buffer+LEFT+40*83,x
	sta $a000+LEFT+40*83,x
	lda buffer+LEFT+40*84,x
	sta $a000+LEFT+40*84,x
	lda buffer+LEFT+40*85,x
	sta $a000+LEFT+40*85,x
	lda buffer+LEFT+40*86,x
	sta $a000+LEFT+40*86,x
	lda buffer+LEFT+40*87,x
	sta $a000+LEFT+40*87,x
	lda buffer+LEFT+40*88,x
	sta $a000+LEFT+40*88,x
	lda buffer+LEFT+40*89,x
	sta $a000+LEFT+40*89,x
	lda buffer+LEFT+40*90,x
	sta $a000+LEFT+40*90,x
	lda buffer+LEFT+40*91,x
	sta $a000+LEFT+40*91,x
	lda buffer+LEFT+40*92,x
	sta $a000+LEFT+40*92,x
	lda buffer+LEFT+40*93,x
	sta $a000+LEFT+40*93,x
	lda buffer+LEFT+40*94,x
	sta $a000+LEFT+40*94,x
	lda buffer+LEFT+40*95,x
	sta $a000+LEFT+40*95,x
	lda buffer+LEFT+40*96,x
	sta $a000+LEFT+40*96,x
	lda buffer+LEFT+40*97,x
	sta $a000+LEFT+40*97,x
	lda buffer+LEFT+40*98,x
	sta $a000+LEFT+40*98,x
	lda buffer+LEFT+40*99,x
	sta $a000+LEFT+40*99,x
	lda buffer+LEFT+40*100,x
	sta $a000+LEFT+40*100,x
	lda buffer+LEFT+40*101,x
	sta $a000+LEFT+40*101,x
	lda buffer+LEFT+40*102,x
	sta $a000+LEFT+40*102,x
	lda buffer+LEFT+40*103,x
	sta $a000+LEFT+40*103,x
	lda buffer+LEFT+40*104,x
	sta $a000+LEFT+40*104,x
	lda buffer+LEFT+40*105,x
	sta $a000+LEFT+40*105,x
	lda buffer+LEFT+40*106,x
	sta $a000+LEFT+40*106,x
	lda buffer+LEFT+40*107,x
	sta $a000+LEFT+40*107,x
	lda buffer+LEFT+40*108,x
	sta $a000+LEFT+40*108,x
	lda buffer+LEFT+40*109,x
	sta $a000+LEFT+40*109,x
	lda buffer+LEFT+40*110,x
	sta $a000+LEFT+40*110,x
	lda buffer+LEFT+40*111,x
	sta $a000+LEFT+40*111,x
	lda buffer+LEFT+40*112,x
	sta $a000+LEFT+40*112,x
	lda buffer+LEFT+40*113,x
	sta $a000+LEFT+40*113,x
	lda buffer+LEFT+40*114,x
	sta $a000+LEFT+40*114,x
	lda buffer+LEFT+40*115,x
	sta $a000+LEFT+40*115,x
	lda buffer+LEFT+40*116,x
	sta $a000+LEFT+40*116,x
	lda buffer+LEFT+40*117,x
	sta $a000+LEFT+40*117,x
	lda buffer+LEFT+40*118,x
	sta $a000+LEFT+40*118,x
	lda buffer+LEFT+40*119,x
	sta $a000+LEFT+40*119,x
	lda buffer+LEFT+40*120,x
	sta $a000+LEFT+40*120,x
	lda buffer+LEFT+40*121,x
	sta $a000+LEFT+40*121,x
	lda buffer+LEFT+40*122,x
	sta $a000+LEFT+40*122,x
	lda buffer+LEFT+40*123,x
	sta $a000+LEFT+40*123,x
	lda buffer+LEFT+40*124,x
	sta $a000+LEFT+40*124,x
	lda buffer+LEFT+40*125,x
	sta $a000+LEFT+40*125,x
	lda buffer+LEFT+40*126,x
	sta $a000+LEFT+40*126,x
	lda buffer+LEFT+40*127,x
	sta $a000+LEFT+40*127,x
    dex
    bmi end
    jmp loop
end
    rts
.)


clr_hires2
.(
    ldx #WIDTH
    lda #$40
loop
		sta buffer+LEFT+40*6,x
		sta buffer+LEFT+40*7,x
		sta buffer+LEFT+40*8,x
		sta buffer+LEFT+40*9,x
		sta buffer+LEFT+40*10,x
		sta buffer+LEFT+40*11,x
		sta buffer+LEFT+40*12,x
		sta buffer+LEFT+40*13,x
		sta buffer+LEFT+40*14,x
		sta buffer+LEFT+40*15,x
		sta buffer+LEFT+40*16,x
		sta buffer+LEFT+40*17,x
		sta buffer+LEFT+40*18,x
		sta buffer+LEFT+40*19,x
		sta buffer+LEFT+40*20,x
		sta buffer+LEFT+40*21,x
		sta buffer+LEFT+40*22,x
		sta buffer+LEFT+40*23,x
		sta buffer+LEFT+40*24,x
		sta buffer+LEFT+40*25,x
		sta buffer+LEFT+40*26,x
		sta buffer+LEFT+40*27,x
		sta buffer+LEFT+40*28,x
		sta buffer+LEFT+40*29,x
		sta buffer+LEFT+40*30,x
		sta buffer+LEFT+40*31,x
		sta buffer+LEFT+40*32,x
		sta buffer+LEFT+40*33,x
		sta buffer+LEFT+40*34,x
		sta buffer+LEFT+40*35,x
		sta buffer+LEFT+40*36,x
		sta buffer+LEFT+40*37,x
		sta buffer+LEFT+40*38,x
		sta buffer+LEFT+40*39,x
		sta buffer+LEFT+40*40,x
		sta buffer+LEFT+40*41,x
		sta buffer+LEFT+40*42,x
		sta buffer+LEFT+40*43,x
		sta buffer+LEFT+40*44,x
		sta buffer+LEFT+40*45,x
		sta buffer+LEFT+40*46,x
		sta buffer+LEFT+40*47,x
		sta buffer+LEFT+40*48,x
		sta buffer+LEFT+40*49,x
		sta buffer+LEFT+40*50,x
		sta buffer+LEFT+40*51,x
		sta buffer+LEFT+40*52,x
		sta buffer+LEFT+40*53,x
		sta buffer+LEFT+40*54,x
		sta buffer+LEFT+40*55,x
		sta buffer+LEFT+40*56,x
		sta buffer+LEFT+40*57,x
		sta buffer+LEFT+40*58,x
		sta buffer+LEFT+40*59,x
		sta buffer+LEFT+40*60,x
		sta buffer+LEFT+40*61,x
		sta buffer+LEFT+40*62,x
		sta buffer+LEFT+40*63,x
		sta buffer+LEFT+40*64,x
		sta buffer+LEFT+40*65,x
		sta buffer+LEFT+40*66,x
		sta buffer+LEFT+40*67,x
		sta buffer+LEFT+40*68,x
		sta buffer+LEFT+40*69,x
		sta buffer+LEFT+40*70,x
		sta buffer+LEFT+40*71,x
		sta buffer+LEFT+40*72,x
		sta buffer+LEFT+40*73,x
		sta buffer+LEFT+40*74,x
		sta buffer+LEFT+40*75,x
		sta buffer+LEFT+40*76,x
		sta buffer+LEFT+40*77,x
		sta buffer+LEFT+40*78,x
		sta buffer+LEFT+40*79,x
		sta buffer+LEFT+40*80,x
		sta buffer+LEFT+40*81,x
		sta buffer+LEFT+40*82,x
		sta buffer+LEFT+40*83,x
		sta buffer+LEFT+40*84,x
		sta buffer+LEFT+40*85,x
		sta buffer+LEFT+40*86,x
		sta buffer+LEFT+40*87,x
		sta buffer+LEFT+40*88,x
		sta buffer+LEFT+40*89,x
		sta buffer+LEFT+40*90,x
		sta buffer+LEFT+40*91,x
		sta buffer+LEFT+40*92,x
		sta buffer+LEFT+40*93,x
		sta buffer+LEFT+40*94,x
		sta buffer+LEFT+40*95,x
		sta buffer+LEFT+40*96,x
		sta buffer+LEFT+40*97,x
		sta buffer+LEFT+40*98,x
		sta buffer+LEFT+40*99,x
		sta buffer+LEFT+40*100,x
		sta buffer+LEFT+40*101,x
		sta buffer+LEFT+40*102,x
		sta buffer+LEFT+40*103,x
		sta buffer+LEFT+40*104,x
		sta buffer+LEFT+40*105,x
		sta buffer+LEFT+40*106,x
		sta buffer+LEFT+40*107,x
		sta buffer+LEFT+40*108,x
		sta buffer+LEFT+40*109,x
		sta buffer+LEFT+40*110,x
		sta buffer+LEFT+40*111,x
		sta buffer+LEFT+40*112,x
		sta buffer+LEFT+40*113,x
		sta buffer+LEFT+40*114,x
		sta buffer+LEFT+40*115,x
		sta buffer+LEFT+40*116,x
		sta buffer+LEFT+40*117,x
		sta buffer+LEFT+40*118,x
		sta buffer+LEFT+40*119,x
		sta buffer+LEFT+40*120,x
		sta buffer+LEFT+40*121,x
		sta buffer+LEFT+40*122,x
		sta buffer+LEFT+40*123,x
		sta buffer+LEFT+40*124,x
		sta buffer+LEFT+40*125,x
		sta buffer+LEFT+40*126,x
		sta buffer+LEFT+40*127,x

    dex
    bmi end
    jmp loop
end
    rts
.)


#define STARTCTRL $bf68-(57*40)

countlines .dsb 0
load_frame
.(
    lda #56
    sta countlines

    lda #<STARTCTRL
    sta tmp0
    lda #>STARTCTRL
    sta tmp0+1

    lda #<_controls
    sta tmp1
    lda #>_controls
    sta tmp1+1


looplines
    ldy #40
loopscans
    lda (tmp1),y
    sta (tmp0),y
    dey
    bpl loopscans
    
    lda tmp0
    clc
    adc #40
    bcc noinc1
    inc tmp0+1
noinc1
    sta tmp0

    lda tmp1
    clc
    adc #40
    bcc noinc2
    inc tmp1+1
noinc2
    sta tmp1
    
    dec countlines
    bne looplines
    rts

.)

save_frame
.(
    jsr EraseRadar

    lda #56
    sta countlines

    lda #<STARTCTRL
    sta tmp0
    lda #>STARTCTRL
    sta tmp0+1

    lda #<_controls
    sta tmp1
    lda #>_controls
    sta tmp1+1


looplines
    ldy #40
loopscans
    lda (tmp0),y
    sta (tmp1),y
    dey
    bpl loopscans
    
    lda tmp0
    clc
    adc #40
    bcc noinc1
    inc tmp0+1
noinc1
    sta tmp0

    lda tmp1
    clc
    adc #40
    bcc noinc2
    inc tmp1+1
noinc2
    sta tmp1
    
    dec countlines
    bne looplines
    rts

.)


