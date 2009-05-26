


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
adjust_clip
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper function
; Adjust pointer, #lines, #scans and x,y position
; of sprite so it clips to the clipping region
; Parametres:
; op1 x position
; op2 y position
; tmp3 lines
; tmp3+1 scans
; tmp4 *image
; tmp5 *mask
; scans_to_draw 
; scan_to_start

; Adjust lines and pointers...

    lda op2             ; if(y_sprite > y_clip)
    sec
    sbc _clip_rgn+1
    bmi ac_donothingy
    beq ac_donothingy  ;{
ac_doy 
    sta tmp     

#define TEST
#ifdef TEST
    ldy tmp3+1
    
ac_loop1
    lda tmp4            ; p_image-=(y_sprite-y_clip)*scans
    sec
    sbc tmp
    sta tmp4
    bcs ac_nocarry1
    dec tmp4+1
ac_nocarry1
    lda tmp5            ; p_mask-=(y_sprite-y_clip)*scans
    sec
    sbc tmp
    sta tmp5
    bcs ac_nocarry2
    dec tmp5+1
ac_nocarry2
    dey
    bne ac_loop1

#else
    tay
ac_loop1
    lda tmp4            ; p_image-=(y_sprite-y_clip)*scans
    sec
    sbc tmp3+1
    sta tmp4
    bcs ac_nocarry1
    dec tmp4+1
ac_nocarry1
    lda tmp5            ; p_mask-=(y_sprite-y_clip)*scans
    sec
    sbc tmp3+1
    sta tmp5
    bcs ac_nocarry2
    dec tmp5+1
ac_nocarry2
    dey
    bne ac_loop1
#endif
    lda tmp3            ; lines-=(y_sprite-y_clip)
    sec
    sbc tmp
    sta tmp3
    
    lda _clip_rgn+1     ; y_sprite=y_clip
    sta op2 
ac_donothingy          ;}

    lda op2             ;b=y_sprite-lines    
    sec
    sbc tmp3
    sta tmp7
    
    lda _clip_rgn+1      ;a=y_clip-lines_clip
    sec
    sbc _clip_rgn+3
    ;sta tmp6
 
    sec
    sbc tmp7            ;if(a>b) ;// SIGNED COMPARISON! 
    sta tmp
    bmi ac_donothingy2
    beq ac_donothingy2
    lda tmp3            ;  lines-=(a-b)   
    sec
    sbc tmp
    sta tmp3
ac_donothingy2         ;}  

; Adjust scans...
    lda _clip_rgn       ; if(x_clip > x_sprite)
    sec
    sbc op1
    bmi ac_donothingx
    beq ac_donothingx  ;{
ac_dox    
    
    jsr do_div6         ; calculate (x_clip-x_sprite) div 6
    tax
    inx
    stx scan_to_start   ; start drawing in scan (x_clip-x_sprite) div 6 + 1
   
    
ac_donothingx          ;}

    
    lda _clip_rgn      ;a=x_clip div 6+scans_clip
    jsr do_div6
    clc
    adc _clip_rgn+2
    sta tmp6
    
    lda op1             ;b=x_sprite div 6+scans_to_draw    
    jsr do_div6
    clc
    adc scans_to_draw
    sta tmp7

    sec
    sbc tmp6            ;if(a<b)
    bmi ac_donothingx2
    beq ac_donothingx2 ;{
ac_dox2
    sta tmp              ;  scans_to_draw-=(a-b)
 
    lda scans_to_draw  
    sec
    sbc tmp    
    sta scans_to_draw
ac_donothingx2         ;}  

    rts                 ;We're done!

;; End of adjust_clip


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
intersect_rect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper function. Calculates if a rectangle intersects 
;; with clipping region
;; Needs: 
;;      op1     X coord of R1
;;      op2     Y coord of R1
;;      tmp3+1  Width of R1 (in scans)
;;      tmp3    Height of R1
;; Returns Z=0 if overlap occurs, else Z=1

;; The formula is !((X1>X2+W2)||(X2>X1+W1)||(Y1>Y2+H2)||(Y2>Y1+H1))
;; or else (X2+W2>=X1)&&(X1+W1>=X2)&&(Y2+H2>=Y1)&&(Y1+H1>=Y2)

    ;lda op2           ;; Y1+H1
    ;tay
    ldy op2
    iny
    tya
    sec               
    sbc tmp3          ;; Y1
	bcs	ir_notneg1      ; clip up!
	lda #0             
ir_notneg1

    sta tmp
    lda _clip_rgn+1   ;; Y2+H2
    cmp tmp           ;; >=Y1  
    bcc irfalse       ;; FALSE

    
    ;lda _clip_rgn+1   ;; Y2+H2
    ;tay
    ;iny
    ;tya
    ;sec
    ;sbc _clip_rgn+3   ;; Y2
   ; bpl ir_notneg2
;	cmp _clip_rgn+1
;	bcs	ir_notneg2
;    lda #0
;ir_notneg2
    ;sta tmp
    ;lda op2           ;; Y1+H1  
    ;cmp tmp           ;; >= Y2  

    sec
	ldy _clip_rgn+1     ;; Y2+H2
	iny
	tya
	sbc _clip_rgn+3     ;; Y2
	sta tmp
	lda op2             ;; Y1+H1
	cmp tmp             ;; >= Y2
    bcc irfalse         ;; FALSE  
    
    lda _clip_rgn+2
    asl
    sta tmp          ;; W2*2
    asl
    clc 
    adc tmp          ;; + W2*4
    sta tmp
	dec tmp    

    lda _clip_rgn     ;; X2
    clc
    adc tmp           ;; X2+W2
    cmp op1           ;; >=X1
    bcc irfalse       ;; FALSE

    lda tmp3+1
    asl
    sta tmp          ;; W1*2
    asl
    clc 
    adc tmp          ;; + W1*4
    sta tmp
	dec tmp

    lda op1           ;; X1
    clc
    adc tmp           ;; X1+W1
    cmp _clip_rgn     ;; >=X2
    bcc irfalse       ;; FALSE

    lda #0
    rts
irfalse
    lda #1
    rts  ; We're done!
    
;; End of intersect_rect

#ifdef CLEARCLIPFN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void clear_clip_rgn();
; Clears the clipping region
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_clear_clip_rgn
    lda _clip_rgn
    sta op1
    lda _clip_rgn+1
    sta op2
    jsr pixel_address

    ;; Pointer in tmp0
    ldx _clip_rgn+3 ; get lines

ccr_looplines
    lda #$40
    ldy _clip_rgn+2 ; get scans
    dey
ccr_loopscans
    sta (tmp0),y
    dey
    bpl ccr_loopscans

    lda tmp0
    sec
    sbc #40         ; Point to previous line
    bcs ccr_no_carry
    dec tmp0+1
ccr_no_carry
    sta tmp0
    dex
    bne ccr_looplines
    
    rts ; We're done

#endif ;CLEARCLIPFN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void clear_buff();
; Clears the buffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_clear_buff
    lda #HI(scr_buffer)
    sta tmp0+1
    lda #LO(scr_buffer)
    sta tmp0
    
    lda #0
    sta tmp
    ;clc 
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
    bcc nocarryt1
    inc tmp0+1
nocarryt1
    sta tmp0
#endif        
 
    ;; Pointer in tmp0
    ldx _clip_rgn+3 ; get lines

cb_looplines
    lda #$40
    ldy _clip_rgn+2 ; get scans
    dey
cb_loopscans
    sta (tmp0),y
    dey
    bpl cb_loopscans

    lda tmp0
    sec
;    sbc #8         ; Point to previous line
     sbc #SCANSINBUFF         ; Point to previous line
    bcs cb_no_carry
    dec tmp0+1
cb_no_carry
    sta tmp0
    dex
    bne cb_looplines
    
    rts ; We're done


;; End of clear_buff

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void set_doublebuff(char status)
; Sets the double buffering on (status<>1) or off (status == 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_set_doublebuff
    ldy #0
    lda (sp),y
    beq sdb_off
    lda #1
    sta double_buff
    ;lda #8  
    lda #SCANSINBUFF  
    sta sps_dbl+1
	sta sps2_dbl+1
    jmp sdb_end
sdb_off
    lda #0
    sta double_buff
    lda #40  
    sta sps_dbl+1
	sta sps2_dbl+1
sdb_end
    rts ; We're done


;; End of set_doublebuff

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void paint_buff()
; paints the double buffer on screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_paint_buff
    
    lda double_buff
    pha
    lda #0
    sta double_buff
    
    lda _clip_rgn
    sta op1
    lda _clip_rgn+1
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
    bcc nocarryt2
    inc tmp1+1
nocarryt2
    sta tmp1
#endif        

    ldx _clip_rgn+3 ; get lines
    ldy _clip_rgn+2 ; get scans
    dey
    sty tmp

pb_looplines
    ldy tmp
pb_loopscans
    lda (tmp1),y
    sta (tmp0),y
    dey
    bpl pb_loopscans

    lda tmp0
    sec
    sbc #40         ; Point to previous line
    bcs pb_no_carry
    dec tmp0+1
pb_no_carry
    sta tmp0

    lda tmp1
    sec
    ;sbc #8        ; Point to previous line
    sbc #SCANSINBUFF       ; Point to previous line
    bcs pb_no_carry2
    dec tmp1+1
pb_no_carry2
    sta tmp1

    dex
    bne pb_looplines
    
    pla
    sta double_buff
    
    rts ; We're done

;; End of paint_buff



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void recalc_clip(char who)
; Recalculates the clipping region for a given character
; after movement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
aux2 .db $00
tempx .db $00
tempy .db $00
+_recalc_clip
	ldy #0
	lda (sp),y  ; grab id of character moving
	sta aux2
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
	sta sizecode

	lda who_i
	jsr do_div6
	sta _orig_i

	lda who_j
	jsr do_div6
	sta _orig_j

	; Prepare for calling ij2xy
	lda _orig_i
	sta op1
	lda _orig_j
	sta op2
	jsr ij2xy
	stx tempx
	sty tempy

	; xo=(who_i-((i<<1)+(i<<2))); yo=(who_j-((j<<1)+(j<<2)));

	lda _orig_i
	asl
	asl
	sta tmp
	lda _orig_i
	asl
	clc
	adc tmp
	sta tmp

	lda who_i
	sec
	sbc tmp

	sta tmp1

	lda _orig_j
	asl
	asl
	sta tmp
	lda _orig_j
	asl
	clc
	adc tmp
	sta tmp

	lda who_j
	sec
	sbc tmp

	sta tmp1+1

	; xo2=(xo-yo)<<1;
	
	lda tmp1
	sec
	sbc tmp1+1
	asl
	sta tmp2

	;yo2=(xo+yo);
	lda tmp1
	clc
	adc tmp1+1
	sta tmp2+1
	
	;y=y-who_k;
	lda tempy
	sec
	sbc who_k
	sta tempy

	; clip_rgn.x_clip=dodiv6(x+xo2); 
	lda tempx
	clc
	adc tmp2
	
	;Adjust sprite size (now x+xo2+(#ancho_tile/2-(size_i*2)))
	adc #ancho_tile/2
	tay
	lda aux2
	asl			; Multiply by 6 (sizeof(sprite_t))
	asl
	sta tmp
	lda aux2
	asl
	clc
	adc tmp
	sta aux2
	tax
	inx
	lda _char_pics,x	; Get number of scans

	sta tmp
	asl	
	clc
	adc tmp			; Multiply by 3 (6 pix per scan /2)
	sta tmp

	;tay
	;ldx sizecode
	;lda _sizes_i,x  
	;asl
	;sta tmp

	tya     
	;sec
    clc     ; ON PURPOSE... SUBSTRACT 1
	sbc tmp
	pha

	jsr do_div6
	sta tmp+1
 
    ;clip_rgn.x_clip=(clip_rgn.x_clip<<1)+(clip_rgn.x_clip<<2); /* *6 */ 
	asl
	asl
	sta tmp 
	lda tmp+1
	asl
    clc
	adc tmp
	sta _clip_rgn

	;clip_rgn.y_clip=y+yo2+3;
	lda tempy
	clc
	adc tmp2+1
;	adc #3
    adc #2
	ldx #1
	sta _clip_rgn,x 

	;clip_rgn.height_clip=char_pics[who].lines+2;
	ldx aux2
	lda _char_pics,x
;	clc
;	adc #2 	
	ldx #3
	sta _clip_rgn,x
	

	;clip_rgn.width_clip=char_pics[who].scans+1;
	ldx aux2
	inx
	lda _char_pics,x 
;	clc
;	adc #1	
	ldx #2
	sta _clip_rgn,x

	; if x mod 6 = 5, then add 1 scan more
	pla
	sec
	sbc _clip_rgn

;    clc
    beq rc_end    

;	cmp #0
;	bne rc_not1
;	lda _clip_rgn
;	sec
;	sbc #6
;	sta _clip_rgn
;	jmp rc_onemorescan
;rc_not1
;	cmp #5
;	bne rc_end
;rc_onemorescan

	inc _clip_rgn,x
;    sec
rc_end	
	rts ; We're done

; End of recalc_clip
