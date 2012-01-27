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
	.byt 24,28,29,28,29,30,29,28,29,28,25
	.byt 34,99,22,18,0,18,9,5,18,99,35
	.byt 34,99,99,0,23,4,5,18,99,99,35
	.byt 34,99,99,99,99,99,99,99,99,99,35
	.byt 34,13,4,18,15,18,9,16,15,99,35
	.byt 34,8,9,18,0,3,16,3,0,20,35
	.byt 26,31,32,31,32,33,32,31,32,31,27

/* RUNIC Alphabet Tiles ordered as follows is as follows:
0	F: Fehu			Cattle/Gold/General Wealth
1	U: Uruz			Strength/Speed/Good Health
2	TH:	Thurisaz	Norse Giants
3	A:	Ansuz		The Gods, mostly Odin
4	R:	Raido		A long Journey
5	K/C: Kenaz		Torch/Light source
6	G:	Gebo		sACRIFICE/OFFERING TO THE gODS
7	W:	Wunjo		Comfort/Joy/Glory
8	H:	Hagalaz		Hail/Missile
9	N:	Nauthiz		Need/Necessity
10	I:	Isa			ICE
11	Y:	Jera		year/harvest
12	EI:	Eithwaz		Sacred Yew tree
13	P:	Perth		Unknown
14	Z:	Algiz		Defence/Protection/Self-Preservation
15	S:	Sowilo		The Sun
16	T:	Tiwaz		The War God, TYR
17	B: 	Berkano		Birch Tree/LDUN(goddess of spring/fertility)
18	E:	Ehwaz		Horse
19	M:	Mannaz		Man/Mankind
20	L:	Laguz		Water
21	NG:	Ingwaz		the Danes (and danish hero ING)
22	D:	Dagaz		Day/Daylight
23	O:	Othila		Inheritance (of property or knowledge)
>23=border tiles
_presents
	.byt 13,4,18,15,18,9,16,15
	
_hnefatafl
	.byt 8,9,18,0,3,16,3,0,20	
	
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



