;Script_Gunpost.s
;Set default frame
Script_Gunpost
 .byt SET_FRAME
 .byt COLGUNPOST_FRAMESTART
 
 .byt SET_ATTRIBUTES
 .byt 128+64

 .byt SET_FRAMEFORDIRECTION
 .byt EAST
 .byt COLGUNPOST_FRAMESTART
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTHEAST
 .byt COLGUNPOST_FRAMESTART+1
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTH
 .byt COLGUNPOST_FRAMESTART+2
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTHWEST
 .byt COLGUNPOST_FRAMESTART+3
 
 .byt SET_FRAMEFORDIRECTION
 .byt WEST
 .byt COLGUNPOST_FRAMESTART+4
 
 .byt SET_FRAMEFORDIRECTION
 .byt NORTHWEST
 .byt COLGUNPOST_FRAMESTART+5
 
 .byt SET_FRAMEFORDIRECTION
 .byt NORTH
 .byt COLGUNPOST_FRAMESTART+6
 
 .byt SET_FRAMEFORDIRECTION
 .byt NORTHEAST
 .byt COLGUNPOST_FRAMESTART+7

;Rotate until in direction of hero
.(
lblLoop3 
 .byt SET_CONDITION
 .byt BRANCHING_ONNOTFACINGHERO
lblLoop
 .byt TURN_TOWARDS_HERO
 
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt BRANCH
 .byt lblLoop-Script_Gunpost

;Fire projectile
 .byt SPAWN_PROJECTILE
 .byt 8,4

;Wait a while
 .byt SET_COUNTER
 .byt 4

 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
lblLoop2 
 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop2-Script_Gunpost

;Continue Turning to face hero and firing until offscreen
 .byt SET_CONDITION
 .byt BRANCHING_ISUNCONDITIONAL

 .byt BRANCH
 .byt lblLoop3-Script_Gunpost
.)

