;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Scripting routines
;; --------------------

#include "params.h"
#include "script.h"
#include "text.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Auxiliar functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Make a character speak the message
; pointed by tmp0

; This is part of routine
; 31996 Make a teacher tell the kids to go 
; to a certain page in their books

s_make_char_speak
.(
	lda tmp0
	sta var3,x
	lda tmp0+1
	sta var4,x

	lda #<s_isc_speak1
	sta i_subcom_low,x
	sta tmp0
	lda #>s_isc_speak1
	sta i_subcom_high,x
	sta tmp0+1
	jmp (tmp0)
.)

; Make a character stand up, if he is not already
s_stand_up
.(
	lda anim_state,x
	cmp #4	; Is he sat on a chair?
	beq doit
	cmp #5	; Sat on the floor?
	beq doit
	cmp #6	; Lying on the floor?
	beq doit
	rts
doit
	; Change animatory state
	lda #0
	sta anim_state,x

	jsr update_SRB_sp
	lda base_as_pointer_low,x
	sta as_pointer_low,x
	lda base_as_pointer_high,x
	sta as_pointer_high,x
	jmp update_SRB_sp
.)

; Get flag byte and bitmask for a given event ID
; and store in y and a
s_get_flagbyte
.(
	pha
	and #%111
	tay
	lda tab_bit8,y	; Get bitmask
	sta smc_bitmask+1
	; Prepare pointer to correct flag byte
	pla
	lsr
	lsr
	lsr
	tay
smc_bitmask
	lda #0
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Used by the routines at 27772 and 27823. Knocks 
;; the current occupant (if any) out of the chair 
;; next to the character looking for a seat.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_knock_and_sit
.(
	; check if there is someone sat, and knock him
	ldy #CHAR_FIRST_TEACHER-1	; Start with little boy 11
loop
	lda pos_col,x
	cmp pos_col,y
	bne next
	lda pos_row,x
	cmp pos_row,y
	bne next

	lda anim_state,y
	cmp #4
	bne next	; He was not sat.
	; There is one already at this seat
	; Dethrone him!

	; Put the character index in X temporary
	stx savx+1
	sty savy+1
	ldx savy+1

	inc anim_state,x
	jsr update_SRB_sp
	lda as_pointer_low,x
	clc
	adc #16
	sta as_pointer_low,x	
	bcc nocarry
	inc as_pointer_high,x
nocarry
	jsr update_SRB_sp
savx
	ldx #0
savy
	ldy #0

	; Check if the character was Eric
	;cpy #0
	beq isEric

	; A character was dethroned and it was not Eric
	; Check if it has an uninterruptible subcommand


	lda uni_subcom_high,y
	beq tofloor
	
	; Seek for another chair
	lda #<s_usc_lchair
	sta uni_subcom_low,y
	lda #>s_usc_lchair
	sta uni_subcom_high,y
	stx savx2+1
	sty savy2+1
	ldx savy2+1
	jsr step_character
savx2
	ldx #0
savy2
	ldy #0

	
tofloor
	; Place the correspondant uninterruptible subcommand
	lda #<s_usc_dethroned1
	sta uni_subcom_low,y
	lda #>s_usc_dethroned1
	sta uni_subcom_high,y
	bne	thatsall	; This jumps always

isEric
	; It was Eric, signal he's been knocked out
	lda Eric_flags
	ora #ERIC_SITTINGLYING
	sta Eric_flags
	bne thatsall
next
	dey
	bpl loop

thatsall


.)
s_sit_char
.(
	; Terminate uninterruptible subcommand
	; Avoid doing anything with Eric
	;cpx #0
	;beq isEric
	lda #0
	sta uni_subcom_high,x
isEric	
	; Change animatory state
	lda #4
	sta anim_state,x

	jsr update_SRB_sp
	lda base_as_pointer_low,x
	clc
	adc #64
	sta as_pointer_low,x
	lda base_as_pointer_high,
	adc #0
	sta as_pointer_high,x

	jmp update_SRB_sp
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Check whether a character is beside a chair
;; Returns with the zero flag set if the character 
;; is standing beside a chair. Returns with the carry 
;; flag set if the character should turn round. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_check_chair
.(
	; Get the direction the character is facing
	lda flags,x
	and #IS_FACING_RIGHT
	bne facing_right
.(
	; The character faces left, now check for seats...
	; Get y-coordinate and check for floor.
	lda pos_row,x
	cmp #3	; top floor
	bne middle_floor


	; We are on the top floor
	; check the chair coordinates
	lda pos_col,x
	cmp #WALLTOPFLOOR
	bcs rmp	; We are to the right of the map room wall

	; We are in the reading room
	cmp #CH_READL	; x-coord of the leftomst chair
	bcs noret1
	; Return with the carry set
	sec
	rts
noret1
	cmp #CH_READR	; x-coord of the rightmost chair
ppp
	bcc maybe1
	; Return with carry clear
	clc
	rts
maybe1
	; Valid seats in even coords..
	and #%00000001
	rts	; Return with zero flag set if we are beside a chair
rmp
	; We are in the map room
	cmp #CH_MAPL
	bcs notyet2
	sec
	rts
notyet2
	cmp #CH_MAPR
	jmp ppp

middle_floor
	; Character is somewhere in the middle floor
	lda pos_col,x
	cmp #WALLMIDDLEFLOOR
	bcs exam_room
	; We are in the white room
	cmp #CH_WHITEL
	bcs noret2
	sec
	; Return with carry set
	rts
noret2
	; Trick to reuse code...
	;clc
	;adc #1
	cmp #CH_WHITER
	jmp ppp
exam_room
	; Ok we are in the exam room
	cmp #CH_EXAMBL
	bcs notyet3
	sec
	rts
notyet3
	cmp #CH_EXAMAL
	bcc otherset

	cmp #CH_EXAMAR
/*	bcs notyet4
	sec
	rts
notyet4*/
	jmp ppp

otherset
	; The character is to the left of the first set of charis
	; Trick to reuse code... Unnecessary here?
	;clc
	;adc #1
	cmp #CH_EXAMBR
	jmp ppp
.)
facing_right
.(
	; We are facing right
	lda pos_row,x
	cmp #3	; Top floor
	bne middle_floor
	lda pos_col,x
	cmp #WALLTOPFLOOR
	bcs rmp

	cmp #CH_READR
ppp2
	clc
	beq noret
	rts	;Return unless the character is beside the rightmost chair in the room
noret
	; Reset zero and set carry flags
	lda #1
	sec
	rts
rmp
	cmp #CH_MAPR
	jmp ppp2

middle_floor
	; Somewhere in the middle floor
	lda pos_col,x
	cmp #WALLMIDDLEFLOOR
	bcs notyet
	cmp #CH_WHITER
	jmp ppp2
notyet
	cmp #CH_EXAMAR
	jmp ppp2
.)
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Terminate an interrubtible subcommand
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
terminate_subcommand
.(
	lda #0
	sta i_subcom_high,x
	jmp check_reset_cl
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main Script Commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Terminate and stop there
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_dinner_duty
s_end_game
s_ctrl_einstein1
s_ctrl_einstein2
s_end
.(
  rts
.)



s_2000lines_eric
s_tell_enistein
s_tell_angelface
s_tell_boywander
s_find_eric
s_follow_boy1
s_goto_random_trip
s_write_bl
.(
	inc pcommand,x
	rts
.)



s_do_class
.(
	rts
.)
s_write_bl_c
.(
	inc pcommand,x
	inc pcommand,x
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Activate a continual subcommand (scommand)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_set_csubcom
.(
	inc pcommand,x
	inc pcommand,x
	inc pcommand,x
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher tell the kids to sit down
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

tab_sit_msg
	.byt SIT_NASTY, SIT_CHERUBS, SIT_CANE, SIT_CHAPS

s_msg_sitdown
.(
	; Move to the next command
  	inc pcommand,x

	; Get the appropriate message
	lda #<sit_messages
	sta tmp0
	lda #>sit_messages
	sta tmp0+1

	txa
	sec
	sbc #CHAR_FIRST_TEACHER
	tay
	lda tab_sit_msg,y

	jsr search_string

	jmp s_make_char_speak
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character find a seat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_find_seat
.(
	lda #<s_usc_lchair
	sta uni_subcom_low,x
	sta tmp0
	lda #>s_usc_lchair
	sta uni_subcom_high,x
	sta tmp0+1
	inc pcommand,x
	jmp (tmp0)
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character go to a random location
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_goto_random
.(
	; Reset flags for fast or slow (continuous) walk	
	lda flags,x
	and #((IS_FAST_WALK|IS_SLOW_CONTINUOUS)^$ff);#%10011111
	sta flags,x
+s_goto_random_ex	; Entry point for routine s_goto_random_trip

	; Generate a random number, and get an entry from the
	; table of possible locations
	jsr randgen
	and #%00000110
	tay
	lda tab_locs,y
	sta dest_y,x
	lda tab_locs+1,y
	sta dest_x,x
	
	; Prepare a pointer to command execution
	
	lda #>s_goto_ex3
	sta cur_command_high,x
	lda #<s_goto_ex3
	sta cur_command_low,x

	inc pcommand,x
	
	jmp s_goto_ex2
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Restart command list until it is time to start a lesson
; or dinner
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_restart_nodinner
s_restart_nolesson
.(
	lda lesson_clock+1	; Get the high byte of the lesson clock
	cmp #CLASS_START
	bcs s_restart		; Keep s_restart nearby!
	inc pcommand,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Restart the command list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_restart
.(
	lda #0
	sta pcommand,x
	sta cur_command_high,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Flag an event (event ID)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_flag_event
.(
	; Get event to set
	inc pcommand,x
	ldy pcommand,x
	lda (tmp0),y

	; Get byte and bitmask
	jsr s_get_flagbyte

	; Set it
	ora lesson_status,y
	sta lesson_status,y

	; Advance the command pointer 
	inc pcommand,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Unflag (reset) an event (event ID)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_unflag_event
.(
	; Get event to reset
	inc pcommand,x
	ldy pcommand,x
	lda (tmp0),y

	; Get byte and bitmask
	jsr s_get_flagbyte
	eor #$ff

	; Reset it
	and lesson_status,y
	sta lesson_status,y

	; Advance the command pointer 
	inc pcommand,x
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character walk up and down a few times or until a certain time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_walk_updown
.(
	lda #>s_mini_walkabout
	sta cur_command_high,x
	lda #<s_mini_walkabout
	sta cur_command_low,x

	; Get params, tmp0 has been set by the caller...
	ldy pcommand,x
	iny
	lda (tmp0),y
	sta var1,x		; Mini walkabouts to perform
	ldy pcommand,x
	iny 
	lda (tmp0),y	; This is always zero!!!
	sta dest_y,x	; byte 101 is used for this purpose too...

	; Advance the command pointer
	inc pcommand,x
	inc pcommand,x
	inc pcommand,x

	; Reset flags for fast or slow (continuous) walk	
	lda flags,x
	and #((IS_FAST_WALK|IS_SLOW_CONTINUOUS)^$ff);#%10011111
	sta flags,x
	
	jmp s_move_until_ex	; First mini-walkabout

.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Send a character on a mini-walkabout
; This is not directly related to any script command
; but used by s_walk_updown
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_mini_walkabout
.(
	dec var1,x
	bne s_move_until_ex
	
	; Done, terminate this command and return
	lda #0
	sta cur_command_high,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move until a certain event occurs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_move_until
.(
	; Prepare a pointer to command execution and get params...

	lda #>s_move_until_ex
	sta cur_command_high,x
	lda #<s_move_until_ex
	sta cur_command_low,x

	; Get params, tmp0 has been set by the caller...
	ldy pcommand,x
	iny 
	lda (tmp0),y
	sta dest_y,x	; byte 101 is used for this purpose too...

	; Advance the command pointer
	inc pcommand,x
	inc pcommand,x

	; Reset flags for fast or slow (continuous) walk	
	lda flags,x
	and #((IS_FAST_WALK|IS_SLOW_CONTINUOUS)^$ff);#%10011111
	sta flags,x

+s_move_until_ex

	lda dest_y,x	; Get the event identifier
	beq cont		; If it is event 0, just move until command is restarted	
	jsr s_get_flagbyte
	and lesson_status,y
	beq cont
	
	; The time has come to stop moving about. However, 
	; before we move on in the command list, the character needs 
	; to return to the walkabout origin.

	lda dest_x,x	; Get the x coordinate of the origin
	cmp pos_col,x	; Is the character at the origin?
	bne miniw
	
	; It is, terminate the command and return
	lda #0
	sta cur_command_high,x
	rts
miniw
	; Fill in the new walkabout destination (either the origin or 
	; some location within 7 spaces to the left of the origin)
	sta var3,x	; destination col for the subcommand s_isc_int_dest
	lda #30		; counter with enough time
	sta var4,x	; time during which the subcommand is under control
	
	; Place the interruptible subcommand
	lda #<s_isc_int_dest
	sta i_subcom_low,x
	sta tmp0
	lda #>s_isc_int_dest
	sta i_subcom_high,x
	sta tmp0+1

	jmp (tmp0)
cont
	; The signal has not been raised yet, so it's time for another mini-walkabout.
	jsr randgen
	and #7
	sec
	sbc #7	; -7<= a <=0
	clc
	adc dest_x,x
	jmp miniw
.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character go to a given location
; The character is passed in reg X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_goto
.(
	; Prepare a pointer to command execution and get params...

	lda #>s_goto_ex3
	sta cur_command_high,x
	lda #<s_goto_ex3
	sta cur_command_low,x

	; Get params, tmp0 has been set by the caller...
	ldy pcommand,x
	iny 
	lda (tmp0),y
	sta dest_y,x
	iny
	lda (tmp0),y
	sta dest_x,x

	; Advance the command pointer
	inc pcommand,x
	inc pcommand,x
	inc pcommand,x

+s_goto_ex
	; Reset flags for fast or slow (continuous) walk	
	lda flags,x
	and #((IS_FAST_WALK|IS_SLOW_CONTINUOUS)^$ff);#%10011111
	sta flags,x

+s_goto_ex2
	jsr s_stand_up
+s_goto_ex3
	
	; Is the character at the same floor as the destination?
	lda pos_row,x
	cmp dest_y,x
	bne notsamefloor
	jmp s_goto_samefloor
notsamefloor
	; Not on the same floor, have to figure out how to reach
	; the destination
	; Is it on the top floor?
	cmp #3
	bne notop
	jmp s_goto_fromtopfloor
notop
	;Is it on the bottom floor?
	cmp #17
	bne wasmiddle
	jmp s_goto_frombottomfloor
wasmiddle
	; To top floor or bottom floor?
	lda dest_y,x
	cmp #17
	beq gobottomfloor

	; going to the top floor...
	lda dest_x,x
	cmp #WALLTOPFLOOR
	bcs rightside 
	; Should take stairs at STAIRLBOTTOM
	lda pos_col,x
	cmp #WALLMIDDLEFLOOR
	bcc	take_left_stair_up
	; But they are not reachable from here...
	jmp take_right_stair_down

+take_left_stair_up
	; Is the char already there?
	cmp #STAIRLBOTTOM
	bne notatstair1
	; Tell him to go upstairs
	lda #<s_isc_up_stair
	sta i_subcom_low,x
	sta tmp0
	lda #>s_isc_up_stair
	sta i_subcom_high,x
	sta tmp0+1
	lda #15	; 15 movements to deal with a stair
	sta var4,x
	jmp (tmp0)

notatstair1
	; Send it there
	lda #STAIRLBOTTOM
	jmp setdest

rightside
	; Should take stairs at STAIRRBOTTOM
	lda pos_col,x
	cmp #WALLMIDDLEFLOOR
	bcs	take_right_stair_up
	; But they are not reachable from here
	jmp take_left_stair_down

+take_right_stair_up
	; Is the char already there?
	cmp #STAIRRBOTTOM
	bne notatstair2
	; Tell him to go upstairs
	lda #<s_isc_up_stair
	sta i_subcom_low,x
	sta tmp0
	lda #>s_isc_up_stair
	sta i_subcom_high,x
	sta tmp0+1
	lda #15	; 15 movements to deal with a stair
	sta var4,x
	jmp (tmp0)
notatstair2
	; Send it there
	lda #STAIRRBOTTOM
	jmp setdest

gobottomfloor
	; This is easy, take the nearest stair
	lda pos_col,x
	cmp #WALLMIDDLEFLOOR
	bcc	take_left_stair_down
+take_right_stair_down
	lda #STAIRRTOP
	.byt $2c
+take_left_stair_down
	; Already there?
	lda #STAIRLTOP
	cmp pos_col,x
	bne notatstair3
	; Tell him to go downstairs
	lda #<s_isc_down_stair
	sta i_subcom_low,x
	sta tmp0
	lda #>s_isc_down_stair
	sta i_subcom_high,x
	sta tmp0+1
	lda #15	; 15 movements to deal with a stair
	sta var4,x
	jmp (tmp0)
notatstair3
	; Send it there
	jmp setdest
.)


s_goto_samefloor
.(
	; Has the character reached the destination yet?
	lda pos_col,x
	cmp dest_x,x
	bne figureoutmove
	
	; It has... check midstride and other matters here...
	; Mark command as finished
	lda #0
	sta cur_command_high,x
	rts
figureoutmove
	; It hasn't... figure out which would be the next move then...
	; Is the character on the bottom floor?
	lda #17
	cmp pos_row,x
	bne notbottomfloor
	; It is... send it to the destination
	jmp setdest1
 notbottomfloor
	; It is not on the bottom floor... maybe middle?
	lda #10
	cmp pos_row,x
	bne topfloor
	; It is in the middle floor...
	lda #WALLMIDDLEFLOOR
	.byt $2c
topfloor
	; Is it left or right to the wall in the middle of the floor?
	lda #WALLTOPFLOOR
	cmp pos_col,x
	bcs leftside
	; It is at the right side
	cmp dest_x,x
	bcc setdest1
	; But the destination isn't
	; Send it to the staircase
	jmp take_right_stair_down 

leftside
	; It is at the left side
	cmp dest_x,x
	bcs setdest1
	; But the destination isn't
	; Send it to the staircase
	jmp take_left_stair_down; 
setdest1
	lda dest_x,x
+setdest
	pha
	lda #<s_isc_int_dest
	sta i_subcom_low,x
	sta tmp0
	lda #>s_isc_int_dest
	sta i_subcom_high,x
	sta tmp0+1
	pla
+setdestex
	sta var3,x	
	lda #9
	sta var4,x

	; Jump to the routine
	jmp (tmp0)
.)

s_goto_frombottomfloor
.(
	; Figure out which stair to use
	lda dest_y,x
	cmp #3	; top floor...
	bne midfloor
	lda #WALLTOPFLOOR
	.byt $2c
midfloor
	lda #WALLMIDDLEFLOOR
	cmp dest_x,x
	lda pos_col,x
	bcc rightstair
	; Take left stair up
	jmp take_left_stair_up
rightstair
	; take right stair up
	jmp take_right_stair_up
.)
s_goto_fromtopfloor
.(
	; Need to use the reachable stair to go down...
	lda #WALLTOPFLOOR
getdownstairs
	cmp pos_col,x
	bcc rightstair
	; Take left stair up
	jmp take_left_stair_down
rightstair
	; take right stair up
	jmp take_right_stair_down
.)


/* The spectrum version 
The address of one of the following uninterruptible subcommand routines may be present 
in bytes 111 and 112 of a character's buffer
27206 Deal with a character who has been knocked over 
27733 Deal with a character who's been dethroned (1) 
27748 Deal with a character who's been dethroned (2) 
27772 Deal with a character who is looking for a seat 
27932 Control the horizontal flight of a catapult pellet 
28102 Control the vertical flight of a catapult pellet 
28544 Make ANGELFACE throw a punch (1) 
28558 Make ANGELFACE throw a punch (2) 
28642 Make ANGELFACE throw a punch (3) 
28655 Make ANGELFACE throw a punch (4) 
28716 Make BOY WANDER fire his catapult (2) 
28733 Make BOY WANDER fire his catapult (3) 
28744 Make BOY WANDER fire his catapult (4) 
28775 Make BOY WANDER fire his catapult (5) 
28786 Make BOY WANDER fire his catapult (6) 
28799 Make BOY WANDER his fire catapult (7) 
63390 Make a character find ERIC 
*/


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deal with a character who has been dethroned (1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_dethroned1
.(
	; Delay timer before rising
	lda #4
	sta var7,x
	
	; Place the correspondant uninterruptible subcommand
	lda #<s_usc_dethroned2
	sta uni_subcom_low,x
	sta tmp0
	lda #>s_usc_dethroned2
	sta uni_subcom_high,x
	sta tmp0+1
	jmp (tmp0)
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deal with a character who has been dethroned (2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_dethroned2
.(
	; Delay timer before rising
	dec var7,x
	beq standup
	rts
standup	

	; Make him stand up
	jsr s_stand_up

	; Place the correspondant uninterruptible subcommand
	lda #<s_usc_lchair
	sta uni_subcom_low,x
	lda #>s_usc_lchair
	sta uni_subcom_high,x

	; Make him step forward once, if it is not Einstein
	cpx #CHAR_EINSTEIN
	bne stepit
	rts
stepit	
	jsr step_character
	jmp step_character
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deal with a character who is looking for a seat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_lchair
.(
	jsr s_check_chair	; Returns Z=1 if there is a chair and C=1 if the 
						; character needs to turn round
	bne notyet
	jmp s_knock_and_sit; s_sit_char
notyet
	bcc noturn
	; Turn him round...
	jmp change_direction
noturn
	; Continue looking
	jmp step_character
.)





/*
The address of one of the following continual subcommand routines will be 
present in bytes 124 and 125 of a character's buffer:
25247 RET (do nothing) 
27126 Make a little boy trip people up 
28446 Make ANGELFACE hit now and then 
28672 Make BOY WANDER fire his catapult now and then 
32234 Make a character walk fast 
64042 Check whether ANGELFACE is touching ERIC 
*/


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Interruptible subcommand routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
The address of one of the following interruptible subcommand routines 
(or an entry point thereof) may be present in bytes 105 and 106 of a 
character's buffer:
25404 Guide a character to an intermediate destination 
25484 Guide a character up a staircase 
25488 Guide a character down a staircase 
29148 Make a teacher wipe a blackboard (1) 
29175 Make a teacher wipe a blackboard (2) 
29284 Make a character write on a blackboard 
31110 Make a character speak (1) 
31130 Make a character speak (2) 
31648 Make a teacher find the truant ERIC 
31739 Move a character looking for ERIC from the midstride position 
31944 Make a teacher wait for EINSTEIN to finish speaking 

*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Guide a character to an intermediate destination 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_isc_int_dest
.(
	; Limit the amount of time this rouine is
	; under control...
	dec var4,x
	bne cont
+terminate_isc
	; Terminate this subcommand
	jmp terminate_subcommand
cont
	; Has it reached the destination?
	lda pos_col,x
	cmp var3,x
	beq terminate_isc
	
	; It hasn't, figure out next move...
	; If carry is set, then the character is to the right 
	; of the destination, if clear it is to the left.
	bcs goleft
	; Is the character facing left?
	lda flags,x
	and #IS_FACING_RIGHT
	bne facingleft
+turnit
	; It was looking the other way... turn it
	jmp change_direction
facingleft
	; Advance
	jmp step_character
goleft
	; Is the character facing right?
	lda flags,x
	and #IS_FACING_RIGHT
	bne turnit
	beq  facingleft
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Two routines for staircases... 
;; Guide a character up or down a staircase
;; For stairs first check
;; the position of the char
;; and find out the direction he should be facing...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_isc_up_stair
.(
	; First check if he is facing correctly...
	lda var4,x
	cmp #15
	bne correct

	lda pos_col,x
	cmp #STAIRLBOTTOM
	beq mustfaceleft
	; The character must face right
	lda flags,x
	and #IS_FACING_RIGHT
	bne correct
	beq turnit
mustfaceleft
	lda flags,x
	and #IS_FACING_RIGHT
	bne turnit
correct
	dec var4,x
	beq terminate_isc

+up_a_stair
	lda anim_state,x
	ror
	bcs onlystep
	jsr update_SRB_sp
	dec pos_row,x	
	jmp step_character_ex
onlystep
	jmp step_character
.)


s_isc_down_stair
.(
	; First check if he is facing correctly...
	lda var4,x
	cmp #15
	bne correct

	lda pos_col,x
	cmp #STAIRLTOP
	beq mustfaceright
	; The character must face left
	lda flags,x
	and #IS_FACING_RIGHT
	beq correct
	bne turnit
mustfaceright
	lda flags,x
	and #IS_FACING_RIGHT
	beq turnit
correct
	dec var4,x
	beq terminate_isc

+down_a_stair
	lda anim_state,x
	cpx #0	; Are we dealing with Eric?
	bne noteric
	ror 
	bcs onlystep
	bcc step_and_up
noteric
	ror
	bcc onlystep
step_and_up
	jsr update_SRB_sp
	inc pos_row,x	
	jmp step_character_ex
onlystep
	jmp step_character

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character speak (1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_isc_speak1
.(
	; Zero out var5 and var6 which normally
	; hold the address of the next character
	; in the submessage being spoken
	lda #0
	sta var5,x
	sta var6,x
	
	; This entry point is used while the 
	; character is waiting for someone else 
	; to stop speaking.
+s_isc_speak1_ex
	jsr print_speech_bubble
	bcc onscreen
	; Terminate this subcommand
	; if the character is off-screen
	jmp terminate_subcommand
onscreen
	beq free2speak
	; Set the interruptible subcommand
	; to the entry point above...
	lda #<s_isc_speak1_ex
	ldy #>s_isc_speak1_ex
	bne store	; Jumps always
free2speak
	; or to the next speak routine, if noone
	; is speaking. But first set who is speaking
	stx cur_speaking_char
	lda #<s_isc_speak2
	ldy #>s_isc_speak2
store
	sta i_subcom_low,x
	tya
	sta	i_subcom_high,x
	
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character speak (2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_isc_speak2
.(
	; Make sure the character speaks slowly
	lda #4
	sta speed_counter,x
	lda flags,x
	ora #IS_SLOW_WALK
	sta flags,x
	jsr slide_char_bubble
	bcc goeson
finished
	jsr remove_speech_bubble
	jmp terminate_subcommand
goeson
	;jsr slide_char_bubble
	;bcs finished
	rts
.)

s_isc_wipe1
s_isc_wipe2
s_isc_write

s_isc_findEric
s_isc_movemidstride
s_isc_waitEinstein
.(
	rts
.)






