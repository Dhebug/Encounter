
;#define DUMPMASK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Clears the buffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clear_occ
	
    lda #HI(buffer_occ)
    sta tmp0+1
    lda #LO(buffer_occ)
    sta tmp0

    lda #0
    sta tmp
    clc 
    ldx _clip_rgn+3
    dex
    txa
#ifdef EIGTHSCANS
    asl
    rol tmp
    asl
    rol tmp
    asl
    rol tmp

    adc tmp0
    sta tmp0
    lda tmp
    adc tmp0+1
    sta tmp0+1

#else
    asl
    sta tmp
    asl
    clc
    adc tmp
    adc tmp0
    sta tmp0
    bcc nocarryt4
    inc tmp0+1
nocarryt4
#endif        
 

    ;; Pointer in tmp0
    ldx _clip_rgn+3 ; get lines

co_looplines
    lda #$40;7f
    ldy _clip_rgn+2 ; get scans
    dey
co_loopscans
    sta (tmp0),y
    dey
    bpl co_loopscans

    lda tmp0
    sec
    ;sbc #8         ; Point to previous line
    sbc #SCANSINBUFF         ; Point to previous line
    bcs co_no_carry
    dec tmp0+1
co_no_carry
    sta tmp0
    dex
    bne co_looplines
    
    rts ; We're done


;; End of clear_buff


calc_occlusion_mask
	;; KLUDGE: Repaint what has been corrupted...

	lda double_buff
	bne k_cont
	jmp endkludge

k_cont
 
	lda #1
	sta in_kludge_height+1

	;Save params
	inc sp
	bne k_done
	inc sp+1
k_done

	jsr clear_occ 

	ldy iloop2
	iny
	sty block_i
	ldy tiley
	dey
	sty block_j

    
    lda #0
	sta block_k ; Initial heigth to start looking for objects in front

	
#if LAYER_HEIGHT<>8
#echo WARNING: LAYER HEIGHT IS NOT 8. CHANGE KLUDGE @ OCCLUSIONS.S
#endif

	; We have in block_i: i+1 and in block_j: j-1

k_loop1
	jsr add_block_mask
	inc block_k
	lda block_k
	cmp #NUM_LAYERS
	bcc k_loop1

	;; Now objects that might be on top
	
	lda sizecode ; Initialised at paint_sprites before calling here
	and #%00111111
	tax
	lda	_sizes_k,x
	asl		; Double the size...
	sec
	sbc #1
	clc
	adc who_k
	lsr
	lsr
	lsr
	sta block_k
	cmp #(NUM_LAYERS-1)
	bcs k_noup
	
	inc block_k
	;inc block_j
	dec block_i ; We are now at (i,j-1)
k_loop2
	; Start at (i,j-1)
	jsr add_block_mask
	dec block_i
	jsr add_block_mask ; Now at (i-1,j-1)

	inc block_j
	jsr add_block_mask ; Now at (i-1, j)
	
    dec block_j
	inc block_i		   ; Back at (i,j-i) for next loop
			
	inc block_k
	lda block_k
	cmp #NUM_LAYERS
	bcc k_loop2

k_noup

	jsr add_sprites_mask

	lda #0
	sta in_kludge_height+1

#ifdef DUMPMASK
	jsr dump_mask
#endif

nokludge
	;Restore sp
	lda sp
	bne k_declsp
	dec sp+1
k_declsp
	dec sp

endkludge
	rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; add_block_mask
; Add a mask of a given block to the sprite mask
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

block_i .byte $00
block_j	.byte $00
block_k .byte $00
block_index .byte $00

add_block_mask

#if LAYER_HEIGHT<>8
#echo WARNING: LAYER HEIGHT IS NOT 8. CHANGE ADD_BLOCK_MASK @ OCCLUSIONS.S
#endif
	; X and Y parameters for put_sprite
	lda block_i
	cmp #10
	bcs abm_nothing2do
	sta op1
	lda block_j
	cmp #10
	bcs abm_nothing2do

	sta op2
	jsr ij2xy
	tya
	clc
	adc #12
	ldy #2
    sta (sp),y     ; store
	txa
    ldy #0
    sta (sp),y     ; store


	; Initialize heigth
    lda block_k
    asl
	asl
	asl	; Multiply by 8
	sta tmp

	; New heigth means changing y
    ldy #2
    lda (sp),y        ; get y
    sec
    sbc tmp
    sta (sp),y     ; store

		
    ;  fetch block to draw
    
    ; Get the block to draw... that is i*10+j (NOT i+j*10 as it would seem BEWARE!)
    lda block_i
    asl            ; i*2
    sta tmp
    asl
    asl            ; i*8
    clc
    adc tmp        ; i*10
    clc
    adc block_j     ; i*10+j 
	sta block_index

	; Get pointer to map of current layer
	lda block_k  
    asl ; double index for 16-bit entries
    tax
    lda _layers,x ; get MSB
    sta tmp
    lda _layers+1,x ; get LSB
    sta tmp+1
   	ldy block_index
    lda (tmp),y    ; get tile
	and #%01111111 ; Remove SPECIAL bit
    beq abm_nothing2do

    jsr draw_block

abm_nothing2do

	rts ; We're done


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; add_sprites_mask
; Helper funcion that searches for sprites that should
; add their masks to the occlusion mask
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

as_num_sp .byte $00

add_sprites_mask
	lda _num_chars
	sta as_num_sp

as_loopchars
	ldx as_num_sp
	dex
	lda _chars_in_room,x ; Get new object
	cmp cur_char	; Is it the current one?
	beq as_nextchar ; It is... so ignore
	
	;jmp as_nextchar

	asl     ; Multiply by 4 (sizeof(moving_object_t))
    asl
    tax
	
	; Should this sprite be treated for occlusions?

	ldy sizecode
	lda _sizes_i,y
	sta tmp
	lda _characters,x		; cur_sp_i+sp_width_i-sp_i-1 < 18?		
	clc
	adc tmp
	clc		; DONE ON PURPOSE
	sbc who_i
	bmi as_nextchar
	cmp #18
	bcs as_nextchar
	
	inx
	lda _sizes_j,y
	sta tmp
	lda _characters,x		; cur_sp_j+sp_width_j-sp_j-1 < 18
	clc
	adc tmp
	clc		; DONE ON PURPOSE
	sbc who_j
	bmi as_nextchar
	cmp #18
	bcs as_nextchar

	inx
	inx
	lda _characters,x
	and #%0011111 ; Get size code
	tay
	lda _sizes_k,y
	asl
	dex

;	inx
;	lda _sizes_k,y
;	asl
	adc _characters,x
	sec
	sbc #1
	cmp who_k
	bcc as_nextchar			; The sprite is below...

	jsr add_this_sprite
	
as_nextchar
	dec as_num_sp
	beq as_end
	jmp as_loopchars	
as_end
	rts	




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; put_mask2(char x_pos, y_pos, sprite_t * sprite, char invert)
;; Saving the mask for occlusions. No rotations.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
put_mask2

    ;; Do the minimum necessary to call intersect_rect, 
    ;; so if painting is not needed we return as fast as possible

#ifdef TINYNOISE
	jsr fetch_coords
#else	
    ;; Fetch x and y coordinates
    ldy #0
    lda(sp),y
	sta op1
    ldy #2
    lda(sp),y
	sta op2
            
    ldy #4         ; Get sprite pointer
    lda (sp),y
    sta tmp2
    iny
    lda (sp),y
    sta tmp2+1
    
    ldy #0
    lda (tmp2),y       ; # of lines
    sta tmp3
    iny
    lda (tmp2),y
    sta tmp3+1         ; # of scans
#endif
    
    jsr intersect_rect
    beq pm2_cont1
    rts
pm2_cont1 
    ldy #6      ; Paint inverted
    lda(sp),y
    sta invert3+1

    lda tmp3+1
    sta scans_to_draw

    lda #0
    sta scan_to_start
    
    ldy tmp3+1 ;scans
	dey
    sty tmp
   
    
    ldy #4
    lda (tmp2),y
    sta tmp5
    iny
    lda (tmp2),y
    sta tmp5+1       ; Pointer to sprite mask

    lda tmp5
    sec
    sbc tmp
    bcs pm2_nocarry3
    dec tmp5+1
pm2_nocarry3
    sta tmp5
	
    ; Test parameter to see if we use double buffer or not...
	
    jsr adjust_clip
	jsr pixel_address

	; Adjust to buffer_occ
	lda tmp0
	clc
	adc #LO(buffer_occ-scr_buffer)
	sta tmp0
	lda tmp0+1
	adc #HI(buffer_occ-scr_buffer)
	sta tmp0+1
	
    ;; We have in tmp1 the code of the pixel in scan
    ;; and in tmp0 the destination address

    lda scan_to_start
    sta scan2start3+1
   
pm2_loop1
    ;;  Some initializations...
    ldy scans_to_draw
	dey
					
pm2_loop2
scan2start3
    cpy #0
    bmi pm2_nopaint


    lda (tmp0),y       ; Take screen contents 
    sta tmp

invert3
	lda #0
    beq pm2_noinvert

    sty aux
    lda tmp3+1
	clc			; DONE ON PURPOSE, BEWARE!
    sbc aux     ; (scans-current_scan)
    tay

	lda (tmp5),y	; Get mask
	tax
	lda tab_inverted_bytes,x
    ora #%010000000  ;  :: HAS TO BE DONE?
	ora tmp			; AND screen
		
    ldy aux

    bvc pm2_paint ; Branches allways

pm2_noinvert
	lda (tmp5),y	; Get mask
	ora tmp			; AND screen
	
pm2_paint

    sta (tmp0),y    ; Put everything in screen

pm2_nopaint
    dey
	bpl pm2_loop2      ; End of scans loop
pm2_noloop2

    lda tmp0
    sec
    ;sbc #8         ; Point to previous line
    sbc #SCANSINBUFF         ; Point to previous line
    bcs pm2_no_carry1
    dec tmp0+1
pm2_no_carry1
    sta tmp0

    ;; Decrement pointers
    lda tmp5   
    sec
    sbc tmp3+1
    bcs pm2_dec5
    dec tmp5+1
pm2_dec5
    sta tmp5
    
    ;; Next line
    dec tmp3       
    beq pm2_end
    jmp pm2_loop1      ; End of lines loop

pm2_end
    rts         ; We're done!




ats_cur_char .byte $00
ats_who_i .byte $00
ats_who_j .byte $00
ats_who_k .byte $00
ats_sizecode .byte $00

add_this_sprite
	ldx as_num_sp
	dex
	;txa
	lda _chars_in_room,x
	sta ats_cur_char
        
    asl     ; Multiply by 4 (sizeof(moving_object_t))
    asl
    tay

    lda _characters,y ; .fine_coord_i
    sta ats_who_i
    iny     
    lda _characters,y ; .fine_coord_j
    sta ats_who_j
    iny     
    lda _characters,y ; .fine_coord_k
    sta ats_who_k
    iny
    lda _characters,y ; .type
	and #%00111111
	sta ats_sizecode

	; Get inverted flag
	lda _characters,y ; .type
    and #%01000000
    beq ats_noinvert
    lda #1
ats_noinvert
	ldy #6
    sta (sp),y

	lda xo
	pha
	lda yo
	pha
	lda xx
	pha
	lda scry
	pha


	;; Calculate x,y screen position from fine coordinates i,j,k
	;; Cannot use ij2xy as it is for tile coordinates

	lda ats_who_i
	jsr do_div6
	sta xo
	sta op1

	lda ats_who_j
	jsr do_div6
	sta yo
	sta op2

	jsr ij2xy

	tya
	clc
	adc #12
	ldy #2
    sta scry

	txa
	ldy #0
    sta xx

    lda xo
    asl
    sta xo
    asl
    clc
    adc xo
    sta xo  ; xo=xo*6
    lda ats_who_i
    clc
    adc #1
    sec
    sbc xo
    sta tmp  ; tmp=who_i-xo*6

    lda yo
    asl
    sta yo
    asl
    clc
    adc yo
    sta yo  ; yo=yo*6
    lda ats_who_j
    clc
    adc #1
    sec
    sbc yo
    sta yo  ; yo=who_j-yo*6

    lda tmp
    sec
    sbc yo
    asl
    sta xo  ; xo=(yo-tmp)*2

    lda yo
    clc 
    adc tmp
    ; Z-pos of sprite       
    sec
    sbc ats_who_k
    sta yo  ; yo=tmp+yo-zpos
    

	;; Now the pointer to graphics...
  	lda ats_cur_char
    ;; Multiply by 6 (size_of(sprite_t))
    asl
    asl
    sta tmp
    lda ats_cur_char
    asl
    clc
    adc tmp         
    sta tmp
                    
    ;; Pointer in tmp1
    lda #LO(_char_pics)
    sta tmp1
    lda #HI(_char_pics)
    sta tmp1+1
    
    clc
    lda tmp
    adc tmp1
    sta tmp1
    bcc ats_nocarry
    inc tmp1+1
ats_nocarry

    ldy #4
    lda tmp1    
    sta (sp),y
    lda tmp1+1
    iny
    sta (sp),y


  
    ; And the coordinates ....
    lda xx
    clc
    adc xo
	
	; Adjust with the sprite size also...
	clc
	adc #ancho_tile/2
	;tay
	;ldx ats_sizecode
	;lda _sizes_i,x  
	;asl
	;sta tmp
	;tya     
	
	tax
	ldy #1
	lda (tmp1),y	; Get number of scans
	sta tmp
	asl	
	clc
	adc tmp			; Multiply by 3 (6 pix per scan /2)
	sta tmp
	txa
	
	sec
	sbc tmp
	
	ldy #0
    sta (sp),y

    ldy #2
    lda scry
    sec        
    sbc #alto_tile
    clc
    adc yo

    sta (sp),y

	
    jsr put_mask
	
	
    ;; Done. Let's restore contents of sp
    pla
	sta scry
	pla
	sta xx
	pla
	sta yo
	pla
	sta xo
	

	rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; put_mask(char x_pos, y_pos, sprite_t * sprite, char invert)
;; Saves mask of a sprite. Rotates if necessary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
put_mask

    ;; Do the minimum necessary to call intersect_rect, 
    ;; so if painting is not needed we return as fast as possible
#ifdef TINYNOISE
	jsr fetch_coords
#else	
    ;; Fetch x and y coordinates
    ldy #0
    lda (sp),y
    sta op1
    ldy #2
    lda (sp),y
    sta op2
            
    ldy #4         ; Get sprite pointer
    lda (sp),y
    sta tmp2
    iny
    lda (sp),y
    sta tmp2+1
    
    ldy #0
    lda (tmp2),y       ; # of lines
    sta tmp3
    iny
    lda (tmp2),y
    sta tmp3+1         ; # of scans
#endif
    clc
    adc #1
	sta scans_to_draw
    
    jsr intersect_rect
    beq pm_cont1
    rts
pm_cont1 

	ldy #6      ; Paint inverted
    lda(sp),y
    sta invert4+1

	
    lda #0
    sta scan_to_start
   
    ldy #4
    lda (tmp2),y
    sta tmp5
    iny
    lda (tmp2),y
    sta tmp5+1       ; Pointer to sprite mask

  
    lda tmp5
    sec
    sbc tmp3+1 ; Was tmp... a copy of tmp3+1 (?)
    bcs pm_nocarry3
    dec tmp5+1
pm_nocarry3
    sta tmp5

    jsr adjust_clip
	jsr pixel_address

	; Adjust to buffer_occ
	lda tmp0
	clc
	adc #LO(buffer_occ-scr_buffer)
	sta tmp0
	lda tmp0+1
	adc #HI(buffer_occ-scr_buffer)
	sta tmp0+1
	

    ;; We have in tmp1 the code of the pixel in scan
    ;; and in tmp0 the destination address

	;; Adjust number of rotations per byte
	lda tmp1
	asl
	asl
	ldx #0
pm_preparerot
	asl
	bcs pm_endpreparerot
	inx
	jmp pm_preparerot
pm_endpreparerot
	stx tmp1
	
	lda tmp3+1
	cmp scans_to_draw
	bcc pm_loop1about
	lda scans_to_draw
pm_loop1about
	sta reg14

    lda scan_to_start
    sta scan2start4+1
    sta scan2start4b+1

    lda scans_to_draw
    sta scans2draw2+1
    sta scans2draw2b+1


pm_loop1
    ;;  Some initializations...
    ldy #0
    sty reg15
    ldy reg14

pm_loop2
    lda (tmp0),y       ; Take screen contents 
    sta tmp

invert4
	lda #0
    beq pm_noinvert

    sty aux
    lda tmp3+1
    sec
    sbc aux     ; (scans-current_scan)
    tay
    iny

    lda (tmp5),y       ; Take scan of mask
	tax
	lda tab_inverted_bytes,x
    sta reg13

    ldy aux
    bvc pm_rotate ; Branches allways

pm_noinvert
    lda (tmp5),y       ; Take scan of mask
    sta reg13

pm_rotate
    ;; Initializations for rotation loop
    lda #0
	ldx tmp1
    beq pm_end_rot
pm_looprot
    
    clc
    ror reg13
    ror 
    
 	dex
 	bne pm_looprot
pm_end_rot

scans2draw2
    cpy #0
    bpl pm_nopaint        
    
    ;; As an scan is composed by the less-significant 6 bits 
    ;; of the byte we should rotate this twice more...
    
    ror 
    ror 
    
   
    ;; Now we have:
    ;;  For the mask;
    ;;      in a the new value for this scan
    ;;      in reg15 the value calculated previosly for this scan (to be ORed)
    ;;      in reg13 the value to be ORed to the next scan to be calculated

    ora reg15       ; Complete mask for this scan
	ora tmp
	
    
    sta (tmp0),y    ; Put everything in screen
pm_nopaint
    
    ldx reg13
    stx reg15       ; Ready for next loop

    dey
	beq pm_noloop2
scan2start4
	cpy #0
	bmi pm_nopaint2
	
    jmp pm_loop2      ; End of scans loop
pm_noloop2
    ;; THERE IS ONE SCAN LEFT TO GO
scans2draw2b
    cpy #0
    bpl pm_nopaint2
    
scan2start4b
    cpy #0
    bmi pm_nopaint2

 
    lda (tmp0),y       ; Take screen contents 
    sta tmp

    lda reg15       ; Get mask for this scan
	ora tmp
    sta (tmp0),y    ; Put everything in screen
pm_nopaint2

    lda tmp0
    sec
    ;sbc #8         ; Point to previous line
    sbc #SCANSINBUFF         ; Point to previous line
    bcs pm_no_carry1
    dec tmp0+1
pm_no_carry1
    sta tmp0

    lda tmp5   
    sec
    sbc tmp3+1
    bcs pm_dec5
    dec tmp5+1
pm_dec5
    sta tmp5
    
    ;; Next line
    dec tmp3       
    beq pm_end
    jmp pm_loop1      ; End of lines loop

pm_end
    rts         ; We're done!


; End of put_mask





#ifdef DUMPMASK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void dump_mask()
; paints the dump mask buffer on screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+dump_mask
    
	lda double_buff
    pha
    lda #0
    sta double_buff
    
    lda #120
    sta op1
    lda #190
    sta op2
    jsr pixel_address

	
    ;; Pointer in tmp1
    lda #LO(buffer_occ)
	sta tmp1
    lda #HI(buffer_occ)
    sta tmp1+1

    lda #0
    sta tmp
    ldx _clip_rgn+3
    dex
    txa
#ifdef EIGTHSCANS
    asl
    rol tmp
    asl
    rol tmp
    asl
    rol tmp

    adc tmp1
    sta tmp1
    lda tmp
    adc tmp1+1
    sta tmp1+1

#else
    asl
    sta tmp
    asl
    clc
    adc tmp
    adc tmp1
    sta tmp1
    bcc nocarryt6
    inc tmp1+1
nocarryt6
#endif        
 
    ldx _clip_rgn+3 ; get lines

dm_looplines
    ldy _clip_rgn+2 ; get scans
    dey
dm_loopscans
    lda (tmp1),y
    sta (tmp0),y
    dey
    bpl dm_loopscans

    lda tmp0
    sec
    sbc #40         ; Point to previous line
    bcs dm_no_carry
    dec tmp0+1
dm_no_carry
    sta tmp0

    lda tmp1
    sec
;    sbc #8        ; Point to previous line
    sbc #SCANSINBUFF        ; Point to previous line
    bcs dm_no_carry2
    dec tmp1+1
dm_no_carry2
    sta tmp1

    dex
    bne dm_looplines
    
    pla
    sta double_buff
    
    ;rts ; We're done

;; End of paint_buff


dump_clip
	lda double_buff
    pha
    lda #0
    sta double_buff
    
    lda #20
    sta op1
    lda #190
    sta op2
    jsr pixel_address

	
    ;; Pointer in tmp1
    lda #LO(scr_buffer)
	sta tmp1
    lda #HI(scr_buffer)
    sta tmp1+1

    lda #0
    sta tmp
    ldx _clip_rgn+3
    dex
    txa
#ifdef EIGTHSCANS
    asl
    rol tmp
    asl
    rol tmp
    asl
    rol tmp
    
    adc tmp1
    sta tmp1
    lda tmp
    adc tmp1+1
    sta tmp1+1
#else
    asl
    sta tmp
    asl
    clc
    adc tmp
    adc tmp1
    sta tmp1
    bcc nocarryt5
    inc tmp1+1
nocarryt5
#endif
    
    

    ldx _clip_rgn+3 ; get lines

dc_looplines
    ldy _clip_rgn+2 ; get scans
    dey
dc_loopscans
    lda (tmp1),y
    sta (tmp0),y
    dey
    bpl dc_loopscans

    lda tmp0
    sec
    sbc #40         ; Point to previous line
    bcs dc_no_carry
    dec tmp0+1
dc_no_carry
    sta tmp0

    lda tmp1
    sec
;    sbc #8        ; Point to previous line
    sbc #SCANSINBUFF        ; Point to previous line
    bcs dc_no_carry2
    dec tmp1+1
dc_no_carry2
    sta tmp1

    dex
    bne dc_looplines
    
    pla
    sta double_buff
    
    rts ; We're done

#endif



