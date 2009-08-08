;OSS_LanguageDefines
#define	PLAYERA		0
#define	PLAYERB		1


#define	DEFAULT_EXPLOSIONSCRIPT	63

#define	SCROLL_SOUTH(s)		.byt 0,s

#define	MOVE_EAST			1
#define	MOVE_SOUTH(s)		.byt 2,s
#define	MOVE_WEST			3
#define	MOVE_NORTH(s)		.byt 4,s
#define	MOVE_FORWARD		5
#define	MOVE_TOWARDS_HERO		6
#define	MOVE(x,y)			.byt 7,x,y

#define	SET_FRAMEFOR_E(f)		.byt 8,0,f
#define	SET_FRAMEFOR_SE(f)		.byt 8,1,f
#define	SET_FRAMEFOR_S(f)		.byt 8,2,f
#define	SET_FRAMEFOR_SW(f)		.byt 8,3,f
#define	SET_FRAMEFOR_W(f)		.byt 8,4,f
#define	SET_FRAMEFOR_NW(f)		.byt 8,5,f
#define	SET_FRAMEFOR_N(f)		.byt 8,6,f
#define	SET_FRAMEFOR_NE(f)		.byt 8,7,f
#define	SET_EXPLOSION(s)		.byt 9,s
#define	SET_COUNTER(v)		.byt 10,v
#define	SET_CONDITION(c)		.byt 11,c

#define	SET_BRANCHINGUNCONDITIONAL	.byt 11,0
#define	SET_BRANCHINGNOTFACINGHERO	.byt 11,1
#define	SET_BRANCHINGNOTFACINGEAST	.byt 11,2
#define	SET_BRANCHINGCOUNTERNOTZERO	.byt 11,3

#define	SET_TARGET(p)		.byt 12,p
#define	SET_FRAME(n)		.byt 13,n
#define	DECREMENT_FRAME		14
#define	INCREMENT_FRAME		15

#define	TURN_CLOCKWISE		16
#define	TURN_ANTICLOCKWISE		17
#define	TURN_TOWARDS_HERO		18

;s ScriptID
;g MultiPartSprite Flag - If 128 the sprite is part of the parent
#define	SPAWN_SCRIPT(s,g)		.byt 19,s,g
#define	SPAWN_SCRIPTXY(x,y,s,g)	.byt 20,x,y,s,g


#define	BRANCH(i)			.byt 21,i
#define	DISPLAY_SPRITE		22
#define	TERMINATE			23
#define	WAIT(p)			.byt 24,p

