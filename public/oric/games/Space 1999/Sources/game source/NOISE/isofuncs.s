


;;;;;;;;;;;; Functions to be called from C ;;;;;;;;;;;;;;;;
; void init_room()
; void draw_room()
; char get_tile(char i, char j, char k)
; void set_tile(char i, char j, char k, char ID)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

;#define DRAW_FLOOR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void init_room()
; Initializes everything in the room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_init_room

	jsr init_blocks
	jsr init_sprites
	jsr calc_sprite_locs

	rts

#ifdef TINYNOISE 
ij2index
	; Get index
	ldy #0
	lda (sp),y
	asl            ; i*2
	sta tmp
	asl
	asl            ; i*8
	clc
	adc tmp        ; i*10
	sta tmp
	ldy #2
	lda (sp),y
	clc
	adc tmp      ; i*10+j 
	sta tmp
	rts
#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char get_tile(char i, char j, char k)
; returns the tile code at map of heigth k in position (i,j)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_get_tile
#ifdef TINYNOISE    
    jsr ij2index
#else
	; Get index
	ldy #0
	lda (sp),y
	asl            ; i*2
	sta tmp
	asl
	asl            ; i*8
	clc
	adc tmp        ; i*10
	sta tmp
	ldy #2
	lda (sp),y
	clc
	adc tmp      ; i*10+j 
	sta tmp
#endif  
	; Get pointer to map of current layer
	ldy #4
	lda (sp),y ; get heigth
	asl ; double index for 16-bit entries
	tax
	lda _layers,x ; get MSB
	sta tmp0
	lda _layers+1,x ; get LSB
	sta tmp0+1
  
	ldy tmp
	lda (tmp0),y    ; get tile
	tax
	lda #0
	rts ; We're done
  
; End of get_tile



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void set_tile(char i, char j, char k,char tile)
; changes the tile code at map of heigth k in position (i,j)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_set_tile
#ifdef TINYNOISE    
    jsr ij2index
#else
	; Get index
	ldy #0
	lda (sp),y
	asl            ; i*2
	sta tmp
	asl
	asl            ; i*8
	clc
	adc tmp        ; i*10
	sta tmp
	ldy #2
	lda (sp),y
	clc
	adc tmp      ; i*10+j 
	sta tmp
#endif
  
	; Get pointer to map of current layer
	ldy #4
	lda (sp),y ; get heigth
	asl ; double index for 16-bit entries
	tax
	lda _layers,x ; get MSB
	sta tmp0
	lda _layers+1,x ; get LSB
	sta tmp0+1
  
	ldy #6
	lda(sp),y	; tile code

	ldy tmp
	sta (tmp0),y    ; set tile

	lda _init_when_setting
	beq _st_dontinit
	
	jsr init_blocks ; Update things...

_st_dontinit
	rts ; We're done
  
; End of set_tile



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void draw_room()
; Draws the room. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; We need some variables in the zero page... 
.zero
iloop1   .byt 0 ; loop indexes
iloop2   .byt 0
tiley    .byt 0
scry     .byt 0
xo       .byt 0 ; offset of sprite
yo       .byt 0
xx       .byt 0 ; auxiliar screen x coord
map_index .byt 0

.text

#define ancho_tile 24
#define alto_tile 12


init_x .byte $00
init_y .byte $00
len      .byt 0 ; auxiliar NOT USED

+_orig_i .byte $00
+_orig_j .byte $00

+_draw_room
	; Calculate original (j-i)
    lda _orig_j
    sec
    sbc _orig_i
    sta col_max+1

    lda _orig_i
    clc
    adc _orig_j
    sta row_max+1

	lda #0
	sta iloop1
	sta iloop2
	sta map_index
	
	clc
	adc #24+14
	sta init_y
	sta scry

	lda #120
	sta init_x

    lda double_buff
    sta dr2_rows+1 ; Self mod code below
    sta dr_nocheck+1

dr2_columns
	lda iloop1
	sta tiley

	lda #0
	sta iloop2

	lda init_x
	sec
	sbc #ancho_tile/2
	sta init_x
	sta xx

	lda init_y
	clc
	adc #alto_tile/2
	sta init_y
	sta scry

dr2_rows
	; Are we in double buffer mode
    lda #0  ; This is self mod code
    beq dr_nocheck ; We are not...

    ; We are in double buffer mode, so:
    ; tile is (iloop2,tiley) for (i,j)
    ; let's see if we need to draw them
    lda tiley
    sec
    sbc iloop2 ; calculate (j-i) and compare with original
  	
col_max
	sbc #0
	bpl cc_notneg
	sta tmp
	lda #0
	sec
	sbc tmp
;#define ONLYSPRITES
#ifndef ONLYSPRITES
; A quick test
    cmp #5
    bcs dr_no_paint
    bcc dr_nocheck
cc_notneg
	cmp #4		;; WARNING: WITH 4 THERE ARE SOME CASES IT DOES NOT WORK!
	bcs dr_no_paint	
#else
cc_notneg
    sec
    sbc #4
    bpl dr_no_paint
    beq dr_sprites
    lda #0
    beq dr_all
dr_sprites
    lda #1
dr_all
    sta only_sprites+1    
#endif

dr_nocheck

	; Are we in double buffer mode
    lda #0  ; This is self mod code
    beq dr_nocheck2 ; We are not...

    lda iloop1
    clc
    adc iloop2
    sec
row_max
    sbc #0

	bpl cc_notneg2
	sta tmp
	lda #0
	sec
	sbc tmp
    cmp #11 ; Can this be 10? Have to test...
    bcs dr_no_paint
    bcc dr_nocheck2
cc_notneg2
	cmp #12 
	;bcs dr_no_paint
    bcc dr_nocheck2
    rts	    ; No need to inspect more...

dr_nocheck2

	ldx map_index
#ifndef DRAW_FLOOR
	lda sprite_loc,x
	beq dr_no_paint
#endif
	jsr draw_stacked_ex

dr_no_paint	
	lda map_index
	clc
	adc #SIZE_GRID
	sta map_index
	
	lda xx
	clc
	adc #ancho_tile/2
	sta xx

	lda scry
	clc
	adc #alto_tile/2
	sta scry

	inc iloop2
	lda iloop2
	cmp #SIZE_GRID
	bne dr2_rows
	
	inc iloop1
	lda iloop1
	sta map_index
	cmp #SIZE_GRID
	;bne dr2_columns
    beq dr_end
    jmp dr2_columns
	
dr_end
	rts

	;; End of draw_room


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; init_blocks
;; initializes where blocks are in room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_blocks	

	lda #0
	sta iloop1
	sta iloop2
	sta map_index

ib_columns
	lda #0
	sta iloop2

ib_rows
	; Initialize loop & heigth
	lda #0
	sta current_layer
ib_looplayers
	; Get pointer to map of current layer
    lda current_layer
    asl ; double index for 16-bit entries
    tax
    lda _layers,x ; get MSB
    sta tmp
    lda _layers+1,x ; get LSB
    sta tmp+1
   	ldy map_index
    lda (tmp),y    ; get tile
	and #%01111111 ; Remove SPECIAL bit
    beq ib_next
	;lda map_index
	;tax
    ldx map_index
	lda #%10000000
	sta sprite_loc,x
	
ib_next
	inc current_layer
	lda current_layer
	cmp #NUM_LAYERS
	bne ib_looplayers

	lda map_index
	clc
	adc #10
	sta map_index	

	inc iloop2
	lda iloop2
	cmp #10
	bne ib_rows
	
	inc iloop1
	lda iloop1
	sta map_index
	cmp #10
	bne ib_columns
	rts

	;; End of init_blocks




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; draw_stacked 
; Helper function used by draw_room. Implements the 
; stacked drawing method
; 4 heighs to be drawn in a tile position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;only_sprites .byte $00

.zero
current_layer .byte $00
.text

draw_stacked
    ; Get the block to draw... that is i*10+j (NOT i+j*10 as it would seem BEWARE!)
    lda iloop2
    asl            ; i*2
    sta tmp
    asl
    asl            ; i*8
    clc
    adc tmp        ; i*10
    clc
    adc tiley      ; i*10+j 
	tax

draw_stacked_ex	; Jump here if you have in reg x the block index
    ;sta temp_index
	lda sprite_loc,x
	sta spritecode

	; X and Y parameters for put_sprite
    ldy #0
    lda xx
    sta (sp),y     ; store
    ldy #2
	lda scry
    sta (sp),y     ; store


#ifdef DRAW_FLOOR
	lda iloop2
	beq ds_nofloor
	cmp #9
	beq ds_nofloor
	lda tiley
	beq ds_nofloor
	cmp #9
	beq ds_nofloor
	lda #16
	jsr draw_block
ds_nofloor
#endif

	; Initialize loop & heigth
	lda #LAYER_HEIGHT
    sta current_layer_height
    lda #0
	sta current_layer
    ldx #0

ds_looplayers

#define PAINTSP_AFTERBK

#ifndef PAINTSP_AFTERBK
	lsr spritecode	
	bcc ds_nosprites
	;; Paint sprites at this height
	jsr paint_sprites
    lda current_layer
ds_nosprites
#endif

#ifdef ONLYSPRITES
only_sprites
	lda #0
	bne ds_next
#endif
	; Get pointer to map of current layer
    ;lda current_layer
    ;asl ; double index for 16-bit entries
    ;tax
    lda _layers,x ; get MSB
    sta tmp
    lda _layers+1,x ; get LSB
    sta tmp+1
   	ldy map_index
    lda (tmp),y    ; get tile

	and #%01111111 ; Remove SPECIAL bit
    beq ds_next

    jsr draw_block

ds_next
#ifdef PAINTSP_AFTERBK
	lsr spritecode	
	bcc ds_nosprites
	;; Paint sprites at this height
	jsr paint_sprites
ds_nosprites
#endif


	lda current_layer_height
	clc
	adc #LAYER_HEIGHT
	sta current_layer_height

	; New heigth means changing y
    ldy #2
    lda (sp),y        ; get y
    sec
    sbc #LAYER_HEIGHT
    sta (sp),y     ; store
	;inc current_layer
	;lda current_layer
    ldx current_layer
    inx
    inx
    stx current_layer
	;cmp #NUM_LAYERS
    cpx #NUM_LAYERS*2
	bne ds_looplayers

	lsr spritecode	
	bcc ds_nospritesupper

	;; Paint sprites upper if necessary
    lda #100 ;; all possible heigths
    sta current_layer_height
    jsr paint_sprites
ds_nospritesupper
	rts ; We're done

;; End of draw_stacked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; draw_block
; Helper function used by draw_stacked
; Gets the block to draw in a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

draw_block
    ; Shall we invert?
    sta tmp
    and #%01000000  ; Check INVERTED flag
    beq db_noinvert
    lda #1
db_noinvert
    ldy #6  
    sta (sp),y
	pha

    lda #0
    sta tmp+1
    lda tmp        ; get block back
    and #%00111111  ; Remove INVERTED flag
    asl            ; a*2
    sta tmp
    asl            ; a*4
    clc
    adc tmp        ; a*6
    bcc db_nocarry
    inc tmp+1
db_nocarry
    sta tmp

    ; Save x pos
    ldy #0
    lda (sp),y
    sta save_a2+1

    lda #LO(_bkg_graphs)
    clc
    adc tmp
    ldy #4
    sta (sp),y
    lda #HI(_bkg_graphs)
    adc tmp+1
    iny
    sta (sp),y

	;; Correct position if less than 4 scans AND we are inverting

	pla
	beq db_nocorrect

	; Get field .scans
    lda (sp),y
    sta tmp+1
    dey
    lda (sp),y
    sta tmp

    ldy #1
    lda (tmp),y
    
	sta tmp
	sec
	lda #4
	sbc tmp ; Get 4-.scans
	beq db_nocorrect

	asl	; *2
	sta tmp
	asl ; *4
	clc
	adc tmp ; *6
	sta tmp
	
	ldy #0
	lda (sp),y
	clc
	adc tmp
	sta (sp),y

db_nocorrect
in_kludge_height
	lda #0
	beq db_normal
	jsr put_mask2
	;jmp db_end
    bvc db_end
db_normal
	jsr _put_sprite2
db_end
    ; Restore x pos
save_a2
    lda #0
    ldy #0
    sta (sp),y
    rts

;; End of draw_block



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; paint_sprites
; Helper that paints the characters that are currently in the room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Some locals for paint_sprites

.zero
spritecode .byte $00
who_i .byte $00
who_j .byte $00
who_k .byte $00
sizecode .byte $00
num_sp .byte $00 ; number of sprites in room

.text
cur_char .byte $00 ; current character being displayed
current_layer_height .byte $08 ; heigth of current layer (8 pixels each layer)


paint_sprites
    ;; Initialize loop
    lda _num_chars
	bne pr_chars 
	jmp pr_nochars
pr_chars
    sta num_sp  

pr_loopsprites
    ;; Get current char to be displayed 
    ldy num_sp
    dey     ; num_sp is 1-based BEWARE!
 
    ;lda aux_buff,y  ;; aux_buff is a temp copy of _chars_in_room, made at draw_room.
	lda _chars_in_room,y
       
    ;; If char is 255 (FFh) then it is invalid
    ;cmp #255
	;bne pr_char_valid
pr_char_invalid
    ;jmp pr_notequal
pr_char_valid
    sta cur_char
    
    ;; If k coordinate does not correspond to this
    ;; layer, it should not be painted
    lda aux_buff_k,y
    cmp current_layer_height
    bmi pr_layerok
    jmp pr_notequal
pr_layerok
    lda aux_buff_i,y
    cmp iloop2      ; iloop2 = tilex BEWARE!
    beq pr_equal1
    jmp pr_notequal
pr_equal1
    sta xo
    lda aux_buff_j,y
    cmp tiley
    beq pr_equal2
    jmp pr_notequal    
pr_equal2
    sta yo
    ; if (tilex==xo) && (tiley==yo)

		
	lda cur_char
        
    asl     ; Multiply by 4 (sizeof(moving_object_t))
    asl
    tay

    lda _characters,y ; .fine_coord_i
    sta who_i
    iny     
    lda _characters,y ; .fine_coord_j
    sta who_j
    iny     
    lda _characters,y ; .fine_coord_k
    sta who_k
    iny
    lda _characters,y ; .type
	and #%00111111
	sta sizecode

	; Get inverted flag
	lda _characters,y ; .type
    and #%01000000
    beq pr_noinvert
    lda #1
pr_noinvert
	ldy #6
    sta (sp),y


	;; Calculate x,y screen position from fine coordinates i,j,k
	;; Cannot use ij2xy as it is for tile coordinates

    lda xo
    asl
    sta xo
    asl
    clc
    adc xo
    sta xo  ; xo=xo*6
    lda who_i
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
    lda who_j
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
    sbc who_k
    sta yo  ; yo=tmp+yo-zpos
    
    
    ; Call put_sprite
    ;; It may corrupt contents of sp calling put_sprite, so let's save them...
    ldy #0
    lda (sp),y
    pha
    iny
    iny
    lda (sp),y
    pha
    ;; pointer to sprite is not saved... not necessary yet.
    ; set params...

	;; The pointer to graphics...
    lda cur_char    

    ;; Multiply by 6 (size_of(sprite_t))
    asl
    asl
    sta tmp
    lda cur_char
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
    bcc pr_nocarry
    inc tmp1+1
pr_nocarry

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

	; Adjust coordinates with the sprite size also...
	clc
	adc #ancho_tile/2
;	tay
;	ldx sizecode
;	lda _sizes_i,x  
	tax
	ldy #1
	lda (tmp1),y	; Get number of scans
	sta tmp
	asl	
	clc
	adc tmp			; Multiply by 3 (6 pix per scan /2)
	sta tmp
;	tya     
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

    jsr _put_sprite
	
	;ldx sizecode
	;lda _sizes_k,x
	;asl
	;clc
	;adc who_k
	;sta tmp

    ;; Done. Let's restore contents of sp
    ldy #2
    pla
    sta (sp),y
    dey
    dey
    pla
    sta (sp),y
    
    
    ;; Now set character as invalid, as it has already been painted
    ldy num_sp
    dey     ; num_sp is 1-based BEWARE!
    ;lda #255
    ;sta aux_buff,y
pr_notequal    

    dec num_sp
    beq pr_nomore      
    jmp pr_loopsprites 
pr_nomore
pr_nochars	
    rts

; End of paint_sprites




	