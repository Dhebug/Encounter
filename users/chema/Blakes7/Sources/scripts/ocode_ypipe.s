;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generated by OASIS compiler
; (c) Chema 2016
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; String pack 31
.(
.byt RESOURCE_STRING
.word (res_end-res_start +4)
.byt 31
res_start
.asc "A Y-pipe. I am not sure I should have",0 ; String 0
.asc "removed it from its place.",0 ; String 1
.asc "I think I got your idea... Nice!",0 ; String 2
.asc "I don't know what you want to do.",0 ; String 3
res_end
.)

; Object Code 31
.(
.byt RESOURCE_OBJECTCODE
.word (res_end-res_start +4)
.byt 31
res_start
; Response table
.byt VERB_LOOKAT
.word (l_LookAt-res_start)
.byt VERB_USE
.word (l_Use-res_start)
.byt $ff ; End of response table
l_LookAt
.byt SC_CURSOR_ON
.byt 0
.byt SC_ACTOR_TALK
.byt 0
.byt 31
.byt 0
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_ACTOR_TALK
.byt 0
.byt 31
.byt 1
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_CURSOR_ON
.byt 1
.byt SC_STOP_SCRIPT
l_Use
.byt SC_CURSOR_ON
.byt 0
.byt SC_LOOK_DIRECTION
.byt 0
.byt 3
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_EQ
.byt SF_GET_ACTIONOBJ1
.byt 33
.byt 21
; then part
.byt SC_ACTOR_TALK
.byt 0
.byt 31
.byt 2
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_REMOVE_FROM_INVENTORY
.byt 33
.byt SC_REMOVE_FROM_INVENTORY
.byt 31
.byt SC_PUT_IN_INVENTORY
.byt 34
.byt SC_SAVEGAME
.byt SC_JUMP_REL, 8
; else part
.byt SC_ACTOR_TALK
.byt 0
.byt 31
.byt 3
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_CURSOR_ON
.byt 1
.byt SC_STOP_SCRIPT
res_end
.)
