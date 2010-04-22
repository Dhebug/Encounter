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

RADDAT   .dsb MAX_RADAR_POINTS*6


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

;bufferY .dsb MAX_RADAR_POINTS*2
;bufferZ .dsb MAX_RADAR_POINTS*2

#define bufferY str_buffer
#define bufferZ str_buffer+MAX_RADAR_POINTS*2

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
         cpx #0  
         beq end 
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
		 lda tmp1c
		 cmp #(MAX_RADAR_POINTS*2)
		 beq end
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
		bne cont 
		rts
cont
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


         lda RADOBJ+1
         beq elrts
         sta countobjs
  
		 ;Now plot each point
loop2    ldy countobjs 
         dey

         lda PLISTX,y   ; X1 the same as X2
         sta radar_savX,y
         tax        
         stx tmp       ; Save X2 for later use (head)

         lda PLISTY-1,y   ; Y2
         sta radar_savY-1,y    
         sta tmp+1     ; Save Y2 for later use (head)

         lda PLISTY,y   ; Y1
         sta radar_savY,y
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

		 sta tmp
		 lsr
		 ora tmp
		 eor (tmp0),y
         sta (tmp0),y
 		 bcc normal		; Carry set above, on the lsr
		 lda #%100000
		 iny
		 eor (tmp0),y
         sta (tmp0),y
normal

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

         lda radar_savX,y   ; X1 the same as X2
         tax        
         stx tmp       ; Save X2 for later use (head)

         lda radar_savY-1,y   ; Y2
         sta tmp+1     ; Save Y2 for later use (head)

         lda radar_savY,y   ; Y1
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

		 sta tmp
		 lsr
		 ora tmp
		 eor (tmp0),y
         sta (tmp0),y
 		 bcc normal		; Carry set above, on the lsr
		 lda #%100000
		 iny
		 eor (tmp0),y
         sta (tmp0),y
normal
         dec countobjs
         dec countobjs
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
        
         lda tmp0       ; Increment pointer
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

/*
update_compass_forced
.(
	lda #$00
	sta compass_x
	sta compass_y
.)
*/

update_compass
.(
    ldx compass_index
	cpx #2
	bne noplcom
	lda _planet_dist
	cmp #PDIST_TOOFAR2
	bcc noplcom
	jmp clear_compass
noplcom

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
    adc #188
    tax
    lda _VectY
    cmp #$80
    ror
    cmp #$80
    ror
    cmp #$80
    ror
 
    clc
    adc #147
    tay

    ;cpx compass_x
    ;bne update
    ;cpy compass_y
    ;bne update
	;rts
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
    ;jsr compass_dot
	; Let the program flow
.)
compass_dot
.(
	lda _VectZ+1
;	php
;	ldx invert
;	beq nothing2do
;	plp
;	lda #$ff
;	php
;nothing2do
;	plp
    bmi hollow
	lda dot_patt
	ldx dot_patt2
	jmp plotit
hollow
	lda dot_patt
	ldx dot_patt+1
plotit
	sta tmp1
	stx tmp2
	lda #0
	sta tmp1+1
	sta tmp2+1
	; Let the program flow
.)	
plot_dot
.(
    ldx compass_x
    ldy compass_y
    jsr pixel_address_real

	asl
	asl
	asl
	bcs plot_dot_norot
loop
	lsr tmp1
	ror tmp1+1
	lsr tmp2
	ror tmp2+1
	asl
	bcc loop
	lsr tmp1+1
	lsr tmp1+1
	lsr tmp2+1
	lsr tmp2+1

+plot_dot_norot
	lda (tmp0),y
+patch_ora1
	ora tmp1
	sta (tmp0),y
	iny
	lda (tmp0),y
+patch_ora2
	ora tmp1+1
	sta (tmp0),y

	tya
	clc
	adc #39
	tay
	lda (tmp0),y
+patch_ora3
	ora tmp2
	sta (tmp0),y
	iny
	lda (tmp0),y
+patch_ora4
	ora tmp2+1
	sta (tmp0),y

	tya
	clc
	adc #39
	tay
	lda (tmp0),y
+patch_ora5
	ora tmp2
	sta (tmp0),y
	iny
	lda (tmp0),y
+patch_ora6
	ora tmp2+1
	sta (tmp0),y

	tya
	clc
	adc #39
	tay
	lda (tmp0),y
+patch_ora7
	ora tmp1
	sta (tmp0),y
	iny
	lda (tmp0),y
+patch_ora8
	ora tmp1+1
	sta (tmp0),y

	rts
.)

dot_patt
	.byt %00011000
	.byt %00100100
dot_patt2
	.byt %00111100

clear_compass
.(

  	lda #$ff
	sta tmp1+1
	sta tmp2+1

	lda dot_patt
	eor #$ff
	sta tmp1
	lda dot_patt2
	eor #$ff
	sta tmp2

    ldx compass_x
    ldy compass_y
    jsr pixel_address_real

	asl
	asl
	asl
	bcs norot
loop
	sec
	ror tmp1
	ror tmp1+1
	sec
	ror tmp2
	ror tmp2+1
	asl
	bcc loop

	sec
	ror tmp1+1
	sec
	ror tmp1+1
	sec
	ror tmp2+1
	sec
	ror tmp2+1
norot
	lda #$25	; AND zp opcode
	sta patch_ora1
	sta patch_ora2
	sta patch_ora3
	sta patch_ora4
	sta patch_ora5
	sta patch_ora6
	sta patch_ora7
	sta patch_ora8
	jsr plot_dot_norot

	lda #$05	; ORA zp opcode
	sta patch_ora1
	sta patch_ora2
	sta patch_ora3
	sta patch_ora4
	sta patch_ora5
	sta patch_ora6
	sta patch_ora7
	sta patch_ora8

	rts
.)


set_compass
.(

    ldx #2
	stx compass_index

    jsr GetObj
    sta tmp1
    sty tmp1+1
    ldy #ObjCenPos

    lda (tmp1),Y
    tax

    lda HCZ,x
    sta _VectZ+1

    lda #188
	sta compass_x
    lda #147
	sta compass_y
	jsr compass_dot
	jmp update_ship_id
    ;rts
.)

reinit_compass
.(
	ldx #2
	stx compass_index
	lda _current_screen
	cmp #SCR_FRONT
	bne dont
	jsr update_ship_id
	jmp update_compass
dont
	rts
.)

compass_next
.(
	ldx compass_index
loop
	jsr SetCurOb
	jsr GetNextOb
	cpx #0
	bne c1
	ldx #2
	jmp setit
c1
	jsr GetShipType
	bmi loop
setit
	stx compass_index
	jsr update_ship_id
	jsr SndCompass
	jmp update_compass
.)