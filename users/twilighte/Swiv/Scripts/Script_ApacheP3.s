;Script_ApacheMain.s
;The Apache is a 2 frame(00,01) 24x24 pixel sprite used at EOL in Level1
;Each frame is split vertically into 3 parts (P1,P2,P3)

;There are 4 scripts connected with the Apache.

;Script M is this one and controls the scroll-on of P3, the trigger of Script S for the scroll-on of P2 and
;the trigger of Script F for the scroll-on of P1. Once completed Scripts M,S and F then call Script X to move
;around the screen synchronously.
Script_ApacheP3
;Do Standard stuff
 .byt SET_FRAME
 .byt FS_APACHE_00P3
 
 .byt SET_ATTRIBUTES
 .byt 8
;Control Scroll on of P3 (8 rasters, 4 rows)
 .byt SET_COUNTER
 .byt 2
 
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
.(
lblLoop1
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt SET_FRAME
 .byt FS_APACHE_01P3
 
 .byt SCROLL_SOUTH
 .byt 1

 .byt SET_FRAME
 .byt FS_APACHE_00P3

 .byt BRANCH
 .byt lblLoop1-Script_ApacheP3
.)



;Trigger Script S
 .byt SPAWN_SCRIPT
 .byt SC_APACHE_P2
 .byt MULTIPART
 

;Continue scrolling on P3 another 8 rasters
 .byt SET_COUNTER
 .byt 2
 
 .byt SET_CONDITION
 .byt BRANCHING_ONCOUNTERNOTZERO
.(
lblLoop1
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt SET_FRAME
 .byt FS_APACHE_01P3
 
 .byt SCROLL_SOUTH
 .byt 1

 .byt SET_FRAME
 .byt FS_APACHE_00P3

 .byt BRANCH
 .byt lblLoop1-Script_ApacheP3
.)

 
;Trigger Script F
 .byt SPAWN_SCRIPT
 .byt SC_APACHE_P1
 .byt MULTIPART

;Jump to Script X
 .byt JUMP_SCRIPT
 .byt SC_APACHE_XX

