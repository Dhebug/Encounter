;Script_ScrubShutteredGunpost.s
;SCROLL_SOUTH(s)		.byt 0,s
;
;MOVE_EAST			1
;MOVE_SOUTH(s)		.byt 2,s
;MOVE_WEST			3
;MOVE_NORTH(s)		.byt 4,s
;MOVE_FORWARD		5
;MOVE_TOWARDS_HERO		6
;MOVE(x,y)			.byt 7,x,y
;
;SET_DIRECTIONFRAME(n,f)	.byt 8,n,f
;SET_EXPLOSION(s)		.byt 9,s
;SET_COUNTER(v)		.byt 10,v
;SET_CONDITION(c)		.byt 11,c
;SET_TARGET(p)		.byt 12,p
;SET_FRAME(n)		.byt 13,n
;DECREMENT_FRAME		14
;INCREMENT_FRAME		15
;
;TURN_CLOCKWISE		16
;TURN_ANTICLOCKWISE		17
;TURN_TOWARDS_HERO		18

;s ScriptID
;g MultiPartSprite Flag - If 128 the sprite is part of the parent
;SPAWN_SCRIPT(s,g)		.byt 19,s,g
;SPAWN_SCRIPTXY(x,y,s,g)	.byt 20,x,y,s,g
;
;BRANCH(i)			.byt 21,i
;DISPLAY_SPRITE		22
;TERMINATE			23
;WAIT(p)			.byt 24,p
	
Script_ScrubShutteredGunpost
;Set frames for directions
	SET_FRAME(2)	;Default frame(shutter closed)
	SET_FRAMEFOR_E(6)	;Set frame for East
	SET_FRAMEFOR_SE(7)	;Set frame for East
	SET_FRAMEFOR_S(8)	;Set frame for East
	SET_FRAMEFOR_SW(9)	;Set frame for East
	SET_FRAMEFOR_W(10)	;Set frame for East
	SET_FRAMEFOR_NW(11)	;Set frame for East
	SET_FRAMEFOR_N(12)	;Set frame for East
	SET_FRAMEFOR_NE(13)	;Set frame for East

	SET_COUNTER(6)
	SET_BRANCHINGCOUNTERNOTZERO
.(
lblLoop
	SCROLL_SOUTH(2)
	BRANCH(lblLoop-Script_ScrubShutteredGunpost)
.)
;Open hatch
	SET_COUNTER(3)
.(
lblLoop
	SCROLL_SOUTH(2)
	SCROLL_SOUTH(2)
	INCREMENT_FRAME
	BRANCH(lblLoop-Script_ScrubShutteredGunpost)
.)
;Rotate until in direction of hero
	SET_COUNTER(4)
	SET_BRANCHINGNOTFACINGHERO
.(
lblLoop
	TURN_TOWARDS_HERO
	SCROLL_SOUTH(2)
	BRANCH(lblLoop-Script_ScrubShutteredGunpost)
;Fire projectile
	SPAWN_SCRIPT(4,0)
;Wait a while
	SCROLL_SOUTH(2)
	SCROLL_SOUTH(2)
;Fire again
	SET_BRANCHINGCOUNTERNOTZERO
	BRANCH(lblLoop-Script_ScrubShutteredGunpost)
.)
;Rotate until East
	SET_BRANCHINGNOTFACINGEAST
.(
lblLoop
	TURN_CLOCKWISE
	SCROLL_SOUTH(2)
	BRANCH(lblLoop-Script_ScrubShutteredGunpost)
.)
;Close hatch
	SET_COUNTER(3)
	SET_FRAME(5)
	SET_BRANCHINGCOUNTERNOTZERO
.(
lblLoop
	SCROLL_SOUTH(2)
	DECREMENT_FRAME
	BRANCH(lblLoop-Script_ScrubShutteredGunpost)
.)
;Continue scrolling down until out of view
	SET_BRANCHINGUNCONDITIONAL
.(
lblLoop
	SCROLL_SOUTH(2)
	BRANCH(lblLoop-Script_ScrubShutteredGunpost)
.)

