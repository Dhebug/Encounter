;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generated by OASIS compiler
; (c) Chema 2016
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Script 8
.(
.byt RESOURCE_SCRIPT
.word (res_end-res_start +4)
.byt 8
res_start
+script_8_start
.byt SC_LOAD_OBJECT
.byt 45
.byt SC_LOAD_OBJECT
.byt 46
.byt SC_LOAD_OBJECT
.byt 47
.byt SC_SET_OBJECT_POS
.byt 45
.byt SF_GET_CURROOM
.byt 16
.byt 27
.byt SC_SET_OBJECT_POS
.byt 47
.byt SF_GET_CURROOM
.byt 16
.byt 21
.byt SC_SET_OBJECT_POS
.byt 46
.byt SF_GET_CURROOM
.byt 16
.byt 12
.byt SC_LOOK_DIRECTION
.byt 45
.byt 1
.byt SC_LOOK_DIRECTION
.byt 46
.byt 1
.byt SC_LOOK_DIRECTION
.byt 47
.byt 1
.byt SC_ACTOR_WALKTO
.byt 45
.byt 13
.byt 16
.byt SC_ACTOR_WALKTO
.byt 46
.byt 3
.byt 16
.byt SC_ACTOR_WALKTO
.byt 47
.byt 8
.byt 16
.byt SC_WAIT_FOR_ACTOR
.byt 47
.byt SC_WAIT_FOR_ACTOR
.byt 46
.byt SC_WAIT_FOR_ACTOR
.byt 45
.byt SC_LOOK_DIRECTION
.byt 46
.byt 0
.byt SC_BREAK_HERE
.byt SC_ACTOR_TALK
.byt 46
.byt 64, 254
.byt 0
.byt SC_DELAY
.byt 64, 80
.byt SC_LOOK_DIRECTION
.byt 45
.byt 0
.byt SC_LOOK_DIRECTION
.byt 47
.byt 0
.byt SC_LOAD_OBJECT
.byt 64, 200
; while
.byt SC_JUMP_IF, SF_NOT
.byt SF_LT
.byt SF_GET_COL
.byt 64, 200
.byt 38
.word 107
.byt SC_DELAY
.byt 5
.byt SC_SET_ANIMSTATE
.byt 64, 200
.byt 1
.byt SC_DELAY
.byt 5
.byt SC_SET_ANIMSTATE
.byt 64, 200
.byt 0
.byt SC_SET_OBJECT_POS
.byt 64, 200
.byt SF_GET_CURROOM
.byt SF_ADD
.byt SF_GET_ROW
.byt 64, 200
.byt 1
.byt SF_ADD
.byt SF_GET_COL
.byt 64, 200
.byt 5
; end while
.byt SC_JUMP, 69, 0	; jump to 69
.byt SC_REMOVE_OBJECT
.byt 64, 200
.byt SC_WAIT_FOR_ACTOR
.byt 46
.byt SC_ACTOR_TALK
.byt 46
.byt 64, 254
.byt 1
.byt SC_DELAY
.byt 50
.byt SC_WAIT_FOR_ACTOR
.byt 46
.byt SC_ACTOR_TALK
.byt 46
.byt 64, 254
.byt 2
.byt SC_WAIT_FOR_ACTOR
.byt 46
.byt SC_ACTOR_TALK
.byt 46
.byt 64, 254
.byt 3
.byt SC_WAIT_FOR_ACTOR
.byt 46
.byt SC_DELAY
.byt 20
.byt SC_LOOK_DIRECTION
.byt 45
.byt 1
.byt SC_ACTOR_TALK
.byt 45
.byt 64, 254
.byt 4
.byt SC_WAIT_FOR_ACTOR
.byt 45
.byt SC_DELAY
.byt 20
.byt SC_ACTOR_TALK
.byt 45
.byt 64, 254
.byt 5
.byt SC_WAIT_FOR_ACTOR
.byt 45
.byt SC_DELAY
.byt 50
.byt SC_ACTOR_WALKTO
.byt 45
.byt 10
.byt 16
.byt SC_ACTOR_WALKTO
.byt 46
.byt 1
.byt 16
.byt SC_ACTOR_WALKTO
.byt 47
.byt 5
.byt 16
.byt SC_WAIT_FOR_ACTOR
.byt 47
.byt SC_STOP_SCRIPT
res_end
.)

; String pack 254
.(
.byt RESOURCE_STRING|$80
.word (res_end-res_start +4)
.byt 254
res_start
.asc "There...",0 ; String 0
.asc "There it is.",0 ; String 1
.asc "The Federation ship bringing in",0 ; String 2
.asc "prisoners.",0 ; String 3
.asc "Prisoners?",0 ; String 4
.asc "New souls for The Faith.",0 ; String 5
res_end
.)
