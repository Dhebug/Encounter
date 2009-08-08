;Script_HWSpitfire.s - Horizontal Spitfire wave (4) heading west from Right side

Script_HWSpitfire
;Only one frame to worry about
 .byt SET_FRAME
 .byt FS_HWSPITFIRE

 .byt SET_ATTRIBUTES
 .byt 8

;However relocate to Right side and down a little
 .byt MOVE_XY
 .byt 19,80
 
;Now simply move East (until boundary terminates it)
.(
lblLoop
 .byt MOVE_WEST
 
 .byt DISPLAY_SPRITE
 
 .byt BRANCH
 .byt lblLoop-Script_HWSpitfire
.)
