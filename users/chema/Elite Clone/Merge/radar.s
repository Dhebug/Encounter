#include "tine.h"

;
; Radar object.  To do the radar, an object is used whose points are simply
; the translated and rotated object centers.  This object is then projected
; using the obj3d routines, and the points plotted.
;


RADOBJ   
         .byt 0            ;Normal object
         .byt 0            ;Number of points
         .byt 0            ;Number of faces

; Point list

RADDAT   .dsb MAXSHIPS*2



CreateRadar
.(
        lda #0
        ;sta RADOBJ
        sta RADOBJ+1
        ;sta RADOBJ+2

        LDA #<RADOBJ
        LDY #>RADOBJ
        LDX #$FF
        JSR AddObj     ;Radar object = object 0
        jsr SetCurOb
        
        lda #0
        tay           ; z and y angles 0 deg of rotation
        ldx #8;       ; rotate 8*360/256 deg around x axis (about 8.4 deg)
        jsr SetMat

        rts
.)

;
; DrawRadar -- Compute and draw radar
; display, by creating a new object whose points are simply the
; (scaled) object centers.
;

#define   RADOFFX         116;120            ;Size of radar
#define   RADOFFY         175-5;199-56+30;128+36-2  

IDENTITY .byt 64,0,0       ;Identity matrix
         .byt 0,64,0
         .byt 0,0,64

; Set radar center to view center
; Needs X loaded with the Player's ship ID (Or the Viewpoint object)
SetRadar
.( 
         ;LDX VOB
         ;LDX ROB
         stx savx+1
         JSR SetCurOb
         STA TEMP
         STY TEMP+1
         LDX #00
         JSR GetObj;SetCurOb
         STA POINT
         STY POINT+1
         LDY #5
l        LDA (TEMP),Y
         STA (POINT),Y
         DEY
         BPL l
savx
         ldx #0 ; Get back X (SMC)
rts2     RTS

tmp1c .byt 0

+DrawRadar
         ;rts
         LDX #00
         JSR GetObj
         STA POINT
         STY POINT+1

         LDY #ObjCenPos
         LDA (POINT),Y
         TAX
         LDA #$d0          ;First, cheat the center
         STA CZ,X         ;by putting it at (0,0,200); note radar is object 0
         LDA #$00          ; WAS 03! ;(so projection will work out correctly -- don't want
         STA HCZ,X        ;negative points!)

         LDX #8
lback    LDA IDENTITY,X
         STA VIEWMAT,X    ;Don't add any extra viewpoint rotation
         DEX
         BPL lback

         ldy #0
         sty tmp1c
         ldx #1
         jsr SetCurOb
         ; Now iterate through object list 
         jsr GetNextOb
         cpx #0  
         beq end2 
         ;bcs end2   

loop2    
         sta tmp1
         sty tmp1+1
         jsr IsAppearing
         beq skip2
         jsr IsInLimit  
         beq skip2
         inc tmp1c
skip2
         jsr GetNextOb
         cpx #0
         bne loop2
         ;bcc loop2

end2
         lda tmp1c
         asl
         tax
         STX RADOBJ+1     ;Number of points
         TXA
         CLC
         ADC #<RADDAT
         STA TEMP         ;y-coords
         LDA #>RADDAT
         ADC #00
         STA TEMP+1
         TXA
         ADC TEMP
         STA POINT        ;z-coords
         LDA TEMP+1
         ADC #00
         STA POINT+1

         ;LDX NUMOBJS
         ;DEX

         LDY #00          ;Order doesn't matter
         sty tmp1c
         ldx #1 
         jsr SetCurOb
         jsr GetNextOb
         cpx #0
         beq end
         ;bcs end

loop    
         sta tmp1
         sty tmp1+1
         jsr IsAppearing
         beq skip
         jsr IsInLimit
         beq skip

         ldy #ObjCenPos
         lda (tmp1),Y
         tax
        
         ldy tmp1c
        
         LDA HCX,X
         STA RADDAT,Y

         LDA HCY,X      ; Y is divided by 4 (avoid long stalks)
         cmp #80
         ror
         cmp #80
         ror
         STA (TEMP),Y
         

         LDA HCZ,X
         STA (POINT),Y

         ; Add a second point to simulate Elite's radar at (x,0,z)
         
         lda RADDAT,Y
         sta RADDAT+1,Y
         lda (POINT),Y
         iny
         sta (POINT),Y
         
         lda #0
         sta (TEMP),Y 

         inc tmp1c
         inc tmp1c

skip         
         jsr GetNextOb
         cpx #0
         BNE loop        ;0 is radar object
         ;bcc loop   

;         STY RADOBJ+1     ;Number of points
end
         LDA XOFFSET      ;Change coordinate offsets
         PHA
         LDA YOFFSET
         PHA
         LDA #RADOFFX
         STA XOFFSET      ;Upper-left cornerof screen
         LDA #RADOFFY
         STA YOFFSET

         LDX #00
         JSR RotDraw

         PLA
         STA YOFFSET
         PLA
         STA XOFFSET

        jmp DrawLollipops

.)


; Draws lollipops at rotated center positions
; It seems that a further check should see if
; abs(x) is less than 70 and the size of the
; stalk is below 52. 

;  if (abs(x) < 70 /*&& (abs(y+z)) < 52 */) 
;  {
;    lollipop(x, y, z, LOLLIPOP_COL(colour), index);
;  }
;
; We know x is in the interval -94..95 and maybe
; that height of stalk is also in that range?


;savX .dsb MAXSHIPS	; defined in data.s
;savY .dsb MAXSHIPS
countobjs .byt 00

EraseRadar
.(
         ;rts

         lda RADOBJ+1
         sta countobjs
         beq elrts
 
loop2    ldy countobjs ;LDY RADOBJ+1     ;Now plot each point
         DEY

         lda savX,y   ; X1 the same as X2
         tax        
         stx tmp       ; Save X2 for later use (head)

         lda savY-1,y   ; Y2
         sta tmp+1     ; Save Y2 for later use (head)

         lda savY,y   ; Y1
         tay
         sec
         sbc tmp+1      ; Y1-Y2 (heigth)

         beq next       ; Just draw the head...
         bmi DD
         jsr DrawUp
         jmp next  
DD       jsr DrawDown     
         
next
                         
         ; Draw the head
         ldx tmp
         ldy tmp+1
         jsr pixel_address_real
         eor (tmp0),y
         sta (tmp0),y

         ldx tmp
         ldy tmp+1
         inx
         jsr pixel_address_real
         eor (tmp0),y
         sta (tmp0),y

       
skip
         dec countobjs;DEC RADOBJ+1
         dec countobjs;dec RADOBJ+1 
         bne loop2
elrts    RTS              ;Whew!



.)


DrawLollipops
.(
         lda RADOBJ+1
         sta countobjs
         beq elrts
 
loop2    ldy countobjs ;LDY RADOBJ+1     ;Now plot each point
         DEY

         lda PLISTX,y   ; X1 the same as X2
         sta savX,y
         tax        
         stx tmp       ; Save X2 for later use (head)

         lda PLISTY-1,y   ; Y2
         sta savY-1,y    
         sta tmp+1     ; Save Y2 for later use (head)

         lda PLISTY,y   ; Y1
         sta savY,y
         tay
         sec
         sbc tmp+1      ; Y1-Y2 (heigth)

         beq next       ; Just draw the head...
         bmi DD
         jsr DrawUp
         jmp next  
DD       jsr DrawDown     
         
next
                         
         ; Draw the head
         ldx tmp
         ldy tmp+1
         jsr pixel_address_real
         eor (tmp0),y
         sta (tmp0),y

         ldx tmp
         ldy tmp+1
         inx
         jsr pixel_address_real
         eor (tmp0),y
         sta (tmp0),y

       
skip
         dec countobjs;DEC RADOBJ+1
         dec countobjs;dec RADOBJ+1 
         bne loop2
elrts    RTS              ;Whew!



.)

DrawUp

.(
 
         sta tmp1
         jsr pixel_address_real
         ;sta tmp1+1
         tax
loop_draw
         txa ;lda tmp1+1     ; get scancode
         eor (tmp0),y   ; Put pixel
         sta (tmp0),y
        
         lda tmp0       ; Decrement pointer
         sec
         sbc #40
         sta tmp0
         bcs nodec
         dec tmp0+1   
nodec   
         dec tmp1       ; Next pixel up
         bne loop_draw

    rts

.)


DrawDown

.(
         sta tmp1
         lda #0
         sec
         sbc tmp1
         sta tmp1
        
         jsr pixel_address_real
         tax ;sta tmp1+1
loop_draw
         txa ;lda tmp1+1     ; get scancode
         eor (tmp0),y   ; Put pixel
         sta (tmp0),y
        
         lda tmp0       ; Decrement pointer
         clc
         adc #40
         sta tmp0
         bcc noinc
         inc tmp0+1   
noinc   
         dec tmp1       ; Next pixel up
         bne loop_draw

    rts

.)


; This function checks if the object whose id is in reg X 
; is to be displayed... Checks for planets, debris, ECMS...
; Returns Z=0 if it is or Z=1 else.

IsAppearing
.(
 
   ; Check if this object is not to appear on scanners:
   ; Basically if this is the Viewpoint Object or if it
   ; is some type of "invisible" object (ECMs or planets...)
   ;cpx #1        ; Check if this object is the viewpoint object (our ship)
   ;beq skip

    ; Invisible ship
    ; Check ship ID byte...
    ldy #ObjID
    lda (tmp1),y
    bmi skip  ; Not visible object 

   lda #$ff
   rts
skip
   lda #0
   rts    


.)



; This function checks if the object whose pos in the list is in
; reg X is near enough to be displayed on the radar.
; Returns Z=0 if it is or Z=1 else.


IsInLimit
.(
        ldy #ObjCenPos
        lda (tmp1),Y
        tax
 
         ; Check if it is out of range. BBC Code is
         ; int d = abs(obj->location.x) | abs(obj->location.y) | abs(obj->location.z);
         ; if (d&0xc000) {
         ; return; // far away
         ;}   
         ; PROBLEM: List of pointers needs the number of points, before this loop...!
         ; So a loop checking is run twice

         lda HCX,x
         bpl nothingX
         eor #$ff
nothingX 
         cmp #$30
         bcs skip

         lda HCY,x
         bpl nothingY
         eor #$ff
nothingY
         cmp #$30
         bcs skip

         lda HCZ,x
         bpl nothingZ
         eor #$ff
nothingZ
         cmp #$30
         bcs skip

         ; Not far far away... but is it in range?
         ; Need to calculate distance!

         lda #0
         sta op1
         sta op1+1

         lda HCX,x
         pha
         lda HCY,x
         pha
         lda HCZ,x
         jsr do_square
         pla
         jsr do_square    
         pla
         jsr do_square    
        
         ; check if greater than $3000^2=$9000000
         ; Check only high byte (op1+1) > $09
         lda op1+1
         cmp #$09
         bcs skip   

         lda #$ff
         bne afters
skip
         lda #0
afters  
   
         rts    

.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Compass code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

compass_x .byt 00
compass_y .byt 00
compass_index .byt 02   ; Planet

update_compass
.(
    ldx compass_index

    jsr GetObj
    sta tmp1
    sty tmp1+1
    ldy #ObjCenPos
    lda (tmp1),Y
    tax

    lda CX,x
    sta _VectX
    lda HCX,x
    sta _VectX+1
    lda CY,x
    sta _VectY
    lda HCY,x
    sta _VectY+1
    lda CZ,x
    sta _VectZ
    lda HCZ,x
    sta _VectZ+1

    jsr _norm_big
    
    lda _VectX
    cmp #$80
    ror
    cmp #$80
    ror
    cmp #$80
    ror
 
    clc
    adc #171
    tax
    lda _VectY
    cmp #$80
    ror
    cmp #$80
    ror
    cmp #$80
    ror
 
    clc
    adc #155
    tay

    cpx compass_x
    bne update
    cpy compass_y
    beq end

update    
    stx savx+1
    sty savy+1
    jsr clear_compass
savx
    ldx #0
savy
    ldy #0
    stx compass_x
    sty compass_y
    stx sdx
    sty sdy
    jsr compass_dot
end    
    rts

.)


compass_dot
.(
    jsr outer_dot
    lda _VectZ+1
    bmi end
    jsr inner_dot
end
    rts
.)

inner_dot
.(
    jsr pdot        
    
    inc sdx
    jsr pdot         
    
    inc sdy
    jsr pdot
    
    dec sdx
    jmp pdot
.)


pdot
.(
    ldx sdx
    ldy sdy
    jsr pixel_address_real
    eor (tmp0),y
    sta (tmp0),y 
    rts
.)


outer_dot
.(
    dec sdx
    jsr pdot
    inc sdy
    jsr pdot
    inc sdy
    inc sdx       
    jsr pdot
    inc sdx
    jsr pdot
    inc sdx
    dec sdy
    jsr pdot
    dec sdy
    jsr pdot
    dec sdy
    dec sdx
    jsr pdot
    dec sdx
    jsr pdot
    inc sdy
    rts
.)

clear_compass
.(
    ldx compass_x
    dex
    stx sdx
    ldy compass_y
    dey
    sty sdy

    lda #4
    sta county
loop2
    lda #4
    sta countx
loop1
    ldx sdx
    ldy sdy
    jsr pixel_address_real
    eor #$ff
    and (tmp0),y
    sta (tmp0),y  
    inc sdx
    dec countx
    bne loop1    

    lda sdx
    sec
    sbc #4
    sta sdx

    inc sdy
    dec county
    bne loop2

    rts

countx .byt 0
county .byt 0

.)

sdx .byt 0
sdy .byt 0

set_compass
.(
    lda #171
    sta compass_x
    lda #155
    sta compass_y
    rts
.)

