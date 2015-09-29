;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Code to handle sprite masked drawing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _put_sprites
;; Draw sprites on the backbuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_put_sprites
.(
;; Render all shots
.(
	ldx #MAX_SPRITES
loop
	lda sprite_status,x
	beq skip
	stx savx+1
	jsr render_shot
savx	
	ldx #0
skip
	dex
	cpx #FIRST_SHOT-1
	bne loop
.)
;; Render hero shadow
.(
	lda labyrinth_mode
	bne skip
	lda sprite_status+1
	beq skip
	ldx #1
	jsr render_sprite
skip	
.)	
;; Render all enemies
.(
	ldx #FIRST_SHOT-1
loop
	lda sprite_status,x
	beq skip
	stx savx+1
	jsr render_sprite
savx	
	ldx #0
skip
	dex
	cpx #1
	bne loop
.)
;; Render hero
.(
	lda ccommand_h
	beq skiprender
	lda skip_hero_drawing
	bne skip
skiprender
	ldx #0
	lda sprite_status
	beq skip
	jsr render_sprite
skip	
.)	
	rts

.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Renders the sprite of code
; passed in reg X. This routine
; handles sprites of 2x2 chars
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.zero 
mirror_draw .byt 00
.text

render_sprite
.(
	; put characters on correct positions
	; Is the character visible?
	lda sprite_cols,x
	sec
	sbc _inicol
	clc
	adc #2
	bpl okhere
retme
	rts
okhere
	cmp #39
	bcs retme
okthere
	sta tmp4

	; Calculate rowx40 and store in tmp1
	ldy sprite_rows,x
	lda tab_m40lo,y
	sta tmp1
	lda #>_backbuffer
	clc
	adc tab_m40hi,y
	sta tmp1+1

	; Now put the characters at the correct
	; positions in the backbuffer
	ldy tmp4
	lda (tmp1),y
	sta t11+1
	lda sprite_tile11,x
	sta (tmp1),y
	iny
	lda (tmp1),y
	sta t12+1
	lda sprite_tile12,x
	sta (tmp1),y
	tya
	clc
	adc #39
	tay	
	lda (tmp1),y
	sta t21+1
	lda sprite_tile21,x
	sta (tmp1),y
	iny
	lda (tmp1),y
	sta t22+1
	lda sprite_tile22,x
	sta (tmp1),y
	
	; Now render the background in those characters
	; Let's first hack a bit, as we need to know if we are
	; drawing on an odd or even line.
	; Store the base pointer in tmp3+1
	;lda #0
	;sta tmp3	
	lda sprite_rows,x
	and #%1
	tay
	lda base_charset_p,y
	sta tmp3+1

	; Update sprite pointers
	; for drawing using render_tile
	ldy sprite_type,x
	lda needs_mirroring,y
	sta mirror_draw
	beq no_mirror
	lda sprite_dir,x
	bmi inversed_draw
no_mirror	
	lda sprite_maskl,x
	sta smc_mask_p+1
	lda sprite_maskh,x
	sta smc_mask_p+2
	lda sprite_grapl,x
	sta smc_sprite_p+1
	lda sprite_graph,x
	sta smc_sprite_p+2
	jmp endinvcheck
inversed_draw
	lda sprite_maskl,x
	sta smc_maski_p+1
	lda sprite_maskh,x
	sta smc_maski_p+2
	lda sprite_grapl,x
	sta smc_spritei_p+1
	lda sprite_graph,x
	sta smc_spritei_p+2
endinvcheck
	
	; Time to get the tile code from the map
t11	
	lda #0	; Contains the tile in the backbuffer to write onto

	; And destination tile
	ldy sprite_tile11,x
	; save X for later
	stx tmp3

	; Off he goes...
	pha
	lda mirror_draw
	beq no_mirror1
	lda sprite_dir,x
	bmi inverse_draw1
no_mirror1	
	pla
	jsr render_tile
	jsr add8pointers
	jmp t12
inverse_draw1
	jsr add8pointersi
	pla
	jsr render_tilei
	jsr sub8pointersi
	
	; Get next tile code
t12	
	lda #0	; Contains the tile in the backbuffer to write onto
	
	; And destination tile
	ldx tmp3
	ldy sprite_tile12,x

	; Off he goes...
	ldx tmp3
	pha
	lda mirror_draw
	beq no_mirror2
	lda sprite_dir,x
	bmi inverse_draw2
no_mirror2	
	pla
	jsr render_tile
	jsr add8pointers
	jmp skipt12
inverse_draw2
	pla
	jsr render_tilei
	jsr add8pointersi
	jsr add8pointersi
	jsr add8pointersi
skipt12
	; Change charsets
	lda tmp3+1
	eor #%00001100
	sta tmp3+1

	; Get tile code
t21	
	lda #0	; Contains the tile in the backbuffer to write onto

	; And destination tile
	ldx tmp3
	ldy sprite_tile21,x

	; Off he goes...
	pha
	lda mirror_draw
	beq no_mirror3
	lda sprite_dir,x
	bmi inverse_draw3
no_mirror3	
	pla
	jsr render_tile
	jsr add8pointers
	jmp t22
inverse_draw3
	pla
	jsr render_tilei
	jsr sub8pointersi	

	; Get next tile code
t22	
	lda #0	; Contains the tile in the backbuffer to write onto

	; And destination tile
	ldx tmp3
	ldy sprite_tile22,x
	
	; Off he goes...
	pha
	lda mirror_draw
	beq normal
	lda sprite_dir,x
	bpl normal
	pla
	jmp render_tilei
normal	
	pla
	jmp render_tile
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Renders the sprite of code
; passed in reg X. This routine
; handles sprites of 1x1 chars
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

render_shot
.(
	; put characters on correct positions
	; Is the character visible?
	lda sprite_cols,x
	sec
	sbc _inicol
	clc
	adc #2
	bpl okhere
retme
	; First remove this shot
	lda #0
	sta sprite_status,x
	rts
okhere
	cmp #39
	bcs retme
okthere
	sta tmp4

	; Calculate rowx40 and store in tmp1
	ldy sprite_rows,x
	lda tab_m40lo,y
	sta tmp1
	lda #>_backbuffer
	clc
	adc tab_m40hi,y
	sta tmp1+1

	; Now put the characters at the correct
	; positions in the backbuffer
	ldy tmp4
	lda (tmp1),y
	sta t11+1
	lda sprite_tile11,x
	sta (tmp1),y
	
	; Now render the background in those characters
	; Let's first hack a bit, as we need to know if we are
	; drawing on an odd or even line.
	; Store the base pointer in tmp3+1
	lda sprite_rows,x
	and #%1
	tay
	lda base_charset_p,y
	sta tmp3+1

	; Update sprite pointers
	; for drawing using render_tile

	lda sprite_maskl,x
	sta smc_mask_p+1
	lda sprite_maskh,x
	sta smc_mask_p+2
	lda sprite_grapl,x
	sta smc_sprite_p+1
	lda sprite_graph,x
	sta smc_sprite_p+2

	; Time to get the tile code from the map
t11	
	lda #0	; Contains the tile in the backbuffer to write onto

	; And destination tile
	ldy sprite_tile11,x
	; save X for later
	;stx tmp3

	; Off he goes...
	;jmp render_tile
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Renders tile (code in reg a) into another
; (tile code in reg y), and masks the sprite
; whose pointers have been updated in the smc
; entries below. The charset used is passed
; as $b4 or $b8 in tmp3+1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_tile
.(
	; Got tile code in a, now get a pointer to the graphic
	; Low byte is directly the result in reg a
	tax
	lda tab_mul8_lo,x
	sta smc_bkg_p+1
	lda tmp3+1
	clc
	adc tab_mul8_hi,x
	; High byte needs adding the base pointer
	sta smc_bkg_p+2

	; Now the pointer to the destination character
	; for instance: $b400+(TILE11)*8

	lda tab_mul8_lo,y
	sta smc_dest_p+1
	lda tab_mul8_hi,y ;tmp+1
	clc
	adc tmp3+1
	sta smc_dest_p+2

	ldy #7	
loop
smc_bkg_p
	lda $1234,y
+smc_mask_p
	and $1234,y
+smc_sprite_p
	ora $1234,y
smc_dest_p
	sta $1234,y
	dey
	bpl loop
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Renders tile (code in reg a) into another
; (tile code in reg y), and masks the sprite
; whose pointers have been updated in the smc
; entries below. The charset used is passed
; as $b4 or $b8 in tmp3+1. The tile is 
; first mirrored
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_tilei
.(
	; Got tile code in a, now get a pointer to the graphic
	; Low byte is directly the result in reg a
	tax
	lda tab_mul8_lo,x
	sta smc_bkg_p+1
	lda tmp3+1
	clc
	adc tab_mul8_hi,x
	; High byte needs adding the base pointer
	sta smc_bkg_p+2

	; Now the pointer to the destination character
	; for instance: $b400+(TILE11)*8
	
	lda tab_mul8_lo,y
	sta smc_dest_p+1
	lda tab_mul8_hi,y ;tmp+1
	clc
	adc tmp3+1
	sta smc_dest_p+2

	ldy #7	
loop
smc_bkg_p
	lda $1234,y
+smc_maski_p
	ldx $1234,y
	and inverse_table,x
+smc_spritei_p
	ldx $1234,y
	ora inverse_table,x
smc_dest_p
	sta $1234,y
	dey
	bpl loop
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper to add 8 to pointers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
add8pointers
.(
	lda smc_mask_p+1
	clc
	adc #8
	sta smc_mask_p+1
	bcc skip1
	inc smc_mask_p+2
skip1
	lda smc_sprite_p+1
	clc
	adc #8
	sta smc_sprite_p+1
	bcc skip2
	inc smc_sprite_p+2
skip2
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper to add 8 to pointers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
add8pointersi
.(
	lda smc_maski_p+1
	clc
	adc #8
	sta smc_maski_p+1
	bcc skip1
	inc smc_maski_p+2
skip1
	lda smc_spritei_p+1
	clc
	adc #8
	sta smc_spritei_p+1
	bcc skip2
	inc smc_spritei_p+2
skip2
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper to substract 8 to pointers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sub8pointersi
.(
	lda smc_maski_p+1
	sec
	sbc #8
	sta smc_maski_p+1
	bcs skip1
	dec smc_maski_p+2
skip1
	lda smc_spritei_p+1
	sec
	sbc #8
	sta smc_spritei_p+1
	bcs skip2
	dec smc_spritei_p+2
skip2
	rts
.)