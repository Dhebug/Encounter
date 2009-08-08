;Script_RailwayGatesP2.s
;This is the spawned Top gates (spawned by Bottom Gates)
Script_RailwayGatesP2
 .byt SET_FRAME
 .byt TOP_RAILWAYGATES_FRAMESTART

 .byt SET_ATTRIBUTES
 .byt 128+64

 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
;Scroll down a short time so its viewable before it starts to drop gate
 .byt SET_COUNTER
 .byt 5
.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt BRANCH
 .byt lblLoop-Script_RailwayGatesP2
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
 .byt lblLoop-Script_RailwayGatesP2
.)

;Then continue down
 .byt SET_CONDITION
 .byt BRANCHING_ISUNCONDITIONAL

.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 1

 .byt BRANCH
 .byt lblLoop-Script_RailwayGatesP2
.)

