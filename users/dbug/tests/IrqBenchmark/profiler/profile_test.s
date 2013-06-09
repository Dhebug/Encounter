
#define PROFILER_ASM
#include "profile.h"

;
; Test routines for the profiler
;

	.dsb 256-(*&255)

; Wait 20000 cycles -> 21593
_Test_20000
.(
 ; (1525+4)*11+1=16820
 ldy #12
outer_loop
 ; 6*254+1=1525
 ldx #255
inner_loop 
 nop				; 2
 dex				; 2
 bne inner_loop 	; 2/3
 
 dey				; 2
 bne outer_loop 	; 2/3
  
 rts
.)



_TestAsm
.(
 PROFILE_ENTER(ROUTINE_ASM) 
  
 ; (1525+4)*11+1=16820
 ldy #12
outer_loop
 ; 6*254+1=1525
 ldx #255
inner_loop 
 nop				; 2
 dex				; 2
 bne inner_loop 	; 2/3
 
 dey				; 2
 bne outer_loop 	; 2/3
  
 PROFILE_LEAVE(ROUTINE_ASM) 
 
 rts
.)