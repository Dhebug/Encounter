;This ones a little more complex
;Scroll down 20.
;Scroll right(and down) for 5 then trigger 15(Coal).
;Scroll Right(and down) another 4 and trigger 16
;Scroll again another 6 and trigger 14
;Scroll again another 5 then trigger 17

Script_TrainEngineE
 .byt SET_FRAME
 .byt FS_TRAINENGINE
 
 .byt SET_ATTRIBUTES
 .byt 64+128
 

;Scroll down 20
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
 
 .byt SET_COUNTER
 .byt 10
.(
lblLoop1
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt BRANCH
 .byt lblLoop1-Script_TrainEngineE
.)

;Scroll right(and down) for 5 then trigger 15(Coal)
 .byt SET_COUNTER
 .byt 5
.(
lblLoop1
 .byt MOVE_EAST
 
 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop1-Script_TrainEngineE
.)
 .byt SPAWN_SCRIPT
 .byt SC_WAGON_COAL
 .byt 0

;Scroll Right(and down) another 4 and trigger 16
 .byt SET_COUNTER
 .byt 4
.(
lblLoop1
 .byt MOVE_EAST
 
 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop1-Script_TrainEngineE
.)
 .byt SPAWN_SCRIPT
 .byt SC_WAGON_EMPTY
 .byt 0

;Scroll again another 6 and trigger 14
 .byt SET_COUNTER
 .byt 6
.(
lblLoop1
 .byt MOVE_EAST

 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop1-Script_TrainEngineE
.)
 .byt SPAWN_SCRIPT
 .byt SC_WAGON_GUN
 .byt 0

;Scroll again another 5 then trigger 17
 .byt SET_COUNTER
 .byt 5
.(
lblLoop1
 .byt MOVE_EAST

 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop1-Script_TrainEngineE
.)
 .byt SPAWN_SCRIPT
 .byt SC_WAGON_LUMBER
 .byt 0

;Continue to scroll right/down until offscreen
 .byt SET_CONDITION
 .byt BRANCHING_ISUNCONDITIONAL
 
.(
lblLoop1
 .byt MOVE_EAST
 
 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop1-Script_TrainEngineE
.)

