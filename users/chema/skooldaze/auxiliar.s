;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Auxiliary functions
;; --------------------

#include "params.h"
#include "text.h"


_GenerateTables
.(
	; Generate screen offset data
#ifdef CENTER_PLAY_AREA
    lda #<$a000+160
    sta tmp0+0
	lda #>$a000+160
    sta tmp0+1
#else
    lda #<$a000
    sta tmp0+0
	lda #>$a000
    sta tmp0+1
#endif

	ldx #0
loop
	; generate two bytes screen address
	clc
	lda tmp0+0
	sta _HiresAddrLow,x
	adc #40
	sta tmp0+0
	lda tmp0+1
	sta _HiresAddrHigh,x
	adc #0
	sta tmp0+1

	inx
	cpx #200
	bne loop
	rts
.)

; A real random generator... trying to enhance this...
randgen 
.(
   ;php				; INTERRUPTS MUST BE ENABLED!  We store the state of flags. 
   ;cli 
   lda randseed     ; get old lsb of seed. 
   ora $308			; lsb of VIA T2L-L/T2C-L. 
   rol				; this is even, but the carry fixes this. 
   adc $304			; lsb of VIA TK-L/T1C-L.  This is taken mod 256. 
   sta randseed     ; random enough yet. 
   sbc randseed+1   ; minus the hsb of seed... 
   rol				; same comment than before.  Carry is fairly random. 
   sta randseed+1   ; we are set. 
   ;plp 
   rts				; see you later alligator. 
.)

utoa
.( 
    ldy#0
    sty bufconv
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Multiplies 2 8-bit numbers
; in tmp0 and tmp0+1 and gets a 16-bit
; result in tmp0,tmp1 using the
; classical shift&add method
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mul8
.(
	lda #0
	sta tmp1
	ldx #9
_m8_loop
	lsr tmp1
	ror tmp0
	bcc _m8_deccnt
	clc
	lda tmp0+1
	adc tmp1
	sta tmp1
_m8_deccnt
	dex
	bne _m8_loop
	rts
.)


/* Moved to tail.s to open space 
; Adds 40 to tmp
add40tmp
.(
	lda tmp
	clc
	adc #40
	sta tmp
	bcc nocarry
	inc tmp+1
nocarry
	rts
.)
*/
/*

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compares two 16-bit numbers in op1 and op2
;; Performs signed and unsigned comparisions at the same time.
;; If the N flag is 1, then op1 (signed) < op2 (signed) and BMI will branch
;; If the N flag is 0, then op1 (signed) >= op2 (signed) and BPL will branch 
;; For unsigned comparisions ,the behaviour is the usual with the carry flag
;; If the C flag is 0, then op1 (unsigned) < op2 (unsigned) and BCC will branch 
;; If the C flag is 1, then op1 (unsigned) >= op2 (unsigned) and BCS will branch 
;; The Z flag DOES NOT indicate equality...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
*/