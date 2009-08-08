Script_DualMissileLauncherEast
 .byt SET_FRAME
 .byt DUALMISSILELAUNCHER
 
 .byt SET_ATTRIBUTES
 .byt 128+64
;Open Hatch
 .byt SCROLL_SOUTH
 .byt 1
 
 .byt SET_FRAME
 .byt DUALMISSILELAUNCHER+1

 .byt SCROLL_SOUTH
 .byt 1

 .byt SET_FRAME
 .byt DUALMISSILELAUNCHER+2

 .byt SCROLL_SOUTH
 .byt 1

 .byt SET_FRAME
 .byt DUALMISSILELAUNCHER+3

 .byt SCROLL_SOUTH
 .byt 1

;Fire Missile West
 .byt SPAWN_PROJECTILE
 .byt 9,10
 
;Close Hatch
 .byt SET_FRAME
 .byt DUALMISSILELAUNCHER+2

 .byt SCROLL_SOUTH
 .byt 1

 .byt SET_FRAME
 .byt DUALMISSILELAUNCHER+1

 .byt SCROLL_SOUTH
 .byt 1

 .byt SET_FRAME
 .byt DUALMISSILELAUNCHER

 .byt SCROLL_SOUTH
 .byt 1

;Wait a moment
 .byt SCROLL_SOUTH
 .byt 1

 .byt SCROLL_SOUTH
 .byt 1

 .byt SCROLL_SOUTH
 .byt 1
;For mo we'll terminate but eventually decide on scroll/statics
 .byt TERMINATE
