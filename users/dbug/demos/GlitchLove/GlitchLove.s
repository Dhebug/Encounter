
; --------------------------------------
; 256 bytes intro for the Lovebyte party
;        (Works only on ROM 1.1)
; --------------------------------------
; (c) 2021 Mickael Pointier

#define ROM_PARAMS		$2e0


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
	sei                   ; More CPU time, and no more blinking cursor !
	lda #3                ; Allow using HIRES drawing commands
	sta $2c0              
	
	; -----------------------------------------------------
	; Fill the TEXT screen area with a bunch of ALT characters which will be used as a pseudo framebuffer.
	; 48 characters are used, with the 6x8 character definition organized over a 8x6 matrix, that gives a 48x48 pixels definition
	; -----------------------------------------------------
	
	lda #<$bb80       ; TEXT screen address
	sta ptr_src+0
	lda #>$bb80
	sta ptr_src+1
	
	ldx #28
loop_y_pattern	

	ldy #39
loop_x_pattern
	lda tmp0
	bne skip_reset_char
	lda #48
skip_reset_char	
	sec
	sbc #6
	sta tmp0
	
	clc
	lda #"@"|128
	adc tmp0
	adc tmp1
	
	sta (ptr_src),y     ; Write character in video memory
	dey
	bne loop_x_pattern

	sty tmp0
	
	; End of line, we write the color attribute at the begining, and update line pointers...
	lda #9               ; ALT gr
	sta (ptr_src),y
	iny 
	lda #3               ; Yellow Ink
	sta (ptr_src),y
	
	ldy tmp1
	iny
	cpy #6
	bne skip_reset_6
	ldy #0
skip_reset_6	
	sty tmp1

	jsr IncPtrSrc
			
	dex
	bne loop_y_pattern


	; -----------------------------------------------------
	;                Draw the LOVEBYTE logo
	;          (and clear the HIRES parameters area)
	; -----------------------------------------------------
	ldx #12+4
loop_lovebyte_message	
	lda LoveByteMessage-1,x

	sta $bb80+40*2-1+5,x          ; Draw the top part of the LOVEBYTE message
	sta $bb80+40*3-1+5,x          ; Draw the bottom part of the LOVEBYTE message

	sta $bb80+40*24-1+25-4,x          ; Draw the top part of the LOVEBYTE message
	sta $bb80+40*25-1+25-4,x          ; Draw the bottom part of the LOVEBYTE message

	lda #0
	sta ROM_PARAMS-1,x           ; Clean the HIRES parameter area
	dex
	bne loop_lovebyte_message
	

	; -----------------------------------------------------
	;                Big loop that draws circles 
	;              and makes a lof horrible noise
	; -----------------------------------------------------
	lda #2              ; 1=DRAW 2=INVERSE 3=NOTHING 
    sta ROM_PARAMS+3	; Set the FB parameter to "inverse"    
BigLoop		
	jsr $fab5     ; Shoot

	; Draw a first animated circle
	lda #55
	sta $219            ; ROM_CURX
	sta $21a            ; ROM_CURY

	inc $213     	; ROM_PATTERN register (create some binary wobbly patterns on the circles)
	lda $213
	and #31
	sta ROM_PARAMS+1
	and #15
	bne no_zero_pattern
	jsr $fae1     	; ZAP
no_zero_pattern
	        
	jsr $f37f       ; CIRCLE (ROM 1.1)
	jsr $fa9f     	; ping
		


	;
	; Let's dump a 24x24 pixels area of the HIRES screen to the redefined characters area :D
	;
	lda #<$a000   		; HIRES screen address
	sta ptr_src+0
	lda #>$a000
	sta ptr_src+1
	
	lda #<$b800+8*"@"   ; ALTernate character set address
	sta ptr_dst+0
	lda #>$b800+8*"@"
	sta ptr_dst+1

	ldx #8
	stx tmp0
loop_x
	
	ldx #48
loop_y	
	clc                  ; Compute the secondary pointer to create the mirror picture
	lda ptr_src+0
	adc #<40*48
	sta ptr_src2+0
	lda ptr_src+1
	adc #>40*48
	sta ptr_src2+1
		
	ldy #8
	lda (ptr_src),y		; Top right
	ora (ptr_src2),y	; Bottom right
	ldy #0
	ora (ptr_src),y		; Top left
	ora (ptr_src2),y	; Bottom left
		
	sta (ptr_dst),y     ; Update the char map

	jsr IncPtrSrc
	
	inc ptr_dst+0
	bne skip_dst
	inc ptr_dst+1
skip_dst

	dex
	bne loop_y

	clc
	lda ptr_src+0
	adc #<(-40*48)+1    ; Rewind
	sta ptr_src+0
	lda ptr_src+1
	adc #>(-40*48)+1
	sta ptr_src+1
		
	dec tmp0
	bne loop_x
	beq BigLoop

	
IncPtrSrc	
	clc
	lda ptr_src+0
	adc #40
	sta ptr_src+0
	bcc skip_src
	inc ptr_src+1
skip_src	
	rts

LoveByteMessage
	.byt 14,6,"L","O"+128,"VEBYTE",3,"Dbug",9  ; Double Height blinking


