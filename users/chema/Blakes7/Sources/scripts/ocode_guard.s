;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generated by OASIS compiler
; (c) Chema 2016
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; String pack 2
.(
.byt RESOURCE_STRING
.word (res_end-res_start +4)
.byt 2
res_start
.asc "Quite menacing...",0 ; String 0
.asc "You must be kidding...",0 ; String 1
.asc "Move along, move along...",0 ; String 2
.asc "He seems to be asleep...",0 ; String 3
.asc "He's busy. Better leave him alone.",0 ; String 4
res_end
.)

; Object Code 2
.(
.byt RESOURCE_OBJECTCODE
.word (res_end-res_start +4)
.byt 2
res_start
; Response table
.byt VERB_LOOKAT
.word (l_LookAt-res_start)
.byt VERB_TALKTO
.word (l_TalkTo-res_start)
.byt VERB_PUSH
.word (l_Push-res_start)
.byt VERB_PULL
.word (l_Pull-res_start)
.byt VERB_USE
.word (l_Use-res_start)
.byt $ff ; End of response table
l_LookAt
.byt SC_ASSIGN, 64, 200	; string=0
.byt 0
.byt SC_JUMP
.word (l_sayit-res_start)
l_TalkTo
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_EQ
.byt SF_GET_CURROOM
.byt 10
.byt 13
; then part
.byt SC_ASSIGN, 64, 200	; string=3
.byt 3
.byt SC_JUMP
.word (l_sayit-res_start)
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_EQ
.byt SF_GET_CURROOM
.byt 51
.byt 13
; then part
.byt SC_ASSIGN, 64, 200	; string=4
.byt 4
.byt SC_JUMP
.word (l_sayit-res_start)
.byt SC_ACTOR_TALK
.byt 2
.byt 2
.byt 2
.byt SC_WAIT_FOR_ACTOR
.byt 2
.byt SC_STOP_SCRIPT
l_Push
l_Pull
.byt SC_ASSIGN, 64, 200	; string=1
.byt 1
.byt SC_JUMP
.word (l_sayit-res_start)
l_Use
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_AND
.byt SF_EQ
.byt SF_GET_CURROOM
.byt 51
.byt SF_EQ
.byt SF_GET_ACTIONOBJ1
.byt 49
.byt 14
; then part
.byt SC_SPAWN_SCRIPT
.byt 64, 202
.byt SC_STOP_SCRIPT
.byt SC_STOP_SCRIPT
l_sayit
.byt SC_ACTOR_TALK
.byt 0
.byt 2
.byt SF_GETVAL,64, 200	; string
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_STOP_SCRIPT
.byt SC_STOP_SCRIPT
res_end
.)
