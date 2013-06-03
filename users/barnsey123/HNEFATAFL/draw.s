

 

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
/*
void tileloop()
{
	ptr_draw=(unsigned char*)0xa002;	// pointer to start of board
	ptr_draw+=(col*3)+(row*720);		// 720=18*40 starting screen coordinate
	for (counter=0;counter<18;inccounter())					//tileheight=pixels (e.g. 18)
	{
		//for (x=0;x<tilewidth;x++)
		//	{
		//	ptr_draw[x]=ptr_graph[x];
		//	}
		ptr_draw[0]=ptr_graph[0];
		ptr_draw[1]=ptr_graph[1];
		ptr_draw[2]=ptr_graph[2];
		ptr_draw+=40;	// number of 6pixel "units" to advance (+40=next line down, same position across)
		ptr_graph+=3;	// + unit of measurement	(how many 6pixel chunks "across" in graphic file)
	}
}
*/

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
	ldx _cx
	ldy _cy
	jsr _SetScreenAddress
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
	ldx _cx
	ldy _cy
	jsr _SetScreenAddress
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


;_hiresasm
;	LDA $02C0
;	PHA
;	AND #$02
;	BEQ $EBF4
;	PLA
;	ORA #$01
;	STA $02C0
;	JSR _sethires
;	RTS
;
;_sethires
;	PHA
;	LDA $021F
;	BNE $F92B
;	LDX #$0B
;	JSR _subhires1
;	LDA #$FE
;	AND $026A
;	STA $026A
;	LDA #$1E
;	STA $BFDF
;	LDA #$40
;	STA $A000
;	LDX #$17
;	JSR _subhires1
;	LDA #$00
;	STA $0219
;	STA $021A
;	STA $10
;	LDA #$A0
;	STA $11
;	LDA #$20
;	STA $0215
;	LDA #$FF
;	STA $0213
;	JSR $F8DC
;	LDA #$01
;	ORA $026A
;	STA $026A
;	PLA
;	RTS

; F982
;_subhires1
;	LDY #$06
;loop
;	LDA $F992,X
;	STA $000B,Y
;	DEX
;	DEY
;	BNE loop
;	JSR _subhires1A
;	RTS
;
;EDC4
;_s;ubhires1A
;	LDX #$00
;	LDY #$00
;bra3
;	CPY $10
;	BNE bra2
;	CPX $11
;	BEQ bra1
;bra2
;	LDA ($0C),Y
;	STA ($0E),Y
;	INY
;	BNE bra3
;	INC $0D
;	INC $0F
;	INX
;	JMP $EDC8
;bra1
;	RTS