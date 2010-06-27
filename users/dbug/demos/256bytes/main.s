
; --------------------------------------
;  256 bytes moving backgound mini demo
; --------------------------------------
; (c) 2006 Mickael Pointier

;
; ROM & RAM system defines
; (Works only on ROM 1.1)
;
#define _rom_hires		$ec33
#define _rom_curset		$f0c8
#define _rom_circle		$f37f

#define ROM_PARAMS		$2e0
#define ROM_PATTERN		$213
#define ROM_CURX		$219
#define ROM_CURY		$21a

#define INK_BLUE		4

#define FB_DRAW			1

#define SCREEN_HIRES	$a000
#define CHARSET_TEXT	$b400+8*"@"
#define SCREEN_TEXT		$bb80
#define SCREEN_LAST		$bfdf

#define SCREEN_SRC_OFFSET	(-40*24)+1

	.zero

	*= $50

circle_ray			.dsb 1

tmp0				.dsb 1
tmp1				.dsb 1

ptr_src				.dsb 2
ptr_src2			.dsb 2

ptr_dst				.dsb 2

	.text

_main
	; Switch to hires
	jsr _rom_hires

	; Erase the parameter area
	lda #0
	ldx #7
loop
	sta ROM_PARAMS-1,x
	dex 
	bne loop
		
	; Force "manualy" the text mode by setting a 50hz TEXT switch attribute 
	lda #26
	sta SCREEN_LAST
	
	; More CPU time, and no more blinking cursor !
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
	
	lda #<SCREEN_TEXT
	sta ptr_src+0
	lda #>SCREEN_TEXT
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
	lda #INK_BLUE
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
	
	lda #FB_DRAW
    sta ROM_PARAMS+3			; Set the FB parameter to "draw"    
BigLoop		
	.(
	; Draw a first animated circle
	ldx circle_ray
	inx
	txa
	and #15
	sta circle_ray
	
	; Draw two circles
	ldx #2
loop_circle
	stx tmp0
	
	lda CircleData-1,x
	sta ROM_CURX
	sta ROM_CURY
	
	ldx circle_ray
	inx
    stx ROM_PARAMS+1
        
	jsr _rom_circle
	
	ldx tmp0
	dex
	bne loop_circle
	
	.)
	
	; Pattern register
	inc ROM_PATTERN
			
	.(
	;
	; Let's dump a 24x24 pixels area of the HIRES screen to the redefined characters area :D
	;
	lda #<SCREEN_HIRES
	sta ptr_src+0
	lda #>SCREEN_HIRES
	sta ptr_src+1
	
	lda #<CHARSET_TEXT
	sta ptr_dst+0
	lda #>CHARSET_TEXT
	sta ptr_dst+1

	ldx #4
loop_x
	stx tmp0
	
	ldx #24
loop_y
	; Compute the secondary pointer to create the mirror picture
	clc
	lda ptr_src+0
	adc #<40*24
	sta ptr_src2+0
	lda ptr_src+1
	adc #>40*24
	sta ptr_src2+1
		
	ldy #4
	lda (ptr_src),y		; Top right
	ora (ptr_src2),y	; Bottom right
	ldy #0
	ora (ptr_src),y		; Top left
	ora (ptr_src2),y	; Bottom left
	
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

	clc
	lda ptr_src+0
	adc #<SCREEN_SRC_OFFSET
	sta ptr_src+0
	lda ptr_src+1
	adc #>SCREEN_SRC_OFFSET
	sta ptr_src+1
		
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

CircleData	
	.byt 12,24
	.byt "-DBUG-"