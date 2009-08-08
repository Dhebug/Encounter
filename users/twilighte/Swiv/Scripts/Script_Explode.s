;Script_Explode.s

ExplosionScript
 .byt SET_FRAME
 .byt DEFAULTEXPLODE_STARTFRAME

 .byt SET_ATTRIBUTES
 .byt BIT4
 
 .byt SET_COUNTER
 .byt 11
 
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 1

 .byt INCREMENT_FRAME
 
 .byt BRANCH
 .byt lblLoop-ExplosionScript
.)
 
 .byt TERMINATE
