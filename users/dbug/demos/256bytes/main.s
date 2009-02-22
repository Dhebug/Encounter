
;// --------------------------------------
;// 256b moving backgound (Working title)
;// --------------------------------------
;// (c) 2006 Mickael Pointier
;// This code is provided as-is.
;// I do not assume any responsability
;// concerning the fact this is a bug-free
;// software !!!
;// Except that, you can use this example
;// without any limitation !
;// If you manage to do something with that
;// please, contact me.
;// --------------------------------------
;// Note: This text was typed with a Win32
;// editor. So perhaps the text will not be
;// displayed correctly with other OS.


;#define DEBUGMODE



;//
;// ROM system defines
;// (Works only on ROM 1.1)
;//
#define _rom_hires		$ec33
//#define _rom_text		$ec21

#define _rom_ink		$f210
#define _rom_paper		$f204

#define _rom_ping		$fa9f
#define _rom_shoot		$fab5
#define _rom_zap		$fae1
#define _rom_explode	$facb

#define _rom_kbdclick1	$fb14
#define _rom_kbdclick2	$fb2a

//#define _rom_cls		$ccce
//#define _rom_lores0		$d9ed
//#define _rom_lores1		$d9ea

#define _rom_curset		$f0c8
#define _rom_curmov		$f0fd
#define _rom_draw		$f110
#define _rom_fill		$f268
#define _rom_circle		$f37f

#define _rom_redef_chars	$f8d0

#define	KEY_NONE	$38
#define KEY_UP		11	//$9c
#define	KEY_DOWN	10	//$b4
#define KEY_LEFT	8	//$ac
#define KEY_RIGHT	9	//$bc
#define KEY_SPACE	32	//$84
#define KEY_P		80	//$9d
#define KEY_DELETE	127
#define KEY_ESCAPE	27	//$a9
#define KEY_ENTER	13


;//
;// Page two definition
;//
#define ROM_CURX	$219
#define ROM_CURY	$21a

;//
;// Zero page definition
;//

	.zero

	*= $50

;// Some two byte values
_zp_start_

circle_ray			.dsb 1

tmp0				.dsb 1
tmp1				.dsb 1

ptr_src				.dsb 2
ptr_src2			.dsb 2

ptr_dst				.dsb 2


param				.dsb 1
param_x				.dsb 2
param_y				.dsb 2
param_fb			.dsb 2



_zp_end_




	.text

_main
	;
	; Switch to hires
	;
#ifndef DEBUGMODE	
	jsr _rom_hires
#endif

	;
	; Erase the parameter area
	;
	.(
	lda #0
	ldx #7
loop
	sta $2e0-1,x
	dex 
	bne loop
    .)
 
		
	;
	; Force "manualy" text mode
	;
	lda #26		; 50hz TEXT switch
	sta $bfdf
	
	;
	; More CPU time, and no more blinking cursor !
	;
	sei
	
	.(
	;
	; Let's fill screen with a pattern of characters, for example that:
	;
	; @CFI
	; ADGJ
	; BEHK
	;
	lda #0
	sta tmp0
	sta tmp1
	
	lda #<$bb80
	sta ptr_src+0
	lda #>$bb80
	sta ptr_src+1
	
	ldx #28
loop_y	
	ldy #39
loop_x	

	.(
	lda tmp0
	bne skip
	lda #12
skip	
	sec
	sbc #3
	sta tmp0
	.)
	
	clc
	lda #"@"
	adc tmp0
	adc tmp1

	; Write character in video memory
	sta (ptr_src),y

	dey
	bne loop_x

	sty tmp0
	
	; End of line, we write the color attribute at the begining,
	; and update line pointers...
	lda #4	; BLUE INK
	sta (ptr_src),y
	
	.(
	clc
	lda tmp1
	adc #1
	cmp #3
	bne skip
	lda #0
skip	
	sta tmp1
	.)

	jsr IncPtrSrc
			
	dex
	bne loop_y
	.)

#ifdef DEBUGMODE	
Breakkk
	jmp Breakkk	
#endif	
	
	lda #1	
    sta $2e0+3			; Set the FB parameter to "draw"    
BigLoop		
	.(
	;
	; Draw a first animated circle
	;
	ldx circle_ray
	inx
	txa
	and #15
	sta circle_ray
	
	;
	; Draw two circles
	;
	ldx #2
loop_circle
	stx tmp0
	
	lda CircleData-1,x
	sta ROM_CURX
	sta ROM_CURY
	
	ldx circle_ray
	inx
    stx $2e0+1
        
	jsr _rom_circle
	
	ldx tmp0
	dex
	bne loop_circle
	
	.)
	
	; Pattern register
	inc $213
			
	.(
	;
	; Let's dump a 24x24 pixels area of the HIRES screen to the redefined characters area :D
	;
#define SCREEN_SRC $a000
#define SCREEN_DST $b400+8*"@"

#define SCREEN_SRC_OFFSET	(-40*24)+1
	
	lda #<SCREEN_SRC
	sta ptr_src+0
	lda #>SCREEN_SRC
	sta ptr_src+1
	
	lda #<SCREEN_DST
	sta ptr_dst+0
	lda #>SCREEN_DST
	sta ptr_dst+1

	ldx #4
loop_x
	stx tmp0
	
	ldx #24
loop_y
	; Compute the secondary pointer to access the tiled versions 
	; of HIRES bitmap
	clc
	lda ptr_src+0
	adc #<40*24
	sta ptr_src2+0
	lda ptr_src+1
	adc #>40*24
	sta ptr_src2+1
		
	ldy #4
	lda (ptr_src),y
	ora (ptr_src2),y
	ldy #0
	ora (ptr_src),y
	ora (ptr_src2),y
	
	; Update the char map
	sta (ptr_dst),y

	; Clean the HIRES buffer	
	lda #64
	sta (ptr_src),y
	sta (ptr_src2),y
	ldy #4
	sta (ptr_src),y
	sta (ptr_src2),y

	jsr IncPtrSrc
	
	.(
	inc ptr_dst+0
	bne skip
	inc ptr_dst+1
skip
	.)	

	dex
	bne loop_y

	.(
	clc
	lda ptr_src+0
	adc #<SCREEN_SRC_OFFSET
	sta ptr_src+0
	lda ptr_src+1
	adc #>SCREEN_SRC_OFFSET
	sta ptr_src+1
	.)	
		
	ldx tmp0
	dex
	bne loop_x
	.)
	jmp BigLoop
	
	
IncPtrSrc	
	.(
	clc
	lda ptr_src+0
	adc #40
	sta ptr_src+0
	bcc skip
	inc ptr_src+1
skip	
	.)
	rts

CircleData	.byt 12,24
				