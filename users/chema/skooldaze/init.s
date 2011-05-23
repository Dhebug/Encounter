

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Init code
;; ---------------------


#include "params.h"


#define _hires		$ec33
#define _text		$ec21
#define _ping		$fa9f

.zero

tmp0	.dsb 2
tmp1	.dsb 2
tmp2	.dsb 2
tmp3	.dsb 2
tmp4	.dsb 2
tmp5	.dsb 2
tmp6	.dsb 2
tmp7	.dsb 2
op1		.dsb 2
op2		.dsb 2
tmp		.dsb 2
;reg0	.dsb 2
;reg1	.dsb 2
;reg2	.dsb 2
;reg3	.dsb 2
;reg4	.dsb 2
;reg5	.dsb 2
;reg6	.dsb 2
;reg7	.dsb 2

#define        via_t1cl                $0304 


.text

; Main procedure.

_main
.(

	jsr _GenerateTables 
	jsr _hires
	//paper(6);ink(0);

	lda #6
	ldy #0        
    sty $2e0
	sta $2e1
	sty $2e2
	jsr $f204      ;paper
	
	ldy #0 
	sty $2e0
	sty $2e1
	sty $2e2
	jsr $f210      ;ink


	jsr _init_irq_routine 
	jsr _init
	jmp _test_loop
.)



