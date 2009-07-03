;;; Some extra math functions
;;; and C interface callers


#define DIVXLO   op1           ;Division: DIVX/DIVY
#define DIVXHI   op1+1
#define DIVY     op2
#define DIVTEMP  op2+1           ;High byte of DY


;;; C interfaces...
#define NEEDCINTERFACES
#ifdef NEEDCINTERFACES
;; mul16 is defined in obj3d.s
_mimul16
.(
    ldy #0
    lda (sp),y
    sta op1
    iny
    lda (sp),y
    sta op1+1
    iny
    lda (sp),y
    sta op2
    iny
    lda (sp),y
    sta op2+1
    jsr mul16
    ldx op1
    lda op1+1   
    rts
.)


;; interface for DivXY defined below

#ifdef 0
_miDiv
.(
    ldy #0
    lda (sp),y
    sta DIVXLO
    iny
    lda (sp),y
    sta DIVXHI
    iny
    lda (sp),y
    sta DIVY
    iny
    lda (sp),y
    sta DIVTEMP
    jmp DIVXY
.)

#endif

;; interface for abs function
_abs
.(
    ldy #0
    lda (sp),y
    sta op1
    iny
    lda (sp),y
    sta op1+1
    jsr abs
    ldx op1
    lda op1+1
    rts
.)


;; Interface for the SqRoot function
_SqRoot
.(
    ldy #0
    lda (sp),y
    sta op1
    iny
    lda (sp),y
    sta op1+1
    jsr SqRoot
    ldx op2
    lda #0
    rts


.)

#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Routines




;; Calculate the absolute value
;; of a 16-bit integer in op1,op1+1

abs
.(
    lda op1+1
    bpl notneg
    sec
    lda #0
    sbc op1
    sta op1
    lda #0    
    sbc op1+1
    sta op1+1
notneg
    rts

.)



;; Compares two 16-bit numbers in op1 and op2
;; Performs signed and unsigned comparisions at the same time.
;; If the N flag is 1, then op1 (signed) < op2 (signed) and BMI will branch
;; If the N flag is 0, then op1 (signed) >= op2 (signed) and BPL will branch 
;; For unsigned comparisions ,the behaviour is the usual with the carry flag:
;; If the C flag is 0, then op1 (unsigned) < op2 (unsigned) and BCC will branch 
;; If the C flag is 1, then op1 (unsigned) >= op2 (unsigned) and BCS will branch 
;; The Z flag DOES NOT indicate equality...

cmp16
.(
    lda op1 ; op1-op2
    cmp op2
    lda op1+1
    sbc op2+1
    bvc ret ; N eor V
    eor #$80
ret
    rts
 
.)


;; Unsigned 16-bit division
;; div by 0 is not checked!

divu
.(
	;lda op2
	;ora op2+1
	;beq zerodiv

	lda #0
	sta tmp
	sta tmp+1
	
	ldx #16
	asl op1
	rol op1+1
udiv2
	rol tmp
	rol tmp+1
	sec
	lda tmp
	sbc op2
	tay
	lda tmp+1
	sbc op2+1
	bcc udiv3
	sty tmp
	sta tmp+1
udiv3
	rol op1
	rol op1+1
	dex
	bne udiv2
	ldx op1
	lda op1+1
	rts
.)

; Calculates the 8 bit root and 9 bit remainder of a 16 bit unsigned integer in
; op1. The result is always in the range 0 to 255 and is held in
; op2, the remainder is in the range 0 to 511 and is held in tmp0
;
; partial results are held in templ/temph
;
; This routine is the complement to the integer square program.
;
; Destroys A, X registers.

; variables - must be in RAM

#define Numberl op1     ; number to find square root of low byte
#define Numberh op1+1   ; number to find square root of high byte
#define Reml    tmp0    ; remainder low byte
#define Remh    tmp0+1	; remainder high byte
#define templ	tmp		; temp partial low byte
#define temph   tmp+1	; temp partial high byte
#define Root	op2		; square root

SqRoot
.(
	LDA	#$00		; clear A
	STA	Reml		; clear remainder low byte
	STA	Remh		; clear remainder high byte
	STA	Root		; clear Root
	LDX	#$08		; 8 pairs of bits to do
Loop
	ASL	Root		; Root = Root * 2

	ASL	Numberl		; shift highest bit of number ..
	ROL	Numberh		;
	ROL	Reml		; .. into remainder
	ROL	Remh		;

	ASL	Numberl		; shift highest bit of number ..
	ROL	Numberh		;
	ROL	Reml		; .. into remainder
	ROL	Remh		;

	LDA	Root		; copy Root ..
	STA	templ		; .. to templ
	LDA	#$00		; clear byte
	STA	temph		; clear temp high byte

	SEC			; +1
	ROL	templ		; temp = temp * 2 + 1
	ROL	temph		;

	LDA	Remh		; get remainder high byte
	CMP	temph		; comapre with partial high byte
	BCC	Next		; skip sub if remainder high byte smaller

	BNE	Subtr		; do sub if <> (must be remainder>partial !)

	LDA	Reml		; get remainder low byte
	CMP	templ		; comapre with partial low byte
	BCC	Next		; skip sub if remainder low byte smaller

				; else remainder>=partial so subtract then
				; and add 1 to root. carry is always set here
Subtr
	LDA	Reml		; get remainder low byte
	SBC	templ		; subtract partial low byte
	STA	Reml		; save remainder low byte
	LDA	Remh		; get remainder high byte
	SBC	temph		; subtract partial high byte
	STA	Remh		; save remainder high byte

	INC	Root		; increment Root
Next
	DEX			; decrement bit pair count
	BNE	Loop		; loop if not all done

	RTS
.)



#ifdef 0
;
; DIVXY
;
; This guy is the old predictor-corrector method,
; modified slightly to be more general.
;
; It computes 2X/2Y as the predictor, then corrects
; in both directions.  Both X and Y must be positive.
; X is assumed to be 9-bits and Y is 8-bits.
;
; Inputs: .X=dx/2 .A=dy/2, dx and dy are in xdivlo etc.
;
; Result is returned in X=integer part, A=remainder
;
; Remainder is now a fraction of 256.
;
; DX and DY can now be huge -- they are simply shifted
; right until DX < 512 and DY < 256.
;

;.zero

;DIVXLO   .byt 00           ;Division: DIVX/DIVY
;DIVXHI   .byt 00
;DIVY     .byt 00
;DIVTEMP  .byt 00           ;High byte of DY
;TEMP1    .byt 00
;TEMP2    .byt 00

;; The rest are #defined in the C wrapper...

#define TEMP1    tmp1
#define TEMP2    tmp2

DIVSHIFT
.( 
         LSR DIVTEMP
         ROR DIVY
         LSR DIVXHI
         ROR DIVXLO
.)
DIVXY
.(   
         LDA DIVTEMP      ;Div by 2 if dy>255
         BNE DIVSHIFT

         LDA DIVXHI
         CMP #2
         BCS DIVSHIFT     ;Or if dx>511

         LSR              ;Compute dx/2
         LDA DIVXLO
         ROR
         TAX
         LDA DIVY
         LSR              ;dy/2
         BEQ TWOSTEP     ;If Y=1 then handle special

         TAY
         LDA tab_log,X        ;This is the division part
         SEC
         SBC tab_log,Y
         BCC NEG
         TAX
         LDA tab_exp,X
         TAX              ;Now we have int estimate

         STA MultLo1
         STA MultHi1
         EOR #$FF
         ADC #00          ;Carry is guaranteed set
         STA MultLo2
         STA MultHi2
         LDY DIVY
         LDA (MultLo1),Y
         SEC
         SBC (MultLo2),Y  ;a=N*dy
         STA TEMP1
         LDA (MultHi1),Y
         SBC (MultHi2),Y
         STA TEMP2

         LDA DIVXLO       ;R=dx-a
         SBC TEMP1        ;C set
         STA TEMP1
         LDA DIVXHI
         SBC TEMP2
         LDA TEMP1        ;A=remainder
         BCC RNEG
                          ;If R>0 then assume R<255
                          ;(true unless dx>500 or so)

RPOS     CMP DIVY         ;If R>=dy then
         BCC DONE
L1       INX              ;a=a+1
         SBC DIVY         ;R=R-dy
         CMP DIVY
         BCS L1
DONE                      ;Now X contains integer, A rem
                          ;y=dy
;
; Compute remainder as a fraction of 256, i.e.
; 256*r/dy
;
; Currently, a small error may occur for large r
; (cumulative error of 1-2 pixels, up to 4 in rare cases)
;
FRACREM 
         STX TEMP1
         TAX
         BEQ ZERO
         LDA tab_log,X
         SEC
         SBC tab_log,Y
         TAX
         LDA tab_negexp,X
ZERO     LDX TEMP1
         RTS
                          ;And, if R<0 then assume
                          ;R>-255
RNEG     DEX
         ADC DIVY
         BCC RNEG
         JMP FRACREM

NEG      LDX #00          ;Since log is monotonic, and
         LDA DIVXLO       ;we /2, there is no chance
         LDY DIVY
         JMP FRACREM     ;of undershooting.

TWOSTEP  LDA DIVXHI       ;If Y=1
         LSR
         LDA DIVXLO       ;then just two steps of size
         ROR              ;dx/2
         TAX
         LDA #255
         RTS
.)

#endif



