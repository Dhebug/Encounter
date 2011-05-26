;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Routines to handle text printing
;; ---------------------------------


#include "params.h"

/*
text_row .byt 00
text_col .byt 00
cur_char .byt 00
pat		 .byt 00

print_string
.(
	; Preserve registers
	stx savX+1
	sty savY+1

	lda tmp0
	sta smc_pstring+1
	lda tmp0+1
	sta smc_pstring+2
	lda #0
	sta cur_char
	lda #%00100000
	sta pat


	ldx text_row
	ldy tab_mul8,x			; 4 (+1)
	lda _HiresAddrHigh,y    ; 4 (+1)    
	sta tmp0+1				; 3
	lda _HiresAddrLow,y     ; 4 (+1)    
	clc						; 2
	adc text_col			; 3
	sta tmp0					; 3
	bcc skip				; 2/3
	inc tmp0+1				; 5
skip
							;===============
							; 33/34 (+3)

loop_st
	; Get the next character in string
	ldy cur_char
smc_pstring
	lda $1234,y
	beq end_st	; if it is 0, we have finished

	jsr print_char

	inc cur_char
	bne	loop_st	 ; Always jumps
end_st

savX
	ldx #0
savY
	ldy #0

	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Print a character (reg A) at the current position
; indicated by tmp0 and pat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
col_now	 .byt 00
ch_count	 .byt 00

print_char
.(
	; Preserve registers
	stx savX+1
	sty savY+1

  	sec
	sbc #32
	tax

	lda char_widths,x
	sta ch_count

	lda #<charset_col1
	sta loop_char+1
	lda #>charset_col1
	sta loop_char+2

loop_char
	lda charset_col1,x
	sta col_now

	lda tmp0
	sta tmp
	lda tmp0+1
	sta tmp+1

	; Print the pixels for this column
	stx savx+1
	ldx #8
	ldy #0
loop_col
 	asl col_now
	bcc noprint1
	lda (tmp),y
	ora pat
	sta (tmp),y
noprint1
	lda tmp
	clc
	adc #40
	sta tmp
	bcc nocarry
	inc tmp+1
nocarry
	dex
	bne loop_col
 
	; Advance one column
	; Decrement the column counter
	dec ch_count
	beq end_char

	; simply rotate the pattern to the right
	jsr st_new_column

	; Prepare pointer to the next column
	; as char bitmaps rely on different pages, it is enough 
	; to increment this...

	inc loop_char+2
savx 
	ldx #0
	jmp loop_char
end_char

	; We have finished with this character
	; now get the next one in the string
	; but first, put a blank column
	jsr st_new_column
	jsr st_new_column

savX
	ldx #0
savY
	ldy #0
	rts
.)

st_new_column
.(
	lsr pat
	bne notnewscan
	; If it becomes zero, advance the basic pointer
	inc tmp0
	bne skip2
	inc tmp0+1
skip2
	lda #%00100000
	sta pat
notnewscan
	rts
.)

*/


ch_count	 .byt 00


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Used by the s_isc_speak1 routine. Returns 
; with the carry flag set if the character 
; about to speak is off-screen. Returns with
; the zero flag reset if somebody else is 
; speaking at the moment.
; The character is passed on reg x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_speech_bubble
.(
	; Check if the character is on-screen
	lda pos_col,x
	;clc
	;adc #1	; First column does not matter
	sec
	sbc first_col
	bcs maybe1
	sec
returnme
	rts
maybe1
	cmp #VISIBLE_COLS+1	; Last one either
	bcs returnme
	; The character is onscreen

	lda bubble_on
	bne returnme

	; Noone is speaking so let's do it

	inc bubble_on

	; Get spot's above character's head

	lda pos_col,x
	sec
	sbc first_col
	sta smc_colcorr+1
	tay
	iny
	cpy #FIRST_VIS_COL
	bcs okcol
	iny
okcol
	cpy #LAST_VIS_COL+1
	bcc	okcolm
	dey
okcolm
	sty bubble_lip_col
	ldy pos_row,x
	dey
	cpx #CHAR_EINSTEIN
	bne nodec
	iny
nodec
	sty bubble_lip_row
	
	; Calculate the position of the speech bubble
	dey
	dey
	sty bubble_row
smc_colcorr
	lda #0 
	and #%11111000	; At the border of 8-tile chunks
	clc
	adc #FIRST_VIS_COL	; Protecting the first two
	cmp #LAST_VIS_COL-8	; And the last two
	bcc nothing
	sec
	sbc #4
nothing
	sta bubble_col

	stx savx+1		; Save register X

	; Calculate the pointer
	ldx bubble_row
	ldy tab_mul8,x			
	lda _HiresAddrHigh,y    
	sta tmp+1				
	lda _HiresAddrLow,y 
	clc						
	adc bubble_col
	sta tmp					
	bcc skip				
	inc tmp+1				
skip
	sta bubble_loc_p		; Store it here for future reference
	lda tmp+1
	sta bubble_loc_p+1


	; Dump the bubble
.(
	lda #<speech_bubble
	sta loop+1
	lda #>speech_bubble
	sta loop+2

	ldx #16
loopr
	ldy #7
loop
	lda speech_bubble,y
	sta (tmp),y
	dey
	bpl loop

	dex
	beq endl
	
	lda loop+1
	clc
	adc #8
	sta loop+1
	bcc nocarry1
	inc loop+2
nocarry1
	lda tmp
	clc
	adc #40
	sta tmp
	bcc nocarry2
	inc tmp+1
nocarry2
	jmp loopr
endl
.)

; Now the bubble lip
.(
	; Calculate the pointer
	ldx bubble_lip_row
	ldy tab_mul8,x			
	lda _HiresAddrHigh,y    
	sta tmp+1				
	lda _HiresAddrLow,y 
	clc						
	adc bubble_lip_col
	sta tmp					
	bcc skip2				
	inc tmp+1				
skip2
  
	; Open the bubble!
	lda tmp
	sec
	sbc #40
	sta smc_olip+1
	lda tmp+1
	sbc #0
	sta smc_olip+2
	lda #%01100001
smc_olip
	sta $1234

	ldx #0
	ldy #0
loop
	lda speech_bubble_lip,x
	sta (tmp),y
	cpx #7 
	beq endl
	inx
	lda tmp
	clc
	adc #40
	sta tmp
	bcc nocarry2
	inc tmp+1
nocarry2
	jmp loop
endl

.)

savx
	ldx #0	; Restore reg X

	jsr bitmask_bubble

	clc
	lda #0
	rts		; Return with zero set and carry clear indicating success
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get bitmasks for the bubble+lip
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bitmask_bubble
.(
  	stx savx+1		; Preserve reg x
	lda bubble_row
	asl
	asl
	adc bubble_row
	sta tmp
	lda bubble_col
	lsr
	lsr
	lsr
	clc
	adc tmp
	sta srb_offset

	lda bubble_col
	and #%111
	tax
	ldy #8
	lda #0
	sta srb_bitmask
loop
	ora tab_bit8,x
	inx
	cpx #8
	bne nonbyte
	sta srb_bitmask
	ldx #0
	txa
nonbyte	
	dey
	bne loop
	
	ldx srb_bitmask
	bne set2
	sta srb_bitmask
	lda #0
set2
	eor #$ff
	sta srb_bitmask2
	lda srb_bitmask
	eor #$ff
	sta srb_bitmask

	; Now the bitmap lip
	lda bubble_lip_row
	asl
	asl
	adc bubble_lip_row
	sta tmp

	lda bubble_lip_col
	lsr
	lsr
	lsr
	clc
	adc tmp
	sta srb_offset_lip

	lda bubble_lip_col
	and #%111
	tax
	lda tab_bit8,x
	eor #$ff
	sta srb_bitmask_lip

savx
	ldx #0
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Used by the s_isc_speak2 routine. Removes the
; speech bubble if any.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
remove_speech_bubble
.(
	lda bubble_on
	bne cont
	rts
cont
	dec bubble_on	; Indicate no-one is speaking

	; Update the SRB
	ldy srb_offset
	lda srb_bitmask
	eor #$ff
	sta SRB,y
	sta SRB+5,y
	lda srb_bitmask2
	eor #$ff
	sta SRB+1,y
	sta SRB+6,y
	ldy srb_offset_lip
	lda srb_bitmask_lip
	eor #$ff
	sta SRB,y
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Slide a message character into the 
; speech bubble text window
; Returns with the carry flag set if we are 
; finished
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

slide_char_bubble
.(
	jsr get_next_char
	bne notzero
retc
	sec
	rts
notzero
	ldy bubble_on
	beq retc

	; The speech bubble is onscreen
	; Save register X
	stx savx+1

	; Get the character's width
  	sec
	sbc #32
	tax

	; As char bitmaps rely on different pages, it is enough 
	; to update this...

	lda #>charset_col1
	sta smc_pcol+2

	lda char_widths,x
	sta ch_count

	lda bubble_loc_p
	clc
	adc #160
	sta smc_initp+1
	lda bubble_loc_p+1
	adc #0
	sta smc_initp2+1
	
loop_char
	; Scroll the message one pixel

smc_initp
	lda #0
	sta tmp1
smc_initp2
	lda #0
	sta tmp1+1
	
	;lda #8
	;sta tmp

smc_pcol
	lda charset_col1,x
	jsr slide_col_bubble

	; Prepare pointer to the next column
	; as char bitmaps rely on different pages, it is enough 
	; to increment this...
	inc smc_pcol+2

	dec ch_count
	bne loop_char

	; Add one blank column
	lda smc_initp+1
	sta tmp1
	lda smc_initp2+1
	sta tmp1+1


	lda #0
	jsr slide_col_bubble

savx
	ldx #0

	clc
	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Slide a pixel column into a speech
; bubble (this is to save a little
; memory).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
slide_col_bubble
.(
	sta tmp+1
	lda #8
	sta tmp

loop_s_col
	asl tmp+1
	ldy #6
loop_s_row
	lda (tmp1),y
	rol
	cmp #192
	and #%00111111
	ora #%01000000
	sta (tmp1),y
	dey
	bne loop_s_row

	lda tmp1
	clc
	adc #40
	sta tmp1
	bcc nocarry1
	inc tmp1+1
nocarry1

	dec tmp
	bne loop_s_col
	
	rts

.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get the next character of a message being 
; spoken or written. Used by the routines at
; 28994 and 29706. Returns with the next 
; character in A 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_next_char
.(
	; TODO -- THIS IS INCOMPLETE!!!
	; Check if we are in a submessage at this moment
	lda var6,x
	beq notsubm

	; We are inside a submessage
	sta smc_pchars+2
	lda var5,x
	sta smc_pchars+1

smc_pchars
	lda $1234	; Get next character
	beq endsubm	; If we have finished...

process_subm
	; Advance the pointer
	inc var5,x
	bne nocarry
	inc var6,x
nocarry
	rts

endsubm
	; Put zero in the pointer
	sta var5,x
	sta var6,x
	; And continue with the main message
notsubm
	lda var3,x
	sta smc_pchar+1
	lda var4,x
	sta smc_pchar+2

	; Move to the next character
	inc var3,x
	bne nocarry2
	inc var4,x
nocarry2

smc_pchar
	lda $1234	; Get char	
	beq end		; If it is zero, just return
	
	; Check if it is a token (>=128)
	; which refers to an entry in one of 
	; the symbol/element, capital city/country 
	; and date/battle question-and-answer pairs
	
	bpl nottoken
	and #127
	; Look up the pointer in the question/answer tables
	; Store it in the var5/var6 pair and jump back to the
	; submessage processing (getting in A the first char)
	jmp process_subm

nottoken
	; The character is <128, but is it >=32?
	cmp #31
	bcc token2 ; return if it is a normal character
	
	; The original version uses codes <16 (2 and 3) 
	; for representing 1 or 8 spaces. They are returned
	; from here and processed by the caller.
	; I think I will change this behaviour and use a kind of
	; token table for all...
end
	rts	
	
token2
	; Look up the pointer in the names/extras table.
	; Store it in the var5/var6 pair and jump back to the
	; submessage processing (getting in A the first char)
	sec
	sbc #3	; Get entry in the table
	ldy #<names_extras
	sty tmp0
	ldy #>names_extras
	sty tmp0+1

search_submessage
	jsr search_string
	lda tmp0
	sta var5,x
	lda tmp0+1
	sta var6,x
	ldy #0
	lda (tmp0),y
	jmp process_subm
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write a line of text into a graphic buffer
; and center it.
; The buffer address is stored in tmp1, and
; the line of text in tmp0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

write_text
.(
	stx savx+1	; preserve reg x

	; First clear the buffer line
	lda #$40
	ldy #BUFFER_TEXT_WIDTH*8-1
loop
	sta (tmp1),y
	dey
	bpl loop

	lda #BUFFER_TEXT_WIDTH*6
	sta tmp2		; Number of pixel columns available

	ldy #0
loopw
	lda (tmp0),y
	beq endw
	
	sty savy+1

	; Get character code
	sec
	sbc #32
	tax

	lda #>charset_col1
	sta smc_pcol+2

	; Get width
	lda char_widths,x
	sta ch_count

loop_char
smc_pcol
	lda charset_col1,x
	jsr slide_col	

	; Prepare pointer to the next column
	inc smc_pcol+2
	dec tmp2

	dec ch_count
	bne loop_char

	; Insert a space
	lda #0
	jsr slide_col
	dec tmp2	

savy
	ldy #0
	iny

	jmp loopw

endw
	; Now center the message
	; See how many columns we have left
	lda tmp2
	; Divide it by 2
	lsr
	beq savx	; If we used them all, then do nothing

	tax
loopc
	lda #0
	jsr slide_col
	dex 
	bpl loopc

savx
	ldx #0
	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Slide a column of pixel bits passed in reg
; a into the buffer pointed by tmp1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

slide_col
.(
	; Save pixel col
	sta tmp+1

	; Save the value of tmp1, 
	; so we don't alter it.
	lda tmp1
	pha
	lda tmp1+1
	pha

	; There are eigth pixels in a column
	lda #8
	sta tmp

loop_s_col
	; Get he pixel value into the carry
	asl tmp+1

	; scroll the whole line
	; inserting the new value from the carry

	ldy #BUFFER_TEXT_WIDTH-1
loop_s_row
	lda (tmp1),y
	rol
	cmp #192
	and #%00111111
	ora #%01000000
	sta (tmp1),y
	dey
	bpl loop_s_row

	; Point to the next line in the buffer
	lda tmp1
	clc
	adc #BUFFER_TEXT_WIDTH
	sta tmp1
	bcc nocarry1
	inc tmp1+1
nocarry1

	; Did we work out all the pixel columns?
	dec tmp
	bne loop_s_col

	; Recover tmp1 to old value
	pla
	sta tmp1+1
	pla
	sta tmp1
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dumps a text buffer, pointed by tmp0
; onto the screen at position pointed
; by tmp1.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dump_text_buffer
.(
	stx savx+1	; Preserve register x
	
	ldx #8*3
looprows
	ldy #BUFFER_TEXT_WIDTH-1									
loopscans
	lda (tmp0),y
	sta (tmp1),y
	dey
	bpl loopscans

	lda tmp0
	clc
	adc #BUFFER_TEXT_WIDTH
	sta tmp0
	bcc nocarry
	inc tmp0+1
nocarry

	lda tmp1
	clc
	adc #40
	sta tmp1
	bcc nocarry2
	inc tmp1+1
nocarry2
	dex
	bne looprows

savx
	ldx #0
	rts
.)






