
;;;;;;;;;;;; Functions to be called from C ;;;;;;;;;;;;;;;;
; void move_sprite(char who, char dir)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void move_sprite(char who, char dir_mov)
; 0: north, 1: south, 2: west, 3: east, 4: up, 5: down
; Moves sprite in the appropriate direction and updates 
; internal arrays
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

charindex .byte $00
buffindex .byte $00
+_move_sprite
	ldy #0
	lda (sp),y  ; grab id of character moving
	sta tmp0
	asl     ; Multiply by 4 (sizeof(moving_object_t))
    asl
    tax
	stx tmp2
	stx charindex	; For using later...

	; Search for the character in the array
	ldy _num_chars
	dey   ;; _num_chars is 1 based BEWARE!
ms_loopsearch
	lda _chars_in_room,y
	cmp tmp0
	beq ms_found
	dey
	bpl ms_loopsearch
	rts	; No char with that index
ms_found

	sty buffindex

	lda aux_buff_i,y	
	asl			; i*2
	sta tmp
	asl
	asl			; i*8
	clc
	adc tmp
	sta tmp		; i*10

    lda aux_buff_j,y  
	clc
	adc tmp		; i*10+j
	
	tay
	lda sprite_loc,y
	and #%10000000
	;lda #0
	sta sprite_loc,y

	;; We have cleared the byte in sprite_pos, now calculate the new postion
	;; and fix everything

ms_domovement
	
	ldy #2
	lda (sp),y ;grab direction
	sta tmp3

	;; NOTE: the parameter for _recalc_clip is ok, as it is
 	;; the same as _move_sprite

	cmp #NORTH
	bne ms_nonorth
	; Moved north
	; recalc_clip(who);
  	; characters[who].fine_coord_j--; 
	jsr _recalc_clip

    ldx #2  ;width_clip
    inc _clip_rgn,x
    inx     ;heigth_clip
    inc _clip_rgn,x

	
	ldx charindex
	inx	;; Point to fine_coord_j
	ldy _characters,x
	dey
	tya
	sta _characters,x
	

	jmp ms_move_done
ms_nonorth
	cmp #SOUTH
	bne ms_nosouth	
	; Moved south
	; characters[who].fine_coord_j++;
  	; recalc_clip(who);
	
	ldx charindex
	inx	;; Point to fine_coord_j
	ldy _characters,x
	iny
	tya
	sta _characters,x
	
	jsr _recalc_clip

    ldx #2  ;width_clip
    inc _clip_rgn,x
    inx     ;heigth_clip
    inc _clip_rgn,x


	jmp ms_move_done
ms_nosouth
	cmp #EAST
	bne ms_noeast
	; Moved east
	; recalc_clip(who);
	; characters[who].fine_coord_i++;
	
	jsr _recalc_clip

   
    ldx #1  ; y_clip
    inc _clip_rgn,x 
    inx  ;width_clip
    inc _clip_rgn,x
    inx     ;heigth_clip
    inc _clip_rgn,x


	ldx charindex
	ldy _characters,x
	iny
	tya
	sta _characters,x

	jmp ms_move_done
ms_noeast
	cmp #WEST
	bne ms_nowest
	; Moved west
	; characters[who].fine_coord_i--;   
  	; recalc_clip(who); 
	
	ldx charindex
	ldy _characters,x
	dey
	tya
	sta _characters,x
	
	jsr _recalc_clip

    ldx #1  ; y_clip
    inc _clip_rgn,x 
    inx  ;width_clip
    inc _clip_rgn,x
    inx     ;heigth_clip
    inc _clip_rgn,x


	jmp ms_move_done
ms_nowest
	cmp #UP
	bne ms_noup
	; Moved up
	; characters[who].fine_coord_k++;
	; recalc_clip(who);
	ldx charindex
	inx
	inx	; Point to fine_coord_k
	ldy _characters,x
	iny
	tya
	sta _characters,x
	
	jsr _recalc_clip

    ldx #1  ; y_clip
    inc _clip_rgn,x 
    inx  ;width_clip
    inx     ;heigth_clip
    inc _clip_rgn,x

	
	jmp ms_move_done
ms_noup
	cmp #DOWN
	bne ms_nodown
	; Moved down
	; characters[who].fine_coord_k--;
	; recalc_clip(who);
	ldx charindex
	inx
	inx	; Point to fine_coord_k
	ldy _characters,x
	dey
	tya
	sta _characters,x
	
	jsr _recalc_clip

    ldx #3     ;heigth_clip
    inc _clip_rgn,x

	jmp ms_move_done

ms_nodown
	
	jmp ms_move_unknown

ms_move_done
	; Update tiles where sprite is in
	ldx charindex
	lda _characters,x ; .fine_coord_i
	jsr do_div6
	ldy buffindex
	sta	aux_buff_i,y

	ldx charindex
	inx
	lda _characters,x ; .fine_coord_j
	jsr do_div6
	ldy buffindex
	sta	aux_buff_j,y

	ldx charindex
	inx
	inx
	lda _characters,x ; .fine_coord_k
	;jsr do_div6
	ldy buffindex
	sta	aux_buff_k,y


	jsr calc_sprite_locs
		
ms_move_unknown
	rts




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; calc_sprite_locs
; Helper that calculates all the tile location for sprites
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calc_sprite_locs

	; Update the array with sprite locs...

    ldy _num_chars
	beq csl_nochars 
    dey   ;; _num_chars is 1 based BEWARE!
csl_looplocs
	;sty tmp0
    lda aux_buff_i,y
	asl			; i*2
	sta tmp
	asl
	asl			; i*8
	clc
	adc tmp		; i*10
	sta tmp	
    lda aux_buff_j,y
	clc
	adc tmp		; i*10+j
	sta tmp

	lda aux_buff_k,y

#if LAYER_HEIGHT<>8
#echo WARNING: LAYER HEIGHT IS NOT 8. CHANGE SPRITEMOV.S
#endif

	; Divide it by 8
	lsr
	lsr
	lsr
	
	tax
	lda #0
	sec
csl_looplayers
	rol
	dex
	bpl csl_looplayers

    ldx tmp ; get index
	ora sprite_loc,x
	sta sprite_loc,x	

	dey
    bpl csl_looplocs	
csl_nochars	
	rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; init_sprites
; initialize tiles for sprites in room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_sprites
    ldy _num_chars 
	beq is_nochars
    dey   ;; _num_chars is 1 based BEWARE!
is_copychars
	sty tmp1
    lda _chars_in_room,y
	
	asl     ; Multiply by 4 (sizeof(moving_object_t))
    asl
    tax
	stx tmp0

    lda _characters,x ; .fine_coord_i
	jsr do_div6
	ldy tmp1
    sta aux_buff_i,y
	
	inc tmp0
    ldx tmp0     
    lda _characters,x ; .fine_coord_j
	jsr do_div6
	ldy tmp1
    sta aux_buff_j,y
	
	ldx tmp0     
	inx
    lda _characters,x ; .fine_coord_k
    sta aux_buff_k,y

	dey
    bpl is_copychars

;	ldy #0
;	lda _chars_in_room,y
;	sta (sp),y  ; id of character moving
;	jsr _recalc_clip

is_nochars
	rts

