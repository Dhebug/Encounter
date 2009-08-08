;Script_SeaShutteredGunpost.s
	
Script_SeaShutteredGunpost
;Set frames for directions
 .byt SET_FRAME
 .byt FS_SEASHUTTEREDGUNPOST
 
 .byt SET_ATTRIBUTES
 .byt 128+64

;Delay for one game cycle
 .byt WAIT
 .byt 0
 
 .byt SET_FRAMEFORDIRECTION
 .byt EAST
 .byt FS_SEASHUTTEREDGUNPOST+4
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTHEAST
 .byt FS_SEASHUTTEREDGUNPOST+5
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTH
 .byt FS_SEASHUTTEREDGUNPOST+6
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTHWEST
 .byt FS_SEASHUTTEREDGUNPOST+7
 
 .byt SET_FRAMEFORDIRECTION
 .byt WEST
 .byt FS_SEASHUTTEREDGUNPOST+8
 
 .byt SET_FRAMEFORDIRECTION
 .byt NORTHWEST
 .byt FS_SEASHUTTEREDGUNPOST+9
 
 .byt SET_FRAMEFORDIRECTION
 .byt NORTH
 .byt FS_SEASHUTTEREDGUNPOST+10
 
 .byt SET_FRAMEFORDIRECTION
 .byt NORTHEAST
 .byt FS_SEASHUTTEREDGUNPOST+11

 .byt SET_COUNTER
 .byt 6
 
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt BRANCH
 .byt lblLoop-Script_SeaShutteredGunpost
.)

;Open hatch
 .byt SET_COUNTER
 .byt 3
.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt INCREMENT_FRAME
 
 .byt BRANCH
 .byt lblLoop-Script_SeaShutteredGunpost
.)

;Rotate until in direction of hero
.(
lblLoop2 
 .byt SET_CONDITION
 .byt BRANCHING_ONNOTFACINGHERO

lblLoop
 .byt TURN_TOWARDS_HERO
 
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt BRANCH
 .byt lblLoop-Script_SeaShutteredGunpost

;Fire projectile
 .byt SPAWN_PROJECTILE
 .byt 8,2
 
;Wait a few game cycles before potentially firing again
 .byt SET_COUNTER
 .byt 16

 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
lblLoop3
 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop3-Script_SeaShutteredGunpost
 
;Just keep turning and shooting
 .byt SET_CONDITION
 .byt BRANCHING_ISUNCONDITIONAL
 .byt BRANCH
 .byt lblLoop2-Script_SeaShutteredGunpost
.)

