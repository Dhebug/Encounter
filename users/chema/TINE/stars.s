
#include "oobj3d\params.h"
#include "tine.h"



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
	ldy #NSTARS
LOOP
    jsr NEWSTAR
    dey
    bpl LOOP

	lda invert
	sta move_stars+1
	beq normal
	ldx #<STARSUBZ
	ldy #>STARSUBZ
	jmp patch
normal
	ldx #<STARADDZ
	ldy #>STARADDZ
patch
	stx patch_staraddz+1
	sty patch_staraddz+2
    rts
.)

NEWSTAR
.(       
	     ;.Y contains index into star table
#ifdef REALRANDOM
		jsr randgen
#else
		jsr _gen_rnd_number
#endif
loop1
		 cmp #(CLIP_BOTTOM-CENTER_Y)  ;100
         bcc SETY
         cmp #(256-(CENTER_Y-CLIP_TOP))		;156         ;-100
         bcs SETY
         ;and #%10111111   ;-65..63
		 cmp #$80
		 ror
		 jmp loop1
SETY     STA STARY,Y

#ifdef REALRANDOM
		lda randseed
#else
         lda _rnd_seed
#endif
loop2
         cmp #(CLIP_RIGHT-CENTER_X)		;120
         bcc SETX
         cmp #(256-(CENTER_X-CLIP_LEFT))			;136
         bcs SETX
         ;and #%10111111   ;-65..63
		 cmp #$80
		 ror
		 jmp loop2
SETX     sta STARX,Y
         rts
.)

/*
tabnrs1 .byt (CLIP_BOTTOM-CENTER_Y)-1, (256-(CENTER_Y-CLIP_TOP-1))
tabnrs2	.byt (CLIP_RIGHT-CENTER_X)-1, (256-(CENTER_X-CLIP_LEFT)-1)

NEWREARSTAR 
.(       
	     ;.Y contains index into star table
         jsr _gen_rnd_number
		 cmp #(CLIP_BOTTOM-CENTER_Y)  ;100
         bcc SETY
         cmp #(256-(CENTER_Y-CLIP_TOP))		;156         ;-100
         bcs SETY
         ;and #%10111111   ;-65..63
		 and #1
		 tax
		 lda tabnrs1,x
SETY     STA STARY,Y

         lda _rnd_seed
         cmp #(CLIP_RIGHT-CENTER_X)		;120
         bcc SETX
         cmp #(256-(CENTER_X-CLIP_LEFT))			;136
         bcs SETX
         ;and #%10111111   ;-65..63
		 and #1
		 tax
		 lda tabnrs2,x
SETX     sta STARX,Y
         rts
.)

*/

;
; PLOTSTAR -- Plot stars into bitmap!
;
PlotStars
.(
         ldy #NSTARS
LOOP     sty TEMP
         lda STARX,y
         clc
         adc #CENTER_X
         tax
         lda STARY,y
         clc
         adc #CENTER_Y
         tay
PLOT    
        ; Now plot the star!

		; Inline this?
#ifdef 0
        jsr pixel_address
#else
	    lda _HiresAddrLow,y			; 4
		sta tmp0+0					; 3
		lda _HiresAddrHigh,y		; 4
		sta tmp0+1					; 3 => Total 14 cycles
	  	ldy _TableDiv6,x
		lda _TableBit6Reverse,x		; 4
#endif
        ora (tmp0),y				; 5
    	sta (tmp0),y   
 
bypass   
         ldy TEMP
         dey
         bpl LOOP
         rts
.)



;; Routine to move stars depending on
;; global:
;; g_alpha  Total rotation in X (Pitch)
;; g_beta   Total rotation in Y (Yaw)
;; g_delta  Total rotation in Z (Roll)
;; g_theta  Total speed?

move_stars
.(
	lda #$00 ; SMC invert
	beq normal1
	lda g_alpha
	eor #$80
	sta g_alpha
	;lda g_beta
	;eor #$80
	;sta g_beta
	lda g_delta
	eor #$80
	sta g_delta
normal1

    lda g_alpha
    beq nowbeta
	bmi negmove1
    jsr STARADDY
    jmp nowbeta
negmove1
    jsr STARSUBY

nowbeta
    lda g_beta
    beq nowdelta
	bmi negmove2
    jsr STARSUBX
    jmp nowdelta
negmove2
    jsr STARADDX

nowdelta
    lda g_delta
    beq nowtheta
	bmi negmove3
	;and #$7f
	sta tmp
loop1
    jsr STARROTP
	dec tmp
	bne loop1

    jmp nowtheta
negmove3
	and #$7f
	beq nowtheta
	sta tmp
loop2
    jsr STARROTM
	dec tmp
	bne loop2

nowtheta
/*
	lda invert
	beq normal
	jsr STARSUBZ
	jmp more
normal
    jsr STARADDZ  ; This can't be negative...
*/

+patch_staraddz
	jsr STARADDZ
	
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
         cmp #(CLIP_RIGHT-CENTER_X)
         BCS NEW
YCHK     LDA STARY,Y
         BMI NEGYCHK
         CMP #64
         BCS NEW
         DEY
         BPL LOOP
         RTS

NEGYCHK  CMP #(256-(CENTER_Y-CLIP_TOP))
         BCS NOTNEW
NEW      JSR NEWSTAR
NOTNEW   DEY
         BPL LOOP
         RTS

NEGCHK   cmp #(256-(CENTER_X-CLIP_LEFT))
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

         cmp #(256-(CENTER_X-CLIP_LEFT))
         BCS NEW
YCHK     LDA STARY,Y
         BMI NEGYCHK
         CMP #(CLIP_BOTTOM-CENTER_Y) 
         BCS NEW
         DEY
         BPL LOOP
         RTS

NEGYCHK  CMP #(256-(CENTER_Y-CLIP_TOP))
         BCS NOTNEW
NEW      JSR NEWSTAR
NOTNEW   DEY
         BPL LOOP
         RTS

NEGCHK   cmp #(256-(CENTER_X-CLIP_LEFT))
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

POSCHK   cmp #(CLIP_RIGHT-CENTER_X)         ;if x>=max_x then need a new star
         BCC ADDY
NEW      JSR NEWSTAR
         JMP NEXT
NEGCHK  
         cmp #(256-(CENTER_X-CLIP_LEFT))          ;and if x<=min_x
         BCC NEW

ADDY     LDX #00          ;Sign
         LDA STARY,Y
         BPL C1
         DEX
C1       STX TEMP1
         LDX tmp; g_theta 
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

POSY     CMP #(CLIP_BOTTOM-CENTER_Y)          ;if abs(y)>max_y then new
         BCS NEW
NEXT     DEY
         BPL LOOP
ELRTS    RTS
NEGY     CMP #(256-(CENTER_Y-CLIP_TOP))
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
NEGCHK   cmp #(256-16)
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

POSY     CMP #16          ;if abs(y)<16 then new
         BCC NEW
NEXT     DEY
         BPL LOOP
OTRORTS  RTS
NEGY     CMP #(256-16)
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
		 lda g_beta
		 ldy #NSTARS
         and #$7f   ; Get absolute value  
         tax     
         LDA ADDTAB,X

         STA _smc_add+1
LOOP     LDA STARX,Y
         CLC
_smc_add
         ADC #$00 ; SMC
         STA STARX,Y
         BMI NEXT

POSCHK   cmp #(CLIP_RIGHT-CENTER_X)         ;if x>=max_x then need a new star
         BCC NEXT
NEW      JSR NEWSTAR
NEXT     DEY
         BPL LOOP
ELRTS    RTS
.)

STARSUBX
.( 
         lda g_beta
		 ldy #NSTARS
         and #$7f   ; Get absolute value  
         tax     
         LDA ADDTAB,X

         STA _smc_sub+1
LOOP     LDA STARX,Y
         SEC
_smc_sub
         SBC #$00	; SMC
         STA STARX,Y
         BPL NEXT


POSCHK   cmp #(256-(CENTER_X-CLIP_LEFT+1))     ;if x<min_x then need a new star
         BCS NEXT
NEW      JSR NEWSTAR
NEXT     DEY
         BPL LOOP
ELRTS    RTS
.)


STARADDY 
.(
		 lda g_alpha
		 ldy #NSTARS
         and #$7f   ; Get absolute value 
         tax     
         LDA ADDTAB,X

         STA _smc_add+1
LOOP     LDA STARY,Y
         CLC
_smc_add
         ADC #$00 ;SMC
         BVS NEW         ;might happen for large temp
         STA STARY,Y
         BMI NEXT
         CMP #(CLIP_BOTTOM-CENTER_Y)
         BCC NEXT
NEW      JSR NEWSTAR
NEXT     DEY
         BPL LOOP
ELRTS    RTS
.)

STARSUBY 
.(
         lda g_alpha
		 ldy #NSTARS
         and #$7f   ; Get absolute value  
         tax     
         LDA ADDTAB,X

         STA _smc_sub+1
LOOP     LDA STARY,Y
         SEC
_smc_sub
         SBC #$00 ; SMC
         BVS NEW
         STA STARY,Y
         BPL NEXT
         CMP #(256-(CENTER_Y-CLIP_TOP))
         BCS NEXT
NEW      JSR NEWSTAR
NEXT     DEY
         BPL LOOP
ELRTS    RTS
.)


