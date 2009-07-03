__tineinc_start

;;;; Math functions needed to perform some calculations. These should be revised...

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

;;; Here goes mul16.  It takes two 16-bit parameters and multiplies them to a 32-bit signed number. The assignments are:
;;;	op1:	multiplier
;;;	op2:	multiplicand
;;; Results go:
;;;	op1:	result LSW
;;;	tmp1:	result HSW
;;; The algorithm used is classical shift-&-add, so the timing depends largely on the number of 1 bits on the multiplier.
;;; This is based on Leventhal / Saville, "6502 Assembly Language Subroutines", as it's compact and general enough, but
;;; it's optimized for speed, sacrificing generality instead.
;;; Max time taken ($ffff * $ffff) is 661 cycles.  Average time is around max time for 8-bit numbers.
;;; Max time taken for 8-bit numbers ($ff * $ff) is 349 cycles.  Average time is 143 cycles.  That's fast enough too.

; Subroutine starts here.

sign .byt 0


mul16
.(
	lda #0
	sta sign

	lda op1+1
	bpl positive1
	
	sec
	lda #0
	sbc op1
	sta op1
	lda #0
	sbc op1+1
	sta op1+1

	lda sign
	eor #$ff
	sta sign

positive1
	lda op2+1
	bpl positive2

	sec
	lda #0
	sbc op2
	sta op2
	lda #0
	sbc op2+1
	sta op2+1

	lda sign
	eor #$ff
	sta sign

positive2

	jsr mul16uc
 
	lda sign
	beq end
	
	; Put sign back
	sec
	lda #0
	sbc op1
	sta op1
	lda #0
	sbc op1+1
	sta op1+1
	lda #0
	sbc tmp1
	sta tmp1
	lda #0
	sbc tmp1+1
	sta tmp1+1

end
	rts

.)

mul16uc
.(
	lda #0
	sta tmp1
	sta tmp1+1
	ldx #17
	clc
_m16_loop
	ror tmp1+1
	ror tmp1
	ror op1+1
	ror op1
	bcc _m16_deccnt
	clc
	lda op2
	adc tmp1
	sta tmp1
	lda op2+1
	adc tmp1+1
	sta tmp1+1
_m16_deccnt
	dex
	bne _m16_loop
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




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  pixel_address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MC routine that calculates the address pointer for a given pixel (x,y) and
; the pixel in scan.
; Needs:
; RegX x coordinate
; RegY y coordinate
;
; Returns:
; The address of the scan in tmp0 which includes
; the selected pixel is calculated as:
;
;  y*40+x/6+$a000
;
; and the pixel in scan as a bit in tmp1
;
;  x mod 6

; 1st: how to find y * 40 and to enjoy it.

pixel_address
.(
    tya             ;; the tab_scan contains only the addresses for even rows, so
    lsr             ;; we 1st check if row if even or odd: IF CARRY IS 1 AFTER
    bcs pp_oddrow   ;; A RIGHT LOGICAL SHIFT THEN IT'S ODD, else it's even.
    rol             ;; we restore the original value...
    tay             ;; ...use it as index...
    lda tab_scan,y  ;; ...look up LSB of offset then...
    sta tmp0        ;; ...store it...
    iny         
    lda tab_scan,y  ;; same for MSB...
    sta tmp0+1
    jmp pp_done1    ;; ...and done for now.
pp_oddrow          
    rol             ;; here: if the row is ODD, we fetch the offset of the FORMER
    tay             ;; one, and add 40 to it... eeeasy as pie... albeit a tad
    lda tab_scan,y  ;; confusing here, since we are at an odd offset within the
    sta tmp0+1      ;; table and that means we must swap MSB & LSB for the
    dey             ;; current entry... ie, let this be the scan offset table:
    lda tab_scan,y  
    adc #40         ;;
    sta tmp0        ;;  LSB1    MSB1    LSB2    MSB2    LSB3   ...
    bcc pp_done1   ;;                              ^ Y points here so...
    inc tmp0+1      ;;          ^ we store, decrement, then add 40.
pp_done1


; 2nd: we must now find (x div 6) and (x mod 6).

;; The idea here is a bit the same that before, BEING THE KEY that:
;;  * EVEN numbers are 0, 2 or 4 (mod 6), while
;;  * ODD numbers are 1, 3 or 5 (mod 6).
;; It follows that there are two cases:
;;  * case 1:  x = 2 * k  (k whole):
;;      x div 6 = k div 3
;;      x mod 6 = 2 * (k mod 3)
;;  * case 2:  x = 2 * k + 1 (k whole):
;;      x div 6 = k div 3 = (2 * k) div 6 = (x - 1) div 6
;;      x mod 6 = ((x - 1) mod 6) + 1
;; Confused?  You are not a Jedi yet. :)
;; Besides, in tab_mod06 are not the remainders, but the pixel masks
;; (of even cols), going as:
;;  remainder 0 ->  mask 32
;;  remainder 2 ->  mask 8
;;  remainder 4 ->  mask 2
;; The masks for odd cols are resp. 16, 4 and 1, which are halves of the
;; even ones, so we must lsr them after fetching.

pp_positive2
    ;lda op1         ;; we 1st load coord x.
    ;tax             ;; use it as index.
    txa
    lsr             ;; is it odd?
    bcs pp_oddcol  ;; then skip till next label, else...
    lda tab_mod06,x ;; load quotient & store it
    sta tmp       
    inx             ;; next offset in table is mask.
    lda tab_mod06,x
    sta tmp1       
    jmp pp_done2   ;; done!
pp_oddcol          ;; what if x is odd? Note the sequence
    asl             ;; "lsr a / asl a" means A := (A/2)-1 if
    tax             ;; A is odd (this case), so now a is even.
    lda tab_mod06,x ;; we fetch divisor then
    sta tmp         ;; store it...
    inx
    lda tab_mod06,x ;; now the pixel mask (doubled)...
    lsr             ;; all that's left is adjusting the mask.
    sta tmp1
pp_done2
    
       
pp_positive3   
; All together now!
    lda tmp0
    adc tmp
    sta tmp0
    lda tmp0+1
    adc #$a0
    sta tmp0+1
pp_end 
    rts ; We're done!
.)


; This two are por pixel_addresss
; table of row scan offsets relative to base_hires_address.

tab_scan
    .word    0,  80, 160, 240, 320, 400, 480, 560, 640, 720, 800, 880, 960,1040,1120,1200,1280,1360,1440,1520
    .word 1600,1680,1760,1840,1920,2000,2080,2160,2240,2320,2400,2480,2560,2640,2720,2800,2880,2960,3040,3120
    .word 3200,3280,3360,3440,3520,3600,3680,3760,3840,3920,4000,4080,4160,4240,4320,4400,4480,4560,4640,4720
    .word 4800,4880,4960,5040,5120,5200,5280,5360,5440,5520,5600,5680,5760,5840,5920,6000,6080,6160,6240,6320
    .word 6400,6480,6560,6640,6720,6800,6880,6960,7040,7120,7200,7280,7360,7440,7520,7600,7680,7760,7840,7920


; table of quotients & masks mod 6.  Format is a pair (a,b), where a = (2x) div 6, b = pixel mask.

tab_mod06
    .byt  0,32, 0,8, 0,2, 1,32, 1,8, 1,2, 2,32, 2,8, 2,2
    .byt  3,32, 3,8, 3,2, 4,32, 4,8, 4,2, 5,32, 5,8, 5,2
    .byt  6,32, 6,8, 6,2, 7,32, 7,8, 7,2, 8,32, 8,8, 8,2
    .byt  9,32, 9,8, 9,2,10,32,10,8,10,2,11,32,11,8,11,2
    .byt 12,32,12,8,12,2,13,32,13,8,13,2,14,32,14,8,14,2
    .byt 15,32,15,8,15,2,16,32,16,8,16,2,17,32,17,8,17,2
    .byt 18,32,18,8,18,2,19,32,19,8,19,2,20,32,20,8,20,2
    .byt 21,32,21,8,21,2,22,32,22,8,22,2,23,32,23,8,23,2
    .byt 24,32,24,8,24,2,25,32,25,8,25,2,26,32,26,8,26,2
    .byt 27,32,27,8,27,2,28,32,28,8,28,2,29,32,29,8,29,2
    .byt 30,32,30,8,30,2,31,32,31,8,31,2,32,32,32,8,32,2
    .byt 33,32,33,8,33,2,34,32,34,8,34,2,35,32,35,8,35,2
    .byt 36,32,36,8,36,2,37,32,37,8,37,2,38,32,38,8,38,2
    .byt 39,32,39,8,39,2

#define miitoa2

#ifdef miitoa2
bufconv
	.byt 0,0,0,0,0,0,0,0,0,0,0,0
itoa2
.(
    lda op2
    sta op1
    lda op2+1
    sta op1+1
    lda #0
    sta op2
    sta op2+1
    jmp ltoa
.)

#endif

#ifdef miitoa
bufconv
	.byt 0,0,0,0,0,0,0,0,0,0,0,0
utoa
.( 
    ldy#0
    sty bufconv
    jmp itoaloop   
+itoa
	ldy #0
	sty bufconv
	lda op2+1
	bpl itoaloop
	lda #$2D	; minus sign
	sta bufconv
	sec
	lda #0
	sbc op2
	sta op2
	lda #0
	sbc op2+1
	sta op2+1
	
itoaloop
	jsr udiv10
	pha
	iny
	lda op2
	ora op2+1
	bne itoaloop
	
	ldx #0
	lda bufconv
	beq poploop
	inx
poploop
	pla
	clc
	adc #$30
	sta bufconv,x
	inx
	dey
	bne poploop
	lda #0
	sta bufconv,x
	ldx #<bufconv
	lda #>bufconv
	rts
			
;
; udiv10 op2= op2 / 10 and A= op2 % 10
;
udiv10
	lda #0
	ldx #16
	clc
udiv10lp
	rol op2
	rol op2+1
	rol 
	cmp #10
	bcc contdiv
	sbc #10
contdiv
	dex
	bne udiv10lp
	rol op2
	rol op2+1
    rts
.)

#endif



;-------------------------------
;
; 32 bit -> ASCII conversion
;
; Take 2 -- Divide by 10 manually; remainder is coeff
; of successive powers of 10
;
; Number to convert -> op1, op1+1, op2, op2+1 (lo..hi)
;
; SLJ 8/28/96


#define FAQ2 op1
#define TEMP tmp+1

ltoa
.(
    LDA #10
    STA FAQ2+4

    ldx #0
loop
    JSR DIV32
    pha
    inx
	lda op2
	ora op2+1
    ora op1
    ora op1+1
    bne loop

    ldy #0
poploopl
    pla
	clc
	adc #$30
	sta bufconv,y
	iny
	dex
	bne poploopl
	lda #0
	sta bufconv,y
    ldx #<bufconv
  	lda #>bufconv
    RTS
.)


;
; Routine to divide a 32-bit number (in faq2..faq2+3) by
; the 8-bit number in faq2+4.  Result -> faq2..faq2+3, remainder
; in A.  Numbers all go lo..hi
;

DIV32     
.(  
          LDA #00
          LDY #$20
LOOP      ASL FAQ2
          ROL FAQ2+1
          ROL FAQ2+2
          ROL FAQ2+3
          ROL
          CMP FAQ2+4
          BCC DIV2
          SBC FAQ2+4
          INC FAQ2
DIV2      DEY
          BNE LOOP
          RTS
.)




__tineinc_end

#echo Size already in tine:
#print (__tineinc_end - __tineinc_start)
#echo
