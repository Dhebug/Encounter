;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Code to handle scripts

#include "params.h"
#include "sfx.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Primary command that loops the
; manta to change direction
; The entry point for the command
; is do_loop, but calling
; loop_hero installs it
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
loop_hero
.(
	; If this is the first step
	; prepare the primary command
	jsr update_pointers_flat
	lda #1
	sta sprite_height
	lda #0
	sta anim_state
	lda #1
	ora SfxFlags
	sta SfxFlags

	lda #<do_loop
	sta pcommand_l
	lda #>do_loop
	sta pcommand_h
do_loop
	;lda frame_counter
	;and #%1
	;bne doit
	lda frame_bit
	and #%01010101
	bne doit
	rts
doit
#ifdef HERO_AT_SIDE
	lda anim_state
	beq next
	;cmp #4
	;bcc next
	;cmp #8
	;bcs next
	; 0=to right
	; 1=to left
	lda direction
	beq toright
	inc _inicol
	jsr _scroll_stars_left
	jmp next
toright
	dec _inicol
	jsr _scroll_stars_right
next
#endif
	lda anim_state
	cmp #10
	bcc next_step
	; We have finished
	; Put back anim_state to 0
	; Change the direction of the manta sprites
	; Remove primary command
	; increase speed a bit
	;inc speedp
	lda #3
	sta speedp
	lda #0
	sta anim_state
	sta pcommand_h
	jmp change_direction
next_step
	; Do the next step..
	; increment pointers and anim_state
	inc anim_state
	lda sprite_grapl
	clc
	adc #32
	sta sprite_grapl
	bcc nocarry
	inc sprite_graph
nocarry
	lda sprite_maskl
	clc
	adc #32
	sta sprite_maskl
	sta sprite_maskl+1
	bcc nocarry2
	inc sprite_maskh
	inc sprite_maskh+1
nocarry2

    ; At state 2 move the player up
    ; which means:
    ; move the shadow down and right
    ; increase height
    ; decrease speed
	lda anim_state
	cmp #2
	bne no2
	inc sprite_cols+1
	inc sprite_rows+1
    inc sprite_height
	lda #8
	sta speedp
no2
    ; At state 7 move the player down
    ; which means:
    ; move the shadow back up and left
    ; decrease height
    ; increase speed again
	cmp #7
	bne no7
	dec sprite_cols+1
	dec sprite_rows+1
    dec sprite_height
	;inc speedp
no7
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Primary command that makes the manta
; jump.
; The entry point for the command
; is do_jump, but calling
; jump_hero installs it
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#define NUMSTEPS 13
jump_hero
.(
	; If this is the first step
	; prepare the primary command
	lda #<do_jump
	sta pcommand_l
	lda #>do_jump
	sta pcommand_h
	lda #<_manta_jump
	sta sprite_grapl
	lda #>_manta_jump
	sta sprite_graph
	lda #<_mask_jump_manta
	sta sprite_maskl
	sta sprite_maskl+1
	lda #>_mask_jump_manta
	sta sprite_maskh
	sta sprite_maskh+1
	lda #JUMPSFX
	jmp _PlaySfx
	;rts
do_jump
	lda frame_counter
	and #%1
	beq doit
	rts
doit
	lda anim_state
	cmp #NUMSTEPS
	bcc next_step
	; We have finished
	; Put back anim_state to 0
	; Remove primary command
	; increase speed a bit
	;inc speedp
	lda #0
	sta anim_state
	sta pcommand_h
	jmp update_pointers_flat
next_step
	; Do the next step..
	; increment pointers and anim_state
	inc anim_state
	cmp #NUMSTEPS-2
	bcc more
update
	lda sprite_grapl
	clc
	adc #32
	sta sprite_grapl
	bcc nocarry
	inc sprite_graph
nocarry
	lda sprite_maskl
	clc
	adc #32
	sta sprite_maskl
	sta sprite_maskl+1
	bcc nocarry2
	inc sprite_maskh
	inc sprite_maskh+1
nocarry2

more
    ; At state 1 move the player up
    ; which means:
    ; move the shadow down and rigth
    ; increase height
    ; decrease speed
	lda anim_state
	cmp #1
	bne no2
	inc sprite_cols+1
	inc sprite_rows+1
    inc sprite_height
	;dec speedp
	rts
no2
    ; At state final-1 move the player down
    ; which means:
    ; move the shadow back up and left
    ; decrease height
	; signal the sound engine that this is occuring
	cmp #NUMSTEPS-1
	bne no6
	dec sprite_cols+1
	dec sprite_rows+1
    dec sprite_height
	lda #1
	ora SfxFlags
	sta SfxFlags
	rts
no6
	cmp #NUMSTEPS-2
	bcs skip
	; If the player is not pressing JUMP
	; increase the animstate twice
	ldy #4
	lda _KeyBank,y
	and #%10100000
	eor	#%10100000
	beq skip
	inc anim_state
skip	
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Continuous command that makes
; the manta blink and be
; invulnerable for some time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hero_blink
.(
	; If this is the first step
	; prepare the primary command
	lda #<do_blink
	sta ccommand_l
	lda #>do_blink
	sta ccommand_h
	lda #0
	sta skip_hero_drawing
	lda #20
	sta sprite_var1
	; TODO: Play an Sfx...
	rts
do_blink
	dec sprite_var1
	bpl continue
	; Finished with the blinking
	lda #0
	sta ccommand_h
	sta sprite_var1
	sta skip_hero_drawing
	rts
continue
	lda skip_hero_drawing
	eor #$ff
	sta skip_hero_drawing
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Command to explode a ship with
; some retarding passed in reg A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
retarded_explode
.(
	sta sprite_var1,x
	lda #<do_ret_explosion
	sta pcommand_l,x
	lda #>do_ret_explosion
	sta pcommand_h,x
	lda #0
	sta ccommand_h,x
	rts
do_ret_explosion
	dec sprite_var1,x
	bne end
	txa
	tay
	jmp explode_ship
end	
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Primary command that explodes a ship
; The entry point for the command
; is do_explode, but calling
; explode_ship installs it for
; the object id passed in reg Y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
explode_ship
.(
	; If this is the first step
	; prepare the primary command
	lda #<do_explode
	sta pcommand_l,y
	lda #>do_explode
	sta pcommand_h,y
	
	; And remove any continual command
	lda #0
	sta ccommand_h,y
	
	; Stop any movement
	sta speedv,y
	lda #8
	sta speedp,y
	
	
	; Setup the explosion graphic
	lda #<_sprite_explosion
	sta sprite_grapl,y
	lda #>_sprite_explosion
	sta sprite_graph,y
	lda #<_mask_explosion
	sta sprite_maskl,y
	lda #>_mask_explosion
	sta sprite_maskh,y	
	
	; Set the flag
	lda #IS_EXPLODING
	ora sprite_status,y
	sta sprite_status,y
	
	; and set the animatory state to 0
	lda #0
	sta anim_state,y
	
	lda #EXPLODE
	jmp _PlaySfx
	
	;rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Entry point for the explosion
; of a ship passed in reg X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
do_explode
	lda frame_counter
	and #%1
	beq doit
	rts
doit
	lda anim_state,x
	cmp #7
	bcc next_step
	; We have finished
	; If it is not the hero, it may
	; create a new item.
	; Else delete the object
	lda sprite_status
	beq delete_object
	jmp create_item
+delete_object	
	lda #0
	sta pcommand_h,x
	sta sprite_status,x
	sta anim_state,x
	sta speedv,x
	sta speedp,x
	dec waveobjects
	rts

next_step
	; Do the next step..
	; increment pointers and anim_state
	inc anim_state,x
	lda sprite_grapl,x
	clc
	adc #32
	sta sprite_grapl,x
	bcc nocarry
	inc sprite_graph,x
nocarry
	lda sprite_maskl,x
	clc
	adc #32
	sta sprite_maskl,x
	bcc nocarry2
	inc sprite_maskh,x
nocarry2

	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;
; Handler to install a
; Primary command
; to make an object
; disappear.
; This must be done
; here this way to make
; it be removed correctly
; without corrupting radar
;;;;;;;;;;;;;;;;;;;;;;;;;;
do_remove_object
.(
	lda #<delete_object
	sta pcommand_l,x
	lda #>delete_object
	sta pcommand_h,x
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Primary command that
; controls a laser shot
; The entry point for the command
; is do_shot, but calling
; control_shot installs it
; Shot id is in reg X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
control_shot
.(
	lda #SHOT_LENGTH	; Steps during which the shot is active
	sta anim_state,x
	; prepare the primary command
	lda #<do_shot
	sta pcommand_l,x
	lda #>do_shot
	sta pcommand_h,x
do_shot
	dec anim_state,x
	bne keepit
	; Shot must disappear
end_shot	
	lda #0
	sta sprite_status,x
	sta pcommand_h,x
	rts
keepit
	; Check for hits
	ldy #FIRST_SHOT-1
loop
	; Is this ship active?
	lda sprite_status,y
	beq skip
	
	; Is it exploding?
	and #IS_EXPLODING
	bne skip
	
	; Did the shot collide with it?
	sec
	lda sprite_cols,x
	sbc sprite_cols,y
	beq may_hit
	cmp #1
	;beq may_hit
	;cmp #$ff
	bne skip
may_hit
	sec	
	lda sprite_rows,x
	sbc sprite_rows,y
	beq hit
	cmp #1
	;beq hit
	;cmp #$ff
	bne skip
hit	
	; Final check... is it an item?
	lda sprite_type,y
	; TODO: CHECK: WE CANNOT USE THE DEFINED LABEL FIRST_ITEM HERE!!!
	cmp #9
	bcs skip
	
	; Aha: a ship was hit, add score, delete shot and make it explode	
	sty savy+1
	tay
	lda enemy_points,y
	jsr add_score
savy
	ldy #0
	lda super_shot
	bne ss1
	jsr end_shot
ss1	
	jmp explode_ship
skip
	dey
	cpy #1	; Avoid checking the hero
	bne loop
	
	; If a shot hits a barrier it should stop
	; If hits a target on the ship, it must destroy it
	lda #0
	sta tmp
	lda sprite_rows,x
	clc
	adc #>_start_rows
	sta tmp+1
	ldy sprite_cols,x
	jsr checkit
	
	lda sprite_dir,x
	bmi goleft
	iny
	jmp checkit
goleft
	dey
checkit
	jsr check_objective
	lda super_shot
	bne ss2
	bcs end_shot
ss2	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; checks if the shot
; hits an objective and
; destroys it.
; Also checks if it is a barrier
; to stop the shot.
; Returns carry set if any of the
; above conditions is true
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_objective
.(
	lda (tmp),y
	cmp #38+$20
	bne not_single
	; An objective of a single square... easy as a pie
	lda #43+$20
	sta (tmp),y
	; add score or bonus, etc.
	lda #1
	jmp destroyer	; Jumps always
not_single
	cmp #42+$20+1
	bcs not_objective
	cmp #39+$20
	bcc not_objective
	; An objective of 4 tiles
	; shouldn't be difficult...
	; Save reg Y
	sty savy+1
	ror
	bcs odd
	dey
odd
	lda tmp+1
	ror
	; TODO: CHECK THIS AS THE LOGIC CHANGES WITH THE VALUE OF THE BASE PAGE
	; CREATING WRONG CRATERS OVER THE SHIP SURFACE
	bcc even
	;bcs even 
	dec tmp+1
even
	lda #44+$20
	sta (tmp),y
	iny
	lda #45+$20
	sta (tmp),y
	inc tmp+1
	dey
	lda #44+$20
	sta (tmp),y
	iny
	lda #45+$20
	sta (tmp),y
	lda #2
destroyer	
	; TODO: A LOT HERE	
	; add score or bonus, check for
	; power ups...
	sed
	clc
	adc ship_destruction_bonus
	bcc isok
	lda #$99 
isok
	sta ship_destruction_bonus
	cld
.(
	lda beginner_mode
	and bm_objective
	beq skipprintbm
	stx savx+1
	dec bm_objective
	lda #90	
	jsr print_beginner_msg
savx
	ldx #0
skipprintbm	
.)	
	lda #EXPLODE
	jsr _PlaySfx
savy
	ldy #0
	sec
	rts
not_objective
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Checks if a tile is a barrier
; and returns carry set if so
; else returns carry clear
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_barrier
.(
	lda (tmp),y
	cmp #BARRIER_START
	bcc nobarrier
	cmp #BARRIER_START+2
	bcc yesbarrier
	cmp #BARRIER_START+4
	bcs nobarrier
	; it is BARRIER_START+2 or +3
	; Are we on odd or even?
	lda tmp+1
	ror
	bcs nobarrier	
yesbarrier
	sec
	rts
nobarrier
	clc
	rts
.)




exp_cols
	.byt $00,$00,$ff,$01,$fe,$02,$ff,$01
exp_rows
	.byt $00,$ff,$01,$ff,$00,$00,$00,$ff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Primary command for exploding the
; hero's ship
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
explode_hero
.(
	; Stop the hero
	lda #8
	sta speedp
	lda #0
	sta speedv
	lda #0
	sta ccommand_h
	sta anim_state
	sta sprite_var1
	
	; Unfreeze enemies
	sta frozen_enemies
	
	; Remove hero
	sta sprite_status+1
	;lda #0
	sta sprite_status
	
	; Set sprites to positions for explosions
	ldx #FIRST_SHOT-1
loop
	; Set the sprite to explode
	txa
	jsr retarded_explode
	
	; Locate this sprite
	lda sprite_cols
	clc
	adc exp_cols-2,x	
	sta sprite_cols,x
	lda sprite_rows
	clc
	adc exp_rows-2,x
	bpl okrow1
	lda #0
okrow1
	cmp #20
	bcc okrow2
	lda #19
okrow2	
	sta sprite_rows,x
	lda #8
	sta speedp,x
	lda #0
	sta speedv,x
	sta sprite_status,x
	
	dex
	cpx #1
	bne loop
	
	; Wait until it all finishes...
	lda #100
	sta sprite_var1
	lda #<do_wait
	sta pcommand_l
	lda #>do_wait
	sta pcommand_h
	
	; Refill energy
	lda #INITAL_ENERGY
	sta energy

	; Adjust number of objectives for onslaught mode
	lsr total_enemies
	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Command to wait and
; re-initialize the level
; again with one life less
;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
do_wait
.(
	dec sprite_var1
	beq end
	rts
end
	; Waited long enough
	
	; Clear screen
	jsr _clear_backbuffer
	jsr waitirq
	jsr _dump_backbuffer
	
	; Get rid of context
	pla
	pla

	; Stop sound for a moment...
	jsr StopSound
	jsr _StartPlayer
	
	; Remove one life, check if no lives left and jump
	; to either _init or next try
	dec lives
	bpl onemore
	; See ya later aligator..
	jsr game_over
	jmp _init
onemore	
	jsr update_lives
	; Continue playing
	jmp _run_level
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; COMMANDS FOR SHIP MOVEMENT AND AI
; This can be combined for creating
; more complex behaviors.
; First some which are rather
; simple and intended to be
; combined.
; For those, no check of reac_speed
; is done.
; Some more complex follow.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Command for avoiding shots
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
avoid_shots
.(
	;lda frame_counter
	;and reac_speed,x
	;bne end

	ldy #FIRST_SHOT
loopshots	
	; Check if shot is active
	lda sprite_status,y
	beq next
	
	; It is, check if it is nearby
	sec
	lda sprite_cols,y	
	sbc sprite_cols,x
	bpl noneg
	sta tmp
	lda #$ff
	sbc tmp
noneg
	cmp #16
	bcs next
	
	; It is, are we on the same row?
	sec
	lda sprite_rows,y
	sbc sprite_rows,x
	bne nosame
	lda #1
	bne store	; Jumps always
nosame
	cmp #1
	bne nodanger
	lda #$ff
	.byt $2c	
nodanger
	lda #0
store	
	sta speedv,x
	bne end
next
	iny
	cpy #(MAX_SPRITES+1)
	bne loopshots
end	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;r;;;;;;;;
; Command for making a ship 
; disappear when reaching 
; a border
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disappear_at_border
.(
	ldy sprite_cols,x
	cpy #0
	bne cont
	jmp delete_object
cont
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Primary command for the simplest
; back and forth movement. When near
; the edge, turn around
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_lateral_and_back
.(
	ldy sprite_cols,x
	lda sprite_dir,x
	bmi checkleft
	cpy #250
	bcs turn
	rts
checkleft
	cpy #6
	bcc turn
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Primary command for the simplest
; up&down movement.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_up_and_down
.(
	lda speedv,x
	bne check
	inc speedv,x
check
	lda sprite_rows,x
	bne notup
	lda #1
store	
	sta speedv,x
return	
	rts
notup	
	cmp #18
	bne return
	lda #$ff
	bne store
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Command for lateral movement
; with random up/down steps
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lateral_rnd_updown
.(
	jsr randgen
	cmp #150
	bcs doit
	rts
doit
	lda speedv,x
	beq updown
	lda #0
	sta speedv,x
	rts
updown	
	lda randseed
	bmi up
	lda #1
	.byt $2c
up
	lda #$ff
	sta speedv,x
	rts
.)	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Combination of lateral
; movement and avoiding
; of shots
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lateral_avoidshots
.(
	jsr disappear_at_border	
	lda frame_counter
	and #%11
	bne retme
	jsr lateral_rnd_updown
	jmp avoid_shots
retme
	rts
.)


; Helper to make a ship turn
turn
.(
	lda sprite_dir,x
	bmi set1
	lda #$ff
	.byt $2c
set1
	lda #1
	sta sprite_dir,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Accelerates a ship, if possible
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
accelerate_ship
.(
	lda speedp,x
	cmp max_speed,x
	bcs retme
	inc speedp,x
retme
	rts 
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Deccelerates a ship, changing
; direction if necessary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
deccelerate_ship
.(
	lda speedp,x
	beq changedir
	dec speedp,x
	rts
changedir
	jsr turn
	inc speedp,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Primary command for lateral movement
; around the ship
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lateral_advanced
.(
	lda frame_counter
	and reac_speed,x
	beq doit
	rts
doit
	jsr lateral_rnd_updown
	jsr avoid_shots

	; check our position compared to the hero
	lda sprite_dir,x
	bmi looking_left
	; We are looking left
	lda sprite_cols
	cmp sprite_cols,x
check	
	bpl accelerate_ship ;We are still not there!
	; We just passed the ship, slow down and go start up/down movement
	jmp deccelerate_ship
looking_left
	lda sprite_cols,x
	cmp sprite_cols
	jmp check
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Primary command for elliptical movement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_elliptical
.(
	lda frame_counter
	and reac_speed,x
	beq doit
	rts
doit
	; check our position compared to the hero
	lda sprite_dir,x
	bmi looking_left
	; We are looking left
	lda sprite_cols
	cmp sprite_cols,x
check	
	bpl accelerate_ship ;We are still not there!
	; We just passed the ship, slow down and go start up/down movement
	jsr deccelerate_ship
	lda sprite_rows,x
	ldy speedv,x
	bmi goingup
	bne goingdown
	; Should we go up or down?
	cmp #10
	bcc godown
	bcs goup
goingdown
	cmp #15-2
	bcs stopv
	rts
goingup
	cmp #4+2+1
	bcc stopv
	rts
stopv	
	lda #0
	sta speedv,x
	rts
	
godown
	lda #$1
	.byt $2c
goup	
	lda #$ff
	sta speedv,x
	rts
looking_left
	lda sprite_cols,x
	cmp sprite_cols
	jmp check
	
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Command for making a ship 
; move elliptically avoiding shots
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
elliptical_advanced
.(
	jsr move_elliptical
	lda frame_counter
	and #%11
	bne retme
	jmp avoid_shots
retme
	rts
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Command to make an enemy ram
; the hero...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ram_hero
.(
	lda frame_counter
	and reac_speed,x
	beq doit
	rts
doit
	; check our position compared to the hero
	lda sprite_dir,x
	bmi looking_left
	; We are looking left
	lda sprite_cols
	cmp sprite_cols,x
check	
	bmi deccel_him 
	jsr accelerate_ship ;We are still not there!
	jmp check_row
	; We just passed the ship, slow down and go start up/down movement
deccel_him	
	jsr deccelerate_ship
check_row	
	lda sprite_rows,x
	cmp sprite_rows
	beq same_row
	bcs below_hero
	; We are above hero
	lda #1
	.byt $2c
below_hero
	; We are below hero, go up ..
	lda #$ff
	.byt $2c
same_row	
	lda #0
	sta speedv,x
	rts
looking_left
	lda sprite_cols,x
	cmp sprite_cols
	jmp check
.)	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Routine to make the mothership explode.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
explode_mothership
.(
	; Stop the hero
	lda #8
	sta speedp
	lda #0
	sta speedv

	; Remove all the objects
.(	
	ldx #MAX_SPRITES
loop
	lda sprite_status,x
	beq next ; don't do anything, it is not active
	lda #0
	sta sprite_status,x
	jsr do_remove_object
next
	dex
	;cpx #1	; Leave hero and his shadow alone
	;bne loop
	bpl loop
.)
.(
loop
	jsr _scroll_stars_left
	; This is usually done in mainloop when drawing,
	; but not this time...
	lda smc_updatestar+1
	beq skip
	sta _star_tile+3
	lda #0
	sta smc_updatestar+1
skip	
	inc _inicol
	lda _inicol
	cmp #255-40+PCOLSL
	bcc loop
.)	

	; Install a primary command for hero to make the
	; ship evaporate
	lda #<big_explode
	sta pcommand_l
	lda #>big_explode
	sta pcommand_h
	
	lda #$ff
	sta anim_state
	rts
	
	; Entry point for the routine to make
	; the mother ship evaporate
	; This is called from within the hero's primary
	; command
big_explode
	ldy anim_state
	beq end
	stx savx+1

	; Copy the wreckage tile into
	; 94 in std and alt charsets
.(	
	ldx #7
loop	
	jsr randgen
	lda randseed
	sta $b400+94*8,x
	and randseed+1
	sta $b800+94*8,x
	lda tile_explode,x
	and randseed
	sta $b400+92*8,x
	and randseed+1
	sta $b800+92*8,x

	dex
	bpl loop
.)


	ldx #20

	lda #>_start_rows
	sta tmp+1
	lda #00
	sta tmp
bexplode_loop
	lda (tmp),y
	cmp #$20
	beq skip
	lda #92
	sta (tmp),y
	
	dey
	lda (tmp),y
	cmp #$20
	beq skip2
	lda #94
	sta (tmp),y
skip2
	iny
skip	
	iny
	lda #$20
	sta (tmp),y
	dey

	inc tmp+1
	dex
	bne bexplode_loop

	dec anim_state
	tya
	sec
	sbc #25
	cmp _inicol
	bcs notyet
	dec _inicol
	jsr _scroll_stars_right
notyet	
savx
	ldx #0
	rts	
end
	; Get rid of context
	pla
	pla

	lda level
	cmp #LAST_LEVEL+1
	bne nolast
	jsr	do_outro
	jmp _init
nolast	
	jsr end_level_screen
	jmp _next_level
.)


