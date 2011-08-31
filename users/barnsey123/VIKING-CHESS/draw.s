

 

 .zero
 
 .text
 
#define _rom_curset		$f0c8
#define _rom_curmov		$f0fd
#define _rom_draw		$f110
#define _rom_fill		$f268
#define _rom_circle		$f37f

#define _params			$2e0
#define	_rom_pattern	$213
 
; draws a box
_drawbox
.(
	; curset(tilex,tiley,3);
	lda _tilex 
	sta _params+1 
	lda _tiley
	sta _params+3	
	lda #0
	sta _params+2
	sta _params+4
	lda #3
	sta _params+5	
	jsr _rom_curset
	
	; draw(size,0,fb);
	lda _size 
	sta _params+1 
	lda #0
	sta _params+2
	sta _params+3	
	sta _params+4
	lda _fb
	sta _params+5	
	jsr _rom_draw
	
	; draw(0,size,fb);
	lda #0
	sta _params+1 
	sta _params+2
	sta _params+4
	lda _size 
	sta _params+3	
	lda _fb
	sta _params+5	
	jsr _rom_draw

	; draw(-size,0,fb);
	lda #0
	sta _params+3	
	sta _params+4
	sec
	sbc _size 
	sta _params+1 
	lda #$ff
	sta _params+2	
	lda _fb
	sta _params+5	
	jsr _rom_draw

	; draw(0,-size,fb);
	lda #0
	sta _params+1
	sta _params+2	
	sec
	sbc _size 
	sta _params+3	
	lda #$ff
	sta _params+4
	lda _fb
	sta _params+5	
	jmp _rom_draw
.)
 


; draw a diamond at x,y size z, foreground or background
_drawdiamond
.(
	; curset(tilex,tiley,fb);
	lda _tilex 
	sta _params+1 
	lda _tiley
	sta _params+3	
	lda #0
	sta _params+2
	sta _params+4
	lda #3
	sta _params+5	
	jsr _rom_curset
	
	; draw(size,size,fb);
	lda _size 
	sta _params+1 
	sta _params+3	
	lda #0
	sta _params+2
	sta _params+4
	lda _fb
	sta _params+5	
	jsr _rom_draw
	
	; draw(-size,size,fb);
	lda #0
	sta _params+4
	sec
	sbc _size 
	sta _params+1 
	lda #$ff
	sta _params+2
	lda _size 
	sta _params+3	
	lda _fb
	sta _params+5	
	jsr _rom_draw

	; draw(-size,-size,fb);
	lda #0
	sec
	sbc _size 
	sta _params+1 
	sta _params+3	
	lda #$ff
	sta _params+2	
	sta _params+4
	lda _fb
	sta _params+5	
	jsr _rom_draw

	; draw(size,-size,fb);
	lda _size 
	sta _params+1
	lda #0
	sta _params+2	
	sec
	sbc _size 
	sta _params+3	
	lda #$ff
	sta _params+4
	lda _fb
	sta _params+5	
	jmp _rom_draw
.)

/*
void drawcursor()
{
	//	- draw the cursor at cx,cy size z, foreground/background color (1 or 0)
	char z=boxsize-2;
	pattern(170);
	curset(cx,cy,fb);
	draw(z,0,fb);
	draw(0,z,fb);
	draw(-z,0,fb);
	draw(0,-z,fb);
	pattern(255);
}
*/

_drawcursor
.(
	; char z=boxsize-2;
	ldx _boxsize
	dex
	dex
	stx tmp
	
	; pattern(170);
	lda #170
	sta _rom_pattern

	; curset(cx,cy,fb);
	lda _cx 
	sta _params+1 
	lda _cy
	sta _params+3	
	lda #0
	sta _params+2
	sta _params+4
	lda _fb
	sta _params+5	
	jsr _rom_curset
	
	; draw(z,0,fb);
	lda tmp 
	sta _params+1 
	lda #0
	sta _params+2
	sta _params+3	
	sta _params+4
	lda _fb
	sta _params+5	
	jsr _rom_draw
	
	; draw(0,z,fb);
	lda #0
	sta _params+1 
	sta _params+2
	sta _params+4	
	lda tmp 
	sta _params+3	
	lda _fb
	sta _params+5	
	jsr _rom_draw
	
	; draw(-z,0,fb);
	lda #0
	sta _params+3	
	sta _params+4	
	sec
	sbc tmp
	sta _params+1 
	lda #$ff
	sta _params+2
	lda _fb
	sta _params+5	
	jsr _rom_draw
	
	; draw(0,-z,fb);
	lda #0
	sta _params+1
	sta _params+2	
	sec
	sbc tmp
	sta _params+3 
	lda #$ff
	sta _params+4
	lda _fb
	sta _params+5	
	jsr _rom_draw
		
	; pattern(255);
	lda #255
	sta _rom_pattern
	rts
.)


_drawattackertile
.(
	lda #13			; line length
	sta _size
	jmp _drawbox	; drawbox at x,y position
.)

