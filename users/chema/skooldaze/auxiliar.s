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
    lda #<$a000
    sta tmp0+0
	lda #>$a000
    sta tmp0+1

	ldx #0
loop
	; generate two bytes screen adress
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
randseed 
  .word $dead       ; will it be $dead again? 


bufconv
	.byt 0,0,0,0,0,0
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

