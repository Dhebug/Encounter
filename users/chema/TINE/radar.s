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

RADDAT   .dsb MAXSHIPS*6



CreateRadar
.(
        lda #0
        sta RADOBJ+1
  
        lda #<RADOBJ
        ldy #>RADOBJ
        ldx #$FF
        jsr AddObj     ;Radar object = object 0
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

; Radar position

#define   RADOFFX         116
#define   RADOFFY         163

IDENTITY .byt 64,0,0       ;Identity matrix
         .byt 0,64,0
         .byt 0,0,64

; Set radar center to view center
; Needs X loaded with the Player's ship ID (Or the Viewpoint object)
SetRadar
.( 
         stx savx+1
         jsr SetCurOb
         sta l+1
         sty l+2
         ldx #00
         jsr GetObj
         sta l2+1
         sty l2+2
         ldy #5
l        lda $1234,y	; SMC
l2       sta $1234,y	; SMC
         dey
         bpl l
savx
         ldx #0 ; Get back X (SMC)
	     rts
.)

.zero
tmp1c .byt 0


.text

bufferY .dsb MAXSHIPS*2
bufferZ .dsb MAXSHIPS*2

DrawRadar
.(
	; First, cheat the center by putting it at (0,0,208)
	; (so projection will work out correctly -- don't want
	; negative points!)

		 ldx #00	; note radar is object 0
         jsr GetObj
         sta POINT
         sty POINT+1

         ldy #ObjCenPos
         lda (POINT),y
         tax
         lda #$d0         
         sta CZ,X         
         lda #$00         
         sta HCZ,X        

		 ;Don't add any extra viewpoint rotation

         ldx #8
lback    lda IDENTITY,x
         sta VIEWMAT,X    
         dex
         bpl lback


         ldy #0
         sty tmp1c
         ldx #1
         jsr SetCurOb

         ; Now iterate through object list 
         jsr GetNextOb
		 ; There must be at least one planet, unless we implement witchspace
         ;cpx #0  
         ;beq end 
loop    
         sta tmp1
         sty tmp1+1
  
		 ; Is Invisible ship?
		 ; Check if this object is not to appear on scanners:
		 ; Basically if this is the Viewpoint Object or if it
		 ; is some type of "invisible" object (ECMs or planets...)

	     ; Check ship ID byte...
		 ldy #ObjID
		 lda (tmp1),y
		 bmi skip	  ; Not visible object 

         jsr IsInLimit  
         beq skip

         ldy #ObjCenPos
         lda (tmp1),y
         tax
        
         ldy tmp1c
        
         lda HCX,x
         sta RADDAT,y
		 sta RADDAT+1,y ; Add a second point to simulate Elite's radar at (x,0,z)

         lda HCY,x      ; Y is divided by 4 (avoid long stalks)
         cmp #80
         ror
         ;cmp #80
         ;ror
         sta bufferY,y
         lda #0
         sta bufferY+1,y ; Add a second point to simulate Elite's radar at (x,0,z)
         

         lda HCZ,x
         sta bufferZ,y
		 sta bufferZ+1,y	; Add a second point to simulate Elite's radar at (x,0,z)

         inc tmp1c
         inc tmp1c

		 ; Should check we are not getting out of buffer space, if we are to limit it
		 ; which would be a good idea, since we have many possible objects
		 ; but should not have much visible in radar.
skip
         jsr GetNextOb
         cpx #0
         bne loop
end

		; Copy the points to the Radar Data Points.
		; This is needed as we don't know in advance
		; how many points it will have and they should be
		; stored in the data consecutively X1..Xn,Y1..Yn,Z1..Zn


		ldy tmp1c		; Number of points
		sty RADOBJ+1    ; Store in Radar data
		tya
		clc
		adc #<RADDAT
        sta _smc_destY+1        ;y-coords
        lda #>RADDAT
        adc #00
        sta _smc_destY+2
        tya
        adc _smc_destY+1
        sta _smc_destZ+1        ;z-coords
        lda _smc_destY+2
        adc #00
        sta _smc_destZ+2

		dey
loopcopy
		lda bufferY,y
_smc_destY
		sta $dead,y
		lda bufferZ,y
_smc_destZ
		sta $dead,y
		dey
		bpl loopcopy
	

		 ; Cheat the coordinate offsets to the 
		 ; position where the radar is.
         lda XOFFSET      
         pha
         lda YOFFSET
         pha
         lda #RADOFFX
         sta XOFFSET      
         lda #RADOFFY
         sta YOFFSET

		 ; Rotate and project!	
         ldx #00
         jsr RotDraw

		 ; Get position of the centre of the screen
		 ; back.
         pla
         sta YOFFSET
         pla
         sta XOFFSET

		 ; Draw the hockey sticks !!

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


         ; Heads
; a=%000001 (1), plot, iny, a=%110000, plot
; a=%000010 (2), a=%000011 (3), plot, iny, a=%100000, plot
; a=%000100 (4), a=%000111 (7), plot
; a=%001000 (8), a=%001110 (14), plot
; a=%010000 (16),a=%011100 (28), plot
; a=%100000 (32),a=%111000 (56), plot

         lda RADOBJ+1
         sta countobjs
         beq elrts
 
		 ;Now plot each point
loop2    ldy countobjs 
         dey

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


 /*        ldx tmp
         ldy tmp+1
         inx
		 inx
         jsr pixel_address_real
         eor (tmp0),y
         sta (tmp0),y
*/
         dec countobjs	
         dec countobjs	
         bne loop2
elrts    
		 rts              ;Whew!


.)




;savX .dsb MAXSHIPS	; defined in data.s
;savY .dsb MAXSHIPS
countobjs .byt 00

EraseRadar
.(
         lda RADOBJ+1
         sta countobjs
         beq elrts
 
loop2    ldy countobjs      ;Now plot each point
         dey

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

 /*        ldx tmp
         ldy tmp+1
         inx
		 inx
         jsr pixel_address_real
         eor (tmp0),y
         sta (tmp0),y
*/
       
         dec countobjs;DEC RADOBJ+1
         dec countobjs;dec RADOBJ+1 
         bne loop2
elrts    
		 rts              ;Whew!

.)




DrawUp
.(
         sta tmp1
         jsr pixel_address_real
		 sta loop_draw+1
		 ldx tmp1
		 sec
loop_draw
		 lda #0	; SMC	get scancode
         eor (tmp0),y   ; Put pixel
         sta (tmp0),y
        
         lda tmp0       ; Decrement pointer
         sbc #40
         sta tmp0
         bcs nodec
         dec tmp0+1   
		 sec
nodec   
		 dex		; Next pixel up
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
         sta loop_draw+1
		 ldx tmp1
		 clc
loop_draw
		 lda #0			; SMC get scancode
         eor (tmp0),y   ; Put pixel
         sta (tmp0),y
        
         lda tmp0       ; Decrement pointer
         adc #40
         sta tmp0
         bcc noinc
         inc tmp0+1   
		 clc
noinc   
         dex	       ; Next pixel up
         bne loop_draw
	     rts
.)



; This function checks if the object whose pointer is in tmp1
; is near enough to be displayed on the radar.
; In reg X we have the object's index.
; Returns Z=0 if it is or Z=1 else.


IsInLimit
.(
		stx savindex+1
        ldy #ObjCenPos
        lda (tmp1),y
        tax
 
         ; Check if it is out of range. BBC Code is
         ; int d = abs(obj->location.x) | abs(obj->location.y) | abs(obj->location.z);
         ; if (d&0xc000) {
         ; return; // far away
         ;}   
 
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
         rts		; Returns with Z=0 (it is in limit)
skip
		 ; Would be nice to take this opportunity to make it
		 ; dissappear from the 3D world.
savindex
		ldx #00	; SMC
		lda _flags,x
		ora #IS_DISAPPEARING
		sta _flags,x
		lda #0
		sta _ttl,x	
        rts			; Returns with Z=1 due to the lda #0...
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
    adc #189
    tax
    lda _VectY
    cmp #$80
    ror
    cmp #$80
    ror
    cmp #$80
    ror
 
    clc
    adc #148
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
	php
	ldx invert
	beq nothing2do
	plp
	lda #$ff
	php
nothing2do
	plp
    bmi end
    jmp inner_dot
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

    ldx compass_index

    jsr GetObj
    sta tmp1
    sty tmp1+1
    ldy #ObjCenPos

    lda (tmp1),Y
    tax

    lda HCZ,x
    sta _VectZ+1

    lda #189
	sta compass_x
	sta sdx
    lda #148
	sta compass_y
	sta sdy
	jmp compass_dot
    ;rts
.)

