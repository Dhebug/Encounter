;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Code to generate enemies

#include "params.h"

; Current number of enemies in the game
waveobjects .byt 0	

; Tables with enemy types:
#define MAX_ENEMY_TYPES 	8

#define ENEMY_SHIPA			0
#define ENEMY_SAUCE			1
#define ENEMY_DOUGNUTH 		2
#define ENEMY_EYEBALL  		3
#define ENEMY_REDBALOON 	4
#define ENEMY_PHANTOM		5
#define ENEMY_VADER			6
#define ENEMY_EVILEYES		7

; This one is generated for boss levels only
#define ENEMY_BOSSSHOT		8

; Table to decide the type of enemies depending on the
; level being played
; Entries are the minimum level at which the corresponding
; enemy type may appear
tab_enemies_level
	.byt 1,2,4,6,10,15,17,29,0


; Types of enemies: 
; ship A, flying sauce, doughnut, eye ball, red baloon, phantom, vader, evil eyes, boss shots
enemy_min_amount 
	.byt 2, 2, 4, 1, 1, 1, 1, 1, 1
enemy_max_amount
	.byt 4, 6, 6, 2, 2, 4, 2, 1, 2
enemy_sprite_lo
	.byt <_enemy_shipA, <_enemy_sauce, <_enemy_doughnut, <_enemy_eyeball,<_enemy_redbaloon,<_enemy_phantom, <_enemy_vader, <_enemy_evileyes, <_boss_shooting_init
enemy_sprite_hi	
	.byt >_enemy_shipA, >_enemy_sauce, >_enemy_doughnut, >_enemy_eyeball,>_enemy_redbaloon,>_enemy_phantom, >_enemy_vader, >_enemy_evileyes, >_boss_shooting_init
enemy_mask_lo
	.byt <_mask_enemy_shipA, <_mask_enemy_sauce,  <_mask_enemy_doughnut, <_mask_enemy_eyeball,<_mask_enemy_redbaloon,<_mask_enemy_phantom, <_mask_enemy_vader, <_mask_enemy_evileyes ,<_mask_all
enemy_mask_hi	
	.byt >_mask_enemy_shipA, >_mask_enemy_sauce, >_mask_enemy_doughnut, >_mask_enemy_eyeball,>_mask_enemy_redbaloon,>_mask_enemy_phantom, >_mask_enemy_vader, >_mask_enemy_evileyes ,>_mask_all
enemy_pcommand_lo
	.byt <move_lateral_and_back, <lateral_avoidshots, <move_elliptical, <move_lateral_and_back, <move_up_and_down, <lateral_advanced, <elliptical_advanced, <lateral_advanced, <boss_shot_ctrl
enemy_pcommand_hi
	.byt >move_lateral_and_back, >lateral_avoidshots, >move_elliptical, >move_lateral_and_back, >move_up_and_down, >lateral_advanced, >elliptical_advanced, >lateral_advanced, >boss_shot_ctrl
enemy_ccommand_lo
	.byt <ai_shipA, <ai_shipA, 0, <ai_eyeballs, <gen_fourframe, <gen_fourframe, <ai_vader, 0, 0
enemy_ccommand_hi
	.byt >ai_shipA, >ai_shipA, 0, >ai_eyeballs, >gen_fourframe, >gen_fourframe, >ai_vader, 0, 0
enemy_max_speed
	.byt 7, 7, 6, 3, 3, 6, 6, 7, 7
enemy_reaction_speed
	.byt %111, %11, %111, %1111, %11, %11, %11, %11, %11
enemy_points
	.byt 1, 1, 2, 3, 4, 5, 6, 7, 5

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Creates a wave of enemies...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
create_wave
.(
	; Skip if enemies are frozen!
	lda frozen_enemies
	bne retme
	
	; See if we don't have the max enemies
	; already onscreen
	lda #MAX_ENEMIES
	sec
	sbc waveobjects
	bpl doit
retme
	rts ; Too many enemies already...
doit
	; Let's create some enemies. This should
	; depend on many things, including some 
	; randomness, the current level being played,
	; the amount of enemies that can be created 
	; in this call, etc.

	
	; Save the amount of enemies that can be created
	sta tmp
	
	jsr randgen
	
	cmp #200 ; Approx. 78% of the times create something.
	bcs retme
		
	; Now determine the type of enemy we are going to create.
	; This should be somewhat random, but as the game level
	; increases, it is more likely to generate difficult enemies
	; (last entries in the table).
	; Also some enemies cannot be created until certain levels

	; If in boss mode, create only boss shots and not so often
	ldy boss_mode
	beq normal_enemies
	;cmp #100
	;bcs retme
	lda boss_shooting
	bne retme
	
	lda #1
	ldy #ENEMY_BOSSSHOT
	bne create_enemy 	; Jumps always
	
normal_enemies	
	jsr randgen
	and #(MAX_ENEMY_TYPES-1)
	tay
	lda level
loopred
	cmp tab_enemies_level,y
	bcs createit
	; Reduce the difficulty
	dey
	jmp loopred
createit	
	; Don't create Vaders or Evil Eyes on Lab mode
	lda labyrinth_mode
	beq skiplabcheck
	cpy #ENEMY_VADER
	bcs retme
	
skiplabcheck	
	; is it posible to generate the minimum number of enemies?
	lda tmp
	cmp enemy_min_amount,y
	bcc retme	; It wasn't
	
	; Are they too many for this kind of object?
	cmp enemy_max_amount,y
	bcc create_enemy
	; They are too many, fix this...
	lda enemy_max_amount,y
	
	; Create enemy of the chosen kind
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Creates reg A number of enemies 
; of the type passed in reg Y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
create_enemy
.(
	sta tmp+1
	ldx onslaught
	beq loop
	; onslaught mode, update total enemies
	ldx total_enemies
	cpx #NUM_ENEMIES_ONSLAUGHT
	bcs end
	clc
	adc total_enemies
	sta total_enemies
loop	
	; Create object at next free entry
	ldx #(FIRST_SHOT-1)
loopent
	lda sprite_status,x
	beq found
	dex 
	cpx #1
	bne loopent
	; Free entry not found. This should never happen!
	; But it does when enemies are exploding and
	; new creation is called
	; TODO: Remove this trap (and fix?) for release
	.(
;	lda #0
;	dbug beq dbug
	.)
	
	rts 
found	
	; Set object as active
	lda #1
	sta sprite_status,x
	
	; Set location and direction
	sta sprite_dir,x
	lda sprite_cols
	clc
	adc #140
	sta tmp
	bpl generate_left
	lda #$ff
	sta sprite_dir,x
generate_left
	txa
	clc
	adc tmp
	sta sprite_cols,x
	
	jsr randgen
	and #%1111
	adc #1
	ora #1
	sta sprite_rows,x

	; If in boss mode, change location speed...
	lda boss_mode
	beq no_boss_mode
	lda sprite_rows
	cmp #9
	bcs down
	lda #4
	.byt $2c
down
	lda #14
	sta sprite_rows,x
	
	lda #(19+BOSS_COL)
	sta sprite_cols,x
	
	lda #8
	sta speedp,x

	; Set this so it is invulnerable
	lda #IS_EXPLODING
	ora sprite_status,x
	sta sprite_status,x

	
	jsr initial_specs_ex
	jmp finishit
	
no_boss_mode	
	; Put initial specs for this enemy
	jsr initial_specs

finishit	
	; Increment objects and see if we have to create more
	inc waveobjects
	dec tmp+1
	beq end
	jmp loop
end	
	; Finished creating this set of enemies
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sets the initial specs for
; an enemy of id passed in reg
; X and of type passed in reg
; Y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
initial_specs
.(
	; Set maximum speed and reaction speed
	lda enemy_max_speed,y
	sta speedp,x
	sta max_speed,x
	lda enemy_reaction_speed,y
	sta reac_speed,x

	; Adjust reaction speed for low levels
	lda #LEV_CAKE
	cmp level
	bcc skip1
	rol reac_speed,x
skip1	
	
	lda #LEV_TUTORIAL
	cmp level
	bcc skip2
	;rol reac_speed,x
	dec speedp,x
	dec max_speed,x
skip2

	lda #LEV_MAYHEM
	cmp level
	bcs skip3
	lsr reac_speed,x 
skip3	

+initial_specs_ex
	; Set sprite graphic & mask
	lda enemy_sprite_lo,y
	sta sprite_grapl,x
	lda enemy_sprite_hi,y
	sta sprite_graph,x
	lda enemy_mask_lo,y
	sta sprite_maskl,x
	lda enemy_mask_hi,y
	sta sprite_maskh,x
	
	; Set commands for this enemy
	lda onslaught
	beq normal
	lda #<move_elliptical
	sta pcommand_l,x
	lda #>move_elliptical
	sta pcommand_h,x
	bne	setccomand	; Branches always
normal	
	lda enemy_pcommand_lo,y
	sta pcommand_l,x
	lda enemy_pcommand_hi,y
	sta pcommand_h,x
setccomand
	lda enemy_ccommand_lo,y
	sta ccommand_l,x
	lda enemy_ccommand_hi,y
	sta ccommand_h,x

	; Set initial anim_state
	lda #0
	sta anim_state,x
	
	; Set type
	tya
	sta sprite_type,x
	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Simple AI for a ship that
; moves laterally. With 
; the reac_speed and some
; randomness tries to
; match the hero's row
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ai_shipA
.(
	lda frame_counter
	and reac_speed,x
	bne retme
doit
	jsr randgen
	cmp #200
	bcs doit2
	lda #0
	sta speedv,x
	rts
doit2
	lda sprite_rows,x
	cmp sprite_rows
	bcs lower
	lda #1
	.byt $2c
lower
	lda #$ff
	sta speedv,x
retme	
	rts
.)
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Implementation of the ai
; for the eyeballs.
; This goes in the continuous
; command.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ai_eyeballs
.(
	lda frame_counter
	and reac_speed,x
	beq doit
retme
	rts
doit
	; With some random prob of doing nothing...
	jsr randgen
	cmp #200
	bcs retme
	
	; Check if near hero
	lda sprite_cols
	sec
	sbc sprite_cols,x
	bpl notneg
	sta tmp
	lda #$ff
	sbc tmp
notneg
	cmp #8
	bcc isnear
	rts
isnear
	; Set the new command to open the eye
	lda #<ai_openeye
	sta ccommand_l,x
	lda #>ai_openeye
	sta ccommand_h,x
	rts
ai_openeye
	; Open the eye!
	inc anim_state,x
	lda anim_state,x
	lsr
	bcc nomore
	
	lda sprite_grapl,x
	clc
	adc #32
	sta sprite_grapl,x
	bcc nocarry
	inc sprite_graph,x
nocarry
	lda anim_state,x
	cmp #3*2-1
	bne nomore
	; The eye is open, make it attack the player!
	lda #<ram_hero
	sta pcommand_l,x
	lda #>ram_hero
	sta pcommand_h,x
	lda #4
	sta speedp,x
	lda #%11
	sta reac_speed,x
	; Set the new command to wait to close the eye
	; Duration of the attack
	lda #100
	sta sprite_var1,x
	lda #<ai_closeeye
	sta ccommand_l,x
	lda #>ai_closeeye
	sta ccommand_h,x
nomore	
	rts
ai_closeeye
	lda sprite_var1,x
	beq closeme
	dec sprite_var1,x
	rts
closeme
	dec anim_state,x
	lda anim_state,x
	lsr
	bcs nomore
	
	lda sprite_grapl,x
	sec
	sbc #32
	sta sprite_grapl,x
	bcs nocarry2
	dec sprite_graph,x
nocarry2
	lda anim_state,x
	bne nomore
	; The eye is closed, back to normal
	ldy #ENEMY_EYEBALL
	jmp initial_specs
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generic 4 frame animation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gen_fourframe
.(
	lda frame_counter
	and #%11 ;reac_speed,x
	beq doit
retme
	rts
doit	
	inc anim_state,x
	lda anim_state,x
	and #%11
	beq restoreg
	; Advance frame
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

restoreg	
	; Get the first frame back
	sec
	lda sprite_grapl,x
	sbc #(32*3)
	sta sprite_grapl,x
	bcs noborrow
	dec sprite_graph,x
noborrow
	sec	
	lda sprite_maskl,x
	sbc #(32*3)
	sta sprite_maskl,x
	bcs noborrow2
	dec sprite_maskh,x
noborrow2	
	rts
.)

;;;;;;;;;;;;;;;;;;
; ai for Vader
;;;;;;;;;;;;;;;;;;
ai_vader
.(
	; Check if near hero
	lda sprite_cols
	sec
	sbc sprite_cols,x
	bpl notneg
	sta tmp
	lda #$ff
	sbc tmp
notneg
	cmp #8
	bcc checkrow
	rts
checkrow
	lda sprite_rows
	sec
	sbc sprite_rows,x
	bpl notneg2
	sta tmp
	lda #$ff
	sbc tmp
notneg2
	cmp #8
	bcc isnear
	rts
isnear	
	lda sprite_rows,x
	cmp sprite_rows
	bcs down
	; Vader is above the hero
	lda #1
	.byt $2c
down
	lda #$ff
	sta speedv
retme
	rts
.)


; ai for boss' shots
boss_shot_ctrl
.(
	; Install the command for the inistialization phase
	lda #<launch_shot
	sta pcommand_l,x
	lda #>launch_shot
	sta pcommand_h,x

	; Signal generating shot
	lda #1
	sta boss_shooting
	rts
launch_shot
	lda frame_counter
	and #%111
	beq doit
	rts
doit
	; Do the next step..
	; increment pointers and anim_state
	lda anim_state,x
	cmp #9
	bcc keep_init
	; Initialization phase ready
	; change commands and graphic pointers...
	lda #0
	sta anim_state,x
	lda #<_boss_shoot
	sta sprite_grapl,x
	lda #>_boss_shoot
	sta sprite_graph,x
	lda #<_mask_boss_shoot
	sta sprite_maskl,x
	lda #>_mask_boss_shoot
	sta sprite_maskh,x
	lda #<boss_shot_fly
	sta pcommand_l,x
	lda #>boss_shot_fly
	sta pcommand_h,x
	lda #<gen_fourframe
	sta ccommand_l,x
	lda #>gen_fourframe
	sta ccommand_h,x

	; Clear the flag
	lda sprite_status,x
	and #255^IS_EXPLODING
	sta sprite_status,x

	; Maximum speed
	lda #7
	sta speedp,x

	; Signal this is finished
	lda #0
	sta boss_shooting
	
	; Direction of shooting
	lda sprite_cols,x
	cmp sprite_cols
	bcc toright
	lda #$ff
	.byt $2c	
toright
	lda #$1
	sta sprite_dir,x
	rts
keep_init	
	inc anim_state,x
	lda sprite_grapl,x
	clc
	adc #32
	sta sprite_grapl,x
	bcc nocarry
	inc sprite_graph,x
nocarry
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Control of boss' shots
; moves laterally. With 
; the reac_speed tries to
; match the hero's row
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
boss_shot_fly
.(
	lda frame_counter
	and reac_speed,x
	beq doit
	rts
doit
	lda sprite_rows,x
	cmp sprite_rows
	beq same
	bcs lower
	lda #1
	.byt $2c
lower
	lda #$ff
	.byt $2c
same
	lda #0
	sta speedv,x

	jmp disappear_at_border
.)



/*

;;;;;;;;;;; TESTING
; Create test ships
rs .byt %111
ms .byt 3
;;;;;;;;;;;;;; VALUES tested with elliptical
; $0f $03 -> Quite innocent, but ok
; $07 $04 -> Better reaction
; $03 $05 -> Bah
; $01 $06 -> Dangerous
; $07 $07 -> Difficult to kill
; $01 $07 -> Quite lethal

;; For avoid_shots make sure reaction speed
;; is set to something like 11 at least, or
;; they will be really hard to kill

;; For ramming tactic reaction speed
;; set to 1 is really hard to beat
;; when set to 1111 it hardly rams the 
;; hero.

create_wave_test
.(	

	ldx #2;9
loop
	lda #1
	sta sprite_status,x
	sta sprite_dir,x
	lda ms
	sta speedp,x
	lda sprite_cols
	clc
	adc #140
	sta tmp
	
	bmi generate_left
	lda #$ff
	sta sprite_dir,x
generate_left
	txa
	clc
	adc tmp
	sta sprite_cols,x
	
	lda #<_enemy_doughnut
	sta sprite_grapl,x
	lda #>_enemy_doughnut
	sta sprite_graph,x
	
	lda #<_mask_enemy_doughnut
	sta sprite_maskl,x
	lda #>_mask_enemy_doughnut
	sta sprite_maskh,x
	
	;lda #<move_elliptical
	lda #<ram_hero
	sta pcommand_l,x
	;lda #>move_elliptical
	lda #>ram_hero
	sta pcommand_h,x

	lda rs
	sta reac_speed,x
	lda ms
	sta max_speed,x
	
	lda #0
	sta anim_state,x

	inc waveobjects
	
	dex
	cpx #1
	bne loop
	
	lda #5
	sta sprite_rows+2
	lda #8
	sta sprite_rows+3
	lda #11
	sta sprite_rows+4
	lda #6
	sta sprite_rows+5
	lda #9
	sta sprite_rows+6
	lda #12
	sta sprite_rows+7
	lda #14
	sta sprite_rows+8
	lda #7
	sta sprite_rows+9
	
	clc
	ror rs
	bne skiprs
	lda #%1111
	sta rs
skiprs

	ldx ms
	cpx #7
	beq skipms
	inc ms
skipms	

	rts
	
.)	
	;;;;;;;;;;;;;; TESTING
*/

