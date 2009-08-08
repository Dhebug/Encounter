;Script_ApacheXX.s
;Manouvre Apache around screen (starting at 10,0)


;On entering this script the Frame must be 00 because we'll use relative stepping to alternate frame

;Move Apache down almost to bottom of screen
Script_ApacheXX
 .byt SET_COUNTER
 .byt 25
 
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 3
 
 .byt INCREMENT_FRAME
 
 .byt SCROLL_SOUTH
 .byt 3
 
 .byt DECREMENT_FRAME

 .byt BRANCH
 .byt lblLoop-Script_ApacheXX
.)

;Now Move apache left 8
 .byt SET_COUNTER
 .byt 4
.(
lblLoop
 .byt MOVE_WEST
 
 .byt DISPLAY_SPRITE
 
 .byt INCREMENT_FRAME
 
 .byt MOVE_WEST

 .byt DISPLAY_SPRITE
 
 .byt DECREMENT_FRAME
 
 .byt BRANCH
 .byt lblLoop-Script_ApacheXX
.)

;Now move apache right 16

 
 



