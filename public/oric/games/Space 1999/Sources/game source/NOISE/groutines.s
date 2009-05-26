



; Graphic routines

#define msb_hires_address $a0

; These are for put_sprite
#define reg10 tmp6
#define reg11 tmp6+1
#define reg12 tmp7
#define reg13 tmp7+1
#define reg14 op1
#define reg15 op2
#define scans_to_draw op1+1
#define scan_to_start op2+1

#define HI(a)   >a
#define LO(a)   <a  



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  pixel_address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MC routine that calculates the address pointer for a given pixel (x,y) and
; the pixel in scan.
; Needs:
; op1 x coordinate
; op2 y coordinate
;
; Returns:
; The address of the scan in tmp0 which includes
; the selected pixel is calculated as:
;
;  y*40+x/6+base_hires_address.
;
; and the pixel in scan as a bit in tmp1
;
;  x mod 6

; 1st: how to find y * 40 and to enjoy it.
kk2  .word $0000

+pixel_address
    lda double_buff
    beq pp_screen

    ;; Use double-buffer
    lda #0
    sta tmp0+1

    lda op1
    sec
    sbc _clip_rgn
    sta op1  
    bpl pp_positive1
    lda #1
    pha
    jmp pp_positiveend
pp_positive1
    lda #0
    pha 
pp_positiveend   
    lda _clip_rgn+1  
    sec
    sbc op2
    sta tmp
    lda _clip_rgn+3
    sec
    sbc tmp
    sta op2

    dec op2
    lda op2
#ifdef EIGTHSCANS
    asl         ;; (y-1)*8
    rol tmp0+1
    asl
    rol tmp0+1
    asl
    rol tmp0+1
    sta tmp0
    jmp pp_done1
#else
    asl         ;; (y-1)*6
    sta kk2
    asl
    clc
    adc kk2
    sta tmp0

    jmp pp_done1
#endif

pp_screen
    lda op2         ;; the tab_scan contains only the addresses for even rows, so
    lsr             ;; we 1st check if row if even or odd: IF CARRY IS 1 AFTER
    bcs pp_oddrow  ;; A RIGHT LOGICAL SHIFT THEN IT'S ODD, else it's even.
    rol             ;; we restore the original value...
    tay             ;; ...use it as index...
    lda tab_scan,y  ;; ...look up LSB of offset then...
    sta tmp0        ;; ...store it...
    iny         
    lda tab_scan,y  ;; same for MSB...
    sta tmp0+1
    jmp pp_done1   ;; ...and done for now.
pp_oddrow          
    rol             ;; here: if the row is ODD, we fetch the offset of the FORMER
    tay             ;; one, and add 40 to it... eeeasy as pie... albeit a tad
    lda tab_scan,y  ;; confusing here, since we are at an odd offset within the
    sta tmp0+1      ;; table and that means we must swap MSB & LSB for the
    dey             ;; current entry... ie, let this be the scan offset table:
    lda tab_scan,y  
    adc #40         ;;
    sta tmp0        ;;  LSB1    MSB1    LSB2    MSB2    LSB3   ...
    bcc pp_done1   ;;                              ^ Y points here so...
    inc tmp0+1      ;;          ^ we store, decrement, then add 40.
pp_done1


; 2nd: we must now find (x div 6) and (x mod 6).

;; The idea here is a bit the same that before, BEING THE KEY that:
;;  * EVEN numbers are 0, 2 or 4 (mod 6), while
;;  * ODD numbers are 1, 3 or 5 (mod 6).
;; It follows that there are two cases:
;;  * case 1:  x = 2 * k  (k whole):
;;      x div 6 = k div 3
;;      x mod 6 = 2 * (k mod 3)
;;  * case 2:  x = 2 * k + 1 (k whole):
;;      x div 6 = k div 3 = (2 * k) div 6 = (x - 1) div 6
;;      x mod 6 = ((x - 1) mod 6) + 1
;; Confused?  You are not a Jedi yet. :)
;; Besides, in tab_mod06 are not the remainders, but the pixel masks
;; (of even cols), going as:
;;  remainder 0 ->  mask 32
;;  remainder 2 ->  mask 8
;;  remainder 4 ->  mask 2
;; The masks for odd cols are resp. 16, 4 and 1, which are halves of the
;; even ones, so we must lsr them after fetching.


;; THIS DOES WORK WITH X<0!!!! 
    lda double_buff
    beq pp_positive2   
    pla
    pha
    beq pp_positive2   
    lda #0
    sec
    sbc op1 
    sta op1
pp_positive2
    lda op1         ;; we 1st load coord x.
    tax             ;; use it as index.
    lsr             ;; is it odd?
    bcs pp_oddcol  ;; then skip till next label, else...
    lda tab_mod06,x ;; load quotient & store it
    sta tmp       
    inx             ;; next offset in table is mask.
    lda tab_mod06,x
    sta tmp1       
    jmp pp_done2   ;; done!
pp_oddcol          ;; what if x is odd? Note the sequence
    asl             ;; "lsr a / asl a" means A := (A/2)-1 if
    tax             ;; A is odd (this case), so now a is even.
    lda tab_mod06,x ;; we fetch divisor then
    sta tmp         ;; store it...
    inx
    lda tab_mod06,x ;; now the pixel mask (doubled)...
    lsr             ;; all that's left is adjusting the mask.
    sta tmp1
pp_done2
    
    lda double_buff
    beq pp_positive3    
    pla
    pha
    beq pp_positive3
    lda tmp1
    cmp #32
    bne pp_not32
    dec scan_to_start   
    jmp pp_endchange
pp_not32	
	tax
	lda tab_inverted_bytes,x
	lsr
	inc tmp
pp_endchange    
    sta tmp1
    
       
pp_positive3   
; All together now!

    lda double_buff
    beq pp_screen2
    
    lda tmp0
    clc
    adc #LO(scr_buffer)
    sta tmp0
    lda tmp0+1
    adc #HI(scr_buffer)
    sta tmp0+1
    
    pla
    beq pp_positive4
       
    lda tmp0
    sec     
    sbc tmp
    sta tmp0
    bcs pp_nocarry1
    dec tmp0+1
pp_nocarry1
    jmp pp_end
    
pp_positive4
    lda tmp0
    adc tmp
    sta tmp0
    bcc pp_nocarry
    inc tmp0+1
pp_nocarry
    jmp pp_end

pp_screen2
    lda tmp0
    adc tmp
    sta tmp0
    lda tmp0+1
    adc #msb_hires_address
    sta tmp0+1
pp_end 
    rts ; We're done!


#ifdef TINYNOISE
fetch_coords
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
	rts
#endif

;;;;;;;;;;;; Functions to be called from C ;;;;;;;;;;;;;;;;

.zero
aux .byt 0

.text

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; put_sprite(char x_pos, y_pos, sprite_t * sprite, char invert)
;; Masked drawing of a sprite on screen.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_put_sprite

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
    
    lda double_buff
    beq sps_cont1
    jsr intersect_rect
    beq sps_cont1
    rts
sps_cont1 

	lda op1
	pha
	lda op2
	pha
	lda tmp2
	pha
	lda tmp2+1
	pha
	lda tmp3
	pha
	lda tmp3+1
	pha
	ldy #6      ; Paint inverted
    lda(sp),y
    sta invert1+1
	
	

	jsr calc_occlusion_mask ; Calculates the mask for occlusions

	pla
	sta tmp3+1
	;sta scans_to_draw
    clc
    adc #1
    sta scans_to_draw
    pla
	sta tmp3
	pla
	sta tmp2+1
	pla
	sta tmp2
	pla
	sta op2
	pla
	sta op1

	

    lda #0
    sta scan_to_start
   
    ldy #2
    lda (tmp2),y
    sta tmp4
    iny
    lda (tmp2),y
    sta tmp4+1       ; Pointer to sprite image

    ldy #4
    lda (tmp2),y
    sta tmp5
    iny
    lda (tmp2),y
    sta tmp5+1       ; Pointer to sprite mask

    lda tmp4
    sec
    sbc tmp3+1	; Was tmp... a copy of tmp3+1 (?)
    bcs sps_nocarry2
    dec tmp4+1
sps_nocarry2
    sta tmp4

    lda tmp5
    sec
    sbc tmp3+1 ; Was tmp... a copy of tmp3+1 (?)
    bcs sps_nocarry3
    dec tmp5+1
sps_nocarry3
    sta tmp5

    ; Test parameter to see if we use double buffer or not...
    lda double_buff
    beq sps_noadjust
    jsr adjust_clip
	;jmp sps_cont2
sps_noadjust    
sps_cont2

    jsr pixel_address

    ;; We have in tmp1 the code of the pixel in scan
    ;; and in tmp0 the destination address


	;; Now prepare pointer to buffer of occlusions
	
	lda tmp0
	clc
	adc #LO(buffer_occ-scr_buffer)
	sta reg7
	lda tmp0+1
	adc #HI(buffer_occ-scr_buffer)
	sta reg7+1

	;; Adjust number of rotations per byte
	lda tmp1
	asl
	asl
	ldx #0
sps_preparerot
	asl
	bcs sps_endpreparerot
	inx
	jmp sps_preparerot
sps_endpreparerot
	stx tmp1
	
	lda tmp3+1
	cmp scans_to_draw
	bcc sps_loop1about
	lda scans_to_draw
sps_loop1about
	sta reg14

    lda scan_to_start
    sta scan2start+1
    sta scan2startb+1

    lda scans_to_draw
    sta scans2draw+1
    sta scans2drawb+1

sps_loop1
    ;;  Some initializations...
    ldy #0
    sty reg12
    ldy #$ff
    sty reg15
    ldy reg14

sps_loop2
    lda (tmp0),y       ; Take screen contents 
    sta tmp

	lda (reg7),y	   ; Take occlusion mask contents
	sta tmp+1

invert1	
	lda #0
    beq sps_noinvert

    sty aux
    lda tmp3+1
    sec
    sbc aux     ; (scans-current_scan)
    tay
    iny

    lda (tmp4),y       ; Take scan of sprite graphic
	tax
	lda tab_inverted_bytes,x
    sta reg10
    lda (tmp5),y       ; Take scan of mask
	tax
	lda tab_inverted_bytes,x
    eor #$ff
    sta reg13

    ldy aux
    bvc sps_rotate ; Branches allways

sps_noinvert
    lda (tmp4),y       ; Take scan of sprite graphic
    and #$bf           ; remove bit 7 (due to pictconv)
    sta reg10
    lda (tmp5),y       ; Take scan of mask
    eor #$ff           ; complement 
    sta reg13

sps_rotate
    ;; Initializations for rotation loop
    lda #0
    sta reg11
    lda #$ff
  
	ldx tmp1
    beq end_rot
sps_looprot
    lsr reg10
	ror reg11
    
    sec
    ror reg13
    ror 
    
 	dex
 	bne sps_looprot
end_rot

scans2draw
    cpy #0
    bpl sps_nopaint        
    
    ;; As an scan is composed by the less-significant 6 bits 
    ;; of the byte we should rotate this twice more...
    
    ror 
    ror 
    
    lsr reg11
    ror reg11

   
    ;; Now we have:
    ;;  For the graphic:    
    ;;      in reg11 the new value for this scan
    ;;      in reg12 the value calculated previously for this scan (to be ORed)
    ;;      in reg10 the value to be ORed to the next scan to be calculated
    ;;  For the mask;
    ;;      in reg14 the new value for this scan
    ;;      in reg15 the value calculated previosly for this scan (to be ORed)
    ;;      in reg13 the value to be ORed to the next scan to be calculated

    ;lda reg14       ; Get mask
    and reg15       ; Complete mask for this scan
	ora tmp+1
    and tmp         ; Mask AND screen
	sta tmp
	lda tmp+1
	eor #$3f
	sta tmp+1
    lda reg11       ; OR Graphic    
    ora reg12       ;   Complete graphic
	and tmp+1
	ora tmp
	
    
    sta (tmp0),y    ; Put everything in screen
sps_nopaint
    
    ldx reg10
    stx reg12       
    ldx reg13
    stx reg15       ; Ready for next loop

    dey
	beq sps_noloop2
scan2start
	cpy #0
	bmi sps_nopaint2
	
    jmp sps_loop2      ; End of scans loop
sps_noloop2
    ;; THERE IS ONE SCAN LEFT TO GO
scans2drawb
    cpy #0
    bpl sps_nopaint2

scan2startb    
    cpy #0
    bmi sps_nopaint2
   
    lda (tmp0),y       ; Take screen contents 
    sta tmp
	lda (reg7),y	   ; Take occlusion mask contents
	sta tmp+1
	

    lda reg15       ; Get mask for this scan
	ora tmp+1
    and tmp         ; Mask AND screen
	sta tmp
	lda tmp+1
	eor #$3f
	sta tmp+1
    lda reg12       ; OR Graphic
	and tmp+1
	ora tmp
    sta (tmp0),y    ; Put everything in screen
sps_nopaint2

    lda tmp0
    sec
sps_dbl
    sbc #40         ; Point to previous line
    bcs sps_no_carry1
    dec tmp0+1
sps_no_carry1
    sta tmp0

    lda reg7
    sec
sps_dbl2
;    sbc #8         ; Point to previous line
    sbc #SCANSINBUFF         ; Point to previous line
    bcs sps_no_carry1b
    dec reg7+1
sps_no_carry1b
    sta reg7


    ;; Decrement pointers
    lda tmp4   
    sec
    sbc tmp3+1
    bcs sps_dec4
    dec tmp4+1
sps_dec4
    sta tmp4

    lda tmp5   
    sec
    sbc tmp3+1
    bcs sps_dec5
    dec tmp5+1
sps_dec5
    sta tmp5
    
    ;; Next line
    dec tmp3       
    beq sps_end
    jmp sps_loop1      ; End of lines loop

sps_end
    rts         ; We're done!


; End of _put_sprite
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char * pixel_address(char pos_x, char pos_y, char* bit)
; 
; Returns
; The address of the scan which includes
; the selected pixel is calculated as:
;
;  y*40+x/6+base_hires_address.
;
; and the pixel in scan in bit as:
;
;  x mod 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_pixel_address
    ldy #2
    lda (sp),y
    sta op2
    ldy #0
    lda (sp),y
    sta op1
    
    ; Initialise message adress using the stack parameter
    ; this uses self-modifying code
    ; (the $0123 is replaced by bit adress)
    ldy #4
    lda (sp),y
    sta pp_scan+1
    iny
    lda (sp),y
    sta pp_scan+2
    
    jsr pixel_address
    
    ldx #0
    lda tmp1
pp_scan
    sta $0123,x
    ldx tmp0
    lda tmp0+1
    rts
; This ends _pixel_address






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; put_sprite2(char x_pos, y_pos, sprite_t * sprite, char invert)
;; Masked drawing of a sprite on screen. No rotations.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_put_sprite2
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
    
    lda double_buff
    beq sps2_cont1

    jsr intersect_rect
    beq sps2_cont1b
    rts
sps2_cont1 
    ; Not in double buffer... check if needs clipping upwards
    lda op2 ; get y
    sec
    sbc tmp3 ; y-heigth
    bcs sps2_cont1b ; no clipping
    ; perform clipping
    clc
    adc tmp3
    sta tmp3
sps2_cont1b

    ldy #6      ; Paint inverted
    lda(sp),y
    sta invert2+1

    lda tmp3+1
    sta scans_to_draw
    
   ; inc scans_to_draw  ; This is needed in case nobody modifies it.
    lda #0
    sta scan_to_start
    
    ldy tmp3+1 ;scans
	dey
    sty tmp
   
    ldy #2
    lda (tmp2),y
    sta tmp4
    iny
    lda (tmp2),y
    sta tmp4+1       ; Pointer to sprite image

    ldy #4
    lda (tmp2),y
    sta tmp5
    iny
    lda (tmp2),y
    sta tmp5+1       ; Pointer to sprite mask

    lda tmp4
    sec
    sbc tmp
    bcs sps2_nocarry2
    dec tmp4+1
sps2_nocarry2
    sta tmp4

    lda tmp5
    sec
    sbc tmp
    bcs sps2_nocarry3
    dec tmp5+1
sps2_nocarry3
    sta tmp5

    ; Test parameter to see if we use double buffer or not...
    lda double_buff
    beq sps2_noadjust
    jsr adjust_clip
	
    jmp sps2_cont2
sps2_noadjust    
sps2_cont2
    jsr pixel_address

    ;; We have in tmp1 the code of the pixel in scan
    ;; and in tmp0 the destination address

    lda scan_to_start
    sta scan2start2+1
   
sps2_loop1
    ;;  Some initializations...
	ldy scans_to_draw
	dey
					
sps2_loop2
scan2start2    
    cpy #0
    bmi sps2_nopaint

pscreen1
    lda (tmp0),y       ; Take screen contents 
    sta tmp

invert2
	lda #0
    beq sps2_noinvert

    sty aux

    lda tmp3+1
	clc			; DONE ON PURPOSE, BEWARE!
    sbc aux     ; (scans-current_scan)
    tay

	lda (tmp5),y	; Get mask
	tax
	lda tab_inverted_bytes,x
    eor #$ff        ; complement
	and tmp			; AND screen
	sta tmp
	lda (tmp4),y	; Get Graphic
	tax
	lda tab_inverted_bytes,x
	ora tmp			; OR Graphic and rest
	
    ldy aux

    bvc sps2_paint  ; Branches allways


sps2_noinvert
	lda (tmp5),y	; Get mask
    eor #$ff        ; complement
	and tmp			; AND screen
	sta tmp
	lda (tmp4),y	; Get Graphic
	ora tmp			; OR Graphic and rest

sps2_paint

    sta (tmp0),y    ; Put everything in screen

sps2_nopaint
    dey
    bpl sps2_loop2  ; End of scans loop
sps2_noloop2


    lda tmp0
    sec
sps2_dbl
    sbc #40         ; Point to previous line
    bcs sps2_no_carry1
    dec tmp0+1
sps2_no_carry1
    sta tmp0

    ;; Decrement pointers
    lda tmp4   
    sec
    sbc tmp3+1
    bcs sps2_dec4
    dec tmp4+1
sps2_dec4
    sta tmp4

    lda tmp5   
    sec
    sbc tmp3+1
    bcs sps2_dec5
    dec tmp5+1
sps2_dec5
    sta tmp5
    
    ;; Next line
    dec tmp3       
    beq sps2_end
    jmp sps2_loop1      ; End of lines loop

sps2_end
    rts         ; We're done!








