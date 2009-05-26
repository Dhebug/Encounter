


;;;;;;;;;;;; Functions to be called from C ;;;;;;;;;;;;;;;;
; int collision_test(char who, char dir_mov)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int collision_test(char who, char dir_mov)
; 0: north, 1: south, 2: west, 3: east, 4: up, 5: down
; checks for collisions.
; Returns: 1 if collision exists
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.zero
corner1i .db $00
corner1j .db $00
corner2i .db $00
corner2j .db $00
checktwo .db $00

.text
+_collision_test
	; Initialise arrays
	lda #0
	sta _num_bkg_collisions
	sta _num_obj_collisions
	
	ldy #2
	lda (sp),y ;grab direction
	sta tmp0
	
	ldy #0
	lda (sp),y  ; grab id of character moving
	sta curr_obj	; Save for use in checking object collisions
    asl     ; Multiply by 4 (sizeof(moving_object_t))
    asl
    tay

; Get coordinates
    lda _characters,y ; .fine_coord_i
	sta who_i
	iny     
    lda _characters,y ; .fine_coord_j
    sta who_j
	iny     
    lda _characters,y ; .fine_coord_k
    sta who_k

	; Get size of object
    iny
    lda _characters,y ; .type
    and #%00111111  ; get size 
	sta tmp4

	jsr check_bkg_collisions
	jsr check_obj_collisions

	ldx _num_bkg_collisions
	lda _num_obj_collisions

	rts ; We're done!

; End of collision_test



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int detect_pressence(char i,char j, char k, char sizecode)
; Detects pressence of other objects and
; returns them in obj_collision_list and num_obj_collisions
; also returns  num_obj_collisions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_detect_pressence
	lda #0
	sta _num_obj_collisions
    ldy #0
    lda (sp),y ; Get i
    sta who_i
    ldy #2
    lda (sp),y ; Get j
    sta who_j
    ldy #4
    lda (sp),y ; Get k
    sta who_k
    ldy #6
    lda (sp),y ; Get sizecode
    sta tmp4

    lda #$ff
    sta curr_obj
    sta tmp0    ; Should be direction of movement... this value should equal no movement.

    jsr check_obj_collisions

    lda #0
    ldx _num_obj_collisions
    rts ; We're done!


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check_bkg_collisions
; Checks for collisions with background
; objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_bkg_collisions
	; If it is vertical, check is different
	lda tmp0
	cmp #4
	bne ct_not_vert1
	jsr cv_up
	jmp ct_end

ct_not_vert1
	cmp #5
	bne ct_not_vert
	jsr cv_down  ; Same as check_vertical, but directly on option 5
	jmp ct_end
	
ct_not_vert
	; Prepare corners
	
	; Start with corner 1i
	; if movement is 0 or 1, just divide by 6
	ldy tmp0	
	beq ct_1iis01
	dey
	beq ct_1iis01
	jmp ct_1inot01
ct_1iis01
	lda who_i
	jmp ct_done1i
ct_1inot01
	; if movement is 2 then substract 1 and (size _i-1), so size_i
	ldy tmp0
	cpy #2
	bne ct_1iwas3
	ldx tmp4
	ldy _sizes_i,x
	;dey
	sty tmp
	lda who_i
	sec
	sbc tmp
	jmp ct_done1i
ct_1iwas3
	; if it is 3 add 1 
	ldy who_i
	iny
	tya
ct_done1i
	jsr do_div6
	sta corner1i
	
		
	; Now corner 1j
	; if movement is 2 or 3, just divide by 6
	ldy tmp0
	cpy #2	
	beq ct_1jis23
	cpy #3
	beq ct_1jis23
	jmp ct_1jnot23
ct_1jis23
	lda who_j
	jmp ct_done1j
ct_1jnot23
	; if movement is 0 then substract 1 and (size _j-1), so size_j
	ldy tmp0
	bne ct_1jwas1
	ldx tmp4
	ldy _sizes_j,x
	;dey
	sty tmp
	lda who_j
	sec
	sbc tmp
	jmp ct_done1j
ct_1jwas1
	; if it is 1 add 1 
	ldy who_j
	iny
	tya
ct_done1j
	jsr do_div6
	sta corner1j

	; Now corner2i
	; if movement is 0 or 1 substract (size_i-1)
	ldy tmp0
	beq ct_2iis01
	dey
	beq ct_2iis01
	jmp ct_2inot01
ct_2iis01
	ldx tmp4
	ldy _sizes_i,x
	dey
	sty tmp
	lda who_i
	sec
	sbc tmp
	jsr do_div6
	sta corner2i
	jmp ct_done2i
ct_2inot01
	; if movement is 2 or 3 it equals corner1i
	lda corner1i
	sta corner2i
ct_done2i

	; Now corner2j
	; if movement is 0 or 1 it equals corner 1j
	ldy tmp0
	beq ct_2jis01
	dey
	beq ct_2jis01
	jmp ct_2jnot01
ct_2jis01
	lda corner1j
	sta corner2j
	jmp ct_done2j
ct_2jnot01
	; if movement is 2 or 3 substract substract (size_j-1)
	ldx tmp4
	ldy _sizes_j,x
	dey
	sty tmp
	lda who_j
	sec
	sbc tmp
	jsr do_div6
	sta corner2j
ct_done2j	

	; See if both corners are equal
	lda corner1i
	cmp corner2i
	bne ct_cornotequal	
	lda corner1j
	cmp corner2j
	bne ct_cornotequal
	; Corners are equal... just check one
	lda #0
	jmp ct_checkcorners 
ct_cornotequal
	lda #1	
ct_checkcorners 
	sta checktwo
	
	
	; Now check if there is something there...

#if LAYER_HEIGHT<>8
#echo WARNING: LAYER HEIGHT IS NOT 8. CHANGE COLLISION.S
#endif

	; Initialize top point
	ldx tmp4
	lda _sizes_k,x
	asl
	sec
	sbc #1
	clc
	adc who_k
	lsr
	lsr
	lsr
	sta tmp3

	; Initialize bottom point
	lda who_k
	lsr
	lsr
	lsr
	sta tmp2
	
ct_checkheight
	; If  point is outside map possible heights, then do not check.
	lda tmp2
	cmp #NUM_LAYERS
	bcs ct_next		; if (tmp2 >=NUMLAYERS) then do not check
	
	; Check corner1
	lda corner1i
	sta tmp1
	lda corner1j
	sta tmp1+1
	jsr check_corner	
	
	lda checktwo
	beq ct_next
	
	; Check corner2
	lda corner2i
	sta tmp1
	lda corner2j
	sta tmp1+1
	jsr check_corner	

ct_next
	inc tmp2	
	lda tmp3	
	cmp tmp2
	bcs ct_checkheight ; loop back if (tmp3(A)>=tmp2)

ct_end
	
	rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check_vertical
; Checks collisions in the vertical directions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_vertical

cv_up
; New height is...
	;cmp #4 ; If it is up
	;bne cv_down
	lda who_k
	sta tmp2
	; Add object's heigth
	ldx tmp4
	lda _sizes_k,x
	asl ; double it
	clc
	adc tmp2
	jmp cv_cont1
cv_down ; If it is down
	ldy who_k
	;; What if we can't go further down?
	bne cv_cango
	; Add an special situation to array
	lda _num_bkg_collisions
	asl
	asl
	tax
	lda #$ff
	sta _bkg_collision_list,x
	inx
	sta _bkg_collision_list,x
	inx
	sta _bkg_collision_list,x
	inx
	sta _bkg_collision_list,x
	inc _num_bkg_collisions
	rts

cv_cango
	dey
	tya
	
cv_cont1	
	lsr
	lsr
	lsr
	cmp #NUM_LAYERS ; If it is >= NUM_LAYERS, no need to check
	bcs cv_end

	sta tmp2

; Initialize a flag
	lda #0
	sta tmp3+1

; Now get the four corners, if necessary. Let's start
; with the control corner
	lda who_i
	jsr do_div6
	sta tmp1	
	lda who_j
	jsr do_div6
	sta tmp1+1
	
	jsr check_corner

; Now the next corner... the new tile_i is (i-(size_i-1))div6
	lda tmp1
	sta tmp5 ;save it...

	ldx tmp4
	lda _sizes_i,x
	sec
	sbc #1
	sta tmp
	lda who_i
	sec
	sbc tmp
	jsr do_div6
	cmp tmp1	; Has it changed?
	beq cv_equali	
	
	; No, so check it
	sta tmp1
	jsr check_corner

	jmp cv_cont2
cv_equali
	lda #1
	sta tmp3+1
cv_cont2
	; Restore old i, save new
	ldx tmp1
	;sta tmp
	lda tmp5
	sta tmp1
	;lda tmp
	stx tmp5

; Now the next corner... the new tile_j is (j-(size_j-1))div6
	ldx tmp4
	lda _sizes_j,x
	sec
	sbc #1
	sta tmp
	lda who_j
	sec
	sbc tmp
	jsr do_div6
	cmp tmp1+1	; Has it changed?
	beq cv_equalj	
	
	; No, so check it
	sta tmp1+1
	jsr check_corner

	jmp cv_cont3
cv_equalj
	lda #1
	sta tmp3+1
cv_cont3

; Okay, now just check, if needed, the last corner...
	lda tmp3+1 ; Do we need to check this?
	bne cv_end
	lda tmp5	;saved (i-(sizei-1))div6
	sta tmp1
	jsr check_corner

cv_end
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check_corner
; Helper to check for collisions
; for a given corner. Adds objects to the collision list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_corner
	; Get index
	lda tmp1
	asl            ; i*2
	sta tmp
	asl
	asl            ; i*8
	clc
	adc tmp        ; i*10
	sta tmp
	lda tmp1+1
	clc
	adc tmp      ; i*10+j 
	pha
	;sta tmp
  
	; Get pointer to map of current layer
	lda tmp2 ; get heigth
	asl ; double index for 16-bit entries
	tax
	lda _layers,x ; get MSB
	sta tmp
	lda _layers+1,x ; get LSB
	sta tmp+1
	pla
	tay
  	;ldy tmp
	lda (tmp),y    ; get tile
	beq cc_end
	; Add object to array
	tay
	lda _num_bkg_collisions
	asl
	asl
	tax
	tya
	sta _bkg_collision_list,x
	inx
	lda tmp1
	sta _bkg_collision_list,x
	inx
	lda tmp1+1
	sta _bkg_collision_list,x
	inx
	lda tmp2
	sta _bkg_collision_list,x
	inc _num_bkg_collisions
cc_end
	rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check_obj_collisions
; Checks for collisions with other sprites
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.zero
obj_k .byte $00
curr_obj .byte $00
sprite_rect .dsb 4,$00

.text

check_obj_collisions
	; The idea is looping through the sprite array
	; checking if "shadows" intersect, that is the
	; rectangle at height 0.
	; If that happens, then we should also check
	; if heigths intersect.
	
	; We will use intersect_rect, so we will also use
	; clip_rgn, but all checks are done in isometric
	; world coordinates.
	
	; Depending on direction (tmp0) we should also
	; increase either one of the corner's coordinate
	; or the width or height of rectangle.


	; Prepare the rectangle of current object
	; i Coordinate
	
	lda who_i
	;sta _clip_rgn ; Set x_clip
	sta sprite_rect
	
	; j Coordinate
	lda who_j
	sta sprite_rect+1
	;sta _clip_rgn+1 ; Set y_clip

	; Sprite width_i
	ldy tmp4
	lda _sizes_i,y
	sta sprite_rect+2
	;sta _clip_rgn+2 ; Set width_clip

	
	; Sprite width_j
	lda _sizes_j,y
	;sta _clip_rgn+3 ; Set height_clip
	sta sprite_rect+3
	
	; Loop through _chars_in_room
	lda _num_chars
	sta num_sp

	; Adjust... if necessary
	lda tmp0
	cmp #0
	bne ct_cont1
	dec sprite_rect+1
	jmp ct_loopchars
ct_cont1
	cmp #1
	bne ct_cont2
	inc sprite_rect+1
	jmp ct_loopchars
ct_cont2
	cmp #2
	bne ct_cont3
	dec sprite_rect
	jmp ct_loopchars
ct_cont3
	cmp #3
	bne ct_cont4
	inc sprite_rect
	jmp ct_loopchars
ct_cont4

ct_loopchars
	ldx num_sp
	dex
	lda _chars_in_room,x ; Get new object
	cmp curr_obj	; Is it the current one?
	beq ct_nextchar ; It is... so ignore

	; Get all the coordinates and store in the params for 
	; calling intersect_rect
	
	asl     ; Multiply by 4 (sizeof(moving_object_t))
    asl
    tax
	
    lda _characters,x ; .fine_coord_i
	sta op1
	inx     
    lda _characters,x ; .fine_coord_j
    sta op2
	inx     
    lda _characters,x ; .fine_coord_k
    sta obj_k		  ; We save this in case it is needed...	


	; Get size of object
    inx
    lda _characters,x ; .type
    and #%00111111  ; get size 
	tax	

	lda _sizes_i,x
	sta tmp3+1

	lda _sizes_j,x
	sta tmp3	
	
	
	jsr intersect_rect2
	bne ct_nextchar		; No intersection

	; Check heigth intersection	
	; intersect_rect2 does not modify index registers x or y

	lda who_k
	sta tmp
	lda tmp0
	cmp #4
	bne ct_noup
	inc tmp
	;jmp ct_doneupdown
ct_noup
	cmp #5
	bne ct_doneupdown
	dec tmp
ct_doneupdown	
		
	lda _sizes_k,x
	asl
	clc
	adc obj_k
	sec
	sbc #1
	cmp tmp	;Is object_k+object_heigth < sprite_k?
	bcc	ct_nextchar ; It is, so no intersection
	
	lda _sizes_k,y
	asl
	clc
	adc tmp
	sec
	sbc #1

	cmp obj_k		; Is sprite_k+sprite_heitgh < object_k?
	bcc ct_nextchar ; It is, so no intersection

	; Add object to array
	lda _num_obj_collisions
	asl
	asl
	tax
	
	ldy num_sp		; Get object code again
	dey
	lda _chars_in_room,y

	sta _obj_collision_list,x
	; Rest of fields are blank for now...
	inc _num_obj_collisions


	
ct_nextchar
	dec num_sp
	beq ct_nomore
	jmp ct_loopchars	
ct_nomore
	rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
intersect_rect2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper function. Calculates if a rectangle intersects 
;; with sprite_rect
;; Needs: 
;;      op1     X coord of R1
;;      op2     Y coord of R1
;;      tmp3+1  Width of R1 (in scans)
;;      tmp3    Height of R1
;; Returns Z=0 if overlap occurs, else Z=1

;; The formula is !((X1>X2+W2)||(X2>X1+W1)||(Y1>Y2+H2)||(Y2>Y1+H1))
;; or else (X2+W2>=X1)&&(X1+W1>=X2)&&(Y2+H2>=Y1)&&(Y1+H1>=Y2)

    lda op2           ;; Y1+H1
    clc
	adc #1
    sec               
    sbc tmp3          ;; Y1
    bcs cont
    lda #0
cont
    sta tmp
    lda sprite_rect+1   ;; Y2+H2
    cmp tmp           ;; >=Y1  
    bcc ir2false      ;; FALSE

    
    ;lda _clip_rgn+1   ;; Y2+H2
    clc
	adc #1
    sec
    sbc sprite_rect+3   ;; Y2
    bcs cont2
    lda #0
cont2
    sta tmp
    lda op2           ;; Y1+H1  
    cmp tmp           ;; >= Y2  
    bcc ir2false      ;; FALSE  
    

	lda op1			  ;; X1+W1
	clc
	adc #1
	sec
	sbc tmp3+1		  ;; X1
    bcs cont3
    lda #0
cont3
	sta tmp
	lda sprite_rect	  ;; X2+W2
	cmp tmp			  ;; >=X1 
	bcc ir2false


	; lda _clip_rgn   ;; X2+W2
	clc
	adc #1
	sec
	sbc sprite_rect+2	  ;; X2
    bcs cont4
    lda #0
cont4
    sta tmp
	lda op1			  ;; X1+W1
    cmp tmp		      ;; >=X2
    bcc ir2false      ;; FALSE

    lda #0
    rts
ir2false
    lda #1
    rts  ; We're done!
    
;; End of intersect_rect

