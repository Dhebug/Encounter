;Script_RailwayGates.s
;This is only complicated because we need to spawn the top gate 11 rows down.
Script_RailwayGatesP1
 .byt SET_FRAME
 .byt BOT_RAILWAYGATES_FRAMESTART
 
 .byt SET_ATTRIBUTES
 .byt 128+64

 .byt WAIT
 .byt 1

;Scroll down 11 rows
 .byt SET_COUNTER
 .byt 3

 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop-Script_RailwayGatesP1
.)
;Now spawn Top gates
 .byt SPAWN_SCRIPT
 .byt TOP_RAILWAYGATES_SCRIPT
 .byt MULTIPART

;Proceed down for a while
 .byt SET_COUNTER
 .byt 14
.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop-Script_RailwayGatesP1
.)
;Then proceed to close Bottom Road gate
 .byt SET_COUNTER
 .byt 2
.(
lblLoop
 .byt INCREMENT_FRAME
 .byt SCROLL_SOUTH
 .byt 1
 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop-Script_RailwayGatesP1
.)

;Then continue down
 .byt SET_CONDITION
 .byt BRANCHING_ISUNCONDITIONAL
.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop-Script_RailwayGatesP1
.)

