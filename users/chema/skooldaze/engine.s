
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Engine main functions
;; ---------------------


#include "params.h"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This routine mimics the Speccy version, which apparently
; checks 3 characters in case they need moving at each
; frame. Seems too slow on Oric?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_chars
.(
	lda #6
	sta tmp7
loop
	ldx last_char_moved
	jsr move_char
	dec tmp7
	bne loop

	ldx last_char_moved
+move_char
	cpx #20
	bne notend
+demo_ff_00
	ldx #0	; Don't move Eric here
notend
	inx
	stx last_char_moved

	
	jsr must_move

/* 
The character shall be moved. From this point, the following steps are taken: 
1/ If there is an uninterruptible subcommand routine address in bytes 111 and 
	112 of the character's buffer, jump to it 
2/ Call the continual subcommand routine address in bytes 124 and 125 of the 
	character's buffer (and then return to step 3) 
3/ If there is an interruptible subcommand routine address in bytes 105 and 
	106 of the character's buffer, jump to it 
4/ Restart the command list if bits 1 and 0 of byte 122 of the character's 
	buffer are reset and set respectively 
5/ If there is a primary command routine address in bytes 99 and 100 of the 
	character's buffer, jump to it 
6/ Replace any continual subcommand routine address in bytes 124 and 125 of 
	the character's buffer with 25247 (RET) 
7/ Collect the next primary command routine address from the command list, 
	place it into bytes 99 and 100 of the character's buffer, and jump to it 
*/
+unint_subcommand
	;; Step 1
	lda uni_subcom_high,x
	beq nounisubcommand
	sta tmp0+1
	lda uni_subcom_low,x
	sta tmp0
	jmp (tmp0)
nounisubcommand

+cont_subcommand
	;; Step 2
	lda cont_subcom_high,x
	beq nocontsubcommand
	sta smc_cont_jump+2
	lda cont_subcom_low,x
	sta smc_cont_jump+1
smc_cont_jump
	jsr $dead	; this is a jsr, not a jmp as the rest...
nocontsubcommand


+int_subcommand
	;; Step 3
	lda i_subcom_high,x
	beq noisubcommand
	sta tmp0+1
	lda i_subcom_low,x
	sta tmp0
	jmp (tmp0)
noisubcommand

+check_reset_cl
	;; Step 4
	;; The spectrum version checks for bit 1 as 0 to perform the operation
	;; but this bit is always reset, so I guess I can avoid the check here...
	;; Maybe later...
	lda flags,x
	and #RESET_COMMAND_LIST
	beq no_reset
	lda flags,x
	and #(RESET_COMMAND_LIST^$ff) 
	sta flags,x
	lda #0
	sta cur_command_high,x
	sta pcommand,x
no_reset

+primary_command
	;; Step 5
	lda cur_command_high,x
	beq command_completed
	sta tmp0+1
	lda cur_command_low,x
	sta tmp0
	jmp (tmp0)
command_completed	

	;; Step 6
	;; I don't understand why a "continuous" subcommand
	;; is ever reset...
	lda #0
	sta cont_subcom_high,x

+next_command
	;; Step 7
	lda command_list_high,x
	beq nocommandlist
	sta tmp0+1
	lda command_list_low,x
	sta tmp0
	lda pcommand,x
	tay
	lda (tmp0),y	; Keep pointer prepared for the called routine
	tay
	lda command_high,y
	sta smc_command+2
	lda command_low,y
	sta smc_command+1
smc_command
	jmp $dead

nocommandlist
	rts
	
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if a character must be moved, and updates
; the walking speed counter. Character is passed
; in register X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

must_move
.(
+demo_ff_002
	cpx #CHAR_ERIC	; If it is ERIC move always
	beq finish

	dec speed_counter,x
	beq new_pace
	lda speed_counter,x
	and #%00000001
	bne dontmove
	rts
dontmove
	lda flags,x	; If not walking slowly, return and move
	bpl finish

	; For not moving the trick is get rid of the
	; return address and then rts.
	pla
	pla
	rts

new_pace
	jsr randgen

	;asl
	rol tmp ; Save the carry flag
	and #61
	clc
	adc #4
	ror

	sta speed_counter,x
	
#ifdef AVOID_ORICUTRON_BUG
	ror tmp
	bcc noset
	lda #%10000000
	ora flags,x
	sta flags,x
	jmp end
noset
	lda #%01111111
	and flags,x
	sta flags,x
end
#else
	asl flags,x
	ror tmp
	ror flags,x
#endif

	lda flags,x
	and #IS_FAST_WALK
	beq normal

	lda flags,x
	and #(IS_SLOW_WALK^$ff) ;#%01111111 ????
	sta flags,x	
normal
	lda flags,x	
	and #IS_TEACHER
	beq finish
	lda flags,x
	ora #IS_SLOW_WALK
	sta flags,x
finish
	rts
.)


_scroll_right
.(
	lda #5	; Scroll 9 columns
	sta count
loop
  	jsr scroll1_right
	dec count
	bne loop
	rts

count .byt 0
.)

scroll1_right
.(
	lda first_col
	cmp #$fe
	bne doit
	rts
doit

	lda bubble_on
	beq skipbubble
	ldy bubble_col
	iny
	iny
	cpy #LAST_VIS_COL-7
	bcc cont
+rsp_bubble
	; It got out of sight, terminate the subcommand for the
	; speaker and remove the speech bubble
	jsr remove_speech_bubble	
	ldx cur_speaking_char
	lda #0
	sta i_subcom_high,x
	jsr render_screen
	jmp skipbubble
cont
	sty bubble_col
	clc
	lda bubble_loc_p
	adc #2
	bcc noinch
	inc bubble_loc_p+1
noinch
	sta bubble_loc_p

	inc bubble_lip_col
	inc bubble_lip_col

	jsr bitmask_bubble
skipbubble


	dec first_col
	dec first_col
	; Scroll the screen data 1 scan right

	ldx #(SKOOL_ROWS*8)

#ifdef CENTER_PLAY_AREA
	lda #<$a002+160
	sta smc_sp1+1
	lda #<$a004+160
	sta smc_sp2+1
	lda #>$a000+160
#else
	lda #<$a002
	sta smc_sp1+1
	lda #<$a004
	sta smc_sp2+1
	lda #>$a000
#endif
	sta smc_sp1+2
	sta smc_sp2+2
loop1
	ldy #VISIBLE_COLS-2-1
loop2
smc_sp1
	lda $1234,y
smc_sp2
	sta $1234,y
	dey
	bpl loop2


	lda smc_sp1+1
	clc
	adc #40
	sta smc_sp1+1
	bcc skip1
	inc smc_sp1+2
	clc
skip1
	lda smc_sp2+1
	adc #40
	sta smc_sp2+1
	bcc skip
	inc smc_sp2+2
skip

	dex
	bne loop1


	; Update the SRB
	ldx #((SKOOL_ROWS-1)*5)
loop3
	lda #%00110000
	sta SRB,x
	dex
	dex
	dex
	dex
	dex
	bpl loop3

	; Call the redrawing...
	jmp render_screen
.)


_scroll_left
.(
	lda #5	; Scroll 9 columns
	sta count
loop
  	jsr scroll1_left
	dec count
	bne loop

	rts

count .byt 0
.)

scroll1_left
.(
	lda first_col
	cmp #(SKOOL_COLS-VISIBLE_COLS-2)
	;bcc doit
	bmi doit
	rts
doit

	lda bubble_on
	beq skipbubble
	ldy bubble_col
	dey
	dey
	cpy #FIRST_VIS_COL
	;bcs cont
	bpl cont
	jmp rsp_bubble ; It got out of sight
cont
	sty bubble_col
	lda bubble_loc_p
	sec
	sbc #2
	bcs nodech
	dec bubble_loc_p+1
nodech
	sta bubble_loc_p

	dec bubble_lip_col
	dec bubble_lip_col
	jsr bitmask_bubble

skipbubble

	inc first_col
	inc first_col

	; Scroll the screen data 1 scan left
	ldx #(SKOOL_ROWS*8)
#ifdef CENTER_PLAY_AREA
	lda #<$a004+160
	sta smc_sp1+1
	lda #<$a002+160
	sta smc_sp2+1
	lda #>$a000+160
#else
	lda #<$a004
	sta smc_sp1+1
	lda #<$a002
	sta smc_sp2+1
	lda #>$a000
#endif
	sta smc_sp1+2
	sta smc_sp2+2
loop1
	ldy #0
loop2
smc_sp1
	lda $1234,y
smc_sp2
	sta $1234,y
	iny
	cpy #(LAST_VIS_COL-2-1)
	bcc loop2

	lda smc_sp1+1
	clc
	adc #40
	sta smc_sp1+1
	bcc skip1
	inc smc_sp1+2
	clc
skip1
	lda smc_sp2+1
	clc
	adc #40
	sta smc_sp2+1
	bcc skip
	inc smc_sp2+2
skip

	dex
	bne loop1


	; Update the SRB
	ldx #((SKOOL_ROWS-1)*5+4)
loop3
	lda #%00001100
	sta SRB,x
	dex
	dex
	dex
	dex
	dex
	bpl loop3

	; Call the redrawing...
	jmp render_screen
.)

		
change_direction
.(
	
	jsr update_SRB_sp
	
	lda flags,x
	and #IS_FACING_RIGHT	; Direction
	beq r2l
	
	; Update the base pointers

	lda base_as_pointer_low,x
	sec
	sbc tab_offset_invl,x
	sta base_as_pointer_low,x
	lda base_as_pointer_high,x
	sbc tab_offset_invh,x
	sta base_as_pointer_high,x

	lda as_pointer_low,x
	sec
	sbc tab_offset_invl,x
	sta as_pointer_low,x
	lda as_pointer_high,x
	sbc tab_offset_invh,x
	sta as_pointer_high,x
	jmp end
r2l

	lda base_as_pointer_low,x
	clc
	adc tab_offset_invl,x
	sta base_as_pointer_low,x
	lda base_as_pointer_high,x
	adc tab_offset_invh,x
	sta base_as_pointer_high,x

	lda as_pointer_low,x
	clc
	adc tab_offset_invl,x
	sta as_pointer_low,x
	lda as_pointer_high,x
	adc tab_offset_invh,x
	sta as_pointer_high,x

end
	; Change the direction flag
	lda #IS_FACING_RIGHT
	eor flags,x
	sta flags,x
	jmp update_SRB_sp
	;rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Perform the stepping for character passed in reg X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


step_character
.(
	jsr update_SRB_sp

	cpx #19
	bcs pellet_entry	; if it is a pellet, skip all the code below...

+step_character_ex		; Entry point when update_SRB_sp has been called (e.g. up/down stairs)

	ldy anim_state,x
	iny
	cpy #4
	bne skip
	ldy #0
skip
	tya
	sta anim_state,x
	bne incp
	lda base_as_pointer_high,x
	sta as_pointer_high,x
	lda base_as_pointer_low,x
	sta as_pointer_low,x
	jmp end
incp	
	lda as_pointer_low,x
	clc
	adc #16
	sta as_pointer_low,x
	bcc nocarry
	inc as_pointer_high,x
nocarry

end
	lda anim_state,x
	and #%1
	bne noincpos
pellet_entry
	lda flags,x
	and #IS_FACING_RIGHT
	bne otherdir
	dec pos_col,x
	bne noincpos
otherdir
	inc pos_col,x
noincpos
#ifndef AVOID_JSRS
	jmp update_SRB_sp
#endif
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Updates the SRB, marking tiles which need to
; be redrawn for a given sprite (reg X), depending
; on his animatory state.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


update_SRB_sp
.(
	; First check if sprite is visible
	lda pos_col,x
	sec
	sbc first_col
	cmp #$FD ; (-3)
	bmi endme		
	cmp #LAST_VIS_COL+1
	bmi doit
endme
	rts
doit
	; Save col-first_col for later
	sta sav_col+1
	; Get the pointer to the animatoy state
	lda as_pointer_low,x
	sta tmp0
	lda as_pointer_high,x
	sta tmp0+1

	; Prepare pointer to SRB
	lda pos_row,x
	asl
	asl
	adc pos_row,x
	adc #<SRB
	sta smc_srbpl+1
	lda #>SRB	
	adc #0
	sta smc_srbph+1

	lda #4	; Iterate through the 4 columns
	sta tmp
loop
	; Get pointer to SRB at the correct byte
	; and also the correct bitmask
sav_col
	lda #0
	bmi skip
	cmp #FIRST_VIS_COL
	bcc skip
	cmp #LAST_VIS_COL+1
	bcs skip
	lsr 
	lsr 
	lsr
	clc
smc_srbpl
	adc #0
	sta tmp1
	lda #0
smc_srbph
	adc #0
	sta tmp1+1

	lda sav_col+1
	and #%00000111
	tay
	lda tab_bit8,y
	sta tmp2

	ldy #0
	lda (tmp0),y
	beq skip1	; Skip if tilecode is zero

	; Mark the corresponding bit for this SRB
	;ldy #0
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y

skip1
	ldy #4
	lda(tmp0),y
	beq skip2

	; Mark the corresponding bit for this SRB
	ldy #5
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y

skip2	
	ldy #8
	lda(tmp0),y
	beq skip3


	; Mark the corresponding bit for this SRB
	ldy #10
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y

skip3
	ldy #12
	lda(tmp0),y
	beq skip
	
	; Mark the corresponding bit for this SRB
	ldy #15
	lda (tmp1),y
	ora tmp2
	sta (tmp1),y


skip
	inc tmp0
	bne nocarry
	inc tmp0+1
nocarry
	inc sav_col+1
	dec tmp
	bne loop
end
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Updates the SRB, marking the tile at coords
; X,Y as invalid
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
update_SRB
.(
	; Is the tile visible?
	txa
	sec
	sbc first_col
	bmi endme
	cmp #FIRST_VIS_COL
	bcc endme
	cmp #LAST_VIS_COL+1
	bmi doit
endme
	rts
doit
	; It is and the corrected coordinate is in reg A now
	; save it for a moment
	pha

	; Get pointer to the correct row of SRB
	tya
	sta tmp
	asl
	asl
	adc tmp
	adc #<SRB
	sta tmp4
	lda #>SRB	
	adc #0
	sta tmp4+1

	; Get the correct byte of the SRB row
	pla
	pha
	lsr 
	lsr 
	lsr
	tay
	; Reg Y holds the offset of inside the SRB
	; Now get the bitmask
	pla
	and #%00000111
	tax
	lda tab_bit8,x
	ora (tmp4),y
	sta (tmp4),y
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Renders the screen, only redrawing tiles set in the SRB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_screen
.(
	; Iterate through SRB checking for bits set to one
	ldx #SRB_SIZE-1
loop
	lda SRB,x
	beq skip	; If the whole byte is zero, skip (that is a usual case).
	
	ldy #8	; counter
	; start rotating the byte to search for bits set to one...
looprot
	lsr
	dey
	bcc looprot
	
	; We found the bit here, y being its position inside the byte x of the SRB
	sta sav_a+1
	sty sav_y+1
	stx sav_x+1

	; Find out the row number from the byte number (that is divide by 5)
	lda tab_div5,x
	sta vis_row

	; Find out the column number (mod 5 plus the bit number)
	sty tmp0
	lda tab_mod5,x
	clc
	adc tmp0
	sta vis_col
	adc first_col
	sta tile_col

#ifdef AVOID_JSRS
	jmp draw_skool_tile
+return_draw_skool_tile
#else
	jsr draw_skool_tile
	jsr draw_sprites
	jsr dump_buffer
#endif


sav_y
	ldy #0
sav_x
	ldx #0
sav_a
	lda #0	
	bne looprot	; If there are more bits set to one, continue

	; No more bits, clear the SRB byte
	sta SRB,x

	; Get next byte
skip
	dex
	bpl loop


	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws the skool tile (background) of coordinates
; (tile_row, tile_col) onto the backbuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

draw_skool_tile
.(
	; Get the skool UDG for the tile
	lda #>skool_r00
	clc
	adc tile_row
	sta smc_p+2		
	ldy tile_col
smc_p
	ldx $1200,y
	beq blank_tile	; If the skool tile is blank...

	; Prepare a pointer to the UDG data. As the first
	; UDG is code 1, we want (code-1)*8, which is 
	; a 16-bit integer...
	; We can save the dex if we move the data 8 bytes
	; so we could use code*8 directly. This is done
	; in draw_sprites...

	dex

#ifdef FULLTABLEMUL8
	lda tab_mul8,x
#else
	txa
	ldx #0
	stx tmp+1
	asl
	rol tmp+1
	asl
	rol tmp+1
	asl
	rol tmp+1
#endif
	sta smc_udgp+1

	; UDG sets are different for the four sections of the map:
	; columns 0-31,32-63,64-95,96-127
	; If UDG data is alinged to a page for each section
	; we only need the high part of the pointer.
	; We may move this to a table, but it would use 512 bytes.
	; BEWARE: NOW ONLY 3 Sections
	; Sec 1: 1-33 (226 tiles)
	; Sec 2: 34-74 (101 tiles, blackboards are here)
	; Sec 3: 75-128 (216 tiles)
	; Shields are missing...


	/*
	cpy #32
	bcs sec2
	lda #>udg_skool
	bne gotit
sec2
	cpy #64
	bcs sec3
	lda #>udg_skool2
	bne gotit
sec3
	cpy #96
	bcs sec4
	lda #>udg_skool3
	bne gotit
sec4
	lda #>udg_skool4
	*/
	cpy #33
	bcs sec2
	lda #>udg_skool
	bne gotit
sec2
	cpy #74
	bcs sec3
	lda #>udg_skool2
	bne gotit
sec3
	lda #>udg_skool3
gotit
	clc
#ifdef FULLTABLEMUL8
	adc tab_mul8hi,x
#else
	adc tmp+1
#endif
	sta smc_udgp+2

	; here it is... now copy it to the backbuffer

	ldx #7
loop
smc_udgp
	lda udg_skool,x
	sta backbuffer,x
	dex
	bpl loop
#ifdef AVOID_JSRS
	jmp draw_sprites
#else
	rts
#endif

; ...we need to empty the backbuffer and set the attributes, correctly.
blank_tile
	ldx #7
	lda #$40
loop2
	sta backbuffer,x
	dex
	bpl loop2
#ifndef AVOID_JSRS
	rts
#endif
	
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Loops through the character list and updates the
; back buffer with corresponding the character sprite tile.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


draw_sprites
.(
	lda tile_col
	sta smc_tilecol+1
	lda tile_row
	sta smc_tilerow+1

	ldx #MAX_CHARACTERS-1	
loop
	; Check if the character overlaps the current tile
	; start with the col
smc_tilecol
	lda #0	;tile_col
	sec
	sbc pos_col,x
	bmi skip
	cmp #4
	bcs skip
	sta smc_row+1

	; now the row
smc_tilerow
	lda #0	;tile_row
	sec
	sbc pos_row,x
	bmi skip
	cmp #4
	bcs skip

	; This sprite overlaps... time to draw it
	; get tile offset in reg Y
	
	asl
	asl
	; Carry is clear here
smc_row
	adc #0
	tay

	; Get the UDG number
	lda as_pointer_low,x
	sta smc_udgp+1	;tmp
	lda as_pointer_high,x
	sta	smc_udgp+2	;tmp tmp+1
smc_udgp
	lda $1234,y
	;lda (tmp),y
	beq skip	; If it is 0, then don't do anything

	; Good, now get the pointer to the graphic and mask, that is multiplying index by 8
#ifdef FULLTABLEMUL8
	tay
	lda tab_mul8hi,y
	sta tmp+1
	lda tab_mul8,y
#else
	ldy #0
	sty tmp+1	
	asl			
	rol tmp+1	
	asl			
	rol tmp+1	
	asl			
	rol tmp+1
#endif

	; If tiles are arranged smartly, we can do this...

	; Carry must be clear here
	sta graphic_p+1
	sta mask_p+1
	lda tmp+1
	adc tab_tiles,x
	sta graphic_p+2
	lda tmp+1
	adc tab_masks,x
	sta mask_p+2

cont
	; ... and copy it
	ldy #7
loopcopy
	lda backbuffer,y

#ifdef AIC_SUPPORT
	bpl ScreenNoInverse
	eor #63
ScreenNoInverse
#endif

mask_p
	and $1234,y
graphic_p
	ora $1234,y
	sta backbuffer,y
	dey
	bpl loopcopy

skip
	dex
	;bpl loop
	bmi end
	jmp loop
end
#ifndef AVOID_JSRS
	rts
#endif
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dumps the backbuffer onto the screen, using coordinates
; (vis_row,vis_col)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dump_buffer
.(
	; Setup pointer to screen row, 
	ldx vis_row				; 3
	ldy tab_mul8,x			; 4 (+1)
	lda _HiresAddrHigh,y    ; 4 (+1)    
	sta tmp+1				; 3
	lda _HiresAddrLow,y     ; 4 (+1)    
	clc						; 2
	adc vis_col				; 3
	sta tmp					; 3
	bcc skip				; 2/3
	inc tmp+1				; 5
skip
							;===============
							; 33/34 (+3)

	ldy #0					; 2
	lda backbuffer			; 4
	sta (tmp),y				; 5 (+1)
	ldy #40					
	lda backbuffer+1		
	sta (tmp),y				
	ldy #80
	lda backbuffer+2
	sta (tmp),y
	ldy #120
	lda backbuffer+3
	sta (tmp),y
	ldy #160
	lda backbuffer+4
	sta (tmp),y
	ldy #200
	lda backbuffer+5
	sta (tmp),y
	ldy #240
	lda backbuffer+6
	sta (tmp),y				; => 77 (+7)

	; Unfortunately, there is one scan left
	lda tmp					; 3
	clc						; 2
	adc #240				; 2
	bcc nocarry				; 2/3
	inc tmp+1				; 5
nocarry
	sta tmp					; 3

	ldy #40					; 2
	lda backbuffer+7		; 4
	sta (tmp),y				; 5 (+1)
							; =====================
							; 77+33/34+28/29= 138/140(+8)					

#ifdef AVOID_JSRS
	jmp return_draw_skool_tile
#else
	rts
#endif
.)









