;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Common routines

; A real random generator... 
randgen 
.(
   lda randseed     ; get old lsb of seed. 
   ora $308			; lsb of VIA T2L-L/T2C-L. 
   rol				; this is even, but the carry fixes this. 
   adc $304			; lsb of VIA TK-L/T1C-L.  This is taken mod 256. 
   sta randseed     ; random enough yet. 
   sbc randseed+1   ; minus the hsb of seed... 
   rol				; same comment than before.  Carry is fairly random. 
   sta randseed+1   ; we are set. 
   ;ldx randseed
   rts				; see you later alligator. 
.)


waitirq
.(
	lda using_vsync_hack
	beq soft_vsync

	lda $300
vsync_wait
	lda $30D
	and #%00010000 ;test du bit cb1 du registre d'indicateur d'IRQ
	beq vsync_wait
	rts

soft_vsync
	lda #0
	sta irq_detected
loop
	lda irq_detected
	beq loop
	rts
.)


_prepare_bottom_text_area
.(
	; Set blue paper attribute to all the area
	ldx #40*3-1
	lda #A_BGBLUE
looppaper
	sta $bf68,x
	dex
	bpl looppaper

	; Correct borders
	lda #A_BGBLACK
	sta $bf68
	sta $bf68+40
	sta $bf68+80
	sta $bf68+39
	sta $bf68+40+39
	sta $bf68+80+39
	
	; Set ink to cyan in the radar area
	lda #A_FWCYAN
	sta $bf68+RADAR_COL
	sta $bf68+RADAR_COL+40
	sta $bf68+RADAR_COL+80
	
	; Fill radar area with the characters,
	; starting at char 26+32=58.
	ldx #10
loopchars
	txa
	cmp #2+1
	bcc skip
	cmp #8
	bcs skip
	ora #%10000000
skip
	clc
	adc #32+26
	sta $bf68+RADAR_COL+1,x
	;clc
	adc #11
	sta $bf68+RADAR_COL+1+40,x
	;clc
	adc #11
	sta $bf68+RADAR_COL+1+80,x
	dex
	bpl loopchars
   
	/*
	*(char *)(0xbf68+26)=49;
	*(char *)(0xbf68+27)=50;
	*(char *)(0xbf68+28)=51;
	*(char *)(0xbf68+29)=52;
	*/
	rts

.)

_clear_bottom_text_area
.(
	; Set black paper attribute to all the area
	ldx #40*3-1
	lda #A_BGBLACK
looppaper
	sta $bf68,x
	dex
	bpl looppaper
	rts
.)

add40totmp
.(
	lda #40
	clc
	adc tmp
	sta tmp
	bcc nocarry
	inc tmp+1
nocarry
	rts
.)


clear_score_area
.(
	lda #<$a000
	sta tmp1
	lda #>$a000
	sta tmp1+1
	ldx #39
looprows
	ldy #39
	cpx #0
	bne notlast
	dey
notlast	
	lda #$40
loopcols
	sta (tmp1),y
	dey
	bpl loopcols
	
	lda tmp1
	clc
	adc #40
	bcc nocarry1
	inc tmp1+1
nocarry1
	sta tmp1
	
	dex 
	bpl looprows
	rts

.)

#define bwidth  tmp2
#define bheigth tmp2+1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copies a block with a given
; width and heigth
; from source in tmp0
; to dest in tmp1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
copy_block
.(
	ldx bheigth
	dex
looprows
	ldy bwidth
	dey
loopcols
	lda (tmp0),y
	sta (tmp1),y
	dey
	bpl loopcols

	lda tmp0
	clc
	adc bwidth
	bcc nocarry0
	inc tmp0+1
nocarry0
	sta tmp0
	
	lda tmp1
	clc
	adc #40
	bcc nocarry1
	inc tmp1+1
nocarry1
	sta tmp1
	
	dex 
	bpl looprows
	rts
.)


draw_scoreboard
.(
	jsr clear_score_area
	; Draw the game scoreboard
	lda #<$a000
	sta tmp1
	lda #>$a000
	sta tmp1+1
	lda #<inlay_graph
	sta tmp0
	lda #>inlay_graph
	sta tmp0+1
	
	lda #40
	sta bwidth
	sta bheigth
	jmp copy_block
.)	

draw_logo
.(
	jsr clear_score_area
	; Draw the game logo
	lda #<$a000+40*8+2
	sta tmp1
	lda #>$a000+40*8+2
	sta tmp1+1
	lda #<logo
	sta tmp0
	lda #>logo
	sta tmp0+1
	
	lda #36
	sta bwidth
	lda #32
	sta bheigth
	jmp copy_block
.)	

set_graphic_attributes
.(
	; Set a change to text attribute (A_TEXT50) and
	; change to hires (A_HIRES50) attribute at the correct places...
	; Set Hires 50Hz (don't know if this is necessary)
	;lda #A_HIRES50 
	;sta $bb80


	; Set text after the inlay
	lda #A_TEXT50 
	sta $a000+START_ROW*8*40-1
	
	; Set hires for the last three lines, so we can draw
	; graphics over the hires charsets too!
	lda #A_HIRES50 
	sta $bf68
	rts
.)

_prepare_play_area
.(
	jsr set_graphic_attributes
	
	;jsr draw_scoreboard
	;jsr draw_logo
+set_color
	; Now set the attributes for the play area.
	; Not only the ink color, but also the alternate
	; or standard charsets (which alternate).
	
	lda #<$bb80+START_ROW*40	
	sta tmp
	lda #>$bb80+START_ROW*40	
	sta tmp+1

	ldx #10
loopattr	
	ldy #0
	lda screen_color
	sta (tmp),y
	iny
	lda #A_STD 
	sta (tmp),y

	jsr add40totmp
	
	ldy #0
	lda screen_color
	sta (tmp),y
	iny
	lda #A_ALT
	sta (tmp),y
	
	jsr add40totmp
	
	dex
	bne loopattr
	
	; That's all folks!
	rts
.)

screen_color .byt A_FWCYAN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Adds A points to the player's score
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
add_score
.(
	sed
	clc
	adc score
	sta score
	bcc nocarry
	lda #0
	adc score+1
	sta score+1
	;bcc nocarry
	;adc score+2
	;sta score+2
nocarry
	cld
	jmp update_score
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Twilighte's code for printing texts...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.zero
screen  .word 00
.text

#ifdef DISPLAY_FRC
_init_print
.(
	lda #<($a000+26*40+9)
	sta screen
	lda #>($a000+26*40+9)
	sta screen+1
    rts  
.)
#endif

; Prints num in reg A (00-99)
printnum
.(
	stx savx+1
	sty savy+1
	pha
	;and #$f0
	lsr
	lsr
	lsr
	lsr
    jsr put_digit
	pla
	and #$0f
    jsr put_digit
savx
	ldx #0
savy
	ldy #0
	rts
.)

put_digit
.(
	ldx #0
	stx tmp+1
	asl
	rol tmp+1
	asl
	rol tmp+1
	asl
	rol tmp+1
	sta tmp

	ldx charset_in
	beq notin

	clc
	adc #<_std_charset+16*8
	sta tmp
	lda tmp+1
	adc #>_std_charset+16*8
	sta tmp+1
	jmp ready
notin	
	clc
    adc #<cs_numbers
	sta tmp
	lda tmp+1
	adc #>cs_numbers
	sta tmp+1
ready

	ldy #00
	lda (tmp),y
    ;ldy #00 
    sta (screen),y 
	ldy #01
    lda (tmp),y
    ldy #40 
    sta (screen),y 
	ldy #02
    lda (tmp),y
    ldy #80 
    sta (screen),y 
	ldy #03
    lda (tmp),y
    ldy #120 
    sta (screen),y 
   	ldy #04
    lda (tmp),y
    ldy #160 
    sta (screen),y 
	ldy #05
    lda (tmp),y
	ldy #200 
    sta (screen),y 
	ldy #06
    lda (tmp),y
	ldy #240 
    sta (screen),y 
		
	inc screen
	bne skip
	inc screen+1
skip
	rts 
.)

#ifdef OLDPUTCHAR
ascii2code 
        cmp #97 
.( 
        bcs skip1 
        cmp #65 
        bcs skip2 
        sbc #32 
        stx tmp 
        tax 
        lda punctuation_ascii,x ;31 Bytes 
        ldx tmp 
        rts 
skip1   sbc #97 
        rts 
skip2   sbc #39 
.) 
        rts 
punctuation_ascii 
 .byt 64,64,64,65,64,62,73,66,67,75,64,69,74,68,79,61 
 ;    !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0 
 .byt 52,53,54,55,56,57,58,59,60,71,70,77,76,78,63 
 ;    1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ? 



;Print character at next cursor position 
;A Character Code 
put_char 
        cmp #32 
        beq put_space
.(
        jsr ascii2code 
        jsr put_char_direct 
.)
increment_cursor 
.(
        inc screen 
        bne skipme 
        inc screen+1 
+skipme   
        rts 
.)


put_space 
.(
        lda #64 
.)
place_char 
        jsr ascii2code 
put_char_direct 
        tax     ;char_number 
        lda character_bitmap_row0,x 
        ldy #00 
        sta (screen),y 
        lda character_bitmap_row1,x 
        ldy #40 
        sta (screen),y 
        lda character_bitmap_row2,x 
        ldy #80 
        sta (screen),y 
        lda character_bitmap_row3,x 
        ldy #120 
        sta (screen),y 
        lda character_bitmap_row4,x 
        ldy #160 
        sta (screen),y 
        rts 

/*
;73 Characters + 7 for special chars (Not defined yet) [CHEMA: 73=', 74=-, 
;75=space (for deleting), 76==, 77=<-, 78=->, 79=/]
;80 Characters == 400($190) Bytes 
*/

character_bitmap_row0   ;80 Bytes 
    .byt $40,$70,$40,$46,$40,$5c,$7e,$70,$58,$4c,$58,$58,$40,$40,$40,$40 
    .byt $40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$7e,$7e,$7e,($7e & %11111100),$7e,$7e 
    .byt $7e,$72,$5c,$5c,$72,$5c,$7e,$7e,($7e & %11011111),$7e,$7e,$7e,$7e,$7e,$72,$72 
    .byt $6a,$72,$72,$7e,$7c,$7e,$7e,$7c,$7e,$7e,$7e,$7e,$7e,$7e,$58,$7e 
    .byt $5c,$7e,$5c,$5c,$40,$40,$40,$40,$5f,$4c,$40,$40,$40,%01001000,%01000100,%01000010 
character_bitmap_row1   ;80 Bytes 
    .byt $5e,$7e,$5e,$7e,$5e,$50,$72,$7e,$40,$40,$5a,$58,$76,$7e,$5e,$7e 
    .byt $7e,$7e,$5e,$7e,$72,$72,$6a,$72,$72,$7e,$66,$72,$66,$66,$70,$70 
    .byt $60,$72,$5c,$5c,$72,$5c,$7e,$66,$72,$72,$72,$72,$70,$5c,$72,$72 
    .byt $6a,$72,$72,$74,$5c,$42,$66,$6c,$60,$60,$66,$72,$72,$72,$72,$72 
    .byt $5c,$68,$58,$4c,$40,$40,$4c,$4c,$53,$46,$40,$40,$7e,%01011111,%01111110,%01000110
character_bitmap_row2   ;80 Bytes 
    .byt $66,$66,$66,$66,$66,$7e,$7e,$66,$58,$4c,$5c,$58,$7e,$66,$72,$72 
    .byt $72,$70,$78,$5c,$72,$72,$6a,$5e,$72,$6c,$7e,$7e,$60,$66,$7e,$7e 
    .byt $6e,$7e,$5c,$5c,$7c,$5c,$6a,$66,$72,$72,$72,$7c,$7e,$5c,$72,$72 
    .byt $6a,$5c,$7e,$48,$5c,$7e,$5e,$6c,$7e,$7e,$4c,$7e,$7e,$72,$5e,$4e 
    .byt $48,$7e,$58,$4c,$40,$40,$40,$40,$7c,$40,$7e,$40,$40,%01111111,%01111111,%01001100 
character_bitmap_row3   ;80 Bytes 
    .byt $66,$66,$60,$66,$78,$5c,$46,$66,$58,$4c,$56,$58,$6a,$66,$72,$7e 
    .byt $7e,$70,$4e,$5c,$72,$5c,$7e,$7c,$7e,$5a,$66,$72,$66,$66,$70,$70 
    .byt $66,$72,$5c,$5c,$66,$5c,$6a,$66,$72,$7e,$72,$66,$46,$5c,$72,$5c 
    .byt $7e,$66,$5c,$56,$5c,$70,$66,$7e,$46,$66,$4c,$66,$46,$72,$72,$40 
    .byt $40,$4a,$58,$4c,$4c,$4c,$4c,$4c,$53,$40,$40,$40,$7e,%01011111,%01111110,%01011000
character_bitmap_row4   ;80 Bytes 
    .byt $7f,$7e,$7e,$7e,$7e,$5c,$7e,$66,$58,$5c,$56,$58,$6a,$66,$7e,$70 
    .byt $46,$70,$7c,$5c,$7e,$48,$5c,$66,$46,$7e,$66,$7e,$7e,$7e,$7e,$70 
    .byt $7e,$72,$5c,$7c,$66,$5e,$6a,$66,$7e,$70,$7f,$66,$7e,$5c,$7e,$48 
    .byt $5c,$66,$5c,$7e,$5c,$7e,$7e,$4c,$7e,$7e,$58,$7e,$7e,$7e,$7e,$4c 
    .byt $48,$7e,$5c,$5c,$4c,$46,$46,$40,$5f,$40,$40,$40,$40,%01001000,%01000100,%01010000
	
#endif	