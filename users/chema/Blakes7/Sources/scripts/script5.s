;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generated by OASIS compiler
; (c) Chema 2016
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Script 5
.(
.byt RESOURCE_SCRIPT
.word (res_end-res_start +4)
.byt 5
res_start
+script_5_start
.byt SC_SHOW_VERBS
.byt 0
.byt SC_LOCK_RESOURCE
.byt 4
.byt 64, 104
; for
; Init part
.byt SC_ASSIGN, 64, 200	; i=0
.byt 0
; Condition
.byt SC_JUMP_IF, SF_NOT
.byt SF_LT
.byt SF_GETVAL,64, 200	; i
.byt 3
.word 39
; for body
.byt SC_ACTOR_TALK
.byt 20
.byt 64, 104
.byt SF_GETVAL,64, 200	; i
.byt SC_WAIT_FOR_ACTOR
.byt 20
; Increment expression
.byt SC_ASSIGN, 64, 200	; i=i+1
.byt SF_ADD
.byt SF_GETVAL,64, 200	; i
.byt 1
; end for
.byt SC_JUMP, 10, 0	; jump to 10
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 104
.byt 3
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 104
.byt 4
.byt SC_WAIT_FOR_ACTOR
.byt 22
; for
; Init part
.byt SC_ASSIGN, 64, 200	; i=5
.byt 5
; Condition
.byt SC_JUMP_IF, SF_NOT
.byt SF_LE
.byt SF_GETVAL,64, 200	; i
.byt 8
.word 86
; for body
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt SF_GETVAL,64, 200	; i
.byt SC_WAIT_FOR_ACTOR
.byt 0
; Increment expression
.byt SC_ASSIGN, 64, 200	; i=i+1
.byt SF_ADD
.byt SF_GETVAL,64, 200	; i
.byt 1
; end for
.byt SC_JUMP, 57, 0	; jump to 57
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 104
.byt 9
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_EXECUTE_ACTION
.byt 22
.byt 9
.byt 64, 204
.byt 64, 255
.byt SC_EXECUTE_ACTION
.byt 20
.byt 9
.byt 64, 203
.byt 64, 255
.byt SC_ACTOR_WALKTO
.byt 0
.byt 22
.byt 14
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_LOOK_DIRECTION
.byt 0
.byt 1
.byt SC_DELAY
.byt 64, 150
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 104
.byt 10
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 104
.byt 11
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_WAIT_FOR_ACTOR
.byt 20
; for
; Init part
.byt SC_ASSIGN, 64, 200	; i=12
.byt 12
; Condition
.byt SC_JUMP_IF, SF_NOT
.byt SF_LE
.byt SF_GETVAL,64, 200	; i
.byt 15
.word 170
; for body
.byt SC_ACTOR_TALK
.byt 20
.byt 64, 104
.byt SF_GETVAL,64, 200	; i
.byt SC_WAIT_FOR_ACTOR
.byt 20
; Increment expression
.byt SC_ASSIGN, 64, 200	; i=i+1
.byt SF_ADD
.byt SF_GETVAL,64, 200	; i
.byt 1
; end for
.byt SC_JUMP, 141, 0	; jump to 141
.byt SC_PRINT
.byt 64, 104
.byt 16
.byt SC_CHAIN_SCRIPT
.byt 64, 203
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt 17
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_ACTOR_WALKTO
.byt 0
.byt 34
.byt 14
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_PRINT
.byt 64, 104
.byt 18
.byt SC_CHAIN_SCRIPT
.byt 64, 203
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 104
.byt 19
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_PRINT
.byt 64, 104
.byt 20
.byt SC_CHAIN_SCRIPT
.byt 64, 203
.byt SC_PRINT
.byt 64, 104
.byt 21
.byt SC_CHAIN_SCRIPT
.byt 64, 203
.byt SC_PRINT
.byt 64, 104
.byt 22
.byt SC_CHAIN_SCRIPT
.byt 64, 203
.byt SC_ACTOR_TALK
.byt 20
.byt 64, 104
.byt 23
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_ACTOR_TALK
.byt 20
.byt 64, 104
.byt 24
.byt SC_WAIT_FOR_ACTOR
.byt 20
; for
; Init part
.byt SC_ASSIGN, 64, 200	; i=25
.byt 25
; Condition
.byt SC_JUMP_IF, SF_NOT
.byt SF_LE
.byt SF_GETVAL,64, 200	; i
.byt 27
.word 272
; for body
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt SF_GETVAL,64, 200	; i
.byt SC_WAIT_FOR_ACTOR
.byt 0
; Increment expression
.byt SC_ASSIGN, 64, 200	; i=i+1
.byt SF_ADD
.byt SF_GETVAL,64, 200	; i
.byt 1
; end for
.byt SC_JUMP, 243, 0	; jump to 243
.byt SC_PRINT
.byt 64, 104
.byt 28
.byt SC_CHAIN_SCRIPT
.byt 64, 203
.byt SC_LOAD_ROOM
.byt 18
l_lw
.byt SC_BREAK_HERE
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_EQ
.byt SF_GET_CURROOM
.byt 18
.byt 9
; then part
.byt SC_JUMP
.word (l_lw-res_start)
.byt SC_ACTOR_TALK
.byt 20
.byt 64, 104
.byt 29
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_ACTOR_TALK
.byt 20
.byt 64, 104
.byt 30
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_LOOK_DIRECTION
.byt 0
.byt 1
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt 31
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt 32
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 104
.byt 33
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt 34
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt 35
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 104
.byt 36
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_ACTOR_TALK
.byt 20
.byt 64, 104
.byt 37
.byt SC_WAIT_FOR_ACTOR
.byt 20
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 104
.byt 38
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_ACTOR_TALK
.byt 22
.byt 64, 104
.byt 39
.byt SC_WAIT_FOR_ACTOR
.byt 22
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt 40
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_LOOK_DIRECTION
.byt 0
.byt 0
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt 41
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_LOOK_DIRECTION
.byt 0
.byt 0
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt 42
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_PRINT
.byt 64, 104
.byt 28
.byt SC_CHAIN_SCRIPT
.byt 64, 203
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt 43
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_ACTOR_TALK
.byt 0
.byt 64, 104
.byt 44
.byt SC_WAIT_FOR_ACTOR
.byt 0
.byt SC_PLAYSFX
.byt 6
.byt SC_WAIT_FOR_TUNE
.byt SC_ASSIGN, 64, 200	; i=sfGetFadeEffect()
.byt SF_GET_FADEEFFECT
.byt SC_SET_FADEEFFECT
.byt 64, 130
.byt SC_LOAD_ROOM
.byt 30
.byt SC_CHAIN_SCRIPT
.byt 8
.byt SC_SET_OBJECT_POS
.byt 22
.byt 24
.byt 15
.byt 32
.byt SC_LOOK_DIRECTION
.byt 22
.byt 1
.byt SC_LOAD_ROOM
.byt 22
.byt SC_SET_CAMERA_AT
.byt 40
.byt SC_SET_FADEEFFECT
.byt SF_GETVAL,64, 200	; i
.byt SC_BREAK_HERE
.byt SC_SET_OBJECT_POS
.byt 45
.byt 0
.byt 16
.byt 27
.byt SC_SET_OBJECT_POS
.byt 47
.byt 0
.byt 16
.byt 21
.byt SC_SET_OBJECT_POS
.byt 46
.byt 0
.byt 16
.byt 12
.byt SC_PRINT
.byt 64, 104
.byt 45
.byt SC_CHAIN_SCRIPT
.byt 64, 203
.byt SC_PRINT
.byt 64, 104
.byt 46
.byt SC_CHAIN_SCRIPT
.byt 64, 203
.byt SC_UNLOCK_RESOURCE
.byt 4
.byt 64, 104
.byt SC_REMOVE_FROM_INVENTORY
.byt 34
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_IS_OBJINVENTORY
.byt 39
.byt 7
; then part
.byt SC_REMOVE_FROM_INVENTORY
.byt 39
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_IS_OBJINVENTORY
.byt 40
.byt 7
; then part
.byt SC_REMOVE_FROM_INVENTORY
.byt 40
; if
.byt SC_JUMP_REL_IF, SF_NOT
.byt SF_IS_OBJINVENTORY
.byt 38
.byt 7
; then part
.byt SC_REMOVE_FROM_INVENTORY
.byt 38
.byt SC_SETFLAG, 39	; bCygnusOrbit=true
.byt 1
.byt SC_SHOW_VERBS
.byt 1
.byt SC_CURSOR_ON
.byt 1
.byt SC_SAVEGAME
.byt SC_STOP_SCRIPT
res_end
.)

; String pack 104
.(
.byt RESOURCE_STRING
.word (res_end-res_start +4)
.byt 104
res_start
.asc "What happened?",0 ; String 0
.asc "I saw my mother.",0 ; String 1
.asc "She was leaving me... again.",0 ; String 2
.asc "And I saw my brother about to die,",0 ; String 3
.asc "and I couldn't do anything.",0 ; String 4
.asc "That... thing... was using your",0 ; String 5
.asc "minds and memories against you.",0 ; String 6
.asc "I guess it failed with me, as I had",0 ; String 7
.asc "my memories erased by the Federation.",0 ; String 8
.asc "Let's examine the ship...",0 ; String 9
.asc "Okay. I have powered on the basic",0 ; String 10
.asc "systems of the ship.",0 ; String 11
.asc "These controls are strange...",0 ; String 12
.asc "Let me try....",0 ; String 13
.asc "AAAAAAHHH!",0 ; String 14
.asc "She's got into my mind! Stop it!",0 ; String 15
.asc " Welcome Jenna Stannis.",0 ; String 16
.asc "Who is it?",0 ; String 17
.asc " Zen. Welcome Roj Blake.",0 ; String 18
.asc "You're a computer.",0 ; String 19
.asc " As you say, Kerr Avon.",0 ; String 20
.asc " The Liberator is ready.",0 ; String 21
.asc " Set speed and course.",0 ; String 22
.asc "The Liberator...",0 ; String 23
.asc "Yes, that name came to my mind.",0 ; String 24
.asc "Zen, close the entry hatch and",0 ; String 25
.asc "manoeuvre the ship away from",0 ; String 26
.asc "the London's sensor range.",0 ; String 27
.asc " Confirmed...",0 ; String 28
.asc "We're free. We've got a ship.",0 ; String 29
.asc "We can go anywhere we like.",0 ; String 30
.asc "We will go to Cygnus Alpha.",0 ; String 31
.asc "We'll free the rest of the group.",0 ; String 32
.asc "WHAT!?",0 ; String 33
.asc "With this ship and a full crew, then",0 ; String 34
.asc "we CAN start fighting back!",0 ; String 35
.asc "You can't be serious...",0 ; String 36
.asc "What's the alternative?",0 ; String 37
.asc "Leave. I'm free.",0 ; String 38
.asc "And I intend to stay that way.",0 ; String 39
.asc "And I need a crew.",0 ; String 40
.asc "Zen. Set course to Cygnus Alpha.",0 ; String 41
.asc "Speed standard.",0 ; String 42
.asc "Oh, I'd better put this pipe back",0 ; String 43
.asc "in its place.",0 ; String 44
.asc " The Liberator is in stationary",0 ; String 45
.asc " orbit over planet Cygnus Alpha.",0 ; String 46
res_end
.)
