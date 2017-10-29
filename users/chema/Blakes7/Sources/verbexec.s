/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

;; Executing user commands (sentences)
;; And basic UI

#include "verbs.h"
#include "inventory.h"
#include "script.h"
#include "gameids.h"


; Verbs are:
; GIVE  PICK UP USE 
; OPEN  LOOK AT PUSH 
; CLOSE TALK TO PULL

; Verb data in tables.s

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UI Routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Verb area is 240x56
; Enough for an upper 8 pixel row 
; for the sentence to execute
; and three rows of 16 pixels for verbs.
; Horizontally we have 40 chars (6 pix)
; We need at least one column for attribs,
; Let's say 38 cols for 3 cols of verbs and
; an inventory area. I'd say that the best way
; is splitting it in two. First 20 cols for
; verbs, and the other 20 for inventory.
; GIVE  PICK UP USE 
; OPEN  LOOK AT PUSH 
; CLOSE TALK TO PULL 
; 0->6 col 1 with attribute
; 7->14 col 2 with attribute
; 15->19 col 3 with attribute
; 20 - Attribute change
; 21->39 attribute+inventory object (or arrow)
; Verbs use 2 rows each, inventory items just 1,
; but the first and last rows are for arrows, 
; that is 56-8=48
; so we can display the name of 6 items if 8 pix high chars
; Or even 8 items if 6 pix high chars.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize internal variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FullInitVars
	ldy #0
	sty LookingForObj2
	sty ActorExecutingAction
	sty CommandRunning
	sty SentenceChanged
InitVars
.(
	; Beware not all the necessary initialization
	; is done here, due to usage in other parts
	; of the code.
	ldy #VERB_WALKTO
	sty SelCurrentVerb
	jmp ClearObjects
	;rts
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Print verbs in verb area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InitVerbs
.(
#define count op1
	jsr InitVars
	; If in dialog mode, verbs are not shown...
	lda InDialogMode
	beq doit
	rts
doit
	jsr ClearVerbArea
	lda #8 ; Num verbs-1
	sta count
loop
	ldy count
	lda #1
	sta verb_active,y
	lda verb_pos_Y,y
	ldx verb_pos_X,y
	tay	
	jsr gotoXY
	lda #UNSEL_VERB_COLOR
	jsr put_code
	
	ldx #<verbs
	ldy #>verbs
	lda count
	inc double_height
	jsr PrintStringWithXY
	dec double_height
	
	ldy count
	lda verb_pos_Y,y
	ldx verb_pos_X,y
	clc
	adc #CHARSET_HEIGHT
	tay	
	jsr gotoXY
	lda #UNSEL_VERB_COLOR
	jsr put_code	
	
	dec count
	bpl loop
	
	rts
;count .byt 0	
#undef count
.)

; Activate/Deactivate verb passed in y
ActivateVerb
	lda #1
	.byt $2c
DeActivateVerb
	lda #0
	sta verb_active,y
UpdateVerbColor
	lda verb_active,y
	pha
	lda verb_pos_Y,y
	ldx verb_pos_X,y
	tay	
	jsr gotoXY
	pla
	bne active
	lda #INACTIVE_VERB_COLOR
	.byt $2c
active	
	lda #UNSEL_VERB_COLOR
	pha
	jsr put_code
	ldx res_x
	lda res_y
	clc
	adc #CHARSET_HEIGHT
	tay
	jsr gotoXY
	pla
	jmp put_code

	
; Auxiliar function (used here and in inventory.s)
auxPixelAddress
.(
	jsr PixelAddress
	sty tmp
	clc
	lda tmp0
	adc tmp
	sta tmp
	lda tmp0+1
	adc #0
	sta tmp+1
	rts
.)	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clears the verb area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearVerbArea
.(
	ldx #0
	ldy #INVENTORY_AREA_FIRSTLINE-CHARSET_HEIGHT

	jsr auxPixelAddress
	
	ldx #(200-INVENTORY_AREA_FIRSTLINE)
looprow	
	ldy #(INVENTORY_AREA_START/6-1)
	lda #$40
loop	
	sta (tmp),y
	dey
	bpl loop
	
	dex
	beq end
	
	jsr add40tmp
	jmp looprow
end	
	rts
.)


	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Transform the pixel coordinates 
; passed in A,Y (x,y) to coordinates
; in characters (tiles)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PointToTile
.(
	sta workwithcol+1
	tya
	; Divide by 8
	lsr
	lsr
	lsr
	tay 	
workwithcol
	ldx #0 ; SMC
	lda _TableDiv6,x
	clc
	adc first_col
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets the actor over which the cursor is.
; I was about to reuse code from the DrawSprites
; routine, but the drawing queue should be explored
; in the inverse order.
; Params: A,Y hold the column and row, as 
; returned by PointToTile. 
; Returns X with the ID of actor, or $ff.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getActorPointedTo
.(
	sta smc_tilecol+1
	
	; The order is inversed to the drawing order	
	ldx #0
	stx tmp7
loop	
	; Get the object to draw was done already
	lda tab_objects,x	; drawing queue
	
	; if it is not the ego
	cmp CurrentEgoEntry
	beq skip

	tax
	; Check if the object overlaps the current tile
	; start with the col
smc_tilecol	
	lda #0	; tile_col
	sec
	sbc pos_col,x
	bmi skip
	cmp size_cols,x
	bcs skip
	; now the row
#ifdef DRAWTOPTOBOT	
	tya
	sec
	sbc pos_row,x
#else
	sty tmp
	lda pos_row,x
	sec
	sbc tmp
#endif
	bmi skip
	cmp size_rows,x
	bcs skip
	; This sprite overlaps, simply
	; return its ID in X	
	rts
skip
	; The object did not overlap, get to the next one
	inc tmp7
	ldx tmp7
	cpx nActiveObjects
	bcc loop
	
	; If we arrive here, no object was found
	ldx #$ff
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code to run when the mouse pointer
; moves
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ProcessMouseMoves
.(
	; Check if in dialog mode
	lda InDialogMode
	beq next2
	jmp MMDialogMode
next2	
	lda plotY
	cmp #(ROOM_ROWS+1)*8	; This is a hack to avoid 'Walk To Exit' when outside room
	bcs next3

	cmp #(ROOM_ROWS)*8	; And this to avoid leaving a verb higlighted when scrolling
	bcs next4
	ldx #$ff
	jsr updatehighlightverb
next4	
	jmp indrawarea

next3	
	; Cursor is not on a point in room	
	lda plotX
	cmp #INVENTORY_AREA_START
	bcs ininventoryarea
	; In the verb area... find out which
	; verb to choose		
	lda plotX
	sta tmp
	lda plotY
	sta tmp+1
	jsr FindChosenVerb
	; Do not branch,
	; so removes highlighting when no verb
	; is selected
	;bmi notfound
	
	
	; Perform a beep sound if verb changes
	; and store Chosen Verb id for later
/*	
	cpx SaveVCode+1
	beq samev
	stx SaveVCode+1	
	cpx #$ff
	beq samev
	lda #SFX_UIA
	jsr _PlaySfx
samev	
*/
updatehighlightverb
	; Save Chosen Verb id for later
	stx SaveVCode+1	

	;; As drawing the cursor
	;; corrupts attributes. PlotCross has been
	;; modified to avoid drawing over attributes,
	;; which seems a good idea anyway.
	
	;; Loop through the verbs
	ldx #8	; There are 9 verbs + Walk To
	stx tmp5
loop
	; Get the positions from tables
	ldx tmp5
	lda verb_active,x
	beq nextv
	lda verb_pos_X,x
	ldy verb_pos_Y,x
	
	; Put cursor at attribute position
	tax
	jsr gotoXY
SaveVCode
	lda #00
	cmp tmp5	 
	bne normalcolor
	lda #SEL_VERB_COLOR
	.byt $2c
normalcolor
	lda #UNSEL_VERB_COLOR
	pha
	jsr put_code	
	tya
	clc
	adc #CHARSET_HEIGHT
	tay
	jsr gotoXY
	pla
	jsr put_code
nextv	
	dec tmp5
	bpl loop
	
notfound
	rts
ininventoryarea
	; Is the mouse over an inventory item?
	; if so, higlight the inventory item
	lda plotY
	jsr CheckOverItem
	beq none
	cmp #1
	bne none

	; This changes the default verb to LOOK AT in
	; the inventory area, but as it does not get
	; back to WALK TO it does not behave nicely
	; so I am commenting it.
/*	
	lda SelCurrentVerb
	cmp #VERB_WALKTO
	bne skipthis
	lda #VERB_LOOKAT
	sta SelCurrentVerb
skipthis
*/
	ldy #1
	lda LookingForObj2
	bne object2b
	sty SelObj1FromInventory
	bpl nextb
object2b	
	lda SelObj1FromInventory
	beq isok2
	cpx SelCurrentObject1
	beq none

isok2
	sty SelObj2FromInventory
nextb
	jmp drawobject
none	
	ldx #$ff
	jmp drawobject
indrawarea
	; The cursor is in the room area, 
	; find out the tile coordinates
	lda plotX
	ldy plotY
	jsr PointToTile
	; Is the mouse over an object or actor?
	; if so, print its name in the command 
	; area
	jsr getActorPointedTo
	ldy #0
	lda LookingForObj2
	bne o2
	sty SelObj1FromInventory
	beq drawobject
o2
	sty SelObj2FromInventory
drawobject	
	lda LookingForObj2
	bne object2
	; Selecting first object
	cpx SelCurrentObject1
	stx SelCurrentObject1

	jmp next
object2
	; Selecting second object
	cpx SelCurrentObject2
	stx SelCurrentObject2
next
	beq end
	inc SentenceChanged
end
	rts
	
.)

; Helper to check if cursor is over an inventory item
; Params A=line
; X Coordinate has already been checked
; returns A=0 if nothing selected, 1 if item selected
; 2 if scroll up selected and 3 if scrolldown selected
CheckOverItem
.(
	cmp #INVENTORY_AREA_FIRSTLINE
	bcc checkup
	cmp #INVENTORY_AREA_FIRSTLINE+((VISIBLE_INV_ITEMS-1)*(CHARSET_HEIGHT))+7
	bcs checkdown
	sec
	sbc #INVENTORY_AREA_FIRSTLINE
	lsr
	lsr
	lsr
	clc
	adc first_item_shown
	tax
	cpx nObjectsInventory
	bcs none
	lda #1
	rts
checkup
	cmp #INVENTORY_AREA_FIRSTLINE-CHARSET_HEIGHT
	bcc none
	lda #2
	rts
checkdown
	lda #3
	rts
none
	lda #0
	rts
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Finds the verb at position
; tmp, tmp+1 (X,Y in pixels)
; If N=0 found and index
; returned in X and A
; If N=1 not found.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FindChosenVerb
.(
	ldx #8	; There are 9 verbs + Walk To
loop
	lda tmp
	; Position includes attribute, so...
	sec
	sbc #CHARSET_WIDTH
	cmp verb_pos_X,x
	bcc notfound
	cmp verb_pos_X2,x
	bcs notfound
	
	lda verb_pos_Y,x
	cmp tmp+1
	bcs notfound
	adc #4	; VERB SIZE Y -1 as carry is always set
	cmp tmp
	bcs found
notfound
	dex
	bpl loop
found
	; if X < 0 (or N=1) not found
	; else found and X=verb ID
	txa
	rts
.)

 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prints the current command
; sentence on the info area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
PrintCommandSentence
.(
	lda #SFX_UIA
	jsr _PlaySfx

	; State the sentence has been printed
	lda #0
	sta SentenceChanged
	
	; Print to temporary buffer
	sta buffercounter
	inc print2buffer
	; Hide the mouse cursor and clear
	; area
	jsr ClearCommandArea
	jsr HideMouse
	
	; Print verb + space
	ldx #<verbs
	ldy #>verbs
	lda SelCurrentVerb
	jsr PrintStringWithXY
	jsr put_space
	
	; If an object is selected as first, 
	; print its name
	ldx SelCurrentObject1
	cpx #$ff
	beq skipo1
	
	; The name is held in a different place
	; if the object is in the room or in the
	; inventory
	lda SelObj1FromInventory
	jsr getNamePointer	
	jsr PrintObjName

	; If the verb wants a 2nd object print
	; space + preposition
	ldx SelCurrentVerb	
	lda verb_prep,x
	cmp #$ff
	beq skipo1
	cpx #VERB_USE
	bne skipusecheck
	jsr getObject1Flags
	and #OBJ_FLAG_USEDWITHOTHER
	beq skipo1
skipusecheck	
	jsr put_space
	lda verb_prep,x	
	ldx #<preps
	ldy #>preps
	jsr PrintStringWithXY
		
	; If there is a second object
	; print it too:
	ldx SelCurrentObject2
	cpx #$ff
	beq skipo1	
	;cpx SelCurrentObject1
	;beq skipo1
	
	lda SelObj2FromInventory
	jsr getNamePointer	
	jsr put_space
	ldx SelCurrentObject2
	jsr PrintObjName
skipo1	
	; Done
	lda #0
	ldy buffercounter
	sta str_buffer,y
	dec print2buffer
	; Dump buffer
	ldy #(ROOM_ROWS)*8+1
	jsr PrintCentered

	; Get mouse cursor back and return
	jmp ShowMouse	; jsr/rts
.) 	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Auxiliar routine that stores
; in tmp0 the correct pointer
; to object name strings
; Param: Z=0 object in room
; 	 Z=1 object in inventory
; as direct result of 
; lda SelObj2FromInventory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getNamePointer
.(
	bne inv1
	lda #<obj_names
	ldy #>obj_names
	jmp doit
inv1
	lda #<inventory_names
	ldy #>inventory_names
doit	
	sta tmp0
	sty tmp0+1
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Print Object name. Object entry is
; passed in reg x and pointer to
; start of names in tmp0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PrintObjName
.(
	jsr getObjNameEntryEx
	jmp print2
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code to run when the user clicks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ProcessMouseClicks
.(
	lda MouseClicked
	bne doit
	rts
doit
	lda #0
	sta MouseClicked

	; Check if in dialog mode
	lda InDialogMode
	beq next
	jmp MCDialogMode
next	
	lda clickY
	cmp #(ROOM_ROWS)*8
	bcc indrawarea
	
	; Not clicking on a point in room
	lda clickX
	cmp #INVENTORY_AREA_START
	bcs ininventoryarea
	; User clicked in the verb area... find out which
	; verb to choose
	lda clickX
	sta tmp
	lda clickY
	sta tmp+1
	jsr FindChosenVerb
	bpl found
notfound
	ldx #VERB_WALKTO	; default to Walk TO ???
found
	lda verb_active,x
	beq noverbchange
	cpx SelCurrentVerb
	beq noverbchange
	stx SelCurrentVerb
	jsr ClearObjects
	inc SentenceChanged
noverbchange
	rts
ininventoryarea	
	lda clickY
	jsr CheckOverItem
	beq noverbchange ; rts above
	
	; User clicked in the inventory area
	cmp #2
	bne skipsu
	jmp ScrollInventoryDown;ScrollInventoryUp
skipsu
	cmp #3
	bne skipsd
	jmp ScrollInventoryUp;ScrollInventoryDown
skipsd	
	; Make sure the verb makes sense
	lda SelCurrentVerb
	cmp #VERB_WALKTO
	beq tweak
	cmp #VERB_PICKUP
	beq tweak
	bne indrawarea
tweak
	lda #VERB_LOOKAT
	
	; This is an entry point for the shortcut code, A=verb to execute
+shortcutentry			
	sta SelCurrentVerb
	inc SentenceChanged
indrawarea
	; If the verb needs 2 objects and the 
	; first one has been selected, then we need
	; to look for the second one.
	; First, if we have already selected a second object
	; different from the first
	; META: THIS IS ALL A MESS... SHOULD CHECK AND SIMPLIFY
	
	lda LookingForObj2
	beq check
	lda SelCurrentObject2
	cmp SelCurrentObject1
	bne isok ; META: This could be simplified to bne doaction, as the cmp #$ff is commented now.
	lda SelObj1FromInventory
	cmp SelObj2FromInventory
	beq noverbchange ;rts above
	lda SelCurrentObject2
isok	
	;cmp #$ff	; If second object is not $ff, then ready to perform action
	bne doaction
check	
	lda SelCurrentVerb
	cmp #VERB_GIVE
	beq needs2
	
	cmp #VERB_USE
	bne doaction
	jsr getObject1Flags
	and #OBJ_FLAG_USEDWITHOTHER
	beq doaction
needs2
	lda SelCurrentObject1
	cmp #$ff
	beq doaction
	lda #1
	sta LookingForObj2
	inc SentenceChanged	; To print "with" or "to"
	rts
doaction	
	lda #SFX_UIB
	jsr _PlaySfx
	; User sends ego to perform a command
	lda CurrentEgoEntry
	sta ActorExecutingAction
	lda #0
	sta LookingForObj2
	; Copy contents with user selection
	ldx #4
loop
	lda SelCurrentVerb,x
	sta CurrentVerb,x
	dex
	bpl loop
	;jsr InitVars
	;jmp ExecCommand
	; Let the program flow
.)
		
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main function to execute
; the command contained in
; CurrentVerb
; CurrentObject1
; CurrentObject2
; Invalid values are marked as $ff
; Assumes the actor executing the action
; is stored in ActorExecutingAction
; (array of objects index, not ID)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ExecCommand
.(
	; Run the current command, with the current Objects
	; Clear speech (in case a message is interrupted) and command areas
	jsr ClearSpeechArea
	jsr ClearCommandArea

	; First check another command is not running
	; META: CHECK THAT...
	; MAYBE THIS CHECK CAN BE SKIPPED, NOT MANY CYCLES WASTED
	; AND PROBABLY WE WANT THE COMMAND AND SUBCOMMAND TO BE
	; SET TO ZERO AS HAPPENS WITH THE SPEECH AREA.	
	;lda CommandRunning
	;beq nocommand

	; Stop current command, with all the necessary 
	; clearing. 
	ldx ActorExecutingAction	; This is now the entry in the characters array, not the Object ID!
	jsr StopCharAction
	
nocommand	
	; Find out if the current Command+Object1+Object2 combination
	; is executable.
	inc CommandRunning
	lda CurrentVerb
	bmi walktocursor
	ldx CurrentObject1
	cpx #$ff
	beq walktocursor
	;lda CurrentVerb
	cmp #VERB_GIVE
	bne skipthis
	; Give needs a second object
	ldx CurrentObject2
	cpx #$ff
	beq walktocursor
skipthis
	lda Obj1FromInventory
	bne skipgo1
	; The first object is not from the inventory
	; so we need to make the actor go there
	ldx CurrentObject1
dogothere	
	jsr getWalkPosOfObject
	bcc ok2
	rts
skipgo1	
	; Object 1 is in inventory
	; See if we need to go to object 2
	ldx CurrentObject2
	cpx #$ff
	beq end
	lda Obj2FromInventory
	beq dogothere
	; The second object is not from the inventory
	; so we need to make the actor go there
end	
	rts
walktocursor	
	; This is the code in case everything else fails!
	; if ActorExecutingAction is in the current room, send it to walk.
	lda #VERB_WALKTO
	sta CurrentVerb
	sta SelCurrentVerb
	jsr ClearObjects
	inc SentenceChanged
	; User clicked in the game area, calculate the tile
	; over which the cursor is
	lda clickX
	ldy clickY
	jsr PointToTile
	; Now A,Y hold the column and row where
	; the cursor was when the user clicked.
	; But if on the verb/inventory area, do not go
	; there, just return
	cpy #(ROOM_ROWS)
	bcc doit
	rts
doit
	; Adjust with the desired actor position
#ifdef DRAWTOPTOBOT	
	; subtract 3 to the row
	dey
	dey
	dey
	cpy #ROOM_ROWS-5
	bcc ok1
	ldy #(ROOM_ROWS-1)-5	
#else
	; add 2 to the row
	iny
	iny
	cpy #ROOM_ROWS
	bcc ok1
	ldy #(ROOM_ROWS-1)
#endif	
ok1	 
	; And subtract 2 to the col
	sec
	sbc #2
	bmi offside
	bne ok2
offside	
	lda #1
ok2	
	ldx ActorExecutingAction	; This is now the entry in the characters array, not the Object ID!
	pha
	lda room,x
	cmp _CurrentRoom
	bne skip
	pla
	jmp WalkTo
skip
	pla
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Stops the action for a character 
; passed in reg X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
StopCharAction
.(
	lda #0
	sta command_high,x
	sta subcom_high,x
	; If the actor is talking, reset the flag
	cpx _TalkingActor
	bne skiptalk
	lda #$ff
	sta _TalkingActor
skiptalk
	cpx ActorExecutingAction
	bne skipaction
	; The actor is executing an action. Stop it!
	lda #0
	sta CommandRunning
skipaction
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clears selection object variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearObjects
.(
	sty savy+1
	ldy #$ff
	sty SelCurrentObject1
	sty SelCurrentObject2
	iny
	sty SelObj1FromInventory
	sty SelObj2FromInventory
	sty LookingForObj2
savy	
	ldy #0
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets the flags for 1st
; object.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getObject1Flags
.(
	ldy SelCurrentObject1
	lda SelObj1FromInventory
	beq notinv
	lda inventory_flags,y
	rts
notinv		
	lda flags,y
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets the walk position 
; for an object passed in X
; returns it in regs A,Y (col,row)
; returns with C=1 if no need to move
; else C=0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getWalkPosOfObject
.(
	; If it is an actor we should calculate from the actor
	; position (the nearest side, same row)
	; if it is an static object we should get the
	; position from its data variables.
	; META: some temporal hacks that should be removed

	; If the object can be interacted with from the distance,
	; OBJ_FLAG_FROMDISTANCE flag is set, and there's no need to walk to it
	lda flags,x 
	and #OBJ_FLAG_FROMDISTANCE
	beq cont
	sec 
	rts
	
cont	
	lda walk_col,x
	cmp #$ff	; Use default location (depending on its position)
	beq default
	;bmi default	; if neg it is either default ($ff) or any ($fe)
	ldy walk_row,x
	clc
	rts
default	
	ldy ActorExecutingAction ; This is now the entry in the characters array, not the Object ID!
	lda pos_col,y
	sec
	sbc #2
	cmp pos_col,x
	bcc left
	lda pos_col,x
	clc
	adc #5
	bcc done ; Always jumps
left
	lda pos_col,x
	;clc
	sec
	sbc #5
done
	ldy pos_row,x
	clc
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Routine to keep executing
; the verb while necessary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ContinuousExecCommand
.(
	; If CommandRunning
	; and command or subcommand of ActorExecutingAction are null
	; one phase has ended (ActorExecutingAction arrived), and we should continue with
	; running the command
	lda CommandRunning
	beq end
	ldx ActorExecutingAction	; This is now the entry in the characters array, not the Object ID!
	lda command_high,x
	bne end
	lda subcom_high,x
	beq doit
end	
	rts
doit
	; Check if near enough to the object in quesiton
	; META: Use different distances for different actions?
	jsr getObjectOfInterest
	rol 
	cpy #$ff
	beq endcommand
	ror 
	bcs nearandready	; Both objects of action are from the inventory
	
	; If the object can be interacted with from the distance,
	; OBJ_FLAG_FROMDISTANCE flag is set, and there's no need to walk to it
	lda flags,y 
	and #OBJ_FLAG_FROMDISTANCE
	bne calculate	; Just check the direction to look at.
	
	; Use the Walk column and row fields if they are > 0, else 
	; calculate using the position of the object ($ff) or any row/col is valid ($fe)
	lda walk_col,y
	bpl usewc
	lda pos_col,y
usewc	
	cmp #$fe		; $fe means ANY
	beq wisok
	; abs(ego_col-target_col)<6 ?
	sec
	sbc pos_col,x
	jsr abs8
	cmp #6	
	bcs toofar	; No, it is too far
wisok	
	; Again use walk row field if > 0 else, it means either any ($fe) or object position ($ff)
	lda walk_row,y
	bpl usewr
	cmp #$fe		; $fe means ANY
	beq near
	lda pos_row,y
usewr	
	; abs(ego_row-target_row)<3?
	sec
	sbc pos_row,x
	jsr abs8
	cmp #3
	bcc near	; Yes, then we have reached the object 
toofar
	; Something happened and the ego could not
	; reach the object.
	; abort command.
	jmp endcommand
near	
	; Check if facing the correct direction (change it and return, if not)
	lda face_dir,y
	cmp #$ff	; Does it have a valid value?
	beq calculate
	
	; It does, just check
	cmp direction,x
	beq nearandready
	; change it
	jmp LookDirection	; jsr/rts
calculate
	; We have to calculate the direction to look at
	lda pos_col,x
	cmp pos_col,y
	bcs lookleft
	lda #FACING_RIGHT
	.byt $2c
lookleft
	lda #FACING_LEFT
	cmp direction,x
	beq nearandready
	jmp LookDirection	; jsr/rts
nearandready	
	; Try to exec the command by searching in the object's script code
	; in anycase set CommandRunning to 0
	; Is this valid even if the script needs work?
	; Probably yes, as it is the script which should take care of it
	;lda CurrentVerb	
	; Walk to has to be handled too, so no exception here!
	
	; Also Y is the object returned by getObjectofInterest
	; Is this correct??? I think we want 2nd object if exists
	; else 1st object always!
	; It is correct for walking to it, but the script handling
	; the action is indeed in the 2nd object if it exists.
	
	jsr RunObjectCode
endcommand
	jsr InitVars
	lda #0
	sta CommandRunning
	;lda #$ff
	;sta ActorExecutingAction
	rts
.)	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; get Object to deal with in verb
; execution, based on the flags
; which indicate if chosen object
; is from inventory or not.
; Helper for reaching, facing...
; Returns object entry in reg Y
; does not change A nor X
; Returns Carry Set if None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getObjectOfInterest
.(

	pha
	; (Object1 or Object2? depends on Object in inventory?)
	lda Obj1FromInventory
	beq targetob1
	; Object 1 is in the inventory... need to check
	; object 2
	ldy CurrentObject2
	cpy #$ff
	bne checkob2inv
	; Object 2 does not exist and
	; Object 1 is in inventory, so
	; return with Carry set
	ldy CurrentObject1
	jmp endc
checkob2inv
	; Object 2 exists, check if in inventory
	lda Obj2FromInventory
	bne endc	; BOth objects are in inventory
	beq endnc	; Obj2 is not in inventory
targetob1
	; target is ob1
	ldy CurrentObject1
endnc
	clc
	bcc end
endc
	sec
end	
	pla
	rts
.)

abs8
.(
	and #$ff	; Get flags
	bpl return
	sta tmp
	sec
	lda #0
	sbc tmp
return	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Runs the code associated to an action
; for a given object.
; Uses the values of CurrentObject1, CurrentObject2,
; CurrentVerb, Obj1FromInventory and Obj2FromInventory
; Use the 2nd entry point if A is loaded with object ID
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RunObjectCode
.(
	; Need to load the object code resource:
	jsr getObjectOfInterest
	bcs inv
	lda obj_id,y
	jmp RunObjectCodeEx
inv	
	lda inventory_id,y
+RunObjectCodeEx	
	tax
	stx param_blk
	jsr LoadObjectCode
	sta tmp
	sty tmp+1
	; Search for action in action table
	ldy #0	
loopaction
	lda (tmp),y
	cmp #$ff
	beq end
	cmp CurrentVerb
	beq found
	iny
	iny
	iny
	bne loopaction ; In practice, branches always
end	
	; Action not found
	; Nuke resource
	ldx param_blk
	jsr NukeObjectCode
	; If the verb is NOT walk to, 
	; call the default script
	; Except if verb is WALK To
	lda CurrentVerb
	cmp #VERB_WALKTO
	bne default
retme	
	rts
default	
	; Parent script is current thread
	ldy _CurrentThread
	ldx #SCRIPT_UNHANDLED_ACTIONS 	; Default script for not valid actions?
	jmp LoadAndInstallScript	;jsr/rts
found	
	; Entry for verb found, install the object's script
	; with the correct offset.
	; META: runObjectScript in scummvm checks
	; if an object script for this object is already
	; running and if it is and the script is not recursive, it
	; stops it. Same when running ANY script.
	; We may do it in InstallScript??

	; param_blk+0 (object id) should have already been
	; set with object id (look at the start of this routine)
	lda _CurrentThread
	sta param_blk+1
	lda tmp
	sta param_blk+2
	lda tmp+1
	sta param_blk+3
	iny
	lda (tmp),y
	sta param_blk+5
	iny
	lda (tmp),y
	sta param_blk+6
	lda #RESOURCE_OBJECTCODE
	sta param_blk+4	
	jmp InstallScriptAtOffset	
.)