;
; Radar object.  To do the radar, an object is used whose points are simply
; the translated and rotated object centers.  This object is then projected
; using the obj3d routines, and the points plotted.
;


#define ELITERADAR
#define LIMIT


RADOBJ   
         .byt 0            ;Normal object
         .byt 0            ;Number of points
         .byt 0            ;Number of faces

; Point list

RADDAT   .dsb 256



CreateRadar
.(

        LDA #<RADOBJ
        LDY #>RADOBJ
        LDX #$FF
        JSR AddObj     ;Radar object = object 0
        jsr SetCurOb
        
        lda #0
        tay           ; z and y angles 0 deg of rotation
        ldx #6;      ; rotate 6*360/256 deg around x axis (about 8.4 deg)
        jsr SetMat

        rts
.)

;
; DrawRadar -- Compute and draw radar
; display, by creating a new object whose points are simply the
; (scaled) object centers.
;

#define   RADOFF    24+20            ;Size of radar
RADFLAG  .byt $00         ;Radar toggle

IDENTITY .byt 64,0,0       ;Identity matrix
         .byt 0,64,0
         .byt 0,0,64

; Set radar center to view center
; Needs X loaded with the Player's ship (Or the Viewpoint object)
SetRadar
.( 
         ;LDX VOB
         ;LDX ROB
         stx savx+1
         JSR SetCurOb
         STA TEMP
         STY TEMP+1
         LDX #00
         JSR SetCurOb
         STA POINT
         STY POINT+1
         LDY #5
l        LDA (TEMP),Y
         STA (POINT),Y
         DEY
         BPL l
savx
         ldx #0
rts2     RTS


+DrawRadar
;        lda #0
;dbug     beq dbug

         LDA RADFLAG
         BMI rts2
         LDX #00
         JSR GetObj
         STA POINT
         STY POINT+1

         LDY #ObjCenPos
         LDA (POINT),Y
         TAX
         LDA #000         ;First, cheat the center
         STA CZ,X         ;by putting it at (0,0,200); note radar is object 0
         LDA #02          ; WAS 03! ;(so projection will work out correctly -- don't want
         STA HCZ,X        ;negative points!)

         LDX #8
lback    LDA IDENTITY,X
         STA VIEWMAT,X    ;Don't add any extra viewpoint rotation
         DEX
         BPL lback

#ifdef ELITERADAR

         ldy #0
         ldx NUMOBJS
         dex
loop2    
         jsr IsInLimit  
         beq skip2
         iny
skip2
         dex
         bne loop2
 
         ;txa
         tya
         asl
         tax
#else
         LDX NUMOBJS
         DEX
#endif
        
         
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

#ifdef ELITERADAR
         LDX NUMOBJS
         DEX
#endif

         LDY #00          ;Order doesn't matter
loop    

#ifdef ELITERADAR
         jsr IsInLimit
         beq skip
         
         ;LDA CX,X
         ;STA X1
         LDA HCX,X
         ;JSR DIV8X1
         STA RADDAT,Y

         ;LDA CY,X
         ;STA X1
         LDA HCY,X
         ;JSR DIV8X1
         STA (TEMP),Y
         

         ;LDA CZ,X
         ;STA X1
         LDA HCZ,X
         ;JSR DIV8X1
         STA (POINT),Y

#ifdef ELITERADAR
         ; Add a second point to simulate Elite's radar at (x,0,z)
         
         lda RADDAT,Y
         sta RADDAT+1,Y
         lda (POINT),Y
         iny
         sta (POINT),Y
         
         lda #0
         sta (TEMP),Y 
#endif
         INY
skip         
         DEX
         BNE loop        ;0 is radar object

         STY RADOBJ+1     ;Number of points

         LDA XOFFSET      ;Change coordinate offsets
         PHA
         LDA YOFFSET
         PHA
         LDA #RADOFF
         STA XOFFSET      ;Upper-left cornerof screen
         STA YOFFSET

         LDX #00
         JSR RotDraw

         PLA
         STA YOFFSET
         PLA
         STA XOFFSET

#ifdef ELITERADAR
        jmp DrawLollipops
#else
        jmp DrawLines
#endif
.)


#ifdef 0
;
;* Divide X1,.A by 8 and normalize
;*
DIV8X1   
.(

         CMP #$80
         ROR
         ROR X1
         CMP #$80
         ROR
         ROR X1
         CMP #$80
         ROR
         ROR X1


         CMP #$80
         ROR
         ROR X1
         CMP #$80
         ROR
         ROR X1
         CMP #$80
         ROR
         ROR X1
         CMP #$80
         ROR
         ROR X1
         CMP #$80
         ROR
         ROR X1


         AND #$FF         ;BMI, BEQ on exit
         BPL pos         ;Check between -95..94
         CMP #$FF
         BNE neg95
         LDA X1
         CMP #($a0+1)        ; a0=-96
         BCS elrts
neg95    LDA #($a0+1)        ;fudge a bit
elrts    RTS

pos      BNE pos95
         LDA X1
         CMP #96
         BCC elrts
pos95    LDA #95-1
         RTS

.)
#endif

#ifdef ELITERADAR
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



DrawLollipops
.(
         ldy RADOBJ+1
         beq elrts
 
loop2    LDY RADOBJ+1     ;Now plot each point
         DEY

         
         LDA PLISTX,Y
         STA X1
         sta X2
         LDA PLISTX+$80,Y
         STA X1+1
         sta X2+1
         LDA PLISTY,Y
         STA Y1
         LDA PLISTY+$80,Y
         STA Y1+1
          
         dey
         lda PLISTY,Y
         sta Y2
         lda PLISTY+$80,Y
         sta Y2+1
          

         JSR _DrawClippedLine


         ; Draw the head
         lda Y2
         sta Y1
         lda Y2+1
         sta Y1+1
         lda X1
         clc
         adc #1
         sta X2
         lda X1+1
         adc #0
         sta X2+1

         jsr _DrawClippedLine        
skip
         DEC RADOBJ+1
         dec RADOBJ+1 
         bne loop2
elrts    RTS              ;Whew!




.)

#else


DrawLines
.(
 
loop2    LDY RADOBJ+1     ;Now plot each point
         DEY
         dey
         
         LDA PLISTX,Y
         STA X1
         LDA PLISTX+$80,Y
         STA X1+1
         LDA PLISTY,Y
         STA Y1
         LDA PLISTY+$80,Y
         STA Y1+1

        LDA #RADOFF      ;Line from center to point
        STA X2
        STA Y2
        LDA #00
        STA X2+1
        STA Y2+1

        jsr _DrawClippedLine

        DEC RADOBJ+1
        dec RADOBJ+1
        bne loop2
elrts    RTS 

.)



#endif


#ifdef LIMIT

; This function check if the object whose pos in the list is in
; reg X is to be displayed on the radar.
; Returns Z=0 if it is or Z=1 else.

IsInLimit
.(

        ; Check if this object is not to appear on scanners:
        ; Basically if this is the Viewpoint Object or if it
        ; is some type of "invisible" object (ECMs or planets...)
 
         cpx VOB        ; Check if this object is the viewpoint object (our ship)
         beq skip


         ; Check if it is out of range. BBC Code is
         ; int d = abs(obj->location.x) | abs(obj->location.y) | abs(obj->location.z);
         ; if (d&0xc000) {
         ; return; // far away
         ;}   
         ; PROBLEM: List of pointers need the number of points, before this loop...!
         ; So a loop checking is run twice

         lda HCX,x
         bpl nothingX
         ;lda #0
         ;sec
         ;sbc HCX,x
         eor #$ff
nothingX 
         cmp #$40
         bcs skip

         lda HCY,x
         bpl nothingY
         ;lda #0
         ;sec
         ;sbc HCY,x
         eor #$ff
nothingY
         cmp #$40
         bcs skip

         lda HCZ,x
         bpl nothingZ
         ;lda #0
         ;sec
         ;sbc HCZ,x
         eor #$ff
nothingZ
         cmp #$40
         bcs skip

         lda #$ff
         rts
skip
         lda #0
         rts    

.)
      
#endif    

;       lda HCX,x
;       and #%11000000
;       beq ok
;       bpl skip
;       eor #%1100000
;       bne skip 
;ok




