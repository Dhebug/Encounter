#include "tine.h"

;typedef struct
;{ char a,b,c,d;
;} fastseedtype;  /* four byte random number used for planet description */


;typedef struct
;{ int w0;
;  int w1;
;  int w2;
;} seedtype;  /* six byte random number used as seed for planets */


;seedtype seed;
;fastseedtype rnd_seed;

_seed .dsb 6
_rnd_seed .dsb 4


;unsigned int base0=0x5A4A;
;unsigned int base1=0x0248;
;unsigned int base2=0xB753;  /* Base seed for galaxy 1 */

_base0 .word $5a4a
_base1 .word $0248
_base2 .word $b753


;; Elite random function

;; Initialize seeds for galaxy 1
_init_rand
.(

    ldx #5
loop
    lda _base0,x
    sta _seed,x
    dex
    bpl loop

    ldx #3
loop2
    lda _seed+2,x
    sta _rnd_seed,x
    dex
    bpl loop2    
    
    rts

.)

;int gen_rnd_number (void)
; This is inspired in the reverse engineered
; source of eliteagb
_gen_rnd_number
.(
    ;int A = (g_rand_seed.r0*2)|(*carry!=0);
    ;int X = A&0xff;
    ;A = (X + g_rand_seed.r2 + (A>0xff)); // carry from this used below
    ;g_rand_seed.r0 = A;

    lda _rnd_seed
    rol   ; It is commented that this is the exact code in original Elite, and not asl
    tax
    adc _rnd_seed+2        
    sta _rnd_seed   
  
    ;g_rand_seed.r2 = X;
    ;txa
    ;sta _rnd_seed+2
	stx _rnd_seed+2
    
    ;A = (g_rand_seed.r1 + g_rand_seed.r3 + (A>0xff));
    ;*carry = (A>0xff);
    ;A&=0xff;
    lda _rnd_seed+1
    clc
    adc _rnd_seed+3
    ;X = g_rand_seed.r1;
    ldx _rnd_seed+1
    
    ;g_rand_seed.r1 = A;
    ;g_rand_seed.r3 = X;
    sta _rnd_seed+1
    stx _rnd_seed+3
    ;return A;
    rts

.)


#ifdef REALRANDOM
; A real random generator... trying to enhance this...
randgen 
.(
   php				; INTERRUPTS MUST BE ENABLED!  We store the state of flags. 
   cli 
   lda randseed     ; get old lsb of seed. 
   ora $308			; lsb of VIA T2L-L/T2C-L. 
   rol				; this is even, but the carry fixes this. 
   adc $304			; lsb of VIA TK-L/T1C-L.  This is taken mod 256. 
   sta randseed     ; random enough yet. 
   sbc randseed+1   ; minus the hsb of seed... 
   rol				; same comment than before.  Carry is fairly random. 
   sta randseed+1   ; we are set. 
   plp 
   rts				; see you later alligator. 
.)
randseed 
  .word $dead       ; will it be $dead again? 

#endif




