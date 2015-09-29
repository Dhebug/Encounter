;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Code to handle level changes, intros
; etc.

#define BASE_STR_READY		2		
#define BASE_STR_PHASES 	4
#define BASE_STR_DESC		12
#define BASE_STR_LEVELCLR	25
#define BASE_STR_KEYRED		28

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set color for this level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
color_tab
	;.byt A_FWGREEN, A_FWRED, A_BGBLUE, A_FWMAGENTA, A_FWWHITE, A_FWYELLOW, A_BGBLUE, A_FWGREEN
	.byt A_FWGREEN, /*A_FWRED*/ A_FWWHITE, A_FWWHITE, A_FWYELLOW

color_level
.(
	lda onslaught
	bne normal
	lda last_seed
	cmp #180
	bcs normal
	and #%011
	tax
	lda color_tab,x
	bne color
normal
	lda #A_FWCYAN
color
	sta screen_color
	jmp set_color
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set switch codes for this level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; These tables contain the information
; aboyt how switches work

; Levels at which different entries are
; used.
tab_level_switchcodes .byt 0, 5, 17, 50

; EOR codes for each switch
tab_switch_eor
	.byt %1000, %0100, %0010, %0001
	.byt %1100, %0110, %0001, %1000
	.byt %1000, %0100, %0010, %0001
	.byt %1000, %0100, %0010, %1001

; AND codes for each switch	
tab_switch_and
	.byt $ff, $ff, $ff, $ff
	.byt $ff, $ff, $ff, $ff
	.byt %1011, %1101, %1110, %1111
	.byt %1011, %0111, %1110, %1111

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set up the AND and EOR codes
; for the switches depending on the
; current level. These codes are to
; be put in the switch_eor_codes
; and switch_and_codes tables.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
switch_codes_level
.(
	lda level
	ldx #3
loop
	cmp tab_level_switchcodes,x
	bcs found
	dex
	bpl loop
	; Cannot arrive here!
found
	; Multiply by 4 to get the correct entry in the tables
	txa
	asl
	asl
	tax
	ldy #0
loopc
	lda tab_switch_eor,x
	sta switch_eor_codes,y
	lda tab_switch_and,x
	sta switch_and_codes,y
	inx
	iny
	cpy #4
	bne loopc
	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;
; Directly go to level
; passed in reg A
; A<=128
;;;;;;;;;;;;;;;;;;;;;;
	
goto_level
.(
	tay
	jsr init_levels
loop	
	jsr set_next_level
	dey
	bpl loop

	;jsr update_level
	jmp generate_ship

.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize variables
; and procedural generator
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
init_levels
.(
	lda #0
	sta level
	sta ship_destruction_bonus
	
	lda #A_FWCYAN
	sta screen_color
	
	; Initialize the procedural generator
	ldx #3
loopi
	lda start_seed_r1,x
	sta last_seed,x
	dex
	bpl loopi

	; Put back original decorations
	lda swapflags
	lsr
	bcc skip
	jsr swap_bchain
skip	
	lda swapflags+1
	lsr
	bcc skip2
	jsr swap_schain
skip2
	lda swapflags+2
	lsr
	bcc skip3
	jsr swap_mchain
skip3
	lda swapflags+3
	lsr
	bcc skip4
	jsr swap_windows
skip4
	
	; Initialize decoration flags
+initialize_flags
	ldx #3
	lda #0
.(
loop	
	sta swapflags,x
	dex
	bpl loop
.)
	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Advance one level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_next_level
.(
	; At certain levels, there is one
	; bonus screen!
	lda #0
	sta onslaught
	sta labyrinth_mode
	sta boss_mode
	
	lda level
	cmp #LAST_LEVEL
	bne continue
	inc boss_mode
	bne notbonus ; jumps always
continue	
	and #%111
	cmp #%010
	bne notlab
	inc labyrinth_mode
	bne notbonus ;jumps always
notlab	
	cmp #%111
	bne notbonus
	inc onslaught
	lda #0
	sta total_enemies
notbonus	
	; Get back the saved seed
.(	
    ldx #3
loop
    lda last_seed,x
    sta seed_r1,x
    dex
    bpl loop
.)	
	; Increment level
	inc level
	
	; Waggle the generator
	jsr waggle
	jsr waggle
	
	; Save the current seed
.(
    ldx #3
loop
    lda seed_r1,x
    sta last_seed,x
    dex
    bpl loop
.)
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Common part before displaying
; text screens.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
common_text
.(
	; Prepare everything
	lda #A_FWCYAN
	sta screen_color
	jsr set_color

	jsr waitirq ; Try to avoid ugly effects

	jsr swap_charsets
+common_text_ext	
	jsr _clear_backbuffer
	jmp _dump_backbuffer
.)


; Tables with level info for
; descriptions

; Phase descriptions: max level considered as:
; tutorial, piece of cake, average, challenging, lethal, mayhem or Elite
tab_levels
	.byt LEV_TUTORIAL, LEV_CAKE, LEV_AVERAGE, LEV_CHALLENGING, LEV_LETHAL, LEV_MAYHEM

; Table of levels where strings with different messages are shown
tab_desc
	;.byt 1,2,4,5,6,10,15,20,25,30,40,70,99
	 .byt 1,2,4,5,6,10,15,17,25,29,30,35,41

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Shows the introduction screen
; for this level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
introduce_level
.(
	jsr common_text
	
	jsr init_panel
	
	; Print the 'Get Ready' message
	ldy #7
	lda #BASE_STR_READY
	jsr print_string_centered

	;ldy #10
	;jsr pause
	
.(
	; Print the phase information
	lda level
	ldx #6
loop
	cmp tab_levels-1,x
	bcs found
	dex
	bne loop
found
	; Base string for phases is 4
	txa
	clc
	adc #BASE_STR_PHASES

	ldy #7+2
	;ldx #10+3
	jsr print_string_centered
.)
	;ldy #10
	;jsr pause

.(
	; Print the intro for this level, if any
	; TODO: Optimize this in size!!!
	lda boss_mode
	beq noboss
	lda #85
	bne desc_level ; Jumps always
noboss	
	lda labyrinth_mode
	beq notlab
	lda #64
	bne desc_level ; Jumps always
notlab	
	lda onslaught
	beq normallevel
	lda #63
	bne desc_level ; Jumps always
normallevel	
	
	lda level
	ldx #13
loop
	cmp tab_desc-1,x
	beq found
	dex
	bne loop
	; Not found
	beq noinfo
found
	; Add base number for description strings
	txa
	clc
	adc #BASE_STR_DESC-1
desc_level		
	ldy #7+6
	jsr print_string_centered
	ldy #20
	jsr pause
.)	
noinfo
	; Print the 'Press Key' message
	ldy #7+6+2
	lda #3
	jsr print_string_centered
	;ldy #10
	;jsr pause
	jmp common_end_text

.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prints the screen for level 
; cleared.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end_level_screen
.(
	jsr common_text

	; Print Well done message
	ldy #7
	lda #BASE_STR_LEVELCLR
	jsr print_string_centered
	

	; If bonus level, no destruction bonus
	; TODO: Can't be done here, as they have been cleared
	; already
	lda onslaught
	ora labyrinth_mode
	ora boss_mode
	bne dest_bonus_finished
	
	; Print ship destruction bonus
	ldy #9
	lda #BASE_STR_LEVELCLR+1
	jsr print_string_centered
	
	; Set counter 
	
	;lda #101
	;sta $bb80+40*10+17
	lda #102
	sta $bb80+40*10+17+1
	lda #103
	sta $bb80+40*10+17+2
	lda #104
	sta $bb80+40*10+17+3
	
	jsr _contador_init
	lda #0
	sta ncon
loopcountinit
	jsr _contador_up
	lda ncon
	bne loopcountinit

dbug	
	
	;TODO: Fix this so it works better
	lda ship_destruction_bonus

	; Get high nibble, so it is a digit.
	lsr
	lsr
	lsr
	lsr
	adc #0 ; This sets A=x+1 if greater than x8
	sta savA+1

	ldy #0
	sty carryA+1
	rol carryA+1 ; Save carry for later
	
	; Multiply by 10 for bonus counter
	asl
	sta tmp
	asl
	asl
	clc
	adc tmp
	
	sta ncon
loopo	
	ldx #2
loopwx
	ldy #0
loopwy
	dey
	bne loopwy
	dex
	bne loopwx
	jsr _contador_up
	lda ncon
	bne loopo

	; Add ship destruction bonus
	ldy #11
	ldx #16
	jsr gotoxy
	lda savA+1
	;jsr printnum
	ldy #50
	jsr pause
savA
	lda #0
	sed
	clc
	adc score
	sta score
	bcc nocarry
carryA	
	lda #0
	adc score+1
	sta score+1
	;bcc nocarry
	;adc score+2
	;sta score+2
nocarry
	cld

	jsr update_score
	
	; Ship destruction bonus finished
dest_bonus_finished	
	; Passcode
	jsr generate_passcode

	
	ldy #15
	lda #53
	jsr print_string_centered
	
	ldy #19
	lda #BASE_STR_LEVELCLR+2
	jsr print_string_centered

	; A small pause
	ldy #10
	jsr pause
	
	; Common finishing of text screens
	jmp common_end_text
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper routine to make 
; a pause. Y=IRQs to wait
;;;;;;;;;;;;;;;;;;;;;;;;;;
pause
.(
loop
	jsr waitirq
	dey
	bne loop
	rts
.)	

;;;;;;;;;;;;;;;;;;;;;;;
; Prints the game over
; screen.
;;;;;;;;;;;;;;;;;;;;;;;
game_over
.(
	lda #<__Stay_start
	sta tmp
	lda #>__Stay_start
	sta tmp+1
	jsr PlayMySong

	jsr common_text
	
	; Print the 'Game Over' message
	lda #11
	ldy #13
	jsr print_string_centered
	lda passcode_valid
	beq nocont
	ldy #50
	jsr pause
	lda #73
	ldy #13+2
	jsr print_string_centered
nocont	
	jsr _WaitKey
	
	lda passcode_valid
	beq over
	cpx #"R"
	bne over
	jsr common_text_ext
	jmp decode_passcode_data
over	
	jsr test_hi_score
	jmp common_end_text_nokey
.)

;;;;;;;;;;;;;;;;;;;;;;;;;
; Common code at the
; end of text screens
;;;;;;;;;;;;;;;;;;;;;;;;;
common_end_text
.(
	jsr _WaitKey
+common_end_text_nokey	
	jsr _dump_backbuffer
	jmp swap_charsets
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display intro text until
; keypress
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
do_intro
.(
	lda #<intro_text
	sta tmp
	lda #>intro_text
	sta tmp+1
	jsr draw_intro_text
	lda #70
	jsr TimedWaitKey
	jmp common_text_ext
.)

do_instructions
.(	
	;ldy #20
	;jsr pause
	lda #<intro_textb
	sta tmp
	lda #>intro_textb
	sta tmp+1
	jsr draw_intro_text
	lda #100
	jmp TimedWaitKey
	;rts
.)

draw_intro_text
.(
	ldx #2
	ldy #6
	jsr gotoxy
+draw_intro_text_ex
loop1
	ldy #0
	;sty oldKey
	lda (tmp),y
	beq end
	jsr putchar
	inc tmp
	bne nocarry
	inc tmp+1
nocarry
	jsr waitirq
	;jsr ReadKeyboard
	;jsr _ReadKeyNoBounce
	;beq loop1
	jmp loop1
end	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper to wait for a keypress
; but with a time limit
; passed in Reg A as number of
; IRQs x 5 (10 means one second)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
waittmp .byt 0
TimedWaitKey
.(
	sta waittmp
loop
	; Wait 10 IRQs
	ldy #5
	jsr pause
	jsr ReadKeyboard
	jsr _ReadKey
	bne keypress
	dec waittmp
	bne loop
	; Timeout: Z is zero
	; keypress Z is not zero and X holds the ASCII value
keypress	
	rts
.)


display_credits
.(
	ldx #2
	ldy #11
	jsr gotoxy
	lda #<credits_text
	sta tmp
	lda #>credits_text
	sta tmp+1
	jsr draw_intro_text_ex

	lda #50
	jsr TimedWaitKey
	jmp common_text_ext	
	;rts
.)

#define TEMP_CHARS 97


display_powerups
.(
	jsr common_text_ext

	; Draw the powerups onto tiles...
	lda #<_item_stick
	sta tmp1
	lda #>_item_stick
	sta tmp1+1
	
	ldx #TEMP_CHARS
	lda tab_mul8_lo,x
	sta tmp2
	lda #$b4
	clc
	adc tab_mul8_hi,x
	sta tmp2+1
	
	ldy #0
loopcopy
	lda (tmp1),y
	sta (tmp2),y
	iny
	cpy #8*20
	bne loopcopy

	; Setup screen
	
	ldy #8
	lda #56
	jsr print_string_centered
	ldy #9
	lda #56
	jsr print_string_centered

	
	ldx #10
	ldy #11
	jsr gotoxy
	
	lda screen
	sta tmp2
	lda screen+1
	sta tmp2+1
	lda #TEMP_CHARS
	sta tmp1
	
	ldx #0
.(	
loopdrawpu
	ldy #0
	lda #A_STD
	sta (tmp2),y
	
	txa
	sta tmp1+1
	lsr
	clc
	adc #1
	iny
	sta (tmp2),y
	
	lda tmp1
	iny
	sta (tmp2),y
	inc tmp1
	iny
	lda tmp1
	sta (tmp2),y
	inc tmp1
	
	clc
	lda tmp2
	adc #8
	sta screen
	lda tmp2+1
	adc #0
	sta screen+1
	txa
	lsr
	bcs skip
	stx savx+1
	adc #57 ;Base powerup descriptions
	jsr search_string
	jsr puts
savx
	ldx #0
skip	
	
	lda tmp2
	clc
	adc #40
	sta tmp2
	bcc nocarry
	inc tmp2+1
nocarry
	inx
	cpx #10
	bne loopdrawpu
.)
	
	ldx #2
	ldy #22
	lda #62
	jsr print_string
	
	; Wait for keypress or timeout
	lda #70
	jsr TimedWaitKey
	jmp common_text_ext	
	;rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display current keys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ascii values of currently user keys
; UP,DOWN,LEFT,RIGHT,FIRE,JUMP,PAUSE in reverse order
user_keys
	.byt 10,7,32,4,2,3,1 
	
display_keys
.(
	jsr common_text_ext

	ldy #8
	lda #86
	jsr print_string_centered
	ldy #9
	lda #86
	jsr print_string_centered
	
	ldy #9
	sty row_temp

	lda #BASE_STR_KEYRED-1
	sta i_temp

	ldy #NUM_KEYS-1
loop
	sty savy+1
	inc row_temp
	inc row_temp
	inc i_temp
	
	ldy row_temp
	lda i_temp
	ldx #12
	jsr print_string

	ldy row_temp
	ldx savy+1
	lda user_keys,x
	ldx #22+2	
	jsr display_user_key
savy
	ldy #0
	dey
	bpl loop

	; Wait for keypress or timeout
	lda #70
	jsr TimedWaitKey
	jmp common_text_ext		
.)

/*
display_objectives
.(
	jsr common_text_ext

	lda #11
	sta tmp3+1
	lda #73
	sta tmp3
loop
	ldy tmp3+1
	jsr print_string_centered
	inc tmp3
	inc tmp3+1
	lda tmp3
	cmp #76
	bcc loop
	
	; Wait for keypress or timeout
	lda #70
	jsr TimedWaitKey
	jmp common_text_ext	

.)
*/
#define FIRST_NAME 80

; Hall of fame: Levels and scores (in BCD and divided by 10, an extra zero is added)
hall_of_fame_level  .byt 20, 15, 10, 5, 2
hall_of_fame_scorel .byt $00, $00, $00, $00, $20
hall_of_fame_scoreh .byt $07, $05, $04, $02, $00

; Hall of fame: string numbers where names are stored
hall_of_fame_name   .byt FIRST_NAME, FIRST_NAME+1, FIRST_NAME+2, FIRST_NAME+3, FIRST_NAME+4

; Hall of fame: colors for each entry
hall_of_fame_colors .byt A_FWCYAN,A_FWYELLOW,A_FWGREEN, A_FWMAGENTA, A_FWRED


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if we made a hi-score!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
test_hi_score
.(
	jsr common_text_ext

	; Check if we made a hi-score
	; loop through the entries, searching for 
	; the first who has:
	; a/ a level less than or equal to ours
	; b/ a score less than or equal to ours
	ldx #0	; Check all entries
loopsearch
	lda level
	cmp hall_of_fame_level,x
	bcc next_entry
	beq check_score
	bcs found
check_score	
	; level == current entry
	; Check score
	; 16 bit comparison
	lda hall_of_fame_scorel,x ; op1-op2
    cmp score
    lda hall_of_fame_scoreh,x
    sbc score+1
    bvc done ; N eor V
    eor #$80
done
	bcc found  

next_entry
	inx
	cpx #5
	bne loopsearch
	; Not found :(
	rts
found
	; Found a hi-score!
	; Save string code where to put new name
	ldy #4
	lda hall_of_fame_name,y
	pha
	; Move all entries down
	stx tmp
loopmove
	lda hall_of_fame_level-1,y	
	sta hall_of_fame_level,y
	lda hall_of_fame_scorel-1,y
	sta hall_of_fame_scorel,y
	lda hall_of_fame_scoreh-1,y
	sta hall_of_fame_scoreh,y
	lda hall_of_fame_name-1,y
	sta hall_of_fame_name,y
	cpy tmp
	beq end
	dey
	bpl loopmove
end
	; Store data
	lda level
	sta hall_of_fame_level,x
	lda score
	sta hall_of_fame_scorel,x
	lda score+1
	sta hall_of_fame_scoreh,x
	pla
	sta hall_of_fame_name,x
	
	; Ask the user for a new name
.)
request_name
.(
	; Load string number to overwrite
	; passed in reg A
	; set it to all zeros
	jsr search_string
	ldy #5
	lda #0
loopclear
	sta (tmp),y
	dey
	bpl loopclear
		
	lda tmp
	sta pstring
	lda tmp+1
	sta pstring+1
	
	ldy #7
	lda #76
	jsr print_string_centered

	ldy #8
	lda #77
	jsr print_string_centered
	
	lda #5
	sta ps_length

	ldx #17
	ldy #9
	jsr gotoxy
	jmp read_string
.)

put_spaces
.(
loopspaces	
	lda #" "
	jsr putchar
	dex
	bne loopspaces
	rts
.)	


display_hall_of_fame
.(
	jsr common_text_ext

	ldy #8
	lda #FIRST_NAME-2
	jsr print_string_centered
	ldy #9
	lda #FIRST_NAME-2
	jsr print_string_centered

	ldy #11
	lda #FIRST_NAME-1
	jsr print_string_centered
	
	
	lda #13 ; First row
	sta tmp3+1
	lda #0  
	sta tmp3
loop
	ldy tmp3+1
	ldx #10-1
	jsr gotoxy
	
	ldx tmp3
	lda hall_of_fame_colors,x
	jsr putchar

	lda #A_STD
	jsr putchar
	
	ldx tmp3
	lda hall_of_fame_level,x
	jsr bin2bcd
	jsr print_digit ;display_bcd_num

	ldx #4
	jsr put_spaces
	
	ldx tmp3
	lda hall_of_fame_scoreh,x
	jsr print_digit; display_bcd_num
	
	ldx tmp3
	lda hall_of_fame_scorel,x
	jsr print_digit ;display_bcd_num
	
	lda #"0"
	jsr putchar

	ldx #3
	jsr put_spaces
	
	ldx tmp3
	lda hall_of_fame_name,x
	jsr print_string_ex

	inc tmp3+1
	inc tmp3+1
	inc tmp3
	lda tmp3
	cmp #5 ; Number of entries
	bne loop
	
	; Wait for keypress or timeout
	lda #70
	jsr TimedWaitKey
	jmp common_text_ext	

.)



ship_show
.(
	jsr swap_charsets
	jsr _prepare_play_area
	jsr init_levels
repeat	
	jsr clear_ship
	jsr randgen
	and #%11111
doitagain	
	jsr goto_level
	lda onslaught
	ora labyrinth_mode
	ora boss_mode
	beq done
	; Special mode, skip...
	jsr clear_ship
	lda level
	clc
	adc #1
	bne doitagain ; Jumps always
done	
	jsr color_level
	jsr switch_codes_level
	
	; Create set of stars
	jsr _create_stars
	
	; Initialize variables
	lda #0
	sta _inicol
	
loop
	lda _inicol
	cmp #255-28+2
	beq finish_show
	inc _inicol
	jsr _scroll_stars_left

	;jsr _clear_backbuffer
	jsr _render_background
	jsr waitirq
	jsr _dump_backbuffer	

.(	
	lda smc_updatestar+1
	beq noupdate
	sta _star_tile+3
	lda #0
	sta smc_updatestar+1
noupdate
.)
	
	jsr ReadKeyboard
	jsr _ReadKeyNoBounce
	beq loop
	;jmp loop
finish_show
	;jmp swap_charsets
	jmp common_text
.)

firstrun .byt 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Menu screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
menu
.(
	jsr common_text
	lda firstrun
	bne skipcredits
	inc firstrun
	jsr display_credits
	jsr do_intro	
skipcredits
	lda #<__TaintedLove_start
	sta tmp
	lda #>__TaintedLove_start
	sta tmp+1
	jsr PlayMySong
	
	; Display different screens in order
loop	
	jsr ship_show
	jsr menu_display
	jsr display_powerups
	jsr menu_display	
	jsr display_keys
	jsr menu_display	
	;jsr display_objectives
	;jsr menu_display
	jsr display_hall_of_fame
	jmp loop
.)	
	
menu_display	
.(
menu_choices
	lda #48
	sta tmp3
	lda #9
	sta tmp3+1
loop
	lda tmp3
	ldy tmp3+1
	jsr print_string_centered
	inc tmp3
	inc tmp3+1
	inc tmp3+1
	lda tmp3
	cmp #53
	bne loop
	
getchoice	
	lda #70
	jsr TimedWaitKey
	bne user_command
	rts
	
user_command	
	cpx #"R"
	bne nored
	ldy #10
	jsr pause
	jsr common_text_ext	
	jsr redefine_keys
	jsr common_text_ext	
	jmp menu_choices
nored	
	cpx #"P"
	bne noplay
	jsr common_text_ext	
	ldx #6
	lda #0
.(
loopset
	sta beginner_mode,x
	dex
	bpl loopset
.)
	pla
	pla
	jmp swap_charsets
noplay	
	cpx #"C"
	bne nosavecode
	ldy #10
	jsr pause
	jsr common_text_ext	
	jsr request_savecode
	jsr common_text_ext	
	jmp menu_display
nosavecode	
	cpx #"B"
	bne nobeginners
	ldy #10
	jsr pause
	jsr common_text_ext	
	jsr do_instructions
	jsr common_text_ext	
	ldx #6
	lda #1
.(
loopset
	sta beginner_mode,x
	dex
	bpl loopset
.)
	pla
	pla
	jmp swap_charsets
nobeginners
	cpx #"V"
	bne novolume
	ldy #10
	jsr pause
	jsr common_text_ext	
	jsr volume_setting
	jsr common_text_ext	
	jmp menu_display
novolume
	jmp getchoice
.)	


;score 2 bytes in BCD
;level 1 byte
;lives 1 byte
;energy	1 byte < 32
;items	1 byte < 32

passcode_valid		.byt 0
passcode_data 		.dsb 8

generate_passcode
.(
	; Generate a checksum for the data
	ldx #5
	lda #0
	clc
.(	
loop
	adc score,x
	dex
	bpl loop
	sta passcode_data+7

	; Now generate the coded data
	; Start with a random number
	jsr randgen
	sta passcode_data
.)

.(	
	; block chain coding
	ldx #0
loop	
	eor score,x
	sta passcode_data+1,x
	inx
	cpx #6
	bne loop
.)

.(	
	; Generate a string for this...
	ldx #0
	ldy #0
	lda #65
	sta tmp
loop
	lda passcode_data,x
	and #%1111
	clc
	adc tmp
	sta passcode_string,y
	lda passcode_data,x
	lsr
	lsr
	lsr
	lsr
	iny
	sec
	adc tmp
	sta passcode_string,y
	
	inc tmp
	iny
	inx
	cpx #8
	bne loop
.)	

	lda #1
	sta passcode_valid
	
	rts	
.)

passcode_tmp .dsb 6

decode_passcode
.(
	; Translate the string to passcode data
.(	
	ldx #0
	ldy #0
	lda #65
	sta tmp
loop
	lda passcode_string,y
	sec
	sbc tmp
	sta passcode_data,x
	iny
	lda passcode_string,y
	clc
	sbc tmp
	asl
	asl
	asl
	asl
	ora passcode_data,x
	sta passcode_data,x
	
	inc tmp
	iny
	inx
	cpx #8
	bne loop
.)	
+decode_passcode_data
.(	
	; Decode the data... on temporary buffer
	ldx #0
loop
	lda passcode_data,x
	eor passcode_data+1,x
	sta passcode_tmp,x
	inx
	cpx #6
	bne loop
.)
	; Check checksum
	ldx #5
	lda #0
	clc
loop2
	adc passcode_tmp,x
	dex
	bpl loop2

	cmp passcode_data+7
	beq correct
	; Incorrect checksum...
	; Invalid data
invalid	
	ldy #7
	lda #55
	jsr print_string_centered
	ldy #50
	jmp pause
correct
	; Checksum is correct, let's
	; check coherence now...
	;score 2 bytes in BCD
	;level 1 byte
	;lives 1 byte
	;energy	1 byte < 32
	;items	1 byte < 32
	lda passcode_tmp
	jsr checkbcd
	bcs invalid
	lda passcode_tmp+1
	jsr checkbcd
	bcs invalid
	lda passcode_tmp+4
	cmp #32
	bcs invalid
	lda passcode_tmp+5
	cmp #32
	bcs invalid
	
	; It was a valid code, then copy to player space
	ldx #5
.(	
loop
	lda passcode_tmp,x
	sta score,x
	dex
	bpl loop
.)	
	; Get rid of context and jump
	pla
	pla
	pla
	pla
	jsr common_text_ext	
	jsr swap_charsets
	ldx passcode_tmp+2
	dex
	txa
	jsr goto_level
	jsr draw_scoreboard
	jsr _prepare_bottom_text_area
	jsr _prepare_play_area
	jsr init_panel	
	lda #0
	; Leds off
	sta ledstatus		
	sta blinkleds		
	sta old_ledstatus 
	jmp _next_level

.)

checkbcd
.(
	cmp #$9a
	bcs end
	and #%1111
	cmp #10
end
	rts
.)

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reads a string from keyboard
; with a fixed length (no ENTER)
; Params: 
;   pstring: pointer to buffer
;   ps_length: length to read
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.zero
pstring 	.word $0000
ps_length 	.byt $00
	
.text
read_string
.(
	; Print a series of symbols to 
	; repreent empty characters
	lda #DELETE_CHAR
	ldy ps_length
	dey
loopdots	
	sta (screen),y
	dey
	bpl loopdots

	; Wait for keypresses
	lda #0
	sta tmp1
loopr
	jsr waitirq
	jsr ReadKeyboard
	jsr _ReadKeyNoBounce
	beq loopr
	
	; Handle the DELETE key
	cpx #KEY_DEL
	bne nodel
	; Delete character
	lda tmp1
	beq loopr
	dec tmp1
	ldx #$7f
	jmp pchar
nodel	
	; Handle only ASCII from 32 to 90
	cpx #32
	bcc loopr
	cpx #91
	bcs loopr
	; Save character and
	; print it
	ldy tmp1
	sta (pstring),y
	inc tmp1
pchar
	txa
	jsr putchar
	; Check if we reached the end
	; of the string length
	lda tmp1
	cmp ps_length
	beq end
	jmp loopr
end
	; Make a small pause
	; and return
	ldy #7
	jmp pause
.)


request_savecode
.(
	ldy #7
	lda #54
	jsr print_string_centered
	lda #16
	sta ps_length
	
	lda #<passcode_string
	sta pstring
	lda #>passcode_string
	sta pstring+1
	ldx #11
	ldy #9
	jsr gotoxy
	jsr read_string
	jmp decode_passcode
.)


#define STVOL_START 65
#define STVOL_ROW	7

vol_table .byt 0,3,6,15
vol_sel   .byt 0

volume_setting
.(

	; Print instructions
	ldy #STVOL_ROW
	lda #STVOL_START
	jsr print_string_centered
	ldy #STVOL_ROW+1
	lda #STVOL_START+1
	jsr print_string_centered
	ldy #STVOL_ROW+2
	lda #STVOL_START+2
	jsr print_string_centered

	; Print current selection and get user input
prsel	
	lda vol_sel
	clc
	adc #STVOL_START+3
	ldy #STVOL_ROW+4
	jsr print_string_centered
loopr
	jsr waitirq
	jsr ReadKeyboard
	jsr _ReadKeyNoBounce
	beq loopr
	cpx #KEY_UP
	bne noup
	ldy vol_sel
	dey 
	jmp setit
noup
	cpx #KEY_DOWN
	bne nodown
	ldy vol_sel
	iny
setit	
	tya
	and #%11
	sta vol_sel
	tax
	lda vol_table,x
	sta GlobalVolume
	cli
	jmp prsel
nodown
	cpx #KEY_RETURN
	bne loopr
	
	; User selection is effective
	
	rts
.)	
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display outro text until
; keypress
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
do_outro
.(
	jsr common_text

	lda #<outro_text
	sta tmp
	lda #>outro_text
	sta tmp+1
	jsr draw_intro_text
	ldy #20
	jsr pause
	lda #200
	jsr TimedWaitKey
	jsr common_text_ext
	
	jsr test_hi_score
	jmp common_end_text_nokey
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Plays a tune when destroying
; a ship
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#define NUMTUNES 7
tunes_lo .byt <__EnolaGay_start,<__LivingOnVideo_start,<__TakeOnMe_start,<__Walking_start,<__BigInJapan_start,<__BlueMonday_start,<__LessonsInLove_start
tunes_hi .byt >__EnolaGay_start,>__LivingOnVideo_start,>__TakeOnMe_start,>__Walking_start,>__BigInJapan_start,>__BlueMonday_start,>__LessonsInLove_start

destroy_tune
.(
	jsr StopSound
	/*
	jsr randgen
	and #%11
	sta tmp
	lda randseed
	and #%1
	clc
	adc tmp*/
	lda level
	and #7
	cmp #NUMTUNES
	bcc valid
	sec
	sbc #NUMTUNES
valid	
	tax
	lda tunes_lo,x
	sta tmp
	lda tunes_hi,x
	sta tmp+1

+PlayMySong	
	jsr _StartPlayer
	jsr _PlaySong
	lda #1
	sta isr_plays_sound
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Implements the ship destruction
; bonus counter
; Thanks Silicebit!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;primera posicion del caracter decena de millar
#define carm $b800+100*8
;+#$b0 apunta a la primera posicion del patron de bits del numero cero
#define caro $b4d0 
;ultima posicion del caracter decena de millar
#define carc carm+7

.zero
ncon .byt $00 ;variable del numero de veces que hay que contar
pvar .dsb 10 ;primera posicion del area de variables
ccae .byt $00 ;variable del numero de deslizamientos del caracter
temp .byt 00

.text
_contador_up
.(
    pha          ;guarda a en la pila
    lda ncon     ;comprueba si se debe iniciar
    beq b00      ;la cuenta si no salta toda la rutina
    dec temp     ;decrementa temporizador en uno
    bne b00      ;si no se ha llegado a cero salta toda la rutina
    tya          ;salva registros
    pha          ;x e y en
    txa          ;la pila
    pha          ;
    ldx #$20     ;x sumado a carm apunta primera posicion caracter unidades
b01 ldy #$07     ;carga y con numero de posiciones que componen el caracter
b02 lda carm+1,x ;toma dato una posicion adelantada+x y
    sta carm,x   ;lo almacena en posicion original+x
    inx          ;incrementa x para posicion siguiente
    dey          ;decrementa numero de posiciones que componen el caracter
    bne b02      ;salta para completar todo el caracter
    stx pvar+6   ;se guarda x para uso posterior
    ldx pvar+7   ;carga x con numero de cifra en la que se esta trabajando
    ldy pvar,x   ;carga y con desplazamiento para puntero caro
    lda caro,y   ;carga a con el patron de bits de la cifra que debe aparecer por abajo
    ldy pvar+8   ;carga y con desplazamiento para puntero carc
    sta carc,y   ;almacena patron de bits en ultima posicion del caracter que se trabaja
    ldy pvar,x   ;carga y con desplazamiento para puntero caro para compararlo despues
    inc pvar,x   ;incrementa desplazamiento para que caro apunte a patron de bits siguiente
    bne b03      ;comprueba si el desplazamiento es cero (se ha llegado a numero nueve)
    lda #$b0     ;entonces se carga a con el desplazamiento para el numero cero y
    sta pvar,x   ;se almacena en la posicion de la cifra correspondiente
b03 cpy #$b8     ;comprueba si la cifra que aparece por abajo es el cero
    bcs b04      ;si no es asi salta
    lda pvar+8   ;si es asi se le resta ocho al desplazamiento para puntero carc para
    sec          ;que apunte asi a la ultima posicion del caracter siguiente
    sbc #$08     ;de orden superior (por ejemplo el caracter para las decenas)
    sta pvar+8   ;y se guarda
    lda pvar+6   ;se carga a con el valor de x antes guardado y se le resta quince para
    sbc #$0f     ;que el scroll hacia arriba se haga en el siguiente caracter de orden
    tax          ;superior (desplazamiento para carm) y se transfiere a x
    dec pvar+7   ;se situa puntero en la cifra siguiente de orden superior en la que se
    bne b01      ;debe trabajar y salta para deslizar dicha cifra
b04 lda #$20     ;restaura desplazamiento para carc para apuntar de nuevo a
    sta pvar+8   ;ultima posicion del caracter unidades
    lda #$05     ;restaura posicion del caracter en la que se debe trabajar
    sta pvar+7   ;a la de unidades
    dec ccae     ;decrementa numero de deslizamientos del caracter y
    bne b05      ;comprueba si se ha deslizado el caracter completo si no es asi salta
    dec ncon     ;si es asi decrementa el numero de veces que se ha de contar en uno
    lda #$08     ;restaura el numero de deslizamientos a ocho (el caracter completo)
    sta ccae     ;
b05 lda #$04     ;restaura el temporizador
    sta temp     ;
    pla          ;recupera todos los registros del stack
    tax          ;
    pla          ;
    tay          ;
b00 pla          ;
    rts          ;vuelve de la rutina
.)


_contador_init
.(
    ldx #$05   ; numero de cifras, una posicion de memoria para cada cifra
    lda #$b0   ; hace que caro apunte a la primera posicion del patron de bits del numero cero
b00 sta pvar,x ;
    dex        ;
    bne b00    ;
    lda #$04   ; ajusta el retardo del temporizador
    ldx #$08   ; numero de deslizamientos del caracter, 8 veces
    ldy #$05   ; ajuste para que se empiece a trabajar con la quinta cifra contando desde izda, unidades
    sta temp   ;
    stx ccae   ;
    sty pvar+7 ;
    lda #$20   ;
    sta pvar+8 ; ajuste inicial desplazamiento para carc para apuntar a la ultima posicion del caracter unidades
	
	lda #1
	sta ncon
loop	
	jsr _contador_up
	lda ncon
	bne loop

    rts        ; vuelve al sistema operativo
.)
