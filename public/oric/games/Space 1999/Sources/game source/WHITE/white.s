#include "white_defs.h"

#echo
#echo This is WHITE (World Handling & Interaction with The Environment).
#printdef  WHITE_VERSION
#echo
#echo José María Enguita
#echo 2007
#echo


#define HI(a)   >a
#define LO(a)   <a  

#include "noise_defs.h"

//#define INVERT 64 ;$40
#define NOINVERT 191 ;$BF
//#define SPECIAL 128 ;$80

#define INTERFRAME (_Helena1-_Helena0)
#define ALLFRAMES (_Helena1-_Helena0)*3
#define FRONTBACK (_Helenabk0-_Helena0)


#define DBUG 	lda #0 : dbug :	beq dbug


;#define ALIGN .dsb 256-(*&255) 
#define ALIGN ;

__white_start

ALIGN
_map1 .dsb SIZE_GRID*SIZE_GRID
_map2 .dsb SIZE_GRID*SIZE_GRID

ALIGN
_map3 .dsb SIZE_GRID*SIZE_GRID
_map4 .dsb SIZE_GRID*SIZE_GRID



;; Some global data for WHITE

_ink_colour 	.byt A_FWNORMAL		; Room ink
_ink_colour2 	.byt A_FWNORMAL		; Room ink (2nd scans)
_room_size 		.byt 0				; Room size
_camera_angle 	.byt 0				; Camera angle
_current_room 	.byt 0 				; RoomID we are at
_player_char 	.byt 0  			; Character we are controlling
_counter1 		.byt 0				; Internal WHITE counter
_room_loaded	.byt 0				; Has any room been loaded?

;_moving_chars	.dsb MAX_CHARS*4	; Moving objects in the Wolrd. This index is the same as NOISE index for characters
;_num_characters	.byt 0				; Total of moving characters

;_objects		.dsb MAX_OBJS, 0	; Objects in the World (that can be moved across rooms)
;_num_objects 	.byt 0				; Total of objects

_ignore_collisions	.byt	0		; Tells WHITE not to process collisions with background anymore.
_phantom_mode	.byt 0				; Tells WHITE not to stop when colliding with something of the background BUT do so when colliding with a characer
_ignore_collision_test .byt 0       ; Tells WHITE to ignore collision check when stepping

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; **** Internal functions ****
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void wh_updatechar(char id)
;Updates when a char is added
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_wh_updatechar
.(
	ldy #0
	lda (sp),y
	pha
	jsr _init_room
	pla
	ldy #0
	sta(sp),y
	jsr _recalc_clip 
	jmp _white_update ; This jmp=jsr/rts
	

; We are done!

.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;char wh_nextdir(char dir1, char dirturn)
;Obtains the next direction when turning 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_wh_nextdir
.(
	; Get current dir
	ldy #0
	lda (sp),y
	tax

	; Get direction of turning
	ldy #2
	lda (sp),y
	beq is_cw
	txa
	clc
	adc #4
	tax
is_cw
	lda tab_nextdirs,x
	tax	
	lda #0	

	rts
; We're done!

tab_nextdirs
.byte 3,2,0,1,2,3,1,0


.)


; The definition of structures that are used

; moving_chars array (white)
; typedef struct t_moving_char{
; 	unsigned char room;
; 	unsigned char frame;
; 	unsigned char direction;
; 	unsigned char aux;
; } moving_char_t;


; char_pics array (noise)
; typedef struct t_sprite {
;    unsigned char lines;
;    unsigned char scans;
;    unsigned char * image;
;    unsigned char * mask;
; }sprite_t;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void wh_framestep(char id)
;Updates picture of char, when stepping
;Four-frame animation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

next_frame
.(
	lda _char_pics,x	; Grab pointer field
	clc
+bytes_frame
	adc #102
	sta _char_pics,x
	bcc cont
	inc _char_pics+1,x
cont
	rts
.)


first_frame
.(
	lda _char_pics,x	; Grab pointer field
	sec
+bytes_dir1
	sbc #LO(306)
	sta _char_pics,x
	lda _char_pics+1,x
+bytes_dir2
	sbc #HI(306)
	sta _char_pics+1,x
	rts
.)

_wh_framestep
.(
	ldy #0
	lda (sp),y ; Grab ID
	pha	

	asl
	asl			; Multiply by four, to get the correct entry
	tax
	sta tmp		; tmp=id*4

	; x contains first field of char ID (room)

	inx			; Get frame (field 2)
	
	lda _moving_chars,x
	
	bpl animate ; If it is negative, don't animate!

	pla
	rts	; We are done!

animate
	clc
	adc #1
	and #%01111111 ; Be sure flag is not set!
	sta _moving_chars,x
	
	and #3	; Get last two bits
	sta tmp+1
	
	pla			; get id back
	asl			; id*2
	clc
	adc tmp		; id*2+id*4
	tax			; Multiply by 6 to get the correct entry

    ; Correct if less lines
    lda _char_pics,x
    sta tmp
    asl
    clc
    adc tmp
    
    sta bytes_frame+1
    
    lda #0
    sta tmp0
    lda tmp
    asl
    rol tmp0
    asl
    rol tmp0
    asl
    rol tmp0
    clc
    adc tmp
    bcc nocarry
    inc tmp0
nocarry
    sta bytes_dir1+1
    lda tmp0
    sta bytes_dir2+1
    
	inx
	inx			; Skip lines and scans
	
	lda tmp+1
	beq	backframe
	jsr next_frame	
	inx
	inx		; Grab shadow field
	jmp next_frame	; This is jsr/rts

backframe
	jsr first_frame
	inx
	inx		; Grab shadow field
	jmp first_frame ; This is jsr/rts	

.)





#define COLLISION_CALLBACKS
#ifndef COLLISION_CALLBACKS
#echo No collision callbacks!
#else
#echo Collision callbacks activated

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void wh_charcol(char ID)
;Checks if calling callbacks for collision
;with other characters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

counter .byt 0
_wh_charcol
.(
	ldx _num_obj_collisions
	beq end

	dex
	stx counter ; Counter
	txa
loop1
	asl
	asl ; Multiply by four
	tax ; We got the index

	lda _obj_collision_list,x ; Grab id of char we collided with
	and #$bf				  ; remove the invert bit (not the SPECIAL, which could be used)
	ldy #2
	sta (sp),y				  ; 2nd param, the 1st is the ID, which is auto-passed
	iny
	lda #0
	sta(sp),y
	jsr _white_collided_with_char
	txa
	beq end					  ; If returned 0 then stop reporting		

	
	dec counter
	lda counter				; Prepare for next entry	
	bpl loop1

end
	rts
	
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void wh_bkgcol(char ID)
;Checks if calling callbacks for collision
;with SPECIAL blocks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_wh_bkgcol
.(
	ldx _num_bkg_collisions
	beq end

    lda tmp
    pha

	dex
	stx counter ; Counter
	txa
loop1
	asl
	asl ; Multiply by four
	tax ; We got the index

	lda _bkg_collision_list,x ; Grab id of bkg we collided with
	bpl	continue			  ; Is the SPECIAL bit set? if it is not, then continue	

	cmp #$ff				  ; Is it $ff (floor)
	beq continue			  ; If it is, continue
	
	tay
    and #$3f                  ; Get ID without flags, but don't remove them
	beq continue			  ; Block 0 is not "special" even if set as so
    tya

	ldy #4
	sty tmp					  ; Counter for params
	ldy #2
loop2									
	sta (sp),y				  ; 2nd param, the 1st is the ID, which is auto-passed
	iny
	lda #0
	sta(sp),y
	
	inx
	iny	

	lda _bkg_collision_list,x

	dec tmp
	bne loop2

	jsr _white_collided_with_bkg
	txa
	beq end					  ; If returned 0 then stop reporting		

continue
	dec counter
	lda counter			; Prepare for next entry

	bpl loop1

    pla
    sta tmp

end
	rts


.)


#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; End of intetrnal functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;*** WHITE Main C Interface *** ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char white_add_hook((void *)f(void),char hook_point);
; Adds a hook at a given hook_point
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Hook points
hook_pointLO .byt <hook_room_loaded, <hook_room_preload, <hook_room_shown
hook_pointHI .byt >hook_room_loaded, >hook_room_preload, >hook_room_shown

_white_add_hook
.(
    ldy #2
    lda (sp),y  ; Get hook point
    tax
    lda hook_pointLO,x
    sta tmp
    lda hook_pointHI,x
    sta tmp+1

    ; Set jsr address
    ldx #0
    ldy #0
    lda (sp),y
    iny
    sta (tmp),y
    lda (sp),y
    iny
    sta (tmp),y

    ldy #0
    lda #$20 ; jsr opcode
    sta (tmp),y

    rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char white_remove_hook(char hook_point);
; Removes a given hook_point
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_white_remove_hook
.(
    ldy #0
    lda (sp),y  ; Get hook point
    tax
    lda hook_pointLO,x
    sta tmp
    lda hook_pointHI,x
    sta tmp+1

    lda #$ea    ; NOP opcode
    sta (tmp),y
    iny
    sta (tmp),y
    iny
    sta (tmp),y
    
    rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void white_load_room(char roomID)
; Loads room ID from worldmap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_white_load_room
.(

    ; Update current room ID
	ldy #0
	lda (sp),y
	sta _current_room

   ; The next is for setting a hook. The three nop's are
    ; modified with a jsr function
+hook_room_preload
    nop
    nop
    nop

    ; De-activate initing a room when
    ; setting tiles, to speed things up.
	lda #0
	sta _init_when_setting

    ; State that a room has been loaded
	lda #1
	sta _room_loaded		

    ; Clear screen and room map
	jsr	_white_clear_screen;
	jsr _white_clear_room_map;
	
    ; Load map data
    jsr mapload ; User may change this function to fit other room format

    ; Place objects that are in this room
	jsr place_objects

    ; Back to normal behaviour when setting tiles
	lda #$ff
	sta _init_when_setting 


    ; Initializes room (needed for NOISE)
	lda #0
	sta _num_chars

	jsr _init_room
	
    ; Deactivate double buffer drawing
	lda #0
	tay
	sta (sp),y
	jsr _set_doublebuff

    ; Draw the room
	jsr _draw_room


    ; Back to double buffer drawing
	lda #1
	ldy #0
	sta (sp),y
	jsr _set_doublebuff


    ; Place characters that are in this room
    ; Needs to be done after initing and in double-buffer mode
    ; to avoid a bug in NOISE
	jsr place_chars

    ; The next is for setting a hook. The three nop's are
    ; modified with a jsr function
+hook_room_loaded
    nop
    nop
    nop

    ; Show room in current ink color
	lda _ink_colour
	ldy #0
	sta (sp),y

    lda _ink_colour2
	ldy #2
	sta (sp),y

	jsr _white_show_screen

+hook_room_shown
    nop
    nop
    nop

	rts ; We're done

.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void white_show_screen(char attrmap1, char attrmap2)
; Shows the screen with the given ink colour
; alternating between two.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_white_show_screen
.(

	lda #LO($b7d2)
	sta tmp
	lda #HI($b7d2)
	sta tmp+1
	
	ldy #0
	lda (sp),y
	sta tmp0	

	ldy #2
	lda (sp),y
	sta tmp0+1
    sty tmp1+1	; counter of lines

	lda #3
	sta tmp3
	
	; loop 18-1 times
	lda #18
	sta tmp1	
loop1

	ldx #3
loop2
	ldy #0

    lda tmp1+1
    lsr
    bcc even; Even line
    lda tmp0+1 
    jmp fixed
even
	lda tmp0
fixed
    inc tmp1+1

	sta (tmp),y
	lda (sp),y  ; Get ink colour
	ldy tmp3
	sta (tmp),y

 	jsr tmp_minus_40		

	dex
	bne loop2

	jsr dec_tmp16

	inc tmp3
	inc tmp3
	
	dec tmp1
	bne loop1
	
	; now loop 99+1 times
	lda #101
	sta tmp1	
loop3

	ldy #0

    lda tmp1+1
    lsr
    bcc even2 ; Even line
    lda tmp0+1 
    jmp fixed2
even2
	lda tmp0
fixed2
    inc tmp1+1

	sta (tmp),y

	jsr tmp_minus_40
	dec tmp1
	bne loop3
	
	rts

	; We're done!
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void white_clear_screen(void)
; Clears the room area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_white_clear_screen
.(

	lda #LO($b7d2)
	sta tmp
	lda #HI($b7d2)
	sta tmp+1

	lda #3
	sta tmp3
	
	; loop 18-1 times
	lda #18
	sta tmp1	
loop1

	ldx #3
loop2
	ldy #0
	lda #A_FWBLACK
	sta (tmp),y
	lda #A_FWNORMAL
	ldy tmp3
	sta (tmp),y

	; Clear contents
	jsr clr_room

 	jsr tmp_minus_40		

	dex
	bne loop2
	
	jsr dec_tmp16

	inc tmp3
	inc tmp3
	
	dec tmp1
	bne loop1
	
	; now loop 99+1 times
	lda #101
	sta tmp1	
    
    inc tmp3

loop3

	ldy #0
	lda #A_FWBLACK
	sta (tmp),y
	
	; Clear contents
	ldy tmp3
	jsr clr_room
	jsr tmp_minus_40
	dec tmp1
	bne loop3
	
	rts

	; We're done!
.)



;;;;;;;;;;;;;;;;;;;;;;
; Auxiliar funcs
;;;;;;;;;;;;;;;;;;;;;;

tmp_minus_40
.(
	lda tmp
	sec
	sbc #40
	sta tmp
	bcs nocarry
	dec tmp+1
nocarry
	rts
.)

clr_room
.(
	dey
	lda #$40
loopclr
	sta (tmp),y
	dey
	bne loopclr
	rts
.)


dec_tmp16
.(
	lda tmp
	sec
	sbc #1
	sta tmp
	bcs nocarry
	dec tmp+1
nocarry
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void white_update()
; Updates screen contents
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_white_update
.(
	jsr _clear_buff
	jsr _draw_room
	jmp _paint_buff ; This jmp=jsr/rts
		
; We are done!

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void white_clear_room_map()
;Clears the room map, setting all entries to 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_white_clear_room_map
.(
	ldx #(SIZE_GRID*SIZE_GRID)
	lda #0
loop
	sta _map1,x
	sta _map2,x
	sta _map3,x
	sta _map4,x
	dex
	bpl loop

	rts	
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void white_init()
;Initializes the white layer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_white_init
.(
	ldx #0
	lda #LO(_map1)
	sta _layers,x
	lda #HI(_map1)
	sta _layers+1,x
	
	ldx #2
	lda #LO(_map2)
	sta _layers,x
	lda #HI(_map2)
	sta _layers+1,x
	
	ldx #4
	lda #LO(_map3)
	sta _layers,x
	lda #HI(_map3)
	sta _layers+1,x

  	ldx #6
	lda #LO(_map4)
	sta _layers,x
	lda #HI(_map4)
	sta _layers+1,x

	jmp _white_clear_room_map ;This jmp=jsr/rts

.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void white_add_new_char(char ID)
; Adds a character to the world
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_white_add_new_char
.(
	lda _room_loaded
	beq not_here ; White has not been initialized


	ldy #0
	lda (sp),y	;Grab ID

	jsr wh_check_room
	bne not_here
	ldx _num_chars
	lda (sp),y	;Grab ID
	sta _chars_in_room,x
	inc _num_chars
	jsr _wh_updatechar

not_here
	
	;inc _num_characters
	rts

.)
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void white_remove_char(char ID)
; Removes a character from the world
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_white_remove_char
.(

	lda _room_loaded
	beq not_here ; White has not been initialized

	ldy #0
	lda (sp),y	;Grab ID
	sta tmp
	jsr wh_check_room
	bne not_here
	
	; Let's find where our ID is
	
	ldx #0
loop1	
	lda _chars_in_room,x
	cmp tmp	;Is it our ID?
	beq found
	cpx _num_chars
	beq not_found
	inx
	jmp loop1
not_found
	rts	; Not found!
found
	dec _num_chars
loop2
	lda _chars_in_room+1,x
	sta _chars_in_room,x
	cpx _num_chars
	beq endcopy
	inx
	jmp loop2
endcopy	
	jsr _wh_updatechar

not_here
	
	;dec _num_characters
	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void white_turn(char ID, char dir)
;Makes a character turn clockwise or anticlockwise
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_white_turn
.(
	ldy #0
	lda (sp),y	; Grab ID
	sta tmp1+1	; Save ID for later use
	asl
	asl			; Multiply by four to get the entry
	tax
	lda _moving_chars,x ; Get room ID
	pha			; save...
	inx			; As direction is the 3rd element
	inx			; Now it is pointing at direction
	lda _moving_chars,x
	sta tmp2
	and #%10000000 ; Get flag for animation
	sta tmp2+1
	lda tmp2	; Get direction again
	and #%01111111; Remove bit 7 (animation flag)
	sta (sp),y	; Prepare params for calling wh_nextdir
	and #1
	sta tmp+1	; Save result
	stx tmp		; Save x

	
	; oldset=(moving_chars[ID].direction)&1;
	
	jsr _wh_nextdir
	
	
	;d=wh_nextdir(moving_chars[ID].direction, dir);
	;moving_chars[ID].direction=d;

	txa		; Get result
	pha		; Save
	ldx tmp
	ora tmp2+1 ; Put flag again
	sta _moving_chars,x		

	bpl animate	
	pla	; Don't animate if bit 7 was set.
	;jmp paint
    pla ; Remove previously saved ID index
    jmp done_all

animate
	; Facing camera is back dAND1==0, front dAND1==1
	;if ( (d&1) != (oldset))
	and #1
	sta tmp1
	cmp tmp+1
	beq not_change
	
	;{
	;	if (d&1) delta=-816;
	;	else delta=+816;
	;	char_pics[ID].image+=delta;
	;	char_pics[ID].mask+=delta;
	;}
	
	lda tmp1+1
	asl
	sta tmp	; tmp=ID*2
	asl		; a=ID*4
	clc
	adc tmp	; a=ID*2+ID*4=ID*6
	tax
	inx
	inx
	ldy #2	

	lda tmp1
	beq add_816
	
loop1	

	lda _char_pics,x	; Grab pointer field
	sec
	sbc #LO(816)
	sta _char_pics,x
	lda _char_pics+1,x
	sbc #HI(816)
	sta _char_pics+1,x
	inx
	inx	; Point to the shadow
	dey
	bne loop1
		
			
	jmp not_change

add_816

	lda _char_pics,x	; Grab pointer field
	clc
	adc #LO(816)
	sta _char_pics,x
	lda _char_pics+1,x
	adc #HI(816)
	sta _char_pics+1,x
	inx
	inx	; Point to the shadow
	dey
	bne add_816

not_change

	; Invert if NOT(dAND2)
	;if( !(d&2))
	; characters[ID].type=(characters[ID].type|INVERT);
	;else
	; characters[ID].type=(characters[ID].type&~INVERT);

	lda tmp1+1 ; Get ID
	asl
	asl	
	tax
	inx
	inx
	inx		; x=ID*4+3
	pla	; Get new direction (d)
	and #2
	bne no_invert
	
	lda _characters,x
	ora #INVERT
	jmp done
no_invert
	lda _characters,x
	and #NOINVERT
done	
	sta _characters,x

paint
	pla
	cmp _current_room
	bne done_all
	;recalc_clip(ID);
	lda tmp1+1
	ldy #0
	sta (sp),y
	jsr _recalc_clip
	;white_update();
	jsr _white_update

done_all
	rts	
	; We are done!

.)	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wh_check_room
; helper that checks if a given
; character ID in reg a
; is in current room.
; Returns Z=1 if it is not
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

wh_check_room
.(
	;If it is on a different room, do nothing (some deffensive programming)
	asl
	asl
	tax
	lda	_moving_chars,x
	
	cmp _current_room
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wh_get_dir
; Helper that grabs the direction
; a given character is facing.
; Gets in reg x the index of the
; first field (room) of the
; moving_chars array
; and stores it in 2nd parameter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

wh_get_dir
.(
		
	inx
	inx	
	lda _moving_chars,x	; Get direction the character is facing
	and #%01111111 ; Remove flag
	ldy #2
	sta (sp),y

	rts
.)



; This functions share a byte so...
.(


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char white_movev(char ID, char dir)
; Moves a character vertically if able
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_white_movev
.(

	ldy #0
	lda (sp),y
	sta ID

	jsr wh_check_room
	bne end


	txa
	pha
	jsr _wh_framestep
	pla
	tax
	jmp white_step_ex

end
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;char white_step(char ID)
;Makes the character ID perform one step
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_white_step
.(
	ldy #0
	lda (sp),y
	sta ID

	jsr wh_check_room
	beq doit
	jmp end_nomoved

doit
	; Perform collision test
	jsr wh_get_dir

+white_step_ex	; Jump here if you have done the rest
    lda _ignore_collision_test
    bne no_collisions
	jsr _collision_test

	; In reg A we have collisions with characters
	; In reg X we have collisions with background objects
	sta tmp+1
	stx tmp
	ora tmp
	beq no_collisions

	lda _phantom_mode
	;bne no_collisions
    beq no_ignore_bkg
    ldx #0
    lda tmp+1
    beq no_collisions
no_ignore_bkg

#ifdef AUTOSTAIRS

#ifndef NPCUSESTAIRS
	lda ID
	cmp _player_char
	bne nostairs
#endif 
	jsr wh_treat_upstairs
nostairs
#endif 

	;lda _ignore_collisions
	;bne no_col_bkg	

	lda tmp+1
#ifdef COLLISION_CALLBACKS
	beq no_col_char
	jsr _wh_charcol

no_col_char

    lda _ignore_collisions
	bne no_col_bkg	

	lda tmp
	beq no_col_bkg

#ifdef NPC_DONTREPORTBKGCOL
	lda ID
	cmp _player_char
	bne no_col_bkg
#endif

	jsr _wh_bkgcol
#endif

no_col_bkg
;	lda _phantom_mode
;	bne no_collisions
	lda tmp
	ora tmp+1
	beq no_collisions

#ifdef AVOID_CORNERS    
    jsr avoid_corners
#endif
    
	jsr _recalc_clip
	jmp end_nomoved
	
no_collisions

	jsr _wh_framestep
	jsr _move_sprite
	jsr _white_update

	lda ID
	cmp _player_char
	bne end_moved		; Nothing more to do

#ifdef AUTO_ROOM_CHANGE
    jsr check_room_change
#endif

end_moved
#ifndef GRAVITY
	lda _phantom_mode
	bne nocheckfloor
	lda ID
	ldy #0
	sta (sp),y
	jsr _white_checkfloor
	jsr wh_treat_downstairs
nocheckfloor
#endif


	lda #0
	ldx #1
	rts
	;We're done!

end_nomoved	
;	jsr _white_update
	lda #0
	ldx #0
	rts

.)

ID 	.byt 0

#ifdef AUTO_ROOM_CHANGE

#define BORDERLOW 6
#define BORDERHIGH 56

check_room_change
.(
	; But if it is the player-controlled character,
	; then we have to change room... if necessary
	
	asl
	asl
	tax 	; Get the index again

	lda _characters,x	; Get i
	cmp #BORDERLOW
	bcs no_west

	; Exited room by the west side... load room id-1 
	lda #(BORDERHIGH-1)
	sta _characters,x
	dec _current_room
	lda _current_room
	sta _moving_chars,x
	jmp change_room

no_west
	cmp #BORDERHIGH
	bcc no_east
	
	; Exited room by east side... load room id+1
	lda #(BORDERLOW+1)
	sta _characters,x
	inc _current_room
	lda _current_room
	sta _moving_chars,x
	jmp change_room
no_east
	
	; Check j coordinate

	inx
	lda _characters,x	; Get j
	cmp #BORDERLOW
	bcs no_north

	; Exited room by the north side... load room id-16
	lda #(BORDERHIGH-1)
	sta _characters,x
	lda _current_room
	sec
	sbc #16
	sta _current_room
	dex
	sta _moving_chars,x
	jmp change_room

no_north
	cmp #(BORDERHIGH)
	bcc no_south
	
	; Exited room by south side... load room id+16
	lda #(BORDERLOW+1)
	sta _characters,x
	lda _current_room
	clc
	adc #16
	sta _current_room
	dex
	sta _moving_chars,x
	jmp change_room

change_room
	ldy #0
	sta (sp),y
	iny
	lda #0
	sta (sp),y

	jmp _white_load_room ; This is jsr/rts

no_south
	; No need to change room
    rts

.)
#endif

#ifdef AVOID_CORNERS

#ifdef AUTO_ROOM_CHANGE
; Check if a character is in the border of room. Return Z=1 if he is.
; ID is in reg A

check_char_border
.(
    asl
    asl
    tax
    lda _characters,x ; Get i
    cmp #(BORDERLOW+1)
    bcc retis
    cmp #(BORDERHIGH-2)
    bcs retis
    lda _characters+1,x ; Get j
    cmp #(BORDERLOW+1)
    bcc retis
    cmp #(BORDERHIGH-2)
    bcs retis

    lda #1
    rts

retis
    lda #0
    rts

.)
#endif

; Try to avoid corners, moving the character laterally...

i .byt 0
j .byt 0
avoid_corners
.(
    lda #0  ; This is self-modifiying code... check below
    bne end

   	lda ID
	cmp _player_char
    bne end

#ifdef AUTO_ROOM_CHANGE
    ; if on a border, don't do anything
    jsr check_char_border 
    beq end
#endif

    lda _num_obj_collisions
    bne end

    ; Initialize i and j
    lda _bkg_collision_list+1 ;Get i
    sta i
    
    lda _bkg_collision_list+2 ;Get j
    sta j

    ldx _num_bkg_collisions
    dex
    txa
loop

    asl
    asl
    tay
    lda _bkg_collision_list,y
    cmp #129
    ;beq valid
    ;bmi end
    bpl end
    lda _bkg_collision_list+1,y ;Get i
    cmp i
    bne end
    lda _bkg_collision_list+2,y ;Get j
    cmp j
    bne end

    dex
    txa

    bpl loop

    ; If we reach this point, we are in condition to try to avoid the corner

    lda ID
    asl
	asl
	tax
	lda _moving_chars+2,x 	; Get character direction
    
    cmp #NORTH
    bne no_north
    jmp check_lateral_NS
no_north
    cmp #SOUTH
    bne no_south
    jmp check_lateral_NS
no_south
    cmp #EAST
    bne no_east
    jmp check_lateral_EW

no_east
    cmp #WEST
    bne no_west
    jmp check_lateral_EW
no_west
end
    rts

.)

search_id
.(
    ldy _num_chars
    dey
loopchars
    lda _chars_in_room,y
    cmp ID
    beq found
    dey
    bne loopchars
found
    rts
.)

check_lateral_NS
.(
    pha
    jsr search_id
    
    lda _char_tiles_i,y
    cmp i
    bne move_rigth
    ; move it left
    lda #WEST
    jmp avoid
move_rigth
    lda #EAST
    jmp avoid
.)

check_lateral_EW
.(
    pha
    jsr search_id
  
    lda _char_tiles_j,y
    cmp j
    bne move_down
    ; move it up
    lda #NORTH
    jmp avoid
move_down
    lda #SOUTH
    jmp avoid
.)

avoid
.(
    sta _moving_chars+2,x
    txa
    pha
    
    lda #1
    sta avoid_corners+1
    jsr _white_step
    lda #0
    sta avoid_corners+1

    pla 
    tax
    pla
    sta _moving_chars+2,x   ; Put direction back
    rts
.)

#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;char white_interact(char ID)
;Makes the character ID try to interact with environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_white_interact
.(
	ldy #0
	lda (sp),y
	sta ID

	jsr wh_check_room
	bne end_col

	; Perform collision test
	jsr wh_get_dir

+white_interact_ex
	jsr _collision_test

	; In reg A we have collisions with characters
	; In reg X we have collisions with background objects
	sta tmp+1
	stx tmp
	ora tmp
	beq end_nocol	
	lda _ignore_collisions
	bne end_nocol	
	lda tmp+1
#ifdef COLLISION_CALLBACKS
	beq no_col_char
	jsr _wh_charcol

no_col_char
	ldx tmp
	beq no_col_bkg
	jsr _wh_bkgcol
#endif

no_col_bkg

end_col
	lda #0
	ldx #1
	rts

end_nocol
	lda #0
	tax
	rts
	;We're done!

.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char white_checkfloor(char ID)
; Checks the floor a character is standing at
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_white_checkfloor
.(	
	ldy #0
	lda (sp),y
	sta ID

	jsr wh_check_room
	bne end
	
	lda #DOWN
	ldy #2
	sta (sp),y
	
	jsr white_interact_ex
end
	rts
.)



#ifdef AUTOSTAIRS

.(
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper that checks if character collided
; with stairs AND ONLY stairs of the same type
; receives the output of collision_detection
; and tmp1 and tmp+1 with the number of
; collisions with bkg and chars respectively
; Returns Z=1 if positive response, Z=0 otherwise
; and a=type of stair (tile code)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_tiles
.(

	; In tmp+1 we have collisions with characters
	; In tmp we have collisions with background objects
	lda tmp+1
	bne end ; Someone was there, retrurn Z=0

	lda tmp
	bne check	
	lda #1	; Nothing to check, return Z=0
	bne end
check
	cmp #1
	beq check1tilestairs ; One tile with stairs?
	cmp #2
	beq check2tilestairs ; Two tiles with stairs?
	bne end				; More tiles means we cannot go, return Z=0
check2tilestairs

	; Check if there are one or two tiles with stairs in the 
	; collision list
	
	ldx #4
	lda _bkg_collision_list,x	; Get object
	
	ldx #0
	cmp _bkg_collision_list,x	; Are they the same?	
	bne end

check1tilestairs
	ldx #0
	lda _bkg_collision_list,x

	cmp #T_STAIRN
	beq end
	; Rest of comparisions
	cmp #T_STAIRW
	beq end

	cmp #T_STAIRS
	beq end
	
	cmp #T_STAIRE
	beq end
	
end	
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; checks if direction of a character
; corresponds to going up a stair.
; receives a=direction, y=stair type
; returns Z=1 if success
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_going_up
.(
	asl
	asl
	tax
	inx
	inx
	lda _moving_chars,x 	; Get character direction

	cpy #T_STAIRN
	bne nostairn
	cmp #NORTH
	beq end		; Was moving up the stairs...
nostairn
	cpy #T_STAIRW
	bne nostairw
	cmp #WEST
	beq end
nostairw
	cpy #T_STAIRS
	bne nostairs
	cmp #SOUTH
	beq end	; Was moving up the stairs...

nostairs
	cpy #T_STAIRE
	bne end
	cmp #EAST
	beq end	; Was moving up the stairs...

end
	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; checks if direction of a character
; corresponds to going down a stair.
; receives a=char who is moving, y=stair type
; returns Z=1 if success
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_going_down
.(
	asl
	asl
	tax
	inx
	inx
	lda _moving_chars,x 	; Get character direction

	cpy #T_STAIRN
	bne nostairn
	cmp #SOUTH
	beq end		; Was moving down the stairs...
nostairn
	cpy #T_STAIRW
	bne nostairw
	cmp #EAST
	beq end
nostairw
	cpy #T_STAIRS
	bne nostairs
	cmp #NORTH
	beq end	; Was moving down the stairs...

nostairs
	cpy #T_STAIRE
	bne end
	cmp #WEST
	beq end	; Was moving up the stairs...


end
	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wh_treat_upstairs
; helper that makes characters climb up
; stairs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+wh_treat_upstairs
.(
	jsr check_tiles
	bne end2

	; All correct, is the character going up?
	tay

	lda ID
	jsr check_going_up
	bne end2

	; Perfect, then make him up if in correct position.
	lda #UP
	ldx #1
	sta dir,x

    ldy #2
	lda (sp),y
	pha

	lda #1
	sta _phantom_mode

 	jsr move_instairsv
    jsr move_instairsh
    jsr move_instairsv

    lda #0
	sta _phantom_mode
 
    lda #2
    ldx #1
    sta numsteps,x

    jsr move_instairsh
    bcs end
     
  
	; Do as if there were no collisions
	lda #0
	sta tmp+1
	sta tmp
	
end

    lda #3
    ldx #1
    sta numsteps,x


    pla

end2
	ldy #2
	sta (sp),y
	ldy #0
	lda ID
	sta (sp),y

	rts

.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wh_treat_downstairs
; helper that makes characters climb down
; stairs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+wh_treat_downstairs
.(
	jsr check_tiles
	bne end2
	
	; All correct, is the character going down?
	tay
	lda ID
	jsr check_going_down
	bne end2

   ; Perfect, then make him down if in correct position.
	lda #DOWN
	ldx #1
	sta dir,x
	
    ldy #2
	lda (sp),y
	pha

	;lda #1
	;sta _phantom_mode

    lda #1
    ldx #1
    sta numsteps,x
    jsr move_instairsh
    
    lda #0
	sta _phantom_mode
    
    lda #2
    ldx #1
    sta numsteps,x
   
    jsr move_instairsh
    bcs end


 	jsr move_instairsv
    
    lda #3
    ldx #1
    sta numsteps,x
    
    jsr move_instairsh
    bcs end
    jsr move_instairsv

endstairs
	; Do as if there were no collisions
	lda #0
	sta tmp+1
	sta tmp
	
end
    pla
    
    lda #3
    ldx #1
    sta numsteps,x



end2
	ldy #2
	sta (sp),y
	ldy #0
	lda ID
	sta (sp),y

	rts


.)


;;;;;;;;;;;;;;;;;;;;;;;;;;
; Moves up or down stairs
; Uses self-modifiying code
;;;;;;;;;;;;;;;;;;;;;;;;;;
move_instairsv
.(

	ldx #4
loop
	txa
	pha

	ldy #0
	lda ID
	sta (sp),y
	ldy #2
+dir	lda #00
	sta (sp),y

	jsr _move_sprite
		
	pla
	tax
	dex
	bne loop

    
    ldx #1
    lda dir,x
    
    cmp #UP
    bne noup
    inc _clip_rgn,x
    inc _clip_rgn,x
    inc _clip_rgn,x
noup
    inx
    inx
    inc _clip_rgn,x
    inc _clip_rgn,x
    inc _clip_rgn,x

    jsr _white_update

	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;
; Moves up or down stairs
; Uses self-modifiying code
; Returns Carry Set if not able
; Carry Clear otherwise
;;;;;;;;;;;;;;;;;;;;;;;;;;
move_instairsh
.(
+numsteps
    ldx #3
   

loop
    txa
    pha
	
    ldy #0
	lda ID
	sta (sp),y
	jsr _white_step
    
    txa
    bne able
    pla
    sec
    rts

able
    pla
    tax
    dex
    
    bne loop
    clc
	rts

.)

#endif ;AUTOSTAIRS

#ifdef GRAVITY

+wh_gravity
.(

	ldy _num_chars
	dey						; BEWARE it is 0-based	
loop_chars

	tya
	tax


	lda _chars_in_room,x	; Get ID of one character in room... 
	sta tmp
	asl
	asl						; Multiply by four to get the correct entry	
	tax
	inx						
	inx						; The third field is fine_coord_k
	lda _characters,x
	beq next

#ifdef GRAVITY
    ; Is it affected by gravity?
    inx
    lda _moving_chars,x
    and #%10    
    bne next    
#endif

	tya
	pha

	lda tmp
	ldy #0
	sta (sp),y
	sta ID
	lda #DOWN
	ldy #2
	sta (sp),y
	jsr _collision_test
	sta tmp+1
	stx tmp
	ora tmp
	beq nothing
	jsr wh_treat_downstairs
	jmp continue
nothing
	lda ID
	ldy #0
	sta (sp),y
	lda #DOWN
	ldy #2
	sta (sp),y
	jsr _white_movev
	stx tmp
	ora tmp
	bne nothing

continue
	pla
	tay

next
	dey
	bpl loop_chars

	rts
.)

#endif

.) ; End of stairs related stuff




.) ; End of the  functions that share one byte in memory




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; white_standstill(char ID)
; Puts char ID back to frame 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,

_white_standstill
.(
loop

	jsr _wh_framestep

	ldy #0
	lda (sp),y ; Grab ID

	asl
	asl			; Multiply by four, to get the correct entry
	tax
	inx			; Get frame (field 2)
	
	lda _moving_chars,x
	and #3	; Get last two bits

	bne loop

   	jsr _recalc_clip 
	jmp _white_update ; This is jsr/rts	

.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void white_setPC(char ID)
; Sets the currently player-controlled character
; and loads the room it is in, if necessary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_white_setPC
.(
	ldy #0
	lda (sp),y	; Get new ID
	sta _player_char	; Store it

	jsr wh_check_room	
	beq end

	sta (sp),y
	iny
	lda #0
	sta (sp),y
	jsr _white_load_room	; It is different, so load it

end
	rts
	; We're done!
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void white_change_block(char i, char j, char k, char newID)
;Changes a block in the room and repaints what necessary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_white_change_block
.(
    ;oldID=get_tile(i,j,k);
	jsr _get_tile	; returns block in X register
	txa
    ; check if it is not the same:
    sta tmp
    ldy #6
    lda (sp),y
    cmp tmp
    bne cont
    rts
cont
    ; different blocks, so let's continue
    lda tmp
	and #%00111111	; Remove SPECIAL and INVERTED bits, which are not necessary
	;sta oldID		; Save it
    pha
	
    ;set_tile(i,j,k,newID);
	jsr _set_tile
    
	ldy #0
	lda (sp),y
	sta op1
    sta _orig_i ; Prepare for drawing what is necessary
	iny
	iny
	lda (sp),y
	sta op2
    sta _orig_j ; Prepare for drawing what is necessary
	jsr ij2xy	; returns x and y in X and Y registers


	stx _clip_rgn ; put x in clip_rgn.x_clip
	
	; y-=(k<<3);
	; y=y+12;
	sty tmp+1
	ldy #4
	lda (sp),y	; Get the k parameter
	asl
	asl
	asl
	sta tmp
	lda tmp+1
	sec
	sbc tmp	
	clc
	adc #12
	

	sta _clip_rgn+1 ; put y in clip_rgn.y_clip

	; lines2go=(bkg_graphs[oldID].lines>bkg_graphs[newID].lines?bkg_graphs[oldID].lines:bkg_graphs[newID].lines);

    lda #LO(_bkg_graphs)
    sta tmp1
    lda #HI(_bkg_graphs)
    sta tmp1+1


	ldy #6
	lda (sp),y 	; Get newID
	and #%00111111	; Remove SPECIAL and INVERTED bits, which are not necessary
	asl
	sta tmp2
	asl
	clc
	adc tmp2	; Multiply by 6
    bcc nocarry
    inc tmp1+1
nocarry
    tay
    lda (tmp1),y    ; Get entry pos for _bkg_graphs[newID].lines
    sta tmp
    iny
    lda (tmp1),y
    sta tmp+1	    ; and .scans


    lda #LO(_bkg_graphs)
    sta tmp1
    lda #HI(_bkg_graphs)
    sta tmp1+1

	;lda oldID
    pla
	asl
	sta tmp2
	asl
	clc
	adc tmp2    ; Multiply by 6
    bcc nocarry2
    inc tmp1+1
nocarry2
    tay
    lda (tmp1),y	; Get entry _bkg_graphs[oldID].lines
    
	
	cmp tmp
	bcs oldlines
	lda tmp
oldlines	
	
	sta tmp0	; This is lines2go

	; clip_rgn.width_clip=(bkg_graphs[oldID].scans>bkg_graphs[newID].scans?bkg_graphs[oldID].scans:bkg_graphs[newID].scans);

;    iny
;    lda (tmp1),y
	
;	cmp tmp+1
;	bcs oldscans
;	lda tmp+1
;oldscans

    lda #4              ; Fix number of scans, as else we have to adjust xscr when using less than 4.
	sta _clip_rgn+2		; Save number of scans

	; Adjust number of lines, if it is bigger than 40 


	;if(lines2go>40)
	;{
	;	clip_rgn.height_clip=40;
	;	lines2go-=40;
	;}
	;else 
	;{
	;	clip_rgn.height_clip=lines2go;
	;	lines2go=0;
	;}

  	lda tmp0
	cmp #40
	bcc noadjust
	lda #40
	sta _clip_rgn+3
	lda tmp0
	sec
	sbc #40
	
	jmp endadjust
noadjust
	sta _clip_rgn+3
	lda #0
endadjust
    pha

    jsr _init_room
	jsr _white_update

	;if (lines2go)
	;{
	;	clip_rgn.y_clip-=40;
	;	clip_rgn.height_clip=lines2go;
	;	white_update();		
	;}	

    pla
	beq end
	sta _clip_rgn+3	
	lda _clip_rgn+1
	sec
	sbc #40
	sta _clip_rgn+1

	jsr _white_update
			
end


	rts
	
	; We're done



.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; atimes5
; multiplies register A times 5.
; Uses tmp register
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
atimes5
.(
	sta tmp
	asl
	asl
	clc
	adc tmp
	rts
.)

#ifdef WAREHOUSE_MANAGE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; search_obj
; helper for searchig an obj in the array of objects.
; Params: A=ID.
; Returns index in Y, 1st field in X (Y*5) and Z=1.
; If it is not found returns  Z=0.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
search_obj
.(
	sta tmp1
	lda _num_objects
    beq not_found
	sec
	sbc #1
	tay

loop
	tya
	jsr atimes5
	tax
	inx		; id is the second field in structure	

	lda _objects,x
	cmp tmp1
	beq found

	dey
	bpl loop

not_found
	lda #1
	rts

found
	php
	dex  	; X=first field in structure: room
	plp
	;lda #1 ; A equals ID, and we need to keep it
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char white_to_warehouse(char i,char j, char k)
; Moves the object in position i,j,k to warehouse
; and returns its ID. Then it is removed 
; from the room and screen updated.
; Returns 0 if object is not found.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_white_to_warehouse
.(
	jsr _get_tile ; Get the id of object at position (i,j,k)
	txa
	and #%00111111 ; Remove SPECIAL and INVERTED flags
	jsr search_obj ; Search it in the movable object list
	beq found

not_found
	lda #0
	tax
	rts
found
	pha
	lda #WAREHOUSE
	sta _objects,x
	
	lda #0	
	ldy #6
	sta (sp),y

	jsr _white_change_block

	pla
	tax
	lda #0	

	rts

	; We're done
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char white_from_warehouse(char i, char j, char k, char ID) 
; Moves object ID from the warehouse to current room at position (i,j,k). 
; Returns 0 if success and an ID if there was an object already at that position.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_white_from_warehouse
.(
	; Is the position currently occupied?
	jsr _get_tile
	txa
	; We don't remove SPECIAL and INVERTED bits here, as the ID=0 with SPECIAL (and/or
	; INVERTED, even if this is normally not the case) are special blocks which should not be
	; substituted.
	bne occupied
	
	ldy #6
	lda (sp),y		; Get ID to put in that position
	sta tmp2
	;and #%00111111	; In case...

	jsr search_obj ; Search for the ID in the list 
	bne not_found
	
	; Set up fields for entry in objects array
	lda _current_room
	sta _objects,x
	inx

	
	lda tmp2 ; Get back ID
	sta _objects,x
	inx


	ldy #0
	lda #3 ; loop 4 times
	sta tmp 
loop
	
	lda (sp),y  ; Get param
	sta _objects,x
	inx
	iny
	iny
	
	dec tmp
	bne loop

	; y is the index to last param, as we looped only 3 times
	
	; Set object as SPECIAL
	;lda (sp),y
	lda tmp2
	ora #SPECIAL
	sta (sp),y

	jsr _white_change_block
	
	lda #0
	tax
	rts
	
not_found
	lda #$ff	; Returning 255 means some kind of error... 
	tax
	rts
occupied
	and #NOINVERT	; Keep the special bit, as  it could be used by the caller...
	tax
	lda #0	; keep X with the ID and A=0
	rts
	; We're done
.)

#endif ; WAREHOUSE_MANAGE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void white_loop(void)
; Main loop for white actions, like moving
; sprites...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
typemov .byt 0
_white_loop
.(
;	sei
	inc _counter1	; Increment counter for timing

	ldy _num_chars
	dey						; BEWARE it is 0-based	
	;stx tmp1
loop_chars

	;lda tmp1
	;pha


	;ldx tmp1
	tya
	tax

	lda _chars_in_room,x	; Get ID of one character in room... 
	sta tmp
	asl
	asl						; Multiply by four to get the correct entry	
	tax
	inx						; The second field is frame
	inx						; The third field is direction
	inx						; The fourth field is the one who controls automatic movement
	
	lda _moving_chars,x

	;; types of automatic movement:
	;; 1- When collision turn clockwise
	;; 2- When collision turn anticlockwise
	;; 3- When collision turn twice
	;; 4- When collision randomly do one of the above
	;; 5- Random movement (just do one of the first three at any time)
	;; 6- Random movement (free, including up/down)
	;; 7- Go towards hero

	;; This field structure is as follows:
	;;	7 6 5 4 3 2 1 0
	;; +---------------+
	;; |a|t t t|f f g|s|
	;; +---------------+

	;; a = automatic movement yes/no
	;; s = speed
	;; t = type of movement
    ;; g = character is unaffected by gravity
	;; f = free
	
	;bpl next			    ; If auto-move is not set, then nothing to do

	bmi shallmove
	jmp next			    ; If auto-move is not set, then nothing to do

shallmove
	
	and #%00000001			; Get speed flag (last bit)
	ora _counter1
	and #%00000001          ; This will be zero if last bit in counter1 is 0 and s bit=0 
	
	;bne next				; Not yet
	bne speedmatches
	jmp next

speedmatches

	lda _moving_chars,x		; Get field again
	and #%01110000			; Get only type of movement						
	sta typemov				; Save it	


	; We have to move it, so start saving loop index
	tya
	pha	

	dex						; The third field is direction
	lda _moving_chars,x
	and #%01111111			; Remove direction flag


	ldy #2
	sta(sp),y
	lda tmp
	ldy #0
	sta (sp),y


	lda typemov
	cmp #%01000000			; Type 4
	bne waitcollision 
	;tya
	;pha
	txa
	pha
#ifdef OWNRAND
    jsr getrand
#else
	jsr _rand
#endif
	sta tmp1
	pla
	tax
	;pla
	;tay

	lda tmp1
	and #%00001111
	cmp #%00001111
	bne waitcollision

	lda #%00110000
	sta typemov
	jmp aftercollision


waitcollision	
	; Check if character is about to leave room and avoid it.
	ldy #2
	lda (sp),y ; Get direction
	dex

	cmp #NORTH
	bne no_north
	lda _characters,x ; Get j coordinate
	cmp #13
	bne no_border
	jmp aftercollision
no_north
	cmp #SOUTH
	bne no_south
	lda _characters,x ; Get j coordinate
	cmp #48
	bne no_border
	jmp aftercollision
no_south
	cmp  #EAST
	bne no_east
	dex
	lda _characters,x ; Get i coordinate
	cmp #48
	bne no_border
	jmp aftercollision
no_east
	;dex
	lda _characters,x ; Get i coordinate
	cmp #13
	bne no_border
	jmp aftercollision
no_border


	;jsr _collision_test
	
	;stx tmp
	;ora tmp
	;bne collision
	
	;jsr _wh_framestep
	;jsr _move_sprite
	;jsr _white_update
	;jmp donechar

	jsr _white_step
	bne donechar


collision
#ifdef COLLISION_CALLBACKS
	;jsr _wh_charcol
#endif	

aftercollision
	; Select what to do, depending on type of movement
	lda typemov

	cmp #%00110000
	bne not_type3
#ifdef OWNRAND
    jsr getrand
#else
	jsr _rand
#endif
	
	; Depending on two last bit in a it will do:
	; 00: turn CLOCKWISE
	; 01: turn ANTICLOCKWISE
	; 10: turn twice
	; 11: randomly one of the above
	
	and #%00110000 ;Only two bits are used for now, so we won't set this #%01110000
		
not_type3
	cmp #%00000000
	bne not_type0
	lda #CLOCKWISE
	ldy #2 
	sta (sp),y
	jsr _white_turn
	jmp doit
not_type0
	cmp #%00010000
	bne not_type1
	lda #ANTICLOCKWISE
	ldy #2 
	sta (sp),y
	jsr _white_turn
	jmp doit


not_type1
	cmp #%00100000
	bne not_type2

	ldy #0
	lda (sp),y
	pha 
	lda #CLOCKWISE
	pha
	ldy #2 
	sta (sp),y
	jsr _white_turn
	pla
	ldy #2
	sta (sp),y
	pla
	ldy #0
	sta (sp),y
	jsr _white_turn
	jmp doit

not_type2

	
doit
	
donechar

	; Restore loop index
	pla
	tay
	
next
	dey
	bmi end
	jmp loop_chars

end
;	cli

#ifdef GRAVITY
	jsr wh_gravity
#endif
	rts
	
	;We're done.
.)



#ifdef OWNRAND
;
; GETRAND
;
; Generate a somewhat random repeating sequence.  I use
; a typical linear congruential algorithm
;      I(n+1) = (I(n)*a + c) mod m
; with m=65536, a=5, and c=13841 ($3611).  c was chosen
; to be a prime number near (1/2 - 1/6 sqrt(3))*m.
;
; Note that in general the higher bits are "more random"
; than the lower bits, so for instance in this program
; since only small integers (0..15, 0..39, etc.) are desired,
; they should be taken from the high byte RANDOM+1, which
; is returned in A.
;
random
.word  $3611
temp
.byt $00
getrand
         lda random+1     
         sta temp        
         lda random       
         asl              
         rol temp        
         asl              
         rol temp        
; asl
; rol tmp
; asl
; rol tmp
         clc              
         adc random       
         pha              
         lda temp        
         adc random+1     
         sta random+1     
         pla              
         adc #$11         
         sta random       
         lda random+1     
         adc #$36         
         sta random+1     
         rts              

#endif


__white_end
; End of White Layer

#echo Size of WHITE in bytes:
#print (__white_end - __white_start)
#echo



