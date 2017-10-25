;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include "debug.h"
#include "box.h"



; Walk boxes and walk matix stuff

; A walk box is a structure with
; five bytes, with the corner and
; size information as follows:
; col-min, col-max, row-min, row-max
; and an additional byte with the zplane
; information and some flags:
; More than 8 zplanes are improbable, so the
; 3 lsb will store this information and
; the 5 msb will be flags.
; fffffzzz
; Check if using two bytes is more efficient in the end.
; Flags indicate special boxes, as in the C64 version of
; scumm. For instance boxes at the side of the rooms, which
; are not really squared (one bitflag for each side).
; I think another flag is used to indicate that a given box
; is not walkable temporary (has disappeared)

; Walkbox bitflag:              76543210
;			   	|||||\_/
;			   	||||| |
;			   	||||| +- z-plane
;			   	|||||
;			   	||||+- free
;			   	|||+- free
;			   	||+- left corner
;			   	|+- right corner
;				+- not walkable

; A walk matrix is a matrix of MxM, where M is the number of 
; boxes in the room. If the entry at (x,y) is z >= 0 it means that
; it is possible to walk from box x to y, through box z. If the entry
; is <0 it is not possible. This way clearing/setting bit 7 of an entry is enough to
; activate/deactivate it.


; Table to handle corner walkboxes
; moved to tables.s


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if a point is inside
; a walk box.
; pointer to walkbox in tmp0
; row, col coordinates in Y, X
; Returns Z=1 if point is inside
; the walkbox, Z=0 otherwhise
; Also returns some sort of
; distance in reg A, calculated
; as the sum of distances from
; point row and col to box limits
; It does not modify regs X nor Y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
isPointInWalkBox
.(
	sty savY+1
	stx savX+1
	txa
	ldy #0

	sec
	sbc (tmp0),y ; col-min
	bcc outside_col

	iny
	txa
	sec
	sbc (tmp0),y ; col-max
	beq cont1
	bcs outside_col

cont1	
	lda #0	; Column distance is zero
outside_col
	; reg A carries the distance to the col, N=1
	; indicates if we need to negate the result
	bpl skipnegcol
	sec
	sta tmp
	lda #0
	sbc tmp
skipnegcol
	sta tmp
	
	iny
	lda savY+1
	sec
	sbc (tmp0),y ; row-min
	bcc outside_row

	iny
	lda savY+1
	sec
	sbc (tmp0),y ; row-max
	beq cont2
	bcs outside_row
cont2
	lda #0
outside_row
	; reg A carries the distance to the row, N=1
	; indicates if we need to negate the result
	bpl skipnegrow
	sec
	sta tmp+1
	lda #0
	sbc tmp+1
skipnegrow
savY
	ldy #0
savX
	ldx #0
	; Just add both distances
	; and return. 
	clc
	adc tmp		
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets the walkbox containing a given
; point (the first one found)
; row, col coordinates in Y, X
; Returns its pointer in tmp0 and walkbox
; number in reg A
; If C=1 no walkbox found
; and reg A and tmp0 point to the
; 'nearest' walkbox
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getWalkBoxForPoint
.(
	lda #$ff 	; invalid walkbox
	sta tmp1
	lda #$ff	; max distance
	sta tmp1+1

	lda pWalkBoxes
	sta tmp0
	lda pWalkBoxes+1
	sta tmp0+1
	
	lda nWalkBoxes
	sta tmp3
loop
	jsr isPointInWalkBox
	beq return
	; it was not, but save the box if 'nearer' than
	; the 'nearest' we have found so far.
	cmp tmp1+1
	bcs skip
	; it was, save
	sta tmp1+1
	lda tmp3
	sta tmp1
skip
	clc
	lda tmp0
	adc #5
	sta tmp0
	bcc nocarry
	inc tmp0+1
nocarry	
	dec tmp3
	bne loop
	; We did not find it! return with C=1 and return tmp0 pointing to the
	; 'nearest' walkbox
	lda tmp1
	cmp #$ff
	beq notevennear
	lda nWalkBoxes
	sec
	sbc tmp1
	pha
	jsr getWalkBoxPointer
	pla
notevennear
	sec
	rts
return	
	; we found it, return with C=0 and tmp0 pointing to the walkbox
	lda nWalkBoxes
	sec
	sbc tmp3
	
	clc
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;
; Gets pointer to
; walkbox number passed
; in reg A. Returns
; it in tmp0
;;;;;;;;;;;;;;;;;;;;;

getWalkBoxPointer
.(
#ifdef DOCHECKS_A
	; Sanity check
	cmp nWalkBoxes
	bcc doit
	lda #0
	sta tmp0
	sta tmp0+1
	rts
doit
#endif
	ldy pWalkBoxes
	sty tmp0
	ldy pWalkBoxes+1
	sty tmp0+1
	
	; Multiply by 5 (size of each walkbox)
	sta tmp1
	asl
	asl
	clc
	adc tmp1
	
	adc tmp0
	sta tmp0
	bcc nocarry
	inc tmp0+1
nocarry	
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; returns the walkbox to go
; for getting from walkbox 
; origin A to walkbox destination
; Y. Returns it in reg A
; If N=1 no path found
; and pointer to entry in (tmp),y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getNextWalkBox
.(
	; Multiply A by nWalkBoxes
	sta tmp
	clc
	ldx nWalkBoxes
	lda #0
loop	
	adc tmp	
	dex
	bne loop
	
	; Store pointer to row in walk matrix in tmp1
	; Carry must be clear here if nWalkBoxes < 51
	adc pWalkMatrix
	sta tmp
	lda #0
	adc pWalkMatrix+1
	sta tmp+1
	
	; Get entry in matrix
	lda (tmp),y
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets the walkbox a given character
; passed in regX is currently in
; Returns C=1 if he is not on a walkbox
; reg A=walkbox number (nearest if not
; on a walkbox), and tmp0 pointing to 
; walbox data. Does not modify reg X
; or Y.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getWalkBoxForCharacter
.(
	stx savx+1
	sty savy+1
	lda pos_col,x
	ldy pos_row,x
	tax
	jsr getWalkBoxForPoint
savx
	ldx #0
savy
	ldy #0	
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets the destination coordinates
; for the next step going between
; walkboxes.
; Parameters passed in orig_col/row
; and dest_col/row.
; Returns, X,Y as column/row
; Also returns with Carry Set
; if coordinates are unreachable
; and movement should stop at 
; returned coordinates.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getWalkCoordinates
.(
	; Find current walkbox
	ldx orig_col
	ldy orig_row

	jsr getWalkBoxForPoint

	;; Apparently this may actually happen, when
	;; an actor is moving from one wb to another,
	;; so I am commenting the whole block.
/*
	bcc cont1
	; We should not arrive here!!!
	; Original coords should be inside
	; a walkbox
#ifdef DOCHECKS_B
	lda #ERR_NOTWALKBOX
	jsr catchEngineException
	rts
#endif
cont1
*/
	sta owb

	; Find walkbox for destination coordinates
	ldx dest_col
	ldy dest_row
	jsr getWalkBoxForPoint
	bcc cont2
	; The point is not inside any walkbox
	; This is possible. Get valid coordinates
	; inside the nearest walkbox
notinwalkbox	
	pha
	lda dest_col
	sta tmp
	lda dest_row
	sta tmp+1
	jsr AdjustCoordinates
	pla
	stx dest_col
	sty dest_row
	;sec
	;rts
cont2
	; We found the destination walkbox, but
	; if it is the same as the origin
	; just go to the coordinates passed
	; as parameters
	cmp owb
	bne dowork
	lda dest_col
	sta tmp
	lda dest_row
	sta tmp+1
	jsr AdjustCoordinates	
	;clc ;sec?
	rts
dowork
	; We found the destination walkbox, but
	; we may have to get there through
	; intermediate walkboxes... get the 
	; next one
	
	tay
	lda owb
	jsr getNextWalkBox
	bpl pathfound  
	; Not found, stop the character there
	; META: TODO: Probably this option is to be deprecated
	ldx orig_col
	ldy orig_row
	sec
	rts
pathfound
	; Get destination wb pointer
	jsr getWalkBoxPointer

	; Check that the destination wb is 'walkable'
	ldy #4	; flags and zplane
	lda (tmp0),y
	php 	; save flags META: TODO: Should save A for testing future flags!
	
	; Now, where to go to get to dwb?
	;- if actor.row>box.row_max -> dest.row=box.row_max
	;- if actor.row<box.row_min-> dest.row=box.row_min	
	;- if actor.col<box.col_min -> dest.col=box.col_min
	;- if actor.col>box.col_max -> dest.col=box.col_max
	
	lda orig_col
	sta tmp
	lda orig_row
	sta tmp+1

	jsr AdjustCoordinates
	plp
	bmi nopathfound
	clc
	rts
nopathfound
	; Either there is no way to go through the origin
	; walkbox to the destination, or the destination
	; is unwalkable. We need to direct the actor to the
	; border of the current walkbox and stop it there
	; Calling *again* AdjustCoordinates with the *original*
	; walkbox does the trick.
	lda owb
	jsr getWalkBoxPointer
	jsr AdjustCoordinates
	sec
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; helper to adjust coordinates
; col (tmp) and row (tmp+1)
; so they fit inside the box
; pointed to by tmp0.
; returns the fixed coords in reg
; X and Y, as well as tmp, tmp+1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AdjustCoordinates	
.(
	ldy #0	; Col-min
	lda (tmp0),y
	cmp tmp
	bcc next
	sta tmp	; Save it
	bcc check_row
next
	iny  ; Col-max
	lda (tmp0),y
	cmp tmp
	bcs check_row
	sta tmp	; Save it
check_row
	ldy #2  ; row-min
	lda (tmp0),y
	cmp tmp+1
	bcc next2
	sta tmp+1
	bcc end_check
next2
	iny  ; Row-max
	lda (tmp0),y	
	cmp tmp+1
	bcs end_check
	sta tmp+1
end_check
	; This is okay for regular (squared) boxes, but
	; does not work properly for lateral corners in rooms
	; This is recorded in the flag field of the walkbox.	
	ldy #4
	lda (tmp0),y	
	and #BOX_LCORNER
	beq nolcorner
checkme	
	; The box is a lateral corner at the left of the room
	; Adjust the column depending on the row.
	sec
	ldy #3 ; row-max
	lda (tmp0),y
	sbc tmp+1
	tax
	
	ldy #0	; col-min
	lda (tmp0),y
	clc
	adc tab_adj_lcols,x
	cmp tmp
	bcc nolcorner
	sta tmp
nolcorner
	ldy #4
	lda (tmp0),y	
	and #BOX_RCORNER
	beq norcorner
	; The box is a lateral corner at the right of the room
	; Adjust the column depending on the row.
	sec
	ldy #3 ; row-max
	lda (tmp0),y
	sbc tmp+1
	tax
	
	ldy #1	; col-max
	lda (tmp0),y
	sec
	sbc tab_adj_lcols,x
	cmp tmp
	bcs norcorner
	sta tmp
norcorner
	ldx tmp
	ldy tmp+1
	rts
.)


	
	
	
