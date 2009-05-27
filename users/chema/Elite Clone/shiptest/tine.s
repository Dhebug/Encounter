; Test code for TINE


#define OBS  osdk_end


OCEN     .word 0100            ;X-coord
         .word 0100            ;Y-coord
         .word 0800            ;Z-coord

OCEN2    .word $3999; 65436           ;X-coord=-100
         .word $3999;$3999;            ;Y-coord
         .word $3999;64736           ;Z-coord=-800

OCEN3    .word $0-$3999;65436           ;X-coord=-100
         .word $0-$3999;0100            ;Y-coord
         .word $0-$3999;64736           ;Z-coord=-800

OCEN4    .word $0-$3999;65436           ;X-coord=-100
         .word $0-$3999;65436           ;Y-coord
         .word $3999;20000           ;Z-coord=20000

OCEN5    .word $3999;9000           ;X-coord=-100
         .word $3999;9000           ;Y-coord
         .word $0-$3999;9000           ;Z-coord=20000



_InitTestCode 

         LDA #<OBS        ;Object records
         LDY #>OBS
         JSR Init3D

         jsr CreateRadar


         LDA #<COBRADAT
         LDY #>COBRADAT

         LDA #<ADDER
         LDY #>ADDER

         LDA #<ASP
         LDY #>ASP


         LDX #1
         JSR AddObj
         STA POINT        ;Object pointer
         STY POINT+1
         LDY #5           ;Set center
l1       LDA OCEN,Y
         STA (POINT),Y
         DEY
         BPL l1

         LDA #<TETDAT
         LDY #>TETDAT
         
         
         LDX #2
         JSR AddObj
         STA POINT        ;Object pointer
         STY POINT+1
         LDY #5           ;Set center
l2       LDA OCEN2,Y
         STA (POINT),Y
         DEY
         BPL l2

        
         lda #<CORIOLIS
         ldy #>CORIOLIS
    
         LDX #3
         JSR AddObj
         STA POINT        ;Object pointer
         STY POINT+1
         LDY #5           ;Set center
l3       LDA OCEN3,Y
         STA (POINT),Y
         DEY
         BPL l3


         LDA #<STARDAT
         LDY #>STARDAT
         LDX #4
         JSR AddObj
         STA POINT        ;Object pointer
         STY POINT+1
         LDY #5           ;Set center
l4       LDA OCEN4,Y
         STA (POINT),Y
         DEY
         BPL l4

         lda #<COBRAIIDAT
         ldy #>COBRAIIDAT
    
         LDX #6
         JSR AddObj
         STA POINT        ;Object pointer
         STY POINT+1
         LDY #5           ;Set center
l5       LDA OCEN5,Y
         STA (POINT),Y
         DEY
         BPL l5

fin


         LDA #<TETDAT     ;Object data
         LDY #>TETDAT
         LDX #7          ;ID
         JSR AddObj
         STX VOB          ;View object
 


         clc              ; Wireframe mode
         JSR SetParms
         rts



_FirstFrame
#ifndef FILLEDPOLYS
         jsr clr_hires2
#endif
         LDX VOB          ;Calculate view
         JSR CalcView
         JSR SortVis      ;Sort objects
         JSR DrawAllVis   ;Draw objects
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
 
loop

    jsr MoveOthers
 
    ldx VOB
    jsr SetCurOb
    
    jsr ProcessKeyboard
 
    ldx VOB
    jsr SetRadar
    jsr CalcView
    jsr SortVis   

#ifndef FILLEDPOLYS
    jsr clr_hires2
#endif

    jsr DrawAllVis   ;Draw objects
    jsr DrawRadar

           lda #100
        sta _LargeX0
        sta _LargeY0; 
        sta _LargeX1; 
        sta _LargeY1;
        lda #0
        sta _LargeX0+1
        sta _LargeY0+1; 
        sta _LargeX1+1; 
        sta _LargeY1+1;
        jsr _DrawClippedLine


#ifdef FILLEDPOLYS
    jsr _ClearAndSwapFlag
#else
    jsr dump_buf
#endif

    ldx VOB
    jsr SetCurOb

    ;jsr GetCurOb
    ;sty _pointer
    ;sta _pointer+1    
    ;jsr _print

    jmp loop

.)

_pointer .dsb 2


ProcessKeyboard
.(
         jsr $023B ; Get key
       	 bpl return
keypressed
         ;sei
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
         BEQ movf
         CMP #"L"
         BEQ movb
         CMP #"I"
         BEQ movl
         CMP #"P"
         BEQ movr
         CMP #"K"
         BEQ movu
         CMP #"M"
         BEQ movd


return
         rts   

yawr         
         CLC
         .byt $24
yawl     SEC
         jmp Yaw

pitchdn  CLC
         .byt $24
pitchup  SEC
         jmp Pitch
rolll    CLC
         .byt $24
rollr    SEC
         jmp Roll
movf     LDA #$50
         .byt $2C
movb     LDA #$CE
         jmp MoveForwards
movr     LDA #$50
         .byt $2C
movl     LDA #$ce
         jmp MoveSide
movd     lda #$50
         .byt $2c
movu     lda #$ce
         jmp MoveDown


.)

objs .byt 00
MoveOthers
.(
    ldx NUMOBJS
    dex 

    stx objs    
loop
    cpx VOB
    beq next

    jsr SetCurOb
    sec
    jsr Pitch
    clc
    jsr Yaw
    clc
    jsr Roll

next
    dec objs
    ldx objs

    bne loop ; Don't move radar (object 0)
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


; Model of ship ANACONDA
ANACONDA
	.byt 0	; Ship type
	.byt 15	;Number of vertices
	.byt 12	;Number of faces

;Vertices List - X coordinate
	.byt $00,$D5,$E6,$1A,$2B,$00,$BB,$D5,$2B,$45,$D5,$BB,$00,$45,$2B

;Vertices List - Y coordinate
	.byt $07,$F3,$D1,$D1,$F3,$30,$0F,$D9,$D9,$0F,$35,$FF,$00,$FF,$35

;Vertices List - Z coordinate
	.byt $C6,$DB,$FD,$FD,$DB,$CF,$F1,$28,$28,$F1,$E9,$20,$FE,$20,$E9

; Face data
	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,1,0,4,3 ; Inverted


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,5,10,6,1 ; Inverted


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 2,1,6,11,7,2 ; Inverted


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 8,12,7,2,3,8


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 4,3,8,13,9,4 ; Inverted


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 9,4,0,5,14,9 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,14,10,5 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 10,6,11,12,10 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,12,11,7 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,13,12,8 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 13,9,14,12,13 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 10,12,14,10 ; Inverted


; End of ship ANACONDA data

; Model of ship ASP
ASP
	.byt 0	; Ship type
	.byt 19	;Number of vertices
	.byt 15	;Number of faces

;Vertices List - X coordinate
	.byt $00,$00,$2B,$45,$2B,$D5,$BB,$D5,$1A,$E6,$2B,$D5,$00,$EF,$11,$00,$00,$00,$00

;Vertices List - Y coordinate
	.byt $EE,$F7,$00,$FD,$F2,$00,$FD,$F2,$F9,$F9,$0E,$0E,$09,$00,$00,$FC,$04,$F9,$F9

;Vertices List - Z coordinate
	.byt $00,$D3,$D3,$00,$1C,$D3,$00,$1C,$49,$49,$1C,$1C,$D3,$D3,$D3,$D3,$D3,$49,$53

; Face data
	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 8,9,7,0,4,8


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 3,4,0,1,2,3


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,7,6,5,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 11,10,12,11


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,8,10,11,9 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 6,11,12,5,6


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,12,10,3,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,4,3,8


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,7,9,6 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,10,8,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 9,11,6,9


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,1,5,12,2 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 14,15,13,16,14 ; Inverted


	.byt 2	;Number of points
	.byt 0	;Fill pattern
	.byt 17,18,17 ; Inverted


	.byt 2	;Number of points
	.byt 0	;Fill pattern
	.byt 17,18,17 ; Inverted


; End of ship ASP data






; Model of ship ADDER
ADDER
	.byt 0	; Ship type
	.byt 18	;Number of vertices
	.byt 14	;Number of faces

;Vertices List - X coordinate
	.byt $EE,$12,$1E,$1E,$12,$EE,$E2,$E2,$EE,$12,$EE,$12,$EE,$12,$F5,$0B,$0B,$F5

;Vertices List - Y coordinate
	.byt $00,$00,$00,$00,$F9,$F9,$00,$00,$07,$07,$07,$07,$F9,$F9,$03,$03,$04,$04

;Vertices List - Z coordinate
	.byt $28,$28,$E8,$D8,$D8,$D8,$D8,$E8,$D8,$D8,$0D,$0D,$0D,$0D,$1D,$1D,$18,$18

; Face data
	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 11,10,0,1,11


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,12,13,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,11,1,2


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,13,2,1 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,11,2,3,9


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,13,4,3 ; Inverted 


	.byt 6	;Number of points
	.byt 0	;Fill pattern
	.byt 3,4,5,6,8,9,3


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 10,8,6,7,10


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 7,6,5,12,7 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 10,7,0,10


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,7,12,0 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 10,11,9,8,10


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 5,4,13,12,5 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 17,14,15,16,17


; End of ship ADDER data

COBRADAT
         .byt 0             ;Normal object
         .byt 20            ;Number of points
         .byt 15            ;Number of faces

COBX     .byt 48,$d6,$d6,$f8,$f8,$d6,$d6,48,$d6,$d6,$d6,8
         .byt $d6,$d6,$d6,$d6,$d6,$d6,$d6,$d6
COBY     .byt 21,21,84,76,$b4,$ac,$eb,$eb,$d2,0,46,0
         .byt $f8,$f8,$e7,$e7,8,25,25,8
COBZ     .byt $f0,$f0,$fc,$fc,$fc,$fc,$f0,$f0,8,16,8,16
         .byt 4,$f8,$fa,2,4,2,$fa,$f8


COBF1
    .byt 4            ;Number of vertices
    .byt 0        ;Fill pattern
    .byt 0,1,2,3,0
COBF2    
    .byt 4            ;Number of vertices
    .byt 1        ;Fill pattern
    .byt 0,7,6,1,0
COBF3
    .byt 4            ;Number of vertices
    .byt 2        ;Fill pattern
    .byt 4,5,6,7,4
COBF4
    .byt 3            ;Number of vertices
    .byt 3        ;Fill pattern
    .byt 0,11,7,0
COBF5
    .byt 3            ;Number of vertices
    .byt 4        ;Fill pattern
    .byt 3,2,10,3
COBF6
    .byt 3            ;Number of vertices
    .byt 1        ;Fill pattern
    .byt 0,3,10,0
COBF7
    .byt 3            ;Number of vertices
    .byt 0        ;Fill pattern
    .byt 0,10,11,0
COBF8
    .byt 3            ;Number of vertices
    .byt 1        ;Fill pattern
    .byt 9,11,10,9
COBF9
    .byt 3            ;Number of vertices
    .byt 2        ;Fill pattern
    .byt 5,4,8,5
COBF10
    .byt 3            ;Number of vertices
    .byt 3        ;Fill pattern
    .byt 4,7,8,4
COBF11
    .byt 3            ;Number of vertices
    .byt 4        ;Fill pattern
    .byt 7,11,8,7
COBF12
    .byt 3            ;Number of vertices
    .byt 1        ;Fill pattern
    .byt 11,9,8,11
COBF13
    .byt 7            ;Number of vertices
    .byt 2        ;Fill pattern
    .byt 9,10,2,1,6,5,8,9 ;Backplate
COBF14
    .byt 4            ;Number of vertices
    .byt 0        ;Fill pattern
    .byt 13,14,15,12,13   ;Engines
COBF15
    .byt 4            ;Number of vertices
    .byt 0        ;Fill pattern
    .byt 17,18,19,16,17




COBRAIIDAT
 .byt 0             ;Normal object     
 .byt 34            ;Number of points  
 .byt 22            ;Number of faces   

COBIIX .byt 20, 236, 0, 181, 75, 201, 55, 80, 176, 0, 236, 20, 233, 251, 5, 23, 23, 5, 251, 233, 255, 255, 206, 206, 201, 50, 55, 50, 1, 1, 1, 1, 255, 255
COBIIY .byt 0, 0, 16, 254, 254, 10, 10, 251, 251, 16, 241, 241, 5, 8, 8, 5, 248, 246, 246, 248, 255, 255, 252, 4, 0, 4, 0, 252, 255, 255, 1, 1, 1, 1
COBIIZ .byt 48, 48, 15, 251, 251, 231, 231, 231, 231, 231, 231, 231, 228, 228, 228, 228, 228, 228, 228, 228, 48, 56, 228, 228, 228, 228, 228, 228, 48, 56, 48, 56, 48, 56

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 2,1,0,2

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 0,1,10,11,0

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 6,2,0,6

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 0,4,6,0

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 0,11,7,4,0

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 1,2,5,1

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 5,3,1,5

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 1,3,8,10,1

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 5,2,9,5

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 2,6,9,2

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 5,8,3,5

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 7,6,4,7

    .byt 7            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 9,6,7,11,10,8,5,9

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 14,15,16,17,14

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 12,13,18,19,12

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 25,26,27,25

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 24,23,22,24

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 21,29,28,20,21

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 31,29,28,30,31

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 32,30,31,33,32

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 21,33,32,20,21

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 20,29,31,33,20




CORIOLIS

.byt 0             ;Normal object    
.byt 52            ;Number of points 
.byt 15            ;Number of faces  

CORX .byt 32, 0, 224, 0, 32, 32, 0, 32, 32, 0, 0, 224, 224, 224, 224, 0, 32, 0, 224, 0, 32, 32, 32, 32, 224, 224, 224, 224, 0, 32, 0, 224, 0, 224, 224, 0, 32, 32, 0, 32, 32, 224, 224, 0, 0, 224, 0, 32, 254, 2, 2, 254
CORY .byt 0, 32, 0, 224, 224, 0, 224, 0, 32, 32, 32, 32, 0, 0, 224, 224, 224, 224, 224, 224, 0, 32, 0, 224, 0, 224, 0, 32, 32, 32, 32, 32, 224, 224, 0, 224, 0, 224, 32, 32, 0, 0, 32, 32, 224, 0, 32, 0, 250, 250, 6, 6
CORZ .byt 32, 32, 32, 32, 0, 32, 32, 32, 0, 32, 32, 0, 32, 32, 0, 32, 0, 32, 0, 224, 224, 0, 32, 0, 224, 0, 32, 0, 32, 0, 224, 0, 224, 0, 224, 224, 224, 0, 224, 0, 224, 224, 0, 224, 224, 224, 224, 224, 32, 32, 32, 32

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 0,1,2,3,0

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 4,5,6,4

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 7,8,9,7

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 10,11,12,10

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 13,14,15,13

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 16,17,18,19,16

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 20,21,22,23,20

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 24,25,26,27,24

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 28,29,30,31,28

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 32,33,34,32

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 35,36,37,35

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 38,39,40,38

    .byt 3            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 41,42,43,41

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 44,45,46,47,44

    .byt 4            ;Number of vertices
    .byt SOLID        ;Fill pattern
    .byt 48,49,50,51,48


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

;
; Test object 2: a compound object,
; spaceship-kind of thing (essentially
; cool world stars)
;
STARDAT  

         .byt $80          ;Compound object
         .byt 14           ;Number of points
         .byt 6            ;Number of oblets

; Point list
         .byt 50,$ce,0,0,0,0,15,15,15,15,$f1,$f1,$f1,$f1
         .byt 0,0,16,$e6,0,0,10,10,$f6,$f6,10,10,$f6,$f6
         .byt 0,0,0,0,94,$ea,15,$f1,$f1,15,15,$f1,$f1,15


;         .byt 15,$f1,0,0,0,0,15,15,15,15,$f1,$f1,$f1,$f1
;         .byt 0,0,15,$f1,0,0,10,10,$f6,$f6,10,10,$f6,$f6
;         .byt 0,0,0,0,15,$f1,15,$f1,$f1,15,15,$f1,$f1,15



; Oblet list: reference points

         .byt 0            ;First 6 points
         .byt 1
         .byt 2
         .byt 3
         .byt 4
         .byt 5

; Oblet 1

         .byt 26           ;26 bytes
         .byt 4            ;4 faces

; faces
         .byt 3            ;4 points
         .byt SOLID        ;pattern
         .byt 0,8,7,0      ;Star 2, Tine 0, face 1

         .byt 3
         .byt ZIGS
         .byt 0,7,6,0

         .byt 3
         .byt ZAGS
         .byt 0,6,9,0

         .byt 3
         .byt DITHER1
         .byt 0,9,8,0

; Oblet 2

         .byt 26           ;26 bytes
         .byt 4            ;4 faces


         .byt 3            ;4 points
         .byt ZIGS
         .byt 1,11,12,1

         .byt 3
         .byt BRICK
         .byt 1,12,13,1

         .byt 3
         .byt DITHER2
         .byt 1,13,10,1

         .byt 3
         .byt ZAGS
         .byt 1,10,11,1

; Oblet 3
         .byt 26           ;26 bytes
         .byt 4            ;4 faces

         .byt 3
         .byt SQUARES
         .byt 2,7,11,2

         .byt 3
         .byt INVSQ
         .byt 2,6,7,2

         .byt 3
         .byt DITHER1
         .byt 2,10,6,2

         .byt 3
         .byt DITHER2
         .byt 2,11,10,2

; Oblet 4
         .byt 26
         .byt 4

         .byt 3
         .byt CROSSSM
         .byt 3,12,8,3

         .byt 3
         .byt HOLES
         .byt 3,8,9,3

         .byt 3
         .byt VSTRIPES
         .byt 3,9,13,3

         .byt 3
         .byt SOLID
         .byt 3,13,12,3

; Oblet 5
         .byt 26           ;26 bytes
         .byt 4            ;4 faces

         .byt 3
         .byt DITHER1
         .byt 4,9,6,4

         .byt 3
         .byt SOLID
         .byt 4,6,10,4

         .byt 3
         .byt DITHER2
         .byt 4,10,13,4

         .byt 3
         .byt HSTRIPES
         .byt 4,13,9,4

; Oblet 6
         .byt 26           ;26 bytes
         .byt 4            ;4 faces

         .byt 3
         .byt ZIGZAG
         .byt 5,8,12,5

         .byt 3
         .byt HSTRIPES
         .byt 5,12,11,5

         .byt 3
         .byt VSTRIPES
         .byt 5,11,7,5

         .byt 3
         .byt DITHER2
         .byt 5,7,8,5
 





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





