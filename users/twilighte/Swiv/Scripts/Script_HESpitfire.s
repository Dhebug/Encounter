;Script_HESpitfire.s - Horizontal Spitfire wave (4) heading east from Left side

Script_HESpitfire
;Only one frame to worry about
 .byt SET_FRAME
 .byt FS_HESPITFIRE

 .byt SET_ATTRIBUTES
 .byt 8

;However relocate to Left side and down a little way
 .byt MOVE_XY
 .byt 0,20
 
;Now simply move East (until boundary terminates it)
.(
lblLoop
 .byt MOVE_EAST
 
 .byt DISPLAY_SPRITE
 
 .byt BRANCH
 .byt lblLoop-Script_HESpitfire
.)
