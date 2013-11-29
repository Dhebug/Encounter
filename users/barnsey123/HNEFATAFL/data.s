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
/*
_border
	.byt 22,26,26,26,26,26,26,26,26,26,23
	.byt 28,99,0,2,4,2,6,20,2,99,29
	.byt 28,99,99,4,8,10,20,2,99,99,29
	.byt 28,99,99,99,99,99,99,99,99,99,29
	.byt 28,12,6,2,4,14,16,14,4,18,29
	.byt 24,27,27,27,27,27,27,27,27,27,25
*/
/* RUNIC Alphabet Tiles ordered as follows is as follows:
4	F: Fehu			Cattle/Gold/General Wealth
14	A:	Ansuz		The Gods, mostly Odin
10	R:	Raido		A long Journey
12	H:	Hagalaz		Hail/Missile
6	N:	Nauthiz		Need/Necessity
16	T:	Tiwaz		The War God, TYR
2	E:	Ehwaz		Horse
18	L:	Laguz		Water
0	D:	Dagaz		Day/Daylight
8	O:	Othila		Inheritance (of property or knowledge)
>23=border tiles
_presents
	.byt 13,4,18,15,18,9,16,15
	
_hnefatafl
	.byt 8,9,18,0,3,16,3,0,20	
	
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
/*
Trophy Text,
FIRST BLOOD
BLOOD EAGLE
BERZERKER
ALGIZ
URUZ
RAIDO
*/
_TrophyText
	.byt 70,73,82,83,84,32,66,76,79,79,68 
	.byt 66,76,79,79,68,32,69,65,71,76,69 
	.byt 66,69,82,90,69,82,75,69,82,32,32 
	.byt 65,76,71,73,90,32,32,32,32,32,32 
	.byt 85,82,85,90,32,32,32,32,32,32,32 
	.byt 82,65,73,68,79,32,32,32,32,32,32 

; uninitialized variable (will calc on fly) - target values of square

_target
	.dsb 11*11		

_enemy
	.dsb 11*11

_computer
	.dsb 11*11

;_priority
;	.dsb 11*11

_kingtracker
	.dsb 11*11

;_ColCountAtt
;	.dsb 11
	
;_RowCountAtt
;	.dsb 11
			  	
_ClearArrays	
.(
	lda #0
	ldx #0
loop_clear
	sta _target,x
	sta _computer,x
	sta _enemy,x
	;sta _priority,x
	sta _kingtracker,x
	inx
	cpx #11*11
	bne loop_clear	
	rts
.)
;_ClearArrays2
;.(
;	lda #0
;	ldx #0
;loop_clear
;	sta _RowCountAtt,x
;	sta _ColCountAtt,x
;	inx
;	cpx #11
;	bne loop_clear
;	rts
;.)
/*
_CopyFont
.(
	ldx #0
loop
	lda _Font_6x8_runic1_partial+256*0,x
	sta $b400+32*8+256*0,x
	
	lda _Font_6x8_runic1_partial+256*1,x
	sta $b400+32*8+256*1,x
	
	lda _Font_6x8_runic1_partial+256*2,x
	sta $b400+32*8+256*2,x
	
	inx 
	
	bne loop
	rts	
.)
*/


