


#define _hires		$ec33
#define _text		$ec21
#define _ping		$fa9f
#define _shoot		$fab5
#define _zap		$fae1
#define _explode	$facb
#define _kbdclick1	$fb14
#define _kbdclick2	$fb2a

#define _cls		$ccce
#define _lores0		$d9ed
#define _lores1		$d9ea



	.zero

	*= $50

ap		.dsb 2
fp		.dsb 2
sp		.dsb 2
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
reg0	.dsb 2
reg1	.dsb 2
reg2	.dsb 2
reg3	.dsb 2
reg4	.dsb 2
reg5	.dsb 2
reg6	.dsb 2
reg7	.dsb 2


	.text

osdk_start

	;#include "adress.tmp"
	;*=$800

	;
	; Needs to clear the BSS section
	;




	tsx
	lda #<osdk_stack
	sta sp
	lda #>osdk_stack
	sta sp+1
	ldy #0
	stx retstack
	jmp _main
retstack	
	.byt 0


enter
	sty tmp
	stx tmp+1
	asl
	sta op2
	tax
	beq noregstosave
savereg	lda reg0-1,x
	sta (sp),y
	iny
	dex
	bne savereg
noregstosave
	sty op2+1
	lda ap
	sta (sp),y
	iny
	lda ap+1
	sta (sp),y
	iny
	lda fp
	sta (sp),y
	iny
	lda fp+1
	sta (sp),y
	iny
	lda op2
	sta (sp),y
	iny
	lda tmp
	sta (sp),y
	clc
	lda sp
	sta ap
	adc op2+1
	sta fp
	lda sp+1
	sta ap+1
	adc #0
	sta fp+1
	lda tmp+1
	adc fp
	sta sp
	lda fp+1
	adc #0
	sta sp+1
	rts

leave
	stx op2
	sta op2+1
	lda ap
	sta sp
	lda ap+1
	sta sp+1
	ldy #4
	lda (fp),y
	tax
	iny
	lda (fp),y
	tay
	txa
	beq noregstorestore
restorereg
	lda (sp),y
	sta reg0-1,x
	iny
	dex
	bne restorereg
noregstorestore
	ldy #0
	lda (fp),y
	sta ap
	iny
	lda (fp),y
	sta ap+1
	iny
	lda (fp),y
	iny
	sta fp
	lda (fp),y
	sta fp+1
	ldx op2
	lda op2+1
	rts

jsrvect 
	jmp (0000)

_exit
	ldx retstack
	txs
	rts

reterr
	lda #$ff	; return -1
	tax
	rts

retzero
false
	lda #0		;return 0
	tax
	rts

true
	ldx #1		;return 1
	lda #0
	rts


#define load_acc1	$DE7B
#define load_acc2	$DD51
#define store_acc	$DEAD
#define fadd		$DB25
#define fsub		$DB0E
#define fmul		$DCF0
#define fdiv		$DDE7
#define fneg		$E271
#define fcomp		$DF4C
#define cif			$DF24

cfi     
	jsr $DF8C
    ldx $D3
    lda $D4
    rts

