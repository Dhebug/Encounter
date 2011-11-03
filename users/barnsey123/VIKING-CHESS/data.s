/* Populate array with tile types
Tile types:
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
/*
_desireatt
	.byt 0,2,2,2,2,2,2,2,2,2,0
	.byt 2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,2,0,2,2,2,2,2
	.byt 2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,2,2,2,2,2,2,2
	.byt 0,2,2,2,2,2,2,2,2,2,0
*/
; uninitialized variable (will calc on fly) - target values of square 
_target
	.dsb 11*11		

_enemy
	.dsb 11*11

_computer
	.dsb 11*11
	  	
_ClearTargetAndEnemy	
.(
	lda #0
	ldx #0
loop_clear
	sta _target,x
	sta _enemy,x
	sta _computer,x
	inx
	cpx #11*11
	bne loop_clear	
	rts
.)


