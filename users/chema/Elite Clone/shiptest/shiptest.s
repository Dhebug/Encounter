; Test code for TINE



#define OBS  osdk_end


OCEN     .word 0000            ;X-coord
         .word 0000            ;Y-coord
         .word 0400            ;Z-coord


VOB      .byt 00           ;View object
ROB      .byt 00           ;2nd object


CurrShip .byt 01

_InitTestCode 
.(

         LDA #<OBS        ;Object records
         LDY #>OBS
         JSR Init3D

         LDA #<COBRA     ;Object data
         LDY #>COBRA
         LDX #1          ;ID
         JSR AddObj
         STX VOB          ;View object

         LDA #<ADDER     ;Object data
         LDY #>ADDER
         LDX #81
         JSR AddObj
         STX ROB          ;Rotate object
         STA POINT        ;Object pointer
         STY POINT+1
         LDY #5           ;Set center
l1       LDA OCEN,Y
         STA (POINT),Y
         DEY
         BPL l1



         clc              ; Wireframe mode
         JSR SetParms

         lda #>$2000
         ldy #>$2000
         ldx #10
         jsr SetVisParms
         rts

         rts

.)

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
 
    jsr CalcView
    jsr SortVis   

#ifndef FILLEDPOLYS
    jsr clr_hires2
#endif

    jsr DrawAllVis   ;Draw objects
 

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
         CMP #"N"
         BEQ nextship


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
movf     LDA #$07; 50
         .byt $2C
movb     LDA #$F9; CE
         jmp MoveForwards
movr     LDA #$07
         .byt $2C
movl     LDA #$f9
         jmp MoveSide
movd     lda #$07
         .byt $2c
movu     lda #$f9
         jmp MoveDown


nextship
         ldx ROB
         beq nada
         jsr DelObj
nada
         ldx CurrShip
         inc CurrShip
         cpx #30
         bne cont
         ldx #0
         stx CurrShip

cont
         lda ShipsHi,x
         tay
         lda ShipsLo,x
         LDX #81
         JSR AddObj
         STX ROB          ;Rotate object
         STA POINT        ;Object pointer
         STY POINT+1
         LDY #5           ;Set center
l1       LDA OCEN,Y
         STA (POINT),Y
         DEY
         BPL l1
         rts
        


.)

objs .byt 00
MoveOthers
.(
    ldx NUMOBJS
    beq end
    dex 
    beq end

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
end
    rts
.)



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





