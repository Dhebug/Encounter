;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Common routines
;; ---------------


#include "params.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Searches for a string. tmp0 holds pointer
;; to base and A holds offset (in strings).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
search_string
.(
	stx savex+1	; Preserve reg x
    tax
    bne cont
	ldx savex+1
    rts
cont
    ldy #0
loop
    lda (tmp0),y
    beq out    ; Search for zero
    iny
    bne loop

out
    ; Found the end. 
	; Skip consecutive zeros
loop2
	iny
	lda (tmp0),y
	beq loop2
	
	;Add length to pointer    
    tya
    clc
    adc tmp0
    bcc nocarry
    inc tmp0+1
nocarry
    sta tmp0    

    dex
    bne cont
  
savex
	ldx #0	; restore reg x
    rts
.)


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Determine the floor nearest to 
;; a character passed in reg x
;; Returns the floor coordinate
;; in register a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

nearest_floor
.(
	lda pos_row,x
	; Entry point when a has already been loaded
+nearest_floor_ex
	; If the character is not on a staircase
	; then the floor coordinate is the same
	; as its pos_row
;	jsr is_on_staircase
;	bne cont
;	rts
;cont
	; WARNING-If we put back the above code,
	; it cannot be reused for teachers.

	; Check the nearest floor
	; floors are in 3,10 and 17
	cmp #3+3
	bcs nobottom
	lda #3
	rts
nobottom
	cmp #10+3
	bcs nomiddle
	lda #10
	rts
nomiddle
	lda #17
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Get the x-coordinate range within which 
;; a character (reg x) can see or be seen.
;; Returns with tmp0 and tmp0+1 holding the 
;; bounding x-coordinates of the range 
;; within which the target character can see 
;; or be seen. 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
visibility_range
.(
	jsr nearest_floor
	sta tmp
	; Entry point if we already have in
	; reg a the calculated nearest floor
+vis_range_ex
	; Set maximum range
	lda #0
	sta tmp0
	lda #127
	sta tmp0+1

	; Get character's x-coordinate
	lda pos_col,x
	sec
	sbc #VIS_RANGE_X
	; If the x-coordinate is < 10 then we have
	; already the lower bound
	bcc upperbound

	; Save x_coord-10
	sta tmp0

	; Get the nearest floor back, to take walls
	; into account
	lda tmp
	cmp #17
	beq upperbound
	cmp #3
	bne middlefloor
	; The character is on the top floor
	lda #WALLTOPFLOOR
	.byt $2c
middlefloor
	; The character is on the middle floor
	lda #WALLMIDDLEFLOOR
	cmp tmp0
	bcc upperbound
	; The character is less than 10 
	; paces to the right of a wall or
	; to its left
	; Is he to the left of a wall?
	cmp pos_col,x
	bcs upperbound
	; Ok the wall is limitting his field of view
	sta tmp0
upperbound
	; Now tmp0+1 holds the lower bound of the 
	; visibilty range, now compute the upper bound
	lda pos_col,x
	clc
	adc #VIS_RANGE_X
	; Is the character within 10 paces of the far right end?
	cmp tmp0+1
	bcc cont
retme
	rts	; All done, return
cont
	sta tmp0+1
	; Get the floor
	lda tmp
	cmp #17
	beq retme	; Return if in the bottom floor
	cmp #3
	bne middlefloor2
	; The character is on the top floor
	lda #WALLTOPFLOOR
	.byt $2c
middlefloor2
	; The character is on the middle floor
	lda #WALLMIDDLEFLOOR
	cmp tmp0+1
	bcs retme	; All done
	cmp pos_col,x
	bcc retme	; All done
	sta tmp0+1
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Check whether a boy can be seen by a teacher
;; Returns with the carry flag set if 
;; the boy in reg X can be seen by a teacher, 
;; and the teacher's character number in reg A. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
can_be_seen
.(
	; Get the visibility rage in tmp0, tmp0+1
	jsr visibility_range

	; Get floor
	jsr nearest_floor
	sta smc_floor+1

	; Loop through teachers
	ldy #3
loop
	lda uni_subcom_high+CHAR_FIRST_TEACHER,y
	bne next
	lda pos_col+CHAR_FIRST_TEACHER,y
	cmp tmp0
	bcc next
	cmp tmp0+1
	bcc foundit
next
	dey
	bpl loop

	; We did not find a teacher
	clc
	rts
foundit
	; Now check y coordinate
	; BE CAREFUL IF WE PUT BACK THE is_on_staricase
	; in nearest_floor!
	lda pos_row+CHAR_FIRST_TEACHER,y
	jsr nearest_floor_ex
smc_floor
	cmp #0		;pos_row,x
	bne next	; Try another teacher

	; The teacher is close, but is he facing
	; the right way?

	lda flags+CHAR_FIRST_TEACHER,y
	and #IS_FACING_RIGHT
	php

	lda pos_col,x
	cmp pos_col+CHAR_FIRST_TEACHER,y
	bcs mustlookright
	; Must be facing left
	plp
	bne next	; If not try another teacher
	beq done
mustlookright
	; Must be facing right
	plp
	beq next
done
	; We found it!
	tya
	clc
	adc #CHAR_FIRST_TEACHER
	sec
	rts
.)


prepare_box
.(
  	; Get spot's above character's head
	; This uses the bubble variables, so I will
	; save them first
	lda bubble_col
	pha
	lda bubble_lip_col
	pha
	lda bubble_row
	pha
	lda bubble_lip_row
	pha
	

	jsr bubble_coords
	
	; Adjust the position, if the teacher is down
	lda anim_state,x
	cmp #5
	bne skipthis
	inc bubble_row
skipthis

	; Adjust the position if the bubble is in the right border
	lda bubble_col
	cmp #LAST_VIS_COL-8
	bne skipthistoo
	sec
	sbc #3		; this is 3 squares bigger
	sta bubble_col
skipthistoo

	; Calculate the pointer
	ldx bubble_row
	ldy tab_mul8,x			
	lda _HiresAddrHigh,y    
	sta tmp3+1				
	lda _HiresAddrLow,y 
	clc						
	adc bubble_col
	sta tmp3					
	bcc skip				
	inc tmp3+1				
skip
	; We have in tmp3 the pointer to the
	; screen where the message will go.

	; Now get the bubble variables back

	pla
	sta bubble_lip_row
	pla
	sta bubble_row
	pla
	sta bubble_lip_col
	pla
	sta bubble_col

	
	; Save the screen data
	jmp save_buffer
.)

show_box
.(
  	lda tmp3
	sta tmp1
	lda tmp3+1
	sta tmp1+1

	; Let's try to add some temporary color
	jsr color_box
	jmp dump_text_buffer
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make a teacher give lines to somebody
;; The teacher is passed in reg X and the recipient
;; in reg Y. The reprimand message is passed on
;; reg A.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
give_lines
.(
	; Save reprimand message identifier
	sta sava+1

	; Check if the teacher is onscreen
	jsr is_on_screen
	bcc cont
	beq cont
	rts
cont
	sty savy+1		; Save register Y
	stx savx+1		; Save register X

	jsr prepare_box

	; Ok now write the lines...
	; Start by determining the number of lines that
	; will be given (divided by 10).

	jsr randgen
	and #%111
	tay
	lda tab_lines,y

	sta smc_savop2+1

	; Deal with the lines given...
	ldy savy+1
	beq toEric
	; They are not given to Eric... add to the score
	jsr add_score
	jmp linesend	; Always jump
toEric
	jsr add_lines

linesend
smc_savop2
	lda #0
	sta op2
	lda #0
	sta op2+1
	jsr utoa

	lda bufconv
	sta st_lines

	lda bufconv+1
	sta st_lines+1

#ifdef BRK2SETTMP0
	brk
	.word st_lines
#else
	lda #<st_lines
	sta tmp0
	lda #>st_lines
	sta tmp0+1
#endif

	jsr write_text_up

#ifdef BRK2SETTMP0
	brk
	.word names_extras
#else
	lda #<names_extras
	sta tmp0
	lda #>names_extras
	sta tmp0+1
#endif
	lda savy+1
	clc
	adc #1
	jsr search_string
	jsr write_text_down
	jsr show_box
	jsr SndLines1

	; Now the reprimand
#ifdef BRK2SETTMP0
	brk
	.word reprimands
#else
	lda #<reprimands
	sta tmp0
	lda #>reprimands
	sta tmp0+1
#endif
sava
	lda #0
	jsr search_string
	jsr write_text_up

#ifdef BRK2SETTMP0
	brk
	.word reprimands
#else
	lda #<reprimands
	sta tmp0
	lda #>reprimands
	sta tmp0+1
#endif
	lda sava+1
	clc
	adc #1
	jsr search_string
	jsr write_text_down

	; Show the reprimand box
	jsr show_box
	jsr SndLines2

	; Restore the screen data
	jsr restore_buffer

	; Restore registers back
savx
	ldx #0
savy 
	ldy #0
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add content of reg A to score
;; and update scorebox
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

add_score
.(
	; If in demo mode, don't do anything
	ldy game_mode
	beq nohiscore

	clc
	adc score
	sta score
	bcc nocarry
	inc score+1
nocarry
	ldy #0
	jsr update_scorepanel

	; are we in the pressence of a hi-score?
    lda hiscore
    cmp score
    lda hiscore+1
    sbc score+1
    bvc ret ; N eor V
    eor #$80
ret
	bcs nohiscore
	; We are, update this...
	lda score
	sta hiscore
	lda score+1
	sta hiscore+1
	ldy #4
	jmp update_scorepanel
nohiscore
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add content of reg A to lines
;; and update scorebox
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

add_lines
.(
	clc
	adc lines
	sta lines
	bcc nocarry
	inc lines+1
nocarry
	ldy #2
	jsr update_scorepanel

	; Check if Eric went over the limit
    lda lines
    cmp #<1000
    lda lines+1
    sbc #>1000
    bvc skip ; N eor V
    eor #$80
skip
	bcs endgame
retme
	rts
endgame
	
	; We have reached the limit. End
	; the current game

	; Make the command list of Mr Wacker
	; be endgame_command_list
	ldy #CHAR_WACKER
	lda #<endgame_command_list
	sta command_list_low,y
	lda #>endgame_command_list
	sta command_list_high,y

	; Trigger a command list restart for
	; Mr Wacker
	lda #RESET_COMMAND_LIST
	ora flags,y
	sta flags,y

	; Trick to avoid the lesson to change in a while...
	lda #255
	sta lesson_clock+1
	rts
.)


wait
.(
	lda counter
	pha
	lda #$e0
	sta counter
loop
	lda counter
	bne loop
	pla 
	sta counter
	rts

.)


uncolor_box
.(
	lda #$29	; and opcode
	sta smc_col
	lda #%01111111
	sta smc_col+1
	jmp common_col_box
.)

color_box
.(
	lda #$09	; ora opcode
	sta smc_col
	lda #%10000000
	sta smc_col+1
+common_col_box
	lda #<buffer_text
	sta tmp
	lda #>buffer_text
	sta tmp+1

	ldx #3
loop2
	ldy #(BUFFER_TEXT_WIDTH*8-1)
loop
	lda (tmp),y
+smc_col
	ora #%10000000
	sta (tmp),y
	dey
	bpl loop

	lda tmp
	clc
	adc #BUFFER_TEXT_WIDTH*8
	sta tmp
	bcc nocarry
	inc tmp+1
nocarry
	dex
	bne loop2
	
	rts
.)


restore_buffer
.(

	lda #<tmp1
	ldy #<tmp2
	jmp common_save_res
.)

save_buffer
.(

	lda #<tmp2
	ldy #<tmp1

+common_save_res
	sta loopscans+1
	sty loopscans+3

	lda #<temp_buffer
	sta tmp1
	lda #>temp_buffer
	sta tmp1+1

	lda tmp3
	sta tmp2
	lda tmp3+1
	sta tmp2+1


	ldx #8*3
looprows
	ldy #BUFFER_TEXT_WIDTH-1									
loopscans
	lda (tmp2),y
	sta (tmp1),y
	dey
	bpl loopscans

	lda tmp1
	clc
	adc #BUFFER_TEXT_WIDTH
	sta tmp1
	bcc nocarry
	inc tmp1+1
nocarry

	lda tmp2
	clc
	adc #40
	sta tmp2
	bcc nocarry2
	inc tmp2+1
nocarry2
	dex
	bne looprows
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make a stricken teacher give lines 
;; or reveal his safe combination letter
;; Used by the routine s_usc_knocked. 
;; If the character who has been knocked 
;; over is a teacher, this routine makes 
;; him reveal his safe combination letter 
;; (if all the shields are flashing but 
;; the safe has not been opened yet) and 
;; give lines the nearest main kid (if any 
;; are close enough). 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 
teacher_knocked
.(
	; First check if the character is a teacher
	cpx #CHAR_FIRST_TEACHER
	bcs cont
	rts
cont
	; Time for what?
	lda var7,x
	cmp #18
	beq reveal
	cmp #9
	beq glines
retme
	rts
glines
	; Get rid of context
	pla
	pla

	; Make the teacher give lines
	; First get the visibility range of the teacher
	; in tmp0, tmp0+1
	jsr visibility_range
	
	txa
	tay

	;Loop through the main kids
	lda #100
	sta tmp1
	lda #$ff
	sta tmp1+1

	ldx #CHAR_BOYWANDER
loopchars
	; Is the kid on the same floor as the teacher?
	jsr nearest_floor
	cmp pos_row,y
	bne nextkid

	; A kid on the same floor... check the
	; x-coordinate
	lda pos_col,x
	cmp tmp0
	bcc nextkid
	cmp tmp0+1
	bcs nextkid
	
	; He is in the visible range, check if he is closer
	; than the previous one
	sec
	sbc pos_col,y
	bpl noabs
	sta tmp
	lda #0
	sec
	sbc tmp
noabs
	cmp tmp1
	bcs nextkid
	; He is closer, save his ID and distance
	sta tmp1
	stx tmp1+1
nextkid
	dex
	bpl loopchars

	; get back register X
	tya
	tax

	; Who was the nearest one?
	ldy tmp1+1
	bmi retme
givelines
	
	lda #DO_AGAIN
	jmp give_lines

reveal
	; Check if it is time to reveal the combination
	; letter
	lda game_mode
	cmp #2
	bne retme

	; Is the character a teacher?
	cpx #CHAR_FIRST_TEACHER+1	; Add one to avoid checking Mr Creak.
	bcc retme
	cpx #CHAR_WITHIT+1
	bcs retme

	; It is, prepare his combination letter

	; Entry point to make Mr Creak reveal his combination letter
	; after seeing his birth year in a blackboard
+reveal_entry
	
	jsr is_on_screen
	bcs retme

	stx savx+1
	sty savy+1

/*
	txa
	sec
	sbc #CHAR_CREAK
	tay
	lda tab_safecodes,y
*/
	lda tab_safecodes-CHAR_CREAK,x
	sta st_safeletter

	; And show it
	jsr prepare_box
#ifdef BRK2SETTMP0
	brk
	.word st_space
#else
	lda #<st_space
	sta tmp0
	lda #>st_space
	sta tmp0+1
#endif
	jsr write_text_up

#ifdef BRK2SETTMP0
	brk
	.word st_safeletter
#else
	lda #<st_safeletter
	sta tmp0
	lda #>st_safeletter
	sta tmp0+1
#endif
	jsr write_text_down

	jsr show_box
	jsr SndSafeLetter

	; Restore the screen data
	jsr restore_buffer
savx
	ldx #0
savy
	ldy #0
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inverts the shield of ID passed
; in reg Y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
invert_shield
.(
	lda tab_sh_udgh,y
	sta tmp+1
	lda tab_sh_udgl,y
	sta tmp

	; Invert it
.(
	ldy #7
loopi
	lda (tmp),y
	pha
	dey
	bne loopi

	ldy #7
loopi2
	pla
	sta (tmp),y
	dey
	bne loopi2
.)
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get the identifier of the blackboard
; closest to a character, return a pointer 
; to the id block in tmp3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_blackboard
.(
	; Assume it is the reading room
	ldy	#0
	lda pos_row,x
	cmp #3
	beq found
	; Distinguish from white and exam rooms 
	lda pos_col,x
	cmp #WALLMIDDLEFLOOR
	bcc white
	ldy #2
	bne found	; Jumps always		
white
	ldy #1
found
	lda tab_bboards_low,y
	sta tmp3
	lda tab_bboards_high,y
	sta tmp3+1
	rts
.)

#ifndef BRK2SETTMP0
set_hires
.(
	lda #30
	;lda $f934
	sta $bfdf
	
	lda #A_BGBLACK 
	sta $bf68
	sta $bf68+40
	sta $bf68+40*2
	rts
.)

clr_hires
.(
	ldy #<($a000)
	sty tmp
	ldy #>($a000)
	sty tmp+1
	ldx #176
loop2
	ldy #39
	lda #$40
loop
	sta (tmp),y
	dey
	bpl loop

	jsr add40tmp
	dex
	bne loop2
end
	rts	
.)
#endif

