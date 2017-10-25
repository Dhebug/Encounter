;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generated by OASIS compiler
; (c) Chema 2016
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; String pack 20
.(
.byt RESOURCE_STRING
.word (res_end-res_start +4)
.byt 20
res_start
.asc "An exceptional woman...",0 ; String 0
.asc "I'm busy trying to understand these",0 ; String 1
.asc "alien controls. Gimme some more time.",0 ; String 2
.asc "She is in shock! I must hurry!",0 ; String 3
.asc "We must switch on the systems.",0 ; String 4
.asc "Any idea?",0 ; String 5
.asc "I'm with you.",0 ; String 6
.asc "Blake! I barely recognize you!",0 ; String 7
res_end
.)

; Object Code 20
.(
.byt RESOURCE_OBJECTCODE
.word (res_end-res_start +4)
.byt 20
res_start
; Response table
.byt VERB_LOOKAT
.word (l_LookAt-res_start)
.byt VERB_TALKTO
.word (l_TalkTo-res_start)
.byt $ff ; End of response table
l_LookAt
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_AND
.byt SF_NOT
.byt SF_GETFLAG,37	; bBallDefeated
.byt SF_EQ
.byt SF_GET_CURROOM
.byt 22
.byt 15
; then part
.byt SC_ACTOR_TALK
.byt 0
.byt 20
.byt 3
.byt SC_STOP_SCRIPT
.byt SC_ACTOR_TALK
.byt 0
.byt 20
.byt 0
.byt SC_STOP_SCRIPT
l_TalkTo
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_GETFLAG,39	; bCygnusOrbit
.byt 38
; then part
.byt SC_CURSOR_ON
.byt 0
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_NOT, SF_EQ
.byt SF_GET_COSTID
.byt 0
.byt 0
.byt 16
; then part
.byt SC_ACTOR_TALK
.byt 20
.byt 20
.byt 7
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_DELAY
.byt 30
.byt SC_ACTOR_TALK
.byt 20
.byt 20
.byt 1
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_ACTOR_TALK
.byt 20
.byt 20
.byt 2
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_CURSOR_ON
.byt 1
.byt SC_STOP_SCRIPT
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_EQ
.byt SF_GET_CURROOM
.byt 15
.byt 64, 120
; then part
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_GETFLAG,31	; bTimeToGetCard
.byt 64, 108
; then part
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_GETFLAG,32	; bCardTaken
.byt 6
; then part
.byt SC_STOP_SCRIPT
.byt SC_FREEZE_SCRIPT
.byt 64, 211
.byt 1
.byt SC_CURSOR_ON
.byt 0
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 221
.byt 7
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_ACTOR_TALK
.byt 20
.byt 64, 221
.byt 8
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_LOOK_DIRECTION
.byt 20
.byt 1
.byt SC_ACTOR_TALK
.byt 20
.byt 64, 221
.byt 9
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_ACTOR_TALK
.byt 20
.byt 64, 221
.byt 10
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_LOOK_DIRECTION
.byt 2
.byt 2
.byt SC_ACTOR_TALK
.byt 2
.byt 64, 221
.byt 11
.byt SC_WAIT_FOR_ACTOR
.byt 2
.byt SC_ACTOR_WALKTO
.byt 21
.byt 18
.byt 14
.byt SC_WAIT_FOR_ACTOR
.byt 21
.byt SC_ACTOR_TALK
.byt 2
.byt 64, 221
.byt 12
.byt SC_WAIT_FOR_ACTOR
.byt 2
.byt SC_ACTOR_WALKTO
.byt 21
.byt 18
.byt 13
.byt SC_WAIT_FOR_ACTOR
.byt 21
.byt SC_LOOK_DIRECTION
.byt 21
.byt 3
.byt SC_ACTOR_TALK
.byt 2
.byt 64, 221
.byt 13
.byt SC_WAIT_FOR_ACTOR
.byt 2
.byt SC_LOOK_DIRECTION
.byt 2
.byt 0
.byt SC_SET_ANIMSTATE
.byt 2
.byt 12
.byt SC_SETFLAG, 32	; bCardTaken=true
.byt 1
.byt SC_LOOK_DIRECTION
.byt 20
.byt 0
.byt SC_FREEZE_SCRIPT
.byt 64, 211
.byt 0
.byt SC_CURSOR_ON
.byt 1
.byt SC_JUMP_REL, 6
; else part
.byt SC_LOAD_DIALOG
.byt 64, 205
.byt SC_START_DIALOG
.byt SC_STOP_SCRIPT
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_EQ
.byt SF_GET_CURROOM
.byt 43
.byt 13
; then part
.byt SC_ACTOR_TALK
.byt 20
.byt 20
.byt 4
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_STOP_SCRIPT
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_AND
.byt SF_AND
.byt SF_EQ
.byt SF_GET_CURROOM
.byt 49
.byt SF_GETFLAG,64, 67	; bShiftTimeFound
.byt SF_NOT
.byt SF_GETFLAG,64, 68	; bClockTampered
.byt 18
; then part
.byt SC_SPAWN_SCRIPT
.byt 19
.byt SC_STOP_SCRIPT
.byt SC_ACTOR_TALK
.byt 20
.byt 20
.byt SF_GETRANDINT
.byt 5
.byt 6
.byt SC_STOP_SCRIPT
res_end
.)
