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

#define        via_t1cl                $0304

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Auxiliar functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Update anim state (passed in A) for the 
; character passed in X and also update SRB
update_animstate
.(
	sta anim_state,x

	; Prepare offset for the pointers
	; which is anim_state*16
	asl
	asl
	asl
	asl
	sta smc_offset+1

	jsr update_SRB_sp
	lda base_as_pointer_low,x
	clc
smc_offset
	adc #0
	sta as_pointer_low,x
	lda base_as_pointer_high,x
	adc #0
	sta as_pointer_high,x

	jmp update_SRB_sp
.)



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

	lda #0
	sta cur_command_high,x

	lda #<s_isc_speak1
	ldy #>s_isc_speak1
	jmp call_subcommand 
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
	jmp update_animstate
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
	ldy #(CHAR_FIRST_TEACHER-1)	; Start with little boy 11
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

	lda uni_subcom_high,y
	beq tofloor

	;Make the character  search for another chair
	jmp step_character
	
tofloor
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
dethrone
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
	
	; If in demo mode, make Eric get up
	lda game_mode
	beq dethrone
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
	jmp update_animstate
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
	ldy #CH_READL	; For later search
	cmp #CH_READL	; x-coord of the leftomst chair
	bcs noret1
	; Return with the carry set
ret_cs
	sec
	rts
noret1
	cmp #CH_READR	; x-coord of the rightmost chair
ppp
	bcc maybe1
	; Return with carry clear
ret_cc
	clc
	rts
maybe1
	; NOT TRUE ANYMORE
	; Valid seats in even coords..
	;and #%00000001

.(
	sta tmp7+1
loopchair
	cpy tmp7+1
	bcs foundit		; Or not...
	iny
	iny
	iny
	bne loopchair	; jumps always
.)
foundit
	clc	; Return with carry flag clear (if C=1 the char must turn, which has already been tested)
	rts	; Return with zero flag set if we are beside a chair
rmp
	; We are in the map room
	ldy #CH_MAPL	; For later search
	cmp #CH_MAPL
	;bcc ret_cs
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

	ldy #CH_WHITEL	; For later search
	cmp #CH_WHITEL
	;bcc ret_cs
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
	;bcc ret_cs
	bcs notyet3
	sec
	rts
notyet3
	cmp #CH_EXAMAL
	bcc otherset

	ldy #CH_EXAMAL	; For later search
	cmp #CH_EXAMAR
;	bcs notyet4
;	sec
;	rts
;notyet4
	jmp ppp

otherset
	; The character is to the left of the first set of charis
	; Trick to reuse code... Unnecessary here?
	;clc
	;adc #1
	ldy #CH_EXAMBL	; For later search
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

	cmp #CH_READR-3
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
	cmp #CH_MAPR-3
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
; Call an interruptible subcommand. This 
; is quite complex. It drops the return address
; from the stack and places it into the character's
; buffer (at cur_command). The speccy version only
; copies the LSB. This ensures that the original
; routine keeps running from the point it was
; interrupted by this call, when the subcommand
; is finished. Then it takes the address stored
; in tmp0 and store it as the interruptible_subcommand
; and jump to it.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
call_subcommand
.(
	sta tmp0
	sty tmp0+1

	; Get the return address...
	pla	; get LSB
	sta tmp
	pla	; get HSB
	sta tmp+1
	inc tmp
	bne noadj
	inc tmp+1
noadj
	; And place it as the current command address...
	lda tmp
	sta cur_command_low,x
	lda tmp+1
	sta cur_command_high,x

	; Place the subcommand and jump to it
	lda tmp0
	sta i_subcom_low,x
	lda tmp0+1
	sta i_subcom_high,x
	jmp (tmp0)
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Terminate an interruptible subcommand
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
s_end
.(
  rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a little boy find and follow 
; little boy no. 1.
; Used by command list 206 (which is used 
; by little boys 2-11). 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_follow_boy1
.(
	inc pcommand,x

	; Reset bit 6 (do not walk slowly continuously) 
	; and bit 7 (walk fast) 
	; and set bit 5 (walk fast continuously)

	lda flags,x
	and #31
	ora #32
	sta flags,x
	
	; Check if the continual subcommand of boy no. 1
	; is csc_trip_people_up, and return otherwise
	ldy #CHAR_BOY1
	lda #>csc_trip_people_up
	cmp cont_subcom_high,y
	beq cont
retme
	rts
cont
	lda #<csc_trip_people_up
	cmp cont_subcom_low,y
	bne retme

	; Set csc_trip_people_up as continual subcommand for this boy
	;lda #<csc_trip_people_up
	sta cont_subcom_low,x
	lda #>csc_trip_people_up
	sta cont_subcom_high,x

	; Copy command and destination from boy no. 1
	lda cur_command_high,y
	sta cur_command_high,x
	lda cur_command_low,y
	sta cur_command_low,x
	lda dest_x,y
	sta dest_x,x
	lda dest_y,y
	sta dest_y,x

	; Send him follow boy no. 1

	jmp s_goto_ex2
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make little boy no. 1 go to a place at random 
; and trip people up on the way.
; Used by command list 204 (which is used only 
; by little boy no. 1). 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_goto_random_trip
.(
	;inc pcommand,x

	; Reset bit 6 (do not walk slowly continuously) 
	; and bit 7 (walk fast) 
	; and set bit 5 (walk fast continuously)

	lda flags,x
	and #31
	ora #32
	sta flags,x
	
	; Place the address of the continual subcommand 
	; routine csc_trip_people_up

	lda #<csc_trip_people_up
	sta cont_subcom_low,x
	lda #>csc_trip_people_up
	sta cont_subcom_high,x

	jmp s_goto_random_ex
.)
 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make little boy no. 10 give ERIC a message
; Used by command lists 208 and 210. Makes little 
; boy no. 210 tell ERIC about BOY WANDER having 
; hidden a pea-shooter on the fire escape, 
; EINSTEIN's intent to grass him up to MR WACKER, 
; or ANGELFACE's medical condition.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
 
s_tell_einstein
.(
	lda #<s_tell_einstein_ex
	sta repeat+1
	lda #>s_tell_einstein_ex
	sta repeat+2
s_tell_einstein_ex
	lda #<st_einstein
	ldy #>st_einstein
	bne s_tell_common	; Jumps always
.)

s_tell_angelface
.(
	lda #<s_tell_angelface_ex
	sta repeat+1
	lda #>s_tell_angelface_ex
	sta repeat+2
s_tell_angelface_ex
	lda #<st_mumps
	ldy #>st_mumps
	bne s_tell_common	; Jumps always
.)

s_tell_boywander
.(
  	lda #<s_tell_boywander_ex
	sta repeat+1
	lda #>s_tell_boywander_ex
	sta repeat+2
s_tell_boywander_ex
	lda #<st_peashooter
	ldy #>st_peashooter
	;bne s_tell_common	; Jumps always
.)
s_tell_common
.(
	sta tmp0
	sty tmp0+1

	; Set bit 3 of Eric's status flags, indicating
	; he is being spoken to
	lda Eric_flags
	ora #ERIC_SPOKEN	
	sta Eric_flags


	; Adjust the MSB of the lesson clock so that the 
	; lesson will not end until the drama has played out

	lda #255
	sta lesson_clock+1

	; Make the character say this...
	jsr s_make_char_speak

	; Initialize the repetition counter
	lda #40
	sta var2,x

	lda #<st_pressU
	sta tmp0
	lda #>st_pressU
	sta tmp0+1
	jsr s_make_char_speak

	; Set bit 0 of special_playtime flags to indicate
	; that the little boy is waiting for the ack from Eric
	lda special_playtime
	ora #%10000000
	sta special_playtime

	; Check Eric's status flags to see if the player
	; pressed U
	lda Eric_flags
	and #ERIC_SPOKEN	
	bne notpressed

	; The player pressed 'U'
	; Set the MSB of the lesson clock to 12, giving 
	; enough time for the ensuing drama to play out

	lda #12
	sta lesson_clock+1
	lda #0
	sta i_subcom_high,x
	/*
	sta cur_command_high,x
	inc pcommand,x
	jmp int_subcommand*/
	jmp next_com
	
notpressed
	; If in need, repeat the message
	dec var4,x
	bne repeat

	; Else force ending
	/*lda Eric_flags
	and #(ERIC_SPOKEN^$ff)
	sta Eric_flags*/
	lda special_playtime
	and #%01111111
	sta special_playtime
+repeat
	jmp $1234
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make MR WACKER give ERIC 2000 lines
; Used by command lists 214 (after EINSTEIN has
; told MR WACKER what ERIC's up to) and 218 
; (after MR WACKER has found the pea-shooter on 
;the fire escape). 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_2000lines_eric
.(
    lda #<reprimand_2000
	sta tmp0
    lda #>reprimand_2000
	sta tmp0+1

	; Make the character say this...
	jsr s_make_char_speak

	stx savx+1
	; Add 2000 lines to the Eric's total
	lda #200
	jsr add_lines
savx
	ldx #0

	; Set the MSB of the lesson clock to 1
	; so it ends soon
	lda #1
	sta lesson_clock+1

	jmp next_com
/*
	inc pcommand,x
	lda #0
	sta cur_command_high,x
	jmp int_subcommand
*/
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher tell ERIC to go home, and end 
; the game (1)
; Used by command list 222 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_end_game
.(
	cpx #CHAR_WACKER
	bne isrockitt
	lda #<end_game_wacker
	ldy #>end_game_wacker
	bne msgdone
isrockitt
	lda #<end_game_rockitt
	ldy #>end_game_rockitt

msgdone	
	sta tmp0
	sty tmp0+1

	; Patch code so the teacher does not give lines to anybody
	lda #$60	;RTS_OPCODE
	sta give_lines

	; Make the character say this...
	jsr s_make_char_speak

	; Put the code back as it was
	lda #$8d ;STA_OPCODE
	sta give_lines
	
	; Restart the game
	jmp restart_game
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character find ERIC
; Used by command lists 208, 210, 214, 218 and 
; 222 to make little boy no. 10, MR WACKER or 
; MR ROCKITT track down ERIC 
; (to deliver a message). 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_find_eric
.(
	; Adjust the length of the lesson to allow 
	; the character enough time to find Eric
	lda #255
	sta lesson_clock+1

	; Prepare call to the routine as uninterruptible 
	; subcommand

	lda #<s_find_eric_ex
	sta uni_subcom_low,x
	lda #>s_find_eric_ex
	sta uni_subcom_high,x

	; Subsequent calls to this routine will enter 
	; at this point, by virtue of its address 
	; being placed as uninterruptible subcommand in 
	; the character's buffer.
+s_find_eric_ex
	; is Mr Wacker the one looking for Eric?
	cpx #CHAR_WACKER	
	bne nofast
	; If it is, then make him walk fast
	jsr csc_walk_fast
nofast

	; It seems that when on a staircase the
	; character cannot find Eric
	jsr is_on_staircase
	bne toofar
	
	; Okay, now let's check the distance to Eric...
	sec
	lda pos_col,x
	sbc pos_col
	bpl noadjust1
	sta tmp
	lda #0
	sec
	sbc tmp
noadjust1
	cmp #5
	bcs toofar

	sec
	lda pos_row,x
	sbc pos_row
	bpl noadjust2
	sta tmp
	lda #0
	sec
	sbc tmp
noadjust2
	cmp #4
	bcs toofar

	; Alright, Eric has been found	

	; Check ERIC's status flags, and return if ERIC 
	; is firing, hitting, jumping, being spoken to 
	; by a little boy, knocked out, or writing on a 
	; blackboard
	lda Eric_flags
	and #127
	beq cont
	rts
cont
	; a is already zero
	sta uni_subcom_high,x
	sta i_subcom_high,x
	
	inc pcommand,x
	rts ;jmp next_command

toofar
	; Eric has not been found yet... keep on looking
	; for him
	ldy #CHAR_ERIC
	jsr which_way
	jmp do_move
.)
 



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher perform dinner duty (1)
; Used by command list 184. Makes the teacher 
; on dinner duty pace up and down the dinner 
; hall, checking whether ERIC is present. If 
; ERIC is absent, the teacher is sent to find 
; him, after which the command list is 
; restarted. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_dinner_duty
.(
	; Dinner has started. Signal it.
	lda lesson_status  
	ora #%10000000
	sta lesson_status

	; This entry point is used for subsequent calls
+s_dinner_duty_ex
	; Check if Eric is where he should be
	jsr s_check_Eric_loc
	php
	ldy #44	; left end of the teacher's dinner duty orbit
	lda #<s_dinner_duty2
	sta tmp0
	lda #>s_dinner_duty2
	sta tmp0+1
	plp

	; Entry point from other routines to chase
	; Eric if needed.
+s_track_down_Eric
	beq nochase
	lda #<s_isc_findEric
	sta i_subcom_low,x
	lda #>s_isc_findEric
	sta i_subcom_high,x
	jmp s_isc_findEric
nochase
	; Eric is where he should be, so no need
	; to chase him.
	; Guide the teacher to the opposite
	; side of the dinner orbit
	lda #<s_isc_int_dest
	sta i_subcom_low,x
	lda #>s_isc_int_dest
	sta i_subcom_high,x
	tya
	sta var3,x
	lda #0		; Give him plenty of time
	sta var4,x

	; Replace the current primary command
	; with either s_dinner_duty2 or 
	; s_dinner_duty_ex
	lda tmp0
	sta cur_command_low,x
	lda tmp0+1
	sta cur_command_high,x
	jmp s_isc_int_dest
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher perform dinner duty (2)
; The address of this primary command routine 
; is placed into bytes 99 and 100 of the 
; teacher's buffer by the routine s_dinner_duty
; The teacher has walked to the left end of 
; the dinner hall, so it's time to check 
; whether ERIC is present.  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_dinner_duty2
.(
	; Prepare Z flag and destination
	jsr s_check_Eric_loc
	php
	lda #<s_dinner_duty_ex
	sta tmp0
	lda #>s_dinner_duty_ex
	sta tmp0+1
	ldy #83	;  right end of the techer's dinner duty orbit
	plp
	jmp	s_track_down_Eric	
.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make BOY WANDER write on a blackboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_write_bl
.(
	inc pcommand,x
	lda #<s_isc_write
	sta i_subcom_low,x
	lda #>s_isc_write
	sta i_subcom_high,x
	jmp s_isc_write
.)

s_write_bl_c
.(
	; Get event to check
	ldy pcommand,x
	iny

	lda (tmp0),y

	; Get byte and bitmask
	jsr s_get_flagbyte

	; Check if it is flagged
	and lesson_status,y
	bne notyet
	inc pcommand,x
	jmp s_write_bl
notyet
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

	ldy pcommand,x
	lda (tmp0),y
	sta cont_subcom_low,x

	inc pcommand,x

	ldy pcommand,x
	lda (tmp0),y
	sta cont_subcom_high,x
	
	inc pcommand,x

	; This is important, so the main loop does not find an empty
	; primary command pointer and clears the continuous subcommand
	; without executing it.

	jmp next_command
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher tell the kids to sit down
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


s_msg_sitdown
.(
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
	jsr s_make_char_speak

	; Move to the next command
+next_com
  	inc pcommand,x
	lda #0
	sta cur_command_high,x
	jmp int_subcommand
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Control teacher when during class
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


s_do_class
.(
	; No need to increment pointer to command here, as this
	; command is finished when the class ends...
	
	; First determine wether he is teaching Eric and Einstein
	; in ths period.
	lda lesson_descriptor

	; Keep only the teacher bits (4-6)
	and #%01110000
	lsr
	lsr
	lsr
	lsr
	tay
	lda table_teacher_codes,y
	sta tmp
	cpx tmp
	beq teachingEric	

	; The teacher is not teaching Eric, prepare the new
	; address for the current command and jump there
	lda #<s_class_no_Eric
	sta cur_command_low,x
	lda #>s_class_no_Eric
	sta cur_command_high,x
	jmp s_class_no_Eric
teachingEric
	; We are teaching Eric, prepare the routine
	; and jump there, but first clear the lesson
	; status flags.
	lda #0
	sta lesson_status
	lda #<s_class_with_Eric
	sta cur_command_low,x
	lda #>s_class_with_Eric
	sta cur_command_high,x
	jmp s_class_with_Eric
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher conduct a class when he is not
; teaching Eric (and Einstein).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_class_no_Eric
.(
	; If the class has a blackboard, make
	; the teacher clean it. The following steps
	; are made:
	
	; Get the identifier of the blackboard next to 
	; the teacher. If we are in the Map room jump
	; tell the kids to go to a certain page of their
	; books.

	lda pos_col,x
	cmp #WALLTOPFLOOR
	bcs page_in_book

	;jsr get_blackboard
.(
	; Use call_subcommand to hand control
	; over the s_isc_wipe1 routine

	lda #<s_isc_wipe1
	ldy #>s_isc_wipe1
	jsr call_subcommand

	; Make the teacher walk to the middle of the blackboard
	; also using call_subcommand

	lda pos_col,x	; Get the teacher x coordinate (now left edge of blackboard)
	clc
	adc #6-2			; Position in the middle of the blackboard
	sta var3,x	
	sta var4,x		; This ensures control does not come here before he reaches the destination
	lda #<s_isc_int_dest
	ldy #>s_isc_int_dest
	jsr call_subcommand
.)
	; Randomly make the teacher ask the kids to write an
	; essay or go to a page of their books

	jsr randgen
	cmp #180
	bcs page_in_book

	lda #<s_isc_write
	ldy #>s_isc_write
	jsr call_subcommand
	
	lda #<st_write_essay
	sta tmp0
	lda #>st_write_essay
	sta tmp0+1
	jsr s_make_char_speak
	jmp teacher_waits
page_in_book
	jsr s_goto_page
teacher_waits
	; Makes the teacher walk up&down, while
	; the students work...

	lda pos_col,x
	eor #3
	sta var3,x
	; And var4???

	lda #<s_isc_int_dest
	ldy #>s_isc_int_dest
	jsr call_subcommand

	; Jump back again. The command is terminated
	; automatically when the class is over...
	jmp teacher_waits
.)


s_goto_page
.(
  	; Prepare a random number for the book's page
	; TODO: This has the effect of repeating the page
	; if two teachers do this at the same time!

	ldy #2
loop
	jsr randgen
	and #%111
	adc #"0"
	sta number_template,y
	dey
	bpl loop

	jsr randgen
	bcs questions
	lda #<st_page_book
	sta tmp0
	lda #>st_page_book
	sta tmp0+1
	jmp s_make_char_speak
questions
	lda #<st_question_book
	sta tmp0
	lda #>st_question_book
	sta tmp0+1
	jmp s_make_char_speak
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher conduct a class when he is 
; teaching Eric (and Einstein).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_class_with_Eric
.(
	; This one is quite tricky... there are many things to 
	; take into acount, let's analyze them...

	; First wait until Einstein sits down and check
	; if Eric is in class.
	jsr s_Einstein_seated
	beq Ericisin
Ericnotin
	; Eric is not in the class
	; Here Einstein could grass on Eric's absence
	; and the teacher may decide track him down
	; and give lines...
	lda #<st_grass
	ldy #>st_grass
	jsr s_make_Einstein_speak
	
	; Make the teacher give lines to Einstein for
	; telling tales (if he is in the moood)

	jsr s_Einstein_tales

	; Tell the kids to read their books
	jsr s_goto_page
	
	; Check for Eric again and maybe send him
	; after Eric... (use s_check_Eric_loc)
	jsr s_check_Eric_loc
	beq heisnow
	
	; Set bit 7, indicating that the next
	; absence message should be 'AND STAY
	; THIS TIME'
	lda #%10000000
	ora lesson_status
	sta lesson_status

	; Make the teacher track down Eric
	jmp s_track_down_Eric
heisnow
	; Get the correct message to punish Eric
	; Get the status flags
	lda lesson_status
	bmi stay
	lda #NEVER_LATE
	.byt $2c
stay
	lda #STAY_THISTIME
	jsr punish_Eric

Ericisin
	; Set bit 7 (indicating that the next absence 
	; lines message should be 'AND STAY THIS TIME')
	; and bit 6 (indicating that the lesson has started)
	lda #%11000000
	ora lesson_status
	sta lesson_status

	; Check if Eric is still in class
	jsr s_Einstein_seated
	bne Ericnotin

	; This is EINSTEIN's opportunity to tell tales 
	; about hitting and blackboard defacement.

	jsr randgen
	cmp #226 
	bcc nohitmsg
	; Make Einstein say "Please Sir... Eric hit me"
	lda #<st_hitme
	ldy #>st_hitme
	jsr s_make_Einstein_speak

	; Make the teacher give lines to Einstein for
	; telling tales (if he is in the moood)
	; or else do the following

	jsr s_Einstein_tales
	bcc	nohitmsg

	; Check if Eric is still in class
	jsr s_Einstein_seated
	bne Ericnotin

	; Punish him!
	lda #DO_AGAIN
	jsr punish_Eric

nohitmsg
	; Get the blackboard
	lda pos_row,x
	; Are we on the top floor?
	cmp #3
	bne nocheck
	; We are, are we on the Map room?
	lda pos_col,x
	cmp #WALLTOPFLOOR
	;bcs no_essay	;noblackboard
.(
	bcc cont
	jmp no_essay
cont
.)
nocheck
	; Get the closest blackboard
	jsr get_blackboard

	; Who wrote here?
	ldy #4
	lda (tmp3),y
	beq Ericwrote
	cmp #CHAR_BOYWANDER
	bne noblackboard
	; Even so, Einstein may blame Eric
	jsr randgen
	cmp #200
	bcs Ericwrote

	lda #BOYW_NAME
	.byt $2c
Ericwrote
	lda #ERIC_NAME
	sta st_bboard+1

	; Make Einstein say "Please Sir... X wrote on the blackboard"
	lda #<st_bboard
	ldy #>st_bboard
	jsr s_make_Einstein_speak

	; Make the teacher give lines to Einstein for
	; telling tales (if he is in the moood)
	; or else do the following

	jsr s_Einstein_tales
	bcc	noblackboard

	; Check if Eric is still in class
	jsr s_Einstein_seated
	;bne Ericnotin
.(
	beq cont
	jmp Ericnotin
cont
.)
	; Punish him!
	lda st_bboard+1
	cmp #ERIC_NAME
	bne boywander
	ldy #CHAR_ERIC
	beq dopunish	; This always jumps
boywander
	ldy #CHAR_BOYWANDER
dopunish
	lda #TOUCH_BLACKBOARDS
	jsr give_lines

noblackboard
	; Check if we are in the map room and avoid doing all this
	;lda pos_col,x
	;cmp #WALLTOPFLOOR
	;bcs no_essay

	; With EINSTEIN's tales now safely told, it's 
	; time to wipe the blackboard.

	; Use call_subcommand to hand control
	; over the s_isc_wipe1 routine

	lda #<s_isc_wipe1
	ldy #>s_isc_wipe1
	jsr call_subcommand

	; Make the teacher walk to the middle of the blackboard
	; also using call_subcommand

	lda pos_col,x	; Get the teacher x coordinate (now left edge of blackboard)
	clc
	adc #6			; Position in the middle of the blackboard
	sta var3,x	
	sta var4,x		; This ensures control does not come here before he reaches the destination
	lda #<s_isc_int_dest
	ldy #>s_isc_int_dest
	jsr call_subcommand

	; Control returns here when the teacher has 
	; wiped the blackboard and walked to the middle 
	; of it.
	; Make the teacher write on the blackboard
	; 180 times out of 256 using call_subcommand
	jsr randgen
	cmp #180
	bcs no_essay
	lda #<s_isc_write
	ldy #>s_isc_write
	jsr call_subcommand

	; Should the teacher tell the kids to write an essay?
	; 10 times out of 16
	jsr randgen
	cmp #160
	bcc no_essay
	
	lda #<st_write_essay
	sta tmp0
	lda #>st_write_essay
	sta tmp0+1
	jsr s_make_char_speak
	jmp teacher_waits
no_essay
	jsr randgen
	cmp #240
	bcc s_questions

read_book
	jsr s_goto_page

teacher_waits
	; Is Eric in class?
	jsr s_Einstein_seated
.(
	beq cont
	jmp Ericnotin
cont
.)

	; Makes the teacher walk up&down, while
	; the students work...

	lda pos_col,x
	eor #3
	sta var3,x
	; And var4???

	lda #<s_isc_int_dest
	ldy #>s_isc_int_dest
	jsr call_subcommand

	; Jump back again. The command is terminated
	; automatically when the class is over...
	jmp teacher_waits

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher conduct a 
; question-and-answer session
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_questions
	; Make this routine the current command
	lda #<s_questions
	sta cur_command_low,x
	lda #>s_questions
	sta cur_command_high,x

checkEricagain
	; Check if Eric is present
	jsr s_Einstein_seated
	beq Ericstillin

	; Eric went absent, deal with it
	lda #<s_class_with_Eric
	sta cur_command_low,x
	lda #>s_class_with_Eric
	sta cur_command_high,x
	jmp Ericnotin
Ericstillin
	; ERIC is in class, so fire off a question and answer.
	jsr s_prepare_question
	lda #<s_isc_speak1
	ldy #>s_isc_speak1
	jsr call_subcommand 

	; Control returns here when the teacher has finished asking the question.

	jsr Einstein_turn

	; And loop back
	jmp checkEricagain
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher decide whether to give EINSTEIN lines
; for telling tales. Returns with C=0 if he did.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_Einstein_tales
.(
	txa
	sec
	sbc #CHAR_FIRST_TEACHER
	tay
	jsr randgen
	cmp tab_teachertales,y
	bcc doit
	; Not this time
	rts
doit
	; Okay, give lines
	ldy #CHAR_EINSTEIN
	lda #TELL_TALES
	jsr give_lines
	clc
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check whether ERIC and EINSTEIN are in class
; Used by the routines at 62208 and 62464. If 
; EINSTEIN is in class, this routine returns to the 
; caller with the zero flag set if and only if ERIC 
; is present too. If EINSTEIN is not yet sitting down 
; in class, it makes the teacher wait until he shows up. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_Einstein_seated
.(
	ldy #CHAR_EINSTEIN
	lda anim_state,y
	cmp #4
	beq s_check_Eric_loc

	; Place the return address into the cur_command of 
	; the teacher, so control keeps calling this...

	; Get the return address... and substract 2 to get the
	; address of the instruction that called this...
	pla ; get LSB
	sec
	sbc #2	; size of jsr inmediate + 1
	sta tmp
	pla ; get MSB
	sta tmp+1
	bcs nocarry
	dec tmp+1
nocarry

	; And place it as the current command address...
	lda tmp
	sta cur_command_low,x
	lda tmp+1
	sta cur_command_high,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check whether ERIC is where he should be
; Used by the routines at 31648, 31854, 31895,
; 31952 and 62208. Returns with the zero flag 
; set if and only if ERIC is where he should 
; be during dinner or class. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_check_Eric_loc
.(
	; Check the floor he is at
	; Get Eric's corrected Y-coordinate
	jsr get_Eric_Ycoord
	;lda pos_row
	ldy #0
	cmp #3
	beq cont
notop
	iny
	cmp #10
	beq cont
nomiddle
	iny
	cmp #17
	beq cont
	; Return with zero flag reset
	rts
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
	; Get lesson descriptor
	lda lesson_descriptor
	and #%111
	; Are we in the correct region?
	cmp (tmp1),y
	rts
.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Auxiliary, to save some
; memory...
;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_domath
.(
	sty savy+1
	sta op2
	lda #0
	sta op2+1
	jsr utoa
savy
	ldy #0

	ldx #0
loop
	lda bufconv,x
	sta number_question,y
	beq end
	inx
	iny
	jmp loop
end
	rts

.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prepare a question and answer pair
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_prepare_question
.(
	; Is Mr Wacker the teacher?
	cpx #CHAR_WACKER
	bne not_wacker

	; It is Mr Wacker who is teaching... prepare a multiplication
	; question...
	stx savx+1

	jsr randgen
	and #%00011111
	ora #%00000100
	sta tmp0

	; Prepare the question
	ldy #0
	jsr s_domath

	lda #" "
	sta  number_question,y
	iny
	lda #"x"
	sta  number_question,y
	iny
	lda #" "
	sta  number_question,y
	iny

	jsr randgen
	and #%00011111
	ora #%00000100
	sta tmp0+1

	jsr s_domath

	jsr mul8
	lda tmp0
	sta op2
	lda tmp1
	sta op2+1
	jsr utoa
	ldx #0
loop
	lda bufconv,x
	sta number_answer,x
	beq end
	inx
	jmp loop
end

	; Place the corresponding answer in Einstein's buffer
	ldy #CHAR_EINSTEIN
	lda #<st_ans
	sta var3,y
	lda #>st_ans
	sta var4,y

savx
	ldx #0

	lda #<st_questions
	sta var3,x
	lda #>st_questions
	sta var4,x
/*
	lda #<s_isc_speak1
	sta i_subcom_low,x
	lda #>s_isc_speak1
	sta i_subcom_high,x
*/
	rts

not_wacker
	; The teacher is no Mr Wacker. We first check if it is
	; Mr Creak and it is time to give the Year of Birth quesion

	jsr s_birthyear_question

	; It is not, then prepare a question and an answer depending
	; on the teacher.

	; Prepare base pointer
	lda #<st_questions
	sta tmp0
	lda #>st_questions
	sta tmp0+1

	; Get the table of questions&answers for the current teacher
	txa
	sec
	sbc #CHAR_FIRST_TEACHER
	asl
	asl
	tay

	; Get the random q&a pair
	lda qa_tables,y
	sta tmp1
	lda qa_tables+1,y
	sta tmp1+1
	lda qa_tables+2,y
	sta tmp2
	lda qa_tables+3,y
	sta tmp2+1

	; Get a random number
	jsr randgen
	; Carry is random here...
	bcc firstq
	iny
	iny
	; Swap pointers
	sty savyb+1
	lda tmp1
	ldy tmp2
	sta tmp2
	sty tmp1
	lda tmp1+1
	ldy tmp2+1
	sta tmp2+1
	sty tmp1+1
savyb
	ldy #0
	
firstq
	lda creak_table,y
	sty savy+1

	; Now get the string
	jsr search_string
	
	; and put it into the character's buffer
	lda tmp0
	sta var3,x
	lda tmp0+1
	sta var4,x

	; Now for the answer
	; Prepare base pointer
	lda #<st_ans
	sta tmp0
	lda #>st_ans
	sta tmp0+1
savy
	ldy #0
	iny
	lda creak_table,y
	; Now get the string
	jsr search_string
	
	; and put it into the Einstein's buffer
	ldy #CHAR_EINSTEIN
	lda tmp0
	sta var3,y
	lda tmp0+1
	sta var4,y

	; Put the corresponding question/answer pair in the pointers
	lda tmp1
	sta tmp0
	lda tmp1+1
	sta tmp0+1
getqa
	jsr randgen
	and #%11111
	cmp #21
	bcs getqa
	sta sava+1
	jsr search_string
	lda tmp0
	sta p_question
	lda tmp0+1
	sta p_question+1
	lda tmp2
	sta tmp0
	lda tmp2+1
	sta tmp0+1
sava
	lda #0
	jsr search_string
	lda tmp0
	sta p_answer
	lda tmp0+1
	sta p_answer+1

	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make MR CREAK ask the birth year question if 
; appropriate.
; Used by the routine s_prepare_question. 
; Makes MR CREAK ask the birth year question if
; (a) he hasn't asked it yet this lesson, and 
; (b) ERIC hasn't opened the safe yet. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_birthyear_question
.(
	; Are we dealing with Mr Creak?
	cpx #CHAR_CREAK
	beq cont
retme
	rts
cont
	; Has Eric opened the safe yet or are we in demo mode?
	lda game_mode
	beq retme
	cmp #3
	beq retme

	; Has Mr. Creak already asked this question?
	lda birthyear_ind
	bne retme


	; MR CREAK hasn't asked the birth year question yet. Make him do so now.
	; Get rid of context, we will be returning to the caller of the
	; caller.
	pla 
	pla

	; Signal Mr. Creak has already asked the question
	inc birthyear_ind
	
	; Prepare the q/a pairs 
	; For Einstein
	ldy #CHAR_EINSTEIN
	lda #<st_ans_batt
	sta var3,y
	lda #>st_ans_batt
	sta var4,y

	; and the corresponding pointer
	lda #<st_battles
	sta tmp0
	lda #>st_battles
	sta tmp0+1
	lda birthyear_id
	jsr search_string
	lda tmp0
	sta p_answer
	lda tmp0+1
	sta p_answer+1

	; And for Mr. Creak
	ldy #CHAR_CREAK
	lda #<st_q_batt
	sta var3,y
	lda #>st_q_batt
	sta var4,y
	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Control EINSTEIN during class (1)
; Used by command lists 144, 152, 160 and 168.
; Makes EINSTEIN wait for his turn to speak, and 
; then hands over control to the interruptible 
; subcommand routine at s_isc_speak1_ex; when EINSTEIN has 
; finished speaking, control returns to the 
; primary command routine at s_ctrl_einstein2. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_ctrl_einstein1
.(
	; Pick up the lesson flags and check
	; if it is Einstein turn to speak
	lda lesson_signals
	lsr
	bcs doit
	rts
doit
	lda #<s_ctrl_einstein2
	sta cur_command_low,x
	lda #>s_ctrl_einstein2
	sta cur_command_high,x

	lda #<s_isc_speak1_ex
	sta i_subcom_low,x
	lda #>s_isc_speak1_ex
	sta i_subcom_high,x

	jmp s_isc_speak1
.)

s_ctrl_einstein2
.(
	lda #<s_ctrl_einstein1
	sta cur_command_low,x
	lda #>s_ctrl_einstein1
	sta cur_command_high,x

	; Signal Einstein has just spoken
	lda lesson_signals
	and #%11111110
	sta lesson_signals
	
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character find a seat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_find_seat
.(
	lda #<s_usc_lchair
	sta uni_subcom_low,x
	lda #>s_usc_lchair
	sta uni_subcom_high,x
	inc pcommand,x
	jmp s_usc_lchair
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
	lda #>s_isc_int_dest
	sta i_subcom_high,x
	jmp s_isc_int_dest
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
	lda #>s_isc_up_stair
	sta i_subcom_high,x
	lda #15	; 15 movements to deal with a stair
	sta var4,x
	jmp s_isc_up_stair

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
	lda #>s_isc_up_stair
	sta i_subcom_high,x
	lda #15	; 15 movements to deal with a stair
	sta var4,x
	jmp s_isc_up_stair
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
	lda #>s_isc_down_stair
	sta i_subcom_high,x
	lda #15	; 15 movements to deal with a stair
	sta var4,x
	jmp s_isc_down_stair
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make BOY WANDER fire his catapult (2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_bfire1
.(
	; Prepare next step in the subcommand
	lda #<s_usc_bfire2
	sta uni_subcom_low,x
	lda #>s_usc_bfire2
	sta uni_subcom_high,x

	; Save animatory state
	lda anim_state,x
	sta var7,x
	
	; Adjust animatory state
	lda #11
	jmp update_animstate

.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make BOY WANDER fire his catapult (3)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_bfire2
.(
	; Prepare next step in the subcommand
	lda #<s_usc_bfire3
	sta uni_subcom_low,x
	lda #>s_usc_bfire3
	sta uni_subcom_high,x

	; Adjust animatory state
	lda anim_state,x
	clc
	adc #1
	jmp update_animstate
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make BOY WANDER fire his catapult (4)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_bfire3
.(
	; Prepare next step in the subcommand
	lda #<s_usc_bfire4
	sta uni_subcom_low,x
	lda #>s_usc_bfire4
	sta uni_subcom_high,x

	; Prepare the calling to the routine entry point in eric.s
	ldy #CHAR_BPELLET
	jmp launch_pellet
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make BOY WANDER fire his catapult (5)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_bfire4
.(
	; Prepare next step in the subcommand
	lda #<s_usc_bfire5
	sta uni_subcom_low,x
	lda #>s_usc_bfire5
	sta uni_subcom_high,x

	; Adjust animatory state
	lda anim_state,x
	sec
	sbc #1
	jmp update_animstate
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make BOY WANDER fire his catapult (6)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_bfire5
.(
	; Prepare next step in the subcommand
	lda #<terminate_unisubcom
	sta uni_subcom_low,x
	lda #>terminate_unisubcom
	sta uni_subcom_high,x

	; Get back animatory state
	lda var7,x
	jmp update_animstate
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Control the horizontal flight of a catapult pellet
;; Controls the pellet from the beginning of its horizontal 
;; flight to the end, handing over to the routine s_usc_pelletv
;; if the pellet bounces upwards off some obstacle. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_pelleth
.(
	; Check if the pellet has finished travelling
	dec var7,x
	bne travel
+terminate_pellet
	; Finished the travel, remove the pellet
	jsr update_SRB_sp
	lda #OFFSCREEN_POS
	sta pos_col,x
	lda #0
	sta uni_subcom_high,x
	rts 
travel
	; The pellet continues travelling
	; Check if it will get offscreen

	; first calculate the destination column
	lda flags,x
	and #IS_FACING_RIGHT
	beq facingl
	lda pos_col,x
	clc
	adc #(1+2)
	jmp next
facingl
	lda pos_col,x
	sec
	sbc #(1)
next
	sta tmp
	; Is it offscreen?

	cmp #SKOOL_COLS-2
	beq terminate_pellet
	cmp #FIRST_VIS_COL-2
	beq terminate_pellet

	; It does not get offscreen... but will it collide with a wall?
	lda pos_row,x
	; is it on the bottom floor?
	cmp #17
	beq moveit
	; is it on the middle floor?
	cmp #10
	beq middlefloor
	; It is on the top floor... will it hit the wall?
	lda tmp
	cmp #WALLTOPFLOOR
	beq terminate_pellet
	bne moveit
middlefloor
	; We have to check for two walls here
	lda tmp
	cmp #WALLMIDDLEFLOOR
	beq terminate_pellet
	cmp #WALLMIDDLEFLOOR2
	beq terminate_pellet
moveit
	; Ok the pellet may move... 
	jsr step_character

	jsr is_on_staircase
	beq notstairs
	; It is, have to check if it hits a shield
	jmp check_shield_hit
notstairs
	;... time to check if it hits somebody
	lda var7,x
	cmp #16
	bcs retme

	lda pos_col,x
	sta smc_xpos+1
	lda pos_row,x
	sta smc_ypos+1

	ldy #CHAR_WITHIT	
loop
	; Kludge to adjust position
	lda pos_col,y
	sta tmp+1
	lda flags,y
	eor flags,x
	and #IS_FACING_RIGHT
	bne skip2
	lda flags,x
	and #IS_FACING_RIGHT
	beq skip3
	dec tmp+1
	jmp skip2
skip3
	inc tmp+1
skip2
smc_xpos
	lda #0
	cmp tmp+1
	bne skip
smc_ypos
	lda #0
	cmp pos_row,y
	beq victimok

skip
	cpy #CHAR_FIRST_TEACHER
	bne nokludge
	ldy #CHAR_BOYWANDER+1
nokludge
	dey
	bpl loop
	; We found no victim, return
retme
	rts

victimok
	; Yeah, somebody was hit!

	; Is the objective already on the floor and it is not a teacher?
	lda anim_state,y
	cmp #6
	beq skip

	; If it is already on the floor and it is a teacher
	; then start moving the pellet up.

	cmp #5
	bne noteacher

	; Unless it is Bow Wander's pellet
	cpx #CHAR_BPELLET
	beq skip

	
	; Put the uninterruptible command to make the pellet
	; travel upwards
	lda #<s_usc_pelletv
	sta uni_subcom_low,x
	lda #>s_usc_pelletv
	sta uni_subcom_high,x
	; Set remaining distance to 5 spaces
	lda #5
	sta var7,x
	rts

noteacher
	; Is there an untinterruptible subcommand for the
	; objective?
	lda uni_subcom_high,y
	bne skip

	; Make the pellet stop travelling next time
	lda #1
	sta var7,x

	; If Angelface was hit, add 10 points
	cpy #CHAR_ANGELFACE
	bne notEric
	cpx #CHAR_EPELLET
	bne notEric
	sty savy+1
	lda #1
	jsr add_score
savy
	ldy #0
notEric
	jmp knock_him

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Control the vertical flight of a catapult pellet
;; Controls the pellet from the beginning of its vertical 
;; flight to the end, including any collision with a shield. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_pelletv
.(
	; Get y coord of the pellet
	lda pos_row,x

	; Has the pellet hit the ceiling of the top floor
	; (is this really necessary?)
	bne cont
jtp
	jmp terminate_pellet
cont

	; Has it finished travelling?
	dec var7,x
	beq jtp

	; Move it up
	jsr update_SRB_sp
	dec pos_row,x
	jsr update_SRB_sp

	; Entry point to check if a pellet hit a shield
+check_shield_hit
	lda pos_row,x
	sta op1
	lda pos_col,x
	sta op1+1

	; Entry point to check if Eric touched a shield
	; store in op, op+1 the row and col to check for
+check_shield_hit2
	; First get the correct table
	lda op1

	ldy #2
loop
	cmp tab_ptablesidx,y
	beq found
	dey
	bpl loop
	rts
found
	lda tab_ptablesl,y
	sta tmp
	lda tab_ptablesh,y
	sta tmp+1

nextchecks
	ldy #5*2-2
	lda op1+1
loop2
	cmp (tmp),y
	beq found2
	bcs retme
	dey
	dey
	bpl loop2
retme
	rts
found2
	; A shield was hit! Now let's put it upside down.
	; Get the shield number
	iny
	lda (tmp),y
	tay

	; Is it already upside-down?
	; Where upside-down depends on the game mode, of course
	lda game_mode
	cmp #1
	bne unflash	
	lda tab_sh_status,y
	bne retme
	beq doit
unflash
	cmp #3
	bne retme
	lda tab_sh_status,y
	beq retme
doit
	eor #$ff
	sta tab_sh_status,y
	jsr invert_shield

	stx savx+1

	ldx op1+1
	inx
	ldy op1
	iny
	jsr update_SRB

	; Add to the score
.(
	lda #10
	cpy #5
	bcc ads
	lda #20
	cpy #10
	bcc ads
	lda #40
ads
	jsr add_score
.)
savx
	ldx #0

	; Increment the count of inverted shields
	ldy flashed_shields
	iny
	cpy #15
	bne skip
	; We have flashed (or unflashed them all!)
	inc game_status
	ldy #0
skip
	sty flashed_shields

	; And terminate the pellet
	cpx #CHAR_EPELLET
	bne doret

	; If it was a pellet that hit the shield, 
	; this sets its remaining distance to travel to 1,
	; so it will be terminated the next time this routine is called

	lda #1
	sta var7,x
doret
	rts
.)
 



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deal with a character who has been knocked over
;; Knocks the character to the floor, makes him give lines to 
;; any nearby kids or reveal his safe combination letter 
;; (if he's a teacher), and then makes him get up. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_usc_knocked
.(

	; Check if it is time to get up
	dec var7,x
	bne cont
	jmp terminate_unisubcom
cont

	; Has the character just been hit?
	lda var7,x
	cmp #19
	beq justhit
	
	; If the character is a teacher make him reveal his
	; safe combination letter or give lines (as appropriate)
	; and exit or else return here

	jsr teacher_knocked

	; decrement again and check if it is time to
	; get up (this is what the speccy version does)
	
	ldy var7,x
	dey
	beq getup
	rts
getup
	; Get back the animatory state
	lda var8,x
	jmp update_animstate

justhit
	; The character has just been hit
	; Save the anim state in var8
	lda anim_state,x
	sta var8,x

	; And put the character lying on the floor
	cpx #CHAR_FIRST_TEACHER
	bcc kid
	lda #5
	.byt $2c
kid
	lda #6
	jmp update_animstate
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make ANGELFACE throw a punch (1) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_apunch1
.(
	; Prepare next step in the subcommand
	lda #<s_usc_apunch2
	sta uni_subcom_low,x
	lda #>s_usc_apunch2
	sta uni_subcom_high,x

	; Save animatory state
	lda anim_state,x
	sta var7,x
	
	; Adjust animatory state
	lda #7
	jmp update_animstate
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make ANGELFACE throw a punch (2) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_apunch2
.(
	; Prepare next step in the subcommand
	lda #<s_usc_apunch3
	sta uni_subcom_low,x
	lda #>s_usc_apunch3
	sta uni_subcom_high,x
	
	; Adjust animatory state

	lda anim_state,x
	clc
	adc #1
	jsr update_animstate
	
	
	; Check if somebody has been hit by Eric or Angelface (as this
	; is also an entry point when Eric hits
+check_hit
	; First see if somebody is in range...
	; Prepare the position where it would be hit
	lda flags,x
	and #IS_FACING_RIGHT
	beq left
	lda pos_col,x
	clc
	adc #2
	jmp done
left
	lda pos_col,x
	sec
	sbc #2
done
	sta smc_tpos+1
	
	ldy #CHAR_BOY11
	sty tmp
loop
smc_tpos
	lda #0
	ldy tmp
	jsr punchable_victim
	bcs knock_him
skip
	dec tmp
	bpl loop

	; We found no victim, return
	rts


	; this entry point is used also with pellets
+knock_him
	cpy #CHAR_ERIC
	bne notEric
	lda Eric_flags
	ora #ERIC_DOWN
	sta Eric_flags

	; If in demo, put the subcommand for Eric too!
	lda game_mode
	beq notEric

	rts
notEric

	; Place the corresponding uninterruptible
	; subcommand
	lda #<s_usc_knocked
	sta uni_subcom_low,y
	lda #>s_usc_knocked
	sta uni_subcom_high,y

	; Initialize timer to be laid down
	lda #20
	sta var7,y

	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make ANGELFACE throw a punch (3) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_apunch3
.(
	; Prepare next step in the subcommand
	lda #<s_usc_apunch4
	sta uni_subcom_low,x
	lda #>s_usc_apunch4
	sta uni_subcom_high,x

	; Get back animatory state
	lda var7,x
	jmp update_animstate
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make ANGELFACE throw a punch (4) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
terminate_unisubcom		; This also serves for this purpose
s_usc_apunch4
.(
	; We are done, terminate this uninterruptible subcommand
	lda #0
	sta uni_subcom_high,x
	;jmp check_reset_cl
	rts
.)


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
	lda #>s_usc_dethroned2
	sta uni_subcom_high,x
	jmp s_usc_dethroned2
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
	;jsr step_character
	jmp step_character
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deal with a character who is looking for a seat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_usc_lchair
.(
	; If the character is midstride, then simply step him
	lda anim_state,x
	lsr
	bcs noturn

	sty tmp7
	jsr s_check_chair	; Returns Z=1 if there is a chair and C=1 if the 
						; character needs to turn round
	bne notyet
	ldy tmp7
	jmp s_knock_and_sit	
notyet
	ldy tmp3
	bcc noturn
	; Turn him round...
	jmp change_direction
noturn
	; Continue looking
	jmp step_character
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check whether a character was or can be punched by ERIC or ANGELFACE
; Used by the routines at 28446 and 28569. 
; On entry, E holds the x-coordinate of the spot three spaces in front 
; of ANGELFACE to check whether it's worth raising his fist (28446),
; or the x-coordinate of the spot two spaces in front of ERIC or ANGELFACE 
; when he has already raised his fist (28569). Returns with the carry flag 
; set if the potential victim is at the target coordinates and is facing the 
; right way.
; Gets the Id of the victim in reg Y and the position where it should be in
; order to be hit in reg A. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

punchable_victim
.(
	; Is the victim at the correct position?
	; First check column
	cmp pos_col,y
	beq col_valid
retnc
	clc
	rts

col_valid
	; Now check row
	lda pos_row,x
	cmp pos_row,y
	bne retnc

	; It is at the right coordinates, but is it facing the right way (that is
	; one facing the other?
	lda flags,x
	eor flags,y
	and #IS_FACING_RIGHT
	beq retnc

	; Finally let's make sure that the victim does not have an interruptible subcommand
	; active at the moment
	lda uni_subcom_high,y
	bne retnc

	; Ok, the victim is ready...
	sec
	rts
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a little boy trip people up
; The address of this continual subcommand routine is placed into 
; bytes 124 and 125 of little boy no. 1's character buffer by the 
; routine s_goto_random_trip , and into bytes 124 and 125 of the 
; character buffers of little boys 2-11 by the routine 
; s_follow_boy1. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

csc_trip_people_up
.(
	; Check the character is not on a staircase
	jsr is_on_staircase
	beq cont
retme
	rts
cont
	; Check the main character's positions
	lda #CHAR_BOYWANDER	
	sta patch_uplim+1
	lda #$ff
	sta patch_lowlim+1

patch_uplim
	ldy #CHAR_BOYWANDER
loop
	lda pos_col,x
	cmp pos_col,y
	bne next
	lda pos_row,x
	cmp pos_row,y
	beq found
next
	dey
patch_lowlim
	cpy #$ff
	bne loop

	; If already patched, we are done
	lda patch_uplim+1
	cmp #CHAR_WITHIT
	beq retme 
	; Now the teachers. Patch the above code
	lda #CHAR_WITHIT	
	sta patch_uplim+1
	lda #CHAR_BOY11
	sta patch_lowlim+1
	jmp patch_uplim
found
	; This character is at the same position, make it fall
	; Is there an uninterruptible subcommand for him?
	lda uni_subcom_high,y
	bne next
	
	jsr knock_him
	jmp next
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check whether ANGELFACE is touching ERIC 
; The address of this continual subcommand routine is placed into 
; bytes 124 and 125 of ANGELFACE's buffer by command list 220. 
; It checks whether ERIC and ANGELFACE are in the same location; 
; if they are, and ERIC has already been informed of ANGELFACE's 
; medical condition, bit 5 at special_playtime is set, indicating 
; that ERIC has mumps (whereupon MR ROCKITT will come looking for 
; ERIC to send him home). 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
csc_check_touch
.(
	; Has ERIC been told (and understood) that ANGELFACE has mumps?
	lda special_playtime
	and #%00001000
	bne cont
retme
	rts
cont
	; Make Angelface walk fast
	jsr csc_walk_fast
	; Now compare positions
	lda pos_col,x
	cmp pos_col
	bne retme
	lda pos_row,x
	cmp pos_row
	bne retme
	; They are, set bit 5 of special_playtime... beware they are
	; numbered 01234567
	lda special_playtime
	ora #%00000100
	sta special_playtime
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make BOY WANDER fire his catapult now and then 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
csc_bwander_fire
.(
	; Check if his coordinate is divisible by 4
	lda pos_col,x
	and #%11
	bne cont
	; Return if not
retme
	rts
cont
	; Check he is midstride
	lda anim_state,x
	ror
	bcs retme

	; Check he does not have an uninteruptible subcommand already
	lda uni_subcom_high,x
	bne retme

	; Generate a random number
	jsr randgen
	; This seems too often in the Oric ?
	;bcc retme	; return half the time
	cmp #200
	bcc retme

	; Check if he is on a staircase
	jsr is_on_staircase
	bne retme

	; Check if he can be seen by a teacher
	jsr can_be_seen
	bcs retme

	; Is the pellet already fired
	ldy #CHAR_BPELLET
	lda pos_col,y
	bpl retme

	; Ok he is about to fire...
	lda #<s_usc_bfire1
	sta uni_subcom_low,x
	lda #>s_usc_bfire1
	sta uni_subcom_high,x

	; Drop the return address and consider moving the next character
	pla
	pla
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make ANGELFACE hit now and then
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
csc_angelhit
.(
	; Return if Angelface is busy...
	lda uni_subcom_high,x
	beq cont
retme
	rts
cont
	; Return if he is not midstride
	lda anim_state,x
	ror
	bcc retme

	; Check if he is on a staircase
	jsr is_on_staircase
	bne retme

	; Check if he can be seen by a teacher
	jsr can_be_seen
	bcs retme

	; Check for potential victims...

	; Prepare the position where it would be hit
	lda flags,x
	and #IS_FACING_RIGHT
	beq left
	lda pos_col,x
	clc
	adc #3
	jmp done
left
	lda pos_col,x
	sec
	sbc #3
done
	sta smc_tpos+1
	
	ldy #0
	sty tmp
loop
	cpy #CHAR_ANGELFACE
	beq skip
smc_tpos
	lda #0
	jsr punchable_victim
	bcs victimok
skip
	inc tmp
	ldy tmp
	cpy #CHAR_BOY8
	bne loop

exit
	; We found no victim, return
	rts

victimok
	lda anim_state,y
	cmp #5
	bcs exit

	; We found a possible victim, let's punch him!
	; Put the uninterruptable subcommand
	; Make ANGELFACE throw a punch (1)

	lda #<s_usc_apunch1
	sta uni_subcom_low,x
	lda #>s_usc_apunch1
	sta uni_subcom_high,x

	; Pop the return address to consider moving next char
	;pla
	;pla
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character walk fast
; The address of this continual subcommand routine
; is placed into bytes 124 and 125 of a character's
; buffer by command lists 214 and 218. This routine
; is also used directly by the routines 
; s_isc_find_Eric, and others
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
csc_walk_fast
.(
	; Set the speed change delay
	; to 4, preventing any change by the routine
	; which determines if a character should be moved
	lda #4
	sta speed_counter,x
	; Reset but 7 of flags
	lda flags,x
	and #(IS_SLOW_WALK^$ff)
	sta flags,x
	rts
.)

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
	ror 
	bcs onlystep
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher wait for EINSTEIN to finish
; speaking.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_isc_waitEinstein
.(
	lda lesson_signals
	lsr
	bcc end
	rts
end
	jmp terminate_subcommand
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make Einstein speak
; Pass the message in reg A (low) and Y 
; (high)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_make_Einstein_speak
.(
	sta tmp0
	sty tmp0+1

	ldy #CHAR_EINSTEIN
	lda tmp0
	sta var3,y
	lda tmp0+1
	sta var4,y

+Einstein_turn	
	; Signal that it is Einstein's turn to speak
	lda lesson_signals
	ora #%1
	sta lesson_signals

	; Set the interruptible subcommand for this teacher
	; to s_isc_waitEinstein

	lda #<s_isc_waitEinstein
	sta i_subcom_low,x
	lda #>s_isc_waitEinstein
	sta i_subcom_high,x

	; Put the return address in the current command
	; of the teacher, so control resumes there when he
	; finishes waiting for Einstein to speak
	pla	; get LSB
	sta tmp
	pla	; get HSB
	sta tmp+1
	inc tmp
	bne noadj
	inc tmp+1
noadj
	; And place it as the current command address...
	lda tmp
	sta cur_command_low,x
	lda tmp+1
	sta cur_command_high,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a character write on a blackboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_isc_write
.(
	; Get the nearest blackboard in tmp3
	jsr get_blackboard
	ldy #4
	lda (tmp3),y	; Who wrote there?
	bmi cont
	jmp terminate_subcommand
cont
	; The board is clean... go and write on it
	; Store the id of the character who is writting
	txa
	sta (tmp3),y
	; Zero out submessages
	lda #0
	sta var5,x
	sta var6,x
	cpx #CHAR_FIRST_TEACHER
	bcc isbwander
	; We are dealing with a teacher
	lda #<st_teachboard
	sta tmp0
	lda #>st_teachboard
	sta tmp0+1
	jsr randgen
	and #%111
	sta tmp
	; Select the set depending on the teacher
	txa
	sec
	sbc #CHAR_FIRST_TEACHER
	asl
	asl
	asl
	clc
	adc tmp
	jmp continue
isbwander
	; It is Boy Wander get a message
	lda #<st_bwboard
	sta tmp0
	lda #>st_bwboard
	sta tmp0+1
	jsr randgen
	and #%111
continue
	jsr search_string
	lda tmp0
	sta var3,x
	lda tmp0+1
	sta var4,x

	; And set the next address to his subcommand pointer (below)
	lda #<make_him_write
	sta i_subcom_low,x
	lda #>make_him_write
	sta i_subcom_high,x
make_him_write
	jsr write_char_board
	bne notfinished
	jsr update_animstate
	jmp terminate_subcommand
notfinished
	cpx #CHAR_FIRST_TEACHER
	bcs teacheranim
	; Animating Boy Wander
	lda #9
	cmp anim_state,x
	beq flop
	.byt $2c
flop
	lda #10
	jmp update_animstate
teacheranim
	; Get animatory state
	lda anim_state,x
	beq rise_arm
	lda #0
	.byt $2c
rise_arm
	lda #4
	jmp update_animstate
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher wipe a blackboard (1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_isc_wipe1
.(
	; Make sure the teacher is facing left
	lda flags,x
	and #IS_FACING_RIGHT
	beq heis
	jsr change_direction
heis

	jsr get_blackboard
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make a teacher wipe a blackboard (2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_isc_wipe2
.(
	; Set the address if the command to after_prepare, once
	; this initialization has been done
	lda #<after_prepare
	sta i_subcom_low,x
	lda #>after_prepare
	sta i_subcom_high,x

	; Wiping requires 11*3 steps, put that value in var3
	lda #33
	sta var3,x
	; Store the y coordinate of the top row/left col of the blackboard
	ldy #5
	lda (tmp3),y
	clc
	adc #10
	sta var4,x
	iny
	lda (tmp3),y
	sta var5,x
after_prepare
	; Each subsequent call enters at this point
	; Decrement the number of steps to be done
	dec var3,x
	bmi finished

	; Check if the teacher has his arm raised or not
	lda anim_state,x
	cmp #4
	beq wipe
	lsr
	bcs check2
	; Time to rise hand
	lda #4
	jmp update_animstate
check2
	; He must perform a step
	jmp step_character
wipe
	; Lower his arm
	lda #0
	jsr update_animstate
	jsr step_character

	; Ready to clean column var4
	jsr get_blackboard
	; Get pointer to base tile
	ldy #0
	lda (tmp3),y
	sta tmp0
	iny
	lda (tmp3),y
	sta tmp0+1

	; Now need to set up several things...
	; First need to get the x coord of the blackboard
	ldy #5
	lda (tmp3),y
	sta tmp
	; Now calculate the XY of the tile to be wiped
	lda var5,x	; Y pos of the blackboard tile
	sta y_coord+1	; Store for later
	lda var4,x	; X pos of blackboard tile
	sta x_coord+1	; Store for later
	sec
	sbc tmp		; Relative X coordinate
	; Now point to the correct UDG
	asl
	asl
	asl
	clc
	adc tmp0
	sta tmp0
	bcc nocarry1
	inc tmp0+1
nocarry1

	lda #11*8
	clc
	adc tmp0
	sta tmp1
	lda #0
	adc tmp0+1
	sta tmp1+1

	; Clear the udg data
.(
	ldy #7
	lda #$7f
wipeloop
	sta (tmp0),y
	sta (tmp1),y
	dey
	bpl wipeloop
.)

	stx savx+1
	; Tell the engine to redraw these tiles
x_coord
	ldx #0
y_coord
	ldy #0
	jsr update_SRB
	ldx x_coord+1
	ldy y_coord+1
	iny
	jsr update_SRB

savx
	ldx #0
	; Tell this column has been wiped
	dec var4,x
	rts

finished
	; get the blackboard
	jsr get_blackboard
	; Set tile=0 and col=1
	ldy #2
	lda #1
	sta (tmp3),y
	iny
	lda #0
	sta (tmp3),y
	; Mark the board as wiped
	iny
	lda #$ff
	sta (tmp3),y
	ldy #11
	lda #0
	sta (tmp3),y

	; Put the teacher back at animstate 0
	lda #0
	jsr update_animstate
	jmp terminate_subcommand
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make a teacher find the truant ERIC
;; Used by the routine s_dinner_duty, which also 
;; places the address of this interruptible 
;; subcommand routine into bytes 105 and 106 
;; of the teacher's buffer when ERIC is absent 
;; during dinner or class. It makes the teacher 
;; run after and stalk ERIC until he goes to 
;; wherever he should be (the dinner hall or the 
;; classroom). 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
s_isc_findEric
.(
	; Make the teacher walk fast
	jsr csc_walk_fast

	; Determine which way the teacher needs
	; to go to find Eric
	ldy #CHAR_ERIC
	jsr which_way
	sta sav_retwhich+1
	beq same_location
	cmp #3
	bcc on_staircase
same_location
	; If the teacher's list has been marked for a restart
	; do so
	lda flags,x
	and #RESET_COMMAND_LIST
	beq noreset
	jmp terminate_subcommand
noreset
	jsr s_check_Eric_loc
	bne notwhereshould 


	; Eric is where he should be, so time to
	; resume his clasroom duties

	; This is quite tricky. It gets the command
	; list back to the second-from-last occurrence
	; of a SC_GOTO command.

	ldy pcommand,x
	lda command_list_high,x
	sta tmp0+1
	lda command_list_low,x
	sta tmp0
	
	lda #2
	sta tmp
loop
	lda (tmp0),y
	; BEWARE SC_GOTO is 1, which is never used as
	; a parameter, or it will break!
	cmp #SC_GOTO
	beq done
	dey
	bpl loop
done
	dec tmp
	bne loop

	; Restart from this point
	tya
	sta pcommand,x
	jmp next_command

on_staircase
notwhereshould
	; Eric is not where he should, or the teacher
	; is on a staircase
sav_retwhich
	lda #0
	bne do_move
	; They are at the same position
	; Make the teacher turn round from time to time 
	lda via_t1cl
	bne skip
	jmp change_direction
skip
	rts

	; This entry point is used by the routine 
	; at 63374 with X holding the number of a 
	; character looking for ERIC (which will be 
	; little boy no. 10 or a teacher), and A 
	; holding 1, 2, 3 or 4 (indicating the 
	; character's next move).

+do_move
	; Here it calls the routine that moves a character
	; looking for Eric from midstride position, at
	; different places
	
	cmp #3
	bcs s_isc_movemidstride_ex
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move a character looking for ERIC to the 
; midstride position.
; Continues from s_isc_findEric. 
; Moves the character looking for ERIC to the 
; midstride position in the appropriate direction. 
; The main entry point is used when the character 
; is on a staircase. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s_isc_movemidstride
.(
	cmp #1
	beq upstairs
	jmp down_a_stair
upstairs
	jmp up_a_stair

+s_isc_movemidstride_ex
	cmp #3
	beq going_left
	lda flags,x
	and #IS_FACING_RIGHT
	bne doit
turnround
	jmp change_direction
doit
	jmp step_character
going_left
	lda flags,x
	and #IS_FACING_RIGHT
	bne turnround
	beq doit
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Determine the next move of a character following 
; another character. The follower is passed in 
; reg X and the objective in reg Y.
; Used by several routines such as s_isc_findEric.
; Returns with one of the following values in A 
; depending on the relative locations of the 
; follower and his target
; 0 Follower is at the same coordinates as the target 
; 1 Follower should go (or continue going) upstairs 
; 2 Follower should go (or continue going) downstairs 
; 3 Follower should go left 
; 4 Follower should go right 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


which_way
.(
	; Check if the follower is on a staircase
	jsr is_on_staircase
	beq notonstaircase

	; He is, find out whether he is going up or down,
	; and set reg A accordingly.
	lda pos_col,x
	cmp #WALLTOPFLOOR
	bcs rightstair
	; We are at a staircase at the left of the school
	lda flags,x
	and #IS_FACING_RIGHT
	bne going_down
going_up
	lda #1
	rts
going_down
	lda #2
retme
	rts
rightstair
	; We are at a staircase at the right of the school
	lda flags,x
	and #IS_FACING_RIGHT
	beq going_down
	bne going_up

notonstaircase
	; The follower is not on a staircase, which way should
	; he go?

	; Get the objective coordinates
	cpy #CHAR_ERIC
	bne notEric
	jsr get_Eric_Ycoord
	sta tmp0
	jmp cont 
notEric
	lda pos_row,y
	sta tmp0
cont
	lda pos_col,y
	sta tmp0+1

	; Are the target and follower on the same floor?
	lda tmp0
	cmp pos_row,x
	bne notsamefloor

	; Ok, they are, but there may be a wall between them...
	lda pos_col,x
	sec
	sbc tmp0+1
	beq retme ; They are at the same spot.
	
	; Is the follower on the bottom floor?
	lda pos_row,x
	cmp #17
	bne notbottom

	; Both are on the bottom floor, so the follower
	; must simply go either left or right
compare
	lda tmp0+1
	cmp pos_col,x
addandret
	lda #3
	adc #0
	rts

notbottom
	; Follower and target both on the middle or 
	; top floors.
	cmp #10
	bne topfloor
	lda #WALLMIDDLEFLOOR
	.byt $2c
topfloor
	lda #WALLTOPFLOOR
	cmp pos_col,x
	bcc follower_right
	cmp tmp0+1
	bcs compare

follower_left
	;The follower is on the left side of the 
	;skool and must go downstairs to get to 
	;the target on the other side of the skool.

	lda #STAIRLTOP
	cmp pos_col,x
	bne addandret

	; The follower is at the top of the staircase
	lda flags,x
	and #IS_FACING_RIGHT
	bne facingright
	lda #4	; Turn around
	rts
facingright
	lda #2	; Go downstairs 
	rts

follower_right
	; The follower is at the right side fo the skool. 
	; Where is the target?
	cmp tmp0+1
	bcc compare

follower_right2
	; Need to take stairs...
	lda #STAIRRTOP
	cmp pos_col,x
	bne addandret

	; The follower is at the top of the staircase
	lda flags,x
	and #IS_FACING_RIGHT
	beq facingleft
	lda #3	; Turn around
	rts
facingleft
	lda #2	; Go downstairs
	rts

notsamefloor
	; The follower and target are on 
	; different floors.

	bcc above	; follower < objective, so above.
	
	; So the objective is below, we need to take a 
	; staircase
	lda pos_row,x
	cmp #10
	beq middlefloor2
	lda #WALLTOPFLOOR
	.byt $2c
middlefloor2
	lda #WALLMIDDLEFLOOR
	cmp pos_col,x
entrypoint2
	bcs follower_left
	bcc follower_right2

above
	; The target is on a floor above the follower. 
	; Which staircase should the follower use?
	lda tmp0
	cmp #10
	beq middlefloor3
	lda #WALLTOPFLOOR
	.byt $2c
middlefloor3
	lda #WALLMIDDLEFLOOR
	cmp tmp0+1
	bcc target_right
target_left
	; Signal target at the left
	lda #1
	.byt $2c
target_right
	; Signal target at the right
	lda #128
	sta tmp

	; Check the floor the chaser is on
	lda pos_row,x
	cmp #17
	bne chaseratmiddle
entrypoint1
	lda #STAIRLBOTTOM
	; Was the target at the left?
	dec tmp
	beq wasleft
	lda #STAIRRBOTTOM
wasleft
	cmp pos_col,x
	beq cont1
	jmp addandret
cont1
	;bne addandret
	
	cmp #STAIRLBOTTOM
	beq upleftstair

	lda flags,x
	and #IS_FACING_RIGHT
	bne facingright2
	lda #4
	rts
facingright2
	lda #1
	rts

upleftstair
	lda flags,x
	and #IS_FACING_RIGHT
	beq facingleft2
	lda #3
	rts
facingleft2
	lda #1
	rts

chaseratmiddle
	; The follower is on the middle floor, 
	; and the target is on the top floor.	

	lda #WALLMIDDLEFLOOR
	cmp pos_col,x
	lda #128
	bcc skip2
	lda #1
skip2
	sta tmp+1
	lda tmp
	cmp tmp+1
	beq entrypoint1
	jmp entrypoint2
.)









