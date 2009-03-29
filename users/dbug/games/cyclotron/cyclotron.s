
;// --------------------------------------
;// Cyclontron
;// --------------------------------------
;// (c) 2004 Mickael Pointier
;// This code is provided as-is.
;// I do not assume any responsability
;// concerning the fact this is a bug-free
;// software !!!
;// Except that, you can use this example
;// without any limitation !
;// If you manage to do something with that
;// please, contact me :)
;// --------------------------------------
;// For more information, please contact me
;// on internet:
;// e-mail: mike@defence-force.org
;// URL: http://www.defence-force.org
;// --------------------------------------
;// Note: This text was typed with a Win32
;// editor. So perhaps the text will not be
;// displayed correctly with other OS.


;//
;// ROM system defines
;// (Works only on ROM 1.1)
;//
#define _rom_hires		$ec33
//#define _rom_text		$ec21

#define _rom_ink		$f210
#define _rom_paper		$f204

#define _rom_ping		$fa9f
#define _rom_shoot		$fab5
#define _rom_zap		$fae1
#define _rom_explode	$facb

#define _rom_kbdclick1	$fb14
#define _rom_kbdclick2	$fb2a

//#define _rom_cls		$ccce
//#define _rom_lores0		$d9ed
//#define _rom_lores1		$d9ea

#define _rom_curset		$f0c8
#define _rom_curmov		$f0fd
#define _rom_draw		$f110
#define _rom_fill		$f268
#define _rom_circle		$f37f

#define _rom_redef_chars	$f8d0

#define	KEY_NONE	$38
#define KEY_UP		11	//$9c
#define	KEY_DOWN	10	//$b4
#define KEY_LEFT	8	//$ac
#define KEY_RIGHT	9	//$bc
#define KEY_SPACE	32	//$84
#define KEY_P		80	//$9d
#define KEY_DELETE	127
#define KEY_ESCAPE	27	//$a9
#define KEY_ENTER	13


;//
;// Vectorial draw engine commands
;//
#define CMD_END		0
#define CMD_CURSET	1
#define CMD_CURMOV	2
#define CMD_DRAW	3
#define	CMD_CIRCLE	4
#define	CMD_FILL	5

#define	CMD_NO_DRAW	128


;//
;// The various text messages
;//
#define MESSAGE_PRESS_SPACE		0
#define	MESSAGE_TABLE_NAMES		1
#define	MESSAGE_LEVEL_NUMBER	2
#define MESSAGE_ENTER_NAME		3

;//
;// The various kinds of game
;//
#define MESSAGE_GAMETYPE		4
#define GAMETYPE_FIND_THE_EXIT		0
#define GAMETYPE_SNAKE				1
#define GAMETYPE_DUEL				2
#define GAMETYPE_SURVIVOR			3
#define _GAMETYPE_COUNT_		4

#define MESSAGE_ARENATYPE		8
#define ARENATYPE_WALLS_NONE		0	// No walls, it warps in all directions
#define ARENATYPE_WALLS_HORIZONTAL	1	// Walls on left and right side, warps verticaly
#define ARENATYPE_WALLS_VERTICAL	2	// Walls on top and bottom side, warps horizontaly
#define ARENATYPE_WALLS_ALL			3	// Walls on all sides, no warp around
#define _ARENATYPE_COUNT_		4

#define MESSAGE_AVOID_COLLISION		12
#define MESSAGE_PAUSE				13
#define MESSAGE_GAME_OVER			14


#define ARENACOLOR_BLACK			0
#define ARENACOLOR_GREEN			1
#define ARENACOLOR_CHESSBOARD		2
#define ARENACOLOR_GRID				3

#define DIRECTION_LEFT				0	// 0 <-
#define DIRECTION_UP				1	// 1 ^
#define DIRECTION_RIGHT				2	// 2 ->
#define DIRECTION_DOWN				3	// 3 v


#define _LEVEL_COUNT_				8	// The number of levels defined in the table (in case we warp)

#define CONTROLMODE_RELATIVE		0	// LEFT and RIGHT keys to turn
#define CONTROLMODE_ABSOLUTE		1	// Use the 4 direction keys to choose the direction

#define ERASEMEMORY_TRONLOGO		0
#define ERASEMEMORY_TEXT_INTRO		1
#define ERASEMEMORY_TEXT_GAME		2
#define ERASEMEMORY_TEXT_GAME_16	3
#define ERASEMEMORY_ZEROPAGE		4
#define ERASEMEMORY_BSS				5

#define OBSTACLE_NONE				0
#define OBSTACLE_CORRIDOR			1
#define OBSTACLE_MICKEY				2
#define OBSTACLE_CROSS				4
#define OBSTACLE_UTURN				8
#define OBSTACLE_ROUNDEDSHAPES		16
//#define OBSTACLE_BLOCKS				32



;//
;// Zero page definition
;//

	.zero

	*= $50

;// Some two byte values
_zp_start_

// Keep these 2 ones consecutive
// so the "Normalize" code can work
base_coordinates
map_y				.dsb 1
player_y			.dsb 1
opponent_y			.dsb 1

map_x				.dsb 1
player_x			.dsb 1
opponent_x			.dsb 1

player_adress_low		.dsb 1
opponent_adress_low		.dsb 1
player_adress_high		.dsb 1
opponent_adress_high	.dsb 1


ptr_player				.dsb 2
ptr_opponent			.dsb 2

// 0 <-
// 1 ^
// 2 ->
// 3 v
player_direction	.dsb 1	
opponent_direction	.dsb 1
current_distance	.dsb 1
best_distance		.dsb 1


intro_memo_ptr		.dsb 1
intro_memo_command	.dsb 1
intro_memo_count	.dsb 1

flag_double_size	.dsb 1

save_a				.dsb 1
save_x				.dsb 1
save_y				.dsb 1

cursor_pos			.dsb 1

temp_x				.dsb 1
temp_y				.dsb 1
temp_color			.dsb 1

explode_x			.dsb 2
explode_y			.dsb 2
explode_color_offset	.dsb 1

primitive_x				.dsb 1
primitive_y				.dsb 1
circle_color			.dsb 1
circle_radius			.dsb 1
circle_radius_squared	.dsb 1

exit_color			.dsb 1

remaining_lifes		.dsb 1
current_level		.dsb 1
life_colors			.dsb 3

game_type			.dsb 1
arena_type			.dsb 1
arena_color			.dsb 1
arena_obstacles		.dsb 1

timer_position		.dsb 1
timer_decay_value	.dsb 1
timer_decay_speed	.dsb 1

control_mode		.dsb 1

raster_direction	.dsb 1	// 0 => down


computemap_tmp_x	.dsb 1

ColorsCounter		.dsb 1
GradientOffet		.dsb 1
ColorLineGradientOffset	.dsb 1

ptr_base_dst
pl_base_dst		.dsb 1
ph_base_dst		.dsb 1

ptr_dst
pl_dst			.dsb 1
ph_dst			.dsb 1

ptr_src
pl_src			.dsb 1
ph_src			.dsb 1

counter_1		.dsb 2
counter_2		.dsb 2

tmp1			.dsb 1

dummy_collide	.dsb 1		;// Used as a place holder for collision in one player mode


;// Some one byte temporaries
offset_src		.dsb 1		;// Position related to ptr_src
offset_dst		.dsb 1		;// Position related to ptr_dst

base_offset_dst	.dsb 1		;// Position related to ptr_dst


b_tmp1			.dsb 1
b_tmp2			.dsb 1
;b_tmp3			.dsb 1

last_key_press	.dsb 1


_zp_end_


	.text

_main	 
	//jmp _main
	//brk

	;// Debounce keyboard (bug init Euphoric)
	jsr _KeyboardDebounce

	;// ======================
	;// Inits 
	;// ======================

	;// ======================
	;// We need to start each new game with a completely
	;// rebuilt screen, cleared BSS, reseted variables.
	;// The only thing that should not be reseted is the
	;// hiscores counter !
	;// ======================

	;//
	;// Clear the zero page adresses
	;//
	ldx #ERASEMEMORY_ZEROPAGE
	jsr _EraseMemory

	;// Set the control mode to relative by default
	lda #CONTROLMODE_RELATIVE
	sta control_mode

intro_start
	;//
	;// Clear the BSS section
	;//
	ldx #ERASEMEMORY_BSS
	jsr _EraseMemory




;// ======================
;// Intro sequence
;// ======================
	// Black paper
	//ldy #0+16
	//sty $26c	// PAPER value
	ldy #0
	jsr _Intro_SetSingleParam
	jsr _rom_paper

	// Switch to HIRES
	jsr _ClearVideo
	jsr _rom_hires

	;// NOKEYCLICK+SCREEN no cursor
	;//
	;// We then need to remove the keyclick, 
	;// and also disable the cursor flashing 
	;// that is enabled after a HIRES switch.
	;//
	;// #define CURSOR		0x01  /* Cursor on		  (ctrl-q) */
	;// #define SCREEN		0x02  /* Printout to screen on (ctrl-s) */
	;// #define NOKEYCLICK	0x08  /* Turn keyclick off	  (ctrl-f) */
	;// #define PROTECT		0x20  /* Protect columns 0-1   (ctrl-]) */
	lda #8+2	;// NOKEYCLICK+SCREEN no cursor
	sta $26a

	// Black ink	
	ldy #0
	jsr _Intro_SetSingleParam
	jsr _rom_ink

	jsr _Intro_DrawTronLogo

	//
	// Fade the logo appearance
	//
	ldx #0
loop_logo_fade
	ldy _Table_LogoFade,x
	jsr _SaveRegisters
		jsr _Intro_SetSingleParam
		jsr _rom_ink
		jsr _TemporizeMedium
	jsr _RestoreRegisters
	inx
	cpx #5
	bne loop_logo_fade


	//
	// Sorte the highscore table
	//
	jsr _SortHighScores

	//
	// Move the logo to the top of screen
	//
	jsr _Intro_MoveTronLogo

	//
	// Switch screen display to a mixed up HIRES/TEXT
	// screen, with HIRES part on the top with TRON logo
	// and TEXT part on the bottom with the messages
	//
	jsr _ClearTextScreen

	// Hires attrib
	lda #30
	sta $bb80+40*28-1

	// Text attrib
	lda #26
	sta $a000+40*60

	//
	// Enable the character set, and display the messages
	//
	jsr _CreateCharSet

	// Display "Press Space"
	ldy #MESSAGE_PRESS_SPACE
	jsr _Display_Message

	// Display the "High Scores"
	ldy #MESSAGE_TABLE_NAMES
	jsr _Display_Message

	//
	// Big loop that moves the color of the TRON logo
	//
	lda #<$a000+40*3
	sta pl_base_dst
	lda #>$a000+40*3
	sta ph_base_dst

loop_color_cycle
.(
	.(
	lda #60-6
	sta counter_1
loop_down

	ldy raster_direction
	clc
	lda pl_base_dst
	sta pl_dst
	adc Intro_TronLogo_Raster_Offset_Low,y
	sta pl_base_dst
	lda ph_base_dst
	sta ph_dst
	adc Intro_TronLogo_Raster_Offset_High,y
	sta ph_base_dst

	ldx #0
loop_inner
	lda ColorCycleTable,x
	ldy raster_direction
	beq skip
	lsr
	lsr
	lsr
skip
	ldy #1
	and #7
	sta (ptr_dst),y

	ldy raster_direction
	clc
	lda pl_dst
	adc Intro_TronLogo_Raster_Offset_Low,y
	sta pl_dst
	lda ph_dst
	adc Intro_TronLogo_Raster_Offset_High,y
	sta ph_dst

	inx
	cpx #10
	bne loop_inner

	jsr _Scroll_ColorLine_Intro
	jsr _Temporize
	jsr _Scroll_Hiscore_Gradient

	// Check for space bar
	jsr $023B
	cmp #KEY_SPACE
	beq	exit_intro


	dec counter_1
	bne loop_down
	.)

	jsr _Temporize
	jsr _Temporize

	lda raster_direction
	eor #1
	sta raster_direction

	jmp loop_color_cycle
.)
 
exit_intro


;// ======================
;// Create game field
;// ======================
	// Erase the Tron logo
	ldx #ERASEMEMORY_TRONLOGO
	jsr _EraseMemory

	// Erase the text part of screen
	ldx #ERASEMEMORY_TEXT_INTRO
	jsr _EraseMemory


	// Scroll the bottom blue line to the top of screen
	jsr _Intro_MoveUpBlueLine

	// HIRES attribute
	lda #30
	sta $bb80+1

	// For the missing color byte
	lda #16+6
	sta $bb80+0

	// TEXT attribute
	lda #26
	sta $a000+40*15+39


	;// ======================
	;// Ask player name
	;// ======================
	jsr _CreateCharSet
	jsr _AskPlayerName


	// Reset the current score
	.(
	lda #"0"
	ldx #5
loop
	sta _LabelPlayerScore-1,x
	dex
	bne loop
	.)

	;// Game init
	lda #0
	sta current_level

	lda #3
	sta remaining_lifes

game_loop
	;//
	;// Level init
	;//
	jsr ScoreDisplay


	://
	;// Set the parameters based on the current level,
	;// by using is as an index in the entry in the table
	;//
	lda current_level
	and #(_LEVEL_COUNT_-1)
	//lda #5  // MIKE !!!	<= Force the Agains the clock level
	tay

//zobi
//	jmp zobi

	//.byt GAMETYPE_SURVIVOR					3	  => 3 
	//		+(ARENATYPE_WALLS_NONE<<2)			0<<2  => 0
	//		+(ARENACOLOR_GRID<<4)				3<<4  =>
	//		+(DIRECTION_RIGHT<<6)				2<<6  =>

	lda _LevelDef_Infos_Arena,y
	tax
	and #%11
	sta game_type

	;// Description of borders of the Arena
	txa
	lsr
	lsr
	tax
	and #%11
	sta arena_type

	;// Arena color scheme
	txa
	lsr
	lsr
	tax
	and #%11
	sta arena_color
	
	;// Player direction
	txa
	lsr
	lsr
	and #%11
	sta player_direction

	// Player position
	lda _LevelDef_Infos_XPos0,y
	sta player_x
	lda _LevelDef_Infos_YPos0,y
	sta player_y

	// Opponent or Exit position
	lda _LevelDef_Infos_XPos1,y
	sta opponent_x
	sta timer_decay_speed
	lda _LevelDef_Infos_YPos1,y
	sta opponent_y
	
	// Opponent orientation
	lda _LevelDef_Infos_Direction0,y
	tax
	and #%11
	sta opponent_direction

	// Obstacle mask
	txa
	lsr
	lsr
	sta arena_obstacles
	



	;//
	;// Erase all the things that are on screen
	;//
	ldx #ERASEMEMORY_TEXT_GAME
	jsr _EraseMemory


	;//
	;// Display current level
	;//
	lda current_level
	and #$0F
	tax
	lda _HexDigits,x
	sta _Message_LevelNumberPatch+1
	lda current_level
	lsr
	lsr
	lsr
	lsr
	tax
	lda _HexDigits,x
	sta _Message_LevelNumberPatch

	ldy #MESSAGE_LEVEL_NUMBER
	jsr _Display_Message

	clc	// Can probably replace by clc/adc by ORA, just be sure it's a power of two
	lda game_type
	adc #MESSAGE_GAMETYPE
	tay
	jsr _Display_Message

	clc	// Can probably replace by clc/adc by ORA, just be sure it's a power of two
	lda arena_type
	adc #MESSAGE_ARENATYPE
	tay
	jsr _Display_Message

	ldy #MESSAGE_AVOID_COLLISION
	jsr _Display_Message


	;//
	;// Display background graphics
	;// => Think about restoring X/Y player position
	jsr	_Arena_Initialize


	;//
	;// For GAMETYPE_SNAKE(1) and GAMETYPE_SURVIVOR(3) we have to
	;// fill a gauge with the objective of the player
	;//
	.(
	lda game_type
	and #1
	beq skip_gauge

	jsr _FillGauge

	lda #1
	sta timer_decay_value
skip_gauge
	.)

	;//
	;// Stay into the game loop while the hero
	;// still has some live to spare
	;//
	jsr _KeyboardDebounce
level_loop
	//jmp level_loop
	jsr ScoreDisplay

	jsr _Arena_UpdateExit	// Only if there is one :p


	;//
	;// Read keyboard input
	;// This way the player if he is fast enough can
	;// Change the direction of the movement at the
	;// begining of the game loop !
	;//
	.(
	jsr $023B

	cmp #KEY_ESCAPE
	bne test_pause
	;// User pressed ESCAPE => reset the game
	jmp intro_start
test_pause
	cmp #KEY_P
	bne test_keys
	.(
pause
	ldy #MESSAGE_PAUSE
	jsr _Display_Message
	jsr _KeyboardDebounce
	jsr _KeyboardGetChar
	.)
	jmp exit


test_keys
	ldx control_mode
	beq relative_mode

absolute_mode
	;// Test Left
	ldx #0
	cmp #KEY_LEFT
	beq validate
	;// Test Up
	inx
	cmp #KEY_UP
	beq validate
	;// Test Right
	inx
	cmp #KEY_RIGHT
	beq validate
	;// Test Down
	inx
	cmp #KEY_DOWN
	beq validate
	bne exit
	
relative_mode
	ldx player_direction

test_left
	// Left arrow
	cmp #KEY_LEFT
	bne test_right
	dex
	jmp validate

test_right
	// Right arrow
	cmp #KEY_RIGHT
	bne exit
	inx

validate
	//jmp validate
	txa
	and #3
	sta player_direction
exit
	.)
	
	;//
	;// And then we move the player(s) in the direction that was chosen.
	;// Implies we have to update the coordinates, but also the map
	;// adress for checks
	;//
	;// 0 <-
	;// 1 ^
	;// 2 ->
	;// 3 v
	;//
	.(
	ldy #0
	jsr _Move_Player
	lda game_type
	cmp #GAMETYPE_DUEL
	bne skip
	jsr _Computer_AI
	ldy #1
	jsr _Move_Player	
skip
	.)


	jsr _ComputeMapPosition


.(
	;//
	;// Check collisions
	;//

	lda player_adress_low+0
	sta ptr_player+0
	lda player_adress_high+0
	sta ptr_player+1

	.(
	;//
	;// Generate a fake NULL collision
	;// In case we are playing alone 
	;//
	ldx player_adress_low+1
	ldy player_adress_high+1

	lda game_type
	cmp #GAMETYPE_DUEL
	beq skip
	;//
	;// This is not duel, so setup a fake collision
	;//
.(
	and #1
	beq skip_gauge

	dec timer_decay_value
	bne skip_gauge

	lda timer_decay_speed
	sta timer_decay_value

	ldx timer_position
	inx
	cpx #241
	bne no_end_timer
	jmp LevelEndSequence
no_end_timer
	stx timer_position
	ldy #0
	dex
	jsr _FillGaugeSegment
skip_gauge
.)
	lda #128
	sta dummy_collide
	ldx #<dummy_collide
	ldy #>dummy_collide
skip
	stx ptr_opponent+0
	sty ptr_opponent+1
	.)

	// Check for simultaneous head shot:
	cpx	ptr_player+0
	bne no_head_collide
	cpy	ptr_player+1
	bne no_head_collide
	jmp opponent_collision

no_head_collide

	// Check for collision
	ldy #0

	lda (ptr_player),y
	cmp #128
	bcc player_collision

	lda (ptr_opponent),y
	cmp #128
	bcs no_collision

opponent_collision
	// End of level
	lda player_x+1
	sta player_x+0
	lda player_y+1
	sta player_y+0
	jsr _ComputeMapPosition
	lda #8
	sta explode_color_offset
	jsr _PlayExplosion
	jmp LevelEndSequence

player_collision
	// End of level

	// Test if that's the end of game
	cmp #16+0
	beq LevelEndSequence
	;//
	;// Game Over
	;//
	lda #0
	sta explode_color_offset
	jsr _PlayExplosion

	dec remaining_lifes
	beq was_last_life
	;// Restart the level
	jmp game_loop

was_last_life
	ldx #ERASEMEMORY_TEXT_GAME_16
	jsr _EraseMemory

	ldy #MESSAGE_GAME_OVER
	jsr _Display_Message

	jsr _Apply_ShapeFilter

	jmp intro_start

no_collision

	;//
	;// Display the bikes on screen
	;//
	lda ColorLightCycle+0
	sta (ptr_player),y

	lda ColorLightCycle+1
	sta (ptr_opponent),y

	;//
	;// Display the map on screen
	;// 
	jsr _Display_ShowMap

	;//
	;// Draw the trail
	;//
	ldy #0
	ldx ColorsCounter
	lda ColorsTrailTable,x
	sta (ptr_player),y
	lda ColorsTrailTable+4,x
	sta (ptr_opponent),y
	inx
	txa
	and #3
	sta	ColorsCounter
exit
.)

	jsr _TemporizeGame

	jmp level_loop

LevelEndSequence
.(
	;//
	;// Display End of Level infos (bonus time, score, bla bla bla)
	;//

	// End of level bonus => 200 points
	ldx #200
	stx counter_1
blink
	jsr IncrementScore
	jsr IncrementScore
	jsr IncrementScore
	jsr ScoreDisplay
	jsr _rom_kbdclick1
	jsr _Arena_UpdateExit	// Only if there is one :p
	jsr _Display_ShowMap
	dec counter_1
	bne blink

	// One more level
	inc current_level

	jmp game_loop
.)



;// Must be called with X for direction
;// Returns distance in Y
_Compute_Distance
.(
	;// Initialise coordinates from the current position
	;//
	lda opponent_x
	sta primitive_x
	lda opponent_y
	sta primitive_y

	ldy #0
loop_scan
	sty current_distance

	;// Increment the position to go to next direction
	clc
	lda primitive_x
	adc _Move_IncrementTable_X,x
	sta primitive_x
	sta pl_src

	clc
	lda primitive_y
	adc _Move_IncrementTable_Y,x
	and #127
	sta primitive_y
	clc
	adc #>_BigBuffer
	sta ph_src

	ldy #0
	lda (ptr_src),y
	ldy current_distance
	cmp #128
	bcc collide

	iny
	cpy #200	// To avoid countless repetitions
	bne loop_scan

collide
	rts
.)


_Computer_AI
	//jmp _Computer_AI
.(
	;//
	;// To avoid stupid things, we scan the current direction, and
	;// continue if we have at lest 15 squares ok
	;//
	ldx opponent_direction
	jsr _Compute_Distance
	cpy #15
	bcc look_for_exit
	rts

look_for_exit
	//jmp look_for_exit
	;//
	;// Starts by a basic polling around the bike to check if we have to turn
	;//
	ldx #0
	stx best_distance
loop_direction
	jsr _Compute_Distance

	cpy best_distance
	bcc not_best
	;// Select this direction for the computer opponent
	sty best_distance
	stx opponent_direction
not_best

	inx
	cpx #4
	bne loop_direction

	rts
.)


_PlayExplosion
.(
	jsr _rom_explode

	lda player_x
	sta primitive_x
	lda player_y
	sta primitive_y

	ldx #0
loop_color
	stx temp_color

	jsr _DrawExplosion
	jsr _Display_ShowMap
	jsr _Temporize

	ldx temp_color
	inx
	cpx #50
	bne loop_color
	rts
.)


_ComputeMapPosition
.(
	;//
	;// Compute the map horizontal display coordinates based on the location of the player
	;// 
.(
	lda arena_type
	and #ARENATYPE_WALLS_VERTICAL
	bne blocked_x

warped_x
	sec
	lda player_x
	sbc #20
	jmp end_test_x
	
blocked_x
	lda player_x
	cmp #20
	bcs x_right
x_left
	lda #0
	jmp end_test_x

x_right
	cmp #255-20
	bcc x_mid
	lda #256-40
	jmp end_test_x

x_mid
	sec
	lda player_x
	sbc #20
end_test_x
	sta map_x
.)


.(
//zobi
//	jmp zobi

	;//
	;// Compute the map vertical display coordinates based on the location of the player
	;// 
	lda arena_type
	and #ARENATYPE_WALLS_HORIZONTAL
	bne blocked_y

warped_y
	sec
	lda player_y
	sbc #13
	jmp end_test_y

blocked_y
	lda player_y
	cmp #13
	bcs y_right
y_left
	lda #0
	jmp end_test_y

y_right
	cmp #127-13
	bcc y_mid
	lda #128-26
	jmp end_test_y

y_mid
	sec
	lda player_y
	sbc #13
end_test_y
	sta map_y
.)
	rts
.)	



_Move_Player
.(
	ldx	player_direction,y

	clc
	lda player_x,y
	adc _Move_IncrementTable_X,x
	sta player_x,y
	sta player_adress_low,y

	clc
	lda player_y,y
	adc _Move_IncrementTable_Y,x
	and #127
	sta player_y,y
	clc
	adc #>_BigBuffer
	sta player_adress_high,y
	rts
.)




_ClearTextScreen
	ldy #($c000-$bb00)/256
	lda #>$bb00
	jmp _ClearVideoLoop

;// A routine that will fill all the video memory with value 0, from 
;// $9800 to $C000, effectively provocking a nice switch of resolution
_ClearVideo
	ldy #($c000-$9800)/256
	lda #>$9800
_ClearVideoLoop
	.(
	sta __patch+2
	lda #0
loop_outer
	ldx #0
loop_inner
__patch
	sta $9800,x
	dex
	bne loop_inner
	inc __patch+2
	dey
	bne loop_outer
	.)
	rts






IncrementScore
.(
	// Pump
	.(
	lda ScoreTable_Sub+5
	bne skip
	lda #10
	sta ScoreTable_Sub+5
skip
	.)

	.(
	ldx #5
loop
	ldy ScoreTable_Sub,x
	beq not_moving

	.(
	dec ScoreTable_Sub,x
	bne skip
	inc _LabelPlayerScore-1,x
skip
	.)

	ldy ScoreTable,x
	iny
	tya
	sta ScoreTable,x
	cpy #100
	bne not_finished

	// Reset current digit
	lda #0
	sta ScoreTable,x
	lda #"0"
	sta _LabelPlayerScore-1,x

	dex
	lda #10
	sta ScoreTable_Sub,x

	inx

not_finished

not_moving
	dex
	bne loop
end
	.)
	rts
.)



// remaining_lifes

ScoreDisplay
	//jmp ScoreDisplay
.(
	ldx #3
	ldy remaining_lifes
loop_life
	lda _LifeColors_Gradient,y
	iny
	dex
	sta life_colors,x
	bne loop_life

	lda #<$a000+40*3
	sta pl_dst
	lda #>$a000+40*3
	sta ph_dst

	ldx #0
loop_y
	stx tmp1

	ldy #0

	// First bike
	lda life_colors+0
	sta (ptr_dst),y
	iny
	lda _BikesPictures_Left,x
	sta (ptr_dst),y
	iny
	lda _BikesPictures_Right,x
	sta (ptr_dst),y
	iny

	// Second bike
	lda life_colors+1
	sta (ptr_dst),y
	iny
	lda _BikesPictures_Left,x
	sta (ptr_dst),y
	iny
	lda _BikesPictures_Right,x
	sta (ptr_dst),y
	iny

	// Third bike
	lda life_colors+2
	sta (ptr_dst),y
	iny
	lda _BikesPictures_Left,x
	sta (ptr_dst),y
	iny
	lda _BikesPictures_Right,x
	sta (ptr_dst),y
	iny

	lda _Score_GradientColorTable,x
	ldy #14
	sta (ptr_dst),y
	iny
loop_x
	
	ldx ScoreTable+1-15,y
	txa
	clc
	adc tmp1
	tax
	
	lda _BigDigits,x
	sta (ptr_dst),y

	iny 
	cpy #6+14
	bne loop_x

	ldx tmp1
	lda _Score_GradientColorTable_Timebar,x
	sta (ptr_dst),y

	jsr increment_ptr_dst_40

	ldx tmp1
	inx
	cpx #9
	bne loop_y

	// Move the blue line
	jsr _Scroll_ColorLine_Ingame

	//
	jsr IncrementScore

	rts
.)






// Y=>Value
_Intro_SetSingleParam
.(
	lda #0
	sta $2e0
	sty $2e1
	sta $2e2
	rts
.)


_Intro_DrawTronLogo
	//jmp _Intro_DrawTronLogo
.(
	//
	ldx #0
	stx intro_memo_ptr
loop_drawlogo
	// Get command
	ldx intro_memo_ptr
	lda Intro_TronLogo_Description,x
	beq end
	inx

	ldy #2
	sta intro_memo_command
	and #127	// Clear the NODRAW command
	cmp #CMD_CURSET
	beq draw_Curset 
	cmp #CMD_CURMOV
	beq draw_Curmov 
	cmp #CMD_DRAW
	beq draw_Draw 
	cmp	#CMD_CIRCLE
	beq draw_Circle 
	cmp	#CMD_FILL
	beq draw_Fill 
	bne	loop_drawlogo

end
	rts

draw_Curset
	jsr _Intro_ReadParams
	stx intro_memo_ptr
	jsr _rom_curset
	jmp	loop_drawlogo

draw_Curmov
	jsr _Intro_ReadParams
	stx intro_memo_ptr
	jsr _rom_curmov
	jmp	loop_drawlogo

draw_Draw
	jsr _Intro_ReadParams
	stx intro_memo_ptr
	jsr _rom_draw
	jmp	loop_drawlogo

draw_Circle
	dey
	jsr _Intro_ReadParams
	stx intro_memo_ptr
	jsr _rom_circle
	jmp	loop_drawlogo

draw_Fill
	iny
	jsr _Intro_ReadParams
	stx intro_memo_ptr
	jsr _rom_fill
	jmp	loop_drawlogo
.)



// Get X params (16bit) from the table
_Intro_ReadParams	   
.(
	sty intro_memo_count        ; store X in storage byte
	lda #0         ; X is the number of params
	sta $2e0       ; Zero error indicator.
	tay
loop
    lda Intro_TronLogo_Description,x
    inx    
    sta $2e1,y
    iny    
    lda Intro_TronLogo_Description,x
    inx 
    sta $2e1,y
    iny            ; 
    dec intro_memo_count        ; decrement pointer
    bne loop

	// Set write mode
	lda intro_memo_command	// 128
	rol					// 128 => c
	rol					// c => 1
	rol					// 1 => 2
	and #3
	ora #1
	sta $2e1,y
	iny
	lda #0
	sta $2e1,y

    rts
.)



increment_ptr_dst_40
.(
	clc
	lda pl_dst
	adc #40
	sta pl_dst
	bcc skip
	inc ph_dst
skip
	rts
.)









_Arena_UpdateExit
.(
	lda game_type
	//cmp #GAMETYPE_FIND_THE_EXIT <= 0
	bne	exit

	lda opponent_x
	sta pl_dst
	clc
	lda opponent_y
	adc #>_BigBuffer
	sta ph_dst

	ldx exit_color
	inx
	stx exit_color
	txa
	and #7
	ora #16
	tax

	// Top half part
	lda #16+0
	ldy #1
	sta (ptr_dst),y
	iny
	sta (ptr_dst),y

	inc ph_dst
	ldy #0
	sta (ptr_dst),y
	iny
	txa
	sta (ptr_dst),y
	iny
	sta (ptr_dst),y
	iny
	lda #16+0
	sta (ptr_dst),y

	// Bottom half part
	inc ph_dst
	ldy #0
	sta (ptr_dst),y
	iny
	txa
	sta (ptr_dst),y
	iny
	sta (ptr_dst),y
	iny
	lda #16+0
	sta (ptr_dst),y

	inc ph_dst
	ldy #1
	sta (ptr_dst),y
	iny
	sta (ptr_dst),y
exit	
	rts
.)



;// Give map coordinates in X and Y.
;// Outputs the pixel adressin "ptr_src"
_Compute_MapAdress
.(
	stx pl_src
	clc
	tya
	and #127
	adc #>_BigBuffer
	sta ph_src
	rts
.)

_pc
_Display_ShowMap
.(
	ldy map_y
	ldx #0		//map_x
	jsr _Compute_MapAdress

	// Force the cursor to stay hiden
	lda #0
	sta $274 

	lda #<__base_mode
	sta pl_dst
	lda #>__base_mode
	sta ph_dst

	lda #<$bb80+40*2
	sta pl_base_dst
	lda #>$bb80+40*2
	sta ph_base_dst

	ldx #26
	ldy #0
loop_patch
	iny	// lda

	lda pl_src
	sta (ptr_dst),y
	iny

	clc
	lda ph_src
	sta (ptr_dst),y
	adc #1

	;//	
	.(
	cmp #>(_BigBuffer+256*128)
	bne skip
	lda #>_BigBuffer
skip
	.)
	;//

	sta ph_src
	iny

	//iny	// $9d sta
	//iny	// $00
	//iny	// $a0

	lda #$9d
	sta (ptr_dst),y
	iny

	clc
	lda pl_base_dst
	sta (ptr_dst),y
	adc #40
	sta pl_base_dst
	iny

	lda ph_base_dst
	sta (ptr_dst),y
	adc #0
	sta ph_base_dst
	iny
	

	dex
	bne	loop_patch



	ldy map_x
	ldx #0
loop_x

__base_mode
	lda $b9b9,y		// lda $BigBuffer+...,y
	lda $b9b9,y		// sta $bb80+000*40,x
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y

	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y

	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y
	lda $b9b9,y

	iny
	inx
	cpx #40
	beq end
	jmp loop_x
end

	rts
.)



// Note:
// A sequence of "jmp _DoTempo" compresses better
// than having only short relative branches...
_TemporizeGame
	ldy #0
	lda current_level
	lsr
	sta tmp1
	cmp #10
	bcs	_DoTempo
	sec
	lda #10
	sbc tmp1
	tay
	jmp _DoTempo

_TemporizeVeryLong
	ldy #0
	jmp _DoTempo
_TemporizeLong
	ldy #150
	jmp _DoTempo
_TemporizeMedium
	ldy #80
	jmp _DoTempo
_TemporizeFast
	ldy #40
	jmp _DoTempo
_Temporize
	ldy #10	//20
	jmp _DoTempo
_TemporizeShort
	ldy #5
_DoTempo
.(
loop_2
	cpy #0
	beq exit
	dey
	ldx #0
loop_1
	nop
	dex
	bne loop_1
	beq loop_2
exit
	rts
.)








;// That small color gradient line on the screen here and there 
_Scroll_ColorLine_Ingame
	lda #<$a000+40*13
	sta pl_dst
	lda #>$a000+40*13
	sta ph_dst
	jmp _Scroll_ColorLine

_Scroll_ColorLine_Intro
	lda #<$a000+40*58
	sta pl_dst
	lda #>$a000+40*58
	sta ph_dst

_Scroll_ColorLine
.(
	; Some color test
	lda #16+6
	sta $a000+40*0
	sta $a000+40*2

	sta $a000+40*57
	sta $a000+40*59

	ldx ColorLineGradientOffset
	inx
	stx ColorLineGradientOffset

	ldy #0
loop
	txa
	and #63
	tax
	lda _Colorline_Gradient,x
	sta $a000+40*1,y
	lda _Colorline_Gradient-4,x
	sta (ptr_dst),y
	inx
	iny
	cpy #40
	bne loop

	rts
.)

_Scroll_Hiscore_Gradient
.(
	lda #<$bb80+40*12+10
	sta pl_dst
	lda #>$bb80+40*12+10
	sta ph_dst

	lda #<$bb80+40*(12+11)+10
	sta pl_src
	lda #>$bb80+40*(12+11)+10
	sta ph_src

	.(
	ldx GradientOffet
	inx
	cpx #12
	bne skip
	ldx #0
skip
	stx	GradientOffet
	.)

	lda #12
	sta tmp1

loop
	.(
	inx
	cpx #12
	bne skip
	ldx #0
skip
	.)
	lda _HighScores_ColorGradient,x
	ldy #0
	sta (pl_dst),y
	ldy #7
	sta (pl_src),y

	jsr increment_ptr_dst_40

	.(
	sec
	lda pl_src
	sbc #40
	sta pl_src
	bcs skip
	dec ph_src
skip
	.)

	dec tmp1
	bne loop

	rts
.)



;//
;// ptr_src 
;//		contains the message
;//
;//	ptr_dst 
;//		contains the position of the first character of the message on screen
;//
;// Codes that can be used in the display:
;// 255 => End of message
;// 254 => End of line
;// 253 => Switch double size flag
;//
_Display_Message
.(
	// Read the source adress of messages
	lda _Messages_Table_AddrLow,y
	sta pl_src
	lda _Messages_Table_AddrHigh,y
	sta ph_src

	lda _Messages_Table_ScreenAddrLow,y
	sta pl_dst
	lda _Messages_Table_ScreenAddrHigh,y
	sta ph_dst

	ldx #0
	stx flag_double_size
loop
	ldy #0
	lda (ptr_src),y
	sta tmp1

	.(
	inc pl_src
	bne skip
	inc ph_src
skip
	.)

	cmp #255
	beq end_loop
	cmp #254
	beq carriage_return
	cmp #253
	beq switch_size
	bne display

switch_size
	lda flag_double_size
	eor #255
	sta flag_double_size
	jmp loop


carriage_return
	// Carriage return
	ldx #0
	jsr increment_ptr_dst_40
	jmp loop

display
	txa
	tay
	lda tmp1
	sta (ptr_dst),y
	lda flag_double_size
	beq no_double_size
	tya
	clc
	adc #40
	tay
	lda tmp1
	sta (ptr_dst),y
no_double_size
	inx

	jmp loop
end_loop

	rts
.)



_CreateCharSet
.(
	// Reinitialise all ROM characters
	jsr _rom_redef_chars

	.(
	// And now modify them so they look "SF"
	lda #<$b400
	sta pl_dst
	lda #>$b400
	sta ph_dst

	ldx #128
loop
	lda #0
	ldy #1
	sta (ptr_dst),y

	.(
	clc
	lda pl_dst
	adc #8
	sta pl_dst
	bcc skip
	inc ph_dst
skip
	.)

	dex
	bne loop
	.)

	rts
.)




;// Logo is from line 80 to 120
_Intro_MoveUpBlueLine
	;// Start by displaying the logo
	lda #<$a000+40*56
	sta pl_dst
	lda #>$a000+40*56
	sta ph_dst

	lda #<$a000+40*57
	sta pl_src
	lda #>$a000+40*57
	sta ph_src

	lda #<40*4
	sta counter_1+0
	lda #>40*4
	sta counter_1+1

	lda #45

	jmp _Intro_ScrollBloc


;// Logo is from line 80 to 120
_Intro_MoveTronLogo
	;// Start by displaying the logo
	lda #<$a000+40*79
	sta pl_dst
	lda #>$a000+40*79
	sta ph_dst

	lda #<$a000+40*80
	sta pl_src
	lda #>$a000+40*80
	sta ph_src

	lda #<40*41
	sta counter_1+0
	lda #>40*41
	sta counter_1+1

	lda #70

_Intro_ScrollBloc
.(
	sta counter_2
loop
	jsr _CopyMemory

	.(
	sec
	lda pl_dst
	sbc #40
	sta pl_dst
	bcs skip
	dec ph_dst
skip
	.)

	.(
	sec
	lda pl_src
	sbc #40
	sta pl_src
	bcs skip
	dec ph_src
skip
	.)

	dec counter_2
	bne loop

	rts
.)




// Take in X register the parameter 
// values to use to erase memory
_EraseMemory
	// Begin pointer of data to erase
	clc
	lda _EraseMemory_Table_AddrLow,x
	sta pl_src
	adc #1
	sta pl_dst
	lda _EraseMemory_Table_AddrHigh,x
	sta ph_src
	adc #0
	sta ph_dst

	// Start by clearing the very first byte
	// with the value we need.
	ldy #0
	lda _EraseMemory_Table_EraseValue,x
	sta (ptr_src),y

	// Size of data to erase
	lda _EraseMemory_Table_CountLow,x
	sta counter_1+0	
	lda _EraseMemory_Table_CountHigh,x
	sta counter_1+1
;//
;// ptr_src
;//		point on the area the data are taken from
;//
;// ptr_dst
;//		point on the are where the data will be transfered to
;//
;// counter_1
;//		size of data to move
;//
_CopyMemory
	sec
	lda #0
	sbc counter_1+0
	sta tmp1
	tax
	cmp #1
	lda counter_1+1
	adc #0
	tay
	beq return

	sec
	lda ptr_dst
	sbc tmp1
	sta memcpyloop+4
	lda ptr_dst+1
	sbc #0
	sta memcpyloop+5

	sec
	lda ptr_src
	sbc tmp1
	sta memcpyloop+1
	lda ptr_src+1
	sbc #0
	sta memcpyloop+2

memcpyloop
	lda $2211,x
	sta $5544,x
	inx
	bne memcpyloop
	inc memcpyloop+2
	inc memcpyloop+5
	dey
	bne memcpyloop
return
	rts


_SaveRegisters
	sta save_a
	stx save_x
	sty save_y
	rts

_RestoreRegisters
	lda save_a
	ldx save_x
	ldy save_y
	rts




;//
;// Assuming the highscores table is always already sorted
;// all we have to do is to start from the end, and move up
;// the new entry
;// Each score is 17 bytes long,
;// Each score is separated in memory by 20 bytes if we count the storage stuff
;// We have a total of 6 comparisons to do
;//
_SortHighScores
	//jmp _SortHighScores
.(
	// Score of the current player
	lda #<_LabelPlayerScore
	sta pl_src
	lda #>_LabelPlayerScore
	sta ph_src

	// Score of the last one
	lda #<_LabelLastScore
	sta pl_dst
	lda #>_LabelLastScore
	sta ph_dst

	ldx #6
loop_next_name
	ldy #0
loop_compare_name
	lda (ptr_src),y	// Player score line
	cmp (ptr_dst),y	// Current score to compare
	beq egal
	bcs exchange_loop
	bcc end_compare
egal
	iny
	// We only want to compare on the first 5 characters !
	cpy #5
	bne loop_compare_name
	beq end_compare

exchange_loop
	lda (ptr_dst),y
	pha
	lda (ptr_src),y
	sta (ptr_dst),y
	pla
	sta (ptr_src),y
	iny
	cpy #17
	bne exchange_loop 

	// Next test
	.(
	sec
	lda pl_dst
	sta pl_src
	sbc #20
	sta pl_dst
	lda ph_dst
	sta ph_src
	sbc #0
	sta ph_dst
	.)

	dex
	bne loop_next_name

end_compare
	rts
.)



_KeyboardDebounce
.(
_getchar
	jsr $023B
	bmi _getchar	;// loop while char available
	rts
.)


_KeyboardGetChar
.(
_getchar
	jsr $023B
	bpl _getchar	;// loop while char are not available
	rts
.)


_AskPlayerName
.(
	jsr _KeyboardDebounce

	// Display the "Enter your name message"
	ldy #MESSAGE_ENTER_NAME
	jsr _Display_Message

	// Activate key click and cursor
	lda #2+1
	sta $26a

	ldx #0
loop_input_set_cursor
	stx cursor_pos
	// Then the loop that display the current player name
loop_input
	// Put cursor at right position
	clc
	lda #<$bb80+40*16+14-2
	adc cursor_pos
	sta $12
	lda #>$bb80+40*16+14-2
	adc #0
	sta $13

	ldx #11
loop_show_name
	lda _LabelPlayerName-1,x
	sta $bb80+40*16+14-1,x
	sta _LabelPlayerScoreName-1,x
	dex 
	bne loop_show_name

	// Display the right 2/4 character for the control mode
	lda control_mode
	asl
	clc
	adc #"2"
	sta $bb80+40*18+12

	// Now check character
	jsr _KeyboardGetChar

	cmp #KEY_ENTER
	beq validate_entry
test_left
	cmp #KEY_LEFT
	bne test_right

	ldx cursor_pos
	beq do_ping
	dex
	bpl loop_input_set_cursor

test_right
	cmp #KEY_RIGHT
	bne test_up

	ldx cursor_pos
	cpx #10
	beq do_ping
	inx
	bne loop_input_set_cursor

do_ping
	jsr _rom_ping
	jmp loop_input

test_erase
	cmp #KEY_DELETE
	bne test_character
	ldx cursor_pos
	beq do_ping
	dex
	lda #32
	sta _LabelPlayerName,x
	bne loop_input_set_cursor

test_character
	cmp #32
	bcc	loop_input
	ldx cursor_pos
	sta _LabelPlayerName,x
	inx
	cpx #11
	bne loop_input_set_cursor
	ldx #0
	beq loop_input_set_cursor

test_up
	cmp #KEY_UP
	bne test_escape
	lda control_mode
	eor #1
	sta control_mode
	jmp loop_input

test_escape
	cmp #KEY_ESCAPE
	bne test_erase
	jsr _rom_zap
	lda #32
	ldx #11
loop_erase
	sta _LabelPlayerName-1,x
	dex
	bne loop_erase
	ldx #0
	jmp loop_input_set_cursor

validate_entry

	// Deactivate key click and cursor
	lda #8+2
	sta $26a

	rts
.)








_DrawCircle_PixelRender_Explode
.(
	ldx #0
loop_seach_color
	cmp ExplodeDistanceTable,x
	bcs set_color
	inx
	bne loop_seach_color

set_color
	txa
	clc 
	adc temp_color
	and #7
	ora explode_color_offset
	tax
	lda _BlueExplosion,x
	sta circle_color

	rts
.)


_DrawCircle_PixelRender_DrawDisc
.(
	rts
.)

_DrawExplosion
	// Radius
	ldx #12
	ldy #0
	jmp _DrawCircle

_DrawDisc
	jsr _SaveRegisters

	lda _ArenaItems_Table_PosX,y
	sta primitive_x

	lda _ArenaItems_Table_PosY,y
	sta primitive_y

	ldx _ArenaItems_Table_Radius,y
	lda _ArenaItems_Table_Color,y
	sta circle_color
	ldy #1
	jsr _DrawCircle
	jsr _RestoreRegisters
	rts


_DrawCircle
.(
	// Maximum allowed radius is 12
	stx circle_radius
	dex
	lda _SquareTable,x
	sta circle_radius_squared

	lda _DrawCircle_PixelRenderTable_AddrLow,y
	sta __auto_pixel+1
	lda _DrawCircle_PixelRenderTable_AddrHigh,y
	sta __auto_pixel+2

	ldx #0
loop_y
	stx temp_y

	ldx #0
loop_x
	stx temp_x

	// Compute the distance
	ldx temp_x
	ldy temp_y
	clc
	lda _SquareTable,x
	adc _SquareTable,y
	bcs skip
	cmp circle_radius_squared
	bcs skip

__auto_pixel
	jsr $1234

	// Display the pixel
	clc
	lda primitive_x
	adc temp_x
	sta explode_x+0
	sec
	lda primitive_x
	sbc temp_x
	sta explode_x+1

	clc
	lda primitive_y
	adc temp_y
	sta explode_y+0
	sec
	lda primitive_y
	sbc temp_y
	sta explode_y+1

	jsr _DrawDisc_Pixels

skip

	ldx temp_x
	inx
	cpx circle_radius
	bne loop_x

	ldx temp_y
	inx
	cpx circle_radius
	bne loop_y

	rts
.)

_DrawDisc_Pixels
.(
	ldx explode_x+0
	ldy explode_y+0
	jsr _DrawDisc_Pixel
	ldx explode_x+1
	ldy explode_y+0
	jsr _DrawDisc_Pixel
	ldx explode_x+0
	ldy explode_y+1
	jsr _DrawDisc_Pixel
	ldx explode_x+1
	ldy explode_y+1
_DrawDisc_Pixel
	jsr _Compute_MapAdress
	ldy #0
	lda circle_color
	sta (ptr_src),y
	rts
.)





_Arena_BackgroundPixel_Checkboard
.(
	txa
	ror
	ror
	ror
	ror
	//clc
	and #1
	sta tmp1

	tya
	ror
	ror
	ror
	ror
	clc
	and #1
	eor tmp1
	asl
	ora #16

	rts
.)

_Arena_BackgroundPixel_Grid
	txa
	and #%1111
	cmp #%1000
	beq _Arena_BackgroundPixel_Green

	tya
	and #%1111
	cmp #%1000
	beq _Arena_BackgroundPixel_Green
_Arena_BackgroundPixel_Black
	lda #16+0
	rts
_Arena_BackgroundPixel_Green
	lda #16+2
	rts


_Arena_InitializeBackground
.(
	// Select the requested pixel filler
	ldy arena_color

	lda _Arena_BackgroundTable_AddrLow,y
	sta __auto_pixel+1
	lda _Arena_BackgroundTable_AddrHigh,y
	sta __auto_pixel+2

	// Fill the whole buffer with black paper
	lda #<_BigBuffer
	sta pl_dst
	lda #>_BigBuffer
	sta ph_dst
	
	ldx #0
loop_y
	ldy #0
loop_x
__auto_pixel
	//jsr _Arena_BackgroundPixel_Checkboard
	jsr _Arena_BackgroundPixel_Grid
	eor #128+7

	sta (ptr_dst),y

	iny
	bne loop_x

	inc ph_dst

	inx
	cpx #128
	bne loop_y
	rts
.)




_Arena_Obstacles_Corridor
.(
	ldy #2
loop
	jsr _Arena_DrawRectangle
	iny
	cpy #12
	bne loop
	rts
.)


_Arena_Obstacles_MickeyMouse
.(
	// Draw mickey
	ldy #12
	jsr _DrawDisc
	iny
	jsr _DrawDisc
	iny
	jsr _DrawDisc
	rts
.)

_Arena_Obstacles_Cross
.(
	ldy #15
	jsr _Arena_DrawRectangle
	iny
	jsr _Arena_DrawRectangle
	rts
.)

_Arena_Obstacles_UTurn
.(
	ldy #17
loop
	jsr _Arena_DrawRectangle
	iny
	cpy #28+1
	bne loop
	rts
.)


//_Arena_Obstacles_Blocks
//.(
//	rts
//.)


_Arena_Obstacles_RoundedShapes
.(
	ldy #29
loop
	jsr _Arena_DrawRectangle
	iny
	cpy #36+1
	bne loop
	rts
	rts
.)



_Arena_Initialize
.(
	jsr _Arena_InitializeBackground

	lda arena_type
	and #ARENATYPE_WALLS_HORIZONTAL
	beq skip_horizontal_wall
	ldy #0
	jsr _Arena_DrawRectangle
skip_horizontal_wall

	lda arena_type
	and #ARENATYPE_WALLS_VERTICAL
	beq skip_vertical_wall
	ldy #1
	jsr _Arena_DrawRectangle
skip_vertical_wall

	
	;//
	;// Display any of the 6 possible obstacles
	;// depending of a bit mask
	;//
	.(
	lsr arena_obstacles
	bcc skip1
	jsr _Arena_Obstacles_Corridor
skip1
	lsr arena_obstacles
	bcc skip2
	jsr _Arena_Obstacles_MickeyMouse
skip2
	lsr arena_obstacles
	bcc skip3
	jsr _Arena_Obstacles_Cross
skip3
	lsr arena_obstacles
	bcc skip4
	jsr _Arena_Obstacles_UTurn
skip4
	//lsr arena_obstacles
	//bcc skip5
	//jsr _Arena_Obstacles_Blocks
//skip5
	lsr arena_obstacles
	bcc skip6
	jsr _Arena_Obstacles_RoundedShapes
skip6
	.)


	jsr _Apply_ShapeFilter


	// Initialise coordinates
	//lda #0
	//sta map_x 
	//sta map_y
	rts
.)







;//	y point on data definition
_Arena_DrawRectangle
	//jmp _Arena_DrawRectangle
.(
	jsr _SaveRegisters

	lda #0
	sta pl_dst
	clc
	lda _ArenaItems_Table_PosY,y
	adc #>_BigBuffer
	sta ph_dst

	lda _ArenaItems_Table_PosX,y
	sta primitive_x
	clc
	adc _ArenaItems_Table_Width,y
	sta temp_x

	lda _ArenaItems_Table_Color,y

	ldx _ArenaItems_Table_Height,y
loop_y
	ldy primitive_x
loop_x
	sta (ptr_dst),y

	iny
	cpy temp_x
	bne loop_x

	.(
	ldy ph_dst
	iny
	cpy #>(_BigBuffer+256*128)
	bne skip
	ldy #>_BigBuffer
skip
	sty ph_dst
	.)

	dex
	bne loop_y

	jsr _RestoreRegisters
	rts
.)



_Apply_ShapeFilter
	//jmp _Apply_ShapeFilter
.(
	// Fill the whole buffer with black paper
	lda #<_BigBuffer+256+1
	sta pl_base_dst
	lda #>_BigBuffer+256+1
	sta ph_base_dst
	
	ldx #1
loop_y
	stx temp_x

	ldy #0
loop_x
	lda pl_base_dst
	sta pl_dst
	lda ph_base_dst
	sta ph_dst

	// Is the middle pixel of the good color, or border color
	lda (ptr_base_dst),y
	cmp #16+6
	beq skip
	cmp #16+3
	beq skip

	
	// Top
	dec	ph_dst
	lda (ptr_dst),y
	ldx #16+4
	cmp #16+6
	beq set
	ldx #16+1
	cmp #16+3
	beq set
	
	// Left
	dec pl_dst
	inc	ph_dst
	lda (ptr_dst),y
	ldx #16+4
	cmp #16+6
	beq set
	ldx #16+1
	cmp #16+3
	beq set


	ldx #16+7

	// Right
	inc pl_dst
	inc pl_dst
	lda (ptr_dst),y
	cmp #16+6
	beq set
	cmp #16+3
	beq set
	
	// Bottom
	dec pl_dst
	inc	ph_dst
	lda (ptr_dst),y
	cmp #16+6
	beq set
	cmp #16+3
	bne skip

	// Set to yellow color
set
	txa	//lda #16+6
	sta (ptr_base_dst),y
skip

	iny
	cpy #0
	bne loop_x

	inc ph_base_dst

	ldx temp_x

	inx
	cpx #127
	bne loop_y

	rts
.)


;//
;// x => x coordinate of segment
;// y => value of pattern (0 or 1)
;//
_FillGaugeSegment
.(
	lda #0
	sta $2e2
	sta $2e4
	sta $2e6

	sty $2e5	// Pattern

	stx $2e1	// X

	ldx #3
	stx $2e3	// Y

	jsr _rom_curset

	lda #0
	sta $2e1	// X

	ldx #7
	stx $2e3	// Y

	jsr _rom_draw

	rts
.)


;//
;// We fill from 239 to 140 (about)
;//
_FillGauge
.(
	ldx #239
loop_draw
	stx timer_position

	ldy #1
	jsr _FillGaugeSegment

	jsr _TemporizeShort

	ldx timer_position
	dex
	cpx #130
	bne loop_draw
	rts
.)





;	.data

_BikesPictures_Left
	.byt 64
	.byt 64+%000111
	.byt 64+%001001
	.byt 64+%010000
	.byt 64+%011100
	.byt 64+%101111
	.byt 64+%100111
	.byt 64+%011000
	.byt 64

_BikesPictures_Right
	.byt 64
	.byt 64+%000000
	.byt 64+%110000
	.byt 64+%111100
	.byt 64+%011110
	.byt 64+%001011
	.byt 64+%111001
	.byt 64+%000110
	.byt 64


_BigDigits
	// 0
	.byt 64+%011111
	.byt 64+%010001
	.byt 64+%010001
	.byt 64+%010011
	.byt 64+%010011
	.byt 64+%010011
	.byt 64+%010011
	.byt 64+%010011
	.byt 64+%011111
	.byt 64+%000000

	// 1
	.byt 64+%000001
	.byt 64+%000001
	.byt 64+%000001
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000000

	// 2
	.byt 64+%011111
	.byt 64+%000001
	.byt 64+%000001
	.byt 64+%000001
	.byt 64+%011111
	.byt 64+%011000
	.byt 64+%011000
	.byt 64+%011000
	.byt 64+%011111
	.byt 64+%000000

	// 3
	.byt 64+%011111
	.byt 64+%000001
	.byt 64+%000001
	.byt 64+%000011
	.byt 64+%011111
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%011111
	.byt 64+%000000

	// 4
	.byt 64+%010001
	.byt 64+%010001
	.byt 64+%010001
	.byt 64+%010011
	.byt 64+%011111
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000000

	// 5
	.byt 64+%011111
	.byt 64+%010000
	.byt 64+%010000
	.byt 64+%010000
	.byt 64+%011111
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%011111
	.byt 64+%000000

	// 6
	.byt 64+%011111
	.byt 64+%010000
	.byt 64+%010000
	.byt 64+%010000
	.byt 64+%011111
	.byt 64+%010011
	.byt 64+%010011
	.byt 64+%010011
	.byt 64+%011111
	.byt 64+%000000

	// 7
	.byt 64+%011111
	.byt 64+%000001
	.byt 64+%000001
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000000

	// 8
	.byt 64+%011111
	.byt 64+%010001
	.byt 64+%010001
	.byt 64+%010011
	.byt 64+%011111
	.byt 64+%010011
	.byt 64+%010011									    
	.byt 64+%010011
	.byt 64+%011111
	.byt 64+%000000

	// 9
	.byt 64+%011111
	.byt 64+%010001
	.byt 64+%010001
	.byt 64+%010011
	.byt 64+%011111
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%000011
	.byt 64+%011111
	.byt 64+%000000

	// 0
	.byt 64+%011111
	.byt 64+%010001
	.byt 64+%010001
	.byt 64+%010011
	.byt 64+%010011
	.byt 64+%010011
	.byt 64+%010011
	.byt 64+%010011
	.byt 64+%011111
	.byt 64+%000000


Intro_TronLogo_Raster_Offset_Low
	.byt <40
	.byt <-40

Intro_TronLogo_Raster_Offset_High
	.byt >40
	.byt >-40


Intro_TronLogo_Description
	// R
	.byt CMD_CURSET	//+CMD_NO_DRAW
	.word 96,101 
	.byt CMD_CIRCLE
	.word 10
	.byt CMD_CIRCLE
	.word 20
	.byt CMD_FILL
	.word 20,4,64
	.byt CMD_CURSET+CMD_NO_DRAW
	.word 96-24,101-20 
	.byt CMD_FILL
	.word 40,4,64

	.byt CMD_CURSET+CMD_NO_DRAW
	.word 96,81 
	.byt CMD_DRAW
	.word -15,0
	.byt CMD_DRAW
	.word 0,10
	.byt CMD_DRAW
	.word 15,0

	.byt CMD_CURSET+CMD_NO_DRAW
	.word 116,101 
	.byt CMD_DRAW
	.word -10,0

	.byt CMD_CURMOV+CMD_NO_DRAW
	.word -3,0 
	.byt CMD_DRAW
	.word 12,18
	.byt CMD_DRAW
	.word -12,0
	.byt CMD_DRAW
	.word -12,-18
	.byt CMD_DRAW
	.word 12,0

	.byt CMD_CURMOV+CMD_NO_DRAW
	.word -14,0 
	.byt CMD_DRAW
	.word 0,18
	.byt CMD_DRAW
	.word -10,0
	.byt CMD_DRAW
	.word 0,-18
	.byt CMD_DRAW
	.word 10,0

	// T
	.byt CMD_CURSET+CMD_NO_DRAW
	.word 49,81 
	.byt CMD_DRAW
	.word 30,0
	.byt CMD_DRAW
	.word 0,10
	.byt CMD_DRAW
	.word -10,0
	.byt CMD_DRAW
	.word 0,28
	.byt CMD_DRAW
	.word -10,0
	.byt CMD_DRAW
	.word 0,-28
	.byt CMD_DRAW
	.word -10,0
	.byt CMD_DRAW
	.word 0,-10

	// O
	.byt CMD_CURSET+CMD_NO_DRAW
	.word 137,100 
	.byt CMD_CIRCLE
	.word 10
	.byt CMD_CIRCLE
	.word 20

	// N
	.byt CMD_CURSET+CMD_NO_DRAW
	.word 158,81 
	.byt CMD_DRAW
	.word 0,38
	.byt CMD_DRAW
	.word 10,0
	.byt CMD_DRAW
	.word 0,-19
	.byt CMD_DRAW
	.word 5,0
	.byt CMD_DRAW
	.word -15,-19

	.byt CMD_CURMOV+CMD_NO_DRAW
	.word 15+2,19 
	.byt CMD_DRAW
	.word 5,0
	.byt CMD_DRAW
	.word 0,-19
	.byt CMD_DRAW
	.word 10,0
	.byt CMD_DRAW
	.word 0,38
	.byt CMD_DRAW
	.word -15,-19

	.byt CMD_END





// one bytes => two digits
// two bytes => 4 digits
// four bytes => 8 digits

_TableNames
	.byt 2,"  TODAY'S HIGHS",254
	.byt 253,254
_TableScores
	.byt 10,"00789       FLYNN",254,254
	.byt 10,"00540         MCP",254,254
	.byt 10,"00230        DBUG",254,254
	.byt 10,"00175       VANJA",254,254
	.byt 10,"00118  COUNT ZERO",254,254
_LabelLastScore = *+1
	.byt 10,"00023   DILLINGER",254,254
	.byt 255
sc
_LabelPlayerScore
	.byt    "00000 "
_LabelPlayerScoreName
	.byt	"SIMPLE USER",254,254


_Message_PressSpace
	.byt 6,12,"Press SPACE to play"
	.byt 255

_Message_Pause
	.byt 253
	.byt 17,14,"PAUSE  "
	.byt 255

_Message_GameOver
	.byt 253
	.byt 14,1,"DISCONNECTED"
	.byt 255

_Message_EnterName
	.byt 2,"Enter your name",254
	.byt 254
	.byt 1," ",62
_LabelPlayerName
	.byt "SIMPLE USER",60	//]"	// 11 characters
	.byt 254,254
	.byt 3,"2 Arrows control",254
	.byt 3," (UP to Change)"
	.byt 255


_Message_LevelNumber
	.byt 253,2,10,"LEVEL #"
_Message_LevelNumberPatch
	.byt "00"
	.byt 255




// The various game types
_Message_GameType_FindTheExit
	.byt 253,10,3,"Locate the shiny exit"
	.byt 255

// Snake/PacMan type :)
_Message_GameType_Snake
	.byt 253,10,3,"Eat all the shiny dots"
	.byt 255

_Message_GameType_Duel
	.byt 253,10,3,"Defeat the other light cycle"
	.byt 255

_Message_GameType_Survivor
	.byt 253,10,3,"Stay alive until the time-out"
	.byt 255



_Message_Arena_NoWalls
	.byt 253,10,3,"The Arena is open"
	.byt 255

_Message_Arena_Closed
	.byt 253,10,3,"The Arena is closed"
	.byt 255

_Message_Arena_HorizontalWalls
	.byt 253,10,3,"The Arena is closed horizontaly"
	.byt 255

_Message_Arena_VerticalWalls
	.byt 253,10,3,"The Arena is closed verticaly"
	.byt 255




_Message_AvoidCollision
	.byt 253,10,3,"Avoid any collision"
	.byt 254,254,254,254
	.byt 14,2," DOWNLOADING ARENA"
	.byt 255


_HexDigits
	.byt "0123456789ABCDEF"


// 12 values
_HighScores_ColorGradient
	.byt 7,7
	.byt 3,3
	.byt 1,1
	.byt 5,5
	.byt 4,4
	.byt 6,6

	.byt 16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4
_Colorline_Gradient
	.byt 16+4,16+4,16+6,16+7,16+3,16+1,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4
	.byt 16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4
	.byt 16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4
	.byt 16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4,16+4


_Table_LogoFade
	.byt 4
	.byt 6
	.byt 7
	.byt 3
	.byt 1

_Score_GradientColorTable
	.byt 1,3,3,7,7,7,3,3,1

_Score_GradientColorTable_Timebar
	.byt 0,7,3,3,3,3,3,1,0

// Table of colors used for the gradient on the Tron logo
// Bits 210	Define the colors for down movement (blue gradient)
// Bits 543 Define the colors for up movement (red gradient)
ColorCycleTable
	.byt 4+(1<<3)
	.byt 4+(1<<3)
	.byt 6+(3<<3)
	.byt 4+(1<<3)
	.byt 6+(3<<3)
	.byt 6+(1<<3)
	.byt 7+(7<<3)
	.byt 6+(3<<3)
	.byt 7+(7<<3)
	.byt 7+(7<<3)


//GradientOffet
//	.byt 0

//ColorLineGradientOffset
//	.byt 0

//ColorsCounter	
//	.byt 0

_LifeColors_Gradient
	.byt 0,0,0,6,6,6

ColorLightCycle
	.byt 16+4
	.byt 16+1

ColorsTrailTable
	.byt 16+6,16+4,16+5,16+4,	// BLUE
	.byt 16+3,16+1,16+5,16+1	// Red


_SquareTable
	.byt 0		// 0*0
	.byt 1		// 1*1
	.byt 4		// 2*2

	.byt 9		// 3*3
	.byt 16		// 4*4
	.byt 25		// 5*5
	.byt 36		// 6*6

	.byt 49		// 7*7
	.byt 64		// 8*8
	.byt 81		// 9*9

	.byt 100	// 10*10
	.byt 121	// 11*11
	// From there, we have overflow :)
	.byt 144	// 12*12
	.byt 169	// 13*13
	.byt 196	// 14*14
	.byt 225	// 15*15
	.byt 255	// (16*16)-1	// 255

_BlueExplosion
	.byt 16+0
	.byt 16+4
	.byt 16+6
	.byt 16+7
	.byt 16+6
	.byt 16+4
	.byt 16+0
	.byt 16+0
_RedExplosion
	.byt 16+0
	.byt 16+1
	.byt 16+3
	.byt 16+7
	.byt 16+3
	.byt 16+1
	.byt 16+0
	.byt 16+0



// List of index values:
// 0 => Erase Tron Logo
// 1 => Erase the text part of screen (During Tron intro)
// 2 => Erase the text part of screen (In Game)
// 3 => Erase the text part of screen (In Game)	with value 16
// 4 => Erase the zero page area
// 5 => Erase the BSS
_EraseMemory_Table_AddrLow
	.byt <$a000+40*3
	.byt <$bb80+40*9
	.byt <$bb80+40*2
	.byt <$bb80+40*2
	.byt <_zp_start_
	.byt <_BssStart_

_EraseMemory_Table_AddrHigh
	.byt >$a000+40*3
	.byt >$bb80+40*9
	.byt >$bb80+40*2
	.byt >$bb80+40*2
	.byt >_zp_start_
	.byt >_BssStart_

_EraseMemory_Table_CountLow
	.byt <40*51
	.byt <40*18
	.byt <40*26-1
	.byt <40*26-1
	.byt <_zp_end_-_zp_start_
	.byt <_BssEnd_-_BssStart_
	
_EraseMemory_Table_CountHigh
	.byt >40*51
	.byt >40*18
	.byt >40*26-1
	.byt >40*26-1
	.byt >_zp_end_-_zp_start_
	.byt >_BssEnd_-_BssStart_

_EraseMemory_Table_EraseValue
	.byt 64
	.byt 0
	.byt 0
	.byt 16
	.byt 0
	.byt 0



// List of all messages:
//  0 => Press space
//  1 => High scores table
//  2 => Level number
//  3 => Enter name
//  4 => Game Type Find the Exit
//  5 => Game Type Snake
//  6 => Game Type Duel
//  7 => Game Type Survivor
//  8 => Arena Warps
//  9 => Arena Walls Horizontal
// 10 => Arena Walls Vertical
// 11 => Arena Walls around
// 12 => Avoid collision !
// 13 => Pause
// 14 => Game over
_Messages_Table_AddrLow
	.byt <_Message_PressSpace
	.byt <_TableNames
	.byt <_Message_LevelNumber
	.byt <_Message_EnterName

	.byt <_Message_GameType_FindTheExit
	.byt <_Message_GameType_Snake
	.byt <_Message_GameType_Duel
	.byt <_Message_GameType_Survivor

	.byt <_Message_Arena_NoWalls
	.byt <_Message_Arena_HorizontalWalls
	.byt <_Message_Arena_VerticalWalls
	.byt <_Message_Arena_Closed

	.byt <_Message_AvoidCollision

	.byt <_Message_Pause
	.byt <_Message_GameOver


_Messages_Table_AddrHigh
	.byt >_Message_PressSpace
	.byt >_TableNames
	.byt >_Message_LevelNumber
	.byt >_Message_EnterName

	.byt >_Message_GameType_FindTheExit
	.byt >_Message_GameType_Snake
	.byt >_Message_GameType_Duel
	.byt >_Message_GameType_Survivor

	.byt >_Message_Arena_NoWalls
	.byt >_Message_Arena_HorizontalWalls
	.byt >_Message_Arena_VerticalWalls
	.byt >_Message_Arena_Closed

	.byt >_Message_AvoidCollision

	.byt >_Message_Pause
	.byt >_Message_GameOver


_Messages_Table_ScreenAddrLow
	.byt <$bb80+40*26+9
	.byt <$bb80+40*10+11
	.byt <$bb80+40*10+13
	.byt <$bb80+40*14+11

	.byt <$bb80+40*14+8
	.byt <$bb80+40*14+10
	.byt <$bb80+40*14+5
	.byt <$bb80+40*14+3

	.byt <$bb80+40*16+10
	.byt <$bb80+40*16+3
	.byt <$bb80+40*16+4
	.byt <$bb80+40*16+9

	.byt <$bb80+40*18+9

	.byt <$bb80+40*14+14

	.byt <$bb80+40*14+11

_Messages_Table_ScreenAddrHigh
	.byt >$bb80+40*26+9
	.byt >$bb80+40*10+11
	.byt >$bb80+40*10+13
	.byt >$bb80+40*14+11

	.byt >$bb80+40*14+8
	.byt >$bb80+40*14+10
	.byt >$bb80+40*14+5
	.byt >$bb80+40*14+3

	.byt >$bb80+40*16+10
	.byt >$bb80+40*16+3
	.byt >$bb80+40*16+4
	.byt >$bb80+40*16+9

	.byt >$bb80+40*18+9

	.byt >$bb80+40*14+14

	.byt >$bb80+40*14+11



_Arena_BackgroundTable_AddrLow
	.byt <_Arena_BackgroundPixel_Black
	.byt <_Arena_BackgroundPixel_Green
	.byt <_Arena_BackgroundPixel_Checkboard
	.byt <_Arena_BackgroundPixel_Grid

_Arena_BackgroundTable_AddrHigh
	.byt >_Arena_BackgroundPixel_Black
	.byt >_Arena_BackgroundPixel_Green
	.byt >_Arena_BackgroundPixel_Checkboard
	.byt >_Arena_BackgroundPixel_Grid



_DrawCircle_PixelRenderTable_AddrLow
	.byt <_DrawCircle_PixelRender_Explode
	.byt <_DrawCircle_PixelRender_DrawDisc

_DrawCircle_PixelRenderTable_AddrHigh
	.byt >_DrawCircle_PixelRender_Explode
	.byt >_DrawCircle_PixelRender_DrawDisc



ExplodeDistanceTable
	.byt 95,60,30,15,4,0



//
// 0 => Horizontal wall (orange)
// 1 => Vertical wall (orange)

// Serie of blocs for the corridor
// 2 => 11

// Serie of discs for the Mickey Level
// 12 => 14 

// Serie of blocs for the cross
// 15 => 16

// Serie of blocs for the UTurn
// 17 => 28

// Serie of blocs for the round shapes
// 29 => 
// 
_ArenaItems_Table_PosX
	.byt 0		// 0
	.byt 255	// 1

	.byt 16		// 2
	.byt 37		// 3
	.byt 37		// 4
	.byt 99		// 5
	.byt 154	// 6
	.byt 177	// 7
	.byt 72		// 8
	.byt 203	// 9
	.byt 62		// 10
	.byt 124	// 11

	.byt 128	// 12
	.byt 128+24	// 13
	.byt 128+14	// 14

	// Cross
	.byt 190	// 15
	.byt 120	// 16

	// Uturn
	.byt 48	// 17
	.byt 48	// 18
	.byt 82	// 19

	.byt 169	// 20
	.byt 169	// 21
	.byt 169	// 22

	.byt 104	// 23
	.byt 144	// 24
	.byt 104	// 25

	.byt 104	// 26
	.byt 144	// 27
	.byt 104	// 28

	// Round shapes
	.byt 11		// 29
	.byt 11		// 30
	.byt 11		// 31
	.byt 11		// 32

	.byt 181	// 33
	.byt 226	// 34
	.byt 226	// 35
	.byt 181	// 36


_ArenaItems_Table_PosY
	.byt 127
	.byt 0

	.byt 1
	.byt 11
	.byt 11
	.byt 22
	.byt 11
	.byt 35
	.byt 47
	.byt 60
	.byt 36
	.byt 1

	.byt 64
	.byt 64-12
	.byt 64+8

	.byt 60
	.byt 96

	//
	.byt 41	// 17
	.byt 81	// 18
	.byt 41	// 19

	.byt 41	// 20
	.byt 81	// 21
	.byt 41	// 22

	.byt 21	// 23
	.byt 21	// 24
	.byt 45	// 25

	.byt 82	// 26
	.byt 82	// 27
	.byt 82	// 28

	// Round shapes
	.byt 5		// 29
	.byt 5		// 30
	.byt 78		// 31
	.byt 98		// 32

	.byt 5		// 33
	.byt 5		// 34
	.byt 78		// 35
	.byt 98		// 36


_ArenaItems_Table_Radius
_ArenaItems_Table_Width
	.byt 0	// 256
	.byt 2

	.byt 10
	.byt 10
	.byt 73
	.byt 66
	.byt 88
	.byt 78
	.byt 114
	.byt 38
	.byt 23
	.byt 18

	.byt 12
	.byt 12
	.byt 14

	.byt 130
	.byt 16

	//
	.byt 41	// 17
	.byt 41	// 18
	.byt 7	// 19

	.byt 41	// 20
	.byt 41	// 21
	.byt 7	// 22

	.byt 7	// 23
	.byt 7	// 24
	.byt 47	// 25

	.byt 7	// 26
	.byt 7	// 27
	.byt 47	// 28

	// Round shapes
	.byt 24		// 29
	.byt 69		// 30
	.byt 24		// 31
	.byt 69		// 32

	.byt 69		// 33
	.byt 24		// 34
	.byt 24		// 35
	.byt 69		// 36
	

_ArenaItems_Table_Height
	.byt 2
	.byt 128

	.byt 116
	.byt 116
	.byt 13
	.byt 13
	.byt 13
	.byt 13
	.byt 63
	.byt 67
	.byt 74
	.byt 10

	.byt 0
	.byt 0
	.byt 0

	.byt 10
	.byt 64

	//
	.byt 7	// 17
	.byt 7	// 18
	.byt 47	// 19

	.byt 7	// 20
	.byt 7	// 21
	.byt 47	// 22

	.byt 27	// 23
	.byt 27	// 24
	.byt 7	// 25

	.byt 27	// 26
	.byt 27	// 27
	.byt 7	// 28

	// Round shapes
	.byt 44		// 29
	.byt 24		// 30
	.byt 44		// 31
	.byt 24		// 32

	.byt 24		// 33
	.byt 44		// 34
	.byt 44		// 35
	.byt 24		// 36


_ArenaItems_Table_Color
	.byt 16+3
	.byt 16+3

	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+6

	.byt 16+3
	.byt 16+3
	.byt 16+6

	.byt 16+3
	.byt 16+3

	//
	.byt 16+3	// 17
	.byt 16+3	// 18
	.byt 16+3	// 19

	.byt 16+3	// 20
	.byt 16+3	// 21
	.byt 16+3	// 22

	.byt 16+6	// 23
	.byt 16+6	// 24
	.byt 16+6	// 25

	.byt 16+6	// 26
	.byt 16+6	// 27
	.byt 16+6	// 28

	// Round shapes
	.byt 16+3	// 29
	.byt 16+3	// 30
	.byt 16+6	// 31
	.byt 16+6	// 32

	.byt 16+6	// 33
	.byt 16+6	// 34
	.byt 16+3	// 35
	.byt 16+3	// 36


//
// List of levels:
// No TYPE		WALLS		LEVEL
// 00 EXIT		ALL			CORRIDOR
// 01 TIME					MICKEY+ANGLES
// 02 CYCLE		
// 03 EXIT
// 04 CYCLE
// 05 TIME
// 06 CYCLE
// 07 TIME


// Definition of levels contains:
// - Game type on two bits (4 values)
// - Game warp mode on two bits (4 values)
// - Arena color scheme on two bits (4 values)
// - Orientation of player on two bits (4 values)
_LevelDef_Infos_Arena
	.byt GAMETYPE_FIND_THE_EXIT	+(ARENATYPE_WALLS_ALL<<2)		+(ARENACOLOR_BLACK<<4)		+(DIRECTION_DOWN<<6)
	.byt GAMETYPE_SURVIVOR		+(ARENATYPE_WALLS_NONE<<2)		+(ARENACOLOR_GRID<<4)		+(DIRECTION_RIGHT<<6)
	.byt GAMETYPE_DUEL			+(ARENATYPE_WALLS_ALL<<2)		+(ARENACOLOR_CHESSBOARD<<4)	+(DIRECTION_UP<<6)
	.byt GAMETYPE_FIND_THE_EXIT	+(ARENATYPE_WALLS_NONE<<2)		+(ARENACOLOR_GRID<<4)		+(DIRECTION_LEFT<<6)
	.byt GAMETYPE_DUEL			+(ARENATYPE_WALLS_HORIZONTAL<<2)+(ARENACOLOR_CHESSBOARD<<4)	+(DIRECTION_LEFT<<6)
	.byt GAMETYPE_SURVIVOR		+(ARENATYPE_WALLS_NONE<<2)		+(ARENACOLOR_GREEN<<4)		+(DIRECTION_LEFT<<6)
	.byt GAMETYPE_DUEL			+(ARENATYPE_WALLS_VERTICAL<<2)	+(ARENACOLOR_GRID<<4)		+(DIRECTION_DOWN<<6)
	.byt GAMETYPE_SURVIVOR		+(ARENATYPE_WALLS_ALL<<2)		+(ARENACOLOR_CHESSBOARD<<4)	+(DIRECTION_RIGHT<<6)

// Orientation of the player
// - Orientation of second player on two bits (4values)
// - [Remains 6 bits]
_LevelDef_Infos_Direction0
	.byt 0				+((OBSTACLE_CORRIDOR)<<2)
	.byt 0				+((OBSTACLE_ROUNDEDSHAPES+OBSTACLE_MICKEY)<<2)
	.byt DIRECTION_UP	+((OBSTACLE_CROSS)<<2)
	.byt 0				+((OBSTACLE_CROSS+OBSTACLE_ROUNDEDSHAPES)<<2)
	.byt DIRECTION_RIGHT+((OBSTACLE_MICKEY)<<2)
	.byt 0				+((OBSTACLE_CORRIDOR)<<2)
	.byt DIRECTION_UP	+((OBSTACLE_ROUNDEDSHAPES)<<2)
	.byt 0				+((OBSTACLE_ROUNDEDSHAPES+OBSTACLE_MICKEY+OBSTACLE_CROSS)<<2)

_LevelDef_Infos_XPos0
	.byt 9
	.byt 20
	.byt 124
	.byt 47
	.byt 107
	.byt 132
	.byt 124
	.byt 183

_LevelDef_Infos_YPos0
	.byt 4
	.byt 64
	.byt 88
	.byt 74
	.byt 63
	.byt 19
	.byt 63
	.byt 3

// Position of the second player, or of the exit,
// depending of the current game mode
// Or timer decaying speed in against the clock mode
_LevelDef_Infos_XPos1
	.byt 246
	.byt 10		// Timer decay speed
	.byt 132
	.byt 127
	.byt 167
	.byt 15		// Timer decay speed
	.byt 132
	.byt 20		// Timer decay speed

_LevelDef_Infos_YPos1
	.byt 115
	.byt 0		// UNUSED
	.byt 88
	.byt 63
	.byt 63
	.byt 0		// UNUSED
	.byt 63
	.byt 0		// UNUSED




;//
;// These two tables are used to define the increments to
;// apply to move the players on the map depending of the
;// orientation.
;//
;// 0 <-
;// 1 ^
;// 2 ->
;// 3 v
;//
_Move_IncrementTable_Y
	.byt 0
_Move_IncrementTable_X
	.byt 255
	.byt 0
	.byt 1
	.byt 0


EndText

	.bss

*=EndText

;
; Allign the content of BSS section to a byte boudary
;
	.dsb 256-(*&255)

_BssStart_


//
// Game area is a 256x128 buffer => 32768k
//
_BigBuffer
	.dsb 256*128

	.byt 0
ScoreTable
	.byt 0	// 0
	.byt 0	// 1
	.byt 0	// 2
	.byt 0	// 3
	.byt 0	// 4
	.byt 0	// 5

	.byt 0
ScoreTable_Sub
	.byt 0	// 0
	.byt 0	// 1
	.byt 0	// 2
	.byt 0	// 3
	.byt 0	// 4
	.byt 0	// 5




_BssEnd_



