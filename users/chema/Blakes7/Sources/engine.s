
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Graphic engine routines
#include "params.h"
#include "object.h"
#include "resource.h"


; The next define should be in params.h but for some reason it does not work if put there...
#define DUMP_ADDRESS ($a000+40*8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initializes the engine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InitEngine
.(
	; No room loaded, no ego, ...
	lda #$ff
	sta _CurrentRoom
	sta _CurrentEgo
	sta _TalkingActor
	sta actor_following
	
	
	; No active Objects
	lda #0
	sta nActiveObjects
	; Reset frame counter
	sta nFrameCount
	; Reset Engine events
	sta _EngineEvents
	; Not in dialog mode
	sta InDialogMode
	; Not in pause mode
	sta InPause
	; Verbs and inventory now shown
	sta VerbsShown
	; Camera inactive
	sta camera_command_hi
			
	; Set first visible column
	lda #($fe+1)
	sta first_col
	
	; Set all the object data entries to empty
	ldx #MAX_OBJECTS-1
	lda #OBJ_EMPTY_ENTRY
loop
	sta obj_id,x
	dex
	bpl loop
	
	; Initialize threads
	jsr InitializeThreads
	
	; Set resource memory as empty;
	lda #RESOURCE_NULL
	sta __resource_memory_start+0
	lda #<(RESOURCE_TOP-__resource_memory_start)
	sta __resource_memory_start+1
	lda #>(RESOURCE_TOP-__resource_memory_start)
	sta __resource_memory_start+2	
	
	; Clear memory space
	ldx #SIZE_GLOBAL_VARS
	lda #0
loopvars
	sta _VARS-1,x
	dex
	bne loopvars
	
	ldx #SIZE_GLOBAL_FLAGS/8
	lda #0
loopflags
	sta _FLAGS-1,x
	dex
	bne loopflags

	; Clear local memory space
#if MAX_THREADS*LSPACE_S <> 256
#error Local space changed change clearing loop
#endif	
	ldx #0
	lda #0
looplo	
	sta _LSPACE,x
	dex
	bne looplo
	
	; Let the program flow to ZeroSRB
	;rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sets all the SRB to
; zero. Used in initialization
; and when clearing the area
; before a transition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ZeroAllSRB
.(
	ldy #ROOM_ROWS*5-1
	lda #0
loop
	sta SRB,y
	dey
	bpl loop
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clears the SBR but keeping the
; protected columns in left/right
; untouched.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearAllSRB
.(
	ldy #ROOM_ROWS-1
	ldx #0
loop
	lda #$7f ;3f
	sta SRB,x
	lda #$ff
	sta SRB+1,x
	sta SRB+2,x
	sta SRB+3,x
	lda #$fe ;fc
	sta SRB+4,x	
	;txa
	;clc
	;adc #5
	;tax
	inx
	inx
	inx
	inx
	inx
	dey
	bpl loop
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character talk (animation)
; Params: regX=character ID
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TalkCharacter
.(
	lda direction,x
	cmp #FACING_UP
	bne doit
	rts
doit	
	cmp #FACING_DOWN
	bne lateral_talk
	; Looking at us
	lda anim_state,x
	cmp #TALK_FRONT
	beq phase2
	lda #TALK_FRONT
	.byt $2c
phase2
	lda #LOOK_FRONT
	jmp UpdateAnimstate
lateral_talk
	; Looking left or right
	lda anim_state,x
	cmp #TALK_RIGHT
	beq phase2l
	lda #TALK_RIGHT
	.byt $2c
phase2l
	lda #LOOK_RIGHT
	jmp UpdateAnimstate
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Perform the stepping for character passed in reg X
; This routine is specialized for up/down movement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
StepCharacterUD
.(
	jsr UpdateSRBsp

	ldy anim_state,x
	iny
	lda direction,x
	cmp #FACING_UP
	beq facing_up
#ifdef DOCHECKS_A
	cmp #FACING_DOWN
	beq okcheck
	rts
okcheck
#endif
	; Character is facing down
	; Check if at the end of the animation loop
	cpy #WALK_DOWN_2+1
	bne incp

	; At the end of the animation loop, get back
	; to original.
	lda #LOOK_FRONT
	bne laststep ; Always jumps
	;jsr UpdateAnimstate
	;jmp end
	
facing_up
	; Character is facing up
	; Check if at the end of the animation loop
	cpy #WALK_UP_2+1
	bne incp

	; At the end of the animation loop, get back
	; to original, in this case 0
	lda #LOOK_BACK
laststep	
	jsr UpdateAnimstate
	jmp end
	
	; We are not at the end of animation loop. Just increment pointers
incp	
	inc anim_state,x
	lda as_pointer_low,x
	clc
	adc #35
	sta as_pointer_low,x
	bcc nocarry
	inc as_pointer_high,x
nocarry

end
	; Now check if it is the correct time to move
	lda anim_state,x
	ldy direction,x
	cpy #FACING_UP
	beq facing_up_2

	cmp #WALK_DOWN_1
	bne nochangepos
	inc pos_row,x
	jmp UpdateSRBsp
facing_up_2	
	cmp #LOOK_BACK 
	bne nochangepos
	dec pos_row,x
	jmp UpdateSRBsp
nochangepos	
.(
	stx savx+1
	lda #0
	jsr _PlaySfx
skipsfx	
savx
	ldx #0
.)		
	jmp UpdateSRBsp
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Perform the stepping for character passed in reg X
; This routine is specialized for left/right movement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Table for handling steps moved to tables.s
;step_anim .byt WALK_RIGHT_2, WALK_RIGHT_1, WALK_RIGHT_2, WALK_RIGHT_3
;step_inc  .byt 1, 0, 1, 0

StepCharacter
.(
.(
	stx savx+1
	lda stride_step,x
	lsr
	bcs skipsfx
	lda #0
	jsr _PlaySfx
skipsfx	
savx
	ldx #0
.)	
#ifdef DOCHECKS_A
	lda direction,x
	cmp #FACING_RIGHT
	beq okcheck
	cmp #FACING_LEFT
	beq okcheck
	rts
okcheck
#endif
	jsr UpdateSRBsp

	lda stride_step,x
	clc
	adc #1
	and #%11
	sta stride_step,x
	tay
	lda step_inc,y
	beq noincpos

	; Depending on direction we increment or decrement the column
	lda direction,x
	cmp #FACING_RIGHT
	beq otherdir
	dec pos_col,x
	;bne noincpos
	jmp noincpos
otherdir
	inc pos_col,x
noincpos
	lda step_anim,y
	jmp UpdateAnimstate

.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update SRB for a sprite passed in reg X
; if it is in the current room.
; Returns with Z=1 if in current room.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IfInRoomUpdateSRBsp
.(
	lda room,x
	cmp _CurrentRoom
	beq doit
	rts
doit
	php
	jsr UpdateSRBsp
	plp 
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Updates the SRB, marking tiles which need to
; be redrawn for a given sprite (reg X), depending
; on its animatory state.
; This code is unrolled for speed.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateSRBsp
.(
	; First check if sprite is visible
	lda pos_col,x
	sec
	sbc first_col
	cmp #$FC ; (-5)
	bmi endme		
	cmp #LAST_VIS_COL+1
	bmi doit
endme
	rts
doit
	; Save col-first_col for later
	sta sav_col+1
	
	; Get the pointer to the animatoy state
	lda as_pointer_low,x
	sta tmp0
	lda as_pointer_high,x
	sta tmp0+1

	; Are we drawing mirrored?
	lda direction,x
	cmp #FACING_LEFT
	bne notmirror1
	; Yes, signal it and update tmp0
	clc
	lda #3+1
	adc tmp0
	bcc nocarrym
	inc tmp0+1
nocarrym
	sta tmp0
notmirror1	
	; Prepare pointer to SRB
	lda #0
	sta tmp+1
	lda pos_row,x
#ifdef DRAWTOPBOT
	asl
	asl
	adc pos_row,x
#else
	sec
	sbc #5+1
	sta start_row+1
	bpl noneg
	dec tmp+1
noneg	
	sta tmp
	asl
	asl
	clc
	adc tmp
	clc
#endif
	adc #<SRB
	sta smc_srbpl+1
	; If SRB is in zero page, this can be skipped
#ifndef SRB_IN_ZEROPAGE
	lda #>SRB	
	adc tmp+1
	sta smc_srbph+1
#endif
	lda #4+1	; Iterate through the 4 columns
	sta tmp
loop
	; Get pointer to SRB at the correct byte
	; and also the correct bitmask
sav_col
	lda #0
	bmi dskip
	cmp #FIRST_VIS_COL
	bcc dskip
	cmp #LAST_VIS_COL+1
	;bcs dskip
	bcc noskip

dskip 	jmp skip
noskip	
	lsr 
	lsr 
	lsr
	clc
smc_srbpl
	adc #0
	sta tmp1
	lda #0
	; If SRB is in zero page, this can be skipped
#ifndef SRB_IN_ZEROPAGE	
smc_srbph
	adc #0
#endif	
	sta tmp1+1

	lda sav_col+1
	and #%00000111
	tay
	lda tab_bit8,y
	sta tmp2

start_row
	lda #0
	bpl start_marking
	cmp #$ff
	beq skip1
	cmp #$fe
	beq skip2
	cmp #$fd
	beq skip3
	cmp #$fc
	beq skip4
	cmp #$fb
	beq skip5
	
start_marking
	ldy #0
	lda (tmp0),y
	beq skip1	; Skip if tilecode is zero

	; Mark the corresponding bit for this SRB
	;ldy #0
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y

skip1
	ldy #5
	lda (tmp0),y
	beq skip2

	; Mark the corresponding bit for this SRB
	;ldy #5
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y

skip2	
	ldy #10
	lda (tmp0),y
	beq skip3

	; Mark the corresponding bit for this SRB
	;ldy #10
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y

skip3
	ldy #15
	lda (tmp0),y
	beq skip4
	
	; Mark the corresponding bit for this SRB
	;ldy #15
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y

skip4
	ldy #20
	lda (tmp0),y
	beq skip5
	
	; Mark the corresponding bit for this SRB
	;ldy #20
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y

skip5
	ldy #25
	lda (tmp0),y
	beq skip6
	
	; Mark the corresponding bit for this SRB
	;ldy #25
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y		

skip6
	ldy #30
	lda (tmp0),y
	beq skip
	
	; Mark the corresponding bit for this SRB
	;ldy #30
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y		
	
skip
	; Again check for mirrored drawing
	lda direction,x
	cmp #FACING_LEFT
	bne notmirror
	sec
	lda tmp0
	sbc #1
	bcs nocarrydec
	dec tmp0+1
nocarrydec
	sta tmp0
	jmp nocarry
	
notmirror
	inc tmp0
	bne nocarry
	inc tmp0+1
nocarry
	inc sav_col+1
	dec tmp
	beq end
	jmp loop
end
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets the SRB bit and pointer for a given
; tile passed in A,Y (col,row) corrected
; with the scroll value.
; Returns (tmp4),y pointing to the byte
; and A with the bitmask value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getSRBforTile
.(
	; save it for a moment
	pha

	; Get pointer to the correct row of SRB
	tya
	sta tmp
	asl
	asl
	;clc
	adc tmp
	adc #<SRB
	sta tmp4
	lda #>SRB	
	adc #0
	sta tmp4+1

	; Get the correct byte of the SRB row
	pla
	pha
	lsr 
	lsr 
	lsr
	tay
	; Reg Y holds the offset of inside the SRB
	; Now get the bitmask
	pla
	and #%00000111
	tax
	lda tab_bit8,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Updates the SRB, marking the tile at coords
; X,Y as invalid
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateSRB
.(
	; Is the tile visible?
	txa
	sec
	sbc first_col
	bmi endme
	cmp #FIRST_VIS_COL
	bcc endme
	cmp #LAST_VIS_COL+1
	bmi doit
endme
	rts
doit
	; It is and the corrected coordinate is in reg A now
	jsr getSRBforTile
	ora (tmp4),y
	sta (tmp4),y
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Renders the screen, only redrawing tiles set in the SRB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RenderScreen
.(
	; Iterate through SRB checking for bits set to one
	ldx #SRB_SIZE-1
loop
	lda SRB,x
	beq skip	; If the whole byte is zero, skip (that is a usual case).
	
	ldy #8	; counter
	; start rotating the byte to search for bits set to one...
looprot
	lsr
	dey
	bcc looprot
	
	; We found the bit here, y being its position inside the byte x of the SRB
	sta sav_a+1
	sty sav_y+1
	stx sav_x+1

	; Find out the row number from the byte number (that is divide by 5)
	lda tab_div5,x
	sta vis_row

	; Find out the column number (mod 5 plus the bit number)
	sty tmp0
	lda tab_mod5,x
	clc
	adc tmp0
	sta vis_col
	adc first_col
	sta tile_col

#ifdef AVOID_JSRS
	jmp DrawRoomTile
+return_DrawRoomTile
#else
	jsr DrawRoomTile
	jsr DrawSprites
	jsr DumpBuffer
#endif


sav_y
	ldy #0
sav_x
	ldx #0
sav_a
	lda #0	
	bne looprot	; If there are more bits set to one, continue

	; No more bits, clear the SRB byte
	sta SRB,x

	; Get next byte
skip
	dex
	bpl loop


	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws the room tile (background) of coordinates
; (tile_row, tile_col) onto the backbuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Some needed zero-page vars
.zero
pRoomData 	.word 0
pRoomTileset 	.word 0
nRoomCols	.byt 0

nZPlanes	.byt 0
pZPlaneData	.dsb 4*2
pZPlaneTiles	.dsb 4*2

offsetTilecode	.word 0
pZPlaneTile	.word 0


.text
DrawRoomTile
.(
	; Get the room UDG for the tile
	lda #0
	sta tmp+1
	lda tile_col
	asl
	rol tmp+1 ; *2
	asl
	rol tmp+1 ; *4
	asl
	rol tmp+1 ; *8
	asl
	rol tmp+1 ; *16
	;clc
	adc tile_col ; *17
	bcc nocarry2
	inc tmp+1
nocarry2
	;;;;;
	sta offsetTilecode
	ldx tmp+1
	stx offsetTilecode+1
	;lda offsetTilecode
	;;;;;
	clc
	adc pRoomData	; Align data to a page to avoid this clc/adc!
	sta smc_p+1
	bcc nocarry
	inc tmp+1
nocarry	
	clc
	lda tmp+1
	adc pRoomData+1
	sta smc_p+2
	ldy tile_row
smc_p
	ldx $1200,y
	beq blank_tile	; If the room tile is blank...

	; Prepare a pointer to the UDG data. As the first
	; UDG is code 1, we want (code-1)*8, which is 
	; a 16-bit integer...
	; We can save the dex if we move the data 8 bytes
	; so we could use code*8 directly. This is done
	; in DrawSprites...

	dex
#ifdef FULLTABLEMUL8
	lda tab_mul8,x
#else	
	txa
	ldx #0
	stx tmp+1
	asl
	rol tmp+1
	asl
	rol tmp+1
	asl
	rol tmp+1
#endif
	clc
	adc pRoomTileset
	sta loop+1
	
	; We could check here if other tileset
	; is to be used (change the base pointer)

	lda pRoomTileset+1	;#>udg_room
	;clc
#ifdef FULLTABLEMUL8
	adc tab_mul8hi,x
#else	
	adc tmp+1
#endif
	sta loop+2
	
	; here it is... now copy it to the backbuffer
	ldx #7
loop
	lda $1234,x
	sta backbuffer,x
	dex
	bpl loop
#ifdef AVOID_JSRS
	jmp DrawSprites
#else
	rts
#endif

; ...we need to empty the backbuffer and set the attributes, correctly.
blank_tile
	lda #$40
	sta backbuffer+0
	sta backbuffer+1
	sta backbuffer+2
	sta backbuffer+3
	sta backbuffer+4
	sta backbuffer+5
	sta backbuffer+6
	sta backbuffer+7
#ifndef AVOID_JSRS
	rts
#endif
	
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Loops through the character list and updates the
; back buffer with the corresponding character sprite tile.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawSprites
.(
	lda tile_col
	sta smc_tilecol+1
	lda tile_row
	sta smc_tilerow+1
	
	; For ordered drawing we'd need something like:
	
	ldx nActiveObjects
	bne doit
	jmp end
doit	
	dex
	stx tmp7
loop
	; Get the object to draw
	ldx tmp7
	lda tab_objects,x	; drawing queue
	tax
	; If the object is a prop, no processing
	; is necessary (does not have a picture)
	lda flags,x
	and #OBJ_FLAG_PROP
	bne noproc
	;beq doit1
	; If it doesn't have a costume assigned,
	; it is also unnecessary.
	lda costume_id,x
	cmp #$ff
	bne doit1
noproc	
	jmp skip
doit1	
	; Check if the object overlaps the current tile
	; start with the col
smc_tilecol	
	lda #0	; tile_col
	sec
	sbc pos_col,x
	;bmi skip
	bpl doit2
	jmp skip
doit2
	cmp #4+1
	;bcs skip
	bcc doit4
	jmp skip
doit4
	sta smc_row+1

#ifdef	DRAWTOPBOT
	; now the row
smc_tilerow	
	lda #0	;tile_row
	sec
	sbc pos_row,x
	;bmi skip
	bpl doit3
	jmp skip
doit3
	cmp #6+1
	bcs skip

#else
	lda pos_row,x
	sec
smc_tilerow	
	sbc #0
	bpl doit5
	jmp skip
doit5	
	cmp #6+1
	bcc cont
	jmp skip
cont	
	sta tmp
	lda #5+1
	sec
	sbc tmp
#endif	
	; This sprite overlaps... time to draw it
	; get tile offset in reg Y
	
	; Multiply by 5 (number of columns of a sprite)
	sta op1
	asl
	asl
	;clc Carry should be clear here
	adc op1
	; Carry is clear here
smc_row
	adc #0
	
	jsr PrepZPlane
	
	tay
	
	lda direction,x
	cmp #FACING_LEFT
	beq mirror_draw_sprite
		

	; Get the UDG number
	lda as_pointer_low,x
	sta smc_udgp+1	;tmp
	lda as_pointer_high,x
	sta smc_udgp+2	;tmp tmp+1
smc_udgp
	lda $1234,y
	beq skip	; If it is 0, then don't do anything

	; Good, now get the pointer to the graphic and mask
#ifdef FULLTABLEMUL8
	tay
	lda tab_mul8hi,y
	sta tmp+1
	lda tab_mul8,y
	clc
#else
	ldy #0
	sty tmp+1	
	asl			
	rol tmp+1	
	asl			
	rol tmp+1	
	asl			
	rol tmp+1
#endif
		
	; Carry must be clear here
	pha
	adc tab_tiles_lo,x
	sta graphic_p+1
	lda tmp+1
	adc tab_tiles_hi,x
	sta graphic_p+2

	pla
	adc tab_masks_lo,x
	sta mask_p+1
	lda tmp+1
	adc tab_masks_hi,x
	sta mask_p+2


	; ... and copy it
#define tmpZPlaneTile tmp+1

	ldy #7
loopcopy

mask_p   
	ldx $1234,y
	bmi finished

	lda (pZPlaneTile),y
	sta tmpZPlaneTile
	
	lda backbuffer,y
	cmp #$80   ; Set Carry =1 if inversed for later
	bcc ScreenNoInverse
	eor #63
ScreenNoInverse
	sta tmp

	txa
	ora tmpZPlaneTile
	and tmp
	sta tmp
   
	lda tmpZPlaneTile
	tax
	eor #%00111111
graphic_p
	and $1234,y
	ora tmp
   
	; Use the value of the carry to inverse if necessary
	bcc okay
	cpx #$40
	beq okay
	eor #%10111111
okay
	sta backbuffer,y   
finished   
	dey
	bpl loopcopy

skip
	dec tmp7
	;bpl loop
	bmi end
	jmp loop
end


#ifndef AVOID_JSRS
	rts
#else
	jmp DumpBuffer
#endif


mirror_draw_sprite
	; The table mirror_codes relates the udg number in
	; an animatory state with the correct one when being
	; displayed mirrored
	lda mirror_codes,y
	tay
	
	; Get the UDG number
	lda as_pointer_low,x
	sta smc_udgpi+1	
	lda as_pointer_high,x
	sta smc_udgpi+2	
smc_udgpi
	lda $1234,y
	beq skip	; If it is 0, then don't do anything

	; Good, now get the pointer to the graphic and mask
#ifdef FULLTABLEMUL8
	tay
	lda tab_mul8hi,y
	sta tmp+1
	lda tab_mul8,y
	clc
#else
	ldy #0
	sty tmp+1	
	asl			
	rol tmp+1	
	asl			
	rol tmp+1	
	asl			
	rol tmp+1
#endif
	; Carry must be clear here
	pha
	adc tab_tiles_lo,x
	sta graphic_pi+1
	lda tmp+1
	adc tab_tiles_hi,x
	sta graphic_pi+2

	pla
	adc tab_masks_lo,x
	sta mask_pi+1
	lda tmp+1
	adc tab_masks_hi,x
	sta mask_pi+2

	;;;;;;;;;;;;
	; ... and copy it
	ldy #7		
loopcopyi	
mask_pi
	ldx $1234,y
	bmi finishedi

	lda (pZPlaneTile),y
	sta tmpZPlaneTile

	lda backbuffer,y
	cmp #$80	; Set Carry =1 if inversed for later
	bcc ScreenNoInversei
	eor #63
ScreenNoInversei
	sta tmp


	lda inverse_table,x	
	ora tmpZPlaneTile
	and tmp
	sta tmp
	lda tmpZPlaneTile
	eor #%00111111
graphic_pi
	ldx $1234,y
	and inverse_table,x
	ora tmp
	
	; Use the value of the carry to inverse if necessary	
	bcc okayi
	ldx tmpZPlaneTile
	cpx #$40
	beq okayi
	eor #%10111111
okayi
	sta backbuffer,y
finishedi	
	dey
	bpl loopcopyi
		
;;;;;;;;;;;;;;;

	dec tmp7
	;bpl loop
	bmi endi
	jmp loop
endi
#ifndef AVOID_JSRS
	rts
#endif
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dumps the backbuffer onto the screnn, using coordinates
; (vis_row,vis_col)
; Again the loop is unrolled for speed.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DumpBuffer
.(
	; Setup pointer to screen row, 
	ldx vis_row				; 3
	ldy tab_mul8,x			; 4 (+1)
	lda _HiresAddrHigh,y    ; 4 (+1)    
	sta tmp+1				; 3
	lda _HiresAddrLow,y     ; 4 (+1)    
	clc						; 2
	adc vis_col				; 3
	sta tmp					; 3
	bcc skip				; 2/3
	inc tmp+1				; 5
skip
							;===============
							; 33/34 (+3)

	ldy #0					; 2
	lda backbuffer			; 4
	sta (tmp),y				; 5 (+1)
	ldy #40					
	lda backbuffer+1		
	sta (tmp),y				
	ldy #80
	lda backbuffer+2
	sta (tmp),y
	ldy #120
	lda backbuffer+3
	sta (tmp),y
	ldy #160
	lda backbuffer+4
	sta (tmp),y
	ldy #200
	lda backbuffer+5
	sta (tmp),y
	ldy #240
	lda backbuffer+6
	sta (tmp),y				; => 77 (+7)

	; Unfortunately, there is one scan left
	lda tmp					; 3
	clc						; 2
	adc #240				; 2
	bcc nocarry				; 2/3
	inc tmp+1				; 5
nocarry
	sta tmp					; 3

	ldy #40					; 2
	lda backbuffer+7		; 4
	sta (tmp),y				; 5 (+1)
							; =====================
							; 77+33/34+28/29= 138/140(+8)					

#ifdef AVOID_JSRS
	jmp return_DrawRoomTile
#else
	rts
#endif
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Waits for a signaled IRQ
; event to occur
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WaitIRQ
.(
	lda #0
	sta irq_detected
loop
	lda irq_detected
	beq loop
	rts
.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper to prepare the pointers
; and data to deal with correct
; zplane and zplane tile data 
; for drawing.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PrepZPlane
.(
	; If there are no zplanes defined
	; for this room, use an empty mask
	pha	
	lda nZPlanes
	beq zerotile	

	; Get the zplane for this object
	; which is in the 3 msb
	lda z_plane,x
	lsr
	lsr
	lsr
	lsr
	lsr
	; Okay. If zero we are done, else we need
	; to subtract 1, as 0 and 1 are *nearly* the same
	; (at least the same for selecting the zplane mask here)
	beq done1	
	sec
	sbc #1
done1	
	; Again, if >= nZplanes, empty mask
	cmp nZPlanes
/*	
	bcc done
	lda nZPlanes
	sec
	sbc #1
done	
*/
	bcs zerotile
	
	; Okay not an empty mask, some work to do then
	; to get the pointer to the tile in the zplane 
	; map.
	; pZPlaneData stores the 16-bit offsets to this data in the room resource 
	; so multiply the entry in A by 2 to get the adequate pointer
	; and add the already calcualted 16-bit offset to the tile we are
	; dealing with
	asl
	tay
	sty saveY+1
	clc
	lda pZPlaneData,y
	adc offsetTilecode
	sta smc_zp+1
	lda pZPlaneData+1,y
	adc offsetTilecode+1
	sta smc_zp+2
	
	; Now get the tile code
	ldy tile_row
smc_zp
	lda $1234,y
	bne calcp
	; The tile code is zero, so empty mask again
zerotile	
	lda #<empty_mask
	sta pZPlaneTile
	lda #>empty_mask
	sta pZPlaneTile+1
	jmp skipall
	
	; Okay the tile code is not zero
	; we have to do the usual work to
	; get the graphic (UDG), *8, add to tile offset, etc.
calcp
	stx resx+1
	tax
	dex
#ifdef FULLTABLEMUL8
	lda tab_mul8,x
#else	
	txa
	ldx #0
	stx tmp+1
	asl
	rol tmp+1
	asl
	rol tmp+1
	asl
	rol tmp+1
#endif
saveY	
	ldy #0
	clc
	adc pZPlaneTiles,y
	sta pZPlaneTile
	
	; We could check here if other tileset
	; is to be used (change the base pointer)

	lda pZPlaneTiles+1,y	
	;clc
#ifdef FULLTABLEMUL8
	adc tab_mul8hi,x
#else	
	adc tmp+1
#endif
	sta pZPlaneTile+1
resx
	ldx #0
	
skipall	
	pla

	rts
.)	


