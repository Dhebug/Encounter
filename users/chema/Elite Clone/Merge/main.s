#include "main.h"


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
*=	$50

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
;reg0	.dsb 2
;reg1	.dsb 2
;reg2	.dsb 2
;reg3	.dsb 2
;reg4	.dsb 2
;reg5	.dsb 2
;reg6	.dsb 2
;reg7	.dsb 2


.text

; Main procedure.

_main
.(
	lda #<osdk_stack
	sta sp
	lda #>osdk_stack
	sta sp+1
	lda #4;8
	sta $24e
	lda #1
	sta $24f

	jsr _hires
	jsr _init_tine
	jsr _init_print
	;lda #1
	;sta _galaxynum
	;lda #7
	;sta _dest_num
	jsr _infoplanet
	jsr _makesystem

	jsr _jump
	;lda #0
	;sta _fluct

	jsr _DoubleBuffOff
	lda #SCR_INFO
	sta _current_screen
	jsr _displayinfo

	jsr _TineLoop

	rts
.)
_end_main
    
    