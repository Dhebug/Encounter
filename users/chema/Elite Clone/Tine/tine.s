; Test code for TINE

#include "ships.h"
#include "params.h"
#include "tine.h"

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

OCENA    .word 1000            ;X-coord
         .word 1000            ;Y-coord
         .word -5000            ;Z-coord

OCENB    .word 20            ;X-coord
         .word -20            ;Y-coord
         .word 2000            ;Z-coord

OCENC    .word -1000            ;X-coord
         .word 1000            ;Y-coord
         .word -1000            ;Z-coord

OCEND    .word 1000            ;X-coord
         .word 1000            ;Y-coord
         .word -1000            ;Z-coord
OCENE   .word 0
        .word 0
        .word 12200

OCENF   .word 1000
        .word 300
        .word 10000

//#define TESTRADAR
//#define FULLC

#ifdef FULLC
CEN1 .word -12200 
 	.word 0
	.word 0

CEN2 .word -9489 
 	.word 0
	.word -7668

CEN3 .word -6778 
 	.word 0
	.word -10144

CEN4 .word -4067 
 	.word 0
	.word -11502

CEN5 .word -1356 
 	.word 0
	.word -12124

CEN6 .word 1356 
 	.word 0
	.word -12124

CEN7 .word 4067 
 	.word 0
	.word -11502

CEN8 .word 6778 
 	.word 0
	.word -10144

CEN9 .word 9489 
 	.word 0
	.word -7668

CEN10 .word 12200 
 	.word 0
	.word 0

CEN11 .word -12200 
 	.word 0
	.word 0

CEN12 .word -9489 
 	.word 0
	.word 7668

CEN13 .word -6778 
 	.word 0
	.word 10144

CEN14 .word -4067 
 	.word 0
	.word 11502

CEN15 .word -1356 
 	.word 0
	.word 12124

CEN16 .word 1356 
 	.word 0
	.word 12124

CEN17 .word 4067 
 	.word 0
	.word 11502

CEN18 .word 6778 
 	.word 0
	.word 10144

CEN19 .word 9489 
 	.word 0
	.word 7668

CEN20 .word 12200 
 	.word 0
	.word 0
#endif

#ifdef FRONTC

CEN1 .word -12200 
 	.word 0
	.word 0

CEN2 .word -10916 
 	.word 0
	.word 5448

CEN3 .word -9632 
 	.word 0
	.word 7488

CEN4 .word -8347 
 	.word 0
	.word 8897

CEN5 .word -7063 
 	.word 0
	.word 9947

CEN6 .word -5779 
 	.word 0
	.word 10744

CEN7 .word -4495 
 	.word 0
	.word 11342

CEN8 .word -3211 
 	.word 0
	.word 11770

CEN9 .word -1926 
 	.word 0
	.word 12047

CEN10 .word -642 
 	.word 0
	.word 12183

CEN11 .word 642 
 	.word 0
	.word 12183

CEN12 .word 1926 
 	.word 0
	.word 12047

CEN13 .word 3211 
 	.word 0
	.word 11770

CEN14 .word 4495 
 	.word 0
	.word 11342

CEN15 .word 5779 
 	.word 0
	.word 10744

CEN16 .word 7063 
 	.word 0
	.word 9947

CEN17 .word 8347 
 	.word 0
	.word 8897

CEN18 .word 9632 
 	.word 0
	.word 7488

CEN19 .word 10916 
 	.word 0
	.word 5448

CEN20 .word 12200 
 	.word 0
	.word 0

#endif

#ifdef REARC
CEN1 .word -12200 
 	.word 0
	.word 0

CEN2 .word -10916 
 	.word 0
	.word -5448

CEN3 .word -9632 
 	.word 0
	.word -7488

CEN4 .word -8347 
 	.word 0
	.word -8897

CEN5 .word -7063 
 	.word 0
	.word -9947

CEN6 .word -5779 
 	.word 0
	.word -10744

CEN7 .word -4495 
 	.word 0
	.word -11342

CEN8 .word -3211 
 	.word 0
	.word -11770

CEN9 .word -1926 
 	.word 0
	.word -12047

CEN10 .word -642 
 	.word 0
	.word -12183

CEN11 .word 642 
 	.word 0
	.word -12183

CEN12 .word 1926 
 	.word 0
	.word -12047

CEN13 .word 3211 
 	.word 0
	.word -11770

CEN14 .word 4495 
 	.word 0
	.word -11342

CEN15 .word 5779 
 	.word 0
	.word -10744

CEN16 .word 7063 
 	.word 0
	.word -9947

CEN17 .word 8347 
 	.word 0
	.word -8897

CEN18 .word 9632 
 	.word 0
	.word -7488

CEN19 .word 10916 
 	.word 0
	.word -5448

CEN20 .word 12200 
 	.word 0
	.word 0
#endif

#ifdef TESTRADAR

nsp .byt 19

AddCOb
.(
    lda #<CEN1
    sta tmp0
    lda #>CEN1
    sta tmp0+1
     
loop
    LDX #SHIP_ADDER
    jsr AddSpaceObject
    
    lda tmp0
    clc
    adc #6
    sta tmp0
    bcc noinc
    inc tmp0+1
noinc
    dec nsp
    bne loop     

    rts
.)

#endif


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

         jsr load_frame

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



#ifdef TESTRADAR
        jsr AddCOb
#endif

         clc              ; Wireframe mode
         JSR SetParms
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





_RunDemo
.(
    ;sei
loop

    ;jsr _MoveOthers

    jsr _Tactics;

    ldx VOB
    jsr SetCurOb
    ;cli
    jsr ProcessKeyboard
    ;sei

    ldx VOB
    ;jsr SetCurOb
    jsr SetRadar
    jsr CalcView
    jsr SortVis   

#ifndef FILLEDPOLYS
    jsr clr_hires2
#endif

    jsr DrawAllVis   ;Draw objects
    jsr EraseRadar   ; Erase radar
    jsr DrawRadar

    jsr _CheckHits  ; Should be called after DrawAllVis!!!!

    jsr PlotStars

    jsr _Lasers
      
#ifdef FILLEDPOLYS
    jsr _ClearAndSwapFlag
#else
    jsr dump_buf
#endif

    jsr _MoveShips

   ; jsr _prdbug    

    ldx VOB
    jsr SetCurOb

    ;jsr GetCurOb
    ;sty _pointer
    ;sta _pointer+1    
    ;jsr _print


 
    jmp loop

.)

;_pointer .dsb 2


ProcessKeyboard
.(

       
       ;  lda THETSTEP
       ;  pha
       ;  lda _speed+1
       ;  lsr
       ;  lsr
       ;  sta THETSTEP
       ;  jsr STARADDZ
       ; 
       ;  pla
       ;  sta THETSTEP

         jsr move_stars

         jsr $023B ; Get key
       	 bpl return
keypressed
         ;sei
         ldx #1 ; Amount to rotate or accelerate

         CMP #"A"
         BEQ pitchdn
         CMP #"Z"
         BEQ pitchup
         CMP #"Q"
         BEQ rolll
         CMP #"W"
         BEQ rollr
         CMP #"S"
         BEQ yawl
         CMP #"D"
         BEQ yawr
         CMP #"O"
         BEQ accel
         CMP #"L"
         BEQ deccel
 ;        CMP #"I"
 ;        BEQ movl
 ;        CMP #"P"
 ;        BEQ movr
 ;        CMP #"K"
 ;        BEQ movu
 ;        CMP #"M"
 ;        BEQ movd
         CMP #"B"
         BEQ fireM
         CMP #"1"
         BEQ fireL

         CMP #"0"
         BEQ setdbg

return
         lda #0
         sta _accel+1
 

         rts   

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
        jsr LaunchMissile
        rts
fireL   jsr FireLaser
        rts

setdbg  lda #0
        sta _dbf
        rts 

.)

_dbf .byt 1


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




;
; Test object 1: simple tetrahedron
;

TETDAT   
         .byt 0            ;Normal object
         .byt 4            ;Number of points
         .byt 4            ;Number of faces

; Point list

TETX     
    .byt 45,45,$D3,$D3
TETY     
    .byt 45,$D3,45,$D3
TETZ     
    .byt 45,$D3,$D3,45

; Face list

FACE1    
         .byt 3            ;Number of vertices
         .byt SOLID        ;Fill pattern
         .byt 0,1,2,0      ;Vertices

FACE2    
         .byt 3
         .byt ZIGS
         .byt 3,2,1,3


FACE3    
         .byt 3
         .byt CROSSSM
         .byt 3,0,2,3


FACE4    
         .byt 3
         .byt HOLES
         .byt 3,1,0,3


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





#ifndef FILLEDPOLYS

#define WIDTH 37
#define LEFT 1
//#define buffer $8000



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
	lda buffer+LEFT+40*16,x
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


//.dsb 256-(*&255)

buffer 
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256


#endif









_controls
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6f,$73,$77,$7f,$7f,$7f,$7f,$7e,$40,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$5f,$60,$44,$40
    .byt  $40,$40,$40,$40,$40,$53,$7b,$7d,$68,$44,$47,$7f,$7f,$7f,$7f,$7e
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$41,$60,$58,$44,$40,$40,$40,$40,$40,$40,$54,$42,$45
    .byt  $6f,$73,$67,$7f,$7f,$7f,$7f,$7e,$40,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$42,$40,$44,$44,$40
    .byt  $40,$40,$40,$40,$40,$53,$73,$79,$68,$40,$57,$7f,$7f,$7f,$7f,$7e
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$44,$40,$42,$44,$40,$40,$40,$40,$40,$40,$50,$4a,$41
    .byt  $68,$47,$67,$7f,$7f,$7f,$7f,$7e,$40,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$48,$40,$41,$44,$40
    .byt  $40,$40,$40,$40,$40,$57,$72,$41,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$50,$40,$40,$64,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$50,$40,$40,$67,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$60,$40,$40,$54,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6f,$43,$77,$7f,$7f,$40,$40,$40,$40,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$45,$55,$55,$55,$50,$40,$40,$40,$40,$40,$60,$40,$40,$54,$40
    .byt  $40,$41,$60,$40,$40,$57,$7a,$41,$68,$64,$47,$7f,$7f,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$45,$50,$40,$40,$40,$45,$50,$40
    .byt  $40,$40,$40,$60,$40,$40,$54,$40,$40,$41,$60,$40,$40,$54,$4a,$41
    .byt  $6f,$63,$67,$7f,$7f,$40,$40,$40,$40,$50,$40,$40,$40,$40,$40,$45
    .byt  $70,$40,$40,$40,$40,$40,$46,$60,$40,$40,$40,$60,$40,$40,$54,$40
    .byt  $40,$41,$60,$40,$40,$57,$72,$41,$68,$60,$57,$7f,$7f,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$43,$70,$68,$40,$40,$40,$40,$40,$54,$4f
    .byt  $40,$40,$40,$60,$40,$40,$54,$40,$40,$41,$60,$40,$40,$54,$52,$41
    .byt  $68,$67,$67,$7f,$7f,$40,$40,$40,$40,$50,$40,$40,$40,$40,$78,$40
    .byt  $44,$40,$40,$40,$40,$40,$60,$40,$5c,$40,$40,$60,$40,$40,$54,$40
    .byt  $40,$41,$60,$40,$40,$54,$4b,$7d,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$46,$40,$42,$42,$40,$40,$40,$40,$41,$41,$40
    .byt  $41,$60,$40,$50,$40,$40,$64,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$40,$40,$70,$40,$40
    .byt  $41,$40,$40,$40,$40,$42,$40,$40,$40,$4c,$40,$50,$40,$40,$67,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$42,$40,$40,$48,$40,$60,$40,$40,$40,$44,$40,$50
    .byt  $40,$41,$40,$48,$40,$41,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6f,$74,$57,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$40,$48,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$48,$40,$40,$40,$40,$50,$44,$40,$42,$44,$40
    .byt  $46,$40,$40,$40,$40,$57,$63,$7d,$68,$44,$57,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$50,$40,$40,$60,$40,$40,$60,$40,$48,$40,$40,$40,$50,$40,$44
    .byt  $40,$40,$44,$42,$40,$44,$44,$40,$46,$40,$40,$40,$40,$54,$52,$41
    .byt  $6f,$74,$57,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$42,$48,$62,$48,$44
    .byt  $51,$44,$40,$40,$40,$62,$48,$60,$51,$44,$51,$41,$60,$58,$44,$40
    .byt  $46,$40,$40,$40,$40,$54,$4a,$41,$68,$44,$57,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$50,$40,$48,$40,$40,$42,$40,$40,$42,$40,$40,$41,$40,$40,$41
    .byt  $40,$40,$40,$50,$5f,$60,$44,$40,$46,$40,$40,$40,$40,$54,$4a,$41
    .byt  $68,$47,$77,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$41,$40,$40,$42,$40,$40,$40,$40,$40,$40,$40,$40,$40,$44,$40
    .byt  $46,$40,$40,$40,$40,$57,$7b,$7d,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$60,$40,$40,$48,$40,$40,$40,$60,$40,$44,$40,$40,$40
    .byt  $50,$40,$40,$44,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$50,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$42,$40,$40,$40,$60,$40,$40,$40,$48,$40,$50,$40,$40,$40
    .byt  $44,$40,$40,$41,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6f,$77,$77,$60,$40,$40,$40,$40,$40,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$44,$40,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$70,$50,$4e,$41,$68,$41,$47,$60,$40,$40,$40,$40
    .byt  $40,$50,$44,$40,$40,$42,$40,$40,$40,$40,$42,$41,$40,$40,$40,$40
    .byt  $41,$40,$40,$40,$60,$40,$47,$7f,$7f,$7f,$7f,$7f,$70,$50,$46,$41
    .byt  $68,$41,$47,$60,$40,$40,$40,$40,$40,$50,$48,$40,$40,$40,$40,$40
    .byt  $40,$40,$41,$42,$40,$40,$40,$40,$40,$40,$40,$40,$50,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$70,$50,$46,$41,$68,$41,$47,$60,$40,$40,$40,$40
    .byt  $40,$50,$48,$40,$40,$48,$40,$40,$40,$40,$40,$64,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$50,$40,$47,$7f,$7f,$7f,$7f,$7f,$70,$50,$46,$41
    .byt  $6f,$71,$47,$60,$40,$40,$40,$40,$40,$50,$4c,$51,$44,$41,$44,$51
    .byt  $44,$51,$44,$58,$62,$48,$62,$48,$62,$41,$44,$51,$50,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$70,$50,$5f,$61,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$48,$40,$40,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$44,$40,$40,$50,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$48,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$50,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$44,$40,$42,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$41,$40,$40,$60,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $68,$47,$74,$40,$40,$40,$40,$40,$40,$50,$44,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$60,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$68,$41,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$42,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$50,$41,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$41,$61
    .byt  $68,$41,$44,$40,$40,$40,$40,$40,$40,$50,$41,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$50,$40,$40,$40,$40,$40,$40,$40,$42,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$68,$41,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$60,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$44,$44,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$58,$41
    .byt  $6f,$61,$44,$40,$40,$40,$40,$40,$40,$50,$40,$50,$40,$40,$40,$40
    .byt  $40,$40,$40,$48,$40,$40,$40,$40,$40,$40,$40,$48,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$4a,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$41,$50,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$46,$62,$48,$62,$48
    .byt  $62,$48,$62,$51,$44,$51,$44,$51,$44,$51,$45,$60,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$41,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$46,$40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6f,$44,$47,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$40,$58,$40,$40,$40
    .byt  $40,$40,$40,$48,$40,$40,$40,$40,$40,$40,$58,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$68,$64,$47,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$50,$40,$40,$46,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$41,$60,$40,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$41,$61
    .byt  $6f,$64,$47,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$40,$41,$60,$40,$40
    .byt  $40,$40,$40,$50,$40,$40,$40,$40,$40,$46,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$68,$64,$47,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$50,$40,$40,$40,$5c,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$78,$40,$40,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$41,$61
    .byt  $68,$67,$77,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$40,$40,$43,$60,$40
    .byt  $40,$40,$40,$48,$40,$40,$40,$40,$47,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$5c,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $78,$40,$40,$40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$40,$40,$40,$43,$70
    .byt  $40,$40,$40,$50,$40,$40,$40,$4f,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $60,$50,$40,$40,$40,$40,$40,$4f,$60,$40,$40,$40,$40,$40,$47,$70
    .byt  $40,$40,$40,$40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6c,$40,$44,$40,$40,$40,$40,$40,$60,$50,$40,$40,$40,$40,$40,$40
    .byt  $5f,$78,$40,$48,$40,$5f,$78,$40,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$58,$41,$6b,$7f,$64,$40,$40,$40,$40,$40
    .byt  $60,$50,$40,$40,$40,$40,$40,$40,$40,$47,$7f,$7f,$7f,$60,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$59,$61
    .byt  $6f,$7f,$74,$40,$40,$40,$40,$40,$60,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$59,$61,$6b,$7f,$64,$40,$40,$40,$40,$40
    .byt  $60,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$5f,$61
    .byt  $6c,$40,$44,$40,$40,$40,$40,$40,$60,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$41,$61,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $60,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41


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




