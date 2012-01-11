/* Populate array with tile types
Tile types (for board) from tiles.png:
0=blank
1=attacker square
2=defender square
3=king square
*/
_tiles
	.byt 4,0,0,1,1,1,1,1,0,0,4
	.byt 0,0,0,0,0,1,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0,0,0,0
	.byt 1,0,0,0,0,2,0,0,0,0,1
	.byt 1,0,0,0,2,2,2,0,0,0,1
	.byt 1,1,0,2,2,3,2,2,0,1,1
	.byt 1,0,0,0,2,2,2,0,0,0,1
	.byt 1,0,0,0,0,2,0,0,0,0,1
	.byt 0,0,0,0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,1,0,0,0,0,0
	.byt 4,0,0,1,1,1,1,1,0,0,4
/* Tile types (from bordertiles.png)
0=topleft, 1=top right, 2=bottoml eft, 3=bottom right
4,5,6 = top row
7,8,9 = bottom row
10,11 = left/right columns
12=blank
*/
_border
	.byt 0,4,5,4,6,4,5,4,1
	.byt 10,12,12,12,12,12,12,12,11
	.byt 10,12,12,12,12,12,12,12,11
	.byt 10,12,12,12,12,12,12,12,11
	.byt 10,12,12,12,12,12,12,12,11
	.byt 10,12,12,12,12,12,12,12,11
	.byt 10,12,12,12,12,12,12,12,11
	.byt 10,12,12,12,12,12,12,12,11
	.byt 2,7,8,7,9,7,8,7,3
/*
_baseplayers
	.byt 4,0,0,1,1,1,1,1,0,0,4
	.byt 0,0,0,0,0,1,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0,0,0,0
	.byt 1,0,0,0,0,2,0,0,0,0,1
	.byt 1,0,0,0,2,2,2,0,0,0,1
	.byt 1,1,0,2,2,3,2,2,0,1,1
	.byt 1,0,0,0,2,2,2,0,0,0,1
	.byt 1,0,0,0,0,2,0,0,0,0,1
	.byt 0,0,0,0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,1,0,0,0,0,0
	.byt 4,0,0,1,1,1,1,1,0,0,4
*/
; uninitialized variable (will calc on fly) - target values of square
_baseplayers
	.dsb 11*11
 
_target
	.dsb 11*11		

_enemy
	.dsb 11*11

_computer
	.dsb 11*11
	  	
_ClearArrays	
.(
	lda #0
	ldx #0
loop_clear
	sta _target,x
	sta _computer,x
	sta _enemy,x
	inx
	cpx #11*11
	bne loop_clear	
	rts
.)



