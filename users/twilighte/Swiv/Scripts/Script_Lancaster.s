;Lancaster Bomber Script
;A simple script of the Lancaster moving from top down animated with frames 0 and 1
Script_Lancaster
 .byt SET_FRAME
 .byt LANCASTER_FRAMESTART

 .byt SET_ATTRIBUTES
 .byt 8

.(
lblLoop
 .byt SCROLL_SOUTH
 .byt 2

 .byt BRANCH
 .byt lblLoop-Script_Lancaster
.)

