

 

 .zero
 
 .text
 
; Add 40 to "tmp1"
_Add40
.(
	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip	
	rts
.)

_Add1
.(
	clc
	lda tmp1+0
	adc #1
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip
	rts
.)

; X=number of columns
; Out: update "tmp1"
_AddCol
.(
	cpx #0
loop
	beq end
	clc
	lda tmp1+0
	adc #3
	sta tmp1+0
	lda tmp1+1
	adc #0
	sta tmp1+1
	dex
	jmp loop
end
	rts
.)


; Y=number of rows
; Out: update "tmp1"
_AddRow
.(
	cpy #0
loop
	beq end
	clc
	lda tmp1+0
	adc #<720
	sta tmp1+0
	lda tmp1+1
	adc #>720
	sta tmp1+1
	dey
	jmp loop
end	
	rts
.)


; x=column
; y=row
_SetScreenAddress
.(
	lda #<$a002
	sta tmp1+0
	lda #>$a002
	sta tmp1+1
		
	; +col*3
	jsr _AddCol
	
	; +row*720
	jsr _AddRow
	rts
.)

_inkasm
.(
	ldx #199
	lda #<$a001
	sta tmp1+0
	lda #>$a001
	sta tmp1+1
	ldy #0
loop
	lda _inkcolor
	sta (tmp1),y
	jsr _Add40
	dex
	bne loop
	rts
.)

_deadatt
.(
	ldx #210
	lda #<$a024
	sta tmp1+0
	lda #>$a024
	sta tmp1+1
	ldy #0
loop
	lda #3
	sta (tmp1),y
	jsr _Add40
	dex
	bne loop
	rts
.)

_deaddef
.(
	ldx #210
	lda #<$a026
	sta tmp1+0
	lda #>$a026
	sta tmp1+1
	ldy #0
loop
	lda #1
	sta (tmp1),y
	jsr _Add40
	dex
	bne loop
	rts
.)

; draws the bottom of the board
_drawbottom
.(
	lda #<$bef2
	sta tmp1+0
	lda #>$bef2
	sta tmp1+1
	ldx #33
loop
	ldy #0
	lda _bottompattern;
	sta (tmp1),y
	jsr _Add1
	dex
	bne loop
	rts
.)
; draws bottom of trophy grid
_DrawTrophyBottom
.(
	lda #<$b967
	sta tmp1+0
	lda #>$b967
	sta tmp1+1
	ldx #6
loop
	ldy #0
	lda #%111111;
	sta (tmp1),y
	jsr _Add1
	dex
	bne loop
	rts
.)
; draws the edge of the board
_drawedge
.(
	lda #<$a023
	sta tmp1+0
	lda #>$a023
	sta tmp1+1
	ldx #199
loop
	ldy #0
	lda #%100000
	sta (tmp1),y
	jsr _Add40
	dex
	bne loop
	rts
.)
; draws the edge of the trophy grid
_DrawTrophyEdge
.(
	lda #<$a5bd
	sta tmp1+0
	lda #>$a5bd
	sta tmp1+1
	ldx #127
loop
	ldy #0
	lda #%100000
	sta (tmp1),y
	jsr _Add40
	dex
	bne loop
	rts
.)

_chasm2
.(
	lda _deadcurset+0
	sta tmp1+0
	lda _deadcurset+1
	sta tmp1+1
	ldx #0
loop
	lda _textchar	; load the char id no into accumulator
	cmp #40			; is it an ( - DEFENDER
	beq chasmDEF
	cmp #41			; is it an ) - ATTACKER
	beq chasmATT
	cmp #65			; is it an A?
	beq chasmA
	cmp #66			; B?
	beq chasmB
	cmp #68			; D?
	beq chasmD
	cmp #69			; E?
	beq chasmE
	cmp #70			; F?
	beq chasmF
	cmp #71			; G?
	beq chasmG
	cmp #73			; I?
	beq chasmI
	cmp #75			; K?
	beq chasmK
	cmp #76			; L?
	beq chasmL
	cmp #79			; O?
	beq chasmO
	cmp #82			; R?
	beq chasmR
	cmp #83			; S?
	beq chasmS
	cmp #84			; T?
	beq chasmT
	cmp #85			; U?
	beq chasmU
	cmp #90			; Z?
	beq chasmZ
	lda $9900,x		; else print a space
chasmx2
	ldy #0
	sta (tmp1),y
	jsr _Add40
	inx
	cpx #7
	bcc loop
	rts
chasmDEF
	lda $9940,x
	jmp chasmx2
chasmATT
	lda $9948,x
	jmp chasmx2
chasmA
	lda $9A08,x
	jmp chasmx2
chasmB
	lda $9A10,x
	jmp chasmx2
chasmD
	lda $9A20,x
	jmp chasmx2
chasmE
	lda $9A28,x
	jmp chasmx2
chasmF
	lda $9A30,x
	jmp chasmx2
chasmG
	lda $9A38,x
	jmp chasmx2
chasmI
	lda $9A48,x
	jmp chasmx2
chasmK
	lda $9A58,x
	jmp chasmx2	
chasmL
	lda $9A60,x
	jmp chasmx2	
chasmO
	lda $9A78,x
	jmp chasmx2	
chasmR
	lda $9A90,x
	jmp chasmx2	
chasmS
	lda $9A98,x
	jmp chasmx2	
chasmT
	lda $9AA0,x
	jmp chasmx2	
chasmU
	lda $9AA8,x
	jmp chasmx2	
chasmZ
	lda $9AD0,x
	jmp chasmx2		
.)

;_chasm3
;.(
;	lda _deadcurset+0
;	sta tmp1+0
;	lda _deadcurset+1
;	sta tmp1+1
;	ldx #0
;loop	
;	lda _someint,x	; where someint represents say $9AD0 (for the char Z)
;	ldy #0
;	sta (tmp1),y
;	jsr _Add40
;	inx
;	cpx #7
;	bcc loop
;	rts	
;.)


_SetScreenAddress2
.(
	ldx _cx
	ldy _cy
	jsr _SetScreenAddress
	rts
.)

_tileloop
.(
	lda _ptr_graph+0
	sta tmp0+0
	lda _ptr_graph+1
	sta tmp0+1
		
	ldx _col
	ldy _row
	jsr _SetScreenAddress
				
	; Draw loop
	.(
	ldx #18
loop
	ldy #0
	lda (tmp0),y
	sta (tmp1),y
	iny
	lda (tmp0),y
	sta (tmp1),y
	iny
	lda (tmp0),y
	sta (tmp1),y

	.(
	clc
	lda tmp0+0
	adc #3
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip	
	.)

	jsr _Add40
			
	dex
	bne loop
	.)
		
	; Update ptr_graph (for animation purpose)
	lda tmp0+0
	sta _ptr_graph+0
	lda tmp0+1
	sta _ptr_graph+1
	
	rts
.)


;_eorMagicValueTable    .byt 0,128,63,63+128
;_eorMagicValue         .byt 0
;_eorMagicValueCounter  .byt 3

;_tileloop2
;.(
;   ;inc _eorMagicValueCounter
 ;  lda #1
;   and #3
;   tax
;   lda _eorMagicValueTable,x
;   sta _eorMagicValue
; 
;   lda _ptr_graph+0
;   sta tmp0+0
;   lda _ptr_graph+1
;   sta tmp0+1
;      
;   ldx _col
;   ldy _row
;   jsr _SetScreenAddress
;            
;   ; Draw loop
;   .(
;   ldx #18
;loop
;   ldy #0
;   lda (tmp0),y
;   eor _eorMagicValue
;   sta (tmp1),y
;   iny
;   lda (tmp0),y
;   eor _eorMagicValue
;   sta (tmp1),y
;   iny
;   lda (tmp0),y
;   eor _eorMagicValue
;   sta (tmp1),y
;   .(
;   clc
;   lda tmp0+0
;   adc #3
;   sta tmp0+0
;   bcc skip
;   inc tmp0+1
;skip	
;   .)
;   jsr _Add40			
;   dex
;   bne loop
;   .)
; Update ptr_graph (for animation purpose)
;   lda tmp0+0
;   sta _ptr_graph+0
;   lda tmp0+1
;   sta _ptr_graph+1	
;   rts
;.)


/*
void drawtile()	// draws a board tile, player piece or "arrow"
{
	startpos=tiletodraw*54;			// 54=3*18 calc how many lines "down" in the graphic file to print from
	ptr_graph+=startpos;				// set start position in graphic file
	tileloop();
}
*/
_drawtile
.(
	; ptr_graph+=tiletodraw*54
	.(
	ldx _tiletodraw
loop
	beq end
	clc
	lda _ptr_graph+0
	adc #<54
	sta _ptr_graph+0
	bcc skip
	inc _ptr_graph+1
skip	
	dex
	jmp loop
end	
	.)

	jmp _tileloop
.)



/*
void drawtiles() // DRAW ALL THE TILES ON THE BOARD
{
	for (row=0;row<11;row++)
	{
		for (col=0;col<11;col++)
		{
			players[row][col]=tiles[row][col];	// populate players array
			ptr_graph=PictureTiles;				// pointer to Picture Tiles graphics
			tiletodraw=tiles[row][col];
			if ( tiletodraw==4 ) { tiletodraw=3;}
			drawtile();	
		}
	}
}
*/
_drawtiles
.(
	ldy #0
	
	ldx #0
loop_row	
	stx _row

	ldx #0
loop_col	
	stx _col
	
	lda _tiles,y
	sta _players,y
	cmp #4
	bne set_tile_to_draw
	lda #3
set_tile_to_draw	
	sta _tiletodraw
	
	lda #<_PictureTiles
	sta _ptr_graph+0
	lda #>_PictureTiles
	sta _ptr_graph+1
	
	tya 
	pha
	
	jsr _drawtile
	
	pla
	tay
	iny

	ldx _col
	inx
	cpx #11
	bne loop_col
	
	ldx _row
	inx
	cpx #11
	bne loop_row
	
	rts
.)



; Draw an inversed colr box to highlight selected box
; _cx=screen x position
; _cy=screen y position
_inverse
.(
	;ldx _cx
	;ldy _cy
	;jsr _SetScreenAddress
	jsr _SetScreenAddress2
	jsr _Add40
	;jsr _Add40
	
	; Draw loop
	.(
	ldx #17
loop
	ldy #0
	lda (tmp1),y
	eor #%111111
	eor #128
	sta (tmp1),y
	iny
	lda (tmp1),y
	eor #%111111
	eor #128
	sta (tmp1),y
	iny
	lda (tmp1),y
	eor #%111111
	eor #128
	sta (tmp1),y

	jsr _Add40
			
	dex
	bne loop
	.)
		
	rts
.)

_inverse2
.(
	;ldx _cx
	;ldy _cy
	;jsr _SetScreenAddress
	jsr _SetScreenAddress2
	jsr _Add40
	; Draw loop
	.(
	ldx #17
loop
	ldy #0
	lda (tmp1),y
	eor #%111111
	eor #128
	eor #63
	sta (tmp1),y
	iny
	lda (tmp1),y
	eor #%111111
	eor #128
	eor #63
	sta (tmp1),y
	iny
	lda (tmp1),y
	eor #%111111
	eor #128
	eor #63
	sta (tmp1),y

	jsr _Add40
			
	dex
	bne loop
	.)
		
	rts
.)

; _cx=x coordinate
; _cy=y coordinate
; _fb=0 -> Erase
; _fb=1 -> Draw
;_drawcursor
;.(
;	ldx _cx
;	ldy _cy
;	jsr _SetScreenAddress
;	
;	jsr _Add40
;
;	lda _fb
;	beq erase
;		
;draw
;	.(
;	; top line
;	ldy #0
;	lda #%101010
;	sta (tmp1),y
;	iny
;	sta (tmp1),y
;	iny
;	sta (tmp1),y
;		
		
	; Draw loop
;	.(
;	ldx #8
;loop
;	jsr _Add40
;	; draw	
;	ldy #0
;	lda (tmp1),y
;	ora #%010000
;	sta (tmp1),y
;	iny
;	iny
;	lda (tmp1),y
;	ora #%000001
;	sta (tmp1),y
;	jsr _Add40
;	dex
;	bne loop
;	.)
;		
;	; bottom line
;	ldy #0
;	lda #%101010
;	sta (tmp1),y
;	iny
;	sta (tmp1),y
;	iny
;	sta (tmp1),y
;	
;	rts
;	.)
;erase
;	.(
;	; top line
;	ldy #0
;	lda #%1000000
;	sta (tmp1),y
;	iny
;	;lda #%1000000
;	sta (tmp1),y
;	iny
;	sta (tmp1),y
;		
		
;	; Draw loop
;	.(
;	ldx #8
;loop
;	jsr _Add40
;
	; draw	
;	ldy #0
;	lda (tmp1),y
;	and #%11111111
;	sta (tmp1),y
;	iny
;	lda (tmp1),y
;	sta (tmp1),y
;	iny
;	lda (tmp1),y
;	and #%11111110
;	sta (tmp1),y
;	
;	jsr _Add40
;			
;	dex
;	bne loop
;	.)
	
	; bottom line
;	ldy #0
;	lda #%1000000
;	sta (tmp1),y
;	iny
;	;lda #%1000000
;	sta (tmp1),y
;	iny
;	sta (tmp1),y
	
;	rts
;	.)
;.)


