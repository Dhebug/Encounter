
#include "oobj3d\params.h"

#define NSTARS 15

STARX    .dsb NSTARS+1
STARXREM .dsb NSTARS+1
STARY    .dsb NSTARS+1
STARYREM .dsb NSTARS+1

;THETSTEP .byt 2

#define TEMP3 tmp3
#define TEMP1 tmp1
#define TEMP2 tmp2

      
;
; INITSTAR -- Initialize starfield, etc.
;
; Stars have locations x=-160..160 and y=-100..100
;
INITSTAR 
.(
         JSR _init_rand
         LDY #NSTARS
LOOP     JSR NEWSTAR
         DEY
         BPL LOOP
         RTS
.)

NEWSTAR
.(                   ;.Y contains index into star table
         JSR _gen_rnd_number
		 CMP #100
         BCC SETY
         CMP #156         ;-100
         BCS SETY
         AND #%10111111   ;-65..63
SETY     STA STARY,Y

         lda _rnd_seed
         cmp #120
         bcs SETX
         cmp #136
         bcs SETX
         and #%10111111   ;-65..63
SETX     sta STARX,Y
         RTS
.)


;
; PLOTSTAR -- Plot stars into bitmap!
;
PlotStars
.(
         LDY #NSTARS
LOOP     STY TEMP
         LDA STARX,Y
         CLC
         ADC #CENTER_X
         cmp #CLIP_RIGHT
         bcs bypass
         cmp #CLIP_LEFT
         bcc bypass
         tax

         LDA STARY,Y
         CLC
         ADC #CENTER_Y
         cmp #CLIP_BOTTOM
         bcs bypass
         cmp #CLIP_TOP
         bcc bypass
         TAY
PLOT    
        ; Now plot the star!

        jsr pixel_address
    	;eor (tmp0),y				; 5
        ora (tmp0),y				; 5
    	sta (tmp0),y   
 
bypass   
         LDY TEMP
         DEY
         BPL LOOP
         RTS
.)



;; Routine to move stars depending on
;; global:
;; g_alpha  Total rotation in X (Pitch)
;; g_beta   Total rotation in Y (Yaw)
;; g_delta  Total rotation in Z (Roll)
;; g_theta  Total speed?

move_stars
.(

	lda invert
	beq normal1
	lda g_alpha
	eor #$80
	sta g_alpha
	lda g_beta
	eor #$80
	sta g_beta
normal1

    lda g_alpha
    beq nowbeta
    cmp #$80    ; Get sign into carry
    bcs negmove1
    jsr STARADDY
    jmp nowbeta
negmove1
    jsr STARSUBY

nowbeta
    lda g_beta
    beq nowdelta
    cmp #$80    ; Get sign into carry
    bcs negmove2
    jsr STARSUBX
    jmp nowdelta
negmove2
    jsr STARADDX

nowdelta
    lda g_delta
    beq nowtheta
    cmp #$80    ; Get sign into carry
    bcs negmove3
	and #$7f
	sta tmp
loop1
    jsr STARROTP
	dec tmp
	bne loop1

    jmp nowtheta
negmove3
	and #$7f
	sta tmp
loop2
    jsr STARROTM
	dec tmp
	bne loop2

nowtheta
	lda invert
	beq normal
	jsr STARSUBZ
	jmp more
normal
    jsr STARADDZ  ; This can't be negative...
more
    lda #0
    sta g_alpha
    sta g_beta
    sta g_delta
    sta g_theta

    rts
.)


;
; STARROTP -- Rotate stars about z-axis, positive.
;
STARROTP 
.(
         LDY #NSTARS
LOOP     LDA STARX,Y
         BMI NEGX
POSX     TAX
         LDA STARYREM,Y   ;y*cos(delta)
         SEC
         SBC tab_sindeltarem2,X     ;-x*sin(delta)
         STA STARYREM,Y
         LDA STARY,Y
         SBC tab_sindelta2,X
         LDX STARY,Y
         STA STARY,Y      ;y=-x*sd + y*cd
         BMI NEGY        ;LDX sets flag

POSY     LDA STARXREM,Y
         CLC
         ADC tab_sindeltarem2,X     ;x*cos(theta) + y*sin(theta)
         STA STARXREM,Y
         LDA STARX,Y
         ADC tab_sindelta2,X
         STA STARX,Y
         BMI NEGCHK

POSCHK   
         cmp #120
         BCS NEW
YCHK     LDA STARY,Y
         BMI NEGYCHK
         CMP #64
         BCS NEW
         DEY
         BPL LOOP
         RTS

NEGYCHK  CMP #192	;#156         ;-100
         BCS NOTNEW
NEW      JSR NEWSTAR
NOTNEW   DEY
         BPL LOOP
         RTS

NEGCHK   cmp #136          ;-120
         BCS YCHK
         BCC NEW

NEGX     EOR #$FF
         TAX
         INX
         LDA STARYREM,Y   ;y*cos(delta)
         CLC
         ADC tab_sindeltarem2,X     ;-x*sin(delta)
         STA STARYREM,Y
         LDA STARY,Y
         ADC tab_sindelta2,X
         LDX STARY,Y
         STA STARY,Y      ;y=-x*sd + y*cd
         BPL POSY        ;LDX sets flag

NEGY     TXA
         EOR #$FF
         TAX
         INX
         LDA STARXREM,Y
         SEC
         SBC tab_sindeltarem2,X     ;x*cos(theta) + y*sin(theta)
         STA STARXREM,Y
         LDA STARX,Y
         SBC tab_sindelta2,X
         STA STARX,Y
         BPL POSCHK
         BMI NEGCHK
.)

;
; STARROTM -- Rotate stars, negative.
;   (sin -> -sin)
;
STARROTM 
.(

         LDY #NSTARS
LOOP     LDA STARX,Y
         BMI NEGX
POSX     TAX
         LDA STARYREM,Y   ;y*cos(delta)
         CLC
         ADC tab_sindeltarem2,X     ;+x*sin(delta)
         STA STARYREM,Y
         LDA STARY,Y
         ADC tab_sindelta2,X
         LDX STARY,Y
         STA STARY,Y      ;y=x*sd + y*cd
         BMI NEGY        ;LDX sets flag

POSY     LDA STARXREM,Y
         SEC
         SBC tab_sindeltarem2,X     ;x*cos(theta) - y*sin(theta)
         STA STARXREM,Y
         LDA STARX,Y
         SBC tab_sindelta2,X
         STA STARX,Y
         BMI NEGCHK
POSCHK   

         cmp #136
         BCS NEW
YCHK     LDA STARY,Y
         BMI NEGYCHK
         CMP #100
         BCS NEW
         DEY
         BPL LOOP
         RTS

NEGYCHK  CMP #156         ;-100
         BCS NOTNEW
NEW      JSR NEWSTAR
NOTNEW   DEY
         BPL LOOP
         RTS

NEGCHK   cmp #136
         BCS YCHK
         BCC NEW

NEGX     EOR #$FF
         TAX
         INX
         LDA STARYREM,Y   ;y*cos(delta)
         SEC
         SBC tab_sindeltarem2,X     ;+x*sin(delta)
         STA STARYREM,Y
         LDA STARY,Y
         SBC tab_sindelta2,X
         LDX STARY,Y
         STA STARY,Y      ;y=x*sd + y*cd
         BPL POSY        ;LDX sets flag

NEGY     TXA
         EOR #$FF
         TAX
         INX
         LDA STARXREM,Y
         CLC
         ADC tab_sindeltarem2,X     ;x*cos(theta) - y*sin(theta)
         STA STARXREM,Y
         LDA STARX,Y
         ADC tab_sindelta2,X
         STA STARX,Y
         BPL POSCHK
         BMI NEGCHK
.)

;
; STARADDZ -- Move stars, forwards or backwards.  Idea
;   is that stars move radially outward from the center
;   of the screen, with velocity dependent on the distance
;   from the center of the screen.
;
STARADDZ 
.(
         lda g_theta
         beq ELRTS
         lsr
         lsr
         lsr
         tax
         inx
         stx tmp

         LDY #NSTARS
LOOP    
         ;LDA g_theta; LDX THETSTEP
         ;BEQ ELRTS
 
         LDX #0 ; sign
         LDA STARX,Y
         bpl C2
         dex
C2
         STX TEMP2
         ldx tmp

L1      

         ASL
         ROL TEMP2
         DEX
         BNE L1          ;Divide by 128/64/32/16
         CLC
         ADC STARXREM,Y
         STA STARXREM,Y
         LDA TEMP2
         ADC STARX,Y    ;x = x + 1/16 x
         STA STARX,Y
         BMI NEGCHK
         ;BNE NEW         ;valid high = either 00 or $FF

POSCHK   cmp #120         ;if x>=160 then need a new star
         BCC ADDY
NEW      JSR NEWSTAR
         JMP NEXT
NEGCHK  
         cmp #136          ;and if x<=-160
         ;SBC #$FF         ;(Subtract $FF + 97)
         BCC NEW

ADDY     LDX #00          ;Sign
         LDA STARY,Y
         BPL C1
         DEX
C1       STX TEMP1
         LDX tmp; g_theta    ;THETSTEP
L2       ASL
         ROL TEMP1
         DEX
         BNE L2
         CLC
         ADC STARYREM,Y
         STA STARYREM,Y
         LDA TEMP1
         ADC STARY,Y
         BVS NEW
         STA STARY,Y
         BMI NEGY

POSY     CMP #100         ;if abs(y)>100 then new
         BCS NEW
NEXT     DEY
         BPL LOOP
ELRTS    RTS
NEGY     CMP #157
         BCC NEW
         DEY
         BPL LOOP
         RTS
.)



STARSUBZ
.(          

         lda g_theta
         beq OTRORTS
         lsr
         lsr
         lsr
         tax
         inx
         stx tmp

         LDY #NSTARS

        ;Same thing but subtract
         LDY #NSTARS
LOOP    
         ;ldx THETSTEP
         ;BEQ OTRORTS

         LDX #0 ; sign
         LDA STARX,Y
         bpl C1
         dex
C1
         STX TEMP2
         ldx tmp

L1      

         ASL
         ROL TEMP2
         DEX
         BNE L1
         STA TEMP
         LDA STARXREM,Y
         SEC
         SBC TEMP
         STA STARXREM,Y
         LDA STARX,Y    ;x = x - 1/16 x
         SBC TEMP2
         STA STARX,Y
         BMI NEGCHK

POSCHK   cmp #16          ;if abs(x)<16 then need a new star
         BCS ADDY
NEW      JSR NEWSTAR
         JMP NEXT
NEGCHK   cmp #240
         ;SBC #$FF
         BCS NEW

ADDY     LDX #00          ;Sign
         LDA STARY,Y
         BPL C2
         DEX
C2       STX TEMP1
         LDX tmp    ;THETSTEP
L2       ASL
         ROL TEMP1
         DEX
         BNE L2
         STA TEMP
         LDA STARYREM,Y
         SEC
         SBC TEMP
         STA STARYREM,Y
         LDA STARY,Y
         SBC TEMP1
         BVS NEW
         STA STARY,Y
         BMI NEGY

POSY     CMP #16          ;if abs(y)<6 then new
         BCC NEW
NEXT     DEY
         BPL LOOP
OTRORTS  RTS
NEGY     CMP #240
         BCS NEW
         DEY
         BPL LOOP
         RTS
.)



;
; STARADDX, STARSUBX, STARADDY, STARSUBY
;   Routines to move stars right/left/up/down to simulate
;   rotations around x and y axis.
;
;ADDTAB   .byt 0,12,24,36,48,60,72
ADDTAB   .byt 0,4,8,12,16,20,24,28,32,36,40,44,52,60
STARADDX 
.(
         LDY #NSTARS
         LDX g_beta    ;THETSTEP
         BEQ ELRTS
         
         txa
         and #$7f   ; Get absolute value  
         ;asl
         tax     
         LDA ADDTAB,X

         STA TEMP
LOOP     LDA STARX,Y
         CLC
         ADC TEMP
         STA STARX,Y
         BMI NEXT

POSCHK   cmp #120         ;if x>=160 then need a new star
         BCC NEXT
NEW      JSR NEWSTAR
NEXT     DEY
         BPL LOOP
ELRTS    RTS
.)

STARSUBX
.( 
         LDY #NSTARS
         LDX g_beta   ;THETSTEP
         BEQ ELRTS
         txa
         and #$7f   ; Get absolute value  
         ;asl
         tax     
         LDA ADDTAB,X

         STA TEMP
LOOP     LDA STARX,Y
         SEC
         SBC TEMP
         STA STARX,Y
         BPL NEXT

POSCHK   cmp #136          ;if x<-160 then need a new star
         BCS NEXT
NEW      JSR NEWSTAR
NEXT     DEY
         BPL LOOP
ELRTS    RTS
.)


STARADDY 
.(
         LDY #NSTARS
         LDX g_alpha ;THETSTEP
         BEQ ELRTS
         txa
         and #$7f   ; Get absolute value 
         ;asl 
         tax     
         LDA ADDTAB,X

         STA TEMP
LOOP     LDA STARY,Y
         CLC
         ADC TEMP
         BVS NEW         ;might happen for large temp
         STA STARY,Y
         BMI NEXT
         CMP #100
         BCC NEXT
NEW      JSR NEWSTAR
NEXT     DEY
         BPL LOOP
ELRTS    RTS
.)

STARSUBY 
.(
         LDY #NSTARS
         LDX g_alpha ;THETSTEP
         BEQ ELRTS
         txa
         and #$7f   ; Get absolute value  
;         asl
         tax     
         LDA ADDTAB,X

         STA TEMP
LOOP     LDA STARY,Y
         SEC
         SBC TEMP
         BVS NEW
         STA STARY,Y
         BPL NEXT
         CMP #156
         BCS NEXT
NEW      JSR NEWSTAR
NEXT     DEY
         BPL LOOP
ELRTS    RTS
.)


