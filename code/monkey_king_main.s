
#include "params.h"


;
; Game sprites defines
;
#define SPRITE_COUNT        _LastSprite-_FirstSprite
#define BARREL_BASE_MAIN	0
#define BARREL_COUNT_MAIN	17

#define GIRDER_BASE_MAIN	FirstGirder-_FirstSprite
#define GIRDER_COUNT_MAIN	5

#define BREAKPOINT  jmp *

#define GAME_MODE    // Comment out to test

	.zero

	*= $1

_zp_start_

ptr_src         .dsb 2
ptr_dst         .dsb 2

current_score	.dsb 2

rand_low		.dsb 1		; Random number generator, low part
rand_high		.dsb 1		; Random number generator, high part

tmp_save_sprite	.dsb 1
tmp_width		.dsb 1
tmp_height		.dsb 1

b_tmp1			.dsb 1
b_tmp2			.dsb 1

live_counter	.dsb 1		; Number of lives remaining
flag_mario_end	.dsb 1		; 0=playing 1=mario collide 2=mario fell 3=mario win
mario_jmp_count	.dsb 1
death_counter	.dsb 1
hero_position	.dsb 1
last_key_press	.dsb 1

zp_x            .dsb 1
zp_y            .dsb 1

CraneStatus		.dsb 1	    ; 01	(OFF or ON)
CranePosition	.dsb 1	    ; 012
HookPosition	.dsb 1	    ; 01234
_KongPosition	.dsb 1		; 0 1 2 (3 when crashed ???)

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
    jsr _ClearMemory
    jsr _GenerateScanlineTable
    jsr _GameInits

#ifndef GAME_MODE
    jsr ScoreDisplay
    jsr _DisplayLives
    jsr RefreshAllSprites
    sei
    ;BREAKPOINT
    jsr _RefineCharacters
    BREAKPOINT
    cli

    ; Erase all the sprites
	ldx #0
	ldy #_LastSprite-_FirstSprite
	jsr SpriteErase
    jsr RefreshAllSprites
    jsr _RefineCharacters

#endif

	;
	; Stay into the game loop while the hero still has some live to spare
	;
game_loop
	jsr ScoreDisplay
    jsr _DisplayLives

	jsr MoveHero

	; Move items
	lda _GameCurrentTick
	bne end_update_items

		lda _GameDelayTick
		sta _GameCurrentTick

		; Call the "click" routine
        jsr Bleep

		jsr HandlePlatforms
		jsr MoveBarrels
		jsr MoveKong
end_update_items
	dec _GameCurrentTick

	jsr MoveGirders
	jsr HandleCrane
	jsr RefreshAllSprites

	jsr HandleCollisions

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
	; 2=mario fell
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
	jsr BlinkTemporization_128
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
	lda #FirstMario-_FirstSprite 
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
	jsr BlinkTemporization_128
	ldx hero_position
	lda #0
	sta _SpriteRequestedState,x
	lda #1
	ldx #MarioJump-_FirstSprite+2
	stx hero_position
	sta _SpriteRequestedState,x

	jmp MarioCollideSequence
	



; Ok, mario managed to grip the hook !
; We award mario some points for the operation
MarioWinSequence 
.(
	; Move mario and the crate to the upper level
	jsr BlinkTemporization_128

	; Erase all crane graphics
	ldx #FirstCrane-_FirstSprite
	ldy #LastCrane-FirstCrane
	jsr SpriteErase

	; Erase previous mario position
	lda #0
	sta _SpriteRequestedState+MarioJump-_FirstSprite

	; Draw upper crane with hook and mario
	lda #1
	sta _SpriteRequestedState+FirstCrane-_FirstSprite+2

	; Remove one of the hooks And redraw them
	dec FixationCount
	jsr HandlePlatforms

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
	ldx #FirstPlatform-_FirstSprite
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
	jsr BlinkTemporization_128

	dec	death_counter
	bne platform_blink 

	; Erase the old kong
	ldx #FirstKong-_FirstSprite
	ldy #LastKong-FirstKong
	jsr SpriteErase

	lda #0
	sta _SpriteRequestedState+FirstPlatform-_FirstSprite+0
	sta _SpriteRequestedState+FirstPlatform-_FirstSprite+1
	sta _SpriteRequestedState+FirstPlatform-_FirstSprite+2

	; Display the fallen down platforms as well as kong
	lda #1
	sta _SpriteRequestedState+FirstPlatformFalling-_FirstSprite+0
	sta _SpriteRequestedState+FirstPlatformFalling-_FirstSprite+1
	sta _SpriteRequestedState+FirstPlatformFalling-_FirstSprite+2
	sta _SpriteRequestedState+FirstKongFalling-_FirstSprite

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
	sta _SpriteRequestedState+FirstHeart-_FirstSprite+0
	lda death_counter
	lsr
	and #1
	sta _SpriteRequestedState+FirstHeart-_FirstSprite+1

	jsr RefreshAllSprites
    jsr Bleep

	ldx #64
	jsr BlinkTemporization

	lda death_counter
	bne hearts_blink 

not_last_platform

	;
	; Move down to intermediate level
	;

	; Erase previous victory graphics
	lda #0
	sta _SpriteRequestedState+FirstCrane-_FirstSprite+2
	sta _SpriteRequestedState+FirstVictoryPose-_FirstSprite+0
	sta _SpriteRequestedState+FirstVictoryPose-_FirstSprite+1

	; Draw upper crane with hook and mario
	lda #1
	sta _SpriteRequestedState+FirstCrane-_FirstSprite+1
	sta _SpriteRequestedState+FirstCraneHook-_FirstSprite+4
	sta _SpriteRequestedState+MarioJump-_FirstSprite

	jsr RefreshAllSprites

	jsr BlinkTemporization_128

	;
	; Move down to lower level
	;

	; Erase previous victory graphics
	lda #0
	sta _SpriteRequestedState+FirstCrane-_FirstSprite+1
	sta _SpriteRequestedState+FirstCraneHook-_FirstSprite+4
	sta _SpriteRequestedState+MarioJump-_FirstSprite

	; Draw lower crane with hook and mario
	lda #1
	sta _SpriteRequestedState+FirstCrane-_FirstSprite+0
	sta _SpriteRequestedState+FirstVictoryPose-_FirstSprite+2
	sta _SpriteRequestedState+FirstVictoryPose-_FirstSprite+3

	jsr RefreshAllSprites

	jsr BlinkTemporization_128

	lda FixationCount
	bne skip
	lda #4
	sta FixationCount
skip

.)
	jmp RestartHero



BlinkTemporization_128
	ldx #128
; Call with X containing the delay
BlinkTemporization
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
	cpy #FirstMarioJump-_FirstSprite+2
	bne check_girder_with_jump2
	lda _SpriteRequestedState+FirstGirder-_FirstSprite+3
	bne MarioDeadSequence

check_girder_with_jump2
	cpy #FirstMarioJump-_FirstSprite+3
	bne check_girder_with_lader
	lda _SpriteRequestedState+FirstGirder-_FirstSprite+2
	bne MarioDeadSequence

check_girder_with_lader
	cpy #MarioLader_2-_FirstSprite
	bne check_jump_on_hook
	lda _SpriteRequestedState+FirstGirder-_FirstSprite+0
	bne MarioDeadSequence

check_jump_on_hook
	cpy #MarioJump-_FirstSprite
	bne check_end

	; 2=mario falling
	; 3=mario wining by getting the hook
	ldx #2	
	lda _SpriteRequestedState+FirstCraneHook-_FirstSprite+4
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
    jsr _RefineCharacters

	ldx #32
	jsr BlinkTemporization
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
    ldx #0

	lda current_score+0
	lsr
	lsr
	lsr
	lsr
    jsr PrintScoreDigit

	lda current_score+0
    and #15
    jsr PrintScoreDigit

	lda current_score+1
	lsr
	lsr
	lsr
	lsr
    jsr PrintScoreDigit

	lda current_score+1
    and #15
    ; Fall-through
PrintScoreDigit
    sta b_tmp1
    asl           ; x2
    asl           ; x4
    clc
    adc b_tmp1    ; x5

    clc
    adc #<SevenDigitPatterns
    sta ptr_src+0
    lda #0
    adc #>SevenDigitPatterns
    sta ptr_src+1

    ldy #0
    lda (ptr_src),y
    sta _BottomGraphics+36+40*14,x

    iny
    lda (ptr_src),y
    sta _BottomGraphics+36+40*15,x
    sta _BottomGraphics+36+40*16,x
    sta _BottomGraphics+36+40*17,x

    iny
    lda (ptr_src),y
    sta _BottomGraphics+36+40*18,x

    iny
    lda (ptr_src),y
    sta _BottomGraphics+36+40*19,x
    sta _BottomGraphics+36+40*20,x
    sta _BottomGraphics+36+40*21,x

    iny
    lda (ptr_src),y
    sta _BottomGraphics+36+40*22,x

    inx
    rts






; Call with 
;   x first sprite to erase
;   y number of sprites to erase
SpriteDraw
.(
    lda #1
    jmp loop
+SpriteErase
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

	; Display the crane control handle
	lda CraneStatus
	ldx #1
	sta _SpriteRequestedState+FirstCraneStick-_FirstSprite,x
	dex
	eor #1
	sta _SpriteRequestedState+FirstCraneStick-_FirstSprite,x

	; Erase all crane graphics
	ldx #FirstCrane-_FirstSprite
	ldy #LastCrane-FirstCrane
	jsr SpriteErase

	; Draw crane depending of flags
	lda #1
	ldx CranePosition
	sta _SpriteRequestedState+FirstCrane-_FirstSprite,x

	; Draw hooks depending of position
	ldx CranePosition
	cpx #1
	bne end_draw_hooks

	lda #1
	ldx HookPosition
	sta _SpriteRequestedState+FirstCraneHook-_FirstSprite,x

end_draw_hooks
	rts
.)





MoveHero
.(
	; Erase all previous position
	ldx #FirstMario-_FirstSprite
	ldy #LastMario-FirstMario
	jsr SpriteErase

	ldy	hero_position

	; Check if the hero is jumping
	lda mario_jmp_count
	beq handle_keyboard

	dec mario_jmp_count
	bne end_keyboard

.(
check_first_jump
	cpy #FirstMarioJump-_FirstSprite+0
	bne check_second_jump
	ldy #FirstFloorMario-_FirstSprite+0
	jmp end_keyboard

check_second_jump
	cpy #FirstMarioJump-_FirstSprite+1
	bne check_third_jump
	ldy #FirstFloorMario-_FirstSprite+3
	jmp end_keyboard

check_third_jump
	cpy #FirstMarioJump-_FirstSprite+2
	bne check_fourth_jump
	ldy #SecondFloorMario-_FirstSprite+1
	jmp end_keyboard

check_fourth_jump
	cpy #FirstMarioJump-_FirstSprite+3
	bne check_end
	ldy #SecondFloorMario-_FirstSprite+2
	;jmp end_keyboard

check_end
	jmp end_keyboard
.)



handle_keyboard
	;
	; Handle keyboard
	;  y contains the position of hero during all code, do not alter
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
	sta _SpriteRequestedState+FirstMarioHand-_FirstSprite+0
	sta _SpriteRequestedState+FirstMarioHand-_FirstSprite+1

	cpy #ThirdFloorMario-_FirstSprite
	bne skip_stick

	lda CraneStatus
	ldx #1
	sta _SpriteRequestedState+FirstMarioHand-_FirstSprite,x
	eor #1
	dex
	sta _SpriteRequestedState+FirstMarioHand-_FirstSprite,x
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
	cpy #ThirdFloorMario-_FirstSprite+1
	bcc check_third_floor_crane_control
	cpy #MarioJump-_FirstSprite
	bcs check_end
	dey
	rts

check_third_floor_crane_control
	cpy #ThirdFloorMario-_FirstSprite
	bne check_second_floor

	; Activate the crane
	lda #1
	sta	CraneStatus
	rts

	; Second floor check (reversed)
check_second_floor
	cpy #SecondFloorMario-_FirstSprite
	bcc check_first_floor
	cpy #MarioLader_2-_FirstSprite-1
	bcs check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((SecondFloorMario-_FirstSprite)-(SecondFloorBarrel-_FirstSprite))
	tax
	lda _SpriteRequestedState,x
	bne collided
	iny
	rts

	; First floor check
check_first_floor
	cpy #FirstFloorMario-_FirstSprite+1
	bcc check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((FirstFloorMario-_FirstSprite)-(FirstBarrel-_FirstSprite))
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
	cpy #ThirdFloorMario-_FirstSprite+2
	bne check_third_floor

	ldy #MarioJump-_FirstSprite+1
	; 0=playing 1=mario collide 2=mario fell 3=mario win
	lda #2
	sta flag_mario_end
	rts

	; Third floor
check_third_floor
	cpy #ThirdFloorMario-_FirstSprite
	bcc check_second_floor
	cpy #MarioJump-_FirstSprite-1
	bcs check_end
	iny
	rts

	; Second floor check (reversed)
check_second_floor
	cpy #SecondFloorMario-_FirstSprite+1
	bcc check_first_floor
	cpy #MarioLader_2-_FirstSprite
	bcs check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((SecondFloorMario-_FirstSprite)-(SecondFloorBarrel-_FirstSprite))
	tax
	lda _SpriteRequestedState-1,x
	bne collided
	dey
	rts


check_first_floor
	cpy #SecondFloorMario-_FirstSprite-1
	bcs check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((FirstFloorMario-_FirstSprite)-(FirstBarrel-_FirstSprite))
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
	cpy #MarioLader_2-_FirstSprite
	bcc check_first_lader
	cpy #ThirdFloorMario-_FirstSprite+1
	bcs check_end
	dey
	rts

check_first_lader
	cpy #SecondFloorMario-_FirstSprite
	bne check_end
	dey
	rts

check_end
	rts
.)



HeroMoveUp
.(
check_second_lader
	cpy #MarioLader_2-_FirstSprite-1
	bcc check_first_lader
	cpy #ThirdFloorMario-_FirstSprite
	bcs check_end
	iny
	rts

check_first_lader
	cpy #MarioLader_1-_FirstSprite
	bne check_end
	iny
	rts

check_end
	rts
.)




HeroMoveSpace
.(
check_first_jump
	cpy #FirstFloorMario-_FirstSprite+0
	bne check_second_jump
	ldy #FirstMarioJump-_FirstSprite+0
	jmp validate_jump

check_second_jump
	cpy #FirstFloorMario-_FirstSprite+3
	bne check_third_jump
	ldy #FirstMarioJump-_FirstSprite+1
	jmp validate_jump

check_third_jump
	cpy #SecondFloorMario-_FirstSprite+1
	bne check_fourth_jump
	ldy #FirstMarioJump-_FirstSprite+2
	jmp validate_jump

check_fourth_jump
	cpy #SecondFloorMario-_FirstSprite+2
	bne check_fifth_jump
	ldy #FirstMarioJump-_FirstSprite+3
	jmp validate_jump

check_fifth_jump
	cpy #ThirdFloorMario-_FirstSprite+2
	bne check_end
	ldy #MarioJump-_FirstSprite
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
	; Memorize the value that will become ejected
	lda _SpriteRequestedState+BARREL_BASE_MAIN,y
	pha
.(
loop
	lda _SpriteRequestedState+BARREL_BASE_MAIN+1,y
	sta _SpriteRequestedState+BARREL_BASE_MAIN,y
	lda #0
	sta _SpriteRequestedState+BARREL_BASE_MAIN+1,y
	iny
	dex
	bne loop

	; Get back the ejected value
	pla
	rts
.)




MoveBarrels
.(
	; First, check that we don't collide the hero
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

	; Scroll the first series
	ldy #0
	ldx #LastBarrel-FirstBarrel-1
	jsr ScrollLeftTable
	beq	skip_increase_score

	jsr ScoreIncrement

skip_increase_score
	; Scroll the three top ones
	ldy #LastBarrel+(3*0)-_FirstSprite
	ldx #2
	jsr ScrollLeftTable
	ora _SpriteRequestedState+BarrelInsertionLeft-_FirstSprite
	sta _SpriteRequestedState+BarrelInsertionLeft-_FirstSprite

	ldy #LastBarrel+(3*1)-_FirstSprite
	ldx #2
	jsr ScrollLeftTable
	ora _SpriteRequestedState+BarrelInsertionMiddle-_FirstSprite
	sta _SpriteRequestedState+BarrelInsertionMiddle-_FirstSprite

	ldy #LastBarrel+(3*2)-_FirstSprite
	ldx #2
	jsr ScrollLeftTable
	ora _SpriteRequestedState+BarrelInsertionRight-_FirstSprite
	sta _SpriteRequestedState+BarrelInsertionRight-_FirstSprite

	rts
.)





HandlePlatforms
.(
	; Start by erasing all the platform data
	ldx #FirstPlatform-_FirstSprite
	ldy #LastHook-FirstPlatform
	jsr SpriteErase

.(
	lda #1
	ldy FixationCount
	beq skip
	; Display hooks
loop
	sta _SpriteRequestedState+FirstHook-_FirstSprite-1,y
	dey
	bne loop

skip
	
.)

.(
	ldx #FirstPlatform-_FirstSprite
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
	ldx #FirstKong-_FirstSprite
	ldy #LastKong-FirstKong
	jsr SpriteErase

.(
	lda _KongFlagThrow
	beq handle_movement

	; Throw a barrel
	lda #0
	sta _KongFlagThrow

	lda #1
	ldx #BarrelStartLeft-_FirstSprite
	ldy _KongPosition
	beq throw_it
	ldx #BarrelStartMiddle-_FirstSprite
	dey
	beq throw_it
	ldx #BarrelStartRight-_FirstSprite
throw_it
	sta _SpriteRequestedState,x
	jmp end


handle_movement
	; And now move kong
	jsr _GetRand
	ldx _KongPosition
	lda rand_low
	cmp #40
	bcc throw_barrel
	cmp #140
	bcc left
	cmp #220
	bcs end

right
	cpx #2
	beq end
	inc _KongPosition
	bcc end

throw_barrel
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
	sta _SpriteRequestedState+FirstKong-_FirstSprite,x
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

	; Change sprite status
	sta _SpriteDisplayState,x

	stx tmp_save_sprite

	; X=Sprite number to display
	jsr _DisplaySingleSprite

	ldx tmp_save_sprite
skip_sprite
	inx
	cpx #SPRITE_COUNT
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


_ClearMemory
.(
	; Clear the zero page addresses
	lda #0
	ldx #_zp_end_-_zp_start_
loop_clear_zp
	sta _zp_start_-1,x
	dex
	bne loop_clear_zp

    ; Clear the BSS section
	tay

	ldx #(_BssEndClear_-_BssStart_+255)/256
loop_outer
	tay
loop_inner
_auto_patch = *+1
	sta _BssStart_,y
	dey
	bne loop_inner
	inc _auto_patch+1
	dex
	bne loop_outer

    rts
.)


_GenerateScanlineTable
.(
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
    rts
.)


_GameInits
.(
	; Initialize the random generator values
	lda #23
	sta rand_low
	lda #35
	sta rand_high		

	;
	; Set some game parameters
	;
    lda #0
	sta flag_mario_end
	sta _GameCurrentTick
	sta CraneStatus
	sta CranePosition
	sta HookPosition

	lda #FirstMario-_FirstSprite 
	sta hero_position

	lda #3
	sta live_counter

	lda #4
	sta FixationCount
    rts
.)


; Display the remaining lives of the hero
_DisplayLives
.(
    ; We start by erasing the  3 lives
	ldx #PlayerLives-_FirstSprite
	ldy #3
    jsr SpriteErase

    ; And then we draw the remaining ones
	ldx #PlayerLives-_FirstSprite
	ldy live_counter
    jsr SpriteDraw
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
_SpriteRequestedState	.dsb 93		; 0=not displayed 1=displayed
#else
_SpriteRequestedState	// Force all the sprites to be on
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1,1,1,1
    .byt 1,1,1,1,1,1,1,1,1
#endif


#include "monkey_king_spr.s"
#include "monkey_king_vars.s"

