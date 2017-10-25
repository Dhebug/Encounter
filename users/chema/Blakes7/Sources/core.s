;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Basic core interpreter routines

#include "params.h"
#include "resource.h"
#include "debug.h"
#include "core.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Camera control
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CameraControl
.(
	lda camera_command_hi
	bne doit
	; No command: Check if following an actor
	jmp CameraFollowsActor
doit
	; Execute the command by jumping to its address
	sta tmp0+1
	lda camera_command_lo
	sta tmp0
	jmp (tmp0)
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Moves Camera to X position stored
; in var_camera
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PanCamera
.(
	lda first_col
	clc
	adc #20
	cmp var_camera
	beq reached
	bcc panright
	jsr ScrollRoomRight
	beq reached
	rts
panright
	jsr ScrollRoomLeft
	beq reached
	rts
reached
	; Remove the command
	lda #0
	sta camera_command_hi
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Makes camera follow an actor
; actor to follow array position 
; in var_camera
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CameraFollowsActor
.(
	; Are we following an actor?
	ldx actor_following
	cpx #$ff
 	beq not_far_right	; return
	
	; Scroll room accordingly, but
	; not only the actor position is checed,
	; but also the direction he is facing and if 
	; he is walking away
	lda pos_col,x
	sec
	sbc first_col
	cmp #6
	bcs not_far_left
	lda anim_state,x
	cmp #WALK_RIGHT_1
	bne not_far_left
	ldy direction,x
	cpy #FACING_LEFT
	bne not_far_left	
	
	; Okay we need to scroll, install 
	; the command and the number of columns
	; to scroll in var_camera2
	lda #<ScrollForActorRight
	ldy #>ScrollForActorRight
install_sc	
	sta camera_command_lo
	sty camera_command_hi
	lda #10*2
	sta var_camera2
not_far_right	
	rts
	
	; Check on the right now
not_far_left
	cmp #32-3
	bcc not_far_right
	lda anim_state,x
	cmp #WALK_RIGHT_1
	bne not_far_right	; returns
	
	ldy direction,x
	cpy #FACING_RIGHT
	bne not_far_right
	lda #<ScrollForActorLeft
	ldy #>ScrollForActorLeft
	jmp install_sc
;not_far_right
;	rts
.)


; Commands and helpers related to scroll
HideMouseIfNecessary
	lda plotY
	cmp #(ROOM_ROWS)*8+6
	bcs notindrawarea1
	jmp HideMouse
notindrawarea1	
	rts
ScrollForActorRight
	jsr ScrollCommon
ScrollRoomRight	
	jsr HideMouseIfNecessary
	jsr _scroll_right
	jmp ScrollEnd
	
ScrollForActorLeft
	jsr ScrollCommon
ScrollRoomLeft	
	jsr HideMouseIfNecessary
	jsr _scroll_left
ScrollEnd	
	; Show mouse cursor again, but keep the value
	; of Z returned by the scrolling routine.
	php
	jsr ShowMouse
	jsr UpdateMouse
	plp
	rts
ScrollCommon
.(
	dec var_camera2	; Decrement number of columns to scroll
	bpl cont
	lda #>CameraFollowsActor
	sta camera_command_hi
	lda #<CameraFollowsActor
	sta camera_command_lo
	pla
	pla
cont	
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clears the area where the room
; is displayed, by stoing $40s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearRoomArea
.(
	ldy #<DUMP_ADDRESS
	sty tmp
	ldy #>DUMP_ADDRESS
	sty tmp+1
	ldx #((ROOM_ROWS)*8)
loop2
	ldy #39
	lda #$40
loop
	sta (tmp),y
	dey
	bpl loop

	jsr add40tmp
	dex
	bne loop2
	rts	
.)

PerformFadeEffect
.(
	jsr HideMouse
	lda CurrentFadeEffect
	bpl noclear
	jsr ClearRoomArea
noclear	
	jsr SetRoomPalette
	lda CurrentFadeEffect
	and #%01111111 ; Clear flag to erase picture	
	cmp #FADE_DEFAULT
	beq DefaultFading
	cmp #FADE_LEFTRIGHT
	beq LRFading
	cmp #FADE_RIGHTLEFT
	beq RLFading

.)
RedrawAllScreen
	jsr HideMouse
	jsr SetRoomPalette
DefaultFading
	jsr ClearAllSRB
	jsr RenderScreen		
	jmp ShowMouse
.(
+RLFading
.(
	jsr ZeroAllSRB
	ldx #LAST_VIS_COL
	stx cur_x
loopcol
	ldy #ROOM_ROWS-1
	sty cur_y
looprow
	ldy cur_y
	lda cur_x
	clc
	adc first_col
	tax
	jsr UpdateSRB
	dec cur_y
	bpl looprow

	jsr RenderScreen
	dec cur_x
	lda cur_x
	cmp #FIRST_VIS_COL-1
	bne loopcol
	
	rts
.)
+LRFading
.(
	jsr ZeroAllSRB
	ldx #FIRST_VIS_COL
	stx cur_x
loopcol
	ldy #ROOM_ROWS-1
	sty cur_y
looprow
	ldy cur_y
	lda cur_x
	clc
	adc first_col
	tax
	jsr UpdateSRB
	dec cur_y
	bpl looprow

	jsr RenderScreen
	inc cur_x
	lda cur_x
	cmp #LAST_VIS_COL+1
	bne loopcol
	
	rts
.)
cur_x 	.byt 0
cur_y	.byt 0
counter .byt 0
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ego routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set ego to the character ID passed
; in A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetEgo
.(
	jsr getObjectEntry
	cpx #$ff
	beq notfound
	stx CurrentEgoEntry
	sta _CurrentEgo
	rts
notfound
	; Object was not found, load it
	; and put it in the game. Then
	; try again.
	pha
	jsr LoadObjectToGame
	pla
	jmp SetEgo
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Room loading
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Helper to read an offset from (tmp0),y 
; add it to tmp0 and return it X (low), A(high)
ReadOffset
.(
	iny
	lda (tmp0),y
	clc
	adc tmp0
	tax
	iny
	lda (tmp0),y
	adc tmp0+1
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update all room pointers
; This is on a separate routine so 
; it can be called after compacting
; resources.
; tmp0 points to the room resource
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateRoomPointers
.(
	; Start from the begining
	ldy #0
	
	; Read offset to column data
	jsr ReadOffset
	stx pRoomData
	sta pRoomData+1
	
	; Read offset to tileset
	jsr ReadOffset
	stx pRoomTileset
	sta pRoomTileset+1	

	; Read zplane information
	iny
	lda (tmp0),y
	sta nZPlanes
	beq nozplanes

	; Read zplane offsets
	lda #0
	sta tmp
	sta tmp1
loopzplanes	
	jsr ReadOffset
	sty tmp+1
	ldy tmp1
	stx pZPlaneData,y
	sta pZPlaneData+1,y

	ldy tmp+1
	jsr ReadOffset
	sty tmp+1
	ldy tmp1
	stx pZPlaneTiles,y
	sta pZPlaneTiles+1,y

	iny
	iny
	sty tmp1	
	ldy tmp+1
	
	inc tmp
	lda tmp
	cmp nZPlanes
	bne loopzplanes
nozplanes
	; Read walkbox data
	iny
	lda (tmp0),y
	sta nWalkBoxes
	;beq nowalkboxes
	jsr ReadOffset
	stx pWalkBoxes
	sta pWalkBoxes+1
	jsr ReadOffset
	stx pWalkMatrix
	sta pWalkMatrix+1
nowalkboxes	

	; Read palette information (if any)
	iny
	lda (tmp0),y
	iny
	ora (tmp0),y
	bne palette
	; There is no palette information
	sta pPalette
	sta pPalette+1
	beq endpalette
palette	
	dey
	dey
	jsr ReadOffset
	; TODO: This is not implemented yet
	stx pPalette
	sta pPalette+1
endpalette
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Loads a new room and makes it active
; Room ID is passed in reg X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LoadNewRoom
.(
	stx savX+1
	jsr StopCharacterCommands
	jsr ClearSpeechArea

	; If there is a room loaded, it should
	; be unloaded, or, at least, unlocked.	
	ldx _CurrentRoom
	cpx #$ff	
	beq skip
		
	; Check for Exit Script and run it now.
	ldx _ExitScript
	cpx #$ff
	beq finish2
	; Params: reg X=script ID, Y=parent
	ldy #$ff	
	jsr LoadAndInstallScript
	jsr RunThreadOnce
finish2
	; If we are loading a local room, signal with C=1
	ldx savX+1
	cpx #RESOURCE_LOCALS_START
	ldx _CurrentRoom
	jsr NukeRoom	
	jsr KillCostumes
skip	
	; Signal RoomChanged, so the main loop
	; performs the fading effect.
	; The main loop also sets it back to 0
	; It also serves to know when to update
	; the room pointers after memory compaction
	; (If RoomChanged != 0 there is no room loaded
	; yet, so it can't be done)
	inc RoomChanged 
	ldx #$ff
	stx _TalkingActor
		
	; Abort any camera command. As
	; Following an actor has been special-cased
	; it will keep on doing it.
	lda #0
	sta camera_command_hi
	sta SentenceChanged
	sta CommandRunning
	
	; Set first visible column to default
	; This avoids incorrect rendering when there
	; is no ego to look at or the script
	; does not specify an initial position
	lda #($fe+1)
	sta first_col

	; META: Compacting memory here is a good idea???
	; Only if room is not local, else it is in memory...
	ldx savX+1
	cpx #RESOURCE_LOCALS_START
	bcs nocompact
	jsr CompactMemory
nocompact	
savX
	ldx #0
	stx _CurrentRoom
	jsr LoadRoom
	
	sta tmp0
	sty tmp0+1
	ldy #0
	
	; Read number of columns
	lda (tmp0),y
	sta nRoomCols

	; Read all the pointers
	jsr UpdateRoomPointers

	; Set up entry and exit scripts
	iny
	lda (tmp0),y
	sta _EntryScript
	iny
	lda (tmp0),y
	sta _ExitScript  	
	
	; Reload the costumes for global objects in the room. 
	; as they surely were discarded when no more needed when
	; we were not in this room and the memory compaction erased
	; them.
	lda tmp0
	pha
	lda tmp0+1
	pha
	jsr ReloadCostumes
	pla 
	sta tmp0+1
	pla
	sta tmp0
	
	
	; Read number of objects in the room
	iny
	lda (tmp0),y
	beq noobjects
	; Read ids and prepare objects
catchme
	sta tmp4
	lda tmp0
	sta tmp6
	lda tmp0+1
	sta tmp6+1
.(	
loop
	iny
	sty Savy+1
	lda (tmp6),y
	jsr LoadObjectToGame
Savy
	ldy #0
	dec tmp4
	bne loop
.)	
	
noobjects
	
	; Here comes the room name, TODO: ignore it for now

	; Update the drawing queue
	jsr UpdateDrawingQueue

	; Install the entry script
	ldx _EntryScript
	cpx #$ff
	beq finish
	; Params: reg X=script ID, Y=parent
	ldy #$ff	
	jsr LoadAndInstallScript
	jmp RunThreadOnce
finish	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Loop for automatic actions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AnimateCharacters
.(
	lda #MAX_OBJECTS-1
	sta tmp6
loop
	ldx tmp6 ; Get next character to deal with.
	;jsr must_move
	lda nFrameCount
	and anim_speed,x	
	bne skipthis
	jsr AnimateCharacter
skipthis
	; Onto the next character.
	dec tmp6 
	bpl loop
	rts
.)

AnimateCharacter
.(	
	; Step 1: If there is a subcommand active
	; jmp to it and end.
+subcommand
	lda subcom_high,x
	beq nosubcommand
	sta tmp0+1
	lda subcom_low,x
	sta tmp0
	jmp (tmp0)
nosubcommand

; Step 2: When there is no subcommand, then 
; jmp to the primary command, if exists.
+primary_command
	lda command_high,x
	beq command_completed
	sta tmp0+1
	lda command_low,x
	sta tmp0
	jmp (tmp0)
command_completed	
	rts	
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Stops all character commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
StopCharacterCommands
.(
	ldx #MAX_OBJECTS-1
	lda #0
loop
	sta command_high,x
	sta subcom_high,x
	dex
	bpl loop
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Makes a character wait for the talk queue
; to be empty
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WaitTalkQueue
.(
	lda _TalkingActor
	cmp #$ff
	bne not_empty
	; Queue is empty!
	lda var1,x
	ldy var2,x
	jmp ProceedTalk
not_empty
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Makes a character say a sentence
; Params: RegX=Character pos in array, RegA STRING resource ID
; RegY= string number inside resource
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Say
.(
	; Check if there is anyone talking
	; First check if it is me...
	cpx _TalkingActor
	beq ProceedTalk
	; Now if the talking queue is empty...
	pha
	lda _TalkingActor
	cmp #$ff
	beq preProceedTalk
	; Uh-oh someone is talking... wait 
	; This means installing the wait command
	; for this character with the data of the 
	; text resource in var1 and var2
	pla	
	sta var1,x
	tya
	sta var2,x
	lda #<WaitTalkQueue
	sta command_low,x
	lda #>WaitTalkQueue
	sta command_high,x
	rts
preProceedTalk
	pla
+ProceedTalk	
	; Signal this actor is talking
	stx _TalkingActor
	
	; Save registers
	sta savA+1
	stx savX+1
	sty savY+1
	
	; Clear speech area
	jsr ClearSpeechArea
	
	; Put cursor at top line
	lda #<$a000
	sta screen
	lda #>$a000
	sta screen+1
	
	; Put color code
#ifdef SPEECHSOUND
	lda color_speech,x
	pha
	and #$0f
	adc #SPEECHBASE
	sta smc_speechbase+1
	pla
	jsr put_code
#else
	lda color_speech,x
	jsr put_code	
#endif
	; Load text resource and print string
savA
	ldx #0
savY	
	lda #0	
	jsr LoadAndPrintString
#ifdef SPEECHSOUND	
	jsr SpeakSentence
#endif
	; Get back X with character ID
	; and install the command to make it talk
savX
	ldx #0 
#ifdef SPEECHSOUND	
	; Store the SFX channel, returned by _PlaySFX in SpeakSentence :)
	sta var1,x
#endif	
	; Install the timer for talking duration
	lda #<timed_talk
	sta command_low,x
	lda #>timed_talk
	sta command_high,x

#ifndef SPEECHSOUND
	; Use the half of the string length as timer
	lda last_nchars_printed  
	;asl
	
	lsr
	lsr
	lsr
	tay
	lda saytime,y
	sta var1,x 
	
	; Patch possible delays when loading resources
	lda #0
	sta LastFrameTime
#endif
	jmp TalkCharacter
	
	; Decrement timer. If zero finish speaking, else
	; get back to TalkCharacter
timed_talk	
#ifdef SPEECHSOUND	
	ldy var1,x
	lda SFX_Sounding,y
	cmp #$ff
	beq end
	lda anim_state,x
	cmp #TALK_FRONT
	beq skip
	cmp #TALK_RIGHT
	beq skip
	lda IsResting,y
	beq skip
	rts
skip
#else
	lda var1,x	
	sec
	sbc LastFrameTime
	bpl noadj
	lda #0
noadj
	sta var1,x
	beq end	
#endif
	jmp TalkCharacter
end
	; Finished talking: clear area
	; set _TalkingActor to none ($ff)
	; and stop command
	jsr ClearSpeechArea
	lda #0
	sta command_high,x
	lda #$ff
	sta _TalkingActor
	; Set the correct animstate
	lda direction,x 
	jmp LookDirection_forced
.)

; saytime .byt 14+4,20+4,30+4,35+4,40+4	; Default is normal speed

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Starts character movement to a given position
; Params: RegA=col, RegY=row, RegX=Character pos in array
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WalkTo
.(
	stx savX+1

	; Store complete destination in var3,var4
	; If col is $fe it means any, so put the current
	; one the actor is in
	cmp #$fe
	bne skipthis2
	lda pos_col,x
skipthis2	
	sta var3,x
	pha

	; If row is $fe it means any, 
	; so put the current one the actor is in
	cpy #$fe
	bne skipthis
	lda pos_row,x
	tay
skipthis	
	tya 
	sta var4,x 
	pla
	
	; Now get the next sub-destination, depending
	; on all the walkbox data and matrices...
	sty dest_row
	sta dest_col
	lda pos_row,x
	sta orig_row
	lda pos_col,x
	sta orig_col
	
	jsr getWalkCoordinates
	txa
savX
	ldx #0
	; Store partial destination in var1,var2
	sta var1,x
	tya 
	sta var2,x

	bcc notimpossible
	; Patch complete destination, as getWalkCoordinates
	; returned Carry set
	lda var1,x
	sta var3,x
	lda var2,x
	sta var4,x
notimpossible

	; Ensure character is not talking or doing
	; anything which requires additiona animatory
	; states, so the calculation of the next state at
	; each step is correct.
	lda direction,x 
	jsr LookDirection_forced

	; Install command
	lda #<MoveTo
	sta command_low,x
	lda #>MoveTo
	sta command_high,x
	rts 
MoveTo
	; Divide in subcommands. First make col equal destination.
	lda pos_col,x 
	cmp var1,x
	beq colmatches
	
	lda #0
	sta stride_step,x

	
	lda #<GetCharToCol
	sta subcom_low,x 
	lda #>GetCharToCol
	sta subcom_high,x
	rts 
colmatches
	; Now the row
	lda pos_row,x 
	cmp var2,x
	beq rowmatches
	lda #<GetCharToRow
	sta subcom_low,x 
	lda #>GetCharToRow
	sta subcom_high,x
	rts 
rowmatches
	; Partial destination reached... Now check full and
	; call this again if not yet done!
	lda pos_col,x
	cmp var3,x
	bne notyet
	lda pos_row,x
	cmp var4,x
	bne notyet
	; Done. De-activate command
	lda #0
	sta command_high,x 
/*	
	; Set the character facing down/up
	lda direction,x
	cmp #FACING_UP
	beq skipme
	lda #FACING_DOWN
	jmp LookDirection
skipme	
*/
	rts
notyet	
	; The character arrived at a new walkbox
	lda var3,x
	ldy var4,x
	jmp WalkTo
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subcommand to get a character walk
; to a given row in var2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetCharToRow
.(
	lda pos_row,x 
	cmp var2,x
	bne notthere
	lda anim_state,x 
	cmp #LOOK_BACK
	beq there
	cmp #LOOK_FRONT
	bne dowalk
there 
	; Arrived, stop subcommand and return
	lda #0
	sta subcom_high,x 
	rts
notthere 
	bcs goup 
	; We have to go down
	lda #FACING_DOWN  
lookthere	
	cmp direction,x
	beq dowalk
	jmp LookDirection
goup 	
	lda #FACING_UP 
	bne lookthere ; Always jumps
dowalk
	jsr StepCharacterUD
	jmp UpdateCharZPlane
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subcommand to get a character walk
; to a given col in Var1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetCharToCol 
.(
	lda pos_col,x 
	cmp var1,x
	bne notthere
	;lda #LOOK_RIGHT
	;cmp anim_state,x
	;bne dowalk 
	
	; Arrived, stop subcommand and return
	lda #LOOK_RIGHT
	jsr UpdateAnimstate
	
	lda #0
	sta subcom_high,x 
	rts
notthere 
	bcs goleft
	; We have to go rigth 
	lda #FACING_RIGHT    
lookthere	
	cmp direction,x
	beq dowalk
	jmp LookDirection
goleft  	
	lda #FACING_LEFT  
	bne lookthere ; Always jumps
dowalk
	jsr StepCharacter
	; jmp UpdateCharZPlane ; Let the program flow...
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update the zplane for this character
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateCharZPlane
.(
	; META: Maybe this could be optimized so it is only 
	; ran if the character is in a different wb
	; but this requires yet another var.
	; Maybe calculating at each step is not *that* expensive
	
	jsr getWalkBoxForCharacter
	bcs skip	; This should not happen!!!
	
	lda #%00011111
	and z_plane,x
	sta tmp
	ldy #4 ; flags and zplane
	lda (tmp0),y
	and #%111
	asl
	asl
	asl
	asl
	asl
	ora tmp
	sta z_plane,x
skip	
	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Routines for scrolling the screen right
; and left one tile
; Returns Z=1 if limit reached
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#ifdef FASTSCROLLS



#define TOP 0
#define FIRST_COL 2

scroll_loop
.(
+smc_orgscan
	ldx #39-3
+smc_destscan
	ldy #39-2
loop
	lda 40*0+(DUMP_ADDRESS),x
	sta 40*0+(DUMP_ADDRESS),y
	lda 40*1+(DUMP_ADDRESS),x
	sta 40*1+(DUMP_ADDRESS),y
	lda 40*2+(DUMP_ADDRESS),x
	sta 40*2+(DUMP_ADDRESS),y
	lda 40*3+(DUMP_ADDRESS),x
	sta 40*3+(DUMP_ADDRESS),y
	lda 40*4+(DUMP_ADDRESS),x
	sta 40*4+(DUMP_ADDRESS),y
	lda 40*5+(DUMP_ADDRESS),x
	sta 40*5+(DUMP_ADDRESS),y
	lda 40*6+(DUMP_ADDRESS),x
	sta 40*6+(DUMP_ADDRESS),y
	lda 40*7+(DUMP_ADDRESS),x
	sta 40*7+(DUMP_ADDRESS),y
	lda 40*8+(DUMP_ADDRESS),x
	sta 40*8+(DUMP_ADDRESS),y
	lda 40*9+(DUMP_ADDRESS),x
	sta 40*9+(DUMP_ADDRESS),y
	lda 40*10+(DUMP_ADDRESS),x
	sta 40*10+(DUMP_ADDRESS),y
	lda 40*11+(DUMP_ADDRESS),x
	sta 40*11+(DUMP_ADDRESS),y
	lda 40*12+(DUMP_ADDRESS),x
	sta 40*12+(DUMP_ADDRESS),y
	lda 40*13+(DUMP_ADDRESS),x
	sta 40*13+(DUMP_ADDRESS),y
	lda 40*14+(DUMP_ADDRESS),x
	sta 40*14+(DUMP_ADDRESS),y
	lda 40*15+(DUMP_ADDRESS),x
	sta 40*15+(DUMP_ADDRESS),y
	lda 40*16+(DUMP_ADDRESS),x
	sta 40*16+(DUMP_ADDRESS),y
	lda 40*17+(DUMP_ADDRESS),x
	sta 40*17+(DUMP_ADDRESS),y
	lda 40*18+(DUMP_ADDRESS),x
	sta 40*18+(DUMP_ADDRESS),y
	lda 40*19+(DUMP_ADDRESS),x
	sta 40*19+(DUMP_ADDRESS),y
	lda 40*20+(DUMP_ADDRESS),x
	sta 40*20+(DUMP_ADDRESS),y
	lda 40*21+(DUMP_ADDRESS),x
	sta 40*21+(DUMP_ADDRESS),y
	lda 40*22+(DUMP_ADDRESS),x
	sta 40*22+(DUMP_ADDRESS),y
	lda 40*23+(DUMP_ADDRESS),x
	sta 40*23+(DUMP_ADDRESS),y
	lda 40*24+(DUMP_ADDRESS),x
	sta 40*24+(DUMP_ADDRESS),y
	lda 40*25+(DUMP_ADDRESS),x
	sta 40*25+(DUMP_ADDRESS),y
	lda 40*26+(DUMP_ADDRESS),x
	sta 40*26+(DUMP_ADDRESS),y
	lda 40*27+(DUMP_ADDRESS),x
	sta 40*27+(DUMP_ADDRESS),y
	lda 40*28+(DUMP_ADDRESS),x
	sta 40*28+(DUMP_ADDRESS),y
	lda 40*29+(DUMP_ADDRESS),x
	sta 40*29+(DUMP_ADDRESS),y
	lda 40*30+(DUMP_ADDRESS),x
	sta 40*30+(DUMP_ADDRESS),y
	lda 40*31+(DUMP_ADDRESS),x
	sta 40*31+(DUMP_ADDRESS),y
	lda 40*32+(DUMP_ADDRESS),x
	sta 40*32+(DUMP_ADDRESS),y
	lda 40*33+(DUMP_ADDRESS),x
	sta 40*33+(DUMP_ADDRESS),y
	lda 40*34+(DUMP_ADDRESS),x
	sta 40*34+(DUMP_ADDRESS),y
	lda 40*35+(DUMP_ADDRESS),x
	sta 40*35+(DUMP_ADDRESS),y
	lda 40*36+(DUMP_ADDRESS),x
	sta 40*36+(DUMP_ADDRESS),y
	lda 40*37+(DUMP_ADDRESS),x
	sta 40*37+(DUMP_ADDRESS),y
	lda 40*38+(DUMP_ADDRESS),x
	sta 40*38+(DUMP_ADDRESS),y
	lda 40*39+(DUMP_ADDRESS),x
	sta 40*39+(DUMP_ADDRESS),y
	lda 40*40+(DUMP_ADDRESS),x
	sta 40*40+(DUMP_ADDRESS),y
	lda 40*41+(DUMP_ADDRESS),x
	sta 40*41+(DUMP_ADDRESS),y
	lda 40*42+(DUMP_ADDRESS),x
	sta 40*42+(DUMP_ADDRESS),y
	lda 40*43+(DUMP_ADDRESS),x
	sta 40*43+(DUMP_ADDRESS),y
	lda 40*44+(DUMP_ADDRESS),x
	sta 40*44+(DUMP_ADDRESS),y
	lda 40*45+(DUMP_ADDRESS),x
	sta 40*45+(DUMP_ADDRESS),y
	lda 40*46+(DUMP_ADDRESS),x
	sta 40*46+(DUMP_ADDRESS),y
	lda 40*47+(DUMP_ADDRESS),x
	sta 40*47+(DUMP_ADDRESS),y
	lda 40*48+(DUMP_ADDRESS),x
	sta 40*48+(DUMP_ADDRESS),y
	lda 40*49+(DUMP_ADDRESS),x
	sta 40*49+(DUMP_ADDRESS),y
	lda 40*50+(DUMP_ADDRESS),x
	sta 40*50+(DUMP_ADDRESS),y
	lda 40*51+(DUMP_ADDRESS),x
	sta 40*51+(DUMP_ADDRESS),y
	lda 40*52+(DUMP_ADDRESS),x
	sta 40*52+(DUMP_ADDRESS),y
	lda 40*53+(DUMP_ADDRESS),x
	sta 40*53+(DUMP_ADDRESS),y
	lda 40*54+(DUMP_ADDRESS),x
	sta 40*54+(DUMP_ADDRESS),y
	lda 40*55+(DUMP_ADDRESS),x
	sta 40*55+(DUMP_ADDRESS),y
	lda 40*56+(DUMP_ADDRESS),x
	sta 40*56+(DUMP_ADDRESS),y
	lda 40*57+(DUMP_ADDRESS),x
	sta 40*57+(DUMP_ADDRESS),y
	lda 40*58+(DUMP_ADDRESS),x
	sta 40*58+(DUMP_ADDRESS),y
	lda 40*59+(DUMP_ADDRESS),x
	sta 40*59+(DUMP_ADDRESS),y
	lda 40*60+(DUMP_ADDRESS),x
	sta 40*60+(DUMP_ADDRESS),y
	lda 40*61+(DUMP_ADDRESS),x
	sta 40*61+(DUMP_ADDRESS),y
	lda 40*62+(DUMP_ADDRESS),x
	sta 40*62+(DUMP_ADDRESS),y
	lda 40*63+(DUMP_ADDRESS),x
	sta 40*63+(DUMP_ADDRESS),y
	lda 40*64+(DUMP_ADDRESS),x
	sta 40*64+(DUMP_ADDRESS),y
	lda 40*65+(DUMP_ADDRESS),x
	sta 40*65+(DUMP_ADDRESS),y
	lda 40*66+(DUMP_ADDRESS),x
	sta 40*66+(DUMP_ADDRESS),y
	lda 40*67+(DUMP_ADDRESS),x
	sta 40*67+(DUMP_ADDRESS),y
	lda 40*68+(DUMP_ADDRESS),x
	sta 40*68+(DUMP_ADDRESS),y
	lda 40*69+(DUMP_ADDRESS),x
	sta 40*69+(DUMP_ADDRESS),y
	lda 40*70+(DUMP_ADDRESS),x
	sta 40*70+(DUMP_ADDRESS),y
	lda 40*71+(DUMP_ADDRESS),x
	sta 40*71+(DUMP_ADDRESS),y
	lda 40*72+(DUMP_ADDRESS),x
	sta 40*72+(DUMP_ADDRESS),y
	lda 40*73+(DUMP_ADDRESS),x
	sta 40*73+(DUMP_ADDRESS),y
	lda 40*74+(DUMP_ADDRESS),x
	sta 40*74+(DUMP_ADDRESS),y
	lda 40*75+(DUMP_ADDRESS),x
	sta 40*75+(DUMP_ADDRESS),y
	lda 40*76+(DUMP_ADDRESS),x
	sta 40*76+(DUMP_ADDRESS),y
	lda 40*77+(DUMP_ADDRESS),x
	sta 40*77+(DUMP_ADDRESS),y
	lda 40*78+(DUMP_ADDRESS),x
	sta 40*78+(DUMP_ADDRESS),y
	lda 40*79+(DUMP_ADDRESS),x
	sta 40*79+(DUMP_ADDRESS),y
	lda 40*80+(DUMP_ADDRESS),x
	sta 40*80+(DUMP_ADDRESS),y
	lda 40*81+(DUMP_ADDRESS),x
	sta 40*81+(DUMP_ADDRESS),y
	lda 40*82+(DUMP_ADDRESS),x
	sta 40*82+(DUMP_ADDRESS),y
	lda 40*83+(DUMP_ADDRESS),x
	sta 40*83+(DUMP_ADDRESS),y
	lda 40*84+(DUMP_ADDRESS),x
	sta 40*84+(DUMP_ADDRESS),y
	lda 40*85+(DUMP_ADDRESS),x
	sta 40*85+(DUMP_ADDRESS),y
	lda 40*86+(DUMP_ADDRESS),x
	sta 40*86+(DUMP_ADDRESS),y
	lda 40*87+(DUMP_ADDRESS),x
	sta 40*87+(DUMP_ADDRESS),y
	lda 40*88+(DUMP_ADDRESS),x
	sta 40*88+(DUMP_ADDRESS),y
	lda 40*89+(DUMP_ADDRESS),x
	sta 40*89+(DUMP_ADDRESS),y
	lda 40*90+(DUMP_ADDRESS),x
	sta 40*90+(DUMP_ADDRESS),y
	lda 40*91+(DUMP_ADDRESS),x
	sta 40*91+(DUMP_ADDRESS),y
	lda 40*92+(DUMP_ADDRESS),x
	sta 40*92+(DUMP_ADDRESS),y
	lda 40*93+(DUMP_ADDRESS),x
	sta 40*93+(DUMP_ADDRESS),y
	lda 40*94+(DUMP_ADDRESS),x
	sta 40*94+(DUMP_ADDRESS),y
	lda 40*95+(DUMP_ADDRESS),x
	sta 40*95+(DUMP_ADDRESS),y
	lda 40*96+(DUMP_ADDRESS),x
	sta 40*96+(DUMP_ADDRESS),y
	lda 40*97+(DUMP_ADDRESS),x
	sta 40*97+(DUMP_ADDRESS),y
	lda 40*98+(DUMP_ADDRESS),x
	sta 40*98+(DUMP_ADDRESS),y
	lda 40*99+(DUMP_ADDRESS),x
	sta 40*99+(DUMP_ADDRESS),y
	lda 40*100+(DUMP_ADDRESS),x
	sta 40*100+(DUMP_ADDRESS),y
	lda 40*101+(DUMP_ADDRESS),x
	sta 40*101+(DUMP_ADDRESS),y
	lda 40*102+(DUMP_ADDRESS),x
	sta 40*102+(DUMP_ADDRESS),y
	lda 40*103+(DUMP_ADDRESS),x
	sta 40*103+(DUMP_ADDRESS),y
	lda 40*104+(DUMP_ADDRESS),x
	sta 40*104+(DUMP_ADDRESS),y
	lda 40*105+(DUMP_ADDRESS),x
	sta 40*105+(DUMP_ADDRESS),y
	lda 40*106+(DUMP_ADDRESS),x
	sta 40*106+(DUMP_ADDRESS),y
	lda 40*107+(DUMP_ADDRESS),x
	sta 40*107+(DUMP_ADDRESS),y
	lda 40*108+(DUMP_ADDRESS),x
	sta 40*108+(DUMP_ADDRESS),y
	lda 40*109+(DUMP_ADDRESS),x
	sta 40*109+(DUMP_ADDRESS),y
	lda 40*110+(DUMP_ADDRESS),x
	sta 40*110+(DUMP_ADDRESS),y
	lda 40*111+(DUMP_ADDRESS),x
	sta 40*111+(DUMP_ADDRESS),y
	lda 40*112+(DUMP_ADDRESS),x
	sta 40*112+(DUMP_ADDRESS),y
	lda 40*113+(DUMP_ADDRESS),x
	sta 40*113+(DUMP_ADDRESS),y
	lda 40*114+(DUMP_ADDRESS),x
	sta 40*114+(DUMP_ADDRESS),y
	lda 40*115+(DUMP_ADDRESS),x
	sta 40*115+(DUMP_ADDRESS),y
	lda 40*116+(DUMP_ADDRESS),x
	sta 40*116+(DUMP_ADDRESS),y
	lda 40*117+(DUMP_ADDRESS),x
	sta 40*117+(DUMP_ADDRESS),y
	lda 40*118+(DUMP_ADDRESS),x
	sta 40*118+(DUMP_ADDRESS),y
	lda 40*119+(DUMP_ADDRESS),x
	sta 40*119+(DUMP_ADDRESS),y
	lda 40*120+(DUMP_ADDRESS),x
	sta 40*120+(DUMP_ADDRESS),y
	lda 40*121+(DUMP_ADDRESS),x
	sta 40*121+(DUMP_ADDRESS),y
	lda 40*122+(DUMP_ADDRESS),x
	sta 40*122+(DUMP_ADDRESS),y
	lda 40*123+(DUMP_ADDRESS),x
	sta 40*123+(DUMP_ADDRESS),y
	lda 40*124+(DUMP_ADDRESS),x
	sta 40*124+(DUMP_ADDRESS),y
	lda 40*125+(DUMP_ADDRESS),x
	sta 40*125+(DUMP_ADDRESS),y
	lda 40*126+(DUMP_ADDRESS),x
	sta 40*126+(DUMP_ADDRESS),y
	lda 40*127+(DUMP_ADDRESS),x
	sta 40*127+(DUMP_ADDRESS),y
	lda 40*128+(DUMP_ADDRESS),x
	sta 40*128+(DUMP_ADDRESS),y
	lda 40*129+(DUMP_ADDRESS),x
	sta 40*129+(DUMP_ADDRESS),y
	lda 40*130+(DUMP_ADDRESS),x
	sta 40*130+(DUMP_ADDRESS),y
	lda 40*131+(DUMP_ADDRESS),x
	sta 40*131+(DUMP_ADDRESS),y
	lda 40*132+(DUMP_ADDRESS),x
	sta 40*132+(DUMP_ADDRESS),y
	lda 40*133+(DUMP_ADDRESS),x
	sta 40*133+(DUMP_ADDRESS),y
	lda 40*134+(DUMP_ADDRESS),x
	sta 40*134+(DUMP_ADDRESS),y
	lda 40*135+(DUMP_ADDRESS),x
	sta 40*135+(DUMP_ADDRESS),y

+smc_dex
	dex
+smc_dey
	dey
+smc_endscan	
	cpx #$ff
	beq end
	jmp loop
end
	rts
.)

_scroll_right
.(
	lda first_col
	cmp #($fe+1)
	bne doit
	rts
doit
	dec first_col
	; Scroll the screen data 1 scan right
	; Patch initial scan to copy
	ldx #LAST_VIS_COL-1
	stx smc_orgscan+1
	inx
	stx smc_destscan+1
	; Patch inx/iny or dex/dey
	ldx #$ca ; dex opcode
	stx smc_dex
	ldx #$88 ; dey opcode
	stx smc_dey
	; Patch cpx value
	ldx #(FIRST_VIS_COL-1)
	stx smc_endscan+1
	jsr scroll_loop
	
	; Update the SRB
	ldx #((ROOM_ROWS-1)*5)
	lda #%01000000 ;%00100000
loop3
	sta SRB,x
	dex
	dex
	dex
	dex
	dex
	bpl loop3

	; Call the redrawing...
+redraw_and_retNZ	
	lda #1
	rts
.)



_scroll_left
.(
	lda first_col
	clc
	adc #VISIBLE_COLS
	adc #2-1
	cmp nRoomCols
	bcc doit
	lda #0
	rts
doit
	inc first_col
	; Scroll the screen data 1 scan left
	; Patch initial scan to copy
	ldx #FIRST_VIS_COL+1
	stx smc_orgscan+1
	dex
	stx smc_destscan+1
	; Patch inx/iny or dex/dey
	ldx #$e8 ; inx opcode
	stx smc_dex
	ldx #$c8 ; iny opcode
	stx smc_dey
	; Patch cpx value
	ldx #(LAST_VIS_COL+1)
	stx smc_endscan+1
	jsr scroll_loop

	; Update the SRB
	ldx #((ROOM_ROWS-1)*5+4)
	lda #%00000010;%00000100
loop3
	sta SRB,x
	dex
	dex
	dex
	dex
	dex
	bpl loop3

	; Call the redrawing...
	jmp redraw_and_retNZ	
.)

#else

_scroll_right
.(
	lda first_col
	bne doit
	rts
doit
	dec first_col
	; Scroll the screen data 1 scan right
	ldx #(ROOM_ROWS*8)
	lda #<(DUMP_ADDRESS+2)
	sta smc_sp1+1
	lda #<(DUMP_ADDRESS+3)
	sta smc_sp2+1
	lda #>(DUMP_ADDRESS)
	sta smc_sp1+2
	sta smc_sp2+2
loop1
	ldy #VISIBLE_COLS-2
loop2
smc_sp1
	lda $1234,y
smc_sp2
	sta $1234,y
	dey
	bpl loop2


	lda smc_sp1+1
	clc
	adc #40
	sta smc_sp1+1
	bcc skip1
	inc smc_sp1+2
	clc
skip1
	lda smc_sp2+1
	adc #40
	sta smc_sp2+1
	bcc skip
	inc smc_sp2+2
skip

	dex
	bne loop1


	; Update the SRB
	ldx #((ROOM_ROWS-1)*5)
loop3
	lda #%00100000
	sta SRB,x
	dex
	dex
	dex
	dex
	dex
	bpl loop3

	; Call the redrawing...
+redraw_and_retNZ	
	;jsr RenderScreen
	lda #1
	rts
.)


_scroll_left
.(
	lda nRoomCols
	sec
	sbc #VISIBLE_COLS
	sbc #3
	cmp first_col
	;lda first_col
	;cmp #(nRoomCols-VISIBLE_COLS-2)
	;bcc doit
	bcs doit
	lda #0
	rts
doit
	inc first_col
	; Scroll the screen data 1 scan left
	ldx #(ROOM_ROWS*8)
	lda #<(DUMP_ADDRESS+3)
	sta smc_sp1+1
	lda #<(DUMP_ADDRESS+2)
	sta smc_sp2+1
	lda #>(DUMP_ADDRESS)
	sta smc_sp1+2
	sta smc_sp2+2
loop1
	ldy #0
loop2
smc_sp1
	lda $1234,y
smc_sp2
	sta $1234,y
	iny
	cpy #(LAST_VIS_COL-2)
	bcc loop2

	lda smc_sp1+1
	clc
	adc #40
	sta smc_sp1+1
	bcc skip1
	inc smc_sp1+2
	clc
skip1
	lda smc_sp2+1
	clc
	adc #40
	sta smc_sp2+1
	bcc skip
	inc smc_sp2+2
skip

	dex
	bne loop1


	; Update the SRB
	ldx #((ROOM_ROWS-1)*5+4)
loop3
	lda #%00000100
	sta SRB,x
	dex
	dex
	dex
	dex
	dex
	bpl loop3

	; Call the redrawing...
	jmp redraw_and_retNZ
.)

#endif

		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Changes the direction a character
; is facing - TODO: TEMPORAL	
; Params: regX=character code	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
change_direction
.(
	; Change the direction
	
	lda #FACING_LEFT
	cmp direction,x
	beq wasleft
	lda #FACING_LEFT
	.byt $2c
wasleft	
	lda #FACING_RIGHT
	sta direction,x
	rts
.)
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Makes a character face a given
; direction
; Params: regX=character code
;         regA=direction FACING_XXX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Table to relate directions and animatory states... moved to tables.s
; FACING_RIGHT, FACING_LEFT, FACING_UP, FACING_DOWN
;tab_dirs_as .byt LOOK_RIGHT,LOOK_RIGHT,LOOK_BACK,LOOK_FRONT
LookDirection
.(
#ifdef DOCHECKS_A
	cmp #4
	bcc okcheck
	rts
okcheck
#endif
	cmp direction,x
	bne doit
	rts
doit	
; Entry point avoiding checks
+LookDirection_forced
	pha
	jsr UpdateSRBsp
	pla
	sta direction,x
	tay
	lda tab_dirs_as,y
	jmp UpdateAnimstate2
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update anim state (passed in A) for the 
; character passed in X and also update SRB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateAnimstate
.(
#ifdef DOCHECKS_A
	cmp #16
	bcc okcheck
	rts
okcheck
#endif
	pha
	jsr IfInRoomUpdateSRBsp
	pla
+UpdateAnimstate2
	; Store the new animatory state
	sta anim_state,x
	; Update pointers to animatory state
	; Base+offset which is anim_state*24
	tay 
	clc
	lda base_as_pointer_low,x
	adc tab_animstate_offsets_lo,y
	sta as_pointer_low,x
	lda base_as_pointer_high,x
	adc tab_animstate_offsets_hi,y
	sta as_pointer_high,x

	; Update the SRB for this character
	; This is needed as it may be called for objects which
	; are not in this room, if pointers to costumes are updated
	/*lda room,x
	cmp _CurrentRoom
	bne skip
	jmp UpdateSRBsp*/
	jmp IfInRoomUpdateSRBsp
skip
	rts
.)


SetRoomPalette
.(
	lda pPalette
	ora pPalette+1
	bne doit
	jmp SetInk2	; Default AIC palette
doit
	lda #<(DUMP_ADDRESS/*+1*/)
	sta tmp
	lda #>(DUMP_ADDRESS/*+1*/)
	sta tmp+1

	lda pPalette
	sta smcp+1
	lda pPalette+1
	sta smcp+2
	
	ldy #0
	ldx #0
loop
smcp
	lda $1234,x
	sta (tmp),y
	
	jsr add40tmp
	inx
	cpx #(ROOM_ROWS*8)
	bne loop
	
	rts
.)


SetBWPalette
.(
	lda smc_ink_1+1
	pha
	lda smc_ink_2+1
	pha

	lda #A_FWWHITE
	sta smc_ink_1+1
	sta smc_ink_2+1
	jsr SetInk2

	pla
	sta smc_ink_2+1
	pla
	sta smc_ink_1+1
	rts
.)


#ifdef SPEECHSOUND
; Buffer for sfx definition
#define sfx_speech $BFE0 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Creates a sfx pattern based on 
; the text pointed to in 
; pointer2string
; Through the sources a word means 
; an independent sound, more like a syllable
; it is generated after 4 chars or 
; a special char (space, fullstop..)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SpeakSentence
.(
	; Store pointer in tmp0
	lda pointer2string
	sta tmp0
	lda pointer2string+1
	sta tmp0+1
	
	; Prepare pattern index (tmp), 
	; char index (Y)
	; and char count (X)
	; in tmp+1 we'll store the length
	; of the pause.
	ldx #0
	ldy #0
	sty tmp
loop
	; No extra length in pause, by default
	lda #0
	sta tmp+1
	; Check next char
	lda (tmp0),y
	beq end
	cmp #" "
	beq isspace	; A space generates a new word/sylable
	cmp #"."	; A full stop generates a long rest
	beq longrest
	cmp #"!"
	beq longrest
	cmp #":"
	beq longrest
	cmp #"?"	; A question mark generates a higher pitch sound
	bne notqm
	lda #15		; Load pitch value for question mark
	jsr endword2 	; generate a word
	jmp rest	; generate a rest and continue
notqm
	; Not a special symbol
	; If we had 4 chars in a row, generate a word
	inx
	cpx #4
	bne nextchar
	jsr endword
	jmp nextchar
longrest
	; Generate a long rest (a full stop)
	; by setting tmp+1 (which will be added to the RST command),
	; generating a new word (a fullstop follows a word)
	; and generating a rest
	; The last two are the same as when we detect a space
	lda #2
	sta tmp+1
isspace
	; There is a space (or full-stop), so get the value
	; of the char just before, and generate a word with it.
	; META: Beware with strings starting with spaces!!!
	; They will get rubbish!!
	dey
	lda (tmp0),y
	iny
	jsr endword
rest	
	; Generate a pause. This is a SIL command and a RST command
	ldx tmp
	lda #$a0	;SIL command
	sta sfx_speech,x
	lda #$90	;RST command
	; Add the value in tmp+1 for implementing long rests
	clc
	adc tmp+1
	sta sfx_speech+1,x
	inc tmp
	inc tmp
	
	; Restart char count
	ldx #0
nextchar
	; Safeguard not to exceed the 32 byte buffer...
	lda tmp
	cmp #29
	beq end
	iny
	bne loop	; Should never exit here...
end
	; If we arrive here, sentence is finished (string[Y] is 0)
	; If we have X<>0, we have to generate a new word
	; with the previous char.
	cpx #0
	beq endcommand
	dey
	lda (tmp0),y
	jsr endword
endcommand
	; Put an end command in the pattern list
	lda #$80
	ldx tmp
	sta sfx_speech,x
	
	; Play the generated SFX
	lda #SFX_SPEECH
	jmp _PlaySfx 
.)	

; Auxiliar function that generates a new word.
; two entry points, one checks if A (current char)
; is a "." to avoid doing anything and gets the 
; lower bits as value.
; the second entry point considers A precharged 
; with the correct value.
endword
.(
	cmp #"."
	beq end
	and #$07
+endword2	
	; Load index in pattern list
	ldx tmp
	; Add a base to the sfx note
+smc_speechbase	
	adc #SPEECHBASE
	; Store in pattern list
	sta sfx_speech,x
	inc tmp
end	
	; Restart char count (X)
	ldx #0	
	rts
.)
#endif

