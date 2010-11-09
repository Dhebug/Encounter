;DroidScriptsData.s

;Set the speed of the droid
; SETSPEED,Speed

;Set the number of steps to move the droid in the current direction. If the droid reaches the end of the rail
;it will move on to the next instruction. If 128 then move to the end of the rail
; MOVE,Step

;Turns the droid to lookback position and waits 2 game cycles
; LOOKBACK

;Senses ethan by sight and branches to index if seen
; ONSENSE,Index

;Returns droid to facing current course after lookback. If currently on course then skip to next instruction
; RETURNTOCOURSE

;branches to index if the droid is at the end of the rail
; ONENDOFRAIL,Index

;Turns Droid in opposite direction. However if in lookback position continue to turn to looking in opposite
;direction.
; TURN

;Droid shoots for set period. If spark found to go beyond wall then only wait for duration of spark
; SPARK

;Jumps to index
; JUMP,Index

;Waits for period
; WAIT,Period

;Set frame to facing direction
; FACE

;eor/fire/turn/
DroidScript00
 .byt SETSPEED
 .byt 4
 
.(
lblLoop
 .byt MOVE	;Move to end of rail
 .byt TOENDOFRAIL
 
 .byt SPARK	;Shoot
 
 .byt TURN	;Turn in opposite direction
 
 .byt JUMP
 .byt lblLoop-DroidScript00
.)


;eor/fire/turn/fire/
DroidScript02
DroidScript01
 .byt SETSPEED
 .byt 4

.(
lblLoop
 .byt MOVE	;Move to end of rail
 .byt TOENDOFRAIL
 
 .byt SPARK	;Shoot
 
 .byt TURN	;Turn in opposite direction

 .byt SPARK	;Shoot
 
 .byt JUMP
 .byt lblLoop-DroidScript01
.)

;mv5/fire/rpt to eor/turn
;DroidScript02
; .byt SETSPEED
; .byt 4
;
;.(
;lblLoop
; .byt MOVE	;Move to end of rail
; .byt 5
; 
; .byt SPARK	;Shoot
; 
; .byt ONENDOFRAIL
; .byt lblTurn-DroidScript02
; 
; .byt JUMP
; .byt lblLoop-DroidScript02
;lblTurn
; .byt TURN	;Turn in opposite direction
; 
; .byt JUMP
; .byt lblLoop-DroidScript02
;.)

;eor/turn
DroidScript03
 .byt SETSPEED
 .byt 2

.(
lblLoop
 .byt MOVE	;Move to end of rail
 .byt TOENDOFRAIL
 
 .byt TURN	;Turn in opposite direction
 
 .byt JUMP
 .byt lblLoop-DroidScript03
.)

