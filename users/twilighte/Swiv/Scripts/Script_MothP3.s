;Moth P3 moves to base of screen then scrolls north until offscreen
Script_MothP3
 .byt SET_FRAME
 .byt FS_MOTHP3

 .byt SET_ATTRIBUTES
 .byt 8


;Move sprite to base of screen
 .byt MOVE_XY
 .byt 158-12
 
 .byt DISPLAY_SPRITE

;Scroll north until off-screen
.(
lblLoop
 .byt MOVE_NORTH
 .byt 2
 
 .byt DISPLAY_SPRITE
 
 .byt BRANCH
 .byt lblLoop-Script_MothP3
.)
