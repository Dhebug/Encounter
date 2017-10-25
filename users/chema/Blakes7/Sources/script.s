/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

;; Script engine

#include "script.h"
#include "params.h"



; Script command table
commands_lo 	.byt <scStopScript, <scRestartScript, <scWaitEvent, <scActorWalkTo, <scActorTalk, <scWaitForActor, <scDelay, <scFollowActor
		.byt <scSetObjectAnimState, <scPanCamera, <scWaitForCamera, <scLoadRoom, <scSetEgo, <scBreakHere, <scSetObjectPosition, <scChangeRoomAndStop
		.byt <scAssign, <scSetFlag, <scExecuteAction, <scJumpRel, <scJumpRelIf, <scChainScript, <scSpawnScript
		.byt <scSetEvents, <scClearEvents, <scRunObjectCode,<scSetCameraAt,<scSetFadeEffect
		.byt <scCursorOn, <scLookDirection, <scSetState, <scSetCostume, <scDisableVerb
		.byt <scSetWalkboxAsWalkable, <scSetNextWalkbox, <scPlayTune, <scWaitForTune, <scStopTune	
		.byt <scShowVerbs, <scPrint, <scPrintAt, <scRedrawScreen
		.byt <scPutInInventory, <scRemoveFromInventory
		.byt <scLoadResource, <scNukeResource, <scLockResource, <scUnlockResource
		.byt <scLoadObjectToGame, <scRemoveObjectFromGame
		.byt <scSetOverrideJump, <scClearRoomArea, <scJump, <scJumpIf
		.byt <scStartDialog, <scEndDialog,<scLoadDialog, <scActivateDlgOption
		.byt <scFreezeScript, <scFreezeAllScripts, <scTerminateScript
		.byt <scFadeToBlack
		.byt <scPlaySFX
		.byt <scStopCharacter
		.byt <scLoad, <scSave, <scMenu
		.byt <scSetBWPalette, <scSetRoomPalette
		.byt <scStopSFX
		.byt <scClearInventory

commands_hi 	.byt >scStopScript, >scRestartScript, >scWaitEvent, >scActorWalkTo, >scActorTalk, >scWaitForActor, >scDelay, >scFollowActor
		.byt >scSetObjectAnimState, >scPanCamera, >scWaitForCamera, >scLoadRoom, >scSetEgo, >scBreakHere, >scSetObjectPosition, >scChangeRoomAndStop
		.byt >scAssign, >scSetFlag, >scExecuteAction, >scJumpRel, >scJumpRelIf, >scChainScript, >scSpawnScript
		.byt >scSetEvents, >scClearEvents, >scRunObjectCode, >scSetCameraAt,>scSetFadeEffect
		.byt >scCursorOn, >scLookDirection, >scSetState, >scSetCostume, >scDisableVerb
		.byt >scSetWalkboxAsWalkable, >scSetNextWalkbox, >scPlayTune, >scWaitForTune, >scStopTune
		.byt >scShowVerbs, >scPrint, >scPrintAt, >scRedrawScreen
		.byt >scPutInInventory, >scRemoveFromInventory
		.byt >scLoadResource, >scNukeResource, >scLockResource, >scUnlockResource
		.byt >scLoadObjectToGame, >scRemoveObjectFromGame	
		.byt >scSetOverrideJump,>scClearRoomArea, >scJump, >scJumpIf
		.byt >scStartDialog, >scEndDialog, >scLoadDialog, >scActivateDlgOption
		.byt >scFreezeScript, >scFreezeAllScripts, >scTerminateScript	
		.byt >scFadeToBlack		
		.byt >scPlaySFX
		.byt >scStopCharacter
		.byt >scLoad, >scSave, >scMenu
		.byt >scSetBWPalette, >scSetRoomPalette
		.byt >scStopSFX
		.byt >scClearInventory
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Advances current offset a number of
; bytes passed in reg Y.
; Reg X contains the thread id
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AdvanceOffset
.(
	ldx _CurrentThread
	pha
	tya
	clc
	adc thread_offset_lo,x
	sta thread_offset_lo,x
	bcc end
	inc thread_offset_hi,x
end
	pla
	ldy #0
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Change Room and Stop
; META: Currently a HACK!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scChangeRoomAndStop
.(
	ldy #1
	lda (tmp0),y	; Grab parameter room number
	pha
	jsr PurgeScript	
	pla
	tax
	jsr LoadNewRoom
	ldx CurrentEgoEntry	
	lda pos_col,x
	jsr SetCameraCol
	pla
	pla
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Break script (schedule it)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scBreakHere
.(
	ldy #1
	jsr AdvanceOffset
	jmp ScheduleScript
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Re-start current script code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scRestartScript
.(
	lda #0
	sta thread_offset_lo,x
	sta thread_offset_hi,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Stop current script (de-schedules it)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scStopScript
	jsr PurgeScript
ScheduleScript
	; schedule script
	pla
	pla
	rts

; Helper for getting param object and its 
; entry in array, with possible exceptions
; calls error_obj which is defined in functions.s
getObject1stParam
	jsr scriptEvaluateNext
getObjectParam
.(
	jsr getObjectEntry
	cpx #$ff
	bne cont
	jmp error_obj
cont
	rts
.)	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Wait for actor to finish its
; command.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scWaitForActor
.(
	jsr getObject1stParam
	lda command_high,x
	beq finished
	jmp ScheduleScript
finished
	jmp AdvanceOffset
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Delay script a number of ticks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scDelay
.(
	jsr scriptEvaluateNext
	sta thread_timeout,x
	lda #TH_STATE_DELAYED
	sta thread_state,x
	jsr AdvanceOffset
	jmp ScheduleScript
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Instruct camera to follow 
; an actor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scFollowActor
.(
	; Can't call this, as it generates an
	; error for 255 (none to follow)
	;jsr getObject1stParam
	jsr scriptEvaluateNext
	tax
	cpx #$ff	; Follow nobody
	beq skip
	jsr getObjectParam
skip	
	stx actor_following	
	jmp AdvanceOffset
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pan the camera to a position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scPanCamera
.(
	jsr scriptEvaluateNext
	sta var_camera
	lda #>PanCamera
	sta camera_command_hi
	lda #<PanCamera
	sta camera_command_lo
	jmp AdvanceOffset
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the camera column
; Additional entry point to be
; called from the engine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scSetCameraAt
.(
	jsr scriptEvaluateNext
	jsr AdvanceOffset
+SetCameraCol
	sec
	sbc #(VISIBLE_COLS>>1)
	; META: CHECK THIS- I changed because long rooms never started at column 00
	; but it may have lateral unwanted effects!
	;bmi corr1
	bpl ok1
	;cmp #FIRST_VIS_COL
	;bcs ok1
corr1	
	lda #$ff ;FIRST_VIS_COL
	bne end ; Jumps always
ok1
	pha
	lda nRoomCols
	sec
	sbc #(VISIBLE_COLS+FIRST_VIS_COL)
	sta tmp
	pla
	cmp tmp ;#LAST_VIS_COL
	bcc end
	
	;lda nRoomCols
	; No need for sec, as Carry is Set here.
	;sbc #(VISIBLE_COLS+FIRST_VIS_COL)
	lda tmp
end	
	; Make sure we do not get too far left...
	pha
	clc
	adc #VISIBLE_COLS
	sec
	sbc nRoomCols
	bcc doit
	sta tmp
	pla
	; Leave carry clear to subtract one more
	clc
	sbc tmp
	jmp doit2 
doit
	pla
doit2	
	sta first_col
/*	
	; META: Shall we use the fading or not?
	stx savx+1
	jsr RedrawAllScreen
savx
	ldx #0
*/
	inc RoomChanged ; Using only this will use current fading effect
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set current fade effect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scSetFadeEffect
	jsr scriptEvaluateNext
	sta CurrentFadeEffect
	jmp AdvanceOffset	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set or clear cursor and UI
; (except ESC key)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scCursorOn
.(
	jsr scriptEvaluateNext
	jsr AdvanceOffset
	cmp #0
	beq setoff
	jmp SetMouseOn
setoff
	jmp SetMouseOff
.)
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set script in TH_STATE_WAITING mode
; and its event flags at the value
; passed by parameter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scWaitEvent
.(
	lda #TH_STATE_WAITING
	sta thread_state,x
	jsr scriptEvaluateNext
	sta thread_event_mask,x		
	jsr AdvanceOffset
	jmp ScheduleScript
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sets object Animstate
;;;;;;;;;;;;;;;;;;;;;;;;;;;
scSetObjectAnimState
.(
	jsr getObject1stParam
	stx eobject+1
	jsr scriptEvaluate
	jsr AdvanceOffset
eobject
	ldx #0
	jmp UpdateAnimstate
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Makes an actor look to a
; given direction:
; FACING_RIGHT, FACING_LEFT
; FACING_UP, FACING_DOWN,
; as in object.h
;;;;;;;;;;;;;;;;;;;;;;;;;;;
scLookDirection
.(
	jsr getObject1stParam
	stx sav+1
	jsr scriptEvaluate
	jsr AdvanceOffset 
sav 
	ldx #0
	jmp LookDirection
.)


;;;;;;;;;;;;;;;;;;;;;;;
; Object state
;;;;;;;;;;;;;;;;;;;;;;;

scSetState
.(
	ldy #1
	jsr setCurObjandInventoryVals
	php
	jsr scriptEvaluate
	sty savy+1
	;and #%00000011
	sta tmp
	plp
	beq inarray
	lda inventory_flags,x
	and #%11111100
	ora tmp
	sta inventory_flags,x	
inarray	
	lda flags,x
	and #%11111100
	ora tmp
	sta flags,x
savy
	ldy #0
	jmp AdvanceOffset
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sets the costume for an
; object.
; Params: object, cosid, cosno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Calls AssignCostume which, in turn, needs
; Needs COSTUME resource ID (X), number of 
; costume inside resource (Y), and actor ID (A)
scSetCostume
.(
	jsr scriptEvaluateNext
	sta actor+1
	jsr scriptEvaluate
	sta cos+1
	jsr scriptEvaluate
	sta oentry+1
	jsr AdvanceOffset	
oentry
	ldy #0
cos
	ldx #0
actor
	lda #0
	jmp AssignCostume
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load Room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scLoadRoom
.(
	jsr scriptEvaluateNext ; Grab parameter room number
	jsr AdvanceOffset
	
	; If the room to load is local, do
	; a normal loading...
	cmp #RESOURCE_LOCALS_START
	bcs normal

	; If the script is local, we have to purge it and stop
	ldx _CurrentThread
	ldy thread_script_id,x
	cpy #LOCALS_START
	bcc normal
	pha
	jsr PurgeScript	
	pla
	tax
	jsr LoadNewRoom
	pla
	pla
	rts	
normal	
	tax
	jmp LoadNewRoom
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set Ego
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scSetEgo
.(
	jsr scriptEvaluateNext
	jsr AdvanceOffset	
	jmp SetEgo
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Waits for Camera command to stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scWaitForCamera
.(
	lda camera_command_hi
	beq finished
	jmp ScheduleScript
finished
	ldy #1
	jmp AdvanceOffset
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Assignment
;;;;;;;;;;;;;;;;;;;;;;;;;;
scAssign
.(
	jsr scriptEvaluateNext
	sta varp+1
	jsr scriptEvaluate
	jsr AdvanceOffset
varp	
	ldy #0
	; If local, use local storage!
	cpy #LOCALS_START
	bcs local
	sta _VARS,y
	rts
local
	sta (lvarp),y
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set/clear flags
;;;;;;;;;;;;;;;;;;;;;;;;;;
; META: This code is a mess!!!!

;tVarp .byt 00
;tMask .byt 00

#define tVarp op1
#define tMask op1+1

scSetFlag
.(
	jsr scriptEvaluateNext
	pha
	and #%111
	sty savy+1
	tay
	lda tab_bit8,y
savy	
	ldy #0
	sta tMask
	pla
	lsr
	lsr
	lsr
	sta tVarp
	jsr scriptEvaluate
	jsr AdvanceOffset	
	ora #0
	beq clear
	ldy tVarp
	cpy #LOCALS_START/8
	bcs local1
	lda _FLAGS,y
	ora tMask
	sta _FLAGS,y
	rts
local1
	lda (lflagp),y
	ora tMask
	sta (lflagp),y
	rts
	
clear
	lda tMask
	eor #$ff
	sta tMask
	ldy tVarp
	cpy #LOCALS_START/8
	bcs local2	
	lda _FLAGS,y	
	and tMask
	sta _FLAGS,y
	rts	
local2
	lda (lflagp),y
	and tMask
	sta (lflagp),y
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set object position room, col and row
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scSetObjectPosition
.(
	; META: Maybe create a function to set actor's position
	; then re-use it with different params for setting room, col
	; row or whatever...
	; This one is tricky due to management of the costume resource
	; for an object. 
	; Let's commence by saving the parameters
	; on the stack, plus the destination room
	; and object entry in smc for later checks.
	jsr getObject1stParam
	stx eobject+1
	jsr scriptEvaluate	; Room
	sta eroom+1
	pha
	jsr scriptEvaluate	; Row
	pha
	jsr scriptEvaluate	; Column
	pha
	sty savy+1
eobject
	ldx #0
	; If we are in the current room (the one being displayed)
	; the SRB for the sprite should be updated
	; and, if there is a room change, the costume must be Nuked
	lda room,x
	cmp _CurrentRoom
	bne skip2 ; We are not, so skip the following
	pha
	jsr UpdateSRBsp	
	pla
	; If the destination room is different, as we have
	; determined that the room is the current room, 
	; its costume must be Nuked.
eroom	
	cmp #0
	beq skip2	; No, it is still this room
	lda costume_id,x
	tax
	jsr NukeCostume
	ldx eobject+1	; Restore reg X with the object entry in the array
skip2	
	; Okay now update coordinates and room
	pla
	sta pos_col,x
	pla
	sta pos_row,x
	pla
	cmp room,x
	sta room,x
	; We are not done yet!
	; Has there been a room change?
	beq skip ; nope, nothing to do
	; If room changed and now in the currently displayed room, update pointer to costume
	; which implies loading it too!
	cmp _CurrentRoom
	bne skip
	; Okay we have to load costume and update pointers, as
	; we were not previously here and therefore our costume
	; was not assigned.
	txa
	tay
	jsr UpdateCostumePointersForObject
	ldx eobject+1
skip	
	; Update SRB, queue and draw (may make sprite disappear if changed to another room)
	jsr IfInRoomUpdateSRBsp
	jsr UpdateCharZPlane
	jsr UpdateDrawingQueue
savy 	
	ldy #0	
	jmp AdvanceOffset	
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper to call a function over
; an object with two parameters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Call2Param
.(
	jsr getObject1stParam
	stx actor+1
	jsr scriptEvaluate
	pha
	jsr scriptEvaluate
	sty savy+1
	tay
	pla
actor
	ldx #0
+smc_function	
	jsr $dead	
savy
	ldy #0
	; Advance offset
	jmp AdvanceOffset
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Start given actor walking to
; a given position (col,row) as params
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scActorWalkTo
	lda #<WalkTo
	sta smc_function+1
	lda #>WalkTo
	sta smc_function+2
	jmp Call2Param

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Makes an actor say a sentence
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scActorTalk
	lda #<Say
	sta smc_function+1
	lda #>Say
	sta smc_function+2
	jmp Call2Param
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Executes a complete action.
; Params: Actor, Verb, Obj1 (Obj2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scExecuteAction
.(
	; Initializations
	ldx #0
	stx Obj1FromInventory
	stx Obj2FromInventory
	
	; Get Actor and set it as Executor
	jsr getObject1stParam
	stx ActorExecutingAction

	; Get Verb to execute
	jsr scriptEvaluate
	sta CurrentVerb
	
	; Now deal with objects and whether
	; they are in the inventory or not,
	; setting the appropriate flags
	jsr scriptEvaluate
	jsr getObjectEntry
	cpx #$ff
	bne object1done
	jsr getInventoryEntry
	inc Obj1FromInventory
object1done
	stx CurrentObject1

	; There could be a second object
	jsr scriptEvaluate
	jsr getObjectEntry
	cpx #$ff
	bne object2done
	jsr getInventoryEntry
	inc Obj2FromInventory
object2done
	stx CurrentObject2
	

	; Advance offset in script and Execute Command!
	jsr AdvanceOffset
	jmp ExecCommand
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Jump instructions (relative)
; Two versions: inconditional and conditional
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scJumpRel
.(
	jsr scriptEvaluateNext
+scJump_ex
	ora #00	; Flags are lost
	bmi neg
	ldy #0
	beq pos
neg
	ldy #$ff
pos	
	ldx _CurrentThread
	clc
	adc thread_offset_lo,x
	sta thread_offset_lo,x
	tya
	adc thread_offset_hi,x
	sta thread_offset_hi,x
	rts
.)

scJumpRelIf
.(
	jsr scriptEvaluateNext
	cmp #0	; Z Flag is lost in Commands
	bne doit
	jsr scriptEvaluate
	jmp AdvanceOffset
doit
	jsr scriptEvaluate
	jmp scJump_ex
	;rts
.)

;;;;;;;;;;;;;;;;;;;;;;;
; Calling other scripts
;;;;;;;;;;;;;;;;;;;;;;;
; Chain runs the script as a child
; and the parent waits for termination
scChainScript
.(
	jsr scSpawnScript
	lda #TH_STATE_PENDED
	ldx _CurrentThread
	sta thread_state,x
	jmp ScheduleScript
.)
; Spawn runs the script in paralell
scSpawnScript
.(
	jsr scriptEvaluateNext
	jsr AdvanceOffset
	; Params: reg X=script ID, Y=parent
	ldy _CurrentThread
	tax
	jmp LoadAndInstallScript
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Events
;;;;;;;;;;;;;;;;;;;;;;;;;;
scSetEvents
.(
	jsr scriptEvaluateNext
	jsr AdvanceOffset
	ora _EngineEvents
	sta _EngineEvents
	rts
.)
scClearEvents
.(
	jsr scriptEvaluateNext
	jsr AdvanceOffset
	eor #$ff
	and _EngineEvents
	sta _EngineEvents
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Actions on objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Helper with two entry points
setCurObjandInventoryVals
.(
	jsr scriptEvaluate
+setCurObjandInventoryValsEx
	jsr getObjectEntry
	cpx #$ff
	beq ininv
end	
	lda #0
	rts
ininv
	jsr getInventoryEntry
	cpx #$ff
	beq end
	lda #1	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Run the code associated to an action
; for a given object.
; Register Y is object over which the command
; is being executed.
; CurrentVerb is the verb id
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scRunObjectCode
.(
	;lda #$ff
	;sta ActorExecutingAction
	
	jsr scriptEvaluateNext
	sta CurrentVerb
	
	jsr setCurObjandInventoryVals
	sta Obj1FromInventory
	stx CurrentObject1
	
	jsr setCurObjandInventoryVals
	sta Obj2FromInventory
	stx CurrentObject2

	jsr AdvanceOffset

	jsr RunObjectCode
	; Parent is set as _CurrentThread by RunObjectCode
	lda #TH_STATE_PENDED
	ldx _CurrentThread
	sta thread_state,x
	jmp ScheduleScript
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Activate/Deactivate verbs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scDisableVerb
.(
	jsr scriptEvaluateNext
	sta vid+1
	jsr scriptEvaluate
	jsr AdvanceOffset
vid
	ldy #0
	cmp #0
	bne deactivate
	jmp ActivateVerb
deactivate
	jmp DeActivateVerb
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Walkboxes
;;;;;;;;;;;;;;;;;;;;;;;;;;;
error_walkbox
#ifdef DOCHECKS_C
	lda #ERR_NOWALKBOX
	jsr catchScriptException
#endif	
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set a given walkbox as walkable
; or not walkable by flagging bit
; 7 in its flags byte.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scSetWalkboxAsWalkable
.(
	; Param 1 walkbox number
	; Param 2 boolean
	jsr scriptEvaluateNext
	pha
	jsr scriptEvaluate
	jsr AdvanceOffset
	sta walk+1
	pla
	jsr getWalkBoxPointer
	beq error_walkbox
	ldy #4	; flags and zplane
	lda (tmp0),y
walk	
	ldx #0
	beq notwalkable
	; clear bit
	and #%01111111
	jmp end
notwalkable
	; set bit
	ora #%10000000
end
	sta (tmp0),y
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sets the next walkbox for 
; goint to an origin walkbox
; to a destinaiton walkbox
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scSetNextWalkbox
.(
	; Param 1 orig wb -> A
	; Param 2 dest wb -> Y
	; Param 3 new next wb
	jsr scriptEvaluateNext
	pha
	jsr scriptEvaluate
	pha
	jsr scriptEvaluate
	sta wb+1
	jsr AdvanceOffset
	pla
	tay
	pla
	jsr getNextWalkBox
wb
	lda #0
	sta (tmp),y
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Music related commands
;;;;;;;;;;;;;;;;;;;;;;;;;;

scPlayTune
	jsr scriptEvaluateNext
	jsr AdvanceOffset
	jmp PlayMusic
	
scStopTune
	jsr StopSound
	ldy #1
	jmp AdvanceOffset
	
scWaitForTune
.(
	lda MusicPlaying
	beq finished
	jmp ScheduleScript
finished
	ldy #1
	jmp AdvanceOffset
.)	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Show/Hide verbs and UI
; Additional entry points
; to be used by the engine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scShowVerbs
.(
	jsr scriptEvaluateNext
	jsr AdvanceOffset
	
	sta VerbsShown ; Signal verbs and invent are or not shown
	cmp #0
	bne ShowVerbs

+HideVerbs	
	jsr SetMouseOff
	jsr ClearInventoryArea
	jsr ClearCommandArea
	jmp ClearVerbArea
+ShowVerbs
	jsr SetMouseOn
	jsr InitVerbs
	jmp UpdateInventory
.)
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Print texts. Two versions, one
; prints in the speech area
; the other at any screen
; position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
scPrint
.(
	jsr scriptEvaluateNext
	sta stres+1
	jsr scriptEvaluate
	sta stid+1
	jsr AdvanceOffset

	jsr ClearSpeechArea
	
	; Put cursor at top line
	lda #<$a000
	sta screen
	lda #>$a000
	sta screen+1
#ifdef SPEECHSOUND	
	jsr callprint
	jmp SpeakSentence
#else	
	jmp callprint
#endif
.)

scPrintAt
.(
	jsr scriptEvaluateNext
	sta stres+1
	jsr scriptEvaluate
	sta stid+1
	jsr scriptEvaluate
	sta posX+1
	jsr scriptEvaluate
	sta posY+1
	jsr AdvanceOffset	
posX	
	ldx #0
posY	
	ldy #0
	jsr gotoXY
.)
callprint	
stres	
	ldx #0
stid
	lda #0
	jmp LoadAndPrintString
	


;;;;;;;;;;;;;;;;;;;;;;;;;;
; Forces a screen redraw
;;;;;;;;;;;;;;;;;;;;;;;;;;
scRedrawScreen
	ldy #1
	jsr AdvanceOffset
	jsr SetRoomPalette
	jmp ClearAllSRB


;;;;;;;;;;;;;;;;;;;;;;;
; Puts an object in the
; inventory (loads it
; if necessary)
;;;;;;;;;;;;;;;;;;;;;;;
scPutInInventory
	jsr scriptEvaluateNext
	jsr AdvanceOffset
	jmp ObjectToInventory

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clears the inventory
;;;;;;;;;;;;;;;;;;;;;;;;;;
scClearInventory
	ldy #1
	jsr AdvanceOffset
	jsr InitInventory
	jmp ClearInventoryArea	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Removes an object
; from the inventory
; BEWARE: does not put it
; back in the global array!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scRemoveFromInventory
	jsr scriptEvaluateNext
	jsr AdvanceOffset
	jmp ObjectOutOfInventory

params2AX
	jsr scriptEvaluateNext
	pha
	jsr scriptEvaluate
	jsr AdvanceOffset
	tax
	pla
	rts
	
;;;;;;;;;;;;;;;;;;;;;;;;;;
; Resource managing
;;;;;;;;;;;;;;;;;;;;;;;;;;	
scLoadResource
	jsr params2AX
	jmp LoadResource
scNukeResource
	jsr params2AX
	jmp NukeResource
scLockResource
	jsr params2AX
	jmp LockResource
scUnlockResource
	jsr params2AX
	jmp UnlockResource


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load/remove an object 
; in the game (into the main
; array)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scLoadObjectToGame
	jsr scriptEvaluateNext
	jsr AdvanceOffset	
	jmp LoadObjectToGame
scRemoveObjectFromGame
	jsr scriptEvaluateNext
	jsr AdvanceOffset	
	jmp RemoveObjectFromGame

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set override script offset
; Notes down the offset of the
; current script and its id
; so pressing ESC jumps to 
; that offset.
; Used to skip parts of 
; cutscenes
; The parameter is a fixed
; 16-bit offset
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scSetOverrideJump	
.(
	stx override_thread
	ldy #1
	lda (tmp0),y
	sta override_offset
	iny
	lda (tmp0),y
	sta override_offset+1
	iny
	jmp AdvanceOffset
.)	

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear room area
;;;;;;;;;;;;;;;;;;;;;;;;;;;
scClearRoomArea
.(
	ldy #1
	jsr AdvanceOffset	
	jmp ClearRoomArea
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Conditional jump
; Extra entry point to 
; unconditional jump
;;;;;;;;;;;;;;;;;;;;;;;;;;;
scJumpIf
.(
	jsr scriptEvaluateNext
	cmp #0	; Z Flag is lost in Commands
	bne doit
	iny
	iny
	jmp AdvanceOffset
+scJump
	ldy #1
doit	
	lda (tmp0),y
	sta thread_offset_lo,x
	iny
	lda (tmp0),y
	sta thread_offset_hi,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Routines to manage dialogs: 
; Load and install dialog resource
; Start a dialong
; Finish a dialog
; Activate/deactivate dialog options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scLoadDialog
	jsr scriptEvaluateNext
	jsr AdvanceOffset	
	jmp LoadAndInstallDialog
scStartDialog
	ldy #1
	jsr AdvanceOffset	
	jmp StartDialog
scEndDialog
	ldy #1
	jsr AdvanceOffset	
	jmp EndDialog
scActivateDlgOption
.(	
	jsr scriptEvaluateNext
	sta option+1
	jsr scriptEvaluate	
option	
	ldx #0
	sta DlgActiveOptions,x
	jmp AdvanceOffset
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Freeze/unfreeze a script
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scFreezeScript
.(
	jsr scriptEvaluateNext
	jsr searchScriptID	
	cpx #$ff
	beq end
	stx option+1
	jsr scriptEvaluate	
	cmp #0
	beq false
	lda #TH_STATE_FROZEN
	.byt $2c
false
	lda #TH_STATE_RUNNING
option	
	ldx #0
	sta thread_state,x
end	
	jmp AdvanceOffset
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Freeze/Unfreeze all scripts
; except the one issuing the
; command.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scFreezeAllScripts
.(	
	jsr scriptEvaluateNext
	cmp #0
	beq false
	lda #TH_STATE_FROZEN
	.byt $2c
false
	lda #TH_STATE_RUNNING
	sta option+1
	
	ldx #MAX_THREADS-1
loop
	cpx _CurrentThread
	beq skip
	lda thread_state,x
	beq skip
option	
	lda #0
	sta thread_state,x	
skip
	dex
	bpl loop

	jmp AdvanceOffset
.)
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Terminate (kill) a script.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scTerminateScript
.(
	jsr scriptEvaluateNext
	sty savy+1
	jsr searchScriptID
	cpx #$ff
	beq end	
	jsr PurgeScript
end	
savy
	ldy #0
	jmp AdvanceOffset
.)	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Perform 'fading' in the
; image. It should not contain
; attributes to work properly
; (those are not deactivated)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;fade_table .byt A_FWBLACK, A_FWBLUE, A_FWCYAN, A_FWWHITE
scFadeToBlack
.(
#define count op1
	ldy #1
	jsr AdvanceOffset
	lda smc_ink_1+1
	pha
	lda smc_ink_2+1
	pha

	lda #3
	sta count
loop
	ldx count
	lda fade_table,x
	sta smc_ink_1+1
	sta smc_ink_2+1
	jsr SetInk2
	
	ldy #6
loopw	
	jsr WaitIRQ
	dey
	bne loopw
	
	dec count
	bpl loop
	
	pla
	sta smc_ink_2+1
	pla
	sta smc_ink_1+1
	rts
;count .byt 00	
#undef count
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make an SFX sound
; At least try, if there is a free
; channel or another SFX with
; lower priority sound is being
; played (in that case it is stopped and
; this one is played)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scPlaySFX
.(
	jsr scriptEvaluateNext
	jsr AdvanceOffset
	jmp _PlaySfx
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Stops an SFX if it is sounding
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scStopSFX
.(
	jsr scriptEvaluateNext
	jsr AdvanceOffset
	jmp _StopSFX
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Stop the command a character
; is running.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scStopCharacter
.(
	jsr getObject1stParam
	stx actor+1
	jsr AdvanceOffset
actor
	ldx #0
	jsr StopCharAction	
	lda #LOOK_RIGHT
	jmp UpdateAnimstate	
.)	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set a B&W pseudo-palette
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scSetBWPalette
	ldy #1
	jsr AdvanceOffset
	jmp SetBWPalette

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the room pseudo-palette
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
scSetRoomPalette
	ldy #1
	jsr AdvanceOffset
	jmp SetRoomPalette

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Show the menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
scMenu
	ldy #1
	jsr AdvanceOffset
	jmp DoMenu

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Save game to disk at
; current save slot
; (just one for now)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
scSave
	ldy #1
	jsr AdvanceOffset
SaveGame
.(	
	;jsr CompactMemory
	jsr SaveListOfGlobalResources
	lda first_col
	sta first_col_copy
	lda #%00111100	
	sta magic
	jsr ChangeIcon
	SaveFileAt(LOADER_SAVESPACE,__SaveGameData_start)
	jmp ChangeIcon
	;rts
.)


ChangeIcon
.(
	ldx #7
loop	
	lda saviconbuff,x
	tay
	lda $9fff-31,x
	sta saviconbuff,x
	tya
	sta $9fff-31,x
	
	lda saviconbuff+8,x
	tay
	lda $9fff-31+16,x
	sta saviconbuff+8,x
	tya
	sta $9fff-31+16,x
	
	dex
	bpl loop
	rts
.)
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load game from disk at
; current save slot
; (just one for now)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
scLoad
/*	
	ldy #1
	jsr AdvanceOffset
	jsr PurgeScript	

	jsr LoadGame	
	
	; Get rid of context and return
	pla
	pla
	rts	
*/	
LoadGame
.(
	lda #0
	sta magic
	
	/* This only necessary if loading from the running game */
	
	jsr PurgeLocalScripts
	jsr RemoveLocalObjects
	
	;lda _CurrentRoom
	;jsr NukeRoom
	;jsr KillCostumes	
	;jsr CompactMemory

	; Set resource memory as empty;
	lda #RESOURCE_NULL
	sta __resource_memory_start+0
	lda #<(RESOURCE_TOP-__resource_memory_start)
	sta __resource_memory_start+1
	lda #>(RESOURCE_TOP-__resource_memory_start)
	sta __resource_memory_start+2	
	
	LoadFileAt(LOADER_SAVESPACE,__SaveGameData_start)	

	; Get some important variables back
	; Current column being displayed
	lda first_col_copy
	sta first_col
	
	; Set inventory to the top object
	lda #0
	sta first_item_shown
	
	; Set Current ego entry
	lda _CurrentEgo
	jsr getObjectEntry
	stx CurrentEgoEntry
	
	; Set player's options
	jsr UpdateVolumeSetting
#ifdef SPEECHSOUND	
	jsr UpdateTalkSound
#else
	jsr UpdateTalkTime
#endif
	; Show UI if needed
	lda VerbsShown
	beq hide
	jsr ShowVerbs
	jmp next
hide
	jsr HideVerbs
next	

	; Load the resources and display inventory
	jsr LoadGlobalResourcesFromList
	jmp UpdateInventory
.)	
