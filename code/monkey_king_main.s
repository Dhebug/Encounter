
#include "params.h"


;
; Game sprites defines
;
#define BAREL_BASE_MAIN		0
#define BAREL_COUNT_MAIN	17

#define GIRDER_BASE_MAIN	__FirstGirder-__FirstSprite
#define GIRDER_COUNT_MAIN	5

#define BREAKPOINT  jmp *

#define GAME_MODE    // Comment out to test

	.zero

	*= $1

; Some two byte values
_zp_start_

ptr_src         .dsb 2
ptr_dst         .dsb 2

current_score	.dsb 2


; Some one byte temporaries
rand_low		.dsb 1		; Random number generator, low part
rand_high		.dsb 1		; Random number generator, high part

meta_bloc_index	.dsb 1
sub_bloc_index	.dsb 1

tmp_save_sprite	.dsb 1
tmp_width		.dsb 1
tmp_height		.dsb 1

paint_width		.dsb 1
paint_height	.dsb 1

save_y			.dsb 1

b_tmp1			.dsb 1
b_tmp2			.dsb 1

live_counter	.dsb 1		; Number of lives remaining
flag_mario_end	.dsb 1		; 0=playing 1=mario collide 2=mario falled 3=mario win
mario_jmp_count	.dsb 1
death_counter	.dsb 1
hero_position	.dsb 1
last_key_press	.dsb 1


zp_x            .dsb 1
zp_y            .dsb 1

CraneStatus				.byt 0	; 01	(OFF or ON)
CranePosition			.byt 0	; 012
HookPosition			.byt 0	; 01234
_KongPosition			.byt 0			; 0 1 2 (3 when crashed ???)

_zp_end_


	.text
    
    *=$d6a0     ; _Minigame

_BottomGraphics = $D2E0

_main           jmp real_start   ; +0
read_keyboard   jmp $1234        ; +3
play_sound      jmp $1234        ; +6


real_start    
    ; Initialize charset with the background image
    jsr _RefineCharacters
    jsr _DisplayCharsetMatrix

	; Initialise the random generator values
	lda #23
	sta rand_low
	lda #35
	sta rand_high		

	;
	; Reconfigurate life character 91 92 93 94
.(
	ldx #8*4
loop
	lda _SpriteMario_Life-1,x
	sta $9800+91*8-1,x
	dex
	bne loop
.)

	; Clear the zero page addresses
	lda #0
ZpClear
.(
	ldx #_zp_end_-_zp_start_
loop
	sta _zp_start_-1,x
	dex
	bne loop
.)

	; Clear the BSS section
BssClear
.(
	tay

	ldx #<_BssStart_
	stx ptr_dst+0
	ldx #>_BssStart_
	stx ptr_dst+1

	ldx #5	;// 5*256
loop_outer
	tay
loop_inner
	sta (ptr_dst),y
	dey
	bne loop_inner
	inc ptr_dst+1
	dex
	bne loop_outer

    ; Generate the scanline table
    lda #<$a000
    sta _gScanlineTableLow
    lda #>$a000
    sta _gScanlineTableHigh

    ldx #1
loop_hires
    clc
    lda _gScanlineTableLow-1,x
    adc #40
    sta _gScanlineTableLow,x

    lda _gScanlineTableHigh-1,x
    adc #0
    sta _gScanlineTableHigh,x

    inx 
    cpx #200
    bne loop_hires  

    ; Point to the "hires buffer"
    lda #<_BottomGraphics
    sta _gScanlineTableLow,x
    lda #>_BottomGraphics
    sta _gScanlineTableHigh,x
    inx

loop_text
    clc
    lda _gScanlineTableLow-1,x
    adc #40
    sta _gScanlineTableLow,x

    lda _gScanlineTableHigh-1,x
    adc #0
    sta _gScanlineTableHigh,x

    inx 
    cpx #224
    bne loop_text


	;
	; Set some game parameters
	;
    lda #0
	sta flag_mario_end
	sta _GameCurrentTick
	sta CraneStatus
	sta CranePosition
	sta HookPosition

	lda #__FirstMario-__FirstSprite 
	sta hero_position

	lda #3
	sta live_counter

	lda #4
	sta FixationCount


	;
	; Display background graphics
	;
	;jsr _DisplayBackground
.)


;#define ATTRIBUTE_TEXT    24
;#define ATTRIBUTE_HIRES   28

    ;lda ATTRIBUTE_HIRES
    ;sta $bfdf


#if 0
panic    
    lda #16+1
    sta $bb80+40*27
    lda #16+3
    sta $bb80+40*27
    jmp panic
    rts
#endif

	;
	; Stay into the game loop while the hero still has some live to spare
	;
game_loop
	jsr ScoreDisplay


.(
	;
	; Display the remaining lives of the hero
	;
	lda live_counter
	asl
	asl
	tax

	ldy #9+2+2

	lda #3
	sta b_tmp1
loop_draw_lives
	lda LifeDisplayTable,x
	inx
	sta $bb80+40*26+0,y
	lda LifeDisplayTable,x
	inx
	sta $bb80+40*27+0,y
	lda LifeDisplayTable,x
	inx
	sta $bb80+40*26+1,y
	lda LifeDisplayTable,x
	inx
	sta $bb80+40*27+1,y
	dey
	dey
	dec b_tmp1
	bne loop_draw_lives
.)

#ifdef GAME_MODE
	jsr MoveHero

	;
	; Move items
	;
	lda _GameCurrentTick
	bne end_update_items

		lda _GameDelayTick
		sta _GameCurrentTick

		; Call the "click" routine
        jsr Bleep

		jsr HandlePlateforms
		jsr MoveBarels
		jsr MoveKong

end_update_items
	dec _GameCurrentTick

	jsr MoveGirders
	jsr HandleCrane
#endif
	jsr RefreshAllSprites

#ifdef GAME_MODE
	jsr HandleCollisions
#endif    

	ldx flag_mario_end
	bne MarioEndSequence
	jmp game_loop



; ======================
; When mario die, we need to:
; - make it blink few times
; - decrement the life counter
; - if life counter is null full death, reset all
; - if life counter is not null, partial death, erase the first barrels
; ======================
MarioEndSequence
	;// Reset lots of things death flag
	lda #0
	sta flag_mario_end
	sta _GameCurrentTick
	sta CraneStatus
	sta CranePosition
	sta HookPosition
	sta last_key_press


	; 0=playing 
	; 1=mario collide
	; 2=mario falled 
	; 3=mario win
	cpx #1
	beq MarioCollideSequence 
	cpx #2
	beq MarioFallSequence 
	jmp MarioWinSequence 


MarioCollideSequence
	lda #8
	sta death_counter
	jsr Bloop

blink_loop
	jsr BlinkTemporisation_128
	ldx hero_position
	lda _SpriteRequestedState,x
	eor #1
	sta _SpriteRequestedState,x
	jsr RefreshAllSprites
    jsr Bleep

	dec death_counter
	bne blink_loop

	dec live_counter
	bmi FullDeath

; Normal death
; Reposition mario at the beginning
RestartHero
	lda #__FirstMario-__FirstSprite 
	sta hero_position

	; Erase the first barrels
	ldx #0
	ldy #3
	jsr SpriteErase

	jmp game_loop

; Full death, start again
FullDeath
	;jmp _main
    rts             ; Back to Encounter
	



; We need to make it fall
; Then blink
; Then check for life
; Ok, remove some lives
MarioFallSequence
	jsr BlinkTemporisation_128
	ldx hero_position
	lda #0
	sta _SpriteRequestedState,x
	lda #1
	ldx #__MarioJump-__FirstSprite+2
	stx hero_position
	sta _SpriteRequestedState,x

	jmp MarioCollideSequence
	



; Ok, mario managed to grip the hook !
; We award mario some points for the operation
MarioWinSequence 
.(
	; Move mario and the crate to the upper level
	jsr BlinkTemporisation_128

	; Erase all crane graphics
	ldx #__FirstCrane-__FirstSprite
	ldy #__LastCrane-__FirstCrane
	jsr SpriteErase

	; Erase previous mario position
	lda #0
	sta _SpriteRequestedState+__MarioJump-__FirstSprite

	; Draw upper crane with hook and mario
	lda #1
	sta _SpriteRequestedState+__FirstCrane-__FirstSprite+2
	sta _SpriteRequestedState+__FirstVictoryPose-__FirstSprite+0
	sta _SpriteRequestedState+__FirstVictoryPose-__FirstSprite+1

	; Remove one of the hooks And redraw them
	dec FixationCount
	jsr HandlePlateforms

	jsr RefreshAllSprites

	; Increment score
	ldx #20
	jsr ScoreIncrementMulti

	; Check if it was the last platform
	lda FixationCount
	bne not_last_platform
	
last_platform
	; Special case of where there are no more platform under kong
	; We need to make them blink, and only after fall down
	lda #4
	sta death_counter

platform_blink
	ldx #__FirstPlatform-__FirstSprite
	ldy #3
loop
	lda _SpriteRequestedState,x
	eor #1
	sta _SpriteRequestedState,x
	inx
	dey
	bne loop

	jsr RefreshAllSprites
    jsr Bleep
	jsr BlinkTemporisation_128

	dec	death_counter
	bne platform_blink 

	; Erase the old kong
	ldx #__FirstKong-__FirstSprite
	ldy #__LastKong-__FirstKong
	jsr SpriteErase

	lda #0
	sta _SpriteRequestedState+__FirstPlatform-__FirstSprite+0
	sta _SpriteRequestedState+__FirstPlatform-__FirstSprite+1
	sta _SpriteRequestedState+__FirstPlatform-__FirstSprite+2

	; Display the falled down platforms as well as kong
	lda #1
	sta _SpriteRequestedState+__FirstPlatformFalling-__FirstSprite+0
	sta _SpriteRequestedState+__FirstPlatformFalling-__FirstSprite+1
	sta _SpriteRequestedState+__FirstPlatformFalling-__FirstSprite+2
	sta _SpriteRequestedState+__FirstKongFalling-__FirstSprite

	jsr RefreshAllSprites

	; Another 20 points bonus
	ldx #20
	jsr ScoreIncrementMulti

	; Small hearts! Because I am worth it
	lda #20
	sta death_counter

hearts_blink
	dec	death_counter
	lda death_counter
	and #1
	sta _SpriteRequestedState+__FirstHeart-__FirstSprite+0
	lda death_counter
	lsr
	and #1
	sta _SpriteRequestedState+__FirstHeart-__FirstSprite+1

	jsr RefreshAllSprites
    jsr Bleep

	ldx #64
	jsr BlinkTemporisation

	lda death_counter
	bne hearts_blink 

not_last_platform


	;
	; Move down to intermediate level
	;

	; Erase previous victory graphics
	lda #0
	sta _SpriteRequestedState+__FirstCrane-__FirstSprite+2
	sta _SpriteRequestedState+__FirstVictoryPose-__FirstSprite+0
	sta _SpriteRequestedState+__FirstVictoryPose-__FirstSprite+1

	; Draw upper crane with hook and mario
	lda #1
	sta _SpriteRequestedState+__FirstCrane-__FirstSprite+1
	sta _SpriteRequestedState+__FirstCraneHook-__FirstSprite+4
	sta _SpriteRequestedState+__MarioJump-__FirstSprite

	jsr RefreshAllSprites

			jsr BlinkTemporisation_128

	;
	; Move down to lower level
	;


	; Erase previous victory graphics
	lda #0
	sta _SpriteRequestedState+__FirstCrane-__FirstSprite+1
	sta _SpriteRequestedState+__FirstCraneHook-__FirstSprite+4
	sta _SpriteRequestedState+__MarioJump-__FirstSprite

	; Draw upper crane with hook and mario
	lda #1
	sta _SpriteRequestedState+__FirstCrane-__FirstSprite+0
	sta _SpriteRequestedState+__FirstVictoryPose-__FirstSprite+2
	sta _SpriteRequestedState+__FirstVictoryPose-__FirstSprite+3

	jsr RefreshAllSprites

			jsr BlinkTemporisation_128

	lda FixationCount
	bne skip
	lda #4
	sta FixationCount
skip

.)
	jmp RestartHero



BlinkTemporisation_128
	ldx #128
;// Call with X containing the delay
BlinkTemporisation
.(
outer_loop
	ldy #0
inner_loop
	nop
	dey
	bne inner_loop
	dex
	bne outer_loop
	rts
.)





HandleCollisions
.(
	ldy hero_position 
check_girder_with_jump1
	cpy #__FirstMarioJump-__FirstSprite+2
	bne check_girder_with_jump2
	lda _SpriteRequestedState+__FirstGirder-__FirstSprite+3
	bne MarioDeadSequence

check_girder_with_jump2
	cpy #__FirstMarioJump-__FirstSprite+3
	bne check_girder_with_lader
	lda _SpriteRequestedState+__FirstGirder-__FirstSprite+2
	bne MarioDeadSequence

check_girder_with_lader
	cpy #__MarioLader_2-__FirstSprite
	bne check_jump_on_hook
	lda _SpriteRequestedState+__FirstGirder-__FirstSprite+0
	bne MarioDeadSequence

check_jump_on_hook
	cpy #__MarioJump-__FirstSprite
	bne check_end

	; 2=mario falling
	; 3=mario wining by getting the hook
	ldx #2	
	lda _SpriteRequestedState+__FirstCraneHook-__FirstSprite+4
	beq mario_failure
	inx
mario_failure
	stx flag_mario_end

check_end
	rts

MarioDeadSequence
	lda #1
	sta flag_mario_end
	rts
.)



; Calculate some RANDOM values
; Not accurate at all, but who cares ?
; For what I need it's enough.
_GetRand
	lda rand_high
	sta b_tmp1
	lda rand_low
	asl 
	rol b_tmp1
	asl 
	rol b_tmp1
	asl
	rol b_tmp1
	asl
	rol b_tmp1
	clc
	adc rand_low
	pha
	lda b_tmp1
	adc rand_high
	sta rand_high
	pla
	adc #$11
	sta rand_low
	lda rand_high
	adc #$36
	sta rand_high
	rts



; Give the value to add in X
ScoreIncrementMulti
.(
	stx death_counter
	jsr Bloop
score_loop
	jsr ScoreIncrement
	jsr ScoreDisplay
    jsr Bleep

	ldx #32
	jsr BlinkTemporisation
	dec death_counter
	bne score_loop
	rts
.)


ScoreIncrement
.(
	pha

	php
	sei
	sed
	clc
	lda current_score+1
	adc #1
	sta current_score+1
	lda current_score+0
	adc #0
	sta current_score+0

	; Sounddemon proposes a 16 bits subtraction
	; aeb156 code
    lda     current_score+0
    cmp     best_score+0
    beq     _checktens
    bcs     _newhigh
    bcc     _nonewhigh
_checktens
    lda     current_score+1
    cmp     best_score+1
    bcc     _nonewhigh
_newhigh
    lda     current_score+0
    sta     best_score+0
    lda     current_score+1
    sta     best_score+1
_nonewhigh

skip_update_best
	plp

	pla
	rts
.)




ScoreDisplay
	;//jmp ScoreDisplay
.(
	;
	; Push two bytes on the stack to avoid using index registers later in the loop.
	;
	lda best_score+0
	pha
	lda best_score+1
	pha
	lda #38
	pha


	lda current_score+0
	pha
	lda current_score+1
	pha
	lda #27
	pha

	; two scores to display
	lda #2
	lda #2
	sta b_tmp1
loop_scores
	lda #2
	sta b_tmp2
	pla
	tay
loop_show_digit
	pla
	pha	
	and #15
	tax
	lda HexDigits,x
	sta $bb80+40*26,y
	sta $bb80+40*27,y
	dey

	pla
	lsr
	lsr
	lsr
	lsr
	tax
	lda HexDigits,x
	sta $bb80+40*26,y
	sta $bb80+40*27,y
	dey
	dec b_tmp2
	bne loop_show_digit

	dec b_tmp1
	bne loop_scores

	rts
.)





; Call with 
;   x first sprite to erase
;   y number of sprites to erase
SpriteErase
.(
	lda #0
loop
	sta _SpriteRequestedState,x
	inx
	dey
	bne loop
	rts
.)





HandleCrane
.(
	;
	; Update things depending of tic
	; Move the crane and hooks accordingly
	;
	lda CraneStatus
	beq end_crane_movement

	dec	_GameCraneCurrentTick
	bne end_crane_movement
	
	lda _GameCraneDelayTick
	sta _GameCraneCurrentTick

	; 0=down
	; 1=mid (need hooks)
	ldx CranePosition
	bne not_down 
down
	inc CranePosition
	jmp end_crane_movement

not_down
	dex
	bne end_mid

mid
	ldx HookPosition
	cpx #4
	beq end_mid
	inc HookPosition
	jmp end_crane_movement

end_mid
	lda #0
	sta CranePosition
	sta CraneStatus
	sta HookPosition

end_crane_movement

	;
	; Display the crane control handle
	;
	lda CraneStatus
	ldx #1
	sta _SpriteRequestedState+__FirstCraneStick-__FirstSprite,x
	dex
	eor #1
	sta _SpriteRequestedState+__FirstCraneStick-__FirstSprite,x

	;
	; Erase all crane graphics
	;
	ldx #__FirstCrane-__FirstSprite
	ldy #__LastCrane-__FirstCrane
	jsr SpriteErase

	;
	; Draw crane depending of flags
	;
	lda #1
	ldx CranePosition
	sta _SpriteRequestedState+__FirstCrane-__FirstSprite,x

	;
	; Draw hooks depending of position
	;
	ldx CranePosition
	cpx #1
	bne end_draw_hooks

	lda #1
	ldx HookPosition
	sta _SpriteRequestedState+__FirstCraneHook-__FirstSprite,x

end_draw_hooks
	rts
.)





MoveHero
.(
	; Erase all previous position
	ldx #__FirstMario-__FirstSprite
	ldy #__LastMario-__FirstMario
	jsr SpriteErase

	ldy	hero_position

	; Check if the hero is jumping
	lda mario_jmp_count
	beq handle_keyboard

;//zlob
;//	jmp zlob

	dec mario_jmp_count
	bne end_keyboard

.(
check_first_jump
	cpy #__FirstMarioJump-__FirstSprite+0
	bne check_second_jump
	ldy #__FirstFloorMario-__FirstSprite+0
	jmp end_keyboard

check_second_jump
	cpy #__FirstMarioJump-__FirstSprite+1
	bne check_third_jump
	ldy #__FirstFloorMario-__FirstSprite+3
	jmp end_keyboard

check_third_jump
	cpy #__FirstMarioJump-__FirstSprite+2
	bne check_fourth_jump
	ldy #__SecondFloorMario-__FirstSprite+1
	jmp end_keyboard

check_fourth_jump
	cpy #__FirstMarioJump-__FirstSprite+3
	bne check_end
	ldy #__SecondFloorMario-__FirstSprite+2
	;jmp end_keyboard

check_end
	jmp end_keyboard
.)



handle_keyboard
	;
	; Handle keyboard
	;  y contains the position of hero during all code, do not alterate
    jsr read_keyboard
	;ldx $208
	cpx #0
	bne key_pressed
	stx last_key_press
	jmp end_keyboard
key_pressed
	cpx	last_key_press
	beq end_keyboard
	stx last_key_press
	jsr HandleKeys

end_keyboard

	;
	; Draw new position
	;
	lda #1
	sta _SpriteRequestedState,y

	;
	; Handle display of mario harm
	;
	lda #0
	sta _SpriteRequestedState+__FirstMarioHand-__FirstSprite+0
	sta _SpriteRequestedState+__FirstMarioHand-__FirstSprite+1

	cpy #__ThirdFloorMario-__FirstSprite
	bne skip_stick

	lda CraneStatus
	ldx #1
	sta _SpriteRequestedState+__FirstMarioHand-__FirstSprite,x
	eor #1
	dex
	sta _SpriteRequestedState+__FirstMarioHand-__FirstSprite,x
skip_stick

	cpy hero_position
	beq no_movement
	sty hero_position
	; Call the "click" routine
	jsr Bloop
no_movement

	rts
.)



HandleKeys
.(
	ldx #0
loop_scan
	lda KeyboardRouter_ScanCode,x
	beq end_of_scan
	cmp last_key_press
	beq execute_key

	inx
	jmp loop_scan

execute_key
	lda KeyboardRouter_AddrLow,x
	sta ptr_dst+0
	lda KeyboardRouter_AddrHigh,x
	sta ptr_dst+1
	jmp (ptr_dst)

end_of_scan
	rts
.)



HeroMoveLeft
.(
	; Third floor

check_third_floor
	cpy #__ThirdFloorMario-__FirstSprite+1
	bcc check_third_floor_crane_control
	cpy #__MarioJump-__FirstSprite
	bcs check_end
	dey
	rts

check_third_floor_crane_control
	cpy #__ThirdFloorMario-__FirstSprite
	bne check_second_floor

	; Activate the crane
	lda #1
	sta	CraneStatus
	rts

	; Second floor check (reversed)
check_second_floor
	cpy #__SecondFloorMario-__FirstSprite
	bcc check_first_floor
	cpy #__MarioLader_2-__FirstSprite-1
	bcs check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((__SecondFloorMario-__FirstSprite)-(__SecondFloorBarel-__FirstSprite))
	tax
	lda _SpriteRequestedState,x
	bne collided
	iny
	rts

	; First floor check
check_first_floor
	cpy #__FirstFloorMario-__FirstSprite+1
	bcc check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((__FirstFloorMario-__FirstSprite)-(__FirstBarel-__FirstSprite))
	tax
	lda _SpriteRequestedState-1,x
	bne collided
	dey
	rts

collided
	lda #1
	sta flag_mario_end
	rts


check_end
	rts
.)



HeroMoveRight
.(
	; Check the jump position
	cpy #__ThirdFloorMario-__FirstSprite+2
	bne check_third_floor

	ldy #__MarioJump-__FirstSprite+1
	; 0=playing 1=mario collide 2=mario falled 3=mario win
	lda #2
	sta flag_mario_end
	rts

	; Third floor
check_third_floor
	cpy #__ThirdFloorMario-__FirstSprite
	bcc check_second_floor
	cpy #__MarioJump-__FirstSprite-1
	bcs check_end
	iny
	rts

	; Second floor check (reversed)
check_second_floor
	cpy #__SecondFloorMario-__FirstSprite+1
	bcc check_first_floor
	cpy #__MarioLader_2-__FirstSprite
	bcs check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((__SecondFloorMario-__FirstSprite)-(__SecondFloorBarel-__FirstSprite))
	tax
	lda _SpriteRequestedState-1,x
	bne collided
	dey
	rts


check_first_floor
	cpy #__SecondFloorMario-__FirstSprite-1
	bcs check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((__FirstFloorMario-__FirstSprite)-(__FirstBarel-__FirstSprite))
	tax
	lda _SpriteRequestedState,x
	bne collided
	iny
	rts

collided
	lda #1
	sta flag_mario_end
	rts

check_end
	rts
.)



HeroMoveDown
.(
check_second_lader
	cpy #__MarioLader_2-__FirstSprite
	bcc check_first_lader
	cpy #__ThirdFloorMario-__FirstSprite+1
	bcs check_end
	dey
	rts

check_first_lader
	cpy #__SecondFloorMario-__FirstSprite
	bne check_end
	dey
	rts

check_end
	rts
.)



HeroMoveUp
.(
check_second_lader
	cpy #__MarioLader_2-__FirstSprite-1
	bcc check_first_lader
	cpy #__ThirdFloorMario-__FirstSprite
	bcs check_end
	iny
	rts

check_first_lader
	cpy #__MarioLader_1-__FirstSprite
	bne check_end
	iny
	rts

check_end
	rts
.)




HeroMoveSpace
.(
check_first_jump
	cpy #__FirstFloorMario-__FirstSprite+0
	bne check_second_jump
	ldy #__FirstMarioJump-__FirstSprite+0
	jmp validate_jump

check_second_jump
	cpy #__FirstFloorMario-__FirstSprite+3
	bne check_third_jump
	ldy #__FirstMarioJump-__FirstSprite+1
	jmp validate_jump

check_third_jump
	cpy #__SecondFloorMario-__FirstSprite+1
	bne check_fourth_jump
	ldy #__FirstMarioJump-__FirstSprite+2
	jmp validate_jump

check_fourth_jump
	cpy #__SecondFloorMario-__FirstSprite+2
	bne check_fifth_jump
	ldy #__FirstMarioJump-__FirstSprite+3
	jmp validate_jump

check_fifth_jump
	cpy #__ThirdFloorMario-__FirstSprite+2
	bne check_end
	ldy #__MarioJump-__FirstSprite
	jmp validate_jump

check_end
	rts

validate_jump
	lda #255
	sta mario_jmp_count
	rts
.)





; Needs a routine that:
; - scrolls a table of "n" values starting at a particular position
; - clear the last one
; - returns the value of the first that goes out of table...

; X=counter
; Y=start position
ScrollLeftTable
	; Memorise the value that will become ejected
	lda _SpriteRequestedState+BAREL_BASE_MAIN,y
	pha
.(
loop
	lda _SpriteRequestedState+BAREL_BASE_MAIN+1,y
	sta _SpriteRequestedState+BAREL_BASE_MAIN,y
	lda #0
	sta _SpriteRequestedState+BAREL_BASE_MAIN+1,y
	iny
	dex
	bne loop

	; Get back the ejected value
	pla
	rts
.)




MoveBarels
.(
	;
	; First, check that we don't collide the hero
	;
.(
	lda #6
	sta b_tmp1
outer_loop
	ldy b_tmp1
	lda TableCollisionCount-1,y
	sta b_tmp2

	ldx TableCollisionSrc-1,y
	lda TableCollisionDst-1,y
	tay
loop
	lda _SpriteRequestedState,x
	beq skip
	lda _SpriteRequestedState,y
	beq skip
collided
	lda #1
	sta flag_mario_end
	rts

skip
	inx
	iny
	dec	b_tmp2
	bne loop

	dec b_tmp1
	bne outer_loop
.)

	;
	; Scroll the first serie
	;
	ldy #0
	ldx #__LastBarel-__FirstBarel-1
	jsr ScrollLeftTable
	beq	skip_increase_score

	jsr ScoreIncrement

skip_increase_score
	;
	; Scroll the three top ones
	;
	ldy #__LastBarel+(3*0)-__FirstSprite
	ldx #2
	jsr ScrollLeftTable
	ora _SpriteRequestedState+__BarelInsertionLeft-__FirstSprite
	sta _SpriteRequestedState+__BarelInsertionLeft-__FirstSprite

	ldy #__LastBarel+(3*1)-__FirstSprite
	ldx #2
	jsr ScrollLeftTable
	ora _SpriteRequestedState+__BarelInsertionMiddle-__FirstSprite
	sta _SpriteRequestedState+__BarelInsertionMiddle-__FirstSprite

	ldy #__LastBarel+(3*2)-__FirstSprite
	ldx #2
	jsr ScrollLeftTable
	ora _SpriteRequestedState+__BarelInsertionRight-__FirstSprite
	sta _SpriteRequestedState+__BarelInsertionRight-__FirstSprite

	rts
.)





HandlePlateforms
.(
	; Start by erasing all the platform data
	ldx #__FirstPlatform-__FirstSprite
	ldy #__LastHook-__FirstPlatform
	jsr SpriteErase

.(
	lda #1
	ldy FixationCount
	beq skip
	; Display hooks
loop
	sta _SpriteRequestedState+__FirstHook-__FirstSprite-1,y
	dey
	bne loop

skip
	
.)

.(
	ldx #__FirstPlatform-__FirstSprite
	lda #1
	ldy #3
loop
	sta _SpriteRequestedState,x
	inx
	dey
	bne loop
skip_platforms
.)

	rts
.)




MoveGirders
.(
	dec _GameGirderTick
	beq update_items
	rts

update_items
	lda _GameGirderDelayTick
	sta _GameGirderTick

	; Move them all by one tick
	ldx #0
	.(
loop
	lda _SpriteRequestedState+GIRDER_BASE_MAIN+1,x
	sta _SpriteRequestedState+GIRDER_BASE_MAIN,x
	inx
	cpx #GIRDER_COUNT_MAIN-1
	bne loop
	.)

	; And clear/set the first one depending of random
	lda #0
	dec _GameGirderSpawnTick
	bpl no_girder_spawn

	jsr _GetRand
	and #7
	sta _GameGirderSpawnTick
	lda #1
no_girder_spawn
	sta _SpriteRequestedState+GIRDER_BASE_MAIN+GIRDER_COUNT_MAIN-1

	rts
.)



MoveKong
.(
	; Start by erasing all the kong data
	ldx #__FirstKong-__FirstSprite
	ldy #__LastKong-__FirstKong
	jsr SpriteErase

.(
	lda _KongFlagThrow
	beq handle_movement

	; Throw a barrel
	lda #0
	sta _KongFlagThrow

	lda #1
	ldx #__BarelStartLeft-__FirstSprite
	ldy _KongPosition
	beq throw_it
	ldx #__BarelStartMiddle-__FirstSprite
	dey
	beq throw_it
	ldx #__BarelStartRight-__FirstSprite
throw_it
	sta _SpriteRequestedState,x
	jmp end


handle_movement
	; And now move kong
	jsr _GetRand
	ldx _KongPosition
	lda rand_low
	cmp #40
	bcc throw_barel
	cmp #140
	bcc left
	cmp #220
	bcs end

right
	cpx #2
	beq end
	inc _KongPosition
	bcc end

throw_barel
	lda #1
	sta _KongFlagThrow
	bcc end

left
	cpx #0
	beq end
	dec _KongPosition

end
.)
	

.(
	lda #0
	ldx _KongPosition
	beq draw_left
	dex
	beq draw_midle
draw_right
	clc
	adc #4
draw_midle
	clc
	adc #4
draw_left
	tax

	inx 
	ldy #3
	lda _KongFlagThrow
	beq skip_throw
	dey
	dex
skip_throw
	sty b_tmp1

	lda #1
loop_draw
	sta _SpriteRequestedState+__FirstKong-__FirstSprite,x
	inx
	dec b_tmp1
	bne loop_draw
.)

	rts
.)



RefreshAllSprites
.(
	ldx #0
loop
	lda _SpriteRequestedState,x
	cmp _SpriteDisplayState,x
	beq skip_sprite

	;
	; Change sprite status
	;
	sta _SpriteDisplayState,x

	stx tmp_save_sprite

	; X=Sprite number to display
	jsr _DisplaySingleSprite

	ldx tmp_save_sprite
skip_sprite
	inx
	cpx #95
	bne loop
.)
    jsr _RefineCharacters
	rts


; Note: In all display routines "tmp0" points on the screen
_DisplaySingleSprite
	; Screen adress
	lda _KongSpriteScreenX,x
	sta zp_x
	lda _KongSpriteScreenY,x
	sta zp_y

	; Sprite data address
	lda _KongSpriteAdd_Low,x
	sta ptr_src+0
	lda _KongSpriteAdd_High,x
	sta ptr_src+1

	; Sprite width and height
	lda _KongSpriteWidth,x
	sta tmp_width

	lda _KongSpriteHeight,x
	sta tmp_height

loop_y
    ldy zp_y    
    inc zp_y
    clc 
    lda _gScanlineTableLow,y
    adc zp_x
    sta ptr_dst+0
    lda _gScanlineTableHigh,y
    adc #0
    sta ptr_dst+1


    ldy #0
loop_x
	lda (ptr_src),y
	;//beq skip_empty

	eor (ptr_dst),y
	;ora #64               ; ----------- test
	sta (ptr_dst),y
skip_empty
	
	iny
    cpy tmp_width
	bne loop_x

    clc
    lda ptr_src+0
    adc tmp_width
    sta ptr_src+0

    lda ptr_src+1
    adc #0
    sta ptr_src+1

	dec tmp_height
	bne loop_y

	rts



_RefineCharacters
.(
    pha
    txa
    pha
    tya
    pha

	// First 16 scanlines in STD charset
    sec
	ldx #9
	ldy #9*16
loop_column_std
    ; Columns 0-9 
	lda _BottomGraphics+40*0,x
	sta $9800+32*8+0,y

	lda _BottomGraphics+40*1,x
	sta $9800+32*8+1,y

	lda _BottomGraphics+40*2,x
	sta $9800+32*8+2,y

	lda _BottomGraphics+40*3,x
	sta $9800+32*8+3,y

	lda _BottomGraphics+40*4,x
	sta $9800+32*8+4,y

	lda _BottomGraphics+40*5,x
	sta $9800+32*8+5,y

	lda _BottomGraphics+40*6,x
	sta $9800+32*8+6,y

	lda _BottomGraphics+40*7,x
	sta $9800+32*8+7,y

	lda _BottomGraphics+40*8,x
	sta $9800+32*8+8,y

	lda _BottomGraphics+40*9,x
	sta $9800+32*8+9,y

	lda _BottomGraphics+40*10,x
	sta $9800+32*8+10,y

	lda _BottomGraphics+40*11,x
	sta $9800+32*8+11,y

	lda _BottomGraphics+40*12,x
	sta $9800+32*8+12,y

	lda _BottomGraphics+40*13,x
	sta $9800+32*8+13,y

	lda _BottomGraphics+40*14,x
	sta $9800+32*8+14,y

	lda _BottomGraphics+40*15,x
	sta $9800+32*8+15,y

    ; Columns 10-19 
	lda _BottomGraphics+40*0+10,x
	sta $9800+32*8+0+16*10,y

	lda _BottomGraphics+40*1+10,x
	sta $9800+32*8+1+16*10,y

	lda _BottomGraphics+40*2+10,x
	sta $9800+32*8+2+16*10,y

	lda _BottomGraphics+40*3+10,x
	sta $9800+32*8+3+16*10,y

	lda _BottomGraphics+40*4+10,x
	sta $9800+32*8+4+16*10,y

	lda _BottomGraphics+40*5+10,x
	sta $9800+32*8+5+16*10,y

	lda _BottomGraphics+40*6+10,x
	sta $9800+32*8+6+16*10,y

	lda _BottomGraphics+40*7+10,x
	sta $9800+32*8+7+16*10,y

	lda _BottomGraphics+40*8+10,x
	sta $9800+32*8+8+16*10,y

	lda _BottomGraphics+40*9+10,x
	sta $9800+32*8+9+16*10,y

	lda _BottomGraphics+40*10+10,x
	sta $9800+32*8+10+16*10,y

	lda _BottomGraphics+40*11+10,x
	sta $9800+32*8+11+16*10,y

	lda _BottomGraphics+40*12+10,x
	sta $9800+32*8+12+16*10,y

	lda _BottomGraphics+40*13+10,x
	sta $9800+32*8+13+16*10,y

	lda _BottomGraphics+40*14+10,x
	sta $9800+32*8+14+16*10,y

	lda _BottomGraphics+40*15+10,x
	sta $9800+32*8+15+16*10,y

    ; Columns 20-29 
	lda _BottomGraphics+40*0+20,x
	sta $9800+32*8+0+16*20,y

	lda _BottomGraphics+40*1+20,x
	sta $9800+32*8+1+16*20,y

	lda _BottomGraphics+40*2+20,x
	sta $9800+32*8+2+16*20,y

	lda _BottomGraphics+40*3+20,x
	sta $9800+32*8+3+16*20,y

	lda _BottomGraphics+40*4+20,x
	sta $9800+32*8+4+16*20,y

	lda _BottomGraphics+40*5+20,x
	sta $9800+32*8+5+16*20,y

	lda _BottomGraphics+40*6+20,x
	sta $9800+32*8+6+16*20,y

	lda _BottomGraphics+40*7+20,x
	sta $9800+32*8+7+16*20,y

	lda _BottomGraphics+40*8+20,x
	sta $9800+32*8+8+16*20,y

	lda _BottomGraphics+40*9+20,x
	sta $9800+32*8+9+16*20,y

	lda _BottomGraphics+40*10+20,x
	sta $9800+32*8+10+16*20,y

	lda _BottomGraphics+40*11+20,x
	sta $9800+32*8+11+16*20,y

	lda _BottomGraphics+40*12+20,x
	sta $9800+32*8+12+16*20,y

	lda _BottomGraphics+40*13+20,x
	sta $9800+32*8+13+16*20,y

	lda _BottomGraphics+40*14+20,x
	sta $9800+32*8+14+16*20,y

	lda _BottomGraphics+40*15+20,x
	sta $9800+32*8+15+16*20,y
    
    ; Columns 30-39 
	lda _BottomGraphics+40*0+30,x
	sta $9800+32*8+0+16*30,y

	lda _BottomGraphics+40*1+30,x
	sta $9800+32*8+1+16*30,y

	lda _BottomGraphics+40*2+30,x
	sta $9800+32*8+2+16*30,y

	lda _BottomGraphics+40*3+30,x
	sta $9800+32*8+3+16*30,y

	lda _BottomGraphics+40*4+30,x
	sta $9800+32*8+4+16*30,y

	lda _BottomGraphics+40*5+30,x
	sta $9800+32*8+5+16*30,y

	lda _BottomGraphics+40*6+30,x
	sta $9800+32*8+6+16*30,y

	lda _BottomGraphics+40*7+30,x
	sta $9800+32*8+7+16*30,y

	lda _BottomGraphics+40*8+30,x
	sta $9800+32*8+8+16*30,y

	lda _BottomGraphics+40*9+30,x
	sta $9800+32*8+9+16*30,y

	lda _BottomGraphics+40*10+30,x
	sta $9800+32*8+10+16*30,y

	lda _BottomGraphics+40*11+30,x
	sta $9800+32*8+11+16*30,y

	lda _BottomGraphics+40*12+30,x
	sta $9800+32*8+12+16*30,y

	lda _BottomGraphics+40*13+30,x
	sta $9800+32*8+13+16*30,y

	lda _BottomGraphics+40*14+30,x
	sta $9800+32*8+14+16*30,y

	lda _BottomGraphics+40*15+30,x
	sta $9800+32*8+15+16*30,y

    tya
    sbc #16
    tay

	dex
    bmi end_std
	jmp loop_column_std
end_std

    // Last 8 scanlines in ALT charset
    sec
	ldx #19
	ldy #19*8
loop_column_alt
    ; Left Half
	lda _BottomGraphics+40*16,x
	sta $9c00+32*8+0,y

	lda _BottomGraphics+40*17,x
	sta $9c00+32*8+1,y

	lda _BottomGraphics+40*18,x
	sta $9c00+32*8+2,y

	lda _BottomGraphics+40*19,x
	sta $9c00+32*8+3,y

	lda _BottomGraphics+40*20,x
	sta $9c00+32*8+4,y

	lda _BottomGraphics+40*21,x
	sta $9c00+32*8+5,y

	lda _BottomGraphics+40*22,x
	sta $9c00+32*8+6,y

	lda _BottomGraphics+40*23,x
	sta $9c00+32*8+7,y

    ; Right Half
	lda _BottomGraphics+40*16+20,x
	sta $9c00+32*8+0+20*8,y

	lda _BottomGraphics+40*17+20,x
	sta $9c00+32*8+1+20*8,y

	lda _BottomGraphics+40*18+20,x
	sta $9c00+32*8+2+20*8,y

	lda _BottomGraphics+40*19+20,x
	sta $9c00+32*8+3+20*8,y

	lda _BottomGraphics+40*20+20,x
	sta $9c00+32*8+4+20*8,y

	lda _BottomGraphics+40*21+20,x
	sta $9c00+32*8+5+20*8,y

	lda _BottomGraphics+40*22+20,x
	sta $9c00+32*8+6+20*8,y

	lda _BottomGraphics+40*23+20,x
	sta $9c00+32*8+7+20*8,y


    tya
    sbc #8
    tay

	dex
	bpl loop_column_alt

    pla
    tay
    pla
    tax
    pla

    rts
.)


_DisplayCharsetMatrix
.(
    ; Fix redefined graphics in the lower border
    ldy #32
    ldx #0
loop_1
    tya
    sta $bb80+40*25,x
    iny
    tya
    sta $bb80+40*26,x
    iny
    inx
    cpx #40
    bne loop_1

    ldx #32
loop_2
    txa
    sta $bb80+40*27-32,x
    inx
    cpx #40+32
    bne loop_2

    lda #9+128
    sta $bb80+40*27       ; Alternate charset
    rts
.)


Bleep
.(
    ldX #<_GameTickData
    ldy #>_GameTickData
    jmp play_sound
.)

Bloop
.(
    ldX #<_JumpData
    ldy #>_JumpData
    jmp play_sound
.)


_GameTickData
    SOUND_SET_VALUE2(REG_A_FREQ,50)
    SOUND_SET_VALUE(REG_A_VOLUME,13)               ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11111110)           ; Enable Tone on channel A
    SOUND_WAIT(1)                                  ; Wait a couple frames
    SOUND_SET_VALUE_END(REG_A_VOLUME,0)            ; Cut the volume

_JumpData
    SOUND_SET_VALUE2(REG_A_FREQ,40)
    SOUND_SET_VALUE(REG_A_VOLUME,13)               ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11111110)           ; Enable Tone on channel A
    SOUND_WAIT(1)                                  ; Wait a couple frames
    SOUND_SET_VALUE_END(REG_A_VOLUME,0)            ; Cut the volume


#ifdef GAME_MODE
_SpriteRequestedState	.dsb 96		; 0=not displayed 1=displayed
#else
_SpriteRequestedState	// Force all the sprites to be on
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
#endif


#include "monkey_king_spr.s"
#include "monkey_king_vars.s"

