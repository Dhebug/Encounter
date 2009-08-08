;Moth P1 moves sprite to base of screen and scrolls up 8 then triggers P2. Scrolls a further 8 then triggers
;P1. Then continues to scroll north until off-screen
Script_MothP1
 .byt SET_FRAME
 .byt FS_MOTHP1

 .byt SET_ATTRIBUTES
 .byt 8

;Move sprite to base of screen
 .byt MOVE_XY
 .byt 158-12

 .byt DISPLAY_SPRITE
;Scroll up 8 rows
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
 
 .byt SET_COUNTER
 .byt 4
.(
lblLoop
 .byt MOVE_NORTH
 .byt 2
 
 .byt DISPLAY_SPRITE
 
 .byt BRANCH
 .byt lblLoop-Script_MothP1
.)
;Spawn P2
 .byt SPAWN_SCRIPT
 .byt SC_MOTHP2
 .byt 128
 
;Scroll up a further 8 rows
 .byt SET_COUNTER
 .byt 4
.(
lblLoop
 .byt MOVE_NORTH
 .byt 2
 
 .byt DISPLAY_SPRITE
 
 .byt BRANCH
 .byt lblLoop-Script_MothP1
.)

;Spawn P3
 .byt SPAWN_SCRIPT
 .byt SC_MOTHP3
 .byt 128
 
;Continue to scroll north until off-screen
 .byt SET_CONDITION
 .byt BRANCHING_ISUNCONDITIONAL
.(
lblLoop
 .byt MOVE_NORTH
 .byt 2
 
 .byt DISPLAY_SPRITE
 
 .byt BRANCH
 .byt lblLoop-Script_MothP1
.)
