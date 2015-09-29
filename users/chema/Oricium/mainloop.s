;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Code with main entry point and game loop

#include "params.h"
#include "sfx.h"

.zero
tmp0	.dsb 2
tmp1	.dsb 2
tmp2	.dsb 2
tmp3	.dsb 2
tmp4	.dsb 2
tmp5	.dsb 2
tmp6	.dsb 2
tmp7	.dsb 2
tmp		.dsb 2

.bss
_free_hires 		.dsb ($9800-*)
_hires_stdcharset 	.dsb ($9c00-*)
_hires_altcharset 	.dsb ($a000-*)
_hires_text_mix 	.dsb ($b400-*)
_text_stdcharset 	.dsb ($b800-*)
_text_altcharset 	.dsb ($bb80-*)
_text_screen		.dsb ($bfe0-*)
_spare				.dsb ($c000-*)
.text

#define _std_charset $b500
#define _alt_charset $b900
#define bwidth  tmp2
#define bheigth tmp2+1
#define _star_tile  $bab0

; Game's entry point
_main
.(
	; Initialize some variables
	lda #0
	sta isr_plays_sound
	sta GlobalVolume
	
	lda #1
	sta audio_on

	; Copy charset to alt hires charset
	jsr charset_to_althires	
	
	lda #A_ALT
	sta $bf90
	
	lda #%11111110
	and $26a
	sta $26a
	
	; Ask the user to press key
	ldy #26
	lda #3
	jsr print_string_centered
.(
loop	
	lda $02df   
	beq loop
.)

	
	; Clear HIRES memory
	lda #<$a000
	sta tmp
	lda #>$a000
	sta tmp+1
.(
	ldx #200
loopp
	lda #$0
	ldy #$39
loop
	sta (tmp),y
	dey
	bpl loop
	lda tmp
	clc
	adc #40
	sta tmp
	bcc ncc
	inc tmp+1
ncc
	dex
	bne loopp
.)


	lda #A_TEXT50 
	sta $bb80
	
	;jsr clear_score_area
	;jsr common_text_ext
	;jsr set_graphic_attributes
	
	; Copy tileset to correct place
	; source tmp0, dest tmp1
	lda #<__Row0
	sta tmp0
	lda #>__Row0
	sta tmp0+1
	lda #<_std_charset
	sta tmp1
	lda #>_std_charset
	sta tmp1+1

.(
	ldx #2
loopp	
	ldy #$0
loop	
	lda (tmp0),y
	sta (tmp1),y
	dey
	bne loop
	inc tmp0+1
	inc tmp1+1
	dex
	bne loopp
.)	

	
	lda #<__Row2
	sta tmp0
	lda #>__Row2
	sta tmp0+1
	lda #<_alt_charset
	sta tmp1
	lda #>_alt_charset
	sta tmp1+1

.(
	ldx #2
loopp	
	ldy #$0
loop	
	lda (tmp0),y
	sta (tmp1),y
	dey
	bne loop
	inc tmp0+1
	inc tmp1+1
	dex
	bne loopp
.)	


	
	; Put the charset in
	jsr swap_charsets

	
	; Get the syncro with the vertical retrace
	jsr perform_vsync
	
	; Start the sound engine
	jsr _StartPlayer
	jsr _SetSFX

	; Display one time intro, & credits

	; Put tileset back
	jsr swap_charsets
	
	; Initialize decoration flags to 0
	jsr initialize_flags
	
	; And start the game!
	; Do not issue an RTS here
.)
_gameinit
.(
    ; One-time after game load initializations 
	jsr _InitISR

	; Initialize the shadow as a null sprite
	lda #<_sprite_null
	sta sprite_grapl+1
	lda #>_sprite_null
	sta sprite_graph+1

	; Initialize energy ball tile (25+$20)
	.(
		ldx #7
loop
		lda energy_on_floor,x
		sta _alt_charset+ENERGYBALL_TILE*8,x
		dex
		bpl loop
	.)

	; Initialize the frame counter
	lda #0
	sta frame_counter
	; Do not issue an RTS here
.)
_init
.(
	; Initializations for each game run
	; Ok, now prepare play area

	jsr _clear_bottom_text_area
	jsr draw_logo
	jsr _prepare_play_area
	
	; Set up the menu
	jsr menu

	; Sets SFX
	jsr _SetSFX
	
	; Set up all player space+3bytes for leds
	lda #0
	ldx #8
loopps	
	sta _begin_player_space,x
	dex
	bpl loopps
	
	; Number of lives
	lda #PLAYER_LIVES
	sta lives
	
	; Initial energy
	lda #INITAL_ENERGY
	sta energy

	; Set passcode data as invalid
	lda #0
	sta passcode_valid
	
	; Draw panel and radar
	jsr draw_scoreboard
	jsr _prepare_bottom_text_area
	jsr _prepare_play_area
	
	; Initialize panel
	jsr init_panel
	
	; Initalize procedural generator
	jsr init_levels

	; TEST A GIVEN LEVEL (Put level to go -1 and zero based -1 again)
	/*
	lda #42-2
	jsr goto_level
	jsr init_panel
	*/
	
	; Do not issue an RTS here
.)
_next_level
.(
	lda #0
	sta ship_destruction_bonus
	
	jsr set_next_level
	; Clear the play area
	jsr clear_ship
	; Create the ship for this level
	jsr generate_ship	
	; Do not issue an RTS here
continue	
.)
_run_level
.(
	jsr _SetSFX
	
	; Text to introduce current level
	jsr introduce_level

	jsr color_level
	jsr switch_codes_level
	
	; Create set of stars
	jsr _create_stars
	
	; Initialize variables
	lda #0
	sta _inicol
	sta direction
	sta waveobjects
	sta skip_hero_drawing
	; Signal no switch is being pressed
	sta switch_pressed
	; No powerups
	sta super_shot
	sta quick_shot
	sta frozen_enemies 

	
	;sta frame_counter ; DO NOT RESET - LEAVE THIS RUN FOREVER!!!
	
	; Frame bit and heigth of manta
	lda #1
	sta frame_bit
	sta sprite_height

	; Vertical position & speed of Manta
	ldx #MANTA_ROW
	stx sprite_rows
	inx
	stx sprite_rows+1
	
	ldx #MANTA_COL
	stx sprite_cols
	inx
	stx sprite_cols+1	
	
	; Horizontal speed of Manta
	lda #4
	sta speedp
	sta speedp+1

	; Set back all the sprite data to
	; initial status:
	; -status and direction bytes to 0
	; -Graphic pointers
	; -Animatory states
	; -AI commands
	lda #0
	ldx #MAX_SPRITES
loop
	sta sprite_dir,x
	sta sprite_status,x
	sta anim_state,x
	sta pcommand_h,x
	sta ccommand_h,x
	sta speedv,x
	sta sprite_type,x
	dex
	bpl loop
	
	; Mark no recent shot
	;lda #0
	sta just_shot
	
	; Nor from the boss
	sta boss_shooting
	
	; Put back pointers to original graphics for Manta
	jsr update_pointers_flat
	
	; Mark Manta as active
	lda #1
	sta sprite_status
	sta sprite_status+1
	

	; Initialize score panel
	jsr init_panel
	
	; Draw the radar
	jsr _draw_radar

	; Create initial set of enemies
	jsr create_wave
	
	; Do not issue an RTS here
.)

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_game_loop
.(
	; Check if in demo mode
	;lda game_mode
	;bne play_mode
	
	; TODO: Everything...
	; Generate simulated user input
	; Change to Hall of Fame, title, 
	; or instructions screen from time to time...
	;jsr ReadKey
	;beq whereverisneeded

	; A key was pressed, exit demo mode.
	;lda #1
	;sta game_mode

	; Jump to initalizations and main loop
	;jmp _init

play_mode
	; Draw radar... 
	jsr _draw_radar

	; Check if we are in onslaught mode
	lda onslaught
	beq normal_mode
	lda total_enemies
	cmp #NUM_ENEMIES_ONSLAUGHT
	bcc noend
	lda waveobjects
	bne noend
	lda #0
	sta total_enemies

finish_special_mode	
	jsr destroy_tune
	jsr end_level_screen
	jmp _next_level

normal_mode	
	; If in boss mode...
	lda boss_mode
	beq no_boss_mode
	lda ship_destruction_bonus
	cmp #$74
	bcc noend
	lda #0
	sta boss_mode
	lda #$99
	sta ship_destruction_bonus
	bne finish_normal_mode ; Always jumps

no_boss_mode	
	; Check if ship is destroyed
	lda blinkleds
	bne noend
	lda ledstatus
	cmp #%1111
	bne noend
	lda #0
	sta ledstatus
	sta blinkleds
	
finish_normal_mode
	jsr explode_mothership
	jsr destroy_tune
noend
	
	; If it is time to create enemies, call
	; create_wave.
	; TODO: This could be modified to create enemies
	; faster when in higher levels.

	; If hero inactive (whatever the reason)
	; skip
	lda sprite_status
	beq heroinactive
	
	lda frame_counter
	and #%00111111
	bne skipwave
	jsr create_wave
skipwave
	
	; Check if it is time to scroll
	; depending on the ship's speed in
	; horizontal movement.
	ldy speedp
	lda tab_speedh,y
	and frame_bit
	beq skipit

doscroll	
	; Ok, we need to scroll

	; Check the movement
	; direction
	; 0=to right
	; 1=to left
	lda direction
	bne go_back

	; We are going right,
	; check if we reached the border
	; to change direction
	lda _inicol
	cmp #255-28+2
	bne no_border
	
	; If we arrived here, it means
	; that we reached the right border
	; If we are in labyrinth mode, we have
	; cleared the level
	lda labyrinth_mode
	beq border_reached
	bne finish_special_mode	; always jumps
	
border_reached
	; We reached the border (either left or right)
	lda #4
	sta speedp
	lda pcommand_h
	bne skip
	jsr loop_hero
skip	
	jmp skipit
no_border
	; No border reached yet
	; Update position and area
	; of view
	inc _inicol
	inc sprite_cols
	inc sprite_cols+1
	; Scroll 2nd plane stars
	jsr _scroll_stars_left

	jmp skipit
go_back
	; We are going left
	; check if we reached the border
	; to change direction 
	lda _inicol
	beq border_reached

	; No border reached yet
	; Update position and area
	; of view
	dec _inicol
	dec sprite_cols
	dec sprite_cols+1

	; Scroll 2nd plane stars
	jsr _scroll_stars_right
skipit

	; Check for collisions if the hero is active
	lda sprite_status
	beq nocolcheck
	; and not high above
	lda sprite_height
	cmp #2
	beq nocolcheck
	;jsr collision_check
	jsr barrier_check
nocolcheck		

heroinactive
	;Process keyboard 
    jsr ReadKeyboard 	
	; Get user input
	jsr user_control

	; Calling core routines	
	; Move all the sprites, calling the AI
	jsr move_sprites		
	
	; Draws the radar at the bottom
	jsr _draw_radar
	
	; Clear the back buffer and render the ship and stars
getme	
	;jsr _clear_backbuffer
	jsr _render_background

	; Update sprite tiles to use this frame
	; Using two sets alternatively avoids having to draw them
	; while the screen is not being refreshed, which was too
	; tight when more than 5-6 sprites on screen.
	; Drawback: we duplicate the tiles needed :/
	lda frame_counter
	and #1	
	beq ones
	lda #$de	; Opcode for dec abs,x
	.byt $2c
ones
	lda #$fe    ; Opcode for inc abs,x
	sta loop
	ldx #(MAX_SPRITES+1)*4-1
loop
	inc sprite_tile11,x
	dex
	bpl loop

	; Draw the sprites over the background
	jsr _put_sprites
	
	; Some other things here... printing the number of irqs used
#ifdef DISPLAY_FRC
	jsr _init_print
	lda irq_detected
	jsr printnum
#endif

/*
	lda screen_color
	pha
	lda #A_FWRED
	sta screen_color
	jsr set_color
*/

	; Now let's synchronize with the vbl
	jsr waitirq

	; Done, now we are (hopefully) on the BLANK period, dump 
	; the double buffer quickly
	jsr _dump_backbuffer

	; Update the star tile if it needs be
	; modified by the star scrolling routine
	; using Self Modifying Code.
	; This must be deferred here to avoid
	; tearing.
+smc_updatestar
	lda #0	;SMC
	beq noupdate
	sta _star_tile+3
	lda #0
	sta smc_updatestar+1
noupdate

#ifdef ANIM_RUNWAY
	lda frame_counter
	lsr
	bcc skiprwanim
	
	ldx #7
looprunway
	lda _std_charset+36*8,x
	and #%00111111
	lsr
	bcc skip1
	ora #%00100000
skip1	
	sta _std_charset+36*8,x
	
	lda _alt_charset+36*8,x
	and #%00111111
	lsr
	bcc skip2
	ora #%00100000
skip2	
	sta _alt_charset+36*8,x
	dex
	bpl looprunway
skiprwanim
#endif

	; Done, we should have used as less cycles as possible in this part.

	; If enemies are frozen, decrement this counter
	lda frozen_enemies
	beq notfrozen
	dec frozen_enemies
	bne notfrozen
	lda #ALERT2
	jsr _PlaySfx
	
notfrozen	
	; Check if we need to blink leds
	; Only if hero is not exploding...
	lda sprite_status
	beq skipblink
	lda frame_counter
	and #%111
	bne skipblink
	lda blinkleds
	beq skipblink
	dec blinkleds
	lsr
	bcs new
	lda old_ledstatus
	jsr update_leds_ex
	jmp skipblink
new	
	jsr update_leds
	lda blinkleds
	bne skipblink
.(
	lda beginner_mode
	and bm_switch2
	beq skipprintbm
	dec bm_switch2
	lda #88	
	jsr print_beginner_msg
	lda #93
	jsr print_beginner_msg
skipprintbm	
.)
skipblink
	
	; Animate the energy balls
	lda frame_counter
	and #%111
	tax
	ldy tab_enframe,x
.(
	ldx #7
enloop
	lda energy_on_floor,y
	sta _alt_charset+ENERGYBALL_TILE*8,x
	dey
	dex
	bpl enloop
.)
skip_balls


	lda sprite_height
	cmp #2
	beq nocolcheck2
	jsr collision_check
	jsr check_energy
	; If in onslaught, facing a boss or labyrinth mode, no switches
	lda onslaught
	ora labyrinth_mode
	ora boss_mode
	bne nocolcheck2
	jsr switch_check
nocolcheck2	


	; Background sfx
	lda sprite_status
	beq skip_bkgsfx
	
	lda frame_counter
	ldx labyrinth_mode
	bne labtune
	and #%11111
	bne skip_bkgsfx
	lda #ZUMZUM
	bne doplay ; always jump
labtune
	and #%11111111
	bne skip_bkgsfx
	lda #LABSFX
doplay	
	jsr _PlaySfx
skip_bkgsfx	

	
	; Call the snd engine
	lda isr_plays_sound
	bne nomusicyet
	lda MusicPlaying
	and audio_on
	beq nomusicyet
	jsr ProcessMusic
nomusicyet
	
	
	; Flag to space player's shots a bit
	lda just_shot
	beq noshotcheck
	dec just_shot
noshotcheck	

	; Increment frame counting
	inc frame_counter
	
	; And frame bit, used for movement syncrho
	asl frame_bit
	bcc end
	rol frame_bit
	;lda frame_bit
	;ora #%1
	;sta frame_bit
end	



	; Jump back to the main loop
	jmp _game_loop
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move the sprites
;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_sprites
.(
	ldx #MAX_SPRITES
loop
	; Are enemies frozen?
	lda frozen_enemies
	beq notfrozen
	
	;Not a shot
	cpx #FIRST_SHOT
	bcs notfrozen
	
	; Active and not exploding
	lda sprite_status,x
	beq skip
	and #IS_EXPLODING
	bne notfrozen
	; and if it is not an item ... then skip movement
	lda sprite_type,x
	cmp #8
	bcc skip
		
notfrozen	
	; Is sprite active?
	;lda sprite_status,x
	;beq skip

	; Check if it has a continual command and jsr to it
	lda ccommand_h,x
	beq noccommand
	sta smc_jmpc+2
	lda ccommand_l,x
	sta smc_jmpc+1
smc_jmpc
	jsr $1234	

noccommand	
	; Check if it has a primary command and jsr to it
	lda pcommand_h,x
	beq noprimcommand
	sta smc_jmp+2
	lda pcommand_l,x
	sta smc_jmp+1
smc_jmp
	jsr $1234

+noprimcommand
	
	; Move horizontally if it is the
	; right time
	ldy speedp,x
	lda tab_speedh,y
	
	and frame_bit
	beq nomoveh

	; Move the sprite
	lda sprite_cols,x
	clc
	adc sprite_dir,x
	sta sprite_cols,x
nomoveh
	
	; The same for vertical movement.
	; This is simpler, up or down. No speed...
	lda frame_counter
	and #%1
	bne skip

	lda speedv,x
	beq skip
	clc
	adc sprite_rows,x
	bmi skipv
	cmp #20-1
	bcs skipv
	sta sprite_rows,x
skipv
	cpx #1
	bcs skip
	; For the player, stop movement
	
	lda #0
	sta speedv,x

skip
	; Done, onto next character
	dex
	cpx #1	; Up to player's shadow
	bne loop
.)

/* Player movement is a bit different, and also moves the shadow */
move_player
.(
	; Update ship's speed, direction, etc... 
	; Only vertically
	lda frame_counter
	and #%1
	bne nohmove

	lda speedv
	clc
	adc sprite_rows
	bmi nohmove
	cmp #19
	bcs nohmove
	sta sprite_rows
	lda speedv
	clc
	adc sprite_rows+1
	sta sprite_rows+1
nohmove
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Checks for collisions between the enemies and
; the player. Also handles items.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
collision_check
.(
	ldx #FIRST_SHOT-1
loop
	; Is sprite active?
	lda sprite_status,x
	beq skip
	
	;Is it exploding?
	and #IS_EXPLODING
	bne skip
	
	; Check if it intersects with the hero
	; first the column
	lda sprite_cols,x
	sec
	sbc sprite_cols
	beq cancrash
	cmp #1
	beq cancrash
	cmp #$ff
	bne skip
cancrash
	; now the row
	lda sprite_rows,x
	sec
	sbc sprite_rows
	beq crash
	cmp #1
	beq crash
	cmp #$ff
	beq crash
skip
	dex
	cpx #1
	bne loop
end	
	rts
crash
	; Check if it is an enemy or an item
	lda sprite_type,x
	; TODO: CHECK: WE CANNOT USE THE DEFINED LABEL FIRST_ITEM HERE!!!
	cmp #9
	bcc enemycrash
	jmp get_item
	; It is an enemy, crash	
enemycrash
	lda ccommand_h
	beq skipcheck
	rts
skipcheck
	lda sprite_type,x
	cmp #8	; Boss shot
	bne nobossshot
	; Make boss shot explode
	txa
	tay
	jsr explode_ship
nobossshot	
	lda energy
	sec
	sbc #ENLOS_COLLISION
	bcc theend
	sta energy
	jsr hero_blink
	jsr update_energy_meter
	lda #ALERT
	jmp _PlaySfx
theend	
	lda #0
	sta energy
	jsr update_energy_meter
	jsr _draw_radar
+crash2	; Entry point for collision with barriers
	jmp explode_hero
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check collision of hero
; with barriers. is_barrier is 
; already implemented in script.s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
barrier_check
.(
	lda #0
	sta tmp
	lda sprite_rows
	clc
	adc #>_start_rows
	sta tmp+1
	ldy sprite_cols
	jsr is_barrier
	bcs crash2
	iny
	jsr is_barrier
	bcs crash2
	dey
	inc tmp+1
	jsr is_barrier
	bcs crash2
	iny
	jsr is_barrier
	bcs crash2
	rts	
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Checks contact with energy bonus
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_energy
.(
	lda #0
	sta tmp
	lda sprite_rows
	clc
	adc #>_start_rows
	sta tmp+1
	ldy sprite_cols
	jsr check_en_tile
	iny
	jsr check_en_tile
	dey
	inc tmp+1
	jsr check_en_tile
	iny
	jmp check_en_tile
.)

check_en_tile
.(
	lda sprite_height
	cmp #1
	bne retme
	
	lda energy
	cmp #31
	beq retme
	
	lda tmp+1
	ror
	; TODO: CHECK THIS AS THE LOGIC CHANGES WITH THE VALUE OF THE BASE PAGE
	; CREATING WRONG CRATERS OVER THE SHIP SURFACE
	bcs odd
retme
	rts
odd
	lda (tmp),y
	cmp #ENERGYBALL_TILE+$20
	bne retme
	; it is... 
.(
	lda beginner_mode
	and bm_energy
	beq skipprintbm
	dec bm_energy
	lda tmp
	pha
	lda tmp+1
	pha
	lda #89	
	jsr print_beginner_msg
	pla 
	sta tmp+1
	pla
	sta tmp
skipprintbm	
.)
	
	; Add, make sfx and clear the tile
	lda #13+$20
	sta (tmp),y
	inc energy
	jsr update_energy_meter	
	lda #PICKA
	jmp _PlaySfx
	;rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if hero presses
; a switch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#define fill_r		tmp2
#define fill_c		tmp2+1
switch_check
.(
	ldx #3
loop
	; Check if it intersects with the hero
	; first the column
	lda switch_cols,x
	sec
	sbc sprite_cols
	beq canpress
	cmp #1
	beq canpress
	cmp #$ff
	bne skip
canpress
	; now the row
	lda switch_rows,x
	sec
	sbc sprite_rows
	beq press_switch
	cmp #1
	beq press_switch
	cmp #$ff
	beq press_switch
skip
	dex
	bpl loop
end	
	lda #0
	sta switch_pressed
	rts
+press_switch
	; A switch (in reg X) has been pressed
	lda switch_pressed
	beq doit
	rts
doit	
	; Make X 1-based (accesses to arrays will 
	; have the -1,x hereafter) so anything
	; different from zero in switch_pressed
	; indicates the switch which has been
	; pressed.
	inx
	stx switch_pressed

	; Invert its state
	lda switch_state-1,x
	eor #$ff
	sta switch_state-1,x
	tay
	
	lda blinkleds
	bne skipb
	lda ledstatus
	sta old_ledstatus
	lda #5
	sta blinkleds
skipb	
	lda switch_eor_codes-1,x
	eor ledstatus
	and switch_and_codes-1,x
	sta ledstatus
	; Change the pic accordingly
	lda switch_cols-1,x
	sta fill_c
	lda switch_rows-1,x
	sta fill_r
	ldx #BASE_SWITCH
	cpy #0
	beq unpressed
	inx
	inx
unpressed
	jsr put_squared_object
.(
	lda beginner_mode
	and bm_switch
	beq skipprintbm
	dec bm_switch
	lda #87	
	jsr print_beginner_msg
skipprintbm
.)
	jsr update_leds
	lda #SFX_SWITCH
	jmp _PlaySfx
.)

switch_eor_codes .dsb 4
switch_and_codes .dsb 4
