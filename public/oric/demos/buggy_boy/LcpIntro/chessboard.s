


	.text

_xpos		.byt 0,0		// Current checkboard coordinate
_curx		.byt 0,0		// Temporaty values for computations
			
_ypos		.byt 0,0
_cury		.byt 0,0

_zoomstart	.byt 128		// Half size stuff
_zoom		.byt 128		// Half size stuff


buffer		.dsb 40-4		// Where we have the defined values of charset after packing

InkTable	.byt 0			,2
PaperTable	.byt 16+7+128	,16
AttriTable	.byt 26+128		,26


_DrawHorizontalChecker
.(

breakpoint
	;jmp breakpoint

	; Init X
	lda _xpos+0
	sta _curx+0
	lda _xpos+1
	sta _curx+1
	
	; Init Y
	lda _ypos+0
	sta _cury+0
	lda _ypos+1
	sta _cury+1

	; Initialize pixel counter
	ldx #(40-4)*6

	; Consider we start with value equal to the first bit of high coordinate
	;lda _xpos+0
	;and #1

	; Starting zoom counter depends of the position where we are in the pixel.
	; If xpos+1=0, then start value=zoom
	; If xpos+1=255, then start value=0
	; If xpos+1=128, then start value=zoom/2
	; start value=zoom*(255-xpos[1])/255
	; Perhaps usefull to do a loop of that ?
.(
	lda #1
	ldy _zoomstart
loop_pixel
	; push pixel in stack buffer
	pha
	dex
	beq end
	dey
	bne loop_pixel

	; reload zoom factor
	ldy _zoom

	; flip color bit
	eor #1

	; continue
	jmp loop_pixel	
		
end
.)

	;
	; Now we need to pack bits together
	; 
	ldx #0
	ldy #0
	clc
loop_pack
	sty tmp1
	
	pla
	ror
	rol tmp1
	pla
	ror
	rol tmp1
	pla
	ror
	rol tmp1
	pla
	ror
	rol tmp1
	pla
	ror
	rol tmp1
	pla
	ror
	rol tmp1

	lda tmp1
	sta buffer,x

	inx
	cpx #40-4
	bne loop_pack


	;
	; Now, need to redefine characters with that
	;
.(
	lda #<$b400+8*32
	sta tmp0+0
	lda #>$b400+8*32
	sta tmp0+1

	lda #3
	sta tmp1
	ldx #0
	ldy #0
loop_copy
	lda buffer,x

	ldy #0
	sta (tmp0),y
	iny
	sta (tmp0),y
	iny
	sta (tmp0),y
	iny
	sta (tmp0),y
	iny
	sta (tmp0),y
	iny
	sta (tmp0),y
	iny
	sta (tmp0),y
	iny
	sta (tmp0),y

	lda #8
.(
	dec tmp1
	bne skip
	lda #4
	sta tmp1
	lda #8+8
skip
.)
.(
	clc
	adc tmp0+0
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
.)
	
	inx 
	cpx #40-4
	bne loop_copy
.)
	
	rts
.)



_DrawVerticalChecker
.(
	; Initialize pixel counter
	ldx #200

.(
	lda #1
	ldy _zoomstart
loop_pixel
	; push pixel in stack buffer
	pha
	dex
	beq end
	dey
	bne loop_pixel

	; reload zoom factor
	ldy _zoom

	; flip color bit
	eor #1

	; continue
	jmp loop_pixel	
		
end
.)

	;
	; Now we need to change the colors
	; 
	lda #<$a000
	sta tmp0+0

	lda #>$a000
	sta tmp0+1

	lda #200
	sta tmp1

loop_colors
	pla
	tax

	lda InkTable,x
	ldy #1
	sta (tmp0),y

	lda PaperTable,x
	iny
	sta (tmp0),y

	lda AttriTable,x
	iny
	sta (tmp0),y

	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip

	dec tmp1
	bne loop_colors

	rts
.)





