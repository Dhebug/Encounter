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
    txa
    sta _rnd_seed+2
    
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




