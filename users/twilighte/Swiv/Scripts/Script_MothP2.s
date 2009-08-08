;Moth P2 Moves to base of screen then scrolls north constantly firing projectiles at both players.
Script_MothP2
 .byt SET_FRAME
 .byt FS_MOTHP2

 .byt SET_ATTRIBUTES
 .byt 8


;Move sprite to base of screen
 .byt MOVE_XY
 .byt 158-12
 
 .byt DISPLAY_SPRITE

;Scroll north(firing) until off-screen
.(
lblLoop
 .byt MOVE_NORTH
 .byt 2
 
; .byt SPAWN_PROJECTILE
; .byt 
 
 .byt DISPLAY_SPRITE
 
 .byt BRANCH
 .byt lblLoop-Script_MothP2
.)
