Script_RiverConcealedGunpost
 .byt SET_FRAME
 .byt FS_RIVERCONCEALEDGUNPOST
 
 .byt SET_ATTRIBUTES
 .byt 128+64
 
;Set Direction frames
 .byt SET_FRAMEFORDIRECTION
 .byt EAST
 .byt FS_RIVERCONCEALEDGUNPOST+2
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTHEAST
 .byt FS_RIVERCONCEALEDGUNPOST+3
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTH
 .byt FS_RIVERCONCEALEDGUNPOST_S

 .byt SET_FRAMEFORDIRECTION
 .byt SOUTHWEST
 .byt FS_RIVERCONCEALEDGUNPOST_S+1
 
 .byt SET_FRAMEFORDIRECTION
 .byt WEST
 .byt FS_RIVERCONCEALEDGUNPOST_S+2

 .byt SET_FRAMEFORDIRECTION
 .byt NORTHWEST
 .byt FS_RIVERCONCEALEDGUNPOST_S+3
 
 .byt SET_FRAMEFORDIRECTION
 .byt NORTH
 .byt FS_RIVERCONCEALEDGUNPOST_S+4

 .byt SET_FRAMEFORDIRECTION
 .byt NORTHEAST
 .byt FS_RIVERCONCEALEDGUNPOST_S+5
 
;Scroll down so we see empty River at first
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO

 .byt SET_COUNTER
 .byt 20
.(
lblLoop
 .byt MOVE_SOUTH
 .byt 3
 
 .byt WAIT
 .byt 1
 
 .byt BRANCH
 .byt lblLoop-Script_RiverConcealedGunpost
.)

;Now raise gunpost from water
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt SCROLL_SOUTH
 .byt 1

 .byt SET_FRAME
 .byt FS_RIVERCONCEALEDGUNPOST+1
  
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt SCROLL_SOUTH
 .byt 1

;And turn to face hero
 .byt SET_COUNTER
 .byt 4
.(
lblLoop2 
 .byt SET_CONDITION
 .byt BRANCHING_ONNOTFACINGHERO
lblLoop
 .byt TURN_TOWARDS_HERO
 
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt BRANCH
 .byt lblLoop-Script_RiverConcealedGunpost

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
 .byt lblLoop3-Script_RiverConcealedGunpost

;Just keep turning and shooting
 .byt SET_CONDITION
 .byt BRANCHING_ISUNCONDITIONAL

 .byt BRANCH
 .byt lblLoop2-Script_RiverConcealedGunpost
.)

 



 
