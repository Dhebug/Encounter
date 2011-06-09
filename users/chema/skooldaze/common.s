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





