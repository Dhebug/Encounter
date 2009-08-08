;Script_SpitFire.s

;The Spitfire script moves the aircraft from the top of the screen downwards to around the centre
;then the plane performs a loop returning back to the top upside down.
Script_SpitFire
 .byt SET_FRAME
 .byt FS_SPITFIRE
 
 .byt SET_ATTRIBUTES
 .byt 8

;Move down to centre of screen
 .byt SET_COUNTER
 .byt 20
 
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 3
 
 .byt BRANCH
 .byt lblLoop-Script_SpitFire
.)
;Now perform flip
 .byt SET_COUNTER
 .byt 5
.(
lblLoop
 .byt INCREMENT_FRAME

 .byt DISPLAY_SPRITE

 .byt BRANCH
 .byt lblLoop-Script_SpitFire
.)
 .byt MOVE_NORTH
 .byt 2
 .byt INCREMENT_FRAME
 .byt DISPLAY_SPRITE
;And move back up off screen
 .byt SET_CONDITION
 .byt BRANCHING_ISUNCONDITIONAL
.(
lblLoop
 .byt MOVE_NORTH
 .byt 4

 .byt DISPLAY_SPRITE
 .byt BRANCH
 .byt lblLoop-Script_SpitFire
.)

 

 

