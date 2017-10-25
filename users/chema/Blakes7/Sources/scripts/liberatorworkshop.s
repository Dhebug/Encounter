;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generated by OASIS compiler
; (c) Chema 2016
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; String pack 200
.(
.byt RESOURCE_STRING|$80
.word (res_end-res_start +4)
.byt 200
res_start
.asc "An apparently normal sink.",0 ; String 0
.asc "I wonder if the water is drinkable.",0 ; String 1
.asc "Ahhh... refreshing...",0 ; String 2
.asc "The water drains very slowly.",0 ; String 3
.asc "Something must be clogging the drain.",0 ; String 4
.asc "Yes... there is something here...",0 ; String 5
.asc "Why would I do that?",0 ; String 6
.asc "I can't unclog it with this.",0 ; String 7
.asc "I've no idea what this is for.",0 ; String 8
.asc "A bit risky, but let's do it...",0 ; String 9
.asc "Better leave it alone.",0 ; String 10
.asc "It seems some kind of repair station.",0 ; String 11
.asc "Full of electronic equipment.",0 ; String 12
.asc "That is beyond my abilities.",0 ; String 13
.asc "Let's see what I can do...",0 ; String 14
.asc "I can't use the station with this.",0 ; String 15
.asc "I can attach this transmitter to any",0 ; String 16
.asc "circuit to activate the relay remotely.",0 ; String 17
.asc "The relay can be attached anywhere.",0 ; String 18
res_end
.)

; Script 200
.(
.byt RESOURCE_SCRIPT|$80
.word (res_end-res_start +4)
.byt 200
res_start
+script_200_start
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_OR
.byt SF_IS_OBJINVENTORY
.byt 31
.byt SF_IS_OBJINVENTORY
.byt 34
.byt 11
; then part
.byt SC_LOAD_OBJECT
.byt 64, 250
.byt SC_STOP_SCRIPT
res_end
.)

; Object Code 202
.(
.byt RESOURCE_OBJECTCODE|$80
.word (res_end-res_start +4)
.byt 202
res_start
; Response table
.byt VERB_LOOKAT
.word (l_LookAt-res_start)
.byt VERB_USE
.word (l_Use-res_start)
.byt $ff ; End of response table
l_LookAt
.byt SC_ACTOR_TALK
.byt SF_GET_ACTIONACTOR
.byt 64, 200
.byt 8
.byt SC_WAIT_FOR_ACTOR
.byt SF_GET_ACTIONACTOR
.byt SC_STOP_SCRIPT
l_Use
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_AND
.byt SF_AND
.byt SF_NOT
.byt SF_IS_OBJINVENTORY
.byt 31
.byt SF_NOT
.byt SF_GETFLAG,37	; bBallDefeated
.byt SF_EQ
.byt SF_GET_ACTIONOBJ1
.byt 40
.byt 29
; then part
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 200
.byt 9
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_PUT_IN_INVENTORY
.byt 31
.byt SC_LOAD_OBJECT
.byt 64, 250
.byt SC_SAVEGAME
.byt SC_JUMP_REL, 9
; else part
.byt SC_ACTOR_TALK
.byt SF_GET_ACTIONACTOR
.byt 64, 200
.byt 10
.byt SC_WAIT_FOR_ACTOR
.byt SF_GET_ACTIONACTOR
.byt SC_STOP_SCRIPT
res_end
.)

; Object Code 200
.(
.byt RESOURCE_OBJECTCODE|$80
.word (res_end-res_start +4)
.byt 200
res_start
; Response table
.byt VERB_OPEN
.word (l_Open-res_start)
.byt VERB_USE
.word (l_Use-res_start)
.byt VERB_LOOKAT
.word (l_LookAt-res_start)
.byt $ff ; End of response table
l_Open
l_Use
.byt SC_ASSIGN, 64, 200	; a=sfGetActorExecutingAction()
.byt SF_GET_ACTIONACTOR
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_AND
.byt SF_AND
.byt SF_EQ
.byt SF_GET_ACTIONOBJ1
.byt 39
.byt SF_GETFLAG,35	; bCloggingSeen
.byt SF_NOT
.byt SF_GETFLAG,36	; bDrainUnclogged
.byt 31
; then part
.byt SC_ACTOR_TALK
.byt SF_GETVAL,64, 200	; a
.byt 64, 200
.byt 5
.byt SC_WAIT_FOR_ACTOR
.byt SF_GETVAL,64, 200	; a
.byt SC_PUT_IN_INVENTORY
.byt 32
.byt SC_SETFLAG, 36	; bDrainUnclogged=true
.byt 1
.byt SC_SAVEGAME
.byt SC_STOP_SCRIPT
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_NOT, SF_EQ
.byt SF_GET_ACTIONOBJ1
.byt 64, 200
.byt 38
; then part
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_AND
.byt SF_GETFLAG,35	; bCloggingSeen
.byt SF_NOT
.byt SF_GETFLAG,36	; bDrainUnclogged
.byt 18
; then part
.byt SC_ACTOR_TALK
.byt SF_GETVAL,64, 200	; a
.byt 64, 200
.byt 7
.byt SC_JUMP_REL, 9
; else part
.byt SC_ACTOR_TALK
.byt SF_GETVAL,64, 200	; a
.byt 64, 200
.byt 6
.byt SC_WAIT_FOR_ACTOR
.byt SF_GETVAL,64, 200	; a
.byt SC_STOP_SCRIPT
.byt SC_ACTOR_TALK
.byt SF_GETVAL,64, 200	; a
.byt 64, 200
.byt 2
.byt SC_WAIT_FOR_ACTOR
.byt SF_GETVAL,64, 200	; a
.byt SC_SETFLAG, 34	; bSinkUsed=true
.byt 1
.byt SC_SAVEGAME
.byt SC_STOP_SCRIPT
l_LookAt
.byt SC_ASSIGN, 64, 200	; a=sfGetActorExecutingAction()
.byt SF_GET_ACTIONACTOR
.byt SC_CURSOR_ON
.byt 0
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_AND
.byt SF_GETFLAG,34	; bSinkUsed
.byt SF_NOT
.byt SF_GETFLAG,36	; bDrainUnclogged
.byt 32
; then part
.byt SC_ACTOR_TALK
.byt SF_GETVAL,64, 200	; a
.byt 64, 200
.byt 3
.byt SC_WAIT_FOR_ACTOR
.byt SF_GETVAL,64, 200	; a
.byt SC_ACTOR_TALK
.byt SF_GETVAL,64, 200	; a
.byt 64, 200
.byt 4
.byt SC_SETFLAG, 35	; bCloggingSeen=true
.byt 1
.byt SC_JUMP_REL, 20
; else part
.byt SC_ACTOR_TALK
.byt SF_GETVAL,64, 200	; a
.byt 64, 200
.byt 0
.byt SC_WAIT_FOR_ACTOR
.byt SF_GETVAL,64, 200	; a
.byt SC_ACTOR_TALK
.byt SF_GETVAL,64, 200	; a
.byt 64, 200
.byt 1
.byt SC_WAIT_FOR_ACTOR
.byt SF_GETVAL,64, 200	; a
.byt SC_CURSOR_ON
.byt 1
.byt SC_STOP_SCRIPT
.byt SC_STOP_SCRIPT
res_end
.)

; Object Code 201
.(
.byt RESOURCE_OBJECTCODE|$80
.word (res_end-res_start +4)
.byt 201
res_start
; Response table
.byt VERB_USE
.word (l_Use-res_start)
.byt VERB_WALKTO
.word (l_WalkTo-res_start)
.byt $ff ; End of response table
l_Use
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_NOT, SF_EQ
.byt SF_GET_ACTIONOBJ2
.byt 64, 255
.byt 11
; then part
.byt SC_SPAWN_SCRIPT
.byt 1
.byt SC_STOP_SCRIPT
l_WalkTo
.byt SC_SET_OBJECT_POS
.byt SF_GET_ACTIONACTOR
.byt 20
.byt 15
.byt 0
.byt SC_LOOK_DIRECTION
.byt SF_GET_ACTIONACTOR
.byt 0
.byt SC_CHANGE_ROOM_AND_STOP
.byt 20
.byt SC_STOP_SCRIPT
res_end
.)

; Object Code 203
.(
.byt RESOURCE_OBJECTCODE|$80
.word (res_end-res_start +4)
.byt 203
res_start
; Response table
.byt VERB_LOOKAT
.word (l_LookAt-res_start)
.byt VERB_USE
.word (l_Use-res_start)
.byt $ff ; End of response table
l_LookAt
.byt SC_ASSIGN, 64, 200	; a=sfGetActorExecutingAction()
.byt SF_GET_ACTIONACTOR
.byt SC_CURSOR_ON
.byt 0
.byt SC_ACTOR_TALK
.byt SF_GETVAL,64, 200	; a
.byt 64, 200
.byt 11
.byt SC_WAIT_FOR_ACTOR
.byt SF_GETVAL,64, 200	; a
.byt SC_ACTOR_TALK
.byt SF_GETVAL,64, 200	; a
.byt 64, 200
.byt 12
.byt SC_WAIT_FOR_ACTOR
.byt SF_GETVAL,64, 200	; a
.byt SC_CURSOR_ON
.byt 1
.byt SC_STOP_SCRIPT
l_Use
.byt SC_ASSIGN, 64, 200	; a=sfGetActorExecutingAction()
.byt SF_GET_ACTIONACTOR
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_EQ
.byt SF_GETVAL,64, 200	; a
.byt 0
.byt 16
; then part
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 200
.byt 13
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_STOP_SCRIPT
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_EQ
.byt SF_GET_ACTIONOBJ1
.byt 28
.byt 55
; then part
.byt SC_CURSOR_ON
.byt 0
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 200
.byt 14
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_DELAY
.byt 40
.byt SC_REMOVE_FROM_INVENTORY
.byt 28
.byt SC_PUT_IN_INVENTORY
.byt 29
.byt SC_PUT_IN_INVENTORY
.byt 30
.byt SC_WAIT_FOR_TUNE
.byt SC_PLAYSFX
.byt 6
.byt SC_WAIT_FOR_TUNE
.byt SC_LOOK_DIRECTION
.byt 22
.byt 3
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 200
.byt 16
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 200
.byt 17
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 200
.byt 18
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_CURSOR_ON
.byt 1
.byt SC_SAVEGAME
.byt SC_STOP_SCRIPT
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 200
.byt 15
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_STOP_SCRIPT
res_end
.)
