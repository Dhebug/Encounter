;Script_ApacheP2 - Script S
;Do Standard stuff
Script_ApacheP2
 .byt SET_FRAME
 .byt FS_APACHE_00P2
 
 .byt SET_ATTRIBUTES
 .byt 8
;Control Scroll on of P2 (8 rasters, 4 rows)
 .byt SET_COUNTER
 .byt 2
 
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
.(
lblLoop1
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt SET_FRAME
 .byt FS_APACHE_01P2
 
 .byt SCROLL_SOUTH
 .byt 1

 .byt SET_FRAME
 .byt FS_APACHE_00P2

 .byt BRANCH
 .byt lblLoop1-Script_ApacheP2
.)

;Jump to Script X
 .byt JUMP_SCRIPT
 .byt SC_APACHE_XX
