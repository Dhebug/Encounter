;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Routines to deal with Eric
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include "params.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the Eric main action timer
; to the appropriate value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_Eric_timer
.(
	ldy #7
	lda #%00010000
	and KeyBank,y
	;bne quick
	beq quick
	lda #NORMAL_ERIC_TIMER
	.byt $2c
quick
	lda #FAST_ERIC_TIMER
	sta Eric_timer
	sta Eric_mid_timer
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get Eric's Y coordinate (adjusted
; if he is jumping) in reg A
; This is used by s_check_Eric_loc
; and TODO others.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_Eric_Ycoord
.(
	sty savy+1
	ldy pos_row
	lda Eric_flags
	and #ERIC_JUMPING
	beq noadjust
	cpy #4
	bcs nottop
	ldy #3
	bne noadjust
nottop
	cpy #11
	bcs notbottom
	ldy #10
	bne noadjust
notbottom
	ldy #17
noadjust
	tya
savy
	ldy #0
	rts
.)


to_front_Eric
.(
	ldx #0
	jmp to_front
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move Eric left
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

left_Eric
.(
	; Check if Eric can move
	lda Eric_flags
	beq doit
retme
	rts
doit
	; Is Eric facing left?
	lda flags  ;,x
	and #IS_FACING_RIGHT
	beq facingleft
	; Turn him
+turnEric
	lda #MIDS_ERIC_TIMER	
	sta Eric_timer
	jmp change_direction
facingleft

	; Assume we can move and put the correct
	; value in Eric's timer
	jsr set_Eric_timer

	; Check if Eric is on a staircase
	ldx #0
	jsr is_on_staircase
	beq notstaircasel
	; Is he at the right of the school?
	lda pos_col  ;,x
	cmp #WALLMIDDLEFLOOR
	bcs left
	jmp up_a_stair
left
	jmp down_a_stair
+notstaircasel
	; Perfect, we can perform a step if
	; there is no obstacle
	; Is he at the left end of the school?
	ldy pos_col  ;,x
	cpy #FIRST_VIS_COL-1
	beq retme

	; Is he on the bottom floor
	lda pos_row  ;,x
	cmp #17	
	beq proceed
	; Is he on the top floor
	cmp #3
	bne middle
	cpy #WALLTOPFLOOR+1
	bne proceed
	rts
middle
	cpy #WALLMIDDLEFLOOR+1
	bne otherwall
	rts
otherwall
	cpy #WALLMIDDLEFLOOR2+1
	bne proceed
	rts
proceed
	jmp step_character
.)


right_Eric
.(
	; Check if Eric can move
	lda Eric_flags
	beq doit
retme
	rts
doit
	; Is Eric facing left?
	lda flags  ;,x
	and #IS_FACING_RIGHT
	bne facingright
	; Turn him
	jmp turnEric
facingright

	; Assume we can move and put the correct
	; value in Eric's timer
	jsr set_Eric_timer

	; Check if Eric is on a staircase
	ldx #0
	jsr is_on_staircase
	beq notstaircaser
	; Is he at the right of the school?
	lda pos_col  ;,x
	cmp #WALLMIDDLEFLOOR
	bcs left
	jmp down_a_stair
left
	jmp up_a_stair
+notstaircaser

	; Perfect, we can perform a step if
	; there is no obstacle
	; Is he at the right end of the school?
	ldy pos_col  ;,x
	cpy #SKOOL_COLS-3
	beq retme

	; Is he on the bottom floor
	lda pos_row  ;,x
	cmp #17	
	beq proceed
	; Is he on the top floor
	cmp #3
	bne middle
	cpy #WALLTOPFLOOR-3
	bne proceed
	rts
middle
	cpy #WALLMIDDLEFLOOR-3
	bne otherwall
	rts
otherwall
	cpy #WALLMIDDLEFLOOR2-3
	bne proceed
	rts
proceed
	jmp step_character
.)



up_Eric
.(
	; Check if Eric can move
	lda Eric_flags
	beq doit
retme
	rts
doit
	; Assume we can move and put the correct
	; value in Eric's timer
	jsr set_Eric_timer

	; Check if Eric is on a staircase
	lda pos_row; ,x
	cmp #3
	beq notstaircase
	cmp #10
	beq middlebottom
	cmp #17
	beq middlebottom
	; Eric is on a staircase, must he turn round first or go up a step?
	; First check if he is on a staircase at the left or at the right of the school
	lda pos_col  ;,x
	cmp #WALLMIDDLEFLOOR
	bcc left
	; He is at a right staircase
	; Is Eric facing left?
	lda flags  ;,x
	and #IS_FACING_RIGHT
	bne doit2	;facingright
	; If so turn him round
	jmp change_direction
/*facingright
	; Move him up a stair
	jmp up_a_stair*/
left
	; His is at a left staircase
	; Is Eric facing left?
	lda flags  ;,x
	and #IS_FACING_RIGHT
	bne facingright2
	; Move him up a stair
	jmp up_a_stair
facingright2
	; If so turn him round
	jmp change_direction
+notstaircase
	; He is not in a staircase
/*
	lda tab_chars
	beq donothing
	jsr to_front_Eric	
donothing
*/
	lda flags
	and #IS_FACING_RIGHT
	bne notstaircaser
	jmp notstaircasel

middlebottom
	; He is at the middle or bottom floors
	lda pos_col
	cmp #STAIRLBOTTOM
	bne notleftstaircase
	; At the bottom of the left staircase
	lda flags
	and #IS_FACING_RIGHT
	bne notstaircase
	; Facing left
	beq doit2
notleftstaircase
	cmp #STAIRRBOTTOM
	bne notstaircase
	lda flags
	and #IS_FACING_RIGHT
	beq notstaircase
	; Facing right
doit2
	jsr to_back
	jmp up_a_stair
.)


down_Eric
.(
	; Check if Eric can move
	lda Eric_flags
	beq doit
retme
	rts
doit
	; Assume we can move and put the correct
	; value in Eric's timer
	jsr set_Eric_timer

	; Check if Eric is on a staircase
	lda pos_row; ,x
	cmp #3
	beq middletop
	cmp #10
	beq middletop
	cmp #17
	beq notstaircase
	; Eric is on a staircase, must he turn round first or go down a step?
	; First check if he is on a staircase at the left or at the right of the school
	lda pos_col  ;,x
	cmp #WALLMIDDLEFLOOR
	bcc left
	; He is at a right staircase
	; Is Eric facing left?
	lda flags  ;,x
	and #IS_FACING_RIGHT
	bne facingright
	; Move him down a stair
	jmp doit22
facingright
	; If so turn him round
	jmp change_direction
left
	; His is at a left staircase
	; Is Eric facing left?
	lda flags  ;,x
	and #IS_FACING_RIGHT
	bne facingright2
	; If so turn him round
	jmp change_direction
facingright2
	jmp doit22
middletop
	; He is at the middle or top floors
	lda pos_col
	cmp #STAIRLTOP
	bne notleftstaircase
	; At the top of the left staircase
	lda flags
	and #IS_FACING_RIGHT
	beq notstaircase
	bne doit2
	; Facing left
notleftstaircase
	cmp #STAIRRTOP
	bne notstaircase
	lda flags
	and #IS_FACING_RIGHT
	beq doit2 
	jmp notstaircase
doit2
	jsr to_back
doit22
	jmp down_a_stair
.)


sit_Eric
.(
	; Flip Eric flag...
	lda Eric_flags
	eor #(ERIC_SITTINGLYING)
	sta Eric_flags
	bmi dosit
	; Eric must stand up
	jmp s_stand_up
dosit
	; Eric is going to sit down... even on the floor

	ldx #0
	jsr is_on_staircase
	beq notstairs

	; Eric is on a staircase...
	; sit him down...
	lda pos_col
	cmp #64
	; Carry is set if Eric is on the right side of the school
	lda flags
	and #IS_FACING_RIGHT
	; Zero is clear if eric is facing right
	bcs rightside
	; Eric is at the left side, must he turn around?
	bne noturn
turn
	jsr change_direction
noturn
	lda #4
	jmp update_animstate
rightside
	; Eric is at the right side, turn if Z is clear
	bne turn 
	beq noturn

notstairs
	; Eric is not at a staircase... so sit down
	; but not on the bottom floor!
	lda pos_row
	cmp #17
	beq notyet

	sty tmp7
  	jsr s_check_chair	; Returns Z=1 if there is a chair and C=1 if the 
						; character needs to turn round
	bne notyet
	ldy tmp7
	jmp s_knock_and_sit
notyet
	ldy tmp3
	; Then sit on the floor
	lda #5
	jmp update_animstate
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Deal with ERIC when he's being spoken to 
; by a little boy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

listen_Eric
.(
	; Is the little boy still delivering the message?
	lda special_playtime
	ora #%10000000
	bne cont
retme
	rts
cont
	; Check the keyboard
	jsr ReadKeyNoBounce
	beq retme

	; Was 'U' pressed?
	cmp #"U"
	bne retme
	
	; Signal it
	lda Eric_flags
	and #(ERIC_SPOKEN^$ff)
	sta Eric_flags
	rts
.)


jump_Eric
.(
	lda Eric_flags
	bpl cont
cannot
	; Eric is lying down or sitting
	rts
cont

	ldx #0
	jsr is_on_staircase
	bne cannot ; Eric cannot jump when on a staircase

	jsr update_SRB_sp
	dec pos_row

	lda #10
	sta tmp+1
	lda #ERIC_JUMPING
	sta tmp
	lda #16
	sta tmp0
	jmp realize_Eric_action
.)

jump_Eric2
.(
	; Decrement action timer
	dec Eric_timer
	bne cont
	jmp endpunch	; Re-use this entry point
cont

	; Usual checks for reprimands, shields, etc.
	; Time to get reprimands?
	lda Eric_timer
entrypoint1
	cmp #12
	bne noreprimand
	lda #NO_JUMPING
	jmp punish_Eric
noreprimand
	; Time to check if Eric touched a shield
	cmp #13
	bne noshieldcheck
	jmp shield_check_jump
noshieldcheck
	; Time to make the jumping sound?
	cmp #14
	bne nojumpsfx
	; jmp jump_sfx
	rts
nojumpsfx
	; Time to move Eric's arm?
	cmp #9
	bne nomovearm
	;lda #9
	jmp setEric_state
nomovearm
	; Time to bring Eric back down to the floor?
	cmp #3
	bne nofall
	ldx #CHAR_ERIC
	jsr update_SRB_sp
	inc pos_row
	jmp update_SRB_sp
nofall
	cmp #6
	bcc retme ; Nothing to do

	; At this point A=6 (which means it's time 
	; to check whether ERIC has jumped onto a boy,
	; or ERIC is already standing on a boy), or A 
	; is one of {7, 8, 10, 11, 15}, or A<128 
	; (which means ERIC has jumped while standing 
	; on a boy).

	bne nocheckboy
	
	; Check if Eric jumped onto a knocked-down boy

	ldy #CHAR_BOY11
loop
	jsr check_boy	
	bcs found
	dey
	bne loop
	; No boy found
retme
	rts	
found
	; Eric is standing on a kid!
	; Read the keyboard
	; Set the timer to value 7, so we keep visiting
	; this code while Eric is standing on the boy
	lda #7
	sta Eric_timer
	jsr ReadKeyNoBounce
	beq retme

	cmp #"J"
	bne nopressJ
	; Set the timer to 144 to indicate that we
	; jumped while standing on a boy
	lda #144
	sta Eric_timer
	; Return to the main loop, but with the
	; carry flag reset, so the keypress is
	; processed there
/*	lda #0
	sta oldKey
	pla
	pla
	clc
	rts*/

	ldx #CHAR_ERIC
	jsr update_SRB_sp
	dec pos_row
	jsr update_SRB_sp
nopressJ
	; Another key of interest was pressed
	; maybe trying to turn Eric round
	cmp #4	; KEY_RIGHT
	bne noright
	lda Eric_flags
	and #IS_FACING_RIGHT
	beq retme
changedir
	ldx #CHAR_ERIC
	jmp change_direction
noright
	cmp #2	; KEY_LEFT
	bne retme

	lda Eric_flags
	and #IS_FACING_RIGHT
	beq retme
	bne changedir
	
nocheckboy
	; At this point A is one of {7, 8, 10, 11, 15}
	; (which means there is nothing to do), 
	; or A=128-143 (which means ERIC has jumped 
	; while standing on a boy).	
	cmp #134
	beq retme
	sec
	sbc #128
	bcc retme	; Return unless Eric jumped while over a boy
	
	; So ERIC has jumped while standing on a boy. 
	; Now either A=0, meaning it's time to set the 
	; jumping action timer at 32758 back to 7, so 
	; we can deal with ERIC while he's standing on
	; a boy; or A=1-15 (but not 6, because that 
	; would lead us into the code at 62819 to 
	; perform a redundant check on whether ERIC 
	; is standing on a boy), meaning we need to run
	; the usual checks while ERIC is in mid-air.
	beq found
	jmp entrypoint1
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check whether ERIC is standing on a boy who's 
; been knocked out. Reg Y is the boy's id
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_boy
.(
	; Set limits (pos_x+-1)
	ldx pos_col
	dex
	stx tmp0
	inx
	inx
	stx tmp0+1
	
	; Check if the boy is at the same y-coordinate
	ldx pos_row
	inx
	txa
	cmp pos_row,y
	bne notthis

	; Get the boy's animatory state
	lda anim_state,y
	cmp #6
	bne notthis

	; Check the boy's x-coordinate
	lda pos_col,y
	cmp tmp0
	bcc notthis
	cmp tmp0+1
	bcs notthis
	sec
	rts
notthis
	clc
	rts
.)

write_Eric
.(
	; Is Eric sitting or lying down?
	lda Eric_flags
	bpl cont
	; Eric is lying down or sitting
retme
	rts
cont
	; Is he on a staircase?
	ldx #0
	jsr is_on_staircase
	bne retme
	
	; Is he on the bottom floor (no blackboards there)
	; A holds the y position
	cmp #17
	beq retme

	; Check if on top floor
	cmp #3
	beq topfloor

	; Check if left or right to the white room wall
	lda pos_col
	cmp #WALLMIDDLEFLOOR
	bcc left
	; He is at the right
	cmp #COL_EXAM_BOARD-2
	bcc retme
	cmp #COL_EXAM_BOARD-2+6
	bcc posok
	rts
left
	; He ia at the left
	cmp #COL_WHITE_BOARD-2
	bcc retme
	cmp #COL_WHITE_BOARD-2+6
	bcc posok
	rts
topfloor
	lda pos_col
	; He is on the top floor
	cmp #COL_READING_BOARD-2
	bcc retme
	cmp #COL_READING_BOARD-2+6
	bcc posok
	rts
posok
	; Set appropriate bit on Eric's flags
	lda Eric_flags
	ora #ERIC_WRITTING
	sta Eric_flags

	; Get the blackboard identifier
	; Reg x=0 has been set way before
	ldx #0
	jsr get_blackboard
	ldy #4
	lda (tmp3),y	; Who wrote there last?
	bpl notclean
	; Blackboard is clean, prepare
	; everything to grab what Eric writes
	lda #0	
	.byt $2c
notclean
	lda #$ff
	ldy #11
	sta (tmp3),y

	; Note Eric wrote here
	ldy #4
	lda #CHAR_ERIC
	sta (tmp3),y

	; Set tile=0 and col=1
	ldy #2
	lda #1
	sta (tmp3),y
	iny
	lda #0
	sta (tmp3),y

	jmp risearm

; Entry point from the main loop whenever we
; deal with Eric when he is writting on a blackboard

+Eric_writting
	jsr ReadKeyNoBounce
	bne cont2
retme2
	rts
cont2

	; Check if it is RETURN  ($0d)
	cmp #$0d
	bne writechar

	; Eric finished writting
	lda Eric_flags
	and #(ERIC_WRITTING^$ff)
	sta Eric_flags
	lda #0
	jsr setEric_state

writechar
	sta tmp+1
	; Check if it is a character
	cmp #32
	bcc retme2
/*
	beq uppercase

	; Is it uppercase or not?
	ldy #7
	lda #%00010000
	and KeyBank,y
	sta tmp
	ldy #4
	lda #%00010000
	and KeyBank,y
	ora tmp
	bne	uppercase

	; Lowercase it
	lda tmp+1
	cmp #"A"
	bcc uppercase
	cmp #"Z"+1
	bcs uppercase
	ora #32
	sta tmp+1
uppercase
*/
	ldx #0
	jsr get_blackboard

	; Note what Eric writes down
	ldy #11
	lda (tmp3),y
	sta tmp
	bmi dowrite
	cmp #4
	beq dowrite
	; Save the written char
	; on the buffer
	clc
	adc #7
	tay
	lda tmp+1
	cmp #32 ; If it is an space, ignore
	beq dowrite
	sta (tmp3),y
	inc tmp
	lda tmp
	ldy #11
	sta (tmp3),y
dowrite
	lda tmp+1
	jsr write_char_board_ex
risearm
/*	lda #9
	cmp anim_state
	beq flop
	.byt $2c
flop
	lda #10
	jmp setEric_state
*/
	lda #9
	jmp setEric_state
.)

fire_Eric
.(
	; Is Eric's catpult pellet already fired?
	ldy #CHAR_EPELLET
	lda pos_col,y
	bmi notfired
	; It is already flying, so return
	rts
notfired
	; Prepare the flag number to set
	lda #ERIC_FIRING
	sta tmp
	; And the animatory state
	lda #11
	sta tmp+1
	; And the action timer
	lda #24
	sta tmp0

	; This entry point is used when Eric is hitting, writting or firing
+realize_Eric_action
	lda Eric_flags
	bpl cont
	; Eric is lying down or sitting
	rts
cont
	; Set the appropriate flag
	lda tmp
	sta Eric_flags

	; Set the action timer
	lda tmp0
	sta Eric_timer

	; Save Eric's animatory state into byte 102 (dest_x variable)
	lda anim_state
	sta dest_x

	; Now set the animatory state
	lda tmp+1
	jmp setEric_state
.)


fire_Eric2
.(
	; Check if Eric has finished firing the catpult?
	dec Eric_timer
	bne cont
	jmp endpunch	; Re-use this entry point
cont
	lda Eric_timer
	; Is it 18? then next step of fire
	cmp #18
	bne nonext
	; First stage
	lda #12
	jmp setEric_state
nonext
	; Stat lowering the catpult?
	cmp #6	
	bne nolower
	lda #11
	jmp setEric_state
nolower
	; Time to launch the pellet?
	cmp #12
	beq launch
	rts
launch
	; This code is to let the player decide *when* to launch
	; the pellet, when he releases the F key.
	lda KeyBank+1
	and #%00001000
	beq doit
	inc Eric_timer
	rts
doit
	; Launch the pellet, reprimands, etc.
	lda #NO_CATAPULTS
	jsr punish_Eric

	jsr SndFire

	; this entry point is used when Boy Wander fires his catapult too
	; the ID of the pellet (Boy Wander's or Eric's) is passed on reg Y
	; and the ID of the character in reg X
	ldy #CHAR_EPELLET
	ldx #0

+launch_pellet
	cpx #0
	bne noteric
	jsr flash_border
noteric
	lda pos_col,x
	sta pos_col,y
	lda pos_row,x
	sta pos_row,y

	lda #<s_usc_pelleth
	sta uni_subcom_low,y
	lda #>s_usc_pelleth
	sta uni_subcom_high,y

	; Initialize distance to travel
	lda #18
	sta var7,y

	; Initialize animatory state
	lda flags,x
	eor flags,y
	and #IS_FACING_RIGHT
	beq s1
	stx savx+1
	tya
	tax
	jsr change_direction
savx
	ldx #1
s1
	rts
.)


hit_Eric
.(
	lda #7
	sta tmp+1
	lda #ERIC_HITTING
	sta tmp
	lda #18-8
	sta tmp0
	jmp realize_Eric_action
.)

hit_Eric2
.(
	; Check if Eric has finished the punch
	dec Eric_timer
	beq endpunch
	
	lda Eric_timer
	; Is it 12? then next step of punch
	cmp #12-4
	bne nonext
	; First stage
	lda #8

	; Entry point from other routines...
	; such as firing with the catpult.
+setEric_state
	stx savx+1
	ldx #CHAR_ERIC
	jsr update_animstate
savx
	ldx #0
	rts
nonext
	; is it time to see if anybody was hit?
	cmp #11-4
	beq completed
	rts
completed
	stx savx2+1

	; Check if anyone was hit
	ldx #CHAR_ERIC
	jsr check_hit
	bmi nobody
#ifndef OTHERS_DOSND
	jsr SndHit
#endif

savx2
	ldx #0

#ifndef EINSTEIN_LIES
	; Check if we hit Einstein
	cpy #CHAR_EINSTEIN
	bne notEinstein
	inc Einstein_was_hit
	bne nobody	; Always jumps
notEinstein
#endif
	; We can check here if it was
	; angelface and increase in 30
	; the score
	cpy #CHAR_ANGELFACE
	bne nobody
	lda #3
	jsr add_score
nobody
	; Make a sound effect
	; Check for reprimands

	lda #NO_HITTING
	jmp punish_Eric
+endpunch
	; This should go to a subroutine?
	lda #0
	sta tmp
	lda #1	; Can't be zero, or it will be decremented to $ff!
	sta tmp0
	lda dest_x	; Old animatory state
	sta tmp+1

	jmp realize_Eric_action
.)

knock_Eric
.(
	lda Eric_knockout
	beq justknocked

	; Time to decrement timer
	dec Eric_knockout
	beq cangetup
	; Jump to make a sound if Eric
	; has jut been knocked down
	; then return
	rts
cangetup
	; Reset bit 4, wo we don't keep
	; visiting this routine, but also
	; keep bit 7 (Eric is lying).
	; It is better to do it this way, than with
	; an and and an or.
	lda #128
	sta Eric_flags
	rts
justknocked
	; Eric has jut been kocked. Initialize everything

	jsr SndKnocked
	; First the counter
	lda #40
	sta Eric_knockout
	; Then the status flags (set bits 7 and 4)
	lda #144
	sta Eric_flags
	
	; Get anim state to differentiate between
	; beking knocked down from a chair or by a
	; punch/pellet
	lda anim_state
	cmp #4
	beq sat
	lda #6
	.byt $2c
sat
	lda #5
	jmp setEric_state
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make any nearby teacher give ERIC lines if 
; necessary.
; Used by the routine deal_with_Eric. 
; Checks whether ERIC is somewhere he 
; shouldn't be, or sitting or standing 
; when or where he shouldn't be, or lying down,
; and makes any nearby teacher give lines 
; accordingly.  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
teacher_gives_lines
.(
	; Check (and decrement) the lines-giving 
	; delay counter, and proceed only if it was 
	; <75 (the counter starts off at 0 for a new 
	; game, and is set to 150 by this routine 
	; after ERIC has been given lines)


	; This has changed, as giving lines has been defered
	; to the main loop. Also the routine is simplified.

	lda lines_delay
	beq proceed
	dec lines_delay
	; This is only if other teacher may give
	; lines. For now we will comment this out
	;cmp #75
	;bcc proceed
	rts
proceed	
/*
	; It is time to give lines, go for it...
	; Let's start checking if he is jumping
	; as it may give trouble with Y coordinate
	ldy pos_row

	lda Eric_flags
	and #ERIC_JUMPING
	beq notjumping
	iny
notjumping
	; Now we have in Y the Y coordinate
	; (row) adjusted.
	
	; Get pointer to region table, and check
	; if Eric is on a staircase at the same time.
	tya
	ldy #0
	cmp #3
	beq cont
	; Not on the top floor
	iny
	cmp #10
	beq cont
	; Not on the middle floor
	iny
	cmp #17
	beq cont
	; Eric is on a staircase
	; Put 7 in tmp for later
	lda #7 
	sta tmp

	; Check if he is not sitting
	lda Eric_flags
	and #ERIC_SITTINGLYING
	beq check_validity
	
	; He is sitting, make any nearby teacher
	; punish him
	lda #SIT_STAIRS
	jmp do_punishment	; Branches always

cont
	; Prepare pointer to region table
	lda tab_regionslo,y
	sta tmp0
	lda tab_regionshi,y
	sta tmp0+1
	lda tab_ridslo,y
	sta tmp1
	lda tab_ridshi,y
	sta tmp1+1

	; Check col
	lda pos_col
	ldy #0
loop
	cmp (tmp0),y
	iny
	bcs loop
	; Point at the correct entry
	dey
	; Get the region ID
	lda (tmp1),y
	sta tmp
*/
	;;;  ***** THIS VERSION MAY BE SMALLER ******

/*
	; It is time to give lines, go for it...
	; Let's start checking if he is jumping
	; as it may give trouble with Y coordinate
	lda Eric_flags
	and #ERIC_JUMPING
	sta smc_jumpflag+1
	beq notjumping
	inc pos_row
*/


	; If jumping, punishment would be 'YOU ARE NOT A KANGAROO'
	lda Eric_flags
	and #ERIC_JUMPING
	beq notjumping
	rts
notjumping
	; Now we have in Y the Y coordinate
	; (row) adjusted.
	; Is Eric on a staircase?
	ldx #CHAR_ERIC
	jsr is_on_staircase
	beq not_on_stairs
	; Put the region ID for later
	lda #7
	sta tmp
	; Check if he is not sitting
	lda Eric_flags
	and #ERIC_SITTINGLYING
	beq check_validity
	
	; He is sitting, make any nearby teacher
	; punish him
	lda #SIT_STAIRS
	jmp do_punishment	; Branches always

not_on_stairs
	; Prepare pointer to region table
	jsr s_check_Eric_loc
	lda (tmp1),y
	sta tmp

/*
	; Put the Y coordinate back as it was
smc_jumpflag
	lda #0
	beq notjumping2
	dec pos_row
notjumping2
*/

check_validity
	; At this point we have in tmp an ID of the
	; region Eric is at (7 includes he is on a staircase).
	lda tmp
	bne notprivate

	; The room is private.
	lda #ROOM_PRIVATE
	jmp do_punishment	
notprivate
	; See if Einstein had a chance to grass on Eric for
	; being absent, or dinner has started, or this is 
	; PLAYTIME or REVISION LIBRARY
	lda lesson_status
	bpl nochanceyet

check_location
	; Compare region and lesson IDs
	lda lesson_descriptor
	and #%111
	cmp tmp
	beq iswhereshould
	lda #GO_CLASS
	jmp do_punishment
iswhereshould
	; Pick again the lesson status flags
	lda lesson_status
	; Set carry if Eric's lesson started with Eric
	; being present
	asl
	asl
strange_entry
	lda anim_state
	bcc notstarted
	; Is Eric sitting in a chair?
	cmp #4
	bne notsitting
	; He is, nothing to be done
retme
	rts
notsitting
	; Aha!, punish him
	lda #FIND_SEAT
	jmp do_punishment
notstarted
	;lda anim_state
	cmp #5
	bcc retme 
	cmp #7
	bcs retme
	; He is on the floor
	lda #OFF_FLOOR
	jmp do_punishment
nochanceyet
	; Bit 7 of lesson_status is reset, which means
	; EINSTEIN has not yet had a chance to grass 
	; on ERIC for being absent at the start of the
	; lesson, or dinner has not started yet, or 
	; this is PLAYTIME or REVISION LIBRARY.

	; Is Eric in a room?
	lda #4
	cmp tmp
	bcc strange_entry
	
	; Have a look at the lesson_clock
	lda #CLASS_START	
	cmp lesson_clock+1
	bcc strange_entry
	bcs check_location

do_punishment
	; Time for a teacher to punish Eric. 
	; A holds the message ID
	sta smc_sav_msg+1

/*
	; Is it too soon for the same teacher to dish Eric?
	lda #0
	sta flag_kludge+1
	lda lines_delay
	beq notsoon
	
	; We need to patch so this teacher does not see
	; Eric.
	; Get the teacher who last gave lines to Eric
+smc_teachpun
	ldy #0
	lda pos_col,y
	sta smc_savcol+1
	lda #255
	sta pos_col,y
	inc flag_kludge

	; Is a teacher in range?
	stx savx+1
	ldx #0
	jsr can_be_seen
savx
	ldx #0
	bcc finish_this

	; Okay, time to give lines (at last!)
notsoon
	; Re-initialize the delay counter
	ldy #150
	sty lines_delay
	; Get the reason code back
smc_sav_msg
	lda #0
	jsr punish_Eric

finish_this
	; Put the teacher's coordinate back, if necessary
flag_kludge
	lda #0
	beq noadjust
smc_savcol
	lda #0
	ldy smc_teachpun+1
	sta pos_col,y
noadjust
	rts
*/
	; Get the teacher who is to give lines to
	; Eric and adjust message if he is his teacher
	; for this period (so he must be chasing him 
	; for being absent).

	; Is the current punish message the GET TO WHERE
	; YOU SHOULD BE? (GO_CLASS)

	cmp #GO_CLASS
	bne finishthis

	; Get the teacher who may give lines in reg A
	jsr can_be_seen
	bcs proceed2

	; No one saw Eric
	rts

proceed2
	sta tmp

	; Get Eric's current teacher
	lda lesson_descriptor
	lsr
	lsr
	lsr
	lsr
	tay
	lda table_teacher_codes,y
	cmp tmp
	bne finishthis

	; Okay it is his teacher, so the message may 
	; change according to the lesson flags

	lda #COME_ME
	sta smc_sav_msg+1

	lda lesson_status
	and #%100000
	bne notfirsttime

	lda lesson_status
	ora #%100000
	sta lesson_status
	jmp finishthis
notfirsttime
	lda lesson_status
	and #%10000
	bne notsecond

	lda lesson_status
	ora #%10000
	sta lesson_status
	lda #HURRY_UP
	sta smc_sav_msg+1
	jmp finishthis
notsecond
	lda #MY_PATIENCE
	sta smc_sav_msg+1

finishthis
/*
	; Re-initialize the delay counter
	ldy #150
	sty lines_delay
	; Get the reason code back
smc_sav_msg
	lda #0
	jmp punish_Eric
*/

	; Defer any punisment so it is issued
	; after the screen has been updated.
	; Else it will seem as given too early.

	inc need_to_punish_Eric+1
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Deal with ERIC
; Called from the main loop.
; Deals with ERIC when any of bits 0-4 at ERIC's status flags are set. 
; Returns with the carry flag set if and only if ERIC was dealt with, 
; indicating that there is no need to check keypresses in the main loop.  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

deal_with_Eric
.(
	;Make any nearby teachers give ERIC lines if he's 
	;not where he should be, or standing or sitting 
	;when or where he shouldn't be 

	jsr teacher_gives_lines

	;Check ERIC's status flags and return with 
	;the carry flag reset unless ERIC has been 
	;knocked over, or he is firing, hitting, 
	;jumping, or being spoken to 

	lda Eric_flags
	and #%00011111
	bne takecare
	clc
	rts

takecare

/*
	;Is ERIC being spoken to by a little boy? 
	lda Eric_flags
	and #ERIC_SPOKEN
	beq notspoken

	sec
	rts
notspoken
	;Has ERIC been knocked over? 
	lda Eric_flags
	and #ERIC_DOWN
	beq noknock
	jsr knock_Eric
	sec
	rts
noknock
	;Is ERIC firing a catapult? 
	lda Eric_flags
	and #ERIC_FIRING
	beq nofire
	jsr fire_Eric2
	sec
	rts
nofire
	;Is ERIC hitting? 
	lda Eric_flags
	and #ERIC_HITTING
	beq nohit
	jsr hit_Eric2
	sec
	rts
nohit
	;ERIC is jumping; deal with him accordingly 
	jsr jump_Eric2	
	sec
	rts
*/
	ldy #4
loop
	lda Eric_flags
	and tab_dE_flags,y
	beq notthis
	; Flag found
	lda tab_dE_routl,y
	sta smc_routine+1
	lda tab_dE_routh,y
	sta smc_routine+2
smc_routine
	jsr $1234
	sec
	rts
notthis
	dey
	bpl loop
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Checks if a teacher must give Eric
;; lines. The reason is passed in reg A.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
punish_Eric
.(
	; Save the reprimand message identifier
	sta sava+1

	; Can Eric be seen by a teacher?
	stx savx+1
	ldx #CHAR_ERIC
	jsr can_be_seen
	bcs punish_him
savx
	ldx #0
	rts
punish_him
	; Time for lines and reprimands
	; Save the teacher code (this is a kludge)
	;sta smc_teachpun+1
	ldy #CHAR_ERIC
	tax
	; Get back the reprimad message identifier
sava
	lda #0
	jsr give_lines

	; Re-initialize the delay counter
	ldy #LINES_DELAY_VAL
	sty lines_delay

	ldx savx+1
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if jumping Eric has touched
; a shield or the safe.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
shield_check_jump
.(
	lda pos_row
	sta op1
	lda pos_col
	sta op1+1

	; Check if Eric is looking right
	lda flags
	and #IS_FACING_RIGHT
	beq skip
	inc op1+1
	inc op1+1
skip
	dec op1
	jsr check_shield_hit2
	dec op1+1
	jmp check_shield_hit2
.)
