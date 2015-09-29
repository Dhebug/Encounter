;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Code to handle items

#include "params.h"

; Use delete_object(X) to eliminate item
; Use script disappear_at_border
; 

; First entry should be equal to MAX_ENEMY_TYPES on enemies.s
#define FIRST_ITEM		9

#define ITEM_GAMEBOY	9
#define ITEM_MAC		10
#define ITEM_SPECCY		11
#define ITEM_TAPE		12
#define ITEM_ATARI		13
#define ITEM_C64		14
#define ITEM_ZX81		15
#define ITEM_DISK		16
#define ITEM_STICK		17
#define ITEM_FRUIT		18
#define ITEM_HEART		19
#define ITEM_BOMB		20
#define ITEM_DEATH		21

#define LAST_ITEM		ITEM_DEATH


; Tables with pointers to graphics
item_sprite_lo	.byt <_item_gameboy,<_item_mac,<_item_speccy,<_item_tape,<_item_atari,<_item_c64,<_item_zx81,<_item_disk,<_item_stick,<_item_fruit,<_item_heart,<_item_bomb,<_item_death
item_sprite_hi  .byt >_item_gameboy,>_item_mac,>_item_speccy,>_item_tape,>_item_atari,>_item_c64,>_item_zx81,>_item_disk,>_item_stick,>_item_fruit,>_item_heart,>_item_bomb,>_item_death
item_mask_lo	.byt <_mask_item_gameboy,<_mask_item_mac,<_mask_item_speccy,<_mask_item_tape,<_mask_item_atari,<_mask_item_c64,<_mask_item_zx81,<_mask_item_disk,<_mask_item_stick,<_mask_item_fruit,<_mask_item_heart,<_mask_item_bomb,<_mask_item_death
item_mask_hi	.byt >_mask_item_gameboy,>_mask_item_mac,>_mask_item_speccy,>_mask_item_tape,>_mask_item_atari,>_mask_item_c64,>_mask_item_zx81,>_mask_item_disk,>_mask_item_stick,>_mask_item_fruit,>_mask_item_heart,>_mask_item_bomb,>_mask_item_death
item_action_lo	.byt <retro_item_taken,<retro_item_taken,<retro_item_taken,<retro_item_taken,<retro_item_taken,<retro_item_taken,<retro_item_taken,<retro_item_taken,<stick_taken,<fruit_taken,<extra_life,<big_bomb,<death_taken
item_action_hi	.byt >retro_item_taken,>retro_item_taken,>retro_item_taken,>retro_item_taken,>retro_item_taken,>retro_item_taken,>retro_item_taken,>retro_item_taken,>stick_taken,>fruit_taken,>extra_life,>big_bomb,>death_taken


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Creates an item for newly
; destroyed ship X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
create_item
.(
	; Test code
	;lda #(ITEM_HEART-FIRST_ITEM)
	;jmp okitem
	
	; Only of not a shot from the boss
	lda sprite_type,x
	cmp #8	; BOSS_SHOT
	beq dontdoit

	; Randomly generate a new item. If not generated jmp delete_object
	jsr randgen
	cmp #80		; Approximately 30% of the time
	bcc doit
dontdoit	
	jmp delete_object
doit	

.(
	lda beginner_mode
	and bm_drop
	beq skipprintbm
	dec bm_drop
	lda #92	
	jsr print_beginner_msg
skipprintbm	
.)	

	; Make an sfx
	lda #TIRU
	jsr _PlaySfx
	
	; Set new speed
	lda #3
	sta speedp,x

	jsr randgen
	lda randseed
	and #%1111
	cmp #LAST_ITEM-FIRST_ITEM+1
	bcc okitem
	lsr
okitem		
	clc
	adc #FIRST_ITEM
	tay
checkitem
	
	; Set sprite graphic & mask
	lda item_sprite_lo-FIRST_ITEM,y
	sta sprite_grapl,x
	lda item_sprite_hi-FIRST_ITEM,y
	sta sprite_graph,x
	lda item_mask_lo-FIRST_ITEM,y
	sta sprite_maskl,x
	lda item_mask_hi-FIRST_ITEM,y
	sta sprite_maskh,x

	; Set its status to normal
	lda #1
	sta sprite_status,x
	
	; Set the command
	lda #<disappear_at_border
	sta pcommand_l,x
	lda #>disappear_at_border
	sta pcommand_h,x
	lda #0
	sta ccommand_h,x
	

	; Set initial anim_state
	;lda #0
	sta anim_state,x
	
	; Set type
	tya
	sta sprite_type,x

	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make the player take an item
; X=sprite index
; A=sprite type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_item
.(
	pha
	jsr do_remove_object
.(
	pla
	pha
	cmp #ITEM_STICK
	bcs skipprintbm
	lda beginner_mode
	and bm_item
	beq skipprintbm
	dec bm_item
	lda #91	
	jsr print_beginner_msg
skipprintbm	
.)	
	pla
	tay
	lda item_action_lo-9,y
	sta jmp_action+1
	lda item_action_hi-9,y
	sta jmp_action+2
jmp_action
	jmp $1234	
.)	


;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Got an extra life
; After enough retro-items
; the code jumps here too
;;;;;;;;;;;;;;;;;;;;;;;;;;;
extra_life
.(
	inc lives
	jsr update_lives
	lda #BEEPLE ; TEMPORARY!!!!
	jmp _PlaySfx
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Got the fruit
;;;;;;;;;;;;;;;;;;;;;;;;;;;
fruit_taken
.(
	lda #128
	sta frozen_enemies
	lda #ALERT2
	jmp _PlaySfx
.)	

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Got a Quickshot powerup
;;;;;;;;;;;;;;;;;;;;;;;;;;;
stick_taken
.(
	lda #1
	sta quick_shot
	bne do_item_sound	
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Got a Supershot powerup
;;;;;;;;;;;;;;;;;;;;;;;;;;;
death_taken
.(
	lda #1
	sta super_shot
	bne do_item_sound	; Jumps always
.)

;;;;;;;;;;;;;;;;;;;;;
; Got a normal item
;;;;;;;;;;;;;;;;;;;;;

retro_item_taken
.(
	lda items
	cmp #31
	bne doit
	; Extra life granted!
	jsr extra_life
	lda #0
	sta items
	jmp update_retro_meter
doit	
	inc items
	jsr update_retro_meter
+do_item_sound	
	lda #PICKB	
	jmp _PlaySfx
.)	

;;;;;;;;;;;;;;;;;;;;;
; Got a bomb
;;;;;;;;;;;;;;;;;;;;;
big_bomb
.(
	lda #PICKB
	jsr _PlaySfx

	; Make all enemies explode
	ldx #FIRST_SHOT-1
loop
	; Is this ship active?
	lda sprite_status,x
	beq skip
	
	; Is it exploding?
	and #IS_EXPLODING
	bne skip

	; Is it an item?
	lda sprite_type,x
	cmp #FIRST_ITEM
	bcs skip
	
	; It is a ship add score, delete shot and make it explode	
	stx savx+1
	tay
	lda enemy_points,y
	jsr add_score
savx
	ldx #0
	
	; Make it explode with some random retarding
	jsr randgen
	and #%11111
	jsr retarded_explode
	ldx savx+1
skip
	dex
	cpx #1	; Avoid checking the hero
	bne loop

	rts

.)