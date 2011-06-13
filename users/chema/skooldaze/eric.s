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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if a character is on a staircase
; return with Z=0 if that is the case
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_on_staircase
.(
	lda pos_row,x
	cmp #3
	beq end
	cmp #10
	beq end
	cmp #17
end
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the Eric main action timer
; to the appropriate value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_Eric_timer
.(
	ldy #7
	lda #%00010000
	and KeyBank,y
	bne quick
	lda #NORMAL_ERIC_TIMER
	.byt $2c
quick
	lda #FAST_ERIC_TIMER
	sta Eric_timer
	sta Eric_mid_timer
	rts
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
	cpy #WALLTOPFLOOR+2
	bne proceed
	rts
middle
	cpy #WALLMIDDLEFLOOR+1
	bne otherwall
	rts
otherwall
	cpy #WALLMIDDLEFLOOR2+2
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
	cpy #WALLTOPFLOOR
	bne proceed
	rts
middle
	cpy #WALLMIDDLEFLOOR-1
	bne otherwall
	rts
otherwall
	cpy #WALLMIDDLEFLOOR2
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
	bne facingright
	; If so turn him round
	jmp change_direction
facingright
	; Move him up a stair
	jmp up_a_stair
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
	jmp doit2
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
	jmp doit2
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
	bne notstaircase
doit2
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

  	jsr s_check_chair	; Returns Z=1 if there is a chair and C=1 if the 
						; character needs to turn round
	bne notyet
	jmp s_knock_and_sit; s_sit_char
notyet
	; Then sit on the floor
	lda #5
	jmp update_animstate
.)

jump_Eric
.(


	rts
.)


write_Eric
.(

	rts
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
	; Launch the pellet, reprimands, etc.
	lda #NO_CATAPULTS
	jsr punish_Eric

	; this entry point is used when Boy Wander fires his catapult too
	; the ID of the pellet (Boy Wander's or Eric's) is passed on reg Y
	; and the ID of the character in reg X
	ldy #CHAR_EPELLET
	ldx #0

+launch_pellet
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
	lda #18
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
	cmp #12
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
	cmp #11
	beq completed
	rts
completed
	stx savx2+1

	; Check if anyone was hit
	ldx #CHAR_ERIC
	jsr check_hit
	bmi nobody
	
savx2
	ldx #0

	; We can check here if it was
	; angelface and increase in 30
	; the score

nobody
	; Make a sound effect
	; Check for reprimands

	lda #NO_HITTING
	jsr punish_Eric

	rts
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

; Deal with ERIC
; Called from the main loop.
; Deals with ERIC when any of bits 0-4 at ERIC's status flags are set. 
; Returns with the carry flag set if and only if ERIC was dealt with, 
; indicating that there is no need to check keypresses in the main loop.  

deal_with_Eric
.(
	;Make any nearby teachers give ERIC lines if he's 
	;not where he should be, or standing or sitting 
	;when or where he shouldn't be 

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
	;Is ERIC being spoken to by a little boy? 
	
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

	sec
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Checks if a teacher must give Eric
;; lines. The reason is passed in reg A
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

	ldy #CHAR_ERIC
	tax
	; Get back the reprimad message identifier
sava
	lda #0
	jsr give_lines


	ldx savx+1
	rts
.)



