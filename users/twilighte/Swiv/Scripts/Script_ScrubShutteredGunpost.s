;Script_ScrubShutteredGunpost.s
	
Script_ScrubShutteredGunpost
;Set frames for directions
 .byt SET_FRAME
 .byt FS_SCRUBSHUTTEREDGUNPOST
 
 .byt SET_ATTRIBUTES
 .byt 128+64

;Delay for one game cycle
 .byt WAIT
 .byt 4
 
 .byt SET_FRAMEFORDIRECTION
 .byt EAST
 .byt FS_SCRUBSHUTTEREDGUNPOST+4
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTHEAST
 .byt FS_SCRUBSHUTTEREDGUNPOST+5
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTH
 .byt FS_SCRUBSHUTTEREDGUNPOST+6
 
 .byt SET_FRAMEFORDIRECTION
 .byt SOUTHWEST
 .byt FS_SCRUBSHUTTEREDGUNPOST+7
 
 .byt SET_FRAMEFORDIRECTION
 .byt WEST
 .byt FS_SCRUBSHUTTEREDGUNPOST+8
 
 .byt SET_FRAMEFORDIRECTION
 .byt NORTHWEST
 .byt FS_SCRUBSHUTTEREDGUNPOST+9
 
 .byt SET_FRAMEFORDIRECTION
 .byt NORTH
 .byt FS_SCRUBSHUTTEREDGUNPOST+10
 
 .byt SET_FRAMEFORDIRECTION
 .byt NORTHEAST
 .byt FS_SCRUBSHUTTEREDGUNPOST+11

 .byt SET_COUNTER
 .byt 6
 
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt BRANCH
 .byt lblLoop-Script_ScrubShutteredGunpost
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
 .byt lblLoop-Script_ScrubShutteredGunpost
.)

;Rotate until in direction of hero
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
 .byt lblLoop-Script_ScrubShutteredGunpost

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
 .byt lblLoop3-Script_ScrubShutteredGunpost

;Just keep turning and shooting
 .byt SET_CONDITION
 .byt BRANCHING_ISUNCONDITIONAL

 .byt BRANCH
 .byt lblLoop2-Script_ScrubShutteredGunpost
.)

;;Wait a while
; .byt SCROLL_SOUTH
; .byt 1
; .byt SCROLL_SOUTH
; .byt 1
;
;;Fire again
; .byt SET_CONDITION
; .byt BRANCHING_ONCOUNTERNOTZERO
;
; .byt BRANCH
; .byt lblLoop-Script_ScrubShutteredGunpost
;.)
;;Rotate until East
; .byt SET_CONDITION
; .byt BRANCHING_ONNOTFACINGEAST
;.(
;lblLoop
; .byt TURN_CLOCKWISE
; 
; .byt SCROLL_SOUTH
; .byt 1
; 
; .byt BRANCH
; .byt lblLoop-Script_ScrubShutteredGunpost
;.)
;;Close hatch
; .byt SET_COUNTER
; .byt 2
; 
; .byt SET_FRAME
; .byt 5
; 
; .byt SET_CONDITION
; .byt BRANCHING_ONCOUNTERNOTZERO
;.(
;lblLoop
; .byt SCROLL_SOUTH
; .byt 1
; 
; .byt DECREMENT_FRAME
; 
; .byt BRANCH
; .byt lblLoop-Script_ScrubShutteredGunpost
;.)
;;Continue scrolling down until out of view
; .byt SET_CONDITION
; .byt BRANCHING_ISUNCONDITIONAL
;.(
;lblLoop
; .byt SCROLL_SOUTH
; .byt 1
; 
; .byt BRANCH
; .byt lblLoop-Script_ScrubShutteredGunpost
;.)

