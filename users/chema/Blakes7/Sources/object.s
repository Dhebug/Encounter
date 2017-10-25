/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

;; Loading/managing objects

#include "object.h"
#include "debug.h"
#include "params.h"



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get the entry in the object list
; for a given object id passed in A
; returns entry in X, $ff if not found
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getObjectEntry
.(
	cmp #$ff
	beq fail
	ldx #MAX_OBJECTS-1
loop	
	cmp obj_id,x
	beq found
	dex
	bpl loop
fail	
	ldx #$ff
found
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update all the pointers to costumes
; for current objects.
; Launched after memory compaction.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateObjectPointers
.(
	; Save tmp_X and restore it later,
	; because this may be called when
	; assigning a new costume and having to 
	; compact memory to load the new one.
	; This happens while the routine expects
	; this variable to keep the entry for the object
	; whose costume is being changed.
	
	lda tmp_X
	pha
	ldx #MAX_OBJECTS-1
loop	
	; Check the entry is not empty
	lda obj_id,x
	cmp #OBJ_EMPTY_ENTRY
	beq next_entry
	; If the object is a prop, it
	; doesn't have a costume
	lda flags,x
	and #OBJ_FLAG_PROP
	bne next_entry

	; Hacking the variable tmp_X
	; and using it for the loop
	stx tmp_X
	lda costume_id,x
	cmp #$ff
	beq next_entry
	jsr PutCorrectCostumePointers
	ldx tmp_X
next_entry
	dex
	bpl loop
	
	pla
	sta tmp_X
	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Removes an object
; from the main array
; Reg A: object id to remove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RemoveObjectFromGame
.(
	jsr getObjectEntry
	cpx #$ff 
	bne found
+retme	rts
found
	stx savx+1
	/*
	lda room,x
	cmp _CurrentRoom
	bne skip
	jsr UpdateSRBsp
	*/
	jsr IfInRoomUpdateSRBsp
	bne skip
	; And nuke costume
	lda costume_id,x
	tax
	jsr NukeCostume	
savx
	ldx #0 ; Load object ID back
skip	
	; Set as empty
	lda #OBJ_EMPTY_ENTRY
	sta obj_id,x
	jmp postRemovingObjects	; this is jsr/rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load an object from a disk
; resource and add it to the
; game set.
; Reg A: object id to load
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LoadObjectToGame
.(
	; If the object is already loaded, skip
	jsr getObjectEntry
	cpx #$ff 
	bne retme

	; Search for an empty entry in the array	
	ldy #MAX_OBJECTS-1
loop
	ldx obj_id,y
	cpx #OBJ_EMPTY_ENTRY
	beq found
	dey
	bpl loop
notfound
#ifdef DOCHECKS_B
	lda #ERR_NOROOMOBJ
	jsr catchEngineException
#else
	rts
#endif
found	
	; Store it
	sta obj_id,y
	pha	
	
	; Save Y for later
	sty smc_entry+1
	; Save resource ID for later
	sta smc_resid+1
	; Load resource
	tax
	jsr LoadObject
	sty tmp+1
	sta tmp
smc_entry
	ldx #00
	; Make sure this is ok
	lda #0
	sta anim_state,x
	; Set flags and size
	ldy #0
	lda (tmp),y
	sta flags,x
	iny	
	lda (tmp),y
	sta size_cols,x
	iny
	lda (tmp),y
	sta size_rows,x
	; Set room and position
	iny
	lda (tmp),y
	cmp #$ff
	bne setroom
	lda _CurrentRoom
setroom	
	sta room,x
	iny
	lda (tmp),y
	sta pos_col,x
	iny
	lda (tmp),y
	sta pos_row,x
	iny
	lda (tmp),y
	; Set zplane, location for interaction and other data
	sta z_plane,x
	iny	
	lda (tmp),y
	sta walk_col,x
	iny
	lda (tmp),y
	sta walk_row,x
	iny
	lda (tmp),y
	sta face_dir,x
	iny	
	lda (tmp),y
	sta color_speech,x	
	stx temp_code
		
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	; For PROPS (no pictures) this can be skipped
	; Put empty costume, in case...
	lda #$ff
	sta costume_id,x

	lda flags,x
	and #OBJ_FLAG_PROP
	bne skipgr	
	iny
	lda (tmp),y	; costume resource ID
	; Store info, even if no costume, as it
	; may be needed later
	sta costume_id,x
	iny
	lda (tmp),y	; number of costume
	sta costume_no,x
	iny	
	lda (tmp),y	; direction
	; META: Need to store it in anim_state. Something
	; is messy here with the direction and animstate
	; need to re-think this all.
	;sta anim_state,x
	sta dir+1 
	sta direction,x
	iny
	lda (tmp),y	; animation speed
	sta anim_speed,x
	iny

	sty savy+1
	/*
	lda tmp
	pha
	lda tmp+1
	pha
	*/
	
	; If not in room, skip loading costume
	lda room,x
	cmp _CurrentRoom
	bne noloadcos
	
	lda costume_id,x
	cmp #$ff
	bne hascos
noloadcos	
	; No, skip loading it
	;pla
	;pla
	jmp skip2
hascos	
	tax
	jsr LoadCostume
	sta tmp0
	sty tmp0+1
	
	ldx temp_code	
	jsr SetupCostumePointers
	ldx temp_code
dir
	lda #0
	jsr LookDirection_forced
	; I had to change this to get the pointer to the resource
	; because loading the costume may have compacted memory, and
	; resource could've been moved.
	; META: Could this be done differently to avoid this? For instance
	; save the name, nuke the object resource, then loading the
	; costume?
	/*pla
	sta tmp+1
	pla
	sta tmp */
smc_resid	
	ldx #0
	lda #RESOURCE_OBJECT
	jsr GetPointerToResource
	sta tmp
	sty tmp+1
	jmp skip2
skipgr	
	; Coming from the point where object is a PROP
	iny
	sty savy+1
skip2	
	; Add the object's name
	ldx temp_code
	jsr getObjNameEntry
savy
	lda #0
	jsr addAtmp

	ldy #$ff
loopname
	iny
	lda (tmp),y
	sta (tmp0),y
	bne loopname

	; Mark resource for deletion
	pla
	tax
	jsr NukeObject	

	; Insert it in the drawing queue
	lda temp_code
	
	; Let the program flow...
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add object to the drawing queue
; reg A contains the entry
; in the object list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AddToDrawingQueue
.(	
	ldy nActiveObjects
	sta tab_objects,y
	inc nActiveObjects
	jmp SortObjects
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets entry to obj name. 
; Needs reg X loaded with object's 
; entry in array. Returns tmp0
; pointing to the object's name
; Use 2nd entry point if tmp0
; is already loaded with the pointer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getObjNameEntry
.(
#if OBJ_NAME_LEN <> 16
#error Object name len changed... Check getObjNameEntry
#endif
//#if OBJ_NAME_LEN*MAX_OBJECTS > 255
//#error Size of names too big... Check getObjNameEntry
//#endif
	lda #<obj_names
	sta tmp0
	lda #>obj_names
	sta tmp0+1
+getObjNameEntryEx
	lda #0
	sta tmp5
	txa

	ldx #4
loop
	asl
	rol tmp5
	dex
	bne loop
/*	
	asl
	rol tmp5
	asl
	rol tmp5
	asl
	rol tmp5
	asl
	rol tmp5
*/	
	adc tmp0
	sta tmp0
	lda tmp5
	adc tmp0+1
	sta tmp0+1
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Remove local objects from
; the set
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RemoveLocalObjects
.(
	ldy #MAX_OBJECTS-1
loop	
	ldx obj_id,y
	cpx #RESOURCE_LOCALS_START
	bcc next
	cpx #OBJ_EMPTY_ENTRY
	beq next
	; Set as empty
	lda #OBJ_EMPTY_ENTRY
	sta obj_id,y
	ldx costume_id,y
	cpx #RESOURCE_LOCALS_START
	bcs next
	sty savy+1
	jsr NukeCostume
savy
	ldy #0
	
next
	dey
	bpl loop
	
	;jmp UpdateDrawingQueue	; this is jsr/rts
	; Let the program flow
.)

postRemovingObjects
NukeUnusedCosutmes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Empties and resets the
; contents of the drawing queue
; with the objects in this room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateDrawingQueue
.(
	lda #0
	sta nActiveObjects 
	
	ldx #MAX_OBJECTS-1
loop
	lda obj_id,x
	cmp #OBJ_EMPTY_ENTRY
	beq next	
	lda room,x
	cmp _CurrentRoom
	bne next

	; META: Attempt to get the correct ZPlane!
	; I had to comment this because it was causing a bug with the London
	; cell door. It recalculated the zplanes even for those in zplane 0!
	; I have to put it back in, or there were problems after loading a room
	lda z_plane,x
	beq skipuz
	jsr UpdateCharZPlane
skipuz	
	ldy nActiveObjects
	txa
	sta tab_objects,y
	inc nActiveObjects
next
	dex
	bpl loop
	
	; Let the program flow...
	;jmp SortObjects
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Order drawing list
; by row position
; Rotine taken from http://6502.org/source/sorting/bubble8.htm
; using bubble sort. META: Should try something
; smarter (or less dumb, to be honest), like
; some sort of selection sort
; here: http://codebase64.org/doku.php?id=base:optimal_sort_8-bit_elements
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SortObjects
.(
loop
	ldy #$00      		;turn exchange flag off (= 0)
	sty flag
	ldx nActiveObjects 	;fetch element count
	beq end			; No elements???
	dex           		;decrement element count
	beq end			; No use in sorting a 1-element list
nxtel
	
	/* META: I changed this for a version which takes into
	account z-planes, but might be changed back later...
	
	ldy tab_objects,x	;fetch element
	lda pos_row,y
	ldy tab_objects-1,x
	cmp pos_row,y
	bcc chkend
	beq chkend
	*/
	ldy tab_objects,x	;fetch element
	lda pos_row,y
	ora z_plane,y
	sta tmp
	ldy tab_objects-1,x
	lda pos_row,y
	ora z_plane,y
	cmp tmp
	bcs chkend
	;yes. exchange elements in memory
	lda tab_objects-1,x
	pha           		; by saving low byte on stack.
	lda tab_objects,x  	; then get high byte and
	sta tab_objects-1,x
	pla           		;pull low byte from stack
	sta tab_objects,x
	lda #$ff      		;turn exchange flag on (= -1)
	sta flag
chkend 
	dex           		;end of list?
	bne nxtel     		;no. fetch next element
	bit flag      		;yes. exchange flag still off?
	bmi loop      		;no. go through list again
end	
	rts           		;yes. list is now ordered.
.zero
flag .byt 0
.text
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sets up graphic pointers to
; an object. Needs index in array
; in reg X and tmp0 pointing to
; costume resource. Costume-related
; fields in array should be correct
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetupCostumePointers
.(
	stx tmp_X
	; Read pointer to tileset
	ldy #$ff	
	jsr ReadOffset
	stx tmp
	ldx tmp_X
	sta tab_tiles_hi,x
	lda tmp
	sta tab_tiles_lo,x

	; Read pointer to masks
	jsr ReadOffset
	stx tmp
	ldx tmp_X
	sta tab_masks_hi,x
	lda tmp
	sta tab_masks_lo,x	
	
	iny	;number of costumes
	
	; Read start of animstates
	lda costume_no,x
	asl
	sta tmp
	clc
	tya
	adc tmp
	tay
	jsr ReadOffset
	stx tmp
	ldx tmp_X
	sta base_as_pointer_high,x
	lda tmp
	sta base_as_pointer_low,x

	lda anim_state,x
	jmp UpdateAnimstate2
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Assign Costume to actor
; Needs COSTUME resource ID (X), number of 
; costume inside resource (Y), and actor ID (A)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AssignCostume
.(
	stx savx+1
	sty savy+1
	; Find actor ID in array
	jsr getObjectEntry 
#ifdef DOCHECKS_C	
	; If not found flag an error
	cpx  #$ff
	bne doit
	pha
	lda #ERR_NOACTOR
	jsr catchScriptException
	pla
	rts
doit	
#else
	cpx #$ff
	bne cont
	rts
cont
#endif
savy
	lda #0
	sta costume_no,x
savx	
	lda #0
	cmp costume_id,x
	stx tmp_X
	beq nochange

	
	; Costume has changed, nuke previous if needed
	pha
	lda room,x
	cmp _CurrentRoom
	bne skipnuke
	lda costume_id,x
	cmp #$ff
	beq skipnuke
	jsr UpdateSRBsp
	lda costume_id,x	
	stx savxb+1
	tax
	jsr NukeCostume
savxb	
	ldx #0
skipnuke	
	pla
	sta costume_id,x

	; If not in this room do not load
	lda room,x
	cmp _CurrentRoom
	bne end2
	lda costume_id,x
	
	; If empty costume, finish here.
	cmp #$ff
	beq end2
	tax
	jsr LoadCostume
	jmp end
nochange
	cmp #$ff
	beq end2
+PutCorrectCostumePointers
	tax
	lda #RESOURCE_COSTUME
	jsr GetPointerToResource
	beq end2	
end	
	sta tmp0
	sty tmp0+1
	ldx tmp_X
	jmp SetupCostumePointers
end2
	rts
.)

/* Updates the pointers for all objects in the room. This is
   called after loading a new room to reload the costume
   data for global objects which are in this room         */
ReloadCostumes
.(
	sty savy+1
	ldy #MAX_OBJECTS-1
loop	
	ldx obj_id,y
	;cpx #RESOURCE_LOCALS_START
	;bcc next
	cpx #OBJ_EMPTY_ENTRY
	beq next
	lda room,y
	cmp _CurrentRoom
	bne next
	jsr UpdateCostumePointersForObject
next	
	dey
	bpl loop
savy
	ldy #0
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Updates the costume pointer
; for an object.
; Params Y= index entry
; Preserves reg Y
; Notes: Used as a helper, now called also
; from script scSetObjectPosition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
UpdateCostumePointersForObject
.(
	ldx costume_id,y
	cpx #$ff
	beq end

	sty savy2+1
	
/*	This was commented because we can be using this to assign a costume which
	is already loaded (shared). Yeah, the name got me confused.
	lda #RESOURCE_COSTUME
	jsr GetPointerToResource
	bne skipl
*/	
	jsr LoadCostume
skipl	
	sta tmp0
	sty tmp0+1
	ldx savy2+1	
	jsr SetupCostumePointers
savy2	
	ldy #0
end	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Nukes the costumes for all
; the objects in the array
; used when changing rooms
; only (we are wasting space by
; keeping it as a routine, but
; it is for the sake of keeping it
; in the file where costumes are
; being handled).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
KillCostumes
.(
	sty savy+1
	ldy #MAX_OBJECTS-1
loop	
	ldx obj_id,y
	;cpx #RESOURCE_LOCALS_START
	;bcc next
	cpx #OBJ_EMPTY_ENTRY
	beq next
	;lda room,y
	;cmp _CurrentRoom
	;bne next
	ldx costume_id,y
	cpx #RESOURCE_LOCALS_START
	bcs next
	;cpx #$ff
	;beq next
	sty tmp_Y
	jsr NukeCostume
	ldy tmp_Y
next	
	dey
	bpl loop
savy
	ldy #0
	rts
.)

