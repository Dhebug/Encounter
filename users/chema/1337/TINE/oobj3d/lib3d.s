; lib3d
; Stephen L. Judd	sjudd@nwu.edu
; Oric version José María Enguita (2008)
; Based on  Version 2.0.2/99

#include "obj3d.h"
#include "params.h"

; Some zero-page addresses
.zero
;*=$00
__lib3d_zeropage_start


;Pointer to the special multiplication table for rotproj 
MATMULT  .word tab_rotmath

; For the fast multiplication routine
MultLo1 .byt 00    			;8 bytes zp index addresses
		.byt >tab_multLO2
MultHi1 .byt 00
		.byt >tab_multHI2
MultLo2 .byt 00
		.byt >tab_multLO 
MultHi2 .byt 00
		.byt >tab_multHI



; Angles for the local matrix, used by CALCMAT
; Keep them as zero-page addresses for now, so
; you can keep them updated for in-program use.
; If deemed necessary they can be put in tmp variables
; to save space.

thetaz  .byt 00
thetay  .byt 00
thetax  .byt 00

;*=$14   ; Keep $12,$13 untouched

; Local rotation matrix
A11     .byt 00          
B12     .byt 00
C13     .byt 00
D21     .byt 00
E22     .byt 00
F23     .byt 00
G31     .byt 00
H32     .byt 00
I33     .byt 00


;Viewpoint rotation matrix
VA11    .byt 00          
VB12    .byt 00
VC13    .byt 00
VD21    .byt 00
VE22    .byt 00
VF23    .byt 00
VG31    .byt 00
VH32    .byt 00
VI33    .byt 00


; GLOBROT variables

count    .byt 00
SIGN     .byt 00

;*=$35            ; Keep some locations used by ROM routines untouched

tCX      .byt 00,00       ;Temporary variables for centers
CXSGN	 .byt 00
tCY      .byt 00,00
CYSGN	 .byt 00
tCZ      .byt 00,00
CZSGN	 .byt 00

;*=$7c       ; $50-$7b are used by C compiler, keep them safe.


C0XLO    .byt 00,00       ;Centers, original points
C0XHI    .byt 00,00
C0YLO    .byt 00,00
C0YHI    .byt 00,00
C0ZLO    .byt 00,00
C0ZHI    .byt 00,00

TM1      .word 00         ;Temporary storage for
TM2      .word 00         ;multiplication


; ROTPROJ variables

INDEX    .dsb 10          ;Center index

AUXP     .word 00         ;Auxiliary pointer
TEMPX    .word 00
TEMPY    .word 00
TEMPZ    .word 00


XOFFSET  .byt 00          ;Center of the screen
YOFFSET  .byt 00


CXLO     .word 00         ;Pointers to list of (rotated)
CXHI     .word 00         ;centers.
CYLO     .word 00
CYHI     .word 00
CZLO     .word 00
CZHI     .word 00



ROTFLAG  .byt 00          ;Rotate or rotate+project.
                          ;Also used by ACCROTX etc.

P0X      .word 00         ;Points to be rotprojed
P0Y      .word 00         ;(pointers)
P0Z      .word 00

/*
PLISTZLO .word 00         ;Place to store rotated z-coords
PLISTZHI .word 00         ;used for depth-sorting, etc.

PLISTXLO .word 00         ;Place to store rotprojed
PLISTXHI .word 00         ;point (same as used by POLYFILL)
PLISTYLO .word 00
PLISTYHI .word 00
*/

__lib3d_zeropage_end


; Now the main code

.text

; Some macros... to the extent Oric's version
; of xa allows them

/*
;Multiply A*Y, store in X, A

#define MULTAY  sta MultLo1  :\
                sta MultHi1  :\
                eor #$ff :\
				clc	:\
				adc #1 :\
                sta MultLo2  :\
                sta MultHi2  :\
                sec      :\
                lda (MultLo1),y :\
                sbc (MultLo2),y :\
                tax :\
                lda (MultHi1),y :\
                sbc (MultHi2),y 

*/

;Multiply A*Y, store in (par, A)

#define MULTAY(par)  sta MultLo1 : sta MultHi1 : eor #$ff : clc : adc #1 : sta MultLo2 : sta MultHi2 : sec : lda (MultLo1),y : sbc (MultLo2),y : sta par : lda (MultHi1),y : sbc (MultHi2),y 

;Quick version that assumes pointers are already set-up
;which means A did not change, even if Y may...

#define QMULTAY(par) sec : lda (MultLo1),y : sbc (MultLo2),y : sta par : lda (MultHi1),y : sbc (MultHi2),y 


;Signed multiplication
#define SMULT   sta MATMULT :\
                eor #$FF :\
                clc :\
                adc #01 :\
                sta AUXP :\
                lda (MATMULT),y :\
                sec :\
                sbc (AUXP),y

;Multiplication that assumes
;pointers are already initialized
#define QMULT   lda (MATMULT),y :\
                sec :\
                sbc (AUXP),y





; Fix sign and divide by 64
; If Mij<0 subtract 256*C
; If C<0 subtract 2^16*Mij
;.A, .Y = final result
; Oric inlined



__lib3d_start



;
; Perform a global rotation, i.e. rotate the centers
; (16-bit signed value) by the rotation matrix.
;
; The multiplication multiplies to get a 24-bit result
; and then divides the result by 64 (mult by 4).  To
; perform the signed multiplication
;   - multiply C*y as normal
;   - if y<0 then subtract 256*C
;   - if C<0 then subtract 2^16*y
;
; Parameters .Y = number of points to rotate
;
; v2 -- rewritten for efficiency.  Old version computed
;              1/64 row1*(cx,cy,cz) + 1/64 row2*(cx,cy,cz) + ...
;       New version computes
;              [ cx*column1 + cy*column2 + cz*column3 ] / 64
; Actually, above seems complicated, and doesn't offer
; a huge advantage, so has been skipped for now 3/5/99.
;


GLOBROT  
.(
gloop    dey
         sty count

         lda (C0XLO),y
         sta tCX
         lda (C0XHI),y
         sta tCX+1

         lda (C0YLO),y
         sta tCY
         lda (C0YHI),y
         sta tCY+1

         lda (C0ZLO),y
         sta tCZ
         lda (C0ZHI),y
         sta tCZ+1

         lda VA11         ;row1
         ldx VB12
         ldy VC13
         jsr multrow      ;returns result in .x .a = lo hi
         ldy count
         sta (CXHI),y
         txa
         sta (CXLO),y

         lda VD21         ;row2
         ldx VE22
         ldy VF23
         jsr multrow
         ldy count
         sta (CYHI),y
         txa
         sta (CYLO),y

         lda VG31         ;row3
         ldx VH32
         ldy VI33
         jsr multrow
         ldy count
         sta (CZHI),y
         txa
         sta (CZLO),y

         tya
         ;beq done
         ;jmp gloop
		 bne gloop

done     rts
.)



; Calculate the local matrix
;
; Pass in A,X,Y = angles around z,x,y axis
;
; Stuff to set up Nothing.
;
; On entry .X .Y .A = theta_x theta_y theta_z
; On exit Rotation matrix is contained in 
; Cycle count 390 cycles, worst case.
; Strategy M = Ry Rx Rz where Rz=roll, Rx=pitch, Ry=yaw
;
; Idea Given
;   t1 = tx+ty
;   t2 = tx-ty
;   t3 = tx+tz
;   t4 = tx-tz
;   t5 = tx+ty+tz = t3+ty
;   t6 = tx-ty-tz = t4-ty
;   t7 = tx+ty-tz = t1-tz
;   t8 = tx-tt+tz = t2+tz
;   t9 = ty+tz
;   t10 = ty-tz
;
; then the rotation elements are
;   A11=.5(cos(t9)+c(t10))-.25(sin(t7)+s(t8)-s(t5)-s(t6))
;   B12=.5(s(t9)-s(t10)) - .25(c(t8)-c(t7) + c(t6)-c(t5))
;   C13=.5(sin(t2)-sin(t1))
;   D21=.5(sin(t4)-sin(t3))
;   E22=.5(cos(t3)+cos(t4))
;   F23= sin(tx)
;   G31=.5(s(t9)+s(t10)) - .25(c(t7)-c(t8) + c(t6)-c(t5))
;   H32=.5(c(t10)-c(t9)) - .25(s(t5)+s(t6) + s(t7)+s(t8))
;   I33=.5(cos(t1)+cos(t2))
;
        
; sin and cos tables; originally as
; $CF00-$CFFF	TRIG, table of 32*sin(2*pi*x/128) -- 160 bytes.
; SIN      EQU $CF00
; COS      EQU $CF20

;;.dsb 256-(*&255)

CALCMAT
.( 
         sta thetaz
         stx thetax
         sty thetay

         clc
         adc thetax
         and #$7f
         tax              ;t3
         lda thetax
         sec
         sbc thetaz
         and #$7f
         tay              ;t4
         lda tab_cos,x
         clc
         adc tab_cos,y
         sta E22
         lda tab_sin,y
         sec
         sbc tab_sin,x
         sta D21          ;these are the t3/t4 elements

         txa
         clc
         adc thetay
         and #$7f
         tax              ;t5
         tya
         sec
         sbc thetay
         and #$7f
         tay              ;t6
         lda tab_sin,x
         clc
         adc tab_sin,y
         cmp #$80         ;set c if negative, clear otw.
                          ;(pretty sneaky, eh? )
         ror              ;.25(sin(t5)+...)
         sta A11          ;partial result
         lda tab_cos,y
         sec
         sbc tab_cos,x
         cmp #$80
         ror
         sta B12          ;partial result

         lda thetax
         clc
         adc thetay
         and #$7f
         tax              ;t1
         lda thetax
         sec
         sbc thetay
         and #$7f
         tay              ;t2
         lda tab_sin,y
         sec
         sbc tab_sin,x
         sta C13
         lda tab_cos,x
         clc
         adc tab_cos,y
         sta I33

         txa
         sec
         sbc thetaz
         and #$7f
         tax              ;t7
         tya
         clc
         adc thetaz
         and #$7f
         tay              ;t8
         lda tab_sin,x
         clc
         adc tab_sin,y
         cmp #$80
         ror
         sta tmp
         clc
         adc A11
         sta H32          ;st5+st6+st7+st8
         lda tmp
         sec
         sbc A11          ;st7+st8-st5-st6
         sta A11
         lda tab_cos,x
         sec
         sbc tab_cos,y
         cmp #$80
         ror
         sta tmp
         clc
         adc B12
         sta G31          ;ct7-ct8 + ct6-ct5
         lda B12
         sec
         sbc tmp
         sta B12          ;ct6-ct5 + ct8-ct7

         lda thetay
         clc
         adc thetaz
         and #$7f
         tax              ;t9
         lda thetay
         sec
         sbc thetaz
         and #$7f
         tay              ;t10
         lda tab_cos,x
         clc
         adc tab_cos,y
         sec
         sbc A11
         sta A11

         lda tab_cos,y
         sec
         sbc tab_cos,x
         sec
         sbc H32
         sta H32

         lda tab_sin,x
         sec
         sbc tab_sin,y
         clc
         adc B12
         sta B12

         lda tab_sin,x
         clc
         adc tab_sin,y
         clc
         adc G31
         sta G31

         lda thetax       ;finally, little f23
         and #$7f
         tax
         lda tab_sin,x
         asl
         sta F23
         rts              ;easy-peasy!

.)



;
; The next three procedures rotate the accumulation
; matrix (multiply by Rx, Ry, or Rz).
;
; Carry clear means rotate by positive amount, clear
; means rotate by negative amount.
;
; On entry (.A,.Y) = (lo,hi) pointer to matrix
;   (bytes 0-8 = integer, 9-17=remainder)
;

;#define MATP     tmp1
;#define REMP     tmp3

.zero
MATP .byt 00,00
REMP .byt 00,00
.text

COMROT                    ;Common to all rotations
         ror ROTFLAG
         sta MATP
         sty MATP+1
         clc
         adc #9
         sta REMP
         tya
         adc #00
         sta REMP+1
         rts

ACCROTZ                ;rows 1 and 2
         jsr COMROT
         ldy #00
         ldx #3
         bne ACCROTX2

ACCROTX  
.(
         jsr COMROT
         ldy #3
         ldx #6
.)
ACCROTX2                  ;ACCROTX and ACCROTZ function
.(                        ;identically
         stx compY+1
loop     sty count
         lda (REMP),Y     ;row 2, remainder
         sta AUXP
         lda (MATP),Y
         tax              ;.X = row 2, integer

         iny              ;+3
         iny
         iny
         lda (REMP),y     ;row 3, remainder
         sta AUXP+1
         lda (MATP),y     ;.Y = row 3
         tay
+patch_rot1
         jsr ROTXY
         lda TEMPX
         ldy count
         sta (REMP),Y
         lda TEMPX+1
         sta (MATP),Y

         iny
         iny
         iny
         lda TEMPY
         sta (REMP),Y
         lda TEMPY+1
         sta (MATP),Y

         dey
         dey
compY    cpy #6
         bcc loop
         rts
.)

ACCROTY                ;rows 3 and 1
.(         
		 jsr COMROT
         ldy #6
loop     sty count
         lda (REMP),y     ;row 3, remainder
         sta AUXP
         lda (MATP),Y
         tax              ;.X = row 3, integer

         tya
         sec
         sbc #6
         tay
         lda (REMP),Y     ;row 1, remainder
         sta AUXP+1
         lda (MATP),Y     ;.Y = row 1
         tay
+patch_rot2
         jsr ROTXY
         lda TEMPX
         ldy count
         sta (REMP),Y
         lda TEMPX+1
         sta (MATP),Y

         tya
         sec
         sbc #6
         tay
         lda TEMPY
         sta (REMP),Y
         lda TEMPY+1
         sta (MATP),Y

         ldy count
         iny
         cpy #9
         bcc loop
         rts
.)

; Rotate .X,AUXP .Y,AUXP+1 -> TEMPX,+1 TEMPY,+1
;
; If flag is set for negative rotations, swap X and Y
; and swap destinations (TEMPX TEMPY)
;
ROTXY    
.(
         lda ROTFLAG
         bpl cont
         stx TEMPX        ;Swap X and Y
         sty TEMPY
         ldx AUXP
         ldy AUXP+1
         stx AUXP+1
         sty AUXP
         ldx TEMPY
         ldy TEMPX
cont     lda tab_cosdeltarem,X
         clc
         adc tab_sindeltarem,Y
         sta TEMPX
         lda tab_cosdelta,X       ;x*cos(delta)
         adc tab_sindelta,Y       ;+y*sin(delta)
         sta TEMPX+1
         lda TEMPX
         clc
         adc AUXP
         sta TEMPX
         bcc next
         inc TEMPX+1

next     lda tab_cosdeltarem,Y
         sec
         sbc tab_sindeltarem,X
         sta TEMPY
         lda tab_cosdelta,Y       ;y*cos - x*sin
         sbc tab_sindelta,X
         sta TEMPY+1
         lda TEMPY
         clc
         adc AUXP+1
         sta TEMPY
         bcc done
         inc TEMPY+1

done     ldx ROTFLAG
         bpl end
         ldx TEMPX
         sta TEMPX
         stx TEMPY
         lda TEMPX+1
         ldx TEMPY+1
         sta TEMPY+1
         stx TEMPX+1
end      rts
.)



; Rotate .X,AUXP .Y,AUXP+1 -> TEMPX,+1 TEMPY,+1
;
; If flag is set for negative rotations, swap X and Y
; and swap destinations (TEMPX TEMPY)
;
ROTXY2    
.(
         lda ROTFLAG
         bpl cont
         stx TEMPX        ;Swap X and Y
         sty TEMPY
         ldx AUXP
         ldy AUXP+1
         stx AUXP+1
         sty AUXP
         ldx TEMPY
         ldy TEMPX
cont     lda tab_cosdeltarem2,X
         clc
         adc tab_sindeltarem2,Y
         sta TEMPX
         lda tab_cosdelta2,X       ;x*cos(delta)
         adc tab_sindelta2,Y       ;+y*sin(delta)
         sta TEMPX+1
         lda TEMPX
         clc
         adc AUXP
         sta TEMPX
         bcc next
         inc TEMPX+1

next     lda tab_cosdeltarem2,Y
         sec
         sbc tab_sindeltarem2,X
         sta TEMPY
         lda tab_cosdelta2,Y       ;y*cos - x*sin
         sbc tab_sindelta2,X
         sta TEMPY+1
         lda TEMPY
         clc
         adc AUXP+1
         sta TEMPY
         bcc done
         inc TEMPY+1

done     ldx ROTFLAG
         bpl end
         ldx TEMPX
         sta TEMPX
         stx TEMPY
         lda TEMPX+1
         ldx TEMPY+1
         sta TEMPY+1
         stx TEMPX+1
end      rts
.)

;
; Multiply a row by tCX tCY tCZ
; (A Procedure to save at least a LITTLE memory...)
;

#define M1	CXSGN
#define M2	CYSGN
#define M3	CZSGN

/*M1 .byt 00
M2 .byt 00
M3 .byt 00
*/

multrow  
.(
         sta M1
         stx M2
         sty M3

         tay
         beq skip1

         ldy tCX+1
		 MULTAY(tmp2)
         sta tmp3         
		 ldy tCX
         QMULTAY(tmp1)
         clc
         adc tmp2
         sta tmp2
         lda tmp3
         adc #00
         
		 ;adjust result and /64
.(	    
		 ldy MultLo1
         bpl pos1
         sta tmp3 
         lda tmp2 
         sec 
         sbc tCX           
         sta tmp2 
         lda tmp3 
         sbc tCX+1         
pos1
         ldy tCX+1 
         bpl pos2
         sec 
         sbc MultLo1 
pos2
         asl tmp1       
         rol tmp2 
         rol 
         asl tmp1 
         rol tmp2 
         rol 
         ldy tmp2 
.)
		 
skip1    sty TM1
         sta TM1+1

         lda M2
         beq skip2
         ldy tCY+1         ;and multiply by cy
		 MULTAY(tmp2)
		 sta tmp3
         ldy tCY
         QMULTAY(tmp1)
         clc
         adc tmp2
         sta tmp2
         lda tmp3
         adc #00

		 ;adjust result and /64
	    
.(		 
		 ldy MultLo1
         bpl pos1
         sta tmp3 
         lda tmp2 
         sec 
         sbc tCY           
         sta tmp2 
         lda tmp3 
         sbc tCY+1         
pos1
         ldy tCY+1 
         bpl pos2
         sec 
         sbc MultLo1 
pos2
         asl tmp1       
         rol tmp2 
         rol 
         asl tmp1 
         rol tmp2 
         rol 
         ldy tmp2 
.)                 
		 tax
         tya              ;low byte
         clc
         adc TM1
         sta TM1
         txa              ;high byte
         adc TM1+1
         sta TM1+1

skip2    lda M3
         beq zero
         ldy tCZ+1
		 MULTAY(tmp2)
         sta tmp3
		 ldy tCZ
		 QMULTAY(tmp1)
         
         clc
         adc tmp2
         sta tmp2
         lda tmp3
         adc #00

       
		 ;adjust result and /64
.(	    
		 ldy MultLo1
         bpl pos1
         sta tmp3 
         lda tmp2 
         sec 
         sbc tCZ
         sta tmp2 
         lda tmp3 
         sbc tCZ+1         
pos1
         ldy tCZ+1 
         bpl pos2
         sec 
         sbc MultLo1 
pos2
         asl tmp1       
         rol tmp2 
         rol 
         asl tmp1 
         rol tmp2 
         rol 
         ldy tmp2 
.)
		          
		 sta tmp3
         tya
         clc
         adc TM1
         tax
         lda tmp3
         adc TM1+1
         rts
zero     ldx TM1
         lda TM1+1
+uprts   rts              ;.X .A = lo hi bytes of row mult

.)



;
; ROTPROJ -- Perform local rotation and project points.
;
; Setup needs
;   Rotation matrix
;   Pointer to math table (MATMULT = $AF-$B0)
;   Pointers to point list (P0X-P0Z = $69-$6E)
;   Pointers to final destinations (PLISTYLO ... = $BD...)
;     (Same as used by POLYFILL)
;   Pointers to lists of centers (CXLO CXHI... = $A3-$AE)
;   .Y = Number of points to rotate (0..N-1)
;   .X = Object center index (index to center of object)
;
; New addition
;   C set means rotate and project, but C clear means just
;   rotate.  If C=0 then need pointers to rotation
;   destinations ROTPX,ROTPY,ROTPZ=$59-$5E.
;
; v2 Now two rotation matrices, local and viewpoint.
;     Points are rotated by local matrix; if projecting,
;     points are now rotated by viewpoint matrix, then
;     projected.
;
;     Rotated z-coordinates are now stored in PLISTZLO/HI
;     ($6F/$71)
;
;     If C=0, then coords just stored in PLISTXLO etc.,
;     as this now seems to be a pretty useless function.
;     (low bytes only!).
;



ROTPROJ
.(  
		 lda P0Z
		 sta _smc_pz+1
		 lda P0Z+1
		 sta _smc_pz+2

		 lda P0Y
		 sta _smc_py+1
		 lda P0Y+1
		 sta _smc_py+2

		 lda P0X
		 sta _smc_px+1
		 lda P0X+1
		 sta _smc_px+2


         lda MATMULT+1
         sta AUXP+1
         stx INDEX
		 sty count
         ror ROTFLAG
         bpl ROTLOOP      ;If C=0 then just rotate.

         ldy INDEX
         lda (CXLO),y     ;Centers
         sta tCX
         lda (CXHI),y
         sta tCX+1
         lda (CYLO),y
         sta tCY
         lda (CYHI),y
         sta tCY+1
         lda (CZLO),y
         sta tCZ
         lda (CZHI),y
         sta tCZ+1

ROTLOOP  ldy count
         beq uprts
         dey
         sty count

#ifdef AVOID_INVISBLEVERTICES
		 lda ROTFLAG
		 bpl skipthis
		 lda vertex2proj,y
		 beq ROTLOOP
skipthis

#endif

_smc_pz
		 lda $dead,y
         pha
_smc_py
		 lda $dead,y
         pha
_smc_px
		 lda $dead,y

ROTLOOP2 
.(
		 bne C1
         sta TEMPX
         sta TEMPY
         sta TEMPZ
         beq C2
C1       ldy A11;,x        ;Column 1
         SMULT
         sta TEMPX
         
         ldy D21;,x
         QMULT
         sta TEMPY

         ldy G31;,x
         QMULT
         sta TEMPZ

                          ;Column 2
C2       pla              ;Py
         beq C3

         ldy B12;,x
         SMULT
         clc   
         adc TEMPX
         sta TEMPX

         ldy E22;,x
         QMULT
         clc     
         adc TEMPY
         sta TEMPY

         ldy H32;,x
         QMULT
         clc     
         adc TEMPZ
         sta TEMPZ

                          ;Column 3
C3       pla              ;Pz
         beq ADDC
         
         ldy C13;,x
         SMULT
         clc     
         adc TEMPX
         sta TEMPX

         ldy F23;,x
         QMULT
         clc     
         adc TEMPY
         sta TEMPY

         ldy I33;,x
         QMULT
ADDC     clc
         adc TEMPZ
.)

         pha
         lda TEMPY
         pha
         lda TEMPX

.(
		 bne C1
         sta TEMPX
         sta TEMPY
         sta TEMPZ
         beq C2
C1       ldy A11+9;,x        ;Column 1
         SMULT
         sta TEMPX
         
         ldy D21+9;,x
         QMULT
         sta TEMPY

         ldy G31+9;,x
         QMULT
         sta TEMPZ

                          ;Column 2
C2       pla              ;Py
         beq C3

         ldy B12+9;,x
         SMULT
         clc   
         adc TEMPX
         sta TEMPX

         ldy E22+9;,x
         QMULT
         clc     
         adc TEMPY
         sta TEMPY

         ldy H32+9;,x
         QMULT
         clc     
         adc TEMPZ
         sta TEMPZ

                          ;Column 3
C3       pla              ;Pz
         beq ADDC
         
         ldy C13+9;,x
         SMULT
         clc     
         adc TEMPX
         sta TEMPX

         ldy F23+9;,x
         QMULT
         clc     
         adc TEMPY
         sta TEMPY

         ldy I33+9;,x
         QMULT
ADDC     clc
         adc TEMPZ
.)


PROJ
;;;;;
         ldy ROTFLAG
         bmi ROT2
         ldy count        ;If just rotating, then just
	     sta PLISTZ,y ;store!
         lda TEMPY
         sta PLISTY,y
         lda TEMPX
         sta PLISTX,y
         jmp ROTLOOP
ROT2 
;;;;;;    
 
         ldy #00          ;.Y = sign
         tax
         bpl POS1
         dey
POS1     clc              ;Add in centers
         adc tCZ
         sta TEMPZ
         tya
         adc tCZ+1
         sta TEMPZ+1      ;Assume this is positive!

         ldx #00
         ldy #00
         lda TEMPY
         bpl POS2
         dey
POS2     clc
         adc tCY
         sta TEMPY
         tya
         adc tCY+1
         sta TEMPY+1
         bpl C1b
         dex
C1b      stx CYSGN        ;Need sign for later

         ldx #00
         ldy #00
         lda TEMPX
         bpl POS3
         dey
POS3     clc
         adc tCX
         sta TEMPX
         tya
         adc tCX+1
         sta TEMPX+1
         bpl C2b
         dex
C2b      stx CXSGN

         ldy count
         ;lda TEMPZ
         ;sta PLISTZ,y
         lda TEMPZ+1
         ;sta PLISTZ+MAXVERTEX,y
         beq PROJb
BLAH     lsr              ;Shift everything until
         ror TEMPZ        ;Z=8-bits
         lsr CXSGN
         ror TEMPX+1      ;Projection thus loses accuracy
         ror TEMPX        ;for far-away objects.
         lsr CYSGN
         ror TEMPY+1      ;(Big whoop)
         ror TEMPY
         tax
         bne BLAH

PROJb    ldx TEMPZ
         lda tab_projtab,x    ;Projection constant
         bne C1c          ;Lots of 0's and 1's, so special
         ldy XOFFSET      ;case them.
         sty TM1
         ldy YOFFSET
         sty TM2
         ldy TEMPY+1
         sta TM1+1
         sta TM2+1
         jmp NOINT

EASY1    ldy TEMPX
         sty TM1
         ldy TEMPX+1
         sty TM1+1
         ldy TEMPY
         sty TM2
         ldy TEMPY+1
         sty TM2+1
         jmp ADDOFF

C1c      cmp #1
         beq EASY1

         ldy TEMPX
         MULTAY(TM1)

         ldy TEMPX+1
         clc
         adc (MultLo1),y  ;+256*ah*N (middle byte)
         sec
         sbc (MultLo2),y
         sta TM1+1

         ldy TEMPY
         QMULTAY(TM2)


         ldy TEMPY+1
         clc
         adc (MultLo1),y
         sec
         sbc (MultLo2),y
         sta TM2+1

ADDOFF   lda XOFFSET      ;Screen offsets
         clc
         adc TM1
         sta TM1
         bcc NOC1
         inc TM1+1
         clc
NOC1     lda YOFFSET
         adc TM2
         sta TM2
         bcc NOINT
         inc TM2+1
NOINT   
         lda tab_projtabrem	,x
         beq NOREM
         sta MultLo1
         sta MultHi1
         eor #$FF
         clc
         adc #01
         sta MultLo2
         sta MultHi2

         lda (MultLo1),y  ;ah*r
         sec
         sbc (MultLo2),y
         tax
         lda (MultHi1),y
         sbc (MultHi2),y
         cpy #$80
         bcc POSREM
         sbc MultLo1      ;Subtract 256*r if neg
                          ;(clears carry)
POSREM   tay
         txa
         adc TM2
         sta TM2
         tya
         adc TM2+1
         sta TM2+1

         ldy TEMPY
         lda (MultLo1),y
         sec
         sbc (MultLo2),y
         lda (MultHi1),y  ;al*r, hi byte
         sbc (MultHi2),y
         clc
         adc TM2          ;Add remainder
         ldy count
         sta PLISTY,y
         lda TM2+1        ;and sign+carry
         adc #00
         sta PLISTY+MAXVERTEX,y

; Do the same for x

         ldy TEMPX+1
         lda (MultLo1),y  ;ah*r
         sec
         sbc (MultLo2),y
         tax
         lda (MultHi1),y
         sbc (MultHi2),y
         cpy #$80
         bcc POSXREM
         sbc MultLo1      ;Subtract 65536*r if neg
                          ;(clears carry)
POSXREM  tay
         txa
         adc TM1
         sta TM1
         tya
         adc TM1+1
         sta TM1+1

         ldy TEMPX
         lda (MultLo1),y
         sec
         sbc (MultLo2),y
         lda (MultHi1),y  ;al*r, hi byte
         sbc (MultHi2),y
         clc
         adc TM1          ;Add remainder
         ldy count        ;and store
         sta PLISTX,y
         lda TM1+1
         adc #00
         sta PLISTX+MAXVERTEX,y

         jmp ROTLOOP      ;And on to the next point!
NOREM   
         ldy count
         lda TM1
         sta PLISTX,y
         lda TM1+1
         sta PLISTX+MAXVERTEX,y
         lda TM2
         sta PLISTY,y
         lda TM2+1
         sta PLISTY+MAXVERTEX,y
         jmp ROTLOOP
.)


;;; Need to call this function to correctly initialize stuff

_lib3dInit
.(
	ldy #>tab_multLO
	sty MultLo2+1
	iny
	sty MultLo1+1
	ldy #>tab_multHI
	sty MultHi2+1
	iny
	sty MultHi1+1


	lda #<tab_rotmath
	sta MATMULT
	lda #>tab_rotmath
	sta MATMULT+1

	rts
.)

__lib3d_end

#echo lib3d: Memory usage
#echo lib3d: Zero page:
#print (__lib3d_zeropage_end - __lib3d_zeropage_start)
#echo lib3d: Normal memory:
#print (__lib3d_end - __lib3d_start)
;#echo lib3d: Tables:
;#print (__lib3d_tables_end - __lib3d_tables_start)




