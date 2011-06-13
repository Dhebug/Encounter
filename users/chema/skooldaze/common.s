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
	cmp #3
	beq upperbound
	cmp #17
	bne middlefloor
	; The character is on the top floor
	lda #WALLTOPFLOOR
	.byt $2c
middlefloor
	; The character is on the middle floor
	lda #WALLMIDDLEFLOOR
	cmp tmp0
	bcs upperbound
	; The character is less than 10 
	; paces to the right of a wall or
	; to its left
	; Is he to the left of a wall?
	cmp pos_col,x
	bcc upperbound
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
	cmp #3
	beq retme	; Return if in the bottom floor
	cmp #17
	bne middlefloor2
	bne middlefloor
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
	cmp pos_row,x
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

	; Checck if the teacher is onscreen
	jsr is_on_screen
	bcc cont
	beq cont
	rts
cont
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
	lda bubble_row
	
	stx savx+1		; Save register X

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
	lda bubble_lip_row
	pla
	lda bubble_row
	pla
	lda bubble_lip_col
	pla
	lda bubble_col

	
	; Save the screen data
	jsr save_buffer

	; Ok now write the lines...
	; Start by determining the number of lines that
	; will be given (divided by 10).

	jsr randgen
	and #%111
	tay
	lda tab_lines,y

	sta op2
	lda #0
	sta op2+1
	jsr utoa

	lda bufconv
	sta st_lines

	lda bufconv+1
	sta st_lines+1
	
	lda #<st_lines
	sta tmp0
	lda #>st_lines
	sta tmp0+1

	lda #<buffer_text+BUFFER_TEXT_WIDTH*4
	sta tmp1
	lda #>buffer_text+BUFFER_TEXT_WIDTH*4
	sta tmp1+1

	jsr write_text

	lda #<names_extras
	sta tmp0
	lda #>names_extras
	sta tmp0+1
	lda savy+1
	clc
	adc #1
	jsr search_string

	lda #<buffer_text+BUFFER_TEXT_WIDTH*12
	sta tmp1
	lda #>buffer_text+BUFFER_TEXT_WIDTH*12
	sta tmp1+1

	jsr write_text

	lda #<buffer_text
	sta tmp0
	lda #>buffer_text
	sta tmp0+1

	lda tmp3
	sta tmp1
	lda tmp3+1
	sta tmp1+1

	; Let's try to add some temporary color
	jsr color_box
	jsr dump_text_buffer
	jsr wait

	; Now the reprimand
	lda #<reprimands
	sta tmp0
	lda #>reprimands
	sta tmp0+1
sava
	lda #0
	jsr search_string

	lda #<buffer_text+BUFFER_TEXT_WIDTH*4
	sta tmp1
	lda #>buffer_text+BUFFER_TEXT_WIDTH*4
	sta tmp1+1

	jsr write_text

	lda #<reprimands
	sta tmp0
	lda #>reprimands
	sta tmp0+1
	lda sava+1
	clc
	adc #1
	jsr search_string

	lda #<buffer_text+BUFFER_TEXT_WIDTH*12
	sta tmp1
	lda #>buffer_text+BUFFER_TEXT_WIDTH*12
	sta tmp1+1

	jsr write_text

	lda #<buffer_text
	sta tmp0
	lda #>buffer_text
	sta tmp0+1

	lda tmp3
	sta tmp1
	lda tmp3+1
	sta tmp1+1

	; Let's try to add some temporary color
	jsr color_box
	jsr dump_text_buffer
	jsr wait

	; Restore the screen data
	jsr restore_buffer

	; Restore registers back
savx
	ldx #0
savy 
	ldy #0


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
	beq lines
	rts
lines
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
	bpl givelines
	; Nobody, just return
	rts
givelines
	
	lda #DO_AGAIN
	jmp give_lines

reveal
	; Check if it is time to reveal the combination
	; letter
	lda game_status
	cmp #2
	beq reveal_letter
	rts
reveal_letter

	; TODO... everything here
	rts
.)


