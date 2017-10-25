/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

;; Script function evaluation

#include "script.h"
#include "params.h"


functions_ptr_hi 
	; Logic & Math
	.byt >sfAdd, >sfSub, >sfMul, >sfDiv, >sfAnd, >sfOr, >sfNot, >sfEqual
	.byt >sfGE, >sfGT, >sfLE, >sfLT, >sfGetRand, >sfGetRandInt, >sfGetVal, >sfGetFlag	
	; Object Control
	.byt >sfGetEgo, >sfGetTalking, >sfGetCol, >sfGetRow, >sfGetFacing, >sfGetRoom
	.byt >sfGetWalkbox, >sfGetCostumeID, >sfGetCostumeNo, >sfGetState, >sfIsNotMoving
	.byt >sfGetAnimState, >sfGetWalkRow,>sfGetWalkCol, >sfGetWalkFaceDir, >sfGetColorSpeech
	.byt >sfGetSizeX, >sfGetSizeY, >sfGetAnimSpeeed, >sfIsActor, >sfIsProp
	.byt >sfGetClosestActor, >sfGetDistance, >sfGetObjectAt, >sfIsInInventory
	; Room control
	.byt >sfGetCurrentRoom, >sfGetRoomCols, >sfIsWalkboxWalkable, >sfGetNextWalkbox
	; Actions
	.byt >sfGetActorExecutingAction, >sfGetActionVerb, >sfGetActionObject1, >sfGetActionObject2
	; Camera control
	.byt >sfGetCameraCol, >sfGetCameraFollowing, >sfGetFadeEffect, >sfIsCameraInAction
	; Script engine
	.byt >sfIsScriptRunning, >sfIsMusicPlaying

functions_ptr_lo 
	; Logic & Math
	.byt <sfAdd, <sfSub, <sfMul, <sfDiv, <sfAnd, <sfOr, <sfNot, <sfEqual
	.byt <sfGE, <sfGT, <sfLE, <sfLT, <sfGetRand, <sfGetRandInt, <sfGetVal, <sfGetFlag	
	; Object Control
	.byt <sfGetEgo, <sfGetTalking, <sfGetCol, <sfGetRow, <sfGetFacing, <sfGetRoom
	.byt <sfGetWalkbox, <sfGetCostumeID, <sfGetCostumeNo, <sfGetState, <sfIsNotMoving
	.byt <sfGetAnimState, <sfGetWalkRow,<sfGetWalkCol, <sfGetWalkFaceDir, <sfGetColorSpeech
	.byt <sfGetSizeX, <sfGetSizeY, <sfGetAnimSpeeed, <sfIsActor, <sfIsProp	
	.byt <sfGetClosestActor, <sfGetDistance, <sfGetObjectAt, <sfIsInInventory	
	; Room control
	.byt <sfGetCurrentRoom, <sfGetRoomCols, <sfIsWalkboxWalkable, <sfGetNextWalkbox
	; Actions
	.byt <sfGetActorExecutingAction, <sfGetActionVerb, <sfGetActionObject1, <sfGetActionObject2
	; Camera control
	.byt <sfGetCameraCol, <sfGetCameraFollowing, <sfGetFadeEffect, <sfIsCameraInAction
	; Script engine & misc
	.byt <sfIsScriptRunning, <sfIsMusicPlaying	
	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Evaluate routine.
; It looks at the current script
; byte and decides if it is a value or a
; function call, acting accordingly
; The main entry point is scriptEvaluate
; Params: (tmp0),y points to the byte
; to be evaluated
; Returns: value in reg A
; The entry point ensures reg X is 
; unmodified
; The entry point at scriptEvaluateNext
; initializes Y to 1, which is common
; when evaluating the first parameter
; of an action.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scriptEvaluateNext
	ldy #1
scriptEvaluate
.(
	stx Savx+1
	jsr doEvaluate
Savx
	ldx #0
	rts
.)
doEvaluate
.(
	lda (tmp0),y
	bmi eval_function
	; It is a constant
	iny	
	cmp #%01000000
	bcs extended_constant
	; A tiny constant, return it in reg A
	and #%00111111
	rts
extended_constant
	; META:Could check for more cases here	
	; such as 16-bit constants
	; there is an 8-bit constant
	; on the next byte, load
	; update Y and return
	lda (tmp0),y
	iny
	rts
eval_function
	iny	
	; It is a function, call it
	and #%01111111
	sta LastFunctionCalled
	tax
	lda functions_ptr_lo,x
	sta smc_jmpaddr+1
	lda functions_ptr_hi,x
	sta smc_jmpaddr+2
smc_jmpaddr	
	jmp $dead	; Jump to the function
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Script functions


; Helper that gets two params, the first
; one in A and the second in tmp

get2param
.(
	; Evaluate 1st param
	jsr doEvaluate
	pha	; Save it in stack to allow recursion
	jsr doEvaluate
	sta tmp
	pla
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add two 8-bit values (no carry)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfAdd
.(
	jsr get2param
	; Add the two values
	clc	
	adc tmp
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subtract two 8-bit values (no carry)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfSub
.(
	jsr get2param
	; Subtract the two values
	sec
	sbc tmp
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Logic AND
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfAnd
.(
	jsr get2param
	; And the two values
	and tmp
	rts
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Logic OR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfOr
.(
	jsr get2param
	; Or the two values
	ora tmp
	rts
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Logic Not
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfNot
.(
	; Evaluate param
	jsr doEvaluate
	eor #1
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; I put these commands here
; so branches are in range...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfIsMusicPlaying
	lda MusicPlaying
	beq false
	bne true

sfIsScriptRunning ; 1st param type, 2nd ID
.(
/*
	jsr get2param	; 1st param in A, 2nd in tmp
	sty savy+1
	ldx #MAX_THREADS-1
loop
	ldy thread_state,x
	beq next
	cmp thread_script_type,x
	bne next
	ldy thread_script_id,x
	cpy tmp
	beq true2
next
	dex
	bmi false2
	bpl loop
false2
true2
	php
savy
	ldy #0
	plp
	bmi false
	bpl true
*/


	jsr get2param	; 1st param in A, 2nd in tmp
	sta tmp+1
	ldx #MAX_THREADS-1
loop
	lda thread_state,x
	beq next
	lda tmp+1
	cmp thread_script_type,x
	bne next
	lda tmp
	cmp thread_script_id,x
	beq true
next
	dex
	bmi false
	bpl loop
.)

sfIsWalkboxWalkable
	lda tmp0
	pha
	lda tmp0+1
	pha
	jsr doEvaluate
	jsr getWalkBoxPointer
	beq false ; META: THIS MUST BE NOT ZERO IF A POINTER IS RETURNED!!!
	ldy #4	; flags and zplane
	lda (tmp0),y
	sta tmp
	pla
	sta tmp0+1
	pla
	sta tmp0
	lda tmp
	; META: BEWARE IF WALABLE FLAG CHANGES FROM BIT 7
	bmi false
	bpl true
sfIsCameraInAction
	lda camera_command_hi
	beq false
	bne true
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comparisons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfEqual
.(
	jsr get2param
	; Are the two equal
	cmp tmp
	beq true
+false	
	lda #0
	rts
+true
	lda #1
	rts
.)
sfGE
.(
	jsr get2param
	; Are the two equal
	cmp tmp
	bcs true
	bcc false
.)
sfLT
.(
	jsr get2param
	; Are the two equal
	cmp tmp
	bcc true
	bcs false
.)
sfGT
.(
	jsr get2param
	; Are the two equal
	cmp tmp
	beq false
	bcs true
	bcc false
.)
sfLE
.(
	jsr get2param
	; Are the two equal
	cmp tmp
	bcc true
	beq true
	bne false
.)	

; Get the value of a flag.	
sfGetFlag
.(
#define tMask tmp	
	jsr doEvaluate
	sty savy+1
	pha
	and #%111
	tay
	lda tab_bit8,y
	sta tMask
	pla
	lsr
	lsr
	lsr
	tay
	cpy #LOCALS_START/8
	bcs local2
	lda _FLAGS,y
	jmp next
local2
	lda (lflagp),y
next	
savy
	ldy #0
	and tMask
	bne true
	beq false
;tMask .byt 00	
#undef tMask
.)		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Object Control:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfIsActor
	jsr getEntryParam
	lda #OBJ_FLAG_ACTOR
testflag	
	and flags,x
	beq false
	bne true
sfIsProp
	jsr getEntryParam
	lda #OBJ_FLAG_PROP
	bne testflag  	; Jumps always
sfIsNotMoving
	jsr getEntryParam
	lda command_high,x
	ora subcom_high,x
	beq true
	bne false
sfGetEgo
	lda _CurrentEgo
	rts
sfGetTalking
.(
	ldx _TalkingActor
	lda obj_id,x
	cpx #$ff
	bne ok
	txa
ok	
	rts
.)	
getEntryParam
.(
	jsr doEvaluate
	jsr getObjectEntry
	cpx #$ff
	bne cont
	jmp error_obj
cont
	rts
.)

	
sfGetRow
	jsr getEntryParam
	lda pos_row,x
	rts
sfGetCol
	jsr getEntryParam
	lda pos_col,x
	rts
sfGetFacing
	jsr getEntryParam
	lda direction,x
	rts
sfGetRoom
	jsr getEntryParam
	lda room,x
	rts
sfGetCostumeID
	jsr getEntryParam
	lda costume_id,x
	rts
sfGetCostumeNo
	jsr getEntryParam
	lda costume_no,x
	rts	
sfGetAnimState
	jsr getEntryParam
	lda anim_state,x
	rts	
sfGetWalkRow
	jsr getEntryParam
	lda walk_row,x
	rts	
sfGetWalkCol
	jsr getEntryParam
	lda walk_col,x
	rts	
sfGetWalkFaceDir
	jsr getEntryParam
	lda face_dir,x
	rts	
sfGetColorSpeech
	jsr getEntryParam
	lda color_speech,x
	rts	
sfGetSizeX
	jsr getEntryParam
	lda size_cols,x
	rts	
sfGetSizeY
	jsr getEntryParam
	lda size_rows,x
	rts	
sfGetAnimSpeeed
	jsr getEntryParam
	lda anim_speed,x
	rts	
sfGetState	
.(
	jsr doEvaluate
	jsr setCurObjandInventoryValsEx
	beq inarray
	lda inventory_flags,x
	and #%11
	rts
inarray	
	lda flags,x
end	
	and #%11
	rts
.)
	
sfGetWalkbox
.(
	lda tmp0
	pha
	lda tmp0+1
	pha
	jsr getEntryParam
	sty endwb+1
	jsr getWalkBoxForCharacter
	bcc endwb
	lda #$ff
+endwb
	ldy #0
	sta tmp
	pla
	sta tmp0+1
	pla
	sta tmp0
	lda tmp
	rts
.)	

sfGetVal
.(
	jsr doEvaluate
	sty savy+1
	tay
	cpy #LOCALS_START
	bcs local1
	lda _VARS,y
	jmp savy
local1
	lda (lvarp),y
savy
	ldy #0
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Random routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfGetRand
	jmp randgen
sfGetRandInt
.(
	jsr get2param ; min val, max val
	cmp tmp
	bcc doit
	lda #0
	rts
doit
	sta tmp+1 ;save min val
	
	; Calculate range
	lda tmp
	sec
	sbc tmp+1
	sta tmp
	
	jsr randgen
loop	
	cmp tmp
	bcc found
	beq found
notfound
	;sec
	sbc tmp
	jmp loop
found	
	clc
	adc tmp+1
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets the next walkbox for 
; goint to an origin walkbox
; to a destinaiton walkbox
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfGetNextWalkbox
.(
	lda tmp0
	pha
	lda tmp0+1
	pha
	jsr get2param
	sty endwb+1
	; Param 1 orig wb -> A
	; Param 2 dest wb -> Y
	ldy tmp
	jsr getNextWalkBox
	jmp endwb
.)
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Actions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfGetActorExecutingAction 
	;lda ActorExecutingAction
	;jsr getObjectEntry
	;txa
	ldx ActorExecutingAction
	lda obj_id,x
	rts
sfGetActionVerb
	lda CurrentVerb
	rts
.(
+sfGetActionObject1
	ldx CurrentObject1
	cpx #$ff
	bne doit
empty
	txa
	rts
doit	
	lda Obj1FromInventory
	beq notinv
ininv	
	lda inventory_id,x
	rts
notinv
	lda obj_id,x
	rts
+sfGetActionObject2
	ldx CurrentObject2
	cpx #$ff
	beq empty
	lda Obj2FromInventory
	beq notinv
	bne ininv
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Room and camera
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sfGetCurrentRoom
	lda _CurrentRoom
	rts
sfGetRoomCols
	lda nRoomCols
	rts
sfGetCameraCol
	lda first_col
	clc
	adc #(VISIBLE_COLS/2)
	rts
sfGetCameraFollowing
	lda actor_following
	rts
sfGetFadeEffect
	lda CurrentFadeEffect
	rts
	
sfIsInInventory	
.(
	jsr doEvaluate
	jsr getInventoryEntry
	cpx #$ff
	bne yep
	lda #0
	rts
yep
	lda #1
	rts
.)	



sfGetClosestActor
sfGetDistance
sfGetObjectAt
sfMul
sfDiv
#ifdef DOCHECKS_C
	lda #ERR_UNDEFOPCODE
	jsr catchScriptException
#endif
	lda #0
	rts

error_obj
#ifdef DOCHECKS_C
	lda #ERR_NOACTOR
	jsr catchScriptException
#endif	
	rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Needed functions
; A real random generator... 
;randseed .word $dead 	; will it be $dead again? 
randgen 
.(
   lda randseed     	; get old lsb of seed. 
   ora $308		; lsb of VIA T2L-L/T2C-L. 
   rol			; this is even, but the carry fixes this. 
   adc $304		; lsb of VIA TK-L/T1C-L.  This is taken mod 256. 
   sta randseed     	; random enough yet. 
   sbc randseed+1   	; minus the hsb of seed... 
   rol			; same comment than before.  Carry is fairly random. 
   sta randseed+1   	; we are set. 
   rts			; see you later alligator. 
.)


