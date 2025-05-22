
#include "params.h"

; Game sprites defines
#define SPRITE_COUNT        _LastSprite-_FirstSprite
#define BARREL_BASE_MAIN	0
#define BARREL_COUNT_MAIN	17

#define GIRDER_BASE_MAIN	FirstGirder-_FirstSprite
#define GIRDER_COUNT_MAIN	5

#define SPRITE(value)  value-_FirstSprite

; Game speed 
#define GAME_SPEED_UP       250
#define GAME_DELAY          64     ; Used for the global movement and the jump
#define CRANE_DELAY         32
#define GIRDER_DELAY        128
#define GIRDER_RAND_MASK    7

; Game status
#define STATUS_PLAYING  0
#define STATUS_COLLIDED 1
#define STATUS_FELL     2
#define STATUS_WON      3

; Crane position
#define CRANE_DOWN      0
#define CRANE_MID       1
#define CRANE_HIGH      2


; Misc
#define BREAKPOINT  jmp *

	.zero

	*= $1

_zp_start_

ptr_src         .dsb 2
ptr_dst         .dsb 2

current_score	.dsb 2

rand_low		.dsb 1		; Random number generator, low part
rand_high		.dsb 1		; Random number generator, high part

tmp_width		.dsb 1
tmp_height		.dsb 1

b_tmp1			.dsb 1
b_tmp2			.dsb 1

player_status	.dsb 1		; 0=playing 1=mario collide 2=mario fell 3=mario win
mario_jmp_count	.dsb 1
death_counter	.dsb 1
hero_position	.dsb 1      ; Where the player is in the game 

zp_y            .dsb 1

crane_status	.dsb 1	    ; 01	(OFF or ON)
crane_position	.dsb 1	    ; 012
hook_position	.dsb 1	    ; 01234
kong_position	.dsb 1		; 0 1 2 (3 when crashed ???)

fixation_count	.dsb 1		; Number of fix that keep the platform attached

game_speed_up   .dsb 1      ; When reaches zero, game_speed_tick decreases
game_speed_tick .dsb 1      ; Current speed of the game
game_tick		.dsb 1      ; Main game tick
crane_tick	    .dsb 1      ; Tick for the crane animation
girder_tick		.dsb 1		; Tick for the handling of moving girders
girder_spawn_tick .dsb 1	; Handling of when new girders are added

kong_throw		.dsb 1		; Indicate if a throw movement is started

best_score		.dsb 2


_zp_end_


	.text
    
    *=$d6a0     ; _Minigame

_BottomGraphics = $D2E0

_main           jmp real_start   ; +0
read_keyboard   jmp $1234        ; +3
play_sound      jmp $1234        ; +6
VSync           jmp $1234        ; +9


real_start    
    ; Initialize charset with the background image
    jsr _RefineCharacters
    jsr _DisplayCharsetMatrix
    jsr _ClearMemory
    jsr _GenerateScanlineTable
    jsr GameInits

    jsr _PatchSprites

    jsr ScoreDisplay

    ; Draw the 3 possible player lives
	ldx #SPRITE(PlayerLives)
	ldy #3
    jsr SpriteDraw


    ; Force displaying all the sprites
	ldx #0
	ldy #SPRITE(_LastSprite)
    jsr SpriteDraw

    ; Wait for a key press to start the game
    jsr _RefreshAllSprites

    jsr _WaitKey

    ; Erase all the sprites (except the three last lives)
	ldx #0
	ldy #SPRITE(PlayerLives)
	jsr SpriteErase
    jsr _RefreshAllSprites

    jsr BlinkTemporization_128

    ; Remove one life, and put the player in play
    jsr _RemoveLife

    lda #1
	sta SpriteRequestedState+SPRITE(FirstMario)

    jsr _RefreshAllSprites

    jsr BlinkTemporization_128

	;
	; Stay into the game loop while the hero still has some live to spare
	;
game_loop
    jsr VSync
	jsr ScoreDisplay

	jsr MoveHero

	; Move items
	lda game_tick
	bne end_update_items

		lda game_speed_tick
		sta game_tick

		; Call the "click" routine
        jsr Bleep

		jsr HandlePlatforms
		jsr MoveBarrels
		jsr MoveKong
        jsr DisplayLives
end_update_items
	dec game_tick

    ; Handle game speed
    ;  50 IRQ = 1 second
    ; 250 IRQ = 3 seconds
    dec game_speed_up
    bne skip_game_speed
    lda #GAME_SPEED_UP
    sta game_speed_up
    dec game_speed_tick
skip_game_speed

	jsr MoveGirders
	jsr HandleCrane
	jsr _RefreshAllSprites

	jsr HandleCollisions

	ldx player_status
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
	; Reset lots of things death flag
	lda #STATUS_PLAYING
	sta player_status
	sta game_tick
	sta crane_status
	sta crane_position    ; CRANE_DOWN
	sta hook_position

	cpx #STATUS_COLLIDED
	beq MarioCollideSequence 
	cpx #STATUS_FELL
	beq MarioFallSequence 
	jmp MarioWinSequence 


MarioCollideSequence
	lda #8
	sta death_counter
	jsr Bloop

blink_loop
	jsr BlinkTemporization_128
	ldx hero_position
	lda SpriteRequestedState,x
	eor #1
	sta SpriteRequestedState,x
	jsr _RefreshAllSprites
    jsr Bleep

	dec death_counter
	bne blink_loop

    ; Do we still have lives?
    ldx #SPRITE(PlayerLives)
	lda SpriteDisplayState,x
	beq FullDeath

; Normal death
    jsr _RemoveLife

; Reposition mario at the beginning
RestartHero
	lda #SPRITE(FirstMario)
	sta hero_position

	; Erase the first barrels
	ldx #0
	ldy #3
	jsr SpriteErase

    ; Force refreshing sprites
    jsr _RefreshAllSprites

    ; Reset the tick
    lda game_speed_tick
    sta game_tick

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
	sta SpriteRequestedState,x
	lda #1
	ldx #SPRITE(MarioJump)+2
	stx hero_position
	sta SpriteRequestedState,x

	jmp MarioCollideSequence
	



; Ok, mario managed to grip the hook !
; We award mario some points for the operation
MarioWinSequence 
.(
	; Move mario and the crate to the upper level
	jsr BlinkTemporization_128

	; Erase all crane graphics
	ldx #SPRITE(FirstCrane)
	ldy #LastCrane-FirstCrane
	jsr SpriteErase

	; Erase previous mario position
	lda #0
	sta SpriteRequestedState+MarioJump-_FirstSprite

	; Draw upper crane with hook and mario
	lda #1
	sta SpriteRequestedState+FirstCrane-_FirstSprite+2

	; Remove one of the hooks And redraw them
	dec fixation_count
	jsr HandlePlatforms

	jsr _RefreshAllSprites

	; Increment score
	ldx #20
	jsr ScoreIncrementMulti

	; Check if it was the last platform
	lda fixation_count
	bne not_last_platform
	
last_platform
	; Special case of where there are no more platform under kong
	; We need to make them blink, and only after fall down
	lda #4
	sta death_counter

platform_blink
	ldx #SPRITE(FirstPlatform)
	ldy #3
loop
	lda SpriteRequestedState,x
	eor #1
	sta SpriteRequestedState,x
	inx
	dey
	bne loop

	jsr _RefreshAllSprites
    jsr Bleep
	jsr BlinkTemporization_128

	dec	death_counter
	bne platform_blink 

	; Erase the old kong
	ldx #SPRITE(FirstKong)
	ldy #LastKong-FirstKong
	jsr SpriteErase

	lda #0
	sta SpriteRequestedState+SPRITE(FirstPlatform)+0
	sta SpriteRequestedState+SPRITE(FirstPlatform)+1
	sta SpriteRequestedState+SPRITE(FirstPlatform)+2

	; Display the fallen down platforms as well as kong
	lda #1
	sta SpriteRequestedState+SPRITE(FirstPlatformFalling)+0
	sta SpriteRequestedState+SPRITE(FirstPlatformFalling)+1
	sta SpriteRequestedState+SPRITE(FirstPlatformFalling)+2
	sta SpriteRequestedState+SPRITE(FirstKongFalling)

	jsr _RefreshAllSprites

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
	sta SpriteRequestedState+SPRITE(FirstHeart)+0
	lda death_counter
	lsr
	and #1
	sta SpriteRequestedState+SPRITE(FirstHeart)+1

	jsr _RefreshAllSprites
    jsr Bleep

	ldx #64
	jsr BlinkTemporization

	lda death_counter
	bne hearts_blink 

not_last_platform
	; Move down to intermediate level
	; Erase previous victory graphics
	lda #0
	sta SpriteRequestedState+SPRITE(FirstCrane)+2
	sta SpriteRequestedState+SPRITE(FirstVictoryPose)+0
	sta SpriteRequestedState+SPRITE(FirstVictoryPose)+1

	; Draw upper crane with hook and mario
	lda #1
	sta SpriteRequestedState+SPRITE(FirstCrane)+1
	sta SpriteRequestedState+SPRITE(FirstCraneHook)+4
	sta SpriteRequestedState+SPRITE(MarioJump)

	jsr _RefreshAllSprites

	jsr BlinkTemporization_128

	; Move down to lower level
	; Erase previous victory graphics
	lda #0
	sta SpriteRequestedState+SPRITE(FirstCrane)+1
	sta SpriteRequestedState+SPRITE(FirstCraneHook)+4
	sta SpriteRequestedState+SPRITE(MarioJump)

	; Draw lower crane with hook and mario
	lda #1
	sta SpriteRequestedState+SPRITE(FirstCrane)+0
	sta SpriteRequestedState+SPRITE(FirstVictoryPose)+0
	sta SpriteRequestedState+SPRITE(FirstVictoryPose)+1

	jsr _RefreshAllSprites

	jsr BlinkTemporization_128

	lda fixation_count
	bne skip
	lda #4
	sta fixation_count
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
	cpy #SPRITE(FirstMarioJump)+2
	bne check_girder_with_jump2
	lda SpriteRequestedState+SPRITE(FirstGirder)+3
	bne MarioDeadSequence

check_girder_with_jump2
	cpy #SPRITE(FirstMarioJump)+3
	bne check_girder_with_lader
	lda SpriteRequestedState+SPRITE(FirstGirder)+2
	bne MarioDeadSequence

check_girder_with_lader
	cpy #SPRITE(MarioLader_2)
	bne check_jump_on_hook
	lda SpriteRequestedState+SPRITE(FirstGirder)+0
	bne MarioDeadSequence

check_jump_on_hook
	cpy #SPRITE(MarioJump)
	bne check_end

	; 2=mario falling
	; 3=mario wining by getting the hook
	ldx #2	
	lda SpriteRequestedState+SPRITE(FirstCraneHook)+4
	beq mario_failure
	inx
mario_failure
	stx player_status

check_end
	rts

MarioDeadSequence
	lda #STATUS_COLLIDED
	sta player_status
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

    ; Check if we reached 300 points to get an extra life
    lda #>$300
    cmp current_score+0
    bne end_extra_life
    lda #<$300
    cmp current_score+1
    bne end_extra_life
    
    ; Normally should blink to indicate to the player, but will work good enough at the moment
    lda #1
    sta SpriteRequestedState+SPRITE(PlayerLives)+2

end_extra_life

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
	sta SpriteRequestedState,x
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
	lda crane_status
	beq end_crane_movement

	dec	crane_tick
	bne end_crane_movement
	
	lda #CRANE_DELAY
	sta crane_tick

	; 0=down
	; 1=mid (need hooks)
	ldx crane_position
	bne not_down 
down
	inc crane_position
	jmp end_crane_movement

not_down
	dex
	bne end_mid

mid
	ldx hook_position
	cpx #HookSequence_End-HookSequence_Start
	beq end_mid
	inc hook_position
	jmp end_crane_movement

end_mid
	lda #0
	sta crane_position
	sta crane_status
	sta hook_position

end_crane_movement

	; Display the crane control handle
	lda crane_status
	ldx #1
	sta SpriteRequestedState+SPRITE(FirstCraneStick),x
	dex
	eor #1
	sta SpriteRequestedState+SPRITE(FirstCraneStick),x

	; Erase all crane graphics
	ldx #SPRITE(FirstCrane)
	ldy #LastCrane-FirstCrane
	jsr SpriteErase

	; Draw crane depending of flags
	lda #CRANE_MID
	ldx crane_position
	sta SpriteRequestedState+SPRITE(FirstCrane),x

	; Draw hooks depending of position
	ldx crane_position
	cpx #CRANE_MID
	bne end_draw_hooks

	ldx hook_position
    lda HookSequence_Start,x
    tax
	lda #1
	sta SpriteRequestedState,x

end_draw_hooks
	rts
.)


; Table with the various positions of hooks for the swinging movement
HookSequence_Start
    .byt SPRITE(FirstCraneHook)+4    ; Close to the player
    .byt SPRITE(FirstCraneHook)+3
    .byt SPRITE(FirstCraneHook)+2
    .byt SPRITE(FirstCraneHook)+1
    .byt SPRITE(FirstCraneHook)+0    ; Far from the player
    .byt SPRITE(FirstCraneHook)+1
    .byt SPRITE(FirstCraneHook)+2
    .byt SPRITE(FirstCraneHook)+3
    .byt SPRITE(FirstCraneHook)+4    ; Close to the player
    .byt SPRITE(FirstCraneHook)+3
    .byt SPRITE(FirstCraneHook)+2
    .byt SPRITE(FirstCraneHook)+1
    .byt SPRITE(FirstCraneHook)+0    ; Far from the player
HookSequence_End




MoveHero
.(
	; Erase all previous position
	ldx #SPRITE(FirstMario)
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
	cpy #SPRITE(FirstMarioJump)+0
	bne check_second_jump
	ldy #SPRITE(FirstFloorMario)+0
	jmp end_keyboard

check_second_jump
	cpy #SPRITE(FirstMarioJump)+1
	bne check_third_jump
	ldy #SPRITE(FirstFloorMario)+3
	jmp end_keyboard

check_third_jump
	cpy #SPRITE(FirstMarioJump)+2
	bne check_fourth_jump
	ldy #SPRITE(SecondFloorMario)+1
	jmp end_keyboard

check_fourth_jump
	cpy #SPRITE(FirstMarioJump)+3
	bne check_end
	ldy #SPRITE(SecondFloorMario)+2
	;jmp end_keyboard

check_end
	jmp end_keyboard
.)



handle_keyboard
	;
	; Handle keyboard
	;  y contains the position of hero during all code, do not alter
	jsr HandleKeys

end_keyboard

	;
	; Draw new position
	;
	lda #1
	sta SpriteRequestedState,y

	;
	; Handle display of mario arm
	;
	lda #0
	sta SpriteRequestedState+SPRITE(FirstMarioHand)+0
	sta SpriteRequestedState+SPRITE(FirstMarioHand)+1

	cpy #SPRITE(ThirdFloorMario)
	bne skip_stick

	lda crane_status
	ldx #1
	sta SpriteRequestedState+SPRITE(FirstMarioHand),x
	eor #1
	dex
	sta SpriteRequestedState+SPRITE(FirstMarioHand),x
skip_stick

	cpy hero_position
	beq no_movement
	sty hero_position
	; Call the "click" routine
	jsr Bloop
no_movement

	rts
.)




HeroMoveLeft
.(
check_third_floor                                 ; Third floor
	cpy #SPRITE(ThirdFloorMario)+1
	bcc check_third_floor_crane_control
	cpy #SPRITE(MarioJump)
	bcs check_end
	dey
	rts

check_third_floor_crane_control
	cpy #SPRITE(ThirdFloorMario)
	bne check_second_floor

	; Activate the crane
	lda #1
	sta	crane_status
	rts
	
check_second_floor                                ; Second floor check (reversed)
	cpy #SPRITE(SecondFloorMario)
	bcc check_first_floor
	cpy #SPRITE(MarioLader_2)
	bcs check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((SecondFloorMario-_FirstSprite)-(SecondFloorBarrel-_FirstSprite))
	tax
	lda SpriteRequestedState,x
	bne collided
	iny
	rts
	
check_first_floor                                ; First floor check
	cpy #SPRITE(FirstFloorMario)+1
	bcc check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((FirstFloorMario-_FirstSprite)-(FirstBarrel-_FirstSprite))
	tax
	lda SpriteRequestedState-1,x
	bne collided
	dey
	rts

collided
	lda #STATUS_COLLIDED
	sta player_status
	rts

check_end
	rts
.)


_WaitKey
.(
    jsr read_keyboard
    beq _WaitKey
    rts
.)


HandleKeys
.(
    jsr read_keyboard
    cpx #KEY_LEFT
    beq HeroMoveLeft
    cpx #KEY_RIGHT
    beq HeroMoveRight
    cpx #KEY_DOWN
    beq HeroMoveDown
    cpx #KEY_UP
    beq HeroMoveUp
    cpx #KEY_SPACE
    beq HeroMoveSpace
	rts
.)


HeroMoveRight
.(
	; Check the jump position
	cpy #SPRITE(ThirdFloorMario)+2
	bne check_third_floor

	ldy #SPRITE(MarioJump)+1
	; 0=playing 1=mario collide 2=mario fell 3=mario win
	lda #STATUS_FELL
	sta player_status
	rts

	; Third floor
check_third_floor
	cpy #SPRITE(ThirdFloorMario)
	bcc check_second_floor
	cpy #SPRITE(MarioJump)-1
	bcs check_end
	iny
	rts

	; Second floor check (reversed)
check_second_floor
	cpy #SPRITE(SecondFloorMario)+1
	bcc check_first_floor
	cpy #SPRITE(MarioLader_2)
	bcs check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((SecondFloorMario-_FirstSprite)-(SecondFloorBarrel-_FirstSprite))
	tax
	lda SpriteRequestedState-1,x
	bne collided
	dey
	rts


check_first_floor
	cpy #SPRITE(SecondFloorMario)-1
	bcs check_end

	; Test collision with first floor barrels
	tya
	sec
	sbc #((FirstFloorMario-_FirstSprite)-(FirstBarrel-_FirstSprite))
	tax
	lda SpriteRequestedState,x
	bne collided
	iny
	rts

collided
	lda #STATUS_COLLIDED
	sta player_status
	rts

check_end
	rts
.)



HeroMoveDown
.(    
check_second_lader    
	cpy #SPRITE(MarioLader_2)
	bcc check_first_lader
	cpy #SPRITE(ThirdFloorMario+1)
	bcs check_end
	dey
check_end
	rts
    
check_first_lader    
	cpy #SPRITE(SecondFloorMario)
	bne check_end
	dey
	rts
.)



HeroMoveUp
.(
check_second_lader
	cpy #SPRITE(MarioLader_2-1)
	bcc check_first_lader
	cpy #SPRITE(ThirdFloorMario)
	bcs check_end
	iny
check_end
	rts

check_first_lader
	cpy #SPRITE(MarioLader_1)
	bne check_end
	iny
	rts
.)




HeroMoveSpace
.(
check_first_jump
	cpy #SPRITE(FirstFloorMario)
	bne check_second_jump
	ldy #SPRITE(FirstMarioJump)
	jmp validate_jump

check_second_jump
	cpy #SPRITE(FirstFloorMario+3)
	bne check_third_jump
	ldy #SPRITE(FirstMarioJump+1)
	jmp validate_jump

check_third_jump
	cpy #SPRITE(SecondFloorMario+1)
	bne check_fourth_jump
	ldy #SPRITE(FirstMarioJump+2)
	jmp validate_jump

check_fourth_jump
	cpy #SPRITE(SecondFloorMario+2)
	bne check_fifth_jump
	ldy #SPRITE(FirstMarioJump+3)
	jmp validate_jump

check_fifth_jump
	cpy #SPRITE(ThirdFloorMario+2)
	bne check_end
	ldy #SPRITE(MarioJump)
	jmp validate_jump

validate_jump
	lda game_speed_tick
	sta mario_jmp_count
check_end
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
	lda SpriteRequestedState+BARREL_BASE_MAIN,y
	pha
.(
loop
	lda SpriteRequestedState+BARREL_BASE_MAIN+1,y
	sta SpriteRequestedState+BARREL_BASE_MAIN,y
	lda #0
	sta SpriteRequestedState+BARREL_BASE_MAIN+1,y
	iny
	dex
	bne loop

	; Get back the ejected value
	pla
	rts
.)




TableCollisionCount
	.byt 5	; first floor
	.byt 5	; second floor
	.byt 1	; barrel coming from the right on third floor
	.byt 1	; barrel from the top left
	.byt 1	; barrel from the top mid
	.byt 1	; barrel from the top right
TableCollisionSrc
	.byt SPRITE(FirstBarrel)
	.byt SPRITE(SecondFloorBarrel)
	.byt SPRITE(BarrelInsertionLeft)
	.byt SPRITE(BarrelCollideFallLeft)
	.byt SPRITE(BarrelCollideFallMiddle)
	.byt SPRITE(BarrelCollideFallRight)
TableCollisionDst
	.byt SPRITE(FirstFloorMario)
	.byt SPRITE(SecondFloorMario)
	.byt SPRITE(MarioLaderCollide)
	.byt SPRITE(ThirdFloorMario)
	.byt SPRITE(ThirdFloorMario)+1
	.byt SPRITE(ThirdFloorMario)+2

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
	lda SpriteRequestedState,x
	beq skip
	lda SpriteRequestedState,y
	beq skip
collided
	lda #STATUS_COLLIDED
	sta player_status
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
	ldy #SPRITE(LastBarrel)+(3*0)
	ldx #2
	jsr ScrollLeftTable
	ora SpriteRequestedState+SPRITE(BarrelInsertionLeft)
	sta SpriteRequestedState+SPRITE(BarrelInsertionLeft)

	ldy #SPRITE(LastBarrel)+(3*1)
	ldx #2
	jsr ScrollLeftTable
	ora SpriteRequestedState+SPRITE(BarrelInsertionMiddle)
	sta SpriteRequestedState+SPRITE(BarrelInsertionMiddle)

	ldy #SPRITE(LastBarrel)+(3*2)
	ldx #2
	jsr ScrollLeftTable
	ora SpriteRequestedState+SPRITE(BarrelInsertionRight)
	sta SpriteRequestedState+SPRITE(BarrelInsertionRight)

	rts
.)





HandlePlatforms
.(
	; Start by erasing all the platform data
	ldx #SPRITE(FirstPlatform)
	ldy #LastHook-FirstPlatform
	jsr SpriteErase

.(
	lda #1
	ldy fixation_count
	beq skip
	; Display hooks
loop
	sta SpriteRequestedState+SPRITE(FirstHook)-1,y
	dey
	bne loop

skip
.)

.(
	ldx #SPRITE(FirstPlatform)
	lda #1
	ldy #3
loop
	sta SpriteRequestedState,x
	inx
	dey
	bne loop
skip_platforms
.)

	rts
.)




MoveGirders
.(
	dec girder_tick
	bne end_update

	lda #GIRDER_DELAY
	sta girder_tick

	; Move them all by one tick
	ldx #0
loop
	lda SpriteRequestedState+GIRDER_BASE_MAIN+1,x
	sta SpriteRequestedState+GIRDER_BASE_MAIN,x
	inx
	cpx #GIRDER_COUNT_MAIN-1
	bne loop

	; And clear/set the first one depending of random
	lda #0
	dec girder_spawn_tick
	bpl end_spawn

	jsr _GetRand
	and #GIRDER_RAND_MASK
	sta girder_spawn_tick
	lda #1
end_spawn
	sta SpriteRequestedState+GIRDER_BASE_MAIN+GIRDER_COUNT_MAIN-1
end_update
	rts
.)



MoveKong
.(
	; Start by erasing all the kong data
	ldx #SPRITE(FirstKong)
	ldy #LastKong-FirstKong
	jsr SpriteErase

.(
	lda kong_throw
	beq handle_movement

	; Throw a barrel
	lda #0
	sta kong_throw

	lda #1
	ldx #SPRITE(BarrelStartLeft)
	ldy kong_position
	beq throw_it
	ldx #SPRITE(BarrelStartMiddle)
	dey
	beq throw_it
	ldx #SPRITE(BarrelStartRight)
throw_it
	sta SpriteRequestedState,x
	jmp end


handle_movement
	; And now move kong
	jsr _GetRand
	ldx kong_position
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
	inc kong_position
	bcc end

throw_barrel
	lda #1
	sta kong_throw
	bcc end

left
	cpx #0
	beq end
	dec kong_position

end
.)
	

.(
	lda #0
	ldx kong_position
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
	lda kong_throw
	beq skip_throw
	dey
	dex
skip_throw
	sty b_tmp1

	lda #1
loop_draw
	sta SpriteRequestedState+SPRITE(FirstKong),x
	inx
	dec b_tmp1
	bne loop_draw
.)

	rts
.)



_RefreshAllSprites
.(
	ldx #0
loop_sprite
	lda SpriteRequestedState,x
	cmp SpriteDisplayState,x
	beq skip_sprite
	sta SpriteDisplayState,x        ; Update the sprite status
		
	lda SpriteTableLow,x            ; Sprite data address
	sta ptr_src+0
	lda SpriteTableHigh,x
	sta ptr_src+1
	
	lda SpriteTableWidth,x          ; Sprite width and height
	sta tmp_width

	lda SpriteTableHeight,x
	sta tmp_height

	lda SpriteTableScreenX,x        ; Screen address
	sta auto_x_offset
	lda SpriteTableScreenY,x
	sta zp_y

loop_y
    ldy zp_y    
    inc zp_y
    clc 
    lda ScanlineTableLow,y
auto_x_offset = *+1
    adc #0
    sta ptr_dst+0
    lda ScanlineTableHigh,y
    adc #0
    sta ptr_dst+1

    ldy #0
loop_x
	lda (ptr_src),y
	eor (ptr_dst),y
	sta (ptr_dst),y	
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

skip_sprite
	inx
	cpx #SPRITE_COUNT
	bne loop_sprite    

    jmp _RefineCharacters      ; And immediately copy the content to the charset
.)


; This should only be called for sprites that are only used once
_PatchSprites
.(
    ;rts
	ldx #0
loop_sprite
	lda SpriteTableScreenX,x        ; Screen address
    bpl skip_sprite                 ; BIT 7 set = must patch at startup
    and #127
	sta SpriteTableScreenX,x        ; Write back the patched value

	sta auto_x_offset
	lda SpriteTableScreenY,x
	sta zp_y
		
	lda SpriteTableLow,x            ; Sprite data address
	sta ptr_src+0
	lda SpriteTableHigh,x
	sta ptr_src+1
	
	lda SpriteTableWidth,x          ; Sprite width and height
	sta tmp_width

	lda SpriteTableHeight,x
	sta tmp_height

loop_y
    ldy zp_y    
    inc zp_y
    clc 
    lda ScanlineTableLow,y
auto_x_offset = *+1
    adc #0
    sta ptr_dst+0
    lda ScanlineTableHigh,y
    adc #0
    sta ptr_dst+1

    ldy #0
loop_x
	lda (ptr_dst),y             ; Load from screen
    and #%00111111              ; Mask out inverse/hires bits
	and (ptr_src),y             ; Mask with the sprite data
	sta (ptr_src),y	            ; Write back into the sprite
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

skip_sprite
	inx
	cpx #SPRITE_COUNT
	bne loop_sprite    
    rts
.)


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

    ; Last 8 scanlines in ALT charset
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
    sta ScanlineTableLow
    lda #>$a000
    sta ScanlineTableHigh

    ldx #1
loop_hires
    clc
    lda ScanlineTableLow-1,x
    adc #40
    sta ScanlineTableLow,x

    lda ScanlineTableHigh-1,x
    adc #0
    sta ScanlineTableHigh,x

    inx 
    cpx #200
    bne loop_hires  

    ; Point to the "hires buffer"
    lda #<_BottomGraphics
    sta ScanlineTableLow,x
    lda #>_BottomGraphics
    sta ScanlineTableHigh,x
    inx

loop_text
    clc
    lda ScanlineTableLow-1,x
    adc #40
    sta ScanlineTableLow,x

    lda ScanlineTableHigh-1,x
    adc #0
    sta ScanlineTableHigh,x

    inx 
    cpx #224
    bne loop_text
    rts
.)


GameInits
.(
	; Initialize the random generator values
	lda #23
	sta rand_low
	lda #35
	sta rand_high		

	; Set some game parameters
    lda #0
	sta player_status
	sta game_tick
	sta crane_status
	sta crane_position
	sta hook_position

    lda #GAME_SPEED_UP
    sta game_speed_up

    lda #GAME_DELAY
    sta game_speed_tick

	lda #SPRITE(FirstMario)
	sta hero_position

    lda #1
    sta crane_tick

    lda #GIRDER_DELAY
    sta girder_tick

	lda #4
	sta fixation_count

#if 0  // TEST
    lda #>$295
    sta current_score+0
    lda #<$295
    sta current_score+1
#endif    

    rts
.)


; Remove life
_RemoveLife
.(
    lda #0
    sta SpriteRequestedState+SPRITE(PlayerLives)+0
    rts
.)

; Display the remaining lives of the hero
DisplayLives
.(
check_first_slot    
    lda SpriteRequestedState+SPRITE(PlayerLives)+0    ; Is first slot occupied?
    bne check_third_slot

check_second_slot
    lda SpriteRequestedState+SPRITE(PlayerLives)+1    ; Is second slot occupied?
    beq check_third_slot
    sta SpriteRequestedState+SPRITE(PlayerLives)+0    ; Fill the first slot
    lda #0
    sta SpriteRequestedState+SPRITE(PlayerLives)+1    ; Clear the second slot
    rts

check_third_slot
    lda SpriteRequestedState+SPRITE(PlayerLives)+1    ; Is second slot occupied?
    bne done
    lda SpriteRequestedState+SPRITE(PlayerLives)+2    ; Is third slot occupied?
    beq done
    sta SpriteRequestedState+SPRITE(PlayerLives)+1    ; Fill the second slot
    lda #0
    sta SpriteRequestedState+SPRITE(PlayerLives)+2    ; Clear the third slot
done
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


#include "monkey_king_spr.s"


_SpriteMario_Life
	; 2x16
	.byt %000111,%110000
	.byt %000111,%110000
	.byt %011111,%111000
	.byt %000101,%111000
	.byt %011101,%111100
	.byt %001111,%111100
	.byt %000111,%111000
	.byt %000011,%110011
	.byt %011001,%111110
	.byt %111111,%110100
	.byt %000011,%110000
	.byt %000011,%111000
	.byt %011011,%011110
	.byt %011110,%000110
	.byt %001100,%000100
	.byt %000000,%000000




SevenDigitPatterns
    ; 0
    .byt %100011
    .byt %011101
    .byt %111111
    .byt %011101
    .byt %100011
    ; 1
    .byt %111111
    .byt %111101
    .byt %111111
    .byt %111101
    .byt %111111
    ; 2
    .byt %100011
    .byt %111101
    .byt %100011
    .byt %011111
    .byt %100011
    ; 3
    .byt %100011
    .byt %111101
    .byt %100011
    .byt %111101
    .byt %100011
    ; 4
    .byt %111111
    .byt %011101
    .byt %100011
    .byt %111101
    .byt %111111
    ; 5
    .byt %100011
    .byt %011111
    .byt %100011
    .byt %111101
    .byt %100011
    ; 6
    .byt %100011
    .byt %011111
    .byt %100011
    .byt %011101
    .byt %100011
    ; 7
    .byt %100011
    .byt %111101
    .byt %111111
    .byt %111101
    .byt %111111
    ; 8
    .byt %100011
    .byt %011101
    .byt %100011
    .byt %011101
    .byt %100011
    ; 9
    .byt %100011
    .byt %011101
    .byt %100011
    .byt %111101
    .byt %100011


EndData

	.bss

* = EndData

;
; Allign the content of BSS section to a byte boudary
;
	.dsb 256-(*&255)

_BssStart_

ScanlineTableLow        .dsb 224
ScanlineTableHigh       .dsb 224

SpriteDisplayState		.dsb SPRITE_COUNT		; 0=not displayed 1=displayed
SpriteRequestedState	.dsb SPRITE_COUNT		; 0=not displayed 1=displayed


_BssEnd_
	.dsb 256-(*&255)    ; This will be overwriten
_BssEndClear_


